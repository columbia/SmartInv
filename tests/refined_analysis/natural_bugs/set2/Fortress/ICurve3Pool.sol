// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// https://curve.fi/tricrypto2 - ETH is wETH

interface ICurve3Pool {
  
    function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external payable;
    
    function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external payable;
    
    function remove_liquidity_one_coin(uint256 token_amount, uint256 i, uint256 min_amount) external payable;

    function coins(uint256 index) external view returns (address);
}