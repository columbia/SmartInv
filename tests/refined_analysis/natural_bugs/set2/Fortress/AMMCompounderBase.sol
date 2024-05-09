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

//  _____ _____ _____ _____                             _         _____             
// |  _  |     |     |     |___ _____ ___ ___ _ _ ___ _| |___ ___| __  |___ ___ ___ 
// |     | | | | | | |   --| . |     | . | . | | |   | . | -_|  _| __ -| .'|_ -| -_|
// |__|__|_|_|_|_|_|_|_____|___|_|_|_|  _|___|___|_|_|___|___|_| |_____|__,|___|___|
//                                   |_|                                            

// Github - https://github.com/FortressFinance

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol";

import {ERC4626, ERC20, FixedPointMathLib} from "src/shared/interfaces/ERC4626.sol";
import {IConvexBasicRewards} from "src/shared/interfaces/IConvexBasicRewards.sol";
import {IConvexBooster} from "src/shared/interfaces/IConvexBooster.sol";
import {IFortressSwap} from "src/shared/fortress-interfaces/IFortressSwap.sol";

abstract contract AMMCompounderBase is ReentrancyGuard, ERC4626 {
  
    using FixedPointMathLib for uint256;
    using SafeERC20 for IERC20;
    using Address for address payable;

    struct Fees {
        /// @notice The percentage of fee to pay for platform on harvest
        uint256 platformFeePercentage;
        /// @notice The percentage of fee to pay for caller on harvest
        uint256 harvestBountyPercentage;
        /// @notice The fee percentage to take on withdrawal. Fee stays in the vault, and is therefore distributed to vault participants. Used as a mechanism to protect against mercenary capital
        uint256 withdrawFeePercentage;
    }

    struct Booster {
        /// @notice The pool ID in LP Booster contract
        uint256 boosterPoolId;
        /// @notice The address of LP Booster contract
        address booster;
        /// @notice The address of LP staking rewards contract
        address crvRewards;
        /// @notice The reward assets
        address[] rewardAssets;
    }

    struct Settings {
        /// @notice The description of the vault
        string description;
        /// @notice The internal accounting of the deposit limit. Denominated in shares
        uint256 depositCap;
        /// @notice The address of the platform
        address platform;
        /// @notice The address of the FortressSwap contract
        address swap;
        /// @notice The address of the Fortress AMM Operations contract
        address payable ammOperations;
        /// @notice The address of the owner
        address owner;
        /// @notice Whether deposit for the pool is paused
        bool pauseDeposit;
        /// @notice Whether withdraw for the pool is paused
        bool pauseWithdraw;
    }

    /// @notice The fees settings
    Fees public fees;

    /// @notice The LP booster settings
    Booster public boosterData;

    /// @notice The vault settings
    Settings public settings;

    /// @notice The internal accounting of AUM
    uint256 internal totalAUM;
    /// @notice The last block number that the harvest function was executed
    uint256 public lastHarvestBlock;

    /// @notice The fee denominator
    uint256 internal constant FEE_DENOMINATOR = 1e9;
    /// @notice The maximum withdrawal fee
    uint256 internal constant MAX_WITHDRAW_FEE = 1e8; // 10%
    /// @notice The maximum platform fee
    uint256 internal constant MAX_PLATFORM_FEE = 2e8; // 20%
    /// @notice The maximum harvest fee
    uint256 internal constant MAX_HARVEST_BOUNTY = 1e8; // 10%
    /// @notice The address representing ETH
    address internal constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    
    /// @notice The mapping of whitelisted feeless redeemers
    mapping(address => bool) public feelessRedeemerWhitelist;

    /// @notice The underlying assets
    address[] public underlyingAssets;

    /********************************** Constructor **********************************/

    constructor(
            ERC20 _asset,
            string memory _name,
            string memory _symbol,
            bytes memory _settingsConfig,
            bytes memory _boosterConfig,
            address[] memory _underlyingAssets
        )
        ERC4626(_asset, _name, _symbol) {
            {
                Fees storage _fees = fees;
                _fees.platformFeePercentage = 50000000; // 5%
                _fees.harvestBountyPercentage = 25000000; // 2.5%
                _fees.withdrawFeePercentage = 2000000; // 0.2%
            }

            {
                Settings storage _settings = settings;

                (_settings.description, _settings.owner, _settings.platform, _settings.swap, _settings.ammOperations)
                = abi.decode(_settingsConfig, (string, address, address, address, address));
                
                _settings.depositCap = 0;
                _settings.pauseDeposit = false;
                _settings.pauseWithdraw = false;
            }

            {
                Booster storage _boosterData = boosterData;

                (_boosterData.boosterPoolId, _boosterData.booster, _boosterData.crvRewards, _boosterData.rewardAssets)
                = abi.decode(_boosterConfig, (uint256, address, address, address[]));

                IERC20(address(_asset)).safeApprove(_boosterData.booster, type(uint256).max);

                for (uint256 i = 0; i < _boosterData.rewardAssets.length; i++) {
                    IERC20(_boosterData.rewardAssets[i]).safeApprove(settings.swap, type(uint256).max);
                }
            }

            underlyingAssets = _underlyingAssets;
    }

    /********************************** View Functions **********************************/

    /// @dev Get the list of addresses of the vault's underlying assets (the assets that comprise the LP token, which is the vault primary asset)
    /// @return - The underlying assets
    function getUnderlyingAssets() external view returns (address[] memory) {
        return underlyingAssets;
    }

    /// @dev Get the name of the vault
    /// @return - The name of the vault
    function getName() external view returns (string memory) {
        return name;
    }

    /// @dev Get the symbol of the vault
    /// @return - The symbol of the vault
    function getSymbol() external view returns (string memory) {
        return symbol;
    }

    /// @dev Get the description of the vault
    /// @return - The description of the vault
    function getDescription() external view returns (string memory) {
        return settings.description;
    }

    /// @dev Indicates whether there are pending rewards to harvest
    /// @return - True if there are pending rewards, false if otherwise
    function isPendingRewards() external virtual view returns (bool) {
        return IConvexBasicRewards(boosterData.crvRewards).earned(address(this)) > 0;
    }

    /// @dev Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions
    /// @param _shares - The amount of shares to redeem
    /// @return - The amount of assets in return, after subtracting a withdrawal fee
    function previewRedeem(uint256 _shares) public view override returns (uint256) {
        uint256 assets = convertToAssets(_shares);

        uint256 _totalSupply = totalSupply;

        // Calculate a fee - zero if user is the last to withdraw
        uint256 _fee = (_totalSupply == 0 || _totalSupply - _shares == 0) ? 0 : assets.mulDivDown(fees.withdrawFeePercentage, FEE_DENOMINATOR);

        // Redeemable amount is the post-withdrawal-fee amount
        return assets - _fee;
    }

    /// @dev Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions
    /// @param _assets - The amount of assets to withdraw
    /// @return - The amount of shares to burn, after subtracting a fee
    function previewWithdraw(uint256 _assets) public view override returns (uint256) {
        uint256 _shares = convertToShares(_assets);

        uint256 _totalSupply = totalSupply;

        // Factor in additional shares to fulfill withdrawal fee if user is not the last to withdraw
        return (_totalSupply == 0 || _totalSupply - _shares == 0) ? _shares : (_shares * FEE_DENOMINATOR) / (FEE_DENOMINATOR - fees.withdrawFeePercentage);
    }

    /// @dev Returns the total AUM
    /// @return - The total AUM
    function totalAssets() public view override returns (uint256) {
        return totalAUM;
    }

    /// @dev Returns the maximum amount of the underlying asset that can be deposited into the Vault for the receiver, through a deposit call
    function maxDeposit(address) public view override returns (uint256) {
        uint256 _assetCap = convertToAssets(settings.depositCap);
        return _assetCap == 0 ? type(uint256).max : _assetCap - totalAUM;
    }

    /// @dev Returns the maximum amount of the Vault shares that can be minted for the receiver, through a mint call
    function maxMint(address) public view override returns (uint256) {
        uint256 _depositCap = settings.depositCap;
        return _depositCap == 0 ? type(uint256).max : _depositCap - totalSupply;
    }

    /// @dev Checks if a specific asset is an underlying asset
    /// @param _asset - The address of the asset to check
    /// @return - Whether the assets is an underlying asset
    function _isUnderlyingAsset(address _asset) internal view returns (bool) {
        address[] memory _underlyingAssets = underlyingAssets;

        for (uint256 i = 0; i < _underlyingAssets.length; i++) {
            if (_underlyingAssets[i] == _asset) {
                return true;
            }
        }
        return false;
    }

    /********************************** Mutated Functions **********************************/

    /// @dev Mints vault shares to _receiver by depositing exact amount of assets
    /// @param _assets - The amount of assets to deposit
    /// @param _receiver - The receiver of minted shares
    /// @return _shares - The amount of shares minted
    function deposit(uint256 _assets, address _receiver) external override nonReentrant returns (uint256 _shares) {
        if (_assets >= maxDeposit(msg.sender)) revert InsufficientDepositCap();

        _shares = previewDeposit(_assets);

        _deposit(msg.sender, _receiver, _assets, _shares);

        _depositStrategy(_assets, true);

        return _shares;
    }

    /// @dev Mints exact vault shares to _receiver by depositing assets
    /// @param _shares - The amount of shares to mint
    /// @param _receiver - The address of the receiver of shares
    /// @return _assets - The amount of assets deposited
    function mint(uint256 _shares, address _receiver) external override nonReentrant returns (uint256 _assets) {
        if (_shares >= maxMint(msg.sender)) revert InsufficientDepositCap();

        _assets = previewMint(_shares);
        
        _deposit(msg.sender, _receiver, _assets, _shares);

        _depositStrategy(_assets, true);

        return _assets;
    }

    /// @dev Burns shares from owner and sends exact amount of assets to _receiver. If the _owner is whitelisted, no withdrawal fee is applied
    /// @param _assets - The amount of assets to receive
    /// @param _receiver - The address of the receiver of assets
    /// @param _owner - The owner of shares
    /// @return _shares - The amount of shares burned
    function withdraw(uint256 _assets, address _receiver, address _owner) external override nonReentrant returns (uint256 _shares) {
        if (_assets > maxWithdraw(_owner)) revert InsufficientBalance();

        // If the _owner is whitelisted, we can skip the preview and just convert the assets to shares
        _shares = feelessRedeemerWhitelist[_owner] ? convertToShares(_assets) : previewWithdraw(_assets);
        
        _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
        
        _withdrawStrategy(_assets, _receiver, true);

        return _shares;
    }

    /// @dev Burns exact amount of shares from owner and sends assets to _receiver. If the _owner is whitelisted, no withdrawal fee is applied
    /// @param _shares - The amount of shares to burn
    /// @param _receiver - The address of the receiver of assets
    /// @param _owner - The owner of shares
    /// @return _assets - The amount of assets sent to the _receiver
    function redeem(uint256 _shares, address _receiver, address _owner) external override nonReentrant returns (uint256 _assets) {
        if (_shares > maxRedeem(_owner)) revert InsufficientBalance();

        // If the _owner is whitelisted, we can skip the preview and just convert the shares to assets
        _assets = feelessRedeemerWhitelist[_owner] ? convertToAssets(_shares) : previewRedeem(_shares);
        
        _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
        
        _withdrawStrategy(_assets, _receiver, true);

        return _assets;
    }

    /// @dev Mints vault shares to _receiver by depositing exact amount of underlying assets
    /// @param _underlyingAsset - The address of the underlying asset to deposit
    /// @param _receiver - The receiver of minted shares
    /// @param _underlyingAmount - The amount of underlying assets to deposit
    /// @param _minAmount - The minimum amount of assets (LP tokens) to receive
    /// @return _shares - The amount of shares minted
    function depositUnderlying(address _underlyingAsset, address _receiver, uint256 _underlyingAmount, uint256 _minAmount) external payable nonReentrant returns (uint256 _shares) {
        if (!_isUnderlyingAsset(_underlyingAsset)) revert NotUnderlyingAsset();
        if (!(_underlyingAmount > 0)) revert ZeroAmount();
        
        if (msg.value > 0) {
            if (msg.value != _underlyingAmount) revert InvalidAmount();
            if (_underlyingAsset != ETH) revert InvalidAsset();
        } else {
            IERC20(_underlyingAsset).safeTransferFrom(msg.sender, address(this), _underlyingAmount);
        }

        uint256 _assets = _swapFromUnderlying(_underlyingAsset, _underlyingAmount, _minAmount);
        if (_assets >= maxDeposit(msg.sender)) revert InsufficientDepositCap();
        
        _shares = previewDeposit(_assets);
        _deposit(msg.sender, _receiver, _assets, _shares);
        
        _depositStrategy(_assets, false);
        
        return _shares;
    }

    /// @notice This function is vulnerable to a frontrunning attacke if called without asserting the returned value
    /// @notice If the _owner is whitelisted, no withdrawal fee is applied
    /// @dev Burns exact shares from owner and sends assets of unwrapped underlying tokens to _receiver
    /// @param _underlyingAsset - The address of underlying asset to redeem shares for
    /// @param _receiver - The address of the receiver of underlying assets
    /// @param _owner - The owner of _shares
    /// @param _shares - The amount of shares to burn
    /// @param _minAmount - The minimum amount of underlying assets to receive
    /// @return _underlyingAmount - The amount of underlying assets sent to the _receiver
    function redeemUnderlying(address _underlyingAsset, address _receiver, address _owner, uint256 _shares, uint256 _minAmount) external nonReentrant returns (uint256 _underlyingAmount) {
        if (!_isUnderlyingAsset(_underlyingAsset)) revert NotUnderlyingAsset();
        if (_shares > maxRedeem(_owner)) revert InsufficientBalance();

        uint256 _assets = feelessRedeemerWhitelist[_owner] ? convertToAssets(_shares) : previewRedeem(_shares);
        _withdraw(msg.sender, _receiver, _owner, _assets, _shares);

        _withdrawStrategy(_assets, _receiver, false);
        
        _underlyingAmount = _swapToUnderlying(_underlyingAsset, _assets, _minAmount);
        
        if (_underlyingAsset == ETH) {
            payable(_receiver).sendValue(_underlyingAmount);
        } else {
            IERC20(_underlyingAsset).safeTransfer(_receiver, _underlyingAmount);
        }

        return _underlyingAmount;
    }

    /// @dev Harvests the pending rewards and converts to assets, then re-stakes the assets
    /// @param _receiver - The address of receiver of harvest bounty
    /// @param _underlyingAsset - The address of underlying asset to convert rewards to, will then be deposited in the pool in return for assets (LP tokens) 
    /// @param _minBounty - The minimum amount of harvest bounty _receiver should get
    /// @return _rewards - The amount of rewards that were deposited back into the vault, denominated in the vault asset
    function harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) external nonReentrant returns (uint256 _rewards) {
        if (!_isUnderlyingAsset(_underlyingAsset)) revert NotUnderlyingAsset();
        if (lastHarvestBlock == block.number) revert HarvestAlreadyCalled();
        lastHarvestBlock = block.number;
        
        _rewards = _harvest(_receiver, _underlyingAsset, _minBounty);
        totalAUM += _rewards;

        return _rewards;
    }

    /// @dev Adds emitting of YbTokenTransfer event to the original function
    function transfer(address to, uint256 amount) public override returns (bool) {
        balanceOf[msg.sender] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);
        emit YbTokenTransfer(msg.sender, to, amount, convertToAssets(amount));
        
        return true;
    }

    /// @dev Adds emitting of YbTokenTransfer event to the original function
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;

        balanceOf[from] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);
        emit YbTokenTransfer(from, to, amount, convertToAssets(amount));

        return true;
    }

    /********************************** Restricted Functions **********************************/

    /// @dev Updates the feelessRedeemerWhitelist
    /// @param _address - The address to update
    /// @param _whitelist - The new whitelist status
    function updateFeelessRedeemerWhitelist(address _address, bool _whitelist) external {
        if (msg.sender != settings.owner) revert Unauthorized();

        feelessRedeemerWhitelist[_address] = _whitelist;

        emit UpdateFeelessRedeemerWhitelist(_address, _whitelist);
    }

    /// @dev Updates the vault fees
    /// @param _withdrawFeePercentage - The new withdrawal fee percentage
    /// @param _platformFeePercentage - The new platform fee percentage
    /// @param _harvestBountyPercentage - The new harvest fee percentage
    function updateFees(uint256 _withdrawFeePercentage, uint256 _platformFeePercentage, uint256 _harvestBountyPercentage) external {
        if (msg.sender != settings.owner) revert Unauthorized();
        if (_withdrawFeePercentage > MAX_WITHDRAW_FEE) revert InvalidAmount();
        if (_platformFeePercentage > MAX_PLATFORM_FEE) revert InvalidAmount();
        if (_harvestBountyPercentage > MAX_HARVEST_BOUNTY) revert InvalidAmount();

        Fees storage _fees = fees;
        _fees.withdrawFeePercentage = _withdrawFeePercentage;
        _fees.platformFeePercentage = _platformFeePercentage;
        _fees.harvestBountyPercentage = _harvestBountyPercentage;

        emit UpdateFees(_withdrawFeePercentage, _platformFeePercentage, _harvestBountyPercentage);
    }

    /// @dev updates the vault external utils
    /// @param _booster - The new booster address
    /// @param _crvRewards - The new crvRewards address
    /// @param _boosterPoolId - The new booster pool id
    function updateBoosterData(address _booster, address _crvRewards, uint256 _boosterPoolId) external {
        if (msg.sender != settings.owner) revert Unauthorized();

        Booster storage _boosterData = boosterData;
        _boosterData.booster = _booster;
        _boosterData.crvRewards = _crvRewards;
        _boosterData.boosterPoolId = _boosterPoolId;

        _approve(address(asset), _boosterData.booster, type(uint256).max);

        emit UpdateBoosterData(_booster, _crvRewards, _boosterPoolId);
    }

    /// @dev updates the reward assets
    /// @param _rewardAssets - The new address list of reward assets
    function updateRewardAssets(address[] memory _rewardAssets) external {
        if (msg.sender != settings.owner) revert Unauthorized();

        boosterData.rewardAssets = _rewardAssets;

        for (uint256 i = 0; i < _rewardAssets.length; i++) {
            _approve(_rewardAssets[i], settings.swap, type(uint256).max);
        }

        emit UpdateRewardAssets(_rewardAssets);
    }

    /// @dev updates the vault internal utils
    /// @param _description - The new description
    /// @param _platform - The new platform address
    /// @param _swap - The new swap address
    /// @param _ammOperations - The new ammOperations address
    /// @param _owner - The address of the new owner
    /// @param _depositCap - The new deposit cap
    /// @param _underlyingAssets - The new address list of underlying assets
    function updateSettings(string memory _description, address _platform, address _swap, address _ammOperations, address _owner, uint256 _depositCap, address[] memory _underlyingAssets) external {
        Settings storage _settings = settings;

        if (msg.sender != _settings.owner) revert Unauthorized();

        _settings.description = _description;
        _settings.platform = _platform;
        _settings.swap = _swap;
        _settings.ammOperations = payable(_ammOperations);
        _settings.owner = _owner;
        _settings.depositCap = _depositCap;

        underlyingAssets = _underlyingAssets;

        emit UpdateSettings(_platform, _swap, _ammOperations, _owner, _depositCap, _underlyingAssets);
    }

    /// @dev Pauses deposits/withdrawals for the vault.
    /// @param _pauseDeposit - The new deposit status.
    /// @param _pauseWithdraw - The new withdraw status.
    function pauseInteractions(bool _pauseDeposit, bool _pauseWithdraw) external {
        Settings storage _settings = settings;

        if (msg.sender != _settings.owner) revert Unauthorized();

        _settings.pauseDeposit = _pauseDeposit;
        _settings.pauseWithdraw = _pauseWithdraw;
        
        emit PauseInteractions(_pauseDeposit, _pauseWithdraw);
    }

    /********************************** Internal Functions **********************************/

    function _deposit(address _caller, address _receiver, uint256 _assets, uint256 _shares) internal override {
        if (settings.pauseDeposit) revert DepositPaused();
        if (_receiver == address(0)) revert ZeroAddress();
        if (!(_assets > 0)) revert ZeroAmount();
        if (!(_shares > 0)) revert ZeroAmount();

        _mint(_receiver, _shares);
        totalAUM += _assets;

        emit Deposit(_caller, _receiver, _assets, _shares);
    }

    function _withdraw(address _caller, address _receiver, address _owner, uint256 _assets, uint256 _shares) internal override {
        if (settings.pauseWithdraw) revert WithdrawPaused();
        if (_receiver == address(0)) revert ZeroAddress();
        if (_owner == address(0)) revert ZeroAddress();
        if (!(_shares > 0)) revert ZeroAmount();
        if (!(_assets > 0)) revert ZeroAmount();
        
        if (_caller != _owner) {
            uint256 _allowed = allowance[_owner][_caller];
            if (_allowed < _shares) revert InsufficientAllowance();
            if (_allowed != type(uint256).max) allowance[_owner][_caller] = _allowed - _shares;
        }
        
        _burn(_owner, _shares);
        totalAUM -= _assets;

        emit Withdraw(_caller, _receiver, _owner, _assets, _shares);
    }

    function _depositStrategy(uint256 _assets, bool _transfer) internal virtual {
        if (_transfer) IERC20(address(asset)).safeTransferFrom(msg.sender, address(this), _assets);
        Booster memory _boosterData = boosterData;
        IConvexBooster(_boosterData.booster).deposit(_boosterData.boosterPoolId, _assets, true);
    }

    function _withdrawStrategy(uint256 _assets, address _receiver, bool _transfer) internal virtual {
        IConvexBasicRewards(boosterData.crvRewards).withdrawAndUnwrap(_assets, false);
        if (_transfer) IERC20(address(asset)).safeTransfer(_receiver, _assets);
    }

    function _swapFromUnderlying(address _underlyingAsset, uint256 _underlyingAmount, uint256 _minAmount) internal virtual returns (uint256 _assets) {}

    function _swapToUnderlying(address _underlyingAsset, uint256 _assets, uint256 _minAmount) internal virtual returns (uint256) {}

    function _harvest(address _receiver, address _underlyingAsset, uint256 _minimumOut) internal virtual returns (uint256) {}

    function _approve(address _token, address _spender, uint256 _amount) internal {
        IERC20(_token).safeApprove(_spender, 0);
        IERC20(_token).safeApprove(_spender, _amount);
    }

    /********************************** Events **********************************/

    event Deposit(address indexed _caller, address indexed _receiver, uint256 _assets, uint256 _shares);
    event Withdraw(address indexed _caller, address indexed _receiver, address indexed _owner, uint256 _assets, uint256 _shares);
    event YbTokenTransfer(address indexed _caller, address indexed _receiver, uint256 _assets, uint256 _shares);
    event Harvest(address indexed _harvester, address indexed _receiver, uint256 _rewards, uint256 _platformFee);
    event UpdateFees(uint256 _withdrawFeePercentage, uint256 _platformFeePercentage, uint256 _harvestBountyPercentage);
    event UpdateBoosterData(address _booster, address _crvRewards, uint256 _boosterPoolId);
    event UpdateRewardAssets(address[] _rewardAssets);
    event UpdateSettings(address _platform, address _swap, address _ammOperations, address _owner, uint256 _depositCap, address[] _underlyingAssets);
    event UpdateFeelessRedeemerWhitelist(address _address, bool _whitelist);
    event PauseInteractions(bool _pauseDeposit, bool _pauseWithdraw);
    
    /********************************** Errors **********************************/

    error Unauthorized();
    error NotUnderlyingAsset();
    error DepositPaused();
    error WithdrawPaused();
    error InsufficientDepositCap();
    error HarvestAlreadyCalled();
    error ZeroAmount();
    error ZeroAddress();
    error InsufficientBalance();
    error InsufficientAllowance();
    error NoPendingRewards();
    error InvalidAmount();
    error InvalidAsset();
    error InsufficientAmountOut();
    error FailedToSendETH();
    error NotWhitelisted();
}