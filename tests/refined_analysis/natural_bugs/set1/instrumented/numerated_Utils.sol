1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { Address } from "@openzeppelin/contracts/utils/Address.sol";
5 
6 import { PPM_RESOLUTION } from "./Constants.sol";
7 import { Token } from "../token/Token.sol";
8 import { TokenLibrary } from "../token/TokenLibrary.sol";
9 
10 error AccessDenied();
11 error AlreadyExists();
12 error DoesNotExist();
13 error InvalidAddress();
14 error InvalidExternalAddress();
15 error InvalidFee();
16 error InvalidToken();
17 error InvalidParam();
18 error NotEmpty();
19 error NotPayable();
20 error ZeroValue();
21 
22 /**
23  * @dev common utilities
24  */
25 abstract contract Utils {
26     using TokenLibrary for Token;
27     using Address for address payable;
28 
29     // allows execution by the caller only
30     modifier only(address caller) {
31         _only(caller);
32 
33         _;
34     }
35 
36     function _only(address caller) internal view {
37         if (msg.sender != caller) {
38             revert AccessDenied();
39         }
40     }
41 
42     // verifies that a value is greater than zero
43     modifier greaterThanZero(uint256 value) {
44         _greaterThanZero(value);
45 
46         _;
47     }
48 
49     // error message binary size optimization
50     function _greaterThanZero(uint256 value) internal pure {
51         if (value == 0) {
52             revert ZeroValue();
53         }
54     }
55 
56     // validates an address - currently only checks that it isn't null
57     modifier validAddress(address addr) {
58         _validAddress(addr);
59 
60         _;
61     }
62 
63     // error message binary size optimization
64     function _validAddress(address addr) internal pure {
65         if (addr == address(0)) {
66             revert InvalidAddress();
67         }
68     }
69 
70     // validates an external address - currently only checks that it isn't null or this
71     modifier validExternalAddress(address addr) {
72         _validExternalAddress(addr);
73 
74         _;
75     }
76 
77     // error message binary size optimization
78     function _validExternalAddress(address addr) internal view {
79         if (addr == address(0) || addr == address(this)) {
80             revert InvalidExternalAddress();
81         }
82     }
83 
84     // ensures that the fee is valid
85     modifier validFee(uint32 fee) {
86         _validFee(fee);
87 
88         _;
89     }
90 
91     // error message binary size optimization
92     function _validFee(uint32 fee) internal pure {
93         if (fee > PPM_RESOLUTION) {
94             revert InvalidFee();
95         }
96     }
97 }
