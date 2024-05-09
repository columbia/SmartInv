1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   /**
75    * @dev Fix for the ERC20 short address attack.
76    */
77   modifier onlyPayloadSize(uint size) {
78      if(msg.data.length < size + 4) {
79        revert();
80      }
81      _;
82   }
83   
84   uint256 totalSupply_;
85 
86   /**
87   * @dev Total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev Transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     emit Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address owner, address spender)
125     public view returns (uint256);
126 
127   function transferFrom(address from, address to, uint256 value)
128     public returns (bool);
129 
130   function approve(address spender, uint256 value) public returns (bool);
131   event Approval(
132     address indexed owner,
133     address indexed spender,
134     uint256 value
135   );
136 }
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     onlyPayloadSize(3 * 32)
162     public
163     returns (bool)
164   {
165     require(_to != address(0));
166     require(_value <= balances[_from]);
167     require(_value <= allowed[_from][msg.sender]);
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172     emit Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(
198     address _owner,
199     address _spender
200    )
201     public
202     view
203     returns (uint256)
204   {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    * approve should be called when allowed[_spender] == 0. To increment
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * @param _spender The address which will spend the funds.
215    * @param _addedValue The amount of tokens to increase the allowance by.
216    */
217   function increaseApproval(
218     address _spender,
219     uint256 _addedValue
220   )
221     public
222     returns (bool)
223   {
224     allowed[msg.sender][_spender] = (
225       allowed[msg.sender][_spender].add(_addedValue));
226     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(
240     address _spender,
241     uint256 _subtractedValue
242   )
243     public
244     returns (bool)
245   {
246     uint256 oldValue = allowed[msg.sender][_spender];
247     if (_subtractedValue > oldValue) {
248       allowed[msg.sender][_spender] = 0;
249     } else {
250       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251     }
252     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256 }
257 
258 /**
259  * @title Ownable
260  * @dev The Ownable contract has an owner address, and provides basic authorization control
261  * functions, this simplifies the implementation of "user permissions".
262  */
263 contract Ownable {
264   address public owner;
265 
266 
267   event OwnershipRenounced(address indexed previousOwner);
268   event OwnershipTransferred(
269     address indexed previousOwner,
270     address indexed newOwner
271   );
272 
273 
274   /**
275    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
276    * account.
277    */
278   constructor() public {
279     owner = msg.sender;
280   }
281 
282   /**
283    * @dev Throws if called by any account other than the owner.
284    */
285   modifier onlyOwner() {
286     require(msg.sender == owner);
287     _;
288   }
289 
290   /**
291    * @dev Allows the current owner to relinquish control of the contract.
292    * @notice Renouncing to ownership will leave the contract without an owner.
293    * It will not be possible to call the functions with the `onlyOwner`
294    * modifier anymore.
295    */
296   function renounceOwnership() public onlyOwner {
297     emit OwnershipRenounced(owner);
298     owner = address(0);
299   }
300 
301   /**
302    * @dev Allows the current owner to transfer control of the contract to a newOwner.
303    * @param _newOwner The address to transfer ownership to.
304    */
305   function transferOwnership(address _newOwner) public onlyOwner {
306     _transferOwnership(_newOwner);
307   }
308 
309   /**
310    * @dev Transfers control of the contract to a newOwner.
311    * @param _newOwner The address to transfer ownership to.
312    */
313   function _transferOwnership(address _newOwner) internal {
314     require(_newOwner != address(0));
315     emit OwnershipTransferred(owner, _newOwner);
316     owner = _newOwner;
317   }
318 }
319 
320 /**
321  * @title Pausable
322  * @dev Base contract which allows children to implement an emergency stop mechanism.
323  */
324 contract Pausable is Ownable {
325   event Pause();
326   event Unpause();
327 
328   bool public paused = false;
329 
330 
331   /**
332    * @dev Modifier to make a function callable only when the contract is not paused.
333    */
334   modifier whenNotPaused() {
335     require(!paused);
336     _;
337   }
338 
339   /**
340    * @dev Modifier to make a function callable only when the contract is paused.
341    */
342   modifier whenPaused() {
343     require(paused);
344     _;
345   }
346 
347   /**
348    * @dev called by the owner to pause, triggers stopped state
349    */
350   function pause() onlyOwner whenNotPaused public {
351     paused = true;
352     emit Pause();
353   }
354 
355   /**
356    * @dev called by the owner to unpause, returns to normal state
357    */
358   function unpause() onlyOwner whenPaused public {
359     paused = false;
360     emit Unpause();
361   }
362 
363 }
364 
365 contract PausableToken is StandardToken, Pausable {
366 
367   function transfer(address _to, uint _value) whenNotPaused public returns (bool) {
368     return super.transfer(_to, _value);
369   }
370 
371   function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool) {
372     return super.transferFrom(_from, _to, _value);
373   }    
374     
375 }
376 
377 contract UnionTokens is PausableToken {
378     string public constant name = "UnionTokens";
379     string public constant symbol = "UNION";
380     uint8 public constant decimals = 6;
381 
382     address public team1 = address(0x945835787779ca81cc6a5bf88276c5650edae881);
383     address public team2 = address(0xa0fad303c2b167a24d6e29e4b1e71879c6a9036b);
384     address public foundation = address(0x9871ed8Fd953E58F2D47a5D8618D8EBF2F49bb51);
385     address public partner = address(0xe7f56c56546d85323f2c60ea640a99542569c7f1);
386     address public ido = address(0xc9df47746cb76c38e4a54bbdbe21f168cc109533);
387     address public operate = address(0x0b1859ce0faba7e7347c22d01333d5f2bdb37acf);
388     
389     constructor() public {
390         totalSupply_ = 10 * (10 ** 8) * (10 ** uint256(decimals));	//Total Supply 1 billion
391         balances[team1] = totalSupply_ * 15 / 100;					//Team1 15%
392         balances[team2] = totalSupply_ * 5 / 100;				    //Team2 5%
393         balances[foundation] = totalSupply_ * 5 / 100;			    //Foundation 5%
394         balances[partner] = totalSupply_ * 10 / 100;                //Partner 10%
395         balances[ido] = totalSupply_ * 20 / 100;				    //IDO 20%
396         balances[operate] = totalSupply_ * 45 / 100;				//Operate (Airdrop and Miner)45%
397         emit Transfer(address(0), team1, balances[team1]);
398         emit Transfer(address(0), team2, balances[team2]);
399         emit Transfer(address(0), foundation, balances[foundation]);
400         emit Transfer(address(0), partner, balances[partner]);
401         emit Transfer(address(0), ido, balances[ido]);
402         emit Transfer(address(0), operate, balances[operate]);
403     }
404 
405     function batchTransfer(address[] _receivers, uint _value) whenNotPaused public {
406         uint cnt = _receivers.length;
407         require(cnt>0);
408         for(uint i=0; i<cnt; i++){
409             address _to = _receivers[i];
410             require(_to!=address(0) && _value<=balances[msg.sender]);
411             balances[msg.sender] = balances[msg.sender].sub(_value);
412             balances[_to] = balances[_to].add(_value);
413             emit Transfer(msg.sender, _to, _value);
414         }
415     }
416     
417     function batchTransfers(address[] _receivers, uint[] _values) whenNotPaused public {
418         uint cnt = _receivers.length;
419         require(cnt>0 && cnt==_values.length);
420         for(uint i=0; i<cnt; i++){
421             address _to = _receivers[i];
422             uint _value = _values[i];
423             require(_to!=address(0) && _value<=balances[msg.sender]);
424             balances[msg.sender] = balances[msg.sender].sub(_values[i]);
425             balances[_to] = balances[_to].add(_values[i]);
426             emit Transfer(msg.sender, _to, _values[i]);
427         }
428     }
429 
430 	// Send back ether sent to me
431 	function () external {
432 		revert();
433 	}
434  
435 }