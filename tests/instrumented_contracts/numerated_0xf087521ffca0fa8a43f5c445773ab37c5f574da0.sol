1 // SPDX-License-Identifier: GPL-3.0
2 // This program is free software: you can redistribute it and/or modify
3 // it under the terms of the GNU General Public License as published by
4 // the Free Software Foundation, either version 3 of the License, or
5 // (at your option) any later version.
6 
7 // This program is distributed in the hope that it will be useful,
8 // but WITHOUT ANY WARRANTY; without even the implied warranty of
9 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
10 // GNU General Public License for more details.
11 
12 // You should have received a copy of the GNU General Public License
13 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
14 
15 pragma solidity ^0.8.0;
16 
17 /// @dev Interface of the ERC20 standard as defined in the EIP.
18 /// @dev This includes the optional name, symbol, and decimals metadata.
19 interface IERC20 {
20     /// @dev Emitted when `value` tokens are moved from one account (`from`) to another (`to`).
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     /// @dev Emitted when the allowance of a `spender` for an `owner` is set, where `value`
24     /// is the new allowance.
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     /// @notice Returns the amount of tokens in existence.
28     function totalSupply() external view returns (uint256);
29 
30     /// @notice Returns the amount of tokens owned by `account`.
31     function balanceOf(address account) external view returns (uint256);
32 
33     /// @notice Moves `amount` tokens from the caller's account to `to`.
34     function transfer(address to, uint256 amount) external returns (bool);
35 
36     /// @notice Returns the remaining number of tokens that `spender` is allowed
37     /// to spend on behalf of `owner`
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /// @notice Sets `amount` as the allowance of `spender` over the caller's tokens.
41     /// @dev Be aware of front-running risks: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
42     function approve(address spender, uint256 amount) external returns (bool);
43 
44     /// @notice Moves `amount` tokens from `from` to `to` using the allowance mechanism.
45     /// `amount` is then deducted from the caller's allowance.
46     function transferFrom(address from, address to, uint256 amount) external returns (bool);
47 
48     /// @notice Returns the name of the token.
49     function name() external view returns (string memory);
50 
51     /// @notice Returns the symbol of the token.
52     function symbol() external view returns (string memory);
53 
54     /// @notice Returns the decimals places of the token.
55     function decimals() external view returns (uint8);
56 }
57 
58 /// @notice Gas optimized reentrancy protection for smart contracts.
59 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/ReentrancyGuard.sol)
60 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
61 abstract contract ReentrancyGuard {
62     uint256 private locked = 1;
63 
64     modifier nonReentrant() virtual {
65         require(locked == 1, "REENTRANCY");
66 
67         locked = 2;
68 
69         _;
70 
71         locked = 1;
72     }
73 }
74 
75 // This program is free software: you can redistribute it and/or modify
76 // it under the terms of the GNU General Public License as published by
77 // the Free Software Foundation, either version 3 of the License, or
78 // (at your option) any later version.
79 
80 // This program is distributed in the hope that it will be useful,
81 // but WITHOUT ANY WARRANTY; without even the implied warranty of
82 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
83 // GNU General Public License for more details.
84 
85 // You should have received a copy of the GNU General Public License
86 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
87 
88 // This program is free software: you can redistribute it and/or modify
89 // it under the terms of the GNU General Public License as published by
90 // the Free Software Foundation, either version 3 of the License, or
91 // (at your option) any later version.
92 
93 // This program is distributed in the hope that it will be useful,
94 // but WITHOUT ANY WARRANTY; without even the implied warranty of
95 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
96 // GNU General Public License for more details.
97 
98 // You should have received a copy of the GNU General Public License
99 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
100 
101 interface IERC20Mintable is IERC20 {
102     function mint(address to, uint256 amount) external;
103 }
104 
105 interface ITokenAdmin {
106     // solhint-disable func-name-mixedcase
107     function INITIAL_RATE() external view returns (uint256);
108 
109     function RATE_REDUCTION_TIME() external view returns (uint256);
110 
111     function RATE_REDUCTION_COEFFICIENT() external view returns (uint256);
112 
113     function RATE_DENOMINATOR() external view returns (uint256);
114 
115     // solhint-enable func-name-mixedcase
116     function getToken() external view returns (IERC20Mintable);
117 
118     function activate() external;
119 
120     function rate() external view returns (uint256);
121 
122     function startEpochTimeWrite() external returns (uint256);
123 
124     function mint(address to, uint256 amount) external;
125 }
126 
127 // https://github.com/swervefi/swerve/edit/master/packages/swerve-contracts/interfaces/IGaugeController.sol
128 
129 interface IGaugeController {
130     struct Point {
131         uint256 bias;
132         uint256 slope;
133     }
134 
135     struct VotedSlope {
136         uint256 slope;
137         uint256 power;
138         uint256 end;
139     }
140 
141     // Public variables
142     function admin() external view returns (address);
143 
144     function token() external view returns (address);
145 
146     function voting_escrow() external view returns (address);
147 
148     function n_gauge_types() external view returns (int128);
149 
150     function n_gauges() external view returns (int128);
151 
152     function gauge_type_names(int128) external view returns (string memory);
153 
154     function gauges(uint256) external view returns (address);
155 
156     function vote_user_slopes(address, address) external view returns (VotedSlope memory);
157 
158     function vote_user_power(address) external view returns (uint256);
159 
160     function last_user_vote(address, address) external view returns (uint256);
161 
162     function points_weight(address, uint256) external view returns (Point memory);
163 
164     function time_weight(address) external view returns (uint256);
165 
166     function points_sum(int128, uint256) external view returns (Point memory);
167 
168     function time_sum(uint256) external view returns (uint256);
169 
170     function points_total(uint256) external view returns (uint256);
171 
172     function time_total() external view returns (uint256);
173 
174     function points_type_weight(int128, uint256) external view returns (uint256);
175 
176     function time_type_weight(uint256) external view returns (uint256);
177 
178     // Getter functions
179     function gauge_types(address) external view returns (int128);
180 
181     function gauge_relative_weight(address) external view returns (uint256);
182 
183     function gauge_relative_weight(address, uint256) external view returns (uint256);
184 
185     function get_gauge_weight(address) external view returns (uint256);
186 
187     function get_type_weight(int128) external view returns (uint256);
188 
189     function get_total_weight() external view returns (uint256);
190 
191     function get_weights_sum_per_type(int128) external view returns (uint256);
192 
193     // External functions
194     function add_gauge(address, int128, uint256) external;
195 
196     function checkpoint() external;
197 
198     function checkpoint_gauge(address) external;
199 
200     function gauge_relative_weight_write(address) external returns (uint256);
201 
202     function gauge_relative_weight_write(address, uint256) external returns (uint256);
203 
204     function add_type(string memory, uint256) external;
205 
206     function change_type_weight(int128, uint256) external;
207 
208     function change_gauge_weight(address, uint256) external;
209 
210     function vote_for_gauge_weights(address, uint256) external;
211 
212     function change_pending_admin(address newPendingAdmin) external;
213 
214     function claim_admin() external;
215 }
216 
217 interface IMinter {
218     event Minted(address indexed recipient, address gauge, uint256 minted);
219 
220     /**
221      * @notice Returns the address of the minted token
222      */
223     function getToken() external view returns (IERC20);
224 
225     /**
226      * @notice Returns the address of the Token Admin contract
227      */
228     function getTokenAdmin() external view returns (ITokenAdmin);
229 
230     /**
231      * @notice Returns the address of the Gauge Controller
232      */
233     function getGaugeController() external view returns (IGaugeController);
234 
235     /**
236      * @notice Mint everything which belongs to `msg.sender` and send to them
237      * @param gauge `LiquidityGauge` address to get mintable amount from
238      */
239     function mint(address gauge) external returns (uint256);
240 
241     /**
242      * @notice Mint everything which belongs to `msg.sender` across multiple gauges
243      * @param gauges List of `LiquidityGauge` addresses
244      */
245     function mintMany(address[] calldata gauges) external returns (uint256);
246 
247     /**
248      * @notice Mint tokens for `user`
249      * @dev Only possible when `msg.sender` has been approved by `user` to mint on their behalf
250      * @param gauge `LiquidityGauge` address to get mintable amount from
251      * @param user Address to mint to
252      */
253     function mintFor(address gauge, address user) external returns (uint256);
254 
255     /**
256      * @notice Mint tokens for `user` across multiple gauges
257      * @dev Only possible when `msg.sender` has been approved by `user` to mint on their behalf
258      * @param gauges List of `LiquidityGauge` addresses
259      * @param user Address to mint to
260      */
261     function mintManyFor(address[] calldata gauges, address user) external returns (uint256);
262 
263     /**
264      * @notice The total number of tokens minted for `user` from `gauge`
265      */
266     function minted(address user, address gauge) external view returns (uint256);
267 
268     /**
269      * @notice Whether `minter` is approved to mint tokens for `user`
270      */
271     function getMinterApproval(address minter, address user) external view returns (bool);
272 
273     /**
274      * @notice Set whether `minter` is approved to mint tokens on your behalf
275      */
276     function setMinterApproval(address minter, bool approval) external;
277 
278     // The below functions are near-duplicates of functions available above.
279     // They are included for ABI compatibility with snake_casing as used in vyper contracts.
280     // solhint-disable func-name-mixedcase
281 
282     /**
283      * @notice Whether `minter` is approved to mint tokens for `user`
284      */
285     function allowed_to_mint_for(address minter, address user) external view returns (bool);
286 
287     /**
288      * @notice Mint everything which belongs to `msg.sender` across multiple gauges
289      * @dev This function is not recommended as `mintMany()` is more flexible and gas efficient
290      * @param gauges List of `LiquidityGauge` addresses
291      */
292     function mint_many(address[8] calldata gauges) external;
293 
294     /**
295      * @notice Mint tokens for `user`
296      * @dev Only possible when `msg.sender` has been approved by `user` to mint on their behalf
297      * @param gauge `LiquidityGauge` address to get mintable amount from
298      * @param user Address to mint to
299      */
300     function mint_for(address gauge, address user) external;
301 
302     /**
303      * @notice Toggle whether `minter` is approved to mint tokens for `user`
304      */
305     function toggle_approve_mint(address minter) external;
306 }
307 
308 // This program is free software: you can redistribute it and/or modify
309 // it under the terms of the GNU General Public License as published by
310 // the Free Software Foundation, either version 3 of the License, or
311 // (at your option) any later version.
312 
313 // This program is distributed in the hope that it will be useful,
314 // but WITHOUT ANY WARRANTY; without even the implied warranty of
315 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
316 // GNU General Public License for more details.
317 
318 // You should have received a copy of the GNU General Public License
319 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
320 
321 // For compatibility, we're keeping the same function names as in the original Curve code, including the mixed-case
322 // naming convention.
323 // solhint-disable func-name-mixedcase
324 // solhint-disable func-param-name-mixedcase
325 
326 interface ILiquidityGauge {
327     // solhint-disable-next-line var-name-mixedcase
328     event RelativeWeightCapChanged(uint256 new_relative_weight_cap);
329 
330     /**
331      * @notice Returns liquidity emissions calculated during checkpoints for the given user.
332      * @param user User address.
333      * @return uint256 token amount to issue for the address.
334      */
335     function integrate_fraction(address user) external view returns (uint256);
336 
337     /**
338      * @notice Record a checkpoint for a given user.
339      * @param user User address.
340      * @return bool Always true.
341      */
342     function user_checkpoint(address user) external returns (bool);
343 
344     /**
345      * @notice Returns true if gauge is killed; false otherwise.
346      */
347     function is_killed() external view returns (bool);
348 
349     /**
350      * @notice Kills the gauge so it cannot mint tokens.
351      */
352     function killGauge() external;
353 
354     /**
355      * @notice Unkills the gauge so it can mint tokens again.
356      */
357     function unkillGauge() external;
358 
359     /**
360      * @notice Uses the Uniswap Poor oracle to decide whether a gauge is alive
361      */
362     function makeGaugePermissionless() external;
363 
364     /**
365      * @notice Sets a new relative weight cap for the gauge.
366      * The value shall be normalized to 1e18, and not greater than MAX_RELATIVE_WEIGHT_CAP.
367      * @param relativeWeightCap New relative weight cap.
368      */
369     function setRelativeWeightCap(uint256 relativeWeightCap) external;
370 
371     /**
372      * @notice Gets the relative weight cap for the gauge.
373      */
374     function getRelativeWeightCap() external view returns (uint256);
375 
376     /**
377      * @notice Returns the gauge's relative weight for a given time, capped to its relative weight cap attribute.
378      * @param time Timestamp in the past or present.
379      */
380     function getCappedRelativeWeight(uint256 time) external view returns (uint256);
381 
382     function initialize(
383         address lpToken,
384         uint256 relativeWeightCap,
385         address votingEscrowDelegation,
386         address admin,
387         bytes32 positionKey
388     ) external;
389 
390     function change_pending_admin(address newPendingAdmin) external;
391 
392     function claim_admin() external;
393 
394     function admin() external view returns (address);
395 
396     function deposit(uint256 amount) external;
397 
398     function withdraw(uint256 amount) external;
399 
400     function balanceOf(address account) external view returns (uint256);
401 
402     function claim_rewards() external;
403 }
404 
405 contract Minter is IMinter, ReentrancyGuard {
406     IERC20 private immutable _token;
407     ITokenAdmin private immutable _tokenAdmin;
408     IGaugeController private immutable _gaugeController;
409 
410     // user -> gauge -> value
411     mapping(address => mapping(address => uint256)) private _minted;
412     // minter -> user -> can mint?
413     mapping(address => mapping(address => bool)) private _allowedMinter;
414 
415     event MinterApprovalSet(address indexed user, address indexed minter, bool approval);
416 
417     constructor(ITokenAdmin tokenAdmin, IGaugeController gaugeController) {
418         _token = tokenAdmin.getToken();
419         _tokenAdmin = tokenAdmin;
420         _gaugeController = gaugeController;
421     }
422 
423     /**
424      * @notice Returns the address of the minted token
425      */
426     function getToken() external view override returns (IERC20) {
427         return _token;
428     }
429 
430     /**
431      * @notice Returns the address of the Token Admin contract
432      */
433     function getTokenAdmin() external view override returns (ITokenAdmin) {
434         return _tokenAdmin;
435     }
436 
437     /**
438      * @notice Returns the address of the Gauge Controller
439      */
440     function getGaugeController() external view override returns (IGaugeController) {
441         return _gaugeController;
442     }
443 
444     /**
445      * @notice Mint everything which belongs to `msg.sender` and send to them
446      * @param gauge `LiquidityGauge` address to get mintable amount from
447      */
448     function mint(address gauge) external override nonReentrant returns (uint256) {
449         return _mintFor(gauge, msg.sender);
450     }
451 
452     /**
453      * @notice Mint everything which belongs to `msg.sender` across multiple gauges
454      * @param gauges List of `LiquidityGauge` addresses
455      */
456     function mintMany(address[] calldata gauges) external override nonReentrant returns (uint256) {
457         return _mintForMany(gauges, msg.sender);
458     }
459 
460     /**
461      * @notice Mint tokens for `user`
462      * @dev Only possible when `msg.sender` has been approved by `user` to mint on their behalf
463      * @param gauge `LiquidityGauge` address to get mintable amount from
464      * @param user Address to mint to
465      */
466     function mintFor(address gauge, address user) external override nonReentrant returns (uint256) {
467         require(_allowedMinter[msg.sender][user], "Caller not allowed to mint for user");
468         return _mintFor(gauge, user);
469     }
470 
471     /**
472      * @notice Mint tokens for `user` across multiple gauges
473      * @dev Only possible when `msg.sender` has been approved by `user` to mint on their behalf
474      * @param gauges List of `LiquidityGauge` addresses
475      * @param user Address to mint to
476      */
477     function mintManyFor(address[] calldata gauges, address user) external override nonReentrant returns (uint256) {
478         require(_allowedMinter[msg.sender][user], "Caller not allowed to mint for user");
479         return _mintForMany(gauges, user);
480     }
481 
482     /**
483      * @notice The total number of tokens minted for `user` from `gauge`
484      */
485     function minted(address user, address gauge) external view override returns (uint256) {
486         return _minted[user][gauge];
487     }
488 
489     /**
490      * @notice Whether `minter` is approved to mint tokens for `user`
491      */
492     function getMinterApproval(address minter, address user) external view override returns (bool) {
493         return _allowedMinter[minter][user];
494     }
495 
496     /**
497      * @notice Set whether `minter` is approved to mint tokens on your behalf
498      */
499     function setMinterApproval(address minter, bool approval) public override {
500         _setMinterApproval(minter, msg.sender, approval);
501     }
502 
503     function _setMinterApproval(address minter, address user, bool approval) private {
504         _allowedMinter[minter][user] = approval;
505         emit MinterApprovalSet(user, minter, approval);
506     }
507 
508     // Internal functions
509 
510     function _mintFor(address gauge, address user) internal returns (uint256 tokensToMint) {
511         tokensToMint = _updateGauge(gauge, user);
512         if (tokensToMint > 0) {
513             _tokenAdmin.mint(user, tokensToMint);
514         }
515     }
516 
517     function _mintForMany(address[] calldata gauges, address user) internal returns (uint256 tokensToMint) {
518         uint256 length = gauges.length;
519         for (uint256 i = 0; i < length;) {
520             tokensToMint += _updateGauge(gauges[i], user);
521 
522             unchecked {
523                 ++i;
524             }
525         }
526 
527         if (tokensToMint > 0) {
528             _tokenAdmin.mint(user, tokensToMint);
529         }
530     }
531 
532     function _updateGauge(address gauge, address user) internal returns (uint256 tokensToMint) {
533         require(_gaugeController.gauge_types(gauge) >= 0, "Gauge does not exist on Controller");
534 
535         ILiquidityGauge(gauge).user_checkpoint(user);
536         uint256 totalMint = ILiquidityGauge(gauge).integrate_fraction(user);
537         tokensToMint = totalMint - _minted[user][gauge];
538 
539         if (tokensToMint > 0) {
540             _minted[user][gauge] = totalMint;
541             emit Minted(user, gauge, totalMint);
542         }
543     }
544 
545     // The below functions are near-duplicates of functions available above.
546     // They are included for ABI compatibility with snake_casing as used in vyper contracts.
547     // solhint-disable func-name-mixedcase
548 
549     /**
550      * @notice Whether `minter` is approved to mint tokens for `user`
551      */
552     function allowed_to_mint_for(address minter, address user) external view override returns (bool) {
553         return _allowedMinter[minter][user];
554     }
555 
556     /**
557      * @notice Mint everything which belongs to `msg.sender` across multiple gauges
558      * @dev This function is not recommended as `mintMany()` is more flexible and gas efficient
559      * @param gauges List of `LiquidityGauge` addresses
560      */
561     function mint_many(address[8] calldata gauges) external override nonReentrant {
562         for (uint256 i = 0; i < 8;) {
563             if (gauges[i] == address(0)) {
564                 break;
565             }
566             _mintFor(gauges[i], msg.sender);
567 
568             unchecked {
569                 ++i;
570             }
571         }
572     }
573 
574     /**
575      * @notice Mint tokens for `user`
576      * @dev Only possible when `msg.sender` has been approved by `user` to mint on their behalf
577      * @param gauge `LiquidityGauge` address to get mintable amount from
578      * @param user Address to mint to
579      */
580     function mint_for(address gauge, address user) external override nonReentrant {
581         if (_allowedMinter[msg.sender][user]) {
582             _mintFor(gauge, user);
583         }
584     }
585 
586     /**
587      * @notice Toggle whether `minter` is approved to mint tokens for `user`
588      */
589     function toggle_approve_mint(address minter) external override {
590         setMinterApproval(minter, !_allowedMinter[minter][msg.sender]);
591     }
592 }