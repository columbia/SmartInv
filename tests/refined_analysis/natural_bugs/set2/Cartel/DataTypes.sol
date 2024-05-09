// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/**
 * @title DataTypes
 * @notice Library containing various data structures and enums for the PirexEth.
 * @dev This library provides data structures and enums crucial for the functionality of the Pirex protocol.
 * @author redactedcartel.finance
 */
library DataTypes {
    // Validator struct type
    struct Validator {
        // Publickey of the validator
        bytes pubKey;
        // Signature associated with the validator
        bytes signature;
        // Root hash of deposit data for the validator
        bytes32 depositDataRoot;
        // beneficiazry address to receive pxEth against preDeposit
        address receiver;
    }

    // ValidatorDeque struct type
    struct ValidatorDeque {
        // Beginning index of the validator deque
        int128 _begin;
        // End index of the validator deque
        int128 _end;
        // Mapping of validator index to Validator struct
        mapping(int128 => Validator) _validators;
    }

    // Burner Account Type
    struct BurnerAccount {
        // Address of the burner account
        address account;
        // Amount associated with the burner account
        uint256 amount;
    }

    // Configurable fees
    enum Fees {
        // Fee type for deposit
        Deposit,
        // Fee type for redemption
        Redemption,
        // Fee type for instant redemption
        InstantRedemption
    }

    // Configurable contracts
    enum Contract {
        // PxEth contract
        PxEth,
        // UpxEth contract
        UpxEth,
        // AutoPxEth contract
        AutoPxEth,
        // OracleAdapter contract
        OracleAdapter,
        // PirexEth contract
        PirexEth,
        // RewardRecipient contract
        RewardRecipient
    }

    // Validator statuses
    enum ValidatorStatus {
        // The validator is not staking and has no defined status.
        None,
        // The validator is actively participating in the staking process.
        // It could be in one of the following states: pending_initialized, pending_queued, or active_ongoing.
        Staking,
        // The validator has proceed with the withdrawal process.
        // It represents a meta state for active_exiting, exited_unslashed, and the withdrawal process being possible.
        Withdrawable,
        // The validator's status indicating that ETH is released to the pirexEthValidators
        // It represents the withdrawal_done status.
        Dissolved,
        // The validator's status indicating that it has been slashed due to misbehavior.
        // It serves as a meta state encompassing active_slashed, exited_slashed,
        // and the possibility of starting the withdrawal process (withdrawal_possible) or already completed (withdrawal_done)
        // with the release of ETH, subject to a penalty for the misbehavior.
        Slashed
    }
}
