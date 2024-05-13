1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 pragma abicoder v2;
4 
5 interface IUniversalVault {
6     /* user events */
7 
8     event Locked(address delegate, address token, uint256 amount);
9     event Unlocked(address delegate, address token, uint256 amount);
10     event RageQuit(address delegate, address token, bool notified, string reason);
11 
12     /* data types */
13 
14     struct LockData {
15         address delegate;
16         address token;
17         uint256 balance;
18     }
19 
20     /* initialize function */
21 
22     function initialize() external;
23 
24     /* user functions */
25 
26     function lock(
27         address token,
28         uint256 amount,
29         bytes calldata permission
30     ) external;
31 
32     function unlock(
33         address token,
34         uint256 amount,
35         bytes calldata permission
36     ) external;
37 
38     function rageQuit(address delegate, address token)
39         external
40         returns (bool notified, string memory error);
41 
42     function transferERC20(
43         address token,
44         address to,
45         uint256 amount
46     ) external;
47 
48     function transferETH(address to, uint256 amount) external payable;
49 
50     /* pure functions */
51 
52     function calculateLockID(address delegate, address token)
53         external
54         pure
55         returns (bytes32 lockID);
56 
57     /* getter functions */
58 
59     function getPermissionHash(
60         bytes32 eip712TypeHash,
61         address delegate,
62         address token,
63         uint256 amount,
64         uint256 nonce
65     ) external view returns (bytes32 permissionHash);
66 
67     function getNonce() external view returns (uint256 nonce);
68 
69     function owner() external view returns (address ownerAddress);
70 
71     function getLockSetCount() external view returns (uint256 count);
72 
73     function getLockAt(uint256 index) external view returns (LockData memory lockData);
74 
75     function getBalanceDelegated(address token, address delegate)
76         external
77         view
78         returns (uint256 balance);
79 
80     function getBalanceLocked(address token) external view returns (uint256 balance);
81 
82     function checkBalances() external view returns (bool validity);
83 }
