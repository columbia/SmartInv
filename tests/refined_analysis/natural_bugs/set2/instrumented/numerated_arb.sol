1 pragma solidity ^0.6.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint supply);
5     function balanceOf(address _owner) external view returns (uint balance);
6     function transfer(address _to, uint _value) external returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
8     function approve(address _spender, uint _value) external returns (bool success);
9     function allowance(address _owner, address _spender) external view returns (uint remaining);
10     function decimals() external view returns(uint digits);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 interface IUniswap {
15     function swapExactETHForTokens(
16         uint256 amountOutMin,
17         address[] calldata path,
18         address to,
19         uint256 deadline
20     ) external payable returns (uint256[] memory amounts);
21 
22     function getAmountsOut(uint256 amountIn, address[] calldata path)
23         external
24         view
25         returns (uint256[] memory amounts);
26         
27         
28     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
29       external
30       payable
31       returns (uint[] memory amounts);
32 
33     function swapExactTokensForTokens(
34         uint256 amountIn,
35         uint256 amountOutMin,
36         address[] calldata path,
37         address to,
38         uint256 deadline
39     ) external returns (uint256[] memory amounts);
40 
41     function swapExactTokensForETH(
42         uint256 amountIn,
43         uint256 amountOutMin,
44         address[] calldata path,
45         address to,
46         uint256 deadline
47     ) external returns (uint256[] memory amounts);
48     
49   function swapTokensForExactTokens(
50       uint amountOut,
51       uint amountInMax,
52       address[] calldata path,
53       address to,
54       uint deadline
55     ) external returns (uint[] memory amounts);
56 }
57 
58 contract PrintMoney {
59     address owner;
60     address uni_addr = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
61     IUniswap uni = IUniswap(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
62     //IERC20 usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
63     //IERC20 weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
64     //IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
65     
66     //IERC20 weth = IERC20(0xc778417E063141139Fce010982780140Aa0cD5Ab); // ropsten weth
67     //IERC20 dai = IERC20(0xaD6D458402F60fD3Bd25163575031ACDce07538D); // ropsten dai
68     
69     constructor() public {
70         owner = msg.sender;
71     }
72     
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77     
78     function setOwner(address _newOwner) onlyOwner external {
79         owner = _newOwner;
80     }
81     
82     function approveToken(address token) onlyOwner external {
83         IERC20 erc20 = IERC20(token);
84         erc20.approve(uni_addr, uint(-1)); // usdt six decimal would fail!
85     }
86     
87     function printMoney(
88         address tokenIn,
89         uint256 amountIn,
90         uint256 amountOutMin,
91         address[] calldata path,
92         uint256 deadline
93     ) onlyOwner external {
94         IERC20 erc20 = IERC20(tokenIn);
95         erc20.transferFrom(msg.sender, address(this), amountIn);
96         uni.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender, deadline);
97     }
98 }
