1 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.18;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: zeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.18;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   /**
52   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 pragma solidity ^0.4.18;
72 
73 
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   uint256 totalSupply_;
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     // SafeMath.sub will throw if there is not enough balance.
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256 balance) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
122 
123 pragma solidity ^0.4.18;
124 
125 
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public view returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
139 
140 pragma solidity ^0.4.18;
141 
142 
143 
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) internal allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     Approval(msg.sender, _spender, _value);
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
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238 }
239 
240 // File: contracts/NapoleonXToken.sol
241 
242 pragma solidity ^0.4.17;
243 
244 
245 contract NapoleonXToken is StandardToken {
246   string public name = 'NapoleonX Token';
247   string public symbol = 'NPX';
248   uint8 public decimals = 2;
249   uint public INITIAL_SUPPLY = 2980000000;
250 
251   uint public endTime;
252   address napoleonXAdministrator;
253 
254   modifier only_napoleonXAdministrator {
255     require(msg.sender == napoleonXAdministrator);
256     _;
257   }
258 
259   modifier is_earlier_than(uint x) {
260       require(now < x);
261       _;
262   }
263 
264   function isEqualLength(address[] x, uint[] y) internal returns (bool) { return x.length == y.length; }
265   modifier onlySameLengthArray(address[] x, uint[] y) {
266       require(isEqualLength(x,y));
267       _;
268   }
269 
270   event TokenAllocated(address investor, uint tokenAmount);
271 
272   function NapoleonXToken(uint setEndTime) public {
273     napoleonXAdministrator = msg.sender;
274     totalSupply_= INITIAL_SUPPLY;
275     balances[napoleonXAdministrator] = INITIAL_SUPPLY;
276     endTime = setEndTime;
277   }
278 
279   function populateWhitelisted(address[] whitelisted, uint[] tokenAmount) onlySameLengthArray(whitelisted, tokenAmount) only_napoleonXAdministrator {
280     for (uint i = 0; i < whitelisted.length; i++) {
281         transferFrom(napoleonXAdministrator, whitelisted[i], tokenAmount[i]);
282     }
283   }
284 
285   function updateWhitelisted(address[] whitelisted, uint[] tokenAmount) is_earlier_than(endTime) only_napoleonXAdministrator onlySameLengthArray(whitelisted, tokenAmount) {
286     for (uint i = 0; i < whitelisted.length; i++) {
287       uint previousAmount = balances[whitelisted[i]];
288       balances[whitelisted[i]] = tokenAmount[i];
289       totalSupply_ = totalSupply_-previousAmount+tokenAmount[i];
290       TokenAllocated(whitelisted[i], tokenAmount[i]);
291     }
292 }
293 
294 function changeFounder(address newAdministrator) only_napoleonXAdministrator {
295     napoleonXAdministrator = newAdministrator;
296 }
297 
298 
299 
300 
301 }