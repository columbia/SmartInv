1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error.
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 /**
69  * @title Secondary
70  * @dev A Secondary contract can only be used by its primary account (the one that created it)
71  */
72 contract Secondary {
73   address private _primary;
74 
75   /**
76    * @dev Sets the primary account to the one that is creating the Secondary contract.
77    */
78   constructor() public {
79     _primary = msg.sender;
80   }
81 
82   /**
83    * @dev Reverts if called from any account other than the primary.
84    */
85   modifier onlyPrimary() {
86     require(msg.sender == _primary);
87     _;
88   }
89 
90   function primary() public view returns (address) {
91     return _primary;
92   }
93 
94   function transferPrimary(address recipient) public onlyPrimary {
95     require(recipient != address(0));
96 
97     _primary = recipient;
98   }
99 }
100 
101  /**
102   * @title Escrow
103   * @dev Base escrow contract, holds funds designated for a payee until they
104   * withdraw them.
105   * @dev Intended usage: This contract (and derived escrow contracts) should be a
106   * standalone contract, that only interacts with the contract that instantiated
107   * it. That way, it is guaranteed that all Ether will be handled according to
108   * the Escrow rules, and there is no need to check for payable functions or
109   * transfers in the inheritance tree. The contract that uses the escrow as its
110   * payment method should be its primary, and provide public methods redirecting
111   * to the escrow's deposit and withdraw.
112   */
113 contract Escrow is Secondary {
114     using SafeMath for uint256;
115 
116     event Deposited(address indexed payee, uint256 weiAmount);
117     event Withdrawn(address indexed payee, uint256 weiAmount);
118 
119     mapping(address => uint256) private _deposits;
120 
121     function depositsOf(address payee) public view returns (uint256) {
122         return _deposits[payee];
123     }
124 
125     /**
126      * @dev Stores the sent amount as credit to be withdrawn.
127      * @param payee The destination address of the funds.
128      */
129     function deposit(address payee) public onlyPrimary payable {
130         uint256 amount = msg.value;
131         _deposits[payee] = _deposits[payee].add(amount);
132 
133         emit Deposited(payee, amount);
134     }
135 
136     /**
137      * @dev Withdraw accumulated balance for a payee.
138      * @param payee The address whose funds will be withdrawn and transferred to.
139      */
140     function withdraw(address payable payee) public onlyPrimary {
141         uint256 payment = _deposits[payee];
142 
143         _deposits[payee] = 0;
144 
145         payee.transfer(payment);
146 
147         emit Withdrawn(payee, payment);
148     }
149 }