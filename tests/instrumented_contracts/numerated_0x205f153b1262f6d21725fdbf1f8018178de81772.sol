1 pragma solidity 0.4.18;
2 
3 
4 /*
5  * https://github.com/OpenZeppelin/zeppelin-solidity
6  *
7  * The MIT License (MIT)
8  * Copyright (c) 2016 Smart Contract Solutions, Inc.
9  */
10 contract Ownable {
11 
12     address public owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() public {
21         owner = msg.sender;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address newOwner) public onlyOwner {
37         require(newOwner != address(0));
38         OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 }
42 
43 
44 contract Migrations is Ownable {
45     /* solhint-disable var-name-mixedcase */
46     /* solhint-disable func-param-name-mixedcase */
47 
48     uint public last_completed_migration;
49 
50     function setCompleted(uint completed) public onlyOwner {
51         last_completed_migration = completed;
52     }
53 
54     function upgrade(address new_address) public onlyOwner {
55         Migrations upgraded = Migrations(new_address);
56         upgraded.setCompleted(last_completed_migration);
57     }
58 }