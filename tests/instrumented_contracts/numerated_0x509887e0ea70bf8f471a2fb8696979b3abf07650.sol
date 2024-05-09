1 pragma solidity ^0.4.11;
2 
3 
4 
5 /**
6 
7  * @title SafeMath
8 
9  * @dev Math operations with safety checks that throw on error
10 
11  */
12 
13 library SafeMath {
14 
15   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16 
17     uint256 c = a * b;
18 
19     assert(a == 0 || c / a == b);
20 
21     return c;
22 
23   }
24 
25 
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28 
29     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
30 
31     uint256 c = a / b;
32 
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36 
37   }
38 
39 
40 
41   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42 
43     assert(b <= a);
44 
45     return a - b;
46 
47   }
48 
49 
50 
51   function add(uint256 a, uint256 b) internal constant returns (uint256) {
52 
53     uint256 c = a + b;
54 
55     assert(c >= a);
56 
57     return c;
58 
59   }
60 
61 }
62 
63 
64 
65 /**
66 
67  * @title Crowdsale
68 
69  * @dev Crowdsale is a base contract for managing a token crowdsale.
70 
71  * Crowdsales have a start and end timestamps, where investors can make
72 
73  * token purchases and the crowdsale will assign them tokens based
74 
75  * on a token per ETH rate. Funds collected are forwarded 
76 
77  to a wallet
78 
79  * as they arrive.
80 
81  */
82 
83 contract token { function transfer(address receiver, uint amount){  } }
84 
85 contract Crowdsale {
86 
87   using SafeMath for uint256;
88 
89 
90 
91   // uint256 durationInMinutes;
92 
93   // address where funds are collected
94 
95   address public wallet;
96 
97   // token address
98 
99   address public addressOfTokenUsedAsReward;
100 
101 
102 
103   uint256 public price = 300;
104 
105 
106 
107   token tokenReward;
108 
109 
110 
111   // mapping (address => uint) public contributions;
112 
113   
114 
115 
116 
117 
118 
119   // start and end timestamps where investments are allowed (both inclusive)
120 
121   // uint256 public startTime;
122 
123   // uint256 public endTime;
124 
125   // amount of raised money in wei
126 
127   uint256 public weiRaised;
128 
129 
130 
131   /**
132 
133    * event for token purchase logging
134 
135    * @param purchaser who paid for the tokens
136 
137    * @param beneficiary who got the tokens
138 
139    * @param value weis paid for purchase
140 
141    * @param amount amount of tokens purchased
142 
143    */
144 
145   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
146 
147 
148 
149 
150 
151   function Crowdsale() {
152 
153     //You will change this to your wallet where you need the ETH 
154 
155     wallet = 0xCEf8A431c0f0C512A587ab3f8470586c2dD1D3EB;
156 
157     // durationInMinutes = _durationInMinutes;
158 
159     //Here will come the checksum address we got
160 
161     addressOfTokenUsedAsReward = 0xB4E3362ee28105CD6D99278424d2176c4F3d76cE;
162 
163 
164 
165 
166 
167     tokenReward = token(addressOfTokenUsedAsReward);
168 
169   }
170 
171 
172 
173   bool public started = true;
174 
175 
176 
177   function startSale(){
178 
179     if (msg.sender != wallet) throw;
180 
181     started = true;
182 
183   }
184 
185 
186 
187   function stopSale(){
188 
189     if(msg.sender != wallet) throw;
190 
191     started = false;
192 
193   }
194 
195 
196 
197   function setPrice(uint256 _price){
198 
199     if(msg.sender != wallet) throw;
200 
201     price = _price;
202 
203   }
204 
205   function changeWallet(address _wallet){
206 
207   	if(msg.sender != wallet) throw;
208 
209   	wallet = _wallet;
210 
211   }
212 
213 
214 
215   function changeTokenReward(address _token){
216 
217     if(msg.sender!=wallet) throw;
218 
219     tokenReward = token(_token);
220 
221   }
222 
223 
224 
225   // fallback function can be used to buy tokens
226 
227   function () payable {
228 
229     buyTokens(msg.sender);
230 
231   }
232 
233 
234 
235   // low level token `purchase function
236 
237   function buyTokens(address beneficiary) payable {
238 
239     require(beneficiary != 0x0);
240 
241     require(validPurchase());
242 
243 
244 
245     uint256 weiAmount = msg.value;
246 
247 
248 
249     // calculate token amount to be sent
250 
251     uint256 tokens = (weiAmount) * price;//weiamount * price 
252 
253     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
254 
255 
256 
257     // update state
258 
259     weiRaised = weiRaised.add(weiAmount);
260 
261     
262 
263     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
264 
265     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
266 
267 
268 
269     tokenReward.transfer(beneficiary, tokens);
270 
271     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
272 
273     forwardFunds();
274 
275   }
276 
277 
278 
279   // send ether to the fund collection wallet
280 
281   // override to create custom fund forwarding mechanisms
282 
283   function forwardFunds() internal {
284 
285     // wallet.transfer(msg.value);
286 
287     if (!wallet.send(msg.value)) {
288 
289       throw;
290 
291     }
292 
293   }
294 
295 
296 
297   // @return true if the transaction can buy tokens
298 
299   function validPurchase() internal constant returns (bool) {
300 
301     bool withinPeriod = started;
302 
303     bool nonZeroPurchase = msg.value != 0;
304 
305     return withinPeriod && nonZeroPurchase;
306 
307   }
308 
309 
310 
311   function withdrawTokens(uint256 _amount) {
312 
313     if(msg.sender!=wallet) throw;
314 
315     tokenReward.transfer(wallet,_amount);
316 
317   }
318 
319 }