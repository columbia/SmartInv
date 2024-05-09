// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IFortressSwap {

    /// @notice swap _amount of _fromToken to _toToken.
    /// @param _fromToken The address of the token to swap from.
    /// @param _toToken The address of the token to swap to.
    /// @param _amount The amount of _fromToken to swap.
    /// @return _amount The amount of _toToken after swap.  
    function swap(address _fromToken, address _toToken, uint256 _amount) external payable returns (uint256);

    /********************************** Events & Errors **********************************/

    event Swap(address indexed _fromToken, address indexed _toToken, uint256 _amount);
    event UpdateRoute(address indexed fromToken, address indexed toToken, address[] indexed poolAddress);
    event DeleteRoute(address indexed fromToken, address indexed toToken);
    event UpdateOwner(address indexed _newOwner);
    event Rescue(address[] indexed _tokens, address indexed _recipient);
    event RescueETH(address indexed _recipient);

    error Unauthorized();
    error UnsupportedPoolType();
    error FailedToSendETH();
    error InvalidTokens();
    error RouteUnavailable();
    error AmountMismatch();
    error TokenMismatch();
    error RouteAlreadyExists();
    error ZeroInput();
}