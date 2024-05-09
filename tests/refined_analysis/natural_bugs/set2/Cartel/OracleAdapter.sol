// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {AccessControlDefaultAdminRules} from "openzeppelin-contracts/contracts/access/AccessControlDefaultAdminRules.sol";
import {IRewardRecipient} from "./interfaces/IRewardRecipient.sol";
import {IOracleAdapter} from "./interfaces/IOracleAdapter.sol";
import {Errors} from "./libraries/Errors.sol";
import {DataTypes} from "./libraries/DataTypes.sol";

/**
 * @title OracleAdapter
 * @notice An oracle adapter contract for handling voluntary exits and dissolving validators.
 * @dev This contract facilitates interactions between PirexEth, the reward recipient, and oracles for managing validators.
 * @author redactedcartel.finance
 */
contract OracleAdapter is IOracleAdapter, AccessControlDefaultAdminRules {
    // General state variables
    /**
     * @notice Address of the PirexEth contract.
     * @dev This variable holds the address of the PirexEth contract, which is utilized for handling voluntary exits and dissolving validators.
     */
    address public pirexEth;

    /**
     * @notice Instance of the reward recipient contract.
     * @dev This variable represents the instance of the reward recipient contract, which manages the distribution of rewards to validators.
     */
    IRewardRecipient public rewardRecipient;

    /**
     * @notice Role identifier for the oracle role.
     * @dev This constant defines the role identifier for the oracle role, which is required for initiating certain operations related to oracles.
     */
    bytes32 private constant ORACLE_ROLE = keccak256("ORACLE_ROLE");

    /**
     * @notice Role identifier for the governance role.
     * @dev This constant defines the role identifier for the governance role, which has the authority to set contract addresses and perform other governance-related actions.
     */
    bytes32 private constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    // Events
    /**
     * @notice Emitted when a contract address is set.
     * @dev This event signals that a contract address has been updated.
     * @param c               DataTypes.Contract indexed Contract.
     * @param contractAddress address                    Contract address.
     */
    event SetContract(DataTypes.Contract indexed c, address contractAddress);

    /**
     * @notice Emitted when a request for voluntary exit is sent.
     * @dev This event signals that a request for a validator's voluntary exit has been initiated.
     * @param pubKey bytes Key.
     */
    event RequestValidatorExit(bytes pubKey);

    /**
     * @notice Constructor to set the initial delay for access control.
     * @param _initialDelay uint48 Delay required to schedule the acceptance.
     */
    constructor(
        uint48 _initialDelay
    ) AccessControlDefaultAdminRules(_initialDelay, msg.sender) {}

    /**
     * @notice Set a contract address.
     * @dev Only callable by addresses with the GOVERNANCE_ROLE.
     * @param _contract       enum    Contract.
     * @param contractAddress address Contract address.
     */
    function setContract(
        DataTypes.Contract _contract,
        address contractAddress
    ) external onlyRole(GOVERNANCE_ROLE) {
        if (contractAddress == address(0)) revert Errors.ZeroAddress();

        emit SetContract(_contract, contractAddress);

        if (_contract == DataTypes.Contract.PirexEth) {
            pirexEth = contractAddress;
        } else if (_contract == DataTypes.Contract.RewardRecipient) {
            rewardRecipient = IRewardRecipient(contractAddress);
        } else {
            revert Errors.UnrecorgnisedContract();
        }
    }

    /**
     * @notice Send the request for voluntary exit.
     * @dev Only callable by the PirexEth contract.
     * @param _pubKey bytes Key.
     */
    function requestVoluntaryExit(bytes calldata _pubKey) external override {
        if (msg.sender != address(pirexEth)) revert Errors.NotPirexEth();

        emit RequestValidatorExit(_pubKey);
    }

    /**
     * @notice Dissolve validator.
     * @dev Only callable by the oracle role.
     * @param _pubKey bytes   Key.
     * @param _amount uint256 ETH amount.
     */
    function dissolveValidator(
        bytes calldata _pubKey,
        uint256 _amount
    ) external onlyRole(ORACLE_ROLE) {
        rewardRecipient.dissolveValidator(_pubKey, _amount);
    }
}
