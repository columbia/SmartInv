1 pragma solidity ^0.4.24;
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
46 contract SBTTokenAbstract {
47   function unlock() public;
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
58 contract StarbitCrowdsale {
59   using SafeMath for uint256;
60 
61   // The token being sold
62   address constant public SBT = 0x503F9794d6A6bB0Df8FBb19a2b3e2Aeab35339Ad;
63 
64   // start and end timestamps where investments are allowed (both inclusive)
65   uint256 public startTime;
66   uint256 public endTime;
67 
68   // address where funds are collected
69   address public starbitWallet = 0xb94F5256B4B87bb7366fA85963Ae041a31F2CcFE;
70   address public setWallet = 0xdca6c0569bb618f8dd91e259681e26363dbc16d4;
71   // how many token units a buyer gets per wei
72   uint256 public rate = 6000;
73 
74   // amount of raised money in wei
75   uint256 public weiRaised;
76   uint256 public weiSold;
77 
78   /**
79    * event for token purchase logging
80    * @param purchaser who paid for the tokens
81    * @param beneficiary who got the tokens
82    * @param value weis paid for purchase
83    * @param amount amount of tokens purchased
84    */
85   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
86 
87   // fallback function can be used to buy tokens
88   function () external payable {
89     buyTokens(msg.sender);
90   }
91 
92   // low level token purchase function
93   function buyTokens(address beneficiary) public payable {
94     require(beneficiary != address(0));
95     require(validPurchase());
96     require(msg.value>=100000000000000000 && msg.value<=200000000000000000000);
97     // calculate token amount to be created
98     uint256 sbtAmounts = calculateObtainedSBT(msg.value);
99 
100     // update state
101     weiRaised = weiRaised.add(msg.value);
102     weiSold = weiSold.add(sbtAmounts);
103     require(ERC20Basic(SBT).transfer(beneficiary, sbtAmounts));
104     emit TokenPurchase(msg.sender, beneficiary, msg.value, sbtAmounts);
105     
106     forwardFunds();
107   }
108 
109   // send ether to the fund collection wallet
110   // override to create custom fund forwarding mechanisms
111   function forwardFunds() internal {
112     starbitWallet.transfer(msg.value);
113   }
114 
115   function calculateObtainedSBT(uint256 amountEtherInWei) public view returns (uint256) {
116     checkRate();
117     return amountEtherInWei.mul(rate);
118   }
119 
120   // @return true if the transaction can buy tokens
121   function validPurchase() internal view returns (bool) {
122     bool withinPeriod = now >= startTime && now <= endTime;
123     return withinPeriod;
124   }
125 
126   // @return true if crowdsale event has ended
127   function hasEnded() public view returns (bool) {
128     bool isEnd = now > endTime || weiRaised >= 20000000000000000000000000;
129     return isEnd;
130   }
131 
132   // only admin 
133   function releaseSbtToken() public returns (bool) {
134     require (msg.sender == setWallet);
135     require (hasEnded() && startTime != 0);
136     uint256 remainedSbt = ERC20Basic(SBT).balanceOf(this);
137     require(ERC20Basic(SBT).transfer(starbitWallet, remainedSbt));    
138     SBTTokenAbstract(SBT).unlock();
139   }
140 
141   // be sure to get the token ownerships
142   function start() public returns (bool) {
143     require (msg.sender == setWallet);
144     startTime = 1533052800;
145     endTime = 1535731199;
146   }
147 
148   function changeStarbitWallet(address _starbitWallet) public returns (bool) {
149     require (msg.sender == setWallet);
150     starbitWallet = _starbitWallet;
151   }
152    function checkRate() public returns (bool) {
153     if (now>=startTime && now<1533657600){
154         rate = 6000;
155     }else if (now >= 1533657600 && now < 1534867200) {
156         rate = 5500;
157     }else if (now >= 1534867200) {
158         rate = 5000;
159     }
160   }
161 }