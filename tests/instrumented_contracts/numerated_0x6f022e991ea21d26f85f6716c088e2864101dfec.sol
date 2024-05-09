1 /**
2   _______ _________ _______  _______     __________________
3 (  ____ \\__   __/(  ___  )(  ____ )    \__   __/\__   __/
4 | (    \/   ) (   | (   ) || (    )|       ) (      ) (   
5 | (_____    | |   | |   | || (____)|       | |      | |   
6 (_____  )   | |   | |   | ||  _____)       | |      | |   
7       ) |   | |   | |   | || (             | |      | |   
8 /\____) |   | |   | (___) || )          ___) (___   | |   
9 \_______)   )_(   (_______)|/           \_______/   )_(   
10 
11 Selling Is Easy.
12 Holding Is Hard.
13 Let's Change That.
14 Our Seller Transfer Only Protocol Initiates Tax (STOP IT) actively taxes sellers while rewarding holders.
15 
16 https://handsofsteel.money
17 https://t.me/handsofsteel
18 */
19 
20 pragma solidity ^0.5.0;
21 
22 
23 
24 interface IERC20 {
25   function totalSupply() external view returns (uint256);
26   function balanceOf(address who) external view returns (uint256);
27   function allowance(address owner, address spender) external view returns (uint256);
28   function transfer(address to, uint256 value) external returns (bool);
29   function approve(address spender, uint256 value) external returns (bool);
30   function transferFrom(address from, address to, uint256 value) external returns (bool);
31 
32   event Transfer(address indexed from, address indexed to, uint256 value);
33   event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeMath {
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39       return 0;
40     }
41     uint256 c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a / b;
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 
62   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
63     uint256 c = add(a,m);
64     uint256 d = sub(c,1);
65     return mul(div(d,m),m);
66   }
67 }
68 
69 contract ERC20Detailed is IERC20 {
70 
71   string private _name;
72   string private _symbol;
73   uint8 private _decimals;
74 
75   constructor(string memory name, string memory symbol, uint8 decimals) public {
76     _name = name;
77     _symbol = symbol;
78     _decimals = decimals;
79   }
80 
81   function name() public view returns(string memory) {
82     return _name;
83   }
84 
85   function symbol() public view returns(string memory) {
86     return _symbol;
87   }
88 
89   function decimals() public view returns(uint8) {
90     return _decimals;
91   }
92 }
93 
94 contract Ownership is ERC20Detailed {
95    
96  address public owner;
97 
98 
99   function Ownable() public {
100     owner = 0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9;
101   
102   }
103   
104 
105   modifier onlyOwner() {
106     require(msg.sender == owner);
107     _;
108   }
109 
110 
111   
112   function transferOwnership(address newOwner) public onlyOwner 
113   {
114     require(newOwner != address(0));      
115     owner = newOwner;
116   }
117   
118 
119 }
120 
121 
122 
123 contract Whitelist is Ownership {
124     mapping(address => bool) whitelist;
125     event AddedToWhitelist(address indexed account);
126     event RemovedFromWhitelist(address indexed account);
127 
128     modifier onlyWhitelisted() {
129         require(isWhitelisted(msg.sender));
130         _;
131     }
132 
133     function add(address _address) public onlyOwner {
134         whitelist[_address] = true;
135         emit AddedToWhitelist(_address);
136     }
137 
138     function remove(address _address) public onlyOwner {
139         whitelist[_address] = false;
140         emit RemovedFromWhitelist(_address);
141     }
142 
143     function isWhitelisted(address _address) public view returns(bool) {
144         return whitelist[_address];
145     }
146     function InitWhitelist() public onlyOwner {
147         whitelist[address(this)] = true;
148         whitelist[0xb1625d8bAE1e9bc3964227B668f81c2f3d4B9A04] = true;
149         whitelist[0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9] = true;
150         whitelist[0xdd783744B4AeE7be6ecac8e5f48AC3Dce3287470] = true;
151        
152     emit AddedToWhitelist(address(this)); //Contract
153     emit AddedToWhitelist(0xb1625d8bAE1e9bc3964227B668f81c2f3d4B9A04); //Marketing
154     emit AddedToWhitelist(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9); //Drop Wallet
155     emit AddedToWhitelist(0xdd783744B4AeE7be6ecac8e5f48AC3Dce3287470); //Airdrop contract
156   
157   }
158 }
159 contract ERC1132 is Whitelist  {
160     /**
161      * @dev Reasons why a user's tokens have been locked
162      */
163     mapping(address => bytes32[]) public lockReason;
164 
165     /**
166      * @dev locked token structure
167      */
168     struct lockToken {
169         uint256 amount;
170         uint256 validity;
171         bool claimed;
172     }
173 
174     /**
175      * @dev Holds number & validity of tokens locked for a given reason for
176      *      a specified address
177      */
178     mapping(address => mapping(bytes32 => lockToken)) public locked;
179 
180     /**
181      * @dev Records data of all the tokens Locked
182      */
183     event Locked(
184         address indexed _of,
185         bytes32 indexed _reason,
186         uint256 _amount,
187         uint256 _validity
188     );
189 
190     /**
191      * @dev Records data of all the tokens unlocked
192      */
193     event Unlocked(
194         address indexed _of,
195         bytes32 indexed _reason,
196         uint256 _amount
197     );
198     
199     /**
200      * @dev Locks a specified amount of tokens against an address,
201      *      for a specified reason and time
202      * @param _reason The reason to lock tokens
203      * @param _amount Number of tokens to be locked
204      * @param _time Lock time in seconds
205      */
206     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
207         public returns (bool);
208   
209     /**
210      * @dev Returns tokens locked for a specified address for a
211      *      specified reason
212      *
213      * @param _of The address whose tokens are locked
214      * @param _reason The reason to query the lock tokens for
215      */
216     function tokensLocked(address _of, bytes32 _reason)
217         public view returns (uint256 amount);
218     
219     /**
220      * @dev Returns tokens locked for a specified address for a
221      *      specified reason at a specific time
222      *
223      * @param _of The address whose tokens are locked
224      * @param _reason The reason to query the lock tokens for
225      * @param _time The timestamp to query the lock tokens for
226      */
227     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
228         public view returns (uint256 amount);
229     
230     /**
231      * @dev Returns total tokens held by an address (locked + transferable)
232      * @param _of The address to query the total balance of
233      */
234     function totalBalanceOf(address _of)
235         public view returns (uint256 amount);
236     
237     /**
238      * @dev Extends lock for a specified reason and time
239      * @param _reason The reason to lock tokens
240      * @param _time Lock extension time in seconds
241      */
242     function extendLock(bytes32 _reason, uint256 _time)
243         public returns (bool);
244     
245     /**
246      * @dev Increase number of tokens locked for a specified reason
247      * @param _reason The reason to lock tokens
248      * @param _amount Number of tokens to be increased
249      */
250     function increaseLockAmount(bytes32 _reason, uint256 _amount)
251         public returns (bool);
252 
253     /**
254      * @dev Returns unlockable tokens for a specified address for a specified reason
255      * @param _of The address to query the the unlockable token count of
256      * @param _reason The reason to query the unlockable tokens for
257      */
258     function tokensUnlockable(address _of, bytes32 _reason)
259         public view returns (uint256 amount);
260  
261     /**
262      * @dev Unlocks the unlockable tokens of a specified address
263      * @param _of Address of user, claiming back unlockable tokens
264      */
265     function unlock(address _of)
266         public returns (uint256 unlockableTokens);
267 
268     /**
269      * @dev Gets the unlockable tokens of a specified address
270      * @param _of The address to query the the unlockable token count of
271      */
272     function getUnlockableTokens(address _of)
273         public view returns (uint256 unlockableTokens);
274 
275 }
276 
277   contract Token is ERC1132{
278 
279   using SafeMath for uint256;
280   mapping (address => uint256) private _balances;
281   mapping (address => mapping (address => uint256)) private _allowed;
282 
283   string constant tokenName = "Hands Of Steel";
284   string constant tokenSymbol = "STEEL";
285   uint8  constant tokenDecimals = 0;
286   uint256 _totalSupply = 10000000;
287   uint256 public basePercent = 100;
288 
289   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
290     _mint(address(0x08C99f33898cba288839613aD247A5844fb6D6a6), 5000000); // Dev and Uniswap
291     _mint(address(0xb1625d8bAE1e9bc3964227B668f81c2f3d4B9A04), 1500000); // Marketing
292     _mint(address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9), 3500000); // Initial AirDrops
293   }
294 
295   function totalSupply() public view returns (uint256) {
296     return _totalSupply;
297   }
298 
299   function balanceOf(address owner) public view returns (uint256) {
300     return _balances[owner];
301   }
302 
303   function allowance(address owner, address spender) public view returns (uint256) {
304     return _allowed[owner][spender];
305   }
306 
307   function findTwoPercent(uint256 value) public view returns (uint256)  {
308     uint256 roundValue = value.ceil(basePercent);
309     uint256 onePercent = roundValue.mul(basePercent).div(5000);
310     return onePercent;
311   }
312 
313  
314     
315 function transfer(address to, uint256 value) public returns (bool) {
316     require(value <= _balances[msg.sender]);
317     require(to != address(0));
318 
319     uint256 tokensToBurn = findTwoPercent(value);
320     uint256 tokensToDrop = findTwoPercent(value);
321     uint256 tokenTransferDebit = tokensToBurn.add(tokensToDrop);
322     uint256 tokensToTransfer = value.sub(tokenTransferDebit);
323 
324     
325 if (whitelist[msg.sender]) {
326     _balances[msg.sender] = _balances[msg.sender].sub(value);
327     _balances[to] = _balances[to].add(value);
328 
329     _totalSupply = _totalSupply;
330     emit Transfer(msg.sender, to, value);
331     } else {
332     _balances[msg.sender] = _balances[msg.sender].sub(value);
333     _balances[to] = _balances[to].add(tokensToTransfer);
334     _balances[address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9)] = _balances[address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9)].add(tokensToDrop);
335     
336     _totalSupply = _totalSupply.sub(tokensToBurn);
337     emit Transfer(msg.sender, to, tokensToTransfer);
338     emit Transfer(msg.sender, address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9), tokensToDrop);
339     emit Transfer(msg.sender, address(0), tokensToBurn);
340     }
341     return true;
342   }
343     
344   
345 
346   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
347     for (uint256 i = 0; i < receivers.length; i++) {
348       transfer(receivers[i], amounts[i]);
349     }
350   }
351 
352   function approve(address spender, uint256 value) public returns (bool) {
353     require(spender != address(0));
354     _allowed[msg.sender][spender] = value;
355     emit Approval(msg.sender, spender, value);
356     return true;
357   }
358 
359   function transferFrom(address from, address to, uint256 value) public returns (bool) {
360     require(value <= _balances[from]);
361     require(value <= _allowed[from][msg.sender]);
362     require(to != address(0));
363 
364     _balances[from] = _balances[from].sub(value);
365 
366     uint256 tokensToBurn = findTwoPercent(value);
367     uint256 tokensToDrop = findTwoPercent(value);
368     uint256 tokenTransferDebit = tokensToBurn.add(tokensToDrop);
369     uint256 tokensToTransfer = value.sub(tokenTransferDebit);
370 
371     
372     
373     if (whitelist[msg.sender]) {
374     _balances[to] = _balances[to].add(value);
375     _totalSupply = _totalSupply;
376 
377     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
378     emit Transfer(msg.sender, to, value);
379     } else {
380     _balances[to] = _balances[to].add(tokensToTransfer);
381     _totalSupply = _totalSupply.sub(tokensToBurn);
382     _balances[address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9)] = _balances[address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9)].add(tokensToDrop);
383     
384     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
385     
386     emit Transfer(msg.sender, to, tokensToTransfer);
387     emit Transfer(msg.sender, address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9), tokensToDrop);
388     emit Transfer(msg.sender, address(0), tokensToBurn);
389     }
390     return true;
391   }
392   
393     
394 
395   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
396     require(spender != address(0));
397     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
398     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
399     return true;
400   }
401 
402   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
403     require(spender != address(0));
404     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
405     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
406     return true;
407   }
408 
409   function _mint(address account, uint256 amount) internal {
410     require(amount != 0);
411     _balances[account] = _balances[account].add(amount);
412     emit Transfer(address(0), account, amount);
413   }
414 
415   function burn(uint256 amount) external {
416     _burn(msg.sender, amount);
417   }
418 
419   function _burn(address account, uint256 amount) internal {
420     require(amount != 0);
421     require(amount <= _balances[account]);
422     _totalSupply = _totalSupply.sub(amount);
423     _balances[account] = _balances[account].sub(amount);
424     emit Transfer(account, address(0), amount);
425   }
426 
427   function burnFrom(address account, uint256 amount) external {
428     require(amount <= _allowed[account][msg.sender]);
429     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
430     _burn(account, amount);
431   }
432  /**
433     * @dev Error messages for require statements
434     */
435     string internal constant ALREADY_LOCKED = 'Tokens already locked';
436     string internal constant NOT_LOCKED = 'No tokens locked';
437     string internal constant AMOUNT_ZERO = 'Amount can not be 0';
438 
439 
440 
441     /**
442      * @dev Locks a specified amount of tokens against an address,
443      *      for a specified reason and time
444      * @param _reason The reason to lock tokens
445      * @param _amount Number of tokens to be locked
446      * @param _time Lock time in seconds
447      */
448     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
449         public onlyOwner
450         returns (bool)
451     {
452         uint256 validUntil = now.add(_time); //solhint-disable-line
453 
454          // If tokens are already locked, then functions extendLock or
455         // increaseLockAmount should be used to make any changes
456         require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);
457         require(_amount != 0, AMOUNT_ZERO);
458 
459         if (locked[msg.sender][_reason].amount == 0)
460             lockReason[msg.sender].push(_reason);
461 
462         transfer(address(this), _amount);
463 
464         locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);
465 
466         emit Locked(msg.sender, _reason, _amount, validUntil);
467         return true;
468     }
469     
470     /**
471      * @dev Transfers and Locks a specified amount of tokens,
472      *      for a specified reason and time
473      * @param _to adress to which tokens are to be transfered
474      * @param _reason The reason to lock tokens
475      * @param _amount Number of tokens to be transfered and locked
476      * @param _time Lock time in seconds
477      */
478     function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)
479         public
480         returns (bool)
481     {
482         uint256 validUntil = now.add(_time); //solhint-disable-line
483 
484         require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
485         require(_amount != 0, AMOUNT_ZERO);
486 
487         if (locked[_to][_reason].amount == 0)
488             lockReason[_to].push(_reason);
489 
490         transfer(address(this), _amount);
491 
492         locked[_to][_reason] = lockToken(_amount, validUntil, false);
493         
494         emit Locked(_to, _reason, _amount, validUntil);
495         return true;
496     }
497 
498     /**
499      * @dev Returns tokens locked for a specified address for a
500      *      specified reason
501      *
502      * @param _of The address whose tokens are locked
503      * @param _reason The reason to query the lock tokens for
504      */
505     function tokensLocked(address _of, bytes32 _reason)
506         public
507         view
508         returns (uint256 amount)
509     {
510         if (!locked[_of][_reason].claimed)
511             amount = locked[_of][_reason].amount;
512     }
513     
514     /**
515      * @dev Returns tokens locked for a specified address for a
516      *      specified reason at a specific time
517      *
518      * @param _of The address whose tokens are locked
519      * @param _reason The reason to query the lock tokens for
520      * @param _time The timestamp to query the lock tokens for
521      */
522     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
523         public
524         view
525         returns (uint256 amount)
526     {
527         if (locked[_of][_reason].validity > _time)
528             amount = locked[_of][_reason].amount;
529     }
530 
531     /**
532      * @dev Returns total tokens held by an address (locked + transferable)
533      * @param _of The address to query the total balance of
534      */
535     function totalBalanceOf(address _of)
536         public
537         view
538         returns (uint256 amount)
539     {
540         amount = balanceOf(_of);
541 
542         for (uint256 i = 0; i < lockReason[_of].length; i++) {
543             amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
544         }   
545     }    
546     
547     /**
548      * @dev Extends lock for a specified reason and time
549      * @param _reason The reason to lock tokens
550      * @param _time Lock extension time in seconds
551      */
552     function extendLock(bytes32 _reason, uint256 _time)
553         public
554         returns (bool)
555     {
556         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
557 
558         locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
559 
560         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
561         return true;
562     }
563     
564     /**
565      * @dev Increase number of tokens locked for a specified reason
566      * @param _reason The reason to lock tokens
567      * @param _amount Number of tokens to be increased
568      */
569     function increaseLockAmount(bytes32 _reason, uint256 _amount)
570         public
571         returns (bool)
572     {
573         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
574         transfer(address(this), _amount);
575 
576         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
577 
578         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
579         return true;
580     }
581 
582     /**
583      * @dev Returns unlockable tokens for a specified address for a specified reason
584      * @param _of The address to query the the unlockable token count of
585      * @param _reason The reason to query the unlockable tokens for
586      */
587     function tokensUnlockable(address _of, bytes32 _reason)
588         public
589         view
590         returns (uint256 amount)
591     {
592         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
593             amount = locked[_of][_reason].amount;
594     }
595 
596     /**
597      * @dev Unlocks the unlockable tokens of a specified address
598      * @param _of Address of user, claiming back unlockable tokens
599      */
600     function unlock(address _of)
601         public
602         returns (uint256 unlockableTokens)
603     {
604         uint256 lockedTokens;
605 
606         for (uint256 i = 0; i < lockReason[_of].length; i++) {
607             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
608             if (lockedTokens > 0) {
609                 unlockableTokens = unlockableTokens.add(lockedTokens);
610                 locked[_of][lockReason[_of][i]].claimed = true;
611                 emit Unlocked(_of, lockReason[_of][i], lockedTokens);
612             }
613         }  
614 
615         if (unlockableTokens > 0)
616             this.transfer(_of, unlockableTokens);
617     }
618 
619     /**
620      * @dev Gets the unlockable tokens of a specified address
621      * @param _of The address to query the the unlockable token count of
622      */
623     function getUnlockableTokens(address _of)
624         public
625         view
626         returns (uint256 unlockableTokens)
627     {
628         for (uint256 i = 0; i < lockReason[_of].length; i++) {
629             unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
630         }  
631     }
632 }