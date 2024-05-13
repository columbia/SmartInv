1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 // Inheritance
5 import "./SwappableToken.sol";
6 import "./MintableToken.sol";
7 
8 
9 /// @title   Umbrella Rewards contract
10 /// @author  umb.network
11 /// @notice  This is reward UMB token (rUMB)
12 /// @dev     Rewards tokens are used for farming and other rewards distributions.
13 abstract contract rUMB is MintableToken, SwappableToken {
14     // ========== STATE VARIABLES ========== //
15 
16     // ========== CONSTRUCTOR ========== //
17 
18     constructor (
19         address _owner,
20         address _initialHolder,
21         uint256 _initialBalance,
22         uint256 _maxAllowedTotalSupply,
23         uint256 _swapDuration,
24         string memory _name,
25         string memory _symbol
26     )
27     Owned(_owner)
28     ERC20(_name, _symbol)
29     MintableToken(_maxAllowedTotalSupply)
30     SwappableToken(_maxAllowedTotalSupply, _swapDuration) {
31         if (_initialHolder != address(0) && _initialBalance != 0) {
32             _mint(_initialHolder, _initialBalance);
33         }
34     }
35 }
