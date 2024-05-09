pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "./PermissionManager.sol";

contract WhitelistManager is PermissionManager {
    bool private statusEnable = true;

    function setCheckStatus(bool status) public onlyOwner {
        statusEnable = status;
    }

    function isEnable() public view returns (bool) {
        return statusEnable;
    }
}