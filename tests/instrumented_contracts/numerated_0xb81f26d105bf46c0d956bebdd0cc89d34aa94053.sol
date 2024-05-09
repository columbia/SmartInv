1 pragma solidity ^0.4.19;
2 
3 contract DSMath {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x);
6     }
7     function sub(uint x, uint y) internal pure returns (uint z) {
8         require((z = x - y) <= x);
9     }
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x);
12     }
13 
14     function min(uint x, uint y) internal pure returns (uint z) {
15         return x <= y ? x : y;
16     }
17     function max(uint x, uint y) internal pure returns (uint z) {
18         return x >= y ? x : y;
19     }
20     function imin(int x, int y) internal pure returns (int z) {
21         return x <= y ? x : y;
22     }
23     function imax(int x, int y) internal pure returns (int z) {
24         return x >= y ? x : y;
25     }
26 
27     uint constant WAD = 10 ** 18;
28     uint constant RAY = 10 ** 27;
29 
30     function wmul(uint x, uint y) internal pure returns (uint z) {
31         z = add(mul(x, y), WAD / 2) / WAD;
32     }
33     function rmul(uint x, uint y) internal pure returns (uint z) {
34         z = add(mul(x, y), RAY / 2) / RAY;
35     }
36     function wdiv(uint x, uint y) internal pure returns (uint z) {
37         z = add(mul(x, WAD), y / 2) / y;
38     }
39     function rdiv(uint x, uint y) internal pure returns (uint z) {
40         z = add(mul(x, RAY), y / 2) / y;
41     }
42 
43     // This famous algorithm is called "exponentiation by squaring"
44     // and calculates x^n with x as fixed-point and n as regular unsigned.
45     //
46     // It's O(log n), instead of O(n) for naive repeated multiplication.
47     //
48     // These facts are why it works:
49     //
50     //  If n is even, then x^n = (x^2)^(n/2).
51     //  If n is odd,  then x^n = x * x^(n-1),
52     //   and applying the equation for even x gives
53     //    x^n = x * (x^2)^((n-1) / 2).
54     //
55     //  Also, EVM division is flooring and
56     //    floor[(n-1) / 2] = floor[n / 2].
57     //
58     function rpow(uint x, uint n) internal pure returns (uint z) {
59         z = n % 2 != 0 ? x : RAY;
60 
61         for (n /= 2; n != 0; n /= 2) {
62             x = rmul(x, x);
63 
64             if (n % 2 != 0) {
65                 z = rmul(z, x);
66             }
67         }
68     }
69 }
70 
71 contract ERC20Events {
72     event Approval(address indexed src, address indexed guy, uint wad);
73     event Transfer(address indexed src, address indexed dst, uint wad);
74 }
75 
76 contract ERC20 is ERC20Events {
77     function totalSupply() public view returns (uint);
78     function balanceOf(address guy) public view returns (uint);
79     function allowance(address src, address guy) public view returns (uint);
80 
81     function approve(address guy, uint wad) public returns (bool);
82     function transfer(address dst, uint wad) public returns (bool);
83     function transferFrom(
84         address src, address dst, uint wad
85     ) public returns (bool);
86 }
87 
88 
89 contract DSAuthority {
90     function canCall(
91         address src, address dst, bytes4 sig
92     ) public view returns (bool);
93 }
94 
95 contract DSAuthEvents {
96     event LogSetAuthority (address indexed authority);
97     event LogSetOwner     (address indexed owner);
98 }
99 
100 contract DSAuth is DSAuthEvents {
101     DSAuthority  public  authority;
102     address      public  owner;
103 
104     constructor() public {
105         owner = msg.sender;
106         emit LogSetOwner(msg.sender);
107     }
108 
109     function setOwner(address owner_)
110         public
111         auth
112     {
113         owner = owner_;
114         emit LogSetOwner(owner);
115     }
116 
117     function setAuthority(DSAuthority authority_)
118         public
119         auth
120     {
121         authority = authority_;
122         emit LogSetAuthority(authority);
123     }
124 
125     modifier auth {
126         require(isAuthorized(msg.sender, msg.sig));
127         _;
128     }
129 
130     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
131         if (src == address(this)) {
132             return true;
133         } else if (src == owner) {
134             return true;
135         } else if (authority == DSAuthority(0)) {
136             return false;
137         } else {
138             return authority.canCall(src, this, sig);
139         }
140     }
141 }
142 
143 
144 contract DSNote {
145     event LogNote(
146         bytes4   indexed  sig,
147         address  indexed  guy,
148         bytes32  indexed  foo,
149         bytes32  indexed  bar,
150         uint              wad,
151         bytes             fax
152     ) anonymous;
153 
154     modifier note {
155         bytes32 foo;
156         bytes32 bar;
157 
158         assembly {
159             foo := calldataload(4)
160             bar := calldataload(36)
161         }
162 
163         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
164 
165         _;
166     }
167 }
168 
169 
170 contract DSStop is DSNote, DSAuth {
171 
172     bool public stopped;
173 
174     modifier stoppable {
175         require(!stopped);
176         _;
177     }
178     function stop() public auth note {
179         stopped = true;
180     }
181     function start() public auth note {
182         stopped = false;
183     }
184 
185 }
186 
187 contract DSTokenBase is ERC20, DSMath {
188     uint256                                            _supply;
189     mapping (address => uint256)                       _balances;
190     mapping (address => mapping (address => uint256))  _approvals;
191 
192     constructor(uint supply) public {
193         _balances[msg.sender] = supply;
194         _supply = supply;
195     }
196 
197     function totalSupply() public view returns (uint) {
198         return _supply;
199     }
200     function balanceOf(address src) public view returns (uint) {
201         return _balances[src];
202     }
203     function allowance(address src, address guy) public view returns (uint) {
204         return _approvals[src][guy];
205     }
206 
207     function transfer(address dst, uint wad) public returns (bool) {
208         return transferFrom(msg.sender, dst, wad);
209     }
210 
211     function transferFrom(address src, address dst, uint wad)
212         public
213         returns (bool)
214     {
215         if (src != msg.sender) {
216             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
217         }
218 
219         _balances[src] = sub(_balances[src], wad);
220         _balances[dst] = add(_balances[dst], wad);
221 
222         emit Transfer(src, dst, wad);
223 
224         return true;
225     }
226 
227     function approve(address guy, uint wad) public returns (bool) {
228         _approvals[msg.sender][guy] = wad;
229 
230         emit Approval(msg.sender, guy, wad);
231 
232         return true;
233     }
234 }
235 
236 contract DSToken is DSTokenBase(0), DSStop {
237 
238     bytes32  public  symbol;
239     uint256  public  decimals = 18; // standard token precision. override to customize
240 
241     constructor(bytes32 symbol_) public {
242         symbol = symbol_;
243     }
244 
245     event Mint(address indexed guy, uint wad);
246     event Burn(address indexed guy, uint wad);
247 
248     function approve(address guy) public stoppable returns (bool) {
249         return super.approve(guy, uint(-1));
250     }
251 
252     function approve(address guy, uint wad) public stoppable returns (bool) {
253         return super.approve(guy, wad);
254     }
255 
256     function transferFrom(address src, address dst, uint wad)
257         public
258         stoppable
259         returns (bool)
260     {
261         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
262             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
263         }
264 
265         _balances[src] = sub(_balances[src], wad);
266         _balances[dst] = add(_balances[dst], wad);
267 
268         emit Transfer(src, dst, wad);
269 
270         return true;
271     }
272 
273     function push(address dst, uint wad) public {
274         transferFrom(msg.sender, dst, wad);
275     }
276     function pull(address src, uint wad) public {
277         transferFrom(src, msg.sender, wad);
278     }
279     function move(address src, address dst, uint wad) public {
280         transferFrom(src, dst, wad);
281     }
282 
283     function mint(uint wad) public {
284         mint(msg.sender, wad);
285     }
286     function burn(uint wad) public {
287         burn(msg.sender, wad);
288     }
289     function mint(address guy, uint wad) public auth stoppable {
290         _balances[guy] = add(_balances[guy], wad);
291         _supply = add(_supply, wad);
292         emit Mint(guy, wad);
293     }
294     function burn(address guy, uint wad) public auth stoppable {
295         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
296             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
297         }
298 
299         _balances[guy] = sub(_balances[guy], wad);
300         _supply = sub(_supply, wad);
301         emit Burn(guy, wad);
302     }
303 
304     // Optional token name
305     bytes32   public  name = "";
306 
307     function setName(bytes32 name_) public auth {
308         name = name_;
309     }
310 }
311 
312 contract ERC223ReceivingContract {
313 
314     /// @dev Function that is called when a user or another contract wants to transfer funds.
315     /// @param _from Transaction initiator, analogue of msg.sender
316     /// @param _value Number of tokens to transfer.
317     /// @param _data Data containig a function signature and/or parameters
318     function tokenFallback(address _from, uint256 _value, bytes _data) public;
319 
320 
321     /// @dev For ERC20 backward compatibility, same with above tokenFallback but without data.
322     /// The function execution could fail, but do not influence the token transfer.
323     /// @param _from Transaction initiator, analogue of msg.sender
324     /// @param _value Number of tokens to transfer.
325     //  function tokenFallback(address _from, uint256 _value) public;
326 }
327 
328 
329 contract TokenController {
330     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
331     /// @param _owner The address that sent the ether to create tokens
332     /// @return True if the ether is accepted, false if it throws
333     function proxyPayment(address _owner) payable public returns (bool);
334 
335     /// @notice Notifies the controller about a token transfer allowing the
336     ///  controller to react if desired
337     /// @param _from The origin of the transfer
338     /// @param _to The destination of the transfer
339     /// @param _amount The amount of the transfer
340     /// @return False if the controller does not authorize the transfer
341     function onTransfer(address _from, address _to, uint _amount) public returns (bool);
342 
343     /// @notice Notifies the controller about an approval allowing the
344     ///  controller to react if desired
345     /// @param _owner The address that calls `approve()`
346     /// @param _spender The spender in the `approve()` call
347     /// @param _amount The amount in the `approve()` call
348     /// @return False if the controller does not authorize the approval
349     function onApprove(address _owner, address _spender, uint _amount) public returns (bool);
350 }
351 
352 
353 contract Controlled {
354     /// @notice The address of the controller is the only address that can call
355     ///  a function with this modifier
356     modifier onlyController { if (msg.sender != controller) revert(); _; }
357 
358     address public controller;
359 
360     constructor() { controller = msg.sender;}
361 
362     /// @notice Changes the controller of the contract
363     /// @param _newController The new controller of the contract
364     function changeController(address _newController) onlyController {
365         controller = _newController;
366     }
367 }
368 
369 contract ApproveAndCallFallBack {
370     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
371 }
372 
373 contract ERC223 {
374     function transfer(address to, uint amount, bytes data) public returns (bool ok);
375 
376     function transferFrom(address from, address to, uint256 amount, bytes data) public returns (bool ok);
377 
378     function transfer(address to, uint amount, bytes data, string custom_fallback) public returns (bool ok);
379 
380     function transferFrom(address from, address to, uint256 amount, bytes data, string custom_fallback) public returns (bool ok);
381 
382     event ERC223Transfer(address indexed from, address indexed to, uint amount, bytes data);
383 
384     event ReceivingContractTokenFallbackFailed(address indexed from, address indexed to, uint amount);
385 }
386 
387 contract AKC is DSToken("AKC"), ERC223, Controlled {
388 
389     constructor() {
390         setName("ARTWOOK Coin");
391     }
392 
393     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
394     ///  is approved by `_from`
395     /// @param _from The address holding the tokens being transferred
396     /// @param _to The address of the recipient
397     /// @param _amount The amount of tokens to be transferred
398     /// @return True if the transfer was successful
399     function transferFrom(address _from, address _to, uint256 _amount
400     ) public returns (bool success) {
401         // Alerts the token controller of the transfer
402         if (isContract(controller)) {
403             if (!TokenController(controller).onTransfer(_from, _to, _amount))
404                revert();
405         }
406 
407         success = super.transferFrom(_from, _to, _amount);
408 
409         if (success && isContract(_to))
410         {
411             // ERC20 backward compatiability
412             if(!_to.call(bytes4(keccak256("tokenFallback(address,uint256)")), _from, _amount)) {
413                 // do nothing when error in call in case that the _to contract is not inherited from ERC223ReceivingContract
414                 // revert();
415                 // bytes memory empty;
416 
417                 emit ReceivingContractTokenFallbackFailed(_from, _to, _amount);
418 
419                 // Even the fallback failed if there is such one, the transfer will not be revert since "revert()" is not called.
420             }
421         }
422     }
423 
424     /*
425      * ERC 223
426      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
427      */
428     function transferFrom(address _from, address _to, uint256 _amount, bytes _data)
429         public
430         returns (bool success)
431     {
432         // Alerts the token controller of the transfer
433         if (isContract(controller)) {
434             if (!TokenController(controller).onTransfer(_from, _to, _amount))
435                revert();
436         }
437 
438         require(super.transferFrom(_from, _to, _amount));
439 
440         if (isContract(_to)) {
441             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
442             receiver.tokenFallback(_from, _amount, _data);
443         }
444 
445         emit ERC223Transfer(_from, _to, _amount, _data);
446 
447         return true;
448     }
449 
450     /*
451      * ERC 223
452      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
453      * https://github.com/ethereum/EIPs/issues/223
454      * function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
455      */
456     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
457     /// tokenFallback if sender is a contract.
458     /// @dev Function that is called when a user or another contract wants to transfer funds.
459     /// @param _to Address of token receiver.
460     /// @param _amount Number of tokens to transfer.
461     /// @param _data Data to be sent to tokenFallback
462     /// @return Returns success of function call.
463     function transfer(
464         address _to,
465         uint256 _amount,
466         bytes _data)
467         public
468         returns (bool success)
469     {
470         return transferFrom(msg.sender, _to, _amount, _data);
471     }
472 
473     /*
474      * ERC 223
475      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
476      */
477     function transferFrom(address _from, address _to, uint256 _amount, bytes _data, string _custom_fallback)
478         public
479         returns (bool success)
480     {
481         // Alerts the token controller of the transfer
482         if (isContract(controller)) {
483             if (!TokenController(controller).onTransfer(_from, _to, _amount))
484                revert();
485         }
486 
487         require(super.transferFrom(_from, _to, _amount));
488 
489         if (isContract(_to)) {
490             if(_to == address(this)) revert();
491             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
492             receiver.call.value(0)(bytes4(keccak256(_custom_fallback)), _from, _amount, _data);
493         }
494 
495         emit ERC223Transfer(_from, _to, _amount, _data);
496 
497         return true;
498     }
499 
500     /*
501      * ERC 223
502      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
503      */
504     function transfer(
505         address _to,
506         uint _amount,
507         bytes _data,
508         string _custom_fallback)
509         public
510         returns (bool success)
511     {
512         return transferFrom(msg.sender, _to, _amount, _data, _custom_fallback);
513     }
514 
515     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
516     ///  its behalf. This is a modified version of the ERC20 approve function
517     ///  to be a little bit safer
518     /// @param _spender The address of the account able to transfer the tokens
519     /// @param _amount The amount of tokens to be approved for transfer
520     /// @return True if the approval was successful
521     function approve(address _spender, uint256 _amount) returns (bool success) {
522         // Alerts the token controller of the approve function call
523         if (isContract(controller)) {
524             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
525                 revert();
526         }
527 
528         return super.approve(_spender, _amount);
529     }
530 
531     function mint(address _guy, uint _wad) auth stoppable {
532         super.mint(_guy, _wad);
533 
534         Transfer(0, _guy, _wad);
535     }
536     function burn(address _guy, uint _wad) auth stoppable {
537         super.burn(_guy, _wad);
538 
539         Transfer(_guy, 0, _wad);
540     }
541 
542     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
543     ///  its behalf, and then a function is triggered in the contract that is
544     ///  being approved, `_spender`. This allows users to use their tokens to
545     ///  interact with contracts in one function call instead of two
546     /// @param _spender The address of the contract able to transfer the tokens
547     /// @param _amount The amount of tokens to be approved for transfer
548     /// @return True if the function call was successful
549     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
550     ) returns (bool success) {
551         if (!approve(_spender, _amount)) revert();
552 
553         ApproveAndCallFallBack(_spender).receiveApproval(
554             msg.sender,
555             _amount,
556             this,
557             _extraData
558         );
559 
560         return true;
561     }
562 
563     /// @dev Internal function to determine if an address is a contract
564     /// @param _addr The address being queried
565     /// @return True if `_addr` is a contract
566     function isContract(address _addr) constant internal returns(bool) {
567         uint size;
568         if (_addr == 0) return false;
569         assembly {
570             size := extcodesize(_addr)
571         }
572         return size>0;
573     }
574 
575     /// @notice The fallback function: If the contract's controller has not been
576     ///  set to 0, then the `proxyPayment` method is called which relays the
577     ///  ether and creates tokens as described in the token controller contract
578     function ()  payable {
579         if (isContract(controller)) {
580             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
581                 revert();
582         } else {
583             revert();
584         }
585     }
586 
587 //////////
588 // Safety Methods
589 //////////
590 
591     /// @notice This method can be used by the controller to extract mistakenly
592     ///  sent tokens to this contract.
593     /// @param _token The address of the token contract that you want to recover
594     ///  set to 0 in case you want to extract ether.
595     function claimTokens(address _token) onlyController {
596         if (_token == 0x0) {
597             controller.transfer(this.balance);
598             return;
599         }
600 
601         ERC20 token = ERC20(_token);
602         uint balance = token.balanceOf(this);
603         token.transfer(controller, balance);
604         emit ClaimedTokens(_token, controller, balance);
605     }
606 
607 ////////////////
608 // Events
609 ////////////////
610 
611     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
612 }
613 
614 
615 /**
616  * @title SafeMath
617  * @dev Math operations with safety checks that throw on error.
618  */
619 library SafeMath {
620   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
621     if (a == 0) {
622       return 0;
623     }
624     uint256 c = a * b;
625     assert(c / a == b);
626     return c;
627   }
628 
629   function div(uint256 a, uint256 b) internal pure returns (uint256) {
630     uint256 c = a / b;
631     return c;
632   }
633 
634   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
635     assert(b <= a);
636     return a - b;
637   }
638 
639   function add(uint256 a, uint256 b) internal pure returns (uint256) {
640     uint256 c = a + b;
641     assert(c >= a);
642     return c;
643   }
644 }
645 
646 /**
647  * @title Ownable
648  * @dev The Ownable contract has an owner address, and provides basic authorization control
649  * functions, this simplifies the implementation of "user permissions".
650  */
651 contract Ownable {
652   address public owner;
653 
654   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
655 
656   /**
657    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
658    * account.
659    */
660   constructor() public {
661     owner = msg.sender;
662   }
663 
664   /**
665    * @dev Throws if called by any account other than the owner.
666    */
667   modifier onlyOwner() {
668     require(msg.sender == owner);
669     _;
670   }
671 
672   /**
673    * @dev Allows the current owner to transfer control of the contract to a newOwner.
674    * @param newOwner The address that transfer ownership to.
675    */
676   function transferOwnership(address newOwner) public onlyOwner {
677     require(newOwner != address(0));
678     owner = newOwner;
679     emit OwnershipTransferred(owner, newOwner);
680   }
681 
682 }
683 
684 /**
685  * @title Pausable
686  * @dev Assign a paused status to contract to pause and continue later.
687  *
688  */
689 contract Pausable is Ownable {
690     bool public paused = false;
691 
692     event Pause();
693     event Unpause();
694 
695     /**
696      * @dev Throws if paused is true.
697      */
698     modifier whenNotPaused() { require(!paused); _; }
699 
700     /**
701      * @dev Throws if paused is false.
702      */
703     modifier whenPaused() { require(paused); _; }
704 
705     /**
706      * @dev Set paused to true.
707      */
708     function pause() onlyOwner whenNotPaused public {
709         paused = true;
710         emit Pause();
711     }
712 
713     /**
714      * @dev Set paused to false.
715      */
716     function unpause() onlyOwner whenPaused public {
717         paused = false;
718         emit Unpause();
719     }
720 }
721 
722 /**
723  * @title Withdrawable
724  * @dev Allow contract owner to withdrow Ether or ERC20 token from contract.
725  *
726  */
727 contract Withdrawable is Ownable {
728     /**
729     * @dev withdraw Ether from contract
730     * @param _to The address transfer Ether to.
731     * @param _value The amount to be transferred.
732     */
733     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
734         require(_to != address(0));
735         require(address(this).balance >= _value);
736 
737         _to.transfer(_value);
738 
739         return true;
740     }
741 
742     /**
743     * @dev withdraw ERC20 token from contract
744     * @param _token ERC20 token contract address.
745     * @param _to The address transfer Token to.
746     * @param _value The amount to be transferred.
747     */
748     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
749         require(_to != address(0));
750 
751         return _token.transfer(_to, _value);
752     }
753 }
754 
755 /**
756  * @title ArtwookCoinCrowdsale
757  * @dev AKC token sale contract.
758  */
759 contract AKCCrowdsale is Pausable, Withdrawable {
760   using SafeMath for uint;
761 
762   struct Step {
763       uint priceTokenWei;
764       uint minInvestEth;
765       uint timestamp;
766       uint tokensSold;
767       uint collectedWei;
768 
769   }
770   AKC public token;
771   address public beneficiary;
772 
773   Step[] public steps;
774   uint8 public currentStep = 0;
775   uint public totalTokensSold = 0;
776   uint public totalCollectedWei = 0;
777   bool public crowdsaleClosed = false;
778   uint public totalTokensForSale = 0;
779 
780   event Purchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
781   event NextStep(uint8 step);
782   event CrowdsaleClose();
783 
784   /**
785   * @dev Initialize the crowdsale conditions.
786   * @param akctoken AKC token contract address.
787   */
788   function AKCCrowdsale(AKC akctoken, uint phase1, uint phase2, uint phase3, uint phase4, address multiSigWallet) public {
789       require(token==address(0));
790       /* token = new AKC(); */
791       token = akctoken;
792       beneficiary = multiSigWallet;
793       // crowdsale only sale 4.5% of totalSupply
794       totalTokensForSale = 9000000 ether;
795       uint oneEther = 1 ether;
796       /**
797       * Crowdsale is conducted in three phases. Token exchange rate is 1Ether:3000AKC
798       * The crowdsale starts on July 20, 2018.
799       * 2018/07/20 - 2018/07/29   15% off on AKC token exchange rate.
800       * 2018/07/30 - 2018/08/08   10% off on AKC token exchange rate.
801       * 2018/08/09 - 2018/08/18   5% off on AKC token exchange rate.
802       * 2018/08/19 - 2018/08/30   Original exchange rate.
803       */
804       steps.push(Step(oneEther.div(3450), 1 ether, phase1, 0, 0));
805       steps.push(Step(oneEther.div(3300), 1 ether, phase2, 0, 0));
806       steps.push(Step(oneEther.div(3150), 1 ether, phase3, 0, 0));
807       steps.push(Step(oneEther.div(3000), 1 ether, phase4, 0, 0));
808   }
809 
810   /**
811   * @dev Fallback function that will delegate the request to purchase().
812   */
813   function() external payable  {
814       purchase(msg.sender);
815   }
816 
817   /**
818   * @dev purchase AKC
819   * @param sender The address to receive AKC.
820   */
821   function purchase(address sender) whenNotPaused payable public {
822       require(!crowdsaleClosed);
823       require(now>steps[0].timestamp);
824       /* Update the step based on the current time. */
825       if (now > steps[1].timestamp && currentStep < 1){
826         currentStep = 1;
827         emit NextStep(currentStep);
828       }
829       if (now > steps[2].timestamp && currentStep < 2){
830         currentStep = 2;
831         emit NextStep(currentStep);
832       }
833       if (now > steps[3].timestamp && currentStep < 3){
834         currentStep = 3;
835         emit NextStep(currentStep);
836       }
837       /* Step memory step = steps[currentStep]; */
838 
839       require(msg.value >= steps[currentStep].minInvestEth);
840       require(totalTokensSold < totalTokensForSale);
841 
842       uint sum = msg.value;
843       uint amount = sum.div(steps[currentStep].priceTokenWei).mul(1 ether);
844       uint retSum = 0;
845 
846       /* Calculate excess Ether */
847       if(totalTokensSold.add(amount) > totalTokensForSale) {
848           uint retAmount = totalTokensSold.add(amount).sub(totalTokensForSale);
849           retSum = retAmount.mul(steps[currentStep].priceTokenWei).div(1 ether);
850           amount = amount.sub(retAmount);
851           sum = sum.sub(retSum);
852       }
853 
854       /* Record purchase info */
855       totalTokensSold = totalTokensSold.add(amount);
856       totalCollectedWei = totalCollectedWei.add(sum);
857       steps[currentStep].tokensSold = steps[currentStep].tokensSold.add(amount);
858       steps[currentStep].collectedWei = steps[currentStep].collectedWei.add(sum);
859 
860       /* Mint and Send AKC */
861       /* token.mint(sender, amount); */
862       token.transfer(sender, amount);
863 
864       /* Return the excess Ether */
865       if(retSum > 0) {
866           sender.transfer(retSum);
867       }
868 
869       beneficiary.transfer(address(this).balance);
870       emit Purchase(sender, amount, sum);
871   }
872 
873   /**
874   * @dev close crowdsale.
875   */
876   function closeCrowdsale() onlyOwner public {
877       require(!crowdsaleClosed);
878       /* Transfer the Ether from the contract to the beneficiary's address.*/
879       beneficiary.transfer(address(this).balance);
880       /* Transfer the AKC from the contract to the beneficiary's address.*/
881       token.transfer(beneficiary, token.balanceOf(address(this)));
882       crowdsaleClosed = true;
883       emit CrowdsaleClose();
884   }
885 }