% Knowledge Base (Product Name, Category, Price in LKR)
product(honda_cb150r, naked_bike, 1200000).
product(yamaha_r15, sport_bike, 1350000).
product(suzuki_gixxer, commuter, 950000).
product(kawasaki_ninja_400, super_sport, 3500000).
product(tvs_apache_rtr, naked_bike, 850000).
product(royal_enfield_classic, cruiser, 1800000).
product(ktm_duke_390, naked_bike, 2200000).
product(vespa_vxl, scooter, 750000).

% Stock Information
in_stock(honda_cb150r).
in_stock(yamaha_r15).
in_stock(tvs_apache_rtr).
in_stock(vespa_vxl).

% Mapping User Inputs to Internal Atoms
name_map("honda cb150r", honda_cb150r).
name_map("yamaha r15", yamaha_r15).
name_map("suzuki gixxer", suzuki_gixxer).
name_map("kawasaki ninja", kawasaki_ninja_400).
name_map("tvs apache", tvs_apache_rtr).
name_map("royal enfield", royal_enfield_classic).
name_map("ktm duke", ktm_duke_390).
name_map("vespa", vespa_vxl).

% Logic Rules
available(Bike) :- in_stock(Bike).
price(Bike, Cost) :- product(Bike, _, Cost).
category(Bike, Type) :- product(Bike, Type, _).

% Entry Point
start :-
    write("Welcome to the Vista Motors Customer Support!"), nl,
    write("You can ask about bike prices, types, or availability."), nl,
    write("Type 'exit' to quit."), nl,
    chat_loop.

% Recursive Chat Loop
chat_loop :-
    nl, write("Ask your question: "),
    read_line_to_string(user_input, Input),
    process_input(Input).

% Input Processing Logic
process_input(Input) :-
    string_lower(Input, Lowercase),
    (
        Lowercase == "exit" -> write("Thank you for visiting Vista Motors. Ride safe!"), !;
        
        contains(Lowercase, "price") -> handle_price_query(Lowercase), chat_loop;
        contains(Lowercase, "type") -> handle_category_query(Lowercase), chat_loop;
        contains(Lowercase, "category") -> handle_category_query(Lowercase), chat_loop;
        contains(Lowercase, "available") -> handle_availability_query(Lowercase), chat_loop;
        contains(Lowercase, "stock") -> handle_availability_query(Lowercase), chat_loop;

        write("I'm sorry, I don't have information on that. Try asking about a specific model."), nl, chat_loop
    ).

% Helper for substring matching
contains(String, Substring) :-
    sub_string(String, _, _, _, Substring).

% Find product atom from input string
find_bike(Input, Bike) :-
    name_map(Name, Bike),
    contains(Input, Name).

% Get display name from atom
bike_display_name(Bike, DisplayName) :-
    name_map(DisplayName, Bike).

% Query Handlers
handle_price_query(Input) :-
    (   find_bike(Input, Bike) ->
            price(Bike, Cost),
            bike_display_name(Bike, Name),
            format("The ~w costs LKR ~w", [Name, Cost])
    ;   write("Please specify a valid motorcycle model to check the price.")
    ).

handle_category_query(Input) :-
    (   find_bike(Input, Bike) ->
            category(Bike, Type),
            bike_display_name(Bike, Name),
            format("The ~w is classified as a ~w", [Name, Type])
    ;   write("Please specify a valid motorcycle model to check its category.")
    ).

handle_availability_query(Input) :-
    (   find_bike(Input, Bike) ->
            bike_display_name(Bike, Name),
            (available(Bike) ->
                format("Yes, the ~w is currently in stock.", [Name])
            ;   format("Sorry, the ~w is currently out of stock.", [Name])
            )
    ;   write("Please specify a valid motorcycle model to check availability.")
    ).
