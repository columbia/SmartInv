1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 import "@studydefi/money-legos/dydx/contracts/DydxFlashloanBase.sol";
5 import "@studydefi/money-legos/dydx/contracts/ICallee.sol";
6 
7 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
8 import './IUniswapV2Router02.sol';
9 import './IWeth.sol';
10 
11 contract MoneyPrinter is ICallee, DydxFlashloanBase {
12 	address uni_addr = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
13 	//address solo_addr = 0x4EC3570cADaAEE08Ae384779B0f3A45EF85289DE; // kovan
14 	//address weth_addr = 0xd0A1E359811322d97991E03f863a0C30C2cF029C; // kovan
15 	//address dai_addr = 0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD; // kovan
16 	address solo_addr = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
17 	address weth_addr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
18 	address dai_addr = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
19 	address usdc_addr = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
20 
21     IUniswapV2Router02 uni = IUniswapV2Router02(uni_addr);
22 	ISoloMargin solo = ISoloMargin(solo_addr);
23 
24     address owner;
25 
26     constructor() public {
27 		owner = msg.sender;
28     }
29 
30 	modifier onlyOwner() {
31 		require(msg.sender == owner);
32 		_;
33 	}
34 
35 	function setOwner(address _o) onlyOwner external {
36 		owner = _o;
37 	}
38 
39 	function printMoney(
40         address tokenIn,
41         uint256 amountIn,
42         uint256 amountOutMin,
43         address[] calldata path,
44         uint256 deadline
45     ) onlyOwner external {
46         IERC20 erc20 = IERC20(tokenIn);
47         erc20.transferFrom(msg.sender, address(this), amountIn);
48 		erc20.approve(uni_addr, amountIn); // usdt -1 six decimal would fail!
49         uni.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender, deadline);
50     }
51 
52     // This is the function that will be called postLoan
53     // i.e. Encode the logic to handle your flashloaned funds here
54     function callFunction(
55         address sender,
56         Account.Info memory account,
57         bytes memory data
58     ) public {
59 		(address tokenIn, uint amountIn, address[] memory path) = abi.decode(data, (address, uint256, address[]));
60 
61 		IERC20(tokenIn).approve(uni_addr, amountIn);
62 		uni.swapExactTokensForTokens(amountIn, amountIn, path, address(this), now + 5 minutes);
63 
64 		uint256 repayAmount = amountIn + 2;
65         uint256 balance = IERC20(tokenIn).balanceOf(address(this));
66         require(
67             IERC20(tokenIn).balanceOf(address(this)) >= repayAmount,
68             "Not enough funds to repay dydx loan!"
69         );
70 
71         uint profit = IERC20(tokenIn).balanceOf(address(this)) - repayAmount; 
72         IERC20(tokenIn).transfer(owner, profit);
73     }
74 
75     function flashPrintMoney(
76       address tokenIn, 
77       uint256 amountIn, 
78       address[] calldata path
79 	) onlyOwner external {
80         // Get marketId from token address
81         uint256 marketId = _getMarketIdFromTokenAddress(solo_addr, tokenIn);
82 
83         // Calculate repay amount (_amount + (2 wei))
84         // Approve transfer from
85         uint256 repayAmount = _getRepaymentAmountInternal(amountIn);
86         IERC20(tokenIn).approve(solo_addr, repayAmount);
87 
88         Actions.ActionArgs[] memory operations = new Actions.ActionArgs[](3);
89 
90         operations[0] = _getWithdrawAction(marketId, amountIn);
91         operations[1] = _getCallAction(
92             abi.encode(tokenIn, amountIn, path)
93         );
94         operations[2] = _getDepositAction(marketId, repayAmount);
95 
96         Account.Info[] memory accountInfos = new Account.Info[](1);
97         accountInfos[0] = _getAccountInfo();
98 
99         solo.operate(accountInfos, operations);
100     }
101 
102     function() external payable {}
103 }
