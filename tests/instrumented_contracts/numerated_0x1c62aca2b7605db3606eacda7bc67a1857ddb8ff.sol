1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
6  */
7 contract ERC20 {
8 
9   /// @return total amount of tokens
10   function totalSupply() public view returns (uint256);
11 
12   /// @param who The address from which the balance will be retrieved
13   /// @return The balance
14   function balanceOf(address who) public view returns (uint256);
15 
16   /// @notice send `_value` token to `_to` from `msg.sender`
17   /// @param to The address of the recipient
18   /// @param value The amount of token to be transferred
19   /// @return Whether the transfer was successful or not
20   function transfer(address to, uint256 value) public returns (bool);
21 
22   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23   /// @param from The address of the sender
24   /// @param to The address of the recipient
25   /// @param value The amount of token to be transferred
26   /// @return Whether the transfer was successful or not
27   function transferFrom(address from, address to, uint256 value) public returns (bool);
28 
29   /// @param owner The address of the account owning tokens
30   /// @param spender The address of the account able to transfer the tokens
31   /// @return Amount of remaining tokens allowed to spent
32   function allowance(address owner, address spender) public view returns (uint256);
33 
34   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
35   /// @param spender The address of the account able to transfer the tokens
36   /// @param value The amount of wei to be approved for transfer
37   /// @return Whether the approval was successful or not
38   function approve(address spender, uint256 value) public returns (bool);
39 
40   event Transfer(address indexed from, address indexed to, uint256 value);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 
90 
91 /**
92 * @title Standard ERC20 token
93 *
94 * @dev Implementation of the basic standard token.
95 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
96 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97 * @dev Based on https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
98 */
99 contract Token is ERC20 {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106   uint256 totalSupply_;
107 
108   /**
109   * @dev total number of tokens in existence
110   */
111   function totalSupply() public view returns (uint256) {
112     return totalSupply_;
113   }
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) public returns (bool) {
121     require(_to != address(0));
122     require(_value <= balances[msg.sender]);
123 
124     // SafeMath.sub will throw if there is not enough balance.
125     balances[msg.sender] = balances[msg.sender].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     emit Transfer(msg.sender, _to, _value);
128     return true;
129   }
130 
131   /**
132   * @dev Gets the balance of the specified address.
133   * @param _owner The address to query the the balance of.
134   * @return An uint256 representing the amount owned by the passed address.
135   */
136   function balanceOf(address _owner) public view returns (uint256 balance) {
137     return balances[_owner];
138   }
139 
140   /**
141   * @dev Transfer tokens from one address to another
142   * @param _from address The address which you want to send tokens from
143   * @param _to address The address which you want to transfer to
144   * @param _value uint256 the amount of tokens to be transferred
145   */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     emit Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     emit Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 
224 contract Soniq is ERC20, Token {
225 
226   string public constant name    = "Soniq Token";  //The Token's name - Soniq Token
227   uint8 public constant decimals = 18;               //Number of decimals of the smallest unit
228   string public constant symbol  = "SONIQ";            //An identifier - soniq
229   uint public INITIAL_SUPPLY     = 50000000 * 10 ** 18;  //
230 
231   function Soniq() public {
232     totalSupply_ = INITIAL_SUPPLY;
233     balances[0x5D51f2983272eca5e0E2503A52Bc41168B5d3314] = INITIAL_SUPPLY;
234   }
235 
236 }