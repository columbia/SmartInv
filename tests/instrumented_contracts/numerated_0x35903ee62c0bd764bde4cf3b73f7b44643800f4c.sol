1 pragma solidity ^0.4.24;
2 contract ERC20 {
3   function totalSupply() public view returns (uint256);
4 
5   function balanceOf(address _who) public view returns (uint256);
6 
7   function allowance(address _owner, address _spender)
8     public view returns (uint256);
9 
10   function transfer(address _to, uint256 _value) public returns (bool);
11 
12   function approve(address _spender, uint256 _value)
13     public returns (bool);
14 
15   function transferFrom(address _from, address _to, uint256 _value)
16     public returns (bool);
17 
18   event Transfer(
19     address indexed from,
20     address indexed to,
21     uint256 value
22   );
23 
24   event Approval(
25     address indexed owner,
26     address indexed spender,
27     uint256 value
28   );
29 }
30 
31 interface TokenRecipient {
32   function receiveApproval(address _sender, uint256 _value,  bytes _data) external returns (bool ok);
33 }
34 
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, throws on overflow.
39   */
40   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
42     // benefit is lost if 'b' is also tested.
43     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44     if (_a == 0) {
45       return 0;
46     }
47 
48     uint256 c = _a * _b;
49     assert(c / _a == _b);
50 
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
58     // assert(_b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = _a / _b;
60     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
61 
62     return c;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
69     assert(_b <= _a);
70     uint256 c = _a - _b;
71 
72     return c;
73   }
74 
75   /**
76   * @dev Adds two numbers, throws on overflow.
77   */
78   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
79     uint256 c = _a + _b;
80     assert(c >= _a);
81 
82     return c;
83   }
84 
85   /**
86    * @dev gives square root of given x.
87    */
88   function sqrt(uint256 x)
89       internal
90       pure
91       returns (uint256 y)
92   {
93       uint256 z = ((add(x,1)) / 2);
94       y = x;
95       while (z < y)
96       {
97           y = z;
98           z = ((add((x / z),z)) / 2);
99       }
100   }
101 
102   /**
103    * @dev gives square. multiplies x by x
104    */
105   function sq(uint256 x)
106       internal
107       pure
108       returns (uint256)
109   {
110       return (mul(x,x));
111   }
112 
113   /**
114    * @dev x to the power of y
115    */
116   function pwr(uint256 x, uint256 y)
117       internal
118       pure
119       returns (uint256)
120   {
121       if (x==0)
122           return (0);
123       else if (y==0)
124           return (1);
125       else
126       {
127           uint256 z = x;
128           for (uint256 i=1; i < y; i++)
129               z = mul(z,x);
130           return (z);
131       }
132   }
133 }
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 
140 
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * https://github.com/ethereum/EIPs/issues/20
147  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20 {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   mapping (address => mapping (address => uint256)) internal allowed;
155 
156   uint256 totalSupply_;
157 
158   /**
159   * @dev Total number of tokens in existence
160   */
161   function totalSupply() public view returns (uint256) {
162     return totalSupply_;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(
181     address _owner,
182     address _spender
183    )
184     public
185     view
186     returns (uint256)
187   {
188     return allowed[_owner][_spender];
189   }
190 
191   /**
192   * @dev Transfer token for a specified address
193   * @param _to The address to transfer to.
194   * @param _value The amount to be transferred.
195   */
196   function transfer(address _to, uint256 _value) public returns (bool) {
197     require(_value <= balances[msg.sender]);
198     require(_to != address(0));
199 
200     balances[msg.sender] = balances[msg.sender].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     emit Transfer(msg.sender, _to, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param _spender The address which will spend the funds.
213    * @param _value The amount of tokens to be spent.
214    */
215   function approve(address _spender, uint256 _value) public returns (bool) {
216     allowed[msg.sender][_spender] = _value;
217     emit Approval(msg.sender, _spender, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Transfer tokens from one address to another
223    * @param _from address The address which you want to send tokens from
224    * @param _to address The address which you want to transfer to
225    * @param _value uint256 the amount of tokens to be transferred
226    */
227   function transferFrom(
228     address _from,
229     address _to,
230     uint256 _value
231   )
232     public
233     returns (bool)
234   {
235     require(_value <= balances[_from]);
236     require(_value <= allowed[_from][msg.sender]);
237     require(_to != address(0));
238 
239     balances[_from] = balances[_from].sub(_value);
240     balances[_to] = balances[_to].add(_value);
241     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242     emit Transfer(_from, _to, _value);
243     return true;
244   }
245 
246 
247   function transferContract(address _to, uint256 _value, bytes _data) public
248     returns (bool success)
249   {
250     bool isContract = false;
251     // solium-disable-next-line security/no-inline-assembly
252     assembly {
253       isContract := not(iszero(extcodesize(_to)))
254     }
255     if (isContract) {
256       transfer(_to, _value);
257       TokenRecipient receiver = TokenRecipient(_to);
258       require(receiver.receiveApproval(msg.sender, _value, _data));//call another contract
259     }
260     return isContract;
261   }
262 
263   /*
264   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
265       TokenRecipient spender = TokenRecipient(_spender);
266       if (approve(_spender, _value)) {
267           spender.receiveApproval(msg.sender, _value, this, _extraData);
268           return true;
269       }
270   }
271   */
272 
273   /**
274    * @dev Increase the amount of tokens that an owner allowed to a spender.
275    * approve should be called when allowed[_spender] == 0. To increment
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _addedValue The amount of tokens to increase the allowance by.
281    */
282   function increaseApproval(
283     address _spender,
284     uint256 _addedValue
285   )
286     public
287     returns (bool)
288   {
289     allowed[msg.sender][_spender] = (
290       allowed[msg.sender][_spender].add(_addedValue));
291     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292     return true;
293   }
294 
295   /**
296    * @dev Decrease the amount of tokens that an owner allowed to a spender.
297    * approve should be called when allowed[_spender] == 0. To decrement
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param _spender The address which will spend the funds.
302    * @param _subtractedValue The amount of tokens to decrease the allowance by.
303    */
304   function decreaseApproval(
305     address _spender,
306     uint256 _subtractedValue
307   )
308     public
309     returns (bool)
310   {
311     uint256 oldValue = allowed[msg.sender][_spender];
312     if (_subtractedValue >= oldValue) {
313       allowed[msg.sender][_spender] = 0;
314     } else {
315       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
316     }
317     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
318     return true;
319   }
320 
321 }
322 
323 /**
324  * @title Burnable Token
325  * @dev Token that can be irreversibly burned (destroyed).
326  */
327 contract BurnableToken is StandardToken {
328 
329   event Burn(address indexed burner, uint256 value);
330 
331   /**
332    * @dev Burns a specific amount of tokens.
333    * @param _value The amount of token to be burned.
334    */
335   function burn(uint256 _value) public {
336     _burn(msg.sender, _value);
337   }
338 
339   /**
340    * @dev Burns a specific amount of tokens from the target address and decrements allowance
341    * @param _from address The address which you want to send tokens from
342    * @param _value uint256 The amount of token to be burned
343    */
344   function burnFrom(address _from, uint256 _value) public {
345     require(_value <= allowed[_from][msg.sender]);
346     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
347     // this function needs to emit an event with the updated approval.
348     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
349     _burn(_from, _value);
350   }
351 
352   function _burn(address _who, uint256 _value) internal {
353     require(_value <= balances[_who]);
354     // no need to require value <= totalSupply, since that would imply the
355     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
356 
357     balances[_who] = balances[_who].sub(_value);
358     totalSupply_ = totalSupply_.sub(_value);
359     emit Burn(_who, _value);
360     emit Transfer(_who, address(0), _value);
361   }
362 }
363 
364 
365 contract PCToken is BurnableToken {
366 
367 //  using SafeMath for uint256;
368   // metadata
369   string public constant name = "PetCraftToken";
370   string public constant symbol = "PCTOKEN";
371   uint256 public constant decimals = 18;
372   string public version = "1.0";
373 
374   // deposit address
375   address public inGameRewardAddress;
376   address public developerAddress;
377 
378   // constructor
379   constructor(address _financeContract) public {
380       require(_financeContract != address(0));
381       inGameRewardAddress = _financeContract;
382       developerAddress = msg.sender;
383 
384       balances[inGameRewardAddress] = 300000000 * 10**uint(decimals);
385       balances[developerAddress] = 1200000000 * 10**uint(decimals);
386       totalSupply_ = balances[inGameRewardAddress]  + balances[developerAddress];
387   }
388 }