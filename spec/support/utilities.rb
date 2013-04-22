# spec/request/static_pages_spec.rbのfull_title()を定義
#
#もし、page_titleに値が入ってなかったら
#base_titleだけを表示、page_titleがある場合はelseを表示
def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
	base_title
  else
	"#{base_title} | #{page_title}"
  end
end
