// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;

import "../../interfaces/IAddressRegistry.sol";
import "../../interfaces/IRevest.sol";
import "../../interfaces/ITokenVault.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import '@openzeppelin/contracts/utils/introspection/ERC165.sol';
import "../../utils/SecuredAddressLock.sol";

contract SupplyLock is SecuredAddressLock, ERC165  {

    mapping(uint => SupplyLockDetails) private locks;

    struct SupplyLockDetails {
        uint supplyLevels;
        address asset;
        bool isLockRisingEdge;
    }

    using SafeERC20 for IERC20;

    constructor(address registry) SecuredAddressLock(registry) {}

    function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IAddressLock).interfaceId
            || interfaceId == type(IRegistryProvider).interfaceId
            || super.supportsInterface(interfaceId);
    }

    function isUnlockable(uint, uint lockId) public view override returns (bool) {
        address asset = locks[lockId].asset;
        uint supply = locks[lockId].supplyLevels;
        if (locks[lockId].isLockRisingEdge) {
            return IERC20(asset).totalSupply() > supply;
        } else {
            return IERC20(asset).totalSupply() < supply;
        }
    }

    function createLock(uint , uint lockId, bytes memory arguments) external override onlyRevestController {
        uint supply;
        bool isRisingEdge;
        address asset;
        (supply, asset, isRisingEdge) = abi.decode(arguments, (uint, address, bool));
        locks[lockId].supplyLevels = supply;
        locks[lockId].isLockRisingEdge = isRisingEdge;
        locks[lockId].asset = asset;
    }

    function updateLock(uint fnftId, uint lockId, bytes memory arguments) external override {}

    function needsUpdate() external pure override returns (bool) {
        return false;
    }

    function getMetadata() external pure override returns (string memory) {
        return "https://revest.mypinata.cloud/ipfs/QmWQWvdpn4ovFEZxYXEqtcGdCCmpwf2FCwDUdh198Fb62g";
    }

    function getDisplayValues(uint, uint lockId) external view override returns (bytes memory) {
        SupplyLockDetails memory lockDetails = locks[lockId];
        return abi.encode(lockDetails.supplyLevels, lockDetails.asset, lockDetails.isLockRisingEdge);
    }
}
