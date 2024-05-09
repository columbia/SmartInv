// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Ownable2Step} from "openzeppelin-contracts/contracts/access/Ownable2Step.sol";
import {ERC4626} from "solmate/mixins/ERC4626.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {FixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {Errors} from "./libraries/Errors.sol";
import {IPirexEth} from "./interfaces/IPirexEth.sol";

/**
 * @title AutoPxEth
 * @notice Autocompounding vault for (staked) pxETH, adapted from pxCVX vault system
 * @dev This contract enables autocompounding for pxETH assets and includes various fee mechanisms.
 * @author redactedcartel.finance
 */
contract AutoPxEth is Ownable2Step, ERC4626 {
    /**
     * @dev Library: SafeTransferLib - Provides safe transfer functions for ERC20 tokens.
     */
    using SafeTransferLib for ERC20;

    /**
     * @dev Library: FixedPointMathLib - Provides fixed-point arithmetic for uint256.
     */
    using FixedPointMathLib for uint256;

    // Constants

    /**
     * @dev Maximum withdrawal penalty percentage.
     */
    uint256 private constant MAX_WITHDRAWAL_PENALTY = 50_000;
    

    /**
     * @dev Maximum platform fee percentage.
     */
    uint256 private constant MAX_PLATFORM_FEE = 200_000;

    /**
     * @dev Fee denominator for precise fee calculations.
     */
    uint256 private constant FEE_DENOMINATOR = 1_000_000;

    /**
     * @dev Duration of the rewards period.
     */
    uint256 private constant REWARDS_DURATION = 7 days;

    // State variables for tracking rewards and actively staked assets

    /**
     * @notice Reference to the PirexEth contract.
     */
    IPirexEth public pirexEth;
    
    /**
     * @notice Timestamp when the current rewards period will end.
     */
    uint256 public periodFinish;
    
    /**
     * @notice Rate at which rewards are distributed per second.
     */
    uint256 public rewardRate;
    
    /**
     * @notice Timestamp of the last update to the reward variables.
     */
    uint256 public lastUpdateTime;
    
    /**
     * @notice Accumulated reward per token stored.
     */
    uint256 public rewardPerTokenStored;
    
    /**
     * @notice Last calculated reward per token paid to stakers.
     */
    uint256 public rewardPerTokenPaid;
    
    /**
     * @notice Total rewards available for distribution.
     */
    uint256 public rewards;
    
    /**
     * @notice Total assets actively staked in the vault.
     */
    uint256 public totalStaked;

    // State variables related to fees
    /**
     * @notice Withdrawal penalty percentage.
     */
    uint256 public withdrawalPenalty = 30_000;
    
    /**
     * @notice Platform fee percentage.
     */
    uint256 public platformFee = 100_000;
    
    /**
     * @notice Address of the platform that receives fees.
     */
    address public platform;

    // Events

    /**
     * @notice Emitted when rewards are harvested and staked.
     * @dev This event is emitted when a user triggers the harvest function.
     * @param caller address indexed Address that triggered the harvest.
     * @param value  uint256         Amount of rewards harvested.
     */
    event Harvest(address indexed caller, uint256 value);

    /**
     * @notice Emitted when the withdrawal penalty is updated.
     * @dev This event is emitted when the withdrawal penalty is modified.
     * @param penalty uint256 New withdrawal penalty percentage.
     */
    event WithdrawalPenaltyUpdated(uint256 penalty);

    /**
     * @notice Emitted when the platform fee is updated.
     * @dev This event is emitted when the platform fee is modified.
     * @param fee uint256 New platform fee percentage.
     */
    event PlatformFeeUpdated(uint256 fee);
    
    /**
     * @notice Emitted when the platform address is updated.
     * @dev This event is emitted when the platform address is modified.
     * @param _platform address New platform address.
     */
    event PlatformUpdated(address _platform);

    /**
     * @notice Emitted when new rewards are added to the vault.
     * @dev This event is emitted when new rewards are added to the vault.
     * @param reward uint256 Amount of rewards added.
     */
    event RewardAdded(uint256 reward);

    /**
     * @notice Emitted when the PirexEth contract address is set.
     * @dev This event is emitted when the PirexEth contract address is set.
     * @param _pirexEth address New PirexEth contract address.
     */
    event SetPirexEth(address _pirexEth);

    // Modifiers
    /**
     * @dev Update reward states modifier
     * @param updateEarned bool Whether to update earned amount so far
     */
    modifier updateReward(bool updateEarned) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();

        if (updateEarned) {
            rewards = earned();
            rewardPerTokenPaid = rewardPerTokenStored;
        }
        _;
    }

    /**
     * @dev Contract constructor
     * @param _asset address Asset contract address
     * @param _platform address Platform address
     */
    constructor(
        address _asset,
        address _platform
    ) ERC4626(ERC20(_asset), "Autocompounding Pirex Ether", "apxETH") {
        if (_platform == address(0)) revert Errors.ZeroAddress();

        platform = _platform;
    }

    /*//////////////////////////////////////////////////////////////
                        RESTRICTED FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Set the PirexEth contract address
     * @dev Function access restricted to only owner
     * @param _pirexEth address PirexEth contract address
     */
    function setPirexEth(address _pirexEth) external onlyOwner {
        if (_pirexEth == address(0)) revert Errors.ZeroAddress();

        emit SetPirexEth(_pirexEth);

        pirexEth = IPirexEth(_pirexEth);
    }

    /**
     * @notice Set the withdrawal penalty
     * @dev Function access restricted to only owner
     * @param penalty uint256 Withdrawal penalty
     */
    function setWithdrawalPenalty(uint256 penalty) external onlyOwner {
        if (penalty > MAX_WITHDRAWAL_PENALTY) revert Errors.ExceedsMax();

        withdrawalPenalty = penalty;

        emit WithdrawalPenaltyUpdated(penalty);
    }

    /**
     * @notice Set the platform fee
     * @dev Function access restricted to only owner
     * @param fee uint256 Platform fee
     */
    function setPlatformFee(uint256 fee) external onlyOwner {
        if (fee > MAX_PLATFORM_FEE) revert Errors.ExceedsMax();

        platformFee = fee;

        emit PlatformFeeUpdated(fee);
    }

    /**
     * @notice Set the platform
     * @dev Function access restricted to only owner
     * @param _platform address Platform
     */
    function setPlatform(address _platform) external onlyOwner {
        if (_platform == address(0)) revert Errors.ZeroAddress();

        platform = _platform;

        emit PlatformUpdated(_platform);
    }

    /**
     * @notice Notify and sync the newly added rewards to be streamed over time
     * @dev Rewards are streamed following the duration set in REWARDS_DURATION
     */
    function notifyRewardAmount() external updateReward(false) {
        if (msg.sender != address(pirexEth)) revert Errors.NotPirexEth();

        // Rewards transferred directly to this contract are not added to totalStaked
        // To get the rewards w/o relying on a potentially incorrect passed in arg,
        // we can use the difference between the asset balance and totalStaked.
        // Additionally, to avoid re-distributing rewards, deduct the output of `earned`
        uint256 rewardBalance = asset.balanceOf(address(this)) -
            totalStaked -
            earned();

        rewardRate = rewardBalance / REWARDS_DURATION;

        if (rewardRate == 0) revert Errors.NoRewards();

        lastUpdateTime = block.timestamp;
        periodFinish = block.timestamp + REWARDS_DURATION;

        emit RewardAdded(rewardBalance);
    }

    /*//////////////////////////////////////////////////////////////
                                VIEWS
    //////////////////////////////////////////////////////////////*/

    /**
     * @inheritdoc ERC4626
     * @notice Get the amount of available pxETH in the contract
     * @dev Rewards are streamed for the duration set in REWARDS_DURATION
     */
    function totalAssets() public view override returns (uint256) {
        // Based on the current totalStaked and available rewards
        uint256 _totalStaked = totalStaked;
        uint256 _rewards = ((_totalStaked *
            (rewardPerToken() - rewardPerTokenPaid)) / 1e18) + rewards;

        // Deduct the exact reward amount staked (after fees are deducted when calling `harvest`)
        return
            _totalStaked +
            (
                _rewards == 0
                    ? 0
                    : (_rewards - ((_rewards * platformFee) / FEE_DENOMINATOR))
            );
    }

    /**
     * @notice Returns the last effective timestamp of the current reward period
     * @return uint256 Timestamp
     */
    function lastTimeRewardApplicable() public view returns (uint256) {
        return block.timestamp < periodFinish ? block.timestamp : periodFinish;
    }

    /**
     * @notice Returns the amount of rewards per staked token/asset
     * @return uint256 Rewards amount
     */
    function rewardPerToken() public view returns (uint256) {
        if (totalStaked == 0) {
            return rewardPerTokenStored;
        }

        return
            rewardPerTokenStored +
            ((((lastTimeRewardApplicable() - lastUpdateTime) * rewardRate) *
                1e18) / totalStaked);
    }

    /**
     * @notice Returns the earned rewards amount so far
     * @return uint256 Rewards amount
     */
    function earned() public view returns (uint256) {
        return
            ((totalStaked * (rewardPerToken() - rewardPerTokenPaid)) / 1e18) +
            rewards;
    }

    /**
     * @notice Return the amount of assets per 1 (1e18) share
     * @return uint256 Assets
     */
    function assetsPerShare() external view returns (uint256) {
        return previewRedeem(1e18);
    }

    /*//////////////////////////////////////////////////////////////
                            INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Internal method to keep track of the total amount of staked token/asset on deposit/mint
     */
    function _stake(uint256 amount) internal updateReward(true) {
        totalStaked += amount;
    }

    /**
     * @dev Internal method to keep track of the total amount of staked token/asset on withdrawal/redeem
     */
    function _withdraw(uint256 amount) internal updateReward(true) {
        totalStaked -= amount;
    }

    /*//////////////////////////////////////////////////////////////
                            ERC4626 OVERRIDES
    //////////////////////////////////////////////////////////////*/

    /**
     * @inheritdoc ERC4626
     * @dev Deduct the specified amount of assets from totalStaked to prepare for transfer to the user
     * @param assets uint256 Assets
     */
    function beforeWithdraw(uint256 assets, uint256) internal override {
        // Perform harvest to make sure that totalStaked is always equal or larger than assets to be withdrawn
        if (assets > totalStaked) harvest();

        _withdraw(assets);
    }

    /**
     * @inheritdoc ERC4626
     * @dev Include the new assets in totalStaked so that rewards can be properly distributed
     * @param assets uint256 Assets
     */
    function afterDeposit(uint256 assets, uint256) internal override {
        _stake(assets);
    }

    /**
     * @inheritdoc ERC4626
     * @dev Preview the amount of assets a user would receive from redeeming shares
     */
    function previewRedeem(
        uint256 shares
    ) public view override returns (uint256) {
        // Calculate assets based on a user's % ownership of vault shares
        uint256 assets = convertToAssets(shares);

        uint256 _totalSupply = totalSupply;

        // Calculate a penalty - zero if user is the last to withdraw.
        uint256 penalty = (_totalSupply == 0 || _totalSupply - shares == 0)
            ? 0
            : assets.mulDivUp(withdrawalPenalty, FEE_DENOMINATOR); // Round up the penalty in favour of the protocol.

        // Redeemable amount is the post-penalty amount
        return assets - penalty;
    }

    /**
     * @inheritdoc ERC4626
     * @notice Preview the amount of shares a user would need to redeem the specified asset amount
     * @dev This modified version takes into consideration the withdrawal fee
     */
    function previewWithdraw(
        uint256 assets
    ) public view override returns (uint256) {
        // Calculate shares based on the specified assets' proportion of the pool
        uint256 shares = convertToShares(assets);

        // Save 1 SLOAD
        uint256 _totalSupply = totalSupply;

        // Factor in additional shares to fulfill withdrawal if user is not the last to withdraw
        return
            (_totalSupply == 0 || _totalSupply - shares == 0)
                ? shares
                : (shares * FEE_DENOMINATOR) /
                    (FEE_DENOMINATOR - withdrawalPenalty);
    }

    /*//////////////////////////////////////////////////////////////
                            MUTATIVE FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Harvest and stake available rewards after distributing fees to the platform
     * @dev This function claims and stakes the available rewards, deducting a fee for the platform.
     */
    function harvest() public updateReward(true) {
        uint256 _rewards = rewards;

        if (_rewards != 0) {
            rewards = 0;

            // Fee for platform
            uint256 feeAmount = (_rewards * platformFee) / FEE_DENOMINATOR;

            // Deduct fee from reward balance
            _rewards -= feeAmount;

            // Claimed rewards should be in pxETH
            asset.safeTransfer(platform, feeAmount);

            // Stake rewards sans fee
            _stake(_rewards);

            emit Harvest(msg.sender, _rewards);
        }
    }

    /**
     * @notice Override transfer logic to trigger direct `initiateRedemption`.
     * @dev This function overrides the standard transfer logic to initiate redemption when transferring to the PirexEth contract.
     * @param to     address Transfer destination
     * @param amount uint256 Amount
     * @return       bool
     */
    function transfer(
        address to,
        uint256 amount
    ) public override returns (bool) {
        super.transfer(to, amount);

        if (to == address(pirexEth)) {
            pirexEth.initiateRedemption(amount, msg.sender, false);
        }

        return true;
    }

    /**
     * @notice Override transferFrom logic to trigger direct `initiateRedemption`.
     * @dev This function overrides the standard transferFrom logic to initiate redemption when transferring from the PirexEth contract.
     * @param from   Address of the transfer origin.
     * @param to     Address of the transfer destination.
     * @param amount Amount of tokens to transfer.
     * @return       A boolean indicating the success of the transfer.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        super.transferFrom(from, to, amount);

        if (to == address(pirexEth)) {
            pirexEth.initiateRedemption(amount, from, false);
        }

        return true;
    }
}
