1 pragma solidity ^0.4.13;
2 
3 /**
4  * blocksoft.biz antifake demo
5  */
6 
7 contract Products {
8 
9 	uint8 constant STATUS_ADDED = 1;
10 
11 	uint8 constant STATUS_REGISTERED = 2;
12 
13 	//who can add products
14 	address public owner;
15 
16 	//indexed requests storage
17 	mapping (bytes32 => uint8) items;
18 
19 	//constructor
20 	function Products() {
21 		owner = msg.sender;
22 	}
23 
24 	//default
25 	function() {
26 		revert();
27 	}
28 
29 	//generate public from secret for manufacturer (note this is not going to transactions - just constant!)
30 	function getPublicForSecretFor(bytes32 secret) constant returns (bytes32 pubkey) {
31 		pubkey = sha3(secret);
32 	}
33 
34 	//add item from manufacturer
35 	function addItem(bytes32 pubkey) public returns (bool) {
36 		if (msg.sender != owner) {
37 			revert();
38 		}
39 		items[pubkey] = STATUS_ADDED;
40 	}
41 
42 	//check item by customer
43 	function checkItem(bytes32 pubkey) constant returns (uint8 a) {
44 		a = items[pubkey];
45 	}
46 
47 	//update item by customer
48 	function updateRequestSeed(bytes32 pubkey, bytes32 secret) returns (bool) {
49 		if (items[pubkey] != STATUS_ADDED) {
50 			revert();
51 		}
52 		if (!(sha3(secret) == pubkey)) {
53 			revert();
54 		}
55 		items[pubkey] = STATUS_REGISTERED;
56 	}
57 }