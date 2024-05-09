// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// https://curve.fi/fraxusdc
// https://curve.fi/eursusd
// https://curve.fi/link
// https://curve.fi/eurs
// https://curve.fi/eursusd
// https://curve.fi/link
// CRV/cvxCRV - https://curve.fi/factory/22
// FXS/sdFXS - https://curve.fi/#/ethereum/pools/factory-v2-100

interface ICurvePlainPool {
  
  function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external returns (uint256);

  function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external returns (uint256);

  function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns (uint256);

  function coins(uint256 index) external view returns (address);
}