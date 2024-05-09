// // SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
// ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
// █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
// ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
// ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
// ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
// ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
// ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
// █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
// ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
// ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
// ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝

//  _____         _                   _____     _ _____             _       _____             _     
// |   __|___ ___| |_ ___ ___ ___ ___|_   _|___|_|     |___ _ _ ___| |_ ___|     |___ ___ ___| |___ 
// |   __| . |  _|  _|  _| -_|_ -|_ -| | | |  _| |   --|  _| | | . |  _| . |  |  |  _| .'|  _| | -_|
// |__|  |___|_| |_| |_| |___|___|___| |_| |_| |_|_____|_| |_  |  _|_| |___|_____|_| |__,|___|_|___|
//                                                         |___|_|                                  

// Github - https://github.com/FortressFinance

import {ITriCryptoLpPriceOracle} from "../interfaces/ITriCryptoLpPriceOracle.sol";

import "./BaseOracle.sol";

contract FortressTriCryptoOracle is BaseOracle {

    using SafeCast for uint256;

    /********************************** Constructor **********************************/

    constructor(address _owner, address _vault) BaseOracle(_owner, _vault) {}

    /********************************** External Functions **********************************/

    function description() external pure override returns (string memory) {
        return "fcTriCrypto USD Oracle";
    }

    /********************************** Internal Functions **********************************/

    function _getPrice() internal view override returns (int256) {
        address _triCryptoLpPriceOracle= address(0x2C2FC48c3404a70F2d33290d5820Edf49CBf74a5);
        uint256 _assetPrice = ITriCryptoLpPriceOracle(_triCryptoLpPriceOracle).lp_price();

        uint256 _sharePrice = ((ERC4626(vault).convertToAssets(_assetPrice) * DECIMAL_DIFFERENCE) / BASE);

        // check that vault share price deviation did not exceed the configured bounds
        if (isCheckPriceDeviation) _checkPriceDeviation(_sharePrice);
        _checkVaultSpread();

        return _sharePrice.toInt256();
    }

    /********************************** Owner Functions **********************************/

    /// @notice this function needs to be called periodically to update the last share price
    function updateLastSharePrice() external override onlyOwner {
        address _triCryptoLpPriceOracle= address(0x2C2FC48c3404a70F2d33290d5820Edf49CBf74a5);
        lastSharePrice = ((ERC4626(vault).convertToAssets(ITriCryptoLpPriceOracle(_triCryptoLpPriceOracle).lp_price()) * DECIMAL_DIFFERENCE) / BASE);

        emit LastSharePriceUpdated(lastSharePrice);
    }
}