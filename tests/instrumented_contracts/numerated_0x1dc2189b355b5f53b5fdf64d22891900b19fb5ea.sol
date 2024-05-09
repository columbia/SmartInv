1 pragma solidity 0.4.21;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
12     {
13         if (a == 0) 
14         {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) 
26     {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return a / b;
31     }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
37     {
38         assert(b <= a);
39         return a - b;
40     }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
46     {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53  /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     address public owner;
60 
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68 
69     function Ownable() public {
70         owner = msg.sender;
71     }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85     function transferOwnership(address newOwner) public onlyOwner {
86         require(newOwner != address(0));
87         emit OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89     }
90 
91 }
92 
93 /**
94  * @title Pausable
95  * @dev Base contract which allows children to implement an emergency stop mechanism.
96  */
97 contract Pausable is Ownable {
98     event Pause();
99     event Unpause();
100 
101     bool public paused = false;
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is not paused.
105    */
106     modifier whenNotPaused() {
107         require(!paused);
108         _;
109     }
110 
111   /**
112    * @dev Modifier to make a function callable only when the contract is paused.
113    */
114     modifier whenPaused() {
115         require(paused);
116         _;
117     }
118 
119   /**
120    * @dev called by the owner to pause, triggers stopped state
121    */
122     function pause() onlyOwner whenNotPaused public {
123         paused = true;
124         emit Pause();
125     }
126 
127   /**
128    * @dev called by the owner to unpause, returns to normal state
129    */
130     function unpause() onlyOwner whenPaused public {
131         paused = false;
132         emit Unpause();
133     }
134 }
135 
136 contract ERC20Basic {
137     function totalSupply() public view returns (uint256);
138     function balanceOf(address who) public view returns (uint256);
139     function transfer(address to, uint256 value) public returns (bool);
140     event Transfer(address indexed from, address indexed to, uint256 value);
141 }
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148     using SafeMath for uint256;
149 
150     mapping(address => uint256) balances;
151     string public name;
152     string public symbol;
153     uint8 public decimals = 18;
154     uint256 totalSupply_;
155 
156   /**
157   * @dev total number of tokens in existence
158   */
159     function totalSupply() public view returns (uint256) {
160         return totalSupply_;
161     }
162 
163   /**
164   * @dev transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168     function transfer(address _to, uint256 _value) public returns (bool) {
169         require(_to != address(0));
170         require(_value <= balances[msg.sender]);
171 
172         balances[msg.sender] = balances[msg.sender].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         emit Transfer(msg.sender, _to, _value);
175         return true;
176     }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183     function balanceOf(address _owner) public view returns (uint256) 
184     {
185         return balances[_owner];
186     }
187 
188 }
189 
190 // @title ERC20 interface
191 // @dev see https://github.com/ethereum/EIPs/issues/20
192 contract ERC20 is ERC20Basic {
193     function allowance(address owner, address spender) public view returns (uint256);
194     function transferFrom(address from, address to, uint256 value) public returns (bool);
195     function approve(address spender, uint256 value) public returns (bool);
196     event Approval(address indexed owner, address indexed spender, uint256 value);
197 }
198 
199 contract BurnableToken is BasicToken {
200     event Burn(address indexed burner, uint256 value);
201 
202   /**
203    * @dev Burns a specific amount of tokens.
204    * @param _value The amount of token to be burned.
205    */
206     function burn(uint256 _value) public {
207         _burn(msg.sender, _value);
208     }
209 
210     function _burn(address _who, uint256 _value) internal {
211         require(_value <= balances[_who]);  
212     // no need to require value <= totalSupply, since that would imply the
213     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
214         balances[_who] = balances[_who].sub(_value);
215         totalSupply_ = totalSupply_.sub(_value);
216         emit Burn(_who, _value);
217         emit Transfer(_who, address(0), _value);
218     }
219 }
220 
221 //@title Standard ERC20 token
222 //@dev Implementation of the basic standard token.
223 //@dev https://github.com/ethereum/EIPs/issues/20
224 //@dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
225 contract StandardToken is ERC20, BasicToken,Ownable{
226 
227     mapping (address => mapping (address => uint256)) internal allowed;
228 
229   /**
230    * @dev Transfer tokens from one address to another
231    * @param _from address The address which you want to send tokens from
232    * @param _to address The address which you want to transfer to
233    * @param _value uint256 the amout of tokens to be transfered
234    */
235     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
236         require(_to != address(0));
237         require(_value <= balances[_from]);
238         require(_value <= allowed[_from][msg.sender]);
239 
240         balances[_from] = balances[_from].sub(_value);
241         balances[_to] = balances[_to].add(_value);
242         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
243         emit Transfer(_from, _to, _value);
244         return true;
245     }
246 
247   /**
248    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249    *
250    * Beware that changing an allowance with this method brings the risk that someone may use both the old
251    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254    * @param _spender The address which will spend the funds.
255    * @param _value The amount of tokens to be spent.
256    */
257     function approve(address _spender, uint256 _value) public returns (bool) {
258         allowed[msg.sender][_spender] = _value;
259         emit Approval(msg.sender, _spender, _value);
260         return true;
261     }
262 
263   /**
264    * @dev Function to check the amount of tokens that an owner allowed to a spender.
265    * @param _owner address The address which owns the funds.
266    * @param _spender address The address which will spend the funds.
267    * @return A uint256 specifying the amount of tokens still available for the spender.
268    */
269     function allowance(address _owner, address _spender) public view returns (uint256) {
270         return allowed[_owner][_spender];
271     }
272 
273   /**
274    * @dev Increase the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To increment
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _addedValue The amount of tokens to increase the allowance by.
282    */
283     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
284         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
285         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286         return true;
287     }
288 
289   /**
290    * @dev Decrease the amount of tokens that an owner allowed to a spender.
291    *
292    * approve should be called when allowed[_spender] == 0. To decrement
293    * allowed value is better to use this function to avoid 2 calls (and wait until
294    * the first transaction is mined)
295    * From MonolithDAO Token.sol
296    * @param _spender The address which will spend the funds.
297    * @param _subtractedValue The amount of tokens to decrease the allowance by.
298    */
299     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
300         uint oldValue = allowed[msg.sender][_spender];
301         if (_subtractedValue > oldValue) 
302         {
303             allowed[msg.sender][_spender] = 0;
304         } else {
305             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
306         }
307         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308         return true;
309     }
310 
311 }
312 
313 /* ABE Token */
314 contract ABEToken is BurnableToken, StandardToken,Pausable {
315     /* This generates a public event on the blockchain that will notify clients */
316     /*It will invoke a public event in block chain, and inform client*/
317     mapping (address => bool) public frozenAccount;
318     event FrozenFunds(address target, bool frozen);
319     function ABEToken() public 
320     {
321         totalSupply_ = 10000000000 ether;//Total amount of tokens
322         balances[msg.sender] = totalSupply_;               //Initial tokens for owner
323         name = "ABE";             //for display
324         symbol = "ABE";                               //Symbol for display
325     }
326 
327 
328  /**
329   * @dev Burns a specific amount of tokens from the target address and decrements allowance
330  * @param _from address The address which you want to send tokens from
331   * @param _value uint256 The amount of token to be burned
332  */
333     function burnFrom(address _from, uint256 _value) public {
334         require(_value <= allowed[_from][msg.sender]);
335 		// Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
336 		// this function needs to emit an event with the updated approval.
337         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
338         _burn(_from, _value);
339     }
340     //Freeze an account (Owner only).
341     function freezeAccount(address target, bool freeze) onlyOwner public {
342         frozenAccount[target] = freeze;
343         emit FrozenFunds(target, freeze);
344     }
345     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
346         require(!frozenAccount[msg.sender]);               //Check if the sender is frozen.
347         return super.transfer(_to, _value);
348     }
349     //Send tokens to an account and froze the account immediately (Owner only).
350     function transferAndFrozen(address _to, uint256 _value) onlyOwner public whenNotPaused returns (bool) {
351         require(!frozenAccount[msg.sender]);               //Check if the sender is frozen.
352         bool Result = transfer(_to,_value);
353         freezeAccount(_to,true);
354         return Result;
355     }
356     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
357         require(!frozenAccount[_from]);                     //Check if the sender is frozen.
358         return super.transferFrom(_from, _to, _value);
359     }
360 
361     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
362         return super.approve(_spender, _value);
363     }
364 
365     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
366         return super.increaseApproval(_spender, _addedValue);
367     }
368 
369     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
370         return super.decreaseApproval(_spender, _subtractedValue);
371     }
372 }