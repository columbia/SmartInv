// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
// ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
// █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
// ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
// ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
// ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
// ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
// ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
// █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
// ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
// ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
// ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝

//  _____                 _____ _     _____                     _           _           
// |     |_ _ ___ _ _ ___|   __| |___|     |___ ___ ___ ___ ___| |_ ___ ___| |_ ___ ___ 
// |   --| | |  _| | | -_|  |  | | . |   --| . |   |  _| -_|   |  _|  _| .'|  _| . |  _|
// |_____|___|_|  \_/|___|_____|_|  _|_____|___|_|_|___|___|_|_|_| |_| |__,|_| |___|_|  
//                               |_|                                                    

// Github - https://github.com/FortressFinance

import {AMMConcentratorBase, ERC4626, ERC20, SafeERC20, Address, IERC20, IFortressSwap} from "src/shared/concentrators/AMMConcentratorBase.sol";

import {ICurveOperations} from "src/shared/fortress-interfaces/ICurveOperations.sol";
import {IConvexBoosterArbi} from "src/arbitrum/interfaces/IConvexBoosterArbi.sol";
import {IConvexBasicRewardsArbi} from "src/arbitrum/interfaces/IConvexBasicRewardsArbi.sol";
import {IGlpMinter} from "src/arbitrum/interfaces/IGlpMinter.sol";

contract CurveGlpConcentrator is AMMConcentratorBase {

    using SafeERC20 for IERC20;
    using Address for address payable;

    struct GmxSettings {
        /// @notice The address of the contract that mints and stakes GLP
        address glpHandler;
        /// @notice The address of the contract that needs an approval before minting GLP
        address glpManager;
    }

    /// @notice The GMX platform settings
    GmxSettings public gmxSettings;

    /// @notice The address of the underlying Curve pool
    address private immutable poolAddress;
    /// @notice The type of the pool, used in ammOperations
    uint256 private immutable poolType;

    /// @notice The address of sGLP token
    address public constant sGLP = 0x5402B5F40310bDED796c7D0F3FF6683f5C0cFfdf;
    /// @notice The address of WETH token (Arbitrum)
    address internal constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    
    /********************************** Constructor **********************************/

    constructor (ERC20 _asset, string memory _name, string memory _symbol, bytes memory _settingsConfig, bytes memory _boosterConfig, address _compounder, address[] memory _underlyingAssets, uint256 _poolType)
        AMMConcentratorBase (_asset, _name, _symbol, _settingsConfig, _boosterConfig, _compounder, _underlyingAssets) {
            
            IERC20(sGLP).safeApprove(_compounder, type(uint256).max);

            GmxSettings storage _gmxSettings = gmxSettings;

            _gmxSettings.glpHandler = 0xB95DB5B167D75e6d04227CfFFA61069348d271F5;
            _gmxSettings.glpManager = 0x3963FfC9dff443c2A94f21b129D429891E32ec18;

            poolType = _poolType;
            poolAddress = ICurveOperations(settings.ammOperations).getPoolFromLpToken(address(_asset));
        }
    
    /********************************** View Functions **********************************/

    /// @notice See {AMMConcentratorBase - isPendingRewards}
    function isPendingRewards() external override view returns (bool) {
        /// The address of CRV token on Arbitrum
        address _crv = address(0x11cDb42B0EB46D95f990BeDD4695A6e3fA034978);
        return IConvexBasicRewardsArbi(boosterData.crvRewards).claimable_reward(_crv, address(this)) > 0;
    }
    
    /********************************** Mutated Functions **********************************/

    /// @dev Adds the ability to choose the underlying asset to deposit to the GLP minter
    /// @dev Harvest the pending rewards and convert to underlying token, then stake
    /// @param _receiver - The address of account to receive harvest bounty
    /// @param _minBounty - The minimum amount of harvest bounty _receiver should get
    function harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) external nonReentrant returns (uint256 _rewards) {
        if (block.number == lastHarvestBlock) revert HarvestAlreadyCalled();
        lastHarvestBlock = block.number;

        _rewards = _harvest(_receiver, _underlyingAsset, _minBounty);
        accRewardPerShare = accRewardPerShare + ((_rewards * PRECISION) / totalSupply);

        return _rewards;
    }

    /********************************** Restricted Functions **********************************/

    function updateGlpContracts(address _glpHandler, address _glpManager) external {
        if (msg.sender != settings.owner) revert Unauthorized();

        GmxSettings storage _gmxSettings = gmxSettings;
        _gmxSettings.glpHandler = _glpHandler;
        _gmxSettings.glpManager = _glpManager;
    }

    /********************************** Internal Functions **********************************/

    function _depositStrategy(uint256 _assets, bool _transfer) internal override {
        if (_transfer) IERC20(address(asset)).safeTransferFrom(msg.sender, address(this), _assets);
        Booster memory _boosterData = boosterData;
        IConvexBoosterArbi(_boosterData.booster).deposit(_boosterData.boosterPoolId, _assets);
    }

    function _withdrawStrategy(uint256 _assets, address _receiver, bool _transfer) internal override {
        IConvexBasicRewardsArbi(boosterData.crvRewards).withdraw(_assets, false);
        if (_transfer) IERC20(address(asset)).safeTransfer(_receiver, _assets);
    }

    function _swapFromUnderlying(address _underlyingAsset, uint256 _underlyingAmount, uint256 _minAmount) internal override returns (uint256 _assets) {
        address payable _ammOperations = settings.ammOperations;
        if (_underlyingAsset == ETH) {
            (bytes memory result) = _ammOperations.functionCallWithValue(
                abi.encodeWithSignature("addLiquidity(address,uint256,address,uint256)", poolAddress, poolType, _underlyingAsset, _underlyingAmount),
                _underlyingAmount
            );
            _assets = abi.decode(result, (uint256));
        } else {
            _approve(_underlyingAsset, _ammOperations, _underlyingAmount);
            _assets = ICurveOperations(_ammOperations).addLiquidity(poolAddress, poolType, _underlyingAsset, _underlyingAmount);
        }

        if (!(_assets >= _minAmount)) revert InsufficientAmountOut();
    }

    function _swapToUnderlying(address _underlyingAsset, uint256 _assets, uint256 _minAmount) internal override returns (uint256 _underlyingAmount) {
        address _ammOperations = settings.ammOperations;
        _approve(address(asset), _ammOperations, _assets);
        _underlyingAmount = ICurveOperations(_ammOperations).removeLiquidity(poolAddress, poolType, _underlyingAsset, _assets);
        
        if (!(_underlyingAmount >= _minAmount)) revert InsufficientAmountOut();
    }

    function _harvest(address _receiver, uint256 _minBounty) internal override returns (uint256 _rewards) {
        return _harvest(_receiver, WETH, _minBounty);
    }

    function _harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) internal returns (uint256 _rewards) {
        Booster memory _boosterData = boosterData;
        
        IConvexBasicRewardsArbi(_boosterData.crvRewards).getReward(address(this));

        Settings memory _settings = settings;
        address _token;
        address _swap = _settings.swap;
        address[] memory _rewardAssets = _boosterData.rewardAssets;
        for (uint256 i = 0; i < _rewardAssets.length; i++) {
            _token = _rewardAssets[i];
            if (_token != _underlyingAsset) {
                uint256 _balance = IERC20(_token).balanceOf(address(this));
                if (_balance > 0) {
                    IFortressSwap(_swap).swap(_token, _underlyingAsset, _balance);
                }
            }
        }

        _rewards = IERC20(_underlyingAsset).balanceOf(address(this));

        GmxSettings memory _gmxSettings = gmxSettings;
        address _sGLP = sGLP;
        uint256 _startBalance = IERC20(_sGLP).balanceOf(address(this));
        _approve(_underlyingAsset, _gmxSettings.glpManager, _rewards);
        IGlpMinter(_gmxSettings.glpHandler).mintAndStakeGlp(_underlyingAsset, _rewards, 0, 0);
        _rewards = IERC20(_sGLP).balanceOf(address(this)) - _startBalance;
        
        if (_rewards > 0) {
            Fees memory _fees = fees;
            uint256 _platformFee = _fees.platformFeePercentage;
            uint256 _harvestBounty = _fees.harvestBountyPercentage;
            if (_platformFee > 0) {
                _platformFee = (_platformFee * _rewards) / FEE_DENOMINATOR;
                _rewards = _rewards - _platformFee;
                IERC20(_sGLP).safeTransfer(_settings.platform, _platformFee);
            }
            if (_harvestBounty > 0) {
                _harvestBounty = (_harvestBounty * _rewards) / FEE_DENOMINATOR;
                if (!(_harvestBounty >= _minBounty)) revert InsufficientAmountOut();

                _rewards = _rewards - _harvestBounty;
                IERC20(_sGLP).safeTransfer(_receiver, _harvestBounty);
            }

            _rewards = ERC4626(_settings.compounder).deposit(_rewards, address(this));
            
            emit Harvest(msg.sender, _receiver, _rewards, _platformFee);

            return _rewards;
        } else {
            revert NoPendingRewards();
        }
    }

    receive() external payable {}
}