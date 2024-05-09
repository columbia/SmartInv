1 pragma solidity ^0.4.24;
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
36 contract AfdltIEO {
37   using SafeMath for uint256;
38 
39   
40   // address where funds are collected
41   address public wallet;
42   // token address
43   address public AFDLT;
44 
45   uint256 public price = 110000000;
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
65   constructor() public{
66     //You will change this to your wallet where you need the ETH 
67     wallet = 0xcfbD73A1404A2CBf956e9E506ff5006601BCd2A4;
68 
69     //Here will come the checksum address we got
70     AFDLT = 0xd8a8843b0a5aba6b030e92b3f4d669fad8a5be50;
71 
72 
73     tokenReward = token(AFDLT);
74   }
75 
76   bool public started = true;
77 
78   function startSale() public{
79     if (msg.sender != wallet) revert();
80     started = true;
81   }
82 
83   function stopSale() public{
84     if(msg.sender != wallet) revert();
85     started = false;
86   }
87 
88   function setPrice(uint256 _price) public{
89     if(msg.sender != wallet) revert();
90     price = _price;
91   }
92   function changeWallet(address _wallet) public{
93   	if(msg.sender != wallet) revert();
94   	wallet = _wallet;
95   }
96 
97   function changeTokenReward(address _token) public{
98     if(msg.sender!=wallet) revert();
99     tokenReward = token(_token);
100     AFDLT = _token;
101   }
102 
103   // fallback function can be used to buy tokens
104   function () payable public{
105     buyTokens(msg.sender);
106   }
107 
108   // low level token purchase function
109   function buyTokens(address beneficiary) payable public{
110     require(beneficiary != 0x0);
111     require(validPurchase());
112 
113     uint256 weiAmount = msg.value;
114 
115 
116     // calculate token amount to be sent
117     uint256 tokens = ((weiAmount) * price).div(10**14);
118      if (tokens >= 2000000000000*10**4) {
119         tokens = tokens.add(tokens.mul(20)/100);
120         
121       }else if (tokens >= 1500000000000*10**4) {
122         tokens = tokens.add(tokens.mul(15)/100);
123         
124       }else if (tokens >= 1000000000000*10**4) {
125         tokens = tokens.add(tokens.mul(12)/100);
126         
127       }else if (tokens >= 500000000000*10**4) {
128         tokens = tokens.add(tokens.mul(10)/100);
129         
130       }else if (tokens >= 100000000000*10**4) {
131         tokens = tokens.add(tokens.mul(8)/100);
132       }else if (tokens >= 10000000000*10**4) {
133         tokens = tokens.add(tokens.mul(5)/100);
134       }else if (tokens >= 1000000000*10**4) {
135         tokens = tokens.add(tokens.mul(3)/100);
136       }if (tokens >= 500000000*10**4) {
137         tokens = tokens.add(tokens.mul(2)/100);
138       }
139       else {
140         tokens = tokens;
141       }
142     
143     
144    
145     weiRaised = weiRaised.add(weiAmount);
146     
147    
148     tokenReward.transfer(beneficiary, tokens);
149     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
150     forwardFunds();
151   }
152 
153   // send ether to the fund collection wallet
154   // override to create custom fund forwarding mechanisms
155   function forwardFunds() internal {
156     // wallet.transfer(msg.value);
157     if (!wallet.send(msg.value)) {
158       revert();
159     }
160   }
161 
162   // @return true if the transaction can buy tokens
163   function validPurchase() internal constant returns (bool) {
164     bool withinPeriod = started;
165     bool nonZeroPurchase = msg.value != 0;
166     return withinPeriod && nonZeroPurchase;
167   }
168 
169   function withdrawTokens(uint256 _amount) public{
170     if(msg.sender!=wallet) revert();
171     tokenReward.transfer(wallet,_amount);
172   }
173 }