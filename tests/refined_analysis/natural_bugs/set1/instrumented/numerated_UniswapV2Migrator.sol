1 pragma solidity =0.6.6;
2 
3 import '@uniswap/lib/contracts/libraries/TransferHelper.sol';
4 
5 import './interfaces/IUniswapV2Migrator.sol';
6 import './interfaces/V1/IUniswapV1Factory.sol';
7 import './interfaces/V1/IUniswapV1Exchange.sol';
8 import './interfaces/IUniswapV2Router01.sol';
9 import './interfaces/IERC20.sol';
10 
11 contract UniswapV2Migrator is IUniswapV2Migrator {
12     IUniswapV1Factory immutable factoryV1;
13     IUniswapV2Router01 immutable router;
14 
15     constructor(address _factoryV1, address _router) public {
16         factoryV1 = IUniswapV1Factory(_factoryV1);
17         router = IUniswapV2Router01(_router);
18     }
19 
20     // needs to accept ETH from any v1 exchange and the router. ideally this could be enforced, as in the router,
21     // but it's not possible because it requires a call to the v1 factory, which takes too much gas
22     receive() external payable {}
23 
24     function migrate(address token, uint amountTokenMin, uint amountETHMin, address to, uint deadline)
25         external
26         override
27     {
28         IUniswapV1Exchange exchangeV1 = IUniswapV1Exchange(factoryV1.getExchange(token));
29         uint liquidityV1 = exchangeV1.balanceOf(msg.sender);
30         require(exchangeV1.transferFrom(msg.sender, address(this), liquidityV1), 'TRANSFER_FROM_FAILED');
31         (uint amountETHV1, uint amountTokenV1) = exchangeV1.removeLiquidity(liquidityV1, 1, 1, uint(-1));
32         TransferHelper.safeApprove(token, address(router), amountTokenV1);
33         (uint amountTokenV2, uint amountETHV2,) = router.addLiquidityETH{value: amountETHV1}(
34             token,
35             amountTokenV1,
36             amountTokenMin,
37             amountETHMin,
38             to,
39             deadline
40         );
41         if (amountTokenV1 > amountTokenV2) {
42             TransferHelper.safeApprove(token, address(router), 0); // be a good blockchain citizen, reset allowance to 0
43             TransferHelper.safeTransfer(token, msg.sender, amountTokenV1 - amountTokenV2);
44         } else if (amountETHV1 > amountETHV2) {
45             // addLiquidityETH guarantees that all of amountETHV1 or amountTokenV1 will be used, hence this else is safe
46             TransferHelper.safeTransferETH(msg.sender, amountETHV1 - amountETHV2);
47         }
48     }
49 }
