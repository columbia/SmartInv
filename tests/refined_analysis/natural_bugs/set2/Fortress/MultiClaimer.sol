// SPDX-License-Identifier: MIT
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

//  _____     _ _   _ _____ _     _               
// |     |_ _| | |_|_|     | |___|_|_____ ___ ___ 
// | | | | | | |  _| |   --| | .'| |     | -_|  _|
// |_|_|_|___|_|_| |_|_____|_|__,|_|_|_|_|___|_|  

// Github - https://github.com/FortressFinance

import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import {IFortressConcentrator} from "src/shared/fortress-interfaces/IFortressConcentrator.sol";

contract MultiClaimer is ReentrancyGuard {

    /// @dev Claim rewards from multiple Concentrator vaults
    /// @param _vaults Array of Concentrator vaults
    /// @param _receiver Address to receive rewards
    /// @return _rewards Total rewards claimed
    function multiClaim(address[] memory _vaults, address _receiver) external nonReentrant returns (uint256 _rewards) {
        for (uint256 i = 0; i < _vaults.length; i++) {
            _rewards += IFortressConcentrator(_vaults[i]).claim(msg.sender, _receiver);
        }
    }
}