// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./interfaces/IRevest.sol";
import "./interfaces/ILockManager.sol";
import "./interfaces/IOracleDispatch.sol";
import "./lib/uniswap/IUniswapV2Pair.sol";
import "./utils/RevestAccessControl.sol";
import "./interfaces/IAddressLock.sol";
import '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';


contract LockManager is ILockManager, ReentrancyGuard, AccessControlEnumerable, RevestAccessControl {

    using ERC165Checker for address;

    bytes4 public constant ADDRESS_LOCK_INTERFACE_ID = type(IAddressLock).interfaceId;
    uint public numLocks = 0; // We increment this to get the lockId for each new lock created
    mapping(uint => uint) public override fnftIdToLockId;
    mapping(uint => IRevest.Lock) public locks; // maps lockId to locks

    constructor(address provider) RevestAccessControl(provider) {}

    /**
     * We access all lock properties by calling this method and then extracting data from the underlying struct
     * No need to write specialized getters for each portion
     */
    function fnftIdToLock(uint fnftId) public view override returns (IRevest.Lock memory) {
        return locks[fnftIdToLockId[fnftId]];
    }

    function getLock(uint lockId) external view override returns (IRevest.Lock memory) {
        return locks[lockId];
    }

    /**
     * Use this when splitting an FNFT so both parts can point to the same lock without creating new ones.
     */
    function pointFNFTToLock(uint fnftId, uint lockId) external override onlyRevest {
        fnftIdToLockId[fnftId] = lockId;
    }

    function createLock(uint fnftId, IRevest.LockParam memory lock) external override onlyRevest returns (uint) {
        // Extensive validation on creation
        require(lock.lockType != IRevest.LockType.DoesNotExist, "E058");
        IRevest.Lock storage newLock = locks[numLocks];
        newLock.lockType = lock.lockType;
        newLock.creationTime = block.timestamp;
        if(lock.lockType == IRevest.LockType.TimeLock) {
            require(lock.timeLockExpiry > block.timestamp, "E002");
            newLock.timeLockExpiry = lock.timeLockExpiry;
        }
        else if (lock.lockType == IRevest.LockType.ValueLock) {
            require(lock.valueLock.unlockValue > 0, "E003");
            require(lock.valueLock.compareTo != address(0) && lock.valueLock.asset != address(0), "E004");
            // Begin validation code to ensure this is actually keyed to a proper oracle
            IOracleDispatch oracle = IOracleDispatch(lock.valueLock.oracle);
            bool oraclePresent = oracle.getPairHasOracle(lock.valueLock.asset, lock.valueLock.compareTo);
            // If the oracle is not present, attempt to initialize it
            if(!oraclePresent && oracle.oracleNeedsInitialization(lock.valueLock.asset, lock.valueLock.compareTo)) {
                oraclePresent = oracle.initializeOracle(lock.valueLock.asset, lock.valueLock.compareTo);
            }
            require(oraclePresent, "E049");
            newLock.valueLock = lock.valueLock;
        }
        else if (lock.lockType == IRevest.LockType.AddressLock) {
            require(lock.addressLock != address(0), "E004");
            newLock.addressLock = lock.addressLock;
        }
        else {
            require(false, "Invalid type");
        }
        fnftIdToLockId[fnftId] = numLocks;
        numLocks += 1;
        return numLocks - 1;
    }

    /**
     * @dev Sets the maturity of an address or value lock to mature – can only be called from main contract
     * if address, only if it is called by the address given permissions to
     * if value, only if value is correct for unlocking
     * lockId - the ID of the FNFT to unlock
     * @return true if the caller is valid and the lock has been unlocked, false otherwise
     */
    function unlockFNFT(uint fnftId, address sender) external override onlyRevestController returns (bool) {
        uint lockId = fnftIdToLockId[fnftId];
        IRevest.Lock storage lock = locks[lockId];
        IRevest.LockType typeLock = lock.lockType;
        if (typeLock == IRevest.LockType.TimeLock) {
            if(!lock.unlocked && lock.timeLockExpiry <= block.timestamp) {
                lock.unlocked = true;
                lock.timeLockExpiry = 0;
            }
        }
        else if (typeLock == IRevest.LockType.ValueLock) {
            bool unlockState;
            address oracleAdd = lock.valueLock.oracle;
            if(getLockMaturity(fnftId)) {
                unlockState = true;
            } else {
                IOracleDispatch oracle = IOracleDispatch(oracleAdd);
                unlockState = oracle.updateOracle(lock.valueLock.asset, lock.valueLock.compareTo) &&
                                getLockMaturity(fnftId);
            }
            if(unlockState && oracleAdd != address(0)) {
                lock.unlocked = true;
                lock.valueLock.oracle = address(0);
                lock.valueLock.asset = address(0);
                lock.valueLock.compareTo = address(0);
                lock.valueLock.unlockValue = 0;
                lock.valueLock.unlockRisingEdge = false;
            }

        }
        else if (typeLock == IRevest.LockType.AddressLock) {
            address addLock = lock.addressLock;
            if (!lock.unlocked && (sender == addLock ||
                    (addLock.supportsInterface(ADDRESS_LOCK_INTERFACE_ID) && IAddressLock(addLock).isUnlockable(fnftId, lockId)))
                ) {
                lock.unlocked = true;
                lock.addressLock = address(0);
            }
        }
        return lock.unlocked;
    }

    /**
     * Return whether a lock of any type is mature. Use this for all locktypes.
     */
    function getLockMaturity(uint fnftId) public view override returns (bool) {
        IRevest.Lock memory lock = locks[fnftIdToLockId[fnftId]];
        if (lock.lockType == IRevest.LockType.TimeLock) {
            return lock.unlocked || lock.timeLockExpiry < block.timestamp;
        }
        else if (lock.lockType == IRevest.LockType.ValueLock) {
            return lock.unlocked || getValueLockMaturity(fnftId);
        }
        else if (lock.lockType == IRevest.LockType.AddressLock) {
            return lock.unlocked || (lock.addressLock.supportsInterface(ADDRESS_LOCK_INTERFACE_ID) &&
                                        IAddressLock(lock.addressLock).isUnlockable(fnftId, fnftIdToLockId[fnftId]));
        }
        else {
            revert("E050");
        }
    }

    function lockTypes(uint tokenId) external view override returns (IRevest.LockType) {
        return fnftIdToLock(tokenId).lockType;
    }

    // Should only read whether the current state is mature based on oracle calls and unlock lists
    // If oracle update tells us that it remains immature, we revert everything
    function getValueLockMaturity(uint fnftId) internal view returns (bool) {
        IRevest.Lock memory lock = fnftIdToLock(fnftId);
        IOracleDispatch oracle = IOracleDispatch(lock.valueLock.oracle);

        uint currentValue = oracle.getValueOfAsset(lock.valueLock.asset, lock.valueLock.compareTo, lock.valueLock.unlockRisingEdge);
        // Perform comparison

        if (lock.valueLock.unlockRisingEdge) {
            return currentValue >= lock.valueLock.unlockValue;
        } else {
            // Only mature if current value less than unlock value
            return currentValue < lock.valueLock.unlockValue;
        }
    }

}
