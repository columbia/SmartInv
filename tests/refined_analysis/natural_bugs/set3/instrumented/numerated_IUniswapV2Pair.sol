1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.5.0;
3 
4 // https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol
5 
6 interface IUniswapV2Pair {
7     event Approval(address indexed owner, address indexed spender, uint value);
8     event Transfer(address indexed from, address indexed to, uint value);
9 
10     function name() external pure returns (string memory);
11 
12     function symbol() external pure returns (string memory);
13 
14     function decimals() external pure returns (uint8);
15 
16     function totalSupply() external view returns (uint);
17 
18     function balanceOf(address owner) external view returns (uint);
19 
20     function allowance(address owner, address spender) external view returns (uint);
21 
22     function approve(address spender, uint value) external returns (bool);
23 
24     function transfer(address to, uint value) external returns (bool);
25 
26     function transferFrom(
27         address from,
28         address to,
29         uint value
30     ) external returns (bool);
31 
32     function DOMAIN_SEPARATOR() external view returns (bytes32);
33 
34     function PERMIT_TYPEHASH() external pure returns (bytes32);
35 
36     function nonces(address owner) external view returns (uint);
37 
38     function permit(
39         address owner,
40         address spender,
41         uint value,
42         uint deadline,
43         uint8 v,
44         bytes32 r,
45         bytes32 s
46     ) external;
47 
48     event Mint(address indexed sender, uint amount0, uint amount1);
49     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
50     event Swap(
51         address indexed sender,
52         uint amount0In,
53         uint amount1In,
54         uint amount0Out,
55         uint amount1Out,
56         address indexed to
57     );
58     event Sync(uint112 reserve0, uint112 reserve1);
59 
60     function MINIMUM_LIQUIDITY() external pure returns (uint);
61 
62     function factory() external view returns (address);
63 
64     function token0() external view returns (address);
65 
66     function token1() external view returns (address);
67 
68     function getReserves()
69     external
70     view
71     returns (
72         uint112 reserve0,
73         uint112 reserve1,
74         uint32 blockTimestampLast
75     );
76 
77     function price0CumulativeLast() external view returns (uint);
78 
79     function price1CumulativeLast() external view returns (uint);
80 
81     function kLast() external view returns (uint);
82 
83     function mint(address to) external returns (uint liquidity);
84 
85     function burn(address to) external returns (uint amount0, uint amount1);
86 
87     function swap(
88         uint amount0Out,
89         uint amount1Out,
90         address to,
91         bytes calldata data
92     ) external;
93 
94     function skim(address to) external;
95 
96     function sync() external;
97 
98     function initialize(address, address) external;
99 }
