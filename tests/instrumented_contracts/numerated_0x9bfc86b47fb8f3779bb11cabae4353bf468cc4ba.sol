1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24     address public owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     /**
29     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30     * account.
31     */
32     constructor(address _owner) public {
33         owner = _owner;
34     }
35 
36     /**
37     * @dev Throws if called by any account other than the owner.
38     */
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     /**
45     * @dev Allows the current owner to transfer control of the contract to a newOwner.
46     * @param newOwner The address to transfer ownership to.
47     */
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0));
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 
54 }
55 
56 
57 
58 contract DetailedERC20 {
59   string public name;
60   string public symbol;
61   uint8 public decimals;
62 
63   constructor(string _name, string _symbol, uint8 _decimals) public {
64     name = _name;
65     symbol = _symbol;
66     decimals = _decimals;
67   }
68 }
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 
79 
80 
81 
82 /**
83  * @title SafeMath
84  * @dev Math operations with safety checks that throw on error
85  */
86 library SafeMath {
87 
88   /**
89   * @dev Multiplies two numbers, throws on overflow.
90   */
91   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92     if (a == 0) {
93       return 0;
94     }
95     uint256 c = a * b;
96     assert(c / a == b);
97     return c;
98   }
99 
100   /**
101   * @dev Integer division of two numbers, truncating the quotient.
102   */
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     // assert(b > 0); // Solidity automatically throws when dividing by 0
105     uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107     return c;
108   }
109 
110   /**
111   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
112   */
113   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114     assert(b <= a);
115     return a - b;
116   }
117 
118   /**
119   * @dev Adds two numbers, throws on overflow.
120   */
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 
129 
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   uint256 totalSupply_;
140 
141   /**
142   * @dev total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return totalSupply_;
146   }
147 
148   /**
149   * @dev transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[msg.sender]);
156 
157     // SafeMath.sub will throw if there is not enough balance.
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     emit Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param _owner The address to query the the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169   function balanceOf(address _owner) public view returns (uint256 balance) {
170     return balances[_owner];
171   }
172 
173 }
174 
175 
176 
177 
178 
179 
180 /**
181  * @title ERC20 interface
182  * @dev see https://github.com/ethereum/EIPs/issues/20
183  */
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender) public view returns (uint256);
186   function transferFrom(address from, address to, uint256 value) public returns (bool);
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * @dev https://github.com/ethereum/EIPs/issues/20
198  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
199  */
200 contract StandardToken is ERC20, BasicToken {
201 
202   mapping (address => mapping (address => uint256)) internal allowed;
203 
204 
205   /**
206    * @dev Transfer tokens from one address to another
207    * @param _from address The address which you want to send tokens from
208    * @param _to address The address which you want to transfer to
209    * @param _value uint256 the amount of tokens to be transferred
210    */
211   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
212     require(_to != address(0));
213     require(_value <= balances[_from]);
214     require(_value <= allowed[_from][msg.sender]);
215 
216     balances[_from] = balances[_from].sub(_value);
217     balances[_to] = balances[_to].add(_value);
218     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
219     emit Transfer(_from, _to, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
225    *
226    * Beware that changing an allowance with this method brings the risk that someone may use both the old
227    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230    * @param _spender The address which will spend the funds.
231    * @param _value The amount of tokens to be spent.
232    */
233   function approve(address _spender, uint256 _value) public returns (bool) {
234     allowed[msg.sender][_spender] = _value;
235     emit Approval(msg.sender, _spender, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Function to check the amount of tokens that an owner allowed to a spender.
241    * @param _owner address The address which owns the funds.
242    * @param _spender address The address which will spend the funds.
243    * @return A uint256 specifying the amount of tokens still available for the spender.
244    */
245   function allowance(address _owner, address _spender) public view returns (uint256) {
246     return allowed[_owner][_spender];
247   }
248 
249   /**
250    * @dev Increase the amount of tokens that an owner allowed to a spender.
251    *
252    * approve should be called when allowed[_spender] == 0. To increment
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _addedValue The amount of tokens to increase the allowance by.
258    */
259   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
260     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
261     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 
265   /**
266    * @dev Decrease the amount of tokens that an owner allowed to a spender.
267    *
268    * approve should be called when allowed[_spender] == 0. To decrement
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _subtractedValue The amount of tokens to decrease the allowance by.
274    */
275   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
276     uint oldValue = allowed[msg.sender][_spender];
277     if (_subtractedValue > oldValue) {
278       allowed[msg.sender][_spender] = 0;
279     } else {
280       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
281     }
282     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286 }
287 
288 
289 
290 
291 /**
292  * @title ReMintable token
293  */
294 contract ReMintableToken is StandardToken, Ownable {
295     event Mint(address indexed to, uint256 amount);
296     event MintFinished();
297     event MintStarted();
298 
299     bool public mintingFinished = false;
300 
301 
302     modifier canMint() {
303         require(!mintingFinished);
304         _;
305     }
306     
307     modifier cannotMint() {
308         require(mintingFinished);
309         _;
310     }
311 
312     constructor(address _owner)
313         public
314         Ownable(_owner)
315     {
316 
317     }
318 
319     /**
320     * @dev Function to mint tokens
321     * @param _to The address that will receive the minted tokens.
322     * @param _amount The amount of tokens to mint.
323     * @return A boolean that indicates if the operation was successful.
324     */
325     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
326         totalSupply_ = totalSupply_.add(_amount);
327         balances[_to] = balances[_to].add(_amount);
328         emit Mint(_to, _amount);
329         emit Transfer(address(0), _to, _amount);
330         return true;
331     }
332 
333     /**
334     * @dev Function to stop minting new tokens.
335     * @return True if the operation was successful.
336     */
337     function finishMinting() onlyOwner canMint public returns (bool) {
338         mintingFinished = true;
339         emit MintFinished();
340         return true;
341     }
342     
343     /**
344     * @dev Function to start minting new tokens.
345     * @return True if the operation was successful.
346     */
347     function startMinting() onlyOwner cannotMint public returns (bool) {
348         mintingFinished = false;
349         emit MintStarted();
350         return true;
351     }
352 }
353 
354 
355 
356 
357 /** @title Token */
358 contract ReToken is DetailedERC20, ReMintableToken {
359 
360     /** @dev Constructor
361       * @param _owner Token contract owner
362       * @param _name Token name
363       * @param _symbol Token symbol
364       * @param _decimals number of decimals in the token(usually 18)
365       */
366     constructor(
367         address _owner,
368         string _name, 
369         string _symbol, 
370         uint8 _decimals
371     )
372         public
373         ReMintableToken(_owner)
374         DetailedERC20(_name, _symbol, _decimals)
375     {
376 
377     }
378 
379     /** @dev Updates token name
380       * @param _name New token name
381       */
382     function updateName(string _name) public onlyOwner {
383         require(bytes(_name).length != 0);
384         name = _name;
385     }
386 
387     /** @dev Updates token symbol
388       * @param _symbol New token name
389       */
390     function updateSymbol(string _symbol) public onlyOwner {
391         require(bytes(_symbol).length != 0);
392         symbol = _symbol;
393     }
394 }