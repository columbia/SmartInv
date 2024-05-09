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
101   uint256 public price = 14000;
102 
103   token tokenReward;
104 
105   // start and end timestamps where investments are allowed (both inclusive)
106 
107   // uint256 public startTime;
108 
109   // uint256 public endTime;
110 
111   // amount of raised money in wei
112 
113   uint256 public weiRaised;
114 
115 
116 
117   /**
118 
119    * event for token purchase logging
120 
121    * @param purchaser who paid for the tokens
122 
123    * @param beneficiary who got the tokens
124 
125    * @param value weis paid for purchase
126 
127    * @param amount amount of tokens purchased
128 
129    */
130 
131   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
132 
133 
134 
135 
136 
137   function Crowdsale() {
138 
139     //You will change this to your wallet where you need the ETH 
140 
141     wallet = 0xA438F169eb2889E4F7c5A684b5bfF8FE04036846;
142 
143     // durationInMinutes = _durationInMinutes;
144 
145     //Here will come the checksum address we got
146 
147     addressOfTokenUsedAsReward = 0xdeA0A6D88A21AA5D8aA5E0231EfD709Ce381e2aA;
148 
149     tokenReward = token(addressOfTokenUsedAsReward);
150 
151   }
152 
153 
154 
155   bool public started = true;
156 
157 
158 
159   function startSale(){
160 
161     if (msg.sender != wallet) throw;
162 
163     started = true;
164 
165   }
166 
167 
168 
169   function stopSale(){
170 
171     if(msg.sender != wallet) throw;
172 
173     started = false;
174 
175   }
176 
177 
178 
179   function setPrice(uint256 _price){
180 
181     if(msg.sender != wallet) throw;
182 
183     price = _price;
184 
185   }
186 
187   function changeWallet(address _wallet){
188 
189   	if(msg.sender != wallet) throw;
190 
191   	wallet = _wallet;
192 
193   }
194 
195 
196 
197   function changeTokenReward(address _token){
198 
199     if(msg.sender!=wallet) throw;
200 
201     tokenReward = token(_token);
202 
203   }
204 
205 
206 
207   // fallback function can be used to buy tokens
208 
209   function () payable {
210 
211     buyTokens(msg.sender);
212 
213   }
214 
215 
216 
217   // low level token `purchase function
218 
219   function buyTokens(address beneficiary) payable {
220 
221     require(beneficiary != 0x0);
222 
223     require(validPurchase());
224 
225 
226 
227     uint256 weiAmount = msg.value;
228 
229 
230 
231     // calculate token amount to be sent
232 
233     uint256 tokens = (weiAmount) * price;//weiamount * price 
234 
235     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
236 
237 
238 
239     // update state
240 
241     weiRaised = weiRaised.add(weiAmount);
242 
243     
244 
245     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
246 
247     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
248 
249 
250 
251     tokenReward.transfer(beneficiary, tokens);
252 
253     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
254 
255     forwardFunds();
256 
257   }
258 
259 
260 
261   // send ether to the fund collection wallet
262 
263   // override to create custom fund forwarding mechanisms
264 
265   function forwardFunds() internal {
266 
267     // wallet.transfer(msg.value);
268 
269     if (!wallet.send(msg.value)) {
270 
271       throw;
272 
273     }
274 
275   }
276 
277 
278 
279   // @return true if the transaction can buy tokens
280 
281   function validPurchase() internal constant returns (bool) {
282 
283     bool withinPeriod = started;
284 
285     bool nonZeroPurchase = msg.value != 0;
286 
287     return withinPeriod && nonZeroPurchase;
288 
289   }
290 
291 
292 
293   function withdrawTokens(uint256 _amount) {
294 
295     if(msg.sender!=wallet) throw;
296 
297     tokenReward.transfer(wallet,_amount);
298 
299   }
300 
301 }