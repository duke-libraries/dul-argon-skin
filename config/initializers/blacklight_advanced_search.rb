# NOTE: Override of BL Advanced Search module so that we can
#       render location constraint codes as human readable strings.
#       Unfortunately, BL Adv. Search does not seem to provide a
#       convenient method of overriding this behavior so we're putting
#       this in an initializer for now.

BlacklightAdvancedSearch::RenderConstraintsOverride.module_eval do
  def render_constraints_query(my_params = params)
    if (advanced_query.nil? || advanced_query.keyword_queries.empty?)
      return super(my_params)
    else
      content = []
      advanced_query.keyword_queries.each_pair do |field, query|
        label = search_field_def_for_key(field)[:label]
        content << render_constraint_element(
          label, query,
          :remove =>
            search_action_path(remove_advanced_keyword_query(field, my_params).except(:controller, :action))
        )
      end
      if (advanced_query.keyword_op == "OR" &&
          advanced_query.keyword_queries.length > 1)
        content.unshift content_tag(:span, "Any of:", class: 'operator')
        content_tag :span, class: "inclusive_or appliedFilter well" do
          safe_join(content.flatten, "\n")
        end
      else
        safe_join(content.flatten, "\n")
      end
    end
  end

  # Over-ride of Blacklight method, provide advanced constraints if needed,
  # otherwise call super.
  def render_constraints_filters(my_params = params)
    content = super(my_params)

    if advanced_query
      advanced_query.filters.each_pair do |field, value_list|
        label = facet_field_label(field)
        content << render_constraint_element(label,
          safe_join(constraint_display_values(field, Array(value_list)), " <strong class='text-muted constraint-connector'>OR</strong> ".html_safe),
          :remove => search_action_path(remove_advanced_filter_group(field, my_params).except(:controller, :action))
                                            )
      end
    end

    content
  end

  def constraint_display_values(field, value_list)
    return value_list unless field == TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s
    value_list.map { |v| location_filter_display(v) }
  end
end
