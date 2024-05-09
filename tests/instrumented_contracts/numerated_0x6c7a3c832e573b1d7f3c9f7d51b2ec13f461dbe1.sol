1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) internal returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) internal returns (uint) {
16     uint c = a + b;
17     assert(c>=a && c>=b);
18     return c;
19   }
20 
21   function assert(bool assertion) internal {
22     if (!assertion) throw;
23   }
24 }
25 
26 contract Ownable {
27   address public owner;
28 
29 
30   /** 
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner. 
41    */
42   modifier onlyOwner() {
43     if (msg.sender != owner) {
44       throw;
45     }
46     _;
47   }
48 
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to. 
53    */
54   function transferOwnership(address newOwner) onlyOwner {
55     if (newOwner != address(0)) {
56       owner = newOwner;
57     }
58   }
59 
60 }
61 
62 contract ERC20Basic {
63   uint public totalSupply;
64   function balanceOf(address who) constant returns (uint);
65   function transfer(address to, uint value);
66   event Transfer(address indexed from, address indexed to, uint value);
67 }
68 
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) constant returns (uint);
71   function transferFrom(address from, address to, uint value);
72   function approve(address spender, uint value);
73   event Approval(address indexed owner, address indexed spender, uint value);
74 }
75 
76 
77 contract BitcoinStore is Ownable, SafeMath {
78 
79   address constant public Bitcoin_address =0xB6eD7644C69416d67B522e20bC294A9a9B405B31;// TESTNET CONTRACT: 0x9D2Cc383E677292ed87f63586086CfF62a009010
80   uint bitcoin_ratio = 500*1E8;
81   uint eth_ratio = 1*1E18;
82 
83   function update_ratio(uint new_bitcoin_ratio, uint new_eth_ratio) 
84   onlyOwner
85   {
86     bitcoin_ratio = new_bitcoin_ratio;
87     eth_ratio = new_eth_ratio;
88   }
89 
90   function send(address _tokenAddr, address dest, uint value)
91   onlyOwner
92   {
93       ERC20(_tokenAddr).transfer(dest, value);
94   }
95 
96   function multisend(address _tokenAddr, address[] dests, uint[] values)
97   onlyOwner
98   returns (uint) {
99       uint i = 0;
100       while (i < dests.length) {
101          ERC20(_tokenAddr).transfer(dests[i], values[i]);
102          i += 1;
103       }
104       return(i);
105   }
106 
107   /* fallback function for when ether is sent to the contract */
108   function () external payable {
109     uint buytokens = safeMul(bitcoin_ratio , msg.value)/eth_ratio;
110     ERC20(Bitcoin_address).transfer(msg.sender, buytokens);
111   }
112 
113   function buy() public payable {
114     uint buytokens = safeMul(bitcoin_ratio , msg.value)/eth_ratio;
115     ERC20(Bitcoin_address).transfer(msg.sender, buytokens);
116   }
117 
118   function withdraw() onlyOwner {
119     msg.sender.transfer(this.balance);
120   }
121 }