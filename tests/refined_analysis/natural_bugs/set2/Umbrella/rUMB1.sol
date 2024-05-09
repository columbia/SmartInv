//SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "./interfaces/rUMB.sol";

contract rUMB1 is rUMB {
     constructor (
        address _owner,
        address _initialHolder,
        uint256 _initialBalance,
        uint256 _maxAllowedTotalSupply,
        uint256 _swapDuration,
        string memory _name,
        string memory _symbol
    )
    rUMB(_owner, _initialHolder, _initialBalance, _maxAllowedTotalSupply, _swapDuration, _name, _symbol) {
    }
}
