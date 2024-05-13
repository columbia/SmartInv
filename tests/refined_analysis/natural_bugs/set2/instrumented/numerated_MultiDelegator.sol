1 pragma solidity ^0.5.16;
2 
3 pragma experimental ABIEncoderV2;
4 
5 interface InvInterface {
6     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
7 }
8 
9 interface XInvInterface {
10     function syncDelegate(address user) external;
11 }
12 
13 contract MultiDelegator {
14 
15     InvInterface public inv;
16     XInvInterface xinv;
17 
18     constructor (InvInterface _inv, XInvInterface _xinv) public {
19         inv = _inv;
20         xinv = _xinv;
21     }
22 
23     function delegateBySig(address delegatee, address[] memory delegator, uint[] memory nonce, uint[] memory expiry, uint8[] memory v, bytes32[] memory r, bytes32[] memory s) public {
24         for (uint256 i = 0; i < nonce.length; i++) {
25             inv.delegateBySig(delegatee, nonce[i], expiry[i], v[i], r[i], s[i]);
26             xinv.syncDelegate(delegator[i]);
27         }
28     }
29 }