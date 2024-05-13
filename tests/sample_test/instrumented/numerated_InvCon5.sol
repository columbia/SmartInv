1 1 pragma solidity ^0.4.23;
2 
3 
4 
5 2 contract ERC20Basic {
6 3   function totalSupply() public view returns (uint256);
7 4   function balanceOf(address who) public view returns (uint256);
8 5   function transfer(address to, uint256 value) public returns (bool);
9 6   event Transfer(address indexed from, address indexed to, uint256 value);
10 7 }
11 
12 
13 8 library SafeMath {
14 
15 
16 9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17 10     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18 11     // benefit is lost if 'b' is also tested.
19 12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20 13     if (a == 0) {
21 14       return 0;
22 15     }
23 
24 16     c = a * b;
25 17     assert(c / a == b);
26 18     return c;
27 19   }
28 
29  
30 20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31 21     // assert(b > 0); // Solidity automatically throws when dividing by 0
32 22     // uint256 c = a / b;
33 23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 24     return a / b;
35 25   }
36 
37  
38 26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39 27     assert(b <= a);
40 28     return a - b;
41 29   }
42 
43 
44 30   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45 31     c = a + b;
46 32     assert(c >= a);
47 33     return c;
48 34   }
49 35 }
50 
51 
52 36 contract BasicToken is ERC20Basic {
53 37   using SafeMath for uint256;
54 
55 38   mapping(address => uint256) balances;
56 
57 39   uint256 totalSupply_;
58 
59 40   function totalSupply() public view returns (uint256) {
60 41     return totalSupply_;
61 42   }
62 
63 
64 43   function transfer(address _to, uint256 _value) public returns (bool) {
65 44     require(_to != address(0));
66 45     require(_value <= balances[msg.sender]);
67 
68 46     balances[msg.sender] = balances[msg.sender].sub(_value);
69 47     balances[_to] = balances[_to].add(_value);
70 48     emit Transfer(msg.sender, _to, _value);
71 49     return true;
72 50   }
73 
74  
75 51   function balanceOf(address _owner) public view returns (uint256) {
76 52     return balances[_owner];
77 53   }
78 
79 54 }
80 
81 
82 
83 55 contract ERC20 is ERC20Basic {
84 56   function allowance(address owner, address spender)
85 57     public view returns (uint256);
86 
87 58   function transferFrom(address from, address to, uint256 value)
88 59     public returns (bool);
89 
90 60   function approve(address spender, uint256 value) public returns (bool);
91 61   event Approval(
92 62     address indexed owner,
93 63     address indexed spender,
94 64     uint256 value
95 65   );
96 66 }
97 
98 
99 67 contract StandardToken is ERC20, BasicToken {
100 
101 68   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104 
105 69   function transferFrom(
106 70     address _from,
107 71     address _to,
108 72     uint256 _value
109 73   )
110 74     public
111 75     returns (bool)
112 76   {
113 77     require(_to != address(0));
114 78     require(_value <= balances[_from]);
115 79     require(_value <= allowed[_from][msg.sender]);
116 
117 80     balances[_from] = balances[_from].sub(_value);
118 81     balances[_to] = balances[_to].add(_value);
119 82     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120 83     emit Transfer(_from, _to, _value);
121 84     return true;
122 85   }
123 
124 86   function approve(address _spender, uint256 _value) public returns (bool) {
125 87     allowed[msg.sender][_spender] = _value;
126 88     emit Approval(msg.sender, _spender, _value);
127 89     return true;
128 90   }
129 
130 
131 91   function allowance(
132 92     address _owner,
133 93     address _spender
134 94    )
135 95     public
136 96     view
137 97     returns (uint256)
138 98   {
139 99     return allowed[_owner][_spender];
140 100   }
141 
142 101   function increaseApproval(
143 102     address _spender,
144 103     uint _addedValue
145 104   )
146 105     public
147 106     returns (bool)
148 107   {
149 108     allowed[msg.sender][_spender] = (
150 109       allowed[msg.sender][_spender].add(_addedValue));
151 110     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152 111     return true;
153 112   }
154 
155 113   function decreaseApproval(
156 114     address _spender,
157 115     uint _subtractedValue
158 116   )
159 117     public
160 118     returns (bool)
161 119   {
162 120     uint oldValue = allowed[msg.sender][_spender];
163 121     if (_subtractedValue > oldValue) {
164 122       allowed[msg.sender][_spender] = 0;
165 123     } else {
166 124       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167 125     }
168 126     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169 127     return true;
170 128   }
171 
172 129 }
173 
174 
175 
176 130 contract Ownable {
177 131   address public owner;
178 
179 
180 132   event OwnershipRenounced(address indexed previousOwner);
181 133   event OwnershipTransferred(
182 134     address indexed previousOwner,
183 135     address indexed newOwner
184 136   );
185 
186 
187 137   constructor() public {
188 138     owner = msg.sender;
189 139   }
190 
191  
192 140   modifier onlyOwner() {
193 141     require(msg.sender == owner);
194 142     _;
195 143   }
196 
197  
198 144   function renounceOwnership() public onlyOwner {
199 145     emit OwnershipRenounced(owner);
200 146     owner = address(0);
201 147   }
202 
203 
204 148   function transferOwnership(address _newOwner) public onlyOwner {
205 149     _transferOwnership(_newOwner);
206 150   }
207 
208 151   function _transferOwnership(address _newOwner) internal {
209 152     require(_newOwner != address(0));
210 153     emit OwnershipTransferred(owner, _newOwner);
211 154     owner = _newOwner;
212 155   }
213 156 }
214 
215 
216 
217 157 contract MintableToken is StandardToken, Ownable {
218 158   event Mint(address indexed to, uint256 amount);
219 159   event MintFinished();
220 
221 160   bool public mintingFinished = false;
222 
223 
224 161   modifier canMint() {
225 162     require(!mintingFinished);
226 163     _;
227 164   }
228 
229 165   modifier hasMintPermission() {
230 166     require(msg.sender == owner);
231 167     _;
232 168   }
233 
234 
235 169   function mint(
236 170     address _to,
237 171     uint256 _amount
238 172   )
239 173     hasMintPermission
240 174     canMint
241 175     public
242 176     returns (bool)
243 177   {
244 178     totalSupply_ = totalSupply_.add(_amount);
245 179     balances[_to] = balances[_to].add(_amount);
246 180     emit Mint(_to, _amount);
247 181     emit Transfer(address(0), _to, _amount);
248 182     return true;
249 183   }
250 
251 
252 184   function finishMinting() onlyOwner canMint public returns (bool) {
253 185     mintingFinished = true;
254 186     emit MintFinished();
255 187     return true;
256 188   }
257 189 }
258 
259 
260 190 contract FreezableToken is StandardToken {
261 191     // freezing chains
262 192     mapping (bytes32 => uint64) internal chains;
263 193     // freezing amounts for each chain
264 194     mapping (bytes32 => uint) internal freezings;
265 195     // total freezing balance per address
266 196     mapping (address => uint) internal freezingBalance;
267 
268 197     event Freezed(address indexed to, uint64 release, uint amount);
269 198     event Released(address indexed owner, uint amount);
270 
271 
272 199     function balanceOf(address _owner) public view returns (uint256 balance) {
273 200         return super.balanceOf(_owner) + freezingBalance[_owner];
274 201     }
275 
276  
277 202     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
278 203         return super.balanceOf(_owner);
279 204     }
280 
281 205     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
282 206         return freezingBalance[_owner];
283 207     }
284 
285 
286 208     function freezingCount(address _addr) public view returns (uint count) {
287 209         uint64 release = chains[toKey(_addr, 0)];
288 210         while (release != 0) {
289 211             count++;
290 212             release = chains[toKey(_addr, release)];
291 213         }
292 214     }
293 
294 
295 215     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
296 216         for (uint i = 0; i < _index + 1; i++) {
297 217             _release = chains[toKey(_addr, _release)];
298 218             if (_release == 0) {
299 219                 return;
300 220             }
301 221         }
302 222         _balance = freezings[toKey(_addr, _release)];
303 223     }
304 
305 
306 224     function freezeTo(address _to, uint _amount, uint64 _until) public {
307 225         require(_to != address(0));
308 226         require(_amount <= balances[msg.sender]);
309 
310 227         balances[msg.sender] = balances[msg.sender].sub(_amount);
311 
312 228         bytes32 currentKey = toKey(_to, _until);
313 229         freezings[currentKey] = freezings[currentKey].add(_amount);
314 230         freezingBalance[_to] = freezingBalance[_to].add(_amount);
315 
316 231         freeze(_to, _until);
317 232         emit Transfer(msg.sender, _to, _amount);
318 233         emit Freezed(_to, _until, _amount);
319 234     }
320 
321 235     function releaseOnce() public {
322 236         bytes32 headKey = toKey(msg.sender, 0);
323 237         uint64 head = chains[headKey];
324 238         require(head != 0);
325 239         require(uint64(block.timestamp) > head);
326 240         bytes32 currentKey = toKey(msg.sender, head);
327 
328 241         uint64 next = chains[currentKey];
329 
330 242         uint amount = freezings[currentKey];
331 243         delete freezings[currentKey];
332 
333 244         balances[msg.sender] = balances[msg.sender].add(amount);
334 245         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
335 
336 246         if (next == 0) {
337 247             delete chains[headKey];
338 248         } else {
339 249             chains[headKey] = next;
340 250             delete chains[currentKey];
341 251         }
342 252         emit Released(msg.sender, amount);
343 253     }
344 
345    
346 254     function releaseAll() public returns (uint tokens) {
347 255         uint release;
348 256         uint balance;
349 257         (release, balance) = getFreezing(msg.sender, 0);
350 258         while (release != 0 && block.timestamp > release) {
351 259             releaseOnce();
352 260             tokens += balance;
353 261             (release, balance) = getFreezing(msg.sender, 0);
354 262         }
355 263     }
356 
357 264     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
358 265         // WISH masc to increase entropy
359 266         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
360 267         assembly {
361 268             result := or(result, mul(_addr, 0x10000000000000000))
362 269             result := or(result, and(_release, 0xffffffffffffffff))
363 270         }
364 271     }
365 
366 272     function freeze(address _to, uint64 _until) internal {
367 273         require(_until > block.timestamp);
368 274         bytes32 key = toKey(_to, _until);
369 275         bytes32 parentKey = toKey(_to, uint64(0));
370 276         uint64 next = chains[parentKey];
371 
372 277         if (next == 0) {
373 278             chains[parentKey] = _until;
374 279             return;
375 280         }
376 
377 281         bytes32 nextKey = toKey(_to, next);
378 282         uint parent;
379 
380 283         while (next != 0 && _until > next) {
381 284             parent = next;
382 285             parentKey = nextKey;
383 
384 286             next = chains[nextKey];
385 287             nextKey = toKey(_to, next);
386 288         }
387 
388 289         if (_until == next) {
389 290             return;
390 291         }
391 
392 292         if (next != 0) {
393 293             chains[key] = next;
394 294         }
395 
396 295         chains[parentKey] = _until;
397 296     }
398 297 }
399 
400 
401 
402 298 contract BurnableToken is BasicToken {
403 
404 299   event Burn(address indexed burner, uint256 value);
405 
406  
407 300   function burn(uint256 _value) public {
408 301     _burn(msg.sender, _value);
409 302   }
410 
411 303   function _burn(address _who, uint256 _value) internal {
412 304     require(_value <= balances[_who]);
413 305     // no need to require value <= totalSupply, since that would imply the
414 306     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
415 
416 307     balances[_who] = balances[_who].sub(_value);
417 308     totalSupply_ = totalSupply_.sub(_value);
418 309     emit Burn(_who, _value);
419 310     emit Transfer(_who, address(0), _value);
420 311   }
421 312 }
422 
423 
424 
425 313 contract Pausable is Ownable {
426 314   event Pause();
427 315   event Unpause();
428 
429 316   bool public paused = false;
430 
431 
432  
433 317   modifier whenNotPaused() {
434 318     require(!paused);
435 319     _;
436 320   }
437 
438 
439 321   modifier whenPaused() {
440 322     require(paused);
441 323     _;
442 324   }
443 
444 
445 325   function pause() onlyOwner whenNotPaused public {
446 326     paused = true;
447 327     emit Pause();
448 328   }
449 
450 329   function unpause() onlyOwner whenPaused public {
451 330     paused = false;
452 331     emit Unpause();
453 332   }
454 333 }
455 
456 
457 334 contract FreezableMintableToken is FreezableToken, MintableToken {
458 
459 335     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
460 336         totalSupply_ = totalSupply_.add(_amount);
461 
462 337         bytes32 currentKey = toKey(_to, _until);
463 338         freezings[currentKey] = freezings[currentKey].add(_amount);
464 339         freezingBalance[_to] = freezingBalance[_to].add(_amount);
465 
466 340         freeze(_to, _until);
467 341         emit Mint(_to, _amount);
468 342         emit Freezed(_to, _until, _amount);
469 343         emit Transfer(msg.sender, _to, _amount);
470 344         return true;
471 345     }
472 346 }
473 
474 
475 
476 347 contract Consts {
477 348     uint public constant TOKEN_DECIMALS = 18;
478 349     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
479 350     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
480 
481 351     string public constant TOKEN_NAME = "Phuket Holiday Coin";
482 352     string public constant TOKEN_SYMBOL = "PHC";
483 353     bool public constant PAUSED = false;
484 354     address public constant TARGET_USER = 0xf4A9B48F974AC8cA9f240F06b3ef71D003248F5a;
485     
486 355     bool public constant CONTINUE_MINTING = true;
487 356 }
488 
489 
490 
491 
492 357 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
493     
494 358 {
495     
496 359     event Initialized();
497 360     bool public initialized = false;
498 
499 361     constructor() public {
500 362         init();
501 363         transferOwnership(TARGET_USER);
502 364     }
503     
504 
505 365     function name() public pure returns (string _name) {
506 366         return TOKEN_NAME;
507 367     }
508 
509 368     function symbol() public pure returns (string _symbol) {
510 369         return TOKEN_SYMBOL;
511 370     }
512 
513 371     function decimals() public pure returns (uint8 _decimals) {
514 372         return TOKEN_DECIMALS_UINT8;
515 373     }
516 
517 374     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
518 375         require(!paused);
519 376         return super.transferFrom(_from, _to, _value);
520 377     }
521 
522 378     function transfer(address _to, uint256 _value) public returns (bool _success) {
523 379         require(!paused);
524 380         return super.transfer(_to, _value);
525 381     }
526 
527     
528 382     function init() private {
529 383         require(!initialized);
530 384         initialized = true;
531 
532 385         if (PAUSED) {
533 386             pause();
534 387         }
535 
536         
537 388         address[1] memory addresses = [address(0xf4a9b48f974ac8ca9f240f06b3ef71d003248f5a)];
538 389         uint[1] memory amounts = [uint(220000000000000000000000000)];
539 390         uint64[1] memory freezes = [uint64(0)];
540 
541 391         for (uint i = 0; i < addresses.length; i++) {
542 392             if (freezes[i] == 0) {
543 393                 mint(addresses[i], amounts[i]);
544 394             } else {
545 395                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
546 396             }
547 397         }
548         
549 
550 398         if (!CONTINUE_MINTING) {
551 399             finishMinting();
552 400         }
553 
554 401         emit Initialized();
555 402     }
556     
557 403 }