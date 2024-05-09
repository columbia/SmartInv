// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;

import "../../interfaces/IAddressRegistry.sol";
import "../../interfaces/IRevest.sol";
import "../../interfaces/ITokenVault.sol";
import "../../interfaces/IOracleDispatch.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import '@openzeppelin/contracts/utils/introspection/ERC165.sol';
import "../../utils/SecuredAddressLock.sol";

/**
 * @title
 * @dev
 */
contract BinaryComboLock is SecuredAddressLock, ERC165  {

    string public metadataURI = "https://revest.mypinata.cloud/ipfs/QmQMVXytJCebqKVbo4iMyU4gRuG5pUAdCKgf5UbZf51tAc";

    constructor(address registry) SecuredAddressLock(registry) {}

    mapping (uint => ComboLock) private locks;

    struct ComboLock {
        uint endTime;
        uint unlockValue;
        bool unlockRisingEdge;
        bool isAnd;
        address asset1;
        address asset2;
        address oracle;
    }

    using SafeERC20 for IERC20;

    function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IAddressLock).interfaceId
            || interfaceId == type(IRegistryProvider).interfaceId
            || super.supportsInterface(interfaceId);
    }

    function isUnlockable(uint , uint lockId) public view override returns (bool) {
        ComboLock memory lock = locks[lockId];
        if(lock.isAnd) {
            return block.timestamp > lock.endTime && getLockMaturity(lockId);
        } else {
            // Or
            return block.timestamp > lock.endTime || getLockMaturity(lockId);
        }
    }


    // Create the lock within that contract DURING minting
    // Likely will be best-practices to call this AFTER minting, once we know that fnftId is set
    function createLock(uint, uint lockId, bytes memory arguments) external override onlyRevestController {
        uint endTime;
        uint unlockValue;
        bool unlockRisingEdge;
        bool isAnd;
        address asset1;
        address asset2;
        address oracleAdd;
        (endTime, unlockValue, unlockRisingEdge, isAnd, asset1, asset2, oracleAdd) =
            abi.decode(arguments, (uint, uint, bool, bool, address, address, address));
        ComboLock memory combo = ComboLock(endTime, unlockValue, unlockRisingEdge, isAnd, asset1, asset2, oracleAdd);
        IOracleDispatch oracle = IOracleDispatch(oracleAdd);
        bool oraclePresent = oracle.getPairHasOracle(asset1, asset2);
        //If the oracle is not present, attempt to initialize it
        if(!oraclePresent && oracle.oracleNeedsInitialization(asset1, asset2)) {
            oraclePresent = oracle.initializeOracle(asset1, asset2);
        }
        require(oraclePresent, "E049");

        locks[lockId] = combo;

    }

    function updateLock(uint, uint lockId, bytes memory ) external override {
        // For a combo lock, there are no arguments
        IOracleDispatch oracle = IOracleDispatch(locks[lockId].oracle);
        oracle.updateOracle(locks[lockId].asset1, locks[lockId].asset2);
    }

    function needsUpdate() external pure override returns (bool) {
        return true;
    }

    function getDisplayValues(uint, uint lockId) external view override returns (bytes memory) {
        ComboLock memory lockDetails = locks[lockId];
        IOracleDispatch oracle = IOracleDispatch(locks[lockId].oracle);
        bool needsUpdateNow = oracle.oracleNeedsUpdates(lockDetails.asset1, lockDetails.asset2);
        if(needsUpdateNow) {
            uint twapPrice = oracle.getValueOfAsset(lockDetails.asset1, lockDetails.asset2, lockDetails.unlockRisingEdge);
            uint instantPrice = oracle.getInstantPrice(lockDetails.asset1, lockDetails.asset2);
            if(lockDetails.unlockRisingEdge) {
                needsUpdateNow = instantPrice > lockDetails.unlockValue && twapPrice < lockDetails.unlockValue;
            } else {
                needsUpdateNow = instantPrice < lockDetails.unlockValue && twapPrice > lockDetails.unlockValue;
            }
        }
        return abi.encode(lockDetails.endTime, lockDetails.unlockValue, lockDetails.unlockRisingEdge, lockDetails.isAnd, lockDetails.asset1, lockDetails.asset2, lockDetails.oracle, needsUpdateNow);
    }

    function setMetadata(string memory _metadataURI) external onlyOwner {
        metadataURI = _metadataURI;
    }

    function getMetadata() external view override returns (string memory) {
        return metadataURI;
    }

    function getValueLockMaturity(uint lockId) internal returns (bool) {
        if(getLockMaturity(lockId)) {
            return true;
        } else {
            IOracleDispatch oracle = IOracleDispatch(locks[lockId].oracle);
            return oracle.updateOracle(locks[lockId].asset1, locks[lockId].asset2) &&
                            getLockMaturity(lockId);
        }
    }

    function getLockMaturity(uint lockId) internal view returns (bool) {
        IOracleDispatch oracle = IOracleDispatch(locks[lockId].oracle);
        // Will not trigger an update
        bool rising = locks[lockId].unlockRisingEdge;
        uint currentValue = oracle.getValueOfAsset(locks[lockId].asset1, locks[lockId].asset2, rising);
        // Perform comparison
        if (rising) {
            return currentValue >= locks[lockId].unlockValue;
        } else {
            // Only mature if current value less than unlock value
            return currentValue < locks[lockId].unlockValue;
        }
    }
}
