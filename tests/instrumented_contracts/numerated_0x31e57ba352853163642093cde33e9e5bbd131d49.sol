1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Crowdsale
35  * @dev Crowdsale is a base contract for managing a token crowdsale.
36  * Crowdsales have a start and end timestamps, where investors can make
37  * token purchases and the crowdsale will assign them tokens based
38  * on a token per ETH rate. Funds collected are forwarded to a wallet
39  * as they arrive.
40  */
41 contract token { function transfer(address receiver, uint amount){  } }
42 contract Crowdsale {
43   using SafeMath for uint256;
44 
45   // uint256 durationInMinutes;
46   // address where funds are collected
47   address public wallet;
48   // token address
49   address public addressOfTokenUsedAsReward;
50 
51   token tokenReward;
52 
53 
54 
55   // start and end timestamps where investments are allowed (both inclusive)
56   uint256 public startTime;
57   uint256 public endTime;
58   // amount of raised money in wei
59   uint256 public weiRaised;
60 
61   /**
62    * event for token purchase logging
63    * @param purchaser who paid for the tokens
64    * @param beneficiary who got the tokens
65    * @param value weis paid for purchase
66    * @param amount amount of tokens purchased
67    */
68   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
69 
70 
71   function Crowdsale() {
72     // wallet = 0x06e8e1c94a03bf157f04FA6528D67437Cb2EBA10;
73     wallet = 0x76483693D885c9ed9055d606D612B1050E981C33;//is it correct?yes ok
74     //your address...
75     // durationInMinutes = _durationInMinutes;
76     addressOfTokenUsedAsReward = 0x77727ef417696f95a10652cf2d02d6421dda5048;
77 
78 
79     tokenReward = token(addressOfTokenUsedAsReward);
80     startTime = now + 12085 * 1 minutes;
81     endTime = startTime + 51*24*60 * 1 minutes;
82   }
83 
84   // fallback function can be used to buy tokens
85   function () payable {
86     buyTokens(msg.sender);
87   }
88 
89   // low level token purchase function
90   // mapping (address => uint) public BALANCE;
91 
92   function buyTokens(address beneficiary) payable {
93     require(beneficiary != 0x0);
94     require(validPurchase());
95 
96     uint256 weiAmount = msg.value;
97     if(weiAmount <  5*10**17 || weiAmount > 10**19) throw;
98 
99     // calculate token amount to be sent
100     uint _price;
101 
102     if(now < startTime + 20*24*60 * 1 minutes)
103       _price = 3300;
104     else _price = 3000;
105     uint256 tokens = (weiAmount / 10000000000) * _price;
106 
107     // update state
108     weiRaised = weiRaised.add(weiAmount);
109 
110     tokenReward.transfer(beneficiary, tokens);
111     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
112     forwardFunds();
113   }
114 
115   // send ether to the fund collection wallet
116   // override to create custom fund forwarding mechanisms
117   function forwardFunds() internal {
118     // wallet.transfer(msg.value);
119     if (!wallet.send(msg.value)) {
120       throw;
121     }
122   }
123 
124   // @return true if the transaction can buy tokens
125   function validPurchase() internal constant returns (bool) {
126     bool withinPeriod = now >= startTime && now <= endTime;
127     bool nonZeroPurchase = msg.value != 0;
128     return withinPeriod && nonZeroPurchase;
129   }
130 
131   // @return true if crowdsale event has ended
132   function hasEnded() public constant returns (bool) {
133     return now > endTime;
134   }
135 
136   function withdrawTokens(uint256 _amount) {
137     if(msg.sender!=wallet) throw;
138     tokenReward.transfer(wallet,_amount);
139   }
140 }