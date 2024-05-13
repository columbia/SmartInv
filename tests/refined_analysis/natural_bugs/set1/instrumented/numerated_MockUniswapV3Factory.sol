1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./MockUniswapV3Pool.sol";
5 
6 contract MockUniswapV3Factory {
7     mapping(address => mapping(address => mapping(uint24 => address))) public getPool;
8 
9     struct Parameters {
10         address factory;
11         address token0;
12         address token1;
13         uint24 fee;
14         int24 tickSpacing;
15     }
16 
17     Parameters public parameters;
18 
19     function deploy(address factory, address token0, address token1, uint24 fee, int24 tickSpacing) internal returns (address pool) {
20         parameters = Parameters({factory: factory, token0: token0, token1: token1, fee: fee, tickSpacing: tickSpacing});
21         pool = address(new MockUniswapV3Pool{salt: keccak256(abi.encode(token0, token1, fee))}());
22         delete parameters;
23     }
24 
25     function createPool(address tokenA, address tokenB, uint24 fee) external returns (address pool) {
26         require(tokenA != tokenB);
27         (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
28         require(token0 != address(0));
29         require(getPool[token0][token1][fee] == address(0));
30 
31         pool = deploy(address(this), token0, token1, fee, 0);
32         getPool[token0][token1][fee] = pool;
33         getPool[token1][token0][fee] = pool;
34     }
35 
36     function setPoolAddress(address tokenA, address tokenB, uint24 fee, address newAddress) external {
37         (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
38         getPool[token0][token1][fee] = newAddress;
39         getPool[token1][token0][fee] = newAddress;
40     }
41 }
