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
73     wallet = 0x7f863e49e4F04851f28af6C6E77cE4E8bb7F9486;
74     // durationInMinutes = _durationInMinutes;
75     addressOfTokenUsedAsReward = 0xA35E4a5C0C228a342c197e3440dFF1A584cc479C;
76 
77 
78     tokenReward = token(addressOfTokenUsedAsReward);
79     startTime = now;
80     endTime = startTime + 13*24*60 * 1 minutes;
81   }
82 
83   // fallback function can be used to buy tokens
84   function () payable {
85     buyTokens(msg.sender);
86   }
87 
88   // low level token purchase function
89   // mapping (address => uint) public BALANCE;
90 
91   function buyTokens(address beneficiary) payable {
92     require(beneficiary != 0x0);
93     require(validPurchase());
94 
95     uint256 weiAmount = msg.value;
96     // calculate token amount to be sent
97     uint _price;
98 
99     if(now < startTime + 6*24*60 * 1 minutes)
100       _price = 1200;
101     else _price = 750;
102     uint256 tokens = (weiAmount / 100) * _price;
103 
104     // update state
105     weiRaised = weiRaised.add(weiAmount);
106 
107     tokenReward.transfer(beneficiary, tokens);
108     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
109     forwardFunds();
110   }
111 
112   // send ether to the fund collection wallet
113   // override to create custom fund forwarding mechanisms
114   function forwardFunds() internal {
115     // wallet.transfer(msg.value);
116     if (!wallet.send(msg.value)) {
117       throw;
118     }
119   }
120 
121   // @return true if the transaction can buy tokens
122   function validPurchase() internal constant returns (bool) {
123     bool withinPeriod = now >= startTime && now <= endTime;
124     bool nonZeroPurchase = msg.value != 0;
125     return withinPeriod && nonZeroPurchase;
126   }
127 
128   // @return true if crowdsale event has ended
129   function hasEnded() public constant returns (bool) {
130     return now > endTime;
131   }
132 
133   function withdrawTokens(uint256 _amount) {
134     if(msg.sender!=wallet) throw;
135     tokenReward.transfer(wallet,_amount);
136   }
137 }