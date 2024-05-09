1 pragma solidity ^0.4.21;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 library IterableMapping
16 {
17   struct itmap
18   {
19     mapping(address => IndexValue) data;
20     KeyFlag[] keys;
21     uint size;
22   }
23   struct IndexValue { uint keyIndex; uint256 value; }
24   struct KeyFlag { address key; bool deleted; }
25   function insert(itmap storage self, address key, uint256 value) returns (bool replaced)
26   {
27     uint keyIndex = self.data[key].keyIndex;
28     self.data[key].value = value;
29     if (keyIndex > 0)
30       return true;
31     else
32     {
33       keyIndex = self.keys.length++;
34       self.data[key].keyIndex = keyIndex + 1;
35       self.keys[keyIndex].key = key;
36       self.size++;
37       return false;
38     }
39   }
40   function remove(itmap storage self, address key) returns (bool success)
41   {
42     uint keyIndex = self.data[key].keyIndex;
43     if (keyIndex == 0)
44       return false;
45     delete self.data[key];
46     self.keys[keyIndex - 1].deleted = true;
47     self.size --;
48   }
49   function contains(itmap storage self, address key) returns (bool)
50   {
51     return self.data[key].keyIndex > 0;
52   }
53   function iterate_start(itmap storage self) returns (uint keyIndex)
54   {
55     return iterate_next(self, uint(-1));
56   }
57   function iterate_valid(itmap storage self, uint keyIndex) returns (bool)
58   {
59     return keyIndex < self.keys.length;
60   }
61   function iterate_next(itmap storage self, uint keyIndex) returns (uint r_keyIndex)
62   {
63     keyIndex++;
64     while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
65       keyIndex++;
66     return keyIndex;
67   }
68   function iterate_get(itmap storage self, uint keyIndex) returns (address key, uint256 value)
69   {
70     key = self.keys[keyIndex].key;
71     value = self.data[key].value;
72   }
73 }
74 
75 
76 
77 contract ExhibationLinkingCoin is ERC20Interface {
78 	
79 
80 	function totalSupply()public constant returns (uint) {
81 		return totalEXLCSupply;
82 	}
83 	
84 	function balanceOf(address tokenOwner)public constant returns (uint balance) {
85 		return balances[tokenOwner];
86 	}
87 
88 	function transfer(address to, uint tokens)public returns (bool success) {
89 		if (balances[msg.sender] >= tokens && tokens > 0 && balances[to] + tokens > balances[to]) {
90             if(lockedUsers[msg.sender].lockedTokens > 0){
91                 TryUnLockBalance(msg.sender);
92                 if(balances[msg.sender] - tokens < lockedUsers[msg.sender].lockedTokens)
93                 {
94                     return false;
95                 }
96             }
97             
98 			balances[msg.sender] -= tokens;
99 			balances[to] += tokens;
100 			emit Transfer(msg.sender, to, tokens);
101 			return true;
102 		} else {
103 			return false;
104 		}
105 	}
106 	
107 
108 	function transferFrom(address from, address to, uint tokens)public returns (bool success) {
109 		if (balances[from] >= tokens && allowed[from].data[to].value >= tokens && tokens > 0 && balances[to] + tokens > balances[to]) {
110             if(lockedUsers[from].lockedTokens > 0)
111             {
112                 TryUnLockBalance(from);
113                 if(balances[from] - tokens < lockedUsers[from].lockedTokens)
114                 {
115                     return false;
116                 }
117             }
118             
119 			balances[from] -= tokens;
120 			allowed[from].data[msg.sender].value -= tokens;
121 			balances[to] += tokens;
122 			return true;
123 		} else {
124 			return false;
125 		}
126 	}
127 	
128 	
129 	function approve(address spender, uint tokens)public returns (bool success) {
130 	    IterableMapping.insert(allowed[msg.sender], spender, tokens);
131 		return true;
132 	}
133 	
134 	function allowance(address tokenOwner, address spender)public constant returns (uint remaining) {
135 		return allowed[tokenOwner].data[spender].value;
136 	}
137 	
138 		
139     string public name = "ExhibationLinkingCoin";
140     string public symbol = "EXLC";
141     uint8 public decimals = 18;
142 	uint256 private totalEXLCSupply = 10000000000000000000000000000;
143 	uint256 private _totalBalance = totalEXLCSupply;
144 	
145 	struct LockUser{
146 	    uint256 lockedTokens;
147 	    uint lockedTime;
148 	    uint lockedIdx;
149 	}
150 	
151 	
152 	address public owner = 0x0;
153 	address public auther_user = 0x0;
154 	address public operater = 0x0;
155 	
156     mapping (address => uint256) balances;
157     mapping(address => IterableMapping.itmap) allowed;
158 
159 	mapping(address => LockUser) lockedUsers;
160 	
161 	
162  	uint  constant    private ONE_DAY_TIME_LEN = 86400;
163  	uint  constant    private ONE_YEAR_TIME_LEN = 946080000;
164 	uint32 private constant MAX_UINT32 = 0xFFFFFFFF;
165 	
166 
167 	uint256   public creatorsTotalBalance =    1130000000000000000000000000; 
168 	uint256   public jiGouTotalBalance =       1000000000000000000000000000;
169 	uint256   public icoTotalBalance =         1000000000000000000000000000;
170 	uint256   public mineTotalBalance =        2000000000000000000000000000;
171 	uint256   public marketorsTotalBalance =   685000000000000000000000000;
172 	uint256   public businessersTotalBalance = 685000000000000000000000000;
173 	uint256   public taskTotalBalance =        3500000000000000000000000000;
174 
175 	uint256   public mineBalance = 0;
176 	
177 	bool public isIcoStart = false;	
178 	bool public isIcoFinished = false;
179 	uint256 public icoPrice = 500000000000000000000000;
180 
181 	
182 	
183 	uint256[] public mineBalanceArry = new uint256[](30); 
184 	uint      public lastUnlockMineBalanceTime = 0;
185 	uint public dayIdx = 0;
186 	
187 	event SendTo(uint32 indexed _idx, uint8 indexed _type, address _from, address _to, uint256 _value);
188 	
189 	uint32 sendToIdx = 0;
190 	
191 	function safeToNextIdx() internal{
192         if (sendToIdx >= MAX_UINT32){
193 			sendToIdx = 1;
194 		}
195         else{
196 			sendToIdx += 1;
197 		}
198     }
199 
200     constructor() public {
201 		owner = msg.sender;
202 		mineBalanceArry[0] = 1000000000000000000000000;
203 		for(uint i=1; i<30; i++){
204 			mineBalanceArry[i] = mineBalanceArry[i-1] * 99 / 100;
205 		}
206 		mineBalance = taskTotalBalance;
207 		balances[owner] = mineBalance;
208 		lastUnlockMineBalanceTime = block.timestamp;
209     }
210 	
211 	
212 	function StartIco() public {
213 		if ((msg.sender != operater && msg.sender != auther_user && msg.sender != owner) || isIcoStart) 
214 		{
215 		    revert();
216 		}
217 		
218 		isIcoStart = true;
219 		isIcoFinished = false;		
220 	}
221 	
222 	function StopIco() public {
223 		if ((msg.sender != operater && msg.sender != auther_user && msg.sender != owner) || isIcoFinished) 
224 		{
225 		    revert();
226 		}
227 		
228 		balances[owner] += icoTotalBalance;
229 		icoTotalBalance = 0;
230 		
231 		isIcoStart = false;
232 		isIcoFinished = true;
233 	}
234 	
235 	function () public payable
236     {
237 		uint256 coin;
238 		
239 			if(isIcoFinished || !isIcoStart)
240 			{
241 				revert();
242 			}
243 		
244 			coin = msg.value * icoPrice / 1 ether;
245 			if(coin > icoTotalBalance)
246 			{
247 				revert();
248 			}
249 
250 			icoTotalBalance -= coin;
251 			_totalBalance -= coin;
252 			balances[msg.sender] += coin;
253 			
254 			emit Transfer(operater, msg.sender, coin);
255 			
256 			safeToNextIdx();
257 			emit SendTo(sendToIdx, 2, 0x0, msg.sender, coin);
258 		
259     }
260 
261 	
262 	function TryUnLockBalance(address target) public {
263 	    if(target == 0x0)
264 	    {
265 	        revert();
266 	    }
267 	    LockUser storage user = lockedUsers[target];
268 	    if(user.lockedIdx > 0 && user.lockedTokens > 0)
269 	    {
270 	        if(block.timestamp >= user.lockedTime)
271 	        {
272 	            if(user.lockedIdx == 1)
273 	            {
274 	                user.lockedIdx = 0;
275 	                user.lockedTokens = 0;
276 	            }
277 	            else
278 	            {
279 	                uint256 append = user.lockedTokens/user.lockedIdx;
280 	                user.lockedTokens -= append;
281         			user.lockedIdx--;
282         			user.lockedTime = block.timestamp + ONE_YEAR_TIME_LEN;
283         			lockedUsers[target] = user;
284 	            }
285 	        }
286 	    }
287 		
288 	}
289 	
290 	function QueryUnlockTime(address target) public constant returns (uint time) {
291 	    if(target == 0x0)
292 	    {
293 	        revert();
294 	    }
295 	    LockUser storage user = lockedUsers[target];
296 	    if(user.lockedIdx > 0 && user.lockedTokens > 0)
297 	    {
298 	        return user.lockedTime;
299 	    }
300 	    return 0x0;
301 	}
302 	
303 
304 	function miningEveryDay() public{
305 		if (msg.sender != operater && msg.sender != auther_user && msg.sender != owner) 
306 		{
307 		    revert();
308 		}
309 		uint day = uint((block.timestamp - lastUnlockMineBalanceTime) / ONE_DAY_TIME_LEN);
310 		if(day > 0){
311 			int max_while = 30;
312 			uint256 val;
313 			while(day > 0 && max_while > 0 && mineTotalBalance > 0){
314 				max_while--;
315 				day -= 1;
316 				dayIdx += 1;
317 				val = mineBalanceArry[(dayIdx/365) % 30];
318 				if(mineTotalBalance >= val)
319 				{
320 					mineBalance += val;
321 					mineTotalBalance -= val;
322 					balances[owner] += val;
323 				}
324 				else
325 				{
326 					mineBalance += mineTotalBalance;
327 					mineTotalBalance = 0;
328 					balances[owner] += mineTotalBalance;
329 					break;
330 				}
331 			}
332 			lastUnlockMineBalanceTime = block.timestamp;
333 		}
334 	}
335 
336 	
337 	function sendMinerByOwner(address _to, uint256 _value) public {
338 	
339 		if (msg.sender != operater && msg.sender != auther_user && msg.sender != owner) 
340 		{
341 		    revert();
342 		}
343 		
344 		if(_to == 0x0){
345 			revert();
346 		}
347 		
348 		
349 		if(_value > mineBalance){
350 			revert();
351 		}
352 		
353 		
354 		mineBalance -= _value;
355 		balances[owner] -= _value;
356 		balances[_to] += _value;
357 		_totalBalance -= _value;
358 		
359 		emit Transfer(msg.sender, _to, _value);
360 		
361 		safeToNextIdx();
362 		emit SendTo(sendToIdx, 3, owner, _to, _value);
363 	}
364 
365 	function sendICOByOwner(address _to, uint256 _value) public {
366 		if (msg.sender != operater && msg.sender != owner && msg.sender != auther_user) 
367 		{
368 		    revert();
369 		}
370 		
371 		if(_to == 0x0){
372 			revert();
373 		}
374 		
375 		if(!isIcoFinished && isIcoStart)
376 		{
377 			revert();
378 		}		
379 
380 		if(_value > icoTotalBalance){
381 			revert();
382 		}
383 
384 		icoTotalBalance -= _value;
385 		_totalBalance -= _value;
386 		balances[_to] += _value;
387 			
388 		emit Transfer(msg.sender, _to, _value);
389 			
390 		safeToNextIdx();
391 		emit SendTo(sendToIdx, 6, 0x0, _to, _value);
392 	
393 	}
394 	
395 	function sendCreatorByOwner(address _to, uint256 _value) public {
396 		if (msg.sender != operater && msg.sender != owner && msg.sender != auther_user) 
397 		{
398 		    revert();
399 		}
400 		
401 		if(_to == 0x0){
402 			revert();
403 		}
404 		
405 		if(_value > creatorsTotalBalance){
406 			revert();
407 		}
408 		
409 		
410 		creatorsTotalBalance -= _value;
411 		_totalBalance -= _value;
412 		balances[_to] += _value;
413 		LockUser storage lockUser = lockedUsers[_to];
414 		lockUser.lockedTime = block.timestamp + ONE_YEAR_TIME_LEN;
415 		lockUser.lockedTokens += _value;
416 		lockUser.lockedIdx = 2;
417 
418         lockedUsers[_to] = lockUser;
419 		
420 		emit Transfer(msg.sender, _to, _value);
421 		
422 		safeToNextIdx();
423 		emit SendTo(sendToIdx, 4, 0x0, _to, _value);
424 	}
425 
426 	function sendJigouByOwner(address _to, uint256 _value) public {
427 		if (msg.sender != operater && msg.sender != owner && msg.sender != auther_user) 
428 		{
429 		    revert();
430 		}
431 		
432 		if(_to == 0x0){
433 			revert();
434 		}
435 		
436 		if(_value > jiGouTotalBalance){
437 			revert();
438 		}
439 		
440 		
441 		jiGouTotalBalance -= _value;
442 		_totalBalance -= _value;
443 		balances[_to] += _value;
444 		LockUser storage lockUser = lockedUsers[_to];
445 		lockUser.lockedTime = block.timestamp + ONE_YEAR_TIME_LEN;
446 		lockUser.lockedTokens += _value;
447 		lockUser.lockedIdx = 1;
448 
449         lockedUsers[_to] = lockUser;
450 		
451 		emit Transfer(msg.sender, _to, _value);
452 		
453 		safeToNextIdx();
454 		emit SendTo(sendToIdx, 4, 0x0, _to, _value);
455 	}
456 	
457 	function sendMarketByOwner(address _to, uint256 _value) public {
458 	
459 		if (msg.sender != operater && msg.sender != owner && msg.sender != auther_user) 
460 		{
461 		    revert();
462 		}
463 		
464 		if(_to == 0x0){
465 			revert();
466 		}
467 		
468 		if(_value > marketorsTotalBalance){
469 			revert();
470 		}
471 		
472 		
473 		marketorsTotalBalance -= _value;
474 		_totalBalance -= _value;
475 		balances[_to] += _value;
476 		
477 		emit Transfer(msg.sender, _to, _value);
478 		
479 		safeToNextIdx();
480 		emit SendTo(sendToIdx, 7, 0x0, _to, _value);
481 	}
482 	
483 
484 	function sendBussinessByOwner(address _to, uint256 _value) public {
485 	
486 		if (msg.sender != operater && msg.sender != owner && msg.sender != auther_user) 
487 		{
488 		    revert();
489 		}
490 		
491 		if(_to == 0x0){
492 			revert();
493 		}
494 		
495 		if(_value > businessersTotalBalance){
496 			revert();
497 		}
498 		
499 		
500 		businessersTotalBalance -= _value;
501 		_totalBalance -= _value;
502 		balances[_to] += _value;
503 		
504 		emit Transfer(msg.sender, _to, _value);
505 		
506 		safeToNextIdx();
507 		emit SendTo(sendToIdx, 5, 0x0, _to, _value);
508 	}
509 	
510 	function Save() public {
511 		if (msg.sender != owner) {
512 		    revert();
513 		}
514 		owner.transfer(address(this).balance);
515     }
516 	
517 	
518 	function changeAutherOwner(address newOwner) public {
519 		if ((msg.sender != owner && msg.sender != auther_user) || newOwner == 0x0) 
520 		{
521 		    revert();
522 		}
523 		else
524 		{
525 		    if(msg.sender != owner)
526 		    {
527 		        balances[msg.sender] = balances[owner];
528 		        for (var i = IterableMapping.iterate_start(allowed[owner]); IterableMapping.iterate_valid(allowed[owner], i); i = IterableMapping.iterate_next(allowed[owner], i))
529                 {
530                     var (key, value) = IterableMapping.iterate_get(allowed[owner], i);
531                     IterableMapping.insert(allowed[msg.sender], key, value);
532                 }
533 			    balances[owner] = 0;
534 			    for (var j = IterableMapping.iterate_start(allowed[owner]); IterableMapping.iterate_valid(allowed[owner], j); j = IterableMapping.iterate_next(allowed[owner], j))
535                 {
536                     var (key2, value2) = IterableMapping.iterate_get(allowed[owner], j);
537                     IterableMapping.remove(allowed[owner], key2);
538                 }
539 		    }
540 			
541 			auther_user = newOwner;
542 			owner = msg.sender;
543 		}
544     }
545 	
546 	function destruct() public {
547 		if (msg.sender != owner) 
548 		{
549 		    revert();
550 		}
551 		else
552 		{
553 			selfdestruct(owner);
554 		}
555     }
556 	
557 	function setOperater(address op) public {
558 		if ((msg.sender != owner && msg.sender != auther_user && msg.sender != operater) || op == 0x0) 
559 		{
560 		    revert();
561 		}
562 		else
563 		{
564 			operater = op;
565 		}
566     }
567 }