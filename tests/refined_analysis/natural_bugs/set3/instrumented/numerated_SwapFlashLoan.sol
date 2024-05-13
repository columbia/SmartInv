1 // SPDX-License-Identifier: MIT WITH AGPL-3.0-only
2 
3 pragma solidity 0.6.12;
4 
5 import "./Swap.sol";
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
25 contract SwapFlashLoan is Swap {
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
59      * @param lpTokenTargetAddress the address of an existing LPToken contract to use as a target
60      */
61     function initialize(
62         IERC20[] memory _pooledTokens,
63         uint8[] memory decimals,
64         string memory lpTokenName,
65         string memory lpTokenSymbol,
66         uint256 _a,
67         uint256 _fee,
68         uint256 _adminFee,
69         address lpTokenTargetAddress
70     ) public payable virtual override initializer {
71         Swap.initialize(
72             _pooledTokens,
73             decimals,
74             lpTokenName,
75             lpTokenSymbol,
76             _a,
77             _fee,
78             _adminFee,
79             lpTokenTargetAddress
80         );
81         flashLoanFeeBPS = 8; // 8 bps
82         protocolFeeShareBPS = 0; // 0 bps
83     }
84 
85     /*** STATE MODIFYING FUNCTIONS ***/
86 
87     /**
88      * @notice Borrow the specified token from this pool for this transaction only. This function will call
89      * `IFlashLoanReceiver(receiver).executeOperation` and the `receiver` must return the full amount of the token
90      * and the associated fee by the end of the callback transaction. If the conditions are not met, this call
91      * is reverted.
92      * @param receiver the address of the receiver of the token. This address must implement the IFlashLoanReceiver
93      * interface and the callback function `executeOperation`.
94      * @param token the protocol fee in bps to be applied on the total flash loan fee
95      * @param amount the total amount to borrow in this transaction
96      * @param params optional data to pass along to the callback function
97      */
98     function flashLoan(
99         address receiver,
100         IERC20 token,
101         uint256 amount,
102         bytes memory params
103     ) external payable nonReentrant {
104         uint8 tokenIndex = getTokenIndex(address(token));
105         uint256 availableLiquidityBefore = token.balanceOf(address(this));
106         uint256 protocolBalanceBefore = availableLiquidityBefore.sub(
107             swapStorage.balances[tokenIndex]
108         );
109         require(
110             amount > 0 && availableLiquidityBefore >= amount,
111             "invalid amount"
112         );
113 
114         // Calculate the additional amount of tokens the pool should end up with
115         uint256 amountFee = amount.mul(flashLoanFeeBPS).div(10000);
116         // Calculate the portion of the fee that will go to the protocol
117         uint256 protocolFee = amountFee.mul(protocolFeeShareBPS).div(10000);
118         require(amountFee > 0, "amount is small for a flashLoan");
119 
120         // Transfer the requested amount of tokens
121         token.safeTransfer(receiver, amount);
122 
123         // Execute callback function on receiver
124         IFlashLoanReceiver(receiver).executeOperation(
125             address(this),
126             address(token),
127             amount,
128             amountFee,
129             params
130         );
131 
132         uint256 availableLiquidityAfter = token.balanceOf(address(this));
133         require(
134             availableLiquidityAfter >= availableLiquidityBefore.add(amountFee),
135             "flashLoan fee is not met"
136         );
137 
138         swapStorage.balances[tokenIndex] = availableLiquidityAfter
139             .sub(protocolBalanceBefore)
140             .sub(protocolFee);
141         emit FlashLoan(receiver, tokenIndex, amount, amountFee, protocolFee);
142     }
143 
144     /*** ADMIN FUNCTIONS ***/
145 
146     /**
147      * @notice Updates the flash loan fee parameters. This function can only be called by the owner.
148      * @param newFlashLoanFeeBPS the total fee in bps to be applied on future flash loans
149      * @param newProtocolFeeShareBPS the protocol fee in bps to be applied on the total flash loan fee
150      */
151     function setFlashLoanFees(
152         uint256 newFlashLoanFeeBPS,
153         uint256 newProtocolFeeShareBPS
154     ) external payable onlyOwner {
155         require(
156             newFlashLoanFeeBPS > 0 &&
157                 newFlashLoanFeeBPS <= MAX_BPS &&
158                 newProtocolFeeShareBPS <= MAX_BPS,
159             "fees are not in valid range"
160         );
161         flashLoanFeeBPS = newFlashLoanFeeBPS;
162         protocolFeeShareBPS = newProtocolFeeShareBPS;
163     }
164 }
