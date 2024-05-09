// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// https://curve.fi/3pool
// https://curve.fi/ib

interface ICurveBase3Pool {
  
    function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external;
    
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;

    function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external;

    function coins(uint256 index) external view returns (address);
}