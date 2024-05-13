1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import "@openzeppelin/contracts/access/Ownable.sol";
9 import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
10 
11 /**
12  * @author Publius
13  * @title MockSiloToken is a mintable ERC-20 Token.
14 **/
15 contract MockSiloToken is Ownable, ERC20Burnable  {
16 
17     using SafeMath for uint256;
18 
19     constructor()
20     ERC20("Bean3Crv", "BEAN3CRV")
21     { }
22 
23     function mint(address account, uint256 amount) public onlyOwner returns (bool) {
24         _mint(account, amount);
25         return true;
26     }
27 
28     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
29         _transfer(sender, recipient, amount);
30         if (allowance(sender, _msgSender()) != uint256(-1)) {
31             _approve(
32                 sender,
33                 _msgSender(),
34                 allowance(sender, _msgSender()).sub(amount, "Bean: Transfer amount exceeds allowance."));
35         }
36         return true;
37     }
38 
39     function decimals() public view virtual override returns (uint8) {
40         return 18;
41     }
42 
43 }
