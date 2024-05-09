1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipRenounced(owner);
55     owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address _newOwner) public onlyOwner {
63     _transferOwnership(_newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param _newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address _newOwner) internal {
71     require(_newOwner != address(0));
72     emit OwnershipTransferred(owner, _newOwner);
73     owner = _newOwner;
74   }
75 }
76 
77 
78 
79 
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, throws on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
91     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
92     // benefit is lost if 'b' is also tested.
93     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94     if (a == 0) {
95       return 0;
96     }
97 
98     c = a * b;
99     assert(c / a == b);
100     return c;
101   }
102 
103   /**
104   * @dev Integer division of two numbers, truncating the quotient.
105   */
106   function div(uint256 a, uint256 b) internal pure returns (uint256) {
107     // assert(b > 0); // Solidity automatically throws when dividing by 0
108     // uint256 c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110     return a / b;
111   }
112 
113   /**
114   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
115   */
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   /**
122   * @dev Adds two numbers, throws on overflow.
123   */
124   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
125     c = a + b;
126     assert(c >= a);
127     return c;
128   }
129 }
130 
131 
132 
133 
134 
135 
136 
137 
138 /**
139  * @title Pausable
140  * @dev Base contract which allows children to implement an emergency stop mechanism.
141  */
142 contract Pausable is Ownable {
143   event Pause();
144   event Unpause();
145 
146   bool public paused = false;
147 
148 
149   /**
150    * @dev Modifier to make a function callable only when the contract is not paused.
151    */
152   modifier whenNotPaused() {
153     require(!paused);
154     _;
155   }
156 
157   /**
158    * @dev Modifier to make a function callable only when the contract is paused.
159    */
160   modifier whenPaused() {
161     require(paused);
162     _;
163   }
164 
165   /**
166    * @dev called by the owner to pause, triggers stopped state
167    */
168   function pause() onlyOwner whenNotPaused public {
169     paused = true;
170     emit Pause();
171   }
172 
173   /**
174    * @dev called by the owner to unpause, returns to normal state
175    */
176   function unpause() onlyOwner whenPaused public {
177     paused = false;
178     emit Unpause();
179   }
180 }
181 
182 
183 
184 
185 
186 
187 /**
188  * @title ERC20 interface
189  * @dev see https://github.com/ethereum/EIPs/issues/20
190  */
191 contract ERC20 is ERC20Basic {
192   function allowance(address owner, address spender)
193     public view returns (uint256);
194 
195   function transferFrom(address from, address to, uint256 value)
196     public returns (bool);
197 
198   function approve(address spender, uint256 value) public returns (bool);
199   event Approval(
200     address indexed owner,
201     address indexed spender,
202     uint256 value
203   );
204 }
205 
206 
207 
208 contract BntyControllerInterface {
209     function destroyTokensInBntyTokenContract(address _owner, uint _amount) public returns (bool);
210 }
211 
212 
213 
214 
215 contract Bounty0xStaking is Ownable, Pausable {
216 
217     using SafeMath for uint256;
218 
219     address public Bounty0xToken;
220     uint public lockTime;
221 
222     mapping (address => uint) public balances;
223     mapping (uint => mapping (address => uint)) public stakes; // mapping of submission ids to mapping of addresses that staked an amount of bounty token
224     mapping (address => uint) public huntersLockDateTime;
225     mapping (address => uint) public huntersLockAmount;
226     
227     
228     event Deposit(address indexed depositor, uint amount, uint balance);
229     event Withdraw(address indexed depositor, uint amount, uint balance);
230     event Stake(uint indexed submissionId, address indexed hunter, uint amount, uint balance);
231     event StakeReleased(uint indexed submissionId, address indexed from, address indexed to, uint amount);
232     event Lock(address indexed hunter, uint amount, uint endDateTime);
233     event Unlock(address indexed hunter, uint amount);
234 
235 
236     constructor(address _bounty0xToken) public {
237         Bounty0xToken = _bounty0xToken;
238         lockTime = 30 days;
239     }
240     
241 
242     function deposit(uint _amount) external whenNotPaused {
243         //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
244         require(ERC20(Bounty0xToken).transferFrom(msg.sender, this, _amount));
245         balances[msg.sender] = SafeMath.add(balances[msg.sender], _amount);
246 
247         emit Deposit(msg.sender, _amount, balances[msg.sender]);
248     }
249     
250     function withdraw(uint _amount) external whenNotPaused {
251         require(balances[msg.sender] >= _amount);
252         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _amount);
253         require(ERC20(Bounty0xToken).transfer(msg.sender, _amount));
254 
255         emit Withdraw(msg.sender, _amount, balances[msg.sender]);
256     }
257     
258     
259     function lock(uint _amount) external whenNotPaused {
260         require(_amount != 0);
261         require(balances[msg.sender] >= _amount);
262         
263         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _amount);
264         huntersLockAmount[msg.sender] = SafeMath.add(huntersLockAmount[msg.sender], _amount);
265         huntersLockDateTime[msg.sender] = SafeMath.add(now, lockTime);
266         
267         emit Lock(msg.sender, huntersLockAmount[msg.sender], huntersLockDateTime[msg.sender]);
268     }
269     
270     function unlock() external whenNotPaused {
271         require(huntersLockDateTime[msg.sender] <= now);
272         uint amountLocked = huntersLockAmount[msg.sender];
273         require(amountLocked != 0);
274         
275         huntersLockAmount[msg.sender] = SafeMath.sub(huntersLockAmount[msg.sender], amountLocked);
276         balances[msg.sender] = SafeMath.add(balances[msg.sender], amountLocked);
277         
278         emit Unlock(msg.sender, amountLocked);
279     }
280 
281 
282     function stake(uint _submissionId, uint _amount) external whenNotPaused {
283         require(balances[msg.sender] >= _amount);
284         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _amount);
285         stakes[_submissionId][msg.sender] = SafeMath.add(stakes[_submissionId][msg.sender], _amount);
286 
287         emit Stake(_submissionId, msg.sender, _amount, balances[msg.sender]);
288     }
289 
290     function stakeToMany(uint[] _submissionIds, uint[] _amounts) external whenNotPaused {
291         uint totalAmount = 0;
292         for (uint j = 0; j < _amounts.length; j++) {
293             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
294         }
295         require(balances[msg.sender] >= totalAmount);
296         balances[msg.sender] = SafeMath.sub(balances[msg.sender], totalAmount);
297 
298         for (uint i = 0; i < _submissionIds.length; i++) {
299             stakes[_submissionIds[i]][msg.sender] = SafeMath.add(stakes[_submissionIds[i]][msg.sender], _amounts[i]);
300 
301             emit Stake(_submissionIds[i], msg.sender, _amounts[i], balances[msg.sender]);
302         }
303     }
304 
305 
306     function releaseStake(uint _submissionId, address _from, address _to) external onlyOwner {
307         require(stakes[_submissionId][_from] != 0);
308 
309         balances[_to] = SafeMath.add(balances[_to], stakes[_submissionId][_from]);
310         emit StakeReleased(_submissionId, _from, _to, stakes[_submissionId][_from]);
311         
312         stakes[_submissionId][_from] = 0;
313     }
314 
315     function releaseManyStakes(uint[] _submissionIds, address[] _from, address[] _to) external onlyOwner {
316         require(_submissionIds.length == _from.length &&
317                 _submissionIds.length == _to.length);
318 
319         for (uint i = 0; i < _submissionIds.length; i++) {
320             require(_from[i] != address(0));
321             require(_to[i] != address(0));
322             require(stakes[_submissionIds[i]][_from[i]] != 0);
323             
324             balances[_to[i]] = SafeMath.add(balances[_to[i]], stakes[_submissionIds[i]][_from[i]]);
325             emit StakeReleased(_submissionIds[i], _from[i], _to[i], stakes[_submissionIds[i]][_from[i]]);
326             
327             stakes[_submissionIds[i]][_from[i]] = 0;
328         }
329     }
330     
331 
332     function changeLockTime(uint _periodInSeconds) external onlyOwner {
333         lockTime = _periodInSeconds;
334     }
335     
336     
337     // Burnable mechanism
338 
339     address public bntyController;
340 
341     event Burn(uint indexed submissionId, address indexed from, uint amount);
342 
343     function changeBntyController(address _bntyController) external onlyOwner {
344         bntyController = _bntyController;
345     }
346 
347 
348     function burnStake(uint _submissionId, address _from) external onlyOwner {
349         require(stakes[_submissionId][_from] > 0);
350 
351         uint amountToBurn = stakes[_submissionId][_from];
352         stakes[_submissionId][_from] = 0;
353 
354         require(BntyControllerInterface(bntyController).destroyTokensInBntyTokenContract(this, amountToBurn));
355         emit Burn(_submissionId, _from, amountToBurn);
356     }
357 
358 
359     // in case of emergency
360     function emergentWithdraw() external onlyOwner {
361         require(ERC20(Bounty0xToken).transfer(msg.sender, this.balance));
362     }
363     
364 }