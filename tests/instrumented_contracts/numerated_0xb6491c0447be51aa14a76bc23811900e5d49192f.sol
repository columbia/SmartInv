1 /*************************************************
2 *                                                *
3 *   AirDrop Dapp                                 *
4 *   Developed by Phenom.Team "www.phenom.team"   *
5 *                                                *
6 *************************************************/
7 
8 pragma solidity ^0.4.24;
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that revert on error
13  */
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, reverts on overflow.
18   */
19   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
20     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
21     // benefit is lost if 'b' is also tested.
22     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23     if (_a == 0) {
24       return 0;
25     }
26 
27     uint256 c = _a * _b;
28     require(c / _a == _b);
29 
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
35   */
36   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
37     require(_b > 0); // Solidity only automatically asserts when dividing by 0
38     uint256 c = _a / _b;
39     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
40 
41     return c;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
48     require(_b <= _a);
49     uint256 c = _a - _b;
50 
51     return c;
52   }
53 
54   /**
55   * @dev Adds two numbers, reverts on overflow.
56   */
57   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
58     uint256 c = _a + _b;
59     require(c >= _a);
60 
61     return c;
62   }
63 
64   /**
65   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
66   * reverts when dividing by zero.
67   */
68   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b != 0);
70     
71     return a % b;
72   }
73 }
74 
75 /**
76  * @title Ownable
77  * @dev The Ownable contract has an owner address, and provides basic authorization control
78  * functions, this simplifies the implementation of "user permissions".
79  */
80 contract Ownable {
81   address public owner;
82 
83   /**
84    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85    * account.
86    */
87   constructor() public {
88     owner = tx.origin;
89   }
90 
91   /**
92    * @dev Throws if called by any account other than the owner.
93    */
94   modifier onlyOwner() {
95     require(msg.sender == owner);
96     _;
97   }
98 }
99 
100 /**
101  * @title ERC20
102  * @dev Standard of ERC20.
103  */
104 contract ERC20 is Ownable {
105   using SafeMath for uint256;
106 
107   uint public totalSupply;
108   string public name;
109   string public symbol;
110   uint8 public decimals;
111   bool public transferable;
112 
113   mapping(address => uint) balances;
114   mapping(address => mapping (address => uint)) allowed;
115 
116   /**
117   *   @dev Get balance of tokens holder
118   *   @param _holder        holder's address
119   *   @return               balance of investor
120   */
121   function balanceOf(address _holder) public view returns (uint) {
122        return balances[_holder];
123   }
124 
125  /**
126   *   @dev Send coins
127   *   throws on any error rather then return a false flag to minimize
128   *   user errors
129   *   @param _to           target address
130   *   @param _amount       transfer amount
131   *
132   *   @return true if the transfer was successful 
133   */
134   function transfer(address _to, uint _amount) public returns (bool) {
135       require(_to != address(0) && _to != address(this));
136       if (!transferable) {
137         require(msg.sender == owner);
138       }
139       balances[msg.sender] = balances[msg.sender].sub(_amount);  
140       balances[_to] = balances[_to].add(_amount);
141       emit Transfer(msg.sender, _to, _amount);
142       return true;
143   }
144 
145  /**
146   *   @dev An account/contract attempts to get the coins
147   *   throws on any error rather then return a false flag to minimize user errors
148   *
149   *   @param _from         source address
150   *   @param _to           target address
151   *   @param _amount       transfer amount
152   *
153   *   @return true if the transfer was successful
154   */
155   function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
156       require(_to != address(0) && _to != address(this));
157       balances[_from] = balances[_from].sub(_amount);
158       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
159       balances[_to] = balances[_to].add(_amount);
160       emit Transfer(_from, _to, _amount);
161       return true;
162    }
163 
164  /**
165   *   @dev Allows another account/contract to spend some tokens on its behalf
166   *   throws on any error rather then return a false flag to minimize user errors
167   *
168   *   also, to minimize the risk of the approve/transferFrom attack vector
169   *   approve has to be called twice in 2 separate transactions - once to
170   *   change the allowance to 0 and secondly to change it to the new allowance
171   *   value
172   *
173   *   @param _spender      approved address
174   *   @param _amount       allowance amount
175   *
176   *   @return true if the approval was successful
177   */
178   function approve(address _spender, uint _amount) public returns (bool) {
179       require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
180       allowed[msg.sender][_spender] = _amount;
181       emit Approval(msg.sender, _spender, _amount);
182       return true;
183   }
184 
185  /**
186   *   @dev Function to check the amount of tokens that an owner allowed to a spender.
187   *
188   *   @param _owner        the address which owns the funds
189   *   @param _spender      the address which will spend the funds
190   *
191   *   @return              the amount of tokens still avaible for the spender
192   */
193   function allowance(address _owner, address _spender) public view returns (uint) {
194       return allowed[_owner][_spender];
195   }
196 
197   /**
198   *   @dev Function make token transferable.
199   *
200   *   @return the status of issue
201   */
202   function unfreeze() public onlyOwner {
203       transferable = true;
204       emit Unfreezed(now);
205   }
206 
207   event Transfer(address indexed _from, address indexed _to, uint _value);
208   event Approval(address indexed _owner, address indexed _spender, uint _value);
209   event Unfreezed(uint indexed _timestamp);
210 }
211 
212 /**
213  * @title StandardToken
214  * @dev Token without the ability to release new ones.
215  */
216 contract StandardToken is ERC20 {
217   using SafeMath for uint256;
218 
219   /**
220   * @dev The Standard token constructor determines the total supply of tokens.
221   */
222   constructor(string _name, string _symbol, uint8 _decimals, uint _totalSupply, bool _transferable) public {   
223       name = _name;
224       symbol = _symbol;
225       decimals = _decimals;
226       totalSupply = _totalSupply;
227       balances[tx.origin] = _totalSupply;
228       transferable = _transferable;
229       emit Transfer(address(0), tx.origin, _totalSupply);
230   }
231 
232   /**
233   * @dev Sends the tokens to a list of addresses.
234   */
235   function airdrop(address[] _addresses, uint256[] _values) public onlyOwner returns (bool) {
236       require(_addresses.length == _values.length);
237       for (uint256 i = 0; i < _addresses.length; i++) {
238           require(transfer(_addresses[i], _values[i]));
239       }        
240       return true;
241   }
242 }
243 
244 /**
245  * @title MintableToken
246  * @dev Token with the ability to release new ones.
247  */
248 contract MintableToken is Ownable, ERC20 {
249   using SafeMath for uint256;
250 
251   bool public mintingFinished = false;
252 
253  /**
254   * @dev The Standard token constructor determines the total supply of tokens.
255   */
256   constructor(string _name, string _symbol, uint8 _decimals, bool _transferable) public {
257     name = _name;
258     symbol = _symbol;
259     decimals = _decimals;
260     transferable = _transferable;
261   }
262 
263   modifier canMint() {
264     require(!mintingFinished);
265     _;
266   }
267 
268  /**
269   *   @dev Function to mint tokens
270   *   @param _holder       beneficiary address the tokens will be issued to
271   *   @param _value        number of tokens to issue
272   */
273   function mintTokens(address _holder, uint _value) public canMint onlyOwner returns (bool) {
274      require(_value > 0);
275      require(_holder != address(0));
276      balances[_holder] = balances[_holder].add(_value);
277      totalSupply = totalSupply.add(_value);
278      emit Transfer(address(0), _holder, _value);
279      return true;
280   }
281 
282   /**
283   * @dev Sends the tokens to a list of addresses.
284   */
285   function airdrop(address[] _addresses, uint256[] _values) public onlyOwner returns (bool) {
286       require(_addresses.length == _values.length);
287       for (uint256 i = 0; i < _addresses.length; i++) {
288           require(mintTokens(_addresses[i], _values[i]));
289       }
290       return true;
291   }
292  
293   /**
294   *   @dev Function finishes minting tokens.
295   *
296   *   @return the status of issue
297   */
298   function finishMinting() public onlyOwner {
299       mintingFinished = true;
300       emit MintFinished(now);
301   }
302 
303   event MintFinished(uint indexed _timestamp);
304 }
305 
306 /**
307  * @title TokenCreator
308  * @dev Create new token ERC20.
309  */
310 contract TokenCreator {
311   using SafeMath for uint256;
312 
313   mapping(address => address[]) public mintableTokens;
314   mapping(address => address[]) public standardTokens;
315   mapping(address => uint256) public amountMintTokens;
316   mapping(address => uint256) public amountStandTokens;
317   
318   /**
319   *   @dev Function create standard token.
320   *
321   *   @return the address of new token.
322   */
323   function createStandardToken(string _name, string _symbol, uint8 _decimals, uint _totalSupply, bool _transferable) public returns (address) {
324     address token = new StandardToken(_name, _symbol, _decimals, _totalSupply, _transferable);
325     standardTokens[msg.sender].push(token);
326     amountStandTokens[msg.sender]++;
327     emit TokenCreated(msg.sender, token);
328     return token;
329   }
330 
331   /**
332   *   @dev Function create mintable token.
333   *
334   *   @return the address of new token.
335   */
336   function createMintableToken(string _name, string _symbol, uint8 _decimals, bool _transferable) public returns (address) {
337     address token = new MintableToken(_name, _symbol, _decimals, _transferable);
338     mintableTokens[msg.sender].push(token);
339     amountMintTokens[msg.sender]++;
340     emit TokenCreated(msg.sender, token);
341     return token;
342   }
343 
344   event TokenCreated(address indexed _creator, address indexed _token);
345 }