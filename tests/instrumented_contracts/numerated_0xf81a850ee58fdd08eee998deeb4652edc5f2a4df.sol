1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public view returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   uint256 totalSupply_;
79 
80   /**
81   * @dev total number of tokens in existence
82   */
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[msg.sender]);
95 
96     // SafeMath.sub will throw if there is not enough balance.
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * @dev https://github.com/ethereum/EIPs/issues/20
119  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public view returns (uint256) {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * @dev Increase the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To increment
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _addedValue The amount of tokens to increase the allowance by.
179    */
180   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
181     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186   /**
187    * @dev Decrease the amount of tokens that an owner allowed to a spender.
188    *
189    * approve should be called when allowed[_spender] == 0. To decrement
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    * @param _spender The address which will spend the funds.
194    * @param _subtractedValue The amount of tokens to decrease the allowance by.
195    */
196   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
197     uint oldValue = allowed[msg.sender][_spender];
198     if (_subtractedValue > oldValue) {
199       allowed[msg.sender][_spender] = 0;
200     } else {
201       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
202     }
203     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 
207 }
208 
209 /**
210  * @title SportX
211  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
212  * Note they can later distribute these tokens as they wish using `transfer` and other
213  * `StandardToken` functions.
214  */
215 contract SportX is StandardToken {
216 
217   string public constant name = "SPORT X"; // solium-disable-line uppercase
218   string public constant symbol = "SOX"; // solium-disable-line uppercase
219   uint8 public constant decimals = 4; // solium-disable-line uppercase
220 
221   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
222 
223   /**
224    * @dev Constructor that gives msg.sender all of existing tokens.
225    */
226   function SportX() public {
227     totalSupply_ = INITIAL_SUPPLY;
228     balances[msg.sender] = INITIAL_SUPPLY;
229     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
230   }
231 
232 }