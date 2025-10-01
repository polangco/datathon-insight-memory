-- apply fixes
update prod_id_graph.grp_people
set lovpid = 'b9854193-9417-4840-bc0a-5fdb41ff277d'
where lovpid = 'c994fb8a-7183-49e2-9838-e9f2b555da13';

delete from prod_id_graph.grp_families
where lovpid = 'c994fb8a-7183-49e2-9838-e9f2b555da13';

update prod_id_graph.grp_families
set lovfid = '1ed50977-ab9b-4072-bc70-07054ab2a278'
where lovfid = '429e80b5-70b6-45ee-ba84-bd27d173e40a';

update prod_id_graph.grp_families
set lovfid = '011f6931-93ff-459f-b9db-b967f59d49de'
where lovfid = '29d84f7b-bc85-401f-8ee9-9d6a8a91c8aa';



update prod_id_graph.grp_people
set lovpid = 'a6933520-ad32-455b-8f76-98f9fc475d5d'
where lovpid = 'be4c87de-a966-4506-a952-6d09e4600511';

delete from prod_id_graph.grp_families
where lovpid = 'be4c87de-a966-4506-a952-6d09e4600511';

update prod_id_graph.grp_families
set lovfid = '8c1c6a16-e108-4b34-8949-c60029072afc'
where lovpid = 'a6933520-ad32-455b-8f76-98f9fc475d5d';


delete from prod_id_graph.grp_families
where lovfid = '11f60820-474f-4779-8c90-e20ce163d023' and lovpid = '24066791-ded2-432a-bc65-63b78ea4c8bd';

update prod_id_graph.grp_families
set lovfid = '8571943f-bd36-4236-a141-cbf0baf2ed05'
where lovfid = '08c22c08-6570-4efb-8c18-bddbbfb107a4';

update prod_id_graph.grp_families
set lovfid = 'e365998d-a873-4f95-b95e-5c0a1caf5fe4'
where lovfid = '69ce19a0-cbcf-4939-826c-662610c46fb8';

-- remove duplication
select distinct * 
into temporary table family_recon_unique
from prod_id_graph.grp_families;

truncate table prod_id_graph.grp_families;

insert into prod_id_graph.grp_families
	select * from family_recon_unique;


-- check tables
select count(*), count(distinct(lovfid, lovpid)) from prod_id_graph.grp_families;

select count(*), count(distinct(lovpid, source_system, person_id, person_type)) from prod_id_graph.grp_people;

select * from prod_id_graph.grp_people where lovpid in ('c994fb8a-7183-49e2-9838-e9f2b555da13', 'be4c87de-a966-4506-a952-6d09e4600511');

select * from prod_id_graph.grp_families where lovpid in ('c994fb8a-7183-49e2-9838-e9f2b555da13', 'be4c87de-a966-4506-a952-6d09e4600511');

-- select lovfid, lovpid from prod_id_graph.grp_families group by lovfid, lovpid having count(*) > 1;


--- set to is_valid false people flagged as problem from Premier Nebraska
update prod_marketing.dim_braze_families set
is_valid = false
where external_id in (
'f94e98be-420b-4886-9956-03cfba87427b',
'5c576124-e9d5-4b06-be3b-6cc45e6a2f16',
'825802fe-1abf-4124-9b46-17e73174e595',
'935cc27e-0bb7-460c-9b7d-4b7ec9e2bf41',
'02b38ac3-0401-4f48-b9c9-ca2e8cd67604',
'6a9c409c-f736-4590-a7dd-91ff5a9c64cb',
'07c1b2e1-cc20-46b6-8aec-df754b6af1ae',
'4d4b767c-dfaf-4d45-ae61-bbfbc10130db',
'c45e1abf-e961-44ca-9a0a-c1d1ef99507f',
'5b04b394-3efb-42af-b8ef-305910d35288',
'23dfcc79-a6e8-4bbe-ba27-5fa8640b4f00',
'fe8a553a-1e6c-4d3f-a078-3783fd1c5467',
'f1e1bddd-f57d-46a3-968e-bfd8d0a49dee',
'05a9332b-dd50-4d55-82ce-996c9e01c138',
'8a32b91c-146c-4bc1-9343-7f9831c55849',
'c5e2cd1e-977a-4c0b-89e9-021e0c771155',
'40e48cdf-122a-41c3-af8a-5e33b1f49783',
'337e8f00-4092-4bc2-a33e-3d74a7e42c45',
'7b36dc90-9318-4b5c-a2c5-6b3dd0f7dd52',
'585cbd9b-6c14-4eec-976f-3701bd2222f6',
'8786c80c-5697-4f7c-a5d3-eaf7ee996b1c',
'293ee528-b641-42ec-8c19-603513a944a7',
'652d5a69-ad07-461d-a117-32e2a23eac14',
'4a22b544-25e7-4928-88b3-b01a3b4607a3',
'44a9eb71-850f-4c78-b7f4-8bc02da297e3',
'24cb72a6-f72c-4d57-a3f3-75266728f362',
'2b563832-9df8-417e-9348-67535d4aae95',
'62f55ac1-7e9f-4d2f-9764-a06aa27ec044',
'5adcd22c-9d86-47b1-b752-8fd8034fa0b8',
'6b03afcf-5ef2-4699-9afb-3fe004cc7246',
'466e48a5-eb2f-4c4e-9d29-c660d110a7e3',
'c01f9887-cd40-41c5-8443-5502bccce303',
'c97920ef-0a2f-4a0b-b3a3-814fb449b6f2');


update prod_marketing.dim_braze_insiders set
is_valid = false
where external_id in (
'f94e98be-420b-4886-9956-03cfba87427b',
'5c576124-e9d5-4b06-be3b-6cc45e6a2f16',
'825802fe-1abf-4124-9b46-17e73174e595',
'935cc27e-0bb7-460c-9b7d-4b7ec9e2bf41',
'02b38ac3-0401-4f48-b9c9-ca2e8cd67604',
'6a9c409c-f736-4590-a7dd-91ff5a9c64cb',
'07c1b2e1-cc20-46b6-8aec-df754b6af1ae',
'4d4b767c-dfaf-4d45-ae61-bbfbc10130db',
'c45e1abf-e961-44ca-9a0a-c1d1ef99507f',
'5b04b394-3efb-42af-b8ef-305910d35288',
'23dfcc79-a6e8-4bbe-ba27-5fa8640b4f00',
'fe8a553a-1e6c-4d3f-a078-3783fd1c5467',
'f1e1bddd-f57d-46a3-968e-bfd8d0a49dee',
'05a9332b-dd50-4d55-82ce-996c9e01c138',
'8a32b91c-146c-4bc1-9343-7f9831c55849',
'c5e2cd1e-977a-4c0b-89e9-021e0c771155',
'40e48cdf-122a-41c3-af8a-5e33b1f49783',
'337e8f00-4092-4bc2-a33e-3d74a7e42c45',
'7b36dc90-9318-4b5c-a2c5-6b3dd0f7dd52',
'585cbd9b-6c14-4eec-976f-3701bd2222f6',
'8786c80c-5697-4f7c-a5d3-eaf7ee996b1c',
'293ee528-b641-42ec-8c19-603513a944a7',
'652d5a69-ad07-461d-a117-32e2a23eac14',
'4a22b544-25e7-4928-88b3-b01a3b4607a3',
'44a9eb71-850f-4c78-b7f4-8bc02da297e3',
'24cb72a6-f72c-4d57-a3f3-75266728f362',
'2b563832-9df8-417e-9348-67535d4aae95',
'62f55ac1-7e9f-4d2f-9764-a06aa27ec044',
'5adcd22c-9d86-47b1-b752-8fd8034fa0b8',
'6b03afcf-5ef2-4699-9afb-3fe004cc7246',
'466e48a5-eb2f-4c4e-9d29-c660d110a7e3',
'c01f9887-cd40-41c5-8443-5502bccce303',
'c97920ef-0a2f-4a0b-b3a3-814fb449b6f2');