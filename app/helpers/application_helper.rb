module ApplicationHelper
	# Return a title on a per page basis

	def title
		base_title = "Homework Application"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end

	def logo
		image_tag("logo.png", :alt => "Homework Helper")
	end



	def sortable(column, title = nil, anchor = nil)
	  title ||= column.titleize
	  css_class = column == sort_column ? "current #{sort_direction}" : nil
	  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
	  link_to title, {:sort => column, :direction => direction, :anchor => "resources"}, {:class => css_class}
	end


end
