1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity =0.7.6;
3 pragma abicoder v2;
4 
5 /// @notice Different types of internal tokens
6 ///  - UnderlyingToken: underlying asset for a cToken (except for Ether)
7 ///  - cToken: Compound interest bearing token
8 ///  - cETH: Special handling for cETH tokens
9 ///  - Ether: the one and only
10 ///  - NonMintable: tokens that do not have an underlying (therefore not cTokens)
11 enum TokenType {UnderlyingToken, cToken, cETH, Ether, NonMintable}
12 
13 /// @notice Internal object that represents a token
14 struct Token {
15     address tokenAddress;
16     bool hasTransferFee;
17     int256 decimals;
18     TokenType tokenType;
19     uint256 maxCollateralBalance;
20 }
21 
22 /// @dev Token object in storage:
23 ///  20 bytes for token address
24 ///  1 byte for hasTransferFee
25 ///  1 byte for tokenType
26 ///  1 byte for tokenDecimals
27 ///  9 bytes for maxCollateralBalance (may not always be set)
28 struct TokenStorage {
29     // Address of the token
30     address tokenAddress;
31     // Transfer fees will change token deposit behavior
32     bool hasTransferFee;
33     TokenType tokenType;
34     uint8 decimalPlaces;
35     // Upper limit on how much of this token the contract can hold at any time
36     uint72 maxCollateralBalance;
37 }
38 
39 /// @dev Holds account balance information, total storage 32 bytes
40 struct BalanceStorage {
41     // Number of nTokens held by the account
42     uint80 nTokenBalance;
43     // Last time the account claimed their nTokens
44     uint32 lastClaimTime;
45     // The total integral supply of the nToken at the last claim time packed into
46     // 56 bits. There is some loss of precision here but it is acceptable
47     uint56 packedLastClaimIntegralSupply;
48     // Cash balance of the account
49     int88 cashBalance;
50 }
