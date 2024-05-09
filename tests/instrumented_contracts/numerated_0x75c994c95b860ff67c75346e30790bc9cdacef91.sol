1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract ERC20Basic {
70   uint256 public totalSupply;
71   function balanceOf(address who) public view returns (uint256);
72   function transfer(address to, uint256 value) public returns (bool);
73   event Transfer(address indexed from, address indexed to, uint256 value);
74 }
75 
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     // SafeMath.sub will throw if there is not enough balance.
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint256 representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) public view returns (uint256 balance) {
103     return balances[_owner];
104   }
105 
106 }
107 
108 contract BurnableToken is BasicToken {
109 
110     event Burn(address indexed burner, uint256 value);
111 
112     /**
113      * @dev Burns a specific amount of tokens.
114      * @param _value The amount of token to be burned.
115      */
116     function burn(uint256 _value) public {
117         require(_value <= balances[msg.sender]);
118         // no need to require value <= totalSupply, since that would imply the
119         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
120 
121         address burner = msg.sender;
122         balances[burner] = balances[burner].sub(_value);
123         totalSupply = totalSupply.sub(_value);
124         Burn(burner, _value);
125     }
126 }
127 
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) public view returns (uint256);
130   function transferFrom(address from, address to, uint256 value) public returns (bool);
131   function approve(address spender, uint256 value) public returns (bool);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
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
223 contract MintableToken is StandardToken, Ownable {
224   event Mint(address indexed to, uint256 amount);
225   event MintFinished();
226 
227   bool public mintingFinished = false;
228 
229 
230   modifier canMint() {
231     require(!mintingFinished);
232     _;
233   }
234 
235   /**
236    * @dev Function to mint tokens
237    * @param _to The address that will receive the minted tokens.
238    * @param _amount The amount of tokens to mint.
239    * @return A boolean that indicates if the operation was successful.
240    */
241   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
242     totalSupply = totalSupply.add(_amount);
243     balances[_to] = balances[_to].add(_amount);
244     Mint(_to, _amount);
245     Transfer(address(0), _to, _amount);
246     return true;
247   }
248 
249   /**
250    * @dev Function to stop minting new tokens.
251    * @return True if the operation was successful.
252    */
253   function finishMinting() onlyOwner canMint public returns (bool) {
254     mintingFinished = true;
255     MintFinished();
256     return true;
257   }
258 }
259 
260 contract ApprovedBurnableToken is BurnableToken, StandardToken {
261 
262         /**
263            Sent when `burner` burns some `value` of `owners` tokens.
264         */
265         event BurnFrom(address indexed owner, // The address whose tokens were burned.
266                        address indexed burner, // The address that executed the `burnFrom` call
267                        uint256 value           // The amount of tokens that were burned.
268                 );
269 
270         /**
271            @dev Burns a specific amount of tokens of another account that `msg.sender`
272            was approved to burn tokens for using `approveBurn` earlier.
273            @param _owner The address to burn tokens from.
274            @param _value The amount of token to be burned.
275         */
276         function burnFrom(address _owner, uint256 _value) public {
277                 require(_value > 0);
278                 require(_value <= balances[_owner]);
279                 require(_value <= allowed[_owner][msg.sender]);
280                 // no need to require value <= totalSupply, since that would imply the
281                 // sender's balance is greater than the totalSupply, which *should* be an assertion failure
282 
283                 address burner = msg.sender;
284                 balances[_owner] = balances[_owner].sub(_value);
285                 allowed[_owner][burner] = allowed[_owner][burner].sub(_value);
286                 totalSupply = totalSupply.sub(_value);
287 
288                 BurnFrom(_owner, burner, _value);
289                 Burn(_owner, _value);
290         }
291 }
292 
293 contract FintechCoin is MintableToken, ApprovedBurnableToken {
294         /**
295            @dev We do not expect this to change ever after deployment,
296            @dev but it is a way to identify different versions of the FintechCoin during development.
297         */
298         uint8 public constant contractVersion = 1;
299 
300         /**
301            @dev The name of the FintechCoin, specified as indicated in ERC20.
302          */
303         string public constant name = "FintechCoin";
304 
305         /**
306            @dev The abbreviation FINC, specified as indicated in ERC20.
307         */
308         string public constant symbol = "FINC";
309 
310         /**
311            @dev The smallest denomination of the FintechCoin is 1 * 10^(-18) FINC. `decimals` is specified as indicated in ERC20.
312         */
313         uint8 public constant decimals = 18;
314 }
315 
316 contract UnlockedAfterMintingToken is MintableToken {
317 
318     /**
319        Ensures certain calls can only be made when minting is finished.
320 
321        The calls that are restricted are any calls that allow direct or indirect transferral of funds.
322        Only the owner is allowed to perform these calls during the minting time as well.
323      */
324     modifier whenMintingFinished() {
325       require(mintingFinished || (msg.sender == owner));
326         _;
327     }
328 
329     function transfer(address _to, uint256 _value) public whenMintingFinished returns (bool) {
330         return super.transfer(_to, _value);
331     }
332 
333     /**
334       @dev Transfer tokens from one address to another
335       @param _from address The address which you want to send tokens from
336       @param _to address The address which you want to transfer to
337       @param _value uint256 the amount of tokens to be transferred
338      */
339     function transferFrom(address _from, address _to, uint256 _value) public whenMintingFinished returns (bool) {
340         return super.transferFrom(_from, _to, _value);
341     }
342 
343     /**
344       @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
345       @dev NOTE: This call is considered deprecated, and only included for proper compliance with ERC20.
346       @dev Rather than use this call, use `increaseApproval` and `decreaseApproval` instead, whenever possible.
347       @dev The reason for this, is that using `approve` directly when your allowance is nonzero results in an exploitable situation:
348       @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349 
350       @param _spender The address which will spend the funds.
351       @param _value The amount of tokens to be spent.
352      */
353     function approve(address _spender, uint256 _value) public whenMintingFinished returns (bool) {
354         return super.approve(_spender, _value);
355     }
356 
357     /**
358       @dev approve should only be called when allowed[_spender] == 0. To alter the
359       @dev allowed value it is better to use this function, because it is safer.
360       @dev (And making `approve` safe manually would require making two calls made in separate blocks.)
361 
362       This method was adapted from the one in use by the MonolithDAO Token.
363      */
364     function increaseApproval(address _spender, uint _addedValue) public whenMintingFinished returns (bool success) {
365         return super.increaseApproval(_spender, _addedValue);
366     }
367 
368     /**
369        @dev approve should only be called when allowed[_spender] == 0. To alter the
370        @dev allowed value it is better to use this function, because it is safer.
371        @dev (And making `approve` safe manually would require making two calls made in separate blocks.)
372 
373        This method was adapted from the one in use by the MonolithDAO Token.
374     */
375     function decreaseApproval(address _spender, uint _subtractedValue) public whenMintingFinished returns (bool success) {
376         return super.decreaseApproval(_spender, _subtractedValue);
377     }
378 
379 }