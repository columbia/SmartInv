1 contract Migrations {
2   address public owner;
3   uint public last_completed_migration;
4 
5   modifier restricted() {
6     if (msg.sender == owner) _
7   }
8 
9   function Migrations() {
10     owner = msg.sender;
11   }
12 
13   function setCompleted(uint completed) restricted {
14     last_completed_migration = completed;
15   }
16 
17   function upgrade(address new_address) restricted {
18     Migrations upgraded = Migrations(new_address);
19     upgraded.setCompleted(last_completed_migration);
20   }
21 }