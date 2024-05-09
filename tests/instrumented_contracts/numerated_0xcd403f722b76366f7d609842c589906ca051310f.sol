1 // File: contracts/IMultisigControl.sol
2 
3 //SPDX-License-Identifier: MIT
4 pragma solidity 0.8.8;
5 
6 /// @title MultisigControl Interface
7 /// @author Vega Protocol
8 /// @notice Implementations of this interface are used by the Vega network to control smart contracts without the need for Vega to have any Ethereum of its own.
9 /// @notice To do this, the Vega validators sign a MultisigControl order to construct a signature bundle. Any interested party can then take that signature bundle and pay the gas to run the command on Ethereum
10 abstract contract IMultisigControl {
11 
12     /***************************EVENTS****************************/
13     event SignerAdded(address new_signer, uint256 nonce);
14     event SignerRemoved(address old_signer, uint256 nonce);
15     event ThresholdSet(uint16 new_threshold, uint256 nonce);
16 
17     /**************************FUNCTIONS*********************/
18     /// @notice Sets threshold of signatures that must be met before function is executed.
19     /// @param new_threshold New threshold value
20     /// @param nonce Vega-assigned single-use number that provides replay attack protection
21     /// @param signatures Vega-supplied signature bundle of a validator-signed order
22     /// @notice See MultisigControl for more about signatures
23     /// @notice Ethereum has no decimals, threshold is % * 10 so 50% == 500 100% == 1000
24     /// @notice signatures are OK if they are >= threshold count of total valid signers
25     /// @dev MUST emit ThresholdSet event
26     function set_threshold(uint16 new_threshold, uint nonce, bytes calldata signatures) public virtual;
27 
28     /// @notice Adds new valid signer and adjusts signer count.
29     /// @param new_signer New signer address
30     /// @param nonce Vega-assigned single-use number that provides replay attack protection
31     /// @param signatures Vega-supplied signature bundle of a validator-signed order
32     /// @notice See MultisigControl for more about signatures
33     /// @dev MUST emit 'SignerAdded' event
34     function add_signer(address new_signer, uint nonce, bytes calldata signatures) public virtual;
35 
36     /// @notice Removes currently valid signer and adjusts signer count.
37     /// @param old_signer Address of signer to be removed.
38     /// @param nonce Vega-assigned single-use number that provides replay attack protection
39     /// @param signatures Vega-supplied signature bundle of a validator-signed order
40     /// @notice See MultisigControl for more about signatures
41     /// @dev MUST emit 'SignerRemoved' event
42     function remove_signer(address old_signer, uint nonce, bytes calldata signatures) public virtual;
43 
44     /// @notice Verifies a signature bundle and returns true only if the threshold of valid signers is met,
45     /// @notice this is a function that any function controlled by Vega MUST call to be securely controlled by the Vega network
46     /// @notice message to hash to sign follows this pattern:
47     /// @notice abi.encode( abi.encode(param1, param2, param3, ... , nonce, function_name_string), validating_contract_or_submitter_address);
48     /// @notice Note that validating_contract_or_submitter_address is the the submitting party. If on MultisigControl contract itself, it's the submitting ETH address
49     /// @notice if function on bridge that then calls Multisig, then it's the address of that contract
50     /// @notice Note also the embedded encoding, this is required to verify what function/contract the function call goes to
51     /// @return MUST return true if valid signatures are over the threshold
52     function verify_signatures(bytes calldata signatures, bytes memory message, uint nonce) public virtual returns(bool);
53 
54     /**********************VIEWS*********************/
55     /// @return Number of valid signers
56     function get_valid_signer_count() public virtual view returns(uint8);
57 
58     /// @return Current threshold
59     function get_current_threshold() public virtual view returns(uint16);
60 
61     /// @param signer_address target potential signer address
62     /// @return true if address provided is valid signer
63     function is_valid_signer(address signer_address) public virtual view returns(bool);
64 
65     /// @param nonce Nonce to lookup
66     /// @return true if nonce has been used
67     function is_nonce_used(uint nonce) public virtual view returns(bool);
68 }
69 
70 /**
71 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
72 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
73 MMMMWEMMMMMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
74 MMMMMMLOVEMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
75 MMMMMMMMMMHIXELMMMMMMMMMMMM....................MMMMMNNMMMMMM
76 MMMMMMMMMMMMMMMMMMMMMMMMMMM....................MMMMMMMMMMMMM
77 MMMMMMMMMMMMMMMMMMMMMM88=........................+MMMMMMMMMM
78 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
79 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
80 MMMMMMMMMMMM.........................MM+..MMM....+MMMMMMMMMM
81 MMMMMMMMMNMM...................... ..MM?..MMM.. .+MMMMMMMMMM
82 MMMMNDDMM+........................+MM........MM..+MMMMMMMMMM
83 MMMMZ.............................+MM....................MMM
84 MMMMZ.............................+MM....................MMM
85 MMMMZ.............................+MM....................DDD
86 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
87 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
88 MM..............................MMZ....ZMMMMMMMMMMMMMMMMMMMM
89 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
90 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
91 MM......................ZMMMMM.......MMMMMMMMMMMMMMMMMMMMMMM
92 MM............... ......ZMMMMM.... ..MMMMMMMMMMMMMMMMMMMMMMM
93 MM...............MMMMM88~.........+MM..ZMMMMMMMMMMMMMMMMMMMM
94 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
95 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
96 MM.......ZMMMMMMM.......ZMMMMM..MMMMM..ZMMMMMMMMMMMMMMMMMMMM
97 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
98 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
99 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
100 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM*/
101 
102 // File: contracts/IERC20_Bridge_Logic.sol
103 
104 
105 /// @title ERC20 Bridge Logic Interface
106 /// @author Vega Protocol
107 /// @notice Implementations of this interface are used by Vega network users to deposit and withdraw ERC20 tokens to/from Vega.
108 // @notice All funds deposited/withdrawn are to/from the ERC20_Asset_Pool
109 abstract contract IERC20_Bridge_Logic {
110 
111     /***************************EVENTS****************************/
112     event Asset_Withdrawn(address indexed user_address, address indexed asset_source, uint256 amount, uint256 nonce);
113     event Asset_Deposited(address indexed user_address, address indexed asset_source, uint256 amount, bytes32 vega_public_key);
114     event Asset_Deposit_Minimum_Set(address indexed asset_source,  uint256 new_minimum, uint256 nonce);
115     event Asset_Deposit_Maximum_Set(address indexed asset_source,  uint256 new_maximum, uint256 nonce);
116     event Asset_Listed(address indexed asset_source,  bytes32 indexed vega_asset_id, uint256 nonce);
117     event Asset_Removed(address indexed asset_source,  uint256 nonce);
118 
119     /***************************FUNCTIONS*************************/
120     /// @notice This function lists the given ERC20 token contract as valid for deposit to this bridge
121     /// @param asset_source Contract address for given ERC20 token
122     /// @param vega_asset_id Vega-generated asset ID for internal use in Vega Core
123     /// @param nonce Vega-assigned single-use number that provides replay attack protection
124     /// @param signatures Vega-supplied signature bundle of a validator-signed order
125     /// @notice See MultisigControl for more about signatures
126     /// @dev MUST emit Asset_Listed if successful
127     function list_asset(address asset_source, bytes32 vega_asset_id, uint256 nonce, bytes memory signatures) public virtual;
128 
129     /// @notice This function removes from listing the given ERC20 token contract. This marks the token as invalid for deposit to this bridge
130     /// @param asset_source Contract address for given ERC20 token
131     /// @param nonce Vega-assigned single-use number that provides replay attack protection
132     /// @param signatures Vega-supplied signature bundle of a validator-signed order
133     /// @notice See MultisigControl for more about signatures
134     /// @dev MUST emit Asset_Removed if successful
135     function remove_asset(address asset_source, uint256 nonce, bytes memory signatures) public virtual;
136 
137     /// @notice This function sets the minimum allowable deposit for the given ERC20 token
138     /// @param asset_source Contract address for given ERC20 token
139     /// @param minimum_amount Minimum deposit amount
140     /// @param nonce Vega-assigned single-use number that provides replay attack protection
141     /// @param signatures Vega-supplied signature bundle of a validator-signed order
142     /// @notice See MultisigControl for more about signatures
143     /// @dev MUST emit Asset_Deposit_Minimum_Set if successful
144     function set_deposit_minimum(address asset_source, uint256 minimum_amount, uint256 nonce, bytes memory signatures) public virtual;
145 
146     /// @notice This function sets the maximum allowable deposit for the given ERC20 token
147     /// @param asset_source Contract address for given ERC20 token
148     /// @param maximum_amount Maximum deposit amount
149     /// @param nonce Vega-assigned single-use number that provides replay attack protection
150     /// @param signatures Vega-supplied signature bundle of a validator-signed order
151     /// @notice See MultisigControl for more about signatures
152     /// @dev MUST emit Asset_Deposit_Maximum_Set if successful
153     function set_deposit_maximum(address asset_source, uint256 maximum_amount, uint256 nonce, bytes memory signatures) public virtual;
154 
155     /// @notice This function withdrawals assets to the target Ethereum address
156     /// @param asset_source Contract address for given ERC20 token
157     /// @param amount Amount of ERC20 tokens to withdraw
158     /// @param target Target Ethereum address to receive withdrawn ERC20 tokens
159     /// @param nonce Vega-assigned single-use number that provides replay attack protection
160     /// @param signatures Vega-supplied signature bundle of a validator-signed order
161     /// @notice See MultisigControl for more about signatures
162     /// @dev MUST emit Asset_Withdrawn if successful
163     function withdraw_asset(address asset_source, uint256 amount, address target, uint256 nonce, bytes memory signatures) public virtual;
164 
165     /// @notice This function allows a user to deposit given ERC20 tokens into Vega
166     /// @param asset_source Contract address for given ERC20 token
167     /// @param amount Amount of tokens to be deposited into Vega
168     /// @param vega_public_key Target Vega public key to be credited with this deposit
169     /// @dev MUST emit Asset_Deposited if successful
170     /// @dev ERC20 approve function should be run before running this
171     /// @notice ERC20 approve function should be run before running this
172     function deposit_asset(address asset_source, uint256 amount, bytes32 vega_public_key) public virtual;
173 
174     /***************************VIEWS*****************************/
175     /// @notice This view returns true if the given ERC20 token contract has been listed valid for deposit
176     /// @param asset_source Contract address for given ERC20 token
177     /// @return True if asset is listed
178     function is_asset_listed(address asset_source) public virtual view returns(bool);
179 
180     /// @notice This view returns minimum valid deposit
181     /// @param asset_source Contract address for given ERC20 token
182     /// @return Minimum valid deposit of given ERC20 token
183     function get_deposit_minimum(address asset_source) public virtual view returns(uint256);
184 
185     /// @notice This view returns maximum valid deposit
186     /// @param asset_source Contract address for given ERC20 token
187     /// @return Maximum valid deposit of given ERC20 token
188     function get_deposit_maximum(address asset_source) public virtual view returns(uint256);
189 
190     /// @return current multisig_control_address
191     function get_multisig_control_address() public virtual view returns(address);
192 
193     /// @param asset_source Contract address for given ERC20 token
194     /// @return The assigned Vega Asset ID for given ERC20 token
195     function get_vega_asset_id(address asset_source) public virtual view returns(bytes32);
196 
197     /// @param vega_asset_id Vega-assigned asset ID for which you want the ERC20 token address
198     /// @return The ERC20 token contract address for a given Vega Asset ID
199     function get_asset_source(bytes32 vega_asset_id) public virtual view returns(address);
200 
201 }
202 
203 /**
204 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
205 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
206 MMMMWEMMMMMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
207 MMMMMMLOVEMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
208 MMMMMMMMMMHIXELMMMMMMMMMMMM....................MMMMMNNMMMMMM
209 MMMMMMMMMMMMMMMMMMMMMMMMMMM....................MMMMMMMMMMMMM
210 MMMMMMMMMMMMMMMMMMMMMM88=........................+MMMMMMMMMM
211 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
212 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
213 MMMMMMMMMMMM.........................MM+..MMM....+MMMMMMMMMM
214 MMMMMMMMMNMM...................... ..MM?..MMM.. .+MMMMMMMMMM
215 MMMMNDDMM+........................+MM........MM..+MMMMMMMMMM
216 MMMMZ.............................+MM....................MMM
217 MMMMZ.............................+MM....................MMM
218 MMMMZ.............................+MM....................DDD
219 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
220 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
221 MM..............................MMZ....ZMMMMMMMMMMMMMMMMMMMM
222 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
223 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
224 MM......................ZMMMMM.......MMMMMMMMMMMMMMMMMMMMMMM
225 MM............... ......ZMMMMM.... ..MMMMMMMMMMMMMMMMMMMMMMM
226 MM...............MMMMM88~.........+MM..ZMMMMMMMMMMMMMMMMMMMM
227 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
228 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
229 MM.......ZMMMMMMM.......ZMMMMM..MMMMM..ZMMMMMMMMMMMMMMMMMMMM
230 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
231 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
232 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
233 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM*/
234 
235 // File: contracts/IERC20.sol
236 
237 
238 /**
239  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
240  * the optional functions; to access them see {ERC20Detailed}.
241  */
242 interface IERC20 {
243     /**
244      * @dev Returns the amount of tokens in existence.
245      */
246     function totalSupply() external view returns (uint256);
247 
248     /**
249      * @dev Returns the amount of tokens owned by `account`.
250      */
251     function balanceOf(address account) external view returns (uint256);
252 
253     /**
254      * @dev Moves `amount` tokens from the caller's account to `recipient`.
255      *
256      * Returns a boolean value indicating whether the operation succeeded.
257      *
258      * Emits a {Transfer} event.
259      */
260     function transfer(address recipient, uint256 amount) external returns (bool);
261 
262     /**
263      * @dev Returns the remaining number of tokens that `spender` will be
264      * allowed to spend on behalf of `owner` through {transferFrom}. This is
265      * zero by default.
266      *
267      * This value changes when {approve} or {transferFrom} are called.
268      */
269     function allowance(address owner, address spender) external view returns (uint256);
270 
271     /**
272      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
273      *
274      * Returns a boolean value indicating whether the operation succeeded.
275      *
276      * IMPORTANT: Beware that changing an allowance with this method brings the risk
277      * that someone may use both the old and the new allowance by unfortunate
278      * transaction ordering. One possible solution to mitigate this race
279      * condition is to first reduce the spender's allowance to 0 and set the
280      * desired value afterwards:
281      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282      *
283      * Emits an {Approval} event.
284      */
285     function approve(address spender, uint256 amount) external returns (bool);
286 
287     /**
288      * @dev Moves `amount` tokens from `sender` to `recipient` using the
289      * allowance mechanism. `amount` is then deducted from the caller's
290      * allowance.
291      *
292      * Returns a boolean value indicating whether the operation succeeded.
293      *
294      * Emits a {Transfer} event.
295      */
296     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
297 
298     /**
299      * @dev Emitted when `value` tokens are moved from one account (`from`) to
300      * another (`to`).
301      *
302      * Note that `value` may be zero.
303      */
304     event Transfer(address indexed from, address indexed to, uint256 value);
305 
306     /**
307      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
308      * a call to {approve}. `value` is the new allowance.
309      */
310     event Approval(address indexed owner, address indexed spender, uint256 value);
311 }
312 
313 // File: contracts/ERC20_Asset_Pool.sol
314 
315 
316 /// @title ERC20 Asset Pool
317 /// @author Vega Protocol
318 /// @notice This contract is the target for all deposits to the ERC20 Bridge via ERC20_Bridge_Logic
319 contract ERC20_Asset_Pool {
320 
321     event Multisig_Control_Set(address indexed new_address);
322     event Bridge_Address_Set(address indexed new_address);
323 
324     /// @return Current MultisigControl contract address
325     address public multisig_control_address;
326 
327     /// @return Current ERC20_Bridge_Logic contract address
328     address public erc20_bridge_address;
329 
330     /// @param multisig_control The initial MultisigControl contract address
331     /// @notice Emits Multisig_Control_Set event
332     constructor(address multisig_control) {
333         multisig_control_address = multisig_control;
334         emit Multisig_Control_Set(multisig_control);
335     }
336 
337     /// @notice this contract is not intended to accept ether directly
338     receive() external payable {
339       revert("this contract does not accept ETH");
340     }
341 
342     /// @param new_address The new MultisigControl contract address.
343     /// @param nonce Vega-assigned single-use number that provides replay attack protection
344     /// @param signatures Vega-supplied signature bundle of a validator-signed set_multisig_control order
345     /// @notice See MultisigControl for more about signatures
346     /// @notice Emits Multisig_Control_Set event
347     function set_multisig_control(address new_address, uint256 nonce, bytes memory signatures) public {
348         require(new_address != address(0));
349         bytes memory message = abi.encode(new_address, nonce, 'set_multisig_control');
350         require(IMultisigControl(multisig_control_address).verify_signatures(signatures, message, nonce), "bad signatures");
351         multisig_control_address = new_address;
352         emit Multisig_Control_Set(new_address);
353     }
354 
355     /// @param new_address The new ERC20_Bridge_Logic contract address.
356     /// @param nonce Vega-assigned single-use number that provides replay attack protection
357     /// @param signatures Vega-supplied signature bundle of a validator-signed set_bridge_address order
358     /// @notice See MultisigControl for more about signatures
359     /// @notice Emits Bridge_Address_Set event
360     function set_bridge_address(address new_address, uint256 nonce, bytes memory signatures) public {
361         bytes memory message = abi.encode(new_address, nonce, 'set_bridge_address');
362         require(IMultisigControl(multisig_control_address).verify_signatures(signatures, message, nonce), "bad signatures");
363         erc20_bridge_address = new_address;
364         emit Bridge_Address_Set(new_address);
365     }
366 
367     /// @notice This function can only be run by the current "multisig_control_address" and, if available, will send the target tokens to the target
368     /// @param token_address Contract address of the ERC20 token to be withdrawn
369     /// @param target Target Ethereum address that the ERC20 tokens will be sent to
370     /// @param amount Amount of ERC20 tokens to withdraw
371     /// @dev amount is in whatever the lowest decimal value the ERC20 token has. For instance, an 18 decimal ERC20 token, 1 "amount" == 0.000000000000000001
372     /// @return true if transfer was successful.
373     function withdraw(address token_address, address target, uint256 amount) public returns(bool) {
374         require(msg.sender == erc20_bridge_address, "msg.sender not authorized bridge");
375 
376         IERC20(token_address).transfer(target, amount);
377         /// @dev the following is a test for non-standard ERC20 tokens IE ones without a return value
378         bool result;
379         assembly {
380            switch returndatasize()
381                case 0 {                      // no return value but didn't revert
382                    result := true
383                }
384                case 32 {                     // standard ERC20, has return value
385                    returndatacopy(0, 0, 32)
386                    result := mload(0)        // result is result of transfer call
387                }
388                default {}
389        }
390        require(result, "token transfer failed"); // revert() if result is false
391 
392       return true;
393     }
394 }
395 
396 /**
397 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
398 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
399 MMMMWEMMMMMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
400 MMMMMMLOVEMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
401 MMMMMMMMMMHIXELMMMMMMMMMMMM....................MMMMMNNMMMMMM
402 MMMMMMMMMMMMMMMMMMMMMMMMMMM....................MMMMMMMMMMMMM
403 MMMMMMMMMMMMMMMMMMMMMM88=........................+MMMMMMMMMM
404 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
405 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
406 MMMMMMMMMMMM.........................MM+..MMM....+MMMMMMMMMM
407 MMMMMMMMMNMM...................... ..MM?..MMM.. .+MMMMMMMMMM
408 MMMMNDDMM+........................+MM........MM..+MMMMMMMMMM
409 MMMMZ.............................+MM....................MMM
410 MMMMZ.............................+MM....................MMM
411 MMMMZ.............................+MM....................DDD
412 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
413 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
414 MM..............................MMZ....ZMMMMMMMMMMMMMMMMMMMM
415 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
416 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
417 MM......................ZMMMMM.......MMMMMMMMMMMMMMMMMMMMMMM
418 MM............... ......ZMMMMM.... ..MMMMMMMMMMMMMMMMMMMMMMM
419 MM...............MMMMM88~.........+MM..ZMMMMMMMMMMMMMMMMMMMM
420 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
421 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
422 MM.......ZMMMMMMM.......ZMMMMM..MMMMM..ZMMMMMMMMMMMMMMMMMMMM
423 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
424 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
425 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
426 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM*/
427 
428 // File: contracts/ERC20_Bridge_Logic.sol
429 
430 
431 
432 /// @title ERC20 Bridge Logic
433 /// @author Vega Protocol
434 /// @notice This contract is used by Vega network users to deposit and withdraw ERC20 tokens to/from Vega.
435 // @notice All funds deposited/withdrawn are to/from the assigned ERC20_Asset_Pool
436 contract ERC20_Bridge_Logic is IERC20_Bridge_Logic {
437 
438     address multisig_control_address;
439     address payable erc20_asset_pool_address;
440     // asset address => is listed
441     mapping(address => bool) listed_tokens;
442     // asset address => minimum deposit amt
443     mapping(address => uint256) minimum_deposits;
444     // asset address => maximum deposit amt
445     mapping(address => uint256) maximum_deposits;
446     // Vega asset ID => asset_source
447     mapping(bytes32 => address) vega_asset_ids_to_source;
448     // asset_source => Vega asset ID
449     mapping(address => bytes32) asset_source_to_vega_asset_id;
450 
451     /// @param erc20_asset_pool Initial Asset Pool contract address
452     /// @param multisig_control Initial MultisigControl contract address
453     constructor(address payable erc20_asset_pool, address multisig_control) {
454         erc20_asset_pool_address = erc20_asset_pool;
455         multisig_control_address = multisig_control;
456     }
457 
458     /***************************FUNCTIONS*************************/
459     /// @notice This function lists the given ERC20 token contract as valid for deposit to this bridge
460     /// @param asset_source Contract address for given ERC20 token
461     /// @param vega_asset_id Vega-generated asset ID for internal use in Vega Core
462     /// @param nonce Vega-assigned single-use number that provides replay attack protection
463     /// @param signatures Vega-supplied signature bundle of a validator-signed order
464     /// @notice See MultisigControl for more about signatures
465     /// @dev Emits Asset_Listed if successful
466     function list_asset(address asset_source, bytes32 vega_asset_id, uint256 nonce, bytes memory signatures) public override {
467         require(!listed_tokens[asset_source], "asset already listed");
468         bytes memory message = abi.encode(asset_source, vega_asset_id, nonce, 'list_asset');
469         require(IMultisigControl(multisig_control_address).verify_signatures(signatures, message, nonce), "bad signatures");
470         listed_tokens[asset_source] = true;
471         vega_asset_ids_to_source[vega_asset_id] = asset_source;
472         asset_source_to_vega_asset_id[asset_source] = vega_asset_id;
473         emit Asset_Listed(asset_source, vega_asset_id, nonce);
474     }
475 
476     /// @notice This function removes from listing the given ERC20 token contract. This marks the token as invalid for deposit to this bridge
477     /// @param asset_source Contract address for given ERC20 token
478     /// @param nonce Vega-assigned single-use number that provides replay attack protection
479     /// @param signatures Vega-supplied signature bundle of a validator-signed order
480     /// @notice See MultisigControl for more about signatures
481     /// @dev Emits Asset_Removed if successful
482     function remove_asset(address asset_source, uint256 nonce, bytes memory signatures) public override {
483         require(listed_tokens[asset_source], "asset not listed");
484         bytes memory message = abi.encode(asset_source, nonce, 'remove_asset');
485         require(IMultisigControl(multisig_control_address).verify_signatures(signatures, message, nonce), "bad signatures");
486         listed_tokens[asset_source] = false;
487         emit Asset_Removed(asset_source, nonce);
488     }
489 
490     /// @notice This function sets the minimum allowable deposit for the given ERC20 token
491     /// @param asset_source Contract address for given ERC20 token
492     /// @param minimum_amount Minimum deposit amount
493     /// @param nonce Vega-assigned single-use number that provides replay attack protection
494     /// @param signatures Vega-supplied signature bundle of a validator-signed order
495     /// @notice See MultisigControl for more about signatures
496     /// @dev Emits Asset_Deposit_Minimum_Set if successful
497     function set_deposit_minimum(address asset_source, uint256 minimum_amount, uint256 nonce, bytes memory signatures) public override{
498         require(listed_tokens[asset_source], "asset not listed");
499         bytes memory message = abi.encode(asset_source, minimum_amount, nonce, 'set_deposit_minimum');
500         require(IMultisigControl(multisig_control_address).verify_signatures(signatures, message, nonce), "bad signatures");
501         minimum_deposits[asset_source] = minimum_amount;
502         emit Asset_Deposit_Minimum_Set(asset_source, minimum_amount, nonce);
503     }
504 
505     /// @notice This function sets the maximum allowable deposit for the given ERC20 token
506     /// @param asset_source Contract address for given ERC20 token
507     /// @param maximum_amount Maximum deposit amount
508     /// @param nonce Vega-assigned single-use number that provides replay attack protection
509     /// @param signatures Vega-supplied signature bundle of a validator-signed order
510     /// @notice See MultisigControl for more about signatures
511     /// @dev Emits Asset_Deposit_Maximum_Set if successful
512     function set_deposit_maximum(address asset_source, uint256 maximum_amount, uint256 nonce, bytes memory signatures) public override {
513         require(listed_tokens[asset_source], "asset not listed");
514         bytes memory message = abi.encode(asset_source, maximum_amount, nonce, 'set_deposit_maximum');
515         require(IMultisigControl(multisig_control_address).verify_signatures(signatures, message, nonce), "bad signatures");
516         maximum_deposits[asset_source] = maximum_amount;
517         emit Asset_Deposit_Maximum_Set(asset_source, maximum_amount, nonce);
518     }
519 
520     /// @notice This function withdrawals assets to the target Ethereum address
521     /// @param asset_source Contract address for given ERC20 token
522     /// @param amount Amount of ERC20 tokens to withdraw
523     /// @param target Target Ethereum address to receive withdrawn ERC20 tokens
524     /// @param nonce Vega-assigned single-use number that provides replay attack protection
525     /// @param signatures Vega-supplied signature bundle of a validator-signed order
526     /// @notice See MultisigControl for more about signatures
527     /// @dev Emits Asset_Withdrawn if successful
528     function withdraw_asset(address asset_source, uint256 amount, address target, uint256 nonce, bytes memory signatures) public  override{
529         bytes memory message = abi.encode(asset_source, amount, target,  nonce, 'withdraw_asset');
530         require(IMultisigControl(multisig_control_address).verify_signatures(signatures, message, nonce), "bad signatures");
531         require(ERC20_Asset_Pool(erc20_asset_pool_address).withdraw(asset_source, target, amount), "token didn't transfer, rejected by asset pool.");
532         emit Asset_Withdrawn(target, asset_source, amount, nonce);
533     }
534 
535     /// @notice This function allows a user to deposit given ERC20 tokens into Vega
536     /// @param asset_source Contract address for given ERC20 token
537     /// @param amount Amount of tokens to be deposited into Vega
538     /// @param vega_public_key Target Vega public key to be credited with this deposit
539     /// @dev MUST emit Asset_Deposited if successful
540     /// @dev ERC20 approve function should be run before running this
541     /// @notice ERC20 approve function should be run before running this
542     function deposit_asset(address asset_source, uint256 amount, bytes32 vega_public_key) public override {
543         require(listed_tokens[asset_source], "asset not listed");
544         //User must run approve before deposit
545         require(maximum_deposits[asset_source] == 0 || amount <= maximum_deposits[asset_source], "deposit above maximum");
546         require(amount >= minimum_deposits[asset_source], "deposit below minimum");
547         require(IERC20(asset_source).transferFrom(msg.sender, erc20_asset_pool_address, amount), "transfer failed in deposit");
548         emit Asset_Deposited(msg.sender, asset_source, amount, vega_public_key);
549     }
550 
551     /***************************VIEWS*****************************/
552     /// @notice This view returns true if the given ERC20 token contract has been listed valid for deposit
553     /// @param asset_source Contract address for given ERC20 token
554     /// @return True if asset is listed
555     function is_asset_listed(address asset_source) public override view returns(bool){
556         return listed_tokens[asset_source];
557     }
558 
559     /// @notice This view returns minimum valid deposit
560     /// @param asset_source Contract address for given ERC20 token
561     /// @return Minimum valid deposit of given ERC20 token
562     function get_deposit_minimum(address asset_source) public override view returns(uint256){
563         return minimum_deposits[asset_source];
564     }
565 
566     /// @notice This view returns maximum valid deposit
567     /// @param asset_source Contract address for given ERC20 token
568     /// @return Maximum valid deposit of given ERC20 token
569     function get_deposit_maximum(address asset_source) public override view returns(uint256){
570         return maximum_deposits[asset_source];
571     }
572 
573     /// @return current multisig_control_address
574     function get_multisig_control_address() public override view returns(address) {
575         return multisig_control_address;
576     }
577 
578     /// @param asset_source Contract address for given ERC20 token
579     /// @return The assigned Vega Asset Id for given ERC20 token
580     function get_vega_asset_id(address asset_source) public override view returns(bytes32){
581         return asset_source_to_vega_asset_id[asset_source];
582     }
583 
584     /// @param vega_asset_id Vega-assigned asset ID for which you want the ERC20 token address
585     /// @return The ERC20 token contract address for a given Vega Asset Id
586     function get_asset_source(bytes32 vega_asset_id) public override view returns(address){
587         return vega_asset_ids_to_source[vega_asset_id];
588     }
589 }
590 
591 /**
592 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
593 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
594 MMMMWEMMMMMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
595 MMMMMMLOVEMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
596 MMMMMMMMMMHIXELMMMMMMMMMMMM....................MMMMMNNMMMMMM
597 MMMMMMMMMMMMMMMMMMMMMMMMMMM....................MMMMMMMMMMMMM
598 MMMMMMMMMMMMMMMMMMMMMM88=........................+MMMMMMMMMM
599 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
600 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
601 MMMMMMMMMMMM.........................MM+..MMM....+MMMMMMMMMM
602 MMMMMMMMMNMM...................... ..MM?..MMM.. .+MMMMMMMMMM
603 MMMMNDDMM+........................+MM........MM..+MMMMMMMMMM
604 MMMMZ.............................+MM....................MMM
605 MMMMZ.............................+MM....................MMM
606 MMMMZ.............................+MM....................DDD
607 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
608 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
609 MM..............................MMZ....ZMMMMMMMMMMMMMMMMMMMM
610 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
611 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
612 MM......................ZMMMMM.......MMMMMMMMMMMMMMMMMMMMMMM
613 MM............... ......ZMMMMM.... ..MMMMMMMMMMMMMMMMMMMMMMM
614 MM...............MMMMM88~.........+MM..ZMMMMMMMMMMMMMMMMMMMM
615 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
616 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
617 MM.......ZMMMMMMM.......ZMMMMM..MMMMM..ZMMMMMMMMMMMMMMMMMMMM
618 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
619 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
620 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
621 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM*/