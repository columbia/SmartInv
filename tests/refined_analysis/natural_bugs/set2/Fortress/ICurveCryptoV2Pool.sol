// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// https://curve.fi/factory-crypto/37 - USDC/STG
// https://curve.fi/factory-crypto/23 - USDC/FIDU
// https://curve.fi/factory-crypto/4 - wBTC/BADGER
// https://curve.fi/factory-crypto/18 - cvxFXS/FXS
// https://curve.fi/factory-crypto/62 - pxCVX/CVX
// https://curve.fi/factory-crypto/22 - SILO/FRAX
// https://curve.fi/factory-crypto/48 - FRAX/FPI
// https://curve.fi/factory-crypto/90 - FXS/FPIS

interface ICurveCryptoV2Pool {

    function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount) external payable returns (uint256);

    function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external payable returns (uint256);
    
    function remove_liquidity_one_coin(uint256 _token_amount, uint256 i, uint256 _min_amount) external returns (uint256);

    function coins(uint256 index) external view returns (address);
}