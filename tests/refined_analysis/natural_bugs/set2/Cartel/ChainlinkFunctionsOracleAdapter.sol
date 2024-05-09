// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {AccessControl} from "openzeppelin-contracts/contracts/access/AccessControl.sol";
import {Functions, FunctionsClient} from "./vendor/chainlink/functions/FunctionsClient.sol";
import {Errors} from "./libraries/Errors.sol";
import {IPirexEth} from "./interfaces/IPirexEth.sol";
import {IOracleAdapter} from "./interfaces/IOracleAdapter.sol";

/**
 * @title ChainlinkFunctionsOracleAdapter
 * @dev An Oracle Adapter using Chainlink FunctionsClient to interact with Chainlink Oracle.
 * @author redactedcartel.finance
 */
contract ChainlinkFunctionsOracleAdapter is
    IOracleAdapter,
    FunctionsClient,
    AccessControl
{
    using Functions for Functions.Request;

    // General state variables

    /**
     * @notice Instance of the PirexEth contract.
     */
    IPirexEth public pirexEth;

    /**
     * @notice Unique identifier for the subscription.
     */
    uint64 public subscriptionId;

    /**
     * @notice Gas limit for transactions.
     */
    uint32 public gasLimit;

    /**
     * @notice Mapping to store the relationship between request ID and validator public key.
     */
    mapping(bytes32 => bytes) public requestIdToValidatorPubKey;

    /**
     * @notice Source code information.
     */
    string public source;

    // Events

    /**
     * @notice Emits when the PirexEth contract is set.
     * @dev This event signals that the address of the PirexEth contract has been updated.
     * @param pirexEth address The address of the PirexEth contract.
     */
    event SetPirexEth(address pirexEth);

    /**
     * @notice Emitted when a validator requests to exit.
     * @dev This event signals that a validator with a specific public key has requested to exit.
     * @param validatorPubKey bytes The public key of the exiting validator.
     */
    event RequestValidatorExit(bytes validatorPubKey);

    /**
     * @notice Emitted when the source code is set.
     * @dev This event indicates that the source code string has been updated.
     * @param source string The source code string.
     */
    event SetSourceCode(string source);

    /**
     * @notice Emitted when the subscription ID is set.
     * @dev This event signals that the subscription ID has been updated.
     * @param subscriptionId uint64 The new subscription ID.
     */
    event SetSubscriptionId(uint64 subscriptionId);

    /**
     * @notice Emitted when the gas limit is set.
     * @dev This event signals that the gas limit has been updated.
     * @param gasLimit uint32 The new gas limit.
     */
    event SetGasLimit(uint32 gasLimit);

    /**
     * @notice Constructor to set the Oracle address and initialize access control.
     * @param oracle address Oracle address.
     */
    constructor(address oracle) FunctionsClient(oracle) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @notice Set source code for Chainlink request.
     * @dev Only callable by the admin role.
     * @param _source string Source code to be set.
     */
    function setSourceCode(
        string calldata _source
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        source = _source;
        emit SetSourceCode(_source);
    }

    /**
     * @notice Set subscription identifier for Chainlink request.
     * @dev Only callable by the admin role.
     * @param _subscriptionId uint64 Subscription identifier to be set.
     */
    function setSubscriptionId(
        uint64 _subscriptionId
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        subscriptionId = _subscriptionId;
        emit SetSubscriptionId(_subscriptionId);
    }

    /**
     * @notice Set gas limit for Chainlink request.
     * @dev Only callable by the admin role.
     * @param _gasLimit uint32 Gas limit to be set.
     */
    function setGasLimit(
        uint32 _gasLimit
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        gasLimit = _gasLimit;
        emit SetGasLimit(_gasLimit);
    }

    /**
     * @notice Send the request for voluntary exit.
     * @dev Only callable by the PirexEth contract.
     * @param _pubKey bytes Validator public key.
     */
    function requestVoluntaryExit(bytes calldata _pubKey) external override {
        if (msg.sender != address(pirexEth)) revert Errors.NotPirexEth();

        Functions.Request memory req;

        // Get pubKey
        string[] memory args = new string[](1);
        args[0] = string(_pubKey);

        req.initializeRequest(
            Functions.Location.Inline,
            Functions.CodeLanguage.JavaScript,
            source
        );
        req.addArgs(args);

        bytes32 assignedReqID = sendRequest(req, subscriptionId, gasLimit);
        requestIdToValidatorPubKey[assignedReqID] = _pubKey;
        emit RequestValidatorExit(_pubKey);
    }

    /**
     * @inheritdoc FunctionsClient
     * @dev Internal function to fulfill the Chainlink request and dissolve the validator.
     */
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory
    ) internal override {
        assert(
            keccak256(response) ==
                keccak256(requestIdToValidatorPubKey[requestId])
        );

        // dissolve validator
        pirexEth.dissolveValidator(response);
    }

    /**
     * @notice Set the PirexEth contract address.
     * @dev Only callable by the admin role.
     * @param _pirexEth address  PirexEth contract address.
     */
    function setPirexEth(
        address _pirexEth
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        if (_pirexEth == address(0)) revert Errors.ZeroAddress();

        emit SetPirexEth(_pirexEth);

        pirexEth = IPirexEth(_pirexEth);
    }
}
