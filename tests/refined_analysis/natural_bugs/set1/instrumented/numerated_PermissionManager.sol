1 // SPDX-License-Identifier: None
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 import "@boringcrypto/boring-solidity/contracts/BoringOwnable.sol";
7 
8 contract PermissionManager is BoringOwnable {
9     struct PermissionInfo {
10         uint index;
11         bool isAllowed;
12     }
13 
14     mapping(address => PermissionInfo) public info;
15     address[] public allowedAccounts;
16 
17     function permit(address _account) public onlyOwner {
18         if (info[_account].isAllowed) {
19             revert("Account is already permitted");
20         }
21         info[_account] = PermissionInfo({index: allowedAccounts.length, isAllowed: true});
22         allowedAccounts.push(_account);
23     }
24 
25     function revoke(address _account) public onlyOwner {
26         PermissionInfo memory accountInfo = info[_account];
27 
28         if (accountInfo.index != allowedAccounts.length-1) {
29             address last = allowedAccounts[allowedAccounts.length-1];
30             PermissionInfo storage infoLast = info[last];
31 
32             allowedAccounts[accountInfo.index] = last;
33             infoLast.index = accountInfo.index;
34         }
35 
36         delete info[_account];
37         allowedAccounts.pop();
38     }
39 
40     function getAllAccounts() public view returns (address[] memory) {
41         return allowedAccounts;
42     }
43 
44     modifier isAllowed() {
45         require(info[msg.sender].isAllowed, "sender is not allowed");
46         _;
47     }
48 }