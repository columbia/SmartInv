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
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
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
97   address addressOfTokenUsedAsReward;
98 
99 
100 
101   token tokenReward;
102 
103 
104 
105 
106 
107 
108 
109   // start and end timestamps where investments are allowed (both inclusive)
110 
111   uint256 public startTime;
112 
113   uint256 public endTime;
114 
115   // amount of raised money in wei
116 
117   uint256 public weiRaised;
118 
119 
120 
121   /**
122 
123    * event for token purchase logging
124 
125    * @param purchaser who paid for the tokens
126 
127    * @param beneficiary who got the tokens
128 
129    * @param value weis paid for purchase
130 
131    * @param amount amount of tokens purchased
132 
133    */
134 
135   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
136 
137 
138 
139 
140 
141   function Crowdsale() {
142 
143     wallet = 0x667794B184E4494f8592302f098A889087a58728;
144 
145     // durationInMinutes = _durationInMinutes;
146 
147     addressOfTokenUsedAsReward = 0x82B99C8a12B6Ee50191B9B2a03B9c7AEF663D527;
148 
149 
150 
151 
152 
153     tokenReward = token(addressOfTokenUsedAsReward);
154 
155   }
156 
157 
158 
159   bool started = false;
160 
161 
162 
163   function startSale(uint256 delay){
164 
165     if (msg.sender != wallet || started) throw;
166 
167     startTime = now + delay * 1 minutes;
168 
169     endTime = startTime + 30 * 24 * 60 * 1 minutes;
170 
171     started = true;
172 
173   }
174 
175 
176 
177   // fallback function can be used to buy tokens
178 
179   function () payable {
180 
181     buyTokens(msg.sender);
182 
183   }
184 
185 
186 
187   // low level token purchase function
188 
189   function buyTokens(address beneficiary) payable {
190 
191     require(beneficiary != 0x0);
192 
193     require(validPurchase());
194 
195 
196 
197     uint256 weiAmount = msg.value;
198 
199 
200 
201     // calculate token amount to be sent
202 
203     uint256 tokens = (weiAmount/10**10) * 1300;
204 
205 
206 
207     if(now < startTime + 1*7*24*60* 1 minutes){
208 
209       tokens += (tokens * 20) / 100;
210 
211     }else if(now < startTime + 2*7*24*60* 1 minutes){
212 
213       tokens += (tokens * 10) / 100;
214 
215     }else{
216 
217       tokens += (tokens * 5) / 100;
218 
219     }
220 
221 
222 
223     // update state
224 
225     weiRaised = weiRaised.add(weiAmount);
226 
227 
228 
229     tokenReward.transfer(beneficiary, tokens);
230 
231     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
232 
233     forwardFunds();
234 
235   }
236 
237 
238 
239   // send ether to the fund collection wallet
240 
241   // override to create custom fund forwarding mechanisms
242 
243   function forwardFunds() internal {
244 
245     // wallet.transfer(msg.value);
246 
247     if (!wallet.send(msg.value)) {
248 
249       throw;
250 
251     }
252 
253   }
254 
255 
256 
257   // @return true if the transaction can buy tokens
258 
259   function validPurchase() internal constant returns (bool) {
260 
261     bool withinPeriod = now >= startTime && now <= endTime;
262 
263     bool nonZeroPurchase = msg.value != 0;
264 
265     return withinPeriod && nonZeroPurchase;
266 
267   }
268 
269 
270 
271   // @return true if crowdsale event has ended
272 
273   function hasEnded() public constant returns (bool) {
274 
275     return now > endTime;
276 
277   }
278 
279 
280 
281   function withdrawTokens(uint256 _amount) {
282 
283     if(msg.sender!=wallet) throw;
284 
285     tokenReward.transfer(wallet,_amount);
286 
287   }
288 
289 }