1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity =0.7.6;
3 pragma abicoder v2;
4 
5 import "../math/SafeInt256.sol";
6 import "../global/LibStorage.sol";
7 import "../global/Types.sol";
8 import "../global/Constants.sol";
9 import "interfaces/compound/CErc20Interface.sol";
10 import "interfaces/compound/CEtherInterface.sol";
11 import "@openzeppelin-0.7/contracts/math/SafeMath.sol";
12 import "@openzeppelin-0.7/contracts/token/ERC20/ERC20.sol";
13 
14 /// @notice Handles all external token transfers and events
15 library TokenHandler {
16     using SafeInt256 for int256;
17     using SafeMath for uint256;
18 
19     function getAssetToken(uint256 currencyId) internal view returns (Token memory) {
20         return _getToken(currencyId, false);
21     }
22 
23     function getUnderlyingToken(uint256 currencyId) internal view returns (Token memory) {
24         return _getToken(currencyId, true);
25     }
26 
27     /// @notice Gets token data for a particular currency id, if underlying is set to true then returns
28     /// the underlying token. (These may not always exist)
29     function _getToken(uint256 currencyId, bool underlying) private view returns (Token memory) {
30         mapping(uint256 => mapping(bool => TokenStorage)) storage store = LibStorage.getTokenStorage();
31         TokenStorage storage tokenStorage = store[currencyId][underlying];
32 
33         return
34             Token({
35                 tokenAddress: tokenStorage.tokenAddress,
36                 hasTransferFee: tokenStorage.hasTransferFee,
37                 // No overflow, restricted on storage
38                 decimals: int256(10**tokenStorage.decimalPlaces),
39                 tokenType: tokenStorage.tokenType,
40                 maxCollateralBalance: tokenStorage.maxCollateralBalance
41             });
42     }
43 
44     function redeem(
45         Token memory assetToken,
46         Token memory underlyingToken,
47         uint256 assetAmountExternal
48     ) internal returns (int256) {
49         uint256 startingBalance;
50         if (assetToken.tokenType == TokenType.cETH) {
51             startingBalance = address(this).balance;
52         } else if (assetToken.tokenType == TokenType.cToken) {
53             startingBalance = IERC20(underlyingToken.tokenAddress).balanceOf(address(this));
54         } else {
55             revert(); // dev: non redeemable failure
56         }
57 
58         uint256 success = CErc20Interface(assetToken.tokenAddress).redeem(assetAmountExternal);
59         require(success == Constants.COMPOUND_RETURN_CODE_NO_ERROR, "Redeem");
60 
61         uint256 endingBalance;
62         if (assetToken.tokenType == TokenType.cETH) {
63             endingBalance = address(this).balance;
64         } else {
65             endingBalance = IERC20(underlyingToken.tokenAddress).balanceOf(address(this));
66         }
67 
68         // Underlying token external precision
69         return SafeInt256.toInt(endingBalance.sub(startingBalance));
70     }
71 
72     function convertToInternal(Token memory token, int256 amount) internal pure returns (int256) {
73         // If token decimals > INTERNAL_TOKEN_PRECISION:
74         //  on deposit: resulting dust will accumulate to protocol
75         //  on withdraw: protocol may lose dust amount. However, withdraws are only calculated based
76         //    on a conversion from internal token precision to external token precision so therefore dust
77         //    amounts cannot be specified for withdraws.
78         // If token decimals < INTERNAL_TOKEN_PRECISION then this will add zeros to the
79         // end of amount and will not result in dust.
80         if (token.decimals == Constants.INTERNAL_TOKEN_PRECISION) return amount;
81         return amount.mul(Constants.INTERNAL_TOKEN_PRECISION).div(token.decimals);
82     }
83 
84     function convertToExternal(Token memory token, int256 amount) internal pure returns (int256) {
85         if (token.decimals == Constants.INTERNAL_TOKEN_PRECISION) return amount;
86         // If token decimals > INTERNAL_TOKEN_PRECISION then this will increase amount
87         // by adding a number of zeros to the end and will not result in dust.
88         // If token decimals < INTERNAL_TOKEN_PRECISION:
89         //  on deposit: Deposits are specified in external token precision and there is no loss of precision when
90         //      tokens are converted from external to internal precision
91         //  on withdraw: this calculation will round down such that the protocol retains the residual cash balance
92         return amount.mul(token.decimals).div(Constants.INTERNAL_TOKEN_PRECISION);
93     }
94 
95 }
