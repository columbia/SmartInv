1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns(uint256);
10     
11     function balanceOf(address who) public view returns(uint256);
12     
13     function transfer(address to, uint256 value) public returns(bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title Basic token
19  * @dev Basic version of StandardToken, with no allowances.
20  */
21 contract BasicToken is ERC20Basic {
22     using SafeMath for uint256;
23     
24     mapping(address => uint256) balances;
25     
26     uint256 totalSupply_;
27     
28     /**
29      * @dev total number of tokens in existence
30      */
31     function totalSupply() public view returns(uint256) {
32         return totalSupply_;
33     }
34     
35     /**
36      * @dev transfer token for a specified address
37      * @param _to The address to transfer to.
38      * @param _value The amount to be transferred.
39      */
40     function transfer(address _to, uint256 _value) public returns(bool) {
41         require(_to != address(0));
42         require(_value <= balances[msg.sender]);
43         
44         // SafeMath.sub will throw if there is not enough balance.
45         balances[msg.sender] = balances[msg.sender].sub(_value);
46         balances[_to] = balances[_to].add(_value);
47         Transfer(msg.sender, _to, _value);
48         return true;
49     }
50     
51     /**
52      * @dev Gets the balance of the specified address.
53      * @param _owner The address to query the the balance of.
54      * @return An uint256 representing the amount owned by the passed address.
55      */
56     function balanceOf(address _owner) public view returns(uint256 balance) {
57         return balances[_owner];
58     }
59     
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67     function allowance(address owner, address spender) public view returns(uint256);
68     
69     function transferFrom(address from, address to, uint256 value) public returns(bool);
70     
71     function approve(address spender, uint256 value) public returns(bool);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 /**
76  * @title Standard ERC20 token
77  *
78  * @dev Implementation of the basic standard token.
79  * @dev https://github.com/ethereum/EIPs/issues/20
80  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
81  */
82 contract StandardToken is ERC20, BasicToken {
83     
84     mapping(address => mapping(address => uint256)) internal allowed;
85     
86     
87     /**
88      * @dev Transfer tokens from one address to another
89      * @param _from address The address which you want to send tokens from
90      * @param _to address The address which you want to transfer to
91      * @param _value uint256 the amount of tokens to be transferred
92      */
93     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
94         require(_to != address(0));
95         require(_value <= balances[_from]);
96         require(_value <= allowed[_from][msg.sender]);
97         
98         balances[_from] = balances[_from].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101         Transfer(_from, _to, _value);
102         return true;
103     }
104     
105     /**
106      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
107      *
108      * Beware that changing an allowance with this method brings the risk that someone may use both the old
109      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
110      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
111      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
112      * @param _spender The address which will spend the funds.
113      * @param _value The amount of tokens to be spent.
114      */
115     function approve(address _spender, uint256 _value) public returns(bool) {
116         allowed[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120     
121     /**
122      * @dev Function to check the amount of tokens that an owner allowed to a spender.
123      * @param _owner address The address which owns the funds.
124      * @param _spender address The address which will spend the funds.
125      * @return A uint256 specifying the amount of tokens still available for the spender.
126      */
127     function allowance(address _owner, address _spender) public view returns(uint256) {
128         return allowed[_owner][_spender];
129     }
130     
131     /**
132      * @dev Increase the amount of tokens that an owner allowed to a spender.
133      *
134      * approve should be called when allowed[_spender] == 0. To increment
135      * allowed value is better to use this function to avoid 2 calls (and wait until
136      * the first transaction is mined)
137      * From MonolithDAO Token.sol
138      * @param _spender The address which will spend the funds.
139      * @param _addedValue The amount of tokens to increase the allowance by.
140      */
141     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
142         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
143         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144         return true;
145     }
146     
147     /**
148      * @dev Decrease the amount of tokens that an owner allowed to a spender.
149      *
150      * approve should be called when allowed[_spender] == 0. To decrement
151      * allowed value is better to use this function to avoid 2 calls (and wait until
152      * the first transaction is mined)
153      * From MonolithDAO Token.sol
154      * @param _spender The address which will spend the funds.
155      * @param _subtractedValue The amount of tokens to decrease the allowance by.
156      */
157     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
158         uint oldValue = allowed[msg.sender][_spender];
159         if (_subtractedValue > oldValue) {
160             allowed[msg.sender][_spender] = 0;
161         } else {
162             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
163         }
164         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167     
168 }
169 
170 /**
171  * @title Ownable
172  * @dev The Ownable contract has an owner address, and provides basic authorization control
173  * functions, this simplifies the implementation of "user permissions".
174  */
175 contract Ownable {
176     address public owner;
177     
178     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
179     
180     /**
181      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
182      * account.
183      */
184     function Ownable() public {
185         owner = msg.sender;
186     }
187     
188     /**
189      * @dev Throws if called by any account other than the owner.
190      */
191     modifier onlyOwner() {
192         require(msg.sender == owner);
193         _;
194     }
195     
196     /**
197      * @dev Allows the current owner to transfer control of the contract to a newOwner.
198      * @param newOwner The address to transfer ownership to.
199      */
200     function transferOwnership(address newOwner) public onlyOwner {
201         require(newOwner != address(0));
202         OwnershipTransferred(owner, newOwner);
203         owner = newOwner;
204     }
205     
206 }
207 /**
208  * @title Pausable
209  * @dev Base contract which allows children to implement an emergency stop mechanism.
210  */
211 contract Pausable is Ownable {
212     event Pause();
213     event Unpause();
214     
215     bool public paused = false;
216     
217     /**
218      * @dev Modifier to make a function callable only when the contract is not paused.
219      */
220     modifier whenNotPaused() {
221         require(!paused);
222         _;
223     }
224     
225     /**
226      * @dev Modifier to make a function callable only when the contract is paused.
227      */
228     modifier whenPaused() {
229         require(paused);
230         _;
231     }
232     
233     /**
234      * @dev called by the owner to pause, triggers stopped state
235      */
236     function pause() onlyOwner whenNotPaused public {
237         paused = true;
238         Pause();
239     }
240     
241     /**
242      * @dev called by the owner to unpause, returns to normal state
243      */
244     function unpause() onlyOwner whenPaused public {
245         paused = false;
246         Unpause();
247     }
248 }
249 
250 /**
251  * @title Mintable token
252  * @dev Simple ERC20 Token example, with mintable token creation
253  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
254  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
255  */
256 contract MintableToken is StandardToken, Ownable {
257     event Mint(address indexed to, uint256 amount);
258     event MintFinished();
259     
260     bool public mintingFinished = false;
261     
262     modifier canMint() {
263         require(!mintingFinished);
264         _;
265     }
266     
267     /**
268      * @dev Function to mint tokens
269      * @param _to The address that will receive the minted tokens.
270      * @param _amount The amount of tokens to mint.
271      * @return A boolean that indicates if the operation was successful.
272      */
273     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
274         totalSupply_ = totalSupply_.add(_amount);
275         balances[_to] = balances[_to].add(_amount);
276         Mint(_to, _amount);
277         Transfer(address(0), _to, _amount);
278         return true;
279     }
280     
281     /**
282      * @dev Function to stop minting new tokens.
283      * @return True if the operation was successful.
284      */
285     function finishMinting() onlyOwner canMint public returns(bool) {
286         mintingFinished = true;
287         MintFinished();
288         return true;
289     }
290 }
291 
292 /**
293  * @title Pausable token
294  * @dev StandardToken modified with pausable transfers.
295  **/
296 contract PausableToken is StandardToken, Pausable {
297     
298     function transfer(address _to, uint256 _value) public whenNotPaused returns(bool) {
299         return super.transfer(_to, _value);
300     }
301     
302     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool) {
303         return super.transferFrom(_from, _to, _value);
304     }
305     
306     function approve(address _spender, uint256 _value) public whenNotPaused returns(bool) {
307         return super.approve(_spender, _value);
308     }
309     
310     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns(bool success) {
311         return super.increaseApproval(_spender, _addedValue);
312     }
313     
314     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns(bool success) {
315         return super.decreaseApproval(_spender, _subtractedValue);
316     }
317 }
318 
319 /**
320  * @title SafeERC20
321  * @dev Wrappers around ERC20 operations that throw on failure.
322  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
323  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
324  */
325 library SafeERC20 {
326     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
327         assert(token.transfer(to, value));
328     }
329     
330     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
331         assert(token.transferFrom(from, to, value));
332     }
333     
334     function safeApprove(ERC20 token, address spender, uint256 value) internal {
335         assert(token.approve(spender, value));
336     }
337 }
338 
339 /**
340  * @title MavinToken
341  * @dev ERC20 mintable token
342  * The token will be minted by the crowdsale contract only
343  */
344 contract MavinToken is MintableToken, PausableToken {
345     
346     string public constant name = "Mavin Token";
347     string public constant symbol = "MVN";
348     uint8 public constant decimals = 18;
349     address public creator;
350     
351     function MavinToken()
352     public
353     Ownable()
354     MintableToken()
355     PausableToken() {
356         creator = msg.sender;
357         paused = true;
358     }
359     
360     function finalize()
361     public
362     onlyOwner {
363         finishMinting(); //this can't be reactivated
364         unpause();
365     }
366     
367     
368     function ownershipToCreator()
369     public {
370         require(creator == msg.sender);
371         owner = msg.sender;
372     }
373 }
374 
375 /**
376  * @author OpenZeppelin
377  * @title SafeMath
378  * @dev Math operations with safety checks that throw on error
379  */
380 library SafeMath {
381     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
382         uint256 c = a * b;
383         assert(a == 0 || c / a == b);
384         return c;
385     }
386     
387     function div(uint256 a, uint256 b) internal pure returns(uint256) {
388         // assert(b > 0); // Solidity automatically throws when dividing by 0
389         uint256 c = a / b;
390         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
391         return c;
392     }
393     
394     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
395         assert(b <= a);
396         return a - b;
397     }
398     
399     function add(uint256 a, uint256 b) internal pure returns(uint256) {
400         uint256 c = a + b;
401         assert(c >= a);
402         return c;
403     }
404 }
405 
406 
407 library Referral {
408     
409     /**
410      * @dev referral tree
411      */
412     event LogRef(address member, address referrer);
413     
414     struct Node {
415         address referrer;
416         bool valid;
417     }
418     
419     /**
420      * @dev tree is a collection of nodes
421      */
422     struct Tree {
423         mapping(address => Referral.Node) nodes;
424     }
425     
426     function addMember(
427                        Tree storage self,
428                        address _member,
429                        address _referrer
430                        
431                        )
432     internal
433     returns(bool success) {
434         Node memory memberNode;
435         memberNode.referrer = _referrer;
436         memberNode.valid = true;
437         self.nodes[_member] = memberNode;
438         LogRef(_member, _referrer);
439         return true;
440     }
441 }
442 
443 
444 contract AffiliateTreeStore is Ownable {
445     using SafeMath for uint256;
446     using Referral for Referral.Tree;
447     
448     address public creator;
449     
450     Referral.Tree affiliateTree;
451     
452     function AffiliateTreeStore()
453     public {
454         creator = msg.sender;
455     }
456     
457     function ownershipToCreator()
458     public {
459         require(creator == msg.sender);
460         owner = msg.sender;
461     }
462     
463     function getNode(
464                      address _node
465                      )
466     public
467     view
468     returns(address referrer) {
469         Referral.Node memory n = affiliateTree.nodes[_node];
470         if (n.valid == true) {
471             return _node;
472         }
473         return 0;
474     }
475     
476     function getReferrer(
477                          address _node
478                          )
479     public
480     view
481     returns(address referrer) {
482         Referral.Node memory n = affiliateTree.nodes[_node];
483         if (n.valid == true) {
484             return n.referrer;
485         }
486         return 0;
487     }
488     
489     function addMember(
490                        address _member,
491                        address _referrer
492                        )
493     
494     public
495     onlyOwner
496     returns(bool success) {
497         return affiliateTree.addMember(_member, _referrer);
498     }
499     
500     
501     // Fallback Function only ETH with no functionCall
502     function() public {
503         revert();
504     }
505     
506 }
507 /**
508  * @title TokenVesting
509  * @dev A token holder contract that can release its token balance gradually like a
510  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
511  * owner.
512  */
513 contract TokenVesting is Ownable {
514     using SafeMath for uint256;
515     using SafeERC20 for ERC20Basic;
516     
517     event Released(uint256 amount);
518     event Revoked();
519     
520     // beneficiary of tokens after they are released
521     address public beneficiary;
522     
523     uint256 public cliff;
524     uint256 public start;
525     uint256 public duration;
526     
527     bool public revocable;
528     
529     mapping(address => uint256) public released;
530     mapping(address => bool) public revoked;
531     
532     /**
533      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
534      * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
535      * of the balance will have vested.
536      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
537      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
538      * @param _duration duration in seconds of the period in which the tokens will vest
539      * @param _revocable whether the vesting is revocable or not
540      */
541     function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
542         require(_beneficiary != address(0));
543         require(_cliff <= _duration);
544         
545         beneficiary = _beneficiary;
546         revocable = _revocable;
547         duration = _duration;
548         cliff = _start.add(_cliff);
549         start = _start;
550     }
551     
552     /**
553      * @notice Transfers vested tokens to beneficiary.
554      * @param token ERC20 token which is being vested
555      */
556     function release(ERC20Basic token) public {
557         uint256 unreleased = releasableAmount(token);
558         
559         require(unreleased > 0);
560         
561         released[token] = released[token].add(unreleased);
562         
563         token.safeTransfer(beneficiary, unreleased);
564         
565         Released(unreleased);
566     }
567     
568     /**
569      * @notice Allows the owner to revoke the vesting. Tokens already vested
570      * remain in the contract, the rest are returned to the owner.
571      * @param token ERC20 token which is being vested
572      */
573     function revoke(ERC20Basic token) public onlyOwner {
574         require(revocable);
575         require(!revoked[token]);
576         
577         uint256 balance = token.balanceOf(this);
578         
579         uint256 unreleased = releasableAmount(token);
580         uint256 refund = balance.sub(unreleased);
581         
582         revoked[token] = true;
583         
584         token.safeTransfer(owner, refund);
585         
586         Revoked();
587     }
588     
589     /**
590      * @dev Calculates the amount that has already vested but hasn't been released yet.
591      * @param token ERC20 token which is being vested
592      */
593     function releasableAmount(ERC20Basic token) public view returns(uint256) {
594         return vestedAmount(token).sub(released[token]);
595     }
596     
597     /**
598      * @dev Calculates the amount that has already vested.
599      * @param token ERC20 token which is being vested
600      */
601     function vestedAmount(ERC20Basic token) public view returns(uint256) {
602         uint256 currentBalance = token.balanceOf(this);
603         uint256 totalBalance = currentBalance.add(released[token]);
604         
605         if (now < cliff) {
606             return 0;
607         } else if (now >= start.add(duration) || revoked[token]) {
608             return totalBalance;
609         } else {
610             return totalBalance.mul(now.sub(start)).div(duration);
611         }
612     }
613 }
614 
615 
616 contract AffiliateManager is Pausable {
617     using SafeMath for uint256;
618     
619     AffiliateTreeStore public affiliateTree; // treeStorage
620     
621     // The token being sold
622     MavinToken public token;
623     // endTime
624     uint256 public endTime;
625     // hardcap
626     uint256 public cap;
627     // address where funds are collected
628     address public vault;
629     // how many token units a buyer gets per eth
630     uint256 public mvnpereth;
631     // amount of raised money in wei
632     uint256 public weiRaised;
633     // min contribution amount
634     uint256 public minAmountWei;
635     // creator
636     address creator;
637     
638     
639     function AffiliateManager(
640                               address _token,
641                               address _treestore
642                               )
643     public {
644         creator = msg.sender;
645         token = MavinToken(_token);
646         endTime = 1536969600; // Sat Sep 15 01:00:00 2018 GMT+1
647         vault = 0xD0b40D3bfd8DFa6ecC0b357555039C3ee1C11202;
648         mvnpereth = 100;
649         
650         minAmountWei = 0.01 ether;
651         cap = 32000 ether;
652         
653         affiliateTree = AffiliateTreeStore(_treestore);
654     }
655     
656     /// Log buyTokens
657     event LogBuyTokens(address owner, uint256 tokens, uint256 tokenprice);
658     /// Log LogId
659     event LogId(address owner, uint48 id);
660     
661     modifier onlyNonZeroAddress(address _a) {
662         require(_a != address(0));
663         _;
664     }
665     
666     modifier onlyDiffAdr(address _referrer, address _sender) {
667         require(_referrer != _sender);
668         _;
669     }
670     
671     function initAffiliate() public onlyOwner returns(bool) {
672         //create first 2 root nodes
673         bool success1 = affiliateTree.addMember(vault, 0); //root
674         bool success2 = affiliateTree.addMember(msg.sender, vault); //root+1
675         return success1 && success2;
676     }
677     
678     
679     // execute after all crowdsale tokens are minted
680     function finalizeCrowdsale() public onlyOwner returns(bool) {
681         
682         pause();
683         
684         uint256 totalSupply = token.totalSupply();
685         
686         // 6 month cliff, 12 month total
687         TokenVesting team = new TokenVesting(vault, now, 24 weeks, 1 years, false);
688         uint256 teamTokens = totalSupply.div(60).mul(16);
689         token.mint(team, teamTokens);
690         
691         uint256 reserveTokens = totalSupply.div(60).mul(18);
692         token.mint(vault, reserveTokens);
693         
694         uint256 advisoryTokens = totalSupply.div(60).mul(6);
695         token.mint(vault, advisoryTokens);
696         
697         token.transferOwnership(creator);
698     }
699     
700     function validPurchase() internal constant returns(bool) {
701         bool withinCap = weiRaised.add(msg.value) <= cap;
702         bool withinTime = endTime > now;
703         bool withinMinAmount = msg.value >= minAmountWei;
704         return withinCap && withinTime && withinMinAmount;
705     }
706     
707     function presaleMint(
708                          address _beneficiary,
709                          uint256 _amountmvn,
710                          uint256 _mvnpereth
711                          
712                          )
713     public
714     onlyOwner
715     returns(bool) {
716         uint256 _weiAmount = _amountmvn.div(_mvnpereth);
717         require(_beneficiary != address(0));
718         token.mint(_beneficiary, _amountmvn);
719         // update state
720         weiRaised = weiRaised.add(_weiAmount);
721         
722         LogBuyTokens(_beneficiary, _amountmvn, _mvnpereth);
723         return true;
724     }
725     
726     function joinManual(
727                         address _referrer,
728                         uint48 _id
729                         )
730     public
731     payable
732     whenNotPaused
733     onlyDiffAdr(_referrer, msg.sender) // prevent selfreferal
734     onlyDiffAdr(_referrer, this) // prevent reentrancy
735     returns(bool) {
736         LogId(msg.sender, _id);
737         return join(_referrer);
738     }
739     
740     
741     function join(
742                   address _referrer
743                   )
744     public
745     payable
746     whenNotPaused
747     onlyDiffAdr(_referrer, msg.sender) // prevent selfreferal
748     onlyDiffAdr(_referrer, this) // prevent reentrancy
749     returns(bool success)
750     
751     {
752         uint256 weiAmount = msg.value;
753         require(_referrer != vault);
754         require(validPurchase()); //respect min amount / cap / date
755         
756         //get existing sender node
757         address senderNode = affiliateTree.getNode(msg.sender);
758         
759         // if senderNode already exists use same referrer
760         if (senderNode != address(0)) {
761             _referrer =  affiliateTree.getReferrer(msg.sender);
762         }
763         
764         //get referrer
765         address referrerNode = affiliateTree.getNode(_referrer);
766         //referrer must exist
767         require(referrerNode != address(0));
768         
769         //get referrer of referrer
770         address topNode = affiliateTree.getReferrer(_referrer);
771         //referrer of referrer must exist
772         require(topNode != address(0));
773         require(topNode != msg.sender); //selfreferal
774         
775         
776         // Add sender to the tree
777         if (senderNode == address(0)) {
778             affiliateTree.addMember(msg.sender, _referrer);
779         }
780         
781         success = buyTokens(msg.sender, weiAmount);
782         
783         uint256 parentAmount = 0;
784         uint256 rootAmount = 0;
785         
786         //p1
787         parentAmount = weiAmount.div(100).mul(5); //5% commision for p1
788         referrerNode.transfer(parentAmount);
789         buyTokens(referrerNode, parentAmount);
790         
791         //p2
792         rootAmount = weiAmount.div(100).mul(3); //3% commision for p2
793         buyTokens(topNode, rootAmount);
794         topNode.transfer(rootAmount);
795         
796         vault.transfer(weiAmount.sub(parentAmount).sub(rootAmount)); //rest goes to vault
797         
798         return success;
799     }
800     
801     function buyTokens(
802                        address _beneficiary,
803                        uint256 _weiAmount
804                        )
805     internal
806     returns(bool success) {
807         require(_beneficiary != address(0));
808         uint256 tokens = 0;
809         
810         tokens = _weiAmount.mul(mvnpereth);
811         
812         // update state
813         weiRaised = weiRaised.add(_weiAmount);
814         success = token.mint(_beneficiary, tokens);
815         
816         LogBuyTokens(_beneficiary, tokens, mvnpereth);
817         return success;
818     }
819     
820     function updateMVNRate(uint256 _value) onlyOwner public returns(bool success) {
821         mvnpereth = _value;
822         return true;
823     }
824     
825     function updateMinAmountWei(uint256 _value) onlyOwner public returns(bool success) {
826         minAmountWei = _value;
827         return true;
828     }
829     
830     function balanceOf(address _owner) public constant returns(uint256 balance) {
831         return token.balanceOf(_owner);
832     }
833     
834     // Fallback Function only ETH with no functionCall
835     function() public {
836         revert();
837     }
838     
839 }