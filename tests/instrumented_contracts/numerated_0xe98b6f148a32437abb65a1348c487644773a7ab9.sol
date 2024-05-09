1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 contract Claimable is Ownable {
39   address public pendingOwner;
40 
41   /**
42    * @dev Modifier throws if called by any account other than the pendingOwner.
43    */
44   modifier onlyPendingOwner() {
45     require(msg.sender == pendingOwner);
46     _;
47   }
48 
49   /**
50    * @dev Allows the current owner to set the pendingOwner address.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) onlyOwner public {
54     pendingOwner = newOwner;
55   }
56 
57   /**
58    * @dev Allows the pendingOwner address to finalize the transfer.
59    */
60   function claimOwnership() onlyPendingOwner public {
61     OwnershipTransferred(owner, pendingOwner);
62     owner = pendingOwner;
63     pendingOwner = address(0);
64   }
65 }
66 
67 library SafeMath {
68 
69   /**
70   * @dev Multiplies two numbers, throws on overflow.
71   */
72   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73     if (a == 0) {
74       return 0;
75     }
76     uint256 c = a * b;
77     assert(c / a == b);
78     return c;
79   }
80 
81   /**
82   * @dev Integer division of two numbers, truncating the quotient.
83   */
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     // assert(b > 0); // Solidity automatically throws when dividing by 0
86     uint256 c = a / b;
87     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88     return c;
89   }
90 
91   /**
92   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
93   */
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   /**
100   * @dev Adds two numbers, throws on overflow.
101   */
102   function add(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a + b;
104     assert(c >= a);
105     return c;
106   }
107 }
108 
109 contract ERC20Basic {
110   function totalSupply() public view returns (uint256);
111   function balanceOf(address who) public view returns (uint256);
112   function transfer(address to, uint256 value) public returns (bool);
113   event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender) public view returns (uint256);
118   function transferFrom(address from, address to, uint256 value) public returns (bool);
119   function approve(address spender, uint256 value) public returns (bool);
120   event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 contract BasicToken is ERC20Basic {
124   using SafeMath for uint256;
125 
126   mapping(address => uint256) balances;
127 
128   uint256 totalSupply_;
129 
130   /**
131   * @dev total number of tokens in existence
132   */
133   function totalSupply() public view returns (uint256) {
134     return totalSupply_;
135   }
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145 
146     // SafeMath.sub will throw if there is not enough balance.
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 contract BurnableToken is BasicToken {
253 
254   event Burn(address indexed burner, uint256 value);
255 
256   /**
257    * @dev Burns a specific amount of tokens.
258    * @param _value The amount of token to be burned.
259    */
260   function burn(uint256 _value) public {
261     require(_value <= balances[msg.sender]);
262     // no need to require value <= totalSupply, since that would imply the
263     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
264 
265     address burner = msg.sender;
266     balances[burner] = balances[burner].sub(_value);
267     totalSupply_ = totalSupply_.sub(_value);
268     Burn(burner, _value);
269     Transfer(burner, address(0), _value);
270   }
271 }
272 
273 contract LuckchemyToken is BurnableToken, StandardToken, Claimable {
274 
275     bool public released = false;
276 
277     string public constant name = "Luckchemy";
278 
279     string public constant symbol = "LUK";
280 
281     uint8 public constant decimals = 8;
282 
283     uint256 public CROWDSALE_SUPPLY;
284 
285     uint256 public OWNERS_AND_PARTNERS_SUPPLY;
286 
287     address public constant OWNERS_AND_PARTNERS_ADDRESS = 0x603a535a1D7C5050021F9f5a4ACB773C35a67602;
288 
289     // Index of unique addresses
290     uint256 public addressCount = 0;
291 
292     // Map of unique addresses
293     mapping(uint256 => address) public addressMap;
294     mapping(address => bool) public addressAvailabilityMap;
295 
296     //blacklist of addresses (product/developers addresses) that are not included in the final Holder lottery
297     mapping(address => bool) public blacklist;
298 
299     // service agent for managing blacklist
300     address public serviceAgent;
301 
302     event Release();
303     event BlacklistAdd(address indexed addr);
304     event BlacklistRemove(address indexed addr);
305 
306     /**
307      * Do not transfer tokens until the crowdsale is over.
308      *
309      */
310     modifier canTransfer() {
311         require(released || msg.sender == owner);
312         _;
313     }
314 
315     /*
316      * modifier which gives specific rights to serviceAgent
317      */
318     modifier onlyServiceAgent(){
319         require(msg.sender == serviceAgent);
320         _;
321     }
322 
323 
324     function LuckchemyToken() public {
325 
326         totalSupply_ = 1000000000 * (10 ** uint256(decimals));
327         CROWDSALE_SUPPLY = 700000000 * (10 ** uint256(decimals));
328         OWNERS_AND_PARTNERS_SUPPLY = 300000000 * (10 ** uint256(decimals));
329 
330         addAddressToUniqueMap(msg.sender);
331         addAddressToUniqueMap(OWNERS_AND_PARTNERS_ADDRESS);
332 
333         balances[msg.sender] = CROWDSALE_SUPPLY;
334 
335         balances[OWNERS_AND_PARTNERS_ADDRESS] = OWNERS_AND_PARTNERS_SUPPLY;
336 
337         owner = msg.sender;
338 
339         Transfer(0x0, msg.sender, CROWDSALE_SUPPLY);
340 
341         Transfer(0x0, OWNERS_AND_PARTNERS_ADDRESS, OWNERS_AND_PARTNERS_SUPPLY);
342     }
343 
344     function transfer(address _to, uint256 _value) public canTransfer returns (bool success) {
345         //Add address to map of unique token owners
346         addAddressToUniqueMap(_to);
347 
348         // Call StandardToken.transfer()
349         return super.transfer(_to, _value);
350     }
351 
352     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool success) {
353         //Add address to map of unique token owners
354         addAddressToUniqueMap(_to);
355 
356         // Call StandardToken.transferForm()
357         return super.transferFrom(_from, _to, _value);
358     }
359 
360     /**
361     *
362     * Release the tokens to the public.
363     * Can be called only by owner which should be the Crowdsale contract
364     * Should be called if the crowdale is successfully finished
365     *
366     */
367     function releaseTokenTransfer() public onlyOwner {
368         released = true;
369         Release();
370     }
371 
372     /**
373      * Add address to the black list.
374      * Only service agent can do this
375      */
376     function addBlacklistItem(address _blackAddr) public onlyServiceAgent {
377         blacklist[_blackAddr] = true;
378 
379         BlacklistAdd(_blackAddr);
380     }
381 
382     /**
383     * Remove address from the black list.
384     * Only service agent can do this
385     */
386     function removeBlacklistItem(address _blackAddr) public onlyServiceAgent {
387         delete blacklist[_blackAddr];
388     }
389 
390     /**
391     * Add address to unique map if it is not added
392     */
393     function addAddressToUniqueMap(address _addr) private returns (bool) {
394         if (addressAvailabilityMap[_addr] == true) {
395             return true;
396         }
397 
398         addressAvailabilityMap[_addr] = true;
399         addressMap[addressCount++] = _addr;
400 
401         return true;
402     }
403 
404     /**
405     * Get address by index from map of unique addresses
406     */
407     function getUniqueAddressByIndex(uint256 _addressIndex) public view returns (address) {
408         return addressMap[_addressIndex];
409     }
410 
411     /**
412     * Change service agent
413     */
414     function changeServiceAgent(address _addr) public onlyOwner {
415         serviceAgent = _addr;
416     }
417 
418 }