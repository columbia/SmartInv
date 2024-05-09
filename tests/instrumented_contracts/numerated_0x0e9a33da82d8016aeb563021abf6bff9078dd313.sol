1 pragma solidity ^0.4.0;
2 
3 /**
4 
5  * @title Ownable
6 
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8 
9  * functions, this simplifies the implementation of "user permissions".
10 
11  */
12 
13 contract Ownable {
14 
15   address public owner;
16 
17 
18 
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24 
25 
26 
27   /**
28 
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30 
31    * account.
32 
33    */
34 
35   function Ownable () public {owner = msg.sender;
36 
37   }
38 
39 
40 
41 
42 
43   /**
44 
45    * @dev Throws if called by any account other than the owner.
46 
47    */
48 
49   modifier onlyOwner() {
50 
51     require(msg.sender == owner);
52 
53     _;
54 
55   }
56 
57 
58 
59 
60 
61   /**
62 
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64 
65    * @param newOwner The address to transfer ownership to.
66 
67    */
68 
69   function transferOwnership(address newOwner) onlyOwner public {
70 
71     require(newOwner != address(0));
72 
73     OwnershipTransferred(owner, newOwner);
74 
75     owner = newOwner;
76 
77   }
78 
79 }
80 
81 
82 
83 contract token {function transfer (address receiver, uint _amount) public { } }
84 
85 
86 
87 contract Distribute is Ownable{
88 
89   
90 
91     token tokenReward = token(0xdd007278B667F6bef52fD0a4c23604aA1f96039a);
92 
93 
94 
95   function register(address[] _addrs) public onlyOwner{
96 
97     for(uint i = 0; i < _addrs.length; ++i){
98 
99       tokenReward.transfer(_addrs[i],20*10**8);
100 
101     }
102 
103   }
104 
105 
106 
107   function withdraw(uint _amount) public onlyOwner {
108 
109     tokenReward.transfer(owner,_amount);
110 
111   }
112 
113 }