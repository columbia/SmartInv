1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity =0.7.6;
3 
4 /// @title All shared constants for the Notional system should be declared here.
5 library Constants {
6     // Return code for cTokens that represents no error
7     uint256 internal constant COMPOUND_RETURN_CODE_NO_ERROR = 0;
8     // Token precision used for all internal balances, TokenHandler library ensures that we
9     // limit the dust amount caused by precision mismatches
10     int256 internal constant INTERNAL_TOKEN_PRECISION = 1e8;
11 
12     // Address of the reserve account
13     address internal constant RESERVE = address(0);
14 
15     // Most significant bit
16     bytes32 internal constant MSB =
17         0x8000000000000000000000000000000000000000000000000000000000000000;
18 
19 }
