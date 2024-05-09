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
52 
53   token tokenReward;
54 
55   // mapping (address => uint) public contributions;
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
76     //you have to do customisation here only
77     //You will change this to your wallet where you need the ETH 
78     wallet = 0xE83698E55c4E685b0057044BD76773aE1EA19DB3;// this is where you set the Wallet which will receive all the funds
79     // durationInMinutes = _durationInMinutes; 
80     //Here will come the checksum address we got
81     addressOfTokenUsedAsReward = 0x167326e8942Fd471b5Ad79adDf6677de73a29718;
82     //see it has both lowecae and uppercase letters. we can now deploy it.
83     // this is where you tell it which token we are using.
84     //we will do ICO of GauravCoin now. 
85     //one trick here is that it will not work right now if we deployed. look at the address of coin, it doesn't have any uppercase letter, all lowecase
86     //means its not checksummed, let's copy the checksummed address
87     //for that we go to etherscan.io/address/youraddresswhichyouwantchecksummed
88 
89 
90     tokenReward = token(addressOfTokenUsedAsReward);
91   }
92 
93   bool public started = false;
94 
95   function startSale(){
96     if (msg.sender != wallet) throw;
97     started = true;
98   }
99 
100   function stopSale(){
101     if(msg.sender != wallet) throw;
102     started = false;
103   }
104 
105   function setPrice(uint256 _price){
106     if(msg.sender != wallet) throw;
107     price = _price;
108   }
109   function changeWallet(address _wallet){
110   	if(msg.sender != wallet) throw;
111   	wallet = _wallet;
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
124   // low level token purchase function
125   function buyTokens(address beneficiary) payable {
126     require(beneficiary != 0x0);
127     require(validPurchase());
128 
129     uint256 weiAmount = msg.value;
130 
131     // calculate token amount to be sent
132     //here also we needed to cange, sorry I forgot to tell in the begining.
133     //let's try to understand this calculation.
134     //the buyer send some ETH 
135     //1 ETH = 10**18 wei 
136     //now here comes our token decimals
137     //if our token has 18 decimals then we don't want this 10**something
138     //if our token has 8 decimals then we want 10**10
139     //if our token has 16 decimals we will divide by 10**2 
140     //how we calculate it? 
141     //10**(18-tokenDecimals)
142     //our token has 18 decimals so it will be 10**(18-18) = 10**0 = 1 so we don't need to divide.
143     uint256 tokens = (weiAmount) * price;//weiamount * price 
144 
145     // update state
146     weiRaised = weiRaised.add(weiAmount);
147     
148     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
149     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
150 
151     tokenReward.transfer(beneficiary, tokens);
152     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
153     forwardFunds();
154   }
155 
156   // send ether to the fund collection wallet
157   // override to create custom fund forwarding mechanisms
158   function forwardFunds() internal {
159     // wallet.transfer(msg.value);
160     if (!wallet.send(msg.value)) {
161       throw;
162     }
163   }
164 
165   // @return true if the transaction can buy tokens
166   function validPurchase() internal constant returns (bool) {
167     bool withinPeriod = started;
168     bool nonZeroPurchase = msg.value != 0;
169     return withinPeriod && nonZeroPurchase;
170   }
171 
172   function withdrawTokens(uint256 _amount) {
173     if(msg.sender!=wallet) throw;
174     tokenReward.transfer(wallet,_amount);
175   }
176 }