% Base UI elements for Propositional Formula Explorer
elem(w, window, root).
attr(w, title, "Propositional Formula Explorer").

% Menu bar
elem(menu_bar, menu_bar, w).
attr(menu_bar, title, "Propositional Formula Explorer").
attr(menu_bar, icon, "fa-lightbulb").

    % Next solution button - Iterate over formulas
    elem(next_solution_btn, button, menu_bar).
    attr(next_solution_btn, label, "Next Solution").
    attr(next_solution_btn, icon, "fa-forward-step").
    attr(next_solution_btn, class, ("btn-outline-primary";"border-0")).
    when(next_solution_btn, click, callback, next_solution).

    % Next optimal solution button - Iterate over optimal formulas
    elem(next_optimal_btn, button, menu_bar).
    attr(next_optimal_btn, label, "Next Optimal").
    attr(next_optimal_btn, icon, "fa-award").
    attr(next_optimal_btn, class, ("btn-outline-success";"border-0")).
    when(next_optimal_btn, click, callback, next_optimal_solution).

    % Clear button
    elem(clear_btn, button, menu_bar).
    attr(clear_btn, label, "Clear Constraints").
    attr(clear_btn, icon, "fa-trash").
    attr(clear_btn, class, ("btn-outline-danger";"border-0")).
    when(clear_btn, click, callback, clear_assumptions).

    elem(toggle_optimal, button, menu_bar).
    attr(toggle_optimal, label, "Toggle Optimization").
    attr(toggle_optimal, icon, "fa-star").
    attr(toggle_optimal, class, ("btn-outline-primary";"border-0")).
    attr(toggle_optimal, class, "btn-primary") :- compute_optimal.
    when(toggle_optimal, click, call, add_atom(compute_optimal)) :- not compute_optimal.
    when(toggle_optimal, click, call, remove_atom(compute_optimal)) :- compute_optimal.


% Main layout with two columns
elem(main_container, container, w).
attr(main_container, width, "100%").
attr(main_container, height, "calc(100% - 60px)").
attr(main_container, child_layout, grid).
attr(main_container, grid_template_columns, "300px 1fr").
attr(main_container, grid_gap, "10px").
attr(main_container, padding, "10px").

% Left panel - Controls and info
elem(left_panel, container, main_container).
attr(left_panel, grid_column, "1").
attr(left_panel, child_layout, flex).
attr(left_panel, flex_direction, column).
attr(left_panel, gap, "15px").
attr(left_panel, class, ("border";"rounded";"p-3";"bg-light"));
attr(left_panel, overflow, "auto").

    % Attribute control - Include/exclude attributes
    elem(attr_control, container, left_panel).
    attr(attr_control, child_layout, flex).
    attr(attr_control, flex_direction, column).
    attr(attr_control, gap, "10px").
    attr(attr_control, class, ("border";"rounded";"p-3")).
    
        elem(attr_title, typography, attr_control).
        attr(attr_title, variant, "h6").
        attr(attr_title, text, "Attribute Controls").
        
        % Include attributes section
        elem(include_attr_section, container, attr_control).
        attr(include_attr_section, child_layout, flex).
        attr(include_attr_section, flex_direction, column).
        attr(include_attr_section, gap, "5px").
        
            elem(include_attr_label, typography, include_attr_section).
            attr(include_attr_label, variant, "body2").
            attr(include_attr_label, text, "Include these attributes:").
            
            elem(include_attr_list, container, include_attr_section).
            attr(include_attr_list, child_layout, flex).
            attr(include_attr_list, flex_direction, row).
            attr(include_attr_list, flex_wrap, wrap).
            attr(include_attr_list, gap, "5px").
            
            % Create a button for each attribute for inclusion
            elem(include_btn(A), button, include_attr_list) :- attribute(A).
            attr(include_btn(A), label, A) :- attribute(A).
            attr(include_btn(A), class, "btn-sm") :- attribute(A).
            attr(include_btn(A), class, "btn-outline-success") :- attribute(A), not include_attr(A).
            attr(include_btn(A), class, "btn-success") :- attribute(A), include_attr(A).
            
            % Toggle attribute inclusion
            when(include_btn(A), click, call, add_atom(include_attr(A))) :- attribute(A), not include_attr(A).
            when(include_btn(A), click, call, remove_atom(include_attr(A))) :- attribute(A), include_attr(A).
        
        % Exclude attributes section
        elem(exclude_attr_section, container, attr_control).
        attr(exclude_attr_section, child_layout, flex).
        attr(exclude_attr_section, flex_direction, column).
        attr(exclude_attr_section, gap, "5px").
        attr(exclude_attr_section, margin_top, "10px").
        
            elem(exclude_attr_label, typography, exclude_attr_section).
            attr(exclude_attr_label, variant, "body2").
            attr(exclude_attr_label, text, "Exclude these attributes:").
            
            elem(exclude_attr_list, container, exclude_attr_section).
            attr(exclude_attr_list, child_layout, flex).
            attr(exclude_attr_list, flex_direction, row).
            attr(exclude_attr_list, flex_wrap, wrap).
            attr(exclude_attr_list, gap, "5px").
            
            % Create a button for each attribute for exclusion
            elem(exclude_btn(A), button, exclude_attr_list) :- attribute(A).
            attr(exclude_btn(A), label, A) :- attribute(A).
            attr(exclude_btn(A), class, "btn-sm") :- attribute(A).
            attr(exclude_btn(A), class, "btn-outline-danger") :- attribute(A), not exclude_attr(A).
            attr(exclude_btn(A), class, "btn-danger") :- attribute(A), exclude_attr(A).
            
            % Toggle attribute exclusion
            when(exclude_btn(A), click, call, add_atom(exclude_attr(A))) :- attribute(A), not exclude_attr(A).
            when(exclude_btn(A), click, call, remove_atom(exclude_attr(A))) :- attribute(A), exclude_attr(A).

    % Formula information box
    elem(formula_info, container, left_panel).
    attr(formula_info, child_layout, flex).
    attr(formula_info, flex_direction, column).
    attr(formula_info, gap, "10px").
    attr(formula_info, class, ("border";"rounded";"p-3")).
    
        elem(formula_title, typography, formula_info).
        attr(formula_title, variant, "h6").
        attr(formula_title, text, "Current Formula").
        
        elem(formula_size_info, typography, formula_info).
        attr(formula_size_info, variant, "body2").
        attr(formula_size_info, text, "Size: ").
        
        elem(error_info, typography, formula_info).
        attr(error_info, variant, "body2").
        attr(error_info, text, "Error: ").

    % Incorrectly classified examples section
    elem(incorrect_examples, container, left_panel).
    attr(incorrect_examples, child_layout, flex).
    attr(incorrect_examples, flex_direction, column).
    attr(incorrect_examples, gap, "10px").
    attr(incorrect_examples, class, ("border";"rounded";"p-3")).
    
        elem(incorrect_title, typography, incorrect_examples).
        attr(incorrect_title, variant, "h6").
        attr(incorrect_title, text, "Incorrectly Classified Examples").
        
        % List of incorrect examples
        elem(incorrect_list, container, incorrect_examples).
        attr(incorrect_list, child_layout, flex).
        attr(incorrect_list, flex_direction, row).
        attr(incorrect_list, flex_wrap, wrap).
        attr(incorrect_list, gap, "5px").
        
        % Create a button for each incorrect example
        elem(incorrect_btn(E), button, incorrect_list) :- incorrect(E).
        attr(incorrect_btn(E), label, E) :- incorrect(E).
        attr(incorrect_btn(E), class, ("btn-sm";"btn-outline-danger")) :- incorrect(E), example(E, pos).
        attr(incorrect_btn(E), class, ("btn-sm";"btn-outline-warning")) :- incorrect(E), example(E, neg).
        when(incorrect_btn(E), click, call, add_atom(show_example_details(E))) :- incorrect(E).
        
        % Example details section - shown when an example is clicked
        elem(example_details, container, incorrect_examples) :- show_example_details(E).
        attr(example_details, child_layout, flex) :- show_example_details(E).
        attr(example_details, flex_direction, column) :- show_example_details(E).
        attr(example_details, gap, "5px") :- show_example_details(E).
        attr(example_details, class, ("border";"rounded";"p-2";"mt-2")) :- show_example_details(E).
        
            % Example header
            elem(example_header(E), typography, example_details) :- show_example_details(E).
            attr(example_header(E), variant, "body1") :- show_example_details(E).
            attr(example_header(E), text, @concat("Example ", E, " (", C, ")")) :- show_example_details(E), example(E, C).
            
            % Attribute list
            elem(example_attr_list, container, example_details) :- show_example_details(E).
            attr(example_attr_list, child_layout, flex) :- show_example_details(E).
            attr(example_attr_list, flex_direction, row) :- show_example_details(E).
            attr(example_attr_list, flex_wrap, wrap) :- show_example_details(E).
            attr(example_attr_list, gap, "5px") :- show_example_details(E).
            
            % Create a badge for each attribute
            elem(attr_badge(E,A), badge, example_attr_list) :- show_example_details(E), has(E,A).
            attr(attr_badge(E,A), text, A) :- show_example_details(E), has(E,A).
            attr(attr_badge(E,A), class, "bg-success") :- show_example_details(E), has(E,A).
            
            % Close button
            elem(close_example_btn, button, example_details) :- show_example_details(E).
            attr(close_example_btn, label, "Close") :- show_example_details(E).
            attr(close_example_btn, class, "btn-outline-secondary") :- show_example_details(E).
            when(close_example_btn, click, call, remove_atom(show_example_details(E))) :- show_example_details(E).

% Right panel - Graph visualization
elem(right_panel, container, main_container).
attr(right_panel, grid_column, "2").
attr(right_panel, child_layout, flex).
attr(right_panel, flex_direction, column).
attr(right_panel, gap, "15px").
attr(right_panel, class, ("border";"rounded";"p-3")).

    % Graph visualization title
    elem(graph_title, typography, right_panel).
    attr(graph_title, variant, "h5").
    attr(graph_title, text, "Propositional Formula Structure").
    
    % Graph canvas using clingraph
    elem(graph_canvas, canvas, right_panel).
    attr(graph_canvas, image_type, clingraph).
    attr(graph_canvas, width, "100%").
    attr(graph_canvas, height, "calc(100% - 40px)").
    attr(graph_canvas, class, ("border";"rounded")).
    
    % Interactive nodes
    elem(n(F), svg_node, graph_canvas) :- node(F).
    attr(n(F), clingraph_id, F) :- node(F).
    
    % When clicking a node, show details
    when(n(F), click, call, add_atom(show_node_details(F))) :- node(F).
    
    % Node details modal
    elem(node_modal, modal, w) :- show_node_details(F), for(F,_,_).
    attr(node_modal, title, @concat("Node ", F, " Details")) :- show_node_details(F), for(F,_,_).
    attr(node_modal, visibility, shown) :- show_node_details(F), for(F,_,_).
    
        % Node details container
        elem(node_details, container, node_modal) :- show_node_details(F), for(F,_,_).
        attr(node_details, child_layout, flex) :- show_node_details(F), for(F,_,_).
        attr(node_details, flex_direction, column) :- show_node_details(F), for(F,_,_).
        attr(node_details, gap, "10px") :- show_node_details(F), for(F,_,_).
        
        % Node type
        elem(node_type, typography, node_details) :- show_node_details(F), for(F,T,X).
        attr(node_type, variant, "body1") :- show_node_details(F), for(F,_,_).
        attr(node_type, text, @concat("Type: ", T)) :- show_node_details(F), for(F,T,_).
        
        % Node value/reference
        elem(node_value, typography, node_details) :- show_node_details(F), for(F,_,_).
        attr(node_value, variant, "body1") :- show_node_details(F), for(F,_,_).
        attr(node_value, text, @concat("Value: ", X)) :- show_node_details(F), for(F,atom,X).
        attr(node_value, text, @concat("References: ", X, " and ", X+1)) :- show_node_details(F), for(F,and,X).
        attr(node_value, text, @concat("References: ", X, " and ", X+1)) :- show_node_details(F), for(F,or,X).
        attr(node_value, text, @concat("References: ", X)) :- show_node_details(F), for(F,neg,X).
        
        % Close button
        elem(close_node_btn, button, node_details) :- show_node_details(F), for(F,_,_).
        attr(close_node_btn, label, "Close") :- show_node_details(F), for(F,_,_).
        attr(close_node_btn, class, "btn-primary") :- show_node_details(F), for(F,_,_).
        when(close_node_btn, click, call, remove_atom(show_node_details(F))) :- show_node_details(F), for(F,_,_).

