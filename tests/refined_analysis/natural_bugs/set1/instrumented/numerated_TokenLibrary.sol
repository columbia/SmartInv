1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
6 import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
7 import { IERC20Permit } from "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
8 
9 import { SafeERC20Ex } from "./SafeERC20Ex.sol";
10 
11 import { Token } from "./Token.sol";
12 
13 /**
14  * @dev This library implements ERC20 and SafeERC20 utilities for both the native token and for ERC20 tokens
15  */
16 library TokenLibrary {
17     using SafeERC20 for IERC20;
18     using SafeERC20Ex for IERC20;
19 
20     error PermitUnsupported();
21 
22     // the address that represents the native token reserve
23     address private constant NATIVE_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
24 
25     // the symbol that represents the native token
26     string private constant NATIVE_TOKEN_SYMBOL = "ETH";
27 
28     // the decimals for the native token
29     uint8 private constant NATIVE_TOKEN_DECIMALS = 18;
30 
31     // the token representing the native token
32     Token public constant NATIVE_TOKEN = Token(NATIVE_TOKEN_ADDRESS);
33 
34     /**
35      * @dev returns whether the provided token represents an ERC20 or the native token reserve
36      */
37     function isNative(Token token) internal pure returns (bool) {
38         return address(token) == NATIVE_TOKEN_ADDRESS;
39     }
40 
41     /**
42      * @dev returns the symbol of the native token/ERC20 token
43      */
44     function symbol(Token token) internal view returns (string memory) {
45         if (isNative(token)) {
46             return NATIVE_TOKEN_SYMBOL;
47         }
48 
49         return toERC20(token).symbol();
50     }
51 
52     /**
53      * @dev returns the decimals of the native token/ERC20 token
54      */
55     function decimals(Token token) internal view returns (uint8) {
56         if (isNative(token)) {
57             return NATIVE_TOKEN_DECIMALS;
58         }
59 
60         return toERC20(token).decimals();
61     }
62 
63     /**
64      * @dev returns the balance of the native token/ERC20 token
65      */
66     function balanceOf(Token token, address account) internal view returns (uint256) {
67         if (isNative(token)) {
68             return account.balance;
69         }
70 
71         return toIERC20(token).balanceOf(account);
72     }
73 
74     /**
75      * @dev transfers a specific amount of the native token/ERC20 token
76      */
77     function safeTransfer(Token token, address to, uint256 amount) internal {
78         if (amount == 0) {
79             return;
80         }
81 
82         if (isNative(token)) {
83             payable(to).transfer(amount);
84         } else {
85             toIERC20(token).safeTransfer(to, amount);
86         }
87     }
88 
89     /**
90      * @dev transfers a specific amount of the native token/ERC20 token from a specific holder using the allowance mechanism
91      *
92      * note that the function does not perform any action if the native token is provided
93      */
94     function safeTransferFrom(Token token, address from, address to, uint256 amount) internal {
95         if (amount == 0 || isNative(token)) {
96             return;
97         }
98 
99         toIERC20(token).safeTransferFrom(from, to, amount);
100     }
101 
102     /**
103      * @dev approves a specific amount of the native token/ERC20 token from a specific holder
104      *
105      * note that the function does not perform any action if the native token is provided
106      */
107     function safeApprove(Token token, address spender, uint256 amount) internal {
108         if (isNative(token)) {
109             return;
110         }
111 
112         toIERC20(token).safeApprove(spender, amount);
113     }
114 
115     /**
116      * @dev ensures that the spender has sufficient allowance
117      *
118      * note that the function does not perform any action if the native token is provided
119      */
120     function ensureApprove(Token token, address spender, uint256 amount) internal {
121         if (isNative(token)) {
122             return;
123         }
124 
125         toIERC20(token).ensureApprove(spender, amount);
126     }
127 
128     /**
129      * @dev compares between a token and another raw ERC20 token
130      */
131     function isEqual(Token token, IERC20 erc20Token) internal pure returns (bool) {
132         return toIERC20(token) == erc20Token;
133     }
134 
135     /**
136      * @dev utility function that converts a token to an IERC20
137      */
138     function toIERC20(Token token) internal pure returns (IERC20) {
139         return IERC20(address(token));
140     }
141 
142     /**
143      * @dev utility function that converts a token to an ERC20
144      */
145     function toERC20(Token token) internal pure returns (ERC20) {
146         return ERC20(address(token));
147     }
148 }
