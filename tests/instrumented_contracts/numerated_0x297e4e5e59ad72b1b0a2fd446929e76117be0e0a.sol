1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, throws on overflow.
30   */
31   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
32     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
33     // benefit is lost if 'b' is also tested.
34     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35     if (_a == 0) {
36       return 0;
37     }
38 
39     c = _a * _b;
40     assert(c / _a == _b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
48     // assert(_b > 0); // Solidity automatically throws when dividing by 0
49     // uint256 c = _a / _b;
50     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
51     return _a / _b;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
58     assert(_b <= _a);
59     return _a - _b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
66     c = _a + _b;
67     assert(c >= _a);
68     return c;
69   }
70 }
71 
72 
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) internal balances;
82 
83   uint256 internal totalSupply_;
84 
85   /**
86   * @dev Total number of tokens in existence
87   */
88   function totalSupply() public view returns (uint256) {
89     return totalSupply_;
90   }
91 
92   /**
93   * @dev Transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_value <= balances[msg.sender]);
99     require(_to != address(0));
100 
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     emit Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) public view returns (uint256) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 
119 
120 
121 
122 
123 
124 
125 
126 /**
127  * @title Burnable Token
128  * @dev Token that can be irreversibly burned (destroyed).
129  */
130 contract BurnableToken is BasicToken {
131 
132   event Burn(address indexed burner, uint256 value);
133 
134   /**
135    * @dev Burns a specific amount of tokens.
136    * @param _value The amount of token to be burned.
137    */
138   function burn(uint256 _value) public {
139     _burn(msg.sender, _value);
140   }
141 
142   function _burn(address _who, uint256 _value) internal {
143     require(_value <= balances[_who]);
144     // no need to require value <= totalSupply, since that would imply the
145     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
146 
147     balances[_who] = balances[_who].sub(_value);
148     totalSupply_ = totalSupply_.sub(_value);
149     emit Burn(_who, _value);
150     emit Transfer(_who, address(0), _value);
151   }
152 }
153 
154 
155 
156 
157 
158 
159 
160 
161 
162 /**
163  * @title ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/20
165  */
166 contract ERC20 is ERC20Basic {
167   function allowance(address _owner, address _spender)
168     public view returns (uint256);
169 
170   function transferFrom(address _from, address _to, uint256 _value)
171     public returns (bool);
172 
173   function approve(address _spender, uint256 _value) public returns (bool);
174   event Approval(
175     address indexed owner,
176     address indexed spender,
177     uint256 value
178   );
179 }
180 
181 
182 
183 /**
184  * @title Standard ERC20 token
185  *
186  * @dev Implementation of the basic standard token.
187  * https://github.com/ethereum/EIPs/issues/20
188  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
189  */
190 contract StandardToken is ERC20, BasicToken {
191 
192   mapping (address => mapping (address => uint256)) internal allowed;
193 
194 
195   /**
196    * @dev Transfer tokens from one address to another
197    * @param _from address The address which you want to send tokens from
198    * @param _to address The address which you want to transfer to
199    * @param _value uint256 the amount of tokens to be transferred
200    */
201   function transferFrom(
202     address _from,
203     address _to,
204     uint256 _value
205   )
206     public
207     returns (bool)
208   {
209     require(_value <= balances[_from]);
210     require(_value <= allowed[_from][msg.sender]);
211     require(_to != address(0));
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216     emit Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    * Beware that changing an allowance with this method brings the risk that someone may use both the old
223    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226    * @param _spender The address which will spend the funds.
227    * @param _value The amount of tokens to be spent.
228    */
229   function approve(address _spender, uint256 _value) public returns (bool) {
230     allowed[msg.sender][_spender] = _value;
231     emit Approval(msg.sender, _spender, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Function to check the amount of tokens that an owner allowed to a spender.
237    * @param _owner address The address which owns the funds.
238    * @param _spender address The address which will spend the funds.
239    * @return A uint256 specifying the amount of tokens still available for the spender.
240    */
241   function allowance(
242     address _owner,
243     address _spender
244    )
245     public
246     view
247     returns (uint256)
248   {
249     return allowed[_owner][_spender];
250   }
251 
252   /**
253    * @dev Increase the amount of tokens that an owner allowed to a spender.
254    * approve should be called when allowed[_spender] == 0. To increment
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _addedValue The amount of tokens to increase the allowance by.
260    */
261   function increaseApproval(
262     address _spender,
263     uint256 _addedValue
264   )
265     public
266     returns (bool)
267   {
268     allowed[msg.sender][_spender] = (
269       allowed[msg.sender][_spender].add(_addedValue));
270     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274   /**
275    * @dev Decrease the amount of tokens that an owner allowed to a spender.
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(
284     address _spender,
285     uint256 _subtractedValue
286   )
287     public
288     returns (bool)
289   {
290     uint256 oldValue = allowed[msg.sender][_spender];
291     if (_subtractedValue >= oldValue) {
292       allowed[msg.sender][_spender] = 0;
293     } else {
294       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295     }
296     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300 }
301 
302 
303 
304 /**
305  * @title Standard Burnable Token
306  * @dev Adds burnFrom method to ERC20 implementations
307  */
308 contract StandardBurnableToken is BurnableToken, StandardToken {
309 
310   /**
311    * @dev Burns a specific amount of tokens from the target address and decrements allowance
312    * @param _from address The address which you want to send tokens from
313    * @param _value uint256 The amount of token to be burned
314    */
315   function burnFrom(address _from, uint256 _value) public {
316     require(_value <= allowed[_from][msg.sender]);
317     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
318     // this function needs to emit an event with the updated approval.
319     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
320     _burn(_from, _value);
321   }
322 }
323 
324 /**
325  * @title ValorToken
326  */
327 contract ValorToken is StandardBurnableToken {
328 
329     string public constant name    =   "ValorToken";
330     string public constant symbol  =   "VALOR";
331     uint8  public constant decimals =   18;
332 
333     // initial supply addresses
334     address public employeePool;
335     address public futureDevFund;
336     address public companyWallet;
337 
338     // initial supply and distribution of tokens
339     uint256 internal constant VALOR = 10 ** uint256(decimals);
340     uint256 public constant INITIAL_SUPPLY = 1e8 * VALOR; //100000000 VALOR.
341 
342     // required distribution is:
343     // employeePool : 19%
344     // futureDevFund: 26%
345     // companyWallet: 55%
346     uint256 internal constant employeePoolSupply =  1.9e7 * VALOR; // 19 000 000 VALOR
347     uint256 internal constant futureDevFundSupply = 2.6e7 * VALOR; // 26 000 000 VALOR
348     uint256 internal constant companyWalletSupply = 5.5e7 * VALOR; // 55 000 000 VALOR
349 
350     /**
351      * @dev Constructor that distributes at TGS the supply among three predefined wallets 
352      * @param _employeePool the account of employees pool funds
353      * @param _futureDevFund the account of future development fund
354      * @param _companyWallet the account of company managed cold wallet
355      */
356     constructor(address _employeePool, address _futureDevFund, address _companyWallet) public {
357         require(_employeePool  != address(0),  "0x0 address is not allowed");
358         require(_futureDevFund != address(0),  "0x0 address is not allowed");
359         require(_companyWallet != address(0),  "0x0 address is not allowed");
360 
361         employeePool  = _employeePool;
362         futureDevFund = _futureDevFund;
363         companyWallet = _companyWallet;
364 
365         assert(INITIAL_SUPPLY == employeePoolSupply + futureDevFundSupply + companyWalletSupply);
366 
367         totalSupply_ = INITIAL_SUPPLY;
368 
369         // EmployeePool
370         balances[employeePool] += employeePoolSupply;
371         emit Transfer(address(0), employeePool, employeePoolSupply);
372 
373         // FutureDevFund
374         balances[futureDevFund] += futureDevFundSupply;
375         emit Transfer(address(0), futureDevFund, futureDevFundSupply);
376 
377         //CompanyWallet
378         balances[companyWallet] += companyWalletSupply;
379         emit Transfer(address(0), companyWallet, companyWalletSupply);
380     }
381 }