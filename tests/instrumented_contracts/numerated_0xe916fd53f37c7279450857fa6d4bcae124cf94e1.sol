1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-10
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * Math operations with safety checks
9  */
10 library SafeMath {
11 function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14 
15         return c;
16     }
17 
18     /**
19      * @dev Returns the subtraction of two unsigned integers, reverting on
20      * overflow (when the result is negative).
21      *
22      * Counterpart to Solidity's `-` operator.
23      *
24      * Requirements:
25      * - Subtraction cannot overflow.
26      */
27     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
28         require(b <= a, "SafeMath: subtraction overflow");
29         uint256 c = a - b;
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the multiplication of two unsigned integers, reverting on
36      * overflow.
37      *
38      * Counterpart to Solidity's `*` operator.
39      *
40      * Requirements:
41      * - Multiplication cannot overflow.
42      */
43     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
44         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
45         // benefit is lost if 'b' is also tested.
46         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47         if (a == 0) {
48             return 0;
49         }
50 
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the integer division of two unsigned integers. Reverts on
59      * division by zero. The result is rounded towards zero.
60      *
61      * Counterpart to Solidity's `/` operator. Note: this function uses a
62      * `revert` opcode (which leaves remaining gas untouched) while Solidity
63      * uses an invalid opcode to revert (consuming all remaining gas).
64      *
65      * Requirements:
66      * - The divisor cannot be zero.
67      */
68     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
69         // Solidity only automatically asserts when dividing by 0
70         require(b > 0, "SafeMath: division by zero");
71         uint256 c = a / b;
72         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
79      * Reverts when dividing by zero.
80      *
81      * Counterpart to Solidity's `%` operator. This function uses a `revert`
82      * opcode (which leaves remaining gas untouched) while Solidity uses an
83      * invalid opcode to revert (consuming all remaining gas).
84      *
85      * Requirements:
86      * - The divisor cannot be zero.
87      */
88     function safeMod(uint256 a, uint256 b) internal pure returns (uint256) {
89         require(b != 0, "SafeMath: modulo by zero");
90         return a % b;
91     }
92 }
93 
94 contract DroneToken {
95     using SafeMath for uint256;
96     string public name;
97     string public symbol;
98     uint8 public decimals;
99     uint256 public totalSupply;
100 	address public owner;
101 
102     /* This creates an array with all balances */
103     mapping (address => uint256) public balanceOf;
104 	mapping (address => uint256) public freezeOf;
105     mapping (address => mapping (address => uint256)) public allowance;
106 
107     /* This generates a public event on the blockchain that will notify clients */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /* This notifies clients about the amount burnt */
111     event Burn(address indexed from, uint256 value);
112 
113 	/* This notifies clients about the amount frozen */
114     event Freeze(address indexed from, uint256 value);
115 
116 	/* This notifies clients about the amount unfrozen */
117     event Unfreeze(address indexed from, uint256 value);
118 
119     /* Initializes contract with initial supply tokens to the creator of the contract */
120     constructor(
121         uint256 initialSupply,
122         string memory tokenName,
123         uint8 decimalUnits,
124         string memory tokenSymbol
125         ) public {
126         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
127         totalSupply = initialSupply;                        // Update total supply
128         name = tokenName;                                   // Set the name for display purposes
129         symbol = tokenSymbol;                               // Set the symbol for display purposes
130         decimals = decimalUnits;                            // Amount of decimals for display purposes
131 		owner = msg.sender;
132     }
133 
134     /* Send coins */
135     function transfer(address _to, uint256 _value) public {
136         require(_to != address(0), "Cannot use zero address");
137         require(_value > 0, "Cannot use zero value");
138 
139         require (balanceOf[msg.sender] >= _value, "Balance not enough");           // Check if the sender has enough
140         require (balanceOf[_to] + _value >= balanceOf[_to], "Overflow" ); // Check for overflows
141         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
142         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
143         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
144     }
145 
146     /* Allow another contract to spend some tokens in your behalf */
147     function approve(address _spender, uint256 _value) public
148         returns (bool success) {
149 		require (_value > 0, "Cannot use zero");
150         allowance[msg.sender][_spender] = _value;
151         return true;
152     }
153 
154 
155     /* A contract attempts to get the coins */
156     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
157         require(_to != address(0), "Cannot use zero address");
158 		require(_value > 0, "Cannot use zero value");
159 		require( balanceOf[_from] >= _value, "Balance not enough" );
160         require( balanceOf[_to] + _value > balanceOf[_to], "Cannot overflows" );
161         require( _value <= allowance[_from][msg.sender], "Cannot over allowance" );
162         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
163         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
164         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
165         emit Transfer(_from, _to, _value);
166         return true;
167     }
168 
169 }