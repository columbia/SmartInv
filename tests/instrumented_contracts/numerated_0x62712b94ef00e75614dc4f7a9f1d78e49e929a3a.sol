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
17     struct itmap
18     {
19         mapping(address => IndexValue) data;
20         KeyFlag[] keys;
21         uint size;
22         
23     }
24     struct IndexValue { uint keyIndex; uint256 value; }
25     struct KeyFlag { address key; bool deleted; }
26     function insert(itmap storage self, address key, uint256 value) returns (bool replaced)
27     {
28         uint keyIndex = self.data[key].keyIndex;
29         self.data[key].value = value;
30         if (keyIndex > 0)
31             return true;
32         else
33         {
34             keyIndex = self.keys.length++;
35             self.data[key].keyIndex = keyIndex + 1;
36             self.keys[keyIndex].key = key;
37             self.size++;
38             return false;
39         }
40     }
41     
42     function remove(itmap storage self, address key) returns (bool success)
43     {
44         uint keyIndex = self.data[key].keyIndex;
45         if (keyIndex == 0)
46             return false;
47         delete self.data[key];
48         self.keys[keyIndex - 1].deleted = true;
49         self.size --;
50     }
51     
52     function contains(itmap storage self, address key) returns (bool)
53     {
54         return self.data[key].keyIndex > 0;
55     }
56     
57     function iterate_start(itmap storage self) returns (uint keyIndex)
58     {
59         return iterate_next(self, uint(-1));
60     }
61     
62     function iterate_valid(itmap storage self, uint keyIndex) returns (bool)
63     {
64         return keyIndex < self.keys.length;
65     }
66     
67     function iterate_next(itmap storage self, uint keyIndex) returns (uint r_keyIndex)
68     {
69         keyIndex++;
70         while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
71             keyIndex++;
72         return keyIndex;
73     }
74     function iterate_get(itmap storage self, uint keyIndex) returns (address key, uint256 value)
75     {
76         key = self.keys[keyIndex].key;
77         value = self.data[key].value;
78     }
79 }
80 
81 
82 contract EXLINKCOIN is ERC20Interface {
83 	
84 
85 	function totalSupply()public constant returns (uint) {
86 		return totalEXLCSupply;
87 	}
88 	
89 	function balanceOf(address tokenOwner)public constant returns (uint balance) {
90 		return balances[tokenOwner];
91 	}
92 
93 	function transfer(address to, uint tokens)public returns (bool success) {
94 		if (balances[msg.sender] >= tokens && tokens > 0 && balances[to] + tokens > balances[to]) {
95             if(lockedUsers[msg.sender].lockedTokens > 0){
96                 TryUnLockBalance(msg.sender);
97                 if(balances[msg.sender] - tokens < lockedUsers[msg.sender].lockedTokens)
98                 {
99                     return false;
100                 }
101             }
102             
103 			balances[msg.sender] -= tokens;
104 			balances[to] += tokens;
105 			emit Transfer(msg.sender, to, tokens);
106 			return true;
107 		} else {
108 			return false;
109 		}
110 	}
111 	
112 
113 	function transferFrom(address from, address to, uint tokens)public returns (bool success) {
114 		if (balances[from] >= tokens && allowed[from].data[to].value >= tokens && tokens > 0 && balances[to] + tokens > balances[to]) {
115             if(lockedUsers[from].lockedTokens > 0)
116             {
117                 TryUnLockBalance(from);
118                 if(balances[from] - tokens < lockedUsers[from].lockedTokens)
119                 {
120                     return false;
121                 }
122             }
123             
124 			balances[from] -= tokens;
125 			allowed[from].data[msg.sender].value -= tokens;
126 			balances[to] += tokens;
127 			return true;
128 		} else {
129 			return false;
130 		}
131 	}
132 	
133 	
134 	function approve(address spender, uint tokens)public returns (bool success) {
135 	    IterableMapping.insert(allowed[msg.sender], spender, tokens);
136 		return true;
137 	}
138 	
139 	function allowance(address tokenOwner, address spender)public constant returns (uint remaining) {
140 		return allowed[tokenOwner].data[spender].value;
141 	}
142 	
143 		
144     string public name = "EXLINK COIN";
145     string public symbol = "EXLC";
146     uint8 public decimals = 18;
147 	uint256 private totalEXLCSupply = 10000000000000000000000000000;
148 	uint256 private _totalBalance = totalEXLCSupply;
149 	
150 	struct LockUser{
151 	    uint256 lockedTokens;
152 	    uint lockedTime;
153 	    uint lockedIdx;
154 	}
155 	
156 	
157 	address public owner = 0x0;
158 	address public auther_user = 0x0;
159 	address public operater = 0x0;
160 	
161     mapping (address => uint256) balances;
162     mapping(address => IterableMapping.itmap) allowed;
163 
164 	mapping(address => LockUser) lockedUsers;
165 	
166 	
167  	uint  constant    private ONE_DAY_TIME_LEN = 86400;
168  	uint  constant    private ONE_YEAR_TIME_LEN = 31536000;
169 	uint32 private constant MAX_UINT32 = 0xFFFFFFFF;
170 	
171 
172 	uint256   public creatorsTotalBalance =    1130000000000000000000000000; 
173 	uint256   public jiGouTotalBalance =       1000000000000000000000000000;
174 	uint256   public icoTotalBalance =         1000000000000000000000000000;
175 	uint256   public mineTotalBalance =        2000000000000000000000000000;
176 	uint256   public marketorsTotalBalance =   685000000000000000000000000;
177 	uint256   public businessersTotalBalance = 685000000000000000000000000;
178 	uint256   public taskTotalBalance =        3500000000000000000000000000;
179 
180 	uint256   public mineBalance = 0;
181 	
182 	bool public isIcoStart = false;	
183 	bool public isIcoFinished = false;
184 	uint256 public icoPrice = 500000000000000000000000;
185 
186 	
187 	
188 	uint256[] public mineBalanceArry = new uint256[](30); 
189 	uint      public lastUnlockMineBalanceTime = 0;
190 	uint public dayIdx = 0;
191 	
192 	event SendTo(uint32 indexed _idx, uint8 indexed _type, address _from, address _to, uint256 _value);
193 	
194 	uint32 sendToIdx = 0;
195 	
196 	function safeToNextIdx() internal{
197         if (sendToIdx >= MAX_UINT32){
198 			sendToIdx = 1;
199 		}
200         else
201         {
202 			sendToIdx += 1;
203 		}
204     }
205 
206     constructor() public {
207 		owner = msg.sender;
208 		mineBalanceArry[0] = 1000000000000000000000000;
209 		for(uint i=1; i<30; i++){
210 			mineBalanceArry[i] = mineBalanceArry[i-1] * 99 / 100;
211 		}
212 		mineBalance = taskTotalBalance;
213 		balances[owner] = mineBalance;
214 		lastUnlockMineBalanceTime = block.timestamp;
215     }
216 	
217 	
218 	function StartIco() public {
219 		if ((msg.sender != operater && msg.sender != auther_user && msg.sender != owner) || isIcoStart) 
220 		{
221 		    revert();
222 		}
223 		
224 		isIcoStart = true;
225 		isIcoFinished = false;		
226 	}
227 	
228 	function StopIco() public {
229 		if ((msg.sender != operater && msg.sender != auther_user && msg.sender != owner) || isIcoFinished) 
230 		{
231 		    revert();
232 		}
233 		
234 		balances[owner] += icoTotalBalance;
235 		icoTotalBalance = 0;
236 		
237 		isIcoStart = false;
238 		isIcoFinished = true;
239 	}
240 	
241 	function () public payable
242     {
243 		uint256 coin;
244 		
245 			if(isIcoFinished || !isIcoStart)
246 			{
247 				revert();
248 			}
249 		
250 			coin = msg.value * icoPrice / 1 ether;
251 			if(coin > icoTotalBalance)
252 			{
253 				revert();
254 			}
255 
256 			icoTotalBalance -= coin;
257 			_totalBalance -= coin;
258 			balances[msg.sender] += coin;
259 			
260 			emit Transfer(operater, msg.sender, coin);
261 			
262 			safeToNextIdx();
263 			emit SendTo(sendToIdx, 2, 0x0, msg.sender, coin);
264 		
265     }
266 
267 	
268 	function TryUnLockBalance(address target) public {
269 	    if(target == 0x0)
270 	    {
271 	        revert();
272 	    }
273 	    LockUser storage user = lockedUsers[target];
274 	    if(user.lockedIdx > 0 && user.lockedTokens > 0)
275 	    {
276 	        if(block.timestamp >= user.lockedTime)
277 	        {
278 	            if(user.lockedIdx == 1)
279 	            {
280 	                user.lockedIdx = 0;
281 	                user.lockedTokens = 0;
282 	            }
283 	            else
284 	            {
285 	                uint256 append = user.lockedTokens/user.lockedIdx;
286 	                user.lockedTokens -= append;
287         			user.lockedIdx--;
288         			user.lockedTime = block.timestamp + ONE_YEAR_TIME_LEN;
289         			lockedUsers[target] = user;
290 	            }
291 	        }
292 	    }
293 		
294 	}
295 	
296 	function QueryUnlockTime(address target) public constant returns (uint time) {
297 	    if(target == 0x0)
298 	    {
299 	        revert();
300 	    }
301 	    LockUser storage user = lockedUsers[target];
302 	    if(user.lockedIdx > 0 && user.lockedTokens > 0)
303 	    {
304 	        return user.lockedTime;
305 	    }
306 	    return 0x0;
307 	}
308 	
309 
310 	function miningEveryDay() public{
311 		if (msg.sender != operater && msg.sender != auther_user && msg.sender != owner) 
312 		{
313 		    revert();
314 		}
315 		uint day = uint((block.timestamp - lastUnlockMineBalanceTime) / ONE_DAY_TIME_LEN);
316 		if(day > 0){
317 			int max_while = 30;
318 			uint256 val;
319 			while(day > 0 && max_while > 0 && mineTotalBalance > 0){
320 				max_while--;
321 				day -= 1;
322 				dayIdx += 1;
323 				val = mineBalanceArry[(dayIdx/365) % 30];
324 				if(mineTotalBalance >= val)
325 				{
326 					mineBalance += val;
327 					mineTotalBalance -= val;
328 					balances[owner] += val;
329 				}
330 				else
331 				{
332 					mineBalance += mineTotalBalance;
333 					mineTotalBalance = 0;
334 					balances[owner] += mineTotalBalance;
335 					break;
336 				}
337 			}
338 			lastUnlockMineBalanceTime = block.timestamp;
339 		}
340 	}
341 
342 	
343 	function sendMinerByOwner(address _to, uint256 _value) public {
344 	
345 		if (msg.sender != operater && msg.sender != auther_user && msg.sender != owner) 
346 		{
347 		    revert();
348 		}
349 		
350 		if(_to == 0x0){
351 			revert();
352 		}
353 		
354 		
355 		if(_value > mineBalance){
356 			revert();
357 		}
358 		
359 		
360 		mineBalance -= _value;
361 		balances[owner] -= _value;
362 		balances[_to] += _value;
363 		_totalBalance -= _value;
364 		
365 		emit Transfer(msg.sender, _to, _value);
366 		
367 		safeToNextIdx();
368 		emit SendTo(sendToIdx, 3, owner, _to, _value);
369 	}
370 
371 	function sendICOByOwner(address _to, uint256 _value) public {
372 		if (msg.sender != operater && msg.sender != owner && msg.sender != auther_user) 
373 		{
374 		    revert();
375 		}
376 		
377 		if(_to == 0x0){
378 			revert();
379 		}
380 		
381 		if(!isIcoFinished && isIcoStart)
382 		{
383 			revert();
384 		}		
385 
386 		if(_value > icoTotalBalance){
387 			revert();
388 		}
389 
390 		icoTotalBalance -= _value;
391 		_totalBalance -= _value;
392 		balances[_to] += _value;
393 			
394 		emit Transfer(msg.sender, _to, _value);
395 			
396 		safeToNextIdx();
397 		emit SendTo(sendToIdx, 6, 0x0, _to, _value);
398 	
399 	}
400 	
401 	function sendCreatorByOwner(address _to, uint256 _value) public {
402 		if (msg.sender != operater && msg.sender != owner && msg.sender != auther_user) 
403 		{
404 		    revert();
405 		}
406 		
407 		if(_to == 0x0){
408 			revert();
409 		}
410 		
411 		if(_value > creatorsTotalBalance){
412 			revert();
413 		}
414 		
415 		
416 		creatorsTotalBalance -= _value;
417 		_totalBalance -= _value;
418 		balances[_to] += _value;
419 		LockUser storage lockUser = lockedUsers[_to];
420 		lockUser.lockedTime = block.timestamp + ONE_YEAR_TIME_LEN;
421 		lockUser.lockedTokens += _value;
422 		lockUser.lockedIdx = 2;
423 
424         lockedUsers[_to] = lockUser;
425 		
426 		emit Transfer(msg.sender, _to, _value);
427 		
428 		safeToNextIdx();
429 		emit SendTo(sendToIdx, 4, 0x0, _to, _value);
430 	}
431 
432 	function sendJigouByOwner(address _to, uint256 _value) public {
433 		if (msg.sender != operater && msg.sender != owner && msg.sender != auther_user) 
434 		{
435 		    revert();
436 		}
437 		
438 		if(_to == 0x0){
439 			revert();
440 		}
441 		
442 		if(_value > jiGouTotalBalance){
443 			revert();
444 		}
445 		
446 		
447 		jiGouTotalBalance -= _value;
448 		_totalBalance -= _value;
449 		balances[_to] += _value;
450 		LockUser storage lockUser = lockedUsers[_to];
451 		lockUser.lockedTime = block.timestamp + ONE_YEAR_TIME_LEN;
452 		lockUser.lockedTokens += _value;
453 		lockUser.lockedIdx = 1;
454 
455         lockedUsers[_to] = lockUser;
456 		
457 		emit Transfer(msg.sender, _to, _value);
458 		
459 		safeToNextIdx();
460 		emit SendTo(sendToIdx, 4, 0x0, _to, _value);
461 	}
462 	
463 	function sendMarketByOwner(address _to, uint256 _value) public {
464 	
465 		if (msg.sender != operater && msg.sender != owner && msg.sender != auther_user) 
466 		{
467 		    revert();
468 		}
469 		
470 		if(_to == 0x0){
471 			revert();
472 		}
473 		
474 		if(_value > marketorsTotalBalance){
475 			revert();
476 		}
477 		
478 		
479 		marketorsTotalBalance -= _value;
480 		_totalBalance -= _value;
481 		balances[_to] += _value;
482 		
483 		emit Transfer(msg.sender, _to, _value);
484 		
485 		safeToNextIdx();
486 		emit SendTo(sendToIdx, 7, 0x0, _to, _value);
487 	}
488 	
489 
490 	function sendBussinessByOwner(address _to, uint256 _value) public {
491 	
492 		if (msg.sender != operater && msg.sender != owner && msg.sender != auther_user) 
493 		{
494 		    revert();
495 		}
496 		
497 		if(_to == 0x0){
498 			revert();
499 		}
500 		
501 		if(_value > businessersTotalBalance){
502 			revert();
503 		}
504 		
505 		
506 		businessersTotalBalance -= _value;
507 		_totalBalance -= _value;
508 		balances[_to] += _value;
509 		
510 		emit Transfer(msg.sender, _to, _value);
511 		
512 		safeToNextIdx();
513 		emit SendTo(sendToIdx, 5, 0x0, _to, _value);
514 	}
515 	
516 	function Save() public {
517 		if (msg.sender != owner) {
518 		    revert();
519 		}
520 		owner.transfer(address(this).balance);
521     }
522 	
523 	
524 	function changeAutherOwner(address newOwner) public {
525 		if ((msg.sender != owner && msg.sender != auther_user) || newOwner == 0x0) 
526 		{
527 		    revert();
528 		}
529 		else
530 		{
531 		    if(msg.sender != owner)
532 		    {
533 		        balances[msg.sender] = balances[owner];
534 		        for (var i = IterableMapping.iterate_start(allowed[owner]); IterableMapping.iterate_valid(allowed[owner], i); i = IterableMapping.iterate_next(allowed[owner], i))
535                 {
536                     var (key, value) = IterableMapping.iterate_get(allowed[owner], i);
537                     IterableMapping.insert(allowed[msg.sender], key, value);
538                 }
539 			    balances[owner] = 0;
540 			    for (var j = IterableMapping.iterate_start(allowed[owner]); IterableMapping.iterate_valid(allowed[owner], j); j = IterableMapping.iterate_next(allowed[owner], j))
541                 {
542                     var (key2, value2) = IterableMapping.iterate_get(allowed[owner], j);
543                     IterableMapping.remove(allowed[owner], key2);
544                 }
545 		    }
546 			
547 			auther_user = newOwner;
548 			owner = msg.sender;
549 		}
550     }
551 	
552 	function destruct() public {
553 		if (msg.sender != owner) 
554 		{
555 		    revert();
556 		}
557 		else
558 		{
559 			selfdestruct(owner);
560 		}
561     }
562 	
563 	function setOperater(address op) public {
564 		if ((msg.sender != owner && msg.sender != auther_user && msg.sender != operater) || op == 0x0) 
565 		{
566 		    revert();
567 		}
568 		else
569 		{
570 			operater = op;
571 		}
572     }
573 }