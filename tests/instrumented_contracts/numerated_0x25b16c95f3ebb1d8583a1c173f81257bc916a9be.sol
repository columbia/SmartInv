1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45      * account.
46      */
47     function Ownable() {
48         owner = msg.sender;
49     }
50 
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a newOwner.
63      * @param newOwner The address to transfer ownership to.
64      */
65     function transferOwnership(address newOwner) onlyOwner public {
66         require(newOwner != address(0));
67         OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69     }
70 
71 }
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79     uint256 public totalSupply;
80     function balanceOf(address who) constant returns (uint256);
81     function transfer(address to, uint256 value) returns (bool);
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) constant returns (uint256);
92     function transferFrom(address from, address to, uint256 value) returns (bool);
93     function approve(address spender, uint256 value) returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103     using SafeMath for uint256;
104 
105     mapping(address => uint256) balances;
106 
107     /**
108     * @dev transfer token for a specified address
109     * @param _to The address to transfer to.
110     * @param _value The amount to be transferred.
111     */
112     function transfer(address _to, uint256 _value) returns (bool) {
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         Transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     /**
120     * @dev Gets the balance of the specified address.
121     * @param _owner The address to query the the balance of.
122     * @return An uint256 representing the amount owned by the passed address.
123     */
124     function balanceOf(address _owner) constant returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128 }
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139     mapping (address => mapping (address => uint256)) internal allowed;
140 
141 
142     /**
143      * @dev Transfer tokens from one address to another
144      * @param _from address The address which you want to send tokens from
145      * @param _to address The address which you want to transfer to
146      * @param _value uint256 the amount of tokens to be transferred
147      */
148     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149         require(_to != address(0));
150         require(_value <= balances[_from]);
151         require(_value <= allowed[_from][msg.sender]);
152 
153         balances[_from] = balances[_from].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156         Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     /**
161      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162      *
163      * Beware that changing an allowance with this method brings the risk that someone may use both the old
164      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      * @param _spender The address which will spend the funds.
168      * @param _value The amount of tokens to be spent.
169      */
170     function approve(address _spender, uint256 _value) public returns (bool) {
171         allowed[msg.sender][_spender] = _value;
172         Approval(msg.sender, _spender, _value);
173         return true;
174     }
175 
176     /**
177      * @dev Function to check the amount of tokens that an owner allowed to a spender.
178      * @param _owner address The address which owns the funds.
179      * @param _spender address The address which will spend the funds.
180      * @return A uint256 specifying the amount of tokens still available for the spender.
181      */
182     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
183         return allowed[_owner][_spender];
184     }
185 
186     /**
187      * approve should be called when allowed[_spender] == 0. To increment
188      * allowed value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      */
192     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
193         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195         return true;
196     }
197 
198     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
199         uint oldValue = allowed[msg.sender][_spender];
200         if (_subtractedValue > oldValue) {
201             allowed[msg.sender][_spender] = 0;
202         } else {
203             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204         }
205         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206         return true;
207     }
208 
209 }
210 
211 /**
212  * @title Pausable
213  * @dev Base contract which allows children to implement an emergency stop mechanism.
214  */
215 contract Pausable is Ownable {
216     event Pause();
217     event Unpause();
218 
219     bool public paused = false;
220 
221 
222     /**
223      * @dev Modifier to make a function callable only when the contract is not paused.
224      */
225     modifier whenNotPaused() {
226         require(!paused);
227         _;
228     }
229 
230     /**
231      * @dev Modifier to make a function callable only when the contract is paused.
232      */
233     modifier whenPaused() {
234         require(paused);
235         _;
236     }
237 
238     /**
239      * @dev called by the owner to pause, triggers stopped state
240      */
241     function pause() onlyOwner whenNotPaused public {
242         paused = true;
243         Pause();
244     }
245 
246     /**
247      * @dev called by the owner to unpause, returns to normal state
248      */
249     function unpause() onlyOwner whenPaused public {
250         paused = false;
251         Unpause();
252     }
253 }
254 
255 /**
256  * @title Pausable token
257  *
258  * @dev StandardToken modified with pausable transfers.
259  **/
260 
261 contract PausableToken is StandardToken, Pausable {
262 
263     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
264         return super.transfer(_to, _value);
265     }
266 
267     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
268         return super.transferFrom(_from, _to, _value);
269     }
270 
271     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
272         return super.approve(_spender, _value);
273     }
274 
275     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
276         return super.increaseApproval(_spender, _addedValue);
277     }
278 
279     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
280         return super.decreaseApproval(_spender, _subtractedValue);
281     }
282 }
283 
284 /**
285  * @title Mintable token
286  * @dev Simple ERC20 Token example, with mintable token creation
287  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
288  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
289  */
290 
291 contract MintableToken is StandardToken, Ownable {
292     event Mint(address indexed to, uint256 amount);
293     event MintFinished();
294 
295     bool public mintingFinished = false;
296 
297 
298     modifier canMint() {
299         require(!mintingFinished);
300         _;
301     }
302 
303     /**
304      * @dev Function to mint tokens
305      * @param _to The address that will receive the minted tokens.
306      * @param _amount The amount of tokens to mint.
307      * @return A boolean that indicates if the operation was successful.
308      */
309     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
310         totalSupply = totalSupply.add(_amount);
311         balances[_to] = balances[_to].add(_amount);
312         Mint(_to, _amount);
313         Transfer(0x0, _to, _amount);
314         return true;
315     }
316 
317     /**
318      * @dev Function to stop minting new tokens.
319      * @return True if the operation was successful.
320      */
321     function finishMinting() onlyOwner public returns (bool) {
322         mintingFinished = true;
323         MintFinished();
324         return true;
325     }
326 }
327 
328 /*
329  * Company reserve pool where the tokens will be locked for two years
330  * @title Company token reserve
331  */
332 contract AdviserTimeLock is Ownable{
333 
334     SignalsToken token;
335     uint256 withdrawn;
336     uint start;
337 
338     event TokensWithdrawn(address owner, uint amount);
339 
340     /*
341      * Constructor changing owner to owner multisig & setting time lock
342      * @param address of the Signals Token contract
343      * @param address of the owner multisig
344      */
345     function AdviserTimeLock(address _token, address _owner) public{
346         token = SignalsToken(_token);
347         owner = _owner;
348         start = now;
349     }
350 
351     /*
352      * Only function for periodical tokens withdrawal (with monthly allowance)
353      * @dev Will withdraw the whole allowance;
354      */
355     function withdraw() onlyOwner public {
356         require(now - start >= 25920000);
357         uint toWithdraw = canWithdraw();
358         token.transfer(owner, toWithdraw);
359         withdrawn += toWithdraw;
360         TokensWithdrawn(owner, toWithdraw);
361     }
362 
363     /*
364      * Only function for the tokens withdrawal (with two years time lock)
365      * @dev Based on division down rounding
366      */
367     function canWithdraw() public view returns (uint256) {
368         uint256 sinceStart = now - start;
369         uint256 allowed = (sinceStart/2592000)*504546000000000;
370         uint256 toWithdraw;
371         if (allowed > token.balanceOf(address(this))) {
372             toWithdraw = token.balanceOf(address(this));
373         } else {
374             toWithdraw = allowed - withdrawn;
375         }
376         return toWithdraw;
377     }
378 
379     /*
380      * Function to clean up the state and moved not allocated tokens to custody
381      */
382     function cleanUp() onlyOwner public {
383         require(token.balanceOf(address(this)) == 0);
384         selfdestruct(owner);
385     }
386 }
387 
388 /*
389  * Pre-allocation pool for company advisers
390  * @title Advisory pool
391  */
392 contract AdvisoryPool is Ownable{
393 
394     SignalsToken token;
395 
396     /*
397      * @dev constant addresses of all advisers
398      */
399     address constant ADVISER1 = 0x7915D5A865FE68C63112be5aD3DCA5187EB08f24;
400     address constant ADVISER2 = 0x31cFF39AA68B91fa7C957272A6aA8fB8F7b69Cb0;
401     address constant ADVISER3 = 0x358b3aeec9fae5ab15fe28d2fe6c7c9fda596857;
402     address constant ADVISER4 = 0x1011FC646261eb5d4aB875886f1470d4919d83c8;
403     address constant ADVISER5 = 0xcc04Cd98da89A9172372aEf4B62BEDecd01A7F5a;
404     address constant ADVISER6 = 0xECD791f8E548D46A9711D853Ead7edC685Ca4ee8;
405     address constant ADVISER7 = 0x38B58e5783fd4D077e422B3362E9d6B265484e3f;
406     address constant ADVISER8 = 0x2934205135A129F995AC891C143cCae83ce175c7;
407     address constant ADVISER9 = 0x9F5D00F4A383bAd14DEfA9aee53C5AF2ad9ad32F;
408     address constant ADVISER10 = 0xBE993c982Fc5a0C0360CEbcEf9e4d2727339d96B;
409     address constant ADVISER11 = 0xdf1E2126eB638335eFAb91a834db4c57Cbe18735;
410     address constant ADVISER12 = 0x8A404969Ad1BCD3F566A7796722f535eD9cA22b2;
411     address constant ADVISER13 = 0x066a8aD6fA94AC83e1AFB5Aa7Dc62eD1D2654bB2;
412     address constant ADVISER14 = 0xA1425Fa987d1b724306d93084b93D62F37482c4b;
413     address constant ADVISER15 = 0x4633515904eE5Bc18bEB70277455525e84a51e90;
414     address constant ADVISER16 = 0x230783Afd438313033b07D39E3B9bBDBC7817759;
415     address constant ADVISER17 = 0xe8b9b07c1cca9aE9739Cec3D53004523Ab206CAc;
416     address constant ADVISER18 = 0x0E73f16CfE7F545C0e4bB63A9Eef18De8d7B422d;
417     address constant ADVISER19 = 0x6B4c6B603ca72FE7dde971CF833a58415737826D;
418     address constant ADVISER20 = 0x823D3123254a3F9f9d3759FE3Fd7d15e21a3C5d8;
419     address constant ADVISER21 = 0x0E48bbc496Ae61bb790Fc400D1F1a57520f772Df;
420     address constant ADVISER22 = 0x06Ee8eCc0145CcaCEc829490e3c557f577BE0e85;
421     address constant ADVISER23 = 0xbE56bFF75A1cB085674Cc37a5C8746fF6C43C442;
422     address constant ADVISER24 = 0xb442b5297E4aEf19E489530E69dFef7fae27F4A5;
423     address constant ADVISER25 = 0x50EF1d6a7435C7FB3dB7c204b74EB719b1EE3dab;
424     address constant ADVISER26 = 0x3e9fed606822D5071f8a28d2c8B51E6964160CB2;
425 
426     AdviserTimeLock public tokenLocker23;
427 
428     /*
429      * Constructor changing owner to owner multisig & calling the allocation
430      * @param address of the Signals Token contract
431      * @param address of the owner multisig
432      */
433     function AdvisoryPool(address _token, address _owner) public {
434         owner = _owner;
435         token = SignalsToken(_token);
436     }
437 
438     /*
439      * Allocation function, tokens get allocated from this contract as current token owner
440      * @dev only accessible from the constructor
441      */
442     function initiate() public onlyOwner {
443         require(token.balanceOf(address(this)) == 18500000000000000);
444         tokenLocker23 = new AdviserTimeLock(address(token), ADVISER23);
445 
446         token.transfer(ADVISER1, 380952380000000);
447         token.transfer(ADVISER2, 380952380000000);
448         token.transfer(ADVISER3, 659200000000000);
449         token.transfer(ADVISER4, 95238100000000);
450         token.transfer(ADVISER5, 1850000000000000);
451         token.transfer(ADVISER6, 15384620000000);
452         token.transfer(ADVISER7, 62366450000000);
453         token.transfer(ADVISER8, 116805560000000);
454         token.transfer(ADVISER9, 153846150000000);
455         token.transfer(ADVISER10, 10683760000000);
456         token.transfer(ADVISER11, 114285710000000);
457         token.transfer(ADVISER12, 576923080000000);
458         token.transfer(ADVISER13, 76190480000000);
459         token.transfer(ADVISER14, 133547010000000);
460         token.transfer(ADVISER15, 96153850000000);
461         token.transfer(ADVISER16, 462500000000000);
462         token.transfer(ADVISER17, 462500000000000);
463         token.transfer(ADVISER18, 399865380000000);
464         token.transfer(ADVISER19, 20032050000000);
465         token.transfer(ADVISER20, 35559130000000);
466         token.transfer(ADVISER21, 113134000000000);
467         token.transfer(ADVISER22, 113134000000000);
468         token.transfer(address(tokenLocker23), 5550000000000000);
469         token.transfer(ADVISER23, 1850000000000000);
470         token.transfer(ADVISER24, 100000000000000);
471         token.transfer(ADVISER25, 100000000000000);
472         token.transfer(ADVISER26, 2747253000000000);
473 
474     }
475 
476     /*
477      * Clean up function for token loss prevention and cleaning up Ethereum blockchain
478      * @dev call to clean up the contract
479      */
480     function cleanUp() onlyOwner public {
481         uint256 notAllocated = token.balanceOf(address(this));
482         token.transfer(owner, notAllocated);
483         selfdestruct(owner);
484     }
485 }
486 
487 /*
488  * Pre-allocation pool for the community, will be govern by a company multisig
489  * @title Community pool
490  */
491 contract CommunityPool is Ownable{
492 
493     SignalsToken token;
494 
495     event CommunityTokensAllocated(address indexed member, uint amount);
496 
497     /*
498      * Constructor changing owner to owner multisig
499      * @param address of the Signals Token contract
500      * @param address of the owner multisig
501      */
502     function CommunityPool(address _token, address _owner) public{
503         token = SignalsToken(_token);
504         owner = _owner;
505     }
506 
507     /*
508      * Function to alloc tokens to a community member
509      * @param address of community member
510      * @param uint amount units of tokens to be given away
511      */
512     function allocToMember(address member, uint amount) public onlyOwner {
513         require(amount > 0);
514         token.transfer(member, amount);
515         CommunityTokensAllocated(member, amount);
516     }
517 
518     /*
519      * Clean up function
520      * @dev call to clean up the contract after all tokens were assigned
521      */
522     function clean() public onlyOwner {
523         require(token.balanceOf(address(this)) == 0);
524         selfdestruct(owner);
525     }
526 }
527 
528 /*
529  * Company reserve pool where the tokens will be locked for two years
530  * @title Company token reserve
531  */
532 contract CompanyReserve is Ownable{
533 
534     SignalsToken token;
535     uint256 withdrawn;
536     uint start;
537 
538     /*
539      * Constructor changing owner to owner multisig & setting time lock
540      * @param address of the Signals Token contract
541      * @param address of the owner multisig
542      */
543     function CompanyReserve(address _token, address _owner) public {
544         token = SignalsToken(_token);
545         owner = _owner;
546         start = now;
547     }
548 
549     event TokensWithdrawn(address owner, uint amount);
550 
551     /*
552      * Only function for the tokens withdrawal (3% anytime, 5% after one year, 10% after two year)
553      * @dev Will withdraw the whole allowance;
554      */
555     function withdraw() onlyOwner public {
556         require(now - start >= 25920000);
557         uint256 toWithdraw = canWithdraw();
558         withdrawn += toWithdraw;
559         token.transfer(owner, toWithdraw);
560         TokensWithdrawn(owner, toWithdraw);
561     }
562 
563     /*
564      * Checker function to find out how many tokens can be withdrawn.
565      * note: percentage of the token.totalSupply
566      * @dev Based on division down rounding
567      */
568     function canWithdraw() public view returns (uint256) {
569         uint256 sinceStart = now - start;
570         uint256 allowed;
571 
572         if (sinceStart >= 0) {
573             allowed = 555000000000000;
574         } else if (sinceStart >= 31536000) { // one year difference
575             allowed = 1480000000000000;
576         } else if (sinceStart >= 63072000) { // two years difference
577             allowed = 3330000000000000;
578         } else {
579             return 0;
580         }
581         return allowed - withdrawn;
582     }
583 
584     /*
585      * Function to clean up the state and moved not allocated tokens to custody
586      */
587     function cleanUp() onlyOwner public {
588         require(token.balanceOf(address(this)) == 0);
589         selfdestruct(owner);
590     }
591 }
592 
593 
594 /**
595  * @title Signals token
596  * @dev Mintable token created for Signals.Network
597  */
598 contract PresaleToken is PausableToken, MintableToken {
599 
600     // Standard token variables
601     string constant public name = "SGNPresaleToken";
602     string constant public symbol = "SGN";
603     uint8 constant public decimals = 9;
604 
605     event TokensBurned(address initiatior, address indexed _partner, uint256 _tokens);
606 
607     /*
608      * Constructor which pauses the token at the time of creation
609      */
610     function PresaleToken() public {
611         pause();
612     }
613     /*
614     * @dev Token burn function to be called at the time of token swap
615     * @param _partner address to use for token balance buring
616     * @param _tokens uint256 amount of tokens to burn
617     */
618     function burnTokens(address _partner, uint256 _tokens) public onlyOwner {
619         require(balances[_partner] >= _tokens);
620 
621         balances[_partner] -= _tokens;
622         totalSupply -= _tokens;
623         TokensBurned(msg.sender, _partner, _tokens);
624     }
625 }
626 
627 
628 /**
629  * @title Signals token
630  * @dev Mintable token created for Signals.Network
631  */
632 contract SignalsToken is PausableToken, MintableToken {
633 
634     // Standard token variables
635     string constant public name = "Signals Network Token";
636     string constant public symbol = "SGN";
637     uint8 constant public decimals = 9;
638 
639 }
640 
641 contract PrivateRegister is Ownable {
642 
643     struct contribution {
644         bool approved;
645         uint8 extra;
646     }
647 
648     mapping (address => contribution) verified;
649 
650     event ApprovedInvestor(address indexed investor);
651     event BonusesRegistered(address indexed investor, uint8 extra);
652 
653     /*
654      * Approve function to adjust allowance to investment of each individual investor
655      * @param _investor address sets the beneficiary for later use
656      * @param _referral address to pay a commission in token to
657      * @param _commission uint8 expressed as a number between 0 and 5
658     */
659     function approve(address _investor, uint8 _extra) onlyOwner public{
660         require(!isContract(_investor));
661         verified[_investor].approved = true;
662         if (_extra <= 100) {
663             verified[_investor].extra = _extra;
664             BonusesRegistered(_investor, _extra);
665         }
666         ApprovedInvestor(_investor);
667     }
668 
669     /*
670      * Constant call to find out if an investor is registered
671      * @param _investor address to be checked
672      * @return bool is true is _investor was approved
673      */
674     function approved(address _investor) view public returns (bool) {
675         return verified[_investor].approved;
676     }
677 
678     /*
679      * Constant call to find out the referral and commission to bound to an investor
680      * @param _investor address to be checked
681      * @return address of the referral, returns 0x0 if there is none
682      * @return uint8 commission to be paid out on any investment
683      */
684     function getBonuses(address _investor) view public returns (uint8 extra) {
685         return verified[_investor].extra;
686     }
687 
688     /*
689      * Check if address is a contract to prevent contracts from participating the direct sale.
690      * @param addr address to be checked
691      * @return boolean of it is or isn't an contract address
692      * @credits Manuel Aráoz
693      */
694     function isContract(address addr) public view returns (bool) {
695         uint size;
696         assembly { size := extcodesize(addr) }
697         return size > 0;
698     }
699 
700 }
701 
702 contract CrowdsaleRegister is Ownable {
703 
704     struct contribution {
705         bool approved;
706         uint8 commission;
707         uint8 extra;
708     }
709 
710     mapping (address => contribution) verified;
711 
712     event ApprovedInvestor(address indexed investor);
713     event BonusesRegistered(address indexed investor, uint8 commission, uint8 extra);
714 
715     /*
716      * Approve function to adjust allowance to investment of each individual investor
717      * @param _investor address sets the beneficiary for later use
718      * @param _referral address to pay a commission in token to
719      * @param _commission uint8 expressed as a number between 0 and 5
720     */
721     function approve(address _investor, uint8 _commission, uint8 _extra) onlyOwner public{
722         require(!isContract(_investor));
723         verified[_investor].approved = true;
724         if (_commission <= 15 && _extra <= 5) {
725             verified[_investor].commission = _commission;
726             verified[_investor].extra = _extra;
727             BonusesRegistered(_investor, _commission, _extra);
728         }
729         ApprovedInvestor(_investor);
730     }
731 
732     /*
733      * Constant call to find out if an investor is registered
734      * @param _investor address to be checked
735      * @return bool is true is _investor was approved
736      */
737     function approved(address _investor) view public returns (bool) {
738         return verified[_investor].approved;
739     }
740 
741     /*
742      * Constant call to find out the referral and commission to bound to an investor
743      * @param _investor address to be checked
744      * @return address of the referral, returns 0x0 if there is none
745      * @return uint8 commission to be paid out on any investment
746      */
747     function getBonuses(address _investor) view public returns (uint8 commission, uint8 extra) {
748         return (verified[_investor].commission, verified[_investor].extra);
749     }
750 
751     /*
752      * Check if address is a contract to prevent contracts from participating the direct sale.
753      * @param addr address to be checked
754      * @return boolean of it is or isn't an contract address
755      * @credits Manuel Aráoz
756      */
757     function isContract(address addr) public view returns (bool) {
758         uint size;
759         assembly { size := extcodesize(addr) }
760         return size > 0;
761     }
762 
763 }
764 
765 
766 /*
767  *  Token pool for the presale tokens swap
768  *  @title PresalePool
769  *  @dev Requires to transfer ownership of both PresaleToken contracts to this contract
770  */
771 contract PresalePool is Ownable {
772 
773     PresaleToken public PublicPresale;
774     PresaleToken public PartnerPresale;
775     SignalsToken token;
776     CrowdsaleRegister registry;
777 
778     /*
779      * Compensation coefficient based on the difference between the max ETHUSD price during the presale
780      * and price fix for mainsale
781      */
782     uint256 compensation1;
783     uint256 compensation2;
784     // Date after which all tokens left will be transfered to the company reserve
785     uint256 deadLine;
786 
787     event SupporterResolved(address indexed supporter, uint256 burned, uint256 created);
788     event PartnerResolved(address indexed partner, uint256 burned, uint256 created);
789 
790     /*
791      * Constructor changing owner to owner multisig, setting all the contract addresses & compensation rates
792      * @param address of the Signals Token contract
793      * @param address of the KYC registry
794      * @param address of the owner multisig
795      * @param uint rate of the compensation for early investors
796      * @param uint rate of the compensation for partners
797      */
798     function PresalePool(address _token, address _registry, address _owner, uint comp1, uint comp2) public {
799         owner = _owner;
800         PublicPresale = PresaleToken(0x15fEcCA27add3D28C55ff5b01644ae46edF15821);
801         PartnerPresale = PresaleToken(0xa70435D1a3AD4149B0C13371E537a22002Ae530d);
802         token = SignalsToken(_token);
803         registry = CrowdsaleRegister(_registry);
804         compensation1 = comp1;
805         compensation2 = comp2;
806         deadLine = now + 30 days;
807     }
808 
809     /*
810      * Fallback function for simple contract usage, only calls the swap()
811      * @dev left for simpler interaction
812      */
813     function() public {
814         swap();
815     }
816 
817     /*
818      * Function swapping the presale tokens for the Signal tokens regardless on the presale pool
819      * @dev requires having ownership of the two presale contracts
820      * @dev requires the calling party to finish the KYC process fully
821      */
822     function swap() public {
823         require(registry.approved(msg.sender));
824         uint256 oldBalance;
825         uint256 newBalance;
826 
827         if (PublicPresale.balanceOf(msg.sender) > 0) {
828             oldBalance = PublicPresale.balanceOf(msg.sender);
829             newBalance = oldBalance * compensation1 / 100;
830             PublicPresale.burnTokens(msg.sender, oldBalance);
831             token.transfer(msg.sender, newBalance);
832             SupporterResolved(msg.sender, oldBalance, newBalance);
833         }
834 
835         if (PartnerPresale.balanceOf(msg.sender) > 0) {
836             oldBalance = PartnerPresale.balanceOf(msg.sender);
837             newBalance = oldBalance * compensation2 / 100;
838             PartnerPresale.burnTokens(msg.sender, oldBalance);
839             token.transfer(msg.sender, newBalance);
840             PartnerResolved(msg.sender, oldBalance, newBalance);
841         }
842     }
843 
844     /*
845      * Function swapping the presale tokens for the Signal tokens regardless on the presale pool
846      * @dev initiated from Signals (passing the ownership to a oracle to handle a script is recommended)
847      * @dev requires having ownership of the two presale contracts
848      * @dev requires the calling party to finish the KYC process fully
849      */
850     function swapFor(address whom) onlyOwner public returns(bool) {
851         require(registry.approved(whom));
852         uint256 oldBalance;
853         uint256 newBalance;
854 
855         if (PublicPresale.balanceOf(whom) > 0) {
856             oldBalance = PublicPresale.balanceOf(whom);
857             newBalance = oldBalance * compensation1 / 100;
858             PublicPresale.burnTokens(whom, oldBalance);
859             token.transfer(whom, newBalance);
860             SupporterResolved(whom, oldBalance, newBalance);
861         }
862 
863         if (PartnerPresale.balanceOf(whom) > 0) {
864             oldBalance = PartnerPresale.balanceOf(whom);
865             newBalance = oldBalance * compensation2 / 100;
866             PartnerPresale.burnTokens(whom, oldBalance);
867             token.transfer(whom, newBalance);
868             SupporterResolved(whom, oldBalance, newBalance);
869         }
870 
871         return true;
872     }
873 
874     /*
875      * Function to clean up the state and moved not allocated tokens to custody
876      */
877     function clean() onlyOwner public {
878         require(now >= deadLine);
879         uint256 notAllocated = token.balanceOf(address(this));
880         token.transfer(owner, notAllocated);
881         selfdestruct(owner);
882     }
883 }
884 
885 /**
886  * @title Crowdsale
887  * @dev Crowdsale is a base contract for managing a token crowdsale.
888  * Crowdsales have a start and end timestamps, where investors can make
889  * token purchases and the crowdsale will assign them tokens based
890  * on a token per ETH rate. Funds collected are forwarded to a wallet
891  * as they arrive.
892  */
893 contract Crowdsale {
894     using SafeMath for uint256;
895 
896     // The token being sold
897     SignalsToken public token;
898 
899     // address where funds are collected
900     address public wallet;
901 
902     // amount of raised money in wei
903     uint256 public weiRaised;
904 
905     // start/end related 
906     uint256 public startTime;
907     bool public hasEnded;
908 
909     /**
910      * event for token purchase logging
911      * @param purchaser who paid for the tokens
912      * @param beneficiary who got the tokens
913      * @param value weis paid for purchase
914      * @param amount amount of tokens purchased
915      */
916     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
917 
918     function Crowdsale(address _token, address _wallet) public {
919         require(_wallet != 0x0);
920         token = SignalsToken(_token);
921         wallet = _wallet;
922     }
923 
924     // fallback function can be used to buy tokens
925     function () public payable {
926         buyTokens(msg.sender);
927     }
928 
929     // low level token purchase function
930     function buyTokens(address beneficiary) private {}
931 
932     // send ether to the fund collection wallet
933     // override to create custom fund forwarding mechanisms
934     function forwardFunds() internal {
935         wallet.transfer(msg.value);
936     }
937 
938     // @return true if the transaction can buy tokens
939     function validPurchase() internal constant returns (bool) {}
940 
941 }
942 
943 /**
944  * @title FinalizableCrowdsale
945  * @dev Extension of Crowdsale where an owner can do extra work
946  * after finishing.
947  */
948 contract FinalizableCrowdsale is Crowdsale, Ownable {
949     using SafeMath for uint256;
950 
951     bool public isFinalized = false;
952 
953     event Finalized();
954 
955     /**
956      * @dev Must be called after crowdsale ends, to do some extra finalization
957      * work. Calls the contract's finalization function.
958      */
959     function finalize() onlyOwner public {
960         require(!isFinalized);
961         require(hasEnded);
962 
963         finalization();
964         Finalized();
965 
966         isFinalized = true;
967     }
968 
969     /**
970      * @dev Can be overridden to add finalization logic. The overriding function
971      * should call super.finalization() to ensure the chain of finalization is
972      * executed entirely.
973      */
974     function finalization() internal {
975     }
976 }
977 
978 
979 contract SignalsCrowdsale is FinalizableCrowdsale {
980 
981     // Cap & price related values
982     uint256 public constant HARD_CAP = 18000*(10**18);
983     uint256 public toBeRaised = 18000*(10**18);
984     uint256 public constant PRICE = 360000;
985     uint256 public tokensSold;
986     uint256 public constant maxTokens = 185000000*(10**9);
987 
988     // Allocation constants
989     uint constant ADVISORY_SHARE = 18500000*(10**9); //FIXED
990     uint constant BOUNTY_SHARE = 3700000*(10**9); // FIXED
991     uint constant COMMUNITY_SHARE = 37000000*(10**9); //FIXED
992     uint constant COMPANY_SHARE = 33300000*(10**9); //FIXED
993     uint constant PRESALE_SHARE = 7856217611546440; // FIXED;
994 
995     // Address pointers
996     address constant ADVISORS = 0x98280b2FD517a57a0B8B01b674457Eb7C6efa842; // TODO: change
997     address constant BOUNTY = 0x8726D7ac344A0BaBFd16394504e1cb978c70479A; // TODO: change
998     address constant COMMUNITY = 0x90CDbC88aB47c432Bd47185b9B0FDA1600c22102; // TODO: change
999     address constant COMPANY = 0xC010b2f2364372205055a299B28ef934f090FE92; // TODO: change
1000     address constant PRESALE = 0x7F3a38fa282B16973feDD1E227210Ec020F2481e; // TODO: change
1001     CrowdsaleRegister register;
1002     PrivateRegister register2;
1003 
1004     // Start & End related vars
1005     bool public ready;
1006 
1007     // Events
1008     event SaleWillStart(uint256 time);
1009     event SaleReady();
1010     event SaleEnds(uint256 tokensLeft);
1011 
1012     function SignalsCrowdsale(address _token, address _wallet, address _register, address _register2) public
1013     FinalizableCrowdsale()
1014     Crowdsale(_token, _wallet)
1015     {
1016         register = CrowdsaleRegister(_register);
1017         register2 = PrivateRegister(_register2);
1018     }
1019 
1020 
1021     // @return true if the transaction can buy tokens
1022     function validPurchase() internal constant returns (bool) {
1023         bool started = (startTime <= now);
1024         bool nonZeroPurchase = msg.value != 0;
1025         bool capNotReached = (weiRaised < HARD_CAP);
1026         bool approved = register.approved(msg.sender);
1027         bool approved2 = register2.approved(msg.sender);
1028         return ready && started && !hasEnded && nonZeroPurchase && capNotReached && (approved || approved2);
1029     }
1030 
1031     /*
1032      * Buy in function to be called from the fallback function
1033      * @param beneficiary address
1034      */
1035     function buyTokens(address beneficiary) private {
1036         require(beneficiary != 0x0);
1037         require(validPurchase());
1038 
1039         uint256 weiAmount = msg.value;
1040 
1041         // base discount
1042         uint256 discount = ((toBeRaised*10000)/HARD_CAP)*15;
1043 
1044         // calculate token amount to be created
1045         uint256 tokens;
1046 
1047         // update state
1048         weiRaised = weiRaised.add(weiAmount);
1049         toBeRaised = toBeRaised.sub(weiAmount);
1050 
1051         uint commission;
1052         uint extra;
1053         uint premium;
1054 
1055         if (register.approved(beneficiary)) {
1056             (commission, extra) = register.getBonuses(beneficiary);
1057 
1058             // If extra access granted then give additional %
1059             if (extra > 0) {
1060                 discount += extra*10000;
1061             }
1062             tokens =  howMany(msg.value, discount);
1063 
1064             // If referral was involved, give some percent to the source
1065             if (commission > 0) {
1066                 premium = tokens.mul(commission).div(100);
1067                 token.mint(BOUNTY, premium);
1068             }
1069 
1070         } else {
1071             extra = register2.getBonuses(beneficiary);
1072             if (extra > 0) {
1073                 discount = extra*10000;
1074                 tokens =  howMany(msg.value, discount);
1075             }
1076         }
1077 
1078         token.mint(beneficiary, tokens);
1079         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1080         tokensSold += tokens + premium;
1081         forwardFunds();
1082 
1083         assert(token.totalSupply() <= maxTokens);
1084     }
1085 
1086     /*
1087      * Helper token emission functions
1088      * @param value uint256 of the wei amount that gets invested
1089      * @return uint256 of how many tokens can one get
1090      */
1091     function howMany(uint256 value, uint256 discount) public view returns (uint256){
1092         uint256 actualPrice = PRICE * (1000000 - discount) / 1000000;
1093         return value / actualPrice;
1094     }
1095 
1096     /*
1097      * Function to do preallocations - MANDATORY to continue
1098      * @dev It's separated so it doesn't have to run in constructor
1099      */
1100     function initialize() public onlyOwner {
1101         require(!ready);
1102 
1103         // Pre-allocation to pools
1104         token.mint(ADVISORS,ADVISORY_SHARE);
1105         token.mint(BOUNTY,BOUNTY_SHARE);
1106         token.mint(COMMUNITY,COMMUNITY_SHARE);
1107         token.mint(COMPANY,COMPANY_SHARE);
1108         token.mint(PRESALE,PRESALE_SHARE);
1109 
1110         tokensSold = PRESALE_SHARE;
1111 
1112         ready = true;
1113         SaleReady();
1114     }
1115 
1116     /*
1117      * Function to do set or adjust the startTime - NOT MANDATORY but good for future start
1118      */
1119     function changeStart(uint256 _time) public onlyOwner {
1120         startTime = _time;
1121         SaleWillStart(_time);
1122     }
1123 
1124     /*
1125      * Function end or pause the sale
1126      * @dev It's MANDATORY to finalize()
1127      */
1128     function endSale(bool end) public onlyOwner {
1129         require(startTime <= now);
1130         uint256 tokensLeft = maxTokens - token.totalSupply();
1131         if (tokensLeft > 0) {
1132             token.mint(wallet, tokensLeft);
1133         }
1134         hasEnded = end;
1135         SaleEnds(tokensLeft);
1136     }
1137 
1138     /*
1139      * Adjust finalization to transfer token ownership to the fund holding address for further use
1140      */
1141     function finalization() internal {
1142         token.finishMinting();
1143         token.transferOwnership(wallet);
1144     }
1145 
1146     /*
1147      * Clean up function to get the contract selfdestructed - OPTIONAL
1148      */
1149     function cleanUp() public onlyOwner {
1150         require(isFinalized);
1151         selfdestruct(owner);
1152     }
1153 
1154 }