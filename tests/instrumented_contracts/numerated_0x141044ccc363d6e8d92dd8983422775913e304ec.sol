1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
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
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is ERC20, BasicToken {
126 
127   mapping (address => mapping (address => uint256)) internal allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint256 the amount of tokens to be transferred
135    */
136   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[_from]);
139     require(_value <= allowed[_from][msg.sender]);
140 
141     balances[_from] = balances[_from].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    *
151    * Beware that changing an allowance with this method brings the risk that someone may use both the old
152    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint256 _value) public returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public view returns (uint256) {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * @dev Increase the amount of tokens that an owner allowed to a spender.
176    *
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    * @param _spender The address which will spend the funds.
182    * @param _addedValue The amount of tokens to increase the allowance by.
183    */
184   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   /**
191    * @dev Decrease the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To decrement
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _subtractedValue The amount of tokens to decrease the allowance by.
199    */
200   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201     uint oldValue = allowed[msg.sender][_spender];
202     if (_subtractedValue > oldValue) {
203       allowed[msg.sender][_spender] = 0;
204     } else {
205       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206     }
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211 }
212 
213 contract Ownable {
214   address public owner;
215 
216 
217   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
218 
219 
220   /**
221    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
222    * account.
223    */
224   function Ownable() public {
225     owner = msg.sender;
226   }
227 
228   /**
229    * @dev Throws if called by any account other than the owner.
230    */
231   modifier onlyOwner() {
232     require(msg.sender == owner);
233     _;
234   }
235 
236   /**
237    * @dev Allows the current owner to transfer control of the contract to a newOwner.
238    * @param newOwner The address to transfer ownership to.
239    */
240   function transferOwnership(address newOwner) public onlyOwner {
241     require(newOwner != address(0));
242     OwnershipTransferred(owner, newOwner);
243     owner = newOwner;
244   }
245 }
246 
247 /**
248  * @title Mintable token
249  * @dev Simple ERC20 Token example, with mintable token creation
250  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
251  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
252  */
253 contract MintableToken is StandardToken, Ownable {
254   event Mint(address indexed to, uint256 amount);
255   event MintFinished();
256 
257   bool public mintingFinished = false;
258 
259 
260   modifier canMint() {
261     require(!mintingFinished);
262     _;
263   }
264 
265   /**
266    * @dev Function to mint tokens
267    * @param _to The address that will receive the minted tokens.
268    * @param _amount The amount of tokens to mint.
269    * @return A boolean that indicates if the operation was successful.
270    */
271   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
272     totalSupply_ = totalSupply_.add(_amount);
273     balances[_to] = balances[_to].add(_amount);
274     Mint(_to, _amount);
275     Transfer(address(0), _to, _amount);
276     return true;
277   }
278 
279   /**
280    * @dev Function to stop minting new tokens.
281    * @return True if the operation was successful.
282    */
283   function finishMinting() onlyOwner canMint public returns (bool) {
284     mintingFinished = true;
285     MintFinished();
286     return true;
287   }
288 }
289 
290 contract MinerOneToken is MintableToken {
291     using SafeMath for uint256;
292 
293     string public name = "MinerOne";
294     string public symbol = "MIO";
295     uint8 public decimals = 18;
296 
297     /**
298      * This struct holds data about token holder dividends
299      */
300     struct Account {
301         /**
302          * Last amount of dividends seen at the token holder payout
303          */
304         uint256 lastDividends;
305         /**
306          * Amount of wei contract needs to pay to token holder
307          */
308         uint256 fixedBalance;
309         /**
310          * Unpayed wei amount due to rounding
311          */
312         uint256 remainder;
313     }
314 
315     /**
316      * Mapping which holds all token holders data
317      */
318     mapping(address => Account) internal accounts;
319 
320     /**
321      * Running total of all dividends distributed
322      */
323     uint256 internal totalDividends;
324     /**
325      * Holds an amount of unpayed weis
326      */
327     uint256 internal reserved;
328 
329     /**
330      * Raised when payment distribution occurs
331      */
332     event Distributed(uint256 amount);
333     /**
334      * Raised when shareholder withdraws his profit
335      */
336     event Paid(address indexed to, uint256 amount);
337     /**
338      * Raised when the contract receives Ether
339      */
340     event FundsReceived(address indexed from, uint256 amount);
341 
342     modifier fixBalance(address _owner) {
343         Account storage account = accounts[_owner];
344         uint256 diff = totalDividends.sub(account.lastDividends);
345         if (diff > 0) {
346             uint256 numerator = account.remainder.add(balances[_owner].mul(diff));
347 
348             account.fixedBalance = account.fixedBalance.add(numerator.div(totalSupply_));
349             account.remainder = numerator % totalSupply_;
350             account.lastDividends = totalDividends;
351         }
352         _;
353     }
354 
355     modifier onlyWhenMintingFinished() {
356         require(mintingFinished);
357         _;
358     }
359 
360     function () external payable {
361         withdraw(msg.sender, msg.value);
362     }
363 
364     function deposit() external payable {
365         require(msg.value > 0);
366         require(msg.value <= this.balance.sub(reserved));
367 
368         totalDividends = totalDividends.add(msg.value);
369         reserved = reserved.add(msg.value);
370         Distributed(msg.value);
371     }
372 
373     /**
374      * Returns unpayed wei for a given address
375      */
376     function getDividends(address _owner) public view returns (uint256) {
377         Account storage account = accounts[_owner];
378         uint256 diff = totalDividends.sub(account.lastDividends);
379         if (diff > 0) {
380             uint256 numerator = account.remainder.add(balances[_owner].mul(diff));
381             return account.fixedBalance.add(numerator.div(totalSupply_));
382         } else {
383             return 0;
384         }
385     }
386 
387     function transfer(address _to, uint256 _value) public
388         onlyWhenMintingFinished
389         fixBalance(msg.sender)
390         fixBalance(_to) returns (bool) {
391         return super.transfer(_to, _value);
392     }
393 
394     function transferFrom(address _from, address _to, uint256 _value) public
395         onlyWhenMintingFinished
396         fixBalance(_from)
397         fixBalance(_to) returns (bool) {
398         return super.transferFrom(_from, _to, _value);
399     }
400 
401     function payoutToAddress(address[] _holders) external {
402         require(_holders.length > 0);
403         require(_holders.length <= 100);
404         for (uint256 i = 0; i < _holders.length; i++) {
405             withdraw(_holders[i], 0);
406         }
407     }
408 
409     /**
410      * Token holder must call this to receive dividends
411      */
412     function withdraw(address _benefeciary, uint256 _toReturn) internal
413         onlyWhenMintingFinished
414         fixBalance(_benefeciary) returns (bool) {
415 
416         uint256 amount = accounts[_benefeciary].fixedBalance;
417         reserved = reserved.sub(amount);
418         accounts[_benefeciary].fixedBalance = 0;
419         uint256 toTransfer = amount.add(_toReturn);
420         if (toTransfer > 0) {
421             _benefeciary.transfer(toTransfer);
422         }
423         if (amount > 0) {
424             Paid(_benefeciary, amount);
425         }
426         return true;
427     }
428 }