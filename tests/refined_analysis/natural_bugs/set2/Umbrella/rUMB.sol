//SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

// Inheritance
import "./SwappableToken.sol";
import "./MintableToken.sol";


/// @title   Umbrella Rewards contract
/// @author  umb.network
/// @notice  This is reward UMB token (rUMB)
/// @dev     Rewards tokens are used for farming and other rewards distributions.
abstract contract rUMB is MintableToken, SwappableToken {
    // ========== STATE VARIABLES ========== //

    // ========== CONSTRUCTOR ========== //

    constructor (
        address _owner,
        address _initialHolder,
        uint256 _initialBalance,
        uint256 _maxAllowedTotalSupply,
        uint256 _swapDuration,
        string memory _name,
        string memory _symbol
    )
    Owned(_owner)
    ERC20(_name, _symbol)
    MintableToken(_maxAllowedTotalSupply)
    SwappableToken(_maxAllowedTotalSupply, _swapDuration) {
        if (_initialHolder != address(0) && _initialBalance != 0) {
            _mint(_initialHolder, _initialBalance);
        }
    }
}
