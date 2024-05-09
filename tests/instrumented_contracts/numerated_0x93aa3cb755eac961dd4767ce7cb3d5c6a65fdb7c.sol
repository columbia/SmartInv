1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 /**
63  * @title ERC20Basic
64  * @dev Simpler version of ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/179
66  */
67 contract ERC20Basic {
68   function totalSupply() public view returns (uint256);
69   function balanceOf(address who) public view returns (uint256);
70   function transfer(address to, uint256 value) public returns (bool);
71   event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79 
80   /**
81   * @dev Multiplies two numbers, throws on overflow.
82   */
83   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
84     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
85     // benefit is lost if 'b' is also tested.
86     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87     if (a == 0) {
88       return 0;
89     }
90 
91     c = a * b;
92     assert(c / a == b);
93     return c;
94   }
95 
96   /**
97   * @dev Integer division of two numbers, truncating the quotient.
98   */
99   function div(uint256 a, uint256 b) internal pure returns (uint256) {
100     // assert(b > 0); // Solidity automatically throws when dividing by 0
101     // uint256 c = a / b;
102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103     return a / b;
104   }
105 
106   /**
107   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
108   */
109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   /**
115   * @dev Adds two numbers, throws on overflow.
116   */
117   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
118     c = a + b;
119     assert(c >= a);
120     return c;
121   }
122 }
123 
124 /**
125  * @title Basic token
126  * @dev Basic version of StandardToken, with no allowances.
127  */
128 contract BasicToken is ERC20Basic {
129   using SafeMath for uint256;
130 
131   mapping(address => uint256) balances;
132 
133   uint256 totalSupply_;
134 
135   /**
136   * @dev total number of tokens in existence
137   */
138   function totalSupply() public view returns (uint256) {
139     return totalSupply_;
140   }
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[msg.sender]);
150 
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     emit Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public view returns (uint256) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 /**
169  * @title ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/20
171  */
172 contract ERC20 is ERC20Basic {
173   function allowance(address owner, address spender)
174     public view returns (uint256);
175 
176   function transferFrom(address from, address to, uint256 value)
177     public returns (bool);
178 
179   function approve(address spender, uint256 value) public returns (bool);
180   event Approval(
181     address indexed owner,
182     address indexed spender,
183     uint256 value
184   );
185 }
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * @dev https://github.com/ethereum/EIPs/issues/20
192  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(
206     address _from,
207     address _to,
208     uint256 _value
209   )
210     public
211     returns (bool)
212   {
213     require(_to != address(0));
214     require(_value <= balances[_from]);
215     require(_value <= allowed[_from][msg.sender]);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(
247     address _owner,
248     address _spender
249    )
250     public
251     view
252     returns (uint256)
253   {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(
268     address _spender,
269     uint _addedValue
270   )
271     public
272     returns (bool)
273   {
274     allowed[msg.sender][_spender] = (
275       allowed[msg.sender][_spender].add(_addedValue));
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 contract NaviCoin is Ownable, StandardToken {
310     // ERC20 requirements
311     string public name;
312     string public symbol;
313     uint8 public decimals;
314 
315     uint256 public totalSupply;
316 
317     // 2 states: mintable (initial) and transferrable
318     bool public releasedForTransfer;
319 
320     event Issue(address recepient, uint amount);
321 
322     constructor() public {
323         name = "NaviCoin";
324         symbol = "NAVI";
325         decimals = 8;
326     }
327 
328     function transfer(address _to, uint256 _value) public returns(bool) {
329         require(releasedForTransfer);
330         return super.transfer(_to, _value);
331     }
332 
333     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
334         require(releasedForTransfer);
335         return super.transferFrom(_from, _to, _value);
336     }
337 
338     // transfer the state from intable to transferrable
339     function release() public onlyOwner() {
340         releasedForTransfer = true;
341     }
342 
343     // creates new amount of navis
344     function issue(address _recepient, uint256 _amount) public onlyOwner() {
345         require(!releasedForTransfer);
346         balances[_recepient] = balances[_recepient].add(_amount);
347         totalSupply = totalSupply.add(_amount);
348         emit Issue(_recepient, _amount);
349         emit Transfer(address(0), _recepient, _amount);
350     }
351 }
352 
353 contract NaviCrowdSale is Ownable {
354     using SafeMath for uint256;
355     
356     mapping(address => uint256) participants;
357 
358     NaviCoin crowdsaleToken;
359 
360     mapping (bytes4 => bool) inUse;
361 
362     uint256 public maxSupply;
363     uint256 public totalCollected;
364 
365     event SellToken(address recepient, uint tokensSold);
366 
367     modifier preventReentrance {
368         require(!inUse[msg.sig]);
369         inUse[msg.sig] = true;
370         _;
371         inUse[msg.sig] = false;
372     }
373 
374     constructor(
375         NaviCoin _token
376     )
377     public
378     {
379         maxSupply = 30000000000000000;
380         totalCollected = 1625000000000000;
381         crowdsaleToken = _token;
382     }
383 
384     // returns address of the erc20 navi token
385     function getToken()
386     public view
387     returns(address)
388     {
389         return address(crowdsaleToken);
390     }
391 
392     // transfers crowdsale token from mintable to transferrable state
393     function releaseTokens()
394     public
395     onlyOwner()             // manager is CrowdsaleController instance
396     {
397         crowdsaleToken.release();
398     }
399 
400     // sels the project's token to buyers
401     function generate(
402         address _recepient, 
403         uint256 _value
404     ) public
405         preventReentrance
406         onlyOwner()        // only manager can call it
407     {
408         uint256 newTotalCollected = totalCollected.add(_value);
409 
410         require(maxSupply >= newTotalCollected);
411 
412         // create new tokens for this buyer
413         crowdsaleToken.issue(_recepient, _value);
414 
415         emit SellToken(_recepient, _value);
416 
417         // remember the buyer so he/she/it may refund its ETH if crowdsale failed
418         participants[_recepient] = participants[_recepient].add(_value);
419 
420         totalCollected = newTotalCollected;
421     }
422 
423     // project's owner withdraws ETH funds
424     function withdraw(
425         uint256 _amount, // can be done partially,
426         address _recepient
427     )
428     public
429     onlyOwner()
430     {
431         require(_amount <= address(this).balance);
432         _recepient.transfer(_amount);
433     }
434 
435 }