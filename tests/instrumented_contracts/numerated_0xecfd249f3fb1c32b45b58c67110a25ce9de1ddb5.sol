1 pragma solidity ^0.4.13;
2 
3 contract Multiowned {
4 
5     // TYPES
6 
7     // struct for the status of a pending operation.
8     struct PendingState {
9         uint yetNeeded;
10         uint ownersDone;
11         uint index;
12     }
13 
14     // EVENTS
15 
16     // this contract only has five types of events: it can accept a confirmation, in which case
17     // we record owner and operation (hash) alongside it.
18     event Confirmation(address owner, bytes32 operation);
19     event Revoke(address owner, bytes32 operation);
20     // some others are in the case of an owner changing.
21     event OwnerChanged(address oldOwner, address newOwner);
22     event OwnerAdded(address newOwner);
23     event OwnerRemoved(address oldOwner);
24     // the last one is emitted if the required signatures change
25     event RequirementChanged(uint newRequirement);
26 
27     // MODIFIERS
28 
29     // simple single-sig function modifier.
30     modifier onlyowner {
31         if (isOwner(msg.sender))
32             _;
33     }
34 
35     // multi-sig function modifier: the operation must have an intrinsic hash in order
36     // that later attempts can be realised as the same underlying operation and
37     // thus count as confirmations.
38     modifier onlymanyowners(bytes32 _operation) {
39         if (confirmAndCheck(_operation))
40             _;
41     }
42 
43     // METHODS
44 
45     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
46     // as well as the selection of addresses capable of confirming them.
47     function Multiowned(address[] _owners, uint _required) public {
48         m_numOwners = _owners.length;
49         m_chiefOwnerIndexBit = 2**1;
50         for (uint i = 0; i < m_numOwners; i++) {
51             m_owners[1 + i] = _owners[i];
52             m_ownerIndex[uint(_owners[i])] = 1 + i;
53         }
54         m_required = _required;
55     }
56     
57     // Revokes a prior confirmation of the given operation
58     function revoke(bytes32 _operation) external {
59         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
60         // make sure they're an owner
61         if (ownerIndex == 0) {
62             return;
63         }
64         uint ownerIndexBit = 2**ownerIndex;
65         var pending = m_pending[_operation];
66         if (pending.ownersDone & ownerIndexBit > 0) {
67             pending.yetNeeded++;
68             pending.ownersDone -= ownerIndexBit;
69             Revoke(msg.sender, _operation);
70         }
71     }
72     
73     // Replaces an owner `_from` with another `_to`.
74     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
75         uint ownerIndex = m_ownerIndex[uint(_from)];
76         if (isOwner(_to) || ownerIndex == 0) {
77             return;
78         }
79 
80         clearPending();
81         m_owners[ownerIndex] = _to;
82         m_ownerIndex[uint(_from)] = 0;
83         m_ownerIndex[uint(_to)] = ownerIndex;
84         OwnerChanged(_from, _to);
85     }
86     
87     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
88         if (isOwner(_owner)) {
89             return;
90         }
91 
92         if (m_numOwners >= c_maxOwners) {
93             clearPending();
94             reorganizeOwners();
95         }
96         require(m_numOwners < c_maxOwners);
97         m_numOwners++;
98         m_owners[m_numOwners] = _owner;
99         m_ownerIndex[uint(_owner)] = m_numOwners;
100         OwnerAdded(_owner);
101     }
102     
103     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
104         uint ownerIndex = m_ownerIndex[uint(_owner)];
105         if (ownerIndex == 0 || m_required > m_numOwners - 1) {
106             return;
107         }
108 
109         m_owners[ownerIndex] = 0;
110         m_ownerIndex[uint(_owner)] = 0;
111         clearPending();
112         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
113         OwnerRemoved(_owner);
114     }
115     
116     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
117         if (_newRequired > m_numOwners) {
118             return;
119         }
120         m_required = _newRequired;
121         clearPending();
122         RequirementChanged(_newRequired);
123     }
124     
125     function isOwner(address _addr) internal view returns (bool) {
126         return m_ownerIndex[uint(_addr)] > 0;
127     }
128     
129     function hasConfirmed(bytes32 _operation, address _owner) public view returns (bool) {
130         var pending = m_pending[_operation];
131         uint ownerIndex = m_ownerIndex[uint(_owner)];
132 
133         // make sure they're an owner
134         if (ownerIndex == 0) {
135             return false;
136         }
137 
138         // determine the bit to set for this owner.
139         uint ownerIndexBit = 2**ownerIndex;
140         if (pending.ownersDone & ownerIndexBit == 0) {
141             return false;
142         } else {
143             return true;
144         }
145     }
146     
147     // INTERNAL METHODS
148 
149     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
150         // determine what index the present sender is:
151         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
152         // make sure they're an owner
153         require(ownerIndex != 0);
154 
155         var pending = m_pending[_operation];
156         // if we're not yet working on this operation, switch over and reset the confirmation status.
157         if (pending.yetNeeded == 0) {
158             // reset count of confirmations needed.
159             pending.yetNeeded = c_maxOwners + m_required;
160             // reset which owners have confirmed (none) - set our bitmap to 0.
161             pending.ownersDone = 0;
162             pending.index = m_pendingIndex.length++;
163             m_pendingIndex[pending.index] = _operation;
164         }
165         // determine the bit to set for this owner.
166         uint ownerIndexBit = 2**ownerIndex;
167         // make sure we (the message sender) haven't confirmed this operation previously.
168         if (pending.ownersDone & ownerIndexBit == 0) {
169             Confirmation(msg.sender, _operation);
170             // ok - check if count is enough to go ahead and chief owner confirmed operation.
171             if ((pending.yetNeeded <= c_maxOwners + 1) && ((pending.ownersDone & m_chiefOwnerIndexBit != 0) || (ownerIndexBit == m_chiefOwnerIndexBit))) {
172                 // enough confirmations: reset and run interior.
173                 delete m_pendingIndex[m_pending[_operation].index];
174                 delete m_pending[_operation];
175                 return true;
176             } else {
177                 // not enough: record that this owner in particular confirmed.
178                 pending.yetNeeded--;
179                 pending.ownersDone |= ownerIndexBit;
180             }
181         }
182     }
183 
184     function reorganizeOwners() private returns (bool) {
185         uint free = 1;
186         while (free < m_numOwners) {
187             while (free < m_numOwners && m_owners[free] != 0) {
188                 free++;
189             }
190             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) {
191                 m_numOwners--;
192             }
193             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0) {
194                 m_owners[free] = m_owners[m_numOwners];
195                 m_ownerIndex[uint(m_owners[free])] = free;
196                 m_owners[m_numOwners] = 0;
197             }
198         }
199     }
200     
201     function clearPending() internal {
202         uint length = m_pendingIndex.length;
203         for (uint i = 0; i < length; ++i) {
204             if (m_pendingIndex[i] != 0) {
205                 delete m_pending[m_pendingIndex[i]];
206             }
207         }
208         delete m_pendingIndex;
209     }
210         
211     // FIELDS
212 
213     // the number of owners that must confirm the same operation before it is run.
214     uint public m_required;
215     // pointer used to find a free slot in m_owners
216     uint public m_numOwners;
217     
218     // list of owners
219     address[8] public m_owners;
220     uint public m_chiefOwnerIndexBit;
221     uint constant c_maxOwners = 7;
222     // index on the list of owners to allow reverse lookup
223     mapping(uint => uint) public m_ownerIndex;
224     // the ongoing operations.
225     mapping(bytes32 => PendingState) public m_pending;
226     bytes32[] public m_pendingIndex;
227 }
228 
229 contract ERC20Basic {
230   function totalSupply() public view returns (uint256);
231   function balanceOf(address who) public view returns (uint256);
232   function transfer(address to, uint256 value) public returns (bool);
233   event Transfer(address indexed from, address indexed to, uint256 value);
234 }
235 
236 contract ERC20 is ERC20Basic {
237   function allowance(address owner, address spender) public view returns (uint256);
238   function transferFrom(address from, address to, uint256 value) public returns (bool);
239   function approve(address spender, uint256 value) public returns (bool);
240   event Approval(address indexed owner, address indexed spender, uint256 value);
241 }
242 
243 library SafeMath {
244 
245   /**
246   * @dev Multiplies two numbers, throws on overflow.
247   */
248   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
249     if (a == 0) {
250       return 0;
251     }
252     uint256 c = a * b;
253     assert(c / a == b);
254     return c;
255   }
256 
257   /**
258   * @dev Integer division of two numbers, truncating the quotient.
259   */
260   function div(uint256 a, uint256 b) internal pure returns (uint256) {
261     // assert(b > 0); // Solidity automatically throws when dividing by 0
262     uint256 c = a / b;
263     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
264     return c;
265   }
266 
267   /**
268   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
269   */
270   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
271     assert(b <= a);
272     return a - b;
273   }
274 
275   /**
276   * @dev Adds two numbers, throws on overflow.
277   */
278   function add(uint256 a, uint256 b) internal pure returns (uint256) {
279     uint256 c = a + b;
280     assert(c >= a);
281     return c;
282   }
283 }
284 
285 contract AlphaMarketTeamBountyWallet is Multiowned {
286     function AlphaMarketTeamBountyWallet(address[] _owners, address _tokenAddress) Multiowned(_owners, _owners.length - 1) public {
287         token = AlphaMarketCoin(_tokenAddress);
288     }
289 
290     function transferTokens(address _to, uint256 _value) external onlymanyowners(sha3(msg.data)) {
291         if(_value == 0 || token.balanceOf(this) < _value || _to == 0x0) {
292             return;
293         }
294         token.transfer(_to, _value);
295     }
296 
297     // Prevent sending ether to this address
298     function () external payable {
299         revert();
300     }
301 
302     AlphaMarketCoin public token;
303 }
304 
305 contract BasicToken is ERC20Basic {
306   using SafeMath for uint256;
307 
308   mapping(address => uint256) balances;
309 
310   uint256 totalSupply_;
311 
312   /**
313   * @dev total number of tokens in existence
314   */
315   function totalSupply() public view returns (uint256) {
316     return totalSupply_;
317   }
318 
319   /**
320   * @dev transfer token for a specified address
321   * @param _to The address to transfer to.
322   * @param _value The amount to be transferred.
323   */
324   function transfer(address _to, uint256 _value) public returns (bool) {
325     require(_to != address(0));
326     require(_value <= balances[msg.sender]);
327 
328     // SafeMath.sub will throw if there is not enough balance.
329     balances[msg.sender] = balances[msg.sender].sub(_value);
330     balances[_to] = balances[_to].add(_value);
331     Transfer(msg.sender, _to, _value);
332     return true;
333   }
334 
335   /**
336   * @dev Gets the balance of the specified address.
337   * @param _owner The address to query the the balance of.
338   * @return An uint256 representing the amount owned by the passed address.
339   */
340   function balanceOf(address _owner) public view returns (uint256 balance) {
341     return balances[_owner];
342   }
343 
344 }
345 
346 contract StandardToken is ERC20, BasicToken {
347 
348   mapping (address => mapping (address => uint256)) internal allowed;
349 
350 
351   /**
352    * @dev Transfer tokens from one address to another
353    * @param _from address The address which you want to send tokens from
354    * @param _to address The address which you want to transfer to
355    * @param _value uint256 the amount of tokens to be transferred
356    */
357   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
358     require(_to != address(0));
359     require(_value <= balances[_from]);
360     require(_value <= allowed[_from][msg.sender]);
361 
362     balances[_from] = balances[_from].sub(_value);
363     balances[_to] = balances[_to].add(_value);
364     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
365     Transfer(_from, _to, _value);
366     return true;
367   }
368 
369   /**
370    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
371    *
372    * Beware that changing an allowance with this method brings the risk that someone may use both the old
373    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
374    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
375    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
376    * @param _spender The address which will spend the funds.
377    * @param _value The amount of tokens to be spent.
378    */
379   function approve(address _spender, uint256 _value) public returns (bool) {
380     allowed[msg.sender][_spender] = _value;
381     Approval(msg.sender, _spender, _value);
382     return true;
383   }
384 
385   /**
386    * @dev Function to check the amount of tokens that an owner allowed to a spender.
387    * @param _owner address The address which owns the funds.
388    * @param _spender address The address which will spend the funds.
389    * @return A uint256 specifying the amount of tokens still available for the spender.
390    */
391   function allowance(address _owner, address _spender) public view returns (uint256) {
392     return allowed[_owner][_spender];
393   }
394 
395   /**
396    * @dev Increase the amount of tokens that an owner allowed to a spender.
397    *
398    * approve should be called when allowed[_spender] == 0. To increment
399    * allowed value is better to use this function to avoid 2 calls (and wait until
400    * the first transaction is mined)
401    * From MonolithDAO Token.sol
402    * @param _spender The address which will spend the funds.
403    * @param _addedValue The amount of tokens to increase the allowance by.
404    */
405   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
406     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
407     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
408     return true;
409   }
410 
411   /**
412    * @dev Decrease the amount of tokens that an owner allowed to a spender.
413    *
414    * approve should be called when allowed[_spender] == 0. To decrement
415    * allowed value is better to use this function to avoid 2 calls (and wait until
416    * the first transaction is mined)
417    * From MonolithDAO Token.sol
418    * @param _spender The address which will spend the funds.
419    * @param _subtractedValue The amount of tokens to decrease the allowance by.
420    */
421   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
422     uint oldValue = allowed[msg.sender][_spender];
423     if (_subtractedValue > oldValue) {
424       allowed[msg.sender][_spender] = 0;
425     } else {
426       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
427     }
428     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
429     return true;
430   }
431 
432 }
433 
434 contract AlphaMarketCoin is StandardToken {
435 
436     function AlphaMarketCoin(address _controller) public {
437         controller = _controller;
438         earlyAccess[_controller] = true;
439         totalSupply_ = 999999999 * 10 ** uint256(decimals);
440         balances[_controller] = totalSupply_;
441     }
442 
443     modifier onlyController {
444         require(msg.sender == controller);
445         _;
446     }
447 
448     // Transfering should be enabled by ICO contract only when half of ICO is passed
449     event TransferEnabled();
450 
451     function addEarlyAccessAddress(address _address) external onlyController {
452         require(_address != 0x0);
453         earlyAccess[_address] = true;
454     }
455 
456     function transfer(address _to, uint256 _value) public returns (bool) {
457         require(isTransferEnabled || earlyAccess[msg.sender]);
458         return super.transfer(_to, _value);
459     }
460 
461     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
462         require(isTransferEnabled);
463         return super.transferFrom(_from, _to, _value);
464     }
465 
466     function approve(address _spender, uint256 _value) public returns (bool) {
467         require(isTransferEnabled);
468         return super.approve(_spender, _value);
469     }
470     
471     function enableTransfering() public onlyController {
472         require(!isTransferEnabled);
473 
474         isTransferEnabled = true;
475         emit TransferEnabled();
476     }
477 
478     // Prevent sending ether to this address
479     function () public payable {
480         revert();
481     }
482 
483     bool public isTransferEnabled = false;
484     address public controller;
485     mapping(address => bool) public earlyAccess;
486 
487     uint8 public constant decimals = 18;
488     string public constant name = 'AlphaMarket Coin';
489     string public constant symbol = 'AMC';
490 }