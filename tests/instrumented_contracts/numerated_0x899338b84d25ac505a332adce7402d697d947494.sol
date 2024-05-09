1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44     if (a == 0) {
45       return 0;
46     }
47     uint256 c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   /**
63   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public view returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98 
99   uint256 totalSupply_;
100 
101   /**
102   * @dev total number of tokens in existence
103   */
104   function totalSupply() public view returns (uint256) {
105     return totalSupply_;
106   }
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[msg.sender]);
116 
117     // SafeMath.sub will throw if there is not enough balance.
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) public view returns (uint256 balance) {
130     return balances[_owner];
131   }
132 
133 }
134 
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 contract StandardTokenExt is StandardToken {
224 
225   /* Interface declaration */
226   function isToken() public pure returns (bool weAre) {
227     return true;
228   }
229 }
230 
231 contract MintableToken is StandardTokenExt, Ownable {
232 
233   using SafeMath for uint;
234 
235   bool public mintingFinished = false;
236 
237   /** List of agents that are allowed to create new tokens */
238   mapping (address => bool) public mintAgents;
239 
240   event MintingAgentChanged(address addr, bool state);
241   event Minted(address receiver, uint amount);
242 
243   /**
244    * Create new tokens and allocate them to an address..
245    *
246    * Only callably by a crowdsale contract (mint agent).
247    */
248   function mint(address receiver, uint amount) onlyMintAgent canMint public {
249     totalSupply_ = 	totalSupply_.add(amount);
250     balances[receiver] = balances[receiver].add(amount);
251 
252     // This will make the mint transaction apper in EtherScan.io
253     // We can remove this after there is a standardized minting event
254     Transfer(0, receiver, amount);
255   }
256 
257   /**
258    * Owner can allow a crowdsale contract to mint new tokens.
259    */
260   function setMintAgent(address addr, bool state) onlyOwner canMint public {
261     mintAgents[addr] = state;
262     MintingAgentChanged(addr, state);
263   }
264 
265   modifier onlyMintAgent() {
266     // Only crowdsale contracts are allowed to mint new tokens
267     if(!mintAgents[msg.sender]) {
268         revert();
269     }
270     _;
271   }
272 
273   /** Make sure we are not done yet. */
274   modifier canMint() {
275     if(mintingFinished) revert();
276     _;
277   }
278 }
279 
280 contract BurnableToken is BasicToken {
281 
282   event Burn(address indexed burner, uint256 value);
283 
284   /**
285    * @dev Burns a specific amount of tokens.
286    * @param _value The amount of token to be burned.
287    */
288   function burn(uint256 _value) public {
289     require(_value <= balances[msg.sender]);
290     // no need to require value <= totalSupply, since that would imply the
291     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
292 
293     address burner = msg.sender;
294     balances[burner] = balances[burner].sub(_value);
295     totalSupply_ = totalSupply_.sub(_value);
296     Burn(burner, _value);
297   }
298 }
299 
300 contract WINCrowdSaleToken is MintableToken, BurnableToken {
301 
302   /** Name and symbol were updated. */
303   event UpdatedTokenInformation(string newName, string newSymbol);
304 
305   string public name;
306 
307   string public symbol;
308 
309   uint public decimals;
310 
311   /**
312    * Construct the token.
313    *
314    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
315    *
316    * @param _name Token name
317    * @param _symbol Token symbol - should be all caps
318    * @param _initialSupply How many tokens we start with
319    * @param _decimals Number of decimal places
320    * @param _mintable Are new tokens created over the crowdsale 
321    */
322   function WINCrowdSaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) public {
323 
324     // Create any address, can be transferred
325     // to team multisig via changeOwner(),
326     // also remember to call setUpgradeMaster()
327     owner = msg.sender;
328 
329     name = _name;
330     symbol = _symbol;
331 
332     totalSupply_ = _initialSupply;
333 
334     decimals = _decimals;
335 
336     // Create initially all balance on the team multisig
337     balances[owner] = totalSupply_;
338 
339     if(totalSupply_ > 0) {
340       Minted(owner, totalSupply_);
341     }
342 
343     // No more new supply allowed after the token creation
344     if(!_mintable) {
345       mintingFinished = true;
346       if(totalSupply_ == 0) {
347         revert(); // Cannot create a token without supply and no minting
348       }
349     }
350   }
351 
352 
353   /**
354    * Owner can update token information here.
355    *
356    * It is often useful to conceal the actual token association, until
357    * the token operations, like central issuance or reissuance have been completed.
358    *
359    * This function allows the token owner to rename the token after the operations
360    * have been completed and then point the audience to use the token contract.
361    */
362   function setTokenInformation(string _name, string _symbol) public onlyOwner {
363     name = _name;
364     symbol = _symbol;
365 
366     UpdatedTokenInformation(name, symbol);
367   }
368 
369 }