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
75  * on a token per ETH rate. Funds collected are forwarded to a wallet
76 
77  * as they arrive.
78 
79  */
80 
81 contract token { function transfer(address receiver, uint amount){  } }
82 
83 contract Crowdsale {
84 
85   using SafeMath for uint256;
86 
87 
88 
89   // uint256 durationInMinutes;
90 
91   // address where funds are collected
92 
93   address public wallet;
94 
95   // token address
96 
97   address public addressOfTokenUsedAsReward;
98 
99 
100 
101   uint256 public price = 300;
102 
103 
104 
105   token tokenReward;
106 
107 
108 
109   // mapping (address => uint) public contributions;
110 
111   
112 
113 
114 
115 
116 
117   // start and end timestamps where investments are allowed (both inclusive)
118 
119   // uint256 public startTime;
120 
121   // uint256 public endTime;
122 
123   // amount of raised money in wei
124 
125   uint256 public weiRaised;
126 
127 
128 
129   /**
130 
131    * event for token purchase logging
132 
133    * @param purchaser who paid for the tokens
134 
135    * @param beneficiary who got the tokens
136 
137    * @param value weis paid for purchase
138 
139    * @param amount amount of tokens purchased
140 
141    */
142 
143   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
144 
145 
146 
147 
148 
149   function Crowdsale() {
150 
151     //You will change this to your wallet where you need the ETH 
152 
153     wallet = 0xf8cd20391D5EFb06906B0bd3099E3789F0305615;
154 
155     // durationInMinutes = _durationInMinutes;
156 
157     //Here will come the checksum address we got
158 
159     addressOfTokenUsedAsReward = 0x75Aa7B0d02532f3833b66c7f0Ad35376d373ddF8;
160 
161 
162 
163 
164 
165     tokenReward = token(addressOfTokenUsedAsReward);
166 
167   }
168 
169 
170 
171   bool public started = false;
172 
173 
174 
175   function startSale(){
176 
177     if (msg.sender != wallet) throw;
178 
179     started = true;
180 
181   }
182 
183 
184 
185   function stopSale(){
186 
187     if(msg.sender != wallet) throw;
188 
189     started = false;
190 
191   }
192 
193 
194 
195   function setPrice(uint256 _price){
196 
197     if(msg.sender != wallet) throw;
198 
199     price = _price;
200 
201   }
202 
203   function changeWallet(address _wallet){
204 
205   	if(msg.sender != wallet) throw;
206 
207   	wallet = _wallet;
208 
209   }
210 
211 
212 
213   function changeTokenReward(address _token){
214 
215     if(msg.sender!=wallet) throw;
216 
217     tokenReward = token(_token);
218 
219   }
220 
221 
222 
223   // fallback function can be used to buy tokens
224 
225   function () payable {
226 
227     buyTokens(msg.sender);
228 
229   }
230 
231 
232 
233   // low level token purchase function
234 
235   function buyTokens(address beneficiary) payable {
236 
237     require(beneficiary != 0x0);
238 
239     require(validPurchase());
240 
241 
242 
243     uint256 weiAmount = msg.value;
244 
245 
246 
247     // calculate token amount to be sent
248 
249     uint256 tokens = (weiAmount) * price;//weiamount * price 
250 
251     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
252 
253 
254 
255     // update state
256 
257     weiRaised = weiRaised.add(weiAmount);
258 
259     
260 
261     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
262 
263     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
264 
265 
266 
267     tokenReward.transfer(beneficiary, tokens);
268 
269     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
270 
271     forwardFunds();
272 
273   }
274 
275 
276 
277   // send ether to the fund collection wallet
278 
279   // override to create custom fund forwarding mechanisms
280 
281   function forwardFunds() internal {
282 
283     // wallet.transfer(msg.value);
284 
285     if (!wallet.send(msg.value)) {
286 
287       throw;
288 
289     }
290 
291   }
292 
293 
294 
295   // @return true if the transaction can buy tokens
296 
297   function validPurchase() internal constant returns (bool) {
298 
299     bool withinPeriod = started;
300 
301     bool nonZeroPurchase = msg.value != 0;
302 
303     return withinPeriod && nonZeroPurchase;
304 
305   }
306 
307 
308 
309   function withdrawTokens(uint256 _amount) {
310 
311     if(msg.sender!=wallet) throw;
312 
313     tokenReward.transfer(wallet,_amount);
314 
315   }
316 
317 }