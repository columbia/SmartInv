1 pragma solidity ^ 0.4.24;
2 
3 contract CFG {
4 	event BuyHistory(
5 		address indexed addr,
6 		uint256 value
7 	);
8 	
9 	event RenewHistory(
10 		address indexed addr,
11 		uint256 value
12 	);
13 	
14 	event Rescission(
15 		address indexed addr
16 	);
17 	
18 	event BalancetHistory(
19 		address indexed addr,
20 		uint256 value,
21 		bool isin,
22 		string t
23 	);
24 	
25 	event ExchangeHistory(
26 		address indexed addr,
27 		uint256 price,
28 		uint256 value,
29 		uint256 cfg
30 	);
31 	
32 	event SuperPointHistory(
33 		address indexed addr
34 	);
35 }
36 
37 contract CFGContract is CFG {
38 	using SafeMath
39 	for * ;
40 
41 	address public manager;
42 	
43 	uint256 public PERIOD = 864000;
44 	
45 	uint256 public MIN = 1000000000000000000;
46 	
47 	uint256 public MAX = 39000000000000000000;
48 	
49 	address private COM = 0x9Dd7ae0FB7AF52954E709aA77F5541C3ddcF383C;
50 	
51 	address private FUND = 0x96eEeB683440c4e5dc5aDD76657fc98edc5B6706;
52 	
53 	address private ORI = 0x91819cF3ba30039D1f1f7FD0A0cb7273022FC1c9;
54 	
55 	uint256 public consume = 0;
56 	
57 	mapping (address => CFGDatasets.PlayerData) public player;
58 	
59 	mapping (address => CFGDatasets.PlayerContractData[]) public pcontract;
60 	
61 	mapping (address => mapping (uint256 => mapping (uint256 => bool))) public isbonus;
62 	
63 	mapping (address => mapping (uint256 => bool)) public ispbonus;
64 	
65 	CFGInterface constant private cfgtoken = CFGInterface(0x715a9405944c7e8b6b74374b8eabbb2260eba195);
66 
67 	uint256 public superPointCount = 0;
68 	
69 	uint256 public superPointTotalSupply = 200;
70 	
71 	mapping (address => bool) public spoint;
72 	
73 	uint256 public rankingId = 0;
74 	mapping (uint256 => uint256) public rankingTotal;
75 	
76 	uint256 public gas = 50000000000000;
77 	uint256 public bonusGas = 150000000000000;
78 	
79 	function CFGContract() {
80 		manager = msg.sender;
81 	}
82 	
83 	function()
84 	public
85 	payable {
86 		
87 	}
88 	
89 	function exchange()
90 	public
91 	payable {
92 		uint256 _price = getPrice();
93 		
94 		uint256 _cfg = msg.value.mul(1000000000000000000)/_price;
95 		
96 		require(cfgtoken.transfer(msg.sender,_cfg), "error");
97 		
98 		FUND.transfer(msg.value);
99 		
100 		emit ExchangeHistory(
101 			msg.sender,
102 			_price,
103 			msg.value,
104 			_cfg
105 		);
106 		
107 	}
108 	
109 	function superpoint()
110 	public
111 	payable {
112 		require(superPointCount < superPointTotalSupply, "The number of superpoint is full.");
113 		
114 		require(!spoint[msg.sender], "You have been a superpoint.");
115 		
116 		if(superPointCount >= 100){
117 			require(msg.value == 100000000000000000000, "The payment amount is mismatch.");
118 		}else if(superPointCount >= 50){
119 			require(msg.value == 50000000000000000000, "The payment amount is mismatch.");
120 		}else if(superPointCount >= 20){
121 			require(msg.value == 30000000000000000000, "The payment amount is mismatch.");
122 		}else{
123 			require(msg.value == 15000000000000000000, "The payment amount is mismatch.");
124 		}
125 		
126 		spoint[msg.sender] = true;
127 		
128 		superPointCount = superPointCount.add(1);
129 		
130 		COM.transfer(msg.value);
131 		
132 		emit SuperPointHistory(
133 			msg.sender
134 		);
135 	}
136 	
137 	function buy(address _aff)
138 	public
139 	payable {
140 		require(msg.value == (msg.value/1000000000000000000).mul(1000000000000000000), "Please enter an integer.");
141 
142 		require(msg.value >= MIN, "The minimum quantity is 1.");
143 		
144 		require(msg.value <= MAX, "The maximum quantity is 39.");
145 		
146 		if(player[msg.sender].aff == address(0)){
147 			if(_aff == 0x0 || _aff == msg.sender || player[_aff].aff == address(0)){
148 				_aff = ORI;
149 			}
150 			player[msg.sender].aff = _aff;
151 		}else{
152 			uint256 _index = pcontract[msg.sender].length.sub(1);
153 			
154 			require(msg.value >= pcontract[msg.sender][_index].value, "The quantity must be more than the last contract.");
155 			
156 			require(pcontract[msg.sender][_index].isrescission,"The current contract hasn't been released.");
157 		}
158 		
159 		uint256 _cfg = msg.value.mul(10000000000000000)/getPrice();
160 		
161 		require(cfgtoken.balanceOf(msg.sender) >= _cfg, "You don't have enough CFG.");
162 		
163 		require(cfgtoken.consume(msg.sender,_cfg), "consume error.");
164 		
165 		consume = consume.add(_cfg);
166 		
167 		address _paddr = getSuperPointAddr(msg.sender);
168 		
169 		pcontract[msg.sender].push(CFGDatasets.PlayerContractData(now,msg.value,false,false,_paddr));
170 		
171 		COM.transfer(msg.value.mul(4)/100);
172 		
173 		emit BuyHistory(
174 			msg.sender,
175 			msg.value
176 		);
177 	}
178 	
179 	function renew()
180 	public
181 	payable {
182 		require(msg.value <= MAX, "The maximun quantity is 39.");
183 		
184 		require(msg.value == (msg.value/1000000000000000000).mul(1000000000000000000), "Please enter an integer.");
185 		
186 		uint256 _index = pcontract[msg.sender].length.sub(1);
187 		
188 		require(!pcontract[msg.sender][_index].isrescission, "The contract has been released, you can't renew the contract.");
189 		
190 		uint256 _time = now;
191 		require(pcontract[msg.sender][_index].time.add(PERIOD) <= _time, "The contract is unexpired, you can't renew the contract.");
192 		
193 		require(msg.value >= pcontract[msg.sender][_index].value, "The quantity must be more than the original.");
194 		
195 		uint256 _cfg = msg.value.mul(10000000000000000)/getPrice();
196 		
197 		require(cfgtoken.balanceOf(msg.sender) >= _cfg, "You don't have enough CFG.");
198 		
199 		require(cfgtoken.consume(msg.sender,_cfg), "consume error.");
200 		
201 		consume = consume.add(_cfg);
202 		
203 		uint256 _income = 0;
204 		uint256 _value = pcontract[msg.sender][_index].value;
205 		if(!pcontract[msg.sender][_index].iswithdraw){
206 			_income = _value;
207 		}
208 		if(_value >= 31000000000000000000){
209 			_income = _income.add(_value.mul(1450)/10000);
210 		}else if(_value >= 21000000000000000000){
211 			_income = _income.add(_value.mul(1250)/10000);
212 		}else if(_value >= 11000000000000000000){
213 			_income = _income.add(_value.mul(1050)/10000);
214 		}else if(_value >= 6000000000000000000){
215 			_income = _income.add(_value.mul(950)/10000);
216 		}else{
217 			_income = _income.add(_value.mul(750)/10000);
218 		}
219 		player[msg.sender].balance = player[msg.sender].balance.add(_income);
220 		
221 		address _paddr = getSuperPointAddr(msg.sender);
222 		
223 		pcontract[msg.sender].push(CFGDatasets.PlayerContractData(_time,msg.value,false,false,_paddr));
224 		
225 		rankingTotal[rankingId] = rankingTotal[rankingId].add(_value);
226 		
227 		COM.transfer(msg.value.mul(4)/100);
228 		
229 		emit RenewHistory(
230 			msg.sender,
231 			msg.value
232 		);
233 		emit BalancetHistory(
234 			msg.sender,
235 			_income,
236 			true,
237 			"renew"
238 		);
239 	}
240 	
241 	function getSuperPointAddr(address _addr)
242 	private
243 	returns(address){
244 		if(spoint[_addr]){
245 			return _addr;
246 		}else{
247 			address _aff = player[msg.sender].aff;
248 			address _paddr = address(0);
249 			while(_aff != address(0)){
250 				if(spoint[_aff]){
251 					_paddr = _aff;
252 					_aff = address(0);
253 				}else{
254 					_aff = player[_aff].aff;
255 				}
256 			}
257 			return _paddr;
258 		}
259 	}
260 	
261 	function rescission()
262 	public {
263 		uint256 _index = pcontract[msg.sender].length.sub(1);
264 		
265 		uint256 _time = now;
266 		require(pcontract[msg.sender][_index].time.add(PERIOD) >= _time, "The contract has been expired.");
267 		
268 		uint256 _income = pcontract[msg.sender][_index].value.mul(90)/100;
269 		player[msg.sender].balance = player[msg.sender].balance.add(_income);
270 		
271 		pcontract[msg.sender][_index].isrescission = true;
272 		pcontract[msg.sender][_index].iswithdraw = true;
273 		
274 		emit Rescission(
275 			msg.sender
276 		);
277 		emit BalancetHistory(
278 			msg.sender,
279 			_income,
280 			true,
281 			"rescission"
282 		);
283 	}
284 	
285 	function withdraw()
286 	public {
287 		uint256 _index = pcontract[msg.sender].length.sub(1);
288 		
289 		uint256 _value = player[msg.sender].balance;
290 		if(!pcontract[msg.sender][_index].isrescission 
291 			&& pcontract[msg.sender][_index].time.add(PERIOD) <= now
292 			&& !pcontract[msg.sender][_index].iswithdraw){
293 			_value = _value.add(pcontract[msg.sender][_index].value);
294 			
295 			pcontract[msg.sender][_index].iswithdraw = true;
296 		}
297 		
298 		require(_value > 0, "The balance is 0.");
299 		
300 		if(player[msg.sender].balance > 0){
301 			player[msg.sender].balance = 0;
302 		}
303 		
304 		_value = _value.add(gas);
305 		
306 		msg.sender.transfer(_value);
307 		
308 		emit BalancetHistory(
309 			msg.sender,
310 			_value,
311 			false,
312 			"withdraw"
313 		);
314 	}
315 	
316 	function withdrawBonuss(address[] _addrs,uint256[] _indexs,uint256[] _genNums,uint256[] _myIndexs,uint8[] _types)
317 	public {
318 		require(_addrs.length == _indexs.length, "array error 1.");
319 		require(_addrs.length == _genNums.length, "array error 2.");
320 		require(_addrs.length == _myIndexs.length, "array error 3.");
321 		require(_addrs.length == _types.length, "array error 4.");
322 
323 		uint256 _value = 0;
324 		for(uint256 i = 0; i < _addrs.length;i++){
325 			if(_types[i] == 1){
326 				_value = _value.add(bonus(_addrs[i], _indexs[i], _genNums[i],_myIndexs[i]));
327 				isbonus[_addrs[i]][_indexs[i]][_genNums[i]] = true;
328 			}else{
329 				_value = _value.add(pbonus(_addrs[i], _indexs[i], _myIndexs[i]));
330 				ispbonus[_addrs[i]][_indexs[i]] = true;
331 			}
332 			
333 		}
334 		
335 		_value = _value.add(bonusGas);
336 		
337 		msg.sender.transfer(_value);
338 		emit BalancetHistory(
339 			msg.sender,
340 			_value,
341 			true,
342 			"bonus"
343 		);
344 	}
345 	
346 	function withdrawBonus(address _addr,uint256 _index,uint256 _genNum,uint256 _myIndex,uint8 _type)
347 	public{
348 		uint256 _value = 0;
349 		if(_type == 1){
350 			_value = bonus(_addr, _index, _genNum,_myIndex);
351 			isbonus[_addr][_index][_genNum] = true;
352 		}else{
353 			_value = pbonus(_addr, _index, _myIndex);
354 			ispbonus[_addr][_index] = true;
355 		}
356 		
357 		msg.sender.transfer(_value);
358 		emit BalancetHistory(
359 			msg.sender,
360 			_value,
361 			true,
362 			"bonus"
363 		);
364 	}
365 	
366 	function bonus(address _addr,uint256 _index,uint256 _genNum,uint256 _myIndex)
367 	private 
368 	returns(uint256){
369 		require(!pcontract[msg.sender][_myIndex].isrescission, "The contract has been released 1.");
370 		
371 		require(!pcontract[_addr][_index].isrescission, "The contract has been released 2.");
372 		
373 		require(!isbonus[_addr][_index][_genNum], "The dividend has been withdraw.");
374 		
375 		require(_index < pcontract[_addr].length.sub(1), "contract error 1.");
376 		
377 		require(pcontract[msg.sender][_myIndex].time <= pcontract[_addr][_index].time, "contract error 2.");
378 		
379 		require(pcontract[msg.sender][_myIndex.add(1)].time >= pcontract[_addr][_index].time, "contract error 3.");
380 		
381 		uint256 _value = pcontract[_addr][_index].value;
382 		uint256 _myValue = pcontract[msg.sender][_myIndex].value;
383 		uint256 _genValue = _myValue > _value ? _value : _myValue;
384 		uint256 _genLevel = 0;
385 		uint256 _earnings = 0;
386 		if(_genValue >= 31000000000000000000){
387 			_genLevel = 20;
388 			_earnings = _value.mul(1450)/10000;
389 		}else if(_genValue >= 21000000000000000000){
390 			_genLevel = 15;
391 			_earnings = _value.mul(1250)/10000;
392 		}else if(_genValue >= 11000000000000000000){
393 			_genLevel = 9;
394 			_earnings = _value.mul(1050)/10000;
395 		}else if(_genValue >= 6000000000000000000){
396 			_genLevel = 6;
397 			_earnings = _value.mul(950)/10000;
398 		}else{
399 			_genLevel = 3;
400 			_earnings = _value.mul(750)/10000;
401 		}
402 		
403 		require(_genLevel >= _genNum, "you can't get the bonus.");
404 		
405 		for(uint256 j = 0; j < _genNum; j++){
406 			_addr = player[_addr].aff;
407 		}
408 		require(_addr == msg.sender, "not yours.");
409 		
410 		if(_genNum == 1){
411 			return _earnings;
412 		}else if(_genNum == 2){
413 			return _earnings.mul(20)/100;
414 		}else if(_genNum == 3){
415 			return _earnings.mul(10)/100;
416 		}else if(_genNum > 3 && _genNum <= 10){
417 			return _earnings.mul(5)/100;
418 		}else{
419 			return _earnings.mul(2)/100;
420 		}
421 	}
422 	
423 	function pbonus(address _addr,uint256 _index,uint256 _myIndex)
424 	private 
425 	returns(uint256){
426 		require(!pcontract[msg.sender][_myIndex].isrescission, "p:The contract has been released.");
427 		
428 		require(!pcontract[_addr][_index].isrescission, "p: contract has been released.");
429 		
430 		require(!ispbonus[_addr][_index], "p:The dividend has been withdraw.");
431 		
432 		require(_index < pcontract[_addr].length.sub(1), "p:contract error 1.");
433 		 
434 		require(pcontract[msg.sender][_myIndex].time <= pcontract[_addr][_index].time, "p:contract error 2.");
435 		
436 		require(pcontract[msg.sender][_myIndex.add(1)].time >= pcontract[_addr][_index].time, "p:contract error 3.");
437 
438 		require(pcontract[_addr][_index].paddr == msg.sender, "p:not yours.");
439 		
440 		return pcontract[_addr][_index].value.mul(5)/100;
441 	}
442 	
443 	function updateSuperPoint(uint256 _superPointTotalSupply)
444 	public{
445 		require(manager == msg.sender, "error");
446 		superPointTotalSupply = _superPointTotalSupply;
447 	}
448 	
449 	function updateGas(uint256 _gas,uint256 _bonusGas)
450 	public{
451 		require(manager == msg.sender, "error");
452 		require(_gas < 10000000000000000, "error");
453 		require(_gas > 10000000000000, "error");
454 		require(_bonusGas >= 0, "error");
455 		require(_bonusGas >= 0, "error");
456 		gas = _gas;
457 		bonusGas = _bonusGas;
458 	}
459 	
460 	function uploadRanking(address[] _addrs,uint256[] _ratios)
461 	public{
462 		require(manager == msg.sender, "error 1");
463 		require(_addrs.length == _ratios.length, "error 2");
464 		
465 		uint256 _total = 0;
466 		for(uint256 j = 0; j < _ratios.length; j++){
467 			_total = _total.add(_ratios[j]);
468 		}
469 		uint256 _rankingTotal = rankingTotal[rankingId].mul(3)/100;
470 		for(uint256 i = 0; i < _addrs.length; i++){
471 			require(spoint[_addrs[i]], "error");
472 			uint256 _value = _rankingTotal.mul(_ratios[i])/_total;
473 //			player[_addrs[i]].balance = player[_addrs[i]].balance.add(_value);
474 			_addrs[i].transfer(_value);
475 			emit BalancetHistory(
476 				_addrs[i],
477 				_value,
478 				true,
479 				"ranking"
480 			);
481 		}
482 		rankingId = rankingId.add(1);
483 		
484 	}
485 	
486 	function balanceOf(address _addr)
487 	public
488 	view
489 	returns(uint256) {
490 		if(pcontract[_addr].length == 0){
491 			return 0;
492 		}
493 		uint256 _value = player[_addr].balance;
494 		uint256 _index = pcontract[_addr].length.sub(1);
495 		if(!pcontract[_addr][_index].isrescission
496 			&& pcontract[_addr][_index].time.add(PERIOD) <= now
497 			&& !pcontract[_addr][_index].iswithdraw){
498 			_value = _value.add(pcontract[_addr][_index].value);
499 		}
500 		return _value;
501 	}
502 	
503 	function getPrice()
504 	public
505 	view
506 	returns(uint256){
507 		uint256 _price = 1000000000000000;
508 		
509 		if(consume >= 1000000000000000000000000){
510 			uint256 _count = consume/1000000000000000000000000;
511 			for(uint256 i = 0; i < _count; i++ ){
512 				_price = _price.add(_price/10);
513 			}
514 		}
515 		return _price;
516 	}
517 	
518 	function getPointMsg()
519 	public
520 	view
521 	returns(uint256,uint256,uint256){
522 		uint256 _price = 0;
523 		if(superPointCount >= 100){
524 			_price = 100000000000000000000;
525 		}else if(superPointCount >= 50){
526 			_price = 50000000000000000000;
527 		}else if(superPointCount >= 20){
528 			_price = 30000000000000000000;
529 		}else{
530 			_price = 15000000000000000000;
531 		}
532 		return(superPointCount,_price,superPointTotalSupply);
533 	}
534 	
535 	function getTotal()
536 	public
537 	view
538 	returns(uint256){
539 		return rankingTotal[rankingId];
540 	}
541 	
542 }
543 
544 interface CFGInterface {
545 	
546 	function balanceOf(address _addr) returns(uint256);
547 
548 	function transfer(address _to, uint256 _value) returns(bool);
549 
550 	function approve(address _spender, uint256 _value) returns(bool);
551 
552 	function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
553 	
554 	function consume(address _from,uint256 _value) returns(bool success);
555 }
556 
557 library CFGDatasets{
558 	
559 	struct PlayerData{
560 		uint256 balance;
561 		address aff;
562 	}
563 	
564 	struct PlayerContractData{
565 		uint256 time;
566 		uint256 value;
567 		bool iswithdraw;
568 		bool isrescission;
569 		address paddr;
570 	}
571 	
572 }
573 
574 library SafeMath {
575 
576 	function mul(uint256 a, uint256 b)
577 	internal
578 	pure
579 	returns(uint256 c) {
580 		if(a == 0) {
581 			return 0;
582 		}
583 		c = a * b;
584 		require(c / a == b, "mul failed");
585 		return c;
586 	}
587 	
588 	function sub(uint256 a, uint256 b)
589 	internal
590 	pure
591 	returns(uint256 c) {
592 		require(b <= a, "sub failed");
593 		c = a - b;
594 		require(c <= a, "sub failed");
595 		return c;
596 	}
597 
598 	function add(uint256 a, uint256 b)
599 	internal
600 	pure
601 	returns(uint256 c) {
602 		c = a + b;
603 		require(c >= a, "add failed");
604 		return c;
605 	}
606 
607 }