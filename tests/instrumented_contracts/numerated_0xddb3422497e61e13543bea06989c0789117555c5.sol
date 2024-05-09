1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipRenounced(address indexed previousOwner);
60   event OwnershipTransferred(
61     address indexed previousOwner,
62     address indexed newOwner
63   );
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   constructor() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to relinquish control of the contract.
84    */
85   function renounceOwnership() public onlyOwner {
86     emit OwnershipRenounced(owner);
87     owner = address(0);
88   }
89 
90   /**
91    * @dev Allows the current owner to transfer control of the contract to a newOwner.
92    * @param _newOwner The address to transfer ownership to.
93    */
94   function transferOwnership(address _newOwner) public onlyOwner {
95     _transferOwnership(_newOwner);
96   }
97 
98   /**
99    * @dev Transfers control of the contract to a newOwner.
100    * @param _newOwner The address to transfer ownership to.
101    */
102   function _transferOwnership(address _newOwner) internal {
103     require(_newOwner != address(0));
104     emit OwnershipTransferred(owner, _newOwner);
105     owner = _newOwner;
106   }
107 }
108 
109 contract HasNoEther is Ownable {
110 
111   /**
112   * @dev Constructor that rejects incoming Ether
113   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
114   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
115   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
116   * we could use assembly to access msg.value.
117   */
118   constructor() public payable {
119     require(msg.value == 0);
120   }
121 
122   /**
123    * @dev Disallows direct send by settings a default function without the `payable` flag.
124    */
125   function() external {
126   }
127 
128   /**
129    * @dev Transfer all Ether held by the contract to the owner.
130    */
131   function reclaimEther() external onlyOwner {
132     owner.transfer(address(this).balance);
133   }
134 }
135 
136 contract Claimable is Ownable {
137   address public pendingOwner;
138 
139   /**
140    * @dev Modifier throws if called by any account other than the pendingOwner.
141    */
142   modifier onlyPendingOwner() {
143     require(msg.sender == pendingOwner);
144     _;
145   }
146 
147   /**
148    * @dev Allows the current owner to set the pendingOwner address.
149    * @param newOwner The address to transfer ownership to.
150    */
151   function transferOwnership(address newOwner) onlyOwner public {
152     pendingOwner = newOwner;
153   }
154 
155   /**
156    * @dev Allows the pendingOwner address to finalize the transfer.
157    */
158   function claimOwnership() onlyPendingOwner public {
159     emit OwnershipTransferred(owner, pendingOwner);
160     owner = pendingOwner;
161     pendingOwner = address(0);
162   }
163 }
164 
165 contract ERC20Basic {
166   function totalSupply() public view returns (uint256);
167   function balanceOf(address who) public view returns (uint256);
168   function transfer(address to, uint256 value) public returns (bool);
169   event Transfer(address indexed from, address indexed to, uint256 value);
170 }
171 
172 contract BasicToken is ERC20Basic {
173   using SafeMath for uint256;
174 
175   mapping(address => uint256) balances;
176 
177   uint256 totalSupply_;
178 
179   /**
180   * @dev total number of tokens in existence
181   */
182   function totalSupply() public view returns (uint256) {
183     return totalSupply_;
184   }
185 
186   /**
187   * @dev transfer token for a specified address
188   * @param _to The address to transfer to.
189   * @param _value The amount to be transferred.
190   */
191   function transfer(address _to, uint256 _value) public returns (bool) {
192     require(_to != address(0));
193     require(_value <= balances[msg.sender]);
194 
195     balances[msg.sender] = balances[msg.sender].sub(_value);
196     balances[_to] = balances[_to].add(_value);
197     emit Transfer(msg.sender, _to, _value);
198     return true;
199   }
200 
201   /**
202   * @dev Gets the balance of the specified address.
203   * @param _owner The address to query the the balance of.
204   * @return An uint256 representing the amount owned by the passed address.
205   */
206   function balanceOf(address _owner) public view returns (uint256) {
207     return balances[_owner];
208   }
209 
210 }
211 
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
227 contract StandardToken is ERC20, BasicToken {
228 
229   mapping (address => mapping (address => uint256)) internal allowed;
230 
231 
232   /**
233    * @dev Transfer tokens from one address to another
234    * @param _from address The address which you want to send tokens from
235    * @param _to address The address which you want to transfer to
236    * @param _value uint256 the amount of tokens to be transferred
237    */
238   function transferFrom(
239     address _from,
240     address _to,
241     uint256 _value
242   )
243     public
244     returns (bool)
245   {
246     require(_to != address(0));
247     require(_value <= balances[_from]);
248     require(_value <= allowed[_from][msg.sender]);
249 
250     balances[_from] = balances[_from].sub(_value);
251     balances[_to] = balances[_to].add(_value);
252     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
253     emit Transfer(_from, _to, _value);
254     return true;
255   }
256 
257   /**
258    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
259    *
260    * Beware that changing an allowance with this method brings the risk that someone may use both the old
261    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
262    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
263    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
264    * @param _spender The address which will spend the funds.
265    * @param _value The amount of tokens to be spent.
266    */
267   function approve(address _spender, uint256 _value) public returns (bool) {
268     allowed[msg.sender][_spender] = _value;
269     emit Approval(msg.sender, _spender, _value);
270     return true;
271   }
272 
273   /**
274    * @dev Function to check the amount of tokens that an owner allowed to a spender.
275    * @param _owner address The address which owns the funds.
276    * @param _spender address The address which will spend the funds.
277    * @return A uint256 specifying the amount of tokens still available for the spender.
278    */
279   function allowance(
280     address _owner,
281     address _spender
282    )
283     public
284     view
285     returns (uint256)
286   {
287     return allowed[_owner][_spender];
288   }
289 
290   /**
291    * @dev Increase the amount of tokens that an owner allowed to a spender.
292    *
293    * approve should be called when allowed[_spender] == 0. To increment
294    * allowed value is better to use this function to avoid 2 calls (and wait until
295    * the first transaction is mined)
296    * From MonolithDAO Token.sol
297    * @param _spender The address which will spend the funds.
298    * @param _addedValue The amount of tokens to increase the allowance by.
299    */
300   function increaseApproval(
301     address _spender,
302     uint _addedValue
303   )
304     public
305     returns (bool)
306   {
307     allowed[msg.sender][_spender] = (
308       allowed[msg.sender][_spender].add(_addedValue));
309     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310     return true;
311   }
312 
313   /**
314    * @dev Decrease the amount of tokens that an owner allowed to a spender.
315    *
316    * approve should be called when allowed[_spender] == 0. To decrement
317    * allowed value is better to use this function to avoid 2 calls (and wait until
318    * the first transaction is mined)
319    * From MonolithDAO Token.sol
320    * @param _spender The address which will spend the funds.
321    * @param _subtractedValue The amount of tokens to decrease the allowance by.
322    */
323   function decreaseApproval(
324     address _spender,
325     uint _subtractedValue
326   )
327     public
328     returns (bool)
329   {
330     uint oldValue = allowed[msg.sender][_spender];
331     if (_subtractedValue > oldValue) {
332       allowed[msg.sender][_spender] = 0;
333     } else {
334       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
335     }
336     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
337     return true;
338   }
339 
340 }
341 
342 contract MintableToken is StandardToken, Ownable {
343   event Mint(address indexed to, uint256 amount);
344   event MintFinished();
345 
346   bool public mintingFinished = false;
347 
348 
349   modifier canMint() {
350     require(!mintingFinished);
351     _;
352   }
353 
354   modifier hasMintPermission() {
355     require(msg.sender == owner);
356     _;
357   }
358 
359   /**
360    * @dev Function to mint tokens
361    * @param _to The address that will receive the minted tokens.
362    * @param _amount The amount of tokens to mint.
363    * @return A boolean that indicates if the operation was successful.
364    */
365   function mint(
366     address _to,
367     uint256 _amount
368   )
369     hasMintPermission
370     canMint
371     public
372     returns (bool)
373   {
374     totalSupply_ = totalSupply_.add(_amount);
375     balances[_to] = balances[_to].add(_amount);
376     emit Mint(_to, _amount);
377     emit Transfer(address(0), _to, _amount);
378     return true;
379   }
380 
381   /**
382    * @dev Function to stop minting new tokens.
383    * @return True if the operation was successful.
384    */
385   function finishMinting() onlyOwner canMint public returns (bool) {
386     mintingFinished = true;
387     emit MintFinished();
388     return true;
389   }
390 }
391 
392 contract BurnableToken is BasicToken {
393 
394   event Burn(address indexed burner, uint256 value);
395 
396   /**
397    * @dev Burns a specific amount of tokens.
398    * @param _value The amount of token to be burned.
399    */
400   function burn(uint256 _value) public {
401     _burn(msg.sender, _value);
402   }
403 
404   function _burn(address _who, uint256 _value) internal {
405     require(_value <= balances[_who]);
406     // no need to require value <= totalSupply, since that would imply the
407     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
408 
409     balances[_who] = balances[_who].sub(_value);
410     totalSupply_ = totalSupply_.sub(_value);
411     emit Burn(_who, _value);
412     emit Transfer(_who, address(0), _value);
413   }
414 }
415 
416 contract Coti is HasNoEther, Claimable, MintableToken, BurnableToken {
417     string public constant name = "COTI Token";
418     string public constant symbol = "COTI";
419     uint8 public constant decimals = 18;
420 
421 }