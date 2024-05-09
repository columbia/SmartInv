1 pragma solidity ^0.4.23;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 
16 
17 
18 /**
19  * @title ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic {
23 
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30 
31   function approve(address spender, uint256 value) public returns (bool);
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 
40 
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47 
48   /**
49   * @dev Multiplies two numbers, throws on overflow.
50   */
51   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
53     // benefit is lost if 'b' is also tested.
54     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55     if (a == 0) {
56       return 0;
57     }
58 
59     c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers, truncating the quotient.
66   */
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     // uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return a / b;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   /**
83   * @dev Adds two numbers, throws on overflow.
84   */
85   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
86     c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   uint256 totalSupply_;
103 
104   /**
105   * @dev Total number of tokens in existence
106   */
107   function totalSupply() public view returns (uint256) {
108     return totalSupply_;
109   }
110 
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, BasicToken {
132 
133   mapping (address => mapping (address => uint256)) internal allowed;
134 
135   address master;
136 
137   bool public paused;
138 
139   modifier isMaster {
140       require(msg.sender == master);
141       _;
142   }
143 
144   modifier isPause {
145    require(paused == true);
146    _;
147  }
148 
149   modifier isNotPause {
150    require(paused == false);
151    _;
152   }
153 
154   /**
155   * @dev Transfer token for a specified address
156   * @param _to The address to transfer to.
157   * @param _value The amount to be transferred.
158   */
159   function transfer(address _to, uint256 _value) public isNotPause returns (bool) {
160     require(_to != address(0));
161     require(_value <= balances[msg.sender]);
162 
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     emit Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _value
180   )
181     public isNotPause
182     returns (bool)
183   {
184     require(_to != address(0));
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    *
198    * Beware that changing an allowance with this method brings the risk that someone may use both the old
199    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) public isNotPause returns (bool) {
206     require(_spender != address(0));
207     allowed[msg.sender][_spender] = _value;
208     emit Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(
219     address _owner,
220     address _spender
221    )
222     public
223     view
224     returns (uint256)
225   {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * @dev Increase the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To increment
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _addedValue The amount of tokens to increase the allowance by.
238    */
239   function increaseApproval(
240     address _spender,
241     uint _addedValue
242   )
243     public isNotPause
244     returns (bool)
245   {
246     require(_spender != address(0));
247     allowed[msg.sender][_spender] = (
248       allowed[msg.sender][_spender].add(_addedValue));
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   /**
254    * @dev Decrease the amount of tokens that an owner allowed to a spender.
255    *
256    * approve should be called when allowed[_spender] == 0. To decrement
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _subtractedValue The amount of tokens to decrease the allowance by.
262    */
263   function decreaseApproval(
264     address _spender,
265     uint _subtractedValue
266   )
267     public isNotPause
268     returns (bool)
269   {
270     require(_spender != address(0));
271     uint oldValue = allowed[msg.sender][_spender];
272     if (_subtractedValue > oldValue) {
273       allowed[msg.sender][_spender] = 0;
274     } else {
275       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
276     }
277     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281 }
282 
283 
284 contract GascToken is StandardToken {
285 
286   string public constant name = "GameCube ToKen";
287   string public constant symbol = "GASC";
288   uint8 public constant decimals = 18;
289 
290   uint256 public constant INITIAL_SUPPLY = 5000000000 * (10 ** uint256(decimals));
291 
292   address private constant coinbase_address       = 0x180038c6Db5aC2d2eA6dbB306EA245e95C7F0fB6;
293   uint8 private constant coinbase_percent         = 100;
294 
295   /**
296   * @dev Constructor that gives msg.sender all of existing tokens.
297   */
298   constructor(address _master) public {
299    require(_master != address(0));
300    totalSupply_ = INITIAL_SUPPLY;
301    master = _master;
302    paused = false;
303    balances[coinbase_address]       = INITIAL_SUPPLY * coinbase_percent / 100;
304  }
305 
306   function batchTransfer(address[] _to, uint256[] _amount) public isNotPause returns (bool) {
307      for (uint i = 0; i < _to.length; i++) {
308        transfer(_to[i] , _amount[i]);
309      }
310      return true;
311    }
312 
313    function setPause() public isMaster isNotPause{
314      paused = true;
315    }
316 
317    function setResume() public isMaster isPause{
318      paused = false;
319    }
320 
321    function pauseStatus() public view isMaster returns (bool){
322      return paused;
323    }
324 
325 
326 
327 }