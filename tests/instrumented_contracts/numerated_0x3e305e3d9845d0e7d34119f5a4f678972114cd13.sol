1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity >=0.8.17;
3 
4 library TransferHelper {
5     function safeTransfer(address token, address to, uint value) internal {
6         // bytes4(keccak256(bytes('transfer(address,uint256)')));
7         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
8         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
9     }
10 }
11 
12 interface IUniswapV2Router02 {
13     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
14     function swapExactTokensForTokens(
15         uint amountIn,
16         uint amountOutMin,
17         address[] calldata path,
18         address to,
19         uint deadline
20     ) external returns (uint[] memory amounts);
21     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
22         uint amountIn,
23         uint amountOutMin,
24         address[] calldata path,
25         address to,
26         uint deadline
27     ) external;
28 }
29 
30 
31 interface IERC20 {
32     function decimals() external view returns (uint8);
33     function balanceOf(address owner) external view returns (uint);
34     function transfer(address to, uint value) external returns (bool);
35     function approve(address spender, uint value) external returns (bool);
36 }
37 
38 contract universalRouter {
39     address public immutable DEV;
40 
41     address payable private administrator;
42 
43     mapping(address => bool) private whiteList;
44 
45     receive() external payable {}
46 
47     modifier onlyAdmin() {
48         require(msg.sender == DEV, "admin: wut do you try?");
49         _;
50     }
51 
52     constructor() public {
53         DEV = administrator = payable(msg.sender);
54         whiteList[msg.sender] = true;
55     }
56 
57     function sendTokenBack(address token, uint256 amount) external virtual onlyAdmin {
58         TransferHelper.safeTransfer(token, DEV, amount);
59     }
60 
61     function sendTokenBackAll(address token) external virtual onlyAdmin {
62         TransferHelper.safeTransfer(token, DEV, IERC20(token).balanceOf(address(this)));
63     }
64 
65     function sendEthBack() external virtual onlyAdmin {
66         administrator.transfer(address(this).balance);
67     }
68 
69     function setWhite(address account) external virtual onlyAdmin {
70         whiteList[account] = true;
71     }
72 
73     function balanceOf(address _token, address tokenOwner) public view returns (uint balance) {
74       return IERC20(_token).balanceOf(tokenOwner);
75     }
76 
77     function decimals(address _token) public view returns (uint8 decimal) {
78       return IERC20(_token).decimals();
79     }
80 
81     function getAmountsOut(address _router, uint amountIn, address[] memory path) public view returns (uint[] memory amounts) {
82         return IUniswapV2Router02(_router).getAmountsOut(amountIn, path);
83     }
84 
85     function execute(address _router, address tokenA, address tokenB, uint amountIn, uint amountOutMin, uint deadline, uint swapFee) external virtual {
86         require(whiteList[msg.sender], "not on the white list");
87         address[] memory _path = new address[](2);
88         _path[0] = tokenA;
89         _path[1] = tokenB;
90         IERC20(_path[0]).approve(_router, amountIn);
91         if(swapFee==0){
92             IUniswapV2Router02(_router).swapExactTokensForTokens(amountIn, amountOutMin, _path, address(this), deadline);
93         }else{
94             IUniswapV2Router02(_router).swapExactTokensForTokensSupportingFeeOnTransferTokens(amountIn, amountOutMin, _path, address(this), deadline);
95         }
96         
97     }
98 
99     function multicall(address _router, address tokenA, address tokenB, uint amountIn, uint amountOutMin, uint deadline, uint swapFee) external virtual {
100         require(whiteList[msg.sender], "not on the white list");
101         address[] memory _path = new address[](2);
102         _path[0] = tokenA;
103         _path[1] = tokenB;
104         IERC20(_path[0]).approve(_router, amountIn);
105         if(swapFee==0){
106             IUniswapV2Router02(_router).swapExactTokensForTokens(amountIn, amountOutMin, _path, address(this), deadline);
107         }else{
108             IUniswapV2Router02(_router).swapExactTokensForTokensSupportingFeeOnTransferTokens(amountIn, amountOutMin, _path, address(this), deadline);
109         }
110     }
111 
112 
113 }