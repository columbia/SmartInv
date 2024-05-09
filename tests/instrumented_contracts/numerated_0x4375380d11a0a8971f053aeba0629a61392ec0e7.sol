1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     emit Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     emit Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
159     allowed[msg.sender][_spender] = _value;
160     emit Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public view returns (uint256) {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * @dev Increase the amount of tokens that an owner allowed to a spender.
176    *
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    * @param _spender The address which will spend the funds.
182    * @param _addedValue The amount of tokens to increase the allowance by.
183    */
184   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   /**
191    * @dev Decrease the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To decrement
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _subtractedValue The amount of tokens to decrease the allowance by.
199    */
200   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201     uint oldValue = allowed[msg.sender][_spender];
202     if (_subtractedValue > oldValue) {
203       allowed[msg.sender][_spender] = 0;
204     } else {
205       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206     }
207     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211 }
212 
213 /**
214  * @title PdxToken
215  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
216  * Note they can later distribute these tokens as they wish using `transfer` and other
217  * `StandardToken` functions.
218  */
219 contract PdxToken is StandardToken {
220 
221     string public constant name = "PdxToken"; // solium-disable-line uppercase
222     string public constant symbol = "PDX"; // solium-disable-line uppercase
223     uint8 public constant decimals = 18; // solium-disable-line uppercase
224 
225     uint256 public constant INITIAL_SUPPLY = (10 ** 10) * (10 ** uint256(decimals));
226 
227     /**
228     * @dev Constructor that gives msg.sender all of existing tokens.
229     */
230     constructor(address _target) public {
231         totalSupply_ = INITIAL_SUPPLY;
232         balances[_target] = INITIAL_SUPPLY;
233         emit Transfer(0x0, _target, INITIAL_SUPPLY);
234     }
235 
236 }