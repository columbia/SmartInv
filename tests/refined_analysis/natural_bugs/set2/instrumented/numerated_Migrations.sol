1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.4.22 <0.9.0;
3 
4 contract Migrations {
5   address public owner = msg.sender;
6   uint public last_completed_migration;
7 
8   modifier restricted() {
9     require(
10       msg.sender == owner,
11       "This function is restricted to the contract's owner"
12     );
13     _;
14   }
15 
16   function setCompleted(uint completed) public restricted {
17     last_completed_migration = completed;
18   }
19 }
