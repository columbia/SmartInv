1 pragma solidity ^0.4.17;
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
72     wallet = 0x9bdaC0B2dDF9F62F2aD03BE43671D5665Ac5b2bB;
73     addressOfTokenUsedAsReward = 0xc310755f88145cabcAA06c714cD668b5465DceaA;
74 
75 
76     tokenReward = token(addressOfTokenUsedAsReward);
77     //update required here.
78     startTime = now + 2625 * 1 minutes;
79     endTime = startTime + 77*24*60 * 1 minutes;
80   }
81 
82   // fallback function can be used to buy tokens
83   function () payable {
84     buyTokens(msg.sender);
85   }
86 
87   // low level token purchase function
88   function buyTokens(address beneficiary) payable {
89     require(beneficiary != 0x0);
90     require(validPurchase());
91 
92     uint256 weiAmount = msg.value;
93     uint price;
94 
95     if(weiRaised < 222*10**18){
96       price = 45000;
97     }else if(weiRaised < 35777*10**18){
98       price = 22500;
99     }else{
100       price = 11250;
101     }
102 
103 
104 
105     // calculate token amount to be sent
106     uint256 tokens = (weiAmount) * price;
107 
108     // update state
109     weiRaised = weiRaised.add(weiAmount);
110 
111     tokenReward.transfer(beneficiary, tokens);
112     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
113     forwardFunds();
114   }
115 
116   // send ether to the fund collection wallet
117   // override to create custom fund forwarding mechanisms
118   function forwardFunds() internal {
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