1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20Basic {
19     function allowance(address owner, address spender) public view returns (uint256);
20     function transferFrom(address from, address to, uint256 value) public returns (bool);
21     function approve(address spender, uint256 value) public returns (bool);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 contract MassSenderForFork {
25     mapping(address => mapping (uint32 => bool)) processedTransactions;
26     ERC20 private fork = ERC20(0x5bB1632fA0023e1AA76a1AE92B4635C8DBa49Fa2);
27 
28     function bulkTransferFrom(
29         uint32[] payment_ids,
30         address[] receivers,
31         uint256[] transfers
32     ) external {
33         require(payment_ids.length == receivers.length);
34         require(payment_ids.length == transfers.length);
35 
36         for (uint i = 0; i < receivers.length; i++) {
37             if (!processedTransactions[msg.sender][payment_ids[i]]) {
38                 require(fork.transferFrom(msg.sender, receivers[i], transfers[i]));
39 
40                 processedTransactions[msg.sender][payment_ids[i]] = true;
41             }
42         }
43     }
44 }