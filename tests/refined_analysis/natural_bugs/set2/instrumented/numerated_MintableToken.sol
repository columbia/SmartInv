1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 // Inheritance
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
7 
8 import "../interfaces/Owned.sol";
9 import "../interfaces/IBurnableToken.sol";
10 
11 /// @title   Umbrella Rewards contract
12 /// @author  umb.network
13 /// @notice  This contract allows to mint tokens and burn key (renounceOwnership)
14 /// @dev     Can be use used with MultiSig as owner
15 abstract contract MintableToken is Owned, ERC20, IBurnableToken {
16     using SafeMath for uint256;
17 
18     // ========== STATE VARIABLES ========== //
19 
20     uint256 public maxAllowedTotalSupply;
21 
22     // ========== CONSTRUCTOR ========== //
23 
24     constructor (uint256 _maxAllowedTotalSupply) {
25         require(_maxAllowedTotalSupply != 0, "_maxAllowedTotalSupply is empty");
26         maxAllowedTotalSupply = _maxAllowedTotalSupply;
27     }
28 
29     // ========== MODIFIERS ========== //
30 
31     modifier assertMaxSupply(uint256 _amountToMint) {
32         require(totalSupply().add(_amountToMint) <= maxAllowedTotalSupply, "total supply limit exceeded");
33         _;
34     }
35 
36     // ========== MUTATIVE FUNCTIONS ========== //
37 
38     function burn(uint256 _amount) override external {
39         uint balance = balanceOf(msg.sender);
40         require(_amount <= balance, "not enough tokens to burn");
41 
42         _burn(msg.sender, _amount);
43         maxAllowedTotalSupply = maxAllowedTotalSupply - _amount;
44     }
45 
46     // ========== RESTRICTED FUNCTIONS ========== //
47 
48     function mint(address _holder, uint256 _amount)
49     external
50     onlyOwner()
51     assertMaxSupply(_amount) {
52         require(_amount > 0, "zero amount");
53 
54         _mint(_holder, _amount);
55     }
56 }
