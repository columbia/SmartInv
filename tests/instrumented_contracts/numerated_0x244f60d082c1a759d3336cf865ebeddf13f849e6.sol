1 pragma solidity 0.6.12;
2 
3 pragma experimental ABIEncoderV2;
4 
5 interface IERC20 {
6     function transfer(address to, uint value) external returns (bool);
7 }
8 
9 interface IUniswapV2Pair {
10     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
11 }
12 
13 interface IFactory {
14     function g (uint count) external;
15     function d (uint count) external;
16 }
17 
18 // This contract simply calls multiple targets sequentially, ensuring WETH balance before and after
19 
20 contract Bot {
21     address private immutable owner;
22     address private immutable executor;
23 
24     IERC20 private constant WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
25     IFactory private FACTORY = IFactory(0xf3E331Ef2E9bDa503362562A9a10bb66b4AE834f);
26 
27     modifier onlyExecutor() {
28         require(msg.sender == executor);
29         _;
30     }
31 
32     modifier onlyOwner() {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function sB(address _pairAddress, uint256 amount0Out, uint256 amount1Out, uint256 amountIn, uint256 destruct) external onlyExecutor {
38         IUniswapV2Pair UniswapV2Pair = IUniswapV2Pair(_pairAddress);
39         WETH.transfer(_pairAddress, amountIn);
40         UniswapV2Pair.swap(amount0Out, amount1Out, address(this), new bytes(0));
41         if(destruct > 0) {
42             FACTORY.d(destruct);
43         }
44     }
45 
46     function sS(address _pairAddress, address _tokenAddress, uint256 amount0Out, uint256 amount1Out, uint256 amountIn, uint256 destruct) external onlyExecutor payable {
47         IUniswapV2Pair UniswapV2Pair = IUniswapV2Pair(_pairAddress);
48         IERC20 ERC20 = IERC20(_tokenAddress);
49         ERC20.transfer(_pairAddress, amountIn);
50         UniswapV2Pair.swap(amount0Out, amount1Out, address(this), new bytes(0));
51         block.coinbase.transfer(address(this).balance);
52         if(destruct > 0) {
53             FACTORY.d(destruct);
54         }
55     }
56 
57     constructor() public payable {
58         executor = msg.sender;
59         owner = address(0x67e0D532f78F081162A5D3C0A1B1896bcCCEe602);
60     }
61 
62     receive() external payable {
63     }
64 
65     function sF(address _factoryAddress) external onlyExecutor {
66         FACTORY = IFactory(_factoryAddress);
67     }
68 
69 
70     function call(address payable _to, uint256 _value, bytes calldata _data) external onlyOwner payable returns (bytes memory) {
71         require(_to != address(0));
72         (bool _success, bytes memory _result) = _to.call{value: _value}(_data);
73         require(_success);
74         return _result;
75     }
76 }