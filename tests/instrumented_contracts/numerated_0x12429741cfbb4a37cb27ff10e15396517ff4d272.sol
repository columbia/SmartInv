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
52   uint256 public price = 12500;
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
78     wallet = 0x49F48581d2008e4A0054b9bC941D7ECbBC21DacC;
79     // durationInMinutes = _durationInMinutes;
80     //Here will come the checksum address we got
81     addressOfTokenUsedAsReward = 0x854d896d6f2C5b642074a57fC9c8EfC032a7Ff79;
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
99 
100   function changeWallet(address _wallet){
101     if(msg.sender != wallet) throw;
102     wallet = _wallet;
103   }
104 
105 
106   // fallback function can be used to buy tokens
107   function () payable {
108     buyTokens(msg.sender);
109   }
110 
111   // low level token purchase function
112   function buyTokens(address beneficiary) payable {
113     require(beneficiary != 0x0);
114     require(validPurchase());
115 
116     uint256 weiAmount = msg.value;
117 
118     // if(weiAmount < 10**16) throw;
119     // if(weiAmount > 50*10**18) throw;
120 
121     // calculate token amount to be sent
122     uint256 tokens = (weiAmount) * price;//weiamount * price 
123     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
124 
125     // update state
126     weiRaised = weiRaised.add(weiAmount);
127     
128     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
129     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
130 
131     tokenReward.transfer(beneficiary, tokens);
132     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
133     forwardFunds();
134   }
135 
136   // send ether to the fund collection wallet
137   // override to create custom fund forwarding mechanisms
138   function forwardFunds() internal {
139     // wallet.transfer(msg.value);
140     if (!wallet.send(msg.value)) {
141       throw;
142     }
143   }
144 
145   // @return true if the transaction can buy tokens
146   function validPurchase() internal constant returns (bool) {
147     bool withinPeriod = started;
148     bool nonZeroPurchase = msg.value != 0;
149     return withinPeriod && nonZeroPurchase;
150   }
151 
152   function withdrawTokens(uint256 _amount) {
153     if(msg.sender!=wallet) throw;
154     tokenReward.transfer(wallet,_amount);
155   }
156 }