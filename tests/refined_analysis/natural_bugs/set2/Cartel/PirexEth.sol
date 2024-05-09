// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {ERC20} from "solmate/tokens/ERC20.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {Errors} from "./libraries/Errors.sol";
import {DataTypes} from "./libraries/DataTypes.sol";
import {IPirexFees} from "./interfaces/IPirexFees.sol";
import {PirexEthValidators} from "./PirexEthValidators.sol";

/**
 * @title  Main contract for handling interactions with pxETH
 * @notice This contract manages various interactions with pxETH, such as deposits, redemptions, and fee adjustments.
 * @dev    This contract inherits from PirexEthValidators and utilizes SafeTransferLib for ERC20 token transfers.
 * @author redactedcartel.finance
 */
contract PirexEth is PirexEthValidators {
    /**
     * @notice Smart contract uses the SafeTransferLib library for secure ERC20 token transfers.
     * @dev    The SafeTransferLib library provides enhanced safety checks and error handling for ERC20 token transfers,
     *         reducing the risk of common vulnerabilities such as reentrancy attacks. By using this library,
     *         the smart contract ensures safer and more reliable interactions with ERC20 tokens.
     */
    using SafeTransferLib for ERC20;

    /**
     * @notice Immutable reference to the Pirex fee repository and distribution contract.
     * @dev    The `pirexFees` variable holds the address of the Pirex fee repository and distribution contract (IPirexFees).
     *         This contract is responsible for managing and distributing fees collected within the Pirex ecosystem.
     *         As an immutable variable, its value is set at deployment and cannot be changed thereafter.
     */
    IPirexFees public immutable pirexFees;

    /**
     * @notice Mapping of maximum fees allowed for different operations in the contract.
     * @dev    The `maxFees` mapping associates each fee type (Deposit, Redemption, InstantRedemption) with its corresponding maximum fee percentage.
     *         For example, a value of 200000 represents a maximum fee of 20% (200000 / 1000000).
     *         Developers can access and modify these maximum fees directly through this public mapping.
     */
    mapping(DataTypes.Fees => uint32) public maxFees;

    /**
     * @notice Mapping of fees for different operations in the contract.
     * @dev    The `fees` mapping associates each fee type (Deposit, Redemption, InstantRedemption) with its corresponding fee percentage.
     *         For example, a value of 5000 represents a 0.5% fee (5000 / 1000000).
     *         Developers can access and modify these fees directly through this public mapping.
     */
    mapping(DataTypes.Fees => uint32) public fees;

    /**
     * @notice Current pause state of the contract.
     * @dev    The `paused` state variable indicates whether certain functionalities of the contract are currently paused or active.
     *         A value of 1 denotes a paused state, while 0 indicates the contract is not paused.
     */
    uint256 public paused;

    // Events
    /**
     * @notice Event emitted when ETH is deposited, minting pxETH, and optionally compounding into the vault.
     * @dev    Use this event to log details about the deposit, including the caller's address, the receiver's address, whether compounding occurred, the deposited amount, received pxETH amount, and fee amount.
     * @param  caller          address  indexed  Address of the entity initiating the deposit.
     * @param  receiver        address  indexed  Address of the receiver of the minted pxETH or apxEth.
     * @param  shouldCompound  bool     indexed  Boolean indicating whether compounding into the vault occurred.
     * @param  deposited       uint256           Amount of ETH deposited.
     * @param  receivedAmount  uint256           Amount of pxETH minted for the receiver.
     * @param  feeAmount       uint256           Amount of pxETH distributed as fees.
     */
    event Deposit(
        address indexed caller,
        address indexed receiver,
        bool indexed shouldCompound,
        uint256 deposited,
        uint256 receivedAmount,
        uint256 feeAmount
    );

    /**
     * @notice Event emitted when a redemption is initiated by burning pxETH in return for upxETH.
     * @dev    Use this event to log details about the redemption initiation, including the redeemed asset amount, post-fee amount, and the receiver's address.
     * @param  assets         uint256           Amount of pxETH burnt for the redemption.
     * @param  postFeeAmount  uint256           Amount of pxETH distributed to the receiver after deducting fees.
     * @param  receiver       address  indexed  Address of the receiver of the upxETH.
     */
    event InitiateRedemption(
        uint256 assets,
        uint256 postFeeAmount,
        address indexed receiver
    );

    /**
     * @notice Event emitted when ETH is redeemed using UpxETH.
     * @dev    Use this event to log details about the redemption, including the tokenId, redeemed asset amount, and the receiver's address.
     * @param  tokenId   uint256           Identifier for the redemption batch.
     * @param  assets    uint256           Amount of ETH redeemed.
     * @param  receiver  address  indexed  Address of the receiver of the redeemed ETH.
     */
    event RedeemWithUpxEth(
        uint256 tokenId,
        uint256 assets,
        address indexed receiver
    );

    /**
     * @notice Event emitted when pxETH is redeemed for ETH with fees.
     * @dev    Use this event to log details about pxETH redemption, including the redeemed asset amount, post-fee amount, and the receiver's address.
     * @param  assets         uint256           Amount of pxETH redeemed.
     * @param  postFeeAmount  uint256           Amount of ETH received by the receiver after deducting fees.
     * @param  _receiver      address  indexed  Address of the receiver of the redeemed ETH.
     */
    event RedeemWithPxEth(
        uint256 assets,
        uint256 postFeeAmount,
        address indexed _receiver
    );

    /**
     * @notice Event emitted when the fee amount for a specific fee type is set.
     * @dev    Use this event to log changes in the fee amount for a particular fee type, including the fee type and the new fee amount.
     * @param  f    DataTypes.Fees  indexed (Deposit, Redemption, InstantRedemption) for which the fee amount is being set.
     * @param  fee  uint32                  New fee amount for the specified fee type.
     */
    event SetFee(DataTypes.Fees indexed f, uint32 fee);

    /**
     * @notice Event emitted when the maximum fee for a specific fee type is set.
     * @dev    Use this event to log changes in the maximum fee for a particular fee type, including the fee type and the new maximum fee.
     * @param  f       DataTypes.Fees  indexed  Deposit, Redemption or InstantRedemption for which the maximum fee is being set.
     * @param  maxFee  uint32                   New maximum fee amount for the specified fee type.
     */
    event SetMaxFee(DataTypes.Fees indexed f, uint32 maxFee);

    /**
     * @notice Event emitted when the contract's pause state is toggled.
     * @dev    Use this event to log changes in the contract's pause state, including the account triggering the change and the new state.
     * @param  account  address  Address of the entity toggling the pause state.
     * @param  state    uint256  New pause state: 1 for paused, 0 for not paused.
     */
    event SetPauseState(address account, uint256 state);

    /**
     * @notice Event emitted when an emergency withdrawal occurs.
     * @dev    Use this event to log details about emergency withdrawals, including the receiver's address, the token involved, and the withdrawn amount.
     * @param  receiver address  indexed  Address of the receiver of the emergency withdrawal.
     * @param  token    address  indexed  Address of the token involved in the emergency withdrawal.
     * @param  amount   uint256           Amount withdrawn in the emergency withdrawal.
     */
    event EmergencyWithdrawal(
        address indexed receiver,
        address indexed token,
        uint256 amount
    );

    // Modifiers
    /**
     * @dev Use this modifier to check if the contract is not currently paused before allowing function execution.
     */
    modifier whenNotPaused() {
        if (paused == _PAUSED) revert Errors.Paused();
        _;
    }

    /**
     * @notice Contract constructor to initialize PirexEthValidator with necessary parameters and configurations.
     * @dev    This constructor sets up the PirexEthValidator contract, configuring key parameters and initializing state variables.
     * @param  _pxEth                      address  PxETH contract address
     * @param  _admin                      address  Admin address
     * @param  _beaconChainDepositContract address  The address of the beacon chain deposit contract
     * @param  _upxEth                     address  UpxETH address
     * @param  _depositSize                uint256  Amount of eth to stake
     * @param  _preDepositAmount           uint256  Amount of ETH for pre-deposit
     * @param  _pirexFees                  address  PirexFees contract address
     * @param  _initialDelay               uint48   Delay required to schedule the acceptance
     *                                              of an access control transfer started
     */
    constructor(
        address _pxEth,
        address _admin,
        address _beaconChainDepositContract,
        address _upxEth,
        uint256 _depositSize,
        uint256 _preDepositAmount,
        address _pirexFees,
        uint48 _initialDelay
    )
        PirexEthValidators(
            _pxEth,
            _admin,
            _beaconChainDepositContract,
            _upxEth,
            _depositSize,
            _preDepositAmount,
            _initialDelay
        )
    {
        if (_pirexFees == address(0)) revert Errors.ZeroAddress();

        pirexFees = IPirexFees(_pirexFees);
        maxFees[DataTypes.Fees.Deposit] = 200_000;
        maxFees[DataTypes.Fees.Redemption] = 200_000;
        maxFees[DataTypes.Fees.InstantRedemption] = 200_000;
        paused = _NOT_PAUSED;
    }

    /*//////////////////////////////////////////////////////////////
                            MUTATIVE FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Set fee
     * @dev    This function allows an entity with the GOVERNANCE_ROLE to set the fee amount for a specific fee type.
     * @param  f    DataTypes.Fees  Fee
     * @param  fee  uint32          Fee amount
     */
    function setFee(
        DataTypes.Fees f,
        uint32 fee
    ) external onlyRole(GOVERNANCE_ROLE) {
        if (fee > maxFees[f]) revert Errors.InvalidFee();

        fees[f] = fee;

        emit SetFee(f, fee);
    }

    /**
     * @notice Set Max fee
     * @dev    This function allows an entity with the GOVERNANCE_ROLE to set the maximum fee for a specific fee type.
     * @param  f       DataTypes.Fees  Fee
     * @param  maxFee  uint32          Max fee amount
     */
    function setMaxFee(
        DataTypes.Fees f,
        uint32 maxFee
    ) external onlyRole(GOVERNANCE_ROLE) {
        if (maxFee < fees[f] || maxFee > DENOMINATOR) revert Errors.InvalidMaxFee();

        maxFees[f] = maxFee;

        emit SetMaxFee(f, maxFee);
    }

    /**
     * @notice Toggle the contract's pause state
     * @dev    This function allows an entity with the GOVERNANCE_ROLE to toggle the contract's pause state.
     */
    function togglePauseState() external onlyRole(GOVERNANCE_ROLE) {
        paused = paused == _PAUSED ? _NOT_PAUSED : _PAUSED;

        emit SetPauseState(msg.sender, paused);
    }

    /**
     * @notice Emergency withdrawal for all ERC20 tokens (except pxETH) and ETH
     * @dev    This function should only be called under major emergency
     * @param  receiver address  Receiver address
     * @param  token    address  Token address
     * @param  amount   uint256  Token amount
     */
    function emergencyWithdraw(
        address receiver,
        address token,
        uint256 amount
    ) external onlyRole(GOVERNANCE_ROLE) onlyWhenDepositEtherPaused {
        if (paused == _NOT_PAUSED) revert Errors.NotPaused();
        if (receiver == address(0)) revert Errors.ZeroAddress();
        if (amount == 0) revert Errors.ZeroAmount();
        if (token == address(pxEth)) revert Errors.InvalidToken();

        if (token == address(0)) {
            // Update pendingDeposit when affected by emergency withdrawal
            uint256 remainingBalance = address(this).balance - amount;
            if (pendingDeposit > remainingBalance) {
                pendingDeposit = remainingBalance;
            }

            // Handle ETH withdrawal
            (bool _success, ) = payable(receiver).call{value: amount}("");
            assert(_success);
        } else {
            ERC20(token).safeTransfer(receiver, amount);
        }

        emit EmergencyWithdrawal(receiver, token, amount);
    }

    /**
     * @notice Handle pxETH minting in return for ETH deposits
     * @dev    This function handles the minting of pxETH in return for ETH deposits.
     * @param  receiver        address  Receiver of the minted pxETH or apxEth
     * @param  shouldCompound  bool     Whether to also compound into the vault
     * @return postFeeAmount   uint256  pxETH minted for the receiver
     * @return feeAmount       uint256  pxETH distributed as fees
     */
    function deposit(
        address receiver,
        bool shouldCompound
    )
        external
        payable
        whenNotPaused
        nonReentrant
        returns (uint256 postFeeAmount, uint256 feeAmount)
    {
        if (msg.value == 0) revert Errors.ZeroAmount();
        if (receiver == address(0)) revert Errors.ZeroAddress();

        // Get the pxETH amounts for the receiver and the protocol (fees)
        (postFeeAmount, feeAmount) = _computeAssetAmounts(
            DataTypes.Fees.Deposit,
            msg.value
        );

        // Mint pxETH for the receiver (or this contract if compounding) excluding fees
        _mintPxEth(shouldCompound ? address(this) : receiver, postFeeAmount);

        if (shouldCompound) {
            // Deposit pxETH excluding fees into the autocompounding vault
            // then mint shares (apxETH) for the user
            autoPxEth.deposit(postFeeAmount, receiver);
        }

        // Mint pxETH for fee distribution contract
        if (feeAmount != 0) {
            _mintPxEth(address(pirexFees), feeAmount);
        }

        // Redirect the deposit to beacon chain deposit contract
        _addPendingDeposit(msg.value);

        emit Deposit(
            msg.sender,
            receiver,
            shouldCompound,
            msg.value,
            postFeeAmount,
            feeAmount
        );
    }

    /**
     * @notice Initiate redemption by burning pxETH in return for upxETH
     * @dev    This function is used to initiate redemption by burning pxETH and receiving upxETH.
     * @param  _assets                      uint256  If caller is AutoPxEth then apxETH; pxETH otherwise.
     * @param  _receiver                    address  Receiver for upxETH.
     * @param  _shouldTriggerValidatorExit  bool     Whether the initiation should trigger voluntary exit.
     * @return postFeeAmount                uint256  pxETH burnt for the receiver.
     * @return feeAmount                    uint256  pxETH distributed as fees.
     */
    function initiateRedemption(
        uint256 _assets,
        address _receiver,
        bool _shouldTriggerValidatorExit
    )
        external
        override
        whenNotPaused
        nonReentrant
        returns (uint256 postFeeAmount, uint256 feeAmount)
    {
        if (_assets == 0) revert Errors.ZeroAmount();
        if (_receiver == address(0)) revert Errors.ZeroAddress();

        uint256 _pxEthAmount;

        if (msg.sender == address(autoPxEth)) {
            // The pxETH amount is calculated as per apxETH-ETH ratio during current block
            _pxEthAmount = autoPxEth.redeem(
                _assets,
                address(this),
                address(this)
            );
        } else {
            _pxEthAmount = _assets;
        }

        // Get the pxETH amounts for the receiver and the protocol (fees)
        (postFeeAmount, feeAmount) = _computeAssetAmounts(
            DataTypes.Fees.Redemption,
            _pxEthAmount
        );

        uint256 _requiredValidators = (pendingWithdrawal + postFeeAmount) /
            DEPOSIT_SIZE;

        if (_shouldTriggerValidatorExit && _requiredValidators == 0)
            revert Errors.NoValidatorExit();

        if (_requiredValidators > getStakingValidatorCount())
            revert Errors.NotEnoughValidators();

        emit InitiateRedemption(_pxEthAmount, postFeeAmount, _receiver);

        address _owner = msg.sender == address(autoPxEth)
            ? address(this)
            : msg.sender;

        _burnPxEth(_owner, postFeeAmount);

        if (feeAmount != 0) {
            // Allow PirexFees to distribute fees directly from sender
            pxEth.operatorApprove(_owner, address(pirexFees), feeAmount);

            // Distribute fees
            pirexFees.distributeFees(_owner, address(pxEth), feeAmount);
        }

        _initiateRedemption(
            postFeeAmount,
            _receiver,
            _shouldTriggerValidatorExit
        );
    }

    /**
     * @notice Bulk redeem back ETH using a set of upxEth identifiers
     * @dev    This function allows the bulk redemption of ETH using upxEth tokens.
     * @param  _tokenIds  uint256[]  Redeem batch identifiers
     * @param  _amounts   uint256[]  Amounts of ETH to redeem for each identifier
     * @param  _receiver  address    Address of the ETH receiver
     */
    function bulkRedeemWithUpxEth(
        uint256[] calldata _tokenIds,
        uint256[] calldata _amounts,
        address _receiver
    ) external whenNotPaused nonReentrant {
        uint256 tLen = _tokenIds.length;
        uint256 aLen = _amounts.length;

        if (tLen == 0) revert Errors.EmptyArray();
        if (tLen != aLen) revert Errors.MismatchedArrayLengths();

        for (uint256 i; i < tLen; ++i) {
            _redeemWithUpxEth(_tokenIds[i], _amounts[i], _receiver);
        }
    }

    /**
     * @notice Redeem back ETH using a single upxEth identifier
     * @dev    This function allows the redemption of ETH using upxEth tokens.
     * @param  _tokenId  uint256  Redeem batch identifier
     * @param  _assets   uint256  Amount of ETH to redeem
     * @param  _receiver  address  Address of the ETH receiver
     */
    function redeemWithUpxEth(
        uint256 _tokenId,
        uint256 _assets,
        address _receiver
    ) external whenNotPaused nonReentrant {
        _redeemWithUpxEth(_tokenId, _assets, _receiver);
    }

    /**
     * @notice Instant redeem back ETH using pxETH
     * @dev    This function burns pxETH, calculates fees, and transfers ETH to the receiver.
     * @param  _assets        uint256   Amount of pxETH to redeem.
     * @param  _receiver      address   Address of the ETH receiver.
     * @return postFeeAmount  uint256   Post-fee amount for the receiver.
     * @return feeAmount      uinit256  Fee amount sent to the PirexFees.
     */
    function instantRedeemWithPxEth(
        uint256 _assets,
        address _receiver
    )
        external
        whenNotPaused
        nonReentrant
        returns (uint256 postFeeAmount, uint256 feeAmount)
    {
        if (_assets == 0) revert Errors.ZeroAmount();
        if (_receiver == address(0)) revert Errors.ZeroAddress();

        // Get the pxETH amounts for the receiver and the protocol (fees)
        (postFeeAmount, feeAmount) = _computeAssetAmounts(
            DataTypes.Fees.InstantRedemption,
            _assets
        );

        if (postFeeAmount > buffer) revert Errors.NotEnoughBuffer();

        if (feeAmount != 0) {
            // Allow PirexFees to distribute fees directly from sender
            pxEth.operatorApprove(msg.sender, address(pirexFees), feeAmount);

            // Distribute fees
            pirexFees.distributeFees(msg.sender, address(pxEth), feeAmount);
        }

        _burnPxEth(msg.sender, postFeeAmount);
        buffer -= postFeeAmount;

        (bool _success, ) = payable(_receiver).call{value: postFeeAmount}("");
        assert(_success);

        emit RedeemWithPxEth(_assets, postFeeAmount, _receiver);
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Redeem back ETH using upxEth
     * @dev    This function allows the redemption of ETH using upxEth tokens.
     * @param  _tokenId  uint256  Redeem batch identifier
     * @param  _assets   uint256  Amount of ETH to redeem
     * @param  _receiver  address  Address of the ETH receiver
     */
    function _redeemWithUpxEth(
        uint256 _tokenId,
        uint256 _assets,
        address _receiver
    ) internal {
        if (_assets == 0) revert Errors.ZeroAmount();
        if (_receiver == address(0)) revert Errors.ZeroAddress();

        DataTypes.ValidatorStatus _validatorStatus = status[
            batchIdToValidator[_tokenId]
        ];

        if (
            _validatorStatus != DataTypes.ValidatorStatus.Dissolved &&
            _validatorStatus != DataTypes.ValidatorStatus.Slashed
        ) {
            revert Errors.StatusNotDissolvedOrSlashed();
        }

        if (outstandingRedemptions < _assets) revert Errors.NotEnoughETH();

        outstandingRedemptions -= _assets;
        upxEth.burn(msg.sender, _tokenId, _assets);

        (bool _success, ) = payable(_receiver).call{value: _assets}("");
        assert(_success);

        emit RedeemWithUpxEth(_tokenId, _assets, _receiver);
    }

    /**
     * @dev     This function calculates the post-fee asset amount and fee amount based on the specified fee type and total assets.
     * @param   f              DataTypes.Fees  representing the fee type.
     * @param   assets         uint256         Total ETH or pxETH asset amount.
     * @return  postFeeAmount  uint256         Post-fee asset amount (for mint/burn/claim/etc.).
     * @return  feeAmount      uint256         Fee amount.
     */
    function _computeAssetAmounts(
        DataTypes.Fees f,
        uint256 assets
    ) internal view returns (uint256 postFeeAmount, uint256 feeAmount) {
        feeAmount = (assets * fees[f]) / DENOMINATOR;
        postFeeAmount = assets - feeAmount;
    }
}
