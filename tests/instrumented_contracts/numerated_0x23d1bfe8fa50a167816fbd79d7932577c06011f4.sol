1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-14
3 */
4 
5 //SPDX-License-Identifier: MIT
6 pragma solidity 0.8.1;
7 
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 /**
85  * @dev Interface contains all of the events necessary for staking Vega token
86  */
87 interface IStake {
88   event Stake_Deposited(address indexed user, uint256 amount, bytes32 indexed vega_public_key);
89   event Stake_Removed(address indexed user, uint256 amount, bytes32 indexed vega_public_key);
90   event Stake_Transferred(address indexed from, uint256 amount, address indexed to, bytes32 indexed vega_public_key);
91 
92   /// @return the address of the token that is able to be staked
93   function staking_token() external view returns (address);
94 
95   /// @param target Target address to check
96   /// @param vega_public_key Target vega public key to check
97   /// @return the number of tokens staked for that address->vega_public_key pair
98   function stake_balance(address target, bytes32 vega_public_key) external view returns (uint256);
99 
100 
101   /// @return total tokens staked on contract
102   function total_staked() external view returns (uint256);
103 }
104 
105 
106 /// @title ERC20 Vesting
107 /// @author Vega Protocol
108 /// @notice This contract manages the vesting of the Vega V2 ERC20 token
109 contract ERC20_Vesting is IStake {
110 
111   event Tranche_Created(uint8 indexed tranche_id, uint256 cliff_start, uint256 duration);
112   event Tranche_Balance_Added(address indexed user, uint8 indexed tranche_id, uint256 amount);
113   event Tranche_Balance_Removed(address indexed user, uint8 indexed tranche_id, uint256 amount);
114   event Issuer_Permitted(address indexed issuer, uint256 amount);
115   event Issuer_Revoked(address indexed issuer);
116   event Controller_Set(address indexed new_controller);
117 
118   /// @notice controller is similar to "owner" in other contracts
119   address public controller;
120   /// @notice tranche_count starts at 1 to cause tranche 0 (perma-lock) to exist as the default tranche
121   uint8 public tranche_count = 1;
122   /// @notice user => has been migrated
123   mapping(address => bool) public v1_migrated;
124   /// @notice user => user_stat struct
125   mapping(address=> user_stat) public user_stats;
126 
127   /// @notice total_locked is the total amount of tokens "on" this contract that are locked into a tranche
128   uint256 public total_locked;
129   /// @notice v1_address is the address for Vega's v1 ERC20 token that has already been deployed
130   address public v1_address; // mainnet = 0xD249B16f61cB9489Fe0Bb046119A48025545b58a;
131   /// @notice v2_address is the address for Vega's v2 ERC20 token that replaces v1
132   address public v2_address;
133   /// @notice accuracy_scale is the multiplier to assist in integer division
134   uint256 constant public accuracy_scale = 100000000000;
135   /// @notice default_tranche_id is the tranche_id for the default tranche
136   uint8 constant public default_tranche_id = 0;
137   /// @dev total_staked_tokens is the number of tokens staked across all users
138   uint256 total_staked_tokens;
139 
140   /****ADDRESS MIGRATION**/
141   /// @notice new address => old address
142   mapping(address => address) public address_migration;
143   /*****/
144 
145   /// @param token_v1_address Vega's already deployed v1 ERC20 token address
146   /// @param token_v2_address Vega's v2 ERC20 token and the token being vested here
147   /// @dev emits Controller_Set event
148   constructor(address token_v1_address, address token_v2_address, address[] memory old_addresses, address[] memory new_addresses) {
149     require(old_addresses.length == new_addresses.length, "array length mismatch");
150 
151     for(uint8 map_idx = 0; map_idx < old_addresses.length; map_idx++) {
152       /// @dev the following line prevents double-mapping attack
153       require(!v1_migrated[old_addresses[map_idx]]);
154       v1_migrated[old_addresses[map_idx]] = true;
155       address_migration[new_addresses[map_idx]] = old_addresses[map_idx];
156     }
157 
158     v1_address = token_v1_address;
159     /// @notice this initializes the total_locked with the amount of already issued v1 VEGA ERC20 tokens
160     total_locked = IERC20(token_v1_address).totalSupply() - IERC20(token_v1_address).balanceOf(token_v1_address);
161     v2_address = token_v2_address;
162     controller = msg.sender;
163     emit Controller_Set(controller);
164   }
165 
166   /// @notice tranche_balance has the params necessary to track what a user is owed in a single tranche
167   /// @param total_deposited is the total number of tokens deposited into this single tranche for a single user
168   /// @param total_claimed is the total number of tokens in this tranche that have been withdrawn
169   struct tranche_balance {
170       uint256 total_deposited;
171       uint256 total_claimed;
172   }
173 
174   /// @notice user_stat is a struct that holds all the details needed to handle a single user's vesting
175   /// @param total_in_all_tranches is the total number of tokens currently in all tranches that have been migrated to v2
176   /// @param lien total amount of locked tokens that have been marked for staking
177   /// @param tranche_balances is a mapping of tranche_id => tranche_balance
178   struct user_stat {
179     uint256 total_in_all_tranches;
180     uint256 lien;
181     mapping (uint8 => tranche_balance) tranche_balances;
182     mapping(bytes32 => uint256) stake;
183   }
184 
185   /// @notice tranche is a struct that hold the details needed for calculating individual tranche vesting
186   /// @param cliff_start is a timestamp after which vesting starts
187   /// @param duration is the number of seconds after cliff_start until the tranche is 100% vested
188   struct tranche {
189     uint256 cliff_start;
190     uint256 duration;
191   }
192 
193   /// @notice tranche_id => tranche struct
194   mapping(uint8 => tranche) public tranches;
195   /// @notice issuer address => permitted issuance allowance
196   mapping(address => uint256) public permitted_issuance;
197 
198   /// @notice this function allows the contract controller to create a tranche
199   /// @notice tranche zero is perma-locked and already exists prior to running this function, making the first vesting tranche "tranche:1"
200   /// @param cliff_start is a timestamp in seconds of when vesting begins for this tranche
201   /// @param duration is the number of seconds after cliff_start that the tranche will be fully vested
202   function create_tranche(uint256 cliff_start, uint256 duration) public only_controller {
203     tranches[tranche_count] = tranche(cliff_start, duration);
204     emit Tranche_Created(tranche_count, cliff_start, duration);
205     /// @notice sol ^0.8 comes with auto-overflow protection
206     tranche_count++;
207   }
208 
209   /// @notice this function allows the conroller or permitted issuer to issue tokens from this contract itself (no tranches) into the specified tranche
210   /// @notice tranche MUST be created
211   /// @notice once assigned to a tranche, tokens can never be clawed back, but they can be reassigned IFF they are in tranche_id:0
212   /// @param user The user being issued the tokens
213   /// @param tranche_id the id of the target tranche
214   /// @param amount number of tokens to be issued into tranche
215   /// @dev emits Tranche_Balance_Added event
216   function issue_into_tranche(address user, uint8 tranche_id, uint256 amount) public controller_or_issuer {
217     require(tranche_id < tranche_count, "tranche_id out of bounds");
218     if(permitted_issuance[msg.sender] > 0){
219       /// @dev if code gets here, they are an issuer if not they must be the controller
220       require(permitted_issuance[msg.sender] >= amount, "not enough permitted balance");
221       require(user != msg.sender, "cannot issue to self");
222       permitted_issuance[msg.sender] -= amount;
223     }
224     require( IERC20(v2_address).balanceOf(address(this)) - (total_locked + amount) >= 0, "contract token balance low" );
225 
226     /// @dev only runs once
227     if(!v1_migrated[user]){
228       uint256 bal = v1_bal(user);
229       user_stats[user].tranche_balances[0].total_deposited += bal;
230       user_stats[user].total_in_all_tranches += bal;
231       v1_migrated[user] = true;
232     }
233     user_stats[user].tranche_balances[tranche_id].total_deposited += amount;
234     user_stats[user].total_in_all_tranches += amount;
235     total_locked += amount;
236     emit Tranche_Balance_Added(user, tranche_id, amount);
237   }
238 
239 
240   /// @notice this function allows the controller to move tokens issued into tranche zero to the target tranche
241   /// @notice can only be moved from tranche 0
242   /// @param user The user being issued the tokens
243   /// @param tranche_id the id of the target tranche
244   /// @param amount number of tokens to be moved from tranche 0
245   /// @dev emits Tranche_Balance_Removed event
246   /// @dev emits Tranche_Balance_Added event
247   function move_into_tranche(address user, uint8 tranche_id, uint256 amount) public only_controller {
248     require(tranche_id > 0 && tranche_id < tranche_count);
249 
250     /// @dev only runs once
251     if(!v1_migrated[user]){
252       uint256 bal = v1_bal(user);
253       user_stats[user].tranche_balances[default_tranche_id].total_deposited += bal;
254       user_stats[user].total_in_all_tranches += bal;
255       v1_migrated[user] = true;
256     }
257     require(user_stats[user].tranche_balances[default_tranche_id].total_deposited >= amount);
258     user_stats[user].tranche_balances[default_tranche_id].total_deposited -= amount;
259     user_stats[user].tranche_balances[tranche_id].total_deposited += amount;
260     emit Tranche_Balance_Removed(user, default_tranche_id, amount);
261     emit Tranche_Balance_Added(user, tranche_id, amount);
262   }
263 
264   /// @notice this view returns the balance of the given tranche for the given user
265   /// @notice tranche 0 balance of a non-v1_migrated user will return user's v1 token balance as they are pre-issued to the current hodlers
266   /// @param user Target user address
267   /// @param tranche_id target tranche
268   /// @return balance of target tranche of user
269   function get_tranche_balance(address user, uint8 tranche_id) public view returns(uint256) {
270     if(tranche_id == default_tranche_id && !v1_migrated[user]){
271       return v1_bal(user);
272     } else {
273       return user_stats[user].tranche_balances[tranche_id].total_deposited - user_stats[user].tranche_balances[tranche_id].total_claimed;
274     }
275   }
276 
277   /// @notice This view returns the amount that is currently vested in a given tranche
278   /// @notice This does NOT take into account any current lien
279   /// @param user Target user address
280   /// @param tranche_id Target tranche
281   /// @return number of tokens vested in the target tranche for the target user
282   function get_vested_for_tranche(address user, uint8 tranche_id) public view returns(uint256) {
283     if(block.timestamp < tranches[tranche_id].cliff_start){
284       return 0;
285     }
286     else if(block.timestamp > tranches[tranche_id].cliff_start + tranches[tranche_id].duration || tranches[tranche_id].duration == 0){
287       return user_stats[user].tranche_balances[tranche_id].total_deposited -  user_stats[user].tranche_balances[tranche_id].total_claimed;
288     } else {
289       return (((( accuracy_scale * (block.timestamp - tranches[tranche_id].cliff_start) )  / tranches[tranche_id].duration
290           ) * user_stats[user].tranche_balances[tranche_id].total_deposited
291         ) / accuracy_scale ) - user_stats[user].tranche_balances[tranche_id].total_claimed;
292     }
293   }
294 
295   /// @notice This view returns the balance remaining in Vega V1 for a given user
296   /// @notice Once migrated, the balance will always return zero, hence "remaining"
297   /// @param user Target user
298   /// @return remaining v1 balance
299   function v1_bal(address user) internal view returns(uint256) {
300     if(!v1_migrated[user]){
301       if(address_migration[user] != address(0)){
302         return IERC20(v1_address).balanceOf(user) + IERC20(v1_address).balanceOf(address_migration[user]);
303       } else {
304         return IERC20(v1_address).balanceOf(user);
305       }
306     } else {
307       return 0;
308     }
309   }
310 
311   /// @notice This view returns the current amount of tokens locked in all tranches
312   /// @notice This includes remaining v1 balance
313   /// @param user Target user
314   /// @return the current amount of tokens for target user in all tranches
315   function user_total_all_tranches(address user) public view returns(uint256){
316     return user_stats[user].total_in_all_tranches + v1_bal(user);
317   }
318 
319   /// @notice This function withdraws all the currently available vested tokens from the target tranche
320   /// @notice This will not allow a user's total tranch balance to go below the user's lien amount
321   /// @dev Emits Tranche_Balance_Removed event if successful
322   /// @param tranche_id Id of target tranche
323   function withdraw_from_tranche(uint8 tranche_id) public {
324     require(tranche_id != default_tranche_id);
325     uint256 to_withdraw = get_vested_for_tranche(msg.sender, tranche_id);
326     require(user_stats[msg.sender].total_in_all_tranches - to_withdraw >=  user_stats[msg.sender].lien);
327     user_stats[msg.sender].tranche_balances[tranche_id].total_claimed += to_withdraw;
328     /// @dev Solidity ^0.8 has overflow protection, if this next line overflows, the transaction will revert
329     user_stats[msg.sender].total_in_all_tranches -= to_withdraw;
330     /// @dev Solidity ^0.8 has overflow protection, if this next line overflows, the transaction will revert
331     total_locked -= to_withdraw;
332     require(IERC20(v2_address).transfer(msg.sender, to_withdraw));
333     emit Tranche_Balance_Removed(msg.sender, tranche_id, to_withdraw);
334   }
335 
336   /// @notice This function allows the controller to assist the target user with their withdrawal. All the currently available vested tokens FOR THE TARGET will be withdrawn TO THE TARGET ADDRESS WALLET
337   /// @notice This function exists in case of users using custodial wallets that are incapable of running "withdraw_from_tranche" but are still ERC20 compatable
338   /// @notice ONLY the controller can run this function and it will only be ran at the target users request
339   /// @notice This will not allow a user's total tranch balance to go below the user's lien amount
340   /// @notice This function does not allow the controller to access any funds from other addresses or change which address is in control of any funds
341   /// @dev Emits Tranche_Balance_Removed event if successful
342   /// @param tranche_id Id of target tranche
343   /// @param target Address with balance that needs the assist
344   function assisted_withdraw_from_tranche(uint8 tranche_id, address target) public only_controller {
345     require(tranche_id != default_tranche_id);
346     uint256 to_withdraw = get_vested_for_tranche(target, tranche_id);
347     require(user_stats[target].total_in_all_tranches - to_withdraw >=  user_stats[target].lien);
348     user_stats[target].tranche_balances[tranche_id].total_claimed += to_withdraw;
349     /// @dev Solidity ^0.8 has overflow protection, if this next line overflows, the transaction will revert
350     user_stats[target].total_in_all_tranches -= to_withdraw;
351     /// @dev Solidity ^0.8 has overflow protection, if this next line overflows, the transaction will revert
352     total_locked -= to_withdraw;
353     require(IERC20(v2_address).transfer(target, to_withdraw));
354     emit Tranche_Balance_Removed(target, tranche_id, to_withdraw);
355   }
356 
357 
358   /// @notice This function will put a lien on the user who runs this function
359   /// @dev Emits Stake_Deposited event if successful
360   /// @param amount Amount of tokens to stake
361   /// @param vega_public_key Target Vega public key to be credited with the stake lock
362   function stake_tokens(uint256 amount, bytes32 vega_public_key) public {
363     require(user_stats[msg.sender].lien + amount > user_stats[msg.sender].lien);
364     require(user_total_all_tranches(msg.sender) >= user_stats[msg.sender].lien + amount);
365     /// @dev Solidity ^0.8 has overflow protection, if this next line overflows, the transaction will revert
366     user_stats[msg.sender].lien += amount;
367     user_stats[msg.sender].stake[vega_public_key] += amount;
368     total_staked_tokens += amount;
369     emit Stake_Deposited(msg.sender, amount, vega_public_key);
370   }
371 
372   /// @notice This function will remove the lien from the user who runs this function
373   /// @notice clears "amount" of lien
374   /// @dev emits Stake_Removed event if successful
375   /// @param amount Amount of tokens to remove from Staking
376   /// @param vega_public_key Target Vega public key from which to remove stake lock
377   function remove_stake(uint256 amount, bytes32 vega_public_key) public {
378     /// @dev Solidity ^0.8 has overflow protection, if this next line overflows, the transaction will revert
379     user_stats[msg.sender].stake[vega_public_key] -= amount;
380     /// @dev Solidity ^0.8 has overflow protection, if this next line overflows, the transaction will revert
381     user_stats[msg.sender].lien -= amount;
382     total_staked_tokens -= amount;
383     emit Stake_Removed(msg.sender, amount, vega_public_key);
384   }
385 
386   /// @notice This function allows the controller to permit the given address to issue the given Amount
387   /// @notice Target users MUST have a zero (0) permitted issuance balance (try revoke_issuer)
388   /// @dev emits Issuer_Permitted event
389   /// @param issuer Target address to be allowed to issue given amount
390   /// @param amount Number of tokens issuer is permitted to issue
391   function permit_issuer(address issuer, uint256 amount) public only_controller {
392     /// @notice revoke is required first to stop a simple double allowance attack
393     require(amount > 0, "amount must be > 0");
394     require(permitted_issuance[issuer] == 0, "issuer already permitted, revoke first");
395     require(controller != issuer, "controller cannot be permitted issuer");
396     permitted_issuance[issuer] = amount;
397     emit Issuer_Permitted(issuer, amount);
398   }
399 
400   /// @notice This function allows the controller to revoke issuance permission from given target
401   /// @notice permitted_issuance must be greater than zero (0)
402   /// @dev emits Issuer_Revoked event
403   /// @param issuer Target address of issuer to be revoked
404   function revoke_issuer(address issuer) public only_controller {
405     require(permitted_issuance[issuer] != 0, "issuer already revoked");
406     permitted_issuance[issuer] = 0;
407     emit Issuer_Revoked(issuer);
408   }
409 
410   /// @notice This function allows the controller to assign a new controller
411   /// @dev Emits Controller_Set event
412   /// @param new_controller Address of the new controller
413   function set_controller(address new_controller) public only_controller {
414     controller = new_controller;
415     if(permitted_issuance[new_controller] > 0){
416       permitted_issuance[new_controller] = 0;
417       emit Issuer_Revoked(new_controller);
418     }
419     emit Controller_Set(new_controller);
420   }
421 
422   /// @dev This is IStake.staking_token
423   /// @return the address of the token that is able to be staked
424   function staking_token() external override view returns (address) {
425     return v2_address;
426   }
427 
428   /// @dev This is IStake.stake_balance
429   /// @param target Target address to check
430   /// @param vega_public_key Target vega public key to check
431   /// @return the number of tokens staked for that address->vega_public_key pair
432   function stake_balance(address target, bytes32 vega_public_key) external override view returns (uint256) {
433     return user_stats[target].stake[vega_public_key];
434   }
435 
436   /// @dev This is IStake.total_staked
437   /// @return total tokens staked on contract
438   function total_staked() external override view returns (uint256) {
439     return total_staked_tokens;
440   }
441 
442   /// @notice this modifier requires that msg.sender is the controller of this contract
443   modifier only_controller {
444          require( msg.sender == controller, "not controller" );
445          _;
446   }
447 
448   /// @notice this modifier requires that msg.sender is the controller of this contract or has a permitted issuance remaining of more than zero (0)
449   modifier controller_or_issuer {
450          require( msg.sender == controller || permitted_issuance[msg.sender] > 0,"not controller or issuer" );
451          _;
452   }
453 }
454 
455 /**
456 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
457 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
458 MMMMWEMMMMMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
459 MMMMMMLOVEMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
460 MMMMMMMMMMHIXELMMMMMMMMMMMM....................MMMMMNNMMMMMM
461 MMMMMMMMMMMMMMMMMMMMMMMMMMM....................MMMMMMMMMMMMM
462 MMMMMMMMMMMMMMMMMMMMMM88=........................+MMMMMMMMMM
463 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
464 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
465 MMMMMMMMMMMM.........................MM+..MMM....+MMMMMMMMMM
466 MMMMMMMMMNMM...................... ..MM?..MMM.. .+MMMMMMMMMM
467 MMMMNDDMM+........................+MM........MM..+MMMMMMMMMM
468 MMMMZ.............................+MM....................MMM
469 MMMMZ.............................+MM....................MMM
470 MMMMZ.............................+MM....................DDD
471 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
472 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
473 MM..............................MMZ....ZMMMMMMMMMMMMMMMMMMMM
474 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
475 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
476 MM......................ZMMMMM.......MMMMMMMMMMMMMMMMMMMMMMM
477 MM............... ......ZMMMMM.... ..MMMMMMMMMMMMMMMMMMMMMMM
478 MM...............MMMMM88~.........+MM..ZMMMMMMMMMMMMMMMMMMMM
479 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
480 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
481 MM.......ZMMMMMMM.......ZMMMMM..MMMMM..ZMMMMMMMMMMMMMMMMMMMM
482 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
483 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
484 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
485 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM*/