// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface ICurvePool {

  function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external payable returns (uint256);

  function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external payable returns (uint256);
  
  function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external returns (uint256);
  
  function coins(uint256 index) external view returns (address);
}