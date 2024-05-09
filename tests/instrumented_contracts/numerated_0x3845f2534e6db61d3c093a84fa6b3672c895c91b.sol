1 pragma solidity ^0.4.21;
2 
3 // File: contracts/Interfaces/MasterDepositInterface.sol
4 
5 /**
6  * @dev Interface of MasterDeposit that should be used in child contracts 
7  * @dev this ensures that no duplication of code and implicit gasprice will be used for the dynamic creation of child contract
8  */
9 contract MasterDepositInterface {
10     address public coldWallet1;
11     address public coldWallet2;
12     uint public percentage;
13     function fireDepositToChildEvent(uint _amount) public;
14 }
15 
16 // File: zeppelin-solidity/contracts/math/SafeMath.sol
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     if (a == 0) {
29       return 0;
30     }
31     uint256 c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers, truncating the quotient.
38   */
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   /**
47   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48   */
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   /**
55   * @dev Adds two numbers, throws on overflow.
56   */
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72   function totalSupply() public view returns (uint256);
73   function balanceOf(address who) public view returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) public view returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 // File: contracts/ChildDeposit.sol
92 
93 /**
94 * @dev Should be dinamically created from master contract 
95 * @dev multiple payers can contribute here 
96 */
97 contract ChildDeposit {
98     
99     /**
100     * @dev prevents over and under flows
101     */
102     using SafeMath for uint;
103     
104     /**
105     * @dev import only the interface for low gas cost
106     */
107     // MasterDepositInterface public master;
108     address masterAddress;
109 
110     function ChildDeposit() public {
111         masterAddress = msg.sender;
112         // master = MasterDepositInterface(msg.sender);
113     }
114 
115     /**
116     * @dev any ETH income will fire a master deposit contract event
117     * @dev the redirect of ETH will be split in the two wallets provided by the master with respect to the share percentage set for wallet 1 
118     */
119     function() public payable {
120 
121         MasterDepositInterface master = MasterDepositInterface(masterAddress);
122         // fire transfer event
123         master.fireDepositToChildEvent(msg.value);
124 
125         // trasnfer of ETH
126         // with respect to the percentage set
127         uint coldWallet1Share = msg.value.mul(master.percentage()).div(100);
128         
129         // actual transfer
130         master.coldWallet1().transfer(coldWallet1Share);
131         master.coldWallet2().transfer(msg.value.sub(coldWallet1Share));
132     }
133 
134     /**
135     * @dev function that can only be called by the creator of this contract
136     * @dev the actual condition of transfer is in the logic of the master contract
137     * @param _value ERC20 amount 
138     * @param _tokenAddress ERC20 contract address 
139     * @param _destination should be onbe of the 2 coldwallets
140     */
141     function withdraw(address _tokenAddress, uint _value, address _destination) public onlyMaster {
142         ERC20(_tokenAddress).transfer(_destination, _value);
143     }
144 
145     modifier onlyMaster() {
146         require(msg.sender == address(masterAddress));
147         _;
148     }
149     
150 }
151 
152 // File: zeppelin-solidity/contracts/ReentrancyGuard.sol
153 
154 /**
155  * @title Helps contracts guard agains reentrancy attacks.
156  * @author Remco Bloemen <remco@2Ï€.com>
157  * @notice If you mark a function `nonReentrant`, you should also
158  * mark it `external`.
159  */
160 contract ReentrancyGuard {
161 
162   /**
163    * @dev We use a single lock for the whole contract.
164    */
165   bool private reentrancy_lock = false;
166 
167   /**
168    * @dev Prevents a contract from calling itself, directly or indirectly.
169    * @notice If you mark a function `nonReentrant`, you should also
170    * mark it `external`. Calling one nonReentrant function from
171    * another is not supported. Instead, you can implement a
172    * `private` function doing the actual work, and a `external`
173    * wrapper marked as `nonReentrant`.
174    */
175   modifier nonReentrant() {
176     require(!reentrancy_lock);
177     reentrancy_lock = true;
178     _;
179     reentrancy_lock = false;
180   }
181 
182 }
183 
184 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
185 
186 /**
187  * @title Ownable
188  * @dev The Ownable contract has an owner address, and provides basic authorization control
189  * functions, this simplifies the implementation of "user permissions".
190  */
191 contract Ownable {
192   address public owner;
193 
194 
195   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197 
198   /**
199    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200    * account.
201    */
202   function Ownable() public {
203     owner = msg.sender;
204   }
205 
206   /**
207    * @dev Throws if called by any account other than the owner.
208    */
209   modifier onlyOwner() {
210     require(msg.sender == owner);
211     _;
212   }
213 
214   /**
215    * @dev Allows the current owner to transfer control of the contract to a newOwner.
216    * @param newOwner The address to transfer ownership to.
217    */
218   function transferOwnership(address newOwner) public onlyOwner {
219     require(newOwner != address(0));
220     OwnershipTransferred(owner, newOwner);
221     owner = newOwner;
222   }
223 
224 }
225 
226 // File: zeppelin-solidity/contracts/ownership/Claimable.sol
227 
228 /**
229  * @title Claimable
230  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
231  * This allows the new owner to accept the transfer.
232  */
233 contract Claimable is Ownable {
234   address public pendingOwner;
235 
236   /**
237    * @dev Modifier throws if called by any account other than the pendingOwner.
238    */
239   modifier onlyPendingOwner() {
240     require(msg.sender == pendingOwner);
241     _;
242   }
243 
244   /**
245    * @dev Allows the current owner to set the pendingOwner address.
246    * @param newOwner The address to transfer ownership to.
247    */
248   function transferOwnership(address newOwner) onlyOwner public {
249     pendingOwner = newOwner;
250   }
251 
252   /**
253    * @dev Allows the pendingOwner address to finalize the transfer.
254    */
255   function claimOwnership() onlyPendingOwner public {
256     OwnershipTransferred(owner, pendingOwner);
257     owner = pendingOwner;
258     pendingOwner = address(0);
259   }
260 }
261 
262 // File: contracts/MasterDeposit.sol
263 
264 /**
265 * @dev master contract that creates ChildDeposits. Responsible for controlling and setup of deposit chain.  
266 * @dev all functions that should be called from child deposits are specified in the MasterDepositInterface 
267 */
268 contract MasterDeposit is MasterDepositInterface, Claimable, ReentrancyGuard {
269     
270     /**
271     * @dev prevents over and under flows
272     */
273     using SafeMath for uint;
274 
275     /**
276     * @dev mapping of all created child deposits
277     */
278     mapping (address => bool) public childDeposits;
279 
280     /**
281     * @dev responsible for creating deposits (in this way the owner isn't exposed to a api/server security breach)
282     * @dev by loosing the depositCreator key an attacker can only create deposits that will not be a real threat and another depositCreator can be allocated
283     */
284     address public depositCreator;
285 
286     /**
287     * @dev Fired at create time
288     * @param _depositAddress blockchain address of the newly created deposit contract
289     */
290     event CreatedDepositEvent (
291     address indexed _depositAddress
292     );
293     
294     /**
295     * @dev Fired at transfer time
296     * @dev Event that signals the transfer of an ETH amount 
297     * @param _depositAddress blockchain address of the deposit contract that received ETH
298     * @param _amount of ETH
299     */
300     event DepositToChildEvent(
301     address indexed _depositAddress, 
302     uint _amount
303     );
304 
305 
306     /**
307     * @param _wallet1 redirect of tokens (ERC20) or ETH
308     * @param _wallet2 redirect of tokens (ERC20) or eth
309     * @param _percentage _wallet1 split percentage 
310     */
311     function MasterDeposit(address _wallet1, address _wallet2, uint _percentage) onlyValidPercentage(_percentage) public {
312         require(_wallet1 != address(0));
313         require(_wallet2 != address(0));
314         percentage = _percentage;
315         coldWallet1 = _wallet1;
316         coldWallet2 = _wallet2;
317     }
318 
319     /**
320     * @dev creates a number of instances of ChildDeposit contracts
321     * @param _count creates a specified number of deposit contracts
322     */
323     function createChildDeposits(uint _count) public onlyDepositCreatorOrMaster {
324         for (uint i = 0; i < _count; i++) {
325             ChildDeposit childDeposit = new ChildDeposit();
326             childDeposits[address(childDeposit)] = true;
327             emit CreatedDepositEvent(address(childDeposit));    
328         }
329     }
330 
331     /**
332     * @dev setter for the address that is responsible for creating deposits 
333     */
334     function setDepositCreator(address _depositCreator) public onlyOwner {
335         require(_depositCreator != address(0));
336         depositCreator = _depositCreator;
337     }
338 
339     /**
340     * @dev Setter for the income percentage in the first coldwallet (not setting this the second wallet will receive all income)
341     */
342     function setColdWallet1SplitPercentage(uint _percentage) public onlyOwner onlyValidPercentage(_percentage) {
343         percentage = _percentage;
344     }
345 
346     /**
347     * @dev function created to emit the ETH transfer event from the child contract only
348     * @param _amount ETH amount 
349     */
350     function fireDepositToChildEvent(uint _amount) public onlyChildContract {
351         emit DepositToChildEvent(msg.sender, _amount);
352     }
353 
354     /**
355     * @dev changes the coldwallet1 address
356     */
357     function setColdWallet1(address _coldWallet1) public onlyOwner {
358         require(_coldWallet1 != address(0));
359         coldWallet1 = _coldWallet1;
360     }
361 
362     /**
363     * @dev changes the coldwallet2 address
364     */
365     function setColdWallet2(address _coldWallet2) public onlyOwner {
366         require(_coldWallet2 != address(0));
367         coldWallet2 = _coldWallet2;
368     }
369 
370     /**
371     * @dev function that can be called only by owner due to security reasons and will withdraw the amount of ERC20 tokens
372     * @dev from the deposit contract list to the cold wallets 
373     * @dev transfers only the ERC20 tokens, ETH should be transferred automatically
374     * @param _deposits batch list with all deposit contracts that might hold ERC20 tokens
375     * @param _tokenContractAddress specifies what token to be transfered form each deposit from the batch to the cold wallets
376     */
377     function transferTokens(address[] _deposits, address _tokenContractAddress) public onlyOwner nonReentrant {
378         for (uint i = 0; i < _deposits.length; i++) {
379             address deposit = _deposits[i];
380             uint erc20Balance = ERC20(_tokenContractAddress).balanceOf(deposit);
381 
382             // if no balance found just skip
383             if (erc20Balance == 0) {
384                 continue;
385             }
386             
387             // trasnfer of erc20 tokens
388             // with respect to the percentage set
389             uint coldWallet1Share = erc20Balance.mul(percentage).div(100);
390             uint coldWallet2Share = erc20Balance.sub(coldWallet1Share); 
391             ChildDeposit(deposit).withdraw(_tokenContractAddress,coldWallet1Share, coldWallet1);
392             ChildDeposit(deposit).withdraw(_tokenContractAddress,coldWallet2Share, coldWallet2);
393         }
394     }
395 
396     modifier onlyChildContract() {
397         require(childDeposits[msg.sender]);
398         _;
399     }
400 
401     modifier onlyDepositCreatorOrMaster() {
402         require(msg.sender == owner || msg.sender == depositCreator);
403         _;
404     }
405 
406     modifier onlyValidPercentage(uint _percentage) {
407         require(_percentage >=0 && _percentage <= 100);
408         _;
409     }
410 
411 }