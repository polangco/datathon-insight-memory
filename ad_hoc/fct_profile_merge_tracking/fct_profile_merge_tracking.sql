/*
create table prod_id_graph.fct_profile_merge_tracking (
    from_id as uuid not null,
    to_id as uuid not null,
    merge_date as date not null,
    id_type as varchar(50) not null
);
*/ 


insert into prod_id_graph.fct_profile_merge_tracking (from_id, to_id, merge_date, id_type) values
    --('c994fb8a-7183-49e2-9838-e9f2b555da13', 'b9854193-9417-4840-bc0a-5fdb41ff277d', to_date('2024-07-03', 'YYYY-MM-DD'), 'lovpid'),
    --('429e80b5-70b6-45ee-ba84-bd27d173e40a', '1ed50977-ab9b-4072-bc70-07054ab2a278', to_date('2024-07-03', 'YYYY-MM-DD'), 'lovfid'),
    --('29d84f7b-bc85-401f-8ee9-9d6a8a91c8aa', '011f6931-93ff-459f-b9db-b967f59d49de', to_date('2024-07-03', 'YYYY-MM-DD'), 'lovfid'),
    --('be4c87de-a966-4506-a952-6d09e4600511', 'a6933520-ad32-455b-8f76-98f9fc475d5d', to_date('2024-07-03', 'YYYY-MM-DD'), 'lovpid'),
    ('08c22c08-6570-4efb-8c18-bddbbfb107a4', '8571943f-bd36-4236-a141-cbf0baf2ed05', to_date('2024-07-29', 'YYYY-MM-DD'), 'lovfid');