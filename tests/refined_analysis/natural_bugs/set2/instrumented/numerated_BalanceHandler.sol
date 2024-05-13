1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity =0.7.6;
3 pragma abicoder v2;
4 
5 import "../global/Types.sol";
6 import "../global/Constants.sol";
7 import "../global/LibStorage.sol";
8 import "../math/SafeInt256.sol";
9 import "../math/FloatingPoint56.sol";
10 
11 library BalanceHandler {
12     using SafeInt256 for int256;
13 
14     /// @notice Emitted when reserve balance is updated
15     event ReserveBalanceUpdated(uint16 indexed currencyId, int256 newBalance);
16     /// @notice Emitted when reserve balance is harvested
17     event ExcessReserveBalanceHarvested(uint16 indexed currencyId, int256 harvestAmount);
18 
19     /// @notice harvests excess reserve balance
20     function harvestExcessReserveBalance(uint16 currencyId, int256 reserve, int256 assetInternalRedeemAmount) internal {
21         // parameters are validated by the caller
22         reserve = reserve.subNoNeg(assetInternalRedeemAmount);
23         _setBalanceStorage(Constants.RESERVE, currencyId, reserve, 0, 0, 0);
24         emit ExcessReserveBalanceHarvested(currencyId, assetInternalRedeemAmount);
25     }
26 
27     /// @notice sets the reserve balance, see TreasuryAction.setReserveCashBalance
28     function setReserveCashBalance(uint16 currencyId, int256 newBalance) internal {
29         require(newBalance >= 0); // dev: invalid balance
30         _setBalanceStorage(Constants.RESERVE, currencyId, newBalance, 0, 0, 0);
31         emit ReserveBalanceUpdated(currencyId, newBalance);
32     }
33 
34     /// @notice Sets internal balance storage.
35     function _setBalanceStorage(
36         address account,
37         uint256 currencyId,
38         int256 cashBalance,
39         int256 nTokenBalance,
40         uint256 lastClaimTime,
41         uint256 lastClaimIntegralSupply
42     ) private {
43         mapping(address => mapping(uint256 => BalanceStorage)) storage store = LibStorage.getBalanceStorage();
44         BalanceStorage storage balanceStorage = store[account][currencyId];
45 
46         require(cashBalance >= type(int88).min && cashBalance <= type(int88).max); // dev: stored cash balance overflow
47         // Allows for 12 quadrillion nToken balance in 1e8 decimals before overflow
48         require(nTokenBalance >= 0 && nTokenBalance <= type(uint80).max); // dev: stored nToken balance overflow
49         require(lastClaimTime <= type(uint32).max); // dev: last claim time overflow
50 
51         balanceStorage.nTokenBalance = uint80(nTokenBalance);
52         balanceStorage.lastClaimTime = uint32(lastClaimTime);
53         balanceStorage.cashBalance = int88(cashBalance);
54 
55         // Last claim supply is stored in a "floating point" storage slot that does not maintain exact precision but
56         // is also not limited by storage overflows. `packTo56Bits` will ensure that the the returned value will fit
57         // in 56 bits (7 bytes)
58         balanceStorage.packedLastClaimIntegralSupply = FloatingPoint56.packTo56Bits(lastClaimIntegralSupply);
59     }
60 
61     /// @notice Gets internal balance storage, nTokens are stored alongside cash balances
62     function getBalanceStorage(address account, uint256 currencyId)
63         internal
64         view
65         returns (
66             int256 cashBalance,
67             int256 nTokenBalance,
68             uint256 lastClaimTime,
69             uint256 lastClaimIntegralSupply
70         )
71     {
72         mapping(address => mapping(uint256 => BalanceStorage)) storage store = LibStorage.getBalanceStorage();
73         BalanceStorage storage balanceStorage = store[account][currencyId];
74 
75         nTokenBalance = balanceStorage.nTokenBalance;
76         lastClaimTime = balanceStorage.lastClaimTime;
77         lastClaimIntegralSupply = FloatingPoint56.unpackFrom56Bits(balanceStorage.packedLastClaimIntegralSupply);
78         cashBalance = balanceStorage.cashBalance;
79     }
80 
81 }
