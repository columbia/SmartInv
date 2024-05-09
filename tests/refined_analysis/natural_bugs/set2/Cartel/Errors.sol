// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library Errors {
    /**
     * @dev Zero address specified
     */
    error ZeroAddress();

    /**
     * @dev Zero amount specified
     */
    error ZeroAmount();

    /**
     * @dev Invalid fee specified
     */
    error InvalidFee();

    /**
     * @dev Invalid max fee specified
     */
    error InvalidMaxFee();

    /**
     * @dev Zero multiplier used
     */
    error ZeroMultiplier();

    /**
     * @dev ETH deposit is paused
     */
    error DepositingEtherPaused();

    /**
     * @dev ETH deposit is not paused
     */
    error DepositingEtherNotPaused();

    /**
     * @dev Contract is paused
     */
    error Paused();

    /**
     * @dev Contract is not paused
     */
    error NotPaused();

    /**
     * @dev Validator not yet dissolved
     */
    error NotDissolved();

    /**
     * @dev Validator not yet withdrawable
     */
    error NotWithdrawable();

    /**
     * @dev Validator has been previously used before
     */
    error NoUsedValidator();

    /**
     * @dev Not oracle adapter
     */
    error NotOracleAdapter();

    /**
     * @dev Not reward recipient
     */
    error NotRewardRecipient();

    /**
     * @dev Exceeding max value
     */
    error ExceedsMax();

    /**
     * @dev No rewards available
     */
    error NoRewards();

    /**
     * @dev Not PirexEth
     */
    error NotPirexEth();

    /**
     * @dev Not minter
     */
    error NotMinter();

    /**
     * @dev Not burner
     */
    error NotBurner();

    /**
     * @dev Empty string
     */
    error EmptyString();

    /**
     * @dev Validator is Not Staking
     */
    error ValidatorNotStaking();

    /**
     * @dev not enough buffer
     */
    error NotEnoughBuffer();

    /**
     * @dev validator queue empty
     */
    error ValidatorQueueEmpty();

    /**
     * @dev out of bounds
     */
    error OutOfBounds();

    /**
     * @dev cannot trigger validator exit
     */
    error NoValidatorExit();

    /**
     * @dev cannot initiate redemption partially
     */
    error NoPartialInitiateRedemption();

    /**
     * @dev not enough validators
     */
    error NotEnoughValidators();

    /**
     * @dev not enough ETH
     */
    error NotEnoughETH();

    /**
     * @dev max processed count is invalid (< 1)
     */
    error InvalidMaxProcessedCount();

    /**
     * @dev fromIndex and toIndex are invalid
     */
    error InvalidIndexRanges();

    /**
     * @dev ETH is not allowed
     */
    error NoETHAllowed();

    /**
     * @dev ETH is not passed
     */
    error NoETH();

    /**
     * @dev validator status is neither dissolved nor slashed
     */
    error StatusNotDissolvedOrSlashed();

    /**
     * @dev validator status is neither withdrawable nor staking
     */
    error StatusNotWithdrawableOrStaking();

    /**
     * @dev account is not approved
     */
    error AccountNotApproved();

    /**
     * @dev invalid token specified
     */
    error InvalidToken();

    /**
     * @dev not same as deposit size
     */
    error InvalidAmount();

    /**
     * @dev contract not recognised
     */
    error UnrecorgnisedContract();

    /**
     * @dev empty array
     */
    error EmptyArray();

    /**
     * @dev arrays length mismatch
     */
    error MismatchedArrayLengths();
}
