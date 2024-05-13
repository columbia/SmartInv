1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 
8 /**
9  * @title IBean
10  * @author Publius
11  * @notice Bean Interface
12  */
13 abstract contract IBean is IERC20 {
14     function burn(uint256 amount) public virtual;
15     function burnFrom(address account, uint256 amount) public virtual;
16     function mint(address account, uint256 amount) public virtual;
17     function symbol() public view virtual returns (string memory);
18 }
