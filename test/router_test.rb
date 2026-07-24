# frozen_string_literal: true

require_relative "setup"

class RouterTest < Minitest::Test
  include Rack::Test::Methods

  def test_guides_index
    get "/api/guides/index"
    assert_equal last_response.status, 200
    assert_equal body["ok"], true
  end

  def test_guides_search
    get "/api/guides/search", q: "Getting Started"
    assert_equal last_response.status, 200
    assert_equal body["ok"], true
    assert_includes body["stdout"], "getting-started.md"
  end

  def test_guides_read
    get "/api/guides/read", q: "getting-started"
    assert_equal last_response.status, 200
    assert_equal body["ok"], true
    assert_includes body["contents"], "Getting Started with mruby"
  end

  def test_mruby_index
    get "/api/mruby/index"
    assert_equal last_response.status, 200
    assert_equal body["ok"], true
  end

  def test_mruby_search
    get "/api/mruby/search", q: "mrb_obj_eq"
    assert_equal last_response.status, 200
    assert_equal body["ok"], true
    assert_includes body["stdout"], "object.c"
  end

  def test_mruby_read
    get "/api/mruby/read", q: "object.c"
    assert_equal last_response.status, 200
    assert_equal body["ok"], true
    assert_includes body["contents"], "mrb_obj_eq"
  end

  def test_mrbgem_index
    get "/api/mrbgems/index"
    assert_equal last_response.status, 200
    assert_equal body["ok"], true
  end

  def test_mrbgem_search
    get "/api/mrbgems/search", q: "json"
    assert_equal last_response.status, 200
    assert_equal body["ok"], true
    assert_includes body["stdout"], "mruby-json.gem"
  end

  def test_mrbgem_read
    get "/api/mrbgems/read", q: "mruby-json"
    assert_equal last_response.status, 200
    assert_equal body["ok"], true
    assert_includes body["contents"], "JavaScript Object Notation"
  end

  def test_llm_deepdive
    get "/llm/deepdive/"
    assert_equal last_response.status, 200
    assert_equal last_response.headers["content-type"], "text/html"
    assert_includes last_response.body, "llm.rb deep dive"
    assert_includes last_response.body, "/llm/deepdive/fundamentals/agents/"
    assert_includes last_response.body, "Fundamentals"
  end

  def test_llm_deepdive_topic
    get "/llm/deepdive/fundamentals/agents/"
    assert_equal last_response.status, 200
    assert_equal last_response.headers["content-type"], "text/html"
    assert_includes last_response.body, "Deep dive"
    assert_includes last_response.body, "Reusable agents"
    assert_includes last_response.body, "Throwaway agents"
  end

  def test_llm_deepdive_topic_not_found
    get "/llm/deepdive/fundamentals/nope/"
    assert_equal last_response.status, 404
  end

  def test_llm_deepdive_book
    get "/llm/deepdive/book/"
    assert_equal last_response.status, 200
    assert_equal last_response.headers["content-type"], "text/html"
    assert_includes last_response.body, "Deep dive"
    assert_includes last_response.body, "Reusable agents"
    assert_includes last_response.body, "Pending functions"
  end

  private

  def app
    Router
  end

  def body
    JSON.parse(last_response.body)
  end
end
