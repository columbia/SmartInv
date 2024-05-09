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
51   uint256 public price = 300;
52   uint256 public minBuy;
53   uint256 public maxBuy;
54 
55   token tokenReward;
56 
57   // mapping (address => uint) public contributions;
58   
59 
60 
61   // start and end timestamps where investments are allowed (both inclusive)
62   uint256 public startTime;
63   // uint256 public endTime;
64   // amount of raised money in wei
65   uint256 public weiRaised;
66 
67   /**
68    * event for token purchase logging
69    * @param purchaser who paid for the tokens
70    * @param beneficiary who got the tokens
71    * @param value weis paid for purchase
72    * @param amount amount of tokens purchased
73    */
74   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
75 
76 
77   function Crowdsale() {
78     //You will change this to your wallet where you need the ETH 
79     wallet = 0x4a81247CE8E94d6f1F0d6065BC62d3eB76904aFD; 
80     // durationInMinutes = _durationInMinutes;
81     //Here will come the checksum address we got
82     addressOfTokenUsedAsReward = 0x452B8B085CED1968b6faDE6C2Dcf608c5c297F31;
83 
84 
85     tokenReward = token(addressOfTokenUsedAsReward);
86   }
87 
88   bool public started = false;
89 
90   function startSale(uint256 _delayInMinutes){
91     if (msg.sender != wallet) throw;
92     startTime = now + _delayInMinutes*1 minutes;
93     started = true;
94   }
95 
96   function stopSale(){
97     if(msg.sender != wallet) throw;
98     started = false;
99   }
100 
101   function setPrice(uint256 _price){
102     if(msg.sender != wallet) throw;
103     price = _price;
104   }
105 
106   function changeWallet(address _wallet){
107   	if(msg.sender != wallet) throw;
108   	wallet = _wallet;
109   }
110 
111   function changeTokenReward(address _token){
112     if(msg.sender!=wallet) throw;
113     tokenReward = token(_token);
114   }
115 
116   // fallback function can be used to buy tokens
117   function () payable {
118     buyTokens(msg.sender);
119   }
120 
121   // low level token purchase function
122   function buyTokens(address beneficiary) payable {
123     require(beneficiary != 0x0);
124     require(validPurchase());
125 
126     uint256 weiAmount = msg.value;
127 
128     // calculate token amount to be sent
129     uint256 tokens = (weiAmount/10**10) * price;//weiamount * price 
130 
131 
132 
133     // update state
134     weiRaised = weiRaised.add(weiAmount);
135     
136     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
137     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
138 
139     tokenReward.transfer(beneficiary, tokens);
140     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
141     forwardFunds();
142   }
143 
144   // send ether to the fund collection wallet
145   // override to create custom fund forwarding mechanisms
146   function forwardFunds() internal {
147     // wallet.transfer(msg.value);
148     if (!wallet.send(msg.value)) {
149       throw;
150     }
151   }
152 
153   // @return true if the transaction can buy tokens
154   function validPurchase() internal constant returns (bool) {
155     bool withinPeriod = started&&(now>=startTime);
156     bool nonZeroPurchase = msg.value != 0;
157     return withinPeriod && nonZeroPurchase;
158   }
159 
160   function withdrawTokens(uint256 _amount) {
161     if(msg.sender!=wallet) throw;
162     tokenReward.transfer(wallet,_amount);
163   }
164 }