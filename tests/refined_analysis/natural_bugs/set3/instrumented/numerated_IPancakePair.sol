1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.2;
3 
4 interface IPancakePair {
5     event Approval(address indexed owner, address indexed spender, uint value);
6     event Transfer(address indexed from, address indexed to, uint value);
7 
8     function name() external pure returns (string memory);
9     function symbol() external pure returns (string memory);
10     function decimals() external pure returns (uint8);
11     function totalSupply() external view returns (uint);
12     function balanceOf(address owner) external view returns (uint);
13     function allowance(address owner, address spender) external view returns (uint);
14 
15     function approve(address spender, uint value) external returns (bool);
16     function transfer(address to, uint value) external returns (bool);
17     function transferFrom(address from, address to, uint value) external returns (bool);
18 
19     function DOMAIN_SEPARATOR() external view returns (bytes32);
20     function PERMIT_TYPEHASH() external pure returns (bytes32);
21     function nonces(address owner) external view returns (uint);
22 
23     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
24 
25     event Mint(address indexed sender, uint amount0, uint amount1);
26     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
27     event Swap(
28         address indexed sender,
29         uint amount0In,
30         uint amount1In,
31         uint amount0Out,
32         uint amount1Out,
33         address indexed to
34     );
35     event Sync(uint112 reserve0, uint112 reserve1);
36 
37     function MINIMUM_LIQUIDITY() external pure returns (uint);
38     function factory() external view returns (address);
39     function token0() external view returns (address);
40     function token1() external view returns (address);
41     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
42     function price0CumulativeLast() external view returns (uint);
43     function price1CumulativeLast() external view returns (uint);
44     function kLast() external view returns (uint);
45 
46     function mint(address to) external returns (uint liquidity);
47     function burn(address to) external returns (uint amount0, uint amount1);
48     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
49     function skim(address to) external;
50     function sync() external;
51 
52     function initialize(address, address) external;
53 }