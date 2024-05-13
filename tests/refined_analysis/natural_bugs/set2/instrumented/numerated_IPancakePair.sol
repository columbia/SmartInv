1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 interface IPancakePair {
6     event Approval(address indexed owner, address indexed spender, uint value);
7     event Transfer(address indexed from, address indexed to, uint value);
8 
9     event Mint(address indexed sender, uint amount0, uint amount1);
10     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
11     event Swap(
12         address indexed sender,
13         uint amount0In,
14         uint amount1In,
15         uint amount0Out,
16         uint amount1Out,
17         address indexed to
18     );
19     event Sync(uint112 reserve0, uint112 reserve1);
20 
21     function MINIMUM_LIQUIDITY() external pure returns (uint);
22     function factory() external view returns (address);
23     function token0() external view returns (address);
24     function token1() external view returns (address);
25     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
26     function price0CumulativeLast() external view returns (uint);
27     function price1CumulativeLast() external view returns (uint);
28     function kLast() external view returns (uint);
29 
30     function mint(address to) external returns (uint liquidity);
31     function burn(address to) external returns (uint amount0, uint amount1);
32     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
33     function skim(address to) external;
34     function sync() external;
35 
36     function initialize(address, address) external;
37 }