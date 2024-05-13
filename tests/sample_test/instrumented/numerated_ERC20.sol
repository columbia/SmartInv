1 1 pragma solidity ^0.5.0;
2 
3 2 import "./IERC20.sol";
4 3 import "./SafeMath.sol";
5 4 import "./Libraries/VeriSolContracts.sol"; //change 
6 
7 
8 5 /**
9 6  * A highly simplified Token to express basic specifications
10 7  * 
11 8  * - totalSupply() equals the Sum({balanceOf(a) | a is an address })
12 9  * 
13 10  */
14 11 contract ERC20 is IERC20 {
15 
16 12     mapping (address => uint256) private _balances;
17 13     uint256 private _totalSupply;
18 
19 
20 14     /**
21 15      * A dummy constructor
22 16      */
23 17     constructor (uint256 totalSupply) public {
24 18        _totalSupply = totalSupply;
25 19        _balances[msg.sender] = totalSupply;
26 20     }
27 
28 21     /**
29 22      * @dev See {IERC20-totalSupply}.
30 23      */
31 24     function totalSupply() public view returns (uint256) {
32 25         return _totalSupply;
33 26     }
34 
35 27     /**
36 28      * @dev See {IERC20-balanceOf}.
37 29      */
38 30     function balanceOf(address account) public view returns (uint256) {
39 31         return _balances[account];
40 32     }
41 
42 33     /**
43 34      * @dev See {IERC20-transfer}.
44 35      *
45 36      * Requirements:
46 37      *
47 38      * - `recipient` cannot be the zero address.
48 39      * - the caller must have a balance of at least `amount`.
49 40      */
50 41     function transfer(address recipient, uint256 amount) public returns (bool) {
51 42         uint oldBalanceSender = _balances[msg.sender];
52 
53 43         _transfer(msg.sender, recipient, amount); 
54 
55 44         // the following assertion will fail due to overflow when not using safemath
56 45         //   to detect it,  run with /modularArith flag
57 46         //   to prove it, run ERC20 with /modularArith flag
58 47         return true;
59 48     }
60 
61 49     /**
62 50      * @dev Moves tokens `amount` from `sender` to `recipient`.
63 51      *
64 52      * This is internal function is equivalent to {transfer}, and can be used to
65 53      * e.g. implement automatic token fees, slashing mechanisms, etc.
66 54      *
67 55      * Emits a {Transfer} evenst.
68 56      *
69 57      * Requirements:
70 58      *
71 59      * - `sender` cannot be the zero address.
72 60      * - `recipient` cannot be the zero address.
73 61      * - `sender` must have a balance of at least `amount`.
74 62      */
75 63     function _transfer(address sender, address recipient, uint256 amount) internal {
76 
77 64         _balances[sender] = SafeMath.sub(_balances[sender], amount);
78 			
79 65 		_balances[recipient] = _balances[recipient] + amount; // nosafemath //_balances[recipient] = _balances[recipient].add(amount);
80 66     }
81 67 }
