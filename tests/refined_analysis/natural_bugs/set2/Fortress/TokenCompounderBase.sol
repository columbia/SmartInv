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
                                                                                    
//  _____    _           _____                             _         _____             
// |_   ____| |_ ___ ___|     |___ _____ ___ ___ _ _ ___ _| |___ ___| __  |___ ___ ___ 
//   | || . | '_| -_|   |   --| . |     | . | . | | |   | . | -_|  _| __ -| .'|_ -| -_|
//   |_||___|_,_|___|_|_|_____|___|_|_|_|  _|___|___|_|_|___|___|_| |_____|__,|___|___|
//                                      |_|                                            

// Github - https://github.com/FortressFinance

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

import {ERC4626, ERC20, FixedPointMathLib} from "src/shared/interfaces/ERC4626.sol";

abstract contract TokenCompounderBase is ReentrancyGuard, ERC4626 {

    using FixedPointMathLib for uint256;
    using SafeERC20 for IERC20;
    
    struct Fees {
        /// @notice The performance fee percentage to take for platform on harvest
        uint256 platformFeePercentage;
        /// @notice The percentage of fee to pay for caller on harvest
        uint256 harvestBountyPercentage;
        /// @notice The fee percentage to take on withdrawal. Fee stays in the vault, and is therefore distributed to vault participants. Used as a mechanism to protect against mercenary capital
        uint256 withdrawFeePercentage;
    }

    /// @notice The fees settings
    Fees public fees;

    /// @notice The last block number that the harvest function was executed
    uint256 public lastHarvestBlock;
    /// @notice The internal accounting of AUM
    uint256 internal totalAUM;
    /// @notice The internal accounting of the deposit limit. Denominated in shares
    uint256 public depositCap;

    /// @notice The description of the vault
    string public description;

    /// @notice The address of owner
    address public owner;
    /// @notice The address of recipient of platform fee
    address public platform;
    /// @notice The address of FortressSwap contract
    address public swap;

    /// @notice Whether deposits are paused
    bool public pauseDeposit = false;
    /// @notice Whether withdrawals are paused
    bool public pauseWithdraw = false;

    /// @notice The fee denominator
    uint256 internal constant FEE_DENOMINATOR = 1e9;
    /// @notice The maximum withdrawal fee
    uint256 internal constant MAX_WITHDRAW_FEE = 1e8; // 10%
    /// @notice The maximum platform fee
    uint256 internal constant MAX_PLATFORM_FEE = 2e8; // 20%
    /// @notice The maximum harvest fee
    uint256 internal constant MAX_HARVEST_BOUNTY = 1e8; // 10%

    /// @notice The underlying assets
    address[] public underlyingAssets;

    /// @notice The mapping of whitelisted feeless redeemers
    mapping(address => bool) public feelessRedeemerWhitelist;

    /********************************** Constructor **********************************/

    constructor(
            ERC20 _asset,
            string memory _name,
            string memory _symbol,
            string memory _description,
            address _owner,
            address _platform,
            address _swap,
            address[] memory _underlyingAssets
        )
        ERC4626(_asset, _name, _symbol) {

        {
            Fees storage _fees = fees;
            _fees.platformFeePercentage = 50000000; // 5%
            _fees.harvestBountyPercentage = 25000000; // 2.5%
            _fees.withdrawFeePercentage = 2000000; // 0.2%
        }
        
        description = _description;
        owner = _owner;
        platform = _platform;
        swap = _swap;
        depositCap = 0;
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
        return description;
    }

    /// @dev Indicates whether there are pending rewards to harvest
    /// @return - True if there's pending rewards, false if otherwise
    function isPendingRewards() public view virtual returns (bool) {}

    /// @dev Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions
    /// @param _shares - The amount of _shares to redeem
    /// @return - The amount of _assets in return, after subtracting a withdrawal fee
    function previewRedeem(uint256 _shares) public view override returns (uint256) {
        // Calculate assets based on a user's % ownership of vault shares
        uint256 assets = convertToAssets(_shares);

        uint256 _totalSupply = totalSupply;

        // Calculate a fee - zero if user is the last to withdraw
        uint256 _fee = (_totalSupply == 0 || _totalSupply - _shares == 0) ? 0 : assets.mulDivDown(fees.withdrawFeePercentage, FEE_DENOMINATOR);

        // Redeemable amount is the post-withdrawal-fee amount
        return assets - _fee;
    }

    /// @dev Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions
    /// @param _assets - The amount of _assets to withdraw
    /// @return - The amount of shares to burn, after subtracting a fee
    function previewWithdraw(uint256 _assets) public view override returns (uint256) {
        // Calculate shares based on the specified assets' proportion of the pool
        uint256 _shares = convertToShares(_assets);

        uint256 _totalSupply = totalSupply;

        // Factor in additional shares to fulfill withdrawal if user is not the last to withdraw
        return (_totalSupply == 0 || _totalSupply - _shares == 0) ? _shares : (_shares * FEE_DENOMINATOR) / (FEE_DENOMINATOR - fees.withdrawFeePercentage);
    }

    /// @dev Returns the total amount of assets that are managed by the vault
    /// @return - The total amount of managed assets
    function totalAssets() public view virtual override returns (uint256) {
        return totalAUM;
    }

    /// @dev Returns the maximum amount of the underlying asset that can be deposited into the Vault for the receiver, through a deposit call
    function maxDeposit(address) public view override returns (uint256) {
        uint256 _assetCap = convertToAssets(depositCap);
        return _assetCap == 0 ? type(uint256).max : _assetCap - totalAUM;
    }

    /// @dev Returns the maximum amount of the Vault shares that can be minted for the receiver, through a mint call
    function maxMint(address) public view override returns (uint256) {
        return depositCap == 0 ? type(uint256).max : depositCap - totalSupply;
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

    /// @dev Mints Vault shares to _receiver by depositing exact amount of underlying assets
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

    /// @dev Mints exact Vault shares to _receiver by depositing amount of underlying assets
    /// @param _shares - The shares to receive
    /// @param _receiver - The address of the receiver of shares
    /// @return _assets - The amount of underlying assets received
    function mint(uint256 _shares, address _receiver) external override nonReentrant returns (uint256 _assets) {
        if (_shares >= maxMint(msg.sender)) revert InsufficientDepositCap();

        _assets = previewMint(_shares);

        _deposit(msg.sender, _receiver, _assets, _shares);

        _depositStrategy(_assets, true);
        
        return _assets;
    }

    /// @dev Burns shares from owner and sends exact assets of underlying assets to _receiver. If the _owner is whitelisted, no withdrawal fee is applied
    /// @param _assets - The amount of underlying assets to receive
    /// @param _receiver - The address of the receiver of underlying assets
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

    /// @dev Burns exact shares from owner and sends assets of underlying tokens to _receiver. If the _owner is whitelisted, no withdrawal fee is applied
    /// @param _shares - The shares to burn
    /// @param _receiver - The address of the receiver of underlying assets
    /// @param _owner - The owner of shares to burn
    /// @return _assets - The amount of assets returned to the user
    function redeem(uint256 _shares, address _receiver, address _owner) external override nonReentrant returns (uint256 _assets) {
        if (_shares > maxRedeem(_owner)) revert InsufficientBalance();

        // If the _owner is whitelisted, we can skip the preview and just convert the shares to assets
        _assets = feelessRedeemerWhitelist[_owner] ? convertToAssets(_shares) : previewRedeem(_shares);

        _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
        
        _withdrawStrategy(_assets, _receiver, true);
        
        return _assets;
    }

    /// @dev Mints Vault shares to receiver by depositing exact amount of unwrapped underlying assets
    /// @param _underlyingAsset - The address of the underlying asset to deposit
    /// @param _receiver - The receiver of minted shares
    /// @param _underlyingAmount - The amount of unwrapped underlying assets to deposit
    /// @param _minAmount - The minimum amount of asset to get for unwrapped asset
    /// @return _shares - The amount of shares minted
    function depositUnderlying(address _underlyingAsset, address _receiver, uint256 _underlyingAmount, uint256 _minAmount) external virtual payable nonReentrant returns (uint256 _shares) {}

    /// @notice that this function is vulnerable to a frontrunning attack if called without asserting the returned value
    /// @notice If the _owner is whitelisted, no withdrawal fee is applied
    /// @dev Burns exact shares from owner and sends assets of unwrapped underlying tokens to _receiver
    /// @param _underlyingAsset - The address of the underlying asset to withdraw
    /// @param _receiver - The address of the receiver of underlying assets
    /// @param _owner - The owner of shares to burn
    /// @param _shares - The shares to burn
    /// @param _minAmount - The minimum amount of underlying assets to get for assets
    /// @return _underlyingAssets - The amount of assets returned to the user
    function redeemUnderlying(address _underlyingAsset, address _receiver, address _owner, uint256 _shares, uint256 _minAmount) external virtual nonReentrant returns (uint256 _underlyingAssets) {}
    
    /// @dev Harvest the pending rewards and convert to underlying token, then stake
    /// @param _receiver - The address of account to receive harvest bounty
    /// @param _minBounty - The minimum amount of harvest bounty _receiver should get
    function harvest(address _receiver, uint256 _minBounty) external nonReentrant returns (uint256 _rewards) {
        if (block.number == lastHarvestBlock) revert HarvestAlreadyCalled();
        lastHarvestBlock = block.number;

        _rewards = _harvest(_receiver, _minBounty);
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
        if (msg.sender != owner) revert Unauthorized();

        feelessRedeemerWhitelist[_address] = _whitelist;
    }

    /// @dev Updates the vault fees
    /// @param _withdrawFeePercentage - The new withdrawal fee percentage
    /// @param _platformFeePercentage - The new platform fee percentage
    /// @param _harvestBountyPercentage - The new harvest fee percentage
    function updateFees(uint256 _withdrawFeePercentage, uint256 _platformFeePercentage, uint256 _harvestBountyPercentage) external {
        if (msg.sender != owner) revert Unauthorized();
        if (_withdrawFeePercentage > MAX_WITHDRAW_FEE) revert InvalidAmount();
        if (_platformFeePercentage > MAX_PLATFORM_FEE) revert InvalidAmount();
        if (_harvestBountyPercentage > MAX_HARVEST_BOUNTY) revert InvalidAmount();

        Fees storage _fees = fees;
        _fees.withdrawFeePercentage = _withdrawFeePercentage;
        _fees.platformFeePercentage = _platformFeePercentage;
        _fees.harvestBountyPercentage = _harvestBountyPercentage;

        emit UpdateFees(_withdrawFeePercentage, _platformFeePercentage, _harvestBountyPercentage);
    }

    /// @dev updates the vault settings
    /// @param _platform - The Fortress platform address
    /// @param _swap - The Fortress swap address
    /// @param _owner - The vault owner address
    /// @param _depositCap - The deposit cap
    /// @param _underlyingAssets - The underlying assets
    function updateSettings(address _platform, address _swap, address _owner, uint256 _depositCap, address[] memory _underlyingAssets) external {
        if (msg.sender != owner) revert Unauthorized();

        platform = _platform;
        swap = _swap;
        owner = _owner;
        depositCap = _depositCap;
        underlyingAssets = _underlyingAssets;

        emit UpdateInternalUtils();
    }

    /// @dev Pauses deposits/withdrawals for the vault
    /// @param _pauseDeposit - The new deposit status
    /// @param _pauseWithdraw - The new withdraw status
    function pauseInteractions(bool _pauseDeposit, bool _pauseWithdraw) external {
        if (msg.sender != owner) revert Unauthorized();

        pauseDeposit = _pauseDeposit;
        pauseWithdraw = _pauseWithdraw;
        
        emit PauseInteractions(_pauseDeposit, _pauseWithdraw);
    }

    /********************************** Internal Functions **********************************/

    function _deposit(address _caller, address _receiver, uint256 _assets, uint256 _shares) internal override {
        if (pauseDeposit) revert DepositPaused();
        if (_receiver == address(0)) revert ZeroAddress();
        if (!(_assets > 0)) revert ZeroAmount();
        if (!(_shares > 0)) revert ZeroAmount();

        _mint(_receiver, _shares);
        totalAUM += _assets;

        emit Deposit(_caller, _receiver, _assets, _shares);
    }

    function _withdraw(address _caller, address _receiver, address _owner, uint256 _assets, uint256 _shares) internal override {
        if (pauseWithdraw) revert WithdrawPaused();
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

    function _harvest(address _receiver, uint256 _minimumOut) internal virtual returns (uint256) {}

    function _depositStrategy(uint256 _assets, bool _transfer) internal virtual {
        if (_transfer) IERC20(address(asset)).safeTransferFrom(msg.sender, address(this), _assets);
    }

    function _withdrawStrategy(uint256 _assets, address _receiver, bool _transfer) internal virtual {
        if (_transfer) IERC20(address(asset)).safeTransfer(_receiver, _assets);
    }

    /********************************** Events **********************************/

    event Deposit(address indexed _caller, address indexed _receiver, uint256 _assets, uint256 _shares);
    event Withdraw(address indexed _caller, address indexed _receiver, address indexed _owner, uint256 _assets, uint256 _shares);
    event YbTokenTransfer(address indexed _caller, address indexed _receiver, uint256 _assets, uint256 _shares);
    event Harvest(address indexed _harvester, uint256 _amount);
    event UpdateFees(uint256 _withdrawFeePercentage, uint256 _platformFeePercentage, uint256 _harvestBountyPercentage);
    event PauseInteractions(bool _pauseDeposit, bool _pauseWithdraw);
    event UpdateInternalUtils();
    
    /********************************** Errors **********************************/

    error Unauthorized();
    error InsufficientBalance();
    error InsufficientAllowance();
    error InvalidAmount();
    error InsufficientDepositCap();
    error HarvestAlreadyCalled();
    error ZeroAddress();
    error ZeroAmount();
    error InsufficientAmountOut();
    error DepositPaused();
    error WithdrawPaused();
    error NoPendingRewards();
    error NotUnderlyingAsset();
}