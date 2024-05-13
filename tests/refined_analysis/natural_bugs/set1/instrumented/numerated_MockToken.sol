1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
9 import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
10 import {ERC20Permit} from "../tokens/ERC20/ERC20Permit.sol";
11 
12 /**
13  * @author Publius
14  * @title Mock Token
15 **/
16 contract MockToken is ERC20, ERC20Burnable, ERC20Permit {
17 
18     uint8 private _decimals = 18;
19     string private _symbol = "MOCK";
20     string private _name = "MockToken";
21 
22     constructor(string memory name, string memory __symbol)
23     ERC20(name, __symbol)
24     ERC20Permit(name)
25     { }
26 
27     function mint(address account, uint256 amount) external returns (bool) {
28         _mint(account, amount);
29         return true;
30     }
31 
32     function burnFrom(address account, uint256 amount) public override(ERC20Burnable) {
33         ERC20Burnable.burnFrom(account, amount);
34     }
35 
36     function burn(uint256 amount) public override {
37         ERC20Burnable.burn(amount);
38     }
39 
40     function setDecimals(uint256 dec) public {
41         _decimals = uint8(dec);
42     }
43 
44     function decimals() public view virtual override returns (uint8) {
45         return _decimals;
46     }
47 
48     function setSymbol(string memory sym) public {
49         _symbol = sym;
50     }
51 
52     function symbol() public view virtual override returns (string memory) {
53         return _symbol;
54     }
55     
56     function setName(string memory name_) public {
57         _name = name_;
58     }
59 }