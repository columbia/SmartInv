1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 contract JoyTokenAbstract {
47   function unlock();
48 }
49 
50 /**
51  * @title Crowdsale
52  * @dev Crowdsale is a base contract for managing a token crowdsale.
53  * Crowdsales have a start and end timestamps, where investors can make
54  * token purchases and the crowdsale will assign them tokens based
55  * on a token per ETH rate. Funds collected are forwarded to a wallet
56  * as they arrive.
57  */
58 contract JoysoCrowdsale {
59   using SafeMath for uint256;
60 
61   // The token being sold
62   address constant public JOY = 0xDDe12a12A6f67156e0DA672be05c374e1B0a3e57;
63 
64   // start and end timestamps where investments are allowed (both inclusive)
65   uint256 public startTime;
66   uint256 public endTime;
67 
68   // address where funds are collected
69   address public joysoWallet = 0xC640B901a529C58FB6f6C53665768E2d5c835421;
70 
71   // how many token units a buyer gets per wei
72   uint256 public rate = 10000;
73 
74   // amount of raised money in wei
75   uint256 public weiRaised;
76 
77   /**
78    * event for token purchase logging
79    * @param purchaser who paid for the tokens
80    * @param beneficiary who got the tokens
81    * @param value weis paid for purchase
82    * @param amount amount of tokens purchased
83    */
84   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
85 
86   // fallback function can be used to buy tokens
87   function () external payable {
88     buyTokens(msg.sender);
89   }
90 
91   // low level token purchase function
92   function buyTokens(address beneficiary) public payable {
93     require(beneficiary != address(0));
94     require(validPurchase());
95 
96     // calculate token amount to be created
97     uint256 joyAmounts = calculateObtainedJOY(msg.value);
98 
99     // update state
100     weiRaised = weiRaised.add(msg.value);
101 
102     require(ERC20Basic(JOY).transfer(beneficiary, joyAmounts));
103     TokenPurchase(msg.sender, beneficiary, msg.value, joyAmounts);
104 
105     forwardFunds();
106   }
107 
108   // send ether to the fund collection wallet
109   // override to create custom fund forwarding mechanisms
110   function forwardFunds() internal {
111     joysoWallet.transfer(msg.value);
112   }
113 
114   function calculateObtainedJOY(uint256 amountEtherInWei) public view returns (uint256) {
115     return amountEtherInWei.mul(rate).div(10 ** 12);
116   } 
117 
118   // @return true if the transaction can buy tokens
119   function validPurchase() internal view returns (bool) {
120     bool withinPeriod = now >= startTime && now <= endTime;
121     return withinPeriod;
122   }
123 
124   // @return true if crowdsale event has ended
125   function hasEnded() public view returns (bool) {
126     bool isEnd = now > endTime || weiRaised >= 10 ** (18 + 4);
127     return isEnd;
128   }
129 
130   // only admin 
131   function releaseJoyToken() public returns (bool) {
132     require (hasEnded() && startTime != 0);
133     require (msg.sender == joysoWallet || now > endTime + 10 days);
134     uint256 remainedJoy = ERC20Basic(JOY).balanceOf(this);
135     require(ERC20Basic(JOY).transfer(joysoWallet, remainedJoy));    
136     JoyTokenAbstract(JOY).unlock();
137   }
138 
139   // be sure to get the joy token ownerships
140   function start() public returns (bool) {
141     require (msg.sender == joysoWallet);
142     startTime = now;
143     endTime = now + 21 days;
144   }
145 
146   function changeJoysoWallet(address _joysoWallet) public returns (bool) {
147     require (msg.sender == joysoWallet);
148     joysoWallet = _joysoWallet;
149   }
150 }