1 pragma solidity ^0.4.18;
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
34  */
35 contract token { function transfer(address receiver, uint amount){  } }
36 contract PLAASCrowdsale {
37   using SafeMath for uint256;
38 
39   
40   // address where funds are collected
41   address public wallet;
42   // token address
43   address public addressOfTokenUsedAsReward;
44 
45   uint256 public price = 1000;
46 
47   token tokenReward;
48 
49   // mapping (address => uint) public contributions;
50   
51 
52   // amount of raised money in wei
53   uint256 public weiRaised;
54 
55   /**
56    * event for token purchase logging
57    * @param purchaser who paid for the tokens
58    * @param beneficiary who got the tokens
59    * @param value weis paid for purchase
60    * @param amount amount of tokens purchased
61    */
62   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
63 
64 
65   function PLAASCrowdsale() {
66     //You will change this to your wallet where you need the ETH 
67     wallet = 0xA8dd9A671d64DB4380AcA5af8976aE6F863fF169;
68 
69     //Here will come the checksum address we got
70     addressOfTokenUsedAsReward = 0x8d9626315e8025b81c3bdb926db4c51dde237f52;
71 
72 
73     tokenReward = token(addressOfTokenUsedAsReward);
74   }
75 
76   bool public started = true;
77 
78   function startSale(){
79     if (msg.sender != wallet) throw;
80     started = true;
81   }
82 
83   function stopSale(){
84     if(msg.sender != wallet) throw;
85     started = false;
86   }
87 
88   function setPrice(uint256 _price){
89     if(msg.sender != wallet) throw;
90     price = _price;
91   }
92   function changeWallet(address _wallet){
93   	if(msg.sender != wallet) throw;
94   	wallet = _wallet;
95   }
96 
97   function changeTokenReward(address _token){
98     if(msg.sender!=wallet) throw;
99     tokenReward = token(_token);
100     addressOfTokenUsedAsReward = _token;
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
115 
116     // calculate token amount to be sent
117     uint256 tokens = ((weiAmount) * price);
118    
119     weiRaised = weiRaised.add(weiAmount);
120     
121    
122     tokenReward.transfer(beneficiary, tokens);
123     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
124     forwardFunds();
125   }
126 
127   // send ether to the fund collection wallet
128   // override to create custom fund forwarding mechanisms
129   function forwardFunds() internal {
130     // wallet.transfer(msg.value);
131     if (!wallet.send(msg.value)) {
132       throw;
133     }
134   }
135 
136   // @return true if the transaction can buy tokens
137   function validPurchase() internal constant returns (bool) {
138     bool withinPeriod = started;
139     bool nonZeroPurchase = msg.value != 0;
140     return withinPeriod && nonZeroPurchase;
141   }
142 
143   function withdrawTokens(uint256 _amount) {
144     if(msg.sender!=wallet) throw;
145     tokenReward.transfer(wallet,_amount);
146   }
147 }