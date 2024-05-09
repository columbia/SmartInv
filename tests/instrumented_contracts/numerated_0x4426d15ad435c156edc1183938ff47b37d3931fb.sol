1 pragma solidity 0.4.25;
2 
3 /// @title provides subject to role checking logic
4 contract IAccessPolicy {
5 
6     ////////////////////////
7     // Public functions
8     ////////////////////////
9 
10     /// @notice We don't make this function constant to allow for state-updating access controls such as rate limiting.
11     /// @dev checks if subject belongs to requested role for particular object
12     /// @param subject address to be checked against role, typically msg.sender
13     /// @param role identifier of required role
14     /// @param object contract instance context for role checking, typically contract requesting the check
15     /// @param verb additional data, in current AccessControll implementation msg.sig
16     /// @return if subject belongs to a role
17     function allowed(
18         address subject,
19         bytes32 role,
20         address object,
21         bytes4 verb
22     )
23         public
24         returns (bool);
25 }
26 
27 /// @title enables access control in implementing contract
28 /// @dev see AccessControlled for implementation
29 contract IAccessControlled {
30 
31     ////////////////////////
32     // Events
33     ////////////////////////
34 
35     /// @dev must log on access policy change
36     event LogAccessPolicyChanged(
37         address controller,
38         IAccessPolicy oldPolicy,
39         IAccessPolicy newPolicy
40     );
41 
42     ////////////////////////
43     // Public functions
44     ////////////////////////
45 
46     /// @dev allows to change access control mechanism for this contract
47     ///     this method must be itself access controlled, see AccessControlled implementation and notice below
48     /// @notice it is a huge issue for Solidity that modifiers are not part of function signature
49     ///     then interfaces could be used for example to control access semantics
50     /// @param newPolicy new access policy to controll this contract
51     /// @param newAccessController address of ROLE_ACCESS_CONTROLLER of new policy that can set access to this contract
52     function setAccessPolicy(IAccessPolicy newPolicy, address newAccessController)
53         public;
54 
55     function accessPolicy()
56         public
57         constant
58         returns (IAccessPolicy);
59 
60 }
61 
62 contract StandardRoles {
63 
64     ////////////////////////
65     // Constants
66     ////////////////////////
67 
68     // @notice Soldity somehow doesn't evaluate this compile time
69     // @dev role which has rights to change permissions and set new policy in contract, keccak256("AccessController")
70     bytes32 internal constant ROLE_ACCESS_CONTROLLER = 0xac42f8beb17975ed062dcb80c63e6d203ef1c2c335ced149dc5664cc671cb7da;
71 }
72 
73 /// @title Granular code execution permissions
74 /// @notice Intended to replace existing Ownable pattern with more granular permissions set to execute smart contract functions
75 ///     for each function where 'only' modifier is applied, IAccessPolicy implementation is called to evaluate if msg.sender belongs to required role for contract being called.
76 ///     Access evaluation specific belong to IAccessPolicy implementation, see RoleBasedAccessPolicy for details.
77 /// @dev Should be inherited by a contract requiring such permissions controll. IAccessPolicy must be provided in constructor. Access policy may be replaced to a different one
78 ///     by msg.sender with ROLE_ACCESS_CONTROLLER role
79 contract AccessControlled is IAccessControlled, StandardRoles {
80 
81     ////////////////////////
82     // Mutable state
83     ////////////////////////
84 
85     IAccessPolicy private _accessPolicy;
86 
87     ////////////////////////
88     // Modifiers
89     ////////////////////////
90 
91     /// @dev limits function execution only to senders assigned to required 'role'
92     modifier only(bytes32 role) {
93         require(_accessPolicy.allowed(msg.sender, role, this, msg.sig));
94         _;
95     }
96 
97     ////////////////////////
98     // Constructor
99     ////////////////////////
100 
101     constructor(IAccessPolicy policy) internal {
102         require(address(policy) != 0x0);
103         _accessPolicy = policy;
104     }
105 
106     ////////////////////////
107     // Public functions
108     ////////////////////////
109 
110     //
111     // Implements IAccessControlled
112     //
113 
114     function setAccessPolicy(IAccessPolicy newPolicy, address newAccessController)
115         public
116         only(ROLE_ACCESS_CONTROLLER)
117     {
118         // ROLE_ACCESS_CONTROLLER must be present
119         // under the new policy. This provides some
120         // protection against locking yourself out.
121         require(newPolicy.allowed(newAccessController, ROLE_ACCESS_CONTROLLER, this, msg.sig));
122 
123         // We can now safely set the new policy without foot shooting.
124         IAccessPolicy oldPolicy = _accessPolicy;
125         _accessPolicy = newPolicy;
126 
127         // Log event
128         emit LogAccessPolicyChanged(msg.sender, oldPolicy, newPolicy);
129     }
130 
131     function accessPolicy()
132         public
133         constant
134         returns (IAccessPolicy)
135     {
136         return _accessPolicy;
137     }
138 }
139 
140 contract Math {
141 
142     ////////////////////////
143     // Internal functions
144     ////////////////////////
145 
146     // absolute difference: |v1 - v2|
147     function absDiff(uint256 v1, uint256 v2)
148         internal
149         pure
150         returns(uint256)
151     {
152         return v1 > v2 ? v1 - v2 : v2 - v1;
153     }
154 
155     // divide v by d, round up if remainder is 0.5 or more
156     function divRound(uint256 v, uint256 d)
157         internal
158         pure
159         returns(uint256)
160     {
161         return add(v, d/2) / d;
162     }
163 
164     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
165     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
166     // mind loss of precision as decimal fractions do not have finite binary expansion
167     // do not use instead of division
168     function decimalFraction(uint256 amount, uint256 frac)
169         internal
170         pure
171         returns(uint256)
172     {
173         // it's like 1 ether is 100% proportion
174         return proportion(amount, frac, 10**18);
175     }
176 
177     // computes part/total of amount with maximum precision (multiplication first)
178     // part and total must have the same units
179     function proportion(uint256 amount, uint256 part, uint256 total)
180         internal
181         pure
182         returns(uint256)
183     {
184         return divRound(mul(amount, part), total);
185     }
186 
187     //
188     // Open Zeppelin Math library below
189     //
190 
191     function mul(uint256 a, uint256 b)
192         internal
193         pure
194         returns (uint256)
195     {
196         uint256 c = a * b;
197         assert(a == 0 || c / a == b);
198         return c;
199     }
200 
201     function sub(uint256 a, uint256 b)
202         internal
203         pure
204         returns (uint256)
205     {
206         assert(b <= a);
207         return a - b;
208     }
209 
210     function add(uint256 a, uint256 b)
211         internal
212         pure
213         returns (uint256)
214     {
215         uint256 c = a + b;
216         assert(c >= a);
217         return c;
218     }
219 
220     function min(uint256 a, uint256 b)
221         internal
222         pure
223         returns (uint256)
224     {
225         return a < b ? a : b;
226     }
227 
228     function max(uint256 a, uint256 b)
229         internal
230         pure
231         returns (uint256)
232     {
233         return a > b ? a : b;
234     }
235 }
236 
237 /// @title standard access roles of the Platform
238 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
239 contract AccessRoles {
240 
241     ////////////////////////
242     // Constants
243     ////////////////////////
244 
245     // NOTE: All roles are set to the keccak256 hash of the
246     // CamelCased role name, i.e.
247     // ROLE_LOCKED_ACCOUNT_ADMIN = keccak256("LockedAccountAdmin")
248 
249     // May issue (generate) Neumarks
250     bytes32 internal constant ROLE_NEUMARK_ISSUER = 0x921c3afa1f1fff707a785f953a1e197bd28c9c50e300424e015953cbf120c06c;
251 
252     // May burn Neumarks it owns
253     bytes32 internal constant ROLE_NEUMARK_BURNER = 0x19ce331285f41739cd3362a3ec176edffe014311c0f8075834fdd19d6718e69f;
254 
255     // May create new snapshots on Neumark
256     bytes32 internal constant ROLE_SNAPSHOT_CREATOR = 0x08c1785afc57f933523bc52583a72ce9e19b2241354e04dd86f41f887e3d8174;
257 
258     // May enable/disable transfers on Neumark
259     bytes32 internal constant ROLE_TRANSFER_ADMIN = 0xb6527e944caca3d151b1f94e49ac5e223142694860743e66164720e034ec9b19;
260 
261     // may reclaim tokens/ether from contracts supporting IReclaimable interface
262     bytes32 internal constant ROLE_RECLAIMER = 0x0542bbd0c672578966dcc525b30aa16723bb042675554ac5b0362f86b6e97dc5;
263 
264     // represents legally platform operator in case of forks and contracts with legal agreement attached. keccak256("PlatformOperatorRepresentative")
265     bytes32 internal constant ROLE_PLATFORM_OPERATOR_REPRESENTATIVE = 0xb2b321377653f655206f71514ff9f150d0822d062a5abcf220d549e1da7999f0;
266 
267     // allows to deposit EUR-T and allow addresses to send and receive EUR-T. keccak256("EurtDepositManager")
268     bytes32 internal constant ROLE_EURT_DEPOSIT_MANAGER = 0x7c8ecdcba80ce87848d16ad77ef57cc196c208fc95c5638e4a48c681a34d4fe7;
269 
270     // allows to register identities and change associated claims keccak256("IdentityManager")
271     bytes32 internal constant ROLE_IDENTITY_MANAGER = 0x32964e6bc50f2aaab2094a1d311be8bda920fc4fb32b2fb054917bdb153a9e9e;
272 
273     // allows to replace controller on euro token and to destroy tokens without withdraw kecckak256("EurtLegalManager")
274     bytes32 internal constant ROLE_EURT_LEGAL_MANAGER = 0x4eb6b5806954a48eb5659c9e3982d5e75bfb2913f55199877d877f157bcc5a9b;
275 
276     // allows to change known interfaces in universe kecckak256("UniverseManager")
277     bytes32 internal constant ROLE_UNIVERSE_MANAGER = 0xe8d8f8f9ea4b19a5a4368dbdace17ad71a69aadeb6250e54c7b4c7b446301738;
278 
279     // allows to exchange gas for EUR-T keccak("GasExchange")
280     bytes32 internal constant ROLE_GAS_EXCHANGE = 0x9fe43636e0675246c99e96d7abf9f858f518b9442c35166d87f0934abef8a969;
281 
282     // allows to set token exchange rates keccak("TokenRateOracle")
283     bytes32 internal constant ROLE_TOKEN_RATE_ORACLE = 0xa80c3a0c8a5324136e4c806a778583a2a980f378bdd382921b8d28dcfe965585;
284 }
285 
286 contract IBasicToken {
287 
288     ////////////////////////
289     // Events
290     ////////////////////////
291 
292     event Transfer(
293         address indexed from,
294         address indexed to,
295         uint256 amount
296     );
297 
298     ////////////////////////
299     // Public functions
300     ////////////////////////
301 
302     /// @dev This function makes it easy to get the total number of tokens
303     /// @return The total number of tokens
304     function totalSupply()
305         public
306         constant
307         returns (uint256);
308 
309     /// @param owner The address that's balance is being requested
310     /// @return The balance of `owner` at the current block
311     function balanceOf(address owner)
312         public
313         constant
314         returns (uint256 balance);
315 
316     /// @notice Send `amount` tokens to `to` from `msg.sender`
317     /// @param to The address of the recipient
318     /// @param amount The amount of tokens to be transferred
319     /// @return Whether the transfer was successful or not
320     function transfer(address to, uint256 amount)
321         public
322         returns (bool success);
323 
324 }
325 
326 /// @title allows deriving contract to recover any token or ether that it has balance of
327 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
328 ///     be ready to handle such claims
329 /// @dev use with care!
330 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
331 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
332 ///         see ICBMLockedAccount as an example
333 contract Reclaimable is AccessControlled, AccessRoles {
334 
335     ////////////////////////
336     // Constants
337     ////////////////////////
338 
339     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
340 
341     ////////////////////////
342     // Public functions
343     ////////////////////////
344 
345     function reclaim(IBasicToken token)
346         public
347         only(ROLE_RECLAIMER)
348     {
349         address reclaimer = msg.sender;
350         if(token == RECLAIM_ETHER) {
351             reclaimer.transfer(address(this).balance);
352         } else {
353             uint256 balance = token.balanceOf(this);
354             require(token.transfer(reclaimer, balance));
355         }
356     }
357 }
358 
359 /// @title uniquely identifies deployable (non-abstract) platform contract
360 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
361 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
362 ///         EIP820 still in the making
363 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
364 ///      ids roughly correspond to ABIs
365 contract IContractId {
366     /// @param id defined as above
367     /// @param version implementation version
368     function contractId() public pure returns (bytes32 id, uint256 version);
369 }
370 
371 contract IERC20Allowance {
372 
373     ////////////////////////
374     // Events
375     ////////////////////////
376 
377     event Approval(
378         address indexed owner,
379         address indexed spender,
380         uint256 amount
381     );
382 
383     ////////////////////////
384     // Public functions
385     ////////////////////////
386 
387     /// @dev This function makes it easy to read the `allowed[]` map
388     /// @param owner The address of the account that owns the token
389     /// @param spender The address of the account able to transfer the tokens
390     /// @return Amount of remaining tokens of owner that spender is allowed
391     ///  to spend
392     function allowance(address owner, address spender)
393         public
394         constant
395         returns (uint256 remaining);
396 
397     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
398     ///  its behalf. This is a modified version of the ERC20 approve function
399     ///  to be a little bit safer
400     /// @param spender The address of the account able to transfer the tokens
401     /// @param amount The amount of tokens to be approved for transfer
402     /// @return True if the approval was successful
403     function approve(address spender, uint256 amount)
404         public
405         returns (bool success);
406 
407     /// @notice Send `amount` tokens to `to` from `from` on the condition it
408     ///  is approved by `from`
409     /// @param from The address holding the tokens being transferred
410     /// @param to The address of the recipient
411     /// @param amount The amount of tokens to be transferred
412     /// @return True if the transfer was successful
413     function transferFrom(address from, address to, uint256 amount)
414         public
415         returns (bool success);
416 
417 }
418 
419 contract IERC20Token is IBasicToken, IERC20Allowance {
420 
421 }
422 
423 contract ITokenMetadata {
424 
425     ////////////////////////
426     // Public functions
427     ////////////////////////
428 
429     function symbol()
430         public
431         constant
432         returns (string);
433 
434     function name()
435         public
436         constant
437         returns (string);
438 
439     function decimals()
440         public
441         constant
442         returns (uint8);
443 }
444 
445 contract IERC223Token is IERC20Token, ITokenMetadata {
446 
447     /// @dev Departure: We do not log data, it has no advantage over a standard
448     ///     log event. By sticking to the standard log event we
449     ///     stay compatible with constracts that expect and ERC20 token.
450 
451     // event Transfer(
452     //    address indexed from,
453     //    address indexed to,
454     //    uint256 amount,
455     //    bytes data);
456 
457 
458     /// @dev Departure: We do not use the callback on regular transfer calls to
459     ///     stay compatible with constracts that expect and ERC20 token.
460 
461     // function transfer(address to, uint256 amount)
462     //     public
463     //     returns (bool);
464 
465     ////////////////////////
466     // Public functions
467     ////////////////////////
468 
469     function transfer(address to, uint256 amount, bytes data)
470         public
471         returns (bool);
472 }
473 
474 contract IGasExchange {
475 
476     ////////////////////////
477     // Events
478     ////////////////////////
479 
480     /// @notice logged on eur-t to gas (ether) exchange
481     /// gasRecipient obtained amountWei gas, there is additional fee of exchangeFeeEurUlps
482     event LogGasExchange(
483         address indexed gasRecipient,
484         uint256 amountEurUlps,
485         uint256 exchangeFeeFrac,
486         uint256 amountWei,
487         uint256 rate
488     );
489 
490     event LogSetExchangeRate(
491         address indexed numeratorToken,
492         address indexed denominatorToken,
493         uint256 rate
494     );
495 
496     event LogReceivedEther(
497         address sender,
498         uint256 amount,
499         uint256 balance
500     );
501 
502     ////////////////////////
503     // Public methods
504     ////////////////////////
505 
506     /// @notice will exchange amountEurUlps of gasRecipient balance into ether
507     /// @dev EuroTokenController has permanent allowance for gasExchange contract to make such exchange possible when gasRecipient has no Ether
508     ///     (chicken and egg problem is solved). The rate from token rate oracle will be used
509     ///     exchangeFeeFraction will be deduced before the exchange happens
510     /// @dev you should probably apply access modifier in the implementation
511     function gasExchange(address gasRecipient, uint256 amountEurUlps, uint256 exchangeFeeFraction)
512         public;
513 
514     /// @notice see above. allows for batching gas exchanges
515     function gasExchangeMultiple(address[] gasRecipients, uint256[] amountsEurUlps, uint256 exchangeFeeFraction)
516         public;
517 
518     /// sets current euro to ether exchange rate, also sets inverse
519     /// ROLE_TOKEN_RATE_ORACLE is allowed to provide rates. we do not implement decentralized oracle here
520     /// there is no so actual working decentralized oracle ecosystem
521     /// the closes is MakerDao Medianizer at https://etherscan.io/address/0x729D19f657BD0614b4985Cf1D82531c67569197B#code but it's still centralized and only USD/ETH
522     /// Oraclize is centralized and you still need to pay fees.
523     /// Gnosis does not seem to be working
524     /// it seems that for Neufund investor it's best to trust Platform Operator to provide correct information, Platform is aligned via NEU and has no incentive to lie
525     /// SimpleExchange is replaceable via Universe. when proper oracle is available we'll move to it
526     /// @param numeratorToken token to be converted from
527     /// @param denominatorToken token to be converted to
528     /// @param rateFraction a decimal fraction (see Math.decimalFraction) of numeratorToken to denominatorToken
529     /// example: to set rate of eur to eth you provide (euroToken, etherToken, 0.0016129032258064516129032*10**18)
530     /// example: to set rate of eth to eur you provide (etherToken, euroToken, 620*10**18)
531     /// @dev you should probably apply access modifier in the implementation
532     function setExchangeRate(IERC223Token numeratorToken, IERC223Token denominatorToken, uint256 rateFraction)
533         public;
534 
535     /// @notice see above. allows for batching gas exchanges
536     /// @dev you should probably apply access modifier in the implementation
537     function setExchangeRates(IERC223Token[] numeratorTokens, IERC223Token[] denominatorTokens, uint256[] rateFractions)
538         public;
539 }
540 
541 contract ITokenExchangeRateOracle {
542     /// @notice provides actual price of 'numeratorToken' in 'denominatorToken'
543     ///     returns timestamp at which price was obtained in oracle
544     function getExchangeRate(address numeratorToken, address denominatorToken)
545         public
546         constant
547         returns (uint256 rateFraction, uint256 timestamp);
548 
549     /// @notice allows to retreive multiple exchange rates in once call
550     function getExchangeRates(address[] numeratorTokens, address[] denominatorTokens)
551         public
552         constant
553         returns (uint256[] rateFractions, uint256[] timestamps);
554 }
555 
556 /// @title simple exchange providing EUR to ETH exchange rate and gas exchange
557 /// see below discussion on oracle type used
558 contract SimpleExchange is
559     ITokenExchangeRateOracle,
560     IGasExchange,
561     IContractId,
562     Reclaimable,
563     Math
564 {
565     ////////////////////////
566     // Data types
567     ////////////////////////
568 
569     struct TokenRate {
570         // rate of numerator token to denominator token
571         uint128 rateFraction;
572         // timestamp of where rate was updated
573         uint128 timestamp;
574     }
575 
576     ////////////////////////
577     // Immutable state
578     ////////////////////////
579 
580     // ether token to store and transfer ether
581     IERC223Token private ETHER_TOKEN;
582     // euro token to store and transfer euro
583     IERC223Token private EURO_TOKEN;
584 
585     ////////////////////////
586     // Mutable state
587     ////////////////////////
588 
589     // rate from numerator to denominator
590     mapping (address => mapping (address => TokenRate)) private _rates;
591 
592     ////////////////////////
593     // Constructor
594     ////////////////////////
595 
596     constructor(
597         IAccessPolicy accessPolicy,
598         IERC223Token euroToken,
599         IERC223Token etherToken
600     )
601         AccessControlled(accessPolicy)
602         Reclaimable()
603         public
604     {
605         EURO_TOKEN = euroToken;
606         ETHER_TOKEN = etherToken;
607     }
608 
609     ////////////////////////
610     // Public methods
611     ////////////////////////
612 
613     //
614     // Implements IGasExchange
615     //
616 
617     function gasExchange(address gasRecipient, uint256 amountEurUlps, uint256 exchangeFeeFraction)
618         public
619         only(ROLE_GAS_EXCHANGE)
620     {
621         // fee must be less than 100%
622         assert(exchangeFeeFraction < 10**18);
623         (uint256 rate, uint256 rateTimestamp) = getExchangeRatePrivate(EURO_TOKEN, ETHER_TOKEN);
624         // require if rate older than 1 hours
625         require(block.timestamp - rateTimestamp < 1 hours, "NF_SEX_OLD_RATE");
626         gasExchangePrivate(gasRecipient, amountEurUlps, exchangeFeeFraction, rate);
627     }
628 
629     function gasExchangeMultiple(
630         address[] gasRecipients,
631         uint256[] amountsEurUlps,
632         uint256 exchangeFeeFraction
633     )
634         public
635         only(ROLE_GAS_EXCHANGE)
636     {
637         // fee must be less than 100%
638         assert(exchangeFeeFraction < 10**18);
639         require(gasRecipients.length == amountsEurUlps.length);
640         (uint256 rate, uint256 rateTimestamp) = getExchangeRatePrivate(EURO_TOKEN, ETHER_TOKEN);
641         // require if rate older than 1 hours
642         require(block.timestamp - rateTimestamp < 1 hours, "NF_SEX_OLD_RATE");
643         uint256 idx;
644         while(idx < gasRecipients.length) {
645             gasExchangePrivate(gasRecipients[idx], amountsEurUlps[idx], exchangeFeeFraction, rate);
646             idx += 1;
647         }
648     }
649 
650     /// @notice please read method description in the interface
651     /// @dev we always set a rate and an inverse rate! so you call once with eur/eth and you also get eth/eur
652     function setExchangeRate(IERC223Token numeratorToken, IERC223Token denominatorToken, uint256 rateFraction)
653         public
654         only(ROLE_TOKEN_RATE_ORACLE)
655     {
656         setExchangeRatePrivate(numeratorToken, denominatorToken, rateFraction);
657     }
658 
659     function setExchangeRates(IERC223Token[] numeratorTokens, IERC223Token[] denominatorTokens, uint256[] rateFractions)
660         public
661         only(ROLE_TOKEN_RATE_ORACLE)
662     {
663         require(numeratorTokens.length == denominatorTokens.length);
664         require(numeratorTokens.length == rateFractions.length);
665         for(uint256 idx = 0; idx < numeratorTokens.length; idx++) {
666             setExchangeRatePrivate(numeratorTokens[idx], denominatorTokens[idx], rateFractions[idx]);
667         }
668     }
669 
670     //
671     // Implements ITokenExchangeRateOracle
672     //
673 
674     function getExchangeRate(address numeratorToken, address denominatorToken)
675         public
676         constant
677         returns (uint256 rateFraction, uint256 timestamp)
678     {
679         return getExchangeRatePrivate(numeratorToken, denominatorToken);
680     }
681 
682     function getExchangeRates(address[] numeratorTokens, address[] denominatorTokens)
683         public
684         constant
685         returns (uint256[] rateFractions, uint256[] timestamps)
686     {
687         require(numeratorTokens.length == denominatorTokens.length);
688         uint256 idx;
689         rateFractions = new uint256[](numeratorTokens.length);
690         timestamps = new uint256[](denominatorTokens.length);
691         while(idx < numeratorTokens.length) {
692             (uint256 rate, uint256 timestamp) = getExchangeRatePrivate(numeratorTokens[idx], denominatorTokens[idx]);
693             rateFractions[idx] = rate;
694             timestamps[idx] = timestamp;
695             idx += 1;
696         }
697     }
698 
699     //
700     // Implements IContractId
701     //
702 
703     function contractId() public pure returns (bytes32 id, uint256 version) {
704         return (0x434a1a753d1d39381c462f37c155e520ae6f86ad79289abca9cde354a0cebd68, 0);
705     }
706 
707     //
708     // Override default function
709     //
710 
711     function () external payable {
712         emit LogReceivedEther(msg.sender, msg.value, address(this).balance);
713     }
714 
715     ////////////////////////
716     // Private methods
717     ////////////////////////
718 
719     function gasExchangePrivate(
720         address gasRecipient,
721         uint256 amountEurUlps,
722         uint256 exchangeFeeFraction,
723         uint256 rate
724     )
725         private
726     {
727         // exchange declared amount - the exchange fee, no overflow, fee < 0
728         uint256 amountEthWei = decimalFraction(amountEurUlps - decimalFraction(amountEurUlps, exchangeFeeFraction), rate);
729         // take all euro tokens
730         assert(EURO_TOKEN.transferFrom(gasRecipient, this, amountEurUlps));
731         // transfer ether to gasRecipient
732         gasRecipient.transfer(amountEthWei);
733 
734         emit LogGasExchange(gasRecipient, amountEurUlps, exchangeFeeFraction, amountEthWei, rate);
735     }
736 
737     function getExchangeRatePrivate(address numeratorToken, address denominatorToken)
738         private
739         constant
740         returns (uint256 rateFraction, uint256 timestamp)
741     {
742         TokenRate storage requested_rate = _rates[numeratorToken][denominatorToken];
743         TokenRate storage inversed_requested_rate = _rates[denominatorToken][numeratorToken];
744         if (requested_rate.timestamp > 0) {
745             return (requested_rate.rateFraction, requested_rate.timestamp);
746         }
747         else if (inversed_requested_rate.timestamp > 0) {
748             uint256 invRateFraction = proportion(10**18, 10**18, inversed_requested_rate.rateFraction);
749             return (invRateFraction, inversed_requested_rate.timestamp);
750         }
751         // will return (0, 0) == (rateFraction, timestamp)
752     }
753 
754     function setExchangeRatePrivate(
755         IERC223Token numeratorToken,
756         IERC223Token denominatorToken,
757         uint256 rateFraction
758     )
759         private
760     {
761         require(numeratorToken != denominatorToken, "NF_SEX_SAME_N_D");
762         assert(rateFraction > 0);
763         assert(rateFraction < 2**128);
764         uint256 invRateFraction = proportion(10**18, 10**18, rateFraction);
765 
766         // Inversion of rate biger than 10**36 is not possible and it will always be 0.
767         // require(invRateFraction < 2**128, "NF_SEX_OVR_INV");
768         require(denominatorToken.decimals() == numeratorToken.decimals(), "NF_SEX_DECIMALS");
769         // TODO: protect against outliers
770 
771         if (_rates[denominatorToken][numeratorToken].timestamp > 0) {
772             _rates[denominatorToken][numeratorToken] = TokenRate({
773                 rateFraction: uint128(invRateFraction),
774                 timestamp: uint128(block.timestamp)
775             });
776         }
777         else {
778             _rates[numeratorToken][denominatorToken] = TokenRate({
779                 rateFraction: uint128(rateFraction),
780                 timestamp: uint128(block.timestamp)
781             });
782         }
783 
784         emit LogSetExchangeRate(numeratorToken, denominatorToken, rateFraction);
785         emit LogSetExchangeRate(denominatorToken, numeratorToken, invRateFraction);
786     }
787 }