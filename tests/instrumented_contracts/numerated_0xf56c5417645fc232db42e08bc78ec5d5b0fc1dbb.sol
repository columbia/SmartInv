1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * 
6  * Author: IceMan
7  * Telegram: ice_man0
8  * 
9  * Token Details:-
10  * Name: Canlead Token
11  * Symbol: CAND
12  * Decimals: 18
13  * Total Supply: 1,000,000,000
14  * 
15  */
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30     if (a == 0) {
31       return 0;
32     }
33 
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38   
39   
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75 
76   address public owner;
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82    constructor() public {
83     owner = 0xCfFF1E0475547Cb68217515568D6d399eF144Ea8; 
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address newOwner)public onlyOwner {
99     require(newOwner != address(0));
100     owner = newOwner;
101   }
102 }
103 
104 /**
105  * @title ERC20Basic
106  * @dev Simpler version of ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/179
108  */
109 contract ERC20Basic is Ownable {
110   uint256 public totalSupply;
111   function balanceOf(address who) public constant returns (uint256);
112   function transfer(address to, uint256 value) public returns (bool);
113   event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances.
119  */
120 contract BasicToken is ERC20Basic {
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124   
125   mapping (address => bool) public frozenAccount;
126   mapping(address => uint256) public lockAccounts;
127   
128   event FrozenFunds(
129       address target, 
130       bool frozen
131       );
132       
133   event AccountLocked(
134       address _addr, 
135       uint256 timePeriod
136       );
137   
138   event Burn(
139         address indexed burner, 
140         uint256 value
141         );
142     
143   
144     /**
145      * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
146      * @param target Address to be frozen
147      * @param freeze either to freeze it or not
148      */
149     function freezeAccount(address target, bool freeze) onlyOwner public {
150         frozenAccount[target] = freeze;
151         emit FrozenFunds(target, freeze);
152     }
153     
154  /**
155   * @dev Lock a specified address
156   * @notice Once an account is locked it can't be unlocked till the time period passes
157   * @param _addr The address to lock
158   * @param _timePeriod The time period to lock the account.
159   */
160     function lockAccount(address _addr, uint256 _timePeriod) onlyOwner public {
161         lockAccounts[_addr] = _timePeriod;
162         emit AccountLocked(_addr, _timePeriod);
163     }
164     
165 
166   /**
167    * @dev Function to burn tokens
168    * @param _who The address from which to burn tokens
169    * @param _amount The amount of tokens to burn
170    * 
171    */
172    function burnTokens(address _who, uint256 _amount) public onlyOwner {
173        require(balances[_who] >= _amount);
174        
175        balances[_who] = balances[_who].sub(_amount);
176        
177        totalSupply = totalSupply.sub(_amount);
178        
179        emit Burn(_who, _amount);
180        emit Transfer(_who, address(0), _amount);
181    }
182     
183   /**
184   * @dev transfer token for a specified address
185   * @param _to The address to transfer to.
186   * @param _value The amount to be transferred.
187   */
188   function transfer(address _to, uint256 _value)public returns (bool) {
189     require(now.add(1 * 1 hours) > lockAccounts[msg.sender] || lockAccounts[msg.sender] == 0);
190     require(!frozenAccount[msg.sender]);
191     
192     balances[msg.sender] = balances[msg.sender].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     emit Transfer(msg.sender, _to, _value);
195     return true;
196   }
197 
198   /**
199   * @dev Gets the balance of the specified address.
200   * @param _owner The address to query the the balance of.
201   * @return An uint256 representing the amount owned by the passed address.
202   */
203   function balanceOf(address _owner)public constant returns (uint256 balance) {
204     return balances[_owner];
205   }
206 
207 }
208 
209 /**
210  * @title ERC20 interface
211  */
212 contract ERC20 is ERC20Basic {
213   function allowance(address owner, address spender)
214     public view returns (uint256);
215 
216   function transferFrom(address from, address to, uint256 value)
217     public returns (bool);
218 
219   function approve(address spender, uint256 value) public returns (bool);
220   event Approval(
221     address indexed owner,
222     address indexed spender,
223     uint256 value
224   );
225 }
226 
227 /**
228  * @title Advance ERC20 token
229  * 
230  */
231 contract AdvanceToken is ERC20, BasicToken {
232 
233   mapping (address => mapping (address => uint256)) internal allowed;
234 
235 /**
236    * @dev Internal function that burns an amount of the token of a given
237    * account.
238    * @param _account The account whose tokens will be burnt.
239    * @param _amount The amount that will be burnt.
240    */
241   function _burn(address _account, uint256 _amount) internal {
242     require(_account != 0);
243     require(_amount <= balances[_account]);
244 
245     totalSupply = totalSupply.sub(_amount);
246     balances[_account] = balances[_account].sub(_amount);
247     emit Transfer(_account, address(0), _amount);
248   }
249 
250   /**
251    * @dev Internal function that burns an amount of the token of a given
252    * account, deducting from the sender's allowance for said account. Uses the
253    * internal _burn function.
254    * @param _account The account whose tokens will be burnt.
255    * @param _amount The amount that will be burnt.
256    */
257   function burnFrom(address _account, uint256 _amount) public {
258     require(_amount <= allowed[_account][msg.sender]);
259     require(!frozenAccount[_account]);
260 
261     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
262     // this function needs to emit an event with the updated approval.
263     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
264     _burn(_account, _amount);
265   }
266 
267   /**
268    * @dev Burns a specific amount of tokens.
269    * @param _value The amount of token to be burned.
270    */
271   function burn(uint256 _value) public {
272     _burn(msg.sender, _value);
273   }
274   
275   /**
276    * @dev Transfer tokens from one address to another
277    * @param _from address The address which you want to send tokens from
278    * @param _to address The address which you want to transfer to
279    * @param _value uint256 the amount of tokens to be transferred
280    */
281   function transferFrom(
282     address _from,
283     address _to,
284     uint256 _value
285   )
286     public
287     returns (bool)
288   {
289       
290     require(_to != address(0));
291     require(_value <= balances[_from]);
292     require(_value <= allowed[_from][msg.sender]);
293     require(!frozenAccount[_from]);                     // Check if sender is frozen
294     require(now.add(1 * 1 hours) > lockAccounts[_from] || lockAccounts[_from] == 0);
295 
296     balances[_from] = balances[_from].sub(_value);
297     balances[_to] = balances[_to].add(_value);
298     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
299     emit Transfer(_from, _to, _value);
300     return true;
301   }
302 
303   /**
304    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
305    *
306    * Beware that changing an allowance with this method brings the risk that someone may use both the old
307    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
308    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
309    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310    * @param _spender The address which will spend the funds.
311    * @param _value The amount of tokens to be spent.
312    */
313   function approve(address _spender, uint256 _value) public returns (bool) {
314     allowed[msg.sender][_spender] = _value;
315     emit Approval(msg.sender, _spender, _value);
316     return true;
317   }
318 
319   /**
320    * @dev Function to check the amount of tokens that an owner allowed to a spender.
321    * @param _owner address The address which owns the funds.
322    * @param _spender address The address which will spend the funds.
323    * @return A uint256 specifying the amount of tokens still available for the spender.
324    */
325   function allowance(
326     address _owner,
327     address _spender
328    )
329     public
330     view
331     returns (uint256)
332   {
333     return allowed[_owner][_spender];
334   }
335 
336   /**
337    * @dev Increase the amount of tokens that an owner allowed to a spender.
338    *
339    * approve should be called when allowed[_spender] == 0. To increment
340    * allowed value is better to use this function to avoid 2 calls (and wait until
341    * the first transaction is mined)
342    * From MonolithDAO Token.sol
343    * @param _spender The address which will spend the funds.
344    * @param _addedValue The amount of tokens to increase the allowance by.
345    */
346   function increaseApproval(
347     address _spender,
348     uint _addedValue
349   )
350     public
351     returns (bool)
352   {
353     allowed[msg.sender][_spender] = (
354       allowed[msg.sender][_spender].add(_addedValue));
355     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
356     return true;
357   }
358 
359   /**
360    * @dev Decrease the amount of tokens that an owner allowed to a spender.
361    *
362    * approve should be called when allowed[_spender] == 0. To decrement
363    * allowed value is better to use this function to avoid 2 calls (and wait until
364    * the first transaction is mined)
365    * From MonolithDAO Token.sol
366    * @param _spender The address which will spend the funds.
367    * @param _subtractedValue The amount of tokens to decrease the allowance by.
368    */
369   function decreaseApproval(
370     address _spender,
371     uint _subtractedValue
372   )
373     public
374     returns (bool)
375   {
376     uint oldValue = allowed[msg.sender][_spender];
377     if (_subtractedValue > oldValue) {
378       allowed[msg.sender][_spender] = 0;
379     } else {
380       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
381     }
382     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
383     return true;
384   }
385 
386 }
387 
388 contract CanleadToken is AdvanceToken {
389 
390   string public constant name = "Canlead Token";
391   string public constant symbol = "CAND";
392   uint256 public constant decimals = 18;
393 
394   uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**decimals;
395 
396   /**
397    * @dev Contructor
398    */
399   constructor() public {
400     totalSupply = INITIAL_SUPPLY;
401     balances[0xCfFF1E0475547Cb68217515568D6d399eF144Ea8] = INITIAL_SUPPLY;
402     emit Transfer(address(0), address(0xCfFF1E0475547Cb68217515568D6d399eF144Ea8),totalSupply);
403     
404   }
405   
406 }