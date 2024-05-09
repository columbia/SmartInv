1 pragma solidity ^0.5.0;

2 import "./IERC20.sol";
3 import "./SafeMath.sol";
4 import "./Libraries/VeriSolContracts.sol"; //change 


5 /**
6  * A highly simplified Token to express basic specifications
7  * 
8  * - totalSupply() equals the Sum({balanceOf(a) | a is an address })
9  * 
10  */
11 contract ERC20 is IERC20 {

12     mapping (address => uint256) private _balances;
13     uint256 private _totalSupply;


14     /**
15      * A dummy constructor
16      */
17     constructor (uint256 totalSupply) public {
18        _totalSupply = totalSupply;
19        _balances[msg.sender] = totalSupply;
20     }

21     /**
22      * @dev See {IERC20-totalSupply}.
23      */
24     function totalSupply() public view returns (uint256) {
25         return _totalSupply;
26     }

27     /**
28      * @dev See {IERC20-balanceOf}.
29      */
30     function balanceOf(address account) public view returns (uint256) {
31         return _balances[account];
32     }

33     /**
34      * @dev See {IERC20-transfer}.
35      *
36      * Requirements:
37      *
38      * - `recipient` cannot be the zero address.
39      * - the caller must have a balance of at least `amount`.
40      */
41     function transfer(address recipient, uint256 amount) public returns (bool) {
42         uint oldBalanceSender = _balances[msg.sender];

43         _transfer(msg.sender, recipient, amount); 

44         // the following assertion will fail due to overflow when not using safemath
45         //   to detect it,  run with /modularArith flag
46         //   to prove it, run ERC20 with /modularArith flag
47         return true;
48     }

49     /**
50      * @dev Moves tokens `amount` from `sender` to `recipient`.
51      *
52      * This is internal function is equivalent to {transfer}, and can be used to
53      * e.g. implement automatic token fees, slashing mechanisms, etc.
54      *
55      * Emits a {Transfer} evenst.
56      *
57      * Requirements:
58      *
59      * - `sender` cannot be the zero address.
60      * - `recipient` cannot be the zero address.
61      * - `sender` must have a balance of at least `amount`.
62      */
63     function _transfer(address sender, address recipient, uint256 amount) internal {

64         _balances[sender] = SafeMath.sub(_balances[sender], amount);
			
65 		_balances[recipient] = _balances[recipient] + amount; // nosafemath //_balances[recipient] = _balances[recipient].add(amount);
66     }
67 }
