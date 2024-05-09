// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {ReentrancyGuard} from "solmate/utils/ReentrancyGuard.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {AccessControlDefaultAdminRules} from "openzeppelin-contracts/contracts/access/AccessControlDefaultAdminRules.sol";
import {UpxEth} from "./tokens/UpxEth.sol";
import {Errors} from "./libraries/Errors.sol";
import {DataTypes} from "./libraries/DataTypes.sol";
import {ValidatorQueue} from "./libraries/ValidatorQueue.sol";
import {IOracleAdapter} from "./interfaces/IOracleAdapter.sol";
import {IPirexEth} from "./interfaces/IPirexEth.sol";
import {IDepositContract} from "./interfaces/IDepositContract.sol";
import {AutoPxEth} from "./AutoPxEth.sol";
import {PxEth} from "./PxEth.sol";

/**
 * @title  PirexEthValidators
 * @notice Manages validators and deposits for the Eth2.0 deposit contract
 * @dev    This contract includes functionality for handling validator-related operations and deposits.
 * @author redactedcartel.finance
 */
abstract contract PirexEthValidators is
    ReentrancyGuard,
    AccessControlDefaultAdminRules,
    IPirexEth
{
    /**
     * @dev This library provides enhanced safety features for ERC20 token transfers, reducing the risk of common vulnerabilities.
     */
    using ValidatorQueue for DataTypes.ValidatorDeque;
    /**
     * @dev This library extends the functionality of the DataTypes.ValidatorDeque data structure to facilitate validator management.
     */
    using SafeTransferLib for ERC20;

    /**
     * @notice Denominator used for mathematical calculations.
     * @dev    This constant is used as a divisor in various mathematical calculations
     *         throughout the contract to achieve precise percentages and ratios.
     */
    uint256 internal constant DENOMINATOR = 1_000_000;

    // Roles
    /**
     * @notice The role assigned to external keepers responsible for specific protocol functions.
     * @dev    This role is assigned to external entities that are responsible for performing specific
     *         functions within the protocol, such as validator upkeep and maintenance.
     */
    bytes32 internal constant KEEPER_ROLE = keccak256("KEEPER_ROLE");

    /**
     * @notice The role assigned to governance entities responsible for managing protocol parameters.
     * @dev    This role is assigned to governance entities that have the authority to manage and
     *         update various protocol parameters, ensuring the smooth operation and evolution of the protocol.
     */
    bytes32 internal constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    /**
     * @notice Paused status indicator when depositing Ether is not paused.
     * @dev    This constant represents the status indicator when depositing Ether is not paused.
     *         It is used as a reference for the depositEtherPaused state variable to determine whether
     *         depositing Ether is currently allowed or paused.
     */
    uint256 internal constant _NOT_PAUSED = 1;

    /**
     * @notice Paused status indicator when depositing Ether is paused.
     * @dev    This constant represents the status indicator when depositing Ether is paused.
     *         It is used as a reference for the depositEtherPaused state variable to determine
     *         whether depositing Ether is currently allowed or paused.
     */
    uint256 internal constant _PAUSED = 2;

    /**
     * @notice The address of the external beacon chain deposit contract.
     * @dev    This variable holds the immutable address of the external beacon chain deposit contract.
     *         It is used to interact with the contract for depositing validators to the Ethereum 2.0 beacon chain.
     */
    address public immutable beaconChainDepositContract;

    /**
     * @notice The amount of Ether that a validator must deposit before being added to the initialized validator queue.
     * @dev    This variable represents the immutable pre-deposit amount required for a validator to be added to the initialized validator queue.
     *         Validators need to deposit this amount of Ether to be put in initialized validator queue.
     */
    uint256 public immutable preDepositAmount;

    /**
     * @notice The default deposit size for validators, set once during contract initialization.
     * @dev    This variable represents the immutable default deposit size for validators.
     *         It is set during the contract initialization and represents the amount of Ether a validator needs to deposit
     *         to participate in the Ethereum 2.0 staking process.
     */
    uint256 public immutable DEPOSIT_SIZE;

    /**
     * @notice The withdrawal credentials used when processing validator withdrawals.
     * @dev    This variable holds the withdrawal credentials, which are used to receive valdiator rewards
     */
    bytes public withdrawalCredentials;

    /**
     * @notice Buffer for instant withdrawals and emergency top-ups.
     * @dev    This variable represents the buffer amount,
     *         which is utilized for immediate withdrawals and emergency top-ups.
     *         It serves as a reserve to facilitate rapid withdrawals or cover unexpected events within the protocol.
     */
    uint256 public buffer;

    /**
     * @notice Maximum buffer size for instant withdrawals and emergency top-ups.
     * @dev    This variable represents the upper limit for the buffer size,
     *         determining the maximum amount that can be reserved for immediate withdrawals,
     *         and emergency top-ups in the protocol.
     */
    uint256 public maxBufferSize;

    /**
     * @notice Percentage of pxEth total supply allocated to determine the max buffer size.
     * @dev    This variable represents the percentage of the total supply of pxEth that is allocated
     *         to determine the maximum buffer size. It influences the dynamic adjustment of the buffer
     *         size based on the total supply of pxEth in the protocol.
     */
    uint256 public maxBufferSizePct;

    /**
     * @notice Maximum count of validators to be processed in a single `_deposit` call.
     * @dev    This variable determines the maximum number of validators that can be processed in a single call to the `_deposit` function.
     *         It helps control the efficiency and gas cost of the depositing process.
     */
    uint256 public maxProcessedValidatorCount = 20;

    // Pirex contracts
    /**
     * @notice The UpxEth contract responsible for managing the upxEth token.
     * @dev    This variable holds the address of the UpxEth contract,
     *         which represents pending redemption.
     */
    UpxEth public upxEth;

    /**
     * @notice The PxEth contract responsible for managing the pxEth token.
     * @dev    This variable holds the address of the PxEth contract,
     *         which represents ETH deposit made to Dinero protocol.
     */
    PxEth public pxEth;

    /**
     * @notice The AutoPxEth contract responsible for automated management of the pxEth token.
     * @dev    This variable holds the address of the AutoPxEth contract,
     *         which represents pxEth deposit to auto compounding vault.
     */
    AutoPxEth public autoPxEth;

    /**
     * @notice The OracleAdapter contract responsible for interfacing with the oracle for protocol data.
     * @dev    This variable holds the address of the OracleAdapter contract,
     *         which is used to request validator exit and update its status to dissolves or slashed.
     */
    IOracleAdapter public oracleAdapter;

    /**
     * @notice The address designated as the reward recipient for protocol incentives.
     * @dev    This variable holds the address of the entity designated to receive consensus,
     *         execution and MEV rewards.
     */
    address public rewardRecipient;

    /**
     * @notice Indicator for whether depositing Ether to the beacon chain deposit contract is paused or not.
     * @dev    This variable holds the status indicator (paused or not) for depositing Ether to the beacon chain deposit contract.
     */
    uint256 public depositEtherPaused;

    /**
     * @notice Buffer for pending deposits to be staked, r
     *         equired to be greater than or equal to multiples of DEPOSIT_SIZE, including preDepositAmount.
     * @dev    This variable holds the amount of pending deposits that are waiting to be staked.
     *         It ensures that the buffer size is sufficient for multiples of DEPOSIT_SIZE, including preDepositAmount.
     */
    uint256 public pendingDeposit;

    /**
     * @notice Queue to prioritize validator spinning on a FIFO basis.
     * @dev    This internal variable represents a deque (double-ended queue) used to prioritize validator
     *         spinning based on a First-In-First-Out (FIFO) basis.
     */
    DataTypes.ValidatorDeque internal _initializedValidators;

    /**
     * @notice Queue to prioritize the next validator to be exited when required on a FIFO basis.
     * @dev    This internal variable represents a deque (double-ended queue) used to prioritize validators
     *         for exiting based on a First-In-First-Out (FIFO) basis.
     */
    DataTypes.ValidatorDeque internal _stakingValidators;

    /**
     * @notice Buffer for withdrawals to be unstaked, required to be greater than or equal to multiples of DEPOSIT_SIZE.
     * @dev    This variable holds the amount of Ether that is pending withdrawal,
     *         and it must be greater than or equal to multiples of DEPOSIT_SIZE.
     */
    uint256 public pendingWithdrawal;

    /**
     * @notice ETH available for redemptions.
     * @dev    This variable represents the amount of Ether available for redemptions by burning upxEth.
     */
    uint256 public outstandingRedemptions;

    /**
     * @notice Batch Id for validator's voluntary exit.
     * @dev    This variable represents the batch ID for a validator's voluntary exit.
     */
    uint256 public batchId;

    /**
     * @notice End block for the ETH rewards calculation.
     * @dev    This variable represents the block number until which ETH rewards are computed.
     */
    uint256 public endBlock;

    /**
     * @notice Validator statuses, mapping from validator public key to their status.
     * @dev    This mapping tracks the status of each validator, using their public key as the identifier.
     */
    mapping(bytes => DataTypes.ValidatorStatus) public status;

    /**
     * @notice Mapping from batchId to validator public key.
     * @dev    This mapping tracks the batch ID of each unstaked validator
     */
    mapping(uint256 => bytes) public batchIdToValidator;

    /**
     * @notice Accounts designated for burning pxEth when the buffer is used for top-up and the validator is slashed.
     * @dev    This mapping identifies accounts designated for burning pxEth under specific conditions.
     */
    mapping(address => bool) public burnerAccounts;

    // Events
    /**
     * @notice Emitted when a validator is deposited, indicating the addition of a new validator.
     * @dev    This event is triggered when a user deposits ETH for staking, creating a new validator.
     *         Validators play a crucial role in the proof-of-stake consensus mechanism and contribute
     *         to the security and functionality of the network. The `pubKey` parameter represents the public key of the deposited validator.
     * @param pubKey bytes Public key of the deposited validator.
     */
    event ValidatorDeposit(bytes pubKey);

    /**
     * @notice Emitted when a contract address is set.
     * @dev    This event is triggered when a contract address is set for a specific contract type.
     * @param  c                DataTypes.Contract  The type of the contract being set.
     * @param  contractAddress  address             The address of the contract being set.
     */
    event SetContract(DataTypes.Contract indexed c, address contractAddress);

    /**
     * @notice Emitted when the status of depositing Ether is paused or unpaused.
     * @dev    This event is triggered when there is a change in the status of depositing Ether.
     *         The `newStatus` parameter indicates whether depositing Ether is currently paused or unpaused.
     *         Pausing depositing Ether can be useful in certain scenarios, such as during contract upgrades or emergency situations.
     * @param  newStatus  uint256  The new status indicating whether depositing Ether is paused or unpaused.
     */
    event DepositEtherPaused(uint256 newStatus);

    /**
     * @notice Emitted when harvesting rewards.
     * @dev    This event is triggered when rewards are harvested. The `amount` parameter indicates the amount of rewards harvested,
     *         and the `endBlock` parameter specifies the block until which ETH rewards are computed.
     * @param  amount    uint256  The amount of rewards harvested.
     * @param  endBlock  uint256  The block until which ETH rewards are computed.
     */
    event Harvest(uint256 amount, uint256 endBlock);

    /**
     * @notice Emitted when the max buffer size percentage is set.
     * @dev    This event is triggered when the max buffer size percentage is updated.
     *         The `pct` parameter represents the new max buffer size percentage.
     * @param  pct  uint256  The new max buffer size percentage.
     */
    event SetMaxBufferSizePct(uint256 pct);

    /**
     * @notice Emitted when a burner account is approved.
     * @dev    This event is triggered when a burner account is approved.
     *         The `account` parameter represents the approved burner account.
     * @param  account  address  The approved burner account.
     */
    event ApproveBurnerAccount(address indexed account);

    /**
     * @notice Emitted when a burner account is revoked.
     * @dev    This event is triggered when a burner account is revoked.
     *         The `account` parameter represents the revoked burner account.
     * @param  account  address  The revoked burner account.
     */
    event RevokeBurnerAccount(address indexed account);

    /**
     * @notice Emitted when a validator is dissolved.
     * @dev    This event is triggered when a validator is dissolved, indicating the update of the validator state.
     * @param  pubKey  bytes  Public key of the dissolved validator.
     */
    event DissolveValidator(bytes pubKey);

    /**
     * @notice Emitted when a validator is slashed.
     * @dev    This event is triggered when a validator is slashed, indicating the slashing action and its details.
     * @param  pubKey          bytes    Public key of the slashed validator.
     * @param  useBuffer       bool     Indicates whether a buffer is used during slashing.
     * @param  releasedAmount  uint256  Amount released from the Beacon chain.
     * @param  penalty         uint256  Penalty amount.
     */
    event SlashValidator(
        bytes pubKey,
        bool useBuffer,
        uint256 releasedAmount,
        uint256 penalty
    );

    /**
     * @notice Emitted when a validator's stake is topped up.
     * @dev    This event is triggered when a validator's stake is topped up, indicating the top-up action and its details.
     * @param  pubKey       bytes    Public key of the topped-up validator.
     * @param  useBuffer    bool     Indicates whether a buffer is used during topping up.
     * @param  topUpAmount  uint256  Amount topped up.
     */
    event TopUp(bytes pubKey, bool useBuffer, uint256 topUpAmount);

    /**
     * @notice Emitted when the maximum processed validator count is set.
     * @dev    This event is triggered when the maximum count of processed validators is set, indicating a change in the processing limit.
     * @param  count  uint256  The new maximum count of processed validators.
     */
    event SetMaxProcessedValidatorCount(uint256 count);

    /**
     * @notice Emitted when the max buffer size is updated.
     * @dev    This event is triggered when max buffer size is updated
     * @param  maxBufferSize  uint256  The updated maximum buffer size.
     */
    event UpdateMaxBufferSize(uint256 maxBufferSize);

    /**
     * @notice Emitted when the withdrawal credentials are set.
     * @dev    This event is triggered when the withdrawal credentials are updated, indicating a change in the credentials used for validator withdrawals.
     * @param  withdrawalCredentials  bytes  The new withdrawal credentials.
     */
    event SetWithdrawCredentials(bytes withdrawalCredentials);

    // Modifiers
    /**
     * @dev Reverts if the sender is not the specified reward recipient. Used to control access to functions that
     *      are intended for the designated recipient of rewards.
     */
    modifier onlyRewardRecipient() {
        if (msg.sender != rewardRecipient) revert Errors.NotRewardRecipient();
        _;
    }

    /**
     * @dev Reverts if depositing Ether is not paused. Used to control access to functions that should only be
     *      callable when depositing Ether is in a paused state.
     */
    modifier onlyWhenDepositEtherPaused() {
        if (depositEtherPaused == _NOT_PAUSED)
            revert Errors.DepositingEtherNotPaused();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                        CONSTRUCTOR/INITIALIZATION LOGIC
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Initializes the PirexEthValidators contract.
     * @dev    Initializes the contract with the provided parameters and sets up the initial state.
     * @param  _pxEth                      address  PxETH contract address
     * @param  _admin                      address  Admin address
     * @param  _beaconChainDepositContract address  The address of the deposit precompile
     * @param  _upxEth                     address  UpxETH address
     * @param  _depositSize                uint256  Amount of ETH to stake
     * @param  _preDepositAmount           uint256  Amount of ETH for pre-deposit
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
        uint48 _initialDelay
    ) AccessControlDefaultAdminRules(_initialDelay, _admin) {
        if (_pxEth == address(0)) revert Errors.ZeroAddress();
        if (_beaconChainDepositContract == address(0))
            revert Errors.ZeroAddress();
        if (_upxEth == address(0)) revert Errors.ZeroAddress();
        if (_depositSize < 1 ether && _depositSize % 1 gwei != 0)
            revert Errors.ZeroMultiplier();
        if (
            _preDepositAmount > _depositSize ||
            _preDepositAmount < 1 ether ||
            _preDepositAmount % 1 gwei != 0
        ) revert Errors.ZeroMultiplier();

        pxEth = PxEth(_pxEth);
        DEPOSIT_SIZE = _depositSize;
        beaconChainDepositContract = _beaconChainDepositContract;
        preDepositAmount = _preDepositAmount;
        upxEth = UpxEth(_upxEth);
        depositEtherPaused = _NOT_PAUSED;
    }

    /*//////////////////////////////////////////////////////////////
                                VIEW
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Get the number of initialized validators
     * @dev    Returns the count of validators that are ready to be staked.
     * @return uint256 count of validators ready to be staked
     */
    function getInitializedValidatorCount() external view returns (uint256) {
        return _initializedValidators.count();
    }

    /**
     * @notice Get the number of staked validators
     * @dev    Returns the count of validators with staking status.
     * @return uint256 count of validators with staking status
     */
    function getStakingValidatorCount() public view returns (uint256) {
        return _stakingValidators.count();
    }

    /**
     * @notice Get the initialized validator info at the specified index
     * @dev    Returns the details of the initialized validator at the given index.
     * @param  _i  uint256  Index
     * @return     bytes    Public key
     * @return     bytes    Withdrawal credentials
     * @return     bytes    Signature
     * @return     bytes32  Deposit data root hash
     * @return     address  pxETH receiver
     */
    function getInitializedValidatorAt(
        uint256 _i
    )
        external
        view
        returns (bytes memory, bytes memory, bytes memory, bytes32, address)
    {
        return _initializedValidators.get(withdrawalCredentials, _i);
    }

    /**
     * @notice Get the staking validator info at the specified index
     * @dev    Returns the details of the staking validator at the given index.
     * @param  _i  uint256  Index
     * @return     bytes    Public key
     * @return     bytes    Withdrawal credentials
     * @return     bytes    Signature
     * @return     bytes32  Deposit data root hash
     * @return     address  pxETH receiver
     */
    function getStakingValidatorAt(
        uint256 _i
    )
        external
        view
        returns (bytes memory, bytes memory, bytes memory, bytes32, address)
    {
        return _stakingValidators.get(withdrawalCredentials, _i);
    }

    /*//////////////////////////////////////////////////////////////
                        RESTRICTED FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Set a contract address
     * @dev    Allows the governance role to set the address for a contract in the system.
     * @param  _contract        DataTypes.Contract  Contract
     * @param  contractAddress  address             Contract address
     */
    function setContract(
        DataTypes.Contract _contract,
        address contractAddress
    ) external onlyRole(GOVERNANCE_ROLE) {
        if (contractAddress == address(0)) revert Errors.ZeroAddress();

        emit SetContract(_contract, contractAddress);

        if (_contract == DataTypes.Contract.UpxEth) {
            upxEth = UpxEth(contractAddress);
        } else if (_contract == DataTypes.Contract.PxEth) {
            pxEth = PxEth(contractAddress);
        } else if (_contract == DataTypes.Contract.AutoPxEth) {
            ERC20 pxEthERC20 = ERC20(address(pxEth));
            address oldVault = address(autoPxEth);

            if (oldVault != address(0)) {
                pxEthERC20.safeApprove(oldVault, 0);
            }

            autoPxEth = AutoPxEth(contractAddress);
            pxEthERC20.safeApprove(address(autoPxEth), type(uint256).max);
        } else if (_contract == DataTypes.Contract.OracleAdapter) {
            oracleAdapter = IOracleAdapter(contractAddress);
        } else if (_contract == DataTypes.Contract.RewardRecipient) {
            rewardRecipient = contractAddress;
            withdrawalCredentials = abi.encodePacked(
                bytes1(0x01),
                bytes11(0x0),
                contractAddress
            );

            emit SetWithdrawCredentials(withdrawalCredentials);
        } else {
            revert Errors.UnrecorgnisedContract();
        }
    }

    /**
     * @notice Set the percentage that will be applied to total supply of pxEth to determine maxBufferSize
     * @dev    Allows the governance role to set the percentage of the total supply of pxEth that will be used as maxBufferSize.
     * @param  _pct  uint256  Max buffer size percentage
     */
    function setMaxBufferSizePct(
        uint256 _pct
    ) external onlyRole(GOVERNANCE_ROLE) {
        if (_pct > DENOMINATOR) {
            revert Errors.ExceedsMax();
        }

        maxBufferSizePct = _pct;

        emit SetMaxBufferSizePct(_pct);
    }

    /**
     * @notice Set the maximum count of validators to be processed in a single _deposit call
     * @dev    Only the role with the GOVERNANCE_ROLE can execute this function.
     * @param _count  uint256  Maximum count of validators to be processed
     */
    function setMaxProcessedValidatorCount(
        uint256 _count
    ) external onlyRole(GOVERNANCE_ROLE) {
        if (_count == 0) {
            revert Errors.InvalidMaxProcessedCount();
        }

        maxProcessedValidatorCount = _count;

        emit SetMaxProcessedValidatorCount(_count);
    }

    /**
     * @notice Toggle the ability to deposit ETH to validators
     * @dev    Only the role with the GOVERNANCE_ROLE can execute this function.
     */
    function togglePauseDepositEther() external onlyRole(GOVERNANCE_ROLE) {
        depositEtherPaused = depositEtherPaused == _NOT_PAUSED
            ? _PAUSED
            : _NOT_PAUSED;

        emit DepositEtherPaused(depositEtherPaused);
    }

    /**
     * @notice Approve or revoke addresses as burner accounts
     * @dev    Only the role with the GOVERNANCE_ROLE can execute this function.
     * @param _accounts  address[]  An array of addresses to be approved or revoked as burner accounts.
     * @param _state     bool       A boolean indicating whether to approve (true) or revoke (false) the burner account state.
     */
    function toggleBurnerAccounts(
        address[] calldata _accounts,
        bool _state
    ) external onlyRole(GOVERNANCE_ROLE) {
        uint256 _len = _accounts.length;

        for (uint256 _i; _i < _len; ) {
            address account = _accounts[_i];

            burnerAccounts[account] = _state;

            if (_state) {
                emit ApproveBurnerAccount(account);
            } else {
                emit RevokeBurnerAccount(account);
            }

            unchecked {
                ++_i;
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                            MUTATIVE FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Update validator to Dissolve once Oracle confirms ETH release
     * @dev    Only the reward recipient can initiate the dissolution process.
     * @param  _pubKey  bytes  The public key of the validator to be dissolved.
     */
    function dissolveValidator(
        bytes calldata _pubKey
    ) external payable override onlyRewardRecipient {
        uint256 _amount = msg.value;
        if (_amount != DEPOSIT_SIZE) revert Errors.InvalidAmount();
        if (status[_pubKey] != DataTypes.ValidatorStatus.Withdrawable)
            revert Errors.NotWithdrawable();

        status[_pubKey] = DataTypes.ValidatorStatus.Dissolved;

        outstandingRedemptions += _amount;

        emit DissolveValidator(_pubKey);
    }

    /**
     * @notice Update validator state to be slashed
     * @dev    Only the reward recipient can initiate the slashing process.
     * @param  _pubKey          bytes                      The public key of the validator to be slashed.
     * @param  _removeIndex     uint256                    Index of the validator to be slashed.
     * @param  _amount          uint256                    ETH amount released from the Beacon chain.
     * @param  _unordered       bool                       Whether to remove from the staking validator queue in order or not.
     * @param  _useBuffer       bool                       Whether to use the buffer to compensate for the loss.
     * @param  _burnerAccounts  DataTypes.BurnerAccount[]  Burner accounts providing additional compensation.
     */
    function slashValidator(
        bytes calldata _pubKey,
        uint256 _removeIndex,
        uint256 _amount,
        bool _unordered,
        bool _useBuffer,
        DataTypes.BurnerAccount[] calldata _burnerAccounts
    ) external payable override onlyRewardRecipient {
        uint256 _ethAmount = msg.value;
        uint256 _defaultDepositSize = DEPOSIT_SIZE;
        DataTypes.ValidatorStatus _status = status[_pubKey];

        if (
            _status != DataTypes.ValidatorStatus.Staking &&
            _status != DataTypes.ValidatorStatus.Withdrawable
        ) revert Errors.StatusNotWithdrawableOrStaking();

        if (_useBuffer) {
            _updateBuffer(_defaultDepositSize - _ethAmount, _burnerAccounts);
        } else if (_ethAmount != _defaultDepositSize) {
            revert Errors.InvalidAmount();
        }

        // It is possible that validator can be slashed while exiting
        if (_status == DataTypes.ValidatorStatus.Staking) {
            bytes memory _removedPubKey;

            if (!_unordered) {
                _removedPubKey = _stakingValidators.removeOrdered(_removeIndex);
            } else {
                _removedPubKey = _stakingValidators.removeUnordered(
                    _removeIndex
                );
            }

            assert(keccak256(_pubKey) == keccak256(_removedPubKey));

            _addPendingDeposit(_defaultDepositSize);
        } else {
            outstandingRedemptions += _defaultDepositSize;
        }
        status[_pubKey] = DataTypes.ValidatorStatus.Slashed;

        emit SlashValidator(
            _pubKey,
            _useBuffer,
            _amount,
            DEPOSIT_SIZE - _amount
        );
    }

    /**
     * @notice Add multiple synced validators in the queue to be ready for staking.
     * @dev    Only callable when depositing Ether is paused and by a user with the GOVERNANCE_ROLE.
     * @param  _validators  DataTypes.Validator[]  An array of validator details (public key, withdrawal credentials, etc.).
     */
    function addInitializedValidators(
        DataTypes.Validator[] memory _validators
    ) external onlyWhenDepositEtherPaused onlyRole(GOVERNANCE_ROLE) {
        uint256 _arrayLength = _validators.length;
        for (uint256 _i; _i < _arrayLength; ) {
            if (
                status[_validators[_i].pubKey] != DataTypes.ValidatorStatus.None
            ) revert Errors.NoUsedValidator();

            _initializedValidators.add(_validators[_i], withdrawalCredentials);

            unchecked {
                ++_i;
            }
        }
    }

    /**
     * @notice Swap initialized validators specified by the indexes.
     * @dev    Only callable when depositing Ether is paused and by a user with the GOVERNANCE_ROLE.
     * @param  _fromIndex  uint256  The index of the validator to be swapped from.
     * @param  _toIndex    uint256  The index of the validator to be swapped to.
     */
    function swapInitializedValidator(
        uint256 _fromIndex,
        uint256 _toIndex
    ) external onlyWhenDepositEtherPaused onlyRole(GOVERNANCE_ROLE) {
        _initializedValidators.swap(_fromIndex, _toIndex);
    }

    /**
     * @notice Pop initialized validators from the queue.
     * @dev    Only callable when depositing Ether is paused and by a user with the GOVERNANCE_ROLE.
     * @param  _times  uint256  The count of pop operations to be performed.
     */
    function popInitializedValidator(
        uint256 _times
    ) external onlyWhenDepositEtherPaused onlyRole(GOVERNANCE_ROLE) {
        _initializedValidators.pop(_times);
    }

    /**
     * @notice Remove an initialized validator from the queue.
     * @dev    Only callable when depositing Ether is paused and by a user with the GOVERNANCE_ROLE.
     * @param  _pubKey       bytes    The public key of the validator to be removed.
     * @param  _removeIndex  uint256  The index of the validator to be removed.
     * @param  _unordered    bool     A flag indicating whether removal should be unordered (true) or ordered (false).
     */
    function removeInitializedValidator(
        bytes calldata _pubKey,
        uint256 _removeIndex,
        bool _unordered
    ) external onlyWhenDepositEtherPaused onlyRole(GOVERNANCE_ROLE) {
        bytes memory _removedPubKey;

        if (_unordered) {
            _removedPubKey = _initializedValidators.removeUnordered(
                _removeIndex
            );
        } else {
            _removedPubKey = _initializedValidators.removeOrdered(_removeIndex);
        }

        assert(keccak256(_removedPubKey) == keccak256(_pubKey));
    }

    /**
     * @notice Clear all initialized validators from the queue.
     * @dev    Only callable when depositing Ether is paused and by a user with the GOVERNANCE_ROLE.
     */
    function clearInitializedValidator()
        external
        onlyWhenDepositEtherPaused
        onlyRole(GOVERNANCE_ROLE)
    {
        _initializedValidators.clear();
    }

    /**
     * @notice Trigger a privileged deposit to the ETH 2.0 deposit contract.
     * @dev    Only callable by a user with the KEEPER_ROLE and ensures that depositing Ether is not paused.
     *         This function initiates the deposit process to the ETH 2.0 deposit contract.
     */
    function depositPrivileged() external nonReentrant onlyRole(KEEPER_ROLE) {
        // Initial pause check
        if (depositEtherPaused == _PAUSED)
            revert Errors.DepositingEtherPaused();

        _deposit();
    }

    /**
     * @notice Top up ETH to a staking validator if the current balance drops below the effective balance.
     * @dev    Only callable by a user with the KEEPER_ROLE.
     * @param  _pubKey           bytes                      Validator public key.
     * @param  _signature        bytes                      A BLS12-381 signature.
     * @param  _depositDataRoot  bytes32                    The SHA-256 hash of the SSZ-encoded DepositData object.
     * @param  _topUpAmount      uint256                    Top-up amount in ETH.
     * @param  _useBuffer        bool                       Whether to use a buffer to compensate for the loss.
     * @param  _burnerAccounts   DataTypes.BurnerAccount[]  Array of burner accounts.
     */
    function topUpStake(
        bytes calldata _pubKey,
        bytes calldata _signature,
        bytes32 _depositDataRoot,
        uint256 _topUpAmount,
        bool _useBuffer,
        DataTypes.BurnerAccount[] calldata _burnerAccounts
    ) external payable nonReentrant onlyRole(KEEPER_ROLE) {
        if (status[_pubKey] != DataTypes.ValidatorStatus.Staking)
            revert Errors.ValidatorNotStaking();

        if (_useBuffer) {
            if (msg.value > 0) {
                revert Errors.NoETHAllowed();
            }
            _updateBuffer(_topUpAmount, _burnerAccounts);
        } else if (msg.value != _topUpAmount) {
            revert Errors.NoETH();
        }

        (bool success, ) = beaconChainDepositContract.call{value: _topUpAmount}(
            abi.encodeCall(
                IDepositContract.deposit,
                (_pubKey, withdrawalCredentials, _signature, _depositDataRoot)
            )
        );

        assert(success);

        emit TopUp(_pubKey, _useBuffer, _topUpAmount);
    }

    /**
     * @notice Harvest and mint staking rewards when available.
     * @dev    Only callable by the reward recipient.
     * @param  _endBlock  uint256  Block until which ETH rewards are computed.
     */
    function harvest(
        uint256 _endBlock
    ) external payable override onlyRewardRecipient {
        if (msg.value != 0) {
            // update end block
            endBlock = _endBlock;

            // Mint pxETH directly for the vault
            _mintPxEth(address(autoPxEth), msg.value);

            // Update rewards tracking with the newly added rewards
            autoPxEth.notifyRewardAmount();

            // Direct the excess balance for pending deposit
            _addPendingDeposit(msg.value);

            emit Harvest(msg.value, _endBlock);
        }
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev   Mints the specified amount of pxETH and updates the maximum buffer size.
     * @param _account  address  The address to which pxETH will be minted.
     * @param _amount   uint256  The amount of pxETH to be minted.
     */
    function _mintPxEth(address _account, uint256 _amount) internal {
        pxEth.mint(_account, _amount);
        uint256 _maxBufferSize = (pxEth.totalSupply() * maxBufferSizePct) /
            DENOMINATOR;
        maxBufferSize = _maxBufferSize;
        emit UpdateMaxBufferSize(_maxBufferSize);
    }

    /**
     * @dev   Burns the specified amount of pxETH from the given account and updates the maximum buffer size.
     * @param _account  address  The address from which pxETH will be burned.
     * @param _amount   uint256  The amount of pxETH to be burned.
     */
    function _burnPxEth(address _account, uint256 _amount) internal {
        pxEth.burn(_account, _amount);
        uint256 _maxBufferSize = (pxEth.totalSupply() * maxBufferSizePct) /
            DENOMINATOR;
        maxBufferSize = _maxBufferSize;
        emit UpdateMaxBufferSize(_maxBufferSize);
    }

    /**
     * @dev Processes the deposit of validators, taking into account the maximum processed validator count,
     *      the remaining deposit amount, and the status of initialized validators. It iterates through initialized
     *      validators, deposits them into the Beacon chain, mints pxETH if needed, and updates the validator status.
     */
    function _deposit() internal {
        uint256 remainingCount = maxProcessedValidatorCount;
        uint256 _remainingdepositAmount = DEPOSIT_SIZE - preDepositAmount;

        while (
            _initializedValidators.count() != 0 &&
            pendingDeposit >= _remainingdepositAmount &&
            remainingCount > 0
        ) {
            // Get validator information
            (
                bytes memory _pubKey,
                bytes memory _withdrawalCredentials,
                bytes memory _signature,
                bytes32 _depositDataRoot,
                address _receiver
            ) = _initializedValidators.getNext(withdrawalCredentials);

            // Make sure the validator hasn't been deposited into already
            // to prevent sending an extra eth equal to `_remainingdepositAmount`
            // until withdrawals are allowed
            if (status[_pubKey] != DataTypes.ValidatorStatus.None)
                revert Errors.NoUsedValidator();

            (bool success, ) = beaconChainDepositContract.call{
                value: _remainingdepositAmount
            }(
                abi.encodeCall(
                    IDepositContract.deposit,
                    (
                        _pubKey,
                        _withdrawalCredentials,
                        _signature,
                        _depositDataRoot
                    )
                )
            );

            assert(success);

            pendingDeposit -= _remainingdepositAmount;

            if (preDepositAmount != 0) {
                _mintPxEth(_receiver, preDepositAmount);
            }

            unchecked {
                --remainingCount;
            }

            status[_pubKey] = DataTypes.ValidatorStatus.Staking;

            _stakingValidators.add(
                DataTypes.Validator(
                    _pubKey,
                    _signature,
                    _depositDataRoot,
                    _receiver
                ),
                _withdrawalCredentials
            );

            emit ValidatorDeposit(_pubKey);
        }
    }

    /**
     * @dev   Adds the specified amount to the pending deposit, considering the available buffer space and deposit pause status.
     *        If the buffer space is available, it may be fully or partially utilized. The method then checks if depositing
     *        ETH is not paused and spins up a validator if conditions are met.
     * @param _amount  uint256  The amount of ETH to be added to the pending deposit.
     */
    function _addPendingDeposit(uint256 _amount) internal virtual {
        uint256 _remainingBufferSpace = (
            maxBufferSize > buffer ? maxBufferSize - buffer : 0
        );
        uint256 _remainingAmount = _amount;

        if (_remainingBufferSpace != 0) {
            bool _canBufferSpaceFullyUtilized = _remainingBufferSpace <=
                _remainingAmount;
            buffer += _canBufferSpaceFullyUtilized
                ? _remainingBufferSpace
                : _remainingAmount;
            _remainingAmount -= _canBufferSpaceFullyUtilized
                ? _remainingBufferSpace
                : _remainingAmount;
        }

        pendingDeposit += _remainingAmount;

        if (depositEtherPaused == _NOT_PAUSED) {
            // Spin up a validator when possible
            _deposit();
        }
    }

    /**
     * @dev   Initiates the redemption process by adding the specified amount of pxETH to the pending withdrawal.
     *        Iteratively processes pending withdrawals in multiples of DEPOSIT_SIZE, triggering validator exits, updating
     *        batch information, and changing validator statuses accordingly. The process continues until the remaining
     *        pending withdrawal is less than DEPOSIT_SIZE. If `_shouldTriggerValidatorExit` is true and there's remaining
     *        pxETH after the redemption process, the function reverts, preventing partial initiation of redemption.
     * @param _pxEthAmount                 uint256  The amount of pxETH to be redeemed.
     * @param _receiver                    address  The receiver address for upxETH.
     * @param _shouldTriggerValidatorExit  bool     Whether to initiate partial redemption with a validator exit or not.
     */
    function _initiateRedemption(
        uint256 _pxEthAmount,
        address _receiver,
        bool _shouldTriggerValidatorExit
    ) internal {
        pendingWithdrawal += _pxEthAmount;

        while (pendingWithdrawal / DEPOSIT_SIZE != 0) {
            uint256 _allocationPossible = DEPOSIT_SIZE +
                _pxEthAmount -
                pendingWithdrawal;

            upxEth.mint(_receiver, batchId, _allocationPossible, "");

            (bytes memory _pubKey, , , , ) = _stakingValidators.getNext(
                withdrawalCredentials
            );

            pendingWithdrawal -= DEPOSIT_SIZE;
            _pxEthAmount -= _allocationPossible;

            oracleAdapter.requestVoluntaryExit(_pubKey);

            batchIdToValidator[batchId++] = _pubKey;
            status[_pubKey] = DataTypes.ValidatorStatus.Withdrawable;
        }

        if (_shouldTriggerValidatorExit && _pxEthAmount > 0)
            revert Errors.NoPartialInitiateRedemption();

        if (_pxEthAmount > 0) {
            upxEth.mint(_receiver, batchId, _pxEthAmount, "");
        }
    }

    /**
     * @dev   Checks if the contract has enough buffer to cover the specified amount. Iterates through the provided
     *        `_burnerAccounts`, verifies each account's approval status, burns the corresponding amount of pxETH, and
     *        updates the buffer accordingly. Reverts if there is insufficient buffer, if an account is not approved, or
     *        if the sum of burned amounts does not match the specified amount.
     * @param _amount          uint256                    The amount to be updated in the buffer.
     * @param _burnerAccounts  DataTypes.BurnerAccount[]  An array of burner account details (account and amount).
     */
    function _updateBuffer(
        uint256 _amount,
        DataTypes.BurnerAccount[] calldata _burnerAccounts
    ) private {
        if (buffer < _amount) {
            revert Errors.NotEnoughBuffer();
        }
        uint256 _len = _burnerAccounts.length;
        uint256 _sum;

        for (uint256 _i; _i < _len; ) {
            if (!burnerAccounts[_burnerAccounts[_i].account])
                revert Errors.AccountNotApproved();

            _sum += _burnerAccounts[_i].amount;

            _burnPxEth(_burnerAccounts[_i].account, _burnerAccounts[_i].amount);

            unchecked {
                ++_i;
            }
        }

        assert(_sum == _amount);
        buffer -= _amount;
    }
}
