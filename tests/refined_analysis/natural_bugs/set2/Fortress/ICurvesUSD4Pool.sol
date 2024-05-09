// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// https://curve.fi/susdv2

interface ICurvesUSD4Pool {
  
    function add_liquidity(uint256[4] memory amounts, uint256 min_mint_amount) external;
    
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
    
    function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 min_uamount) external;

    function coins(int128 arg0) external view returns (address);
}