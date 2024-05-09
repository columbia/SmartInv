1 /**
2  * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 
6 pragma solidity 0.5.2;
7 
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
19     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
20     // benefit is lost if 'b' is also tested.
21     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22     if (_a == 0) {
23       return 0;
24     }
25 
26     c = _a * _b;
27     assert(c / _a == _b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     // assert(_b > 0); // Solidity automatically throws when dividing by 0
36     // uint256 c = _a / _b;
37     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
38     return _a / _b;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     assert(_b <= _a);
46     return _a - _b;
47   }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
53     c = _a + _b;
54     assert(c >= _a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address public owner;
66 
67 
68   event OwnershipRenounced(address indexed previousOwner);
69   event OwnershipTransferred(
70     address indexed previousOwner,
71     address indexed newOwner
72   );
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   constructor() public {
80     owner = msg.sender;
81   }
82 
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to relinquish control of the contract.
93    * @notice Renouncing to ownership will leave the contract without an owner.
94    * It will not be possible to call the functions with the `onlyOwner`
95    * modifier anymore.
96    */
97   function renounceOwnership() public onlyOwner {
98     emit OwnershipRenounced(owner);
99     owner = address(0);
100   }
101 
102   /**
103    * @dev Allows the current owner to transfer control of the contract to a newOwner.
104    * @param _newOwner The address to transfer ownership to.
105    */
106   function transferOwnership(address _newOwner) public onlyOwner {
107     _transferOwnership(_newOwner);
108   }
109 
110   /**
111    * @dev Transfers control of the contract to a newOwner.
112    * @param _newOwner The address to transfer ownership to.
113    */
114   function _transferOwnership(address _newOwner) internal {
115     require(_newOwner != address(0));
116     emit OwnershipTransferred(owner, _newOwner);
117     owner = _newOwner;
118   }
119 }
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 /**
134  * @title ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/20
136  */
137 contract ERC20 is ERC20Basic {
138   function allowance(address _owner, address _spender)
139     public view returns (uint256);
140 
141   function transferFrom(address _from, address _to, uint256 _value)
142     public returns (bool);
143 
144   function approve(address _spender, uint256 _value) public returns (bool);
145   event Approval(
146     address indexed owner,
147     address indexed spender,
148     uint256 value
149   );
150 }
151 
152 /**
153  * @title DetailedERC20 token
154  * @dev The decimals are only for visualization purposes.
155  * All the operations are done using the smallest and indivisible token unit,
156  * just as on Ethereum all the operations are done in wei.
157  */
158 contract DetailedERC20 is ERC20 {
159   string public name;
160   string public symbol;
161   uint8 public decimals;
162 
163   constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
164     name = _name;
165     symbol = _symbol;
166     decimals = _decimals;
167   }
168 }
169 
170 /**
171  * @title Basic token
172  * @dev Basic version of StandardToken, with no allowances.
173  */
174 contract BasicToken is ERC20Basic {
175   using SafeMath for uint256;
176 
177   mapping(address => uint256) internal balances;
178 
179   uint256 internal totalSupply_;
180 
181   /**
182   * @dev Total number of tokens in existence
183   */
184   function totalSupply() public view returns (uint256) {
185     return totalSupply_;
186   }
187 
188   /**
189   * @dev Transfer token for a specified address
190   * @param _to The address to transfer to.
191   * @param _value The amount to be transferred.
192   */
193   function transfer(address _to, uint256 _value) public returns (bool) {
194     require(_value <= balances[msg.sender]);
195     require(_to != address(0));
196 
197     balances[msg.sender] = balances[msg.sender].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     emit Transfer(msg.sender, _to, _value);
200     return true;
201   }
202 
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param _owner The address to query the the balance of.
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address _owner) public view returns (uint256) {
209     return balances[_owner];
210   }
211 
212 }
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * https://github.com/ethereum/EIPs/issues/20
219  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(
232     address _from,
233     address _to,
234     uint256 _value
235   )
236     public
237     returns (bool)
238   {
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241     require(_to != address(0));
242 
243     balances[_from] = balances[_from].sub(_value);
244     balances[_to] = balances[_to].add(_value);
245     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246     emit Transfer(_from, _to, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     emit Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(
272     address _owner,
273     address _spender
274    )
275     public
276     view
277     returns (uint256)
278   {
279     return allowed[_owner][_spender];
280   }
281 
282   /**
283    * @dev Increase the amount of tokens that an owner allowed to a spender.
284    * approve should be called when allowed[_spender] == 0. To increment
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param _spender The address which will spend the funds.
289    * @param _addedValue The amount of tokens to increase the allowance by.
290    */
291   function increaseApproval(
292     address _spender,
293     uint256 _addedValue
294   )
295     public
296     returns (bool)
297   {
298     allowed[msg.sender][_spender] = (
299       allowed[msg.sender][_spender].add(_addedValue));
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304   /**
305    * @dev Decrease the amount of tokens that an owner allowed to a spender.
306    * approve should be called when allowed[_spender] == 0. To decrement
307    * allowed value is better to use this function to avoid 2 calls (and wait until
308    * the first transaction is mined)
309    * From MonolithDAO Token.sol
310    * @param _spender The address which will spend the funds.
311    * @param _subtractedValue The amount of tokens to decrease the allowance by.
312    */
313   function decreaseApproval(
314     address _spender,
315     uint256 _subtractedValue
316   )
317     public
318     returns (bool)
319   {
320     uint256 oldValue = allowed[msg.sender][_spender];
321     if (_subtractedValue >= oldValue) {
322       allowed[msg.sender][_spender] = 0;
323     } else {
324       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
325     }
326     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
327     return true;
328   }
329 
330 }
331 
332 contract UnlimitedAllowanceToken is StandardToken {
333 
334     uint256 internal constant MAX_UINT = 2**256 - 1;
335     
336     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance, and to add revert reasons.
337     /// @param _from Address to transfer from.
338     /// @param _to Address to transfer to.
339     /// @param _value Amount to transfer.
340     /// @return Success of transfer.
341     function transferFrom(
342         address _from,
343         address _to,
344         uint256 _value)
345         public
346         returns (bool)
347     {
348         uint256 allowance = allowed[_from][msg.sender];
349         require(_value <= balances[_from], "insufficient balance");
350         require(_value <= allowance, "insufficient allowance");
351         require(_to != address(0), "token burn not allowed");
352 
353         balances[_from] = balances[_from].sub(_value);
354         balances[_to] = balances[_to].add(_value);
355         if (allowance < MAX_UINT) {
356             allowed[_from][msg.sender] = allowance.sub(_value);
357         }
358         emit Transfer(_from, _to, _value);
359         return true;
360     }
361 
362     /// @dev Transfer token for a specified address, modified to add revert reasons.
363     /// @param _to The address to transfer to.
364     /// @param _value The amount to be transferred.
365     function transfer(
366         address _to,
367         uint256 _value)
368         public 
369         returns (bool)
370     {
371         require(_value <= balances[msg.sender], "insufficient balance");
372         require(_to != address(0), "token burn not allowed");
373 
374         balances[msg.sender] = balances[msg.sender].sub(_value);
375         balances[_to] = balances[_to].add(_value);
376         emit Transfer(msg.sender, _to, _value);
377         return true;
378     }
379 }
380 
381 contract BZRxToken is UnlimitedAllowanceToken, DetailedERC20, Ownable {
382 
383     event Mint(address indexed to, uint256 amount);
384     event MintFinished();
385     event LockingFinished();
386 
387     bool public mintingFinished = false;
388     bool public lockingFinished = false;
389 
390     mapping (address => bool) public minters;
391 
392     modifier canMint() {
393         require(!mintingFinished);
394         _;
395     }
396 
397     modifier hasMintPermission() {
398         require(minters[msg.sender]);
399         _;
400     }
401 
402     modifier isLocked() {
403         require(!lockingFinished);
404         _;
405     }
406 
407     constructor()
408         public
409         DetailedERC20(
410             "bZx Protocol Token",
411             "BZRX", 
412             18
413         )
414     {
415         minters[msg.sender] = true;
416     }
417 
418     /// @dev ERC20 transferFrom function
419     /// @param _from Address to transfer from.
420     /// @param _to Address to transfer to.
421     /// @param _value Amount to transfer.
422     /// @return Success of transfer.
423     function transferFrom(
424         address _from,
425         address _to,
426         uint256 _value)
427         public
428         returns (bool)
429     {
430         if (lockingFinished || minters[msg.sender]) {
431             return super.transferFrom(
432                 _from,
433                 _to,
434                 _value
435             );
436         }
437 
438         revert("this token is locked for transfers");
439     }
440 
441     /// @dev ERC20 transfer function
442     /// @param _to Address to transfer to.
443     /// @param _value Amount to transfer.
444     /// @return Success of transfer.
445     function transfer(
446         address _to, 
447         uint256 _value) 
448         public 
449         returns (bool)
450     {
451         if (lockingFinished || minters[msg.sender]) {
452             return super.transfer(
453                 _to,
454                 _value
455             );
456         }
457 
458         revert("this token is locked for transfers");
459     }
460 
461     /// @dev Allows minter to initiate a transfer on behalf of another spender
462     /// @param _spender Minter with permission to spend.
463     /// @param _from Address to transfer from.
464     /// @param _to Address to transfer to.
465     /// @param _value Amount to transfer.
466     /// @return Success of transfer.
467     function minterTransferFrom(
468         address _spender,
469         address _from,
470         address _to,
471         uint256 _value)
472         public
473         hasMintPermission
474         canMint
475         returns (bool)
476     {
477         require(canTransfer(
478             _spender,
479             _from,
480             _value),
481             "canTransfer is false");
482 
483         require(_to != address(0), "token burn not allowed");
484 
485         uint256 allowance = allowed[_from][_spender];
486         balances[_from] = balances[_from].sub(_value);
487         balances[_to] = balances[_to].add(_value);
488         if (allowance < MAX_UINT) {
489             allowed[_from][_spender] = allowance.sub(_value);
490         }
491         emit Transfer(_from, _to, _value);
492         return true;
493     }
494 
495     /**
496     * @dev Function to mint tokens
497     * @param _to The address that will receive the minted tokens.
498     * @param _amount The amount of tokens to mint.
499     * @return A boolean that indicates if the operation was successful.
500     */
501     function mint(
502         address _to,
503         uint256 _amount)
504         public
505         hasMintPermission
506         canMint
507         returns (bool)
508     {
509         require(_to != address(0), "token burn not allowed");
510         totalSupply_ = totalSupply_.add(_amount);
511         balances[_to] = balances[_to].add(_amount);
512         emit Mint(_to, _amount);
513         emit Transfer(address(0), _to, _amount);
514         return true;
515     }
516 
517     /**
518     * @dev Function to stop minting new tokens.
519     * @return True if the operation was successful.
520     */
521     function finishMinting() 
522         public 
523         onlyOwner 
524         canMint 
525     {
526         mintingFinished = true;
527         emit MintFinished();
528     }
529 
530     /**
531     * @dev Function to stop locking token.
532     * @return True if the operation was successful.
533     */
534     function finishLocking() 
535         public 
536         onlyOwner 
537         isLocked 
538     {
539         lockingFinished = true;
540         emit LockingFinished();
541     }
542 
543     /**
544     * @dev Function to add minter address.
545     * @return True if the operation was successful.
546     */
547     function addMinter(
548         address _minter) 
549         public 
550         onlyOwner 
551         canMint 
552     {
553         minters[_minter] = true;
554     }
555 
556     /**
557     * @dev Function to remove minter address.
558     * @return True if the operation was successful.
559     */
560     function removeMinter(
561         address _minter) 
562         public 
563         onlyOwner 
564         canMint 
565     {
566         minters[_minter] = false;
567     }
568 
569     /**
570     * @dev Function to check balance and allowance for a spender.
571     * @return True transfer will succeed based on balance and allowance.
572     */
573     function canTransfer(
574         address _spender,
575         address _from,
576         uint256 _value)
577         public
578         view
579         returns (bool)
580     {
581         return (
582             balances[_from] >= _value && 
583             (_spender == _from || allowed[_from][_spender] >= _value)
584         );
585     }
586 }
587 
588 interface WETHInterface {
589     function deposit() external payable;
590     function withdraw(uint256 wad) external;
591 }
592 
593 contract BZRxTokenConvert is Ownable {
594     using SafeMath for uint256;
595 
596     uint256 public tokenPrice = 73 * 10**12;    // 0.000073 ETH
597     uint256 public ethCollected;
598 
599     bool public conversionAllowed = true;
600 
601     address public bZRxTokenContractAddress;    // BZRX Token
602     address public bZxVaultAddress;             // bZx Vault
603     address public wethContractAddress;         // WETH Token
604 
605     modifier conversionIsAllowed() {
606         require(conversionAllowed, "conversion not allowed");
607         _;
608     }
609 
610     constructor(
611         address _bZRxTokenContractAddress,
612         address _bZxVaultAddress,
613         address _wethContractAddress,
614         uint256 _previousAmountCollected)
615         public
616     {
617         bZRxTokenContractAddress = _bZRxTokenContractAddress;
618         bZxVaultAddress = _bZxVaultAddress;
619         wethContractAddress = _wethContractAddress;
620         ethCollected = _previousAmountCollected;
621     }
622 
623     function()
624         external
625         payable 
626     {
627         require(msg.sender == wethContractAddress, "fallback not allowed");
628     }
629 
630     // conforms to ERC20 transferFrom function for BZRX token support
631     function transferFrom(
632         address _from,
633         address _to,
634         uint256 _value)
635         public
636         conversionIsAllowed
637         returns (bool)
638     {
639         require(msg.sender == bZxVaultAddress, "only the bZx vault can call this function");
640         
641         if (BZRxToken(bZRxTokenContractAddress).canTransfer(msg.sender, _from, _value)) {
642             return BZRxToken(bZRxTokenContractAddress).minterTransferFrom(
643                 msg.sender,
644                 _from,
645                 _to,
646                 _value
647             );
648         } else {
649             uint256 wethValue = _value                          // amount of BZRX
650                                 .mul(tokenPrice).div(10**18);   // fixed ETH price per token (0.000073 ETH)
651 
652             require(StandardToken(wethContractAddress).transferFrom(
653                 _from,
654                 address(this),
655                 wethValue
656             ), "weth transfer failed");
657 
658             ethCollected += wethValue;
659 
660             return BZRxToken(bZRxTokenContractAddress).mint(
661                 _to,
662                 _value
663             );
664         }
665     }
666 
667     /**
668     * @dev Function to stop conversion for this contract.
669     * @return True if the operation was successful.
670     */
671     function toggleConversionAllowed(
672         bool _conversionAllowed) 
673         public 
674         onlyOwner 
675         returns (bool)
676     {
677         conversionAllowed = _conversionAllowed;
678         return true;
679     }
680 
681     function changeTokenPrice(
682         uint256 _tokenPrice) 
683         public 
684         onlyOwner 
685         returns (bool)
686     {
687         tokenPrice = _tokenPrice;
688         return true;
689     }
690 
691     function changeBZRxTokenContract(
692         address _bZRxTokenContractAddress) 
693         public 
694         onlyOwner 
695         returns (bool)
696     {
697         bZRxTokenContractAddress = _bZRxTokenContractAddress;
698         return true;
699     }
700 
701     function changeBZxVault(
702         address _bZxVaultAddress) 
703         public 
704         onlyOwner 
705         returns (bool)
706     {
707         bZxVaultAddress = _bZxVaultAddress;
708         return true;
709     }
710 
711     function changeWethContract(
712         address _wethContractAddress) 
713         public 
714         onlyOwner 
715         returns (bool)
716     {
717         wethContractAddress = _wethContractAddress;
718         return true;
719     }
720 
721     function unwrapEth() 
722         public 
723         onlyOwner 
724         returns (bool)
725     {
726         uint256 balance = StandardToken(wethContractAddress).balanceOf.gas(4999)(address(this));
727         if (balance == 0)
728             return false;
729 
730         WETHInterface(wethContractAddress).withdraw(balance);
731         return true;
732     }
733 
734     function transferEther(
735         address payable _to,
736         uint256 _value)
737         public
738         onlyOwner
739         returns (bool)
740     {
741         uint256 amount = _value;
742         if (amount > address(this).balance) {
743             amount = address(this).balance;
744         }
745 
746         return (_to.send(amount));
747     }
748 
749     function transferToken(
750         address _tokenAddress,
751         address _to,
752         uint256 _value)
753         public
754         onlyOwner
755         returns (bool)
756     {
757         uint256 balance = StandardToken(_tokenAddress).balanceOf.gas(4999)(address(this));
758         if (_value > balance) {
759             return StandardToken(_tokenAddress).transfer(
760                 _to,
761                 balance
762             );
763         } else {
764             return StandardToken(_tokenAddress).transfer(
765                 _to,
766                 _value
767             );
768         }
769     }
770 }