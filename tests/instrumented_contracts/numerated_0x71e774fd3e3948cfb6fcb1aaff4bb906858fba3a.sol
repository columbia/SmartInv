1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 /**
30  * @title Crowdsale
31  * @dev Crowdsale is a base contract for managing a token crowdsale.
32  * Crowdsales have a start and end timestamps, where investors can make
33  * token purchases and the crowdsale will assign them tokens based
34  * on a token per ETH rate. Funds collected are forwarded to a wallet
35  * as they arrive.
36  */
37 contract token { function transfer(address receiver, uint amount){  } }
38 contract BezopCrowdsale {
39   using SafeMath for uint256;
40 
41   // uint256 durationInMinutes;
42   // address where funds are collected
43   address public wallet;
44   // token address
45   address public addressOfTokenUsedAsReward;
46 
47   uint256 public price = 3840 ;
48 
49   token tokenReward;
50 
51   mapping (address => uint) public contributions;
52   
53 
54 
55   // start and end timestamps where investments are allowed (both inclusive)
56   // uint256 public startTime;
57   // uint256 public endTime;
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
71   function BezopCrowdsale() {
72     //You will change this to your wallet where you need the ETH 
73     wallet = 0x634f8C7C2DDD8671632624850C7C8F3e20622F5F;
74     // durationInMinutes = _durationInMinutes;
75     //Here will come the checksum address we got
76     addressOfTokenUsedAsReward = 0x3839d8ba312751aa0248fed6a8bacb84308e20ed;
77 
78 
79     tokenReward = token(addressOfTokenUsedAsReward);
80   }
81 
82   bool public started = false;
83 
84   function startSale(){
85     if (msg.sender != wallet) throw;
86     started = true;
87   }
88 
89   function stopSale(){
90     if(msg.sender != wallet) throw;
91     started = false;
92   }
93 
94   function setPrice(uint256 _price){
95     if(msg.sender != wallet) throw;
96     price = _price;
97   }
98   function changeWallet(address _wallet){
99     if(msg.sender != wallet) throw;
100     wallet = _wallet;
101   }
102 
103   function changeTokenReward(address _token){
104     if(msg.sender!=wallet) throw;
105     tokenReward = token(_token);
106   }
107 
108   // fallback function can be used to buy tokens
109   function () payable {
110     buyTokens(msg.sender);
111   }
112 
113   // low level token purchase function
114   function buyTokens(address beneficiary) payable {
115     require(beneficiary != 0x0);
116     require(validPurchase());
117 
118     uint256 weiAmount = msg.value;
119 
120     // calculate token amount to be sent
121     uint256 tokens = (weiAmount) * price;//weiamount * price 
122     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
123 
124     // update state
125     weiRaised = weiRaised.add(weiAmount);
126 
127     if(weiAmount<10**17&&contributions[msg.sender]<10**17) throw;
128     
129     if(contributions[msg.sender].add(weiAmount)>550*10**18) throw;
130     contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
131 
132     tokenReward.transfer(beneficiary, tokens);
133     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
134     forwardFunds();
135   }
136 
137   // send ether to the fund collection wallet
138   // override to create custom fund forwarding mechanisms
139   function forwardFunds() internal {
140     // wallet.transfer(msg.value);
141     if (!wallet.send(msg.value)) {
142       throw;
143     }
144   }
145 
146   // @return true if the transaction can buy tokens
147   function validPurchase() internal constant returns (bool) {
148     bool withinPeriod = started;
149     bool nonZeroPurchase = msg.value != 0;
150     return withinPeriod && nonZeroPurchase;
151   }
152 
153   function withdrawTokens(uint256 _amount) {
154     if(msg.sender!=wallet) throw;
155     tokenReward.transfer(wallet,_amount);
156   }
157 }