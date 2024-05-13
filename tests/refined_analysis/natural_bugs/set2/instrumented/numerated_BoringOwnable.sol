1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 // Audit on 5-Jan-2021 by Keno and BoringCrypto
5 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
6 // Edited by BoringCrypto
7 
8 contract BoringOwnableData {
9     address public owner;
10     address public pendingOwner;
11 }
12 
13 contract BoringOwnable is BoringOwnableData {
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
17     /// Can only be invoked by the current `owner`.
18     /// @param newOwner Address of the new owner.
19     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
20     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
21     function transferOwnership(
22         address newOwner,
23         bool direct,
24         bool renounce
25     ) public onlyOwner {
26         if (direct) {
27             // Checks
28             require(newOwner != address(0) || renounce, "Ownable: zero address");
29 
30             // Effects
31             emit OwnershipTransferred(owner, newOwner);
32             owner = newOwner;
33             pendingOwner = address(0);
34         } else {
35             // Effects
36             pendingOwner = newOwner;
37         }
38     }
39 
40     /// @notice Needs to be called by `pendingOwner` to claim ownership.
41     function claimOwnership() public {
42         address _pendingOwner = pendingOwner;
43 
44         // Checks
45         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
46 
47         // Effects
48         emit OwnershipTransferred(owner, _pendingOwner);
49         owner = _pendingOwner;
50         pendingOwner = address(0);
51     }
52 
53     /// @notice Only allows the `owner` to execute the function.
54     modifier onlyOwner() {
55         require(msg.sender == owner, "Ownable: caller is not the owner");
56         _;
57     }
58 }