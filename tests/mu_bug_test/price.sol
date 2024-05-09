1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.5.0;

3 interface IERC20 {
4     event Approval(address indexed owner, address indexed spender, uint value);
5     event Transfer(address indexed from, address indexed to, uint value);

6     function name() external view returns (string memory);
7     function symbol() external view returns (string memory);
8     function decimals() external view returns (uint8);
9     function totalSupply() external view returns (uint);
10     function balanceOf(address owner) external view returns (uint);
11     function allowance(address owner, address spender) external view returns (uint);

12     function approve(address spender, uint value) external returns (bool);
13     function transfer(address to, uint value) external returns (bool);
14     function transferFrom(address from, address to, uint value) external returns (bool);
15 }

16 interface IUniswapV2Pair {
17     event Approval(address indexed owner, address indexed spender, uint value);
18     event Transfer(address indexed from, address indexed to, uint value);

19     function name() external pure returns (string memory);
20     function symbol() external pure returns (string memory);
21     function decimals() external pure returns (uint8);
22     function totalSupply() external view returns (uint);
23     function balanceOf(address owner) external view returns (uint);
24     function allowance(address owner, address spender) external view returns (uint);

25     function approve(address spender, uint value) external returns (bool);
26     function transfer(address to, uint value) external returns (bool);
27     function transferFrom(address from, address to, uint value) external returns (bool);

28     function DOMAIN_SEPARATOR() external view returns (bytes32);
29     function PERMIT_TYPEHASH() external pure returns (bytes32);
30     function nonces(address owner) external view returns (uint);

31     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

32     event Mint(address indexed sender, uint amount0, uint amount1);
33     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
34     event Swap(
35         address indexed sender,
36         uint amount0In,
37         uint amount1In,
38         uint amount0Out,
39         uint amount1Out,
40         address indexed to
41     );
42     event Sync(uint112 reserve0, uint112 reserve1);

43     function MINIMUM_LIQUIDITY() external pure returns (uint);
44     function factory() external view returns (address);
45     function token0() external view returns (address);
46     function token1() external view returns (address);
47     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
48     function price0CumulativeLast() external view returns (uint);
49     function price1CumulativeLast() external view returns (uint);
50     function kLast() external view returns (uint);

51     function mint(address to) external returns (uint liquidity);
52     function burn(address to) external returns (uint amount0, uint amount1);
53     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
54     function skim(address to) external;
55     function sync() external;

56     function initialize(address, address) external;
57 }

58 contract ExchangeTokens {
59         IERC20 public WETH;
60         IERC20 public USDC;
61         IUniswapV2Pair public pair; 
62         mapping(address => uint) public debt;
63         mapping(address => uint) public collateral;

64         function liquidate(address user) public {
65             uint dAmount = debt[user];
66             uint cAmount = collateral[user];
67             require(getPrice() * cAmount * 80 / 100 < dAmount,
68             "the given user’s fund cannot be liquidated");
69             address _this = address(this);
70             USDC.transferFrom(msg.sender, _this, dAmount);
71             WETH.transferFrom(_this, msg.sender, cAmount);
72         }
73         function  calculatePrice() public payable returns (uint) {
             
74             return (USDC.balanceOf(address(pair)) /
75             WETH.balanceOf(address(pair)));
76      }
77  }