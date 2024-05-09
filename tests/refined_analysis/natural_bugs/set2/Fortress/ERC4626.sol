// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.17;

import {ERC20} from "./ERC20.sol";
import {FixedPointMathLib} from "./utils/FixedPointMathLib.sol";

/// @notice Minimal ERC4626 tokenized Vault implementation.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/mixins/ERC4626.sol)
abstract contract ERC4626 is ERC20 {
    
    using FixedPointMathLib for uint256;

    /*//////////////////////////////////////////////////////////////
                               IMMUTABLES
    //////////////////////////////////////////////////////////////*/

    ERC20 public immutable asset;

    constructor(ERC20 _asset, string memory _name, string memory _symbol) ERC20(_name, _symbol, _asset.decimals()) {
        asset = _asset;
    }

    /*//////////////////////////////////////////////////////////////
                        DEPOSIT/WITHDRAWAL LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @dev Mints Vault shares to receiver by depositing exact amount of underlying assets.
    /// @param assets - The amount of assets to deposit.
    /// @param receiver - The receiver of minted shares.
    /// @return shares - The amount of shares minted.
    function deposit(uint256 assets, address receiver) external virtual returns (uint256 shares) {
        // require(assets <= maxDeposit(receiver), "ERC4626: deposit more than max");

        // shares = previewDeposit(assets);
        // _deposit(msg.sender, receiver, assets, shares);

        // return shares;
    }

    /// @dev Mints exact Vault shares to receiver by depositing amount of underlying assets.
    /// @param shares - The shares to receive.
    /// @param receiver - The address of the receiver of shares.
    /// @return assets - The amount of underlying assets received.
    function mint(uint256 shares, address receiver) external virtual returns (uint256 assets) {
        // require(shares <= maxMint(receiver), "ERC4626: mint more than max");

        // assets = previewMint(shares);
        // _deposit(msg.sender, receiver, assets, shares);

        // return assets;
    }

    /// @dev Burns shares from owner and sends exact assets of underlying assets to receiver.
    /// @param assets - The amount of underlying assets to receive.
    /// @param receiver - The address of the receiver of underlying assets.
    /// @param owner - The owner of shares.
    /// @return shares - The amount of shares burned.
    function withdraw(uint256 assets, address receiver, address owner) external virtual returns (uint256 shares) {
        // require(assets <= maxWithdraw(owner), "ERC4626: withdraw more than max");

        // shares = previewWithdraw(assets);
        // _withdraw(msg.sender, receiver, owner, assets, shares);

        // return shares;
    }

    /// @dev Burns exact shares from owner and sends assets of underlying tokens to receiver.
    /// @param shares - The shares to burn.
    /// @param receiver - The address of the receiver of underlying assets.
    /// @param owner - The owner of shares to burn.
    /// @return assets - The amount of assets returned to the user.
    function redeem(uint256 shares, address receiver, address owner) external virtual returns (uint256 assets) {
        // require(shares <= maxRedeem(owner), "ERC4626: redeem more than max");

        // assets = previewRedeem(shares);
        // _withdraw(msg.sender, receiver, owner, assets, shares);

        // return assets;
    }

    /*//////////////////////////////////////////////////////////////
                            ACCOUNTING LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @dev Returns the total amount of the underlying asset that is “managed” by Vault.
    function totalAssets() public view virtual returns (uint256);

    /// @dev Returns the amount of shares that the Vault would exchange for the amount of assets provided, in an ideal scenario.
    function convertToShares(uint256 assets) public view virtual returns (uint256) {
        uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.

        // slither-disable-next-line incorrect-equality
        return supply == 0 ? assets : assets.mulDivDown(supply, totalAssets());
    }

    /// @dev Returns the amount of assets that the Vault would exchange for the amount of shares provided, in an ideal scenario
    function convertToAssets(uint256 shares) public view virtual returns (uint256) {
        uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.

        // slither-disable-next-line incorrect-equality
        return supply == 0 ? shares : shares.mulDivDown(totalAssets(), supply);
    }

    /// @dev Allows an on-chain or off-chain user to simulate the effects of their deposit at the current block, given current on-chain conditions.
    function previewDeposit(uint256 _assets) public view virtual returns (uint256) {
        return convertToShares(_assets);
    }

    /// @dev Allows an on-chain or off-chain user to simulate the effects of their mint at the current block, given current on-chain conditions.
    function previewMint(uint256 _shares) public view virtual returns (uint256) {
        return convertToAssets(_shares);
    }

    /// @dev Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions.
    function previewWithdraw(uint256 assets) public view virtual returns (uint256) {
        return convertToShares(assets);
    }

    /// @dev Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions.
    function previewRedeem(uint256 shares) public view virtual returns (uint256) {
        return convertToAssets(shares);
    }

    /*//////////////////////////////////////////////////////////////
                     DEPOSIT/WITHDRAWAL LIMIT LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @dev Returns the maximum amount of the underlying asset that can be deposited into the Vault for the receiver, through a deposit call.
    function maxDeposit(address) public view virtual returns (uint256) {
        return type(uint256).max;
    }

    /// @dev Returns the maximum amount of the Vault shares that can be minted for the receiver, through a mint call.
    function maxMint(address) public view virtual returns (uint256) {
        return type(uint256).max;
    }

    /// @dev Returns the maximum amount of the underlying asset that can be withdrawn from the owner balance in the Vault, through a withdraw call.
    function maxWithdraw(address owner) public view virtual returns (uint256) {
        return convertToAssets(balanceOf[owner]);
    }

    /// @dev Returns the maximum amount of Vault shares that can be redeemed from the owner balance in the Vault, through a redeem call.
    function maxRedeem(address owner) public view virtual returns (uint256) {
        return balanceOf[owner];
    }

    /*//////////////////////////////////////////////////////////////
                          INTERNAL HOOKS LOGIC
    //////////////////////////////////////////////////////////////*/

   function _withdraw(address caller, address receiver, address owner, uint256 assets, uint256 shares) internal virtual {}

    function _deposit(address caller, address receiver, uint256 assets, uint256 shares) internal virtual {}
}