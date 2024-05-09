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
51   uint256 public price = 350;
52 
53   token tokenReward;
54 
55   mapping (address => uint) public contributions;
56   
57 
58 
59   // start and end timestamps where investments are allowed (both inclusive)
60   // uint256 public startTime;
61   // uint256 public endTime;
62   // amount of raised money in wei
63   uint256 public weiRaised;
64 
65   /**
66    * event for token purchase logging
67    * @param purchaser who paid for the tokens
68    * @param beneficiary who got the tokens
69    * @param value weis paid for purchase
70    * @param amount amount of tokens purchased
71    */
72   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
73 
74 
75   function Crowdsale() {
76     //You will change this to your wallet where you need the ETH 
77     wallet = 0xd0af9888cFb401083ad5944c6a046C831e7d8b20;//eth address here
78     // durationInMinutes = _durationInMinutes;
79     //Here will come the checksum address we got
80     addressOfTokenUsedAsReward = 0xa7A05Cf8d6D8e4e73dB47fE4de4Cbd5b63D15cfA;
81 
82 
83     tokenReward = token(addressOfTokenUsedAsReward);
84   }
85 
86   bool public started = false;
87 
88   function startSale(){
89     if (msg.sender != wallet) throw;
90     started = true;
91   }
92 
93   function stopSale(){
94     if(msg.sender != wallet) throw;
95     started = false;
96   }
97 
98   function setPrice(uint256 _price){
99     if(msg.sender != wallet) throw;
100     price = _price;
101   }
102 
103   // fallback function can be used to buy tokens
104   function () payable {
105     buyTokens(msg.sender);
106   }
107 
108   // low level token purchase function
109   function buyTokens(address beneficiary) payable {
110     require(beneficiary != 0x0);
111     require(validPurchase());
112 
113     uint256 weiAmount = msg.value;
114 
115     // calculate token amount to be sent
116     uint256 tokens = (weiAmount) * price;//weiamount * price 
117 
118     // update state
119     weiRaised = weiRaised.add(weiAmount);
120     
121     if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
122     contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
123 
124     tokenReward.transfer(beneficiary, tokens);
125     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
126     forwardFunds();
127   }
128 
129   // send ether to the fund collection wallet
130   // override to create custom fund forwarding mechanisms
131   function forwardFunds() internal {
132     // wallet.transfer(msg.value);
133     if (!wallet.send(msg.value)) {
134       throw;
135     }
136   }
137 
138   // @return true if the transaction can buy tokens
139   function validPurchase() internal constant returns (bool) {
140     bool withinPeriod = started;
141     bool nonZeroPurchase = msg.value != 0;
142     return withinPeriod && nonZeroPurchase;
143   }
144 
145   function withdrawTokens(uint256 _amount) {
146     if(msg.sender!=wallet) throw;
147     tokenReward.transfer(wallet,_amount);
148   }
149 }