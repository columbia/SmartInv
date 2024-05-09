1 pragma solidity ^0.4.24;
2 
3 contract ERC223Interface {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address _who) public view returns (uint256);
6     function transfer(address _to, uint256 _value) public returns (bool);
7     function allowance(address _owner, address _spender) public view returns (uint256);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
9     function approve(address _spender, uint256 _value) public returns (bool);
10     
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Transfer(address indexed from, address indexed to, uint value, bytes data);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16  /**
17  * @title Contract that will work with ERC223 tokens.
18  */
19  
20 contract ERC223ReceivingContract { 
21 /**
22  * @dev Standard ERC223 function that will handle incoming token transfers.
23  *
24  * @param _from  Token sender address.
25  * @param _value Amount of tokens.
26  * @param _data  Transaction metadata.
27  */
28     function tokenFallback(address _from, uint _value, bytes _data) public;
29 }
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipRenounced(address indexed previousOwner);
41   event OwnershipTransferred(
42     address indexed previousOwner,
43     address indexed newOwner
44   );
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to relinquish control of the contract.
65    * @notice Renouncing to ownership will leave the contract without an owner.
66    * It will not be possible to call the functions with the `onlyOwner`
67    * modifier anymore.
68    */
69   function renounceOwnership() public onlyOwner {
70     emit OwnershipRenounced(owner);
71     owner = address(0);
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param _newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address _newOwner) public onlyOwner {
79     _transferOwnership(_newOwner);
80   }
81 
82   /**
83    * @dev Transfers control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function _transferOwnership(address _newOwner) internal {
87     require(_newOwner != address(0));
88     emit OwnershipTransferred(owner, _newOwner);
89     owner = _newOwner;
90   }
91 }
92 
93 
94 /**
95  * @title Pausable
96  * @dev Base contract which allows children to implement an emergency stop mechanism.
97  */
98 contract Pausable is Ownable {
99   event Pause();
100   event Unpause();
101 
102   bool public paused = false;
103 
104 
105   /**
106    * @dev Modifier to make a function callable only when the contract is not paused.
107    */
108   modifier whenNotPaused() {
109     require(!paused);
110     _;
111   }
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is paused.
115    */
116   modifier whenPaused() {
117     require(paused);
118     _;
119   }
120 
121   /**
122    * @dev called by the owner to pause, triggers stopped state
123    */
124   function pause() public onlyOwner whenNotPaused {
125     paused = true;
126     emit Pause();
127   }
128 
129   /**
130    * @dev called by the owner to unpause, returns to normal state
131    */
132   function unpause() public onlyOwner whenPaused {
133     paused = false;
134     emit Unpause();
135   }
136 }
137 
138 /**
139  * @title SafeMath
140  * @dev Math operations with safety checks that throw on error
141  */
142 library SafeMath {
143 
144   /**
145   * @dev Multiplies two numbers, throws on overflow.
146   */
147   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
148     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
149     // benefit is lost if 'b' is also tested.
150     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
151     if (_a == 0) {
152       return 0;
153     }
154 
155     c = _a * _b;
156     assert(c / _a == _b);
157     return c;
158   }
159 
160   /**
161   * @dev Integer division of two numbers, truncating the quotient.
162   */
163   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
164     // assert(_b > 0); // Solidity automatically throws when dividing by 0
165     // uint256 c = _a / _b;
166     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
167     return _a / _b;
168   }
169 
170   /**
171   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
172   */
173   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
174     assert(_b <= _a);
175     return _a - _b;
176   }
177 
178   /**
179   * @dev Adds two numbers, throws on overflow.
180   */
181   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
182     c = _a + _b;
183     assert(c >= _a);
184     return c;
185   }
186 }
187 
188 
189 contract VictoryGlobalCoin is ERC223Interface, Pausable {
190     using SafeMath for uint256;
191     
192     string internal _name;
193     string internal _symbol;
194     uint8 internal _decimals;
195     uint256 internal _totalSupply;
196     
197     mapping (address => uint256) internal balances;
198     mapping (address => mapping (address => uint256)) internal allowed;
199     mapping (address => bool) public frozenAccount;
200     
201     event FrozenFunds(address target, bool frozen);
202     
203     constructor(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
204         _name = name;
205         _symbol = symbol;
206         _decimals = decimals;
207         _totalSupply = totalSupply;
208         balances[msg.sender] = totalSupply;
209     }
210     
211     function name() public view returns (string) {
212         return _name;
213     }
214     
215     function symbol() public view returns (string) {
216         return _symbol;
217     }
218     
219     function decimals() public view returns (uint8) {
220         return _decimals;
221     }
222     
223     function totalSupply() public view returns (uint256) {
224         return _totalSupply;
225     }
226     
227     function balanceOf(address _owner) public view returns (uint256 balance) {
228         return balances[_owner];
229     }
230     
231     function freezeAccount(address target, bool freeze) 
232     public 
233     onlyOwner
234     {
235         frozenAccount[target] = freeze;
236         emit FrozenFunds(target, freeze);
237     }
238     
239     function transfer(address _to, uint256 _value) 
240     public
241     whenNotPaused
242     returns (bool) 
243     {
244         require(_to != address(0));
245         require(_value <= balances[msg.sender]);
246         require(!frozenAccount[_to]);
247         require(!frozenAccount[msg.sender]);
248         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
249         balances[_to] = SafeMath.add(balances[_to], _value);
250         emit Transfer(msg.sender, _to, _value);
251         return true;
252     }
253     
254     function transfer(address _to, uint _value, bytes _data) 
255     public
256     whenNotPaused
257     returns (bool)
258     {
259         require(_value > 0 );
260         require(!frozenAccount[_to]);
261         require(!frozenAccount[msg.sender]);
262         if(isContract(_to)) {
263             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
264             receiver.tokenFallback(msg.sender, _value, _data);
265         }
266         balances[msg.sender] = balances[msg.sender].sub(_value);
267         balances[_to] = balances[_to].add(_value);
268         emit Transfer(msg.sender, _to, _value, _data);
269         return true;
270     }
271     
272     function isContract(address _addr) 
273     private
274     view
275     returns (bool is_contract) 
276     {
277         uint length;
278         assembly {
279             //retrieve the size of the code on target address, this needs assembly
280             length := extcodesize(_addr)
281         }
282         return (length>0);
283     }
284     
285     function transferFrom(address _from, address _to, uint256 _value) 
286     public
287     whenNotPaused
288     returns (bool) 
289     {
290         require(_to != address(0));
291         require(_value <= balances[_from]);
292         require(_value <= allowed[_from][msg.sender]);
293         require(!frozenAccount[_to]);
294         require(!frozenAccount[_from]);
295         
296         balances[_from] = SafeMath.sub(balances[_from], _value);
297         balances[_to] = SafeMath.add(balances[_to], _value);
298         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
299         emit Transfer(_from, _to, _value);
300         return true;
301     }
302     
303     function approve(address _spender, uint256 _value) 
304     public
305     whenNotPaused
306     returns (bool) 
307     {
308         allowed[msg.sender][_spender] = _value;
309         emit Approval(msg.sender, _spender, _value);
310         return true;
311     }
312     
313     function allowance(address _owner, address _spender) 
314     public
315     view
316     returns (uint256) 
317     {
318         return allowed[_owner][_spender];
319     }
320     
321     function increaseApproval(address _spender, uint _addedValue) 
322     public
323     whenNotPaused
324     returns (bool) 
325     {
326         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
327         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328         return true;
329     }
330     
331     function decreaseApproval(address _spender, uint _subtractedValue) 
332     public
333     whenNotPaused
334     returns (bool) 
335     {
336         uint oldValue = allowed[msg.sender][_spender];
337         if (_subtractedValue > oldValue) {
338             allowed[msg.sender][_spender] = 0;
339         } else {
340             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
341         }
342         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343         return true;
344     }
345     
346     function distributeAirdrop(address[] addresses, uint256 amount) 
347     public
348     returns (bool seccess) 
349     {
350         require(amount > 0);
351         require(addresses.length > 0);
352         require(!frozenAccount[msg.sender]);
353         
354         uint256 totalAmount = amount.mul(addresses.length);
355         require(balances[msg.sender] >= totalAmount);
356         bytes memory empty;
357         
358         for (uint i = 0; i < addresses.length; i++) {
359             require(addresses[i] != address(0));
360             require(!frozenAccount[addresses[i]]);
361             balances[addresses[i]] = balances[addresses[i]].add(amount);
362             emit Transfer(msg.sender, addresses[i], amount, empty);
363         }
364         balances[msg.sender] = balances[msg.sender].sub(totalAmount);
365         
366         return true;
367     }
368     
369     function distributeAirdrop(address[] addresses, uint256[] amounts) 
370     public returns (bool) {
371         require(addresses.length > 0);
372         require(addresses.length == amounts.length);
373         require(!frozenAccount[msg.sender]);
374         
375         uint256 totalAmount = 0;
376         
377         for(uint i = 0; i < addresses.length; i++){
378             require(amounts[i] > 0);
379             require(addresses[i] != address(0));
380             require(!frozenAccount[addresses[i]]);
381             
382             totalAmount = totalAmount.add(amounts[i]);
383         }
384         require(balances[msg.sender] >= totalAmount);
385         
386         bytes memory empty;
387         for (i = 0; i < addresses.length; i++) {
388             balances[addresses[i]] = balances[addresses[i]].add(amounts[i]);
389             emit Transfer(msg.sender, addresses[i], amounts[i], empty);
390         }
391         balances[msg.sender] = balances[msg.sender].sub(totalAmount);
392         return true;
393     }
394     
395     /**
396      * @dev Function to collect tokens from the list of addresses
397      */
398     function collectTokens(address[] addresses, uint256[] amounts) 
399     public
400     onlyOwner 
401     returns (bool) {
402         require(addresses.length > 0);
403         require(addresses.length == amounts.length);
404 
405         uint256 totalAmount = 0;
406         bytes memory empty;
407         
408         for (uint j = 0; j < addresses.length; j++) {
409             require(amounts[j] > 0);
410             require(addresses[j] != address(0));
411             require(!frozenAccount[addresses[j]]);
412                     
413             require(balances[addresses[j]] >= amounts[j]);
414             balances[addresses[j]] = balances[addresses[j]].sub(amounts[j]);
415             totalAmount = totalAmount.add(amounts[j]);
416             emit Transfer(addresses[j], msg.sender, amounts[j], empty);
417         }
418         balances[msg.sender] = balances[msg.sender].add(totalAmount);
419         return true;
420     }
421 }