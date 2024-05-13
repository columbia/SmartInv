1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-upgradeable-4.7.3/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
6 import "@openzeppelin/contracts-upgradeable-4.7.3/access/OwnableUpgradeable.sol";
7 import "./interfaces/ISwapV2.sol";
8 
9 /**
10  * @title Liquidity Provider Token
11  * @notice This token is an ERC20 detailed token with added capability to be minted by the owner.
12  * It is used to represent user's shares when providing liquidity to swap contracts.
13  * @dev Only Swap contracts should initialize and own LPToken contracts.
14  */
15 contract LPTokenV2 is ERC20BurnableUpgradeable, OwnableUpgradeable {
16     /**
17      * @notice Initializes this LPToken contract with the given name and symbol
18      * @dev The caller of this function will become the owner. A Swap contract should call this
19      * in its initializer function.
20      * @param name name of this token
21      * @param symbol symbol of this token
22      */
23     function initialize(string memory name, string memory symbol)
24         external
25         initializer
26         returns (bool)
27     {
28         __Context_init_unchained();
29         __ERC20_init_unchained(name, symbol);
30         __Ownable_init_unchained();
31         return true;
32     }
33 
34     /**
35      * @notice Mints the given amount of LPToken to the recipient.
36      * @dev only owner can call this mint function
37      * @param recipient address of account to receive the tokens
38      * @param amount amount of tokens to mint
39      */
40     function mint(address recipient, uint256 amount) external onlyOwner {
41         require(amount != 0, "LPToken: cannot mint 0");
42         _mint(recipient, amount);
43     }
44 
45     /**
46      * @dev Overrides ERC20._beforeTokenTransfer() which get called on every transfers including
47      * minting and burning. This ensures that Swap.updateUserWithdrawFees are called everytime.
48      * This assumes the owner is set to a Swap contract's address.
49      */
50     function _beforeTokenTransfer(
51         address from,
52         address to,
53         uint256 amount
54     ) internal virtual override(ERC20Upgradeable) {
55         super._beforeTokenTransfer(from, to, amount);
56         require(to != address(this), "LPToken: cannot send to itself");
57     }
58 }
