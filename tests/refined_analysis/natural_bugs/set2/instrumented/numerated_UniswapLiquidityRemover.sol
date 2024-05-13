1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 import {Address} from "@openzeppelin/contracts/utils/Address.sol";
7 import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
8 import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
9 import {TribeRoles} from "../core/TribeRoles.sol";
10 import {CoreRef} from "../refs/CoreRef.sol";
11 import {Constants} from "../Constants.sol";
12 
13 /// @title Uniswap pool liquidity remover
14 /// @notice Redeems Uniswap FEI-TRIBE LP tokens held on this contract for the underlying FEI and TRIBE.
15 ///         Then burns the remaining redeemed FEI and transfers the redeemed TRIBE to Core treasury
16 ///         Expected that this contract holds all LP tokens prior to redemption
17 contract UniswapLiquidityRemover is CoreRef {
18     using SafeERC20 for IERC20;
19 
20     event RemoveLiquidity(uint256 amountFei, uint256 amountTribe);
21     event WithdrawERC20(address indexed _caller, address indexed _token, address indexed _to, uint256 _amount);
22 
23     /// @notice Uniswap V2 version 2 Router
24     IUniswapV2Router02 public constant UNISWAP_ROUTER = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
25 
26     /// @notice Uniswap Fei-Tribe LP token
27     IUniswapV2Pair public constant FEI_TRIBE_PAIR = IUniswapV2Pair(0x9928e4046d7c6513326cCeA028cD3e7a91c7590A);
28 
29     /// @param _core FEI protocol Core address
30     constructor(address _core) CoreRef(_core) {}
31 
32     ///////////   Public state changing API   ///////////////
33 
34     /// @notice Redeem LP tokens held on this contract for underlying FEI and TRIBE.
35     ///         Burn all the FEI redeemed and send all TRIBE to Core
36     /// @param minAmountFeiOut Minimum amount of FEI to be redeemed
37     /// @param minAmountTribeOut Minimum amount of TRIBE to be redeemed
38     /// @return feiLiquidity Redeemed FEI liquidity that is burned
39     /// @return tribeLiquidity Redeemed TRIBE liquidity that is sent to Core
40     function redeemLiquidity(uint256 minAmountFeiOut, uint256 minAmountTribeOut)
41         external
42         onlyTribeRole(TribeRoles.GOVERNOR)
43         returns (uint256, uint256)
44     {
45         uint256 amountLP = FEI_TRIBE_PAIR.balanceOf(address(this));
46         require(amountLP > 0, "LiquidityRemover: Insufficient liquidity");
47 
48         // Approve Uniswap router to swap tokens
49         FEI_TRIBE_PAIR.approve(address(UNISWAP_ROUTER), amountLP);
50 
51         // Remove liquidity from Uniswap and send underlying to this contract
52         UNISWAP_ROUTER.removeLiquidity(
53             address(fei()),
54             address(tribe()),
55             amountLP,
56             minAmountFeiOut,
57             minAmountTribeOut,
58             address(this),
59             block.timestamp
60         );
61 
62         uint256 feiLiquidity = fei().balanceOf(address(this));
63         uint256 tribeLiquidity = tribe().balanceOf(address(this));
64 
65         // Burn all FEI
66         fei().burn(feiLiquidity);
67 
68         // Send all remaining TRIBE to Core
69         tribe().safeTransfer(address(core()), tribeLiquidity);
70 
71         emit RemoveLiquidity(feiLiquidity, tribeLiquidity);
72         return (feiLiquidity, tribeLiquidity);
73     }
74 
75     /// @notice Emergency withdraw function to withdraw funds from the contract
76     /// @param token ERC20 token being withdrawn
77     /// @param to Address to send tokens to
78     /// @param amount Amount of tokens to be withdrawn
79     function withdrawERC20(
80         address token,
81         address to,
82         uint256 amount
83     ) external onlyTribeRole(TribeRoles.PCV_CONTROLLER) {
84         IERC20(token).safeTransfer(to, amount);
85         emit WithdrawERC20(msg.sender, token, to, amount);
86     }
87 }
