1 pragma solidity ^0.5.0;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 // Safe maths
7 // ----------------------------------------------------------------------------
8 library SafeMath {
9     function add(uint a, uint b) internal pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function sub(uint a, uint b) internal pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function div(uint a, uint b) internal pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 } 
26 
27 
28 // ----------------------------------------------------------------------------
29 // ERC Toke n Standard #20 Interface
30 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
31 // ----------------------------------------------------------------------------
32 contract ERC20Interface {
33     function totalSupply() public view returns (uint);
34     function balanceOf(address tokenOwner) public view returns (uint balance);
35     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
36     function transfer(address to, uint tokens) public returns (bool success);
37     function approve(address spender, uint tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint tokens) public returns (bool success);
39 
40     event Transfer(address indexed from, address indexed to, uint tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43 
44 
45 // ----------------------------------------------------------------------------
46 // Contract function to receive approval and execute function in one call
47 //
48 // Borrowed from MiniMeToken
49 // ----------------------------------------------------------------------------
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Owned contract
57 // ----------------------------------------------------------------------------
58 contract Owned {
59     address public owner;
60     address public newOwner;
61 
62     event OwnershipTransferred(address indexed _from, address indexed _to);
63 
64     constructor() public {
65         owner = 0x9E48E9C4a696020cCFd07aAD7476a830eA14a819;
66     }
67 
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function transferOwnership(address _newOwner) public onlyOwner {
74         newOwner = _newOwner;
75     }
76     function acceptOwnership() public {
77         require(msg.sender == newOwner);
78         emit OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80         newOwner = address(0);
81     }
82 }
83 
84 contract ERC1132 {
85     /**
86      * @dev Reasons why a user's tokens have been locked
87      */
88     mapping(address => bytes32[]) public lockReason;
89 
90     /**
91      * @dev locked token structure
92      */
93     struct lockToken {
94         uint256 amount;
95         uint256 validity;
96         bool claimed;
97     }
98 
99     /**
100      * @dev Holds number & validity of tokens locked for a given reason for
101      *      a specified address
102      */
103     mapping(address => mapping(bytes32 => lockToken)) public locked;
104 
105     /**
106      * @dev Records data of all the tokens Locked
107      */
108     event Locked(
109         address indexed _of,
110         bytes32 indexed _reason,
111         uint256 _amount,
112         uint256 _validity
113     );
114 
115     /**
116      * @dev Records data of all the tokens unlocked
117      */
118     event Unlocked(
119         address indexed _of,
120         bytes32 indexed _reason,
121         uint256 _amount
122     );
123     
124     /**
125      * @dev Locks a specified amount of tokens against an address,
126      *      for a specified reason and time
127      * @param _reason The reason to lock tokens
128      * @param _amount Number of tokens to be locked
129      * @param _time Lock time in seconds
130      */
131     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
132         public returns (bool);
133   
134     /**
135      * @dev Returns tokens locked for a specified address for a
136      *      specified reason
137      *
138      * @param _of The address whose tokens are locked
139      * @param _reason The reason to query the lock tokens for
140      */
141     function tokensLocked(address _of, bytes32 _reason)
142         public view returns (uint256 amount);
143     
144     /**
145      * @dev Returns tokens locked for a specified address for a
146      *      specified reason at a specific time
147      *
148      * @param _of The address whose tokens are locked
149      * @param _reason The reason to query the lock tokens for
150      * @param _time The timestamp to query the lock tokens for
151      */
152     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
153         public view returns (uint256 amount);
154     
155     /**
156      * @dev Returns total tokens held by an address (locked + transferable)
157      * @param _of The address to query the total balance of
158      */
159     function totalBalanceOf(address _of)
160         public view returns (uint256 amount);
161     
162     /**
163      * @dev Extends lock for a specified reason and time
164      * @param _reason The reason to lock tokens
165      * @param _time Lock extension time in seconds
166      */
167     function extendLock(bytes32 _reason, uint256 _time)
168         public returns (bool);
169     
170     /**
171      * @dev Increase number of tokens locked for a specified reason
172      * @param _reason The reason to lock tokens
173      * @param _amount Number of tokens to be increased
174      */
175     function increaseLockAmount(bytes32 _reason, uint256 _amount)
176         public returns (bool);
177 
178     /**
179      * @dev Returns unlockable tokens for a specified address for a specified reason
180      * @param _of The address to query the the unlockable token count of
181      * @param _reason The reason to query the unlockable tokens for
182      */
183     function tokensUnlockable(address _of, bytes32 _reason)
184         public view returns (uint256 amount);
185  
186     /**
187      * @dev Unlocks the unlockable tokens of a specified address
188      * @param _of Address of user, claiming back unlockable tokens
189      */
190     function unlock(address _of)
191         public returns (uint256 unlockableTokens);
192 
193     /**
194      * @dev Gets the unlockable tokens of a specified address
195      * @param _of The address to query the the unlockable token count of
196      */
197     function getUnlockableTokens(address _of)
198         public view returns (uint256 unlockableTokens);
199 
200 }
201 
202 
203 
204 
205 // ----------------------------------------------------------------------------
206 // ERC20 Token, with the addition of symbol, name and decimals and a
207 // fixed supply
208 // ----------------------------------------------------------------------------
209 contract Token is ERC1132, ERC20Interface, Owned {
210     using SafeMath for uint;
211     
212     string internal constant ALREADY_LOCKED = 'Tokens already locked';
213     string internal constant NOT_LOCKED = 'No tokens locked';
214     string internal constant AMOUNT_ZERO = 'Amount can not be 0';
215 
216     string public symbol;
217     string public  name;
218     uint8 public decimals;
219     uint _totalSupply;
220 
221     mapping(address => uint) balances;
222     mapping(address => mapping(address => uint)) allowed;
223 
224 
225     // ------------------------------------------------------------------------
226     // Constructor
227     // ------------------------------------------------------------------------
228     constructor() public { 
229         name = "NIWIX";
230         symbol = "NWX";
231         decimals = 18;
232         _totalSupply = 1000000000 * 10**uint(decimals);
233         balances[owner] = _totalSupply;
234         emit Transfer(address(0), owner, _totalSupply);
235     }
236 
237 
238     // ------------------------------------------------------------------------
239     // Total supply
240     // ------------------------------------------------------------------------
241     function totalSupply() public view returns (uint) {
242         return _totalSupply.sub(balances[address(0)]);
243     }
244 
245 
246     // ------------------------------------------------------------------------
247     // Get the token balance for account `tokenOwner`
248     // ------------------------------------------------------------------------
249     function balanceOf(address tokenOwner) public view returns (uint balance) {
250         return balances[tokenOwner];
251     }
252 
253 
254     // ------------------------------------------------------------------------
255     // Transfer the balance from token owner's account to `to` account
256     // - Owner's account must have sufficient balance to transfer
257     // - 0 value transfers are allowed
258     // ------------------------------------------------------------------------
259     function transfer(address to, uint tokens) public returns (bool success) {
260         balances[msg.sender] = balances[msg.sender].sub(tokens);
261         balances[to] = balances[to].add(tokens);
262         emit Transfer(msg.sender, to, tokens);
263         return true;
264     }
265 
266 
267     // ------------------------------------------------------------------------
268     // Token owner can approve for `spender` to transferFrom(...) `tokens`
269     // from the token owner's account
270     //
271     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
272     // recommends that there are no checks for the approval double-spend attack
273     // as this should be implemented in user interfaces
274     // ------------------------------------------------------------------------
275     function approve(address spender, uint tokens) public returns (bool success) {
276         allowed[msg.sender][spender] = tokens;
277         emit Approval(msg.sender, spender, tokens);
278         return true;
279     }
280 
281 
282     // ------------------------------------------------------------------------
283     // Transfer `tokens` from the `from` account to the `to` account
284     //
285     // The calling account must already have sufficient tokens approve(...)-d
286     // for spending from the `from` account and
287     // - From account must have sufficient balance to transfer
288     // - Spender must have sufficient allowance to transfer
289     // - 0 value transfers are allowed
290     // ------------------------------------------------------------------------
291     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
292         balances[from] = balances[from].sub(tokens);
293         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
294         balances[to] = balances[to].add(tokens);
295         emit Transfer(from, to, tokens);
296         return true;
297     }
298 
299 
300     // ------------------------------------------------------------------------
301     // Returns the amount of tokens approved by the owner that can be
302     // transferred to the spender's account
303     // ------------------------------------------------------------------------
304     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
305         return allowed[tokenOwner][spender];
306     }
307 
308 
309     // ------------------------------------------------------------------------
310     // Token owner can approve for `spender` to transferFrom(...) `tokens`
311     // from the token owner's account. The `spender` contract function
312     // `receiveApproval(...)` is then executed
313     // ------------------------------------------------------------------------
314     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
315         allowed[msg.sender][spender] = tokens;
316         emit Approval(msg.sender, spender, tokens);
317         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
318         return true;
319     }
320 
321 
322     // ------------------------------------------------------------------------
323     // Don't accept ETH
324     // ------------------------------------------------------------------------
325     function () external payable {
326         revert();
327     }
328 
329 
330     // ------------------------------------------------------------------------
331     // Owner can transfer out any accidentally sent ERC20 tokens
332     // ------------------------------------------------------------------------
333     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
334         return ERC20Interface(tokenAddress).transfer(owner, tokens);
335     }
336     
337     function mint(address account, uint256 amount) onlyOwner public returns (bool) {
338         require(account != address(0), "ERC20: mint to the zero address");
339 
340         _totalSupply = _totalSupply.add(amount);
341         balances[account] = balances[account].add(amount);
342         emit Transfer(address(0), account, amount);
343     }
344 
345     /**
346      * @dev Destroys `amount` tokens from `account`, reducing the
347      * total supply.
348      *
349      * Emits a {Transfer} event with `to` set to the zero address.
350      *
351      * Requirements
352      *
353      * - `account` cannot be the zero address.
354      * - `account` must have at least `amount` tokens.
355      */
356     function burn(address account, uint256 amount) onlyOwner public returns (bool) {
357         require(account != address(0), "ERC20: burn from the zero address");
358 
359         balances[account] = balances[account].sub(amount);
360         _totalSupply = _totalSupply.sub(amount);
361         emit Transfer(account, address(0), amount);
362     }
363     
364     
365      /**
366      * @dev Locks a specified amount of tokens against an address,
367      *      for a specified reason and time
368      * @param _reason The reason to lock tokens
369      * @param _amount Number of tokens to be locked
370      * @param _time Lock time in seconds
371      */
372     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
373         public
374         returns (bool)
375     {
376         uint256 validUntil = now.add(_time); //solhint-disable-line
377 
378         // If tokens are already locked, then functions extendLock or
379         // increaseLockAmount should be used to make any changes
380         require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);
381         require(_amount != 0, AMOUNT_ZERO);
382 
383         if (locked[msg.sender][_reason].amount == 0)
384             lockReason[msg.sender].push(_reason);
385 
386         transfer(address(this), _amount);
387 
388         locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);
389 
390         emit Locked(msg.sender, _reason, _amount, validUntil);
391         return true;
392     }
393     
394     /**
395      * @dev Transfers and Locks a specified amount of tokens,
396      *      for a specified reason and time
397      * @param _to adress to which tokens are to be transfered
398      * @param _reason The reason to lock tokens
399      * @param _amount Number of tokens to be transfered and locked
400      * @param _time Lock time in seconds
401      */
402     function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)
403         public
404         returns (bool)
405     {
406         uint256 validUntil = now.add(_time); //solhint-disable-line
407 
408         require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
409         require(_amount != 0, AMOUNT_ZERO);
410 
411         if (locked[_to][_reason].amount == 0)
412             lockReason[_to].push(_reason);
413 
414         transfer(address(this), _amount);
415 
416         locked[_to][_reason] = lockToken(_amount, validUntil, false);
417         
418         emit Locked(_to, _reason, _amount, validUntil);
419         return true;
420     }
421 
422     /**
423      * @dev Returns tokens locked for a specified address for a
424      *      specified reason
425      *
426      * @param _of The address whose tokens are locked
427      * @param _reason The reason to query the lock tokens for
428      */
429     function tokensLocked(address _of, bytes32 _reason)
430         public
431         view
432         returns (uint256 amount)
433     {
434         if (!locked[_of][_reason].claimed)
435             amount = locked[_of][_reason].amount;
436     }
437     
438     /**
439      * @dev Returns tokens locked for a specified address for a
440      *      specified reason at a specific time
441      *
442      * @param _of The address whose tokens are locked
443      * @param _reason The reason to query the lock tokens for
444      * @param _time The timestamp to query the lock tokens for
445      */
446     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
447         public
448         view
449         returns (uint256 amount)
450     {
451         if (locked[_of][_reason].validity > _time)
452             amount = locked[_of][_reason].amount;
453     }
454 
455     /**
456      * @dev Returns total tokens held by an address (locked + transferable)
457      * @param _of The address to query the total balance of
458      */
459     function totalBalanceOf(address _of)
460         public
461         view
462         returns (uint256 amount)
463     {
464         amount = balanceOf(_of);
465 
466         for (uint256 i = 0; i < lockReason[_of].length; i++) {
467             amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
468         }   
469     }    
470     
471     /**
472      * @dev Extends lock for a specified reason and time
473      * @param _reason The reason to lock tokens
474      * @param _time Lock extension time in seconds
475      */
476     function extendLock(bytes32 _reason, uint256 _time)
477         public
478         returns (bool)
479     {
480         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
481 
482         locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
483 
484         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
485         return true;
486     }
487     
488     /**
489      * @dev Increase number of tokens locked for a specified reason
490      * @param _reason The reason to lock tokens
491      * @param _amount Number of tokens to be increased
492      */
493     function increaseLockAmount(bytes32 _reason, uint256 _amount)
494         public
495         returns (bool)
496     {
497         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
498         transfer(address(this), _amount);
499 
500         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
501 
502         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
503         return true;
504     }
505 
506     /**
507      * @dev Returns unlockable tokens for a specified address for a specified reason
508      * @param _of The address to query the the unlockable token count of
509      * @param _reason The reason to query the unlockable tokens for
510      */
511     function tokensUnlockable(address _of, bytes32 _reason)
512         public
513         view
514         returns (uint256 amount)
515     {
516         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
517             amount = locked[_of][_reason].amount;
518     }
519 
520     /**
521      * @dev Unlocks the unlockable tokens of a specified address
522      * @param _of Address of user, claiming back unlockable tokens
523      */
524     function unlock(address _of)
525         public
526         returns (uint256 unlockableTokens)
527     {
528         uint256 lockedTokens;
529 
530         for (uint256 i = 0; i < lockReason[_of].length; i++) {
531             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
532             if (lockedTokens > 0) {
533                 unlockableTokens = unlockableTokens.add(lockedTokens);
534                 locked[_of][lockReason[_of][i]].claimed = true;
535                 emit Unlocked(_of, lockReason[_of][i], lockedTokens);
536             }
537         }  
538 
539         if (unlockableTokens > 0)
540             this.transfer(_of, unlockableTokens);
541     }
542 
543     /**
544      * @dev Gets the unlockable tokens of a specified address
545      * @param _of The address to query the the unlockable token count of
546      */
547     function getUnlockableTokens(address _of)
548         public
549         view
550         returns (uint256 unlockableTokens)
551     {
552         for (uint256 i = 0; i < lockReason[_of].length; i++) {
553             unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
554         }  
555     }
556     
557     
558    
559     
560 }