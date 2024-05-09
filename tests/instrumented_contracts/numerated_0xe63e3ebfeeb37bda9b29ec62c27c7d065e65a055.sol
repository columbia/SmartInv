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
58 
59   function getBalance()
60   public
61   view
62   returns (uint)
63   {
64       return ERC20Basic(Bitcoin_address).balanceOf(this);
65   }
66 
67   function getPrice()
68   public
69   view
70   returns (uint)
71   {
72       return tokenPrice;
73   }
74 
75   function updatePrice(uint newPrice)
76   onlyOwner
77   {
78       tokenPrice = newPrice;
79   }
80 
81   function send(address _tokenAddr, address dest, uint value)
82   onlyOwner
83   {
84       ERC20(_tokenAddr).transfer(dest, value);
85   }
86 
87   /* fallback function for when ether is sent to the contract */
88   function () external payable {
89       uint buytokens = msg.value / tokenPrice;
90       require(getBalance() >= buytokens);
91       ERC20(Bitcoin_address).transfer(msg.sender, buytokens);
92   }
93 
94   function buy() public payable {
95       uint buytokens = msg.value / tokenPrice;
96       require(getBalance() >= buytokens);
97       ERC20(Bitcoin_address).transfer(msg.sender, buytokens);
98   }
99 
100   function withdraw() onlyOwner {
101       msg.sender.transfer(this.balance);
102   }
103 }