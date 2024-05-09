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
15     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
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
51   // uint256 public price = 300;
52   uint256 public weiPerToken = 1787289880;
53 
54   token tokenReward;
55 
56   // mapping (address => uint) public contributions;
57   
58 
59 
60   // start and end timestamps where investments are allowed (both inclusive)
61   // uint256 public startTime;
62   // uint256 public endTime;
63   // amount of raised money in wei
64   uint256 public weiRaised;
65 
66   /**
67    * event for token purchase logging
68    * @param purchaser who paid for the tokens
69    * @param beneficiary who got the tokens
70    * @param value weis paid for purchase
71    * @param amount amount of tokens purchased
72    */
73   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
74 
75 
76   function Crowdsale() {
77     //You will change this to your wallet where you need the ETH 
78     wallet = 0x6a3a52fF68f684A6D8402F450d52275F41246253;
79     // durationInMinutes = _durationInMinutes;
80     //Here will come the checksum address we got
81     addressOfTokenUsedAsReward = 0x6A3777eB316ed485dd399628E8C0711eB8f5b0dB;
82 
83 
84     tokenReward = token(addressOfTokenUsedAsReward);
85   }
86 
87   bool public started = true;
88 
89   function startSale(){
90     if (msg.sender != wallet) throw;
91     started = true;
92   }
93 
94   function stopSale(){
95     if(msg.sender != wallet) throw;
96     started = false;
97   }
98 
99   // function setPrice(uint256 _price){
100   //   if(msg.sender != wallet) throw;
101   //   price = _price;
102   // }
103 
104   function setWeiPerToken(uint256 _weiPerToken){
105     if(msg.sender!=wallet) throw;
106     weiPerToken = _weiPerToken;
107   }
108 
109   function changeWallet(address _wallet){
110     if(msg.sender != wallet) throw;
111     wallet = _wallet;
112   }
113 
114   function changeTokenReward(address _token){
115     if(msg.sender!=wallet) throw;
116     tokenReward = token(_token);
117   }
118 
119   // fallback function can be used to buy tokens
120   function () payable {
121     buyTokens(msg.sender);
122   }
123 
124   // low level token `purchase function
125   function buyTokens(address beneficiary) payable {
126     require(beneficiary != 0x0);
127     require(validPurchase());
128 
129     uint256 weiAmount = msg.value;
130 
131     // calculate token amount to be sent
132     uint256 tokens = ((weiAmount * (10**18)) / weiPerToken);//weiamount * price 
133     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
134 
135     // update state
136     weiRaised = weiRaised.add(weiAmount);
137     
138     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
139     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
140 
141     tokenReward.transfer(beneficiary, tokens);
142     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
143     forwardFunds();
144   }
145 
146   // send ether to the fund collection wallet
147   // override to create custom fund forwarding mechanisms
148   function forwardFunds() internal {
149     // wallet.transfer(msg.value);
150     if (!wallet.send(msg.value)) {
151       throw;
152     }
153   }
154 
155   // @return true if the transaction can buy tokens
156   function validPurchase() internal constant returns (bool) {
157     bool withinPeriod = started;
158     bool nonZeroPurchase = msg.value != 0;
159     return withinPeriod && nonZeroPurchase;
160   }
161 
162   function withdrawTokens(uint256 _amount) {
163     if(msg.sender!=wallet) throw;
164     tokenReward.transfer(wallet,_amount);
165   }
166 }