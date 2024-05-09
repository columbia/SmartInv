1 pragma solidity ^0.4.21;
2 
3 
4 
5 contract ERC20Interface {
6 
7     function totalSupply() public constant returns (uint);
8 
9     function balanceOf(address tokenOwner) public constant returns (uint balance);
10 
11     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
12 
13     function transfer(address to, uint tokens) public returns (bool success);
14 
15     function approve(address spender, uint tokens) public returns (bool success);
16 
17     function transferFrom(address from, address to, uint tokens) public returns (bool success);
18 
19 
20 
21     event Transfer(address indexed from, address indexed to, uint tokens);
22 
23     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
24 
25 }
26 
27 
28 
29 contract CryptoQuantumTradingFund is ERC20Interface {
30 
31 	
32 
33 	
34 
35 	// ERC20 //////////////
36 
37 
38 
39 	event Burn(address indexed from, uint256 value);
40 
41 
42 
43     /**
44 
45      * Destroy tokens
46 
47      */
48 
49     function burn(uint256 _value) public returns (bool success) {
50 
51 	if (msg.sender != owner) 
52 
53 	{
54 
55 		    revert();
56 
57 	}
58 
59 	if(_value <= 0 || _totalBalance < _value){
60 
61 	    revert();
62 
63 	}
64 
65         balances[owner] -= _value;
66 
67         _totalBalance -= _value;
68 	totalCQTFSupply -= _value;
69 
70 
71 
72         emit Burn(msg.sender, _value);
73 
74         emit Transfer(msg.sender, address(0), _value);
75 
76         return true;
77 
78     }
79 
80 
81 
82 
83 
84 	function totalSupply()public constant returns (uint) {
85 
86 		return totalCQTFSupply;
87 
88 	}
89 
90 	
91 
92 	function balanceOf(address tokenOwner)public constant returns (uint balance) {
93 
94 		return balances[tokenOwner];
95 
96 	}
97 
98 
99 
100 	function transfer(address to, uint tokens)public returns (bool success) {
101 
102 		if (balances[msg.sender] >= tokens && tokens > 0 && balances[to] + tokens > balances[to]) {
103 
104             if(lockedUsers[msg.sender].lockedTokens > 0){
105 
106                 TryUnLockBalance(msg.sender);
107 
108                 if(balances[msg.sender] - tokens < lockedUsers[msg.sender].lockedTokens)
109 
110                 {
111 
112                     return false;
113 
114                 }
115 
116             }
117 
118             
119 
120 			balances[msg.sender] -= tokens;
121 
122 			balances[to] += tokens;
123 
124 			emit Transfer(msg.sender, to, tokens);
125 
126 			return true;
127 
128 		} else {
129 
130 			return false;
131 
132 		}
133 
134 	}
135 
136 	
137 
138 
139 
140 	function transferFrom(address from, address to, uint tokens)public returns (bool success) {
141 
142 		if (balances[from] >= tokens && allowed[from][msg.sender] >= tokens && tokens > 0 && balances[to] + tokens > balances[to]) {
143 
144             if(lockedUsers[from].lockedTokens > 0)
145 
146             {
147 
148                 TryUnLockBalance(from);
149 
150                 if(balances[from] - tokens < lockedUsers[from].lockedTokens)
151 
152                 {
153 
154                     return false;
155 
156                 }
157 
158             }
159 
160             
161 
162 			balances[from] -= tokens;
163 
164 			allowed[from][msg.sender] -= tokens;
165 
166 			balances[to] += tokens;
167 
168 			emit Transfer(from, to, tokens);
169 
170 			return true;
171 
172 		} else {
173 
174 			return false;
175 
176 		}
177 
178 	}
179 
180 	
181 
182 	
183 
184 	function approve(address spender, uint tokens)public returns (bool success) {
185 
186 		allowed[msg.sender][spender] = tokens;
187 
188 		emit Approval(msg.sender, spender, tokens);
189 
190 		return true;
191 
192 	}
193 
194 	
195 
196 	function allowance(address tokenOwner, address spender)public constant returns (uint remaining) {
197 
198 		return allowed[tokenOwner][spender];
199 
200 	}
201 
202 	
203 
204 	event Transfer(address indexed from, address indexed to, uint tokens);//transfer方法调用时的通知事件
205 
206 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens); //approve方法调用时的通知事件
207 
208 	
209 
210 	// ERC20 //////////////
211 
212 		
213 
214     	string public name = "CryptoQuantumTradingFund";
215 
216     	string public symbol = "CQTF";
217 
218     	uint8 public decimals = 18;
219 
220 	uint256 private totalCQTFSupply = 100000000000000000000000000;
221 
222 	uint256 private _totalBalance = totalCQTFSupply;
223 
224 	
225 
226 	struct LockUser{
227 
228 	    uint256 lockedTokens;
229 
230 	    uint lockedTime;
231 
232 	    uint lockedIdx;
233 
234 	}
235 
236 	
237 
238 	
239 
240 	address public owner = 0x0;
241 
242 	
243 
244     	mapping (address => uint256) balances;
245 
246     	mapping(address => mapping (address => uint256)) allowed;
247 
248 
249 
250 	mapping(address => LockUser) lockedUsers;
251 
252 	
253 
254 	
255 
256 	uint  constant    private ONE_DAY_TIME_LEN =     86400; //一天的秒数
257 
258 	uint  constant    private ONE_YEAR_TIME_LEN = 31536000; //一年的秒数
259 
260 	uint  constant    private THREE_MONTH_LEN =    7776000; //三个月秒数
261 
262 	// uint  constant    private ONE_DAY_TIME_LEN = 1; //一天的秒数 测试
263 
264 	// uint  constant    private ONE_YEAR_TIME_LEN = 10; //一年的秒数 测试
265 
266 	uint32 private constant MAX_UINT32 = 0xFFFFFFFF;
267 
268 	
269 
270 
271 
272 	uint256   public creatorsTotalBalance =    8000000000000000000000000;//创世团队当前锁定额度
273 
274 	
275 
276 
277 
278 	
279 
280 	event SendTo(uint32 indexed _idx, uint8 indexed _type, address _from, address _to, uint256 _value);
281 
282 	
283 
284 	uint32 sendToIdx = 0;
285 
286 	
287 
288 	function safeToNextIdx() internal{
289 
290         if (sendToIdx >= MAX_UINT32){
291 
292 			sendToIdx = 1;
293 
294 		}
295 
296         else{
297 
298 			sendToIdx += 1;
299 
300 		}
301 
302     }
303 
304 
305 
306     function CryptoQuantumTradingFund() public {
307 
308 	
309 
310 		owner = msg.sender;
311 
312 		balances[owner] = _totalBalance;
313 
314     }
315 
316 	
317 
318 	
319 
320 
321 
322 	
323 
324 	//解锁
325 
326 	function TryUnLockBalance(address target) public {
327 
328 	    if(target == 0x0)
329 
330 	    {
331 
332 	        revert();
333 
334 	    }
335 
336 	    LockUser storage user = lockedUsers[target];
337 
338 	    if(user.lockedIdx > 0 && user.lockedTokens > 0)
339 
340 	    {
341 
342 	        if(block.timestamp >= user.lockedTime)
343 
344 	        {
345 
346 	            if(user.lockedIdx == 1)
347 
348 	            {
349 
350 	                user.lockedIdx = 0;
351 
352 	                user.lockedTokens = 0;
353 
354 	            }
355 
356 	            else
357 
358 	            {
359 
360 	                uint256 append = user.lockedTokens/user.lockedIdx;
361 
362 	                user.lockedTokens -= append;
363 
364         			user.lockedIdx--;
365 
366         			user.lockedTime = block.timestamp + ONE_YEAR_TIME_LEN;
367 
368         			lockedUsers[target] = user;
369 
370 	            }
371 
372 	        }
373 
374 	    }
375 
376 		
377 
378 	}
379 
380 	
381 
382 	
383 
384 
385 
386 	
387 
388 	//创始团队
389 
390 	function sendCreatorByOwner(address _to, uint256 _value) public {
391 
392 		if (msg.sender != owner) 
393 
394 		{
395 
396 		    revert();
397 
398 		}
399 
400 		
401 
402 		if(_to == 0x0){
403 
404 			revert();
405 
406 		}
407 
408 		
409 
410 		if(_value > creatorsTotalBalance){
411 
412 			revert();
413 
414 		}
415 
416 		
417 
418 		
419 
420 		creatorsTotalBalance -= _value;
421 
422 		balances[owner] -= _value;
423 
424 		_totalBalance -= _value;
425 
426 		balances[_to] += _value;
427 
428 		LockUser storage lockUser = lockedUsers[_to];
429 
430 		lockUser.lockedTime = block.timestamp + ONE_YEAR_TIME_LEN;
431 
432 		lockUser.lockedTokens += _value;
433 
434 		lockUser.lockedIdx = 1;
435 
436 
437 
438                 lockedUsers[_to] = lockUser;
439 
440 		
441 
442 		emit Transfer(owner, _to, _value);
443 
444 		
445 
446 		safeToNextIdx();
447 
448 		emit SendTo(sendToIdx, 4, 0x0, _to, _value);
449 
450 	}
451 
452 
453 
454 
455 
456        
457 
458 	
459 
460 	
461 
462 	
463 
464 	function changeOwner(address newOwner) public {
465 
466 		if (msg.sender != owner) 
467 
468 		{
469 
470 		    revert();
471 
472 		}
473 
474 		else
475 
476 		{
477 
478 			balances[newOwner] = balances[owner];
479 
480 			balances[owner] = 0x0;
481 
482 			owner = newOwner;
483 
484 			
485 
486 		}
487 
488     }
489 
490 	
491 
492 	function destruct() public {
493 
494 		if (msg.sender != owner) 
495 
496 		{
497 
498 		    revert();
499 
500 		}
501 
502 		else
503 
504 		{
505 
506 			selfdestruct(owner);
507 
508 		}
509 
510     }
511 
512 	
513 
514 	
515 
516 }