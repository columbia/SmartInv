1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.10;
3 
4 import "../IPCVDepositBalances.sol";
5 import "../../refs/UniRef.sol";
6 import "@uniswap/lib/contracts/libraries/Babylonian.sol";
7 
8 /// @title UniswapLens
9 /// @author Fei Protocol
10 /// @notice a contract to read tokens & fei out of a contract that reports balance in Uniswap LP tokens.
11 contract UniswapLens is IPCVDepositBalances, UniRef {
12     using Decimal for Decimal.D256;
13     using Babylonian for uint256;
14 
15     /// @notice FEI token address
16     address private constant FEI = 0x956F47F50A910163D8BF957Cf5846D573E7f87CA;
17 
18     /// @notice the deposit inspected
19     address public immutable depositAddress;
20 
21     /// @notice the token the lens reports balances in
22     address public immutable override balanceReportedIn;
23 
24     /// @notice true if FEI is token0 in the Uniswap pool
25     bool public immutable feiIsToken0;
26 
27     constructor(
28         address _depositAddress,
29         address _core,
30         address _oracle,
31         address _backupOracle
32     )
33         UniRef(
34             _core,
35             IPCVDepositBalances(_depositAddress).balanceReportedIn(), // pair address
36             _oracle,
37             _backupOracle
38         )
39     {
40         depositAddress = _depositAddress;
41         IUniswapV2Pair pair = IUniswapV2Pair(IPCVDepositBalances(_depositAddress).balanceReportedIn());
42         address token0 = pair.token0();
43         address token1 = pair.token1();
44         feiIsToken0 = token0 == FEI;
45         balanceReportedIn = feiIsToken0 ? token1 : token0;
46     }
47 
48     function balance() public view override returns (uint256) {
49         (, uint256 tokenReserves) = getReserves();
50         return _ratioOwned().mul(tokenReserves).asUint256();
51     }
52 
53     function resistantBalanceAndFei() public view override returns (uint256, uint256) {
54         (uint256 reserve0, uint256 reserve1) = getReserves();
55         uint256 feiInPool = feiIsToken0 ? reserve0 : reserve1;
56         uint256 otherInPool = feiIsToken0 ? reserve1 : reserve0;
57 
58         Decimal.D256 memory priceOfToken = readOracle();
59 
60         uint256 k = feiInPool * otherInPool;
61 
62         // resistant other/fei in pool
63         uint256 resistantOtherInPool = Decimal.one().div(priceOfToken).mul(k).asUint256().sqrt();
64         uint256 resistantFeiInPool = Decimal.ratio(k, resistantOtherInPool).asUint256();
65 
66         Decimal.D256 memory ratioOwned = _ratioOwned();
67         return (ratioOwned.mul(resistantOtherInPool).asUint256(), ratioOwned.mul(resistantFeiInPool).asUint256());
68     }
69 
70     /// @notice ratio of all pair liquidity owned by the deposit contract
71     function _ratioOwned() internal view returns (Decimal.D256 memory) {
72         uint256 liquidity = liquidityOwned();
73         uint256 total = pair.totalSupply();
74         return Decimal.ratio(liquidity, total);
75     }
76 
77     /// @notice amount of pair liquidity owned by the deposit contract
78     /// @return amount of LP tokens
79     function liquidityOwned() public view virtual returns (uint256) {
80         return IPCVDepositBalances(depositAddress).balance();
81     }
82 }
