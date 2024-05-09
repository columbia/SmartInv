// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IUniswapV3Pool {
    
  function token0() external returns (address);

  function token1() external returns (address);

  function fee() external returns (uint24);
}