1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // TOKENMOM Korean Won(KRWT) Smart contract Token V.10
5 // 토큰맘 거래소 Korean Won 스마트 컨트랙트 토큰
6 // Deployed to : 0x8af2d2e23f0913af81abc6ccaa6200c945a161b4
7 // Symbol      : BETA
8 // Name        : TOKENMOM Korean Won
9 // Total supply: 100000000000
10 // Decimals    : 8
11 // ----------------------------------------------------------------------------
12 
13 contract ERC20Basic {
14   function totalSupply() public view returns (uint256);
15   function balanceOf(address who) public view returns (uint256);
16   function transfer(address to, uint256 value) public returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 library SafeMath {
21 
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38 
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   uint256 totalSupply_;
58 
59   function totalSupply() public view returns (uint256) {
60     return totalSupply_;
61   }
62 
63 
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[msg.sender]);
67 
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     emit Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   function balanceOf(address _owner) public view returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) public view returns (uint256);
82   function transferFrom(address from, address to, uint256 value) public returns (bool);
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[_from]);
94     require(_value <= allowed[_from][msg.sender]);
95 
96     balances[_from] = balances[_from].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99     emit Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     allowed[msg.sender][_spender] = _value;
105     emit Approval(msg.sender, _spender, _value);
106     return true;
107   }
108 
109   function allowance(address _owner, address _spender) public view returns (uint256) {
110     return allowed[_owner][_spender];
111   }
112 
113 
114   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
115     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
116     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
117     return true;
118   }
119 
120   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
121     uint oldValue = allowed[msg.sender][_spender];
122     if (_subtractedValue > oldValue) {
123       allowed[msg.sender][_spender] = 0;
124     } else {
125       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
126     }
127     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 }
131 
132 contract Ownable {
133   address public owner;
134 
135 
136   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138 
139   /**
140    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
141    * account.
142    */
143   function Ownable() public {
144     owner = msg.sender;
145   }
146 
147   /**
148    * @dev Throws if called by any account other than the owner.
149    */
150   modifier onlyOwner() {
151     require(msg.sender == owner);
152     _;
153   }
154 
155   /**
156    * @dev Allows the current owner to transfer control of the contract to a newOwner.
157    * @param newOwner The address to transfer ownership to.
158    */
159   function transferOwnership(address newOwner) public onlyOwner {
160     require(newOwner != address(0));
161     emit OwnershipTransferred(owner, newOwner);
162     owner = newOwner;
163   }
164 
165 }
166 
167 contract MintableToken is StandardToken, Ownable {
168   event Mint(address indexed to, uint256 amount);
169   event MintFinished();
170 
171   bool public mintingFinished = false;
172 
173 
174   modifier canMint() {
175     require(!mintingFinished);
176     _;
177   }
178 
179   /**
180    * @dev Function to mint tokens
181    * @param _to The address that will receive the minted tokens.
182    * @param _amount The amount of tokens to mint.
183    * @return A boolean that indicates if the operation was successful.
184    */
185   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
186     totalSupply_ = totalSupply_.add(_amount);
187     balances[_to] = balances[_to].add(_amount);
188     emit Mint(_to, _amount);
189     emit Transfer(address(0), _to, _amount);
190     return true;
191   }
192 
193   /**
194    * @dev Function to stop minting new tokens.
195    * @return True if the operation was successful.
196    */
197   function finishMinting() onlyOwner canMint public returns (bool) {
198     mintingFinished = true;
199     emit MintFinished();
200     return true;
201   }
202 }
203 
204 /**
205  * @title Burnable Token
206  * @dev Token that can be irreversibly burned (destroyed).
207  */
208 contract BurnableToken is BasicToken {
209 
210   event Burn(address indexed burner, uint256 value);
211 
212   /**
213    * @dev Burns a specific amount of tokens.
214    * @param _value The amount of token to be burned.
215    */
216   function burn(uint256 _value) public {
217     require(_value <= balances[msg.sender]);
218     // no need to require value <= totalSupply, since that would imply the
219     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
220 
221     address burner = msg.sender;
222     balances[burner] = balances[burner].sub(_value);
223     totalSupply_ = totalSupply_.sub(_value);
224     emit Burn(burner, _value);
225     emit Transfer(burner, address(0), _value);
226   }
227 }
228 
229 /**
230  * @title Capped token
231  * @dev Mintable token with a token cap.
232  */
233 contract CappedToken is MintableToken {
234 
235   uint256 public cap;
236 
237   function CappedToken(uint256 _cap) public {
238     require(_cap > 0);
239     cap = _cap;
240   }
241 
242   /**
243    * @dev Function to mint tokens
244    * @param _to The address that will receive the minted tokens.
245    * @param _amount The amount of tokens to mint.
246    * @return A boolean that indicates if the operation was successful.
247    */
248   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
249     require(totalSupply_.add(_amount) <= cap);
250 
251     return super.mint(_to, _amount);
252   }
253 
254 }
255 
256 /**
257  * @title Pausable
258  * @dev Base contract which allows children to implement an emergency stop mechanism.
259  */
260 contract Pausable is Ownable {
261   event Pause();
262   event Unpause();
263 
264   bool public paused = false;
265 
266 
267   /**
268    * @dev Modifier to make a function callable only when the contract is not paused.
269    */
270   modifier whenNotPaused() {
271     require(!paused);
272     _;
273   }
274 
275   /**
276    * @dev Modifier to make a function callable only when the contract is paused.
277    */
278   modifier whenPaused() {
279     require(paused);
280     _;
281   }
282 
283   /**
284    * @dev called by the owner to pause, triggers stopped state
285    */
286   function pause() onlyOwner whenNotPaused public {
287     paused = true;
288     emit Pause();
289   }
290 
291   /**
292    * @dev called by the owner to unpause, returns to normal state
293    */
294   function unpause() onlyOwner whenPaused public {
295     paused = false;
296     emit Unpause();
297   }
298 }
299 
300 
301 contract PausableToken is StandardToken, Pausable {
302 
303   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
304     return super.transfer(_to, _value);
305   }
306 
307   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
308     return super.transferFrom(_from, _to, _value);
309   }
310 
311   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
312     return super.approve(_spender, _value);
313   }
314 
315   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
316     return super.increaseApproval(_spender, _addedValue);
317   }
318 
319   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
320     return super.decreaseApproval(_spender, _subtractedValue);
321   }
322 }
323 
324 contract ERC827 is ERC20 {
325 
326   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
327   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
328   function transferFrom(
329     address _from,
330     address _to,
331     uint256 _value,
332     bytes _data
333   )
334     public
335     returns (bool);
336 
337 }
338 
339 contract ERC827Token is ERC827, StandardToken {
340 
341   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
342     require(_spender != address(this));
343 
344     super.approve(_spender, _value);
345 
346     require(_spender.call(_data));
347 
348     return true;
349   }
350 
351   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
352     require(_to != address(this));
353 
354     super.transfer(_to, _value);
355 
356     require(_to.call(_data));
357     return true;
358   }
359 
360   function transferFrom(
361     address _from,
362     address _to,
363     uint256 _value,
364     bytes _data
365   )
366     public returns (bool)
367   {
368     require(_to != address(this));
369 
370     super.transferFrom(_from, _to, _value);
371 
372     require(_to.call(_data));
373     return true;
374   }
375 
376   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
377     require(_spender != address(this));
378 
379     super.increaseApproval(_spender, _addedValue);
380 
381     require(_spender.call(_data));
382 
383     return true;
384   }
385 
386   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
387     require(_spender != address(this));
388 
389     super.decreaseApproval(_spender, _subtractedValue);
390 
391     require(_spender.call(_data));
392 
393     return true;
394   }
395 
396 }
397 
398 contract KRWT is StandardToken, MintableToken, BurnableToken, PausableToken {
399     string constant public name = "Korean Won";
400     string constant public symbol = "KRWT";
401     uint8 constant public decimals = 8;
402     uint public totalSupply = 100000000000 * 10**uint(decimals);
403 
404     function KRWT () public {
405         balances[msg.sender] = totalSupply;
406     }
407 }