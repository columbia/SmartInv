1 //pragma solidity >=0.4.21 <0.6.0;
2 pragma solidity 0.4.24;
3 
4 contract Migrations {
5   address public owner;
6   uint public last_completed_migration;
7 
8   constructor() public {
9     owner = msg.sender;
10   }
11 
12   modifier restricted() {
13     if (msg.sender == owner) _;
14   }
15 
16   function setCompleted(uint completed) public restricted {
17     last_completed_migration = completed;
18   }
19 
20   function upgrade(address new_address) public restricted {
21     Migrations upgraded = Migrations(new_address);
22     upgraded.setCompleted(last_completed_migration);
23   }
24 }