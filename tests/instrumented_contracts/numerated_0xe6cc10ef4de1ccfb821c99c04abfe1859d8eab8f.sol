1 pragma solidity ^0.4.24;
2 
3 pragma solidity ^0.4.24;
4 
5 pragma solidity ^0.4.24;
6 
7 
8 pragma solidity ^0.4.24;
9 
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * See https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address _who) public view returns (uint256);
19   function transfer(address _to, uint256 _value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 pragma solidity ^0.4.24;
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
36     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
37     // benefit is lost if 'b' is also tested.
38     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39     if (_a == 0) {
40       return 0;
41     }
42 
43     c = _a * _b;
44     assert(c / _a == _b);
45     return c;
46   }
47 
48   /**
49   * @dev Integer division of two numbers, truncating the quotient.
50   */
51   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     // assert(_b > 0); // Solidity automatically throws when dividing by 0
53     // uint256 c = _a / _b;
54     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
55     return _a / _b;
56   }
57 
58   /**
59   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
60   */
61   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
62     assert(_b <= _a);
63     return _a - _b;
64   }
65 
66   /**
67   * @dev Adds two numbers, throws on overflow.
68   */
69   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
70     c = _a + _b;
71     assert(c >= _a);
72     return c;
73   }
74 }
75 
76 
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances.
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) internal balances;
86 
87   uint256 internal totalSupply_;
88 
89   /**
90   * @dev Total number of tokens in existence
91   */
92   function totalSupply() public view returns (uint256) {
93     return totalSupply_;
94   }
95 
96   /**
97   * @dev Transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_value <= balances[msg.sender]);
103     require(_to != address(0));
104 
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     emit Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 
123 
124 /**
125  * @title Burnable Token
126  * @dev Token that can be irreversibly burned (destroyed).
127  */
128 contract BurnableToken is BasicToken {
129 
130   event Burn(address indexed burner, uint256 value);
131 
132   /**
133    * @dev Burns a specific amount of tokens.
134    * @param _value The amount of token to be burned.
135    */
136   function burn(uint256 _value) public {
137     _burn(msg.sender, _value);
138   }
139 
140   function _burn(address _who, uint256 _value) internal {
141     require(_value <= balances[_who]);
142     // no need to require value <= totalSupply, since that would imply the
143     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
144 
145     balances[_who] = balances[_who].sub(_value);
146     totalSupply_ = totalSupply_.sub(_value);
147     emit Burn(_who, _value);
148     emit Transfer(_who, address(0), _value);
149   }
150 }
151 
152 
153 contract ExenToken is BurnableToken {
154 
155 	string public name = "ExenToken";
156 	string public symbol = "EXEN";
157 	uint8 public decimals = 2;
158 	uint public INITIAL_SUPPLY = 1500000000;
159 
160 	constructor() public {
161 	  totalSupply_ = INITIAL_SUPPLY;
162 	  balances[msg.sender] = INITIAL_SUPPLY;
163 	}
164 
165 }