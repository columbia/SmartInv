1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 	function mul(uint a, uint b) internal returns (uint) {
10 		uint c = a * b;
11 		assert(a == 0 || c / a == b);
12 		return c;
13 	}
14 	function safeSub(uint a, uint b) internal returns (uint) {
15 		assert(b <= a);
16 		return a - b;
17 	}
18 	function div(uint a, uint b) internal returns (uint) {
19 		assert(b > 0);
20 		uint c = a / b;
21 		assert(a == b * c + a % b);
22 		return c;
23 	}
24 	function sub(uint a, uint b) internal returns (uint) {
25 		assert(b <= a);
26 		return a - b;
27 	}
28 	function add(uint a, uint b) internal returns (uint) {
29 		uint c = a + b;
30 		assert(c >= a);
31 		return c;
32 	}
33 	function max64(uint64 a, uint64 b) internal constant returns (uint64) {
34 		return a >= b ? a : b;
35 	}
36 	function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37 		return a < b ? a : b;
38 	}
39 	function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40 		return a >= b ? a : b;
41 	}
42 	function min256(uint256 a, uint256 b) internal constant returns (uint256) {
43 		return a < b ? a : b;
44 	}
45 	function assert(bool assertion) internal {
46 		if (!assertion) {
47 			throw;
48 		}
49 	}
50 }
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     address public owner;
60     function Ownable() {
61         owner = msg.sender;
62     }
63     modifier onlyOwner {
64         if (msg.sender != owner) throw;
65         _;
66     }
67     function transferOwnership(address newOwner) onlyOwner {
68         if (newOwner != address(0)) {
69             owner = newOwner;
70         }
71     }
72 }
73 
74 
75 /**
76  * @title Pausable
77  * @dev Base contract which allows children to implement an emergency stop mechanism.
78  */
79 contract Pausable is Ownable {
80 	bool public stopped;
81 	modifier stopInEmergency {
82 		if (stopped) {
83 			throw;
84 		}
85 		_;
86 	}
87 
88 	modifier onlyInEmergency {
89 		if (!stopped) {
90 		  throw;
91 		}
92 	_;
93 	}
94 	// called by the owner on emergency, triggers stopped state
95 	function emergencyStop() external onlyOwner {
96 		stopped = true;
97 	}
98 	// called by the owner on end of emergency, returns to normal state
99 	function release() external onlyOwner onlyInEmergency {
100 		stopped = false;
101 	}
102 }
103 
104 
105 
106 /**
107  * @title PullPayment
108  * @dev Base contract supporting async send for pull payments. Inherit from this
109  * contract and use asyncSend instead of send.
110  */
111 contract PullPayment {
112 	using SafeMath for uint;
113 
114 	mapping(address => uint) public payments;
115 	event LogRefundETH(address to, uint value);
116 	/**
117 	*  Store sent amount as credit to be pulled, called by payer 
118 	**/
119 	function asyncSend(address dest, uint amount) internal {
120 		payments[dest] = payments[dest].add(amount);
121 	}
122 	// withdraw accumulated balance, called by payee
123 	function withdrawPayments() {
124 		address payee = msg.sender;
125 		uint payment = payments[payee];
126 
127 		if (payment == 0) {
128 			throw;
129 		}
130 		if (this.balance < payment) {
131 		    throw;
132 		}
133 		payments[payee] = 0;
134 		if (!payee.send(payment)) {
135 		    throw;
136 		}
137 		LogRefundETH(payee,payment);
138 	}
139 }
140 
141 
142 
143 /**
144  * @title ERC20Basic
145  * @dev Simpler version of ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/179
147  */
148 contract ERC20Basic {
149 	uint public totalSupply;
150 	function balanceOf(address who) constant returns (uint);
151 	function transfer(address to, uint value);
152 	event Transfer(address indexed from, address indexed to, uint value);
153 }
154 
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161 	function allowance(address owner, address spender) constant returns (uint);
162 	function transferFrom(address from, address to, uint value);
163 	function approve(address spender, uint value);
164 	event Approval(address indexed owner, address indexed spender, uint value);
165 }
166 
167 
168 /**
169  * @title Basic token
170  * @dev Basic version of StandardToken, with no allowances. 
171  */
172 contract BasicToken is ERC20Basic {
173   
174 	using SafeMath for uint;
175 
176 	mapping(address => uint) balances;
177 
178 	/*
179 	* Fix for the ERC20 short address attack  
180 	*/
181 	modifier onlyPayloadSize(uint size) {
182 	   if(msg.data.length < size + 4) {
183 	     throw;
184 	   }
185 	 _;
186 	}
187 	function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
188 		balances[msg.sender] = balances[msg.sender].sub(_value);
189 		balances[_to] = balances[_to].add(_value);
190 		Transfer(msg.sender, _to, _value);
191 	}
192 	function balanceOf(address _owner) constant returns (uint balance) {
193 		return balances[_owner];
194 	}
195 }
196 
197 
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implementation of the basic standard token.
202  * @dev https://github.com/ethereum/EIPs/issues/20
203  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
204  */
205 contract StandardToken is BasicToken, ERC20 {
206 	mapping (address => mapping (address => uint)) allowed;
207 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
208 		var _allowance = allowed[_from][msg.sender];
209 		balances[_to] = balances[_to].add(_value);
210 		balances[_from] = balances[_from].sub(_value);
211 		allowed[_from][msg.sender] = _allowance.sub(_value);
212 		Transfer(_from, _to, _value);
213     }
214 	function approve(address _spender, uint _value) {
215 		if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
216 		allowed[msg.sender][_spender] = _value;
217 		Approval(msg.sender, _spender, _value);
218 	}
219 	function allowance(address _owner, address _spender) constant returns (uint remaining) {
220 		return allowed[_owner][_spender];
221 	}
222 }
223 
224 
225 /**
226  *  ClusterToken presale contract.
227  */
228 contract ClusterToken is StandardToken, PullPayment, Ownable, Pausable {
229 	
230   using SafeMath for uint;
231   
232   struct Backer {
233         address buyer;
234         uint contribution;
235         uint withdrawnAtSegment;
236         uint withdrawnAtCluster;
237         bool state;
238     }
239     
240     /**
241      * Variables
242     */
243     string public constant name = "ClusterToken";
244     string public constant symbol = "CLRT";
245     uint256 public constant decimals = 18;
246     uint256 private buyPriceEth = 10000000000000000;
247     
248     uint256 public initialBlockCount;
249     uint256 private testBlockEnd;
250     uint256 public contributors;
251     
252     uint256 private minedBlocks;
253     uint256 private ClusterCurrent;
254     uint256 private SegmentCurrent;
255     uint256 private UnitCurrent;
256   
257   
258     mapping(address => Backer) public backers;
259     
260    
261     /**
262      * @dev Contract constructor
263      */ 
264     function ClusterToken() {
265     totalSupply = 750000000000000000000;
266     balances[msg.sender] = totalSupply;
267     
268     initialBlockCount = 4086356;
269 
270     contributors = 0;
271     }
272     
273     
274     /**
275      * @return Returns the current amount of CLUSTERS
276      */ 
277     function currentCluster() constant returns (uint256 currentCluster)
278     {
279     	uint blockCount = block.number - initialBlockCount;
280     	uint result = blockCount.div(1000000);
281     	return result;
282     }
283     
284     
285     /**
286      * @return Returns the current amount of SEGMENTS
287      */ 
288     function currentSegment() constant returns (uint256 currentSegment)
289     {
290     	uint blockCount = block.number - initialBlockCount;
291     	uint newSegment = currentCluster().mul(1000);
292     	uint result = blockCount.div(1000).sub(newSegment);
293 
294     	return result;
295     }
296     
297     
298     /**
299      * @return Returns the current amount of UNITS
300      */ 
301     function currentUnit() constant returns (uint256 currentUnit)
302     {
303     	uint blockCount = block.number - initialBlockCount;
304     	uint getClusters = currentCluster().mul(1000000);
305         uint newUnit = currentSegment().mul(1000);
306     	return blockCount.sub(getClusters).sub(newUnit);      
307     	
308     }
309     
310     
311     /**
312      * @return Returns the current network block
313      */ 
314     function currentBlock() constant returns (uint256 blockNumber)
315     {
316     	return block.number - initialBlockCount;
317     }
318 
319 
320 
321     /**
322      * @dev Allows users to buy CLUSTER and receive their tokens at once.
323      * @return The amount of CLUSTER bought by sender.
324      */ 
325     function buyClusterToken() payable returns (uint amount) {
326         
327         if (balances[this] < amount) throw;                          
328         amount = msg.value.mul(buyPriceEth).div(1 ether);
329         balances[msg.sender] += amount;
330         balances[this] -= amount;
331         Transfer(this, msg.sender, amount);
332         
333         Backer backer = backers[msg.sender];
334         backer.contribution = backer.contribution.add(amount);
335         backer.withdrawnAtSegment = backer.withdrawnAtSegment.add(0);
336         backer.withdrawnAtCluster = backer.withdrawnAtCluster.add(0);
337         backer.state = backer.state = true;
338         
339         contributors++;
340         
341         return amount;
342     }
343     
344     
345     /**
346      * @dev Allows users to claim CLUSTER every 1000 SEGMENTS (1.000.000 blocks).
347      * @return The amount of CLUSTER claimed by sender.
348      */
349     function claimClusters() public returns (uint amount) {
350         
351         if (currentSegment() == 0) throw;
352         if (!backers[msg.sender].state) throw; 
353         
354         uint previousWithdraws = backers[msg.sender].withdrawnAtCluster;
355         uint entitledToClusters = currentCluster().sub(previousWithdraws);
356         
357         if (entitledToClusters == 0) throw;
358         if (!isEntitledForCluster(msg.sender)) throw;
359         
360         uint userShares = backers[msg.sender].contribution.div(1 finney);
361         uint amountForPayout = buyPriceEth.div(contributors);
362         
363         amount =  amountForPayout.mul(userShares).mul(1000);                           
364         
365         balances[msg.sender] += amount;
366         balances[this] -= amount;
367         Transfer(this, msg.sender, amount);
368         
369         backers[msg.sender].withdrawnAtCluster = currentCluster(); 
370         
371         return amount;
372     }
373     
374     
375     /**
376      * @dev Allows users to claim segments every 1000 UNITS (blocks).
377      * @dev NOTE: Users claiming SEGMENTS instead of CLUSTERS get only half of the reward.
378      * @return The amount of SEGMENTS claimed by sender.
379      */
380     function claimSegments() public returns (uint amount) {
381         
382         if (currentSegment() == 0) throw;
383         if (!backers[msg.sender].state) throw;  
384         
385         
386         uint previousWithdraws = currentCluster().add(backers[msg.sender].withdrawnAtSegment);
387         uint entitledToSegments = currentCluster().add(currentSegment().sub(previousWithdraws));
388         
389         if (entitledToSegments == 0 ) throw;
390         
391         uint userShares = backers[msg.sender].contribution.div(1 finney);
392         uint amountForPayout = buyPriceEth.div(contributors);
393         
394         amount =  amountForPayout.mul(userShares).div(10).div(2);                           
395         
396         balances[msg.sender] += amount;
397         balances[this] -= amount;
398         Transfer(this, msg.sender, amount);
399         
400         backers[msg.sender].withdrawnAtSegment = currentSegment(); 
401         
402         return amount;
403     }
404 
405     
406     /**
407      * @dev Function if users send funds to this contract, call the buy function.
408      */ 
409     function() payable {
410         if (msg.sender != owner) {
411             buyClusterToken();
412         }
413     }
414     
415     
416     /**
417      * @dev Allows owner to withdraw funds from the account.
418      */ 
419     function Drain() onlyOwner public {
420         if(this.balance > 0) {
421             if (!owner.send(this.balance)) throw;
422         }
423     }
424     
425     
426     
427     /**
428     *  Burn away the specified amount of ClusterToken tokens.
429     * @return Returns success boolean.
430     */
431     function burn(uint _value) onlyOwner returns (bool) {
432         balances[msg.sender] = balances[msg.sender].sub(_value);
433         totalSupply = totalSupply.sub(_value);
434         Transfer(msg.sender, 0x0, _value);
435         return true;
436     }
437     
438     
439     /**
440      * @dev Internal check to see if at least 1000 segments passed without withdrawal prior to rewarding a cluster
441      */ 
442     function isEntitledForCluster(address _sender) private constant returns (bool) {
443         
444         uint t1 = currentCluster().mul(1000).add(currentSegment()); 
445         uint t2 = backers[_sender].withdrawnAtSegment;      
446 
447         if (t1.sub(t2) >= 1000) { return true; }
448         return false;
449         
450     }
451     
452 }