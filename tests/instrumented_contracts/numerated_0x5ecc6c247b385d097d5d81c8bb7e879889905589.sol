1 /* solhint-disable no-simple-event-func-name */
2 
3 pragma solidity 0.4.18;
4 
5 
6 /*
7  * https://github.com/OpenZeppelin/zeppelin-solidity
8  *
9  * The MIT License (MIT)
10  * Copyright (c) 2016 Smart Contract Solutions, Inc.
11  */
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 
42 /*
43  * https://github.com/OpenZeppelin/zeppelin-solidity
44  *
45  * The MIT License (MIT)
46  * Copyright (c) 2016 Smart Contract Solutions, Inc.
47  */
48 contract Ownable {
49     address public owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55      * account.
56      */
57     function Ownable() public {
58         owner = msg.sender;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     /**
70      * @dev Allows the current owner to transfer control of the contract to a newOwner.
71      * @param newOwner The address to transfer ownership to.
72      */
73     function transferOwnership(address newOwner) public onlyOwner {
74         require(newOwner != address(0));
75         OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77     }
78 }
79 
80 
81 /*
82  * https://github.com/OpenZeppelin/zeppelin-solidity
83  *
84  * The MIT License (MIT)
85  * Copyright (c) 2016 Smart Contract Solutions, Inc.
86  */
87 contract ERC20Basic {
88     uint256 public totalSupply;
89     function balanceOf(address who) public view returns (uint256);
90     function transfer(address to, uint256 value) public returns (bool);
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 }
93 
94 
95 /*
96  * https://github.com/OpenZeppelin/zeppelin-solidity
97  *
98  * The MIT License (MIT)
99  * Copyright (c) 2016 Smart Contract Solutions, Inc.
100  */
101 contract BasicToken is ERC20Basic {
102     using SafeMath for uint256;
103 
104     mapping (address => uint256) internal balances;
105 
106     /**
107     * @dev transfer token for a specified address
108     * @param _to The address to transfer to.
109     * @param _value The amount to be transferred.
110     */
111     function transfer(address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113         require(_value <= balances[msg.sender]);
114 
115         // SafeMath.sub will throw if there is not enough balance.
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         Transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     /**
123     * @dev Gets the balance of the specified address.
124     * @param _owner The address to query the the balance of.
125     * @return An uint256 representing the amount owned by the passed address.
126     */
127     function balanceOf(address _owner) public view returns (uint256 balance) {
128         return balances[_owner];
129     }
130 }
131 
132 
133 /**
134  * @title A token that can decrease its supply
135  * @author Jakub Stefanski (https://github.com/jstefanski)
136  *
137  * https://github.com/OnLivePlatform/onlive-contracts
138  *
139  * The BSD 3-Clause Clear License
140  * Copyright (c) 2018 OnLive LTD
141  */
142 contract BurnableToken is BasicToken {
143 
144     using SafeMath for uint256;
145 
146     /**
147      * @dev Address where burned tokens are Transferred.
148      * @dev This is useful for blockchain explorers operating on Transfer event.
149      */
150     address public constant BURN_ADDRESS = address(0x0);
151 
152     /**
153      * @dev Tokens destroyed from specified address
154      * @param from address The burner
155      * @param amount uint256 The amount of destroyed tokens
156      */
157     event Burned(address indexed from, uint256 amount);
158 
159     modifier onlyHolder(uint256 amount) {
160         require(balances[msg.sender] >= amount);
161         _;
162     }
163 
164     /**
165      * @dev Destroy tokens (reduce total supply)
166      * @param amount uint256 The amount of tokens to be burned
167      */
168     function burn(uint256 amount)
169         public
170         onlyHolder(amount)
171     {
172         balances[msg.sender] = balances[msg.sender].sub(amount);
173         totalSupply = totalSupply.sub(amount);
174 
175         Burned(msg.sender, amount);
176         Transfer(msg.sender, BURN_ADDRESS, amount);
177     }
178 }
179 
180 
181 /**
182  * @title A token with modifiable name and symbol
183  * @author Jakub Stefanski (https://github.com/jstefanski)
184  *
185  * https://github.com/OnLivePlatform/onlive-contracts
186  *
187  * The BSD 3-Clause Clear License
188  * Copyright (c) 2018 OnLive LTD
189  */
190 contract DescriptiveToken is BasicToken, Ownable {
191 
192     string public name;
193     string public symbol;
194     bool public isDescriptionFinalized;
195     uint256 public decimals = 18;
196 
197     function DescriptiveToken(
198         string _name,
199         string _symbol
200     )
201         public
202         onlyNotEmpty(_name)
203         onlyNotEmpty(_symbol)
204     {
205         name = _name;
206         symbol = _symbol;
207     }
208 
209     /**
210      * @dev Logs change of token name and symbol
211      * @param name string The new token name
212      * @param symbol string The new token symbol
213      */
214     event DescriptionChanged(string name, string symbol);
215 
216     /**
217      * @dev Further changes to name and symbol are forbidden
218      */
219     event DescriptionFinalized();
220 
221     modifier onlyNotEmpty(string str) {
222         require(bytes(str).length > 0);
223         _;
224     }
225 
226     modifier onlyDescriptionNotFinalized() {
227         require(!isDescriptionFinalized);
228         _;
229     }
230 
231     /**
232      * @dev Change name and symbol of tokens
233      * @dev May be used in case of symbol collisions in exchanges.
234      * @param _name string A new token name
235      * @param _symbol string A new token symbol
236      */
237     function changeDescription(string _name, string _symbol)
238         public
239         onlyOwner
240         onlyDescriptionNotFinalized
241         onlyNotEmpty(_name)
242         onlyNotEmpty(_symbol)
243     {
244         name = _name;
245         symbol = _symbol;
246 
247         DescriptionChanged(name, symbol);
248     }
249 
250     /**
251      * @dev Prevents further changes to name and symbol
252      */
253     function finalizeDescription()
254         public
255         onlyOwner
256         onlyDescriptionNotFinalized
257     {
258         isDescriptionFinalized = true;
259 
260         DescriptionFinalized();
261     }
262 }
263 
264 
265 /**
266  * @title A token that can increase its supply in initial period
267  * @author Jakub Stefanski (https://github.com/jstefanski)
268  *
269  * https://github.com/OnLivePlatform/onlive-contracts
270  *
271  * The BSD 3-Clause Clear License
272  * Copyright (c) 2018 OnLive LTD
273  */
274 contract MintableToken is BasicToken, Ownable {
275 
276     using SafeMath for uint256;
277 
278     /**
279      * @dev Address from which minted tokens are Transferred.
280      * @dev This is useful for blockchain explorers operating on Transfer event.
281      */
282     address public constant MINT_ADDRESS = address(0x0);
283 
284     /**
285      * @dev Indicates whether creating tokens has finished
286      */
287     bool public mintingFinished;
288 
289     /**
290      * @dev Addresses allowed to create tokens
291      */
292     mapping (address => bool) public isMintingManager;
293 
294     /**
295      * @dev Tokens minted to specified address
296      * @param to address The receiver of the tokens
297      * @param amount uint256 The amount of tokens
298      */
299     event Minted(address indexed to, uint256 amount);
300 
301     /**
302      * @dev Approves specified address as a Minting Manager
303      * @param addr address The approved address
304      */
305     event MintingManagerApproved(address addr);
306 
307     /**
308      * @dev Revokes specified address as a Minting Manager
309      * @param addr address The revoked address
310      */
311     event MintingManagerRevoked(address addr);
312 
313     /**
314      * @dev Creation of tokens finished
315      */
316     event MintingFinished();
317 
318     modifier onlyMintingManager(address addr) {
319         require(isMintingManager[addr]);
320         _;
321     }
322 
323     modifier onlyMintingNotFinished {
324         require(!mintingFinished);
325         _;
326     }
327 
328     /**
329      * @dev Approve specified address to mint tokens
330      * @param addr address The approved Minting Manager address
331      */
332     function approveMintingManager(address addr)
333         public
334         onlyOwner
335         onlyMintingNotFinished
336     {
337         isMintingManager[addr] = true;
338 
339         MintingManagerApproved(addr);
340     }
341 
342     /**
343      * @dev Forbid specified address to mint tokens
344      * @param addr address The denied Minting Manager address
345      */
346     function revokeMintingManager(address addr)
347         public
348         onlyOwner
349         onlyMintingManager(addr)
350         onlyMintingNotFinished
351     {
352         delete isMintingManager[addr];
353 
354         MintingManagerRevoked(addr);
355     }
356 
357     /**
358      * @dev Create new tokens and transfer them to specified address
359      * @param to address The address to transfer to
360      * @param amount uint256 The amount to be minted
361      */
362     function mint(address to, uint256 amount)
363         public
364         onlyMintingManager(msg.sender)
365         onlyMintingNotFinished
366     {
367         totalSupply = totalSupply.add(amount);
368         balances[to] = balances[to].add(amount);
369 
370         Minted(to, amount);
371         Transfer(MINT_ADDRESS, to, amount);
372     }
373 
374     /**
375      * @dev Prevent further creation of tokens
376      */
377     function finishMinting()
378         public
379         onlyOwner
380         onlyMintingNotFinished
381     {
382         mintingFinished = true;
383 
384         MintingFinished();
385     }
386 }
387 
388 
389 /**
390  * @title A token that can increase its supply to the specified limit
391  * @author Jakub Stefanski (https://github.com/jstefanski)
392  *
393  * https://github.com/OnLivePlatform/onlive-contracts
394  *
395  * The BSD 3-Clause Clear License
396  * Copyright (c) 2018 OnLive LTD
397  */
398 contract CappedMintableToken is MintableToken {
399 
400     /**
401      * @dev Maximum supply that can be minted
402      */
403     uint256 public maxSupply;
404 
405     function CappedMintableToken(uint256 _maxSupply)
406         public
407         onlyNotZero(_maxSupply)
408     {
409         maxSupply = _maxSupply;
410     }
411 
412     modifier onlyNotZero(uint256 value) {
413         require(value != 0);
414         _;
415     }
416 
417     modifier onlyNotExceedingMaxSupply(uint256 supply) {
418         require(supply <= maxSupply);
419         _;
420     }
421 
422     /**
423      * @dev Create new tokens and transfer them to specified address
424      * @dev Checks against capped max supply of token.
425      * @param to address The address to transfer to
426      * @param amount uint256 The amount to be minted
427      */
428     function mint(address to, uint256 amount)
429         public
430         onlyNotExceedingMaxSupply(totalSupply.add(amount))
431     {
432         return MintableToken.mint(to, amount);
433     }
434 }
435 
436 
437 /*
438  * https://github.com/OpenZeppelin/zeppelin-solidity
439  *
440  * The MIT License (MIT)
441  * Copyright (c) 2016 Smart Contract Solutions, Inc.
442  *
443  * https://github.com/OnLivePlatform/onlive-contracts
444  *
445  * The BSD 3-Clause Clear License
446  * Copyright (c) 2018 OnLive LTD
447  */
448 contract ERC20 is ERC20Basic {
449     function allowance(address owner, address spender) public view returns (uint256);
450     function transferFrom(address from, address to, uint256 value) public returns (bool);
451     function approve(address spender, uint256 value) public returns (bool);
452     event Approval(address indexed owner, address indexed spender, uint256 value);
453 }
454 
455 
456 /*
457  * https://github.com/OpenZeppelin/zeppelin-solidity
458  *
459  * The MIT License (MIT)
460  * Copyright (c) 2016 Smart Contract Solutions, Inc.
461  *
462  * https://github.com/OnLivePlatform/onlive-contracts
463  *
464  * The BSD 3-Clause Clear License
465  * Copyright (c) 2018 OnLive LTD
466  */
467 contract StandardToken is ERC20, BasicToken {
468 
469     mapping (address => mapping (address => uint256)) internal allowed;
470 
471     /**
472      * @dev Transfer tokens from one address to another
473      * @param _from address The address which you want to send tokens from
474      * @param _to address The address which you want to transfer to
475      * @param _value uint256 the amount of tokens to be transferred
476      */
477     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
478         require(_to != address(0));
479         require(_value <= balances[_from]);
480         require(_value <= allowed[_from][msg.sender]);
481 
482         balances[_from] = balances[_from].sub(_value);
483         balances[_to] = balances[_to].add(_value);
484         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
485         Transfer(_from, _to, _value);
486         return true;
487     }
488 
489     /**
490      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
491      *
492      * Beware that changing an allowance with this method brings the risk that someone may use both the old
493      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
494      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
495      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
496      * @param _spender The address which will spend the funds.
497      * @param _value The amount of tokens to be spent.
498      */
499     function approve(address _spender, uint256 _value) public returns (bool) {
500         allowed[msg.sender][_spender] = _value;
501         Approval(msg.sender, _spender, _value);
502         return true;
503     }
504 
505     /**
506      * @dev Function to check the amount of tokens that an owner allowed to a spender.
507      * @param _owner address The address which owns the funds.
508      * @param _spender address The address which will spend the funds.
509      * @return A uint256 specifying the amount of tokens still available for the spender.
510      */
511     function allowance(address _owner, address _spender) public view returns (uint256) {
512         return allowed[_owner][_spender];
513     }
514 
515     /**
516      * @dev Increase the amount of tokens that an owner allowed to a spender.
517      *
518      * approve should be called when allowed[_spender] == 0. To increment
519      * allowed value is better to use this function to avoid 2 calls (and wait until
520      * the first transaction is mined)
521      * From MonolithDAO Token.sol
522      * @param _spender The address which will spend the funds.
523      * @param _addedValue The amount of tokens to increase the allowance by.
524      */
525     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
526         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
527         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
528         return true;
529     }
530 
531     /**
532      * @dev Decrease the amount of tokens that an owner allowed to a spender.
533      *
534      * approve should be called when allowed[_spender] == 0. To decrement
535      * allowed value is better to use this function to avoid 2 calls (and wait until
536      * the first transaction is mined)
537      * From MonolithDAO Token.sol
538      * @param _spender The address which will spend the funds.
539      * @param _subtractedValue The amount of tokens to decrease the allowance by.
540      */
541     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
542         uint oldValue = allowed[msg.sender][_spender];
543         if (_subtractedValue > oldValue) {
544             allowed[msg.sender][_spender] = 0;
545         } else {
546             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
547         }
548         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
549         return true;
550     }
551 
552 }
553 
554 
555 /**
556  * @title ERC20 token with manual initial lock up period
557  * @author Jakub Stefanski (https://github.com/jstefanski)
558  *
559  * https://github.com/OnLivePlatform/onlive-contracts
560  *
561  * The BSD 3-Clause Clear License
562  * Copyright (c) 2018 OnLive LTD
563  */
564 contract ReleasableToken is StandardToken, Ownable {
565 
566     /**
567      * @dev Controls whether token transfers are enabled
568      * @dev If false, token is in transfer lock up period.
569      */
570     bool public released;
571 
572     /**
573      * @dev Contract or EOA that can enable token transfers
574      */
575     address public releaseManager;
576 
577     /**
578      * @dev Map of addresses allowed to transfer tokens despite the lock up period
579      */
580     mapping (address => bool) public transferManagers;
581 
582     /**
583      * @dev Specified address set as a Release Manager
584      * @param addr address The approved address
585      */
586     event ReleaseManagerSet(address addr);
587 
588     /**
589      * @dev Approves specified address as Transfer Manager
590      * @param addr address The approved address
591      */
592     event TransferManagerApproved(address addr);
593 
594     /**
595      * @dev Revokes specified address as Transfer Manager
596      * @param addr address The denied address
597      */
598     event TransferManagerRevoked(address addr);
599 
600     /**
601      * @dev Marks token as released (transferable)
602      */
603     event Released();
604 
605     /**
606      * @dev Token is released or specified address is transfer manager
607      */
608     modifier onlyTransferableFrom(address from) {
609         if (!released) {
610             require(transferManagers[from]);
611         }
612 
613         _;
614     }
615 
616     /**
617      * @dev Specified address is transfer manager
618      */
619     modifier onlyTransferManager(address addr) {
620         require(transferManagers[addr]);
621         _;
622     }
623 
624     /**
625      * @dev Sender is release manager
626      */
627     modifier onlyReleaseManager() {
628         require(msg.sender == releaseManager);
629         _;
630     }
631 
632     /**
633      * @dev Token is released (transferable)
634      */
635     modifier onlyReleased() {
636         require(released);
637         _;
638     }
639 
640     /**
641      * @dev Token is in lock up period
642      */
643     modifier onlyNotReleased() {
644         require(!released);
645         _;
646     }
647 
648     /**
649      * @dev Set release manager if token not released yet
650      * @param addr address The new Release Manager address
651      */
652     function setReleaseManager(address addr)
653         public
654         onlyOwner
655         onlyNotReleased
656     {
657         releaseManager = addr;
658 
659         ReleaseManagerSet(addr);
660     }
661 
662     /**
663      * @dev Approve specified address to make transfers in lock up period
664      * @param addr address The approved Transfer Manager address
665      */
666     function approveTransferManager(address addr)
667         public
668         onlyOwner
669         onlyNotReleased
670     {
671         transferManagers[addr] = true;
672 
673         TransferManagerApproved(addr);
674     }
675 
676     /**
677      * @dev Forbid specified address to make transfers in lock up period
678      * @param addr address The denied Transfer Manager address
679      */
680     function revokeTransferManager(address addr)
681         public
682         onlyOwner
683         onlyTransferManager(addr)
684         onlyNotReleased
685     {
686         delete transferManagers[addr];
687 
688         TransferManagerRevoked(addr);
689     }
690 
691     /**
692      * @dev Release token and makes it transferable
693      */
694     function release()
695         public
696         onlyReleaseManager
697         onlyNotReleased
698     {
699         released = true;
700 
701         Released();
702     }
703 
704     /**
705      * @dev Transfer token to a specified address
706      * @dev Available only after token release
707      * @param to address The address to transfer to
708      * @param amount uint256 The amount to be transferred
709      */
710     function transfer(
711         address to,
712         uint256 amount
713     )
714         public
715         onlyTransferableFrom(msg.sender)
716         returns (bool)
717     {
718         return super.transfer(to, amount);
719     }
720 
721     /**
722      * @dev Transfer tokens from one address to another
723      * @dev Available only after token release
724      * @param from address The address which you want to send tokens from
725      * @param to address The address which you want to transfer to
726      * @param amount uint256 the amount of tokens to be transferred
727      */
728     function transferFrom(
729         address from,
730         address to,
731         uint256 amount
732     )
733         public
734         onlyTransferableFrom(from)
735         returns (bool)
736     {
737         return super.transferFrom(from, to, amount);
738     }
739 }
740 
741 
742 /**
743  * @title OnLive Token
744  * @author Jakub Stefanski (https://github.com/jstefanski)
745  * @dev Implements ERC20 interface
746  * @dev Mintable by selected addresses until sale finishes
747  * @dev A cap on total supply of tokens
748  * @dev Burnable by anyone
749  * @dev Manual lock-up period (non-transferable) with a non-reversible release by the selected address
750  * @dev Modifiable symbol and name in case of collision
751  *
752  * https://github.com/OnLivePlatform/onlive-contracts
753  *
754  * The BSD 3-Clause Clear License
755  * Copyright (c) 2018 OnLive LTD
756  */
757 contract OnLiveToken is DescriptiveToken, ReleasableToken, CappedMintableToken, BurnableToken {
758 
759     function OnLiveToken(
760         string _name,
761         string _symbol,
762         uint256 _maxSupply
763     )
764         public
765         DescriptiveToken(_name, _symbol)
766         CappedMintableToken(_maxSupply)
767     {
768         owner = msg.sender;
769     }
770 }