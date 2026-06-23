namespace :docs do
  desc "Generate API docs for llm.rb"
  task :"llm.rb" do
    chdir  = File.join(__dir__, "..", "llm.rb")
    outdir = File.join(__dir__, "public", "api-docs", "llm.rb")
    template = File.join(__dir__, "..", "blog", "yardtmpl")
    rm_rf(outdir)
    yardoc(chdir:, outdir:, template:)
  end
end

def yardoc(chdir:, outdir:, template:)
  Dir.chdir(chdir) do
    sh [
        "bundle", "exec", "yardoc",
        "-o", outdir, "-p", template, "lib"
      ].join(" ")
  end
end