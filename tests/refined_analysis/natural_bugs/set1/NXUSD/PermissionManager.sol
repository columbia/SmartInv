// SPDX-License-Identifier: None

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "@boringcrypto/boring-solidity/contracts/BoringOwnable.sol";

contract PermissionManager is BoringOwnable {
    struct PermissionInfo {
        uint index;
        bool isAllowed;
    }

    mapping(address => PermissionInfo) public info;
    address[] public allowedAccounts;

    function permit(address _account) public onlyOwner {
        if (info[_account].isAllowed) {
            revert("Account is already permitted");
        }
        info[_account] = PermissionInfo({index: allowedAccounts.length, isAllowed: true});
        allowedAccounts.push(_account);
    }

    function revoke(address _account) public onlyOwner {
        PermissionInfo memory accountInfo = info[_account];

        if (accountInfo.index != allowedAccounts.length-1) {
            address last = allowedAccounts[allowedAccounts.length-1];
            PermissionInfo storage infoLast = info[last];

            allowedAccounts[accountInfo.index] = last;
            infoLast.index = accountInfo.index;
        }

        delete info[_account];
        allowedAccounts.pop();
    }

    function getAllAccounts() public view returns (address[] memory) {
        return allowedAccounts;
    }

    modifier isAllowed() {
        require(info[msg.sender].isAllowed, "sender is not allowed");
        _;
    }
}