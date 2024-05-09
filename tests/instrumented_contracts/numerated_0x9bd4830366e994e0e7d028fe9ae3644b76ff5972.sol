1 pragma solidity >=0.4.22 <0.7.0;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal pure returns (uint) {
5     if (a == 0) {
6       return 0;
7     }
8     uint c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal pure returns (uint) {
14     uint c = a / b;
15     return c;
16   }
17 
18   function sub(uint a, uint b) internal pure returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint a, uint b) internal pure returns (uint) {
24     uint c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Sunflower {
31     
32     using SafeMath for uint;
33 
34 	uint40 constant CHECK_CYCLE = 2592000;
35 	uint40 constant GAMBLING_POOL_CYCLE = 259200;
36 	uint40 constant RELEASE_CYCLE = 86400;
37 	
38    
39     uint gambling_pool;
40 	uint40 gambling_pool_time;
41 	address[100] gambling_pool_address;
42 	uint8 gambling_pool_address_pos;
43 	
44 	struct InvestParam {
45         uint8 releaseRate;
46         
47         uint8 outMultiple;
48 		}
49     
50 	mapping(uint => InvestParam) investParams;
51 	
52 	uint total_deposit;
53 	
54     struct User {
55         address upline;
56 		
57         uint referrals;
58 		
59         uint payouts;
60 		
61         uint invite_bonus;
62 		uint level_bonus;
63 		
64         uint deposit_amount;
65 		
66         uint release_num;
67 		
68         uint40 deposit_time;
69 		
70         uint total_deposits;
71 		
72 		uint total_invite_deposits;
73 
74 		uint8 level;
75 		
76 		uint8 check_level;
77 		
78 		uint40 check_time;
79 		
80 		uint check_invite_deposits;
81 		
82 		uint total_payouts;
83     }
84 	
85     mapping(address => User) users;
86 	uint8[] ref_bonuses;
87 	uint8[] ref_nums;
88 	uint[] levels_invite_deposits;
89 	uint[] levels_check_invite_deposits;
90 	uint8[] levels_bonus;
91 	mapping(uint8 => address[]) levels_users;
92 	
93 	address[3] operate_address = [0xac2b4501284261ff009f22AfcC7F4997bA77ecB2,0xc9a02f9a161a51Fa48039684d6DFC933f4ACE55C,0xbd4FA6AF1e6fE6b211414948346420694fFab8cD];
94 	uint[3] operate_bonuses;
95     
96 	event Upline(address indexed addr, address indexed upline);
97 	event InvitePayout(address indexed addr, address indexed from, uint amount);
98 	event NewDeposit(address indexed addr, uint amount);
99 	event LevelPayout(address indexed addr, address indexed from, uint amount);
100 	
101 	constructor() public {
102         ref_bonuses.push(5);
103         ref_bonuses.push(3);
104         ref_bonuses.push(2);
105         ref_bonuses.push(1);
106         ref_bonuses.push(1);
107         ref_bonuses.push(1);
108         ref_bonuses.push(1);
109         ref_bonuses.push(1);
110         ref_bonuses.push(1);
111         ref_bonuses.push(1);
112         ref_bonuses.push(1);
113         ref_bonuses.push(1);
114         ref_bonuses.push(2);
115         ref_bonuses.push(3);
116         ref_bonuses.push(5);
117 		
118 		ref_nums.push(1);
119         ref_nums.push(3);
120         ref_nums.push(3);
121         ref_nums.push(5);
122         ref_nums.push(5);
123         ref_nums.push(5);
124         ref_nums.push(5);
125         ref_nums.push(5);
126         ref_nums.push(8);
127         ref_nums.push(8);
128         ref_nums.push(8);
129         ref_nums.push(8);
130         ref_nums.push(10);
131         ref_nums.push(10);
132         ref_nums.push(10);
133 		
134 		levels_bonus.push(15);
135         levels_bonus.push(20);
136         levels_bonus.push(25);
137 
138         gambling_pool_time = uint40(now);
139 		
140 		levels_invite_deposits.push(500 ether);
141         levels_invite_deposits.push(5000 ether);
142         levels_invite_deposits.push(50000 ether);
143 		
144 		levels_check_invite_deposits.push(50 ether);
145         levels_check_invite_deposits.push(500 ether);
146         levels_check_invite_deposits.push(2000 ether);
147 		
148 		investParams[0.5 ether].releaseRate = 5;
149 		investParams[0.5 ether].outMultiple = 15;
150 		investParams[1 ether].releaseRate = 6;
151 		investParams[1 ether].outMultiple = 18;
152 		investParams[3 ether].releaseRate = 7;
153 		investParams[3 ether].outMultiple = 20;
154 		investParams[5 ether].releaseRate = 8;
155 		investParams[5 ether].outMultiple = 22;
156 		investParams[10 ether].releaseRate = 9;
157 		investParams[10 ether].outMultiple = 24;
158 		investParams[30 ether].releaseRate = 10;
159 		investParams[30 ether].outMultiple = 26; 
160     }
161 	
162 	function getGamblingPoolAddress() public constant returns (address[100]){
163 		return gambling_pool_address;
164 	}
165 	
166 	function getGamblingPoolAddressPos() public constant returns (uint8){
167 		return gambling_pool_address_pos;
168 	}
169 	
170 	function getLevelsUsers(uint8 index) public constant returns (address[]){
171 		return levels_users[index];
172 	}
173 	
174 	function getOperateBonuses() public constant returns (uint[3]){
175 		return operate_bonuses;
176 	}
177 	
178 	function getSFC() public constant returns (uint){
179 		return users[msg.sender].total_deposits;
180 	}
181 
182 	function getUser() public constant returns (address, uint, uint, uint, uint, uint, uint, uint40, uint, uint8, uint8, uint40, uint, uint){
183 		return (users[msg.sender].upline, users[msg.sender].referrals, users[msg.sender].payouts, 
184 		users[msg.sender].invite_bonus, users[msg.sender].level_bonus, users[msg.sender].deposit_amount, users[msg.sender].release_num, 
185 		users[msg.sender].deposit_time, users[msg.sender].total_invite_deposits, 
186 		users[msg.sender].level, users[msg.sender].check_level, 
187 		users[msg.sender].check_time, users[msg.sender].check_invite_deposits, users[msg.sender].total_payouts );
188 	}
189 	
190 	function getInfo() public constant returns (uint, uint, uint40){
191 		return (total_deposit, gambling_pool, gambling_pool_time);
192 	}
193 	
194     function _setUpline(address _addr, address _upline) private {
195 
196 		require(users[_upline].deposit_amount > 0);
197 		users[_addr].upline = _upline;
198         users[_upline].referrals++;
199 
200 		if(users[_upline].referrals >= 10)
201 		{
202 			for(uint8 g=(uint8)(levels_invite_deposits.length); g>0; g--)
203 			{
204 				if(users[_upline].total_invite_deposits >= levels_invite_deposits[g-1] && users[_upline].level < g)
205 				{
206 					levels_users[g].push(_upline);
207 					if(users[_upline].level > 0)
208 					{
209 						for(uint k=0; k<levels_users[users[_upline].level].length; k++)
210 						{
211 							if(levels_users[users[_upline].level][k] == _upline && levels_users[users[_upline].level].length>1)
212 							{
213 								levels_users[users[_upline].level][k] = levels_users[users[_upline].level][levels_users[users[_upline].level].length - 1];
214 								break;
215 							}
216 						}
217 						delete levels_users[users[_upline].level][levels_users[users[_upline].level].length - 1];
218 						levels_users[users[_upline].level].length--;
219 					}
220 					users[_upline].level = g;
221 					users[_upline].check_time = uint40(now);
222 					users[_upline].check_level = g;
223 					users[_upline].check_invite_deposits = 0;
224 					break;
225 				}
226 			}
227 		}	
228         emit Upline(_addr, _upline);
229     }
230 	
231 	function _levels_bonus(address _addr, uint _amount) private {
232 		uint[3] memory _levels_num;
233 		for(uint8 m=1; m<=3; m++)
234 		{
235 			for(uint8 n=0; n<levels_users[m].length; n++)
236 			{
237 				User storage _user1 = users[levels_users[m][n]];
238 				if(now >= _user1.check_time + CHECK_CYCLE)
239 				{
240 					_user1.check_level = 0;
241 					for(uint8 s= (uint8)(levels_check_invite_deposits.length); s>0; s--)
242 					{
243 						if(_user1.check_invite_deposits >= levels_check_invite_deposits[s-1])
244 						{
245 							_user1.check_level = s > _user1.level ? _user1.level : s;
246 							break;
247 						}
248 					}
249 					uint40 _old_time = _user1.check_time;
250 					_user1.check_time = _user1.check_time + (uint40)(now.sub(_user1.check_time).div(CHECK_CYCLE).mul(CHECK_CYCLE));
251 					_user1.check_invite_deposits = 0;
252 					if(_user1.check_time - _old_time > CHECK_CYCLE)
253 					{
254 						_user1.check_level = 0;
255 					}
256 				}
257 				
258 				if(_user1.check_level > 0 && _user1.deposit_time > 0)
259 				{
260 					_levels_num[_user1.check_level-1]++;
261 				}
262 			}
263 		}
264 		uint[3] memory _levels_bonus_num;
265 		for(m=0; m<3; m++)
266 		{
267 			if(_levels_num[m] != 0)
268 			{
269 				_levels_bonus_num[m] = _amount.mul(levels_bonus[m]).div(1000).div(_levels_num[m]);
270 			}
271 		}
272 		for(m=1; m<=3; m++)
273 		{
274 			for(n=0; n<levels_users[m].length; n++)
275 			{
276 				User storage _user2 = users[levels_users[m][n]];
277 				if(_user2.check_level > 0 && _user2.deposit_time > 0)
278 				{	
279 					_user2.level_bonus =_user2.level_bonus.add(_levels_bonus_num[_user2.check_level-1]);
280 					
281 					emit LevelPayout(levels_users[m][n], _addr, _levels_bonus_num[_user2.check_level-1]);
282 				}
283 			}
284 		}
285 	}
286 	
287 	function _gambling_pool_bonus(address _addr, uint _amount) private {
288 		if(now >= gambling_pool_time + GAMBLING_POOL_CYCLE)
289 		{
290 			if(gambling_pool > 0)
291 			{
292 				uint _total_deposit = 0;
293 				for(uint16 i=0; i<gambling_pool_address.length; i++)
294 				{
295 					if(gambling_pool_address[i] != address(0))
296 					{
297 						_total_deposit = _total_deposit.add(users[gambling_pool_address[i]].deposit_amount);
298 					}
299 				}
300 				address _first_address;
301 				uint _remaining = gambling_pool;
302 				uint _bonus;
303 				for(uint16 j=0; j<gambling_pool_address.length; j++)
304 				{
305 					if(gambling_pool_address[j] != address(0))
306 					{
307 					    if(_first_address == address(0))
308 						{
309 							_first_address = gambling_pool_address[j];
310 							continue;
311 						}
312 						_bonus = users[gambling_pool_address[j]].deposit_amount.mul(gambling_pool).div(_total_deposit);
313 						_remaining = _remaining.sub(_bonus);
314 						gambling_pool_address[j].transfer(_bonus);
315 					}
316 				}
317 				if(_first_address != address(0))
318 				{
319 					_first_address.transfer(_remaining);
320 				}
321 			}
322 			gambling_pool_time = uint40(now);
323 			gambling_pool = 0;
324 			gambling_pool_address_pos = 0;
325 			for(uint16 k=0; k<gambling_pool_address.length; k++)
326 			{
327 				gambling_pool_address[k] = address(0);
328 			}
329 		}else{
330 			gambling_pool_time =  uint40((uint(gambling_pool_time)).add(_amount.div(0.1 ether).mul(3600).div(10)));
331 			if(gambling_pool_time > uint40(now))
332 			{
333 				gambling_pool_time = uint40(now);
334 			}
335 			
336 		}
337 		
338 		if(gambling_pool < 1000 ether)
339 		{
340 			gambling_pool = gambling_pool.add(_amount.div(100));
341 			gambling_pool = gambling_pool > 1000 ether ? 1000 ether : gambling_pool;
342 		}
343 		gambling_pool_address[gambling_pool_address_pos] = _addr;
344 		gambling_pool_address_pos ++;
345 		if(gambling_pool_address_pos == gambling_pool_address.length)
346 		{
347 			gambling_pool_address_pos = 0;
348 		}
349 	}
350 	
351 	function _deposit(address _addr, uint _amount) private {
352 		require(users[_addr].deposit_time == 0);
353 		require(_amount >= users[_addr].deposit_amount);
354 		if(total_deposit < 20000 ether)
355 		{
356 			require(_amount == 0.5 ether || _amount == 1 ether || _amount == 3 ether || _amount == 5 ether);
357 		}else
358 		{
359 			if(total_deposit < 50000 ether)
360 			{
361 				require(_amount == 0.5 ether || _amount == 1 ether || _amount == 3 ether || _amount == 5 ether || (_amount >= 10 ether && _amount <= 29 ether && _amount % 1 ether == 0));
362 			}else{
363 				require(_amount == 0.5 ether || _amount == 1 ether || _amount == 3 ether || _amount == 5 ether || (_amount >= 10 ether && _amount <= 49 ether && _amount % 1 ether == 0));
364 			}
365 		}
366         users[_addr].deposit_amount = _amount;
367         users[_addr].deposit_time = uint40(now);
368         users[_addr].total_deposits = users[_addr].total_deposits.add(_amount.mul(100).div(1 ether));
369 		total_deposit = total_deposit.add(_amount);
370         emit NewDeposit(_addr, _amount);
371 		
372 		operate_bonuses[0] = operate_bonuses[0].add(_amount.div(100));
373 		operate_bonuses[1] = operate_bonuses[1].add(_amount.div(100));
374 		operate_bonuses[2] = operate_bonuses[2].add(_amount.div(100));
375 
376 		address _upline = _addr;
377         for(uint8 i=0; i < ref_bonuses.length; i++)
378 		{
379 			_upline = users[_upline].upline;
380 		    
381 			if(_upline == address(0)) break;
382 			if(users[_upline].deposit_time > 0 && users[_upline].referrals >= ref_nums[i])
383 			{
384 				uint _upline_amount = users[_upline].deposit_amount > _amount? _amount:users[_upline].deposit_amount;
385 				users[_upline].invite_bonus = users[_upline].invite_bonus.add(_upline_amount.mul(ref_bonuses[i]).div(100));
386 				emit InvitePayout(_upline, _addr, _upline_amount.mul(ref_bonuses[i]).div(100));
387 			}
388 
389 			if(users[_upline].check_time != 0)
390 			{
391 				if(uint40(now) < users[_upline].check_time + CHECK_CYCLE)
392 				{
393 					if(uint40(now) >= users[_upline].check_time)
394 					{
395 						uint8 _current_check_level = 0;
396 						users[_upline].check_invite_deposits += _amount;
397 						for(uint8 j= (uint8)(levels_check_invite_deposits.length); j>0; j--)
398 						{
399 							if(users[_upline].check_invite_deposits >= levels_check_invite_deposits[j-1])
400 							{
401 								_current_check_level = j > users[_upline].level ? users[_upline].level : j;
402 								break;
403 							}
404 						}
405 						if(_current_check_level > users[_upline].check_level)
406 						{
407 							users[_upline].check_time = uint40(now);
408 							users[_upline].check_level = _current_check_level;
409 							users[_upline].check_invite_deposits = 0;
410 						}
411 						else if(_current_check_level == users[_upline].level)
412 						{
413 							users[_upline].check_time = users[_upline].check_time + CHECK_CYCLE;
414 							users[_upline].check_level = users[_upline].level;
415 							users[_upline].check_invite_deposits = 0;
416 						}
417 					}
418 				}
419 				else
420 				{
421 					users[_upline].check_level = 0;
422 					for(uint8 p = (uint8)(levels_check_invite_deposits.length); p > 0; p--)
423 					{
424 						if(users[_upline].check_invite_deposits >= levels_check_invite_deposits[p-1])
425 						{
426 							users[_upline].check_level = p > users[_upline].level ? users[_upline].level : p;
427 							break;
428 						}
429 					}
430 					uint40 _old_time = users[_upline].check_time;
431 					users[_upline].check_time = users[_upline].check_time + (uint40)(now.sub(users[_upline].check_time).div(CHECK_CYCLE).mul(CHECK_CYCLE));
432 					users[_upline].check_invite_deposits = _amount;
433 					if(users[_upline].check_time - _old_time > CHECK_CYCLE)
434 					{
435 						users[_upline].check_level = 0;
436 					}
437 				}
438 			}
439 
440 			users[_upline].total_invite_deposits = users[_upline].total_invite_deposits.add(_amount);
441 				
442 			if(users[_upline].referrals >= 10)
443 			{
444 				for(uint8 g=(uint8)(levels_invite_deposits.length); g>0; g--)
445 				{
446 					if(users[_upline].total_invite_deposits >= levels_invite_deposits[g-1] && users[_upline].level < g)
447 					{
448 						levels_users[g].push(_upline);
449 						if(users[_upline].level > 0)
450 						{
451 							for(uint k=0; k<levels_users[users[_upline].level].length; k++)
452 							{
453 								if(levels_users[users[_upline].level][k] == _upline && levels_users[users[_upline].level].length>1)
454 								{
455 									levels_users[users[_upline].level][k] = levels_users[users[_upline].level][levels_users[users[_upline].level].length - 1];
456 									break;
457 								}
458 							}
459 							delete levels_users[users[_upline].level][levels_users[users[_upline].level].length - 1];
460 							levels_users[users[_upline].level].length--;
461 						}
462 						users[_upline].level = g;
463 						users[_upline].check_time = uint40(now);
464 						users[_upline].check_level = g;
465 						users[_upline].check_invite_deposits = 0;
466 						break;
467 					}
468 				}
469 			}
470 		}
471 		
472 		_levels_bonus(_addr, _amount);
473 
474 		_gambling_pool_bonus(_addr, _amount);
475     }
476 	
477 	function deposit(address _upline) payable public{
478 		if(_upline != address(0) && users[msg.sender].upline == address(0) && users[msg.sender].deposit_amount == 0)
479 		{
480 			_setUpline(msg.sender, _upline);
481 		}
482         
483         _deposit(msg.sender, msg.value);
484     }
485 	
486 	function user_benefit() public{
487 		require(users[msg.sender].deposit_time > 0);
488 	    InvestParam memory _investParam;
489 		if(users[msg.sender].deposit_amount <= 5 ether)
490 		{
491 			_investParam = investParams[users[msg.sender].deposit_amount];
492 		}else if(users[msg.sender].deposit_amount <= 29 ether)
493 		{
494 			_investParam = investParams[10 ether];
495 		}else{
496 			_investParam = investParams[30 ether];
497 		}
498 		uint _maxPayout = users[msg.sender].deposit_amount.mul(_investParam.outMultiple).div(10);
499 		uint _releaseNum = (now - users[msg.sender].deposit_time).div(RELEASE_CYCLE);
500 		uint _currentReleaseNum = _releaseNum - users[msg.sender].release_num;
501 		uint _releasePayout = users[msg.sender].deposit_amount.mul(_investParam.releaseRate).div(1000).mul(_currentReleaseNum);
502 		uint _currentPayout = _releasePayout.add(users[msg.sender].invite_bonus);
503 		
504 		if(_currentPayout > 0)
505 		{
506 			if(users[msg.sender].payouts.add(_currentPayout) >= _maxPayout)
507 			{
508 				_currentPayout = _maxPayout.sub(users[msg.sender].payouts);
509 				users[msg.sender].release_num = 0;
510 				users[msg.sender].payouts = 0;
511 				users[msg.sender].invite_bonus = 0;
512 				users[msg.sender].deposit_time = 0;
513 			}
514 			else{
515 				users[msg.sender].release_num = _releaseNum;
516 				users[msg.sender].payouts = users[msg.sender].payouts.add(_currentPayout);
517 				users[msg.sender].invite_bonus = 0;
518 			}
519 		}
520 		
521 		if(users[msg.sender].level_bonus > 0)
522 		{
523 			_currentPayout = _currentPayout.add(users[msg.sender].level_bonus);
524 			users[msg.sender].level_bonus = 0;
525 		}
526 		
527 		
528 		require(_currentPayout > 0);
529 		users[msg.sender].total_payouts = users[msg.sender].total_payouts.add(_currentPayout);
530 		uint _contractSum = address(this).balance.sub(gambling_pool).sub(operate_bonuses[0]).sub(operate_bonuses[1]).sub(operate_bonuses[2]);
531 		require(_contractSum >= _currentPayout);
532 		msg.sender.transfer(_currentPayout);
533 	}
534 	
535 	function operate_benefit() public{
536 		require(msg.sender == operate_address[0] || msg.sender == operate_address[1] || msg.sender == operate_address[2]);
537 	    uint8 index;
538 		if(msg.sender == operate_address[0])
539 		{
540 			index = 0;
541 		}else if(msg.sender == operate_address[1])
542 		{
543 			index = 1;
544 		}
545 		else if(msg.sender == operate_address[2])
546 		{
547 			index = 2;
548 		}else{
549 			return;
550 		}
551 		if(operate_bonuses[index] > 0)
552 		{
553 			msg.sender.transfer(operate_bonuses[index]);
554 			operate_bonuses[index] = 0;
555 		}
556 		
557 	}
558 	
559 	function pledge_sfc(uint _amount) public{
560 		require(total_deposit >= 500000 ether);
561 		require(_amount % 10000 == 0 && users[msg.sender].total_deposits >= _amount && _amount > 0);
562 		users[msg.sender].total_deposits = users[msg.sender].total_deposits.sub(_amount);
563 		uint _contractSum = address(this).balance.sub(gambling_pool).sub(operate_bonuses[0]).sub(operate_bonuses[1]).sub(operate_bonuses[2]);
564 		require(_contractSum >= _amount.div(10000).mul(1 ether));
565 		msg.sender.transfer(_amount.div(10000).mul(1 ether));
566 	}
567 }