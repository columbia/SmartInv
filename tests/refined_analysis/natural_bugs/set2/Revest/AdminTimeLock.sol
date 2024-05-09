// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;

import "../../utils/SecuredAddressLock.sol";
import "../../interfaces/IAddressRegistry.sol";
import "../../interfaces/IRevest.sol";
import '@openzeppelin/contracts/utils/introspection/ERC165.sol';

/**
 * @title
 * @dev
 */
contract AdminTimeLock is SecuredAddressLock, ERC165  {

    string public metadataURI = "https://revest.mypinata.cloud/ipfs/QmR9uFVk9fqKwzQHe6dvD4MNDMisJxv16PikxxJNuR6US5";

    mapping (uint => AdminLock) public locks;

    struct AdminLock {
        uint endTime;
        address admin;
        bool unlocked;
    }

    constructor(address reg_) SecuredAddressLock(reg_) {}

    function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IAddressLock).interfaceId
            || interfaceId == type(IRegistryProvider).interfaceId
            || super.supportsInterface(interfaceId);
    }

    function isUnlockable(uint, uint lockId) public view override returns (bool) {
        return locks[lockId].unlocked || block.timestamp > locks[lockId].endTime;
    }


    // Create the lock within that contract DURING minting
    function createLock(uint, uint lockId, bytes memory arguments) external override onlyRevestController {
        uint endTime;
        address admin;
        (endTime, admin) = abi.decode(arguments, (uint, address));

        // Check that we aren't creating a lock in the past
        require(block.timestamp < endTime, 'E002');

        AdminLock memory adminLock = AdminLock(endTime, admin, false);
        locks[lockId] = adminLock;
    }

    function updateLock(uint, uint lockId, bytes memory) external override {
        // For an admin lock, there are no arguments
        if(_msgSender() == locks[lockId].admin) {
           locks[lockId].unlocked = true;
        }
    }

    function needsUpdate() external pure override returns (bool) {
        return true;
    }

    // TODO: Now that we have changed this from being broken for splittable locks, how do we communicate the two-steps
    // That are now needed to unlock this lock?
    function getDisplayValues(uint, uint lockId) external view override returns (bytes memory) {
        uint endTime = locks[lockId].endTime;
        address admin = locks[lockId].admin;
        bool canUnlock = admin == _msgSender();
        return abi.encode(endTime, admin, canUnlock);
    }

    function setMetadata(string memory _metadataURI) external onlyOwner {
        metadataURI = _metadataURI;
    }

    function getMetadata() external view override returns (string memory) {
        return metadataURI;
    }

}
