1 pragma solidity ^0.5.0;
2 
3 import "./IERC20.sol";
4 
5 /**
6  * @dev Optional functions from the ERC20 standard.
7  * Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20Detailed.sol
8  */
9 contract ERC20Detailed is IERC20 {
10     string private _name;
11     string private _symbol;
12     uint8 private _decimals;
13 
14     /**
15      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
16      * these values are immutable: they can only be set once during
17      * construction.
18      */
19     constructor (string memory name, string memory symbol, uint8 decimals) public {
20         _name = name;
21         _symbol = symbol;
22         _decimals = decimals;
23     }
24 
25     /**
26      * @dev Returns the name of the token.
27      */
28     function name() public view returns (string memory) {
29         return _name;
30     }
31 
32     /**
33      * @dev Returns the symbol of the token, usually a shorter version of the
34      * name.
35      */
36     function symbol() public view returns (string memory) {
37         return _symbol;
38     }
39 
40     /**
41      * @dev Returns the number of decimals used to get its user representation.
42      * For example, if `decimals` equals `2`, a balance of `505` tokens should
43      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
44      *
45      * Tokens usually opt for a value of 18, imitating the relationship between
46      * Ether and Wei.
47      *
48      * NOTE: This information is only used for _display_ purposes: it in
49      * no way affects any of the arithmetic of the contract, including
50      * {IERC20-balanceOf} and {IERC20-transfer}.
51      */
52     function decimals() public view returns (uint8) {
53         return _decimals;
54     }
55 }
