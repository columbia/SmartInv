1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10     address public owner;
11 
12     /**
13      * Events
14      */
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18      * @dev Throws if called by any account other than the owner.
19      */
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     /**
26      * @dev Constructor
27      * Sets the original `owner` of the contract to the sender account.
28      */
29     function Ownable() public {
30         owner = msg.sender;
31         OwnershipTransferred(0, owner);
32     }
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a new owner.
36      * @param _newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address _newOwner)
39         public
40         onlyOwner
41     {
42         require(_newOwner != 0);
43 
44         OwnershipTransferred(owner, _newOwner);
45         owner = _newOwner;
46     }
47 
48 }
49 
50 /**
51  * @title SafeMath
52  * @dev Math operations with safety checks that throw on error
53  */
54 library SafeMath {
55 
56     /**
57      * @dev Multiplies two numbers, throws on overflow.
58      */
59     function mul(uint _a, uint _b)
60         internal
61         pure
62         returns (uint)
63     {
64         if (_a == 0) {
65             return 0;
66         }
67     
68         uint c = _a * _b;
69         assert(c / _a == _b);
70         return c;
71     }
72 
73     /**
74      * @dev Integer division of two numbers, truncating the quotient.
75      */
76     function div(uint _a, uint _b)
77         internal
78         pure
79         returns (uint)
80     {
81         // Solidity automatically throws when dividing by 0
82         uint c = _a / _b;
83         return c;
84     }
85 
86     /**
87      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88      */
89     function sub(uint _a, uint _b)
90         internal
91         pure
92         returns (uint)
93     {
94         assert(_b <= _a);
95         return _a - _b;
96     }
97 
98     /**
99      * @dev Adds two numbers, throws on overflow.
100      */
101     function add(uint _a, uint _b)
102         internal
103         pure
104         returns (uint)
105     {
106         uint c = _a + _b;
107         assert(c >= _a);
108         return c;
109     }
110 
111 }
112 
113 /**
114  * @title Standard ERC20 token
115  */
116 contract StandardToken is Ownable {
117 
118     using SafeMath for uint;
119 
120     string public name;
121     string public symbol;
122     uint8 public decimals;
123 
124     uint public totalSupply;
125     mapping(address => uint) public balanceOf;
126     mapping(address => mapping(address => uint)) internal allowed;
127 
128     /**
129      * Events
130      */
131     event ChangeTokenInformation(string name, string symbol);
132     event Transfer(address indexed from, address indexed to, uint value);
133     event Approval(address indexed owner, address indexed spender, uint value);
134 
135     /**
136      * Owner can update token information here.
137      *
138      * It is often useful to conceal the actual token association, until
139      * the token operations, like central issuance or reissuance have been completed.
140      *
141      * This function allows the token owner to rename the token after the operations
142      * have been completed and then point the audience to use the token contract.
143      */
144     function changeTokenInformation(string _name, string _symbol)
145         public
146         onlyOwner
147     {
148         name = _name;
149         symbol = _symbol;
150         ChangeTokenInformation(_name, _symbol);
151     }
152 
153 	/**
154 	 * @dev Transfer token for a specified address
155 	 * @param _to The address to transfer to.
156 	 * @param _value The amount to be transferred.
157 	 */
158 	function transfer(address _to, uint _value)
159 		public
160 		returns (bool)
161 	{
162 		require(_to != 0);
163         require(_value > 0);
164 
165 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
166 		balanceOf[_to] = balanceOf[_to].add(_value);
167 		Transfer(msg.sender, _to, _value);
168 		return true;
169 	}
170 
171     /**
172      * @dev Transfer tokens from one address to another
173      * @param _from The address which you want to send tokens from
174      * @param _to The address which you want to transfer to
175      * @param _value The amount of tokens to be transferred
176      */
177     function transferFrom(address _from, address _to, uint _value)
178         public
179         returns (bool)
180     {
181         require(_to != 0);
182         require(_value > 0);
183 
184         balanceOf[_from] = balanceOf[_from].sub(_value);
185         balanceOf[_to] = balanceOf[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     /**
192      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193      *
194      * Beware that changing an allowance with this method brings the risk that someone may use both the old
195      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      *
199      * @param _spender The address which will spend the funds.
200      * @param _value The amount of tokens to be spent.
201      */
202     function approve(address _spender, uint _value)
203         public
204         returns (bool)
205     {
206         allowed[msg.sender][_spender] = _value;
207         Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     /**
212      * @dev Increase the amount of tokens that an owner allowed to a spender.
213      *
214      * approve should be called when allowed[_spender] == 0. To increment
215      * allowed value is better to use this function to avoid 2 calls (and wait until
216      * the first transaction is mined)
217      *
218      * @param _spender The address which will spend the funds.
219      * @param _addedValue The amount of tokens to increase the allowance by.
220      */
221     function increaseApproval(address _spender, uint _addedValue)
222         public
223         returns (bool)
224     {
225         require(_addedValue > 0);
226 
227         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
228         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232     /**
233      * @dev Decrease the amount of tokens that an owner allowed to a spender.
234      *
235      * approve should be called when allowed[_spender] == 0. To decrement
236      * allowed value is better to use this function to avoid 2 calls (and wait until
237      * the first transaction is mined)
238      *
239      * @param _spender The address which will spend the funds.
240      * @param _subtractedValue The amount of tokens to decrease the allowance by.
241      */
242     function decreaseApproval(address _spender, uint _subtractedValue)
243         public
244         returns (bool)
245     {
246         require(_subtractedValue > 0);
247 
248         uint oldValue = allowed[msg.sender][_spender];
249 
250         if (_subtractedValue > oldValue) {
251             allowed[msg.sender][_spender] = 0;
252 
253         } else {
254             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255         }
256 
257         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258         return true;
259     }
260 
261     /**
262      * @dev Function to check the amount of tokens that an owner allowed to a spender.
263      * @param _owner The address which owns the funds.
264      * @param _spender The address which will spend the funds.
265      * @return A uint specifying the amount of tokens still available for the spender.
266      */
267     function allowance(address _owner, address _spender)
268         public
269         view
270         returns (uint)
271     {
272         return allowed[_owner][_spender];
273     }
274 
275 }
276 
277 /**
278  * @title UpgradeAgent Interface
279  * @dev Upgrade agent transfers tokens to a new contract. Upgrade agent itself can be the
280  * token contract, or just a middle man contract doing the heavy lifting.
281  */
282 contract UpgradeAgent {
283 
284     bool public isUpgradeAgent = true;
285 
286     function upgradeFrom(address _from, uint _value) public;
287 
288 }
289 
290 
291 /**
292  * @title Mintable token
293  */
294 contract MintableToken is StandardToken {
295 
296 	bool public mintingFinished = false;
297 
298 	/**
299      * Events
300      */
301 	event Mint(address indexed to, uint amount);
302   	event MintFinished();
303 
304 	modifier canMint() {
305 		require(!mintingFinished);
306 		_;
307 	}
308 
309 	/**
310 	 * @dev Function to mint tokens
311 	 * @param _to The address that will receive the minted tokens.
312 	 * @param _amount The amount of tokens to mint.
313 	 */
314 	function mint(address _to, uint _amount)
315 		public
316 		onlyOwner
317 		canMint
318 	{
319 		totalSupply = totalSupply.add(_amount);
320 		balanceOf[_to] = balanceOf[_to].add(_amount);
321 		Mint(_to, _amount);
322 		Transfer(0, _to, _amount);
323 	}
324 
325 	/**
326 	 * @dev Function to stop minting new tokens.
327 	 */
328 	function finishMinting()
329 		public
330 		onlyOwner
331 		canMint
332 	{
333 		mintingFinished = true;
334 		MintFinished();
335 	}
336 
337 }
338 
339 /**
340  * @title Capped token
341  * @dev Mintable token with a token cap.
342  */
343 contract CappedToken is MintableToken {
344 
345     uint public cap;
346 
347     /**
348      * @dev Function to mint tokens
349      * @param _to The address that will receive the minted tokens.
350      * @param _amount The amount of tokens to mint.
351      */
352     function mint(address _to, uint _amount)
353         public
354         onlyOwner
355         canMint
356     {
357         require(totalSupply.add(_amount) <= cap);
358 
359         super.mint(_to, _amount);
360     }
361 
362 }
363 
364 /**
365  * @title Pausable token
366  * @dev Token that can be freeze "Transfer" function
367  */
368 contract PausableToken is StandardToken {
369 
370     bool public isTradable = true;
371 
372     /**
373      * Events
374      */
375     event FreezeTransfer();
376     event UnfreezeTransfer();
377 
378     modifier canTransfer() {
379 		require(isTradable);
380 		_;
381 	}
382 
383     /**
384      * Disallow to transfer token from an address to other address
385      */
386     function freezeTransfer()
387         public
388         onlyOwner
389     {
390         isTradable = false;
391         FreezeTransfer();
392     }
393 
394     /**
395      * Allow to transfer token from an address to other address
396      */
397     function unfreezeTransfer()
398         public
399         onlyOwner
400     {
401         isTradable = true;
402         UnfreezeTransfer();
403     }
404 
405     /**
406 	 * @dev Transfer token for a specified address
407 	 * @param _to The address to transfer to.
408 	 * @param _value The amount to be transferred.
409 	 */
410     function transfer(address _to, uint _value)
411 		public
412         canTransfer
413 		returns (bool)
414 	{
415 		return super.transfer(_to, _value);
416 	}
417 
418     /**
419      * @dev Transfer tokens from one address to another
420      * @param _from The address which you want to send tokens from
421      * @param _to The address which you want to transfer to
422      * @param _value The amount of tokens to be transferred
423      */
424     function transferFrom(address _from, address _to, uint _value)
425         public
426         canTransfer
427         returns (bool)
428     {
429         return super.transferFrom(_from, _to, _value);
430     }
431 
432     /**
433      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
434      *
435      * Beware that changing an allowance with this method brings the risk that someone may use both the old
436      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
437      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
438      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
439      *
440      * @param _spender The address which will spend the funds.
441      * @param _value The amount of tokens to be spent.
442      */
443     function approve(address _spender, uint _value)
444         public
445         canTransfer
446         returns (bool)
447     {
448         return super.approve(_spender, _value);
449     }
450 
451     /**
452      * @dev Increase the amount of tokens that an owner allowed to a spender.
453      *
454      * approve should be called when allowed[_spender] == 0. To increment
455      * allowed value is better to use this function to avoid 2 calls (and wait until
456      * the first transaction is mined)
457      *
458      * @param _spender The address which will spend the funds.
459      * @param _addedValue The amount of tokens to increase the allowance by.
460      */
461     function increaseApproval(address _spender, uint _addedValue)
462         public
463         canTransfer
464         returns (bool)
465     {
466         return super.increaseApproval(_spender, _addedValue);
467     }
468 
469     /**
470      * @dev Decrease the amount of tokens that an owner allowed to a spender.
471      *
472      * approve should be called when allowed[_spender] == 0. To decrement
473      * allowed value is better to use this function to avoid 2 calls (and wait until
474      * the first transaction is mined)
475      *
476      * @param _spender The address which will spend the funds.
477      * @param _subtractedValue The amount of tokens to decrease the allowance by.
478      */
479     function decreaseApproval(address _spender, uint _subtractedValue)
480         public
481         canTransfer
482         returns (bool)
483     {
484         return super.decreaseApproval(_spender, _subtractedValue);
485     }
486 
487 }
488 
489 /**
490  * @title Upgradable token
491  */
492 contract UpgradableToken is StandardToken {
493 
494     address public upgradeMaster;
495 
496     // The next contract where the tokens will be migrated.
497     UpgradeAgent public upgradeAgent;
498 
499     bool public isUpgradable = false;
500 
501     // How many tokens we have upgraded by now.
502     uint public totalUpgraded;
503 
504     /**
505      * Events
506      */
507     event ChangeUpgradeMaster(address newMaster);
508     event ChangeUpgradeAgent(address newAgent);
509     event FreezeUpgrade();
510     event UnfreezeUpgrade();
511     event Upgrade(address indexed from, address indexed to, uint value);
512 
513     modifier onlyUpgradeMaster() {
514 		require(msg.sender == upgradeMaster);
515 		_;
516 	}
517 
518     modifier canUpgrade() {
519 		require(isUpgradable);
520 		_;
521 	}
522 
523     /**
524      * Change the upgrade master.
525      * @param _newMaster New upgrade master.
526      */
527     function changeUpgradeMaster(address _newMaster)
528         public
529         onlyOwner
530     {
531         require(_newMaster != 0);
532 
533         upgradeMaster = _newMaster;
534         ChangeUpgradeMaster(_newMaster);
535     }
536 
537     /**
538      * Change the upgrade agent.
539      * @param _newAgent New upgrade agent.
540      */
541     function changeUpgradeAgent(address _newAgent)
542         public
543         onlyOwner
544     {
545         require(totalUpgraded == 0);
546 
547         upgradeAgent = UpgradeAgent(_newAgent);
548 
549         // Bad interface
550         if (!upgradeAgent.isUpgradeAgent()) {
551             revert();
552         }
553 
554         ChangeUpgradeAgent(_newAgent);
555     }
556 
557     /**
558      * Disallow to upgrade token to new smart contract
559      */
560     function freezeUpgrade()
561         public
562         onlyOwner
563     {
564         isUpgradable = false;
565         FreezeUpgrade();
566     }
567 
568     /**
569      * Allow to upgrade token to new smart contract
570      */
571     function unfreezeUpgrade()
572         public
573         onlyOwner
574     {
575         isUpgradable = true;
576         UnfreezeUpgrade();
577     }
578 
579     /**
580      * Token holder upgrade their tokens to a new smart contract.
581      */
582     function upgrade()
583         public
584         canUpgrade
585     {
586         uint amount = balanceOf[msg.sender];
587 
588         require(amount > 0);
589 
590         processUpgrade(msg.sender, amount);
591     }
592 
593     /**
594      * Upgrader upgrade tokens of holder to a new smart contract.
595      * @param _holders List of token holder.
596      */
597     function forceUpgrade(address[] _holders)
598         public
599         onlyUpgradeMaster
600         canUpgrade
601     {
602         uint amount;
603 
604         for (uint i = 0; i < _holders.length; i++) {
605             amount = balanceOf[_holders[i]];
606 
607             if (amount == 0) {
608                 continue;
609             }
610 
611             processUpgrade(_holders[i], amount);
612         }
613     }
614 
615     function processUpgrade(address _holder, uint _amount)
616         private
617     {
618         balanceOf[_holder] = balanceOf[_holder].sub(_amount);
619 
620         // Take tokens out from circulation
621         totalSupply = totalSupply.sub(_amount);
622         totalUpgraded = totalUpgraded.add(_amount);
623 
624         // Upgrade agent reissues the tokens
625         upgradeAgent.upgradeFrom(_holder, _amount);
626         Upgrade(_holder, upgradeAgent, _amount);
627     }
628 
629 }
630 
631 /**
632  * @title QNTU 1.0 token
633  */
634 contract QNTU is UpgradableToken, CappedToken, PausableToken {
635 
636     /**
637 	 * @dev Constructor
638 	 */
639     function QNTU()
640         public
641     {
642         symbol = "QNTU";
643         name = "QNTU Token";
644         decimals = 18;
645 
646         uint multiplier = 10 ** uint(decimals);
647 
648         cap = 120000000000 * multiplier;
649         totalSupply = 72000000000 * multiplier;
650 
651         // 40%
652         balanceOf[0xd83ef0076580e595b3be39d654da97184623b9b5] = 4800000000 * multiplier;
653         balanceOf[0xd4e40860b41f666fbc6c3007f3d1434e353063d8] = 4800000000 * multiplier;
654         balanceOf[0x84dd4187a87055495d0c08fe260ca9cc9e02f09e] = 4800000000 * multiplier;
655         balanceOf[0x0556620d12c38babd0461e366b433682a5000fae] = 4800000000 * multiplier;
656         balanceOf[0x0f363f18f49aa350ba8fcf233cdd155a7b77af99] = 4800000000 * multiplier;
657         balanceOf[0x1a38292d3f685cd79bcdfc19fad7447ae762aa4c] = 4800000000 * multiplier;
658         balanceOf[0xb262d04ee29ad9ebacb1ab9da99398916f425d84] = 4800000000 * multiplier;
659         balanceOf[0xd8c2d6f12baf10258eb390be4377e460c1d033e2] = 4800000000 * multiplier;
660         balanceOf[0x1ca70fd8433ec97fa0777830a152d028d71b88fa] = 4800000000 * multiplier;
661         balanceOf[0x57be4b8c57c0bb061e05fdf85843503fba673394] = 4800000000 * multiplier;
662 
663         Transfer(0, 0xd83ef0076580e595b3be39d654da97184623b9b5, 4800000000 * multiplier);
664         Transfer(0, 0xd4e40860b41f666fbc6c3007f3d1434e353063d8, 4800000000 * multiplier);
665         Transfer(0, 0x84dd4187a87055495d0c08fe260ca9cc9e02f09e, 4800000000 * multiplier);
666         Transfer(0, 0x0556620d12c38babd0461e366b433682a5000fae, 4800000000 * multiplier);
667         Transfer(0, 0x0f363f18f49aa350ba8fcf233cdd155a7b77af99, 4800000000 * multiplier);
668         Transfer(0, 0x1a38292d3f685cd79bcdfc19fad7447ae762aa4c, 4800000000 * multiplier);
669         Transfer(0, 0xb262d04ee29ad9ebacb1ab9da99398916f425d84, 4800000000 * multiplier);
670         Transfer(0, 0xd8c2d6f12baf10258eb390be4377e460c1d033e2, 4800000000 * multiplier);
671         Transfer(0, 0x1ca70fd8433ec97fa0777830a152d028d71b88fa, 4800000000 * multiplier);
672         Transfer(0, 0x57be4b8c57c0bb061e05fdf85843503fba673394, 4800000000 * multiplier);
673 
674         // 20%
675         balanceOf[0xb6ff15b634571cb56532022fe00f96fee51322b3] = 4800000000 * multiplier;
676         balanceOf[0x631c87278de77902e762ba0ab57d55c10716e0b6] = 4800000000 * multiplier;
677         balanceOf[0x7fe443391d9a3eb0c401181c46a44eb6106bba2e] = 4800000000 * multiplier;
678         balanceOf[0x94905c20fa2596fdc7d37bab6dd67b52e2335122] = 4800000000 * multiplier;
679         balanceOf[0x6ad8038f53ae2800d45a31d8261b062a0b55d63b] = 4800000000 * multiplier;
680 
681         Transfer(0, 0xb6ff15b634571cb56532022fe00f96fee51322b3, 4800000000 * multiplier);
682         Transfer(0, 0x631c87278de77902e762ba0ab57d55c10716e0b6, 4800000000 * multiplier);
683         Transfer(0, 0x7fe443391d9a3eb0c401181c46a44eb6106bba2e, 4800000000 * multiplier);
684         Transfer(0, 0x94905c20fa2596fdc7d37bab6dd67b52e2335122, 4800000000 * multiplier);
685         Transfer(0, 0x6ad8038f53ae2800d45a31d8261b062a0b55d63b, 4800000000 * multiplier);
686     }
687 
688 }