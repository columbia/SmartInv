1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 import "./IRevest.sol";
6 
7 interface ILockManager {
8 
9     function createLock(uint fnftId, IRevest.LockParam memory lock) external returns (uint);
10 
11     function getLock(uint lockId) external view returns (IRevest.Lock memory);
12 
13     function fnftIdToLockId(uint fnftId) external view returns (uint);
14 
15     function fnftIdToLock(uint fnftId) external view returns (IRevest.Lock memory);
16 
17     function pointFNFTToLock(uint fnftId, uint lockId) external;
18 
19     function lockTypes(uint tokenId) external view returns (IRevest.LockType);
20 
21     function unlockFNFT(uint fnftId, address sender) external returns (bool);
22 
23     function getLockMaturity(uint fnftId) external view returns (bool);
24 }
