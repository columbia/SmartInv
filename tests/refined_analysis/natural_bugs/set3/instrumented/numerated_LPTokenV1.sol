1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20BurnableUpgradeable.sol";
6 import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
7 import "./interfaces/ISwapV1.sol";
8 
9 /**
10  * @title Liquidity Provider Token
11  * @notice This token is an ERC20 detailed token with added capability to be minted by the owner.
12  * It is used to represent user's shares when providing liquidity to swap contracts.
13  * @dev Only Swap contracts should initialize and own LPToken contracts.
14  */
15 contract LPTokenV1 is ERC20BurnableUpgradeable, OwnableUpgradeable {
16     using SafeMathUpgradeable for uint256;
17 
18     /**
19      * @notice Initializes this LPToken contract with the given name and symbol
20      * @dev The caller of this function will become the owner. A Swap contract should call this
21      * in its initializer function.
22      * @param name name of this token
23      * @param symbol symbol of this token
24      */
25     function initialize(string memory name, string memory symbol)
26         external
27         initializer
28         returns (bool)
29     {
30         __Context_init_unchained();
31         __ERC20_init_unchained(name, symbol);
32         __Ownable_init_unchained();
33         return true;
34     }
35 
36     /**
37      * @notice Mints the given amount of LPToken to the recipient.
38      * @dev only owner can call this mint function
39      * @param recipient address of account to receive the tokens
40      * @param amount amount of tokens to mint
41      */
42     function mint(address recipient, uint256 amount) external onlyOwner {
43         require(amount != 0, "LPToken: cannot mint 0");
44         _mint(recipient, amount);
45     }
46 
47     /**
48      * @dev Overrides ERC20._beforeTokenTransfer() which get called on every transfers including
49      * minting and burning. This ensures that Swap.updateUserWithdrawFees are called everytime.
50      * This assumes the owner is set to a Swap contract's address.
51      */
52     function _beforeTokenTransfer(
53         address from,
54         address to,
55         uint256 amount
56     ) internal virtual override(ERC20Upgradeable) {
57         super._beforeTokenTransfer(from, to, amount);
58         require(to != address(this), "LPToken: cannot send to itself");
59         ISwapV1(owner()).updateUserWithdrawFee(to, amount);
60     }
61 }
