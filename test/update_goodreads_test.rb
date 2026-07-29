#!/usr/bin/env ruby

require "minitest/autorun"
require "tmpdir"
require "yaml"

require_relative "../scripts/update_goodreads"

class UpdateGoodreadsTest < Minitest::Test
  FIXTURE_DIRECTORY = File.expand_path("fixtures/goodreads", __dir__)

  def fixture(name)
    File.read(File.join(FIXTURE_DIRECTORY, name))
  end

  def test_builds_and_groups_a_snapshot
    data = GoodreadsImporter.build_snapshot(
      fixture("currently-reading.xml"),
      fixture("read.xml")
    )

    assert_equal("2026-07-29T05:17:00+00:00", data["currently_reading_updated_at"])
    assert_equal(["Example Architecture"], data["currently_reading"].map { |book| book["title"] })
    assert_equal(320, data["currently_reading"].first["pages"])
    assert_equal(
      "https://www.goodreads.com/book/show/101-example-architecture",
      data["currently_reading"].first["url"]
    )
    assert_equal([2026, 2025], data["read_by_year"].map { |group| group["year"] })
    assert_equal(["Undated Book"], data["undated_read"].map { |book| book["title"] })
    assert_equal(
      "https://www.goodreads.com/book/show/203",
      data["read_by_year"].last["books"].first["url"]
    )
  end

  def test_rejects_an_empty_read_shelf
    error = assert_raises(RuntimeError) do
      GoodreadsImporter.build_snapshot(
        fixture("currently-reading.xml"),
        fixture("empty-read.xml")
      )
    end

    assert_match("empty read shelf", error.message)
  end

  def test_rejects_malformed_xml
    assert_raises(REXML::ParseException) do
      GoodreadsImporter.build_snapshot(
        fixture("malformed.xml"),
        fixture("read.xml")
      )
    end
  end

  def test_writes_a_parseable_snapshot_atomically
    data = GoodreadsImporter.build_snapshot(
      fixture("currently-reading.xml"),
      fixture("read.xml")
    )

    Dir.mktmpdir do |directory|
      output_path = File.join(directory, "goodreads.yml")
      GoodreadsImporter.write_snapshot(output_path, data)

      written = YAML.load_file(output_path)
      assert_equal(data, written)
      assert_equal(0o644, File.stat(output_path).mode & 0o777)
      assert_empty(Dir.glob(File.join(directory, ".goodreads-*")))
    end
  end

  def test_successful_run_fetches_both_feeds_and_writes_the_snapshot
    responses = {
      GoodreadsImporter::CURRENTLY_READING_URL => fixture("currently-reading.xml"),
      GoodreadsImporter::READ_URL => fixture("read.xml")
    }
    fetcher = ->(uri) { responses.fetch(uri.to_s) }

    Dir.mktmpdir do |directory|
      output_path = File.join(directory, "goodreads.yml")

      assert(GoodreadsImporter.run(output_path: output_path, strict: true, fetcher: fetcher))
      assert_equal(
        ["Example Architecture"],
        YAML.load_file(output_path)["currently_reading"].map { |book| book["title"] }
      )
    end
  end

  def test_strict_failure_preserves_the_existing_snapshot_and_fails
    Dir.mktmpdir do |directory|
      output_path = File.join(directory, "goodreads.yml")
      File.write(output_path, "existing snapshot\n")
      fetcher = ->(_uri) { raise "network unavailable" }

      refute(GoodreadsImporter.run(output_path: output_path, strict: true, fetcher: fetcher))
      assert_equal("existing snapshot\n", File.read(output_path))
    end
  end

  def test_tolerant_failure_preserves_the_existing_snapshot_and_succeeds
    Dir.mktmpdir do |directory|
      output_path = File.join(directory, "goodreads.yml")
      File.write(output_path, "existing snapshot\n")
      fetcher = ->(_uri) { raise "network unavailable" }

      assert(GoodreadsImporter.run(output_path: output_path, strict: false, fetcher: fetcher))
      assert_equal("existing snapshot\n", File.read(output_path))
    end
  end
end
