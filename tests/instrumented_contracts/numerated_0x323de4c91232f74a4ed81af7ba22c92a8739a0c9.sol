1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * See https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address _who) public view returns (uint256);
63   function transfer(address _to, uint256 _value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) internal balances;
76 
77   uint256 internal totalSupply_;
78 
79   /**
80   * @dev Total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev Transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_value <= balances[msg.sender]);
93     require(_to != address(0));
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256) {
107     return balances[_owner];
108   }
109 }
110 
111 
112 /**
113  * @title Burnable Token
114  * @dev Token that can be irreversibly burned (destroyed).
115  */
116 contract BurnableToken is BasicToken {
117 
118   event Burn(address indexed burner, uint256 value);
119 
120   /**
121    * @dev Burns a specific amount of tokens.
122    * @param _value The amount of token to be burned.
123    */
124   function burn(uint256 _value) public {
125     _burn(msg.sender, _value);
126   }
127 
128   function _burn(address _who, uint256 _value) internal {
129     require(_value <= balances[_who]);
130     // no need to require value <= totalSupply, since that would imply the
131     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
132 
133     balances[_who] = balances[_who].sub(_value);
134     totalSupply_ = totalSupply_.sub(_value);
135     emit Burn(_who, _value);
136     emit Transfer(_who, address(0), _value);
137   }
138 }
139 
140 
141 contract UniGoldToken is BurnableToken {
142   address public minter;
143   string public name = "UniGoldCoin";
144   string public symbol = "UGCС";
145   uint8 public decimals = 4;
146 
147   event Mint(address indexed to, uint256 amount);
148 
149   /**
150    * @dev constructor sets the 'minter'
151    * account.
152    */
153   constructor(address _minter) public {
154     minter = _minter;
155   }
156 
157   /**
158    * @dev Throws if called by any account other than the minter.
159    */
160   modifier onlyMinter() {
161     require(msg.sender == minter);
162     _;
163   }
164 
165   /**
166    * @dev Function to mint tokens
167    * @param _to The address that will receive the minted tokens.
168    * @param _amount The amount of tokens to mint.
169    * @return A boolean that indicates if the operation was successful.
170    */
171   function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
172     totalSupply_ = totalSupply_.add(_amount);
173     balances[_to] = balances[_to].add(_amount);
174     emit Mint(_to, _amount);
175     emit Transfer(address(0), _to, _amount);
176     return true;
177   }
178 }