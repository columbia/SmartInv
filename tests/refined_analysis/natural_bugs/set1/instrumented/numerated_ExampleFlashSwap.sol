1 pragma solidity =0.6.6;
2 
3 import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Callee.sol';
4 
5 import '../libraries/UniswapV2Library.sol';
6 import '../interfaces/V1/IUniswapV1Factory.sol';
7 import '../interfaces/V1/IUniswapV1Exchange.sol';
8 import '../interfaces/IUniswapV2Router01.sol';
9 import '../interfaces/IERC20.sol';
10 import '../interfaces/IWETH.sol';
11 
12 contract ExampleFlashSwap is IUniswapV2Callee {
13     IUniswapV1Factory immutable factoryV1;
14     address immutable factory;
15     IWETH immutable WETH;
16 
17     constructor(address _factory, address _factoryV1, address router) public {
18         factoryV1 = IUniswapV1Factory(_factoryV1);
19         factory = _factory;
20         WETH = IWETH(IUniswapV2Router01(router).WETH());
21     }
22 
23     // needs to accept ETH from any V1 exchange and WETH. ideally this could be enforced, as in the router,
24     // but it's not possible because it requires a call to the v1 factory, which takes too much gas
25     receive() external payable {}
26 
27     // gets tokens/WETH via a V2 flash swap, swaps for the ETH/tokens on V1, repays V2, and keeps the rest!
28     function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external override {
29         address[] memory path = new address[](2);
30         uint amountToken;
31         uint amountETH;
32         { // scope for token{0,1}, avoids stack too deep errors
33         address token0 = IUniswapV2Pair(msg.sender).token0();
34         address token1 = IUniswapV2Pair(msg.sender).token1();
35         assert(msg.sender == UniswapV2Library.pairFor(factory, token0, token1)); // ensure that msg.sender is actually a V2 pair
36         assert(amount0 == 0 || amount1 == 0); // this strategy is unidirectional
37         path[0] = amount0 == 0 ? token0 : token1;
38         path[1] = amount0 == 0 ? token1 : token0;
39         amountToken = token0 == address(WETH) ? amount1 : amount0;
40         amountETH = token0 == address(WETH) ? amount0 : amount1;
41         }
42 
43         assert(path[0] == address(WETH) || path[1] == address(WETH)); // this strategy only works with a V2 WETH pair
44         IERC20 token = IERC20(path[0] == address(WETH) ? path[1] : path[0]);
45         IUniswapV1Exchange exchangeV1 = IUniswapV1Exchange(factoryV1.getExchange(address(token))); // get V1 exchange
46 
47         if (amountToken > 0) {
48             (uint minETH) = abi.decode(data, (uint)); // slippage parameter for V1, passed in by caller
49             token.approve(address(exchangeV1), amountToken);
50             uint amountReceived = exchangeV1.tokenToEthSwapInput(amountToken, minETH, uint(-1));
51             uint amountRequired = UniswapV2Library.getAmountsIn(factory, amountToken, path)[0];
52             assert(amountReceived > amountRequired); // fail if we didn't get enough ETH back to repay our flash loan
53             WETH.deposit{value: amountRequired}();
54             assert(WETH.transfer(msg.sender, amountRequired)); // return WETH to V2 pair
55             (bool success,) = sender.call{value: amountReceived - amountRequired}(new bytes(0)); // keep the rest! (ETH)
56             assert(success);
57         } else {
58             (uint minTokens) = abi.decode(data, (uint)); // slippage parameter for V1, passed in by caller
59             WETH.withdraw(amountETH);
60             uint amountReceived = exchangeV1.ethToTokenSwapInput{value: amountETH}(minTokens, uint(-1));
61             uint amountRequired = UniswapV2Library.getAmountsIn(factory, amountETH, path)[0];
62             assert(amountReceived > amountRequired); // fail if we didn't get enough tokens back to repay our flash loan
63             assert(token.transfer(msg.sender, amountRequired)); // return tokens to V2 pair
64             assert(token.transfer(sender, amountReceived - amountRequired)); // keep the rest! (tokens)
65         }
66     }
67 }
