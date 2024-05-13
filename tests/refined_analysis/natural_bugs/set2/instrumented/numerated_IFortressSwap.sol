1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IFortressSwap {
5 
6     /// @notice swap _amount of _fromToken to _toToken.
7     /// @param _fromToken The address of the token to swap from.
8     /// @param _toToken The address of the token to swap to.
9     /// @param _amount The amount of _fromToken to swap.
10     /// @return _amount The amount of _toToken after swap.  
11     function swap(address _fromToken, address _toToken, uint256 _amount) external payable returns (uint256);
12 
13     /********************************** Events & Errors **********************************/
14 
15     event Swap(address indexed _fromToken, address indexed _toToken, uint256 _amount);
16     event UpdateRoute(address indexed fromToken, address indexed toToken, address[] indexed poolAddress);
17     event DeleteRoute(address indexed fromToken, address indexed toToken);
18     event UpdateOwner(address indexed _newOwner);
19     event Rescue(address[] indexed _tokens, address indexed _recipient);
20     event RescueETH(address indexed _recipient);
21 
22     error Unauthorized();
23     error UnsupportedPoolType();
24     error FailedToSendETH();
25     error InvalidTokens();
26     error RouteUnavailable();
27     error AmountMismatch();
28     error TokenMismatch();
29     error RouteAlreadyExists();
30     error ZeroInput();
31 }