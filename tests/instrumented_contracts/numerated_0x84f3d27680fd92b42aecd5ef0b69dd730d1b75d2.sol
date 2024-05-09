1 pragma solidity ^0.4.21;
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
18 
19 
20 
21 
22 
23 
24 
25 
26 
27 
28 /**
29  * @title Basic token
30  * @dev Basic version of StandardToken, with no allowances.
31  */
32 contract BasicToken is ERC20Basic {
33   using SafeMath for uint256;
34 
35   mapping(address => uint256) balances;
36 
37   uint256 totalSupply_;
38 
39   /**
40   * @dev total number of tokens in existence
41   */
42   function totalSupply() public view returns (uint256) {
43     return totalSupply_;
44   }
45 
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value <= balances[msg.sender]);
54 
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     emit Transfer(msg.sender, _to, _value);
58     return true;
59   }
60 
61   /**
62   * @dev Gets the balance of the specified address.
63   * @param _owner The address to query the the balance of.
64   * @return An uint256 representing the amount owned by the passed address.
65   */
66   function balanceOf(address _owner) public view returns (uint256) {
67     return balances[_owner];
68   }
69 
70 }
71 
72 
73 
74 /**
75  * @title Burnable Token
76  * @dev Token that can be irreversibly burned (destroyed).
77  */
78 contract BurnableToken is BasicToken {
79 
80   event Burn(address indexed burner, uint256 value);
81 
82   /**
83    * @dev Burns a specific amount of tokens.
84    * @param _value The amount of token to be burned.
85    */
86   function burn(uint256 _value) public {
87     _burn(msg.sender, _value);
88   }
89 
90   function _burn(address _who, uint256 _value) internal {
91     require(_value <= balances[_who]);
92     // no need to require value <= totalSupply, since that would imply the
93     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
94 
95     balances[_who] = balances[_who].sub(_value);
96     totalSupply_ = totalSupply_.sub(_value);
97     emit Burn(_who, _value);
98     emit Transfer(_who, address(0), _value);
99   }
100 }
101 
102 
103 
104 
105 
106 
107 
108 
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, BasicToken {
131 
132   mapping (address => mapping (address => uint256)) internal allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint256 the amount of tokens to be transferred
140    */
141   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[_from]);
144     require(_value <= allowed[_from][msg.sender]);
145 
146     balances[_from] = balances[_from].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149     emit Transfer(_from, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    *
156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint256 _value) public returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     emit Approval(msg.sender, _spender, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Function to check the amount of tokens that an owner allowed to a spender.
171    * @param _owner address The address which owns the funds.
172    * @param _spender address The address which will spend the funds.
173    * @return A uint256 specifying the amount of tokens still available for the spender.
174    */
175   function allowance(address _owner, address _spender) public view returns (uint256) {
176     return allowed[_owner][_spender];
177   }
178 
179   /**
180    * @dev Increase the amount of tokens that an owner allowed to a spender.
181    *
182    * approve should be called when allowed[_spender] == 0. To increment
183    * allowed value is better to use this function to avoid 2 calls (and wait until
184    * the first transaction is mined)
185    * From MonolithDAO Token.sol
186    * @param _spender The address which will spend the funds.
187    * @param _addedValue The amount of tokens to increase the allowance by.
188    */
189   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
190     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
191     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195   /**
196    * @dev Decrease the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To decrement
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _subtractedValue The amount of tokens to decrease the allowance by.
204    */
205   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206     uint oldValue = allowed[msg.sender][_spender];
207     if (_subtractedValue > oldValue) {
208       allowed[msg.sender][_spender] = 0;
209     } else {
210       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211     }
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216 }
217 
218 
219 /**
220  * @title Standard Burnable Token
221  * @dev Adds burnFrom method to ERC20 implementations
222  */
223 contract StandardBurnableToken is BurnableToken, StandardToken {
224 
225   /**
226    * @dev Burns a specific amount of tokens from the target address and decrements allowance
227    * @param _from address The address which you want to send tokens from
228    * @param _value uint256 The amount of token to be burned
229    */
230   function burnFrom(address _from, uint256 _value) public {
231     require(_value <= allowed[_from][msg.sender]);
232     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
233     // this function needs to emit an event with the updated approval.
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     _burn(_from, _value);
236   }
237 }
238 
239 
240 
241 
242 /**
243  * @title SafeMath
244  * @dev Math operations with safety checks that throw on error
245  */
246 library SafeMath {
247 
248   /**
249   * @dev Multiplies two numbers, throws on overflow.
250   */
251   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
252     if (a == 0) {
253       return 0;
254     }
255     c = a * b;
256     assert(c / a == b);
257     return c;
258   }
259 
260   /**
261   * @dev Integer division of two numbers, truncating the quotient.
262   */
263   function div(uint256 a, uint256 b) internal pure returns (uint256) {
264     // assert(b > 0); // Solidity automatically throws when dividing by 0
265     // uint256 c = a / b;
266     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
267     return a / b;
268   }
269 
270   /**
271   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
272   */
273   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
274     assert(b <= a);
275     return a - b;
276   }
277 
278   /**
279   * @dev Adds two numbers, throws on overflow.
280   */
281   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
282     c = a + b;
283     assert(c >= a);
284     return c;
285   }
286 }
287 
288 
289 contract CQSToken is StandardBurnableToken {
290     // Constants
291     string  public constant name = "CQS";
292     string  public constant symbol = "CQS";
293     uint8   public constant decimals = 18;
294     address public owner;
295     string  public website = "www.cqsexchange.io"; 
296     uint256 public constant INITIAL_SUPPLY      =  2000000000 * (10 ** uint256(decimals));
297     uint256 public constant CROWDSALE_ALLOWANCE =  1600000000 * (10 ** uint256(decimals));
298     uint256 public constant ADMIN_ALLOWANCE     =   400000000 * (10 ** uint256(decimals));
299 
300     // Properties
301     //uint256 public totalSupply;
302     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
303     uint256 public adminAllowance;          // the number of tokens available for the administrator
304     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
305     address public adminAddr;               // the address of a crowdsale currently selling this token
306     bool public icoStart = false;
307     mapping(address => uint256) public tokensTransferred;
308 
309     // Events
310     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
311 
312     // Modifiers
313     modifier validDestination(address _to) {
314         require(_to != address(0x0));
315         require(_to != address(this));
316         require(_to != owner);
317         //require(_to != address(adminAddr));
318         //require(_to != address(crowdSaleAddr));
319         _;
320     }
321 
322     modifier onlyOwner() {
323         require(msg.sender == owner);
324         _;
325     }
326 
327     constructor(address _admin) public {
328         // the owner is a custodian of tokens that can
329         // give an allowance of tokens for crowdsales
330         // or to the admin, but cannot itself transfer
331         // tokens; hence, this requirement
332         require(msg.sender != _admin);
333 
334         owner = msg.sender;
335 
336         //totalSupply = INITIAL_SUPPLY;
337         totalSupply_ = INITIAL_SUPPLY;
338         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
339         adminAllowance = ADMIN_ALLOWANCE;
340 
341         // mint all tokens
342         balances[msg.sender] = totalSupply_.sub(adminAllowance);
343         emit Transfer(address(0x0), msg.sender, totalSupply_.sub(adminAllowance));
344 
345         balances[_admin] = adminAllowance;
346         emit Transfer(address(0x0), _admin, adminAllowance);
347 
348         adminAddr = _admin;
349         approve(adminAddr, adminAllowance);
350     }
351 
352     /**
353     * @dev called by the owner to start the ICO
354     */
355     function startICO() external onlyOwner {
356         icoStart = true;
357     }
358 
359     /**
360     * @dev called by the owner to stop the ICO
361     */
362     function stopICO() external onlyOwner {
363         icoStart = false;
364     }
365 
366 
367     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
368         require(_amountForSale <= crowdSaleAllowance);
369 
370         // if 0, then full available crowdsale supply is assumed
371         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
372 
373         // Clear allowance of old, and set allowance of new
374         approve(crowdSaleAddr, 0);
375         approve(_crowdSaleAddr, amount);
376 
377         crowdSaleAddr = _crowdSaleAddr;
378         //icoStart = true;
379     }
380 
381 
382     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
383         if(icoStart && (msg.sender != owner || msg.sender != adminAddr)){
384             require((tokensTransferred[msg.sender].add(_value)).mul(2)<=balances[msg.sender].add(tokensTransferred[msg.sender]));
385             tokensTransferred[msg.sender] = tokensTransferred[msg.sender].add(_value);
386             return super.transfer(_to, _value);
387         }else
388             return super.transfer(_to, _value);
389     }
390 
391     function transferOwnership(address newOwner) public onlyOwner {
392         require(newOwner != address(0));
393         emit OwnershipTransferred(owner, newOwner);
394         owner = newOwner;
395     }
396 
397 
398     function burn(uint256 _value) public {
399         require(msg.sender==owner || msg.sender==adminAddr);
400         _burn(msg.sender, _value);
401     }
402 
403 
404     function burnFromAdmin(uint256 _value) external onlyOwner {
405         _burn(adminAddr, _value);
406     }
407 
408     function changeWebsite(string _website) external onlyOwner {website = _website;}
409 
410 
411 }