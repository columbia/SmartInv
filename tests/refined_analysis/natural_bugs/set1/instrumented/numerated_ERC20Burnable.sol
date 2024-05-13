1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
5 
6 import { IERC20Burnable } from "./interfaces/IERC20Burnable.sol";
7 
8 /**
9  * @dev this is an adapted clone of the OZ's ERC20Burnable extension which is unfortunately required so that it can be
10  * explicitly specified in interfaces via our new IERC20Burnable interface.
11  *
12  * We have also removed the explicit use of Context and updated the code to our style.
13  */
14 abstract contract ERC20Burnable is ERC20, IERC20Burnable {
15     /**
16      * @inheritdoc IERC20Burnable
17      */
18     function burn(uint256 amount) external virtual {
19         _burn(msg.sender, amount);
20     }
21 
22     /**
23      * @inheritdoc IERC20Burnable
24      */
25     function burnFrom(address recipient, uint256 amount) external virtual {
26         _approve(recipient, msg.sender, allowance(recipient, msg.sender) - amount);
27         _burn(recipient, amount);
28     }
29 }
