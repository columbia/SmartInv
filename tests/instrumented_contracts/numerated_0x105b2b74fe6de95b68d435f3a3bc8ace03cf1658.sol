1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function balanceOf(address _owner) public view returns (uint256);
9   function allowance(address _owner, address _spender) public view returns (uint256);
10   function transfer(address _to, uint256 _value) public returns (bool);
11   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
12   function approve(address _spender, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /*
18 Copyright (c) 2016 Smart Contract Solutions, Inc.
19 
20 Permission is hereby granted, free of charge, to any person obtaining
21 a copy of this software and associated documentation files (the
22 "Software"), to deal in the Software without restriction, including
23 without limitation the rights to use, copy, modify, merge, publish,
24 distribute, sublicense, and/or sell copies of the Software, and to
25 permit persons to whom the Software is furnished to do so, subject to
26 the following conditions:
27 
28 The above copyright notice and this permission notice shall be included
29 in all copies or substantial portions of the Software.
30 
31 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
32 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
33 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
34 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
35 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
36 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
37 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
38 */
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     if (a == 0) {
47       return 0;
48     }
49     uint256 c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return c;
59   }
60 
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 /**
74  * @title Standard ERC20 token
75  *
76  * @dev Implementation of the basic standard token.
77  * @dev https://github.com/ethereum/EIPs/issues/20
78  */
79 contract PolyToken is IERC20 {
80   using SafeMath for uint256;
81 
82   // Poly Token parameters
83   string public name = 'Polymath';
84   string public symbol = 'POLY';
85   uint8 public constant decimals = 18;
86   uint256 public constant decimalFactor = 10 ** uint256(decimals);
87   uint256 public constant totalSupply = 1000000000 * decimalFactor;
88   mapping (address => uint256) balances;
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91   event Transfer(address indexed from, address indexed to, uint256 value);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 
94   /**
95   * @dev Constructor for Poly creation
96   * @dev Assigns the totalSupply to the PolyDistribution contract
97   */
98   function PolyToken(address _polyDistributionContractAddress) public {
99     require(_polyDistributionContractAddress != address(0));
100     balances[_polyDistributionContractAddress] = totalSupply;
101     Transfer(address(0), _polyDistributionContractAddress, totalSupply);
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256 balance) {
110     return balances[_owner];
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifying the amount of tokens still available for the spender.
118    */
119   function allowance(address _owner, address _spender) public view returns (uint256) {
120     return allowed[_owner][_spender];
121   }
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[msg.sender]);
131 
132     // SafeMath.sub will throw if there is not enough balance.
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /*
213 Copyright (c) 2016 Smart Contract Solutions, Inc.
214 
215 Permission is hereby granted, free of charge, to any person obtaining
216 a copy of this software and associated documentation files (the
217 "Software"), to deal in the Software without restriction, including
218 without limitation the rights to use, copy, modify, merge, publish,
219 distribute, sublicense, and/or sell copies of the Software, and to
220 permit persons to whom the Software is furnished to do so, subject to
221 the following conditions:
222 
223 The above copyright notice and this permission notice shall be included
224 in all copies or substantial portions of the Software.
225 
226 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
227 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
228 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
229 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
230 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
231 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
232 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
233 */
234 
235 /**
236  * @title Ownable
237  * @dev The Ownable contract has an owner address, and provides basic authorization control
238  * functions, this simplifies the implementation of "user permissions".
239  */
240 contract Ownable {
241   address public owner;
242 
243   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245   /**
246    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
247    * account.
248    */
249   function Ownable() public {
250     owner = msg.sender;
251   }
252 
253   /**
254    * @dev Throws if called by any account other than the owner.
255    */
256   modifier onlyOwner() {
257     require(msg.sender == owner);
258     _;
259   }
260 
261   /**
262    * @dev Allows the current owner to transfer control of the contract to a newOwner.
263    * @param newOwner The address to transfer ownership to.
264    */
265   function transferOwnership(address newOwner) public onlyOwner {
266     require(newOwner != address(0));
267     OwnershipTransferred(owner, newOwner);
268     owner = newOwner;
269   }
270 
271 }
272 
273 /**
274  * @title POLY token initial distribution
275  *
276  * @dev Distribute purchasers, airdrop, reserve, and founder tokens
277  */
278 contract PolyDistribution is Ownable {
279   using SafeMath for uint256;
280 
281   PolyToken public POLY;
282 
283   uint256 private constant decimalFactor = 10**uint256(18);
284   enum AllocationType { PRESALE, FOUNDER, AIRDROP, ADVISOR, RESERVE, BONUS1, BONUS2, BONUS3 }
285   uint256 public constant INITIAL_SUPPLY   = 1000000000 * decimalFactor;
286   uint256 public AVAILABLE_TOTAL_SUPPLY    = 1000000000 * decimalFactor;
287   uint256 public AVAILABLE_PRESALE_SUPPLY  =  230000000 * decimalFactor; // 100% Released at Token Distribution (TD)
288   uint256 public AVAILABLE_FOUNDER_SUPPLY  =  150000000 * decimalFactor; // 33% Released at TD +1 year -> 100% at TD +3 years
289   uint256 public AVAILABLE_AIRDROP_SUPPLY  =   10000000 * decimalFactor; // 100% Released at TD
290   uint256 public AVAILABLE_ADVISOR_SUPPLY  =   20000000 * decimalFactor; // 100% Released at TD +7 months
291   uint256 public AVAILABLE_RESERVE_SUPPLY  =  513116658 * decimalFactor; // 6.8% Released at TD +100 days -> 100% at TD +4 years
292   uint256 public AVAILABLE_BONUS1_SUPPLY  =    39053330 * decimalFactor; // 100% Released at TD +1 year
293   uint256 public AVAILABLE_BONUS2_SUPPLY  =     9354408 * decimalFactor; // 100% Released at TD +2 years
294   uint256 public AVAILABLE_BONUS3_SUPPLY  =    28475604 * decimalFactor; // 100% Released at TD +3 years
295 
296   uint256 public grandTotalClaimed = 0;
297   uint256 public startTime;
298 
299   // Allocation with vesting information
300   struct Allocation {
301     uint8 AllocationSupply; // Type of allocation
302     uint256 endCliff;       // Tokens are locked until
303     uint256 endVesting;     // This is when the tokens are fully unvested
304     uint256 totalAllocated; // Total tokens allocated
305     uint256 amountClaimed;  // Total tokens claimed
306   }
307   mapping (address => Allocation) public allocations;
308 
309   // List of admins
310   mapping (address => bool) public airdropAdmins;
311 
312   // Keeps track of whether or not a 250 POLY airdrop has been made to a particular address
313   mapping (address => bool) public airdrops;
314 
315   modifier onlyOwnerOrAdmin() {
316     require(msg.sender == owner || airdropAdmins[msg.sender]);
317     _;
318   }
319 
320   event LogNewAllocation(address indexed _recipient, AllocationType indexed _fromSupply, uint256 _totalAllocated, uint256 _grandTotalAllocated);
321   event LogPolyClaimed(address indexed _recipient, uint8 indexed _fromSupply, uint256 _amountClaimed, uint256 _totalAllocated, uint256 _grandTotalClaimed);
322 
323   /**
324     * @dev Constructor function - Set the poly token address
325     * @param _startTime The time when PolyDistribution goes live
326     */
327   function PolyDistribution(uint256 _startTime) public {
328     require(_startTime >= now);
329     require(AVAILABLE_TOTAL_SUPPLY == AVAILABLE_PRESALE_SUPPLY.add(AVAILABLE_FOUNDER_SUPPLY).add(AVAILABLE_AIRDROP_SUPPLY).add(AVAILABLE_ADVISOR_SUPPLY).add(AVAILABLE_BONUS1_SUPPLY).add(AVAILABLE_BONUS2_SUPPLY).add(AVAILABLE_BONUS3_SUPPLY).add(AVAILABLE_RESERVE_SUPPLY));
330     startTime = _startTime;
331     POLY = new PolyToken(this);
332   }
333 
334   /**
335     * @dev Allow the owner of the contract to assign a new allocation
336     * @param _recipient The recipient of the allocation
337     * @param _totalAllocated The total amount of POLY available to the receipient (after vesting)
338     * @param _supply The POLY supply the allocation will be taken from
339     */
340   function setAllocation (address _recipient, uint256 _totalAllocated, AllocationType _supply) onlyOwner public {
341     require(allocations[_recipient].totalAllocated == 0 && _totalAllocated > 0);
342     require(_supply >= AllocationType.PRESALE && _supply <= AllocationType.BONUS3);
343     require(_recipient != address(0));
344     if (_supply == AllocationType.PRESALE) {
345       AVAILABLE_PRESALE_SUPPLY = AVAILABLE_PRESALE_SUPPLY.sub(_totalAllocated);
346       allocations[_recipient] = Allocation(uint8(AllocationType.PRESALE), 0, 0, _totalAllocated, 0);
347     } else if (_supply == AllocationType.FOUNDER) {
348       AVAILABLE_FOUNDER_SUPPLY = AVAILABLE_FOUNDER_SUPPLY.sub(_totalAllocated);
349       allocations[_recipient] = Allocation(uint8(AllocationType.FOUNDER), startTime + 1 years, startTime + 3 years, _totalAllocated, 0);
350     } else if (_supply == AllocationType.ADVISOR) {
351       AVAILABLE_ADVISOR_SUPPLY = AVAILABLE_ADVISOR_SUPPLY.sub(_totalAllocated);
352       allocations[_recipient] = Allocation(uint8(AllocationType.ADVISOR), startTime + 209 days, 0, _totalAllocated, 0);
353     } else if (_supply == AllocationType.RESERVE) {
354       AVAILABLE_RESERVE_SUPPLY = AVAILABLE_RESERVE_SUPPLY.sub(_totalAllocated);
355       allocations[_recipient] = Allocation(uint8(AllocationType.RESERVE), startTime + 100 days, startTime + 4 years, _totalAllocated, 0);
356     } else if (_supply == AllocationType.BONUS1) {
357       AVAILABLE_BONUS1_SUPPLY = AVAILABLE_BONUS1_SUPPLY.sub(_totalAllocated);
358       allocations[_recipient] = Allocation(uint8(AllocationType.BONUS1), startTime + 1 years, startTime + 1 years, _totalAllocated, 0);
359     } else if (_supply == AllocationType.BONUS2) {
360       AVAILABLE_BONUS2_SUPPLY = AVAILABLE_BONUS2_SUPPLY.sub(_totalAllocated);
361       allocations[_recipient] = Allocation(uint8(AllocationType.BONUS2), startTime + 2 years, startTime + 2 years, _totalAllocated, 0);
362     } else if (_supply == AllocationType.BONUS3) {
363       AVAILABLE_BONUS3_SUPPLY = AVAILABLE_BONUS3_SUPPLY.sub(_totalAllocated);
364       allocations[_recipient] = Allocation(uint8(AllocationType.BONUS3), startTime + 3 years, startTime + 3 years, _totalAllocated, 0);
365     }
366     AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(_totalAllocated);
367     LogNewAllocation(_recipient, _supply, _totalAllocated, grandTotalAllocated());
368   }
369 
370   /**
371     * @dev Add an airdrop admin
372     */
373   function setAirdropAdmin(address _admin, bool _isAdmin) public onlyOwner {
374     airdropAdmins[_admin] = _isAdmin;
375   }
376 
377   /**
378     * @dev perform a transfer of allocations
379     * @param _recipient is a list of recipients
380     */
381   function airdropTokens(address[] _recipient) public onlyOwnerOrAdmin {
382     require(now >= startTime);
383     uint airdropped;
384     for(uint256 i = 0; i< _recipient.length; i++)
385     {
386         if (!airdrops[_recipient[i]]) {
387           airdrops[_recipient[i]] = true;
388           require(POLY.transfer(_recipient[i], 250 * decimalFactor));
389           airdropped = airdropped.add(250 * decimalFactor);
390         }
391     }
392     AVAILABLE_AIRDROP_SUPPLY = AVAILABLE_AIRDROP_SUPPLY.sub(airdropped);
393     AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(airdropped);
394     grandTotalClaimed = grandTotalClaimed.add(airdropped);
395   }
396 
397   /**
398     * @dev Transfer a recipients available allocation to their address
399     * @param _recipient The address to withdraw tokens for
400     */
401   function transferTokens (address _recipient) public {
402     require(allocations[_recipient].amountClaimed < allocations[_recipient].totalAllocated);
403     require(now >= allocations[_recipient].endCliff);
404     require(now >= startTime);
405     uint256 newAmountClaimed;
406     if (allocations[_recipient].endVesting > now) {
407       // Transfer available amount based on vesting schedule and allocation
408       newAmountClaimed = allocations[_recipient].totalAllocated.mul(now.sub(startTime)).div(allocations[_recipient].endVesting.sub(startTime));
409     } else {
410       // Transfer total allocated (minus previously claimed tokens)
411       newAmountClaimed = allocations[_recipient].totalAllocated;
412     }
413     uint256 tokensToTransfer = newAmountClaimed.sub(allocations[_recipient].amountClaimed);
414     allocations[_recipient].amountClaimed = newAmountClaimed;
415     require(POLY.transfer(_recipient, tokensToTransfer));
416     grandTotalClaimed = grandTotalClaimed.add(tokensToTransfer);
417     LogPolyClaimed(_recipient, allocations[_recipient].AllocationSupply, tokensToTransfer, newAmountClaimed, grandTotalClaimed);
418   }
419 
420   // Returns the amount of POLY allocated
421   function grandTotalAllocated() public view returns (uint256) {
422     return INITIAL_SUPPLY - AVAILABLE_TOTAL_SUPPLY;
423   }
424 
425   // Allow transfer of accidentally sent ERC20 tokens
426   function refundTokens(address _recipient, address _token) public onlyOwner {
427     require(_token != address(POLY));
428     IERC20 token = IERC20(_token);
429     uint256 balance = token.balanceOf(this);
430     require(token.transfer(_recipient, balance));
431   }
432 }