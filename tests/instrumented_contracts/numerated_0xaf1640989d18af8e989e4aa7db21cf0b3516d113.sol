1 pragma solidity ^0.4.24;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 
7 // @Name SafeMath
8 
9 // @Desc Math operations with safety checks that throw on error
10 
11 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
12 
13 // ----------------------------------------------------------------------------
14 
15 library SafeMath {
16 
17     
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20 
21         if (a == 0) {
22 
23             return 0;
24 
25         }
26 
27         uint256 c = a * b;
28 
29         assert(c / a == b);
30 
31         return c;
32 
33     }
34 
35 
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38 
39         return a / b;
40 
41     }
42 
43 
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46 
47         assert(b <= a);
48 
49         return a - b;
50 
51     }
52 
53 
54 
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56 
57         uint256 c = a + b;
58 
59         assert(c >= a);
60 
61         return c;
62 
63     }
64 
65 }
66 
67 // ----------------------------------------------------------------------------
68 
69 // @title ERC20Basic
70 
71 // @dev Simpler version of ERC20 interface
72 
73 // See https://github.com/ethereum/EIPs/issues/179
74 
75 // ----------------------------------------------------------------------------
76 
77 contract ERC20Basic {
78 
79     function totalSupply() public view returns (uint256);
80 
81     function balanceOf(address who) public view returns (uint256);
82 
83     function transfer(address to, uint256 value) public returns (bool);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87 }
88 
89 // ----------------------------------------------------------------------------
90 
91 // @title ERC20 interface
92 
93 // @dev See https://github.com/ethereum/EIPs/issues/20
94 
95 // ----------------------------------------------------------------------------
96 
97 contract ERC20 is ERC20Basic {
98 
99     function allowance(address owner, address spender) public view returns (uint256);
100 
101     function transferFrom(address from, address to, uint256 value) public returns (bool);
102 
103     function approve(address spender, uint256 value) public returns (bool); 
104 
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 
107 }
108 
109 // ----------------------------------------------------------------------------
110 
111 // @title Basic token
112 
113 // @dev Basic version of StandardToken, with no allowances.
114 
115 // ----------------------------------------------------------------------------
116 
117 contract BasicToken is ERC20Basic {
118 
119     using SafeMath for uint256;
120 
121 
122 
123     mapping(address => uint256) balances;
124 
125 
126 
127     uint256 totalSupply_;
128 
129 
130 
131     function totalSupply() public view returns (uint256) {
132 
133         return totalSupply_;
134 
135     }
136 
137 
138 
139     function transfer(address _to, uint256 _value) public returns (bool) {
140 
141         require(_to != address(0));
142 
143         require(_value <= balances[msg.sender]);
144 
145 
146 
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148 
149         balances[_to] = balances[_to].add(_value);
150 
151     
152 
153         emit Transfer(msg.sender, _to, _value);
154 
155         return true;
156 
157     }
158 
159 
160 
161     function balanceOf(address _owner) public view returns (uint256) {
162 
163         return balances[_owner];
164 
165     }
166 
167 }
168 
169 // ----------------------------------------------------------------------------
170 
171 // @title Ownable
172 
173 // ----------------------------------------------------------------------------
174 
175 contract Ownable {
176 
177     // Development Team Leader
178 
179     address public owner;
180 
181 
182 
183     constructor() public {
184 
185         owner    = msg.sender;
186 
187     }
188 
189 
190 
191     modifier onlyOwner() { require(msg.sender == owner); _; }
192 
193 }
194 
195 // ----------------------------------------------------------------------------
196 
197 // @title BlackList
198 
199 // @dev Base contract which allows children to implement an emergency stop mechanism.
200 
201 // ----------------------------------------------------------------------------
202 
203 contract BlackList is Ownable {
204 
205 
206 
207     event Lock(address indexed LockedAddress);
208 
209     event Unlock(address indexed UnLockedAddress);
210 
211 
212 
213     mapping( address => bool ) public blackList;
214 
215 
216 
217     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }
218 
219 
220 
221     function SetLockAddress(address _lockAddress) external onlyOwner returns (bool) {
222 
223         require(_lockAddress != address(0));
224 
225         require(_lockAddress != owner);
226 
227         require(blackList[_lockAddress] != true);
228 
229         
230 
231         blackList[_lockAddress] = true;
232 
233         
234 
235         emit Lock(_lockAddress);
236 
237 
238 
239         return true;
240 
241     }
242 
243 
244 
245     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
246 
247         require(blackList[_unlockAddress] != false);
248 
249         
250 
251         blackList[_unlockAddress] = false;
252 
253         
254 
255         emit Unlock(_unlockAddress);
256 
257 
258 
259         return true;
260 
261     }
262 
263 }
264 
265 // ----------------------------------------------------------------------------
266 
267 // @title Pausable
268 
269 // @dev Base contract which allows children to implement an emergency stop mechanism.
270 
271 // ----------------------------------------------------------------------------
272 
273 contract Pausable is Ownable {
274 
275     event Pause();
276 
277     event Unpause();
278 
279 
280 
281     bool public paused = false;
282 
283 
284 
285     modifier whenNotPaused() { require(!paused); _; }
286 
287     modifier whenPaused() { require(paused); _; }
288 
289 
290 
291     function pause() onlyOwner whenNotPaused public {
292 
293         paused = true;
294 
295         emit Pause();
296 
297     }
298 
299 
300 
301     function unpause() onlyOwner whenPaused public {
302 
303         paused = false;
304 
305         emit Unpause();
306 
307     }
308 
309 }
310 
311 // ----------------------------------------------------------------------------
312 
313 // @title Standard ERC20 token
314 
315 // @dev Implementation of the basic standard token.
316 
317 // https://github.com/ethereum/EIPs/issues/20
318 
319 // ----------------------------------------------------------------------------
320 
321 contract StandardToken is ERC20, BasicToken {
322 
323   
324 
325     mapping (address => mapping (address => uint256)) internal allowed;
326 
327 
328 
329     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
330 
331         require(_to != address(0));
332 
333         require(_value <= balances[_from]);
334 
335         require(_value <= allowed[_from][msg.sender]);
336 
337 
338 
339         balances[_from] = balances[_from].sub(_value);
340 
341         balances[_to] = balances[_to].add(_value);
342 
343         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
344 
345     
346 
347         emit Transfer(_from, _to, _value);
348 
349     
350 
351         return true;
352 
353     }
354 
355 
356 
357     function approve(address _spender, uint256 _value) public returns (bool) {
358 
359         allowed[msg.sender][_spender] = _value;
360 
361     
362 
363         emit Approval(msg.sender, _spender, _value);
364 
365     
366 
367         return true;
368 
369     }
370 
371 
372 
373     function allowance(address _owner, address _spender) public view returns (uint256) {
374 
375         return allowed[_owner][_spender];
376 
377     }
378 
379 
380 
381     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
382 
383         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
384 
385     
386 
387         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
388 
389     
390 
391         return true;
392 
393     }
394 
395 
396 
397     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
398 
399         uint256 oldValue = allowed[msg.sender][_spender];
400 
401     
402 
403         if (_subtractedValue > oldValue) {
404 
405         allowed[msg.sender][_spender] = 0;
406 
407         } else {
408 
409         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
410 
411         }
412 
413     
414 
415         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
416 
417         return true;
418 
419     }
420 
421 }
422 
423 // ----------------------------------------------------------------------------
424 
425 // @title MultiTransfer Token
426 
427 // @dev Only Admin
428 
429 // ----------------------------------------------------------------------------
430 
431 contract MultiTransferToken is StandardToken, Ownable {
432 
433 
434 
435     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
436 
437         require(_to.length == _amount.length);
438 
439 
440 
441         uint256 ui;
442 
443         uint256 amountSum = 0;
444 
445     
446 
447         for (ui = 0; ui < _to.length; ui++) {
448 
449             require(_to[ui] != address(0));
450 
451 
452 
453             amountSum = amountSum.add(_amount[ui]);
454 
455         }
456 
457 
458 
459         require(amountSum <= balances[msg.sender]);
460 
461 
462 
463         for (ui = 0; ui < _to.length; ui++) {
464 
465             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
466 
467             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
468 
469         
470 
471             emit Transfer(msg.sender, _to[ui], _amount[ui]);
472 
473         }
474 
475     
476 
477         return true;
478 
479     }
480 
481 }
482 
483 // ----------------------------------------------------------------------------
484 
485 // @title Burnable Token
486 
487 // @dev Token that can be irreversibly burned (destroyed).
488 
489 // ----------------------------------------------------------------------------
490 
491 contract BurnableToken is StandardToken, Ownable {
492 
493 
494 
495     event BurnAdminAmount(address indexed burner, uint256 value);
496 
497 
498 
499     function burnAdminAmount(uint256 _value) onlyOwner public {
500 
501         require(_value <= balances[msg.sender]);
502 
503 
504 
505         balances[msg.sender] = balances[msg.sender].sub(_value);
506 
507         totalSupply_ = totalSupply_.sub(_value);
508 
509     
510 
511         emit BurnAdminAmount(msg.sender, _value);
512 
513         emit Transfer(msg.sender, address(0), _value);
514 
515     }
516 
517 }
518 
519 // ----------------------------------------------------------------------------
520 
521 // @title Mintable token
522 
523 // @dev Simple ERC20 Token example, with mintable token creation
524 
525 // Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
526 
527 // ----------------------------------------------------------------------------
528 
529 contract MintableToken is StandardToken, Ownable {
530 
531     event Mint(address indexed to, uint256 amount);
532 
533     event MintFinished();
534 
535 
536 
537     bool public mintingFinished = false;
538 
539 
540 
541     modifier canMint() { require(!mintingFinished); _; }
542 
543     modifier cannotMint() { require(mintingFinished); _; }
544 
545 
546 
547     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
548 
549         totalSupply_ = totalSupply_.add(_amount);
550 
551         balances[_to] = balances[_to].add(_amount);
552 
553     
554 
555         emit Mint(_to, _amount);
556 
557         emit Transfer(address(0), _to, _amount);
558 
559     
560 
561         return true;
562 
563     }
564 
565 
566 
567     function finishMinting() onlyOwner canMint public returns (bool) {
568 
569         mintingFinished = true;
570 
571         emit MintFinished();
572 
573         return true;
574 
575     }
576 
577 }
578 
579 // ----------------------------------------------------------------------------
580 
581 // @title Pausable token
582 
583 // @dev StandardToken modified with pausable transfers.
584 
585 // ----------------------------------------------------------------------------
586 
587 contract PausableToken is StandardToken, Pausable, BlackList {
588 
589 
590 
591     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
592 
593         return super.transfer(_to, _value);
594 
595     }
596 
597 
598 
599     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
600 
601         return super.transferFrom(_from, _to, _value);
602 
603     }
604 
605 
606 
607     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
608 
609         return super.approve(_spender, _value);
610 
611     }
612 
613 
614 
615     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
616 
617         return super.increaseApproval(_spender, _addedValue);
618 
619     }
620 
621 
622 
623     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
624 
625         return super.decreaseApproval(_spender, _subtractedValue);
626 
627     }
628 
629 }
630  
631 
632 // ----------------------------------------------------------------------------
633 
634 // @Project 
635 
636 // @Creator
637 
638 // @Source
639 
640 // ----------------------------------------------------------------------------
641 
642 contract TESTOS is PausableToken, MintableToken, BurnableToken, MultiTransferToken {
643 
644     string public name = "TESTOS";
645 
646     string public symbol = "TEO";
647 
648     uint256 public decimals = 18;
649 
650 }