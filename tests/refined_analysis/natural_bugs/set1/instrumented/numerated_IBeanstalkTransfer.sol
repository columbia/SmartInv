1 // SPDX-License-Identifier: MIT
2 pragma experimental ABIEncoderV2;
3 pragma solidity =0.7.6;
4 
5 import "@openzeppelin/contracts/drafts/IERC20Permit.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 
8 enum From {
9     EXTERNAL,
10     INTERNAL,
11     EXTERNAL_INTERNAL,
12     INTERNAL_TOLERANT
13 }
14 enum To {
15     EXTERNAL,
16     INTERNAL
17 }
18 
19 interface IBeanstalkTransfer {
20     function transferInternalTokenFrom(
21         IERC20 token,
22         address sender,
23         address recipient,
24         uint256 amount,
25         To toMode
26     ) external payable;
27 
28     function permitToken(
29         address owner,
30         address spender,
31         address token,
32         uint256 value,
33         uint256 deadline,
34         uint8 v,
35         bytes32 r,
36         bytes32 s
37     ) external payable;
38 
39     function transferDeposit(
40         address sender,
41         address recipient,
42         address token,
43         int96 stem,
44         uint256 amount
45     ) external payable returns (uint256 bdv);
46 
47     function transferDeposits(
48         address sender,
49         address recipient,
50         address token,
51         int96[] calldata stems,
52         uint256[] calldata amounts
53     ) external payable returns (uint256[] memory bdvs);
54 
55     function permitDeposits(
56         address owner,
57         address spender,
58         address[] calldata tokens,
59         uint256[] calldata values,
60         uint256 deadline,
61         uint8 v,
62         bytes32 r,
63         bytes32 s
64     ) external payable;
65 
66     function permitDeposit(
67         address owner,
68         address spender,
69         address token,
70         uint256 value,
71         uint256 deadline,
72         uint8 v,
73         bytes32 r,
74         bytes32 s
75     ) external payable;
76 }
