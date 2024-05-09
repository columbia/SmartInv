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
34  * @title Crowdsale
35  * @dev Crowdsale is a base contract for managing a token crowdsale.
36  * Crowdsales have a start and end timestamps, where investors can make
37  * token purchases and the crowdsale will assign them tokens based
38  * on a token per ETH rate. Funds collected are forwarded 
39  to a wallet
40  * as they arrive.
41  */
42 contract token { function transfer(address receiver, uint amount) public{  }
43     function balanceOf(address _owner) public returns (uint256 balance){ }
44 }
45 contract IMCrowdsale {
46   using SafeMath for uint256;
47 
48   // uint256 durationInMinutes;
49   // address where funds are collected
50   address public wallet;
51   // token address
52   address public addressOfTokenUsedAsReward;
53 
54   uint256 public price = 500;
55 
56   token tokenReward;
57 
58 
59   // amount of raised money in wei
60   uint256 public weiRaised;
61 
62   /**
63    * event for token purchase logging
64    * @param purchaser who paid for the tokens
65    * @param beneficiary who got the tokens
66    * @param value weis paid for purchase
67    * @param amount amount of tokens purchased
68    */
69   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
70 
71 
72   constructor() public {
73     //You will change this to your wallet where you need the ETH 
74     wallet = 0xAe2544ec9F7716998d102fcdCa9CC401B3277203;
75     // durationInMinutes = _durationInMinutes;
76     //Here will come the checksum address we got
77     addressOfTokenUsedAsReward = 0x16c86d6e140e0cD7F9a993C3f1632A4c3A0af008;
78 
79 
80     tokenReward = token(addressOfTokenUsedAsReward);
81   }
82 
83   bool public started = true;
84 
85   function startSale() external{
86     if (msg.sender != wallet) revert();
87     started = true;
88   }
89 
90   function stopSale() external{
91     if(msg.sender != wallet) revert();
92     started = false;
93   }
94 
95   function setPrice(uint256 _price) external{
96     if(msg.sender != wallet) revert();
97     price = _price;
98   }
99   function changeWallet(address _wallet) external{
100   	if(msg.sender != wallet) revert();
101   	wallet = _wallet;
102   }
103 
104   function changeTokenReward(address _token) external{
105     if(msg.sender!=wallet) revert();
106     tokenReward = token(_token);
107     addressOfTokenUsedAsReward = _token;
108   }
109 
110   // fallback function can be used to buy tokens
111   function () payable public {
112     buyTokens(msg.sender);
113   }
114 
115   // low level token purchase function
116     function buyTokens(address beneficiary) payable public {
117     require(beneficiary != 0x0);
118     require(validPurchase());
119 
120     uint256 weiAmount = msg.value;
121 
122 
123     // calculate token amount to be sent
124     uint256 tokens = ((weiAmount) * price);
125    
126     weiRaised = weiRaised.add(weiAmount);
127     if (now <= 1542326400) {
128         tokens = tokens.mul(4);
129       }else if (now <= 1544918400) {
130         tokens = tokens.mul(2);
131         }
132       else {
133         tokens = tokens;
134       }
135     
136     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
137     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
138 
139     tokenReward.transfer(beneficiary, tokens);
140     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
141     forwardFunds();
142   }
143 
144   // send ether to the fund collection wallet
145   // override to create custom fund forwarding mechanisms
146   function forwardFunds() internal {
147     // wallet.transfer(msg.value);
148     if (!wallet.send(msg.value)) {
149       revert();
150     }
151   }
152 
153 
154 
155   // @return true if the transaction can buy tokens
156   function validPurchase() internal constant returns (bool) {
157     bool withinPeriod = started;
158     bool nonZeroPurchase = msg.value != 0;
159     return withinPeriod && nonZeroPurchase;
160   }
161 
162   function withdrawTokens(uint256 _amount) external {
163     if(msg.sender!=wallet) revert();
164     tokenReward.transfer(wallet,_amount);
165   }
166   function destroy()  external {
167     if(msg.sender != wallet) revert();
168     // Transfer tokens back to owner
169     uint256 balance = tokenReward.balanceOf(address(this));
170     assert(balance > 0);
171     tokenReward.transfer(wallet, balance);
172 
173     // There should be no ether in the contract but just in case
174      selfdestruct(wallet);
175   }
176 
177 }