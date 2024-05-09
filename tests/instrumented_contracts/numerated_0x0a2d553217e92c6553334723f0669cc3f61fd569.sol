1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24   /**
25   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
26   */
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31   /**
32   * @dev Adds two numbers, throws on overflow.
33   */
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 contract LowRiskBag {
42   using SafeMath for uint256;
43 
44   address contractOwner;
45   uint tokenStartPrice = 0.001 ether;
46   uint tokenPrice;
47   address tokenOwner;
48   uint lastBuyBlock;
49   uint newRoundDelay = 40;
50   event Transfer(address indexed from, address indexed to, uint256 price);
51   event NewRound();
52     
53 
54   function LowRiskBag() public {
55     contractOwner = msg.sender;
56     tokenOwner = address(0);
57     lastBuyBlock = block.number; 
58     tokenPrice = tokenStartPrice;
59   }
60 
61   function changeContractOwner(address newOwner) public {
62     require(contractOwner == msg.sender);
63     contractOwner = newOwner;
64   }
65   function changeStartPrice(uint price) public {
66     require(contractOwner == msg.sender);
67     tokenStartPrice = price;
68   }
69     
70   function changeNewRoundDelay(uint delay) public {
71     require(contractOwner == msg.sender);
72     newRoundDelay = delay;
73   }
74   
75   function buyToken() public payable {
76     address currentOwner = tokenOwner;
77     uint256 currentPrice = tokenPrice;
78 
79     require(currentOwner != msg.sender);
80     require(msg.value >= currentPrice);
81     require(currentPrice > 0);
82 
83     uint256 paidTooMuch = msg.value.sub(currentPrice);
84     uint256 payment = currentPrice.div(2);
85     
86     tokenPrice = currentPrice.mul(110).div(50);
87     tokenOwner = msg.sender;
88     lastBuyBlock = block.number;
89 
90     Transfer(currentOwner, msg.sender, currentPrice);
91     if (currentOwner != address(0))
92       currentOwner.transfer(payment);
93     if (paidTooMuch > 0)
94       msg.sender.transfer(paidTooMuch);
95   }
96 
97   function getBlocksToNextRound() public view returns(uint) {
98     if (lastBuyBlock + newRoundDelay < block.number)
99       return 0;
100     return lastBuyBlock + newRoundDelay + 1 - block.number;
101   }
102 
103   function getCurrentData() public view returns (uint price, uint nextPrice, uint pool, uint nextPool, address owner, bool canFinish) {
104     owner = tokenOwner;
105     pool = tokenPrice.mul(50).div(110).mul(85).div(100);
106     nextPool = tokenPrice.mul(85).div(100);
107     price = tokenPrice;
108     nextPrice = price.mul(110).div(50);
109     if (getBlocksToNextRound() == 0)
110       canFinish = true;
111     else
112       canFinish = false;
113   }
114 
115   function finishRound() public {
116     require(tokenPrice > tokenStartPrice);
117     require(tokenOwner == msg.sender || lastBuyBlock + newRoundDelay < block.number);
118     lastBuyBlock = block.number;
119     uint payout = tokenPrice.mul(50).div(110).mul(85).div(100); // 85% of last paid price
120     address owner = tokenOwner;
121     tokenPrice = tokenStartPrice;
122     tokenOwner = address(0);
123     owner.transfer(payout);
124     NewRound();
125   }
126 
127   function payout(uint amount) public {
128     require(contractOwner == msg.sender);
129     uint balance = this.balance;
130     if (tokenPrice > tokenStartPrice)
131       balance -= tokenPrice.mul(50).div(110).mul(85).div(100); // payout for tokenOwner cant be paid out from contract owner
132     if (amount>balance)
133       amount = balance;
134     contractOwner.transfer(amount);
135   }
136   
137   function getBalance() public view returns(uint balance) {
138     balance = this.balance;
139     if (tokenPrice > tokenStartPrice)
140       balance -= tokenPrice.mul(50).div(110).mul(85).div(100); // payout for tokenOwner cant be paid out from contract owner
141       
142   }
143 }