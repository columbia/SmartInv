1 pragma solidity ^0.4.23;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * Owned contract
55  */
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     
75     function acceptOwnership() public {
76         require(msg.sender == newOwner);
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80     }
81 }
82 
83 /**
84  * Secured contract
85  * @dev Important actions such as mint or burn will be controlled by smart contract.
86  *      This contract will get admin privillige from owner
87  */
88 contract Secured is Owned {
89     address public admin;
90 
91     event SetAdmin(address indexed _admin);
92 
93     modifier onlyAdmin {
94         require(msg.sender == admin);
95         _;
96     }
97 
98     function setAdmin(address _newAdmin) public onlyOwner {
99         admin = _newAdmin;
100         emit SetAdmin(admin);
101     }
102 }
103 
104 
105 /**
106  * @title ERC20 interface
107  * @dev 
108  */
109 contract ERC20 {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function totalSupply() public view returns (uint256);
112   function balanceOf(address who) public view returns (uint256);
113   function transfer(address to, uint256 value) public returns (bool);
114   function transferFrom(address from, address to, uint256 value) public returns (bool);
115   function approve(address spender, uint256 value) public returns (bool);
116   
117   event Transfer(address indexed from, address indexed to, uint256 value);
118   event Approval(
119     address indexed owner,
120     address indexed spender,
121     uint256 value
122   );
123 }
124 
125 /**
126  * @title Basic token
127  * @dev Basic version of ERC20 token.
128  * @dev based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
129  * @dev Contract which inherit this token should implement transfer and transferFrom as specified in ERC20
130  */
131 contract BasicToken is ERC20 {
132   using SafeMath for uint256;
133   
134   mapping(address => uint256) balances;
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137   uint256 totalSupply_;
138 
139   /**
140   * @dev total number of tokens in existence
141   */
142   function totalSupply() public view returns (uint256) {
143     return totalSupply_;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256) {
152     return balances[_owner];
153   }
154   
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     emit Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(
178     address _owner,
179     address _spender
180    )
181     public
182     view
183     returns (uint256)
184   {
185     return allowed[_owner][_spender];
186   }
187 }
188 
189 
190 /**
191  * @title TimeLock
192  * @dev Deny some action from lockstart to lockend. 
193  *      Owner is allowd action even it is timelocked.
194  */
195 contract Timelocked is Owned {
196   uint256 public lockstart;
197   uint256 public lockend;
198 
199   event SetTimelock(uint256 start, uint256 end);
200 
201   /**
202   * @dev timelock modifier.
203   */
204   modifier notTimeLocked() {
205     require((msg.sender == owner) || (now < lockstart || now > lockend));
206     _;
207   }
208 
209   function setTimeLock(uint256 _start, uint256 _end) public onlyOwner {
210     require(_end > _start);
211     lockstart = _start;
212     lockend = _end;
213     
214     emit SetTimelock(_start, _end);
215   }
216   
217   function releaseTimeLock() public onlyOwner {
218     lockstart = 0;
219     lockend = 0;
220     
221     emit SetTimelock(0, 0);
222   }
223 
224 }
225 
226 /**
227  * @title Mintable token
228  * @dev Admin(contract which controls AER token) can mint token.
229  *      Minted tokens is belong to owner, so that owner can distribute to users.
230  *      After distribution, all remained tokens will be reserved as burnable token.
231  */
232 contract MintableToken is BasicToken, Owned, Secured {
233   event Mint(address indexed to, uint256 amount);
234 
235   /**
236    * @dev Function to mint tokens
237    * @param _amount The amount of tokens to mint.
238    * @return A boolean that indicates if the operation was successful.
239    */
240   function mint(
241     uint256 _amount
242   )
243     onlyAdmin
244     public
245     returns (bool)
246   {
247     totalSupply_ = totalSupply_.add(_amount);
248     balances[owner] = balances[owner].add(_amount);
249     emit Mint(owner, _amount);
250     emit Transfer(address(0), owner, _amount);
251     return true;
252   }
253 }
254 
255 
256 /**
257  * @title Burnable Token
258  * @dev Token that can be irreversibly burned (destroyed) for each AERYUS transaction.
259  *      Tokens are burned at a rate based on the average transaction per second. 
260  */
261 contract BurnableToken is BasicToken, Owned, Secured {
262   // coldledger address which has reserved tokens for Aeryus transactions.   
263   address public coldledger; 
264 
265   event SetColdledger(address ledger);
266   event BurnForTransaction(address who, uint256 nft, string txtype, uint256 value);
267 
268   function setColdLedger(address ledger) public onlyOwner {
269       require(ledger != address(0));
270       coldledger = ledger;
271       emit SetColdledger(ledger);
272   }
273 
274    /**
275    * @dev All token remained is stored to coldledger.
276    */
277   function reserveAll() public onlyOwner {
278     uint256 val = balances[owner];
279     balances[coldledger] = balances[coldledger].add(val);
280     emit Transfer(owner, coldledger, val);
281   }
282   
283   /**
284    * @dev Burns a specific amount of tokens.
285    * @param _nft ERC721 token(NFT) address(index).
286    * @param _txtype transaction type such as POS, mobile, government or 
287    *        any other type that can be covered by the NFTA model .
288    * @param _value The amount of token to be burned.
289    */
290   function burn(uint256 _nft, string _txtype, uint256 _value) public onlyAdmin {
291     require(_value <= balances[coldledger]);
292 
293     balances[coldledger] = balances[coldledger].sub(_value);
294     totalSupply_ = totalSupply_.sub(_value);
295     emit BurnForTransaction(coldledger, _nft, _txtype, _value);
296     emit Transfer(coldledger, address(0), _value);
297   }
298 }
299 
300 
301 // ----------------------------------------------------------------------------
302 // The AER Token is fungible token asset of Aeryus protocol.
303 // As ERC-721 tokens are created to document transactions, AER tokens are burned at a rate based on
304 // the average transaction per second.
305 // Visit http://aeryus.ilhaus.com/ for full details. Thank you
306 //
307 //
308 // AER Token Contract
309 //
310 // Symbol      : AER
311 // Name        : Aeryus Token
312 // Total supply: 4,166,666,663.000000000000000000
313 // Decimals    : 18
314 // Website     : http://aeryus.ilhaus.com
315 // Company     : AERYUS
316 //
317 // ----------------------------------------------------------------------------
318 
319 contract AerToken is Timelocked, MintableToken, BurnableToken {
320 
321   string public name;
322   string public symbol;
323   uint256 public decimals;
324   
325   constructor(address coldledger) public {
326     name = "Aeryus Token";
327     symbol = "AER";
328     decimals = 18;
329     totalSupply_ = 4166666663000000000000000000;
330     balances[msg.sender] = totalSupply_;
331     setColdLedger(coldledger);
332     
333     emit Transfer(address(0), msg.sender, totalSupply_);
334   }
335   
336   /**
337   * @dev transfer token for a specified address
338   * @param _to The address to transfer to.
339   * @param _value The amount to be transferred.
340   */
341   function transfer(address _to, uint256 _value) public notTimeLocked returns (bool) {
342     require(_to != address(0));
343     require(_value <= balances[msg.sender]);
344 
345     balances[msg.sender] = balances[msg.sender].sub(_value);
346     balances[_to] = balances[_to].add(_value);
347     emit Transfer(msg.sender, _to, _value);
348     return true;
349   }
350 
351     /**
352    * @dev Transfer tokens from one address to another
353    * @param _from address The address which you want to send tokens from
354    * @param _to address The address which you want to transfer to
355    * @param _value uint256 the amount of tokens to be transferred
356    */
357   function transferFrom(
358     address _from,
359     address _to,
360     uint256 _value
361   )
362     public notTimeLocked
363     returns (bool)
364   {
365     require(_to != address(0));
366     require(_value <= balances[_from]);
367     require(_value <= allowed[_from][msg.sender]);
368 
369     balances[_from] = balances[_from].sub(_value);
370     balances[_to] = balances[_to].add(_value);
371     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
372     emit Transfer(_from, _to, _value);
373     return true;
374   }
375 
376     // ------------------------------------------------------------------------
377 
378     // Do not accept ETH
379 
380     // ------------------------------------------------------------------------
381 
382     function () public payable {
383         revert();
384     }
385 
386 
387     // ------------------------------------------------------------------------
388 
389     // Owner can transfer out any accidentally sent ERC20 tokens
390 
391     // ------------------------------------------------------------------------
392 
393     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
394 
395         return BasicToken(tokenAddress).transfer(owner, tokens);
396 
397     }
398 }