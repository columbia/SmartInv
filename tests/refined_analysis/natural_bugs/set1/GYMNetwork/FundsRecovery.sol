// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import { IERC20Token } from "./interfaces/IERC20Token.sol";
import { Ownable } from "./Ownable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract FundsRecovery is Ownable, ReentrancyGuard {
    address payable internal fundsDestination;
    IERC20Token public token;

    event DestinationChanged(address indexed previousDestination, address indexed newDestination);

    /**
     * Setting new destination of funds recovery.
     */
    function setFundsDestination(address payable _newDestination) public virtual onlyOwner {
        require(_newDestination != address(0));
        emit DestinationChanged(fundsDestination, _newDestination);
        fundsDestination = _newDestination;
    }

    /**
     * Getting funds destination address.
     */
    function getFundsDestination() public view returns (address) {
        return fundsDestination;
    }

    /**
     * Possibility to recover funds in case they were sent to this address before smart contract deployment
     */
    function claimNativeCoin() public nonReentrant {
        require(fundsDestination != address(0));
        fundsDestination.transfer(address(this).balance);
    }

    /**
       Transfers selected tokens into owner address.
    */
    function claimTokens(address _token) public nonReentrant {
        require(fundsDestination != address(0));
        require(_token != address(token), "native token funds can't be recovered");
        uint256 _amount = IERC20Token(_token).balanceOf(address(this));
        IERC20Token(_token).transfer(fundsDestination, _amount);
    }
}
