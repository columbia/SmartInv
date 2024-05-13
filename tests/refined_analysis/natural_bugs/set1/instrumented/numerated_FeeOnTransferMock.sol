1 //SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.4;
3 
4 import "../../libraries/MathLib.sol";
5 import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
6 import "@openzeppelin/contracts/access/Ownable.sol";
7 
8 /**
9  * @notice DO NOT USE IN PRODUCTION. FOR TEST PURPOSES ONLY.
10  * This token burns a fee on transfer and is used for testing fee on transfer tokens in ElasticSwap only
11  */
12 contract FeeOnTransferMock is ERC20PresetFixedSupply, Ownable {
13     using MathLib for uint256;
14 
15     uint256 public constant FEE_IN_BASIS_POINTS = 30;
16     uint256 public constant BASIS_POINTS = 10000;
17 
18     constructor(
19         string memory name,
20         string memory symbol,
21         uint256 initialSupply,
22         address owner
23     ) ERC20PresetFixedSupply(name, symbol, initialSupply, owner) {}
24 
25     function transfer(address recipient, uint256 amount)
26         public
27         virtual
28         override
29         returns (bool)
30     {
31         uint256 feeAmount = (amount * FEE_IN_BASIS_POINTS) / BASIS_POINTS;
32         _transfer(_msgSender(), recipient, amount - feeAmount);
33         _burn(_msgSender(), feeAmount);
34         return true;
35     }
36 
37     function transferFrom(
38         address sender,
39         address recipient,
40         uint256 amount
41     ) public virtual override returns (bool) {
42         uint256 feeAmount = (amount * FEE_IN_BASIS_POINTS) / BASIS_POINTS;
43         _transfer(sender, recipient, amount - feeAmount);
44         _burn(sender, feeAmount);
45 
46         uint256 currentAllowance = allowance(sender, _msgSender());
47         require(
48             currentAllowance >= amount,
49             "ERC20: transfer amount exceeds allowance"
50         );
51         _approve(sender, _msgSender(), currentAllowance - amount);
52 
53         return true;
54     }
55 }
