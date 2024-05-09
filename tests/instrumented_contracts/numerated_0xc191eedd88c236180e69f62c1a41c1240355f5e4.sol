1 pragma solidity >=0.4.0 <0.6.0;
2 
3 /* taking ideas from FirstBlood token */
4 contract SafeMath {
5 
6     /* function assert(bool assertion) internal { */
7     /*   if (!assertion) { */
8     /*     throw; */
9     /*   } */
10     /* }      // assert no longer needed once solidity is on 0.4.10 */
11 
12     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
13       uint256 z = x + y;
14       assert((z >= x) && (z >= y));
15       return z;
16     }
17 
18     function safeSubtract(uint256 x, uint256 y) internal pure  returns(uint256) {
19       assert(x >= y);
20       uint256 z = x - y;
21       return z;
22     }
23 
24     function safeMult(uint256 x, uint256 y) internal pure  returns(uint256) {
25       uint256 z = x * y;
26       assert((x == 0)||(z/x == y));
27       return z;
28     }
29 
30 }
31 
32 contract Token {
33     uint256 public totalSupply;
34     function balanceOf(address _owner) public view  returns (uint256 balance);
35     function transfer(address _to, uint256 _value) public returns (bool success);
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37     function approve(address _spender, uint256 _value) public returns (bool success);
38     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 /*  ERC 20 token */
44 contract StandardToken is Token {
45     function transfer(address _to, uint256 _value) public returns (bool success) {
46       if (balances[msg.sender] >= _value && _value > 0) {
47         balances[msg.sender] -= _value;
48         balances[_to] += _value;
49         emit Transfer(msg.sender, _to, _value);
50         return true;
51       } else {
52         return false;
53       }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
57       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58         balances[_to] += _value;
59         balances[_from] -= _value;
60         allowed[_from][msg.sender] -= _value;
61         emit Transfer(_from, _to, _value);
62         return true;
63       } else {
64         return false;
65       }
66     }
67 
68     function balanceOf(address _owner) public view returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) public returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85 
86 contract ERC1132 {
87     /**
88      * @dev Reasons why a user's tokens have been locked
89      */
90     mapping(address => string[]) public lockReason;
91 
92     /**
93      * @dev locked token structure
94      */
95     struct lockToken {
96         uint256 amount;
97         uint256 validity;
98         bool claimed;
99     }
100 
101     /**
102      * @dev Holds number & validity of tokens locked for a given reason for
103      *      a specified address
104      */
105     mapping(address => mapping(string => lockToken)) public locked;
106 
107     /**
108      * @dev Records data of all the tokens Locked
109      */
110     event Locked(
111         address indexed _of,
112         string indexed _reason,
113         uint256 _amount,
114         uint256 _validity
115     );
116 
117     /**
118      * @dev Records data of all the tokens unlocked
119      */
120     event Unlocked(
121         address indexed _of,
122         string indexed _reason,
123         uint256 _amount
124     );
125 
126     /**
127      * @dev Locks a specified amount of tokens against an address,
128      *      for a specified reason and time
129      * @param _reason The reason to lock tokens
130      * @param _amount Number of tokens to be locked
131      * @param _time Lock time in seconds
132      */
133     function lock(string memory _reason, uint256 _amount, uint256 _time)
134         public returns (bool);
135     /**
136      * @dev Returns tokens locked for a specified address for a
137      *      specified reason
138      *
139      * @param _of The address whose tokens are locked
140      * @param _reason The reason to query the lock tokens for
141      */
142     function tokensLocked(address _of, string memory _reason)
143         public view returns (uint256 amount);
144     /**
145      * @dev Returns tokens locked for a specified address for a
146      *      specified reason at a specific time
147      *
148      * @param _of The address whose tokens are locked
149      * @param _reason The reason to query the lock tokens for
150      * @param _time The timestamp to query the lock tokens for
151      */
152     function tokensLockedAtTime(address _of, string memory _reason, uint256 _time)
153         public view returns (uint256 amount);
154     /**
155      * @dev Returns total tokens held by an address (locked + transferable)
156      * @param _of The address to query the total balance of
157      */
158     function totalBalanceOf(address _of)
159         public view returns (uint256 amount);
160     /**
161      * @dev Extends lock for a specified reason and time
162      * @param _reason The reason to lock tokens
163      * @param _time Lock extension time in seconds
164      */
165     function extendLock(string memory _reason, uint256 _time)
166         public returns (bool);
167     /**
168      * @dev Increase number of tokens locked for a specified reason
169      * @param _reason The reason to lock tokens
170      * @param _amount Number of tokens to be increased
171      */
172     function increaseLockAmount(string memory _reason, uint256 _amount)
173         public returns (bool);
174 
175     /**
176      * @dev Returns unlockable tokens for a specified address for a specified reason
177      * @param _of The address to query the the unlockable token count of
178      * @param _reason The reason to query the unlockable tokens for
179      */
180     function tokensUnlockable(address _of, string memory _reason)
181         public view returns (uint256 amount);
182     /**
183      * @dev Unlocks the unlockable tokens of a specified address
184      * @param _of Address of user, claiming back unlockable tokens
185      */
186     function unlock(address _of)
187         public returns (uint256 unlockableTokens);
188 
189     /**
190      * @dev Gets the unlockable tokens of a specified address
191      * @param _of The address to query the the unlockable token count of
192      */
193     function getUnlockableTokens(address _of)
194         public view returns (uint256 unlockableTokens);
195 
196 }
197 
198 contract Lockable is ERC1132,StandardToken {
199 
200     string internal constant ALREADY_LOCKED = 'Tokens already locked';
201     string internal constant NOT_LOCKED = 'No tokens locked';
202     string internal constant AMOUNT_ZERO = 'Amount can not be 0';
203     /**
204      * @dev Locks a specified amount of tokens against an address,
205      *      for a specified reason and time
206      * @param _reason The reason to lock tokens
207      * @param _amount Number of tokens to be locked
208      * @param _time Lock time in days
209      */
210     function lock(string memory _reason, uint256 _amount, uint256 _time)
211         public
212         returns (bool)
213     {
214         uint256 validUntil = now + (_time * 1 days); //solhint-disable-line
215 
216         // If tokens are already locked, then functions extendLock or
217         // increaseLockAmount should be used to make any changes
218         require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);
219         require(_amount != 0, AMOUNT_ZERO);
220 
221         if (locked[msg.sender][_reason].amount == 0)
222             lockReason[msg.sender].push(_reason);
223 
224         transfer(address(this), _amount);
225 
226         locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);
227 
228         emit Locked(msg.sender, _reason, _amount, validUntil);
229         return true;
230     }
231     /**
232      * @dev Transfers and Locks a specified amount of tokens,
233      *      for a specified reason and time
234      * @param _to adress to which tokens are to be transfered
235      * @param _reason The reason to lock tokens
236      * @param _amount Number of tokens to be transfered and locked
237      * @param _time Lock time in seconds
238      */
239     function transferWithLock(address _to, string memory _reason, uint256 _amount, uint256 _time)
240         public
241         returns (bool)
242     {
243         uint256 validUntil = now + (_time * 1 days); //solhint-disable-line
244 
245         require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
246         require(_amount != 0, AMOUNT_ZERO);
247 
248         if (locked[_to][_reason].amount == 0)
249             lockReason[_to].push(_reason);
250 
251         transfer(address(this), _amount);
252 
253         locked[_to][_reason] = lockToken(_amount, validUntil, false);
254         emit Locked(_to, _reason, _amount, validUntil);
255         return true;
256     }
257 
258     /**
259      * @dev Returns tokens locked for a specified address for a
260      *      specified reason
261      *
262      * @param _of The address whose tokens are locked
263      * @param _reason The reason to query the lock tokens for
264      */
265     function tokensLocked(address _of, string memory _reason)
266         public
267         view
268         returns (uint256 amount)
269     {
270         if (!locked[_of][_reason].claimed)
271             amount = locked[_of][_reason].amount;
272     }
273     /**
274      * @dev Returns tokens locked for a specified address for a
275      *      specified reason at a specific time
276      *
277      * @param _of The address whose tokens are locked
278      * @param _reason The reason to query the lock tokens for
279      * @param _time The timestamp to query the lock tokens for
280      */
281     function tokensLockedAtTime(address _of, string memory _reason, uint256 _time)
282         public
283         view
284         returns (uint256 amount)
285     {
286         if (locked[_of][_reason].validity > _time)
287             amount = locked[_of][_reason].amount;
288     }
289 
290     /**
291      * @dev Returns total tokens held by an address (locked + transferable)
292      * @param _of The address to query the total balance of
293      */
294     function totalBalanceOf(address _of)
295         public
296         view
297         returns (uint256 amount)
298     {
299         amount = balanceOf(_of);
300 
301         for (uint256 i = 0; i < lockReason[_of].length; i++) {
302             amount = amount + (tokensLocked(_of, lockReason[_of][i]));
303         }
304     }
305     /**
306      * @dev Extends lock for a specified reason and time
307      * @param _reason The reason to lock tokens
308      * @param _time Lock extension time in seconds
309      */
310     function extendLock(string memory _reason, uint256 _time)
311         public
312         returns (bool)
313     {
314         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
315 
316         locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity + (_time);
317 
318         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
319         return true;
320     }
321     /**
322      * @dev Increase number of tokens locked for a specified reason
323      * @param _reason The reason to lock tokens
324      * @param _amount Number of tokens to be increased
325      */
326     function increaseLockAmount(string memory _reason, uint256 _amount)
327         public
328         returns (bool)
329     {
330         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
331         transfer(address(this), _amount);
332 
333         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount + (_amount);
334 
335         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
336         return true;
337     }
338 
339     /**
340      * @dev Returns unlockable tokens for a specified address for a specified reason
341      * @param _of The address to query the the unlockable token count of
342      * @param _reason The reason to query the unlockable tokens for
343      */
344     function tokensUnlockable(address _of, string memory _reason)
345         public
346         view
347         returns (uint256 amount)
348     {
349         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
350             amount = locked[_of][_reason].amount;
351     }
352 
353     /**
354      * @dev Unlocks the unlockable tokens of a specified address
355      * @param _of Address of user, claiming back unlockable tokens
356      */
357     function unlock(address _of)
358         public
359         returns (uint256 unlockableTokens)
360     {
361         uint256 lockedTokens;
362 
363         for (uint256 i = 0; i < lockReason[_of].length; i++) {
364             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
365             if (lockedTokens > 0) {
366                 unlockableTokens = unlockableTokens + (lockedTokens);
367                 locked[_of][lockReason[_of][i]].claimed = true;
368                 emit Unlocked(_of, lockReason[_of][i], lockedTokens);
369             }
370         }
371 
372         if (unlockableTokens > 0)
373             this.transfer(_of, unlockableTokens);
374     }
375 
376     /**
377      * @dev Gets the unlockable tokens of a specified address
378      * @param _of The address to query the the unlockable token count of
379      */
380     function getUnlockableTokens(address _of)
381         public
382         view
383         returns (uint256 unlockableTokens)
384     {
385         for (uint256 i = 0; i < lockReason[_of].length; i++) {
386             unlockableTokens = unlockableTokens + (tokensUnlockable(_of, lockReason[_of][i]));
387         }
388     }
389 }
390 
391 
392 contract AGToken is Lockable, SafeMath {
393 
394     // metadata
395     string public constant name = "Agri10x Token";
396     string public constant symbol = "AG10";
397     uint256 public constant decimals = 18;
398     string public version = "1.0";
399     string internal constant PUBLIC_LOCKED = 'Public sale of token is locked';
400     address owner;
401     // contracts
402     address payable ethFundDeposit;      // deposit address for ETH for Agri10x International
403     address payable agtFundDeposit;      // deposit address for Agri10x International use and AGT User Fund
404 
405     // crowdsale parameters
406     bool public isFinalized;              // switched to true in operational state
407     uint256 public fundingStartBlock;
408     uint256 public fundingEndBlock;
409     uint256 public constant agtFund = 45 * (10**6) * 10**decimals;   // 500m AGT reserved for Agri10x Intl use
410     uint256 public constant tokenExchangeRate = 1995; // 6400 AGT tokens per 1 ETH
411     uint256 public constant tokenCreationCap =  200 * (10**6) * 10**decimals;
412     uint256 public constant tokenCreationMin = 1 * (10**6) * 10**decimals;
413     uint256 public publicSaleDate;
414 
415 
416     // events
417     event LogRefund(address indexed _to, uint256 _value);
418     event CreateAGT(address indexed _to, uint256 _value);
419     event SoldAGT(address indexed _to, uint256 _value);
420 
421     modifier onlyOwner {
422         require(
423             msg.sender == owner,
424             "Only owner can call this function."
425         );
426         _;
427     }
428 
429     // constructor
430     constructor(
431         address payable _ethFundDeposit,
432         address payable _agtFundDeposit,
433         uint256 _fundingStartBlock,
434         uint256 _fundingEndBlock) public
435     {
436       owner = msg.sender;
437       publicSaleDate = now + (120 * 1 days);
438       isFinalized = false;                   //controls pre through crowdsale state
439       ethFundDeposit = _ethFundDeposit;
440       agtFundDeposit = _agtFundDeposit;
441       fundingStartBlock = _fundingStartBlock;
442       fundingEndBlock = _fundingEndBlock;
443       totalSupply = agtFund;
444       balances[agtFundDeposit] = agtFund;    // Deposit Agri10x Intl share
445       emit CreateAGT(agtFundDeposit, agtFund);  // logs Agri10x Intl fund
446     }
447 
448     /// @dev Accepts ether and creates new AGT tokens.
449     function customRatecreateTokens(uint256 customtokenExchangeRate) external payable  onlyOwner{
450       if (isFinalized) revert();
451       if (block.number < fundingStartBlock) revert();
452       if (block.number > fundingEndBlock) revert();
453       if (msg.value == 0) revert();
454 
455       uint256 tokens = safeMult(msg.value, customtokenExchangeRate); // check that we're not over totals
456       uint256 checkedSupply = safeAdd(totalSupply, tokens);
457 
458       // return money if something goes wrong
459       if (tokenCreationCap < checkedSupply) revert();  // odd fractions won't be found
460 
461       totalSupply = checkedSupply;
462       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
463       emit CreateAGT(msg.sender, tokens);  // logs token creation
464     }
465 
466     function createTokens() external payable  onlyOwner{
467       if (isFinalized) revert();
468       if (block.number < fundingStartBlock) revert();
469       if (block.number > fundingEndBlock) revert();
470       if (msg.value == 0) revert();
471 
472       uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
473       uint256 checkedSupply = safeAdd(totalSupply, tokens);
474 
475       // return money if something goes wrong
476       if (tokenCreationCap < checkedSupply) revert();  // odd fractions won't be found
477 
478       totalSupply = checkedSupply;
479       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
480       emit CreateAGT(msg.sender, tokens);  // logs token creation
481     }
482 
483     function publicSale() external payable {
484       require(publicSaleDate < now, PUBLIC_LOCKED);
485       if (msg.value == 0) revert();
486       uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
487       uint256 checkedSupply = safeAdd(totalSupply, tokens);
488 
489       // return money if something goes wrong
490       if (tokenCreationCap < checkedSupply) revert();  // odd fractions won't be found
491 
492       totalSupply = checkedSupply;
493       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
494       emit SoldAGT(msg.sender, tokens);  // logs token creation
495     }
496 
497     function changeSaleDate(uint256 _time) external onlyOwner{
498         publicSaleDate = now + (_time * 1 days);
499     }
500 
501     function createFreeTokens(uint256 numberOfTokens) external payable  onlyOwner{
502       uint256 tokens = safeMult(1, numberOfTokens); // check that we're not over totals
503       uint256 checkedSupply = safeAdd(totalSupply, tokens);
504 
505       // return money if something goes wrong
506       if (tokenCreationCap < checkedSupply) revert();  // odd fractions won't be found
507 
508       totalSupply = checkedSupply;
509       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
510       emit CreateAGT(msg.sender, tokens);  // logs token creation
511     }
512 
513     /// @dev Ends the funding period and sends the ETH home
514     function finalize() external onlyOwner{
515       if (isFinalized) revert();
516       if (msg.sender != ethFundDeposit) revert(); // locks finalize to the ultimate ETH owner
517       if(totalSupply < tokenCreationMin) revert();      // have to sell minimum to move to operational
518       if(block.number <= fundingEndBlock && totalSupply != tokenCreationCap) revert();
519       // move to operational
520       isFinalized = true;
521       if(!ethFundDeposit.send(address(this).balance)) revert();  // send the eth to Agri10x International
522     }
523 
524     /// @dev Allows contributors to recover their ether in the case of a failed funding campaign.
525     function refund() external onlyOwner{
526       if(isFinalized) revert();                       // prevents refund if operational
527       if (block.number <= fundingEndBlock) revert(); // prevents refund until sale period is over
528       if(totalSupply >= tokenCreationMin) revert();  // no refunds if we sold enough
529       if(msg.sender == agtFundDeposit) revert();    // Agri10x Intl not entitled to a refund
530       uint256 agtVal = balances[msg.sender];
531       if (agtVal == 0) revert();
532       balances[msg.sender] = 0;
533       totalSupply = safeSubtract(totalSupply, agtVal); // extra safe
534       uint256 ethVal = agtVal / tokenExchangeRate;     // should be safe; previous throws covers edges
535       emit LogRefund(msg.sender, ethVal);               // log it
536       if (!msg.sender.send(ethVal)) revert();       // if you're using a contract; make sure it works with .send gas limits
537     }
538 
539     function() external payable {}
540 
541 }