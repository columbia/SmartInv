1 pragma solidity ^0.4.24;
2 
3 // File: contracts/Ownable.sol
4 
5 /**
6 * Copyright CENTRE SECZ 2018
7 *
8 * Permission is hereby granted, free of charge, to any person obtaining a copy 
9 * of this software and associated documentation files (the "Software"), to deal 
10 * in the Software without restriction, including without limitation the rights 
11 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
12 * copies of the Software, and to permit persons to whom the Software is furnished to 
13 * do so, subject to the following conditions:
14 *
15 * The above copyright notice and this permission notice shall be included in all 
16 * copies or substantial portions of the Software.
17 *
18 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
19 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
20 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
21 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
22 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
23 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
24 */
25 
26 pragma solidity ^0.4.24;
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract from https://github.com/zeppelinos/labs/blob/master/upgradeability_ownership/contracts/ownership/Ownable.sol 
31  * branch: master commit: 3887ab77b8adafba4a26ace002f3a684c1a3388b modified to:
32  * 1) Add emit prefix to OwnershipTransferred event (7/13/18)
33  * 2) Replace constructor with constructor syntax (7/13/18)
34  * 3) consolidate OwnableStorage into this contract
35  */
36 contract Ownable {
37 
38   // Owner of the contract
39   address private _owner;
40 
41   /**
42   * @dev Event to show ownership has been transferred
43   * @param previousOwner representing the address of the previous owner
44   * @param newOwner representing the address of the new owner
45   */
46   event OwnershipTransferred(address previousOwner, address newOwner);
47 
48   /**
49   * @dev The constructor sets the original owner of the contract to the sender account.
50   */
51   constructor() public {
52     setOwner(msg.sender);
53   }
54 
55   /**
56  * @dev Tells the address of the owner
57  * @return the address of the owner
58  */
59   function owner() public view returns (address) {
60     return _owner;
61   }
62 
63   /**
64    * @dev Sets a new owner address
65    */
66   function setOwner(address newOwner) internal {
67     _owner = newOwner;
68   }
69 
70   /**
71   * @dev Throws if called by any account other than the owner.
72   */
73   modifier onlyOwner() {
74     require(msg.sender == owner());
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner(), newOwner);
85     setOwner(newOwner);
86   }
87 }
88 
89 // File: contracts/Blacklistable.sol
90 
91 /**
92 * Copyright CENTRE SECZ 2018
93 *
94 * Permission is hereby granted, free of charge, to any person obtaining a copy 
95 * of this software and associated documentation files (the "Software"), to deal 
96 * in the Software without restriction, including without limitation the rights 
97 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
98 * copies of the Software, and to permit persons to whom the Software is furnished to 
99 * do so, subject to the following conditions:
100 *
101 * The above copyright notice and this permission notice shall be included in all 
102 * copies or substantial portions of the Software.
103 *
104 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
105 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
106 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
107 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
108 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
109 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
110 */
111 
112 pragma solidity ^0.4.24;
113 
114 
115 /**
116  * @title Blacklistable Token
117  * @dev Allows accounts to be blacklisted by a "blacklister" role
118 */
119 contract Blacklistable is Ownable {
120 
121     address public blacklister;
122     mapping(address => bool) internal blacklisted;
123 
124     event Blacklisted(address indexed _account);
125     event UnBlacklisted(address indexed _account);
126     event BlacklisterChanged(address indexed newBlacklister);
127 
128     /**
129      * @dev Throws if called by any account other than the blacklister
130     */
131     modifier onlyBlacklister() {
132         require(msg.sender == blacklister);
133         _;
134     }
135 
136     /**
137      * @dev Throws if argument account is blacklisted
138      * @param _account The address to check
139     */
140     modifier notBlacklisted(address _account) {
141         require(blacklisted[_account] == false);
142         _;
143     }
144 
145     /**
146      * @dev Checks if account is blacklisted
147      * @param _account The address to check    
148     */
149     function isBlacklisted(address _account) public view returns (bool) {
150         return blacklisted[_account];
151     }
152 
153     /**
154      * @dev Adds account to blacklist
155      * @param _account The address to blacklist
156     */
157     function blacklist(address _account) public onlyBlacklister {
158         blacklisted[_account] = true;
159         emit Blacklisted(_account);
160     }
161 
162     /**
163      * @dev Removes account from blacklist
164      * @param _account The address to remove from the blacklist
165     */
166     function unBlacklist(address _account) public onlyBlacklister {
167         blacklisted[_account] = false;
168         emit UnBlacklisted(_account);
169     }
170 
171     function updateBlacklister(address _newBlacklister) public onlyOwner {
172         require(_newBlacklister != address(0));
173         blacklister = _newBlacklister;
174         emit BlacklisterChanged(blacklister);
175     }
176 }
177 
178 // File: contracts/Pausable.sol
179 
180 /**
181 * Copyright CENTRE SECZ 2018
182 *
183 * Permission is hereby granted, free of charge, to any person obtaining a copy 
184 * of this software and associated documentation files (the "Software"), to deal 
185 * in the Software without restriction, including without limitation the rights 
186 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
187 * copies of the Software, and to permit persons to whom the Software is furnished to 
188 * do so, subject to the following conditions:
189 *
190 * The above copyright notice and this permission notice shall be included in all 
191 * copies or substantial portions of the Software.
192 *
193 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
194 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
195 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
196 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
197 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
198 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
199 */
200 
201 pragma solidity ^0.4.24;
202 
203 
204 /**
205  * @title Pausable
206  * @dev Base contract which allows children to implement an emergency stop mechanism.
207  * Based on openzeppelin tag v1.10.0 commit: feb665136c0dae9912e08397c1a21c4af3651ef3
208  * Modifications:
209  * 1) Added pauser role, switched pause/unpause to be onlyPauser (6/14/2018)
210  * 2) Removed whenNotPause/whenPaused from pause/unpause (6/14/2018)
211  * 3) Removed whenPaused (6/14/2018)
212  * 4) Switches ownable library to use zeppelinos (7/12/18)
213  * 5) Remove constructor (7/13/18)
214  */
215 contract Pausable is Ownable {
216   event Pause();
217   event Unpause();
218   event PauserChanged(address indexed newAddress);
219 
220 
221   address public pauser;
222   bool public paused = false;
223 
224   /**
225    * @dev Modifier to make a function callable only when the contract is not paused.
226    */
227   modifier whenNotPaused() {
228     require(!paused);
229     _;
230   }
231 
232   /**
233    * @dev throws if called by any account other than the pauser
234    */
235   modifier onlyPauser() {
236     require(msg.sender == pauser);
237     _;
238   }
239 
240   /**
241    * @dev called by the owner to pause, triggers stopped state
242    */
243   function pause() onlyPauser public {
244     paused = true;
245     emit Pause();
246   }
247 
248   /**
249    * @dev called by the owner to unpause, returns to normal state
250    */
251   function unpause() onlyPauser public {
252     paused = false;
253     emit Unpause();
254   }
255 
256   /**
257    * @dev update the pauser role
258    */
259   function updatePauser(address _newPauser) onlyOwner public {
260     require(_newPauser != address(0));
261     pauser = _newPauser;
262     emit PauserChanged(pauser);
263   }
264 
265 }
266 
267 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
268 
269 /**
270  * @title SafeMath
271  * @dev Math operations with safety checks that throw on error
272  */
273 library SafeMath {
274 
275   /**
276   * @dev Multiplies two numbers, throws on overflow.
277   */
278   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
279     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
280     // benefit is lost if 'b' is also tested.
281     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
282     if (a == 0) {
283       return 0;
284     }
285 
286     c = a * b;
287     assert(c / a == b);
288     return c;
289   }
290 
291   /**
292   * @dev Integer division of two numbers, truncating the quotient.
293   */
294   function div(uint256 a, uint256 b) internal pure returns (uint256) {
295     // assert(b > 0); // Solidity automatically throws when dividing by 0
296     // uint256 c = a / b;
297     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
298     return a / b;
299   }
300 
301   /**
302   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
303   */
304   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
305     assert(b <= a);
306     return a - b;
307   }
308 
309   /**
310   * @dev Adds two numbers, throws on overflow.
311   */
312   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
313     c = a + b;
314     assert(c >= a);
315     return c;
316   }
317 }
318 
319 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
320 
321 /**
322  * @title ERC20Basic
323  * @dev Simpler version of ERC20 interface
324  * See https://github.com/ethereum/EIPs/issues/179
325  */
326 contract ERC20Basic {
327   function totalSupply() public view returns (uint256);
328   function balanceOf(address who) public view returns (uint256);
329   function transfer(address to, uint256 value) public returns (bool);
330   event Transfer(address indexed from, address indexed to, uint256 value);
331 }
332 
333 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
334 
335 /**
336  * @title ERC20 interface
337  * @dev see https://github.com/ethereum/EIPs/issues/20
338  */
339 contract ERC20 is ERC20Basic {
340   function allowance(address owner, address spender)
341     public view returns (uint256);
342 
343   function transferFrom(address from, address to, uint256 value)
344     public returns (bool);
345 
346   function approve(address spender, uint256 value) public returns (bool);
347   event Approval(
348     address indexed owner,
349     address indexed spender,
350     uint256 value
351   );
352 }
353 
354 // File: contracts/FiatTokenV1.sol
355 
356 /**
357 * Copyright CENTRE SECZ 2018
358 *
359 * Permission is hereby granted, free of charge, to any person obtaining a copy 
360 * of this software and associated documentation files (the "Software"), to deal 
361 * in the Software without restriction, including without limitation the rights 
362 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
363 * copies of the Software, and to permit persons to whom the Software is furnished to 
364 * do so, subject to the following conditions:
365 *
366 * The above copyright notice and this permission notice shall be included in all 
367 * copies or substantial portions of the Software.
368 *
369 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
370 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
371 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
372 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
373 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
374 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
375 */
376 
377 pragma solidity ^0.4.24;
378 
379 
380 
381 
382 
383 
384 /**
385  * @title FiatToken
386  * @dev ERC20 Token backed by fiat reserves
387  */
388 contract FiatTokenV1 is Ownable, ERC20, Pausable, Blacklistable {
389     using SafeMath for uint256;
390 
391     string public name;
392     string public symbol;
393     uint8 public decimals;
394     string public currency;
395     address public masterMinter;
396     bool internal initialized;
397 
398     mapping(address => uint256) internal balances;
399     mapping(address => mapping(address => uint256)) internal allowed;
400     uint256 internal totalSupply_ = 0;
401     mapping(address => bool) internal minters;
402     mapping(address => uint256) internal minterAllowed;
403 
404     event Mint(address indexed minter, address indexed to, uint256 amount);
405     event Burn(address indexed burner, uint256 amount);
406     event MinterConfigured(address indexed minter, uint256 minterAllowedAmount);
407     event MinterRemoved(address indexed oldMinter);
408     event MasterMinterChanged(address indexed newMasterMinter);
409 
410     function initialize(
411         string _name,
412         string _symbol,
413         string _currency,
414         uint8 _decimals,
415         address _masterMinter,
416         address _pauser,
417         address _blacklister,
418         address _owner
419     ) public {
420         require(!initialized);
421         require(_masterMinter != address(0));
422         require(_pauser != address(0));
423         require(_blacklister != address(0));
424         require(_owner != address(0));
425 
426         name = _name;
427         symbol = _symbol;
428         currency = _currency;
429         decimals = _decimals;
430         masterMinter = _masterMinter;
431         pauser = _pauser;
432         blacklister = _blacklister;
433         setOwner(_owner);
434         initialized = true;
435     }
436 
437     /**
438      * @dev Throws if called by any account other than a minter
439     */
440     modifier onlyMinters() {
441         require(minters[msg.sender] == true);
442         _;
443     }
444 
445     /**
446      * @dev Function to mint tokens
447      * @param _to The address that will receive the minted tokens.
448      * @param _amount The amount of tokens to mint. Must be less than or equal to the minterAllowance of the caller.
449      * @return A boolean that indicates if the operation was successful.
450     */
451     function mint(address _to, uint256 _amount) whenNotPaused onlyMinters notBlacklisted(msg.sender) notBlacklisted(_to) public returns (bool) {
452         require(_to != address(0));
453         require(_amount > 0);
454 
455         uint256 mintingAllowedAmount = minterAllowed[msg.sender];
456         require(_amount <= mintingAllowedAmount);
457 
458         totalSupply_ = totalSupply_.add(_amount);
459         balances[_to] = balances[_to].add(_amount);
460         minterAllowed[msg.sender] = mintingAllowedAmount.sub(_amount);
461         emit Mint(msg.sender, _to, _amount);
462         emit Transfer(0x0, _to, _amount);
463         return true;
464     }
465 
466     /**
467      * @dev Throws if called by any account other than the masterMinter
468     */
469     modifier onlyMasterMinter() {
470         require(msg.sender == masterMinter);
471         _;
472     }
473 
474     /**
475      * @dev Get minter allowance for an account
476      * @param minter The address of the minter
477     */
478     function minterAllowance(address minter) public view returns (uint256) {
479         return minterAllowed[minter];
480     }
481 
482     /**
483      * @dev Checks if account is a minter
484      * @param account The address to check    
485     */
486     function isMinter(address account) public view returns (bool) {
487         return minters[account];
488     }
489 
490     /**
491      * @dev Get allowed amount for an account
492      * @param owner address The account owner
493      * @param spender address The account spender
494     */
495     function allowance(address owner, address spender) public view returns (uint256) {
496         return allowed[owner][spender];
497     }
498 
499     /**
500      * @dev Get totalSupply of token
501     */
502     function totalSupply() public view returns (uint256) {
503         return totalSupply_;
504     }
505 
506     /**
507      * @dev Get token balance of an account
508      * @param account address The account
509     */
510     function balanceOf(address account) public view returns (uint256) {
511         return balances[account];
512     }
513 
514     /**
515      * @dev Adds blacklisted check to approve
516      * @return True if the operation was successful.
517     */
518     function approve(address _spender, uint256 _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_spender) public returns (bool) {
519         allowed[msg.sender][_spender] = _value;
520         emit Approval(msg.sender, _spender, _value);
521         return true;
522     }
523 
524     /**
525      * @dev Transfer tokens from one address to another.
526      * @param _from address The address which you want to send tokens from
527      * @param _to address The address which you want to transfer to
528      * @param _value uint256 the amount of tokens to be transferred
529      * @return bool success
530     */
531     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused notBlacklisted(_to) notBlacklisted(msg.sender) notBlacklisted(_from) public returns (bool) {
532         require(_to != address(0));
533         require(_value <= balances[_from]);
534         require(_value <= allowed[_from][msg.sender]);
535 
536         balances[_from] = balances[_from].sub(_value);
537         balances[_to] = balances[_to].add(_value);
538         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
539         emit Transfer(_from, _to, _value);
540         return true;
541     }
542 
543     /**
544      * @dev transfer token for a specified address
545      * @param _to The address to transfer to.
546      * @param _value The amount to be transferred.
547      * @return bool success
548     */
549     function transfer(address _to, uint256 _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_to) public returns (bool) {
550         require(_to != address(0));
551         require(_value <= balances[msg.sender]);
552 
553         balances[msg.sender] = balances[msg.sender].sub(_value);
554         balances[_to] = balances[_to].add(_value);
555         emit Transfer(msg.sender, _to, _value);
556         return true;
557     }
558 
559     /**
560      * @dev Function to add/update a new minter
561      * @param minter The address of the minter
562      * @param minterAllowedAmount The minting amount allowed for the minter
563      * @return True if the operation was successful.
564     */
565     function configureMinter(address minter, uint256 minterAllowedAmount) whenNotPaused onlyMasterMinter public returns (bool) {
566         minters[minter] = true;
567         minterAllowed[minter] = minterAllowedAmount;
568         emit MinterConfigured(minter, minterAllowedAmount);
569         return true;
570     }
571 
572     /**
573      * @dev Function to remove a minter
574      * @param minter The address of the minter to remove
575      * @return True if the operation was successful.
576     */
577     function removeMinter(address minter) onlyMasterMinter public returns (bool) {
578         minters[minter] = false;
579         minterAllowed[minter] = 0;
580         emit MinterRemoved(minter);
581         return true;
582     }
583 
584     /**
585      * @dev allows a minter to burn some of its own tokens
586      * Validates that caller is a minter and that sender is not blacklisted
587      * amount is less than or equal to the minter's account balance
588      * @param _amount uint256 the amount of tokens to be burned
589     */
590     function burn(uint256 _amount) whenNotPaused onlyMinters notBlacklisted(msg.sender) public {
591         uint256 balance = balances[msg.sender];
592         require(_amount > 0);
593         require(balance >= _amount);
594 
595         totalSupply_ = totalSupply_.sub(_amount);
596         balances[msg.sender] = balance.sub(_amount);
597         emit Burn(msg.sender, _amount);
598         emit Transfer(msg.sender, address(0), _amount);
599     }
600 
601     function updateMasterMinter(address _newMasterMinter) onlyOwner public {
602         require(_newMasterMinter != address(0));
603         masterMinter = _newMasterMinter;
604         emit MasterMinterChanged(masterMinter);
605     }
606 }