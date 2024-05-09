// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// https://curve.fi/frax
// https://curve.fi/tusd
// https://curve.fi/lusd
// https://curve.fi/gusd
// https://curve.fi/mim
// https://curve.fi/factory/113 - pUSD
// https://curve.fi/alusd

interface ICurveCRVMeta {
  
  function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external returns (uint256);

  function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external returns (uint256);

  function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns (uint256);

  // function remove_liquidity(uint256 _burn_amount, uint256[2] memory _min_amounts) external returns (uint256[2]);

  function coins(uint256 index) external view returns (address);
}