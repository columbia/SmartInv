1 pragma solidity ^0.4.24;
2 
3 // File: @0xcert/ethereum-erc20/contracts/tokens/ERC20.sol
4 
5 /**
6  * @title A standard interface for tokens.
7  */
8 interface ERC20 {
9 
10   /**
11    * @dev Returns the name of the token.
12    */
13   function name()
14     external
15     view
16     returns (string _name);
17 
18   /**
19    * @dev Returns the symbol of the token.
20    */
21   function symbol()
22     external
23     view
24     returns (string _symbol);
25 
26   /**
27    * @dev Returns the number of decimals the token uses.
28    */
29   function decimals()
30     external
31     view
32     returns (uint8 _decimals);
33 
34   /**
35    * @dev Returns the total token supply.
36    */
37   function totalSupply()
38     external
39     view
40     returns (uint256 _totalSupply);
41 
42   /**
43    * @dev Returns the account balance of another account with address _owner.
44    * @param _owner The address from which the balance will be retrieved.
45    */
46   function balanceOf(
47     address _owner
48   )
49     external
50     view
51     returns (uint256 _balance);
52 
53   /**
54    * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
55    * function SHOULD throw if the _from account balance does not have enough tokens to spend.
56    * @param _to The address of the recipient.
57    * @param _value The amount of token to be transferred.
58    */
59   function transfer(
60     address _to,
61     uint256 _value
62   )
63     external
64     returns (bool _success);
65 
66   /**
67    * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
68    * Transfer event.
69    * @param _from The address of the sender.
70    * @param _to The address of the recipient.
71    * @param _value The amount of token to be transferred.
72    */
73   function transferFrom(
74     address _from,
75     address _to,
76     uint256 _value
77   )
78     external
79     returns (bool _success);
80 
81   /**
82    * @dev Allows _spender to withdraw from your account multiple times, up to
83    * the _value amount. If this function is called again it overwrites the current
84    * allowance with _value.
85    * @param _spender The address of the account able to transfer the tokens.
86    * @param _value The amount of tokens to be approved for transfer.
87    */
88   function approve(
89     address _spender,
90     uint256 _value
91   )
92     external
93     returns (bool _success);
94 
95   /**
96    * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
97    * @param _owner The address of the account owning tokens.
98    * @param _spender The address of the account able to transfer the tokens.
99    */
100   function allowance(
101     address _owner,
102     address _spender
103   )
104     external
105     view
106     returns (uint256 _remaining);
107 
108   /**
109    * @dev Triggers when tokens are transferred, including zero value transfers.
110    */
111   event Transfer(
112     address indexed _from,
113     address indexed _to,
114     uint256 _value
115   );
116 
117   /**
118    * @dev Triggers on any successful call to approve(address _spender, uint256 _value).
119    */
120   event Approval(
121     address indexed _owner,
122     address indexed _spender,
123     uint256 _value
124   );
125 
126 }
127 
128 // File: @0xcert/ethereum-utils/contracts/math/SafeMath.sol
129 
130 /**
131  * @dev Math operations with safety checks that throw on error. This contract is based
132  * on the source code at https://goo.gl/iyQsmU.
133  */
134 library SafeMath {
135 
136   /**
137    * @dev Multiplies two numbers, throws on overflow.
138    * @param _a Factor number.
139    * @param _b Factor number.
140    */
141   function mul(
142     uint256 _a,
143     uint256 _b
144   )
145     internal
146     pure
147     returns (uint256)
148   {
149     if (_a == 0) {
150       return 0;
151     }
152     uint256 c = _a * _b;
153     assert(c / _a == _b);
154     return c;
155   }
156 
157   /**
158    * @dev Integer division of two numbers, truncating the quotient.
159    * @param _a Dividend number.
160    * @param _b Divisor number.
161    */
162   function div(
163     uint256 _a,
164     uint256 _b
165   )
166     internal
167     pure
168     returns (uint256)
169   {
170     uint256 c = _a / _b;
171     // assert(b > 0); // Solidity automatically throws when dividing by 0
172     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173     return c;
174   }
175 
176   /**
177    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
178    * @param _a Minuend number.
179    * @param _b Subtrahend number.
180    */
181   function sub(
182     uint256 _a,
183     uint256 _b
184   )
185     internal
186     pure
187     returns (uint256)
188   {
189     assert(_b <= _a);
190     return _a - _b;
191   }
192 
193   /**
194    * @dev Adds two numbers, throws on overflow.
195    * @param _a Number.
196    * @param _b Number.
197    */
198   function add(
199     uint256 _a,
200     uint256 _b
201   )
202     internal
203     pure
204     returns (uint256)
205   {
206     uint256 c = _a + _b;
207     assert(c >= _a);
208     return c;
209   }
210 
211 }
212 
213 // File: @0xcert/ethereum-erc20/contracts/tokens/Token.sol
214 
215 /**
216  * @title ERC20 standard token implementation.
217  * @dev Standard ERC20 token. This contract follows the implementation at https://goo.gl/mLbAPJ.
218  */
219 contract Token is
220   ERC20
221 {
222   using SafeMath for uint256;
223 
224   /**
225    * Token name.
226    */
227   string internal tokenName;
228 
229   /**
230    * Token symbol.
231    */
232   string internal tokenSymbol;
233 
234   /**
235    * Number of decimals.
236    */
237   uint8 internal tokenDecimals;
238 
239   /**
240    * Total supply of tokens.
241    */
242   uint256 internal tokenTotalSupply;
243 
244   /**
245    * Balance information map.
246    */
247   mapping (address => uint256) internal balances;
248 
249   /**
250    * Token allowance mapping.
251    */
252   mapping (address => mapping (address => uint256)) internal allowed;
253 
254   /**
255    * @dev Trigger when tokens are transferred, including zero value transfers.
256    */
257   event Transfer(
258     address indexed _from,
259     address indexed _to,
260     uint256 _value
261   );
262 
263   /**
264    * @dev Trigger on any successful call to approve(address _spender, uint256 _value).
265    */
266   event Approval(
267     address indexed _owner,
268     address indexed _spender,
269     uint256 _value
270   );
271 
272   /**
273    * @dev Returns the name of the token.
274    */
275   function name()
276     external
277     view
278     returns (string _name)
279   {
280     _name = tokenName;
281   }
282 
283   /**
284    * @dev Returns the symbol of the token.
285    */
286   function symbol()
287     external
288     view
289     returns (string _symbol)
290   {
291     _symbol = tokenSymbol;
292   }
293 
294   /**
295    * @dev Returns the number of decimals the token uses.
296    */
297   function decimals()
298     external
299     view
300     returns (uint8 _decimals)
301   {
302     _decimals = tokenDecimals;
303   }
304 
305   /**
306    * @dev Returns the total token supply.
307    */
308   function totalSupply()
309     external
310     view
311     returns (uint256 _totalSupply)
312   {
313     _totalSupply = tokenTotalSupply;
314   }
315 
316   /**
317    * @dev Returns the account balance of another account with address _owner.
318    * @param _owner The address from which the balance will be retrieved.
319    */
320   function balanceOf(
321     address _owner
322   )
323     external
324     view
325     returns (uint256 _balance)
326   {
327     _balance = balances[_owner];
328   }
329 
330   /**
331    * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
332    * function SHOULD throw if the _from account balance does not have enough tokens to spend.
333    * @param _to The address of the recipient.
334    * @param _value The amount of token to be transferred.
335    */
336   function transfer(
337     address _to,
338     uint256 _value
339   )
340     public
341     returns (bool _success)
342   {
343     require(_value <= balances[msg.sender]);
344 
345     balances[msg.sender] = balances[msg.sender].sub(_value);
346     balances[_to] = balances[_to].add(_value);
347 
348     emit Transfer(msg.sender, _to, _value);
349     _success = true;
350   }
351 
352   /**
353    * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. If
354    * this function is called again it overwrites the current allowance with _value.
355    * @param _spender The address of the account able to transfer the tokens.
356    * @param _value The amount of tokens to be approved for transfer.
357    */
358   function approve(
359     address _spender,
360     uint256 _value
361   )
362     public
363     returns (bool _success)
364   {
365     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
366 
367     allowed[msg.sender][_spender] = _value;
368 
369     emit Approval(msg.sender, _spender, _value);
370     _success = true;
371   }
372 
373   /**
374    * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
375    * @param _owner The address of the account owning tokens.
376    * @param _spender The address of the account able to transfer the tokens.
377    */
378   function allowance(
379     address _owner,
380     address _spender
381   )
382     external
383     view
384     returns (uint256 _remaining)
385   {
386     _remaining = allowed[_owner][_spender];
387   }
388 
389   /**
390    * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
391    * Transfer event.
392    * @param _from The address of the sender.
393    * @param _to The address of the recipient.
394    * @param _value The amount of token to be transferred.
395    */
396   function transferFrom(
397     address _from,
398     address _to,
399     uint256 _value
400   )
401     public
402     returns (bool _success)
403   {
404     require(_value <= balances[_from]);
405     require(_value <= allowed[_from][msg.sender]);
406 
407     balances[_from] = balances[_from].sub(_value);
408     balances[_to] = balances[_to].add(_value);
409     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
410 
411     emit Transfer(_from, _to, _value);
412     _success = true;
413   }
414 
415 }
416 
417 // File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol
418 
419 /**
420  * @dev The contract has an owner address, and provides basic authorization control whitch
421  * simplifies the implementation of user permissions. This contract is based on the source code
422  * at https://goo.gl/n2ZGVt.
423  */
424 contract Ownable {
425   address public owner;
426 
427   /**
428    * @dev An event which is triggered when the owner is changed.
429    * @param previousOwner The address of the previous owner.
430    * @param newOwner The address of the new owner.
431    */
432   event OwnershipTransferred(
433     address indexed previousOwner,
434     address indexed newOwner
435   );
436 
437   /**
438    * @dev The constructor sets the original `owner` of the contract to the sender account.
439    */
440   constructor()
441     public
442   {
443     owner = msg.sender;
444   }
445 
446   /**
447    * @dev Throws if called by any account other than the owner.
448    */
449   modifier onlyOwner() {
450     require(msg.sender == owner);
451     _;
452   }
453 
454   /**
455    * @dev Allows the current owner to transfer control of the contract to a newOwner.
456    * @param _newOwner The address to transfer ownership to.
457    */
458   function transferOwnership(
459     address _newOwner
460   )
461     onlyOwner
462     public
463   {
464     require(_newOwner != address(0));
465     emit OwnershipTransferred(owner, _newOwner);
466     owner = _newOwner;
467   }
468 
469 }
470 
471 // File: @0xcert/ethereum-utils/contracts/ownership/Claimable.sol
472 
473 /**
474  * @dev The contract has an owner address, and provides basic authorization control whitch
475  * simplifies the implementation of user permissions. This contract is based on the source code
476  * at goo.gl/CfEAkv and upgrades Ownable contracts with additional claim step which makes ownership
477  * transfers less prone to errors.
478  */
479 contract Claimable is Ownable {
480   address public pendingOwner;
481 
482   /**
483    * @dev An event which is triggered when the owner is changed.
484    * @param previousOwner The address of the previous owner.
485    * @param newOwner The address of the new owner.
486    */
487   event OwnershipTransferred(
488     address indexed previousOwner,
489     address indexed newOwner
490   );
491 
492   /**
493    * @dev Allows the current owner to give new owner ability to claim the ownership of the contract.
494    * This differs from the Owner's function in that it allows setting pedingOwner address to 0x0,
495    * which effectively cancels an active claim.
496    * @param _newOwner The address which can claim ownership of the contract.
497    */
498   function transferOwnership(
499     address _newOwner
500   )
501     onlyOwner
502     public
503   {
504     pendingOwner = _newOwner;
505   }
506 
507   /**
508    * @dev Allows the current pending owner to claim the ownership of the contract. It emits
509    * OwnershipTransferred event and resets pending owner to 0.
510    */
511   function claimOwnership()
512     public
513   {
514     require(msg.sender == pendingOwner);
515     address previousOwner = owner;
516     owner = pendingOwner;
517     pendingOwner = 0;
518     emit OwnershipTransferred(previousOwner, owner);
519   }
520 }
521 
522 // File: contracts/tokens/Zxc.sol
523 
524 /*
525  * @title ZXC protocol token.
526  * @dev Standard ERC20 token used by the 0xcert protocol. This contract follows the implementation
527  * at https://goo.gl/twbPwp.
528  */
529 contract Zxc is
530   Token,
531   Claimable
532 {
533   using SafeMath for uint256;
534 
535   /**
536    * Transfer feature state.
537    */
538   bool internal transferEnabled;
539 
540   /**
541    * Crowdsale smart contract address.
542    */
543   address public crowdsaleAddress;
544 
545   /**
546    * @dev An event which is triggered when tokens are burned.
547    * @param _burner The address which burns tokens.
548    * @param _value The amount of burned tokens.
549    */
550   event Burn(
551     address indexed _burner,
552     uint256 _value
553   );
554 
555   /**
556    * @dev Assures that the provided address is a valid destination to transfer tokens to.
557    * @param _to Target address.
558    */
559   modifier validDestination(
560     address _to
561   )
562   {
563     require(_to != address(0x0));
564     require(_to != address(this));
565     require(_to != address(crowdsaleAddress));
566     _;
567   }
568 
569   /**
570    * @dev Assures that tokens can be transfered.
571    */
572   modifier onlyWhenTransferAllowed()
573   {
574     require(transferEnabled || msg.sender == crowdsaleAddress);
575     _;
576   }
577 
578   /**
579    * @dev Contract constructor.
580    */
581   constructor()
582     public
583   {
584     tokenName = "0xcert Protocol Token";
585     tokenSymbol = "ZXC";
586     tokenDecimals = 18;
587     tokenTotalSupply = 500000000000000000000000000;
588     transferEnabled = false;
589 
590     balances[owner] = tokenTotalSupply;
591     emit Transfer(address(0x0), owner, tokenTotalSupply);
592   }
593 
594   /**
595    * @dev Transfers token to a specified address.
596    * @param _to The address to transfer to.
597    * @param _value The amount to be transferred.
598    */
599   function transfer(
600     address _to,
601     uint256 _value
602   )
603     onlyWhenTransferAllowed()
604     validDestination(_to)
605     public
606     returns (bool _success)
607   {
608     _success = super.transfer(_to, _value);
609   }
610 
611   /**
612    * @dev Transfers tokens from one address to another.
613    * @param _from address The address which you want to send tokens from.
614    * @param _to address The address which you want to transfer to.
615    * @param _value uint256 The amount of tokens to be transferred.
616    */
617   function transferFrom(
618     address _from,
619     address _to,
620     uint256 _value
621   )
622     onlyWhenTransferAllowed()
623     validDestination(_to)
624     public
625     returns (bool _success)
626   {
627     _success = super.transferFrom(_from, _to, _value);
628   }
629 
630   /**
631    * @dev Enables token transfers.
632    */
633   function enableTransfer()
634     onlyOwner()
635     external
636   {
637     transferEnabled = true;
638   }
639 
640   /**
641    * @dev Burns a specific amount of tokens. This function is based on BurnableToken implementation
642    * at goo.gl/GZEhaq.
643    * @notice Only owner is allowed to perform this operation.
644    * @param _value The amount of tokens to be burned.
645    */
646   function burn(
647     uint256 _value
648   )
649     onlyOwner()
650     external
651   {
652     require(_value <= balances[msg.sender]);
653 
654     balances[owner] = balances[owner].sub(_value);
655     tokenTotalSupply = tokenTotalSupply.sub(_value);
656 
657     emit Burn(owner, _value);
658     emit Transfer(owner, address(0x0), _value);
659   }
660 
661   /**
662     * @dev Set crowdsale address which can distribute tokens even when onlyWhenTransferAllowed is
663     * false.
664     * @param crowdsaleAddr Address of token offering contract.
665     */
666   function setCrowdsaleAddress(
667     address crowdsaleAddr
668   )
669     external
670     onlyOwner()
671   {
672     crowdsaleAddress = crowdsaleAddr;
673   }
674 
675 }