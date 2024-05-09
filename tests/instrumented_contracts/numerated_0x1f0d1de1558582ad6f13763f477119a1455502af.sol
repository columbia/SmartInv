1 pragma solidity ^0.4.24;
2 
3 // Saturn Network
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 library BytesLib {
32   function toAddress(bytes _bytes, uint _start) internal pure returns (address) {
33     require(_bytes.length >= (_start + 20));
34     address tempAddress;
35 
36     assembly {
37       tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
38     }
39 
40     return tempAddress;
41   }
42 
43   function toUint(bytes _bytes, uint _start) internal pure returns (uint256) {
44     require(_bytes.length >= (_start + 32));
45     uint256 tempUint;
46 
47     assembly {
48       tempUint := mload(add(add(_bytes, 0x20), _start))
49     }
50 
51     return tempUint;
52   }
53 }
54 
55 contract ERC223 {
56   uint public totalSupply;
57   function balanceOf(address who) constant public returns (uint);
58 
59   function name() constant public returns (string _name);
60   function symbol() constant public returns (string _symbol);
61   function decimals() constant public returns (uint8 _decimals);
62   function totalSupply() constant public returns (uint256 _supply);
63 
64   function transfer(address to, uint value) public returns (bool ok);
65   function transfer(address to, uint value, bytes data) public returns (bool ok);
66   event Transfer(address indexed _from, address indexed _to, uint256 _value);
67   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
68 }
69 
70 contract ContractReceiver {
71   function tokenFallback(address _from, uint _value, bytes _data) public;
72 }
73 
74 contract ERC20 {
75     function totalSupply() public view returns (uint);
76     function balanceOf(address holder) public view returns (uint);
77     function allowance(address holder, address other) public view returns (uint);
78 
79     function approve(address other, uint amount) public returns (bool);
80     function transfer(address to, uint amount) public returns (bool);
81     function transferFrom(
82         address from, address to, uint amount
83     ) public returns (bool);
84 }
85 
86 contract Exchange is ContractReceiver {
87   using SafeMath for uint256;
88   using BytesLib for bytes;
89 
90   struct Order {
91     address owner;
92     bool    active;
93     address sellToken;
94     address buyToken;
95     address ring;
96     uint256 amount;
97     uint256 priceMul;
98     uint256 priceDiv;
99   }
100 
101   // person => token => balance
102   mapping(address => mapping(address => uint256)) private balances;
103   mapping(uint256 => Order) private orderBook;
104   uint256 public orderCount;
105   address private etherAddress = 0x0;
106 
107   address private saturnToken;
108   address private admin;
109   uint256 public tradeMiningBalance;
110   address public treasury;
111 
112   uint256 public feeMul;
113   uint256 public feeDiv;
114   uint256 public tradeMiningMul;
115   uint256 public tradeMiningDiv;
116 
117   event NewOrder(
118     uint256 id,
119     address owner,
120     address sellToken,
121     address buyToken,
122     address ring,
123     uint256 amount,
124     uint256 priceMul,
125     uint256 priceDiv,
126     uint256 time
127   );
128 
129   event OrderCancelled(
130     uint256 id,
131     uint256 time
132   );
133 
134   event OrderFulfilled(
135     uint256 id,
136     uint256 time
137   );
138 
139   event Trade(
140     address from,
141     address to,
142     uint256 orderId,
143     uint256 soldTokens,
144     uint256 boughtTokens,
145     uint256 feePaid,
146     uint256 time
147   );
148 
149   event Mined(
150     address trader,
151     uint256 amount,
152     uint256 time
153   );
154 
155   // this syntax was too advanced for ETC pre-Agharta
156   /* constructor( */
157   function Exchange(
158     address _saturnToken,
159     address _treasury,
160     uint256 _feeMul,
161     uint256 _feeDiv,
162     uint256 _tradeMiningMul,
163     uint256 _tradeMiningDiv
164   ) public {
165     saturnToken    = _saturnToken;
166     treasury       = _treasury;
167     feeMul         = _feeMul;
168     feeDiv         = _feeDiv;
169     tradeMiningMul = _tradeMiningMul;
170     tradeMiningDiv = _tradeMiningDiv;
171     // admin can only add & remove tokens from SATURN trade mining token distribution program
172     // admin has no ability to halt trading, delist tokens, or claim anyone's funds
173     admin          = msg.sender;
174   }
175 
176   function() payable public { revert(); }
177 
178   //////////////////
179   // public views //
180   //////////////////
181   // TODO: add views for prices too
182   // TODO: and for order owner too
183 
184   function getBalance(address token, address user) view public returns(uint256) {
185     return balances[user][token];
186   }
187 
188   function isOrderActive(uint256 orderId) view public returns(bool) {
189     return orderBook[orderId].active;
190   }
191 
192   function remainingAmount(uint256 orderId) view public returns(uint256) {
193     return orderBook[orderId].amount;
194   }
195 
196   function getBuyTokenAmount(uint256 desiredSellTokenAmount, uint256 orderId) public view returns(uint256 amount) {
197     require(desiredSellTokenAmount > 0);
198     Order storage order = orderBook[orderId];
199 
200     if (order.sellToken == etherAddress || order.buyToken == etherAddress) {
201       uint256 feediff = feeDiv.sub(feeMul);
202       amount = desiredSellTokenAmount.mul(order.priceDiv).mul(feeDiv).div(order.priceMul).div(feediff);
203     } else {
204       amount = desiredSellTokenAmount.mul(order.priceDiv).div(order.priceMul);
205     }
206     require(amount > 0);
207   }
208 
209   function calcFees(uint256 amount, uint256 orderId) public view returns(uint256 fees) {
210     Order storage order = orderBook[orderId];
211 
212     if (order.sellToken == etherAddress) {
213       uint256 sellTokenAmount = amount.mul(order.priceMul).div(order.priceDiv);
214       fees = sellTokenAmount.mul(feeMul).div(feeDiv);
215     } else if (order.buyToken == etherAddress) {
216       fees = amount.mul(feeMul).div(feeDiv);
217     } else {
218       fees = 0;
219     }
220     return fees;
221   }
222 
223   function tradeMiningAmount(uint256 fees, uint256 orderId) public view returns(uint256) {
224     if (fees == 0) { return 0; }
225     Order storage order = orderBook[orderId];
226     if (!order.active) { return 0; }
227     uint256 tokenAmount = fees.mul(tradeMiningMul).div(tradeMiningDiv);
228 
229     if (tradeMiningBalance < tokenAmount) {
230       return tradeMiningBalance;
231     } else {
232       return tokenAmount;
233     }
234   }
235 
236   ////////////////////
237   // public methods //
238   ////////////////////
239 
240   function withdrawTradeMining() public {
241     if (msg.sender != admin) { revert(); }
242     require(tradeMiningBalance > 0);
243 
244     uint toSend = tradeMiningBalance;
245     tradeMiningBalance = 0;
246     require(sendTokensTo(admin, toSend, saturnToken));
247   }
248 
249   function changeTradeMiningPrice(uint256 newMul, uint256 newDiv) public {
250     if (msg.sender != admin) { revert(); }
251     require(newDiv != 0);
252     tradeMiningMul = newMul;
253     tradeMiningDiv = newDiv;
254   }
255 
256   // handle incoming ERC223 tokens
257   function tokenFallback(address from, uint value, bytes data) public {
258     // depending on length of data
259     // this should be either an order creating transaction
260     // or an order taking transaction
261     // or a transaction allocating tokens for trade mining
262     if (data.length == 0 && msg.sender == saturnToken) {
263       _topUpTradeMining(value);
264     } else if (data.length == 84) {
265       _newOrder(from, msg.sender, data.toAddress(64), value, data.toUint(0), data.toUint(32), etherAddress);
266     } else if (data.length == 104) {
267       _newOrder(from, msg.sender, data.toAddress(64), value, data.toUint(0), data.toUint(32), data.toAddress(84));
268     } else if (data.length == 32) {
269       _executeOrder(from, data.toUint(0), msg.sender, value);
270     } else {
271       // unknown payload!
272       revert();
273     }
274   }
275 
276   function sellEther(
277     address buyToken,
278     uint256 priceMul,
279     uint256 priceDiv
280   ) public payable returns(uint256 orderId) {
281     require(msg.value > 0);
282     return _newOrder(msg.sender, etherAddress, buyToken, msg.value, priceMul, priceDiv, etherAddress);
283   }
284 
285   function sellEtherWithRing(
286     address buyToken,
287     uint256 priceMul,
288     uint256 priceDiv,
289     address ring
290   ) public payable returns(uint256 orderId) {
291     require(msg.value > 0);
292     return _newOrder(msg.sender, etherAddress, buyToken, msg.value, priceMul, priceDiv, ring);
293   }
294 
295   function buyOrderWithEth(uint256 orderId) public payable {
296     require(msg.value > 0);
297     _executeOrder(msg.sender, orderId, etherAddress, msg.value);
298   }
299 
300   function sellERC20Token(
301     address sellToken,
302     address buyToken,
303     uint256 amount,
304     uint256 priceMul,
305     uint256 priceDiv
306   ) public returns(uint256 orderId) {
307     require(amount > 0);
308     require(pullTokens(sellToken, amount));
309     return _newOrder(msg.sender, sellToken, buyToken, amount, priceMul, priceDiv, etherAddress);
310   }
311 
312   function sellERC20TokenWithRing(
313     address sellToken,
314     address buyToken,
315     uint256 amount,
316     uint256 priceMul,
317     uint256 priceDiv,
318     address ring
319   ) public returns(uint256 orderId) {
320     require(amount > 0);
321     require(pullTokens(sellToken, amount));
322     return _newOrder(msg.sender, sellToken, buyToken, amount, priceMul, priceDiv, ring);
323   }
324 
325   function buyOrderWithERC20Token(
326     uint256 orderId,
327     address token,
328     uint256 amount
329   ) public {
330     require(amount > 0);
331     require(pullTokens(token, amount));
332     _executeOrder(msg.sender, orderId, token, amount);
333   }
334 
335   function cancelOrder(uint256 orderId) public {
336     Order storage order = orderBook[orderId];
337     require(order.amount > 0);
338     require(order.active);
339     require(msg.sender == order.owner);
340 
341     balances[msg.sender][order.sellToken] = balances[msg.sender][order.sellToken].sub(order.amount);
342     require(sendTokensTo(order.owner, order.amount, order.sellToken));
343 
344     // deleting the order refunds the caller some gas (up to 50%)
345     // this also sets order.active to false
346     delete orderBook[orderId];
347     emit OrderCancelled(orderId, now);
348   }
349 
350   /////////////////////
351   // private methods //
352   /////////////////////
353 
354   function _newOrder(
355     address owner,
356     address sellToken,
357     address buyToken,
358     uint256 amount,
359     uint256 priceMul,
360     uint256 priceDiv,
361     address ring
362   ) private returns(uint256 orderId) {
363     /////////////////////////
364     // step 1. validations //
365     /////////////////////////
366     require(amount > 0);
367     require(priceMul > 0);
368     require(priceDiv > 0);
369     require(sellToken != buyToken);
370     ///////////////////////////////
371     // step 2. Update order book //
372     ///////////////////////////////
373     orderId = orderCount++;
374     orderBook[orderId] = Order(owner, true, sellToken, buyToken, ring, amount, priceMul, priceDiv);
375     balances[owner][sellToken] = balances[owner][sellToken].add(amount);
376 
377     emit NewOrder(orderId, owner, sellToken, buyToken, ring, amount, priceMul, priceDiv, now);
378   }
379 
380   function _executeBuyOrder(address trader, uint256 orderId, uint256 buyTokenAmount) private returns(uint256) {
381     // buytoken: tkn
382     // selltoken: ether
383     Order storage order = orderBook[orderId];
384     uint256 sellTokenAmount = buyTokenAmount.mul(order.priceMul).div(order.priceDiv);
385     uint256 fees = sellTokenAmount.mul(feeMul).div(feeDiv);
386 
387     require(sellTokenAmount > 0);
388     require(sellTokenAmount <= order.amount);
389     order.amount = order.amount.sub(sellTokenAmount);
390     // send tokens to order owner
391     require(sendTokensTo(order.owner, buyTokenAmount, order.buyToken));
392     // send ether to trader
393     require(sendTokensTo(trader, sellTokenAmount.sub(fees), order.sellToken));
394 
395     emit Trade(trader, order.owner, orderId, sellTokenAmount.sub(fees), buyTokenAmount, fees, now);
396     return fees;
397   }
398 
399   function _executeSellOrder(address trader, uint256 orderId, uint256 buyTokenAmount) private returns(uint256) {
400     // buytoken: ether
401     // selltoken: tkn
402     Order storage order = orderBook[orderId];
403     uint256 fees = buyTokenAmount.mul(feeMul).div(feeDiv);
404     uint256 sellTokenAmount = buyTokenAmount.sub(fees).mul(order.priceMul).div(order.priceDiv);
405 
406 
407     require(sellTokenAmount > 0);
408     require(sellTokenAmount <= order.amount);
409     order.amount = order.amount.sub(sellTokenAmount);
410     // send ether to order owner
411     require(sendTokensTo(order.owner, buyTokenAmount.sub(fees), order.buyToken));
412     // send token to trader
413     require(sendTokensTo(trader, sellTokenAmount, order.sellToken));
414 
415     emit Trade(trader, order.owner, orderId, sellTokenAmount, buyTokenAmount.sub(fees), fees, now);
416     return fees;
417   }
418 
419   function _executeTokenSwap(address trader, uint256 orderId, uint256 buyTokenAmount) private returns(uint256) {
420     // no ether was exchanged
421     Order storage order = orderBook[orderId];
422     uint256 sellTokenAmount = buyTokenAmount.mul(order.priceMul).div(order.priceDiv);
423 
424     require(sellTokenAmount > 0);
425     require(sellTokenAmount <= order.amount);
426     order.amount = order.amount.sub(sellTokenAmount);
427 
428     require(sendTokensTo(order.owner, buyTokenAmount, order.buyToken));
429     require(sendTokensTo(trader, sellTokenAmount, order.sellToken));
430 
431     emit Trade(trader, order.owner, orderId, sellTokenAmount, buyTokenAmount, 0, now);
432     return 0;
433   }
434 
435   function _executeOrder(address trader, uint256 orderId, address buyToken, uint256 buyTokenAmount) private {
436     /////////////////////////
437     // step 0. validations //
438     /////////////////////////
439     require(orderId < orderCount);
440     require(buyTokenAmount > 0);
441     Order storage order = orderBook[orderId];
442     require(order.active);
443     require(trader != order.owner);
444     require(buyToken == order.buyToken);
445 
446     // enforce exclusivity for the rings
447     if (order.ring != etherAddress) { require(order.ring == tx.origin); }
448 
449     ////////////////////////////
450     // step 1. token exchange //
451     ////////////////////////////
452     uint256 fees;
453     if (order.sellToken == etherAddress) {
454       // buy order: taker sends ether, gets tokens
455       fees = _executeBuyOrder(trader, orderId, buyTokenAmount);
456     } else if (order.buyToken == etherAddress) {
457       // sell order: taker sends tokens, gets ether
458       fees = _executeSellOrder(trader, orderId, buyTokenAmount);
459     } else {
460       fees = _executeTokenSwap(trader, orderId, buyTokenAmount);
461     }
462 
463     ////////////////////////////
464     // step 2. fees & wrap up //
465     ////////////////////////////
466     // collect fees and issue trade mining
467     require(_tradeMiningAndFees(fees, trader));
468     // deleting the order refunds the caller some gas
469     if (orderBook[orderId].amount == 0) {
470       delete orderBook[orderId];
471       emit OrderFulfilled(orderId, now);
472     }
473   }
474 
475   function _tradeMiningAndFees(uint256 fees, address trader) private returns(bool) {
476     if (fees == 0) { return true; }
477     // step one: send fees to the treasury
478     require(sendTokensTo(treasury, fees, etherAddress));
479     if (tradeMiningBalance == 0) { return true; }
480 
481     // step two: calculate reward
482     uint256 tokenAmount = fees.mul(tradeMiningMul).div(tradeMiningDiv);
483     if (tokenAmount == 0) { return true; }
484     if (tokenAmount > tradeMiningBalance) { tokenAmount = tradeMiningBalance; }
485 
486     // account for sent tokens
487     tradeMiningBalance = tradeMiningBalance.sub(tokenAmount);
488     // step three: send the reward to the trader
489     require(sendTokensTo(trader, tokenAmount, saturnToken));
490     emit Mined(trader, tokenAmount, now);
491     return true;
492   }
493 
494   function sendTokensTo(address destination, uint256 amount, address tkn) private returns(bool) {
495     if (tkn == etherAddress) {
496       destination.transfer(amount);
497     } else {
498       // works with both ERC223 and ERC20
499       require(ERC20(tkn).transfer(destination, amount));
500     }
501     return true;
502   }
503 
504   // ERC20 fixture
505   function pullTokens(address token, uint256 amount) private returns(bool) {
506     return ERC20(token).transferFrom(msg.sender, address(this), amount);
507   }
508 
509   function _topUpTradeMining(uint256 amount) private returns(bool) {
510     tradeMiningBalance = tradeMiningBalance.add(amount);
511     return true;
512   }
513 }