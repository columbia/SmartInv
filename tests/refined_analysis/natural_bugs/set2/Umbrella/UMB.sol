//SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

// import "@nomiclabs/buidler/console.sol";

// Inheritance
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./interfaces/SwappableToken.sol";
import "./interfaces/MintableToken.sol";
import "./interfaces/ISwapReceiver.sol";
import "./interfaces/Airdrop.sol";


/// @title   Umbrella Rewards contract
/// @author  umb.network
/// @notice  This is main UMB token
///
/// @dev     Owner (multisig) can set list of rewards tokens rUMB. rUMBs can be swapped to UMB.
///          This token can be mint by owner eg we need UMB for auction. After that we can burn the key
///          so nobody can mint anymore.
///          It has limit for max total supply, so we need to make sure, total amount of rUMBs fit this limit.
contract UMB is MintableToken, Airdrop, ISwapReceiver {
    using SafeMath for uint256;

    // ========== STATE VARIABLES ========== //

    mapping(address => bool) rewardsTokens;

    // ========== CONSTRUCTOR ========== //

    constructor (
        address _owner,
        address _initialHolder,
        uint _initialBalance,
        uint256 _maxAllowedTotalSupply,
        string memory _name,
        string memory _symbol
    )
    Owned(_owner)
    ERC20(_name, _symbol)
    MintableToken(_maxAllowedTotalSupply) {
        if (_initialHolder != address(0) && _initialBalance != 0) {
            _mint(_initialHolder, _initialBalance);
        }
    }

    // ========== MODIFIERS ========== //

    // ========== MUTATIVE FUNCTIONS ========== //

    // ========== PRIVATE / INTERNAL ========== //

    // ========== RESTRICTED FUNCTIONS ========== //

    function setRewardTokens(address[] calldata _tokens, bool[] calldata _statuses)
    external
    onlyOwner {
        require(_tokens.length > 0, "please pass a positive number of reward tokens");
        require(_tokens.length == _statuses.length, "please pass same number of tokens and statuses");

        for (uint i = 0; i < _tokens.length; i++) {
            rewardsTokens[_tokens[i]] = _statuses[i];
        }

        emit LogSetRewardTokens(_tokens, _statuses);
    }

    function swapMint(address _holder, uint256 _amount) public override assertMaxSupply(_amount) {
        require(rewardsTokens[_msgSender()], "only reward token can be swapped");

        _mint(_holder, _amount);
    }

    // ========== EVENTS ========== //

    event LogSetRewardTokens(address[] tokens, bool[] statuses);
}
