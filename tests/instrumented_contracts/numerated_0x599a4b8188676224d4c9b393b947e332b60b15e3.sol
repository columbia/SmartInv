1 pragma solidity ^0.4.8;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     if (msg.sender != owner) {
12       throw;
13     }
14     _;
15   }
16 
17   function transferOwnership(address newOwner) onlyOwner {
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22 
23 }
24 
25 contract Killable is Ownable {
26   function kill() onlyOwner {
27     selfdestruct(owner);
28   }
29 }
30 
31 contract ERC20 {
32   uint public totalSupply;
33   function balanceOf(address who) constant returns (uint);
34   function allowance(address owner, address spender) constant returns (uint);
35 
36   function transfer(address to, uint value) returns (bool ok);
37   function transferFrom(address from, address to, uint value) returns (bool ok);
38   function approve(address spender, uint value) returns (bool ok);
39   event Transfer(address indexed from, address indexed to, uint value);
40   event Approval(address indexed owner, address indexed spender, uint value);
41 }
42 
43 contract SafeMath {
44   function safeMul(uint a, uint b) internal returns (uint) {
45     uint c = a * b;
46     assert(a == 0 || c / a == b);
47     return c;
48   }
49 
50   function safeDiv(uint a, uint b) internal returns (uint) {
51     assert(b > 0);
52     uint c = a / b;
53     assert(a == b * c + a % b);
54     return c;
55   }
56 
57   function safeSub(uint a, uint b) internal returns (uint) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function safeAdd(uint a, uint b) internal returns (uint) {
63     uint c = a + b;
64     assert(c>=a && c>=b);
65     return c;
66   }
67 
68   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
69     return a >= b ? a : b;
70   }
71 
72   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
73     return a < b ? a : b;
74   }
75 
76   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
77     return a >= b ? a : b;
78   }
79 
80   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
81     return a < b ? a : b;
82   }
83 
84   function assert(bool assertion) internal {
85     if (!assertion) {
86       throw;
87     }
88   }
89 }
90 
91 
92 /// @title Veritaseum Purchase
93 /// @author Riaan F Venter~ RFVenter~ <msg@rfv.io>
94 contract TokenPurchase is Ownable, Killable, SafeMath {
95 
96     uint public constant startTime = 1493130600;            // 2017 April 25th 9:30 EST (14:30 UTC)
97     uint public constant closeTime = startTime + 31 days;   // ICO will run for 31 days
98     uint public constant price = 33333333333333333;         // Each token has 18 decimal places, just like ether.
99     uint private constant priceDayOne = price * 8 / 10;     // Day one price [20 % discount (x * 8 / 10)]
100     uint private constant priceDayTwo = price * 9 / 10;     // Day two price [10 % discount (x * 9 / 10)]
101 
102     ERC20 public token;                         // the address of the token 
103 
104     // //// time test functionality /////
105     // uint public now;                //
106     //                                 //
107     // function setNow(uint _time) {   //
108     //     now = _time;                //
109     // }                               //
110     // //////////////////////////////////
111 
112     /// @notice Used to buy tokens with Ether
113     /// @return The amount of actual tokens purchased
114     function purchaseTokens() payable returns (uint) {
115         // check if now is within ICO period, or if the amount sent is nothing
116         if ((now < startTime) || (now > closeTime) || (msg.value == 0)) throw;
117         
118         uint currentPrice;
119         // only using safeMath for calculations involving external incoming data (to safe gas)
120         if (now < (startTime + 1 days)) {       // day one discount
121             currentPrice = priceDayOne;
122         } 
123         else if (now < (startTime + 2 days)) {  // day two discount
124             currentPrice = priceDayTwo;
125         }
126         else if (now < (startTime + 12 days)) {
127             // 1 % reduction in the discounted rate from day 2 until day 12 (sliding scale per second)
128             currentPrice = price - ((startTime + 12 days - now) * price / 100 days);
129         }
130         else {
131             currentPrice = price;
132         }
133         uint tokens = safeMul(msg.value, 1 ether) / currentPrice;       // only one safeMath check is required for the incoming ether value
134 
135         if (!token.transferFrom(owner, msg.sender, tokens)) throw;      // if there is some error with the token transfer, throw and return the Ether
136 
137         return tokens;                          // after successful purchase, return the amount of tokens purchased value
138     }
139 
140     //////////////// owner only functions below
141 
142     /// @notice Withdraw all Ether in this contract
143     /// @return True if successful
144     function withdrawEther() payable onlyOwner returns (bool) {
145         return owner.send(this.balance);
146     }
147 
148     /// @notice sets the token that is to be used for this Lottery
149     /// @param _token The address of the ERC20 token
150     function setToken(address _token) external onlyOwner {     
151         token = ERC20(_token);
152     }
153 }