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
38  * on a token per ETH rate. Funds collected are forwarded 
39  to a wallet
40  * as they arrive.
41  */
42 contract token { function transfer(address receiver, uint amount){  } }
43 contract Crowdsale {
44   using SafeMath for uint256;
45 
46   // uint256 durationInMinutes;
47   // address where funds are collected
48   address public wallet;
49   // token address
50   address public addressOfTokenUsedAsReward;
51 
52   uint256 public price = 1818;
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
78     wallet = 0x5d467Dfc5e3FcA3ea4bd6C312275ca930d2f3E19;
79     // durationInMinutes = _durationInMinutes;
80     //Here will come the checksum address we got
81     addressOfTokenUsedAsReward = 0xB6eC8C3a347f66a3d7C4F39D6DD68A422E69E81d  ;
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
99   function setPrice(uint256 _price){
100     if(msg.sender != wallet) throw;
101     price = _price;
102   }
103   function changeWallet(address _wallet){
104   	if(msg.sender != wallet) throw;
105   	wallet = _wallet;
106   }
107 
108   function changeTokenReward(address _token){
109     if(msg.sender!=wallet) throw;
110     tokenReward = token(_token);
111     addressOfTokenUsedAsReward = _token;
112   }
113 
114   // fallback function can be used to buy tokens
115   function () payable {
116     buyTokens(msg.sender,"");
117   }
118 
119   // low level token purchase function
120   function buyTokens(address beneficiary, bytes32 promoCode) payable {
121     require(beneficiary != 0x0);
122     require(validPurchase());
123 
124     uint256 weiAmount = msg.value;
125 
126     // if(weiAmount < 10**16) throw;
127     // if(weiAmount > 50*10**18) throw;
128 
129     // calculate token amount to be sent
130     uint256 tokens = (weiAmount) * price;//weiamount * price 
131     
132     if (promoCode == "ILOVEBUFFER")
133         tokens = weiAmount * 2015;
134     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
135 
136     // update state
137     weiRaised = weiRaised.add(weiAmount);
138     
139     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
140     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
141 
142     tokenReward.transfer(beneficiary, tokens);
143     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
144     forwardFunds();
145   }
146 
147   // send ether to the fund collection wallet
148   // override to create custom fund forwarding mechanisms
149   function forwardFunds() internal {
150     // wallet.transfer(msg.value);
151     if (!wallet.send(msg.value)) {
152       throw;
153     }
154   }
155 
156   // @return true if the transaction can buy tokens
157   function validPurchase() internal constant returns (bool) {
158     bool withinPeriod = started;
159     bool nonZeroPurchase = msg.value != 0;
160     return withinPeriod && nonZeroPurchase;
161   }
162 
163   function withdrawTokens(uint256 _amount) {
164     if(msg.sender!=wallet) throw;
165     tokenReward.transfer(wallet,_amount);
166   }
167 }