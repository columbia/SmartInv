1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.6.12;
3 
4 pragma experimental ABIEncoderV2;
5 
6 interface IERC20 {
7     event Approval(address indexed owner, address indexed spender, uint value);
8     event Transfer(address indexed from, address indexed to, uint value);
9 
10     function name() external view returns (string memory);
11     function symbol() external view returns (string memory);
12     function decimals() external view returns (uint8);
13     function totalSupply() external view returns (uint);
14     function balanceOf(address owner) external view returns (uint);
15     function allowance(address owner, address spender) external view returns (uint);
16 
17     function approve(address spender, uint value) external returns (bool);
18     function transfer(address to, uint value) external returns (bool);
19     function transferFrom(address from, address to, uint value) external returns (bool);
20 }
21 
22 interface IWETH is IERC20 {
23     function deposit() external payable;
24     function withdraw(uint) external;
25 }
26 
27 // This contract simply calls multiple targets sequentially, ensuring WETH balance before and after
28 
29 contract FlashBotsMultiCall {
30     address private immutable owner;
31     address private immutable executor;
32     IWETH private constant WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
33 
34     modifier onlyExecutor() {
35         require(msg.sender == executor);
36         _;
37     }
38 
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     constructor(address _executor) public payable {
45         owner = msg.sender;
46         executor = _executor;
47         if (msg.value > 0) {
48             WETH.deposit{value: msg.value}();
49         }
50     }
51 
52     receive() external payable {
53     }
54 
55     function uniswapWeth(uint256 _wethAmountToFirstMarket, uint256 _ethAmountToCoinbase, address[] memory _targets, bytes[] memory _payloads) external onlyExecutor payable {
56         require (_targets.length == _payloads.length);
57         uint256 _wethBalanceBefore = WETH.balanceOf(address(this));
58         WETH.transfer(_targets[0], _wethAmountToFirstMarket);
59         for (uint256 i = 0; i < _targets.length; i++) {
60             (bool _success, bytes memory _response) = _targets[i].call(_payloads[i]);
61             require(_success); _response;
62         }
63 
64         uint256 _wethBalanceAfter = WETH.balanceOf(address(this));
65         require(_wethBalanceAfter > _wethBalanceBefore + _ethAmountToCoinbase);
66         if (_ethAmountToCoinbase == 0) return;
67 
68         block.coinbase.transfer(_ethAmountToCoinbase);
69     }
70 
71     function call(address payable _to, uint256 _value, bytes calldata _data) external onlyOwner payable returns (bytes memory) {
72         require(_to != address(0));
73         (bool _success, bytes memory _result) = _to.call{value: _value}(_data);
74         require(_success);
75         return _result;
76     }
77 }