1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.0;
3 
4 import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
5 
6 /**
7  * @dev {ERC20} token, including:
8  *
9  *  - Preminted initial supply
10  *  - Ability for holders to burn (destroy) their tokens
11  *  - No access control mechanism (for minting/pausing) and hence no governance
12  *
13  * This contract uses {ERC20Burnable} to include burn capabilities - head to
14  * its documentation for details.
15  *
16  * _Available since v3.4._
17  */
18 contract BaconToken is ERC20Burnable {
19     /**
20      * @dev Mints `initialSupply` amount of token and transfers them to msg.sender.
21      *
22      * See {ERC20-constructor}.
23      */
24     constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
25        _mint(msg.sender, initialSupply);
26     }
27 }