1 pragma solidity ^0.4.18;
2 
3 /*
4   Set of classes OpenZeppelin
5 */
6 
7 /*
8 *****************************************************************************************
9 
10 below is 'OpenZeppelin  - Ownable.sol'
11 
12 */
13 
14 /**
15  * @title Ownable
16  * @dev The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of "user permissions".
18  */
19 contract Ownable {
20   address public owner;
21 
22 
23   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30   function Ownable() {
31     owner = msg.sender;
32   }
33 
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) onlyOwner public {
49     require(newOwner != address(0));
50     OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53 
54 }
55 
56 
57 
58 
59 
60 /*
61 *****************************************************************************************
62 below is 'OpenZeppelin  - ERC20Basic.sol'
63 
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/179
67  */
68 contract ERC20Basic {
69   uint256 public totalSupply;
70   function balanceOf(address who) public constant returns (uint256);
71   function transfer(address to, uint256 value) public returns (bool);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 
76 /*
77 *****************************************************************************************
78 below is 'OpenZeppelin  - BasicToken.sol'
79 
80 */
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 
118 
119 /*
120 *****************************************************************************************
121 below is 'OpenZeppelin  - ERC20.sol'
122 
123 */
124 
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) public constant returns (uint256);
132   function transferFrom(address from, address to, uint256 value) public returns (bool);
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 
138 
139 
140 /*
141 *****************************************************************************************
142 
143 below is 'OpenZeppelin  - StandardToken.sol'
144 
145 */
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * @dev https://github.com/ethereum/EIPs/issues/20
152  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract StandardToken is ERC20, BasicToken {
155 
156   mapping (address => mapping (address => uint256)) internal allowed;
157 
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[_from]);
168     require(_value <= allowed[_from][msg.sender]);
169 
170     balances[_from] = balances[_from].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173     Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    *
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint256 _value) public returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(address _owner, address _spender) public view returns (uint256) {
200     return allowed[_owner][_spender];
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
214     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
215     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To decrement
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _subtractedValue The amount of tokens to decrease the allowance by.
228    */
229   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
230     uint oldValue = allowed[msg.sender][_spender];
231     if (_subtractedValue > oldValue) {
232       allowed[msg.sender][_spender] = 0;
233     } else {
234       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
235     }
236     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240 }
241 
242 
243 contract MintableAndBurnableToken is StandardToken, Ownable {
244 
245 
246   event Mint(address indexed to, uint256 amount);
247   event MintFinished();
248 
249   bool public mintingFinished = false;
250 
251 
252   modifier canMint() {
253     require(!mintingFinished);
254     _;
255   }
256 
257   /**
258    * @dev Function to mint tokens
259    * @param _to The address that will receive the minted tokens.
260    * @param _amount The amount of tokens to mint.
261    * @return A boolean that indicates if the operation was successful.
262    */
263   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
264     totalSupply = totalSupply.add(_amount);
265     balances[_to] = balances[_to].add(_amount);
266     Mint(_to, _amount);
267     Transfer(address(0), _to, _amount);
268     return true;
269   }
270 
271   /**
272    * @dev Function to stop minting new tokens.
273    * @return True if the operation was successful.
274    */
275   function finishMinting() onlyOwner canMint public returns (bool) {
276     mintingFinished = true;
277     MintFinished();
278     return true;
279   }
280 
281     event Burn(address indexed burner, uint256 value);
282 
283   /**
284   * @dev Burns a specific amount of tokens.
285   * @param _value The amount of token to be burned.
286   */
287   function burn(uint256 _value) public {
288       require(_value <= balances[msg.sender]);
289       // no need to require value <= totalSupply, since that would imply the
290       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
291 
292       address burner = msg.sender;
293       balances[burner] = balances[burner].sub(_value);
294       totalSupply = totalSupply.sub(_value);
295       Burn(burner, _value);
296   }
297 }
298 
299 
300 /*
301 *****************************************************************************************
302 below is 'OpenZeppelin  - SafeMath.sol'
303  * @title SafeMath
304  * @dev Math operations with safety checks that throw on error
305  */
306 library SafeMath {
307   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
308     uint256 c = a * b;
309     assert(a == 0 || c / a == b);
310     return c;
311   }
312 
313   function div(uint256 a, uint256 b) internal constant returns (uint256) {
314     // assert(b > 0); // Solidity automatically throws when dividing by 0
315     uint256 c = a / b;
316     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
317     return c;
318   }
319 
320   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
321     assert(b <= a);
322     return a - b;
323   }
324 
325   function add(uint256 a, uint256 b) internal constant returns (uint256) {
326     uint256 c = a + b;
327     assert(c >= a);
328     return c;
329   }
330 }
331 
332 
333 contract IQUASaleMint {
334   function mintProxyWithoutCap(address _to, uint256 _amount) public;
335   function mintProxy(address _to, uint256 _amount) public;
336 }
337 contract IQUATokenMint {
338   function mint(address _to, uint256 _amount) public returns (bool);
339 }
340 
341 contract QuasacoinCodeToken is MintableAndBurnableToken {
342     
343   string public name = "QuasacoinCode";
344   string public symbol = "QUA_CODE";
345   uint public decimals = 18;
346 
347   IQUASaleMint public icoSmartcontract;
348   IQUATokenMint public tokenSmartcontract;
349 
350   function QuasacoinCodeToken() {
351     icoSmartcontract = IQUASaleMint(0x48299b98d25c700e8f8c4393b4ee49d525162513);
352     tokenSmartcontract = IQUATokenMint(0x4dAeb4a06F70f4b1A5C329115731fE4b89C0B227);
353 
354     mintMode = 1;
355   }
356 
357   function burnAndConvertToQUA(uint256 _value) public {
358     
359       burn(_value);
360 
361       if(mintMode == 0)
362         tokenSmartcontract.mint(msg.sender, _value);
363       else if(mintMode == 1)
364         icoSmartcontract.mintProxy(msg.sender, _value);
365       else if(mintMode == 2)
366         icoSmartcontract.mintProxyWithoutCap(msg.sender, _value);
367   }
368 
369   // 0 - call token mint, 1 - call crowdsale mintProxy, 2 - call crowdsale mintProxyWithoutCap
370   uint public mintMode;
371   function setMintMode(uint _mode) onlyOwner public {
372     mintMode = _mode;
373   }
374 
375 }