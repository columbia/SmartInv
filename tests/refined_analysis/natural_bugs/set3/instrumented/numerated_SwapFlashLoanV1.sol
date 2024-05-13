1 // SPDX-License-Identifier: MIT WITH AGPL-3.0-only
2 
3 pragma solidity 0.6.12;
4 
5 import "./SwapV1.sol";
6 import "./interfaces/IFlashLoanReceiver.sol";
7 
8 /**
9  * @title Swap - A StableSwap implementation in solidity.
10  * @notice This contract is responsible for custody of closely pegged assets (eg. group of stablecoins)
11  * and automatic market making system. Users become an LP (Liquidity Provider) by depositing their tokens
12  * in desired ratios for an exchange of the pool token that represents their share of the pool.
13  * Users can burn pool tokens and withdraw their share of token(s).
14  *
15  * Each time a swap between the pooled tokens happens, a set fee incurs which effectively gets
16  * distributed to the LPs.
17  *
18  * In case of emergencies, admin can pause additional deposits, swaps, or single-asset withdraws - which
19  * stops the ratio of the tokens in the pool from changing.
20  * Users can always withdraw their tokens via multi-asset withdraws.
21  *
22  * @dev Most of the logic is stored as a library `SwapUtils` for the sake of reducing contract's
23  * deployment size.
24  */
25 contract SwapFlashLoanV1 is SwapV1 {
26     // Total fee that is charged on all flashloans in BPS. Borrowers must repay the amount plus the flash loan fee.
27     // This fee is split between the protocol and the pool.
28     uint256 public flashLoanFeeBPS;
29     // Share of the flash loan fee that goes to the protocol in BPS. A portion of each flash loan fee is allocated
30     // to the protocol rather than the pool.
31     uint256 public protocolFeeShareBPS;
32     // Max BPS for limiting flash loan fee settings.
33     uint256 public constant MAX_BPS = 10000;
34 
35     /*** EVENTS ***/
36     event FlashLoan(
37         address indexed receiver,
38         uint8 tokenIndex,
39         uint256 amount,
40         uint256 amountFee,
41         uint256 protocolFee
42     );
43 
44     /**
45      * @notice Initializes this Swap contract with the given parameters.
46      * This will also clone a LPToken contract that represents users'
47      * LP positions. The owner of LPToken will be this contract - which means
48      * only this contract is allowed to mint/burn tokens.
49      *
50      * @param _pooledTokens an array of ERC20s this pool will accept
51      * @param decimals the decimals to use for each pooled token,
52      * eg 8 for WBTC. Cannot be larger than POOL_PRECISION_DECIMALS
53      * @param lpTokenName the long-form name of the token to be deployed
54      * @param lpTokenSymbol the short symbol for the token to be deployed
55      * @param _a the amplification coefficient * n * (n - 1). See the
56      * StableSwap paper for details
57      * @param _fee default swap fee to be initialized with
58      * @param _adminFee default adminFee to be initialized with
59      * @param _withdrawFee default withdrawFee to be initialized with
60      * @param lpTokenTargetAddress the address of an existing LPToken contract to use as a target
61      */
62     function initialize(
63         IERC20[] memory _pooledTokens,
64         uint8[] memory decimals,
65         string memory lpTokenName,
66         string memory lpTokenSymbol,
67         uint256 _a,
68         uint256 _fee,
69         uint256 _adminFee,
70         uint256 _withdrawFee,
71         address lpTokenTargetAddress
72     ) public virtual override initializer {
73         SwapV1.initialize(
74             _pooledTokens,
75             decimals,
76             lpTokenName,
77             lpTokenSymbol,
78             _a,
79             _fee,
80             _adminFee,
81             _withdrawFee,
82             lpTokenTargetAddress
83         );
84         flashLoanFeeBPS = 8; // 8 bps
85         protocolFeeShareBPS = 0; // 0 bps
86     }
87 
88     /*** STATE MODIFYING FUNCTIONS ***/
89 
90     /**
91      * @notice Borrow the specified token from this pool for this transaction only. This function will call
92      * `IFlashLoanReceiver(receiver).executeOperation` and the `receiver` must return the full amount of the token
93      * and the associated fee by the end of the callback transaction. If the conditions are not met, this call
94      * is reverted.
95      * @param receiver the address of the receiver of the token. This address must implement the IFlashLoanReceiver
96      * interface and the callback function `executeOperation`.
97      * @param token the protocol fee in bps to be applied on the total flash loan fee
98      * @param amount the total amount to borrow in this transaction
99      * @param params optional data to pass along to the callback function
100      */
101     function flashLoan(
102         address receiver,
103         IERC20 token,
104         uint256 amount,
105         bytes memory params
106     ) external nonReentrant {
107         uint8 tokenIndex = getTokenIndex(address(token));
108         uint256 availableLiquidityBefore = token.balanceOf(address(this));
109         uint256 protocolBalanceBefore = availableLiquidityBefore.sub(
110             swapStorage.balances[tokenIndex]
111         );
112         require(
113             amount > 0 && availableLiquidityBefore >= amount,
114             "invalid amount"
115         );
116 
117         // Calculate the additional amount of tokens the pool should end up with
118         uint256 amountFee = amount.mul(flashLoanFeeBPS).div(10000);
119         // Calculate the portion of the fee that will go to the protocol
120         uint256 protocolFee = amountFee.mul(protocolFeeShareBPS).div(10000);
121         require(amountFee > 0, "amount is small for a flashLoan");
122 
123         // Transfer the requested amount of tokens
124         token.safeTransfer(receiver, amount);
125 
126         // Execute callback function on receiver
127         IFlashLoanReceiver(receiver).executeOperation(
128             address(this),
129             address(token),
130             amount,
131             amountFee,
132             params
133         );
134 
135         uint256 availableLiquidityAfter = token.balanceOf(address(this));
136         require(
137             availableLiquidityAfter >= availableLiquidityBefore.add(amountFee),
138             "flashLoan fee is not met"
139         );
140 
141         swapStorage.balances[tokenIndex] = availableLiquidityAfter
142             .sub(protocolBalanceBefore)
143             .sub(protocolFee);
144         emit FlashLoan(receiver, tokenIndex, amount, amountFee, protocolFee);
145     }
146 
147     /*** ADMIN FUNCTIONS ***/
148 
149     /**
150      * @notice Updates the flash loan fee parameters. This function can only be called by the owner.
151      * @param newFlashLoanFeeBPS the total fee in bps to be applied on future flash loans
152      * @param newProtocolFeeShareBPS the protocol fee in bps to be applied on the total flash loan fee
153      */
154     function setFlashLoanFees(
155         uint256 newFlashLoanFeeBPS,
156         uint256 newProtocolFeeShareBPS
157     ) external onlyOwner {
158         require(
159             newFlashLoanFeeBPS > 0 &&
160                 newFlashLoanFeeBPS <= MAX_BPS &&
161                 newProtocolFeeShareBPS <= MAX_BPS,
162             "fees are not in valid range"
163         );
164         flashLoanFeeBPS = newFlashLoanFeeBPS;
165         protocolFeeShareBPS = newProtocolFeeShareBPS;
166     }
167 }
