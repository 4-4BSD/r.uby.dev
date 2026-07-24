# frozen_string_literal: true

require "cgi"
require "kramdown"
require "kramdown-parser-gfm"
require "tilt"

class DeepdivePage
  TOPIC_ROOT = File.expand_path("../../llm.rb/resources/deepdive", __dir__)
  GROUP_ORDER = %w[fundamentals advanced interface protocols].freeze
  VIEW_DIR = File.expand_path("../views/deepdive", __dir__)

  def render
    set_meta(
      title: "llm.rb deep dive",
      canonical_url: "https://r.uby.dev/llm/deepdive/",
      description: "A deeper tour of llm.rb, organized into focused topic pages covering fundamentals, advanced runtime behavior, interfaces, and protocols.",
      og_type: "website"
    )

    layout = t("layout")
    page = t("index")

    html = page.render(self,
      intro_html: render_index_intro,
      nav_groups: nav_groups,
      groups: nav_groups
    )
    html = layout.render(self) { html }
    normalize_html(html)
  end

  def render_topic(group_slug, topic_slug)
    topic = topic_entry(group_slug, topic_slug)
    return nil unless topic

    article_html, _headings = render_topic_article(topic[:source])
    previous_topic, next_topic = topic_neighbors(topic)

    set_meta(
      title: "#{topic[:title]} · llm.rb deep dive",
      canonical_url: "https://r.uby.dev/llm/deepdive/#{CGI.escapeHTML(topic[:group_slug])}/#{CGI.escapeHTML(topic[:topic_slug])}/",
      description: topic[:description],
      og_type: "article",
      og_title: "#{topic[:title]} · llm.rb deep dive",
      og_description: topic[:description]
    )

    layout = t("layout")
    page = t("topic")

    html = page.render(self,
      article_html: article_html,
      nav_groups: nav_groups,
      current_group: topic[:group_slug],
      current_slug: topic[:topic_slug],
      prev_topic: previous_topic,
      next_topic: next_topic
    )
    html = layout.render(self) { html }
    normalize_html(html)
  end

  def render_book
    article_html, _headings = render_book_article

    set_meta(
      title: "llm.rb deep dive book",
      canonical_url: "https://r.uby.dev/llm/deepdive/book/",
      description: "The complete llm.rb deep dive assembled as a single long-form reference page.",
      og_type: "article",
      og_title: "llm.rb deep dive book",
      og_description: "The complete llm.rb deep dive assembled as a single long-form reference page."
    )

    layout = t("layout")
    page = t("book")

    html = page.render(self,
      article_html: article_html,
      nav_groups: nav_groups
    )
    html = layout.render(self) { html }
    normalize_html(html)
  end

  # Template helper: HTML-escape a string
  def h(text)
    CGI.escapeHTML(text.to_s)
  end

  private

  def set_meta(title:, canonical_url:, description:, og_type: "website", og_title: nil, og_description: nil)
    @title = title
    @canonical_url = canonical_url
    @description = description
    @og_type = og_type
    @og_title = og_title || title
    @og_description = og_description || description
  end

  def t(name)
    @_templates ||= {}
    @_templates[name] ||= Tilt::ERBTemplate.new(File.join(VIEW_DIR, "#{name}.erb"))
  end

  def render_markdown(markdown)
    Kramdown::Document.new(
      markdown,
      input: "GFM",
      hard_wrap: false,
      syntax_highlighter: nil
    ).to_html
  end

  def slugify(text)
    text.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
  end

  def normalize_html(html)
    "#{html.lines.map(&:rstrip).join("\n").strip}\n"
  end

  DEEPDIVE_MD = File.expand_path("../../llm.rb/resources/deepdive.md", __dir__)

  def render_index_intro
    source = File.read(DEEPDIVE_MD)
    # Everything before the group listings (before the --- separator)
    intro = source.split(/\n---\n\n## /, 2).first
    render_markdown(intro)
  end

  def nav_groups
    @nav_groups ||= begin
      group_dirs = Dir.children(TOPIC_ROOT)
        .select { |entry| File.directory?(File.join(TOPIC_ROOT, entry)) }

      ordered_group_slugs = GROUP_ORDER.select { |slug| group_dirs.include?(slug) } +
        (group_dirs - GROUP_ORDER).sort

      ordered_group_slugs.map do |group_slug|
        topic_paths = Dir.glob(File.join(TOPIC_ROOT, group_slug, "*.md")).sort

        {
          title: titleize(group_slug),
          slug: group_slug,
          topics: topic_paths.map { |source| topic_metadata(group_slug, source) }
        }
      end
    end
  end

  def ordered_topics
    @ordered_topics ||= nav_groups.flat_map { |group| group[:topics] }
  end

  def topic_entry(group_slug, topic_slug)
    ordered_topics.find do |topic|
      topic[:group_slug] == group_slug && topic[:topic_slug] == topic_slug
    end
  end

  def topic_neighbors(topic)
    index = ordered_topics.index(topic)
    return [nil, nil] unless index

    prev = index > 0 ? ordered_topics[index - 1] : nil
    nxt  = index < ordered_topics.length - 1 ? ordered_topics[index + 1] : nil
    [prev, nxt]
  end

  def topic_description(source)
    markdown = File.read(source)
    text = markdown[/^#### Overview\n\n(.+?)(?=\n\n#### |\n\n### |\z)/m, 1].to_s
    paragraph = text.split(/\n{2,}/).first.to_s
    paragraph.gsub(/\[([^\]]+)\]\([^)]+\)/, "\\1").gsub(/\s+/, " ").strip
  end

  def topic_title(source)
    File.read(source)[/^## (.+)$/, 1] || titleize(File.basename(source, ".md"))
  end

  def topic_metadata(group_slug, source)
    topic_slug = File.basename(source, ".md")

    {
      title: topic_title(source),
      group_title: titleize(group_slug),
      group_slug: group_slug,
      topic_slug: topic_slug,
      source: source,
      description: topic_description(source)
    }
  end

  def titleize(text)
    text.split(/[-_]/).map(&:capitalize).join(" ")
  end

  def render_topic_article(source)
    article_html = rewrite_topic_links(render_markdown(File.read(source)))
    rewrite_heading_ids(article_html)
  end

  def render_book_article
    combined = ordered_topics.map { |topic| File.read(topic[:source]).strip }.join("\n\n---\n\n")
    article_html = rewrite_topic_links(render_markdown(combined))
    rewrite_heading_ids(article_html)
  end

  def rewrite_topic_links(html)
    html.gsub(%r{href="deepdive/([^/]+)/([^"]+)\.md"}) do
      %(href="/llm/deepdive/#{Regexp.last_match(1)}/#{Regexp.last_match(2)}/")
    end
  end

  def rewrite_heading_ids(article_html)
    headings = []
    current = {}
    used_ids = Hash.new(0)

    rewritten = article_html.gsub(/<h([2-5]) id="[^"]+">(.+?)<\/h\1>/m) do
      level = Regexp.last_match(1).to_i
      inner_html = Regexp.last_match(2)
      text = CGI.unescapeHTML(inner_html.gsub(/<[^>]+>/, "")).strip
      base_id = semantic_heading_id(level, text, current)

      used_ids[base_id] += 1
      id = used_ids[base_id] == 1 ? base_id : "#{base_id}-#{used_ids[base_id]}"

      slug = slugify(text)
      current[:h2] = slug if level == 2
      current[:h3] = slug if level == 3
      current[:h4] = slug if level == 4
      current[:h3] = nil if level == 2
      current[:h4] = nil if level <= 3

      headings << {level: level, id: id, text: text}
      %(<h#{level} id="#{CGI.escapeHTML(id)}">#{inner_html}</h#{level}>)
    end

    [rewritten, headings]
  end

  def semantic_heading_id(level, text, current)
    slug = slugify(text)

    case level
    when 2
      slug
    when 3
      [current[:h2], slug].compact.join("-")
    when 4
      [current[:h2], current[:h3], slug].compact.join("-")
    when 5
      [current[:h2], current[:h3], current[:h4], slug].compact.join("-")
    else
      slug
    end
  end
end
