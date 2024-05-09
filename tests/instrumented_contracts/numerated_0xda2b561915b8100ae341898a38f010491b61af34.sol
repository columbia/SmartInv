1 pragma solidity ^0.4.19;
2 
3 interface FsTKAuthority {
4   function isAuthorized(address sender, address _contract, bytes data) external view returns (bool);
5   function validate() external pure returns (bool);
6 }
7 
8 interface ServiceProvider {
9   function serviceFallback(address from, uint256 value, bytes data, uint256 gas) external;
10 }
11 
12 interface TokenReceiver {
13   function tokenFallback(address from, uint256 value, bytes data) external;
14 }
15 
16 interface ERC20 {
17   event Transfer(address indexed from, address indexed to, uint256 value);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 
20   function balanceOf(address owner) external view returns (uint256);
21   function allowance(address owner, address spender) external view returns (uint256);
22   function transfer(address to, uint256 value) external returns (bool);
23   function transferFrom(address from, address to, uint256 value) external returns (bool);
24   function approve(address spender, uint256 value) external returns (bool);
25 }
26 
27 interface FsTKToken {
28   event Transfer(address indexed from, address indexed to, uint value, bytes data);
29   event CancelSubscription(address indexed from, address indexed to);
30   event Subscribe(address indexed from, address indexed to, uint256 startTime, uint256 interval, uint256 amount);
31 
32   function transfer(address to, uint value, bytes data) external returns (bool);
33 
34   function buyService(ServiceProvider service, uint256 value, bytes data) external;
35   function transfer(uint256[] data) external;
36   function approve(address spender, uint256 expectedValue, uint256 newValue) external;
37   function increaseAllowance(address spender, uint256 value) external;
38   function decreaseAllowance(address spender, uint256 value) external;
39   function decreaseAllowanceOrEmtpy(address spender, uint256 value) external;
40 }
41 
42 library AddressExtension {
43 
44   function isValid(address _address) internal pure returns (bool) {
45     return 0 != _address;
46   }
47 
48   function isAccount(address _address) internal view returns (bool result) {
49     assembly {
50       result := iszero(extcodesize(_address))
51     }
52   }
53 
54   function toBytes(address _address) internal pure returns (bytes b) {
55    assembly {
56       let m := mload(0x40)
57       mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, _address))
58       mstore(0x40, add(m, 52))
59       b := m
60     }
61   }
62 }
63 
64 library Math {
65   struct Fraction {
66     uint256 numerator;
67     uint256 denominator;
68   }
69 
70   function mul(uint256 a, uint256 b) internal pure returns (uint256 r) {
71     r = a * b;
72     require((a == 0) || (r / a == b));
73   }
74 
75   function div(uint256 a, uint256 b) internal pure returns (uint256 r) {
76     r = a / b;
77   }
78 
79   function sub(uint256 a, uint256 b) internal pure returns (uint256 r) {
80     require((r = a - b) <= a);
81   }
82 
83   function add(uint256 a, uint256 b) internal pure returns (uint256 r) {
84     require((r = a + b) >= a);
85   }
86 
87   function min(uint256 x, uint256 y) internal pure returns (uint256 r) {
88     return x <= y ? x : y;
89   }
90 
91   function max(uint256 x, uint256 y) internal pure returns (uint256 r) {
92     return x >= y ? x : y;
93   }
94 
95   function mulDiv(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
96     // fast path
97     if (value == 0 || m == 0) {
98       return 0;
99     }
100 
101     r = value * m;
102     // if mul not overflow
103     if (r / value == m) {
104       r /= d;
105     } else {
106       // else div first
107       r = mul(value / d, m);
108     }
109   }
110 
111   function mul(uint256 x, Fraction memory f) internal pure returns (uint256) {
112     return mulDiv(x, f.numerator, f.denominator);
113   }
114 
115   function div(uint256 x, Fraction memory f) internal pure returns (uint256) {
116     return mulDiv(x, f.denominator, f.numerator);
117   }
118 }
119 
120 contract FsTKAllocation {
121   // vested 10% total supply of FST for core team members for 4 years
122   uint256 public constant VESTED_AMOUNT = 5500000 * (10 ** 18);  
123   uint256 public constant VESTED_AMOUNT_TOTAL = VESTED_AMOUNT * 6;
124   uint256 public constant RELEASE_EPOCH = 1642032000;
125   ERC20 public token;
126 
127   function initialize() public {
128     require(address(token) == 0);
129     token = ERC20(msg.sender);
130   }
131 
132   function () external {
133     require(
134       token.transfer(0x808b0730252DAA3a12CadC72f42E46E92a5e1bC8, VESTED_AMOUNT) &&                                true && true && true && true && true &&                  token.transfer(0xdA01fAFaF5E49e9467f99f5969cab499a5759cC6, VESTED_AMOUNT) &&
135       token.transfer(0xddab6c29090E6111A490527614Ceac583D02C8De, VESTED_AMOUNT) &&                         true && true && true && true && true && true &&                 token.transfer(0x5E6C9EC32b088c9FA1Fc0FEFa38A9B4De4169316, VESTED_AMOUNT) &&
136       true&&                                                                                            true &&                                                                                               true&&
137       true&&                                                                                          true &&                                                                                                 true&&
138       true&&                                                                                       true &&                                                                                                    true&&
139       true&&                                                                                     true &&                                                                                                      true&&
140       true&&                                                                                   true &&                                                                                                        true&&
141       true&&                                                                                  true &&                                                                                                         true&&
142       true&&                                                                                 true &&                                                                                                          true&&
143       true&&                                                                                 true &&                                                                                                          true&&
144       true&&                                                                                true &&                                                                                                           true&&
145       true&&                                                                                true &&                                                                                                           true&&
146       true&&                                                                                true &&                                                                                                           true&&
147       true&&                                                                                 true &&                                                                                                          true&&
148       true&&                                                                                  true &&                                                                                                         true&&
149       true&&                                                                                   true &&                                                                                                        true&&
150       token.transfer(0xFFB5d7C71e8680D0e9482e107F019a2b25D225B5,VESTED_AMOUNT)&&                true &&                                                                                                       true&&
151       token.transfer(0x91cE537b1a8118Aa20Ef7F3093697a7437a5Dc4B,VESTED_AMOUNT)&&                  true &&                                                                                                     true&&
152       true&&                                                                                         true &&                                                                                                  true&&
153       true&&                                                                                            block.timestamp >= RELEASE_EPOCH && true &&                                                           true&&
154       true&&                                                                                                   true && true && true && true && true &&                                                        true&&
155       true&&                                                                                                                                     true &&                                                      true&&
156       true&&                                                                                                                                       true &&                                                    true&&
157       true&&                                                                                                                                          true &&                                                 true&&
158       true&&                                                                                                                                            true &&                                               true&&
159       true&&                                                                                                                                             true &&                                              true&&
160       true&&                                                                                                                                              true &&                                             true&&
161       true&&                                                                                                                                               true &&                                            true&&
162       true&&                                                                                                                                                true &&                                           true&&
163       true&&                                                                                                                                                true &&                                           true&&
164       true&&                                                                                                                                                true &&                                           true&&
165       true&&                                                                                                                                               true &&                                            true&&
166       true&&                                                                                                                                              true &&                                             true&&
167       true&&                                                                                                                                             true &&                                              true&&
168       true&&                                                                                                                                           true &&                                                true&&
169       true&&                                                                                                                                         true &&                                                  true&&
170       true&&                                                                                                                                       true &&                                                    true&&
171       true&&                                                                                             true && true && true && true && true && true &&                                                      true&&
172       true&&                                                                                          true && true && true && true && true && true &&                                                          true
173     );
174   }
175 }
176 
177 
178 
179 contract Authorizable {
180   using AddressExtension for address;
181 
182   event FsTKAuthorityChanged(address indexed _address);
183 
184   modifier onlyFsTKAuthorized {
185     require(fstkAuthority.isAuthorized(msg.sender, this, msg.data));
186     _;
187   }
188 
189   FsTKAuthority internal fstkAuthority;
190 
191   function Authorizable(FsTKAuthority _fstkAuthority) internal {
192     require(_fstkAuthority.validate());
193     FsTKAuthorityChanged(fstkAuthority = _fstkAuthority);
194   }
195 
196   function changeFsTKAuthority(FsTKAuthority _fstkAuthority) public onlyFsTKAuthorized {
197     require(_fstkAuthority.validate());
198     FsTKAuthorityChanged(fstkAuthority = _fstkAuthority);
199   }
200 }
201 
202 contract AbstractToken is ERC20, FsTKToken {
203   using AddressExtension for address;
204   using Math for uint256;
205 
206   struct Subscription {
207     uint256 amount;
208     uint256 startTime;
209     uint256 interval;
210     uint256 epoch;
211     uint256 collectTime;
212   }
213 
214   struct Account {
215     uint256 balance;
216     mapping (address => uint256) allowances;
217     mapping (address => Subscription) subscriptions;
218   }
219 
220   modifier liquid {
221     require(isLiquid);
222      _;
223   }
224 
225   bool public isLiquid = true;
226   bool public erc20ApproveChecking;
227   mapping(address => Account) internal accounts;
228 
229   // *************************
230   // * ERC 20
231   // *************************
232 
233   function balanceOf(address owner) external view returns (uint256) {
234     return accounts[owner].balance;
235   }
236 
237   function allowance(address owner, address spender) external view returns (uint256) {
238     return accounts[owner].allowances[spender];
239   }
240 
241   function transfer(address to, uint256 value) external liquid returns (bool) {
242     Account storage senderAccount = accounts[msg.sender];
243     require(value <= senderAccount.balance);
244 
245     senderAccount.balance -= value;
246     accounts[to].balance += value;
247 
248     Transfer(msg.sender, to, value);
249     Transfer(msg.sender, to, value, new bytes(0));
250     return true;
251   }
252 
253   function transferFrom(address from, address to, uint256 value) external liquid returns (bool) {
254     Account storage fromAccount = accounts[from];
255     require(value <= fromAccount.balance && value <= fromAccount.allowances[msg.sender]);
256 
257     fromAccount.balance -= value;
258     fromAccount.allowances[msg.sender] -= value;
259     accounts[to].balance += value;
260 
261     Transfer(from, to, value);
262     Transfer(from, to, value, new bytes(0));
263     return true;
264   }
265 
266   function approve(address spender, uint256 value) external returns (bool) {
267     Account storage senderAccount = accounts[msg.sender];
268     if (erc20ApproveChecking) {
269       require((value == 0) || (senderAccount.allowances[spender] == 0));
270     }
271     senderAccount.allowances[spender] = value;
272 
273     Approval(msg.sender, spender, value);
274     return true;
275   }
276 
277   // *************************
278   // * FsTK Token
279   // *************************
280 
281   function transfer(address to, uint256 value, bytes data) external liquid returns (bool) {
282     Account storage senderAccount = accounts[msg.sender];
283     require(value <= senderAccount.balance);
284 
285     senderAccount.balance -= value;
286     accounts[to].balance += value;
287 
288     Transfer(msg.sender, to, value);
289     Transfer(msg.sender, to, value, data);
290 
291     if (!to.isAccount()) {
292       TokenReceiver(to).tokenFallback(msg.sender, value, data);
293     }
294     return true;
295   }
296 
297   function buyService(ServiceProvider service, uint256 value, bytes data) external liquid {
298     uint256 gas = msg.gas;
299     Account storage senderAccount = accounts[msg.sender];
300     uint256 currentValue = senderAccount.allowances[service];
301     senderAccount.allowances[service] = currentValue.add(value);
302     service.serviceFallback(msg.sender, value, data, gas);
303     senderAccount.allowances[service] = currentValue;
304   }
305 
306   function transfer(uint256[] data) external liquid {
307     Account storage senderAccount = accounts[msg.sender];
308     for (uint256 i = 0; i < data.length; i++) {
309       address receiver = address(data[i] >> 96);
310       uint256 value = data[i] & 0xffffffffffffffffffffffff;
311       require(value <= senderAccount.balance);
312 
313       senderAccount.balance -= value;
314       accounts[receiver].balance += value;
315 
316       Transfer(msg.sender, receiver, value);
317       Transfer(msg.sender, receiver, value, new bytes(0));
318     }
319   }
320 
321   function subscriptionOf(address owner, address collector) external view returns (Subscription) {
322     return accounts[owner].subscriptions[collector];
323   }
324 
325   function subscribe(address collector, uint256 startTime, uint256 interval, uint256 amount) external {
326     accounts[msg.sender].subscriptions[collector] = Subscription({
327       startTime: startTime,
328       interval: interval,
329       amount: amount,
330       epoch: 0,
331       collectTime: 0
332     });
333     Subscribe(msg.sender, collector, startTime, interval, amount);
334   }
335 
336   function cancelSubscription(address collector) external {
337     delete accounts[msg.sender].subscriptions[collector];
338     CancelSubscription(msg.sender, collector);
339   }
340 
341   function collect(address from) external {
342     Account storage fromAccount = accounts[from];
343     Subscription storage info = fromAccount.subscriptions[msg.sender];
344     uint256 epoch = (block.timestamp.sub(info.startTime)) / info.interval + 1;
345     require(info.amount > 0 && epoch > info.epoch);
346     uint256 totalAmount = (epoch - info.epoch).mul(info.amount);
347     if (totalAmount > fromAccount.balance) {
348       delete fromAccount.subscriptions[msg.sender];
349       CancelSubscription(from, msg.sender);
350     } else {
351       info.collectTime = block.timestamp;
352       fromAccount.balance -= totalAmount;
353       accounts[msg.sender].balance += totalAmount;
354 
355       Transfer(from, msg.sender, totalAmount);
356       Transfer(from, msg.sender, totalAmount, new bytes(0));
357     }
358   }
359 
360   function collect(address[] froms) external {
361     for (uint256 i = 0; i < froms.length; i++) {
362       address from = froms[i];
363       Account storage fromAccount = accounts[from];
364       Subscription storage info = fromAccount.subscriptions[msg.sender];
365       uint256 epoch = (block.timestamp.sub(info.startTime)) / info.interval + 1;
366       require(info.amount > 0 && epoch > info.epoch);
367       uint256 totalAmount = (epoch - info.epoch).mul(info.amount);
368       if (totalAmount > fromAccount.balance) {
369         delete fromAccount.subscriptions[msg.sender];
370         CancelSubscription(from, msg.sender);
371       } else {
372         info.collectTime = block.timestamp;
373         fromAccount.balance -= totalAmount;
374         accounts[msg.sender].balance += totalAmount;
375   
376         Transfer(from, msg.sender, totalAmount);
377         Transfer(from, msg.sender, totalAmount, new bytes(0));
378       }
379     }
380   }
381 
382   function approve(address spender, uint256 expectedValue, uint256 newValue) external {
383     Account storage senderAccount = accounts[msg.sender];
384     require(senderAccount.allowances[spender] == expectedValue);
385 
386     senderAccount.allowances[spender] = newValue;
387 
388     Approval(msg.sender, spender, newValue);
389   }
390 
391   function increaseAllowance(address spender, uint256 value) external {
392     Account storage senderAccount = accounts[msg.sender];
393     uint256 newValue = senderAccount.allowances[spender].add(value);
394     senderAccount.allowances[spender] = newValue;
395 
396     Approval(msg.sender, spender, newValue);
397   }
398 
399   function decreaseAllowance(address spender, uint256 value) external {
400     Account storage senderAccount = accounts[msg.sender];
401     uint256 newValue = senderAccount.allowances[spender].sub(value);
402     senderAccount.allowances[spender] = newValue;
403 
404     Approval(msg.sender, spender, newValue);
405   }
406 
407   function decreaseAllowanceOrEmtpy(address spender, uint256 value) external {
408     Account storage senderAccount = accounts[msg.sender];
409     uint256 currentValue = senderAccount.allowances[spender];
410     uint256 newValue;
411     if (value < currentValue) {
412       newValue = currentValue - value;
413     }
414     senderAccount.allowances[spender] = newValue;
415 
416     Approval(msg.sender, spender, newValue);
417   }
418 
419   function setLiquid(bool _isLiquid) public {
420     isLiquid = _isLiquid;
421   }
422 
423   function setERC20ApproveChecking(bool _erc20ApproveChecking) public {
424     erc20ApproveChecking = _erc20ApproveChecking;
425   }
426 }
427 
428 contract FunderSmartToken is AbstractToken, Authorizable {
429   string public constant name = "Funder Smart Token";
430   string public constant symbol = "FST";
431   uint256 public constant totalSupply = 330000000 * (10 ** 18);
432   uint8 public constant decimals = 18;
433 
434   function FunderSmartToken(FsTKAuthority _fstkAuthority, address fstkWallet, FsTKAllocation allocation) Authorizable(_fstkAuthority) public {
435     // vested 10% total supply of FST for core team members for 4 years
436     uint256 vestedAmount = allocation.VESTED_AMOUNT_TOTAL();
437     accounts[allocation].balance = vestedAmount;
438     allocation.initialize();     
439     Transfer(address(0), allocation, vestedAmount);
440     Transfer(address(0), allocation, vestedAmount, new bytes(0));
441 
442     uint256 releaseAmount = totalSupply - vestedAmount;
443     accounts[fstkWallet].balance = releaseAmount;
444     Transfer(address(0), fstkWallet, releaseAmount);
445     Transfer(address(0), fstkWallet, releaseAmount, new bytes(0));
446   }
447 
448   function setLiquid(bool _isLiquid) public onlyFsTKAuthorized {
449     AbstractToken.setLiquid(_isLiquid);
450   }
451 
452   function setERC20ApproveChecking(bool _erc20ApproveChecking) public onlyFsTKAuthorized {
453     AbstractToken.setERC20ApproveChecking(_erc20ApproveChecking);
454   }
455 
456   function transferToken(ERC20 erc20, address to, uint256 value) public onlyFsTKAuthorized {
457     erc20.transfer(to, value);
458   }
459 }