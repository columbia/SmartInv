1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ Internal Imports ============
5 import {ITokenRegistry} from "../../interfaces/bridge/ITokenRegistry.sol";
6 import {Router} from "../Router.sol";
7 import {XAppConnectionClient} from "../XAppConnectionClient.sol";
8 import {BridgeMessage} from "./BridgeMessage.sol";
9 import {IBridgeToken} from "../../interfaces/bridge/IBridgeToken.sol";
10 // ============ External Imports ============
11 import {Home} from "@nomad-xyz/nomad-core-sol/contracts/Home.sol";
12 import {Version0} from "@nomad-xyz/nomad-core-sol/contracts/Version0.sol";
13 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
14 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
15 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
16 
17 /**
18  * @title BridgeRouter
19  */
20 contract BridgeRouter is Version0, Router {
21     // ============ Libraries ============
22 
23     using TypedMemView for bytes;
24     using TypedMemView for bytes29;
25     using BridgeMessage for bytes29;
26     using SafeERC20 for IERC20;
27 
28     // ============ Constants ============
29 
30     // 5 bps (0.05%) hardcoded fast liquidity fee. Can be changed by contract upgrade
31     uint256 public constant PRE_FILL_FEE_NUMERATOR = 9995;
32     uint256 public constant PRE_FILL_FEE_DENOMINATOR = 10000;
33     uint256 public constant DUST_AMOUNT = 0.06 ether;
34 
35     // ============ Public Storage ============
36 
37     // contract that manages registry representation tokens
38     ITokenRegistry public tokenRegistry;
39     // token transfer prefill ID => LP that pre-filled message to provide fast liquidity
40     mapping(bytes32 => address) public liquidityProvider;
41 
42     // ============ Upgrade Gap ============
43 
44     // gap for upgrade safety
45     uint256[49] private __GAP;
46 
47     // ======== Events =========
48 
49     /**
50      * @notice emitted when tokens are sent from this domain to another domain
51      * @param token the address of the token contract
52      * @param from the address sending tokens
53      * @param toDomain the domain of the chain the tokens are being sent to
54      * @param toId the bytes32 address of the recipient of the tokens
55      * @param amount the amount of tokens sent
56      * @param fastLiquidityEnabled True if fast liquidity is enabled, False otherwise
57      */
58     event Send(
59         address indexed token,
60         address indexed from,
61         uint32 indexed toDomain,
62         bytes32 toId,
63         uint256 amount,
64         bool fastLiquidityEnabled
65     );
66 
67     /**
68      * @notice emitted when tokens are dispensed to an account on this domain
69      * emitted both when fast liquidity is provided, and when the transfer ultimately settles
70      * @param originAndNonce Domain where the transfer originated and the unique identifier
71      * for the message from origin to destination, combined in a single field ((origin << 32) & nonce)
72      * @param token The address of the local token contract being received
73      * @param recipient The address receiving the tokens; the original recipient of the transfer
74      * @param liquidityProvider The account providing liquidity
75      * @param amount The amount of tokens being received
76      */
77     event Receive(
78         uint64 indexed originAndNonce,
79         address indexed token,
80         address indexed recipient,
81         address liquidityProvider,
82         uint256 amount
83     );
84 
85     // ======== Receive =======
86     receive() external payable {}
87 
88     // ======== Initializer ========
89 
90     function initialize(address _tokenRegistry, address _xAppConnectionManager)
91         public
92         initializer
93     {
94         tokenRegistry = ITokenRegistry(_tokenRegistry);
95         __XAppConnectionClient_initialize(_xAppConnectionManager);
96     }
97 
98     // ======== External: Handle =========
99 
100     /**
101      * @notice Handles an incoming message
102      * @param _origin The origin domain
103      * @param _nonce The unique identifier for the message from origin to destination
104      * @param _sender The sender address
105      * @param _message The message
106      */
107     function handle(
108         uint32 _origin,
109         uint32 _nonce,
110         bytes32 _sender,
111         bytes memory _message
112     ) external override onlyReplica onlyRemoteRouter(_origin, _sender) {
113         // parse tokenId and action from message
114         bytes29 _msg = _message.ref(0).mustBeMessage();
115         bytes29 _tokenId = _msg.tokenId();
116         bytes29 _action = _msg.action();
117         // handle message based on the intended action
118         if (_action.isTransfer()) {
119             _handleTransfer(_origin, _nonce, _tokenId, _action, false);
120         } else if (_action.isFastTransfer()) {
121             _handleTransfer(_origin, _nonce, _tokenId, _action, true);
122         } else {
123             require(false, "!valid action");
124         }
125     }
126 
127     // ======== External: Send Token =========
128 
129     /**
130      * @notice Send tokens to a recipient on a remote chain
131      * @param _token The token address
132      * @param _amount The token amount
133      * @param _destination The destination domain
134      * @param _recipient The recipient address
135      * @param _enableFast True to enable fast liquidity
136      */
137     function send(
138         address _token,
139         uint256 _amount,
140         uint32 _destination,
141         bytes32 _recipient,
142         bool _enableFast
143     ) external {
144         require(_amount > 0, "!amnt");
145         require(_recipient != bytes32(0), "!recip");
146         // get remote BridgeRouter address; revert if not found
147         bytes32 _remote = _mustHaveRemote(_destination);
148         // Setup vars used in both if branches
149         IBridgeToken _t = IBridgeToken(_token);
150         bytes32 _detailsHash;
151         // remove tokens from circulation on this chain
152         if (tokenRegistry.isLocalOrigin(_token)) {
153             // if the token originates on this chain,
154             // hold the tokens in escrow in the Router
155             IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
156             // query token contract for details and calculate detailsHash
157             _detailsHash = BridgeMessage.getDetailsHash(
158                 _t.name(),
159                 _t.symbol(),
160                 _t.decimals()
161             );
162         } else {
163             // if the token originates on a remote chain,
164             // burn the representation tokens on this chain
165             _t.burn(msg.sender, _amount);
166             _detailsHash = _t.detailsHash();
167         }
168         // format Transfer Tokens action
169         bytes29 _action = BridgeMessage.formatTransfer(
170             _recipient,
171             _amount,
172             _detailsHash,
173             _enableFast
174         );
175         // get the tokenID
176         (uint32 _domain, bytes32 _id) = tokenRegistry.getTokenId(_token);
177         bytes29 _tokenId = BridgeMessage.formatTokenId(_domain, _id);
178         // send message to remote chain via Nomad
179         Home(xAppConnectionManager.home()).dispatch(
180             _destination,
181             _remote,
182             BridgeMessage.formatMessage(_tokenId, _action)
183         );
184         // emit Send event to record token sender
185         emit Send(
186             _token,
187             msg.sender,
188             _destination,
189             _recipient,
190             _amount,
191             _enableFast
192         );
193     }
194 
195     // ======== External: Fast Liquidity =========
196 
197     /**
198      * @notice Allows a liquidity provider to give an
199      * end user fast liquidity by pre-filling an
200      * incoming transfer message.
201      * Transfers tokens from the liquidity provider to the end recipient, minus the LP fee;
202      * Records the liquidity provider, who receives
203      * the full token amount when the transfer message is handled.
204      * @dev fast liquidity can only be provided for ONE token transfer
205      * with the same (recipient, amount) at a time.
206      * in the case that multiple token transfers with the same (recipient, amount)
207      * @param _origin The domain of the chain from which the transfer originated
208      * @param _nonce The unique identifier for the message from origin to destination
209      * @param _message The incoming transfer message to pre-fill
210      */
211     function preFill(
212         uint32 _origin,
213         uint32 _nonce,
214         bytes calldata _message
215     ) external {
216         // parse tokenId and action from message
217         bytes29 _msg = _message.ref(0).mustBeMessage();
218         bytes29 _tokenId = _msg.tokenId();
219         bytes29 _action = _msg.action();
220         // ensure that this is a fast transfer message, eligible for fast liquidity
221         require(_action.isFastTransfer(), "!fast transfer");
222         // calculate prefill ID
223         bytes32 _id = BridgeMessage.getPreFillId(
224             _origin,
225             _nonce,
226             _tokenId,
227             _action
228         );
229         // require that transfer has not already been pre-filled
230         require(liquidityProvider[_id] == address(0), "!unfilled");
231         // record liquidity provider so they will be repaid later
232         liquidityProvider[_id] = msg.sender;
233         // load transfer details to memory once
234         IERC20 _token = tokenRegistry.mustHaveLocalToken(
235             _tokenId.domain(),
236             _tokenId.id()
237         );
238         address _liquidityProvider = msg.sender;
239         address _recipient = _action.evmRecipient();
240         uint256 _amount = _applyPreFillFee(_action.amnt());
241         // transfer tokens from liquidity provider to token recipient
242         _token.safeTransferFrom(_liquidityProvider, _recipient, _amount);
243         // dust the recipient if appropriate
244         _dust(_recipient);
245         // emit event
246         emit Receive(
247             _originAndNonce(_origin, _nonce),
248             address(_token),
249             _recipient,
250             _liquidityProvider,
251             _amount
252         );
253     }
254 
255     // ======== External: Custom Tokens =========
256 
257     /**
258      * @notice Enroll a custom token. This allows projects to work with
259      * governance to specify a custom representation.
260      * @param _domain the domain of the canonical Token to enroll
261      * @param _id the bytes32 ID of the canonical of the Token to enroll
262      * @param _custom the address of the custom implementation to use.
263      */
264     function enrollCustom(
265         uint32 _domain,
266         bytes32 _id,
267         address _custom
268     ) external onlyOwner {
269         // Sanity check. Ensures that human error doesn't cause an
270         // unpermissioned contract to be enrolled.
271         IBridgeToken(_custom).mint(address(this), 1);
272         IBridgeToken(_custom).burn(address(this), 1);
273         tokenRegistry.enrollCustom(_domain, _id, _custom);
274     }
275 
276     /**
277      * @notice Migrate all tokens in a previous representation to the latest
278      * custom representation. This works by looking up local mappings and then
279      * burning old tokens and minting new tokens.
280      * @dev This is explicitly opt-in to allow dapps to decide when and how to
281      * upgrade to the new representation.
282      * @param _oldRepr The address of the old token to migrate
283      */
284     function migrate(address _oldRepr) external {
285         address _currentRepr = tokenRegistry.oldReprToCurrentRepr(_oldRepr);
286         require(_currentRepr != _oldRepr, "!different");
287         // burn the total balance of old tokens & mint the new ones
288         IBridgeToken _old = IBridgeToken(_oldRepr);
289         uint256 _bal = _old.balanceOf(msg.sender);
290         _old.burn(msg.sender, _bal);
291         IBridgeToken(_currentRepr).mint(msg.sender, _bal);
292     }
293 
294     // ============ Internal: Handle ============
295 
296     /**
297      * @notice Handles an incoming Transfer message.
298      *
299      * If the token is of local origin, the amount is sent from escrow.
300      * Otherwise, a representation token is minted.
301      *
302      * @param _origin The domain of the chain from which the transfer originated
303      * @param _nonce The unique identifier for the message from origin to destination
304      * @param _tokenId The token ID
305      * @param _action The action
306      * @param _fastEnabled True if fast liquidity was enabled, False otherwise
307      */
308     function _handleTransfer(
309         uint32 _origin,
310         uint32 _nonce,
311         bytes29 _tokenId,
312         bytes29 _action,
313         bool _fastEnabled
314     ) internal {
315         // get the token contract for the given tokenId on this chain;
316         // (if the token is of remote origin and there is
317         // no existing representation token contract, the TokenRegistry will
318         // deploy a new one)
319         address _token = tokenRegistry.ensureLocalToken(
320             _tokenId.domain(),
321             _tokenId.id()
322         );
323         // load the original recipient of the tokens
324         address _recipient = _action.evmRecipient();
325         if (_fastEnabled) {
326             // If an LP has prefilled this token transfer,
327             // send the tokens to the LP instead of the recipient
328             bytes32 _id = BridgeMessage.getPreFillId(
329                 _origin,
330                 _nonce,
331                 _tokenId,
332                 _action
333             );
334             address _lp = liquidityProvider[_id];
335             if (_lp != address(0)) {
336                 _recipient = _lp;
337                 delete liquidityProvider[_id];
338             }
339         }
340         // load amount once
341         uint256 _amount = _action.amnt();
342         // send the tokens into circulation on this chain
343         if (tokenRegistry.isLocalOrigin(_token)) {
344             // if the token is of local origin, the tokens have been held in
345             // escrow in this contract
346             // while they have been circulating on remote chains;
347             // transfer the tokens to the recipient
348             IERC20(_token).safeTransfer(_recipient, _amount);
349         } else {
350             // if the token is of remote origin, mint the tokens to the
351             // recipient on this chain
352             IBridgeToken(_token).mint(_recipient, _amount);
353             // Tell the token what its detailsHash is
354             IBridgeToken(_token).setDetailsHash(_action.detailsHash());
355         }
356         // dust the recipient if appropriate
357         _dust(_recipient);
358         // emit Receive event
359         emit Receive(
360             _originAndNonce(_origin, _nonce),
361             _token,
362             _recipient,
363             address(0),
364             _amount
365         );
366     }
367 
368     // ============ Internal: Fast Liquidity ============
369 
370     /**
371      * @notice Calculate the token amount after
372      * taking a 5 bps (0.05%) liquidity provider fee
373      * @param _amnt The token amount before the fee is taken
374      * @return _amtAfterFee The token amount after the fee is taken
375      */
376     function _applyPreFillFee(uint256 _amnt)
377         internal
378         pure
379         returns (uint256 _amtAfterFee)
380     {
381         // overflow only possible if (2**256 / 9995) tokens sent once
382         // in which case, probably not a real token
383         _amtAfterFee =
384             (_amnt * PRE_FILL_FEE_NUMERATOR) /
385             PRE_FILL_FEE_DENOMINATOR;
386     }
387 
388     /**
389      * @notice Dust the recipient. This feature allows chain operators to use
390      * the Bridge as a faucet if so desired. Any gas asset held by the
391      * bridge will be slowly sent to users who need initial gas bootstrapping
392      * @dev Does not dust if insufficient funds, or if user has funds already
393      */
394     function _dust(address _recipient) internal {
395         if (
396             _recipient.balance < DUST_AMOUNT &&
397             address(this).balance >= DUST_AMOUNT
398         ) {
399             // `send` gives execution 2300 gas and returns a `success` boolean.
400             // however, we do not care if the call fails. A failed call
401             // indicates a smart contract attempting to execute logic, which we
402             // specifically do not want.
403             // While we could check EXTCODESIZE, it seems sufficient to rely on
404             // the 2300 gas stipend to ensure that no state change logic can
405             // be executed.
406             payable(_recipient).send(DUST_AMOUNT);
407         }
408     }
409 
410     /**
411      * @dev explicit override for compiler inheritance
412      * @dev explicit override for compiler inheritance
413      * @return domain of chain on which the contract is deployed
414      */
415     function _localDomain()
416         internal
417         view
418         override(XAppConnectionClient)
419         returns (uint32)
420     {
421         return XAppConnectionClient._localDomain();
422     }
423 
424     /**
425      * @notice Internal utility function that combines
426      * `_origin` and `_nonce`.
427      * @dev Both origin and nonce should be less than 2^32 - 1
428      * @param _origin Domain of chain where the transfer originated
429      * @param _nonce The unique identifier for the message from origin to destination
430      * @return Returns (`_origin` << 32) & `_nonce`
431      */
432     function _originAndNonce(uint32 _origin, uint32 _nonce)
433         internal
434         pure
435         returns (uint64)
436     {
437         return (uint64(_origin) << 32) | _nonce;
438     }
439 }
