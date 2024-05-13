1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
7 import "@openzeppelin/contracts/utils/math/SafeCast.sol";
8 
9 import "../libraries/Errors.sol";
10 import "./access/Authorization.sol";
11 import "../interfaces/ISwapperRegistry.sol";
12 
13 contract SwapperRegistry is ISwapperRegistry, Authorization {
14     mapping(address => address[]) private _swappableTokens;
15     mapping(address => mapping(address => address)) private _swapperImplementations;
16 
17     event NewSwapper(address fromToken, address toToken, address newSwapper);
18     event SwapperRemoved(address fromToken, address toToken, address oldSwapper);
19     event NewSwappablePair(address fromToken, address toToken);
20 
21     constructor(IRoleManager roleManager) Authorization(roleManager) {}
22 
23     /**
24      * @notice Add new swapper implementation for a given token pair.
25      * @param fromToken Address of token to swap.
26      * @param toToken Address of token to receive.
27      * @param newSwapper Address of new swapper implementation for the token pair.
28      * @return True if the swapper was successfully set for the token pair.
29      */
30     function registerSwapper(
31         address fromToken,
32         address toToken,
33         address newSwapper
34     ) external onlyGovernance returns (bool) {
35         require(
36             fromToken != toToken &&
37                 fromToken != address(0) &&
38                 toToken != address(0) &&
39                 newSwapper != address(0),
40             Error.INVALID_TOKEN_PAIR
41         );
42         address swapper = _swapperImplementations[fromToken][toToken];
43         if (swapper != address(0)) {
44             if (swapper == newSwapper) return false;
45             emit SwapperRemoved(fromToken, toToken, swapper);
46         } else {
47             _swappableTokens[fromToken].push(toToken);
48             emit NewSwappablePair(fromToken, toToken);
49         }
50         _swapperImplementations[fromToken][toToken] = newSwapper;
51         emit NewSwapper(fromToken, toToken, newSwapper);
52         return true;
53     }
54 
55     /**
56      * @notice Get swapper implementation for a given token pair.
57      * @param fromToken Address of token to swap.
58      * @param toToken Address of token to receive.
59      * @return Address of swapper for token pair. Returns zero address if no swapper implementation exists.
60      */
61     function getSwapper(address fromToken, address toToken)
62         external
63         view
64         override
65         returns (address)
66     {
67         return _swapperImplementations[fromToken][toToken];
68     }
69 
70     /**
71      * @notice Check if a swapper implementation exists for a given token pair.
72      * @param fromToken Address of token to swap.
73      * @param toToken Address of token to receive.
74      * @return True if a swapper exists for the token pair.
75      */
76     function swapperExists(address fromToken, address toToken)
77         external
78         view
79         override
80         returns (bool)
81     {
82         return _swapperImplementations[fromToken][toToken] != address(0) ? true : false;
83     }
84 
85     function getAllSwappableTokens(address token)
86         external
87         view
88         override
89         returns (address[] memory)
90     {
91         return _swappableTokens[token];
92     }
93 }
