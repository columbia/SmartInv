1 pragma solidity ^0.4.13;
2 
3 library Roles {
4   struct Role {
5     mapping (address => bool) bearer;
6   }
7 
8   /**
9    * @dev give an account access to this role
10    */
11   function add(Role storage role, address account) internal {
12     require(account != address(0));
13     require(!has(role, account));
14 
15     role.bearer[account] = true;
16   }
17 
18   /**
19    * @dev remove an account's access to this role
20    */
21   function remove(Role storage role, address account) internal {
22     require(account != address(0));
23     require(has(role, account));
24 
25     role.bearer[account] = false;
26   }
27 
28   /**
29    * @dev check if an account has this role
30    * @return bool
31    */
32   function has(Role storage role, address account)
33     internal
34     view
35     returns (bool)
36   {
37     require(account != address(0));
38     return role.bearer[account];
39   }
40 }
41 
42 contract MinterRole {
43   using Roles for Roles.Role;
44 
45   event MinterAdded(address indexed account);
46   event MinterRemoved(address indexed account);
47 
48   Roles.Role private minters;
49 
50   constructor() internal {
51     _addMinter(msg.sender);
52   }
53 
54   modifier onlyMinter() {
55     require(isMinter(msg.sender));
56     _;
57   }
58 
59   function isMinter(address account) public view returns (bool) {
60     return minters.has(account);
61   }
62 
63   function addMinter(address account) public onlyMinter {
64     _addMinter(account);
65   }
66 
67   function renounceMinter() public {
68     _removeMinter(msg.sender);
69   }
70 
71   function _addMinter(address account) internal {
72     minters.add(account);
73     emit MinterAdded(account);
74   }
75 
76   function _removeMinter(address account) internal {
77     minters.remove(account);
78     emit MinterRemoved(account);
79   }
80 }
81 
82 library SafeMath {
83 
84   /**
85   * @dev Multiplies two numbers, reverts on overflow.
86   */
87   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89     // benefit is lost if 'b' is also tested.
90     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91     if (a == 0) {
92       return 0;
93     }
94 
95     uint256 c = a * b;
96     require(c / a == b);
97 
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     require(b > 0); // Solidity only automatically asserts when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109     return c;
110   }
111 
112   /**
113   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
114   */
115   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116     require(b <= a);
117     uint256 c = a - b;
118 
119     return c;
120   }
121 
122   /**
123   * @dev Adds two numbers, reverts on overflow.
124   */
125   function add(uint256 a, uint256 b) internal pure returns (uint256) {
126     uint256 c = a + b;
127     require(c >= a);
128 
129     return c;
130   }
131 
132   /**
133   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
134   * reverts when dividing by zero.
135   */
136   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137     require(b != 0);
138     return a % b;
139   }
140 }
141 
142 interface IERC20 {
143   function totalSupply() external view returns (uint256);
144 
145   function balanceOf(address who) external view returns (uint256);
146 
147   function allowance(address owner, address spender)
148     external view returns (uint256);
149 
150   function transfer(address to, uint256 value) external returns (bool);
151 
152   function approve(address spender, uint256 value)
153     external returns (bool);
154 
155   function transferFrom(address from, address to, uint256 value)
156     external returns (bool);
157 
158   event Transfer(
159     address indexed from,
160     address indexed to,
161     uint256 value
162   );
163 
164   event Approval(
165     address indexed owner,
166     address indexed spender,
167     uint256 value
168   );
169 }
170 
171 contract ERC20 is IERC20 {
172   using SafeMath for uint256;
173 
174   mapping (address => uint256) private _balances;
175 
176   mapping (address => mapping (address => uint256)) private _allowed;
177 
178   uint256 private _totalSupply;
179 
180   /**
181   * @dev Total number of tokens in existence
182   */
183   function totalSupply() public view returns (uint256) {
184     return _totalSupply;
185   }
186 
187   /**
188   * @dev Gets the balance of the specified address.
189   * @param owner The address to query the balance of.
190   * @return An uint256 representing the amount owned by the passed address.
191   */
192   function balanceOf(address owner) public view returns (uint256) {
193     return _balances[owner];
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param owner address The address which owns the funds.
199    * @param spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(
203     address owner,
204     address spender
205    )
206     public
207     view
208     returns (uint256)
209   {
210     return _allowed[owner][spender];
211   }
212 
213   /**
214   * @dev Transfer token for a specified address
215   * @param to The address to transfer to.
216   * @param value The amount to be transferred.
217   */
218   function transfer(address to, uint256 value) public returns (bool) {
219     _transfer(msg.sender, to, value);
220     return true;
221   }
222 
223   /**
224    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
225    * Beware that changing an allowance with this method brings the risk that someone may use both the old
226    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
227    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
228    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229    * @param spender The address which will spend the funds.
230    * @param value The amount of tokens to be spent.
231    */
232   function approve(address spender, uint256 value) public returns (bool) {
233     require(spender != address(0));
234 
235     _allowed[msg.sender][spender] = value;
236     emit Approval(msg.sender, spender, value);
237     return true;
238   }
239 
240   /**
241    * @dev Transfer tokens from one address to another
242    * @param from address The address which you want to send tokens from
243    * @param to address The address which you want to transfer to
244    * @param value uint256 the amount of tokens to be transferred
245    */
246   function transferFrom(
247     address from,
248     address to,
249     uint256 value
250   )
251     public
252     returns (bool)
253   {
254     require(value <= _allowed[from][msg.sender]);
255 
256     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
257     _transfer(from, to, value);
258     return true;
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    * approve should be called when allowed_[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param spender The address which will spend the funds.
268    * @param addedValue The amount of tokens to increase the allowance by.
269    */
270   function increaseAllowance(
271     address spender,
272     uint256 addedValue
273   )
274     public
275     returns (bool)
276   {
277     require(spender != address(0));
278 
279     _allowed[msg.sender][spender] = (
280       _allowed[msg.sender][spender].add(addedValue));
281     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
282     return true;
283   }
284 
285   /**
286    * @dev Decrease the amount of tokens that an owner allowed to a spender.
287    * approve should be called when allowed_[_spender] == 0. To decrement
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    * @param spender The address which will spend the funds.
292    * @param subtractedValue The amount of tokens to decrease the allowance by.
293    */
294   function decreaseAllowance(
295     address spender,
296     uint256 subtractedValue
297   )
298     public
299     returns (bool)
300   {
301     require(spender != address(0));
302 
303     _allowed[msg.sender][spender] = (
304       _allowed[msg.sender][spender].sub(subtractedValue));
305     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
306     return true;
307   }
308 
309   /**
310   * @dev Transfer token for a specified addresses
311   * @param from The address to transfer from.
312   * @param to The address to transfer to.
313   * @param value The amount to be transferred.
314   */
315   function _transfer(address from, address to, uint256 value) internal {
316     require(value <= _balances[from]);
317     require(to != address(0));
318 
319     _balances[from] = _balances[from].sub(value);
320     _balances[to] = _balances[to].add(value);
321     emit Transfer(from, to, value);
322   }
323 
324   /**
325    * @dev Internal function that mints an amount of the token and assigns it to
326    * an account. This encapsulates the modification of balances such that the
327    * proper events are emitted.
328    * @param account The account that will receive the created tokens.
329    * @param value The amount that will be created.
330    */
331   function _mint(address account, uint256 value) internal {
332     require(account != 0);
333     _totalSupply = _totalSupply.add(value);
334     _balances[account] = _balances[account].add(value);
335     emit Transfer(address(0), account, value);
336   }
337 
338   /**
339    * @dev Internal function that burns an amount of the token of a given
340    * account.
341    * @param account The account whose tokens will be burnt.
342    * @param value The amount that will be burnt.
343    */
344   function _burn(address account, uint256 value) internal {
345     require(account != 0);
346     require(value <= _balances[account]);
347 
348     _totalSupply = _totalSupply.sub(value);
349     _balances[account] = _balances[account].sub(value);
350     emit Transfer(account, address(0), value);
351   }
352 
353   /**
354    * @dev Internal function that burns an amount of the token of a given
355    * account, deducting from the sender's allowance for said account. Uses the
356    * internal burn function.
357    * @param account The account whose tokens will be burnt.
358    * @param value The amount that will be burnt.
359    */
360   function _burnFrom(address account, uint256 value) internal {
361     require(value <= _allowed[account][msg.sender]);
362 
363     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
364     // this function needs to emit an event with the updated approval.
365     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
366       value);
367     _burn(account, value);
368   }
369 }
370 
371 contract ERC20Mintable is ERC20, MinterRole {
372   /**
373    * @dev Function to mint tokens
374    * @param to The address that will receive the minted tokens.
375    * @param value The amount of tokens to mint.
376    * @return A boolean that indicates if the operation was successful.
377    */
378   function mint(
379     address to,
380     uint256 value
381   )
382     public
383     onlyMinter
384     returns (bool)
385   {
386     _mint(to, value);
387     return true;
388   }
389 }
390 
391 contract RevenueToken is ERC20Mintable {
392     using SafeMath for uint256;
393 
394     bool public mintingDisabled;
395 
396     address[] public holders;
397 
398     mapping(address => bool) public holdersMap;
399 
400     mapping(address => uint256[]) public balances;
401 
402     mapping(address => uint256[]) public balanceBlocks;
403 
404     mapping(address => uint256[]) public balanceBlockNumbers;
405 
406     event DisableMinting();
407 
408     /**
409      * @notice Disable further minting
410      * @dev This operation can not be undone
411      */
412     function disableMinting()
413     public
414     onlyMinter
415     {
416         mintingDisabled = true;
417 
418         emit DisableMinting();
419     }
420 
421     /**
422      * @notice Mint tokens
423      * @param to The address that will receive the minted tokens.
424      * @param value The amount of tokens to mint.
425      * @return A boolean that indicates if the operation was successful.
426      */
427     function mint(address to, uint256 value)
428     public
429     onlyMinter
430     returns (bool)
431     {
432         require(!mintingDisabled);
433 
434         // Call super's mint, including event emission
435         bool minted = super.mint(to, value);
436 
437         if (minted) {
438             // Adjust balance blocks
439             addBalanceBlocks(to);
440 
441             // Add to the token holders list
442             if (!holdersMap[to]) {
443                 holdersMap[to] = true;
444                 holders.push(to);
445             }
446         }
447 
448         return minted;
449     }
450 
451     /**
452      * @notice Transfer token for a specified address
453      * @param to The address to transfer to.
454      * @param value The amount to be transferred.
455      * @return A boolean that indicates if the operation was successful.
456      */
457     function transfer(address to, uint256 value)
458     public
459     returns (bool)
460     {
461         // Call super's transfer, including event emission
462         bool transferred = super.transfer(to, value);
463 
464         if (transferred) {
465             // Adjust balance blocks
466             addBalanceBlocks(msg.sender);
467             addBalanceBlocks(to);
468 
469             // Add to the token holders list
470             if (!holdersMap[to]) {
471                 holdersMap[to] = true;
472                 holders.push(to);
473             }
474         }
475 
476         return transferred;
477     }
478 
479     /**
480      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
481      * @dev Beware that to change the approve amount you first have to reduce the addresses'
482      * allowance to zero by calling `approve(spender, 0)` if it is not already 0 to mitigate the race
483      * condition described here:
484      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
485      * @param spender The address which will spend the funds.
486      * @param value The amount of tokens to be spent.
487      */
488     function approve(address spender, uint256 value)
489     public
490     returns (bool)
491     {
492         // Prevent the update of non-zero allowance
493         require(0 == value || 0 == allowance(msg.sender, spender));
494 
495         // Call super's approve, including event emission
496         return super.approve(spender, value);
497     }
498 
499     /**
500      * @dev Transfer tokens from one address to another
501      * @param from address The address which you want to send tokens from
502      * @param to address The address which you want to transfer to
503      * @param value uint256 the amount of tokens to be transferred
504      * @return A boolean that indicates if the operation was successful.
505      */
506     function transferFrom(address from, address to, uint256 value)
507     public
508     returns (bool)
509     {
510         // Call super's transferFrom, including event emission
511         bool transferred = super.transferFrom(from, to, value);
512 
513         if (transferred) {
514             // Adjust balance blocks
515             addBalanceBlocks(from);
516             addBalanceBlocks(to);
517 
518             // Add to the token holders list
519             if (!holdersMap[to]) {
520                 holdersMap[to] = true;
521                 holders.push(to);
522             }
523         }
524 
525         return transferred;
526     }
527 
528     /**
529      * @notice Calculate the amount of balance blocks, i.e. the area under the curve (AUC) of
530      * balance as function of block number
531      * @dev The AUC is used as weight for the share of revenue that a token holder may claim
532      * @param account The account address for which calculation is done
533      * @param startBlock The start block number considered
534      * @param endBlock The end block number considered
535      * @return The calculated AUC
536      */
537     function balanceBlocksIn(address account, uint256 startBlock, uint256 endBlock)
538     public
539     view
540     returns (uint256)
541     {
542         require(startBlock < endBlock);
543         require(account != address(0));
544 
545         if (balanceBlockNumbers[account].length == 0 || endBlock < balanceBlockNumbers[account][0])
546             return 0;
547 
548         uint256 i = 0;
549         while (i < balanceBlockNumbers[account].length && balanceBlockNumbers[account][i] < startBlock)
550             i++;
551 
552         uint256 r;
553         if (i >= balanceBlockNumbers[account].length)
554             r = balances[account][balanceBlockNumbers[account].length - 1].mul(endBlock.sub(startBlock));
555 
556         else {
557             uint256 l = (i == 0) ? startBlock : balanceBlockNumbers[account][i - 1];
558 
559             uint256 h = balanceBlockNumbers[account][i];
560             if (h > endBlock)
561                 h = endBlock;
562 
563             h = h.sub(startBlock);
564             r = (h == 0) ? 0 : balanceBlocks[account][i].mul(h).div(balanceBlockNumbers[account][i].sub(l));
565             i++;
566 
567             while (i < balanceBlockNumbers[account].length && balanceBlockNumbers[account][i] < endBlock) {
568                 r = r.add(balanceBlocks[account][i]);
569                 i++;
570             }
571 
572             if (i >= balanceBlockNumbers[account].length)
573                 r = r.add(
574                     balances[account][balanceBlockNumbers[account].length - 1].mul(
575                         endBlock.sub(balanceBlockNumbers[account][balanceBlockNumbers[account].length - 1])
576                     )
577                 );
578 
579             else if (balanceBlockNumbers[account][i - 1] < endBlock)
580                 r = r.add(
581                     balanceBlocks[account][i].mul(
582                         endBlock.sub(balanceBlockNumbers[account][i - 1])
583                     ).div(
584                         balanceBlockNumbers[account][i].sub(balanceBlockNumbers[account][i - 1])
585                     )
586                 );
587         }
588 
589         return r;
590     }
591 
592     /**
593      * @notice Get the count of balance updates for the given account
594      * @return The count of balance updates
595      */
596     function balanceUpdatesCount(address account)
597     public
598     view
599     returns (uint256)
600     {
601         return balanceBlocks[account].length;
602     }
603 
604     /**
605      * @notice Get the count of holders
606      * @return The count of holders
607      */
608     function holdersCount()
609     public
610     view
611     returns (uint256)
612     {
613         return holders.length;
614     }
615 
616     /**
617      * @notice Get the subset of holders (optionally with positive balance only) in the given 0 based index range
618      * @param low The lower inclusive index
619      * @param up The upper inclusive index
620      * @param posOnly List only positive balance holders
621      * @return The subset of positive balance registered holders in the given range
622      */
623     function holdersByIndices(uint256 low, uint256 up, bool posOnly)
624     public
625     view
626     returns (address[])
627     {
628         require(low <= up);
629 
630         up = up > holders.length - 1 ? holders.length - 1 : up;
631 
632         uint256 length = 0;
633         if (posOnly) {
634             for (uint256 i = low; i <= up; i++)
635                 if (0 < balanceOf(holders[i]))
636                     length++;
637         } else
638             length = up - low + 1;
639 
640         address[] memory _holders = new address[](length);
641 
642         uint256 j = 0;
643         for (i = low; i <= up; i++)
644             if (!posOnly || 0 < balanceOf(holders[i]))
645                 _holders[j++] = holders[i];
646 
647         return _holders;
648     }
649 
650     function addBalanceBlocks(address account)
651     private
652     {
653         uint256 length = balanceBlockNumbers[account].length;
654         balances[account].push(balanceOf(account));
655         if (0 < length)
656             balanceBlocks[account].push(
657                 balances[account][length - 1].mul(
658                     block.number.sub(balanceBlockNumbers[account][length - 1])
659                 )
660             );
661         else
662             balanceBlocks[account].push(0);
663         balanceBlockNumbers[account].push(block.number);
664     }
665 }
666 
667 contract NahmiiToken is RevenueToken {
668 
669     string public name = "Nahmii";
670 
671     string public symbol = "NII";
672 
673     uint8 public constant decimals = 15;
674 
675     event SetName(string name);
676 
677     event SetSymbol(string symbol);
678 
679     /**
680      * @dev Set the name of the token
681      * @param _name The new token name
682      */
683     function setName(string _name)
684     public
685     onlyMinter
686     {
687         name = _name;
688         emit SetName(name);
689     }
690 
691     /**
692      * @dev Set the symbol of the token
693      * @param _symbol The new token symbol
694      */
695     function setSymbol(string _symbol)
696     public
697     onlyMinter
698     {
699         symbol = _symbol;
700         emit SetSymbol(_symbol);
701     }
702 }