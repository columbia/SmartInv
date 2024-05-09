// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {AccessControlDefaultAdminRules} from "openzeppelin-contracts/contracts/access/AccessControlDefaultAdminRules.sol";
import {DataTypes} from "./libraries/DataTypes.sol";
import {IOracleAdapter} from "./interfaces/IOracleAdapter.sol";
import {IPirexEth} from "./interfaces/IPirexEth.sol";
import {Errors} from "./libraries/Errors.sol";

/**
 * @title RewardRecipient
 * @notice Manages rewards for validators and handles associated functionalities.
 * @dev Inherits from AccessControlDefaultAdminRules to control access to critical functions.
 * @author redactedcartel.finance
 */
contract RewardRecipient is AccessControlDefaultAdminRules {
    /**
     * @notice The role assigned to external keepers responsible for specific protocol functions.
     * @dev This constant represents the keccak256 hash of the string "KEEPER_ROLE".
     */
    bytes32 private constant KEEPER_ROLE = keccak256("KEEPER_ROLE");

    /**
     * @notice The role assigned to governance entities responsible for managing protocol parameters.
     * @dev This constant represents the keccak256 hash of the string "GOVERNANCE_ROLE".
     */
    bytes32 private constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    // Pirex contracts
    /**
     * @notice The IPirexEth interface for interacting with the PirexEth contract.
     * @dev This interface defines the methods available for communication with the PirexEth contract.
     */
    IPirexEth public pirexEth;

    /**
     * @notice The OracleAdapter contract responsible for interfacing with the oracle for protocol data.
     * @dev This contract provides receives update when validator is dissolved.
     */
    IOracleAdapter public oracleAdapter;

    // Events
    /**
     * @notice Emitted when a contract address is set.
     * @dev Signals changes to contract addresses, indicating updates to PirexEth or OracleAdapter.
     * @param c               DataTypes.Contract Enum indicating the contract type.
     * @param contractAddress address            The new address of the contract.
     */
    event SetContract(DataTypes.Contract indexed c, address contractAddress);

    // Modifiers
    /**
     * @notice Modifier to restrict access to the function only to the Oracle Adapter.
     * @dev Reverts with an error if the caller is not the Oracle Adapter.
     */
    modifier onlyOracleAdapter() {
        if (msg.sender != address(oracleAdapter))
            revert Errors.NotOracleAdapter();
        _;
    }

    /**
     * @notice Constructor to set the admin and initial delay for access control transfer.
     * @dev Initializes the contract with the specified admin address and initial delay for access control transfer.
     * @param _admin        address Admin address.
     * @param _initialDelay uint48  Initial delay required for the acceptance of an access control transfer.
     */
    constructor(
        address _admin,
        uint48 _initialDelay
    ) AccessControlDefaultAdminRules(_initialDelay, _admin) {}

    /**
     * @notice Set a contract address.
     * @dev Allows a contract address to be set by the governance role.
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
            pirexEth = IPirexEth(contractAddress);
        } else if (_contract == DataTypes.Contract.OracleAdapter) {
            oracleAdapter = IOracleAdapter(contractAddress);
        } else {
            revert Errors.UnrecorgnisedContract();
        }
    }

    /**
     * @notice Dissolve a validator.
     * @dev Allows the dissolution of a validator by the OracleAdapter.
     * @param _pubKey bytes   Key of the validator.
     * @param _amount uint256 ETH amount.
     */
    function dissolveValidator(
        bytes calldata _pubKey,
        uint256 _amount
    ) external onlyOracleAdapter {
        pirexEth.dissolveValidator{value: _amount}(_pubKey);
    }

    /**
     * @notice Slash a validator.
     * @dev Allows the slashing of a validator by a Keeper, potentially using a buffer for penalty compensation.
     * @param _pubKey         bytes                     Key of the validator.
     * @param _removeIndex    uint256                   Validator public key index.
     * @param _amount         uint256                   ETH amount released from Beacon chain.
     * @param _unordered      bool                      Removed in a gas-efficient way or not.
     * @param _useBuffer      bool                      Whether to use a buffer to compensate for the penalty.
     * @param _burnerAccounts DataTypes.BurnerAccount[] Burner accounts.
     */
    function slashValidator(
        bytes calldata _pubKey,
        uint256 _removeIndex,
        uint256 _amount,
        bool _unordered,
        bool _useBuffer,
        DataTypes.BurnerAccount[] calldata _burnerAccounts
    ) external payable onlyRole(KEEPER_ROLE) {
        if (_useBuffer && msg.value > 0) {
            revert Errors.NoETHAllowed();
        }
        pirexEth.slashValidator{value: _amount + msg.value}(
            _pubKey,
            _removeIndex,
            _amount,
            _unordered,
            _useBuffer,
            _burnerAccounts
        );
    }

    /**
     * @notice Harvest and mint staking rewards.
     * @dev Allows a Keeper to trigger the harvest of staking rewards and mint the corresponding amount of ETH.
     * @param _amount   uint256 Amount of ETH to be harvested.
     * @param _endBlock uint256 Block until which ETH rewards are computed.
     */
    function harvest(
        uint256 _amount,
        uint256 _endBlock
    ) external onlyRole(KEEPER_ROLE) {
        pirexEth.harvest{value: _amount}(_endBlock);
    }

    /**
     * @notice Receive MEV rewards.
     * @dev Allows the contract to receive MEV rewards in the form of ETH.
     */
    receive() external payable {}
}
