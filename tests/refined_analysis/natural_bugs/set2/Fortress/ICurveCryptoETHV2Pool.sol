// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// https://curve.fi/cvxeth
// https://curve.fi/crveth
// https://curve.fi/spelleth
// https://curve.fi/factory-crypto/3 - FXS/ETH
// https://curve.fi/factory-crypto/8 - YFI/ETH
// https://curve.fi/factory-crypto/85 - BTRFLY/ETH
// https://curve.fi/factory-crypto/39 - KP3R/ETH
// https://curve.fi/factory-crypto/43 - JPEG/ETH
// https://curve.fi/factory-crypto/55 - TOKE/ETH
// https://curve.fi/factory-crypto/21 - OHM/ETH

interface ICurveCryptoETHV2Pool {

    function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount, bool use_eth) external payable returns (uint256);

    function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy, bool use_eth) external payable returns (uint256);

    function remove_liquidity_one_coin(uint256 _token_amount, uint256 i, uint256 _min_amount, bool use_eth) external returns (uint256);

    function coins(uint256 index) external view returns (address);
}