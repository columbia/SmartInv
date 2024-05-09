1 pragma solidity 0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41     c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 contract ERC20Basic {
47   function totalSupply() public view returns (uint256);
48   function balanceOf(address who) public view returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54   mapping(address => uint256) balances;
55   uint256 totalSupply_;
56   /**
57   * @dev Total number of tokens in existence
58   */
59   function totalSupply() public view returns (uint256) {
60     return totalSupply_;
61   }
62   /**
63   * @dev Transfer token for a specified address
64   * @param _to The address to transfer to.
65   * @param _value The amount to be transferred.
66   */
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_value <= balances[msg.sender]);
69     require(_to != address(0));
70     balances[msg.sender] = balances[msg.sender].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     emit Transfer(msg.sender, _to, _value);
73     return true;
74   }
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public view returns (uint256) {
81     return balances[_owner];
82   }
83 }
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender)
86     public view returns (uint256);
87   function transferFrom(address from, address to, uint256 value)
88     public returns (bool);
89   function approve(address spender, uint256 value) public returns (bool);
90   event Approval(
91     address indexed owner,
92     address indexed spender,
93     uint256 value
94   );
95 }
96 contract Ownable {
97   address public owner;
98   event OwnershipRenounced(address indexed previousOwner);
99   event OwnershipTransferred(
100     address indexed previousOwner,
101     address indexed newOwner
102   );
103   /**
104    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105    * account.
106    */
107   constructor() public {
108     owner = msg.sender;
109   }
110   /**
111    * @dev Throws if called by any account other than the owner.
112    */
113   modifier onlyOwner() {
114     require(msg.sender == owner);
115     _;
116   }
117   /**
118    * @dev Allows the current owner to relinquish control of the contract.
119    * @notice Renouncing to ownership will leave the contract without an owner.
120    * It will not be possible to call the functions with the `onlyOwner`
121    * modifier anymore.
122    */
123   function renounceOwnership() public onlyOwner {
124     emit OwnershipRenounced(owner);
125     owner = address(0);
126   }
127   /**
128    * @dev Allows the current owner to transfer control of the contract to a newOwner.
129    * @param _newOwner The address to transfer ownership to.
130    */
131   function transferOwnership(address _newOwner) public onlyOwner {
132     _transferOwnership(_newOwner);
133   }
134   /**
135    * @dev Transfers control of the contract to a newOwner.
136    * @param _newOwner The address to transfer ownership to.
137    */
138   function _transferOwnership(address _newOwner) internal {
139     require(_newOwner != address(0));
140     emit OwnershipTransferred(owner, _newOwner);
141     owner = _newOwner;
142   }
143 }
144 contract StandardToken is ERC20, BasicToken {
145   mapping (address => mapping (address => uint256)) internal allowed;
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(
153     address _from,
154     address _to,
155     uint256 _value
156   )
157     public
158     returns (bool)
159   {
160     require(_value <= balances[_from]);
161     require(_value <= allowed[_from][msg.sender]);
162     require(_to != address(0));
163     balances[_from] = balances[_from].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166     emit Transfer(_from, _to, _value);
167     return true;
168   }
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     emit Approval(msg.sender, _spender, _value);
181     return true;
182   }
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(
190     address _owner,
191     address _spender
192    )
193     public
194     view
195     returns (uint256)
196   {
197     return allowed[_owner][_spender];
198   }
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(
209     address _spender,
210     uint256 _addedValue
211   )
212     public
213     returns (bool)
214   {
215     allowed[msg.sender][_spender] = (
216       allowed[msg.sender][_spender].add(_addedValue));
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220   /**
221    * @dev Decrease the amount of tokens that an owner allowed to a spender.
222    * approve should be called when allowed[_spender] == 0. To decrement
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _subtractedValue The amount of tokens to decrease the allowance by.
228    */
229   function decreaseApproval(
230     address _spender,
231     uint256 _subtractedValue
232   )
233     public
234     returns (bool)
235   {
236     uint256 oldValue = allowed[msg.sender][_spender];
237     if (_subtractedValue >= oldValue) {
238       allowed[msg.sender][_spender] = 0;
239     } else {
240       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241     }
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 }
246 contract MintableToken is StandardToken, Ownable {
247    
248     event Mint(address indexed to, uint256 amount);
249     event MintFinished();
250     event MinterAssigned(address indexed owner, address newMinter);
251     bool public mintingFinished = false;
252     modifier canMint() {
253         require(!mintingFinished);
254         _;
255     }
256     address public crowdsale;
257     
258     // we have two minters the crowdsale contract and the token deployer(owner)
259     modifier hasMintPermission() {
260         require(msg.sender == crowdsale || msg.sender == owner);
261         _;
262     }
263     function setCrowdsale(address _crowdsaleContract) external onlyOwner {
264         crowdsale = _crowdsaleContract;
265         emit MinterAssigned(msg.sender, _crowdsaleContract);
266     }
267   /**
268    * @dev Function to mint tokens
269    * @param _to The address that will receive the minted tokens.
270    * @param _amount The amount of tokens to mint.
271    * @return A boolean that indicates if the operation was successful.
272    */
273     function mint(
274         address _to,
275         uint256 _amount
276     )
277         public
278         hasMintPermission
279         canMint  
280         returns (bool)
281     { 
282         require(balances[_to].add(_amount) > balances[_to]); // Guard against overflow
283         totalSupply_ = totalSupply_.add(_amount);
284         balances[_to] = balances[_to].add(_amount);
285         emit Mint(_to, _amount);
286         emit Transfer(address(0), _to, _amount);
287         return true;
288     }
289   /**
290    * @dev Function to stop minting new tokens.
291    * @return True if the operation was successful.
292    */
293     function finishMinting() public hasMintPermission canMint returns (bool) {
294         mintingFinished = true;
295         emit MintFinished();
296         return true;
297     }
298 }
299 contract BurnableToken is BasicToken, Ownable {
300     event Burn(address indexed burner, uint256 value);
301     
302     address public destroyer;
303     modifier onlyDestroyer() {
304         require(msg.sender == destroyer || msg.sender == owner);
305         _;
306     }
307     
308     // destroyer must be settled
309     function setDestroyer(address _destroyer) external onlyOwner {
310         destroyer = _destroyer;
311     }
312     function burn(address _who, uint256 _value) internal {
313         require(_value <= balances[_who]);
314         // no need to require value <= totalSupply, since that would imply the
315         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
316         balances[_who] = balances[_who].sub(_value);
317         totalSupply_ = totalSupply_.sub(_value);
318         emit Burn(_who, _value);
319         emit Transfer(_who, address(0), _value);
320     }
321 }
322 contract BitminerFactoryToken is MintableToken, BurnableToken {
323   
324     using SafeMath for uint256;
325     
326     // NOT IN CAPITALIZED SNAKE_CASE TO BE RECONIZED FROM METAMASK
327     string public constant name = "Bitminer Factory Token";
328     string public constant symbol = "BMF";
329     uint8 public constant decimals = 18;
330     
331     uint256 public cap;
332     
333     mapping (address => uint256) amount;
334     
335     event MultiplePurchase(address indexed purchaser);
336     
337     constructor(uint256 _cap) public {
338         require(_cap > 0);
339         cap = _cap;
340     }
341     function burnFrom(address _from, uint256 _value) external onlyDestroyer {
342         require(balances[_from] >= _value && _value > 0);
343         
344         burn(_from, _value);
345     }
346     function mint(
347         address _to,
348         uint256 _amount
349     )  
350     public
351     returns (bool)
352     {
353         require(totalSupply_.add(_amount) <= cap);
354         return super.mint(_to, _amount);
355     }
356     
357     // EACH INVESTOR MUST FIGURE IN THE '_TO' ARRAY ONLY ONE TIME
358     function multipleTransfer(address[] _to, uint256[] _amount) public hasMintPermission canMint {
359         require(_to.length == _amount.length);
360         _multiSet(_to, _amount); // map beneficiaries 
361         _multiMint(_to);
362         
363         emit MultiplePurchase(msg.sender);
364     }
365     
366     // INTERNAL INTERFACE
367     
368     // add to beneficiary mapping in batches
369     function _multiSet(address[] _to, uint256[] _amount) internal {
370         for (uint i = 0; i < _to.length; i++) {
371             amount[_to[i]] = _amount[i];
372         }
373     }
374     
375     // add to beneficiary mapping in batches
376     function _multiMint(address[] _to) internal {
377         for(uint i = 0; i < _to.length; i++) {
378             mint(_to[i], amount[_to[i]]);
379         }
380     }
381 }