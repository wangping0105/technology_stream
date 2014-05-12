#encoding:utf-8
module ApplicationHelper
  def section_name(sections,id)
    sections.each do |s|
      if s.id==id
        return s.name
      end
    end
    nil
  end

  def markdown(html)
    @markdown =Redcarpet::Markdown.new(Redcarpet::Render::HTML,:autolink => true,:highlight=>true, :space_after_headers => true,hard_wrap:true,filter_html:true,no_intraemphasis:true,fenced_code:true,gh_blockcode:true)
    syntax_highlighter(@markdown.render(html)).html_safe
  end
  def syntax_highlighter(html)
    doc = Nokogiri::HTML(html)
    doc.search("//pre[@lang]").each do |pre|
      pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
    end
    doc.to_s
  end
  
  
end
