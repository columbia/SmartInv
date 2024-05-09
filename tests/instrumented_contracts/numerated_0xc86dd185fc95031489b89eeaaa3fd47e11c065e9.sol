1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is ERC20, BasicToken {
126 
127   mapping (address => mapping (address => uint256)) internal allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint256 the amount of tokens to be transferred
135    */
136   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[_from]);
139     require(_value <= allowed[_from][msg.sender]);
140 
141     balances[_from] = balances[_from].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    *
151    * Beware that changing an allowance with this method brings the risk that someone may use both the old
152    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint256 _value) public returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public view returns (uint256) {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * @dev Increase the amount of tokens that an owner allowed to a spender.
176    *
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    * @param _spender The address which will spend the funds.
182    * @param _addedValue The amount of tokens to increase the allowance by.
183    */
184   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   /**
191    * @dev Decrease the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To decrement
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _subtractedValue The amount of tokens to decrease the allowance by.
199    */
200   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201     uint oldValue = allowed[msg.sender][_spender];
202     if (_subtractedValue > oldValue) {
203       allowed[msg.sender][_spender] = 0;
204     } else {
205       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206     }
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211 }
212 
213 /**
214  * @title SimpleToken
215  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
216  * Note they can later distribute these tokens as they wish using `transfer` and other
217  * `StandardToken` functions.
218  */
219 contract OpportyToken is StandardToken {
220 
221   string public constant name = "OpportyToken";
222   string public constant symbol = "OPP";
223   uint8 public constant decimals = 18;
224 
225   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
226 
227   /**
228    * @dev Contructor that gives msg.sender all of existing tokens.
229    */
230   function OpportyToken() public {
231     totalSupply_ = INITIAL_SUPPLY;
232     balances[msg.sender] = INITIAL_SUPPLY;
233     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
234   }
235 
236 }
237 
238 /**
239  * @title Ownable
240  * @dev The Ownable contract has an owner address, and provides basic authorization control
241  * functions, this simplifies the implementation of "user permissions".
242  */
243 contract Ownable {
244   address public owner;
245 
246 
247   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248 
249 
250   /**
251    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
252    * account.
253    */
254   function Ownable() public {
255     owner = msg.sender;
256   }
257 
258   /**
259    * @dev Throws if called by any account other than the owner.
260    */
261   modifier onlyOwner() {
262     require(msg.sender == owner);
263     _;
264   }
265 
266   /**
267    * @dev Allows the current owner to transfer control of the contract to a newOwner.
268    * @param newOwner The address to transfer ownership to.
269    */
270   function transferOwnership(address newOwner) public onlyOwner {
271     require(newOwner != address(0));
272     OwnershipTransferred(owner, newOwner);
273     owner = newOwner;
274   }
275 
276 }
277 
278 
279 contract OpportyBountyHold is Ownable {
280   OpportyToken public token;
281 
282   // start and end timestamps where investments are allowed
283   uint public startDate;
284   uint public endDate;
285 
286   struct Holder {
287     bool isActive;
288     uint tokens;
289     bool withdrawed;
290   }
291 
292   mapping(address => Holder) public holderList;
293   mapping(uint => address) private holderIndexes;
294   uint private holderIndex;
295 
296   mapping (uint => address) private assetOwners;
297   mapping (address => uint) private assetOwnersIndex;
298   uint public assetOwnersIndexes;
299 
300   event TokensTransfered(address contributor , uint amount);
301   event ManualChangeStartDate(uint beforeDate, uint afterDate);
302   event ManualChangeEndDate(uint beforeDate, uint afterDate);
303   event HolderAdded(address presenter, address holder, uint tokens);
304   event HoldChanged(address presenter, address holder, uint tokens);
305   event TokenChanged(address newAddress);
306 
307   modifier onlyAssetsOwners() {
308     require(assetOwnersIndex[msg.sender] > 0 || msg.sender == owner);
309     _;
310   }
311 
312   function OpportyBountyHold(uint start, uint end) public {
313     startDate = start;
314     endDate   = end;
315   }
316 
317   function addHolder(address holder, uint tokens) onlyAssetsOwners external {
318     if (holderList[holder].isActive == false) {
319         holderList[holder].isActive = true;
320         holderList[holder].tokens = tokens;
321         holderIndexes[holderIndex] = holder;
322         holderIndex++;
323         HolderAdded(msg.sender, holder, tokens);
324     } else {
325         holderList[holder].tokens += tokens;
326         HoldChanged(msg.sender, holder, tokens);
327     }
328   }
329 
330   function changeHold(address holder, uint tokens) onlyAssetsOwners public {
331       require(holderList[holder].isActive == true);
332       holderList[holder].tokens = tokens;
333       HoldChanged(msg.sender, holder, tokens);
334   }
335 
336   function addAssetsOwner(address _owner) public onlyOwner {
337     assetOwnersIndexes++;
338     assetOwners[assetOwnersIndexes] = _owner;
339     assetOwnersIndex[_owner] = assetOwnersIndexes;
340   }
341 
342   function removeAssetsOwner(address _owner) public onlyOwner {
343     uint index = assetOwnersIndex[_owner];
344     delete assetOwnersIndex[_owner];
345     delete assetOwners[index];
346     assetOwnersIndexes--;
347   }
348 
349   function getAssetsOwners(uint _index) onlyOwner public constant returns (address) {
350     return assetOwners[_index];
351   }
352 
353   function getBalance() public constant returns (uint) {
354     return token.balanceOf(this);
355   }
356 
357   function returnTokens(uint nTokens) public onlyOwner returns (bool) {
358     require(nTokens <= getBalance());
359     token.transfer(msg.sender, nTokens);
360     TokensTransfered(msg.sender, nTokens);
361     return true;
362   }
363 
364   function unlockTokens() public returns (bool) {
365     require(holderList[msg.sender].isActive);
366     require(!holderList[msg.sender].withdrawed);
367     require(now >= endDate);
368     token.transfer(msg.sender, holderList[msg.sender].tokens); 
369     holderList[msg.sender].withdrawed = true;
370     TokensTransfered(msg.sender, holderList[msg.sender].tokens);
371     return true;
372   }
373 
374   function getTokenAmount() public view returns (uint) {
375     uint tokens = 0;
376     for (uint i = 0; i < holderIndex; ++i) {
377         if (!holderList[holderIndexes[i]].withdrawed) {
378           tokens += holderList[holderIndexes[i]].tokens;
379         }
380     }
381     return tokens;
382   }
383 
384   function setStartDate(uint date) public onlyOwner {
385     uint oldStartDate = startDate;
386     startDate = date;
387     ManualChangeStartDate(oldStartDate, date);
388   }
389 
390   function setEndDate(uint date) public onlyOwner {
391     uint oldEndDate = endDate;
392     endDate = date;
393     ManualChangeEndDate(oldEndDate, date);
394   }
395 
396   function setToken(address newToken) public onlyOwner {
397     token = OpportyToken(newToken);
398     TokenChanged(token);
399   }
400 }