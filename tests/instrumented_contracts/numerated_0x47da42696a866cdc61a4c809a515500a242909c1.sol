1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract BITVesting is Ownable {
81 
82     BITToken public token;
83     uint256 public releaseDate;
84 
85     function BITVesting (
86         BITToken _token,
87         address _beneficiary,
88         uint256 _releaseDate
89         ) public {
90 
91         token = _token;
92         releaseDate = _releaseDate;
93         owner = _beneficiary;
94     }
95 
96     /* After vesting period, this function transfers all available tokens
97      * from it's account to `_recipient` address. This address could either be
98      * a wallet or another smart contract. If the transfer was successful, it
99      * selfdestructs the contract.
100      */
101     function claim (
102         address _recipient,
103         bytes _data
104         ) external onlyOwner returns (bool success) {
105 
106         require(_recipient != address(0));
107         require(block.timestamp > releaseDate);
108         uint256 funds = token.balanceOf(this);
109         require(token.transfer(_recipient, funds));
110         // require(token.transfer(_recipient, funds, _data)); // ERC-20 compatible string
111         selfdestruct(msg.sender);
112         return true;
113     }
114 
115     /* From: https://github.com/ethereum/EIPs/issues/223
116      *
117      * A function for handling token transfers, which is called from the token
118      * contract, when a token holder sends tokens. `_from` is the address of the
119      * sender of the token, `_value` is the amount of incoming tokens, and
120      * `_data` is attached data similar to `msg.data` of Ether transactions.
121      * It works by analogy with the fallback function of Ether transactions and
122      * returns nothing.
123      */
124     function tokenFallback(
125         address _from,
126         uint _value,
127         bytes _data
128         ) external view {
129 
130         require(msg.sender == address(token));
131     }
132 }
133 
134 contract Pausable is Ownable {
135   event Pause();
136   event Unpause();
137 
138   bool public paused = false;
139 
140 
141   /**
142    * @dev Modifier to make a function callable only when the contract is not paused.
143    */
144   modifier whenNotPaused() {
145     require(!paused);
146     _;
147   }
148 
149   /**
150    * @dev Modifier to make a function callable only when the contract is paused.
151    */
152   modifier whenPaused() {
153     require(paused);
154     _;
155   }
156 
157   /**
158    * @dev called by the owner to pause, triggers stopped state
159    */
160   function pause() onlyOwner whenNotPaused public {
161     paused = true;
162     emit Pause();
163   }
164 
165   /**
166    * @dev called by the owner to unpause, returns to normal state
167    */
168   function unpause() onlyOwner whenPaused public {
169     paused = false;
170     emit Unpause();
171   }
172 }
173 
174 contract ERC20Basic {
175   function totalSupply() public view returns (uint256);
176   function balanceOf(address who) public view returns (uint256);
177   function transfer(address to, uint256 value) public returns (bool);
178   event Transfer(address indexed from, address indexed to, uint256 value);
179 }
180 
181 contract BasicToken is ERC20Basic {
182   using SafeMath for uint256;
183 
184   mapping(address => uint256) balances;
185 
186   uint256 totalSupply_;
187 
188   /**
189   * @dev total number of tokens in existence
190   */
191   function totalSupply() public view returns (uint256) {
192     return totalSupply_;
193   }
194 
195   /**
196   * @dev transfer token for a specified address
197   * @param _to The address to transfer to.
198   * @param _value The amount to be transferred.
199   */
200   function transfer(address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[msg.sender]);
203 
204     balances[msg.sender] = balances[msg.sender].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     emit Transfer(msg.sender, _to, _value);
207     return true;
208   }
209 
210   /**
211   * @dev Gets the balance of the specified address.
212   * @param _owner The address to query the the balance of.
213   * @return An uint256 representing the amount owned by the passed address.
214   */
215   function balanceOf(address _owner) public view returns (uint256 balance) {
216     return balances[_owner];
217   }
218 
219 }
220 
221 contract ERC20 is ERC20Basic {
222   function allowance(address owner, address spender) public view returns (uint256);
223   function transferFrom(address from, address to, uint256 value) public returns (bool);
224   function approve(address spender, uint256 value) public returns (bool);
225   event Approval(address indexed owner, address indexed spender, uint256 value);
226 }
227 
228 contract StandardToken is ERC20, BasicToken {
229 
230   mapping (address => mapping (address => uint256)) internal allowed;
231 
232 
233   /**
234    * @dev Transfer tokens from one address to another
235    * @param _from address The address which you want to send tokens from
236    * @param _to address The address which you want to transfer to
237    * @param _value uint256 the amount of tokens to be transferred
238    */
239   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
240     require(_to != address(0));
241     require(_value <= balances[_from]);
242     require(_value <= allowed[_from][msg.sender]);
243 
244     balances[_from] = balances[_from].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
247     emit Transfer(_from, _to, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253    *
254    * Beware that changing an allowance with this method brings the risk that someone may use both the old
255    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
256    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
257    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258    * @param _spender The address which will spend the funds.
259    * @param _value The amount of tokens to be spent.
260    */
261   function approve(address _spender, uint256 _value) public returns (bool) {
262     allowed[msg.sender][_spender] = _value;
263     emit Approval(msg.sender, _spender, _value);
264     return true;
265   }
266 
267   /**
268    * @dev Function to check the amount of tokens that an owner allowed to a spender.
269    * @param _owner address The address which owns the funds.
270    * @param _spender address The address which will spend the funds.
271    * @return A uint256 specifying the amount of tokens still available for the spender.
272    */
273   function allowance(address _owner, address _spender) public view returns (uint256) {
274     return allowed[_owner][_spender];
275   }
276 
277   /**
278    * @dev Increase the amount of tokens that an owner allowed to a spender.
279    *
280    * approve should be called when allowed[_spender] == 0. To increment
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _addedValue The amount of tokens to increase the allowance by.
286    */
287   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
288     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    *
296    * approve should be called when allowed[_spender] == 0. To decrement
297    * allowed value is better to use this function to avoid 2 calls (and wait until
298    * the first transaction is mined)
299    * From MonolithDAO Token.sol
300    * @param _spender The address which will spend the funds.
301    * @param _subtractedValue The amount of tokens to decrease the allowance by.
302    */
303   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
304     uint oldValue = allowed[msg.sender][_spender];
305     if (_subtractedValue > oldValue) {
306       allowed[msg.sender][_spender] = 0;
307     } else {
308       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
309     }
310     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314 }
315 
316 contract MintableToken is StandardToken, Ownable {
317   event Mint(address indexed to, uint256 amount);
318   event MintFinished();
319 
320   bool public mintingFinished = false;
321 
322 
323   modifier canMint() {
324     require(!mintingFinished);
325     _;
326   }
327 
328   /**
329    * @dev Function to mint tokens
330    * @param _to The address that will receive the minted tokens.
331    * @param _amount The amount of tokens to mint.
332    * @return A boolean that indicates if the operation was successful.
333    */
334   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
335     totalSupply_ = totalSupply_.add(_amount);
336     balances[_to] = balances[_to].add(_amount);
337     emit Mint(_to, _amount);
338     emit Transfer(address(0), _to, _amount);
339     return true;
340   }
341 
342   /**
343    * @dev Function to stop minting new tokens.
344    * @return True if the operation was successful.
345    */
346   function finishMinting() onlyOwner canMint public returns (bool) {
347     mintingFinished = true;
348     emit MintFinished();
349     return true;
350   }
351 }
352 
353 contract PausableToken is StandardToken, Pausable {
354 
355   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
356     return super.transfer(_to, _value);
357   }
358 
359   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
360     return super.transferFrom(_from, _to, _value);
361   }
362 
363   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
364     return super.approve(_spender, _value);
365   }
366 
367   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
368     return super.increaseApproval(_spender, _addedValue);
369   }
370 
371   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
372     return super.decreaseApproval(_spender, _subtractedValue);
373   }
374 }
375 
376 contract BITToken is MintableToken, PausableToken {
377 
378     event Vested(address indexed beneficiary, address indexed vestingContract, uint256 releaseDate, uint256 amount);
379     event BITTransfer(address indexed _from, address indexed _to, uint256 _value, bytes32 data);
380 
381     uint256 public constant decimals = 18;
382     string public constant name = "BitRewards Token";
383     string public constant symbol = "BIT";
384 
385     function BITToken () public MintableToken() {
386 
387     }
388 
389     function transfer (address _to, uint256 _value, bytes32 _data) public returns(bool res) {
390         if (PausableToken.transfer(_to, _value)) {
391             emit BITTransfer(msg.sender, _to, _value, _data);
392             return true;
393         }
394     }
395 
396     function transferFrom (address _from, address _to, uint256 _value, bytes32 _data) public returns(bool res) {
397         if (PausableToken.transferFrom(_from, _to, _value)) {
398             emit BITTransfer(_from, _to, _value, _data);
399             return true;
400         }
401     }
402 
403 
404     function vest(
405         address _beneficiary,
406         uint256 _releaseDate,
407         uint256 _amount
408     )
409         public onlyOwner canMint returns (address)
410     {
411         address vestingContract = new BITVesting(
412             this,
413             _beneficiary,
414             _releaseDate
415         );
416         assert (vestingContract != 0x0);
417         require(mint(vestingContract, _amount));
418         emit Vested(_beneficiary, address(vestingContract), _releaseDate, _amount);
419         return vestingContract;
420     }
421 }