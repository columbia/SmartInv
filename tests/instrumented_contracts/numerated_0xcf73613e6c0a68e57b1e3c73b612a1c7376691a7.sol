1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     if (msg.sender != owner) {
27       throw;
28     }
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner {
38     if (newOwner != address(0)) {
39       owner = newOwner;
40     }
41   }
42 
43 }
44 
45 
46 
47 /**
48  * @title Claimable
49  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
50  * This allows the new owner to accept the transfer.
51  */
52 contract Claimable is Ownable {
53   address public pendingOwner;
54 
55   /**
56    * @dev Modifier throws if called by any account other than the pendingOwner.
57    */
58   modifier onlyPendingOwner() {
59     if (msg.sender != pendingOwner) {
60       throw;
61     }
62     _;
63   }
64 
65   /**
66    * @dev Allows the current owner to set the pendingOwner address.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner {
70     pendingOwner = newOwner;
71   }
72 
73   /**
74    * @dev Allows the pendingOwner address to finalize the transfer.
75    */
76   function claimOwnership() onlyPendingOwner {
77     owner = pendingOwner;
78     pendingOwner = 0x0;
79   }
80 }
81 
82 contract Index is Claimable {
83   address [] public addresses;
84 
85   function getAllAddresses() constant public returns(address []) {
86     return addresses;
87   }
88 
89   function add(address item) onlyOwner {
90     addresses.push(item);
91   }
92 
93   function remove(uint pos) onlyOwner {
94     if (pos >= addresses.length) throw;
95     delete addresses[pos];
96   }
97 }