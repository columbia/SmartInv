1 pragma solidity 0.6.12;
2 pragma experimental ABIEncoderV2;
3 
4 import "./PermissionManager.sol";
5 
6 contract WhitelistManager is PermissionManager {
7     bool private statusEnable = true;
8 
9     function setCheckStatus(bool status) public onlyOwner {
10         statusEnable = status;
11     }
12 
13     function isEnable() public view returns (bool) {
14         return statusEnable;
15     }
16 }