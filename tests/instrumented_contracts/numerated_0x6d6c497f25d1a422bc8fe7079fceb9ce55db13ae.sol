1 /**
2  * Source Code first verified at https://etherscan.io on Monday, April 29, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 contract ERC223Interface {
8     function totalSupply() public view returns (uint256);
9     function balanceOf(address _who) public view returns (uint256);
10     function transfer(address _to, uint256 _value) public returns (bool);
11     function allowance(address _owner, address _spender) public view returns (uint256);
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
13     function approve(address _spender, uint256 _value) public returns (bool);
14     
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Transfer(address indexed from, address indexed to, uint value, bytes data);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20  /**
21  * @title Contract that will work with ERC223 tokens.
22  */
23  
24 contract ERC223ReceivingContract { 
25 /**
26  * @dev Standard ERC223 function that will handle incoming token transfers.
27  *
28  * @param _from  Token sender address.
29  * @param _value Amount of tokens.
30  * @param _data  Transaction metadata.
31  */
32     function tokenFallback(address _from, uint _value, bytes _data) public;
33 }
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipRenounced(address indexed previousOwner);
45   event OwnershipTransferred(
46     address indexed previousOwner,
47     address indexed newOwner
48   );
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   constructor() public {
56     owner = msg.sender;
57   }
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67   /**
68    * @dev Allows the current owner to relinquish control of the contract.
69    * @notice Renouncing to ownership will leave the contract without an owner.
70    * It will not be possible to call the functions with the `onlyOwner`
71    * modifier anymore.
72    */
73   function renounceOwnership() public onlyOwner {
74     emit OwnershipRenounced(owner);
75     owner = address(0);
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param _newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address _newOwner) public onlyOwner {
83     _transferOwnership(_newOwner);
84   }
85 
86   /**
87    * @dev Transfers control of the contract to a newOwner.
88    * @param _newOwner The address to transfer ownership to.
89    */
90   function _transferOwnership(address _newOwner) internal {
91     require(_newOwner != address(0));
92     emit OwnershipTransferred(owner, _newOwner);
93     owner = _newOwner;
94   }
95 }
96 
97 
98 /**
99  * @title Pausable
100  * @dev Base contract which allows children to implement an emergency stop mechanism.
101  */
102 contract Pausable is Ownable {
103   event Pause();
104   event Unpause();
105 
106   bool public paused = false;
107 
108 
109   /**
110    * @dev Modifier to make a function callable only when the contract is not paused.
111    */
112   modifier whenNotPaused() {
113     require(!paused);
114     _;
115   }
116 
117   /**
118    * @dev Modifier to make a function callable only when the contract is paused.
119    */
120   modifier whenPaused() {
121     require(paused);
122     _;
123   }
124 
125   /**
126    * @dev called by the owner to pause, triggers stopped state
127    */
128   function pause() public onlyOwner whenNotPaused {
129     paused = true;
130     emit Pause();
131   }
132 
133   /**
134    * @dev called by the owner to unpause, returns to normal state
135    */
136   function unpause() public onlyOwner whenPaused {
137     paused = false;
138     emit Unpause();
139   }
140 }
141 
142 /**
143  * @title SafeMath
144  * @dev Math operations with safety checks that throw on error
145  */
146 library SafeMath {
147 
148   /**
149   * @dev Multiplies two numbers, throws on overflow.
150   */
151   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
152     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
153     // benefit is lost if 'b' is also tested.
154     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
155     if (_a == 0) {
156       return 0;
157     }
158 
159     c = _a * _b;
160     assert(c / _a == _b);
161     return c;
162   }
163 
164   /**
165   * @dev Integer division of two numbers, truncating the quotient.
166   */
167   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
168     // assert(_b > 0); // Solidity automatically throws when dividing by 0
169     // uint256 c = _a / _b;
170     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
171     return _a / _b;
172   }
173 
174   /**
175   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
176   */
177   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
178     assert(_b <= _a);
179     return _a - _b;
180   }
181 
182   /**
183   * @dev Adds two numbers, throws on overflow.
184   */
185   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
186     c = _a + _b;
187     assert(c >= _a);
188     return c;
189   }
190 }
191 
192 contract SRATOKEN is ERC223Interface, Pausable {
193     using SafeMath for uint256;
194     
195     string internal _name;
196     string internal _symbol;
197     uint8 internal _decimals;
198     uint256 internal _totalSupply;
199     
200     mapping (address => uint256) internal balances;
201     mapping (address => mapping (address => uint256)) internal allowed;
202     mapping (address => bool) public frozenAccount;
203     
204     event FrozenFunds(address target, bool frozen);
205     
206     constructor(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
207         _name = name;
208         _symbol = symbol;
209         _decimals = decimals;
210         _totalSupply = totalSupply;
211         balances[msg.sender] = totalSupply;
212     }
213     
214     function name() public view returns (string) {
215         return _name;
216     }
217     
218     function symbol() public view returns (string) {
219         return _symbol;
220     }
221     
222     function decimals() public view returns (uint8) {
223         return _decimals;
224     }
225     
226     function totalSupply() public view returns (uint256) {
227         return _totalSupply;
228     }
229     
230     function balanceOf(address _owner) public view returns (uint256 balance) {
231         return balances[_owner];
232     }
233     
234     function freezeAccount(address target, bool freeze) 
235     public 
236     onlyOwner
237     {
238         frozenAccount[target] = freeze;
239         emit FrozenFunds(target, freeze);
240     }
241     
242     function transfer(address _to, uint256 _value) 
243     public
244     whenNotPaused
245     returns (bool) 
246     {
247         require(_value > 0 );
248         require(_value <= balances[msg.sender]);
249         require(!frozenAccount[_to]);
250         require(!frozenAccount[msg.sender]);
251         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
252         balances[_to] = SafeMath.add(balances[_to], _value);
253         emit Transfer(msg.sender, _to, _value);
254         return true;
255     }
256     
257     function transfer(address _to, uint _value, bytes _data) 
258     public
259     whenNotPaused
260     returns (bool)
261     {
262         require(_value > 0 );
263         require(!frozenAccount[_to]);
264         require(!frozenAccount[msg.sender]);
265         if(isContract(_to)) {
266             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
267             receiver.tokenFallback(msg.sender, _value, _data);
268         }
269         balances[msg.sender] = balances[msg.sender].sub(_value);
270         balances[_to] = balances[_to].add(_value);
271         emit Transfer(msg.sender, _to, _value, _data);
272         return true;
273     }
274     
275     function isContract(address _addr) 
276     private
277     view
278     returns (bool is_contract) 
279     {
280         uint length;
281         assembly {
282             //retrieve the size of the code on target address, this needs assembly
283             length := extcodesize(_addr)
284         }
285         return (length>0);
286     }
287     
288     function transferFrom(address _from, address _to, uint256 _value) 
289     public
290     whenNotPaused
291     returns (bool) 
292     {
293         require(_value > 0 );
294         require(_value <= balances[_from]);
295         require(_value <= allowed[_from][msg.sender]);
296         require(!frozenAccount[_to]);
297         require(!frozenAccount[_from]);
298         
299         balances[_from] = SafeMath.sub(balances[_from], _value);
300         balances[_to] = SafeMath.add(balances[_to], _value);
301         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
302         emit Transfer(_from, _to, _value);
303         return true;
304     }
305     
306     function approve(address _spender, uint256 _value) 
307     public
308     whenNotPaused
309     returns (bool) 
310     {
311         allowed[msg.sender][_spender] = _value;
312         emit Approval(msg.sender, _spender, _value);
313         return true;
314     }
315     
316     function allowance(address _owner, address _spender) 
317     public
318     view
319     returns (uint256) 
320     {
321         return allowed[_owner][_spender];
322     }
323     
324     function increaseApproval(address _spender, uint _addedValue) 
325     public
326     whenNotPaused
327     returns (bool) 
328     {
329         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
330         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
331         return true;
332     }
333     
334     function decreaseApproval(address _spender, uint _subtractedValue) 
335     public
336     whenNotPaused
337     returns (bool) 
338     {
339         uint oldValue = allowed[msg.sender][_spender];
340         if (_subtractedValue > oldValue) {
341             allowed[msg.sender][_spender] = 0;
342         } else {
343             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
344         }
345         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346         return true;
347     }
348     
349     function distributeAirdrop(address[] addresses, uint256 amount) 
350     public
351     returns (bool seccess) 
352     {
353         require(amount > 0);
354         require(addresses.length > 0);
355         require(!frozenAccount[msg.sender]);
356         
357         uint256 totalAmount = amount.mul(addresses.length);
358         require(balances[msg.sender] >= totalAmount);
359         bytes memory empty;
360         
361         for (uint i = 0; i < addresses.length; i++) {
362             require(addresses[i] != address(0));
363             require(!frozenAccount[addresses[i]]);
364             balances[addresses[i]] = balances[addresses[i]].add(amount);
365             emit Transfer(msg.sender, addresses[i], amount, empty);
366         }
367         balances[msg.sender] = balances[msg.sender].sub(totalAmount);
368         
369         return true;
370     }
371     
372     function distributeAirdrop(address[] addresses, uint256[] amounts) 
373     public returns (bool) {
374         require(addresses.length > 0);
375         require(addresses.length == amounts.length);
376         require(!frozenAccount[msg.sender]);
377         
378         uint256 totalAmount = 0;
379         
380         for(uint i = 0; i < addresses.length; i++){
381             require(amounts[i] > 0);
382             require(addresses[i] != address(0));
383             require(!frozenAccount[addresses[i]]);
384             
385             totalAmount = totalAmount.add(amounts[i]);
386         }
387         require(balances[msg.sender] >= totalAmount);
388         
389         bytes memory empty;
390         for (i = 0; i < addresses.length; i++) {
391             balances[addresses[i]] = balances[addresses[i]].add(amounts[i]);
392             emit Transfer(msg.sender, addresses[i], amounts[i], empty);
393         }
394         balances[msg.sender] = balances[msg.sender].sub(totalAmount);
395         return true;
396     }
397     
398     /**
399      * @dev Function to collect tokens from the list of addresses
400      */
401     function collectTokens(address[] addresses, uint256[] amounts) 
402     public
403     onlyOwner 
404     returns (bool) {
405         require(addresses.length > 0);
406         require(addresses.length == amounts.length);
407 
408         uint256 totalAmount = 0;
409         bytes memory empty;
410         
411         for (uint j = 0; j < addresses.length; j++) {
412             require(amounts[j] > 0);
413             require(addresses[j] != address(0));
414             require(!frozenAccount[addresses[j]]);
415                     
416             require(balances[addresses[j]] >= amounts[j]);
417             balances[addresses[j]] = balances[addresses[j]].sub(amounts[j]);
418             totalAmount = totalAmount.add(amounts[j]);
419             emit Transfer(addresses[j], msg.sender, amounts[j], empty);
420         }
421         balances[msg.sender] = balances[msg.sender].add(totalAmount);
422         return true;
423     }
424 }