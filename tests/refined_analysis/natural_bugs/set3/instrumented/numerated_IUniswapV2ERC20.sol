1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.5.0;
3 
4 interface IUniswapV2ERC20 {
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
24 }
