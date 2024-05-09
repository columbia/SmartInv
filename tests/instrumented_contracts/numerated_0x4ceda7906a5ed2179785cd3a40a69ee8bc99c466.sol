1 pragma solidity >=0.4.10;
2 
3 // from Zeppelin
4 contract SafeMath {
5     function safeMul(uint a, uint b) internal returns (uint) {
6         uint c = a * b;
7         require(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeSub(uint a, uint b) internal returns (uint) {
12         require(b <= a);
13         return a - b;
14     }
15 
16     function safeAdd(uint a, uint b) internal returns (uint) {
17         uint c = a + b;
18         require(c>=a && c>=b);
19         return c;
20     }
21 }
22 
23 contract Owned {
24     address public owner;
25     address newOwner;
26 
27     function Owned() {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function changeOwner(address _newOwner) onlyOwner {
37         newOwner = _newOwner;
38     }
39 
40     function acceptOwnership() {
41         if (msg.sender == newOwner) {
42             owner = newOwner;
43         }
44     }
45 }
46 
47 contract IToken {
48     function transfer(address _to, uint _value) returns (bool);
49     function balanceOf(address owner) returns(uint);
50 }
51 
52 // In case someone accidentally sends token to one of these contracts,
53 // add a way to get them back out.
54 contract TokenReceivable is Owned {
55     function claimTokens(address _token, address _to) onlyOwner returns (bool) {
56         IToken token = IToken(_token);
57         return token.transfer(_to, token.balanceOf(this));
58     }
59 }
60 
61 contract EventDefinitions {
62     event Transfer(address indexed from, address indexed to, uint value);
63     event Approval(address indexed owner, address indexed spender, uint value);
64     event Burn(address indexed from, bytes32 indexed to, uint value);
65     event Claimed(address indexed claimer, uint value);
66 }
67 
68 contract Pausable is Owned {
69     bool public paused;
70 
71     function pause() onlyOwner {
72         paused = true;
73     }
74 
75     function unpause() onlyOwner {
76         paused = false;
77     }
78 
79     modifier notPaused() {
80         require(!paused);
81         _;
82     }
83 }
84 
85 contract Finalizable is Owned {
86     bool public finalized;
87 
88     function finalize() onlyOwner {
89         finalized = true;
90     }
91 
92     modifier notFinalized() {
93         require(!finalized);
94         _;
95     }
96 }
97 
98 contract Ledger is Owned, SafeMath, Finalizable {
99     Controller public controller;
100     mapping(address => uint) public balanceOf;
101     mapping (address => mapping (address => uint)) public allowance;
102     uint public totalSupply;
103     uint public mintingNonce;
104     bool public mintingStopped;
105 
106     /**
107      * Used for updating the contract with proofs. Note that the logic
108      * for guarding against unwanted actions happens in the controller. We only
109      * specify onlyController here.
110      * @notice: not yet used
111      */
112     mapping(uint256 => bytes32) public proofs;
113 
114     /**
115      * If bridge delivers currency back from the other network, it may be that we
116      * want to lock it until the user is able to "claim" it. This mapping would store the
117      * state of the unclaimed currency.
118      * @notice: not yet used
119      */
120     mapping(address => uint256) public locked;
121 
122     /**
123      * As a precautionary measure, we may want to include a structure to store necessary
124      * data should we find that we require additional information.
125      * @notice: not yet used
126      */
127     mapping(bytes32 => bytes32) public metadata;
128 
129     /**
130      * Set by the controller to indicate where the transfers should go to on a burn
131      */
132     address public burnAddress;
133 
134     /**
135      * Mapping allowing us to identify the bridge nodes, in the current setup
136      * manipulation of this mapping is only accessible by the parameter.
137      */
138     mapping(address => bool) public bridgeNodes;
139 
140     // functions below this line are onlyOwner
141 
142     function Ledger() {
143     }
144 
145     function setController(address _controller) onlyOwner notFinalized {
146         controller = Controller(_controller);
147     }
148 
149     /**
150      * @dev         To be called once minting is complete, disables minting.  
151      */
152     function stopMinting() onlyOwner {
153         mintingStopped = true;
154     }
155 
156     /**
157      * @dev         Used to mint a batch of currency at once.
158      * 
159      * @notice      This gives us a maximum of 2^96 tokens per user.
160      * @notice      Expected packed structure is [ADDR(20) | VALUE(12)].
161      *
162      * @param       nonce   The minting nonce, an incorrect nonce is rejected.
163      * @param       bits    An array of packed bytes of address, value mappings.  
164      *
165      */
166     function multiMint(uint nonce, uint256[] bits) onlyOwner {
167         require(!mintingStopped);
168         if (nonce != mintingNonce) return;
169         mintingNonce += 1;
170         uint256 lomask = (1 << 96) - 1;
171         uint created = 0;
172         for (uint i=0; i<bits.length; i++) {
173             address a = address(bits[i]>>96);
174             uint value = bits[i]&lomask;
175             balanceOf[a] = balanceOf[a] + value;
176             controller.ledgerTransfer(0, a, value);
177             created += value;
178         }
179         totalSupply += created;
180     }
181 
182     // functions below this line are onlyController
183 
184     modifier onlyController() {
185         require(msg.sender == address(controller));
186         _;
187     }
188 
189     function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
190         if (balanceOf[_from] < _value) return false;
191 
192         balanceOf[_from] = safeSub(balanceOf[_from], _value);
193         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
194         return true;
195     }
196 
197     function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
198         if (balanceOf[_from] < _value) return false;
199 
200         var allowed = allowance[_from][_spender];
201         if (allowed < _value) return false;
202 
203         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
204         balanceOf[_from] = safeSub(balanceOf[_from], _value);
205         allowance[_from][_spender] = safeSub(allowed, _value);
206         return true;
207     }
208 
209     function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
210         // require user to set to zero before resetting to nonzero
211         if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
212             return false;
213         }
214 
215         allowance[_owner][_spender] = _value;
216         return true;
217     }
218 
219     function increaseApproval (address _owner, address _spender, uint _addedValue) onlyController returns (bool success) {
220         uint oldValue = allowance[_owner][_spender];
221         allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
222         return true;
223     }
224 
225     function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyController returns (bool success) {
226         uint oldValue = allowance[_owner][_spender];
227         if (_subtractedValue > oldValue) {
228             allowance[_owner][_spender] = 0;
229         } else {
230             allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
231         }
232         return true;
233     }
234 
235     function setProof(uint256 _key, bytes32 _proof) onlyController {
236         proofs[_key] = _proof;
237     }
238 
239     function setLocked(address _key, uint256 _value) onlyController {
240         locked[_key] = _value;
241     }
242 
243     function setMetadata(bytes32 _key, bytes32 _value) onlyController {
244         metadata[_key] = _value;
245     }
246 
247     /**
248      * Burn related functionality
249      */
250 
251     /**
252      * @dev        sets the burn address to the new value
253      *
254      * @param      _address  The address
255      *
256      */
257     function setBurnAddress(address _address) onlyController {
258         burnAddress = _address;
259     }
260 
261     function setBridgeNode(address _address, bool enabled) onlyController {
262         bridgeNodes[_address] = enabled;
263     }
264 }
265 
266 contract ControllerEventDefinitions {
267     /**
268      * An internal burn event, emitted by the controller contract
269      * which the bridges could be listening to.
270      */
271     event ControllerBurn(address indexed from, bytes32 indexed to, uint value);
272 }
273 
274 /**
275  * @title Controller for business logic between the ERC20 API and State
276  *
277  * Controller is responsible for the business logic that sits in between
278  * the Ledger (model) and the Token (view). Presently, adherence to this model
279  * is not strict, but we expect future functionality (Burning, Claiming) to adhere
280  * to this model more closely.
281  * 
282  * The controller must be linked to a Token and Ledger to become functional.
283  * 
284  */
285 contract Controller is Owned, Finalizable, ControllerEventDefinitions {
286     Ledger public ledger;
287     Token public token;
288     address public burnAddress;
289 
290     function Controller() {
291     }
292 
293     // functions below this line are onlyOwner
294 
295 
296     function setToken(address _token) onlyOwner {
297         token = Token(_token);
298     }
299 
300     function setLedger(address _ledger) onlyOwner {
301         ledger = Ledger(_ledger);
302     }
303 
304     /**
305      * @dev         Sets the burn address burn values get moved to. Only call
306      *              after token and ledger contracts have been hooked up. Ensures
307      *              that all three values are set atomically.
308      *             
309      * @notice      New Functionality
310      *
311      * @param       _address    desired address
312      *
313      */
314     function setBurnAddress(address _address) onlyOwner {
315         burnAddress = _address;
316         ledger.setBurnAddress(_address);
317         token.setBurnAddress(_address);
318     }
319 
320     modifier onlyToken() {
321         require(msg.sender == address(token));
322         _;
323     }
324 
325     modifier onlyLedger() {
326         require(msg.sender == address(ledger));
327         _;
328     }
329 
330     function totalSupply() constant returns (uint) {
331         return ledger.totalSupply();
332     }
333 
334     function balanceOf(address _a) constant returns (uint) {
335         return ledger.balanceOf(_a);
336     }
337 
338     function allowance(address _owner, address _spender) constant returns (uint) {
339         return ledger.allowance(_owner, _spender);
340     }
341 
342     // functions below this line are onlyLedger
343 
344     // let the ledger send transfer events (the most obvious case
345     // is when we mint directly to the ledger and need the Transfer()
346     // events to appear in the token)
347     function ledgerTransfer(address from, address to, uint val) onlyLedger {
348         token.controllerTransfer(from, to, val);
349     }
350 
351     // functions below this line are onlyToken
352 
353     function transfer(address _from, address _to, uint _value) onlyToken returns (bool success) {
354         return ledger.transfer(_from, _to, _value);
355     }
356 
357     function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken returns (bool success) {
358         return ledger.transferFrom(_spender, _from, _to, _value);
359     }
360 
361     function approve(address _owner, address _spender, uint _value) onlyToken returns (bool success) {
362         return ledger.approve(_owner, _spender, _value);
363     }
364 
365     function increaseApproval (address _owner, address _spender, uint _addedValue) onlyToken returns (bool success) {
366         return ledger.increaseApproval(_owner, _spender, _addedValue);
367     }
368 
369     function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyToken returns (bool success) {
370         return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
371     }
372 
373     /**
374      * End Original Contract
375      * Below is new functionality
376      */
377 
378     /**
379      * @dev        Enables burning on the token contract
380      */
381     function enableBurning() onlyOwner {
382         token.enableBurning();
383     }
384 
385     /**
386      * @dev        Disables burning on the token contract
387      */
388     function disableBurning() onlyOwner {
389         token.disableBurning();
390     }
391 
392     // public functions
393 
394     /**
395      * @dev         
396      *
397      * @param       _from       account the value is burned from
398      * @param       _to         the address receiving the value
399      * @param       _amount     the value amount
400      * 
401      * @return      success     operation successful or not.
402      */ 
403     function burn(address _from, bytes32 _to, uint _amount) onlyToken returns (bool success) {
404         if (ledger.transfer(_from, burnAddress, _amount)) {
405             ControllerBurn(_from, _to, _amount);
406             token.controllerBurn(_from, _to, _amount);
407             return true;
408         }
409         return false;
410     }
411 
412     /**
413      * @dev         Implementation for claim mechanism. Note that this mechanism has not yet
414      *              been implemented. This function is only here for future expansion capabilities.
415      *              Presently, just returns false to indicate failure.
416      *              
417      * @notice      Only one of claimByProof() or claim() will potentially be activated in the future.
418      *              Depending on the functionality required and route selected. 
419      *
420      * @param       _claimer    The individual claiming the tokens (also the recipient of said tokens).
421      * @param       data        The input data required to release the tokens.
422      * @param       success     The proofs associated with the data, to indicate the legitimacy of said data.
423      * @param       number      The block number the proofs and data correspond to.
424      *
425      * @return      success     operation successful or not.
426      * 
427      */
428     function claimByProof(address _claimer, bytes32[] data, bytes32[] proofs, uint256 number)
429         onlyToken
430         returns (bool success) {
431         return false;
432     }
433 
434     /**
435      * @dev         Implementation for an alternative claim mechanism, in which the participant
436      *              is not required to confirm through proofs. Note that this mechanism has not
437      *              yet been implemented.
438      *              
439      * @notice      Only one of claimByProof() or claim() will potentially be activated in the future.
440      *              Depending on the functionality required and route selected.
441      * 
442      * @param       _claimer    The individual claiming the tokens (also the recipient of said tokens).
443      * 
444      * @return      success     operation successful or not.
445      */
446     function claim(address _claimer) onlyToken returns (bool success) {
447         return false;
448     }
449 }
450 
451 contract Token is Finalizable, TokenReceivable, SafeMath, EventDefinitions, Pausable {
452     // Set these appropriately before you deploy
453     string constant public name = "AION";
454     uint8 constant public decimals = 8;
455     string constant public symbol = "AION";
456     Controller public controller;
457     string public motd;
458     event Motd(string message);
459 
460     address public burnAddress; //@ATTENTION: set this to a correct value
461     bool public burnable = false;
462 
463     // functions below this line are onlyOwner
464 
465     // set "message of the day"
466     function setMotd(string _m) onlyOwner {
467         motd = _m;
468         Motd(_m);
469     }
470 
471     function setController(address _c) onlyOwner notFinalized {
472         controller = Controller(_c);
473     }
474 
475     // functions below this line are public
476 
477     function balanceOf(address a) constant returns (uint) {
478         return controller.balanceOf(a);
479     }
480 
481     function totalSupply() constant returns (uint) {
482         return controller.totalSupply();
483     }
484 
485     function allowance(address _owner, address _spender) constant returns (uint) {
486         return controller.allowance(_owner, _spender);
487     }
488 
489     function transfer(address _to, uint _value) notPaused returns (bool success) {
490         if (controller.transfer(msg.sender, _to, _value)) {
491             Transfer(msg.sender, _to, _value);
492             return true;
493         }
494         return false;
495     }
496 
497     function transferFrom(address _from, address _to, uint _value) notPaused returns (bool success) {
498         if (controller.transferFrom(msg.sender, _from, _to, _value)) {
499             Transfer(_from, _to, _value);
500             return true;
501         }
502         return false;
503     }
504 
505     function approve(address _spender, uint _value) notPaused returns (bool success) {
506         // promote safe user behavior
507         if (controller.approve(msg.sender, _spender, _value)) {
508             Approval(msg.sender, _spender, _value);
509             return true;
510         }
511         return false;
512     }
513 
514     function increaseApproval (address _spender, uint _addedValue) notPaused returns (bool success) {
515         if (controller.increaseApproval(msg.sender, _spender, _addedValue)) {
516             uint newval = controller.allowance(msg.sender, _spender);
517             Approval(msg.sender, _spender, newval);
518             return true;
519         }
520         return false;
521     }
522 
523     function decreaseApproval (address _spender, uint _subtractedValue) notPaused returns (bool success) {
524         if (controller.decreaseApproval(msg.sender, _spender, _subtractedValue)) {
525             uint newval = controller.allowance(msg.sender, _spender);
526             Approval(msg.sender, _spender, newval);
527             return true;
528         }
529         return false;
530     }
531 
532     // modifier onlyPayloadSize(uint numwords) {
533     //     assert(msg.data.length >= numwords * 32 + 4);
534     //     _;
535     // }
536 
537     // functions below this line are onlyController
538 
539     modifier onlyController() {
540         assert(msg.sender == address(controller));
541         _;
542     }
543 
544     // In the future, when the controller supports multiple token
545     // heads, allow the controller to reconstitute the transfer and
546     // approval history.
547 
548     function controllerTransfer(address _from, address _to, uint _value) onlyController {
549         Transfer(_from, _to, _value);
550     }
551 
552     function controllerApprove(address _owner, address _spender, uint _value) onlyController {
553         Approval(_owner, _spender, _value);
554     }
555 
556     /**
557      * @dev        Burn event possibly called by the controller on a burn. This is
558      *             the public facing event that anyone can track, the bridges listen
559      *             to an alternative event emitted by the controller.
560      *
561      * @param      _from   address that coins are burned from
562      * @param      _to     address (on other network) that coins are received by
563      * @param      _value  amount of value to be burned
564      *
565      * @return     { description_of_the_return_value }
566      */
567     function controllerBurn(address _from, bytes32 _to, uint256 _value) onlyController {
568         Burn(_from, _to, _value);
569     }
570 
571     function controllerClaim(address _claimer, uint256 _value) onlyController {
572         Claimed(_claimer, _value);
573     }
574 
575     /**
576      * @dev        Sets the burn address to a new value
577      *
578      * @param      _address  The address
579      *
580      */
581     function setBurnAddress(address _address) onlyController {
582         burnAddress = _address;
583     }
584 
585     /**
586      * @dev         Enables burning through burnable bool
587      *
588      */
589     function enableBurning() onlyController {
590         burnable = true;
591     }
592 
593     /**
594      * @dev         Disables burning through burnable bool
595      *
596      */
597     function disableBurning() onlyController {
598         burnable = false;
599     }
600 
601     /**
602      * @dev         Indicates that burning is enabled
603      */
604     modifier burnEnabled() {
605         require(burnable == true);
606         _;
607     }
608 
609     /**
610      * @dev         burn function, changed from original implementation. Public facing API
611      *              indicating who the token holder wants to burn currency to and the amount.
612      *
613      * @param       _amount  The amount
614      *
615      */
616     function burn(bytes32 _to, uint _amount) notPaused burnEnabled returns (bool success) {
617         return controller.burn(msg.sender, _to, _amount);
618     }
619 
620     /**
621      * @dev         claim (quantumReceive) allows the user to "prove" some an ICT to the contract
622      *              thereby thereby releasing the tokens into their account
623      * 
624      */
625     function claimByProof(bytes32[] data, bytes32[] proofs, uint256 number) notPaused burnEnabled returns (bool success) {
626         return controller.claimByProof(msg.sender, data, proofs, number);
627     }
628 
629     /**
630      * @dev         Simplified version of claim, just requires user to call to claim.
631      *              No proof is needed, which version is chosen depends on our bridging model.
632      *
633      * @return      
634      */
635     function claim() notPaused burnEnabled returns (bool success) {
636         return controller.claim(msg.sender);
637     }
638 }