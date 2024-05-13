1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 import {DineroERC20} from "./DineroERC20.sol";
5 import {Errors} from "./libraries/Errors.sol";
6 
7 /**
8  * @title  PxEth
9  * @notice The PxEth token, the main token for the PirexEth system used in the Dinero ecosystem.
10  * @dev    Extends the DineroERC20 contract and includes additional functionality.
11  * @author redactedcartel.finance
12  */
13 contract PxEth is DineroERC20 {
14     // Roles
15     /**
16      * @notice The OPERATOR_ROLE role assigned for operator functions in the PxEth token contract.
17      * @dev    Used to control access to critical functions.
18      */
19     bytes32 private constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
20 
21     /**
22      * @notice Constructor to initialize the PxEth token.
23      * @dev    Inherits from the DineroERC20 contract and sets the name, symbol, decimals, admin, and initial delay.
24      * @param  _admin         address  Admin address.
25      * @param  _initialDelay  uint48   Delay required to schedule the acceptance of an access control transfer started.
26      */
27     constructor(
28         address _admin,
29         uint48 _initialDelay
30     ) DineroERC20("Pirex Ether", "pxETH", 18, _admin, _initialDelay) {}
31 
32     /**
33      * @notice Operator function to approve allowances for specified accounts and amounts.
34      * @dev    Only callable by the operator role.
35      * @param  _from    address  Owner of the tokens.
36      * @param  _to      address  Account to be approved.
37      * @param  _amount  uint256  Amount to be approved.
38      */
39     function operatorApprove(
40         address _from,
41         address _to,
42         uint256 _amount
43     ) external onlyRole(OPERATOR_ROLE) {
44         if (_from == address(0)) revert Errors.ZeroAddress();
45         if (_to == address(0)) revert Errors.ZeroAddress();
46 
47         allowance[_from][_to] = _amount;
48 
49         emit Approval(_from, _to, _amount);
50     }
51 }
