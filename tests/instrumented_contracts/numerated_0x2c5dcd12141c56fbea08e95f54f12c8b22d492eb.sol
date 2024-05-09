1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 contract owned {
17     address public owner;
18 
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     function transferOwnership(address newOwner) onlyOwner public {
29         owner = newOwner;
30     }
31 
32     function getOwned() onlyOwner public view returns (address) {
33         return owner;
34     }
35 }
36 
37 
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that throw on error
42  */
43 library SafeMath {
44 
45   /**
46   * @dev Multiplies two numbers, throws on overflow.
47   */
48   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49     if (a == 0) {
50       return 0;
51     }
52     uint256 c = a * b;
53     assert(c / a == b);
54     return c;
55   }
56 
57   /**
58   * @dev Integer division of two numbers, truncating the quotient.
59   */
60   function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   /**
68   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
69   */
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   /**
76   * @dev Adds two numbers, throws on overflow.
77   */
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender) public view returns (uint256);
92   function transferFrom(address from, address to, uint256 value) public returns (bool);
93   function approve(address spender, uint256 value) public returns (bool);
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   uint256 totalSupply_;
108 
109   /**
110   * @dev total number of tokens in existence
111   */
112   function totalSupply() public view returns (uint256) {
113     return totalSupply_;
114   }
115 
116   /**
117   * @dev transfer token for a specified address
118   * @param _to The address to transfer to.
119   * @param _value The amount to be transferred.
120   */
121   function transfer(address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[msg.sender]);
124 
125     // SafeMath.sub will throw if there is not enough balance.
126     balances[msg.sender] = balances[msg.sender].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     emit Transfer(msg.sender, _to, _value);
129     return true;
130   }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137   function balanceOf(address _owner) public view returns (uint256 balance) {
138     return balances[_owner];
139   }
140 
141 }
142 
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken,owned {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     emit Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     require((_value == 0) || allowed[msg.sender][_spender]== 0);
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(address _owner, address _spender) public view returns (uint256) {
198     return allowed[_owner][_spender];
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _addedValue The amount of tokens to increase the allowance by.
210    */
211   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   /**
218    * @dev Decrease the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To decrement
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _subtractedValue The amount of tokens to decrease the allowance by.
226    */
227   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
228     uint oldValue = allowed[msg.sender][_spender];
229     if (_subtractedValue > oldValue) {
230       allowed[msg.sender][_spender] = 0;
231     } else {
232       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233     }
234     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237   
238   function mintToken( uint256 _value) onlyOwner public returns (bool) {
239     totalSupply_ += _value;
240         balances[msg.sender] += _value;
241         emit Transfer(0x0, msg.sender, _value);
242      return true;
243   }
244 
245 }
246 
247 
248 /**
249  * @title SimpleToken
250  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
251  * Note they can later distribute these tokens as they wish using `transfer` and other
252  * `StandardToken` functions.
253  */
254 contract USDCoinToken is StandardToken {
255 
256     string public constant name = "USDCoin"; // solium-disable-line uppercase
257     string public constant symbol = "USC"; // solium-disable-line uppercase
258     uint8 public constant decimals = 18; // solium-disable-line uppercase
259 
260     uint256 public constant INITIAL_SUPPLY = (100000) * (10 ** uint256(decimals));
261 
262     /**
263     * @dev Constructor that gives msg.sender all of existing tokens.
264     */
265     constructor() public {
266         totalSupply_ = INITIAL_SUPPLY;
267         balances[msg.sender] = INITIAL_SUPPLY;
268         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
269     }
270 
271 }