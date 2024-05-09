1 pragma solidity 0.4.24;
2 
3 contract Config {
4     uint256 public constant jvySupply = 333333333333333;
5     uint256 public constant bonusSupply = 83333333333333;
6     uint256 public constant saleSupply =  250000000000000;
7     uint256 public constant hardCapUSD = 8000000;
8 
9     uint256 public constant preIcoBonus = 25;
10     uint256 public constant minimalContributionAmount = 0.4 ether;
11 
12     function getStartPreIco() public view returns (uint256) {
13         // solium-disable-next-line security/no-block-members
14         uint256 nowTime = block.timestamp;
15         // uint256 _preIcoStartTime = nowTime + 2 days;
16         uint256 _preIcoStartTime = nowTime + 1 minutes;
17         return _preIcoStartTime;
18     }
19 
20     function getStartIco() public view returns (uint256) {
21         // solium-disable-next-line security/no-block-members
22         // uint256 nowTime = block.timestamp;
23         // uint256 _icoStartTime = nowTime + 20 days;
24         uint256 _icoStartTime = 1543554000;
25         return _icoStartTime;
26     }
27 
28     function getEndIco() public view returns (uint256) {
29         // solium-disable-next-line security/no-block-members
30         // uint256 nowTime = block.timestamp;
31         // uint256 _icoEndTime = nowTime + 50 days;
32         uint256 _icoEndTime = 1551416400;
33         return _icoEndTime;
34     }
35 }
36 
37 contract ERC20Basic {
38   function totalSupply() public view returns (uint256);
39   function balanceOf(address _who) public view returns (uint256);
40   function transfer(address _to, uint256 _value) public returns (bool);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     c = _a * _b;
58     assert(c / _a == _b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     // assert(_b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = _a / _b;
68     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69     return _a / _b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     assert(_b <= _a);
77     return _a - _b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
84     c = _a + _b;
85     assert(c >= _a);
86     return c;
87   }
88 }
89 
90 
91 contract ERC20 is ERC20Basic {
92   function allowance(address _owner, address _spender)
93     public view returns (uint256);
94 
95   function transferFrom(address _from, address _to, uint256 _value)
96     public returns (bool);
97 
98   function approve(address _spender, uint256 _value) public returns (bool);
99   event Approval(
100     address indexed owner,
101     address indexed spender,
102     uint256 value
103   );
104 }
105 
106 
107 contract DetailedERC20 is ERC20 {
108   string public name;
109   string public symbol;
110   uint8 public decimals;
111 
112   constructor(string _name, string _symbol, uint8 _decimals) public {
113     name = _name;
114     symbol = _symbol;
115     decimals = _decimals;
116   }
117 }
118 
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121 
122   mapping(address => uint256) internal balances;
123 
124   uint256 internal totalSupply_;
125 
126   /**
127   * @dev Total number of tokens in existence
128   */
129   function totalSupply() public view returns (uint256) {
130     return totalSupply_;
131   }
132 
133   /**
134   * @dev Transfer token for a specified address
135   * @param _to The address to transfer to.
136   * @param _value The amount to be transferred.
137   */
138   function transfer(address _to, uint256 _value) public returns (bool) {
139     require(_value <= balances[msg.sender]);
140     require(_to != address(0));
141 
142     balances[msg.sender] = balances[msg.sender].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     emit Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public view returns (uint256) {
154     return balances[_owner];
155   }
156 
157 }
158 
159 contract StandardToken is ERC20, BasicToken {
160 
161   mapping (address => mapping (address => uint256)) internal allowed;
162 
163 
164   /**
165    * @dev Transfer tokens from one address to another
166    * @param _from address The address which you want to send tokens from
167    * @param _to address The address which you want to transfer to
168    * @param _value uint256 the amount of tokens to be transferred
169    */
170   function transferFrom(
171     address _from,
172     address _to,
173     uint256 _value
174   )
175     public
176     returns (bool)
177   {
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180     require(_to != address(0));
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185     emit Transfer(_from, _to, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191    * Beware that changing an allowance with this method brings the risk that someone may use both the old
192    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195    * @param _spender The address which will spend the funds.
196    * @param _value The amount of tokens to be spent.
197    */
198   function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     emit Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210   function allowance(
211     address _owner,
212     address _spender
213    )
214     public
215     view
216     returns (uint256)
217   {
218     return allowed[_owner][_spender];
219   }
220 
221   /**
222    * @dev Increase the amount of tokens that an owner allowed to a spender.
223    * approve should be called when allowed[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseApproval(
231     address _spender,
232     uint256 _addedValue
233   )
234     public
235     returns (bool)
236   {
237     allowed[msg.sender][_spender] = (
238       allowed[msg.sender][_spender].add(_addedValue));
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243   /**
244    * @dev Decrease the amount of tokens that an owner allowed to a spender.
245    * approve should be called when allowed[_spender] == 0. To decrement
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _subtractedValue The amount of tokens to decrease the allowance by.
251    */
252   function decreaseApproval(
253     address _spender,
254     uint256 _subtractedValue
255   )
256     public
257     returns (bool)
258   {
259     uint256 oldValue = allowed[msg.sender][_spender];
260     if (_subtractedValue >= oldValue) {
261       allowed[msg.sender][_spender] = 0;
262     } else {
263       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264     }
265     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269 }
270 
271 contract Ownable {
272   address public owner;
273 
274 
275   event OwnershipRenounced(address indexed previousOwner);
276   event OwnershipTransferred(
277     address indexed previousOwner,
278     address indexed newOwner
279   );
280 
281 
282   /**
283    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
284    * account.
285    */
286   constructor() public {
287     owner = msg.sender;
288   }
289 
290   /**
291    * @dev Throws if called by any account other than the owner.
292    */
293   modifier onlyOwner() {
294     require(msg.sender == owner);
295     _;
296   }
297 
298   /**
299    * @dev Allows the current owner to relinquish control of the contract.
300    * @notice Renouncing to ownership will leave the contract without an owner.
301    * It will not be possible to call the functions with the `onlyOwner`
302    * modifier anymore.
303    */
304   function renounceOwnership() public onlyOwner {
305     emit OwnershipRenounced(owner);
306     owner = address(0);
307   }
308 
309   /**
310    * @dev Allows the current owner to transfer control of the contract to a newOwner.
311    * @param _newOwner The address to transfer ownership to.
312    */
313   function transferOwnership(address _newOwner) public onlyOwner {
314     _transferOwnership(_newOwner);
315   }
316 
317   /**
318    * @dev Transfers control of the contract to a newOwner.
319    * @param _newOwner The address to transfer ownership to.
320    */
321   function _transferOwnership(address _newOwner) internal {
322     require(_newOwner != address(0));
323     emit OwnershipTransferred(owner, _newOwner);
324     owner = _newOwner;
325   }
326 }
327 
328 contract JavvyToken is DetailedERC20, StandardToken, Ownable, Config {
329     address public crowdsaleAddress;
330     address public bonusAddress;
331     address public multiSigAddress;
332 
333     constructor(
334         string _name, 
335         string _symbol, 
336         uint8 _decimals
337     ) public
338     DetailedERC20(_name, _symbol, _decimals) {
339         require(
340             jvySupply == saleSupply + bonusSupply,
341             "Sum of provided supplies is not equal to declared total Javvy supply. Check config!"
342         );
343         totalSupply_ = tokenToDecimals(jvySupply);
344     }
345 
346     function initializeBalances(
347         address _crowdsaleAddress,
348         address _bonusAddress,
349         address _multiSigAddress
350     ) public 
351     onlyOwner() {
352         crowdsaleAddress = _crowdsaleAddress;
353         bonusAddress = _bonusAddress;
354         multiSigAddress = _multiSigAddress;
355 
356         _initializeBalance(_crowdsaleAddress, saleSupply);
357         _initializeBalance(_bonusAddress, bonusSupply);
358     }
359 
360     function _initializeBalance(address _address, uint256 _supply) private {
361         require(_address != address(0), "Address cannot be equal to 0x0!");
362         require(_supply != 0, "Supply cannot be equal to 0!");
363         balances[_address] = tokenToDecimals(_supply);
364         emit Transfer(address(0), _address, _supply);
365     }
366 
367     function tokenToDecimals(uint256 _amount) private view returns (uint256){
368         // NOTE for additional accuracy, we're using 6 decimal places in supply
369         return _amount * (10 ** 12);
370     }
371 
372     function getRemainingSaleTokens() external view returns (uint256) {
373         return balanceOf(crowdsaleAddress);
374     }
375 
376 }