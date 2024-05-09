1 pragma solidity ^0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
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
42 interface token { 
43   function transfer(address receiver, uint amount) external returns (bool) ; 
44   function balanceOf(address holder) external view returns (uint) ;
45 }
46 contract Crowdsale {
47   using SafeMath for uint256;
48 
49 
50   // address where funds are collected
51   address payable public wallet;
52   // token address
53   address public addressOfTokenUsedAsReward;
54 
55   uint256 public price = 75000;
56   uint256 public tokensSold;
57 
58   token tokenReward;
59 
60   // amount of raised money in wei
61   uint256 public weiRaised;
62 
63   mapping (address => uint) public balances;
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
75   constructor () public {
76     //You will change this to your wallet where you need the ETH 
77     wallet = 0x41d5e81BFBCb4eB82F9d7Fda41b9FE2759C69564;
78     
79     //Here will come the checksum address we got
80     addressOfTokenUsedAsReward = 0x0B44547be0A0Df5dCd5327de8EA73680517c5a54;
81 
82     tokenReward = token(addressOfTokenUsedAsReward);
83   }
84 
85   bool public started = true;
86 
87   function startSale() public {
88     require (msg.sender == wallet);
89     started = true;
90   }
91 
92   function stopSale() public {
93     require(msg.sender == wallet);
94     started = false;
95   }
96 
97   function setPrice(uint256 _price) public {
98     require(msg.sender == wallet);
99     price = _price;
100   }
101   function changeWallet(address payable _wallet) public {
102     require (msg.sender == wallet);
103     wallet = _wallet;
104   }
105 
106 
107   // fallback function can be used to buy tokens
108   function () payable external {
109     buyTokens(msg.sender);
110   }
111 
112   // low level token purchase function
113   function buyTokens(address beneficiary) payable public {
114     require(beneficiary != address(0));
115     require(validPurchase());
116 
117     uint256 weiAmount = msg.value;
118 
119 
120     // calculate token amount to be sent
121     uint256 tokens = (weiAmount) * price;//weiamount * price 
122     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
123 
124     // update state
125     weiRaised = weiRaised.add(weiAmount);
126 
127     // tokenReward.transfer(beneficiary, tokens);
128     tokensSold = tokensSold.add(tokens);
129 
130     // ensure the smart contract has enough tokens to sell
131     require(tokenReward.balanceOf(address(this)).sub(tokensSold) >= tokens);
132 
133     // allocate tokens to benefeciary
134     balances[beneficiary] = balances[beneficiary].add(tokens);
135 
136     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
137     forwardFunds();
138   }
139 
140   function claimTokens() public {
141     // ensure benefeciary has enough tokens
142     require(started == false && balances[msg.sender] > 0);
143 
144     tokenReward.transfer(msg.sender, balances[msg.sender]);
145 
146     // now benefeciary doesn't have any tokens
147     balances[msg.sender] = 0;
148   }
149 
150   function myBalance() public view returns (uint) {
151     return balances[msg.sender];
152   }
153 
154   // send ether to the fund collection wallet
155   // override to create custom fund forwarding mechanisms
156   function forwardFunds() internal {
157      wallet.transfer(msg.value);
158   }
159 
160   // @return true if the transaction can buy tokens
161   function validPurchase() internal view returns (bool) {
162     bool withinPeriod = started;
163     bool nonZeroPurchase = msg.value != 0;
164     return withinPeriod && nonZeroPurchase;
165   }
166 
167   function withdrawTokens(uint256 _amount) public {
168     
169     require (msg.sender == wallet && 
170       tokenReward.balanceOf(address(this)).sub(tokensSold) >= _amount);
171 
172     tokenReward.transfer(wallet,_amount);
173   }
174 }