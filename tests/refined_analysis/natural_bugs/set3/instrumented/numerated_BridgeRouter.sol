1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ Internal Imports ============
5 import {BridgeMessage} from "./BridgeMessage.sol";
6 import {IBridgeToken} from "./interfaces/IBridgeToken.sol";
7 import {ITokenRegistry} from "./interfaces/ITokenRegistry.sol";
8 import {IBridgeHook} from "./interfaces/IBridgeHook.sol";
9 import {IEventAccountant} from "./interfaces/IEventAccountant.sol";
10 // ============ External Imports ============
11 import {XAppConnectionClient} from "@nomad-xyz/contracts-router/contracts/XAppConnectionClient.sol";
12 import {Router} from "@nomad-xyz/contracts-router/contracts/Router.sol";
13 import {Home} from "@nomad-xyz/contracts-core/contracts/Home.sol";
14 import {TypeCasts} from "@nomad-xyz/contracts-core/contracts/libs/TypeCasts.sol";
15 import {Version0} from "@nomad-xyz/contracts-core/contracts/Version0.sol";
16 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
17 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
18 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
19 
20 /**
21  * @title BaseBridgeRouter
22  */
23 abstract contract BaseBridgeRouter is Version0, Router {
24     // ============ Libraries ============
25 
26     using TypedMemView for bytes;
27     using TypedMemView for bytes29;
28     using BridgeMessage for bytes29;
29     using SafeERC20 for IERC20;
30 
31     // ============ Constants ============
32 
33     // The amount transferred to bridgoors without gas funds
34     uint256 public constant DUST_AMOUNT = 0.06 ether;
35 
36     // ============ Public Storage ============
37 
38     // contract that manages registry representation tokens
39     ITokenRegistry public tokenRegistry;
40     // DEPRECATED; mapped token transfer prefill ID =>
41     // LP that pre-filled message to provide fast liquidity
42     // while fast liquidity feature existed
43     mapping(bytes32 => address) public liquidityProvider;
44 
45     // ============ Upgrade Gap ============
46 
47     // gap for upgrade safety
48     uint256[49] private __GAP;
49 
50     // ======== Events =========
51 
52     /**
53      * @notice emitted when tokens are sent from this domain to another domain
54      * @param token the address of the token contract
55      * @param from the address sending tokens
56      * @param toDomain the domain of the chain the tokens are being sent to
57      * @param toId the bytes32 address of the recipient of the tokens
58      * @param amount the amount of tokens sent
59      * @param toHook True if sent to a hook, on the remote chain, false
60      *        otherwise
61      */
62     event Send(
63         address indexed token,
64         address indexed from,
65         uint32 indexed toDomain,
66         bytes32 toId,
67         uint256 amount,
68         bool toHook
69     );
70 
71     /**
72      * @notice emitted when tokens are dispensed to an account on this domain
73      * @param originAndNonce Domain where the transfer originated and the
74      *        unique identifier for the message from origin to destination,
75      *        combined in a single field ((origin << 32) & nonce)
76      * @param token The address of the local token contract being received
77      * @param recipient The address receiving the tokens; the original
78      *        recipient of the transfer
79      * @param liquidityProvider DEPRECATED; The account providing liquidity
80      * @param amount The amount of tokens being received
81      */
82     event Receive(
83         uint64 indexed originAndNonce,
84         address indexed token,
85         address indexed recipient,
86         address liquidityProvider,
87         uint256 amount
88     );
89 
90     // ======== Receive =======
91     receive() external payable {}
92 
93     // ======== Initializer ========
94 
95     function initialize(address _tokenRegistry, address _xAppConnectionManager)
96         public
97         initializer
98     {
99         tokenRegistry = ITokenRegistry(_tokenRegistry);
100         __XAppConnectionClient_initialize(_xAppConnectionManager);
101     }
102 
103     // ======== External: Handle =========
104 
105     /**
106      * @notice Handles an incoming message
107      * @param _origin The origin domain
108      * @param _nonce The unique identifier for the message from origin to
109      *        destination
110      * @param _sender The sender address
111      * @param _message The message
112      */
113     function handle(
114         uint32 _origin,
115         uint32 _nonce,
116         bytes32 _sender,
117         bytes memory _message
118     ) external override onlyReplica onlyRemoteRouter(_origin, _sender) {
119         // parse tokenId and action from message
120         bytes29 _msg = _message.ref(0).mustBeMessage();
121         bytes29 _tokenId = _msg.tokenId();
122         bytes29 _action = _msg.action();
123         // handle message based on the intended action
124         if (_action.isTransfer()) {
125             _handleTransfer(_origin, _nonce, _tokenId, _action);
126         } else if (_action.isTransferToHook()) {
127             _handleTransferToHook(_origin, _nonce, _tokenId, _action);
128         } else {
129             require(false, "!valid action");
130         }
131     }
132 
133     // ======== External: Send Token =========
134 
135     /**
136      * @notice Send tokens to a recipient on a remote chain
137      * @param _token The token address
138      * @param _amount The token amount
139      * @param _destination The destination domain
140      * @param _recipient The recipient address
141      */
142     function send(
143         address _token,
144         uint256 _amount,
145         uint32 _destination,
146         bytes32 _recipient,
147         bool /*_enableFast - deprecated field, left argument for backwards compatibility */
148     ) external {
149         // validate inputs
150         require(_recipient != bytes32(0), "!recip");
151         // debit tokens from the sender
152         (bytes29 _tokenId, bytes32 _detailsHash) = _takeTokens(_token, _amount);
153         require(
154             _destination == _tokenId.domain(),
155             "sends temporarily disabled"
156         );
157         // format Transfer message
158         bytes29 _action = BridgeMessage.formatTransfer(
159             _recipient,
160             _amount,
161             _detailsHash
162         );
163         // send message to destination chain bridge router
164         _sendTransferMessage(_destination, _tokenId, _action);
165         // emit Send event to record token sender
166         emit Send(_token, msg.sender, _destination, _recipient, _amount, false);
167     }
168 
169     /**
170      * @notice Send tokens to a hook on the remote chain
171      * @param _token The token address
172      * @param _amount The token amount
173      * @param _destination The destination domain
174      * @param _remoteHook The hook contract on the remote chain
175      * @param _extraData Extra data that will be passed to the hook for
176      *        execution
177      */
178     function sendToHook(
179         address _token,
180         uint256 _amount,
181         uint32 _destination,
182         bytes32 _remoteHook,
183         bytes calldata _extraData
184     ) external {
185         // debit tokens from msg.sender
186         (bytes29 _tokenId, bytes32 _detailsHash) = _takeTokens(_token, _amount);
187         require(_remoteHook != bytes32(0), "!hook");
188         require(
189             _destination == _tokenId.domain(),
190             "sends temporarily disabled"
191         );
192         // format Hook transfer message
193         bytes29 _action = BridgeMessage.formatTransferToHook(
194             _remoteHook,
195             _amount,
196             _detailsHash,
197             TypeCasts.addressToBytes32(msg.sender),
198             _extraData
199         );
200         // send message to destination chain bridge router
201         _sendTransferMessage(_destination, _tokenId, _action);
202         // emit Send event to record token sender
203         emit Send(_token, msg.sender, _destination, _remoteHook, _amount, true);
204     }
205 
206     // ======== External: Custom Tokens =========
207 
208     /**
209      * @notice Enroll a custom token. This allows projects to work with
210      *         governance to specify a custom representation.
211      * @param _domain the domain of the canonical Token to enroll
212      * @param _id the bytes32 ID of the canonical of the Token to enroll
213      * @param _custom the address of the custom implementation to use.
214      */
215     function enrollCustom(
216         uint32 _domain,
217         bytes32 _id,
218         address _custom
219     ) external onlyOwner {
220         // Sanity check. Ensures that human error doesn't cause an
221         // unpermissioned contract to be enrolled.
222         IBridgeToken(_custom).mint(address(this), 1);
223         IBridgeToken(_custom).burn(address(this), 1);
224         tokenRegistry.enrollCustom(_domain, _id, _custom);
225     }
226 
227     /**
228      * @notice Migrate all tokens in a previous representation to the latest
229      *         custom representation. This works by looking up local mappings
230      *         and then burning old tokens and minting new tokens.
231      * @dev This is explicitly opt-in to allow dapps to decide when and how to
232      *      upgrade to the new representation.
233      * @param _oldRepr The address of the old token to migrate
234      */
235     function migrate(address _oldRepr) external {
236         address _currentRepr = tokenRegistry.oldReprToCurrentRepr(_oldRepr);
237         require(_currentRepr != _oldRepr, "!different");
238         // burn the total balance of old tokens & mint the new ones
239         IBridgeToken _old = IBridgeToken(_oldRepr);
240         uint256 _bal = _old.balanceOf(msg.sender);
241         _old.burn(msg.sender, _bal);
242         IBridgeToken(_currentRepr).mint(msg.sender, _bal);
243     }
244 
245     // ============ Internal: Send ============
246 
247     /**
248      * @notice Take from msg.sender as part of sending tokens across chains
249      * @dev Locks canonical tokens in escrow in BridgeRouter
250      *      OR Burns representation tokens
251      * @param _token The token to pull from the sender
252      * @param _amount The amount to pull from the sender
253      * @return _tokenId the bytes canonical token identifier
254      * @return _detailsHash the hash of the canonical token details (name,
255      *         symbol, decimal)
256      */
257     function _takeTokens(address _token, uint256 _amount)
258         internal
259         returns (bytes29 _tokenId, bytes32 _detailsHash)
260     {
261         // ensure that amount is non-zero
262         require(_amount > 0, "!amnt");
263         // Setup vars used in both if branches
264         IBridgeToken _t = IBridgeToken(_token);
265         // remove tokens from circulation on this chain
266         if (tokenRegistry.isLocalOrigin(_token)) {
267             // if the token originates on this chain,
268             // hold the tokens in escrow in the Router
269             IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
270             // query token contract for details and calculate detailsHash
271             _detailsHash = BridgeMessage.getDetailsHash(
272                 _t.name(),
273                 _t.symbol(),
274                 _t.decimals()
275             );
276         } else {
277             // if the token originates on a remote chain,
278             // burn the representation tokens on this chain
279             _t.burn(msg.sender, _amount);
280             _detailsHash = _t.detailsHash();
281         }
282         // get the tokenID
283         (uint32 _domain, bytes32 _id) = tokenRegistry.getTokenId(_token);
284         _tokenId = BridgeMessage.formatTokenId(_domain, _id);
285     }
286 
287     /**
288      * @notice Dispatch a message via Nomad to a destination domain
289      *         addressed to the remote BridgeRouter on that chain
290      * @dev Message will trigger `handle` method on the remote BridgeRouter
291      *      when it is received on the destination chain
292      * @param _destination The domain of the destination chain
293      * @param _tokenId The canonical token identifier for the transfer message
294      * @param _action The contents of the transfer message
295      */
296     function _sendTransferMessage(
297         uint32 _destination,
298         bytes29 _tokenId,
299         bytes29 _action
300     ) internal {
301         // get remote BridgeRouter address; revert if not found
302         bytes32 _remote = _mustHaveRemote(_destination);
303         // send message to remote chain via Nomad
304         Home(xAppConnectionManager.home()).dispatch(
305             _destination,
306             _remote,
307             BridgeMessage.formatMessage(_tokenId, _action)
308         );
309     }
310 
311     // ============ Internal: Handle ============
312 
313     /**
314      * @notice Handles an incoming Transfer message.
315      *
316      * If the token is of local origin, the amount is sent from escrow.
317      * Otherwise, a representation token is minted.
318      *
319      * @param _origin The domain of the chain from which the transfer originated
320      * @param _nonce The unique identifier for the message from origin to
321      *        destination
322      * @param _tokenId The token ID
323      * @param _action The action
324      */
325     function _handleTransfer(
326         uint32 _origin,
327         uint32 _nonce,
328         bytes29 _tokenId,
329         bytes29 _action
330     ) internal {
331         // tokens will be sent to the specified recipient
332         address _recipient = _action.evmRecipient();
333         // send tokens
334         _giveTokens(_origin, _nonce, _tokenId, _action, _recipient);
335         // dust the recipient with gas tokens
336         _dust(_recipient);
337     }
338 
339     /**
340      * @notice Handles an incoming TransferToHook message.
341      *
342      * @dev The hook is called AFTER tokens have been transferred to the hook
343      *      contract. If this hook errors, the bridge WILL revert.
344      *
345      * @param _origin The domain of the chain from which the transfer originated
346      * @param _nonce The unique identifier for the message from origin to destination
347      * @param _tokenId The token ID
348      * @param _action The action
349      */
350     function _handleTransferToHook(
351         uint32 _origin,
352         uint32 _nonce,
353         bytes29 _tokenId,
354         bytes29 _action
355     ) internal {
356         // tokens will be sent to user-specified hook
357         address _hook = _action.evmHook();
358         // send tokens
359         address _token = _giveTokens(_origin, _nonce, _tokenId, _action, _hook);
360         // ABI-encode the calldata for a `Hook.onReceive` call
361         bytes memory _call = abi.encodeWithSelector(
362             IBridgeHook.onReceive.selector,
363             _origin,
364             _action.sender(),
365             _tokenId.domain(),
366             _tokenId.id(),
367             _token,
368             _action.amnt(),
369             _action.extraData().clone()
370         );
371         // Call the hook with the ABI-encoded payload
372         // We use a low-level call here so that solc will skip the pre-call check.
373         // Specifically we want to skip the pre-flight extcode check and revert
374         // if the call reverts, with the revert message of the call
375         (bool _success, ) = _hook.call(_call);
376         // Revert with the call's revert string
377         if (!_success) {
378             assembly {
379                 let data := returndatasize()
380                 returndatacopy(0, 0, data)
381                 revert(0, data)
382             }
383         }
384     }
385 
386     /**
387      * @notice Send tokens to a specified recipient.
388      * @dev Unlocks canonical tokens from escrow in BridgeRouter
389      *      OR Mints representation tokens
390      * @param _origin The domain of the chain from which the transfer originated
391      * @param _nonce The unique identifier for the message from origin to
392      *        destination
393      * @param _tokenId The canonical token identifier to credit
394      * @param _action The contents of the transfer message
395      * @param _recipient The recipient that will receive tokens
396      * @return _token The address of the local token contract
397      */
398     function _giveTokens(
399         uint32 _origin,
400         uint32 _nonce,
401         bytes29 _tokenId,
402         bytes29 _action,
403         address _recipient
404     ) internal returns (address _token) {
405         // get the token contract for the given tokenId on this chain;
406         // (if the token is of remote origin and there is
407         // no existing representation token contract, the TokenRegistry will
408         // deploy a new one)
409         _token = tokenRegistry.ensureLocalToken(
410             _tokenId.domain(),
411             _tokenId.id()
412         );
413         // load amount once
414         uint256 _amount = _action.amnt();
415         // send the tokens into circulation on this chain
416         if (tokenRegistry.isLocalOrigin(_token)) {
417             _giveLocal(_token, _amount, _recipient);
418         } else {
419             _giveRepr(_token, _amount, _recipient, _action.detailsHash());
420         }
421         // emit Receive event
422         emit Receive(
423             _originAndNonce(_origin, _nonce),
424             _token,
425             _recipient,
426             address(0),
427             _amount
428         );
429     }
430 
431     /**
432      * @notice Gives local tokens on inbound bridge message
433      * @dev May record ProcessFailure instead of transferring the asset itself
434      * @param _token The asset
435      * @param _amount The amount
436      * @param _recipient The recipient
437      */
438     function _giveLocal(
439         address _token,
440         uint256 _amount,
441         address _recipient
442     ) internal virtual {
443         IERC20(_token).safeTransfer(_recipient, _amount);
444     }
445 
446     /**
447      * @notice Gives remote tokens on inbound bridge message
448      * @dev Mints the appropriate amount to the user
449      * @param _token The asset
450      * @param _amount The amount
451      * @param _recipient The recipient
452      * @param _detailsHash The hash of the token details
453      */
454     function _giveRepr(
455         address _token,
456         uint256 _amount,
457         address _recipient,
458         bytes32 _detailsHash
459     ) internal {
460         // if the token is of remote origin, mint the tokens to the
461         // recipient on this chain
462         IBridgeToken(_token).mint(_recipient, _amount);
463         // Tell the token what its detailsHash is
464         IBridgeToken(_token).setDetailsHash(_detailsHash);
465     }
466 
467     // ============ Internal: Dust with Gas ============
468 
469     /**
470      * @notice Dust the recipient. This feature allows chain operators to use
471      * the Bridge as a faucet if so desired. Any gas asset held by the
472      * bridge will be slowly sent to users who need initial gas bootstrapping
473      * @dev Does not dust if insufficient funds, or if user has funds already
474      */
475     function _dust(address _recipient) internal {
476         if (
477             _recipient.balance < DUST_AMOUNT &&
478             address(this).balance >= DUST_AMOUNT
479         ) {
480             // `send` gives execution 2300 gas and returns a `success` boolean.
481             // however, we do not care if the call fails. A failed call
482             // indicates a smart contract attempting to execute logic, which we
483             // specifically do not want.
484             // While we could check EXTCODESIZE, it seems sufficient to rely on
485             // the 2300 gas stipend to ensure that no state change logic can
486             // be executed.
487             payable(_recipient).send(DUST_AMOUNT);
488         }
489     }
490 
491     // ============ Internal: Utils ============
492 
493     /**
494      * @notice Internal utility function that combines
495      *         `_origin` and `_nonce`.
496      * @dev Both origin and nonce should be less than 2^32 - 1
497      * @param _origin Domain of chain where the transfer originated
498      * @param _nonce The unique identifier for the message from origin to
499               destination
500      * @return Returns (`_origin` << 32) & `_nonce`
501      */
502     function _originAndNonce(uint32 _origin, uint32 _nonce)
503         internal
504         pure
505         returns (uint64)
506     {
507         return (uint64(_origin) << 32) | _nonce;
508     }
509 
510     /**
511      * @dev should be impossible to renounce ownership;
512      *      we override OpenZeppelin OwnableUpgradeable's
513      *      implementation of renounceOwnership to make it a no-op
514      */
515     function renounceOwnership() public override onlyOwner {
516         // do nothing
517     }
518 }
519 
520 /**
521  * @title BridgeRouter
522  */
523 contract BridgeRouter is BaseBridgeRouter {
524 
525 }
526 
527 /**
528  * @title EthereumBridgeRouter
529  */
530 contract EthereumBridgeRouter is BaseBridgeRouter {
531     using SafeERC20 for IERC20;
532 
533     // ============== Immutables ==============
534     IEventAccountant public immutable accountant;
535 
536     // ======== Constructor =======
537     constructor(address _accountant) {
538         accountant = IEventAccountant(_accountant);
539     }
540 
541     /**
542      * @notice Approve funds remaining in the bridge router to be collected via accountant
543      */
544     function approveAffectedAssets() external onlyOwner {
545         address payable[14] memory _assets = accountant.affectedAssets();
546         for (uint256 i = 0; i < 14; i++) {
547             IERC20 _asset = IERC20(_assets[i]);
548             uint256 _balance = _asset.balanceOf(address(this));
549             if (_balance > 0) {
550                 // some tokens require setting approval to 0 before changing the approval to another value
551                 // in order to enable calling this function multiple times,
552                 // set approval to zero first
553                 _asset.approve(address(accountant), 0);
554                 _asset.approve(address(accountant), _balance);
555             }
556         }
557     }
558 
559     /**
560      * @notice Gives local tokens on inbound bridge message
561      * @dev May record ProcessFailure instead of transferring the asset itself
562      * @param _token The asset
563      * @param _amount The amount
564      * @param _recipient The recipient
565      */
566     function _giveLocal(
567         address _token,
568         uint256 _amount,
569         address _recipient
570     ) internal override {
571         // if the token is of local origin, the tokens have been held in this
572         // contract while the representations have been circulating on remote
573         // chains
574         // For unaffected assets, we transfer the tokens to the recipient
575         // For affected assets, we instead record a failure with the accountant
576         if (accountant.isAffectedAsset(_token)) {
577             accountant.record(_token, _recipient, _amount);
578         } else {
579             IERC20(_token).safeTransfer(_recipient, _amount);
580         }
581     }
582 }
