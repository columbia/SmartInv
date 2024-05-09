1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   function totalSupply() public view returns (uint256);
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic, Ownable {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   uint256 totalSupply_;
80   
81   
82   mapping (address => bool) public frozenAccount;
83 
84   event FrozenFunds(address target, bool frozen);
85   
86     /**
87      * @notice `freeze? Prevent | Allow` `target` from sending tokens
88      * @param target Address to be frozen
89      * @param freeze either to freeze it or not
90      */
91     function freezeAccount(address target, bool freeze) onlyOwner public {
92         frozenAccount[target] = freeze;
93         emit FrozenFunds(target, freeze);
94     }
95 
96   /**
97   * @dev total number of tokens in existence
98   */
99   function totalSupply() public view returns (uint256) {
100     return totalSupply_;
101   }
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(!frozenAccount[msg.sender]);
110 
111     require(_to != address(0));
112     require(_value <= balances[msg.sender]);
113 
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     emit Transfer(msg.sender, _to, _value);
117     return true;
118   }
119 
120   /**
121   * @dev Gets the balance of the specified address.
122   * @param _owner The address to query the the balance of.
123   * @return An uint256 representing the amount owned by the passed address.
124   */
125   function balanceOf(address _owner) public view returns (uint256) {
126     return balances[_owner];
127   }
128 
129 }
130 
131 
132 /**
133  * @title SafeERC20
134  * @dev Wrappers around ERC20 operations that throw on failure.
135  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
136  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
137  */
138 library SafeERC20 {
139   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
140     assert(token.transfer(to, value));
141   }
142 
143   function safeTransferFrom(
144     ERC20 token,
145     address from,
146     address to,
147     uint256 value
148   )
149     internal
150   {
151     assert(token.transferFrom(from, to, value));
152   }
153 
154   function safeApprove(ERC20 token, address spender, uint256 value) internal {
155     assert(token.approve(spender, value));
156   }
157 }
158 
159 
160 /**
161  * @title SafeMath
162  * @dev Math operations with safety checks that throw on error
163  */
164 library SafeMath {
165 
166   /**
167   * @dev Multiplies two numbers, throws on overflow.
168   */
169   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
170     if (a == 0) {
171       return 0;
172     }
173     c = a * b;
174     assert(c / a == b);
175     return c;
176   }
177 
178   /**
179   * @dev Integer division of two numbers, truncating the quotient.
180   */
181   function div(uint256 a, uint256 b) internal pure returns (uint256) {
182     // assert(b > 0); // Solidity automatically throws when dividing by 0
183     // uint256 c = a / b;
184     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
185     return a / b;
186   }
187 
188   /**
189   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
190   */
191   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192     assert(b <= a);
193     return a - b;
194   }
195 
196   /**
197   * @dev Adds two numbers, throws on overflow.
198   */
199   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
200     c = a + b;
201     assert(c >= a);
202     return c;
203   }
204 }
205 
206 
207 /**
208  * @title Standard ERC20 token
209  *
210  * @dev Implementation of the basic standard token.
211  * @dev https://github.com/ethereum/EIPs/issues/20
212  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
213  */
214 contract StandardToken is ERC20, BasicToken {
215 
216   mapping (address => mapping (address => uint256)) internal allowed;
217 
218 
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param _from address The address which you want to send tokens from
222    * @param _to address The address which you want to transfer to
223    * @param _value uint256 the amount of tokens to be transferred
224    */
225   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
226     require(!frozenAccount[_from]);
227     
228     require(_to != address(0));
229     require(_value <= balances[_from]);
230     require(_value <= allowed[_from][msg.sender]);
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    *
242    * Beware that changing an allowance with this method brings the risk that someone may use both the old
243    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
244    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
245    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246    * @param _spender The address which will spend the funds.
247    * @param _value The amount of tokens to be spent.
248    */
249   function approve(address _spender, uint256 _value) public returns (bool) {
250     allowed[msg.sender][_spender] = _value;
251     emit Approval(msg.sender, _spender, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Function to check the amount of tokens that an owner allowed to a spender.
257    * @param _owner address The address which owns the funds.
258    * @param _spender address The address which will spend the funds.
259    * @return A uint256 specifying the amount of tokens still available for the spender.
260    */
261   function allowance(address _owner, address _spender) public view returns (uint256) {
262     return allowed[_owner][_spender];
263   }
264 
265   /**
266    * @dev Increase the amount of tokens that an owner allowed to a spender.
267    *
268    * approve should be called when allowed[_spender] == 0. To increment
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _addedValue The amount of tokens to increase the allowance by.
274    */
275   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
276     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
277     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281   /**
282    * @dev Decrease the amount of tokens that an owner allowed to a spender.
283    *
284    * approve should be called when allowed[_spender] == 0. To decrement
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param _spender The address which will spend the funds.
289    * @param _subtractedValue The amount of tokens to decrease the allowance by.
290    */
291   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
292     uint oldValue = allowed[msg.sender][_spender];
293     if (_subtractedValue > oldValue) {
294       allowed[msg.sender][_spender] = 0;
295     } else {
296       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297     }
298     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302 }
303 
304 
305 contract SUPM is BasicToken {
306   string public name = "SUPM"; 
307   string public symbol = "SUPM";
308   uint public decimals = 18;
309   uint public INITIAL_SUPPLY = 600000000 * (10 ** decimals);
310 
311 
312   event Burn(address indexed burner, uint256 value);
313 
314   constructor() public {
315     totalSupply_ = INITIAL_SUPPLY;
316     balances[msg.sender] = INITIAL_SUPPLY;
317   }
318 
319   /**
320   * @dev Airdrops SUPM tokens to the specified adresses
321   * @param _recipients The list of addresses to send to
322   * @param _balances Values corresponding to the addresses
323   */
324   function airdrop(address[] _recipients, uint256[] _balances) public onlyOwner{
325     require(_recipients.length == _balances.length);
326     for (uint i=0; i < _recipients.length; i++) {
327         transfer(_recipients[i], _balances[i]);
328     }
329   }
330 
331   /**
332    * @dev Burns a specific amount of tokens from yourself(The Owner)
333    * @param _value The amount of token to be burned.
334    */
335   function burnMe(uint256 _value) public onlyOwner{
336     burnFromAnotherAccount(msg.sender, _value);
337   }
338   
339   /**
340    * @dev Burns a specific amount of tokens from another address
341    * @param _who From whom the tokens should be burnt 
342    * @param _value The amount of token to be burned.
343    */
344   function burnFromAnotherAccount(address _who, uint256 _value) public onlyOwner {
345     require(_value <= balances[_who]);
346     // no need to require value <= totalSupply, since that would imply the
347     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
348 
349     balances[_who] = balances[_who].sub(_value);
350     totalSupply_ = totalSupply_.sub(_value);
351     emit Burn(_who, _value);
352     emit Transfer(_who, address(0), _value);
353   }
354   
355 
356 }