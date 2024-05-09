// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// https://curve.fi/factory-crypto/95 - CVX/crvFRAX
// https://curve.fi/factory-crypto/94 - cvxFXS/crvFRAX
// https://curve.fi/factory-crypto/96 - ALCX/crvFRAX
// https://curve.fi/factory-crypto/97 - cvxCRV/crvFRAX

interface ICurveFraxCryptoMeta {

  function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external returns (uint256);

  function remove_liquidity_one_coin(uint256 token_amount, uint256 i, uint256 min_amount) external returns (uint256);

  function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external returns (uint256);

  function coins(uint256 index) external view returns (address);
}