1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     if (msg.sender != owner) {
21       throw;
22     }
23     _;
24   }
25 
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) onlyOwner {
32     if (newOwner != address(0)) {
33       owner = newOwner;
34     }
35   }
36 
37 }
38 
39 contract ERC20Basic {
40   uint public totalSupply;
41   function balanceOf(address who) constant returns (uint);
42   function transfer(address to, uint value);
43   event Transfer(address indexed from, address indexed to, uint value);
44 }
45 
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender) constant returns (uint);
48   function transferFrom(address from, address to, uint value);
49   function approve(address spender, uint value);
50   event Approval(address indexed owner, address indexed spender, uint value);
51 }
52 
53 
54 contract BitcoinStore is Ownable {
55 
56   address constant public Bitcoin_address = 0xB6eD7644C69416d67B522e20bC294A9a9B405B31;
57   uint tokenPrice = 35e14; // 0.0035 eth starting price
58   uint tokenFactor = 1e8;
59 
60   function getBalance()
61   public
62   view
63   returns (uint)
64   {
65       return ERC20Basic(Bitcoin_address).balanceOf(this);
66   }
67 
68   function getPrice()
69   public
70   view
71   returns (uint)
72   {
73       return tokenPrice;
74   }
75 
76   function updatePrice(uint newPrice)
77   onlyOwner
78   {
79       tokenPrice = newPrice;
80   }
81 
82   function send(address _tokenAddr, address dest, uint value)
83   onlyOwner
84   {
85       ERC20(_tokenAddr).transfer(dest, value);
86   }
87 
88   /* fallback function for when ether is sent to the contract */
89   function () external payable {
90       uint buytokens = msg.value * tokenFactor / tokenPrice;
91       require(getBalance() >= buytokens);
92       ERC20(Bitcoin_address).transfer(msg.sender, buytokens);
93   }
94 
95   function buy() public payable {
96       uint buytokens = msg.value * tokenFactor / tokenPrice;
97       require(getBalance() >= buytokens);
98       ERC20(Bitcoin_address).transfer(msg.sender, buytokens);
99   }
100 
101   function withdraw() onlyOwner {
102       msg.sender.transfer(this.balance);
103   }
104 }