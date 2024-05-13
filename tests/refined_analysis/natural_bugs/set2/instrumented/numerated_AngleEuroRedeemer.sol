1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {IAngleStableMaster, IAnglePoolManager} from "./IAngleStableMaster.sol";
5 import {Decimal} from "../../external/Decimal.sol";
6 import {IOracle} from "../../oracle/IOracle.sol";
7 import {CoreRef} from "../../refs/CoreRef.sol";
8 import {TribeRoles} from "../../core/TribeRoles.sol";
9 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
10 
11 interface IMakerPSM {
12     function sellGem(address, uint256) external;
13 }
14 
15 /// @title Contract to redeem agEUR for FEI and DAI
16 /// @author eswak
17 contract AngleEuroRedeemer is CoreRef {
18     using Decimal for Decimal.D256;
19 
20     constructor(address _core) CoreRef(_core) {}
21 
22     // Angle Protocol addresses
23     IAngleStableMaster public constant ANGLE_STABLEMASTER =
24         IAngleStableMaster(0x5adDc89785D75C86aB939E9e15bfBBb7Fc086A87);
25     IAnglePoolManager public constant ANGLE_POOLMANAGER_USDC =
26         IAnglePoolManager(0xe9f183FC656656f1F17af1F2b0dF79b8fF9ad8eD);
27 
28     // Maker addresses
29     address public constant MAKER_DAI_USDC_PSM_AUTH = 0x0A59649758aa4d66E25f08Dd01271e891fe52199;
30     address public constant MAKER_DAI_USDC_PSM = 0x89B78CfA322F6C5dE0aBcEecab66Aee45393cC5A;
31 
32     // Token addresses
33     IERC20 public constant AGEUR = IERC20(0x1a7e4e63778B4f12a199C062f3eFdD288afCBce8);
34     IERC20 public constant USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
35     IERC20 public constant DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
36 
37     // Tribe DAO addresses
38     IOracle public constant TRIBEDAO_EUR_USD_ORACLE = IOracle(0xFb3a062236A7E08b572F17bc9Ad2bBc2becB87b1);
39     address public constant TRIBEDAO_FEI_DAI_PSM = 0x2A188F9EB761F70ECEa083bA6c2A40145078dfc2;
40     address public constant TRIBEDAO_TC_TIMELOCK = 0xe0C7DE94395B629860Cbb3c42995F300F56e6d7a;
41 
42     /// @notice redeem all agEUR held on this contract to USDC using Angle Protocol,
43     /// and then use the Maker PSM to convert the USDC to DAI, and send the DAI to
44     /// Tribe DAO's FEI/DAI PSM.
45     function redeemAgEurToDai()
46         external
47         hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.GUARDIAN, TribeRoles.PCV_SAFE_MOVER_ROLE)
48     {
49         // Get the amount of agEUR to redeem
50         uint256 agEurBalance = AGEUR.balanceOf(address(this));
51 
52         // agEUR -> USDC
53         // Read amount of agEUR to redeem & current oracle price
54         (Decimal.D256 memory oracleValue, bool oracleValid) = TRIBEDAO_EUR_USD_ORACLE.read();
55         require(oracleValid, "ORACLE_INVALID");
56         uint256 usdPerEur = oracleValue.mul(1e18).asUint256(); // ~1.05e18
57 
58         // redeem USDC available
59         uint256 usdcAvailableForRedeem = ANGLE_POOLMANAGER_USDC.getBalance();
60         // scale decimals 6 -> 18
61         uint256 agEurSpentToRedeemUsdc = (usdcAvailableForRedeem * 1e12 * 1e18) / (usdPerEur);
62         if (agEurSpentToRedeemUsdc > agEurBalance) {
63             agEurSpentToRedeemUsdc = agEurBalance;
64         }
65         // no need to check stableMaster.collateralMap[PoolManager].stocksUsers because
66         // USDC has a lot of stock available (~57M)
67 
68         // max 1% slippage (angle redeem has 0.5% fee, oracle has 0.15% precision)
69         // scale decimals 18 -> 6
70         uint256 minUsdcOut = (agEurSpentToRedeemUsdc * usdPerEur * 99) / (100 * 1e18 * 1e12);
71 
72         // burn agEUR for USDC
73         ANGLE_STABLEMASTER.burn(
74             agEurSpentToRedeemUsdc,
75             address(this),
76             address(this),
77             ANGLE_POOLMANAGER_USDC,
78             minUsdcOut
79         );
80 
81         // USDC -> DAI
82         // read dai balance before redeeming
83         uint256 daiBalanceBefore = DAI.balanceOf(address(this));
84 
85         // Use Maker PSM to convert USDC to DAI
86         uint256 usdcBalance = USDC.balanceOf(address(this));
87         USDC.approve(MAKER_DAI_USDC_PSM_AUTH, usdcBalance);
88         IMakerPSM(MAKER_DAI_USDC_PSM).sellGem(address(this), usdcBalance);
89 
90         // sanity check
91         // Maker PSM has no fee for USDC->DAI
92         uint256 daiBalanceAfter = DAI.balanceOf(address(this));
93         uint256 redeemedDai = daiBalanceAfter - daiBalanceBefore;
94         require(usdcBalance / 1e6 == redeemedDai / 1e18, "PSM_SLIPPAGE");
95 
96         // send DAI to DAI/FEI PSM
97         DAI.transfer(TRIBEDAO_FEI_DAI_PSM, daiBalanceAfter);
98     }
99 
100     /// @notice send all tokens held to the Tribal Council timelock
101     /// this contract should never hold agEUR as it will atomically be funded & redeemed,
102     /// nor should it hold any DAI/FEI/USDC because the redeemed funds are atomically
103     /// sent away, but this function is included for funds recovery in case something goes wrong.
104     function withdrawERC20(address token)
105         external
106         hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.GUARDIAN, TribeRoles.PCV_SAFE_MOVER_ROLE)
107     {
108         uint256 balance = IERC20(token).balanceOf(address(this));
109         IERC20(token).transfer(TRIBEDAO_TC_TIMELOCK, balance);
110     }
111 }
