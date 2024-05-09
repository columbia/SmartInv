1 // Saturn Protocol
2 
3 // File: contracts/SafeMath.sol
4 
5 pragma solidity ^0.4.24;
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
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
33 // File: contracts/BytesLib.sol
34 // from
35 // https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
36 
37 
38 library BytesLib {
39   function toAddress(bytes _bytes, uint _start) internal pure returns (address) {
40     require(_bytes.length >= (_start + 20));
41     address tempAddress;
42 
43     assembly {
44       tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
45     }
46 
47     return tempAddress;
48   }
49 
50   function toUint(bytes _bytes, uint _start) internal pure returns (uint256) {
51     require(_bytes.length >= (_start + 32));
52     uint256 tempUint;
53 
54     assembly {
55       tempUint := mload(add(add(_bytes, 0x20), _start))
56     }
57 
58     return tempUint;
59   }
60 }
61 
62 // File: contracts/ERC223.sol
63 
64 contract ERC223 {
65   uint public totalSupply;
66   function balanceOf(address who) constant public returns (uint);
67 
68   function name() constant public returns (string _name);
69   function symbol() constant public returns (string _symbol);
70   function decimals() constant public returns (uint8 _decimals);
71   function totalSupply() constant public returns (uint256 _supply);
72 
73   function transfer(address to, uint value) public returns (bool ok);
74   function transfer(address to, uint value, bytes data) public returns (bool ok);
75   event Transfer(address indexed _from, address indexed _to, uint256 _value);
76   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
77 }
78 
79 contract ContractReceiver {
80   function tokenFallback(address _from, uint _value, bytes _data) public;
81 }
82 
83 contract ERC223I is ERC223 {
84   using SafeMath for uint;
85 
86   mapping(address => uint) balances;
87 
88   string public name;
89   string public symbol;
90   uint8 public decimals;
91   uint256 public totalSupply;
92 
93 
94   function name() constant public returns (string _name) {
95     return name;
96   }
97   function symbol() constant public returns (string _symbol) {
98     return symbol;
99   }
100   function decimals() constant public returns (uint8 _decimals) {
101     return decimals;
102   }
103   function totalSupply() constant public returns (uint256 _totalSupply) {
104     return totalSupply;
105   }
106 
107   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
108     if (isContract(_to)) {
109       return transferToContract(_to, _value, _data);
110     } else {
111       return transferToAddress(_to, _value, _data);
112     }
113   }
114 
115   function transfer(address _to, uint _value) public returns (bool success) {
116     bytes memory empty;
117     if (isContract(_to)) {
118       return transferToContract(_to, _value, empty);
119     } else {
120       return transferToAddress(_to, _value, empty);
121     }
122   }
123 
124   function isContract(address _addr) private view returns (bool is_contract) {
125     uint length;
126     assembly {
127       length := extcodesize(_addr)
128     }
129     return (length > 0);
130   }
131 
132   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
133     if (balanceOf(msg.sender) < _value) revert();
134     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
135     balances[_to] = balanceOf(_to).add(_value);
136     Transfer(msg.sender, _to, _value);
137     ERC223Transfer(msg.sender, _to, _value, _data);
138     return true;
139   }
140 
141   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
142     if (balanceOf(msg.sender) < _value) revert();
143     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
144     balances[_to] = balanceOf(_to).add(_value);
145     ContractReceiver reciever = ContractReceiver(_to);
146     reciever.tokenFallback(msg.sender, _value, _data);
147     Transfer(msg.sender, _to, _value);
148     ERC223Transfer(msg.sender, _to, _value, _data);
149     return true;
150   }
151 
152   function balanceOf(address _owner) constant public returns (uint balance) {
153     return balances[_owner];
154   }
155 }
156 
157 // File: contracts/Exchange.sol
158 
159 // Saturn Protocol
160 
161 contract ERC20 {
162     function totalSupply() public view returns (uint);
163     function balanceOf(address holder) public view returns (uint);
164     function allowance(address holder, address other) public view returns (uint);
165 
166     function approve(address other, uint amount) public returns (bool);
167     function transfer(address to, uint amount) public returns (bool);
168     function transferFrom(
169         address from, address to, uint amount
170     ) public returns (bool);
171 }
172 
173 contract Exchange is ContractReceiver {
174   using SafeMath for uint256;
175   using BytesLib for bytes;
176 
177   bool private rentrancy_lock = false;
178   modifier nonReentrant() {
179     require(!rentrancy_lock);
180     rentrancy_lock = true;
181     _;
182     rentrancy_lock = false;
183   }
184 
185   struct Order {
186     address owner;
187     bool    active;
188     address sellToken;
189     address buyToken;
190     address ring;
191     uint256 amount;
192     uint256 priceMul;
193     uint256 priceDiv;
194   }
195 
196   // person => token => balance
197   mapping(address => mapping(address => uint256)) private balances;
198   mapping(uint256 => Order) private orderBook;
199   uint256 public orderCount;
200   address private etherAddress = 0x0;
201 
202   address private saturnToken;
203   address private admin;
204   uint256 public tradeMiningBalance;
205   address public treasury;
206 
207   uint256 public feeMul;
208   uint256 public feeDiv;
209   uint256 public tradeMiningMul;
210   uint256 public tradeMiningDiv;
211 
212   event NewOrder(
213     uint256 id,
214     address owner,
215     address sellToken,
216     address buyToken,
217     address ring,
218     uint256 amount,
219     uint256 priceMul,
220     uint256 priceDiv,
221     uint256 time
222   );
223 
224   event OrderCancelled(
225     uint256 id,
226     uint256 time
227   );
228 
229   event OrderFulfilled(
230     uint256 id,
231     uint256 time
232   );
233 
234   event Trade(
235     address from,
236     address to,
237     uint256 orderId,
238     uint256 soldTokens,
239     uint256 boughtTokens,
240     uint256 feePaid,
241     uint256 time
242   );
243 
244   event Mined(
245     address trader,
246     uint256 amount,
247     uint256 time
248   );
249 
250   function Exchange(
251     address _saturnToken,
252     address _treasury,
253     uint256 _feeMul,
254     uint256 _feeDiv,
255     uint256 _tradeMiningMul,
256     uint256 _tradeMiningDiv
257   ) public {
258     saturnToken    = _saturnToken;
259     treasury       = _treasury;
260     feeMul         = _feeMul;
261     feeDiv         = _feeDiv;
262     tradeMiningMul = _tradeMiningMul;
263     tradeMiningDiv = _tradeMiningDiv;
264     admin          = msg.sender;
265   }
266 
267   function() payable public { revert(); }
268 
269   //////////////////
270   // public views //
271   //////////////////
272   // add views for prices too
273   // and for order owner too
274 
275   function getBalance(address token, address user) view public returns(uint256) {
276     return balances[user][token];
277   }
278 
279   function isOrderActive(uint256 orderId) view public returns(bool) {
280     return orderBook[orderId].active;
281   }
282 
283   function remainingAmount(uint256 orderId) view public returns(uint256) {
284     return orderBook[orderId].amount;
285   }
286 
287   function getBuyTokenAmount(uint256 desiredSellTokenAmount, uint256 orderId) public view returns(uint256 amount) {
288     require(desiredSellTokenAmount > 0);
289     Order storage order = orderBook[orderId];
290 
291     if (order.sellToken == etherAddress || order.buyToken == etherAddress) {
292       uint256 feediff = feeDiv.sub(feeMul);
293       amount = desiredSellTokenAmount.mul(order.priceDiv).mul(feeDiv).div(order.priceMul).div(feediff);
294     } else {
295       amount = desiredSellTokenAmount.mul(order.priceDiv).div(order.priceMul);
296     }
297     require(amount > 0);
298   }
299 
300   function calcFees(uint256 amount, uint256 orderId) public view returns(uint256 fees) {
301     Order storage order = orderBook[orderId];
302 
303     if (order.sellToken == etherAddress) {
304       uint256 sellTokenAmount = amount.mul(order.priceMul).div(order.priceDiv);
305       fees = sellTokenAmount.mul(feeMul).div(feeDiv);
306     } else if (order.buyToken == etherAddress) {
307       fees = amount.mul(feeMul).div(feeDiv);
308     } else {
309       fees = 0;
310     }
311     return fees;
312   }
313 
314   function tradeMiningAmount(uint256 fees, uint256 orderId) public view returns(uint256) {
315     if (fees == 0) { return 0; }
316     Order storage order = orderBook[orderId];
317     if (!order.active) { return 0; }
318     uint256 tokenAmount = fees.mul(tradeMiningMul).div(tradeMiningDiv);
319 
320     if (tradeMiningBalance < tokenAmount) {
321       return tradeMiningBalance;
322     } else {
323       return tokenAmount;
324     }
325   }
326 
327   ////////////////////
328   // public methods //
329   ////////////////////
330 
331   function withdrawTradeMining() public {
332     if (msg.sender != admin) { revert(); }
333     require(tradeMiningBalance > 0);
334 
335     uint toSend = tradeMiningBalance;
336     tradeMiningBalance = 0;
337     require(sendTokensTo(admin, toSend, saturnToken));
338   }
339 
340   function changeTradeMiningPrice(uint256 newMul, uint256 newDiv) public {
341     if (msg.sender != admin) { revert(); }
342     require(newDiv != 0);
343     tradeMiningMul = newMul;
344     tradeMiningDiv = newDiv;
345   }
346 
347   // handle incoming ERC223 tokens
348   function tokenFallback(address from, uint value, bytes data) public {
349     // depending on length of data
350     // this should be either an order creating transaction
351     // or an order taking transaction
352     // or a transaction allocating tokens for trade mining
353     if (data.length == 0 && msg.sender == saturnToken) {
354       _topUpTradeMining(value);
355     } else if (data.length == 84) {
356       _newOrder(from, msg.sender, data.toAddress(64), value, data.toUint(0), data.toUint(32), etherAddress);
357     } else if (data.length == 104) {
358       _newOrder(from, msg.sender, data.toAddress(64), value, data.toUint(0), data.toUint(32), data.toAddress(84));
359     } else if (data.length == 32) {
360       _executeOrder(from, data.toUint(0), msg.sender, value);
361     } else {
362       // unknown payload!
363       revert();
364     }
365   }
366 
367   function sellEther(
368     address buyToken,
369     uint256 priceMul,
370     uint256 priceDiv
371   ) public payable returns(uint256 orderId) {
372     require(msg.value > 0);
373     return _newOrder(msg.sender, etherAddress, buyToken, msg.value, priceMul, priceDiv, etherAddress);
374   }
375 
376   function sellEtherWithRing(
377     address buyToken,
378     uint256 priceMul,
379     uint256 priceDiv,
380     address ring
381   ) public payable returns(uint256 orderId) {
382     require(msg.value > 0);
383     return _newOrder(msg.sender, etherAddress, buyToken, msg.value, priceMul, priceDiv, ring);
384   }
385 
386   function buyOrderWithEth(uint256 orderId) public payable {
387     require(msg.value > 0);
388     _executeOrder(msg.sender, orderId, etherAddress, msg.value);
389   }
390 
391   function sellERC20Token(
392     address sellToken,
393     address buyToken,
394     uint256 amount,
395     uint256 priceMul,
396     uint256 priceDiv
397   ) public returns(uint256 orderId) {
398     require(amount > 0);
399     uint256 pulledAmount = pullTokens(sellToken, amount);
400     return _newOrder(msg.sender, sellToken, buyToken, pulledAmount, priceMul, priceDiv, etherAddress);
401   }
402 
403   function sellERC20TokenWithRing(
404     address sellToken,
405     address buyToken,
406     uint256 amount,
407     uint256 priceMul,
408     uint256 priceDiv,
409     address ring
410   ) public returns(uint256 orderId) {
411     require(amount > 0);
412     uint256 pulledAmount = pullTokens(sellToken, amount);
413     return _newOrder(msg.sender, sellToken, buyToken, pulledAmount, priceMul, priceDiv, ring);
414   }
415 
416   function buyOrderWithERC20Token(
417     uint256 orderId,
418     address token,
419     uint256 amount
420   ) public {
421     require(amount > 0);
422     require(pullTokens(token, amount) > 0);
423     _executeOrder(msg.sender, orderId, token, amount);
424   }
425 
426   function cancelOrder(uint256 orderId) public nonReentrant {
427     Order storage order = orderBook[orderId];
428     require(order.amount > 0);
429     require(order.active);
430     require(msg.sender == order.owner);
431 
432     balances[msg.sender][order.sellToken] = balances[msg.sender][order.sellToken].sub(order.amount);
433     require(sendTokensTo(order.owner, order.amount, order.sellToken));
434 
435     // deleting the order refunds the caller some gas
436     // this also sets order.active to false
437     delete orderBook[orderId];
438     emit OrderCancelled(orderId, now);
439   }
440 
441   /////////////////////
442   // private methods //
443   /////////////////////
444 
445   function _newOrder(
446     address owner,
447     address sellToken,
448     address buyToken,
449     uint256 amount,
450     uint256 priceMul,
451     uint256 priceDiv,
452     address ring
453   ) private nonReentrant returns(uint256 orderId) {
454     /////////////////////////
455     // step 1. validations //
456     /////////////////////////
457     require(amount > 0);
458     require(priceMul > 0);
459     require(priceDiv > 0);
460     require(sellToken != buyToken);
461     ///////////////////////////////
462     // step 2. Update order book //
463     ///////////////////////////////
464     orderId = orderCount++;
465     orderBook[orderId] = Order(owner, true, sellToken, buyToken, ring, amount, priceMul, priceDiv);
466     balances[owner][sellToken] = balances[owner][sellToken].add(amount);
467 
468     emit NewOrder(orderId, owner, sellToken, buyToken, ring, amount, priceMul, priceDiv, now);
469   }
470 
471   function _executeBuyOrder(address trader, uint256 orderId, uint256 buyTokenAmount) private returns(uint256) {
472     // buytoken: tkn
473     // selltoken: ether
474     Order storage order = orderBook[orderId];
475     uint256 sellTokenAmount = buyTokenAmount.mul(order.priceMul).div(order.priceDiv);
476     uint256 fees = sellTokenAmount.mul(feeMul).div(feeDiv);
477 
478     require(sellTokenAmount > 0);
479     require(sellTokenAmount <= order.amount);
480     order.amount = order.amount.sub(sellTokenAmount);
481     // send tokens to order owner
482     require(sendTokensTo(order.owner, buyTokenAmount, order.buyToken));
483     // send ether to trader
484     require(sendTokensTo(trader, sellTokenAmount.sub(fees), order.sellToken));
485 
486     emit Trade(trader, order.owner, orderId, sellTokenAmount.sub(fees), buyTokenAmount, fees, now);
487     return fees;
488   }
489 
490   function _executeSellOrder(address trader, uint256 orderId, uint256 buyTokenAmount) private returns(uint256) {
491     // buytoken: ether
492     // selltoken: tkn
493     Order storage order = orderBook[orderId];
494     uint256 fees = buyTokenAmount.mul(feeMul).div(feeDiv);
495     uint256 sellTokenAmount = buyTokenAmount.sub(fees).mul(order.priceMul).div(order.priceDiv);
496 
497 
498     require(sellTokenAmount > 0);
499     require(sellTokenAmount <= order.amount);
500     order.amount = order.amount.sub(sellTokenAmount);
501     // send ether to order owner
502     require(sendTokensTo(order.owner, buyTokenAmount.sub(fees), order.buyToken));
503     // send token to trader
504     require(sendTokensTo(trader, sellTokenAmount, order.sellToken));
505 
506     emit Trade(trader, order.owner, orderId, sellTokenAmount, buyTokenAmount.sub(fees), fees, now);
507     return fees;
508   }
509 
510   function _executeTokenSwap(address trader, uint256 orderId, uint256 buyTokenAmount) private returns(uint256) {
511     // no ether was exchanged
512     Order storage order = orderBook[orderId];
513     uint256 sellTokenAmount = buyTokenAmount.mul(order.priceMul).div(order.priceDiv);
514 
515     require(sellTokenAmount > 0);
516     require(sellTokenAmount <= order.amount);
517     order.amount = order.amount.sub(sellTokenAmount);
518 
519     require(sendTokensTo(order.owner, buyTokenAmount, order.buyToken));
520     require(order.active);
521     require(sendTokensTo(trader, sellTokenAmount, order.sellToken));
522 
523     emit Trade(trader, order.owner, orderId, sellTokenAmount, buyTokenAmount, 0, now);
524     return 0;
525   }
526 
527   function _executeOrder(address trader, uint256 orderId, address buyToken, uint256 buyTokenAmount) private nonReentrant {
528     /////////////////////////
529     // step 0. validations //
530     /////////////////////////
531     require(orderId < orderCount);
532     require(buyTokenAmount > 0);
533     Order storage order = orderBook[orderId];
534     require(order.active);
535     require(trader != order.owner);
536     require(buyToken == order.buyToken);
537 
538     // enforce exclusivity
539     if (order.ring != etherAddress) { require(order.ring == tx.origin); }
540 
541     ////////////////////////////
542     // step 1. token exchange //
543     ////////////////////////////
544     uint256 fees;
545     if (order.sellToken == etherAddress) {
546       // buy order: taker sends ether, gets tokens
547       fees = _executeBuyOrder(trader, orderId, buyTokenAmount);
548     } else if (order.buyToken == etherAddress) {
549       // sell order: taker sends tokens, gets ether
550       fees = _executeSellOrder(trader, orderId, buyTokenAmount);
551     } else {
552       fees = _executeTokenSwap(trader, orderId, buyTokenAmount);
553     }
554 
555     ////////////////////////////
556     // step 2. fees & wrap up //
557     ////////////////////////////
558     // collect fees and issue trade mining
559     require(_tradeMiningAndFees(fees, trader));
560     // deleting the order refunds the caller some gas
561     if (orderBook[orderId].amount == 0) {
562       delete orderBook[orderId];
563       emit OrderFulfilled(orderId, now);
564     }
565   }
566 
567   function _tradeMiningAndFees(uint256 fees, address trader) private returns(bool) {
568     if (fees == 0) { return true; }
569     // step one: send fees to the treasury
570     require(sendTokensTo(treasury, fees, etherAddress));
571     if (tradeMiningBalance == 0) { return true; }
572 
573     // step two: calculate reward
574     uint256 tokenAmount = fees.mul(tradeMiningMul).div(tradeMiningDiv);
575     if (tokenAmount == 0) { return true; }
576     if (tokenAmount > tradeMiningBalance) { tokenAmount = tradeMiningBalance; }
577 
578     // account for sent tokens
579     tradeMiningBalance = tradeMiningBalance.sub(tokenAmount);
580     // step three: send the reward to the trader
581     require(sendTokensTo(trader, tokenAmount, saturnToken));
582     emit Mined(trader, tokenAmount, now);
583     return true;
584   }
585 
586   function sendTokensTo(
587     address destination,
588     uint256 amount,
589     address tkn
590   ) private returns(bool) {
591     if (tkn == etherAddress) {
592       destination.transfer(amount);
593     } else {
594       // works with both ERC223 and ERC20
595       ERC20(tkn).transfer(destination, amount);
596     }
597     return true;
598   }
599 
600   // ERC20 fixture
601   function pullTokens(address token, uint256 amount) private nonReentrant returns(uint256) {
602     ERC20 tkn = ERC20(token);
603     // need to do this balance dance in order to account for deflationary tokens
604     uint256 balanceBefore = tkn.balanceOf(address(this));
605     tkn.transferFrom(msg.sender, address(this), amount);
606     uint256 balanceAfter = tkn.balanceOf(address(this));
607     return balanceAfter.sub(balanceBefore);
608   }
609 
610   function _topUpTradeMining(uint256 amount) private returns(bool) {
611     tradeMiningBalance = tradeMiningBalance.add(amount);
612     return true;
613   }
614 }