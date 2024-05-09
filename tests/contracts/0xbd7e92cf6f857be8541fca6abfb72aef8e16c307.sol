/**
 * This is the utility token for the Prodigy Bot, a Telegram multichain trading tool suite.
 *
 * https://prodigybot.io/
 * https://t.me/ProdigySniper/
 * https://t.me/ProdigySniperBot/
 *
 * $$$$$$$\                            $$\ $$\                     $$\                  $$\     
 * $$  __$$\                           $$ |\__|                    $$ |                 $$ |    
 * $$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$$ |$$\  $$$$$$\  $$\   $$\ $$$$$$$\   $$$$$$\ $$$$$$\   
 * $$$$$$$  |$$  __$$\ $$  __$$\ $$  __$$ |$$ |$$  __$$\ $$ |  $$ |$$  __$$\ $$  __$$\\_$$  _|  
 * $$  ____/ $$ |  \__|$$ /  $$ |$$ /  $$ |$$ |$$ /  $$ |$$ |  $$ |$$ |  $$ |$$ /  $$ | $$ |    
 * $$ |      $$ |      $$ |  $$ |$$ |  $$ |$$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ | $$ |$$\ 
 * $$ |      $$ |      \$$$$$$  |\$$$$$$$ |$$ |\$$$$$$$ |\$$$$$$$ |$$$$$$$  |\$$$$$$  | \$$$$  |
 * \__|      \__|       \______/  \_______|\__| \____$$ | \____$$ |\_______/  \______/   \____/ 
 *                                             $$\   $$ |$$\   $$ |                             
 *                                             \$$$$$$  |\$$$$$$  |                             
 *                                              \______/  \______/                              
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/**
 * @notice Simple ERC20 implementation from Solady.
 * @author Solady (https://github.com/vectorized/solady/blob/main/src/tokens/ERC20.sol)
 * @notice EIP-2612 has been removed due to concerns of userbase not being familiar with the security risks of signatures.
 * @notice Hooks removed since they could be called twice during tax events.
 * @notice Burn is removed as there is no intended use.
 */
abstract contract ERC20 {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The total supply has overflowed.
    error TotalSupplyOverflow();

    /// @dev The allowance has overflowed.
    error AllowanceOverflow();

    /// @dev The allowance has underflowed.
    error AllowanceUnderflow();

    /// @dev Insufficient balance.
    error InsufficientBalance();

    /// @dev Insufficient allowance.
    error InsufficientAllowance();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Emitted when `amount` tokens is transferred from `from` to `to`.
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /// @dev Emitted when `amount` tokens is approved by `owner` to be used by `spender`.
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    /// @dev `keccak256(bytes("Transfer(address,address,uint256)"))`.
    uint256 private constant _TRANSFER_EVENT_SIGNATURE =
        0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;

    /// @dev `keccak256(bytes("Approval(address,address,uint256)"))`.
    uint256 private constant _APPROVAL_EVENT_SIGNATURE =
        0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The storage slot for the total supply.
    uint256 private constant _TOTAL_SUPPLY_SLOT = 0x05345cdf77eb68f44c;

    /// @dev The balance slot of `owner` is given by:
    /// ```
    ///     mstore(0x0c, _BALANCE_SLOT_SEED)
    ///     mstore(0x00, owner)
    ///     let balanceSlot := keccak256(0x0c, 0x20)
    /// ```
    uint256 private constant _BALANCE_SLOT_SEED = 0x87a211a2;

    /// @dev The allowance slot of (`owner`, `spender`) is given by:
    /// ```
    ///     mstore(0x20, spender)
    ///     mstore(0x0c, _ALLOWANCE_SLOT_SEED)
    ///     mstore(0x00, owner)
    ///     let allowanceSlot := keccak256(0x0c, 0x34)
    /// ```
    uint256 private constant _ALLOWANCE_SLOT_SEED = 0x7f5e9f20;

    /// @dev The nonce slot of `owner` is given by:
    /// ```
    ///     mstore(0x0c, _NONCES_SLOT_SEED)
    ///     mstore(0x00, owner)
    ///     let nonceSlot := keccak256(0x0c, 0x20)
    /// ```
    uint256 private constant _NONCES_SLOT_SEED = 0x38377508;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       ERC20 METADATA                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Returns the name of the token.
    function name() public view virtual returns (string memory);

    /// @dev Returns the symbol of the token.
    function symbol() public view virtual returns (string memory);

    /// @dev Returns the decimals places of the token.
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           ERC20                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Returns the amount of tokens in existence.
    function totalSupply() public view virtual returns (uint256 result) {
        /// @solidity memory-safe-assembly
        assembly {
            result := sload(_TOTAL_SUPPLY_SLOT)
        }
    }

    /// @dev Returns the amount of tokens owned by `owner`.
    function balanceOf(address owner) public view virtual returns (uint256 result) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x0c, _BALANCE_SLOT_SEED)
            mstore(0x00, owner)
            result := sload(keccak256(0x0c, 0x20))
        }
    }

    /// @dev Returns the amount of tokens that `spender` can spend on behalf of `owner`.
    function allowance(address owner, address spender)
        public
        view
        virtual
        returns (uint256 result)
    {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x20, spender)
            mstore(0x0c, _ALLOWANCE_SLOT_SEED)
            mstore(0x00, owner)
            result := sload(keccak256(0x0c, 0x34))
        }
    }

    /// @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
    ///
    /// Emits a {Approval} event.
    function approve(address spender, uint256 amount) public virtual returns (bool) {
        /// @solidity memory-safe-assembly
        assembly {
            // Compute the allowance slot and store the amount.
            mstore(0x20, spender)
            mstore(0x0c, _ALLOWANCE_SLOT_SEED)
            mstore(0x00, caller())
            sstore(keccak256(0x0c, 0x34), amount)
            // Emit the {Approval} event.
            mstore(0x00, amount)
            log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, caller(), shr(96, mload(0x2c)))
        }
        return true;
    }

    /// @dev Atomically increases the allowance granted to `spender` by the caller.
    ///
    /// Emits a {Approval} event.
    function increaseAllowance(address spender, uint256 difference) public virtual returns (bool) {
        /// @solidity memory-safe-assembly
        assembly {
            // Compute the allowance slot and load its value.
            mstore(0x20, spender)
            mstore(0x0c, _ALLOWANCE_SLOT_SEED)
            mstore(0x00, caller())
            let allowanceSlot := keccak256(0x0c, 0x34)
            let allowanceBefore := sload(allowanceSlot)
            // Add to the allowance.
            let allowanceAfter := add(allowanceBefore, difference)
            // Revert upon overflow.
            if lt(allowanceAfter, allowanceBefore) {
                mstore(0x00, 0xf9067066) // `AllowanceOverflow()`.
                revert(0x1c, 0x04)
            }
            // Store the updated allowance.
            sstore(allowanceSlot, allowanceAfter)
            // Emit the {Approval} event.
            mstore(0x00, allowanceAfter)
            log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, caller(), shr(96, mload(0x2c)))
        }
        return true;
    }

    /// @dev Atomically decreases the allowance granted to `spender` by the caller.
    ///
    /// Emits a {Approval} event.
    function decreaseAllowance(address spender, uint256 difference) public virtual returns (bool) {
        /// @solidity memory-safe-assembly
        assembly {
            // Compute the allowance slot and load its value.
            mstore(0x20, spender)
            mstore(0x0c, _ALLOWANCE_SLOT_SEED)
            mstore(0x00, caller())
            let allowanceSlot := keccak256(0x0c, 0x34)
            let allowanceBefore := sload(allowanceSlot)
            // Revert if will underflow.
            if lt(allowanceBefore, difference) {
                mstore(0x00, 0x8301ab38) // `AllowanceUnderflow()`.
                revert(0x1c, 0x04)
            }
            // Subtract and store the updated allowance.
            let allowanceAfter := sub(allowanceBefore, difference)
            sstore(allowanceSlot, allowanceAfter)
            // Emit the {Approval} event.
            mstore(0x00, allowanceAfter)
            log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, caller(), shr(96, mload(0x2c)))
        }
        return true;
    }

    /// @dev Transfer `amount` tokens from the caller to `to`.
    ///
    /// Requirements:
    /// - `from` must at least have `amount`.
    ///
    /// Emits a {Transfer} event.
    function transfer(address to, uint256 amount) public virtual returns (bool) {
        /// @solidity memory-safe-assembly
        assembly {
            // Compute the balance slot and load its value.
            mstore(0x0c, _BALANCE_SLOT_SEED)
            mstore(0x00, caller())
            let fromBalanceSlot := keccak256(0x0c, 0x20)
            let fromBalance := sload(fromBalanceSlot)
            // Revert if insufficient balance.
            if gt(amount, fromBalance) {
                mstore(0x00, 0xf4d678b8) // `InsufficientBalance()`.
                revert(0x1c, 0x04)
            }
            // Subtract and store the updated balance.
            sstore(fromBalanceSlot, sub(fromBalance, amount))
            // Compute the balance slot of `to`.
            mstore(0x00, to)
            let toBalanceSlot := keccak256(0x0c, 0x20)
            // Add and store the updated balance of `to`.
            // Will not overflow because the sum of all user balances
            // cannot exceed the maximum uint256 value.
            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))
            // Emit the {Transfer} event.
            mstore(0x20, amount)
            log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, caller(), shr(96, mload(0x0c)))
        }
        return true;
    }

    /// @dev Transfers `amount` tokens from `from` to `to`.
    ///
    /// Note: Does not update the allowance if it is the maximum uint256 value.
    ///
    /// Requirements:
    /// - `from` must at least have `amount`.
    /// - The caller must have at least `amount` of allowance to transfer the tokens of `from`.
    ///
    /// Emits a {Transfer} event.
    function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
        /// @solidity memory-safe-assembly
        assembly {
            let from_ := shl(96, from)
            // Compute the allowance slot and load its value.
            mstore(0x20, caller())
            mstore(0x0c, or(from_, _ALLOWANCE_SLOT_SEED))
            let allowanceSlot := keccak256(0x0c, 0x34)
            let allowance_ := sload(allowanceSlot)
            // If the allowance is not the maximum uint256 value.
            if iszero(eq(allowance_, not(0))) {
                // Revert if the amount to be transferred exceeds the allowance.
                if gt(amount, allowance_) {
                    mstore(0x00, 0x13be252b) // `InsufficientAllowance()`.
                    revert(0x1c, 0x04)
                }
                // Subtract and store the updated allowance.
                sstore(allowanceSlot, sub(allowance_, amount))
            }
            // Compute the balance slot and load its value.
            mstore(0x0c, or(from_, _BALANCE_SLOT_SEED))
            let fromBalanceSlot := keccak256(0x0c, 0x20)
            let fromBalance := sload(fromBalanceSlot)
            // Revert if insufficient balance.
            if gt(amount, fromBalance) {
                mstore(0x00, 0xf4d678b8) // `InsufficientBalance()`.
                revert(0x1c, 0x04)
            }
            // Subtract and store the updated balance.
            sstore(fromBalanceSlot, sub(fromBalance, amount))
            // Compute the balance slot of `to`.
            mstore(0x00, to)
            let toBalanceSlot := keccak256(0x0c, 0x20)
            // Add and store the updated balance of `to`.
            // Will not overflow because the sum of all user balances
            // cannot exceed the maximum uint256 value.
            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))
            // Emit the {Transfer} event.
            mstore(0x20, amount)
            log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, shr(96, from_), shr(96, mload(0x0c)))
        }
        return true;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  INTERNAL MINT FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Mints `amount` tokens to `to`, increasing the total supply.
    ///
    /// Emits a {Transfer} event.
    function _mint(address to, uint256 amount) internal virtual {
        /// @solidity memory-safe-assembly
        assembly {
            let totalSupplyBefore := sload(_TOTAL_SUPPLY_SLOT)
            let totalSupplyAfter := add(totalSupplyBefore, amount)
            // Revert if the total supply overflows.
            if lt(totalSupplyAfter, totalSupplyBefore) {
                mstore(0x00, 0xe5cfe957) // `TotalSupplyOverflow()`.
                revert(0x1c, 0x04)
            }
            // Store the updated total supply.
            sstore(_TOTAL_SUPPLY_SLOT, totalSupplyAfter)
            // Compute the balance slot and load its value.
            mstore(0x0c, _BALANCE_SLOT_SEED)
            mstore(0x00, to)
            let toBalanceSlot := keccak256(0x0c, 0x20)
            // Add and store the updated balance.
            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))
            // Emit the {Transfer} event.
            mstore(0x20, amount)
            log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, 0, shr(96, mload(0x0c)))
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                INTERNAL TRANSFER FUNCTIONS                 */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Moves `amount` of tokens from `from` to `to`.
    function _transfer(address from, address to, uint256 amount) internal virtual {
        /// @solidity memory-safe-assembly
        assembly {
            let from_ := shl(96, from)
            // Compute the balance slot and load its value.
            mstore(0x0c, or(from_, _BALANCE_SLOT_SEED))
            let fromBalanceSlot := keccak256(0x0c, 0x20)
            let fromBalance := sload(fromBalanceSlot)
            // Revert if insufficient balance.
            if gt(amount, fromBalance) {
                mstore(0x00, 0xf4d678b8) // `InsufficientBalance()`.
                revert(0x1c, 0x04)
            }
            // Subtract and store the updated balance.
            sstore(fromBalanceSlot, sub(fromBalance, amount))
            // Compute the balance slot of `to`.
            mstore(0x00, to)
            let toBalanceSlot := keccak256(0x0c, 0x20)
            // Add and store the updated balance of `to`.
            // Will not overflow because the sum of all user balances
            // cannot exceed the maximum uint256 value.
            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))
            // Emit the {Transfer} event.
            mstore(0x20, amount)
            log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, shr(96, from_), shr(96, mload(0x0c)))
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                INTERNAL ALLOWANCE FUNCTIONS                */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Updates the allowance of `owner` for `spender` based on spent `amount`.
    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        /// @solidity memory-safe-assembly
        assembly {
            // Compute the allowance slot and load its value.
            mstore(0x20, spender)
            mstore(0x0c, _ALLOWANCE_SLOT_SEED)
            mstore(0x00, owner)
            let allowanceSlot := keccak256(0x0c, 0x34)
            let allowance_ := sload(allowanceSlot)
            // If the allowance is not the maximum uint256 value.
            if iszero(eq(allowance_, not(0))) {
                // Revert if the amount to be transferred exceeds the allowance.
                if gt(amount, allowance_) {
                    mstore(0x00, 0x13be252b) // `InsufficientAllowance()`.
                    revert(0x1c, 0x04)
                }
                // Subtract and store the updated allowance.
                sstore(allowanceSlot, sub(allowance_, amount))
            }
        }
    }

    /// @dev Sets `amount` as the allowance of `spender` over the tokens of `owner`.
    ///
    /// Emits a {Approval} event.
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        /// @solidity memory-safe-assembly
        assembly {
            let owner_ := shl(96, owner)
            // Compute the allowance slot and store the amount.
            mstore(0x20, spender)
            mstore(0x0c, or(owner_, _ALLOWANCE_SLOT_SEED))
            sstore(keccak256(0x0c, 0x34), amount)
            // Emit the {Approval} event.
            mstore(0x00, amount)
            log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, shr(96, owner_), shr(96, mload(0x2c)))
        }
    }
}

/**
 * @notice Simple single owner authorization mixin.
 * @author Solady (https://github.com/vectorized/solady/blob/main/src/auth/Ownable.sol)
 */
abstract contract Ownable {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The caller is not authorized to call the function.
    error Unauthorized();

    /// @dev The `newOwner` cannot be the zero address.
    error NewOwnerIsZeroAddress();

    /// @dev The `pendingOwner` does not have a valid handover request.
    error NoHandoverRequest();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The ownership is transferred from `oldOwner` to `newOwner`.
    /// This event is intentionally kept the same as OpenZeppelin's Ownable to be
    /// compatible with indexers and [EIP-173](https://eips.ethereum.org/EIPS/eip-173),
    /// despite it not being as lightweight as a single argument event.
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    /// @dev An ownership handover to `pendingOwner` has been requested.
    event OwnershipHandoverRequested(address indexed pendingOwner);

    /// @dev The ownership handover to `pendingOwner` has been canceled.
    event OwnershipHandoverCanceled(address indexed pendingOwner);

    /// @dev `keccak256(bytes("OwnershipTransferred(address,address)"))`.
    uint256 private constant _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE =
        0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0;

    /// @dev `keccak256(bytes("OwnershipHandoverRequested(address)"))`.
    uint256 private constant _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE =
        0xdbf36a107da19e49527a7176a1babf963b4b0ff8cde35ee35d6cd8f1f9ac7e1d;

    /// @dev `keccak256(bytes("OwnershipHandoverCanceled(address)"))`.
    uint256 private constant _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE =
        0xfa7b8eab7da67f412cc9575ed43464468f9bfbae89d1675917346ca6d8fe3c92;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The owner slot is given by: `not(_OWNER_SLOT_NOT)`.
    /// It is intentionally chosen to be a high value
    /// to avoid collision with lower slots.
    /// The choice of manual storage layout is to enable compatibility
    /// with both regular and upgradeable contracts.
    uint256 private constant _OWNER_SLOT_NOT = 0x8b78c6d8;

    /// The ownership handover slot of `newOwner` is given by:
    /// ```
    ///     mstore(0x00, or(shl(96, user), _HANDOVER_SLOT_SEED))
    ///     let handoverSlot := keccak256(0x00, 0x20)
    /// ```
    /// It stores the expiry timestamp of the two-step ownership handover.
    uint256 private constant _HANDOVER_SLOT_SEED = 0x389a75e1;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     INTERNAL FUNCTIONS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Initializes the owner directly without authorization guard.
    /// This function must be called upon initialization,
    /// regardless of whether the contract is upgradeable or not.
    /// This is to enable generalization to both regular and upgradeable contracts,
    /// and to save gas in case the initial owner is not the caller.
    /// For performance reasons, this function will not check if there
    /// is an existing owner.
    function _initializeOwner(address newOwner) internal virtual {
        /// @solidity memory-safe-assembly
        assembly {
            // Clean the upper 96 bits.
            newOwner := shr(96, shl(96, newOwner))
            // Store the new value.
            sstore(not(_OWNER_SLOT_NOT), newOwner)
            // Emit the {OwnershipTransferred} event.
            log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, 0, newOwner)
        }
    }

    /// @dev Sets the owner directly without authorization guard.
    function _setOwner(address newOwner) internal virtual {
        /// @solidity memory-safe-assembly
        assembly {
            let ownerSlot := not(_OWNER_SLOT_NOT)
            // Clean the upper 96 bits.
            newOwner := shr(96, shl(96, newOwner))
            // Emit the {OwnershipTransferred} event.
            log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, sload(ownerSlot), newOwner)
            // Store the new value.
            sstore(ownerSlot, newOwner)
        }
    }

    /// @dev Throws if the sender is not the owner.
    function _checkOwner() internal view virtual {
        /// @solidity memory-safe-assembly
        assembly {
            // If the caller is not the stored owner, revert.
            if iszero(eq(caller(), sload(not(_OWNER_SLOT_NOT)))) {
                mstore(0x00, 0x82b42900) // `Unauthorized()`.
                revert(0x1c, 0x04)
            }
        }
    }

    /// @dev Returns how long a two-step ownership handover is valid for in seconds.
    /// Override to return a different value if needed.
    /// Made internal to conserve bytecode. Wrap it in a public function if needed.
    function _ownershipHandoverValidFor() internal view virtual returns (uint64) {
        return 48 * 3600;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Allows the owner to transfer the ownership to `newOwner`.
    function transferOwnership(address newOwner) public payable virtual onlyOwner {
        /// @solidity memory-safe-assembly
        assembly {
            if iszero(shl(96, newOwner)) {
                mstore(0x00, 0x7448fbae) // `NewOwnerIsZeroAddress()`.
                revert(0x1c, 0x04)
            }
        }
        _setOwner(newOwner);
    }

    /// @dev Allows the owner to renounce their ownership.
    function renounceOwnership() public payable virtual onlyOwner {
        _setOwner(address(0));
    }

    /// @dev Request a two-step ownership handover to the caller.
    /// The request will automatically expire in 48 hours (172800 seconds) by default.
    function requestOwnershipHandover() public payable virtual {
        unchecked {
            uint256 expires = block.timestamp + _ownershipHandoverValidFor();
            /// @solidity memory-safe-assembly
            assembly {
                // Compute and set the handover slot to `expires`.
                mstore(0x0c, _HANDOVER_SLOT_SEED)
                mstore(0x00, caller())
                sstore(keccak256(0x0c, 0x20), expires)
                // Emit the {OwnershipHandoverRequested} event.
                log2(0, 0, _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE, caller())
            }
        }
    }

    /// @dev Cancels the two-step ownership handover to the caller, if any.
    function cancelOwnershipHandover() public payable virtual {
        /// @solidity memory-safe-assembly
        assembly {
            // Compute and set the handover slot to 0.
            mstore(0x0c, _HANDOVER_SLOT_SEED)
            mstore(0x00, caller())
            sstore(keccak256(0x0c, 0x20), 0)
            // Emit the {OwnershipHandoverCanceled} event.
            log2(0, 0, _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE, caller())
        }
    }

    /// @dev Allows the owner to complete the two-step ownership handover to `pendingOwner`.
    /// Reverts if there is no existing ownership handover requested by `pendingOwner`.
    function completeOwnershipHandover(address pendingOwner) public payable virtual onlyOwner {
        /// @solidity memory-safe-assembly
        assembly {
            // Compute and set the handover slot to 0.
            mstore(0x0c, _HANDOVER_SLOT_SEED)
            mstore(0x00, pendingOwner)
            let handoverSlot := keccak256(0x0c, 0x20)
            // If the handover does not exist, or has expired.
            if gt(timestamp(), sload(handoverSlot)) {
                mstore(0x00, 0x6f5e8818) // `NoHandoverRequest()`.
                revert(0x1c, 0x04)
            }
            // Set the handover slot to 0.
            sstore(handoverSlot, 0)
        }
        _setOwner(pendingOwner);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Returns the owner of the contract.
    function owner() public view virtual returns (address result) {
        /// @solidity memory-safe-assembly
        assembly {
            result := sload(not(_OWNER_SLOT_NOT))
        }
    }

    /// @dev Returns the expiry timestamp for the two-step ownership handover to `pendingOwner`.
    function ownershipHandoverExpiresAt(address pendingOwner)
        public
        view
        virtual
        returns (uint256 result)
    {
        /// @solidity memory-safe-assembly
        assembly {
            // Compute the handover slot.
            mstore(0x0c, _HANDOVER_SLOT_SEED)
            mstore(0x00, pendingOwner)
            // Load the handover slot.
            result := sload(keccak256(0x0c, 0x20))
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         MODIFIERS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Marks a function as only callable by the owner.
    modifier onlyOwner() virtual {
        _checkOwner();
        _;
    }
}

/**
 * @notice Interface for UniV2 router.
 */
interface IDexRouter {
	function factory() external pure returns (address);
	function WETH() external pure returns (address);
	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
}

/**
 * @notice The prodigy bot utility token.
 * @author ProdigyBot
 */
contract ProdigyBot is ERC20, Ownable {

	struct FeeSettings {
		uint8 buyLiqFee;
		uint8 buyDevFee;
		uint8 sellLiqFee;
		uint8 sellDevFee;
	}

	bool public autoLiqActive = true;
	bool public swapActive = true;
	bool private _inSwap = false;
	address public autoliqReceiver;
	address public devFeeReceiver;
	address private _pair;
	bool public limited;
	uint256 public launchBlock;
	uint256 private _maxTx;
	uint256 private _swapTrigger;
	uint256 private _swapAmount;
	FeeSettings public fees;
	address private _router;
	mapping (address => bool) private _taxExempt;
	mapping (address => bool) private _silicon;

	error ExceedsLimits();
	error ReentrantSwap();

	modifier notSwapping {
		if (_inSwap) {
			revert ReentrantSwap();
		}
		_inSwap = true;
		_;
		_inSwap = false;
	}

	constructor(address router) {
		// Init the owner.
		_initializeOwner(msg.sender);
		/**
		 * Init the total supply.
		 * See implementation in ERC20 contract above.
		 * This is only called in this constructor.
		 * It cannot be called againt.
		 */
		_mint(msg.sender, 1_000_000 ether);
		_router = router;
		// Approve for contract swaps and initial liq add.
		_approve(address(this), router, type(uint256).max);
		_approve(msg.sender, router, type(uint256).max);
		// Initial fees.
		_taxExempt[msg.sender] = true;
		_taxExempt[address(this)] = true;
		fees.buyDevFee = 3;
		fees.buyLiqFee = 2;
		fees.sellDevFee = 3;
		fees.sellLiqFee = 2;
		// Initial swapback value.
		_swapAmount = totalSupply();
		_swapTrigger = totalSupply() / 1000;
	}

	function name() public pure override returns (string memory) {
		return "Prodigy Bot";
	}

    function symbol() public pure override returns (string memory) {
		return "PRO";
	}

	function release(address pair) external onlyOwner {
		require(launchBlock == 0, "Already launched!");
		launchBlock = block.number;
		_pair = pair;
	}

	/**
	 * @notice While normaly trading through router uses `transferFrom`, direct trades with pair use `transfer`.
	 * Thus, limits and tax status must be checked on both.
	 * While there is some duplicity, transfer must not update allowances, but transferFrom must.
	 */
	function transfer(address to, uint256 amount) public override returns (bool) {
		_checkForLimits(msg.sender, to, amount);

		// Transfer with fee.
		bool isEitherBot = _silicon[msg.sender] || _silicon[to];
		if (isEitherBot || _hasFee(msg.sender, to)) {
			uint256 fee = _feeAmount(msg.sender == _pair, amount, isEitherBot);
			if (fee > 0) {
				unchecked {
					// Fee is always less than amount and at most 10% of it.
					amount = amount - fee;
				}
				super._transfer(msg.sender, address(this), fee);
			}
			if (to == _pair) {
				_checkPerformSwap();
			}
		}

		// Base class ERC20 checks for balance.
		return super.transfer(to, amount);
	}

	function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
		_checkForLimits(from, to, amount);

		// Transfer from with fee.
		bool isEitherBot = _silicon[from] || _silicon[to];
		if (isEitherBot || _hasFee(from, to)) {
			_transferFrom(from, to, amount, isEitherBot);
			return true;
		}

		// Regular non taxed transferFrom. Straight from base class.
		// Base class ERC20 checks for allowance and balance of sender.
		// It also updates the allowance.
		return super.transferFrom(from, to, amount);
	}

	function _transferFrom(address from, address to, uint256 amount, bool isEitherBot) private {
		/**
		 * In the case of a transfer from with fees, we deal here with approval.
		 * Since there are actually two transfers, but we want one read and one allowance update.
		 */
		uint256 allowed = allowance(from, msg.sender);
		if (allowance(from, msg.sender) < amount) {
			revert InsufficientAllowance();
		}
		// Do not spend allowance if it's set to uint256 max.
		if (allowed != type(uint256).max) {
			_spendAllowance(from, msg.sender, amount);
		}

		uint256 fee = _feeAmount(from == _pair, amount, isEitherBot);
		if (fee > 0) {
			unchecked {
				// Fee is always less than amount and at most 10% of it.
				amount = amount - fee;
			}
			/**
			 * Fee is a separate transfer event.
			 * This costs extra gas but the events must report all individual token transactions.
			 * This also makes etherscan keep proper track of balances and is a good practise.
			 */
			super._transfer(from, address(this), fee);
		}
		if (to == _pair) {
			_checkPerformSwap();
		}
		super._transfer(from, to, amount);
	}

	/**
	 * @dev Wallet and tx limitations for launch.
	 */
	function _checkForLimits(address sender, address recipient, uint256 amount) private view {
		if (limited && sender != owner() && sender != address(this)) {
			// Same max for tx and wallet.
			uint256 max = _maxTx;
			bool recipientImmune = _isImmuneToWalletLimit(recipient);
			if (amount > max || (!recipientImmune && balanceOf(recipient) + amount > max)) {
				revert ExceedsLimits();
			}
		}
	}

	/**
	 * @dev Check whether transaction is subject to AMM trading fee.
	 */
	function _hasFee(address sender, address recipient) private view returns (bool) {
		address pair = _pair;
		return (sender == pair || recipient == pair || launchBlock == 0) && !_taxExempt[sender] && !_taxExempt[recipient];
	}

	/**
	 * @dev Calculate fee amount for an AMM trade.
	 */
	function _feeAmount(bool isBuy, uint256 amount, bool isEitherBot) private view returns (uint256) {
		if (amount == 0) {
			return 0;
		}
		uint256 feePct = _getFeePct(isBuy, isEitherBot);
		if (feePct > 0) {
			return amount * feePct / 100;
		}
		return 0;
	}

	/**
	 * @dev Check whether to perform a contract swap.
	 */
	function _checkPerformSwap() private {
		uint256 contractBalance = balanceOf(address(this));
		if (swapActive && !_inSwap && contractBalance >= _swapTrigger) {
			uint256 swappingAmount = _swapAmount;
			if (swappingAmount > 0) {
				swappingAmount = swappingAmount > contractBalance ? contractBalance : swappingAmount;
				_swapAndLiq(swappingAmount);
			}
		}
	}

	/**
	 * @dev Calculate trade fee percent.
	 */
	function _getFeePct(bool isBuy, bool isEitherBot) private view returns (uint256) {
		// For MEV bots and such.
		if (isEitherBot) {
			return isBuy ? 25 : 80;
		}
		// Before launch.
		if (launchBlock == 0) {
			return isBuy ? 25 : 66;
		}
		// Buy fees.
		if (isBuy) {
			return fees.buyDevFee + fees.buyLiqFee;
		}
		// Sell fees.
		return fees.sellDevFee + fees.sellLiqFee;
	}

	/**
	 * @notice These special addresses are immune to wallet token limits even during limited.
	 */
	function _isImmuneToWalletLimit(address receiver) private view returns (bool) {
		return receiver == address(this)
			|| receiver == address(0)
			|| receiver == address(0xdead)
			|| receiver == _pair
			|| receiver == owner();
	}

	function _swapAndLiq(uint256 swapAmount) private notSwapping {
		// If this is active, sales that lead to swaps will add some liquidity from the taxed tokens.
		if (autoLiqActive) {
			uint256 total = fees.sellDevFee + fees.sellLiqFee;
			uint256 forLiquidity = (swapAmount * fees.sellLiqFee / total) / 2;
			uint256 balanceBefore = address(this).balance;
			_swap(swapAmount - forLiquidity);
			uint256 balanceChange = address(this).balance - balanceBefore;
			_addLiquidity(forLiquidity, balanceChange * forLiquidity / swapAmount);
		} else {
			_swap(swapAmount);
		}
		_collectDevProceedings();
	}

	receive() external payable {}

	function _swap(uint256 amount) private {
		address[] memory path = new address[](2);
		path[0] = address(this);
		IDexRouter router = IDexRouter(_router);
		path[1] = router.WETH();
		router.swapExactTokensForETHSupportingFeeOnTransferTokens(
			amount,
			0,
			path,
			address(this),
			block.timestamp
		);
	}

	function _addLiquidity(uint256 tokens, uint256 eth) private {
		IDexRouter(_router).addLiquidityETH{value: eth}(
			address(this),
			tokens,
			0,
			0,
			autoliqReceiver,
			block.timestamp
		);
	}

	/**
	 * @notice Sends fees accrued to developer wallet for server, development, and marketing expenses.
	 */
	function _collectDevProceedings() private {
		devFeeReceiver.call{value: address(this).balance}("");
	}

	/**
	 * @notice Control automated malicious value subtracting bots such as MEV so they cannot profit out of the token.
	 */
	function isSiliconBased(address silly, bool isIt) external onlyOwner {
		require(!isIt || launchBlock == 0 || block.number - launchBlock < 14000, "Can only be done during launch.");
		_silicon[silly] = isIt;
	}

	function manySuchCases(address[] calldata malevolent) external onlyOwner {
		require(launchBlock == 0 || block.number - launchBlock < 14000, "Can only be done during launch.");
		for (uint256 i = 0; i < malevolent.length; i++) {
			_silicon[malevolent[i]] = true;
		}
	}

	/**
	 * @notice Whether the transactions and wallets are limited or not.
	 */
	function setIsLimited(bool isIt) external onlyOwner {
		limited = isIt;
	}

	function setBuyConfig(uint8 buyLiqFee, uint8 buyDevFee) external onlyOwner {
		require(buyLiqFee + buyDevFee < 11, "Cannot set above 10%");
		fees.buyLiqFee = buyLiqFee;
		fees.buyDevFee = buyDevFee;
	}

	function SetSellConfig(uint8 sellLiqFee, uint8 sellDevFee) external onlyOwner {
		require(sellLiqFee + sellDevFee < 11, "Cannot set above 10%");
		fees.sellLiqFee = sellLiqFee;
		fees.sellDevFee = sellDevFee;
	}

	function setAutoliqActive(bool isActive) external onlyOwner {
		autoLiqActive = isActive;
	}

	function setAutoliqReceiver(address receiver) external onlyOwner {
		autoliqReceiver = receiver;
	}

	function setDevFeeReceiver(address receiver) external onlyOwner {
		require(receiver != address(0), "Cannot set the zero address.");
		devFeeReceiver = receiver;
	}

	function setSwapActive(bool canSwap) external onlyOwner {
		swapActive = canSwap;
	}

	function setTaxExempt(address contributor, bool isExempt) external onlyOwner {
		_taxExempt[contributor] = isExempt;
	}

	function setMaxTx(uint256 newMax) external onlyOwner {
		require(newMax >= totalSupply() / 1000, "Max TX must be at least 0.1%!");
		_maxTx = newMax;
	}

	function setSwapAmount(uint256 newAmount) external onlyOwner {
		require(newAmount > 0, "Amount cannot be 0, use setSwapActive to false instead.");
		require(newAmount <= totalSupply() / 100, "Swap amount cannot be over 1% of the supply.");
		_swapAmount = newAmount;
	}

	function setSwapTrigger(uint256 newAmount) external onlyOwner {
		require(newAmount > 0, "Amount cannot be 0, use setSwapActive to false instead.");
		_swapTrigger = newAmount;
	}

	function whatIsThis(uint256 wahoo, uint256 bading) external view returns (uint256) {
		return wahoo + bading;
	}
}