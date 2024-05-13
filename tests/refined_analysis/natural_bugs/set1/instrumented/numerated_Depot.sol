1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import "@openzeppelin/contracts/drafts/IERC20Permit.sol";
7 import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
8 import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
9 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
10 import "../beanstalk/farm/DepotFacet.sol";
11 import "../beanstalk/farm/TokenSupportFacet.sol";
12 import "../interfaces/IBeanstalkTransfer.sol";
13 import "../interfaces/IERC4494.sol";
14 import "../libraries/LibFunction.sol";
15 
16 /**
17  * @title Depot
18  * @author Publius
19  * @notice Depot wraps Pipeline's Pipe functions to facilitate the loading of non-Ether assets in Pipeline
20  * in the same transaction that loads Ether, Pipes calls to other protocols and unloads Pipeline.
21  * https://evmpipeline.org
22 **/
23 
24 contract Depot is DepotFacet, TokenSupportFacet {
25 
26     using SafeERC20 for IERC20;
27 
28     IBeanstalkTransfer private constant beanstalk =
29         IBeanstalkTransfer(0xC1E088fC1323b20BCBee9bd1B9fC9546db5624C5);
30 
31     /**
32      * @dev So Depot can receive Ether.
33      */
34     receive() external payable {}
35 
36     /**
37      * @dev Returns the current version of Depot.
38      */
39     function version() external pure returns (string memory) {
40         return "1.0.1";
41     }
42 
43     /**
44      * 
45      * Farm
46      * 
47     **/
48 
49     /**
50      * @notice Execute multiple function calls in Depot.
51      * @param data list of encoded function calls to be executed
52      * @return results list of return data from each function call
53      * @dev Implementation from https://github.com/Uniswap/v3-periphery/blob/main/contracts/base/Multicall.sol.
54     **/
55     function farm(bytes[] calldata data)
56         external
57         payable
58         returns (bytes[] memory results)
59     {
60         results = new bytes[](data.length);
61         for (uint256 i = 0; i < data.length; i++) {
62             (bool success, bytes memory result) = address(this).delegatecall(data[i]);
63             LibFunction.checkReturn(success, result);
64             results[i] = result;
65         }
66     }
67 
68     /**
69      *
70      * Transfer
71      *
72     **/
73 
74     /**
75      * @notice Execute a Beanstalk ERC-20 token transfer.
76      * @dev See {TokenFacet-transferToken}.
77      * @dev Only supports INTERNAL and EXTERNAL From modes.
78     **/
79     function transferToken(
80         IERC20 token,
81         address recipient,
82         uint256 amount,
83         From fromMode,
84         To toMode
85     ) external payable {
86         if (fromMode == From.EXTERNAL) {
87             token.safeTransferFrom(msg.sender, recipient, amount);
88         } else if (fromMode == From.INTERNAL) {
89             beanstalk.transferInternalTokenFrom(token, msg.sender, recipient, amount, toMode);
90         } else {
91             revert("Mode not supported");
92         }
93     }
94 
95     /**
96      * @notice Execute a single Beanstalk Deposit transfer.
97      * @dev See {SiloFacet-transferDeposit}.
98     **/
99     function transferDeposit(
100         address sender,
101         address recipient,
102         address token,
103         int96 stem,
104         uint256 amount
105     ) external payable returns (uint256 bdv) {
106         require(sender == msg.sender, "invalid sender");
107         bdv = beanstalk.transferDeposit(msg.sender, recipient, token, stem, amount);
108     }
109 
110     /**
111      * @notice Execute multiple Beanstalk Deposit transfers of a single Whitelisted Tokens.
112      * @dev See {SiloFacet-transferDeposits}.
113     **/
114     function transferDeposits(
115         address sender,
116         address recipient,
117         address token,
118         int96[] calldata stems,
119         uint256[] calldata amounts
120     ) external payable returns (uint256[] memory bdvs) {
121         require(sender == msg.sender, "invalid sender");
122         bdvs = beanstalk.transferDeposits(msg.sender, recipient, token, stems, amounts);
123     }
124 
125     /**
126      *
127      * Permits
128      *
129     **/
130 
131     /**
132      * @notice Execute a permit for an ERC-20 Token stored in a Beanstalk Farm balance.
133      * @dev See {TokenFacet-permitToken}.
134     **/
135     function permitToken(
136         address owner,
137         address spender,
138         address token,
139         uint256 value,
140         uint256 deadline,
141         uint8 v,
142         bytes32 r,
143         bytes32 s
144     ) external payable {
145         beanstalk.permitToken(owner, spender, token, value, deadline, v, r, s);
146     }
147 
148     /**
149      * @notice Execute a permit for Beanstalk Deposits of a single Whitelisted Token.
150      * @dev See {SiloFacet-permitDeposit}.
151     **/
152     function permitDeposit(
153         address owner,
154         address spender,
155         address token,
156         uint256 value,
157         uint256 deadline,
158         uint8 v,
159         bytes32 r,
160         bytes32 s
161     ) external payable {
162         beanstalk.permitDeposit(owner, spender, token, value, deadline, v, r, s);
163     }
164 
165     /**
166      * @notice Execute a permit for a Beanstalk Deposits of a multiple Whitelisted Tokens.
167      * @dev See {SiloFacet-permitDeposits}.
168     **/
169     function permitDeposits(
170         address owner,
171         address spender,
172         address[] calldata tokens,
173         uint256[] calldata values,
174         uint256 deadline,
175         uint8 v,
176         bytes32 r,
177         bytes32 s
178     ) external payable {
179         beanstalk.permitDeposits(owner, spender, tokens, values, deadline, v, r, s);
180     }
181 }
