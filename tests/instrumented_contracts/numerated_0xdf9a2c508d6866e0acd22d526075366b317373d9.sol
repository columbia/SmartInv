1 pragma solidity 0.4.24;
2 
3 // File: contracts/Migrations.sol
4 
5 contract Migrations {
6   address public owner;
7   uint public last_completed_migration;
8 
9   modifier restricted() {
10     if (msg.sender == owner)
11       _;
12   }
13 
14   constructor() public {
15     owner = msg.sender;
16   }
17 
18   function setCompleted(uint completed) public restricted {
19     last_completed_migration = completed;
20   }
21 
22   function upgrade(address _newAddress) public restricted {
23     Migrations upgraded = Migrations(_newAddress);
24     upgraded.setCompleted(last_completed_migration);
25   }
26 }