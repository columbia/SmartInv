1 pragma solidity ^0.4.24;
2 
3 contract OwnableToken {
4     mapping (address => bool) owners;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7     event OwnershipExtended(address indexed host, address indexed guest);
8 
9     modifier onlyOwner() {
10         require(owners[msg.sender]);
11         _;
12     }
13 
14     function OwnableToken() public {
15         owners[msg.sender] = true;
16     }
17 
18     function addOwner(address guest) public onlyOwner {
19         require(guest != address(0));
20         owners[guest] = true;
21         emit OwnershipExtended(msg.sender, guest);
22     }
23 
24     function transferOwnership(address newOwner) public onlyOwner {
25         require(newOwner != address(0));
26         owners[newOwner] = true;
27         delete owners[msg.sender];
28         emit OwnershipTransferred(msg.sender, newOwner);
29     }
30 }
31 
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
38     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
39     // benefit is lost if 'b' is also tested.
40     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41     if (_a == 0) {
42       return 0;
43     }
44 
45     c = _a * _b;
46     assert(c / _a == _b);
47     return c;
48   }
49 
50   /**
51   * @dev Integer division of two numbers, truncating the quotient.
52   */
53   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
54     // assert(_b > 0); // Solidity automatically throws when dividing by 0
55     // uint256 c = _a / _b;
56     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
57     return _a / _b;
58   }
59 
60   /**
61   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
62   */
63   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
64     assert(_b <= _a);
65     return _a - _b;
66   }
67 
68   /**
69   * @dev Adds two numbers, throws on overflow.
70   */
71   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
72     c = _a + _b;
73     assert(c >= _a);
74     return c;
75   }
76 }
77 
78 contract Ownable {
79   address public owner;
80 
81 
82   event OwnershipRenounced(address indexed previousOwner);
83   event OwnershipTransferred(
84     address indexed previousOwner,
85     address indexed newOwner
86   );
87 
88 
89   /**
90    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91    * account.
92    */
93   constructor() public {
94     owner = msg.sender;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104 
105   /**
106    * @dev Allows the current owner to relinquish control of the contract.
107    * @notice Renouncing to ownership will leave the contract without an owner.
108    * It will not be possible to call the functions with the `onlyOwner`
109    * modifier anymore.
110    */
111   function renounceOwnership() public onlyOwner {
112     emit OwnershipRenounced(owner);
113     owner = address(0);
114   }
115 
116   /**
117    * @dev Allows the current owner to transfer control of the contract to a newOwner.
118    * @param _newOwner The address to transfer ownership to.
119    */
120   function transferOwnership(address _newOwner) public onlyOwner {
121     _transferOwnership(_newOwner);
122   }
123 
124   /**
125    * @dev Transfers control of the contract to a newOwner.
126    * @param _newOwner The address to transfer ownership to.
127    */
128   function _transferOwnership(address _newOwner) internal {
129     require(_newOwner != address(0));
130     emit OwnershipTransferred(owner, _newOwner);
131     owner = _newOwner;
132   }
133 }
134 
135 contract Magino is Ownable {
136     ABL abl;
137 
138     constructor(ABL _abl) public {
139         abl = _abl;
140     }
141 
142     function addOwner(address guest) public onlyOwner {
143         require(address(this) != guest, "No suicide.");
144         abl.addOwner(guest);
145     }
146 }
147 
148 contract ERC20Basic {
149   function totalSupply() public view returns (uint256);
150   function balanceOf(address _who) public view returns (uint256);
151   function transfer(address _to, uint256 _value) public returns (bool);
152   event Transfer(address indexed from, address indexed to, uint256 value);
153 }
154 
155 contract BasicToken is ERC20Basic {
156   using SafeMath for uint256;
157 
158   mapping(address => uint256) internal balances;
159 
160   uint256 internal totalSupply_;
161 
162   /**
163   * @dev Total number of tokens in existence
164   */
165   function totalSupply() public view returns (uint256) {
166     return totalSupply_;
167   }
168 
169   /**
170   * @dev Transfer token for a specified address
171   * @param _to The address to transfer to.
172   * @param _value The amount to be transferred.
173   */
174   function transfer(address _to, uint256 _value) public returns (bool) {
175     require(_value <= balances[msg.sender]);
176     require(_to != address(0));
177 
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     emit Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public view returns (uint256) {
190     return balances[_owner];
191   }
192 
193 }
194 
195 contract ERC20 is ERC20Basic {
196   function allowance(address _owner, address _spender)
197     public view returns (uint256);
198 
199   function transferFrom(address _from, address _to, uint256 _value)
200     public returns (bool);
201 
202   function approve(address _spender, uint256 _value) public returns (bool);
203   event Approval(
204     address indexed owner,
205     address indexed spender,
206     uint256 value
207   );
208 }
209 
210 contract StandardToken is ERC20, BasicToken {
211 
212   mapping (address => mapping (address => uint256)) internal allowed;
213 
214 
215   /**
216    * @dev Transfer tokens from one address to another
217    * @param _from address The address which you want to send tokens from
218    * @param _to address The address which you want to transfer to
219    * @param _value uint256 the amount of tokens to be transferred
220    */
221   function transferFrom(
222     address _from,
223     address _to,
224     uint256 _value
225   )
226     public
227     returns (bool)
228   {
229     require(_value <= balances[_from]);
230     require(_value <= allowed[_from][msg.sender]);
231     require(_to != address(0));
232 
233     balances[_from] = balances[_from].sub(_value);
234     balances[_to] = balances[_to].add(_value);
235     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236     emit Transfer(_from, _to, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
242    * Beware that changing an allowance with this method brings the risk that someone may use both the old
243    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
244    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
245    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246    * @param _spender The address which will spend the funds.
247    * @param _value The amount of tokens to be spent.
248    */
249   function approve(address _spender, uint256 _value) public returns (bool) {
250     allowed[msg.sender][_spender] = _value;
251     emit Approval(msg.sender, _spender, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Function to check the amount of tokens that an owner allowed to a spender.
257    * @param _owner address The address which owns the funds.
258    * @param _spender address The address which will spend the funds.
259    * @return A uint256 specifying the amount of tokens still available for the spender.
260    */
261   function allowance(
262     address _owner,
263     address _spender
264    )
265     public
266     view
267     returns (uint256)
268   {
269     return allowed[_owner][_spender];
270   }
271 
272   /**
273    * @dev Increase the amount of tokens that an owner allowed to a spender.
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _addedValue The amount of tokens to increase the allowance by.
280    */
281   function increaseApproval(
282     address _spender,
283     uint256 _addedValue
284   )
285     public
286     returns (bool)
287   {
288     allowed[msg.sender][_spender] = (
289       allowed[msg.sender][_spender].add(_addedValue));
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   /**
295    * @dev Decrease the amount of tokens that an owner allowed to a spender.
296    * approve should be called when allowed[_spender] == 0. To decrement
297    * allowed value is better to use this function to avoid 2 calls (and wait until
298    * the first transaction is mined)
299    * From MonolithDAO Token.sol
300    * @param _spender The address which will spend the funds.
301    * @param _subtractedValue The amount of tokens to decrease the allowance by.
302    */
303   function decreaseApproval(
304     address _spender,
305     uint256 _subtractedValue
306   )
307     public
308     returns (bool)
309   {
310     uint256 oldValue = allowed[msg.sender][_spender];
311     if (_subtractedValue >= oldValue) {
312       allowed[msg.sender][_spender] = 0;
313     } else {
314       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
315     }
316     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
317     return true;
318   }
319 
320 }
321 
322 contract ABL is StandardToken, OwnableToken {
323     using SafeMath for uint256;
324 
325     // Token Distribution Rate
326     uint256 public constant SUM = 400000000;   // totalSupply
327     uint256 public constant DISTRIBUTION = 221450000; // distribution
328     uint256 public constant DEVELOPERS = 178550000;   // developer
329 
330     // Token Information
331     string public constant name = "Airbloc";
332     string public constant symbol = "ABL";
333     uint256 public constant decimals = 18;
334     uint256 public totalSupply = SUM.mul(10 ** uint256(decimals));
335 
336     // token is non-transferable until owner calls unlock()
337     // (to prevent OTC before the token to be listed on exchanges)
338     bool isTransferable = false;
339 
340     function ABL(
341         address _dtb,
342         address _dev
343     ) public {
344         require(_dtb != address(0));
345         require(_dev != address(0));
346         require(DISTRIBUTION + DEVELOPERS == SUM);
347 
348         balances[_dtb] = DISTRIBUTION.mul(10 ** uint256(decimals));
349         emit Transfer(address(0), _dtb, balances[_dtb]);
350 
351         balances[_dev] = DEVELOPERS.mul(10 ** uint256(decimals));
352         emit Transfer(address(0), _dev, balances[_dev]);
353     }
354 
355     function unlock() external onlyOwner {
356         isTransferable = true;
357     }
358 
359     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
360         require(isTransferable || owners[msg.sender]);
361         return super.transferFrom(_from, _to, _value);
362     }
363 
364     function transfer(address _to, uint256 _value) public returns (bool) {
365         require(isTransferable || owners[msg.sender]);
366         return super.transfer(_to, _value);
367     }
368 
369     //////////////////////
370     //  mint and burn   //
371     //////////////////////
372     function mint(
373         address _to,
374         uint256 _amount
375     ) onlyOwner public returns (bool) {
376         require(_to != address(0));
377         require(_amount >= 0);
378 
379         uint256 amount = _amount.mul(10 ** uint256(decimals));
380 
381         totalSupply = totalSupply.add(amount);
382         balances[_to] = balances[_to].add(amount);
383 
384         emit Mint(_to, amount);
385         emit Transfer(address(0), _to, amount);
386 
387         return true;
388     }
389 
390     function burn(
391         uint256 _amount
392     ) onlyOwner public {
393         require(_amount >= 0);
394         require(_amount <= balances[msg.sender]);
395 
396         totalSupply = totalSupply.sub(_amount.mul(10 ** uint256(decimals)));
397         balances[msg.sender] = balances[msg.sender].sub(_amount.mul(10 ** uint256(decimals)));
398 
399         emit Burn(msg.sender, _amount.mul(10 ** uint256(decimals)));
400         emit Transfer(msg.sender, address(0), _amount.mul(10 ** uint256(decimals)));
401     }
402 
403     event Mint(address indexed _to, uint256 _amount);
404     event Burn(address indexed _from, uint256 _amount);
405 }