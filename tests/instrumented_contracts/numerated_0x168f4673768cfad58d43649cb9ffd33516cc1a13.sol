1 pragma solidity 0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Migrations {
6     address public owner;
7     uint public last_completed_migration;
8 
9     modifier restricted() {
10         if (msg.sender == owner) _;
11     }
12 
13     constructor() public {
14         owner = msg.sender;
15     }
16 
17     function setCompleted(uint completed) public restricted {
18         last_completed_migration = completed;
19     }
20 
21     function upgrade(address new_address) public restricted {
22         Migrations upgraded = Migrations(new_address);
23         upgraded.setCompleted(last_completed_migration);
24     }
25 }