1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 
7 import "../../../../libraries/Errors.sol";
8 import "../../../../libraries/AccountEncoding.sol";
9 
10 import "../../../../interfaces/actions/topup/ITopUpHandler.sol";
11 import "../../../../interfaces/vendor/ILendingPool.sol";
12 import "../../../../interfaces/vendor/IWETH.sol";
13 import "../../../../libraries/vendor/DataTypes.sol";
14 
15 contract AaveHandler is ITopUpHandler {
16     using SafeERC20 for IERC20;
17     using AccountEncoding for bytes32;
18 
19     uint16 public constant BACKD_REFERRAL_CODE = 62314;
20 
21     ILendingPool public immutable lendingPool;
22     IWETH public immutable weth;
23 
24     constructor(address lendingPoolAddress, address wethAddress) {
25         lendingPool = ILendingPool(lendingPoolAddress);
26         weth = IWETH(wethAddress);
27     }
28 
29     /**
30      * @notice Executes the top-up of a position.
31      * @param account Account holding the position.
32      * @param underlying Underlying for tup-up.
33      * @param amount Amount to top-up by.
34      * @return `true` if successful.
35      */
36     function topUp(
37         bytes32 account,
38         address underlying,
39         uint256 amount,
40         bytes memory extra
41     ) external override returns (bool) {
42         bool repayDebt = abi.decode(extra, (bool));
43         if (underlying == address(0)) {
44             weth.deposit{value: amount}();
45             underlying = address(weth);
46         }
47 
48         address addr = account.addr();
49 
50         DataTypes.ReserveData memory reserve = lendingPool.getReserveData(underlying);
51         require(reserve.aTokenAddress != address(0), Error.UNDERLYING_NOT_SUPPORTED);
52 
53         IERC20(underlying).safeApprove(address(lendingPool), amount);
54 
55         if (repayDebt) {
56             uint256 stableDebt = IERC20(reserve.stableDebtTokenAddress).balanceOf(addr);
57             uint256 variableDebt = IERC20(reserve.variableDebtTokenAddress).balanceOf(addr);
58             if (variableDebt + stableDebt > 0) {
59                 uint256 rateMode = stableDebt > variableDebt ? 1 : 2;
60                 amount -= lendingPool.repay(underlying, amount, rateMode, addr);
61                 if (amount == 0) return true;
62             }
63         }
64 
65         lendingPool.deposit(underlying, amount, addr, BACKD_REFERRAL_CODE);
66         return true;
67     }
68 
69     function getUserFactor(bytes32 account, bytes memory) external view override returns (uint256) {
70         (, , , , , uint256 healthFactor) = lendingPool.getUserAccountData(account.addr());
71         return healthFactor;
72     }
73 }
