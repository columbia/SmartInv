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
51   uint256 public price = 200;//initial price
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
64   uint256 public tokensSold;
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
77     //DO NOT FORGET TO CHANGE THIS
78     //This is the wallet where all the ETH will go!
79     wallet = 0x8c7E29FE448ea7E09584A652210fE520f992cE64;//this should be Filips wallet!
80     // durationInMinutes = _durationInMinutes;
81     //Here will come the checksum address we got
82     addressOfTokenUsedAsReward = 0xA7352F9d1872D931b3F9ff3058025c4aE07EF888; //address of the token contract
83     //web3.toChecksumAddress is needed here in most cases.
84 
85 
86 
87     tokenReward = token(addressOfTokenUsedAsReward);
88   }
89 
90   bool public started = false;
91 
92   function startSale(){
93     if (msg.sender != wallet) throw;
94     started = true;
95   }
96 
97   function stopSale(){
98     if(msg.sender != wallet) throw;
99     started = false;
100   }
101 
102   function setPrice(uint256 _price){
103     if(msg.sender != wallet) throw;
104     price = _price;
105   }
106 
107   // fallback function can be used to buy tokens
108   function () payable {
109     buyTokens(msg.sender);
110   }
111 
112   // low level token purchase function
113   function buyTokens(address beneficiary) payable {
114     require(beneficiary != 0x0);
115     require(validPurchase());
116 
117     uint256 weiAmount = msg.value;
118 
119     if(tokensSold < 10000*10**6){
120       price = 300;      
121     }else if(tokensSold < 20000*10**6){
122       price = 284;
123     }else if(tokensSold < 30000*10**6){
124       price = 269;
125     }else if(tokensSold < 40000*10**6){
126       price = 256;
127     }else if(tokensSold < 50000*10**6){
128       price = 244;
129     }else if(tokensSold < 60000*10**6){
130       price = 233;
131     }else if(tokensSold < 70000*10**6){
132       price = 223;
133     }else if(tokensSold < 80000*10**6){
134       price = 214;
135     }else if(tokensSold < 90000*10**6){
136       price = 205;
137     }else if(tokensSold < 100000*10**6){
138       price = 197;
139     }else if(tokensSold < 110000*10**6){
140       price = 189;
141     }else if(tokensSold < 120000*10**6){
142       price = 182;
143     }else if(tokensSold < 130000*10**6){
144       price = 175;
145     }else if(tokensSold < 140000*10**6){
146       price = 168;
147     }else if(tokensSold < 150000*10**6){
148       price = 162;
149     }else if(tokensSold < 160000*10**6){
150       price = 156;
151     }else if(tokensSold < 170000*10**6){
152       price = 150;
153     }else if(tokensSold < 180000*10**6){
154       price = 145;
155     }else if(tokensSold < 190000*10**6){
156       price = 140;
157     }else if(tokensSold < 200000*10**6){
158       price = 135;
159     }else if(tokensSold < 210000*10**6){
160       price = 131;
161     }else if(tokensSold < 220000*10**6){
162       price = 127;
163     }else if(tokensSold < 230000*10**6){
164       price = 123;
165     }else if(tokensSold < 240000*10**6){
166       price = 120;
167     }else if(tokensSold < 250000*10**6){
168       price = 117;
169     }else if(tokensSold < 260000*10**6){
170       price = 114;
171     }else if(tokensSold < 270000*10**6){
172       price = 111;
173     }else if(tokensSold < 280000*10**6){
174       price = 108;
175     }else if(tokensSold < 290000*10**6){
176       price = 105;
177     }else if(tokensSold < 300000*10**6){
178       price = 102;
179     }else if(tokensSold < 310000*10**6){
180       price = 100;
181     }else if(tokensSold < 320000*10**6){
182       price = 98;
183     }else if(tokensSold < 330000*10**6){
184       price = 96;
185     }else if(tokensSold < 340000*10**6){
186       price = 94;
187     }else if(tokensSold < 350000*10**6){
188       price = 92;
189     }else if(tokensSold < 360000*10**6){
190       price = 90;
191     }else if(tokensSold < 370000*10**6){
192       price = 88;
193     }else if(tokensSold < 380000*10**6){
194       price = 86;
195     }else if(tokensSold < 390000*10**6){
196       price = 84;
197     }else if(tokensSold < 400000*10**6){
198       price = 82;
199     }else if(tokensSold < 410000*10**6){
200       price = 80;
201     }else if(tokensSold < 420000*10**6){
202       price = 78;
203     }else if(tokensSold < 430000*10**6){
204       price = 76;
205     }else if(tokensSold < 440000*10**6){
206       price = 74;
207     }else if(tokensSold < 450000*10**6){
208       price = 72;
209     }else if(tokensSold < 460000*10**6){
210       price = 70;
211     }else if(tokensSold < 470000*10**6){
212       price = 68;
213     }else if(tokensSold < 480000*10**6){
214       price = 66;
215     }else if(tokensSold < 490000*10**6){
216       price = 64;
217     }else if(tokensSold < 500000*10**6){
218       price = 62;
219     }else if(tokensSold < 510000*10**6){
220       price = 60;
221     }else if(tokensSold < 520000*10**6){
222       price = 58;
223     }else if(tokensSold < 530000*10**6){
224       price = 57;
225     }else if(tokensSold < 540000*10**6){
226       price = 56;
227     }else if(tokensSold < 550000*10**6){
228       price = 55;
229     }else if(tokensSold < 560000*10**6){
230       price = 54;
231     }else if(tokensSold < 570000*10**6){
232       price = 53;
233     }else if(tokensSold < 580000*10**6){
234       price = 52;
235     }else if(tokensSold < 590000*10**6){
236       price = 51;
237     }else if(tokensSold < 600000*10**6){
238       price = 50;
239     }else if(tokensSold < 610000*10**6){
240       price = 49;
241     }else if(tokensSold < 620000*10**6){
242       price = 48;
243     }else if(tokensSold < 630000*10**6){
244       price = 47;
245     }else if(tokensSold < 640000*10**6){
246       price = 46;
247     }else if(tokensSold < 650000*10**6){
248       price = 45;
249     }else if(tokensSold < 660000*10**6){
250       price = 44;
251     }else if(tokensSold < 670000*10**6){
252       price = 43;
253     }else if(tokensSold < 680000*10**6){
254       price = 42;
255     }else if(tokensSold < 690000*10**6){
256       price = 41;
257     }else if(tokensSold < 700000*10**6){
258       price = 40;
259     }
260     //the price above is Token per ETH
261     // calculate token amount to be sent
262     uint256 tokens = (weiAmount/10**12) * price;//weiamount * price 
263     
264     
265 
266     require(tokens >= 1 * 10 ** 6); //1 token minimum
267 
268 
269     // update state
270     weiRaised = weiRaised.add(weiAmount);
271     
272 
273     tokenReward.transfer(beneficiary, tokens);
274     tokensSold = tokensSold.add(tokens);//now we can track the number of tokens sold.
275     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
276     forwardFunds();
277   }
278 
279   // send ether to the fund collection wallet
280   // override to create custom fund forwarding mechanisms
281   function forwardFunds() internal {
282     // wallet.transfer(msg.value);
283     if (!wallet.send(msg.value)) {
284       throw;
285     }
286   }
287 
288   // @return true if the transaction can buy tokens
289   function validPurchase() internal constant returns (bool) {
290     bool withinPeriod = started;
291     bool nonZeroPurchase = msg.value != 0;
292     return withinPeriod && nonZeroPurchase;
293   }
294 
295   function withdrawTokens(uint256 _amount) {
296     if(msg.sender!=wallet) throw;
297     tokenReward.transfer(wallet,_amount);
298   }
299 }