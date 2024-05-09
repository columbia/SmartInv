1 pragma solidity 0.4.24;
2 
3 
4 contract Migrations {
5     address public owner;
6     uint public last_completed_migration; // solhint-disable-line var-name-mixedcase
7 
8     modifier restricted() {
9         if (msg.sender == owner) _;
10     }
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     function setCompleted(uint completed) external restricted {
17         last_completed_migration = completed;
18     }
19 
20     function upgrade(address newAddress) external restricted {
21         Migrations upgraded = Migrations(newAddress);
22         upgraded.setCompleted(last_completed_migration);
23     }
24 }