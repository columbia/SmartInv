1 pragma solidity ^0.4.24;
2 
3 
4 /** Site: wowsecret.net
5     Bitcointalk https://bitcointalk.org/index.php?topic=5114412.0
6      */
7      
8  /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
18     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (_a == 0) {
22       return 0;
23     }
24 
25     c = _a * _b;
26     assert(c / _a == _b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
34     // assert(_b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = _a / _b;
36     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
37     return _a / _b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
44     assert(_b <= _a);
45     return _a - _b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
52     c = _a + _b;
53     assert(c >= _a);
54     return c;
55   }
56 }
57 
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * See https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   function totalSupply() public view returns (uint256);
66   function balanceOf(address _who) public view returns (uint256);
67   function transfer(address _to, uint256 _value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) internal balances;
80 
81   uint256 internal totalSupply_;
82 
83   /**
84   * @dev Total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev Transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_value <= balances[msg.sender]);
97     require(_to != address(0));
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * https://github.com/ethereum/EIPs/issues/20
142  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(
156     address _from,
157     address _to,
158     uint256 _value
159   )
160     public
161     returns (bool)
162   {
163     require(_value <= balances[_from]);
164     require(_value <= allowed[_from][msg.sender]);
165     require(_to != address(0));
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
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     emit Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(
196     address _owner,
197     address _spender
198    )
199     public
200     view
201     returns (uint256)
202   {
203     return allowed[_owner][_spender];
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(
216     address _spender,
217     uint256 _addedValue
218   )
219     public
220     returns (bool)
221   {
222     allowed[msg.sender][_spender] = (
223       allowed[msg.sender][_spender].add(_addedValue));
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    * approve should be called when allowed[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseApproval(
238     address _spender,
239     uint256 _subtractedValue
240   )
241     public
242     returns (bool)
243   {
244     uint256 oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue >= oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 
257 /**
258  * @title SimpleToken
259  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
260  * Note they can later distribute these tokens as they wish using `transfer` and other
261  * `StandardToken` functions.
262  */
263 contract SimpleToken is StandardToken {
264 
265   string public constant name = "WOWcoin";
266   string public constant symbol = "WOW";
267   uint8 public constant decimals = 18;
268 
269   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
270 
271   /**
272    * @dev Constructor that gives msg.sender all of existing tokens.
273    */
274   constructor() public {
275     totalSupply_ = INITIAL_SUPPLY;
276     address initialAddress = 0x68957c70C72e175a9DaFebaA15999b38F22111B4;
277     balances[initialAddress] = INITIAL_SUPPLY;
278     emit Transfer(address(0), initialAddress, INITIAL_SUPPLY);
279   }
280 
281 }