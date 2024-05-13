1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
5 
6 import "../../interfaces/tokenomics/IBkdToken.sol";
7 
8 import "../../libraries/ScaledMath.sol";
9 import "../../libraries/Errors.sol";
10 
11 contract BkdToken is IBkdToken, ERC20 {
12     using ScaledMath for uint256;
13 
14     address public immutable minter;
15 
16     constructor(
17         string memory name_,
18         string memory symbol_,
19         address _minter
20     ) ERC20(name_, symbol_) {
21         minter = _minter;
22     }
23 
24     /**
25      * @notice Mints tokens for a given address.
26      * @dev Fails if msg.sender is not the minter.
27      * @param account Account for which tokens should be minted.
28      * @param amount Amount of tokens to mint.
29      */
30     function mint(address account, uint256 amount) external override {
31         require(msg.sender == minter, Error.UNAUTHORIZED_ACCESS);
32         _mint(account, amount);
33     }
34 }
