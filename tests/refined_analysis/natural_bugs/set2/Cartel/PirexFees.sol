// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Ownable2Step} from "openzeppelin-contracts/contracts/access/Ownable2Step.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {DataTypes} from "./libraries/DataTypes.sol";
import {Errors} from "./libraries/Errors.sol";

/**
 * @title  PirexFees
 * @notice Handling protocol fees distributions
 * @dev    This contract manages the distribution of protocol fees to assigned recipient.
 * @author redactedcartel.finance
 */
contract PirexFees is Ownable2Step {
    /**
     * @dev Library: SafeTransferLib - Provides safe transfer functions for ERC20 tokens.
     */
    using SafeTransferLib for ERC20;

    /**
     * @notice The address designated as the recipient for fees distribution.
     * @dev    This address is configurable and determines where fees is directed.
     */
    address public recipient;

    // Events
    /**
     * @notice Emitted when a fee recipient address is set.
     * @dev    Signals changes to fee recipient addresses.
     * @param  recipient  address  The new address set as the new fee recipient.
     */
    event SetRecipient(address recipient);

    /**
     * @notice Emitted when fees are distributed.
     * @dev    Signals the distribution of fees.
     * @param  token   address  The token address for which fees are distributed.
     * @param  amount  uint256  The amount of fees being distributed.
     */
    event DistributeFees(address token, uint256 amount);

    /**
     * @notice Constructor to initialize the fee recipient addresses.
     * @dev    Initializes the contract with the provided recipient address.
     * @param  _recipient  address  The address of the fee recipient.
     */
    constructor(address _recipient) {
        if (_recipient == address(0)) revert Errors.ZeroAddress();

        recipient = _recipient;
    }

    /**
     * @notice Set a fee recipient address.
     * @dev    Allows the owner to set the fee recipient address.
     * @param  _recipient  address  Fee recipient address.
     */
    function setRecipient(address _recipient) external onlyOwner {
        if (_recipient == address(0)) revert Errors.ZeroAddress();

        emit SetRecipient(_recipient);

        recipient = _recipient;
    }

    /**
     * @notice Distribute fees.
     * @param  from    address  Fee source address.
     * @param  token   address  Fee token address.
     * @param  amount  uint256  Fee token amount.
     */
    function distributeFees(
        address from,
        address token,
        uint256 amount
    ) external {
        emit DistributeFees(token, amount);

        ERC20 t = ERC20(token);

        // Favoring push over pull to reduce accounting complexity for different tokens
        t.safeTransferFrom(from, recipient, amount);
    }
}
