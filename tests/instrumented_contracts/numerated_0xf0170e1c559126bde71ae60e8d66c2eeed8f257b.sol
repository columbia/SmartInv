1 pragma solidity ^0.4.24;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 
7 // @Name ETHEGRAM
8 // @Name ETHEGRAM MSG TOKEN
9 
10 // ----------------------------------------------------------------------------
11 
12 library SafeMath {
13 
14     
15 
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17 
18         if (a == 0) {
19 
20             return 0;
21 
22         }
23 
24         uint256 c = a * b;
25 
26         assert(c / a == b);
27 
28         return c;
29 
30     }
31 
32 
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35 
36         return a / b;
37 
38     }
39 
40 
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43 
44         assert(b <= a);
45 
46         return a - b;
47 
48     }
49 
50 
51 
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53 
54         uint256 c = a + b;
55 
56         assert(c >= a);
57 
58         return c;
59 
60     }
61 
62 }
63 
64 
65 contract ERC20Basic {
66 
67     function totalSupply() public view returns (uint256);
68 
69     function balanceOf(address who) public view returns (uint256);
70 
71     function transfer(address to, uint256 value) public returns (bool);
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75 }
76 
77 
78 contract ERC20 is ERC20Basic {
79 
80     function allowance(address owner, address spender) public view returns (uint256);
81 
82     function transferFrom(address from, address to, uint256 value) public returns (bool);
83 
84     function approve(address spender, uint256 value) public returns (bool); 
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 
88 }
89 
90 
91 contract BasicToken is ERC20Basic {
92 
93     using SafeMath for uint256;
94 
95 
96 
97     mapping(address => uint256) balances;
98 
99 
100 
101     uint256 totalSupply_;
102 
103 
104 
105     function totalSupply() public view returns (uint256) {
106 
107         return totalSupply_;
108 
109     }
110 
111 
112 
113     function transfer(address _to, uint256 _value) public returns (bool) {
114 
115         require(_to != address(0));
116 
117         require(_value <= balances[msg.sender]);
118 
119 
120 
121         balances[msg.sender] = balances[msg.sender].sub(_value);
122 
123         balances[_to] = balances[_to].add(_value);
124 
125     
126 
127         emit Transfer(msg.sender, _to, _value);
128 
129         return true;
130 
131     }
132 
133 
134 
135     function balanceOf(address _owner) public view returns (uint256) {
136 
137         return balances[_owner];
138 
139     }
140 
141 }
142 
143 
144 contract Ownable {
145 
146     // Development Team Leader
147 
148     address public owner;
149 
150 
151 
152     constructor() public {
153 
154         owner    = msg.sender;
155 
156     }
157 
158 
159 
160     modifier onlyOwner() { require(msg.sender == owner); _; }
161 
162 }
163 
164 
165 contract BlackList is Ownable {
166 
167 
168 
169     event Lock(address indexed LockedAddress);
170 
171     event Unlock(address indexed UnLockedAddress);
172 
173 
174 
175     mapping( address => bool ) public blackList;
176 
177 
178 
179     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }
180 
181 
182 
183     function SetLockAddress(address _lockAddress) external onlyOwner returns (bool) {
184 
185         require(_lockAddress != address(0));
186 
187         require(_lockAddress != owner);
188 
189         require(blackList[_lockAddress] != true);
190 
191         
192 
193         blackList[_lockAddress] = true;
194 
195         
196 
197         emit Lock(_lockAddress);
198 
199 
200 
201         return true;
202 
203     }
204 
205 
206 
207     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
208 
209         require(blackList[_unlockAddress] != false);
210 
211         
212 
213         blackList[_unlockAddress] = false;
214 
215         
216 
217         emit Unlock(_unlockAddress);
218 
219 
220 
221         return true;
222 
223     }
224 
225 }
226 
227 
228 contract Pausable is Ownable {
229 
230     event Pause();
231 
232     event Unpause();
233 
234 
235 
236     bool public paused = false;
237 
238 
239 
240     modifier whenNotPaused() { require(!paused); _; }
241 
242     modifier whenPaused() { require(paused); _; }
243 
244 
245 
246     function pause() onlyOwner whenNotPaused public {
247 
248         paused = true;
249 
250         emit Pause();
251 
252     }
253 
254 
255 
256     function unpause() onlyOwner whenPaused public {
257 
258         paused = false;
259 
260         emit Unpause();
261 
262     }
263 
264 }
265 
266 contract StandardToken is ERC20, BasicToken {
267 
268   
269 
270     mapping (address => mapping (address => uint256)) internal allowed;
271 
272 
273 
274     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
275 
276         require(_to != address(0));
277 
278         require(_value <= balances[_from]);
279 
280         require(_value <= allowed[_from][msg.sender]);
281 
282 
283 
284         balances[_from] = balances[_from].sub(_value);
285 
286         balances[_to] = balances[_to].add(_value);
287 
288         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
289 
290     
291 
292         emit Transfer(_from, _to, _value);
293 
294     
295 
296         return true;
297 
298     }
299 
300 
301 
302     function approve(address _spender, uint256 _value) public returns (bool) {
303 
304         allowed[msg.sender][_spender] = _value;
305 
306     
307 
308         emit Approval(msg.sender, _spender, _value);
309 
310     
311 
312         return true;
313 
314     }
315 
316 
317 
318     function allowance(address _owner, address _spender) public view returns (uint256) {
319 
320         return allowed[_owner][_spender];
321 
322     }
323 
324 
325 
326     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
327 
328         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
329 
330     
331 
332         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
333 
334     
335 
336         return true;
337 
338     }
339 
340 
341 
342     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
343 
344         uint256 oldValue = allowed[msg.sender][_spender];
345 
346     
347 
348         if (_subtractedValue > oldValue) {
349 
350         allowed[msg.sender][_spender] = 0;
351 
352         } else {
353 
354         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
355 
356         }
357 
358     
359 
360         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361 
362         return true;
363 
364     }
365 
366 }
367 
368 
369 contract MultiTransferToken is StandardToken, Ownable {
370 
371 
372 
373     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
374 
375         require(_to.length == _amount.length);
376 
377 
378 
379         uint256 ui;
380 
381         uint256 amountSum = 0;
382 
383     
384 
385         for (ui = 0; ui < _to.length; ui++) {
386 
387             require(_to[ui] != address(0));
388 
389 
390 
391             amountSum = amountSum.add(_amount[ui]);
392 
393         }
394 
395 
396 
397         require(amountSum <= balances[msg.sender]);
398 
399 
400 
401         for (ui = 0; ui < _to.length; ui++) {
402 
403             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
404 
405             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
406 
407         
408 
409             emit Transfer(msg.sender, _to[ui], _amount[ui]);
410 
411         }
412 
413     
414 
415         return true;
416 
417     }
418 
419 }
420 
421 
422 contract BurnableToken is StandardToken, Ownable {
423 
424 
425 
426     event BurnAdminAmount(address indexed burner, uint256 value);
427 
428 
429 
430     function burnAdminAmount(uint256 _value) onlyOwner public {
431 
432         require(_value <= balances[msg.sender]);
433 
434 
435 
436         balances[msg.sender] = balances[msg.sender].sub(_value);
437 
438         totalSupply_ = totalSupply_.sub(_value);
439 
440     
441 
442         emit BurnAdminAmount(msg.sender, _value);
443 
444         emit Transfer(msg.sender, address(0), _value);
445 
446     }
447 
448 }
449 
450 
451 contract MintableToken is StandardToken, Ownable {
452 
453     event Mint(address indexed to, uint256 amount);
454 
455     event MintFinished();
456 
457 
458 
459     bool public mintingFinished = false;
460 
461 
462 
463     modifier canMint() { require(!mintingFinished); _; }
464 
465     modifier cannotMint() { require(mintingFinished); _; }
466 
467 
468 
469     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
470 
471         totalSupply_ = totalSupply_.add(_amount);
472 
473         balances[_to] = balances[_to].add(_amount);
474 
475     
476 
477         emit Mint(_to, _amount);
478 
479         emit Transfer(address(0), _to, _amount);
480 
481     
482 
483         return true;
484 
485     }
486 
487 
488 
489     function finishMinting() onlyOwner canMint public returns (bool) {
490 
491         mintingFinished = true;
492 
493         emit MintFinished();
494 
495         return true;
496 
497     }
498 
499 }
500 
501 
502 contract PausableToken is StandardToken, Pausable, BlackList {
503 
504 
505 
506     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
507 
508         return super.transfer(_to, _value);
509 
510     }
511 
512 
513 
514     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
515 
516         return super.transferFrom(_from, _to, _value);
517 
518     }
519 
520 
521 
522     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
523 
524         return super.approve(_spender, _value);
525 
526     }
527 
528 
529 
530     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
531 
532         return super.increaseApproval(_spender, _addedValue);
533 
534     }
535 
536 
537 
538     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
539 
540         return super.decreaseApproval(_spender, _subtractedValue);
541 
542     }
543 
544 }
545 
546 
547 contract ETHEGRAM is PausableToken, MintableToken, BurnableToken, MultiTransferToken {
548 
549     string public name = "ETHEGRAM";
550     string public symbol = "EGR";
551     uint256 public decimals = 18;
552 
553 }