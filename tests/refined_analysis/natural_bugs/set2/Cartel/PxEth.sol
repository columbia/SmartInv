// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {DineroERC20} from "./DineroERC20.sol";
import {Errors} from "./libraries/Errors.sol";

/**
 * @title  PxEth
 * @notice The PxEth token, the main token for the PirexEth system used in the Dinero ecosystem.
 * @dev    Extends the DineroERC20 contract and includes additional functionality.
 * @author redactedcartel.finance
 */
contract PxEth is DineroERC20 {
    // Roles
    /**
     * @notice The OPERATOR_ROLE role assigned for operator functions in the PxEth token contract.
     * @dev    Used to control access to critical functions.
     */
    bytes32 private constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

    /**
     * @notice Constructor to initialize the PxEth token.
     * @dev    Inherits from the DineroERC20 contract and sets the name, symbol, decimals, admin, and initial delay.
     * @param  _admin         address  Admin address.
     * @param  _initialDelay  uint48   Delay required to schedule the acceptance of an access control transfer started.
     */
    constructor(
        address _admin,
        uint48 _initialDelay
    ) DineroERC20("Pirex Ether", "pxETH", 18, _admin, _initialDelay) {}

    /**
     * @notice Operator function to approve allowances for specified accounts and amounts.
     * @dev    Only callable by the operator role.
     * @param  _from    address  Owner of the tokens.
     * @param  _to      address  Account to be approved.
     * @param  _amount  uint256  Amount to be approved.
     */
    function operatorApprove(
        address _from,
        address _to,
        uint256 _amount
    ) external onlyRole(OPERATOR_ROLE) {
        if (_from == address(0)) revert Errors.ZeroAddress();
        if (_to == address(0)) revert Errors.ZeroAddress();

        allowance[_from][_to] = _amount;

        emit Approval(_from, _to, _amount);
    }
}
