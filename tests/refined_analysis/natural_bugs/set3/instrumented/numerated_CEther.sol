1 pragma solidity ^0.5.16;
2 
3 import "./CTokenDeprecated.sol";
4 
5 /**
6  * @title Compound's CEther Contract
7  * @notice CToken which wraps Ether
8  * @author Compound
9  */
10 contract CEther is CTokenDeprecated {
11     /**
12      * @notice Construct a new CEther money market
13      * @param comptroller_ The address of the Comptroller
14      * @param interestRateModel_ The address of the interest rate model
15      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
16      * @param name_ ERC-20 name of this token
17      * @param symbol_ ERC-20 symbol of this token
18      * @param decimals_ ERC-20 decimal precision of this token
19      * @param admin_ Address of the administrator of this token
20      */
21     constructor(
22         ComptrollerInterface comptroller_,
23         InterestRateModel interestRateModel_,
24         uint256 initialExchangeRateMantissa_,
25         string memory name_,
26         string memory symbol_,
27         uint8 decimals_,
28         address payable admin_
29     ) public {
30         // Creator of the contract is admin during initialization
31         admin = msg.sender;
32 
33         initialize(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_);
34 
35         // Set the proper admin now that initialization is done
36         admin = admin_;
37     }
38 
39     /*** User Interface ***/
40 
41     /**
42      * @notice Sender supplies assets into the market and receives cTokens in exchange
43      * @dev Reverts upon any failure
44      */
45     function mint() external payable {
46         (uint256 err, ) = mintInternal(msg.value);
47         requireNoError(err, "mint failed");
48     }
49 
50     /**
51      * @notice Sender redeems cTokens in exchange for the underlying asset
52      * @dev Accrues interest whether or not the operation succeeds, unless reverted
53      * @param redeemTokens The number of cTokens to redeem into underlying
54      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
55      */
56     function redeem(uint256 redeemTokens) external returns (uint256) {
57         return redeemInternal(redeemTokens);
58     }
59 
60     /**
61      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
62      * @dev Accrues interest whether or not the operation succeeds, unless reverted
63      * @param redeemAmount The amount of underlying to redeem
64      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
65      */
66     function redeemUnderlying(uint256 redeemAmount) external returns (uint256) {
67         return redeemUnderlyingInternal(redeemAmount);
68     }
69 
70     /**
71      * @notice Sender borrows assets from the protocol to their own address
72      * @param borrowAmount The amount of the underlying asset to borrow
73      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
74      */
75     function borrow(uint256 borrowAmount) external returns (uint256) {
76         return borrowInternal(borrowAmount);
77     }
78 
79     /**
80      * @notice Sender repays their own borrow
81      * @dev Reverts upon any failure
82      */
83     function repayBorrow() external payable {
84         (uint256 err, ) = repayBorrowInternal(msg.value);
85         requireNoError(err, "repayBorrow failed");
86     }
87 
88     /**
89      * @notice Sender repays a borrow belonging to borrower
90      * @dev Reverts upon any failure
91      * @param borrower the account with the debt being payed off
92      */
93     function repayBorrowBehalf(address borrower) external payable {
94         (uint256 err, ) = repayBorrowBehalfInternal(borrower, msg.value);
95         requireNoError(err, "repayBorrowBehalf failed");
96     }
97 
98     /**
99      * @notice The sender liquidates the borrowers collateral.
100      *  The collateral seized is transferred to the liquidator.
101      * @dev Reverts upon any failure
102      * @param borrower The borrower of this cToken to be liquidated
103      * @param cTokenCollateral The market in which to seize collateral from the borrower
104      */
105     function liquidateBorrow(address borrower, CTokenDeprecated cTokenCollateral) external payable {
106         (uint256 err, ) = liquidateBorrowInternal(borrower, msg.value, cTokenCollateral);
107         requireNoError(err, "liquidateBorrow failed");
108     }
109 
110     /**
111      * @notice Send Ether to CEther to mint
112      */
113     function() external payable {
114         (uint256 err, ) = mintInternal(msg.value);
115         requireNoError(err, "mint failed");
116     }
117 
118     /*** Safe Token ***/
119 
120     /**
121      * @notice Gets balance of this contract in terms of Ether, before this message
122      * @dev This excludes the value of the current message, if any
123      * @return The quantity of Ether owned by this contract
124      */
125     function getCashPrior() internal view returns (uint256) {
126         (MathError err, uint256 startingBalance) = subUInt(address(this).balance, msg.value);
127         require(err == MathError.NO_ERROR);
128         return startingBalance;
129     }
130 
131     /**
132      * @notice Perform the actual transfer in, which is a no-op
133      * @param from Address sending the Ether
134      * @param amount Amount of Ether being sent
135      * @return The actual amount of Ether transferred
136      */
137     function doTransferIn(address from, uint256 amount) internal returns (uint256) {
138         // Sanity checks
139         require(msg.sender == from, "sender mismatch");
140         require(msg.value == amount, "value mismatch");
141         return amount;
142     }
143 
144     function doTransferOut(address payable to, uint256 amount) internal {
145         /* Send the Ether, with minimal gas and revert on failure */
146         to.transfer(amount);
147     }
148 
149     function requireNoError(uint256 errCode, string memory message) internal pure {
150         if (errCode == uint256(Error.NO_ERROR)) {
151             return;
152         }
153 
154         bytes memory fullMessage = new bytes(bytes(message).length + 5);
155         uint256 i;
156 
157         for (i = 0; i < bytes(message).length; i++) {
158             fullMessage[i] = bytes(message)[i];
159         }
160 
161         fullMessage[i + 0] = bytes1(uint8(32));
162         fullMessage[i + 1] = bytes1(uint8(40));
163         fullMessage[i + 2] = bytes1(uint8(48 + (errCode / 10)));
164         fullMessage[i + 3] = bytes1(uint8(48 + (errCode % 10)));
165         fullMessage[i + 4] = bytes1(uint8(41));
166 
167         require(errCode == uint256(Error.NO_ERROR), string(fullMessage));
168     }
169 }
