// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// (Curve Crypto V1 Pools)

// https://curve.fi/reth
// https://curve.fi/ankreth
// https://curve.fi/steth
// https://curve.fi/seth
// https://curve.fi/factory/155 - fraxETH
// https://curve.fi/factory/38 - alETH
// https://curve.fi/factory/194 - pETH
// https://curve.fi/#/ethereum/pools/frxeth - frxETH

interface ICurveETHPool {

    function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount) external payable returns (uint256);

    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external payable returns (uint256);
    
    function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 _min_amount) external returns (uint256);

    function coins(uint256 index) external view returns (address);
}