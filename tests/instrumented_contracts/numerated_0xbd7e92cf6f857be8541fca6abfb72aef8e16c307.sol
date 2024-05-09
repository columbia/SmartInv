1 /**
2  * This is the utility token for the Prodigy Bot, a Telegram multichain trading tool suite.
3  *
4  * https://prodigybot.io/
5  * https://t.me/ProdigySniper/
6  * https://t.me/ProdigySniperBot/
7  *
8  * $$$$$$$\                            $$\ $$\                     $$\                  $$\     
9  * $$  __$$\                           $$ |\__|                    $$ |                 $$ |    
10  * $$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$$ |$$\  $$$$$$\  $$\   $$\ $$$$$$$\   $$$$$$\ $$$$$$\   
11  * $$$$$$$  |$$  __$$\ $$  __$$\ $$  __$$ |$$ |$$  __$$\ $$ |  $$ |$$  __$$\ $$  __$$\\_$$  _|  
12  * $$  ____/ $$ |  \__|$$ /  $$ |$$ /  $$ |$$ |$$ /  $$ |$$ |  $$ |$$ |  $$ |$$ /  $$ | $$ |    
13  * $$ |      $$ |      $$ |  $$ |$$ |  $$ |$$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ | $$ |$$\ 
14  * $$ |      $$ |      \$$$$$$  |\$$$$$$$ |$$ |\$$$$$$$ |\$$$$$$$ |$$$$$$$  |\$$$$$$  | \$$$$  |
15  * \__|      \__|       \______/  \_______|\__| \____$$ | \____$$ |\_______/  \______/   \____/ 
16  *                                             $$\   $$ |$$\   $$ |                             
17  *                                             \$$$$$$  |\$$$$$$  |                             
18  *                                              \______/  \______/                              
19  */
20 
21 // SPDX-License-Identifier: MIT
22 pragma solidity >=0.7.0 <0.9.0;
23 
24 /**
25  * @notice Simple ERC20 implementation from Solady.
26  * @author Solady (https://github.com/vectorized/solady/blob/main/src/tokens/ERC20.sol)
27  * @notice EIP-2612 has been removed due to concerns of userbase not being familiar with the security risks of signatures.
28  * @notice Hooks removed since they could be called twice during tax events.
29  * @notice Burn is removed as there is no intended use.
30  */
31 abstract contract ERC20 {
32     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
33     /*                       CUSTOM ERRORS                        */
34     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
35 
36     /// @dev The total supply has overflowed.
37     error TotalSupplyOverflow();
38 
39     /// @dev The allowance has overflowed.
40     error AllowanceOverflow();
41 
42     /// @dev The allowance has underflowed.
43     error AllowanceUnderflow();
44 
45     /// @dev Insufficient balance.
46     error InsufficientBalance();
47 
48     /// @dev Insufficient allowance.
49     error InsufficientAllowance();
50 
51     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
52     /*                           EVENTS                           */
53     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
54 
55     /// @dev Emitted when `amount` tokens is transferred from `from` to `to`.
56     event Transfer(address indexed from, address indexed to, uint256 amount);
57 
58     /// @dev Emitted when `amount` tokens is approved by `owner` to be used by `spender`.
59     event Approval(address indexed owner, address indexed spender, uint256 amount);
60 
61     /// @dev `keccak256(bytes("Transfer(address,address,uint256)"))`.
62     uint256 private constant _TRANSFER_EVENT_SIGNATURE =
63         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
64 
65     /// @dev `keccak256(bytes("Approval(address,address,uint256)"))`.
66     uint256 private constant _APPROVAL_EVENT_SIGNATURE =
67         0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;
68 
69     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
70     /*                          STORAGE                           */
71     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
72 
73     /// @dev The storage slot for the total supply.
74     uint256 private constant _TOTAL_SUPPLY_SLOT = 0x05345cdf77eb68f44c;
75 
76     /// @dev The balance slot of `owner` is given by:
77     /// ```
78     ///     mstore(0x0c, _BALANCE_SLOT_SEED)
79     ///     mstore(0x00, owner)
80     ///     let balanceSlot := keccak256(0x0c, 0x20)
81     /// ```
82     uint256 private constant _BALANCE_SLOT_SEED = 0x87a211a2;
83 
84     /// @dev The allowance slot of (`owner`, `spender`) is given by:
85     /// ```
86     ///     mstore(0x20, spender)
87     ///     mstore(0x0c, _ALLOWANCE_SLOT_SEED)
88     ///     mstore(0x00, owner)
89     ///     let allowanceSlot := keccak256(0x0c, 0x34)
90     /// ```
91     uint256 private constant _ALLOWANCE_SLOT_SEED = 0x7f5e9f20;
92 
93     /// @dev The nonce slot of `owner` is given by:
94     /// ```
95     ///     mstore(0x0c, _NONCES_SLOT_SEED)
96     ///     mstore(0x00, owner)
97     ///     let nonceSlot := keccak256(0x0c, 0x20)
98     /// ```
99     uint256 private constant _NONCES_SLOT_SEED = 0x38377508;
100 
101     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
102     /*                       ERC20 METADATA                       */
103     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
104 
105     /// @dev Returns the name of the token.
106     function name() public view virtual returns (string memory);
107 
108     /// @dev Returns the symbol of the token.
109     function symbol() public view virtual returns (string memory);
110 
111     /// @dev Returns the decimals places of the token.
112     function decimals() public view virtual returns (uint8) {
113         return 18;
114     }
115 
116     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
117     /*                           ERC20                            */
118     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
119 
120     /// @dev Returns the amount of tokens in existence.
121     function totalSupply() public view virtual returns (uint256 result) {
122         /// @solidity memory-safe-assembly
123         assembly {
124             result := sload(_TOTAL_SUPPLY_SLOT)
125         }
126     }
127 
128     /// @dev Returns the amount of tokens owned by `owner`.
129     function balanceOf(address owner) public view virtual returns (uint256 result) {
130         /// @solidity memory-safe-assembly
131         assembly {
132             mstore(0x0c, _BALANCE_SLOT_SEED)
133             mstore(0x00, owner)
134             result := sload(keccak256(0x0c, 0x20))
135         }
136     }
137 
138     /// @dev Returns the amount of tokens that `spender` can spend on behalf of `owner`.
139     function allowance(address owner, address spender)
140         public
141         view
142         virtual
143         returns (uint256 result)
144     {
145         /// @solidity memory-safe-assembly
146         assembly {
147             mstore(0x20, spender)
148             mstore(0x0c, _ALLOWANCE_SLOT_SEED)
149             mstore(0x00, owner)
150             result := sload(keccak256(0x0c, 0x34))
151         }
152     }
153 
154     /// @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
155     ///
156     /// Emits a {Approval} event.
157     function approve(address spender, uint256 amount) public virtual returns (bool) {
158         /// @solidity memory-safe-assembly
159         assembly {
160             // Compute the allowance slot and store the amount.
161             mstore(0x20, spender)
162             mstore(0x0c, _ALLOWANCE_SLOT_SEED)
163             mstore(0x00, caller())
164             sstore(keccak256(0x0c, 0x34), amount)
165             // Emit the {Approval} event.
166             mstore(0x00, amount)
167             log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, caller(), shr(96, mload(0x2c)))
168         }
169         return true;
170     }
171 
172     /// @dev Atomically increases the allowance granted to `spender` by the caller.
173     ///
174     /// Emits a {Approval} event.
175     function increaseAllowance(address spender, uint256 difference) public virtual returns (bool) {
176         /// @solidity memory-safe-assembly
177         assembly {
178             // Compute the allowance slot and load its value.
179             mstore(0x20, spender)
180             mstore(0x0c, _ALLOWANCE_SLOT_SEED)
181             mstore(0x00, caller())
182             let allowanceSlot := keccak256(0x0c, 0x34)
183             let allowanceBefore := sload(allowanceSlot)
184             // Add to the allowance.
185             let allowanceAfter := add(allowanceBefore, difference)
186             // Revert upon overflow.
187             if lt(allowanceAfter, allowanceBefore) {
188                 mstore(0x00, 0xf9067066) // `AllowanceOverflow()`.
189                 revert(0x1c, 0x04)
190             }
191             // Store the updated allowance.
192             sstore(allowanceSlot, allowanceAfter)
193             // Emit the {Approval} event.
194             mstore(0x00, allowanceAfter)
195             log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, caller(), shr(96, mload(0x2c)))
196         }
197         return true;
198     }
199 
200     /// @dev Atomically decreases the allowance granted to `spender` by the caller.
201     ///
202     /// Emits a {Approval} event.
203     function decreaseAllowance(address spender, uint256 difference) public virtual returns (bool) {
204         /// @solidity memory-safe-assembly
205         assembly {
206             // Compute the allowance slot and load its value.
207             mstore(0x20, spender)
208             mstore(0x0c, _ALLOWANCE_SLOT_SEED)
209             mstore(0x00, caller())
210             let allowanceSlot := keccak256(0x0c, 0x34)
211             let allowanceBefore := sload(allowanceSlot)
212             // Revert if will underflow.
213             if lt(allowanceBefore, difference) {
214                 mstore(0x00, 0x8301ab38) // `AllowanceUnderflow()`.
215                 revert(0x1c, 0x04)
216             }
217             // Subtract and store the updated allowance.
218             let allowanceAfter := sub(allowanceBefore, difference)
219             sstore(allowanceSlot, allowanceAfter)
220             // Emit the {Approval} event.
221             mstore(0x00, allowanceAfter)
222             log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, caller(), shr(96, mload(0x2c)))
223         }
224         return true;
225     }
226 
227     /// @dev Transfer `amount` tokens from the caller to `to`.
228     ///
229     /// Requirements:
230     /// - `from` must at least have `amount`.
231     ///
232     /// Emits a {Transfer} event.
233     function transfer(address to, uint256 amount) public virtual returns (bool) {
234         /// @solidity memory-safe-assembly
235         assembly {
236             // Compute the balance slot and load its value.
237             mstore(0x0c, _BALANCE_SLOT_SEED)
238             mstore(0x00, caller())
239             let fromBalanceSlot := keccak256(0x0c, 0x20)
240             let fromBalance := sload(fromBalanceSlot)
241             // Revert if insufficient balance.
242             if gt(amount, fromBalance) {
243                 mstore(0x00, 0xf4d678b8) // `InsufficientBalance()`.
244                 revert(0x1c, 0x04)
245             }
246             // Subtract and store the updated balance.
247             sstore(fromBalanceSlot, sub(fromBalance, amount))
248             // Compute the balance slot of `to`.
249             mstore(0x00, to)
250             let toBalanceSlot := keccak256(0x0c, 0x20)
251             // Add and store the updated balance of `to`.
252             // Will not overflow because the sum of all user balances
253             // cannot exceed the maximum uint256 value.
254             sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))
255             // Emit the {Transfer} event.
256             mstore(0x20, amount)
257             log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, caller(), shr(96, mload(0x0c)))
258         }
259         return true;
260     }
261 
262     /// @dev Transfers `amount` tokens from `from` to `to`.
263     ///
264     /// Note: Does not update the allowance if it is the maximum uint256 value.
265     ///
266     /// Requirements:
267     /// - `from` must at least have `amount`.
268     /// - The caller must have at least `amount` of allowance to transfer the tokens of `from`.
269     ///
270     /// Emits a {Transfer} event.
271     function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
272         /// @solidity memory-safe-assembly
273         assembly {
274             let from_ := shl(96, from)
275             // Compute the allowance slot and load its value.
276             mstore(0x20, caller())
277             mstore(0x0c, or(from_, _ALLOWANCE_SLOT_SEED))
278             let allowanceSlot := keccak256(0x0c, 0x34)
279             let allowance_ := sload(allowanceSlot)
280             // If the allowance is not the maximum uint256 value.
281             if iszero(eq(allowance_, not(0))) {
282                 // Revert if the amount to be transferred exceeds the allowance.
283                 if gt(amount, allowance_) {
284                     mstore(0x00, 0x13be252b) // `InsufficientAllowance()`.
285                     revert(0x1c, 0x04)
286                 }
287                 // Subtract and store the updated allowance.
288                 sstore(allowanceSlot, sub(allowance_, amount))
289             }
290             // Compute the balance slot and load its value.
291             mstore(0x0c, or(from_, _BALANCE_SLOT_SEED))
292             let fromBalanceSlot := keccak256(0x0c, 0x20)
293             let fromBalance := sload(fromBalanceSlot)
294             // Revert if insufficient balance.
295             if gt(amount, fromBalance) {
296                 mstore(0x00, 0xf4d678b8) // `InsufficientBalance()`.
297                 revert(0x1c, 0x04)
298             }
299             // Subtract and store the updated balance.
300             sstore(fromBalanceSlot, sub(fromBalance, amount))
301             // Compute the balance slot of `to`.
302             mstore(0x00, to)
303             let toBalanceSlot := keccak256(0x0c, 0x20)
304             // Add and store the updated balance of `to`.
305             // Will not overflow because the sum of all user balances
306             // cannot exceed the maximum uint256 value.
307             sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))
308             // Emit the {Transfer} event.
309             mstore(0x20, amount)
310             log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, shr(96, from_), shr(96, mload(0x0c)))
311         }
312         return true;
313     }
314 
315     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
316     /*                  INTERNAL MINT FUNCTIONS                   */
317     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
318 
319     /// @dev Mints `amount` tokens to `to`, increasing the total supply.
320     ///
321     /// Emits a {Transfer} event.
322     function _mint(address to, uint256 amount) internal virtual {
323         /// @solidity memory-safe-assembly
324         assembly {
325             let totalSupplyBefore := sload(_TOTAL_SUPPLY_SLOT)
326             let totalSupplyAfter := add(totalSupplyBefore, amount)
327             // Revert if the total supply overflows.
328             if lt(totalSupplyAfter, totalSupplyBefore) {
329                 mstore(0x00, 0xe5cfe957) // `TotalSupplyOverflow()`.
330                 revert(0x1c, 0x04)
331             }
332             // Store the updated total supply.
333             sstore(_TOTAL_SUPPLY_SLOT, totalSupplyAfter)
334             // Compute the balance slot and load its value.
335             mstore(0x0c, _BALANCE_SLOT_SEED)
336             mstore(0x00, to)
337             let toBalanceSlot := keccak256(0x0c, 0x20)
338             // Add and store the updated balance.
339             sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))
340             // Emit the {Transfer} event.
341             mstore(0x20, amount)
342             log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, 0, shr(96, mload(0x0c)))
343         }
344     }
345 
346     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
347     /*                INTERNAL TRANSFER FUNCTIONS                 */
348     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
349 
350     /// @dev Moves `amount` of tokens from `from` to `to`.
351     function _transfer(address from, address to, uint256 amount) internal virtual {
352         /// @solidity memory-safe-assembly
353         assembly {
354             let from_ := shl(96, from)
355             // Compute the balance slot and load its value.
356             mstore(0x0c, or(from_, _BALANCE_SLOT_SEED))
357             let fromBalanceSlot := keccak256(0x0c, 0x20)
358             let fromBalance := sload(fromBalanceSlot)
359             // Revert if insufficient balance.
360             if gt(amount, fromBalance) {
361                 mstore(0x00, 0xf4d678b8) // `InsufficientBalance()`.
362                 revert(0x1c, 0x04)
363             }
364             // Subtract and store the updated balance.
365             sstore(fromBalanceSlot, sub(fromBalance, amount))
366             // Compute the balance slot of `to`.
367             mstore(0x00, to)
368             let toBalanceSlot := keccak256(0x0c, 0x20)
369             // Add and store the updated balance of `to`.
370             // Will not overflow because the sum of all user balances
371             // cannot exceed the maximum uint256 value.
372             sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))
373             // Emit the {Transfer} event.
374             mstore(0x20, amount)
375             log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, shr(96, from_), shr(96, mload(0x0c)))
376         }
377     }
378 
379     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
380     /*                INTERNAL ALLOWANCE FUNCTIONS                */
381     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
382 
383     /// @dev Updates the allowance of `owner` for `spender` based on spent `amount`.
384     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
385         /// @solidity memory-safe-assembly
386         assembly {
387             // Compute the allowance slot and load its value.
388             mstore(0x20, spender)
389             mstore(0x0c, _ALLOWANCE_SLOT_SEED)
390             mstore(0x00, owner)
391             let allowanceSlot := keccak256(0x0c, 0x34)
392             let allowance_ := sload(allowanceSlot)
393             // If the allowance is not the maximum uint256 value.
394             if iszero(eq(allowance_, not(0))) {
395                 // Revert if the amount to be transferred exceeds the allowance.
396                 if gt(amount, allowance_) {
397                     mstore(0x00, 0x13be252b) // `InsufficientAllowance()`.
398                     revert(0x1c, 0x04)
399                 }
400                 // Subtract and store the updated allowance.
401                 sstore(allowanceSlot, sub(allowance_, amount))
402             }
403         }
404     }
405 
406     /// @dev Sets `amount` as the allowance of `spender` over the tokens of `owner`.
407     ///
408     /// Emits a {Approval} event.
409     function _approve(address owner, address spender, uint256 amount) internal virtual {
410         /// @solidity memory-safe-assembly
411         assembly {
412             let owner_ := shl(96, owner)
413             // Compute the allowance slot and store the amount.
414             mstore(0x20, spender)
415             mstore(0x0c, or(owner_, _ALLOWANCE_SLOT_SEED))
416             sstore(keccak256(0x0c, 0x34), amount)
417             // Emit the {Approval} event.
418             mstore(0x00, amount)
419             log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, shr(96, owner_), shr(96, mload(0x2c)))
420         }
421     }
422 }
423 
424 /**
425  * @notice Simple single owner authorization mixin.
426  * @author Solady (https://github.com/vectorized/solady/blob/main/src/auth/Ownable.sol)
427  */
428 abstract contract Ownable {
429     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
430     /*                       CUSTOM ERRORS                        */
431     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
432 
433     /// @dev The caller is not authorized to call the function.
434     error Unauthorized();
435 
436     /// @dev The `newOwner` cannot be the zero address.
437     error NewOwnerIsZeroAddress();
438 
439     /// @dev The `pendingOwner` does not have a valid handover request.
440     error NoHandoverRequest();
441 
442     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
443     /*                           EVENTS                           */
444     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
445 
446     /// @dev The ownership is transferred from `oldOwner` to `newOwner`.
447     /// This event is intentionally kept the same as OpenZeppelin's Ownable to be
448     /// compatible with indexers and [EIP-173](https://eips.ethereum.org/EIPS/eip-173),
449     /// despite it not being as lightweight as a single argument event.
450     event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
451 
452     /// @dev An ownership handover to `pendingOwner` has been requested.
453     event OwnershipHandoverRequested(address indexed pendingOwner);
454 
455     /// @dev The ownership handover to `pendingOwner` has been canceled.
456     event OwnershipHandoverCanceled(address indexed pendingOwner);
457 
458     /// @dev `keccak256(bytes("OwnershipTransferred(address,address)"))`.
459     uint256 private constant _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE =
460         0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0;
461 
462     /// @dev `keccak256(bytes("OwnershipHandoverRequested(address)"))`.
463     uint256 private constant _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE =
464         0xdbf36a107da19e49527a7176a1babf963b4b0ff8cde35ee35d6cd8f1f9ac7e1d;
465 
466     /// @dev `keccak256(bytes("OwnershipHandoverCanceled(address)"))`.
467     uint256 private constant _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE =
468         0xfa7b8eab7da67f412cc9575ed43464468f9bfbae89d1675917346ca6d8fe3c92;
469 
470     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
471     /*                          STORAGE                           */
472     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
473 
474     /// @dev The owner slot is given by: `not(_OWNER_SLOT_NOT)`.
475     /// It is intentionally chosen to be a high value
476     /// to avoid collision with lower slots.
477     /// The choice of manual storage layout is to enable compatibility
478     /// with both regular and upgradeable contracts.
479     uint256 private constant _OWNER_SLOT_NOT = 0x8b78c6d8;
480 
481     /// The ownership handover slot of `newOwner` is given by:
482     /// ```
483     ///     mstore(0x00, or(shl(96, user), _HANDOVER_SLOT_SEED))
484     ///     let handoverSlot := keccak256(0x00, 0x20)
485     /// ```
486     /// It stores the expiry timestamp of the two-step ownership handover.
487     uint256 private constant _HANDOVER_SLOT_SEED = 0x389a75e1;
488 
489     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
490     /*                     INTERNAL FUNCTIONS                     */
491     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
492 
493     /// @dev Initializes the owner directly without authorization guard.
494     /// This function must be called upon initialization,
495     /// regardless of whether the contract is upgradeable or not.
496     /// This is to enable generalization to both regular and upgradeable contracts,
497     /// and to save gas in case the initial owner is not the caller.
498     /// For performance reasons, this function will not check if there
499     /// is an existing owner.
500     function _initializeOwner(address newOwner) internal virtual {
501         /// @solidity memory-safe-assembly
502         assembly {
503             // Clean the upper 96 bits.
504             newOwner := shr(96, shl(96, newOwner))
505             // Store the new value.
506             sstore(not(_OWNER_SLOT_NOT), newOwner)
507             // Emit the {OwnershipTransferred} event.
508             log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, 0, newOwner)
509         }
510     }
511 
512     /// @dev Sets the owner directly without authorization guard.
513     function _setOwner(address newOwner) internal virtual {
514         /// @solidity memory-safe-assembly
515         assembly {
516             let ownerSlot := not(_OWNER_SLOT_NOT)
517             // Clean the upper 96 bits.
518             newOwner := shr(96, shl(96, newOwner))
519             // Emit the {OwnershipTransferred} event.
520             log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, sload(ownerSlot), newOwner)
521             // Store the new value.
522             sstore(ownerSlot, newOwner)
523         }
524     }
525 
526     /// @dev Throws if the sender is not the owner.
527     function _checkOwner() internal view virtual {
528         /// @solidity memory-safe-assembly
529         assembly {
530             // If the caller is not the stored owner, revert.
531             if iszero(eq(caller(), sload(not(_OWNER_SLOT_NOT)))) {
532                 mstore(0x00, 0x82b42900) // `Unauthorized()`.
533                 revert(0x1c, 0x04)
534             }
535         }
536     }
537 
538     /// @dev Returns how long a two-step ownership handover is valid for in seconds.
539     /// Override to return a different value if needed.
540     /// Made internal to conserve bytecode. Wrap it in a public function if needed.
541     function _ownershipHandoverValidFor() internal view virtual returns (uint64) {
542         return 48 * 3600;
543     }
544 
545     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
546     /*                  PUBLIC UPDATE FUNCTIONS                   */
547     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
548 
549     /// @dev Allows the owner to transfer the ownership to `newOwner`.
550     function transferOwnership(address newOwner) public payable virtual onlyOwner {
551         /// @solidity memory-safe-assembly
552         assembly {
553             if iszero(shl(96, newOwner)) {
554                 mstore(0x00, 0x7448fbae) // `NewOwnerIsZeroAddress()`.
555                 revert(0x1c, 0x04)
556             }
557         }
558         _setOwner(newOwner);
559     }
560 
561     /// @dev Allows the owner to renounce their ownership.
562     function renounceOwnership() public payable virtual onlyOwner {
563         _setOwner(address(0));
564     }
565 
566     /// @dev Request a two-step ownership handover to the caller.
567     /// The request will automatically expire in 48 hours (172800 seconds) by default.
568     function requestOwnershipHandover() public payable virtual {
569         unchecked {
570             uint256 expires = block.timestamp + _ownershipHandoverValidFor();
571             /// @solidity memory-safe-assembly
572             assembly {
573                 // Compute and set the handover slot to `expires`.
574                 mstore(0x0c, _HANDOVER_SLOT_SEED)
575                 mstore(0x00, caller())
576                 sstore(keccak256(0x0c, 0x20), expires)
577                 // Emit the {OwnershipHandoverRequested} event.
578                 log2(0, 0, _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE, caller())
579             }
580         }
581     }
582 
583     /// @dev Cancels the two-step ownership handover to the caller, if any.
584     function cancelOwnershipHandover() public payable virtual {
585         /// @solidity memory-safe-assembly
586         assembly {
587             // Compute and set the handover slot to 0.
588             mstore(0x0c, _HANDOVER_SLOT_SEED)
589             mstore(0x00, caller())
590             sstore(keccak256(0x0c, 0x20), 0)
591             // Emit the {OwnershipHandoverCanceled} event.
592             log2(0, 0, _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE, caller())
593         }
594     }
595 
596     /// @dev Allows the owner to complete the two-step ownership handover to `pendingOwner`.
597     /// Reverts if there is no existing ownership handover requested by `pendingOwner`.
598     function completeOwnershipHandover(address pendingOwner) public payable virtual onlyOwner {
599         /// @solidity memory-safe-assembly
600         assembly {
601             // Compute and set the handover slot to 0.
602             mstore(0x0c, _HANDOVER_SLOT_SEED)
603             mstore(0x00, pendingOwner)
604             let handoverSlot := keccak256(0x0c, 0x20)
605             // If the handover does not exist, or has expired.
606             if gt(timestamp(), sload(handoverSlot)) {
607                 mstore(0x00, 0x6f5e8818) // `NoHandoverRequest()`.
608                 revert(0x1c, 0x04)
609             }
610             // Set the handover slot to 0.
611             sstore(handoverSlot, 0)
612         }
613         _setOwner(pendingOwner);
614     }
615 
616     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
617     /*                   PUBLIC READ FUNCTIONS                    */
618     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
619 
620     /// @dev Returns the owner of the contract.
621     function owner() public view virtual returns (address result) {
622         /// @solidity memory-safe-assembly
623         assembly {
624             result := sload(not(_OWNER_SLOT_NOT))
625         }
626     }
627 
628     /// @dev Returns the expiry timestamp for the two-step ownership handover to `pendingOwner`.
629     function ownershipHandoverExpiresAt(address pendingOwner)
630         public
631         view
632         virtual
633         returns (uint256 result)
634     {
635         /// @solidity memory-safe-assembly
636         assembly {
637             // Compute the handover slot.
638             mstore(0x0c, _HANDOVER_SLOT_SEED)
639             mstore(0x00, pendingOwner)
640             // Load the handover slot.
641             result := sload(keccak256(0x0c, 0x20))
642         }
643     }
644 
645     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
646     /*                         MODIFIERS                          */
647     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
648 
649     /// @dev Marks a function as only callable by the owner.
650     modifier onlyOwner() virtual {
651         _checkOwner();
652         _;
653     }
654 }
655 
656 /**
657  * @notice Interface for UniV2 router.
658  */
659 interface IDexRouter {
660 	function factory() external pure returns (address);
661 	function WETH() external pure returns (address);
662 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
663 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
664 }
665 
666 /**
667  * @notice The prodigy bot utility token.
668  * @author ProdigyBot
669  */
670 contract ProdigyBot is ERC20, Ownable {
671 
672 	struct FeeSettings {
673 		uint8 buyLiqFee;
674 		uint8 buyDevFee;
675 		uint8 sellLiqFee;
676 		uint8 sellDevFee;
677 	}
678 
679 	bool public autoLiqActive = true;
680 	bool public swapActive = true;
681 	bool private _inSwap = false;
682 	address public autoliqReceiver;
683 	address public devFeeReceiver;
684 	address private _pair;
685 	bool public limited;
686 	uint256 public launchBlock;
687 	uint256 private _maxTx;
688 	uint256 private _swapTrigger;
689 	uint256 private _swapAmount;
690 	FeeSettings public fees;
691 	address private _router;
692 	mapping (address => bool) private _taxExempt;
693 	mapping (address => bool) private _silicon;
694 
695 	error ExceedsLimits();
696 	error ReentrantSwap();
697 
698 	modifier notSwapping {
699 		if (_inSwap) {
700 			revert ReentrantSwap();
701 		}
702 		_inSwap = true;
703 		_;
704 		_inSwap = false;
705 	}
706 
707 	constructor(address router) {
708 		// Init the owner.
709 		_initializeOwner(msg.sender);
710 		/**
711 		 * Init the total supply.
712 		 * See implementation in ERC20 contract above.
713 		 * This is only called in this constructor.
714 		 * It cannot be called againt.
715 		 */
716 		_mint(msg.sender, 1_000_000 ether);
717 		_router = router;
718 		// Approve for contract swaps and initial liq add.
719 		_approve(address(this), router, type(uint256).max);
720 		_approve(msg.sender, router, type(uint256).max);
721 		// Initial fees.
722 		_taxExempt[msg.sender] = true;
723 		_taxExempt[address(this)] = true;
724 		fees.buyDevFee = 3;
725 		fees.buyLiqFee = 2;
726 		fees.sellDevFee = 3;
727 		fees.sellLiqFee = 2;
728 		// Initial swapback value.
729 		_swapAmount = totalSupply();
730 		_swapTrigger = totalSupply() / 1000;
731 	}
732 
733 	function name() public pure override returns (string memory) {
734 		return "Prodigy Bot";
735 	}
736 
737     function symbol() public pure override returns (string memory) {
738 		return "PRO";
739 	}
740 
741 	function release(address pair) external onlyOwner {
742 		require(launchBlock == 0, "Already launched!");
743 		launchBlock = block.number;
744 		_pair = pair;
745 	}
746 
747 	/**
748 	 * @notice While normaly trading through router uses `transferFrom`, direct trades with pair use `transfer`.
749 	 * Thus, limits and tax status must be checked on both.
750 	 * While there is some duplicity, transfer must not update allowances, but transferFrom must.
751 	 */
752 	function transfer(address to, uint256 amount) public override returns (bool) {
753 		_checkForLimits(msg.sender, to, amount);
754 
755 		// Transfer with fee.
756 		bool isEitherBot = _silicon[msg.sender] || _silicon[to];
757 		if (isEitherBot || _hasFee(msg.sender, to)) {
758 			uint256 fee = _feeAmount(msg.sender == _pair, amount, isEitherBot);
759 			if (fee > 0) {
760 				unchecked {
761 					// Fee is always less than amount and at most 10% of it.
762 					amount = amount - fee;
763 				}
764 				super._transfer(msg.sender, address(this), fee);
765 			}
766 			if (to == _pair) {
767 				_checkPerformSwap();
768 			}
769 		}
770 
771 		// Base class ERC20 checks for balance.
772 		return super.transfer(to, amount);
773 	}
774 
775 	function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
776 		_checkForLimits(from, to, amount);
777 
778 		// Transfer from with fee.
779 		bool isEitherBot = _silicon[from] || _silicon[to];
780 		if (isEitherBot || _hasFee(from, to)) {
781 			_transferFrom(from, to, amount, isEitherBot);
782 			return true;
783 		}
784 
785 		// Regular non taxed transferFrom. Straight from base class.
786 		// Base class ERC20 checks for allowance and balance of sender.
787 		// It also updates the allowance.
788 		return super.transferFrom(from, to, amount);
789 	}
790 
791 	function _transferFrom(address from, address to, uint256 amount, bool isEitherBot) private {
792 		/**
793 		 * In the case of a transfer from with fees, we deal here with approval.
794 		 * Since there are actually two transfers, but we want one read and one allowance update.
795 		 */
796 		uint256 allowed = allowance(from, msg.sender);
797 		if (allowance(from, msg.sender) < amount) {
798 			revert InsufficientAllowance();
799 		}
800 		// Do not spend allowance if it's set to uint256 max.
801 		if (allowed != type(uint256).max) {
802 			_spendAllowance(from, msg.sender, amount);
803 		}
804 
805 		uint256 fee = _feeAmount(from == _pair, amount, isEitherBot);
806 		if (fee > 0) {
807 			unchecked {
808 				// Fee is always less than amount and at most 10% of it.
809 				amount = amount - fee;
810 			}
811 			/**
812 			 * Fee is a separate transfer event.
813 			 * This costs extra gas but the events must report all individual token transactions.
814 			 * This also makes etherscan keep proper track of balances and is a good practise.
815 			 */
816 			super._transfer(from, address(this), fee);
817 		}
818 		if (to == _pair) {
819 			_checkPerformSwap();
820 		}
821 		super._transfer(from, to, amount);
822 	}
823 
824 	/**
825 	 * @dev Wallet and tx limitations for launch.
826 	 */
827 	function _checkForLimits(address sender, address recipient, uint256 amount) private view {
828 		if (limited && sender != owner() && sender != address(this)) {
829 			// Same max for tx and wallet.
830 			uint256 max = _maxTx;
831 			bool recipientImmune = _isImmuneToWalletLimit(recipient);
832 			if (amount > max || (!recipientImmune && balanceOf(recipient) + amount > max)) {
833 				revert ExceedsLimits();
834 			}
835 		}
836 	}
837 
838 	/**
839 	 * @dev Check whether transaction is subject to AMM trading fee.
840 	 */
841 	function _hasFee(address sender, address recipient) private view returns (bool) {
842 		address pair = _pair;
843 		return (sender == pair || recipient == pair || launchBlock == 0) && !_taxExempt[sender] && !_taxExempt[recipient];
844 	}
845 
846 	/**
847 	 * @dev Calculate fee amount for an AMM trade.
848 	 */
849 	function _feeAmount(bool isBuy, uint256 amount, bool isEitherBot) private view returns (uint256) {
850 		if (amount == 0) {
851 			return 0;
852 		}
853 		uint256 feePct = _getFeePct(isBuy, isEitherBot);
854 		if (feePct > 0) {
855 			return amount * feePct / 100;
856 		}
857 		return 0;
858 	}
859 
860 	/**
861 	 * @dev Check whether to perform a contract swap.
862 	 */
863 	function _checkPerformSwap() private {
864 		uint256 contractBalance = balanceOf(address(this));
865 		if (swapActive && !_inSwap && contractBalance >= _swapTrigger) {
866 			uint256 swappingAmount = _swapAmount;
867 			if (swappingAmount > 0) {
868 				swappingAmount = swappingAmount > contractBalance ? contractBalance : swappingAmount;
869 				_swapAndLiq(swappingAmount);
870 			}
871 		}
872 	}
873 
874 	/**
875 	 * @dev Calculate trade fee percent.
876 	 */
877 	function _getFeePct(bool isBuy, bool isEitherBot) private view returns (uint256) {
878 		// For MEV bots and such.
879 		if (isEitherBot) {
880 			return isBuy ? 25 : 80;
881 		}
882 		// Before launch.
883 		if (launchBlock == 0) {
884 			return isBuy ? 25 : 66;
885 		}
886 		// Buy fees.
887 		if (isBuy) {
888 			return fees.buyDevFee + fees.buyLiqFee;
889 		}
890 		// Sell fees.
891 		return fees.sellDevFee + fees.sellLiqFee;
892 	}
893 
894 	/**
895 	 * @notice These special addresses are immune to wallet token limits even during limited.
896 	 */
897 	function _isImmuneToWalletLimit(address receiver) private view returns (bool) {
898 		return receiver == address(this)
899 			|| receiver == address(0)
900 			|| receiver == address(0xdead)
901 			|| receiver == _pair
902 			|| receiver == owner();
903 	}
904 
905 	function _swapAndLiq(uint256 swapAmount) private notSwapping {
906 		// If this is active, sales that lead to swaps will add some liquidity from the taxed tokens.
907 		if (autoLiqActive) {
908 			uint256 total = fees.sellDevFee + fees.sellLiqFee;
909 			uint256 forLiquidity = (swapAmount * fees.sellLiqFee / total) / 2;
910 			uint256 balanceBefore = address(this).balance;
911 			_swap(swapAmount - forLiquidity);
912 			uint256 balanceChange = address(this).balance - balanceBefore;
913 			_addLiquidity(forLiquidity, balanceChange * forLiquidity / swapAmount);
914 		} else {
915 			_swap(swapAmount);
916 		}
917 		_collectDevProceedings();
918 	}
919 
920 	receive() external payable {}
921 
922 	function _swap(uint256 amount) private {
923 		address[] memory path = new address[](2);
924 		path[0] = address(this);
925 		IDexRouter router = IDexRouter(_router);
926 		path[1] = router.WETH();
927 		router.swapExactTokensForETHSupportingFeeOnTransferTokens(
928 			amount,
929 			0,
930 			path,
931 			address(this),
932 			block.timestamp
933 		);
934 	}
935 
936 	function _addLiquidity(uint256 tokens, uint256 eth) private {
937 		IDexRouter(_router).addLiquidityETH{value: eth}(
938 			address(this),
939 			tokens,
940 			0,
941 			0,
942 			autoliqReceiver,
943 			block.timestamp
944 		);
945 	}
946 
947 	/**
948 	 * @notice Sends fees accrued to developer wallet for server, development, and marketing expenses.
949 	 */
950 	function _collectDevProceedings() private {
951 		devFeeReceiver.call{value: address(this).balance}("");
952 	}
953 
954 	/**
955 	 * @notice Control automated malicious value subtracting bots such as MEV so they cannot profit out of the token.
956 	 */
957 	function isSiliconBased(address silly, bool isIt) external onlyOwner {
958 		require(!isIt || launchBlock == 0 || block.number - launchBlock < 14000, "Can only be done during launch.");
959 		_silicon[silly] = isIt;
960 	}
961 
962 	function manySuchCases(address[] calldata malevolent) external onlyOwner {
963 		require(launchBlock == 0 || block.number - launchBlock < 14000, "Can only be done during launch.");
964 		for (uint256 i = 0; i < malevolent.length; i++) {
965 			_silicon[malevolent[i]] = true;
966 		}
967 	}
968 
969 	/**
970 	 * @notice Whether the transactions and wallets are limited or not.
971 	 */
972 	function setIsLimited(bool isIt) external onlyOwner {
973 		limited = isIt;
974 	}
975 
976 	function setBuyConfig(uint8 buyLiqFee, uint8 buyDevFee) external onlyOwner {
977 		require(buyLiqFee + buyDevFee < 11, "Cannot set above 10%");
978 		fees.buyLiqFee = buyLiqFee;
979 		fees.buyDevFee = buyDevFee;
980 	}
981 
982 	function SetSellConfig(uint8 sellLiqFee, uint8 sellDevFee) external onlyOwner {
983 		require(sellLiqFee + sellDevFee < 11, "Cannot set above 10%");
984 		fees.sellLiqFee = sellLiqFee;
985 		fees.sellDevFee = sellDevFee;
986 	}
987 
988 	function setAutoliqActive(bool isActive) external onlyOwner {
989 		autoLiqActive = isActive;
990 	}
991 
992 	function setAutoliqReceiver(address receiver) external onlyOwner {
993 		autoliqReceiver = receiver;
994 	}
995 
996 	function setDevFeeReceiver(address receiver) external onlyOwner {
997 		require(receiver != address(0), "Cannot set the zero address.");
998 		devFeeReceiver = receiver;
999 	}
1000 
1001 	function setSwapActive(bool canSwap) external onlyOwner {
1002 		swapActive = canSwap;
1003 	}
1004 
1005 	function setTaxExempt(address contributor, bool isExempt) external onlyOwner {
1006 		_taxExempt[contributor] = isExempt;
1007 	}
1008 
1009 	function setMaxTx(uint256 newMax) external onlyOwner {
1010 		require(newMax >= totalSupply() / 1000, "Max TX must be at least 0.1%!");
1011 		_maxTx = newMax;
1012 	}
1013 
1014 	function setSwapAmount(uint256 newAmount) external onlyOwner {
1015 		require(newAmount > 0, "Amount cannot be 0, use setSwapActive to false instead.");
1016 		require(newAmount <= totalSupply() / 100, "Swap amount cannot be over 1% of the supply.");
1017 		_swapAmount = newAmount;
1018 	}
1019 
1020 	function setSwapTrigger(uint256 newAmount) external onlyOwner {
1021 		require(newAmount > 0, "Amount cannot be 0, use setSwapActive to false instead.");
1022 		_swapTrigger = newAmount;
1023 	}
1024 
1025 	function whatIsThis(uint256 wahoo, uint256 bading) external view returns (uint256) {
1026 		return wahoo + bading;
1027 	}
1028 }