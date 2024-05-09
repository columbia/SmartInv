1 // pragma solidity ^0.4.0;
2 contract MigrationAgent {
3     event Migrated( uint indexed id, address indexed from, uint amount, string eos_account_name);
4     event NameRegistered(address indexed from, string eos_account_name);
5 
6     struct Migration {
7         uint id;
8         address participant;
9         string eos_account_name;
10         uint amount;
11     }
12 
13     address game_address = 0xb1;
14     address public token_address = 0x089A6D83282Fb8988A656189F1E7A73FA6C1caC2;
15     uint public migration_id = 0;
16     
17     mapping(address => string) public registrations;
18     mapping(uint => Migration) public migrations;
19     mapping(address => Migration[]) public participant_migrations;
20 
21     function migrateFrom(address participant, uint amount) public {
22         if (msg.sender != token_address || !participantRegistered(participant) || amount < 0.0001 ether) revert();
23         if (participant != game_address)
24         {
25             var migration = Migration(migration_id, participant, registrations[participant], amount);
26             participant_migrations[participant].push(migration);
27             migrations[migration_id] = migration;
28             emit Migrated(migration_id, participant, amount, registrations[participant]);
29             migration_id++;
30         }
31     }
32     
33     function register(string eos_account_name) public
34     {
35         registrations[msg.sender] = eos_account_name;
36         if (participantRegistered(msg.sender))
37             emit NameRegistered(msg.sender, eos_account_name);
38     }
39     
40     function participantRegistered(address participant) public constant returns (bool)
41     {
42         return participant == game_address || keccak256(registrations[participant]) != keccak256("");
43     }
44 }