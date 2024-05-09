1 /**
2 *
3 The MIT License (MIT)
4 
5 Copyright (c) 2018 Bitindia.
6 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
7 
8 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
9 
10 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
11 For more information regarding the MIT License visit: https://opensource.org/licenses/MIT
12 
13 @AUTHOR Bitindia. https://bitindia.co/
14 *
15 */
16 
17 
18 pragma solidity ^0.4.15;
19 
20 
21 contract IERC20 {
22     function totalSupply() public constant returns (uint _totalSupply);
23     function balanceOf(address _owner) public constant returns (uint balance);
24     function transfer(address _to, uint _value) public returns (bool success);
25     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
26     function approve(address _spender, uint _value) public returns (bool success);
27     function allowance(address _owner, address _spender) public constant returns (uint remaining);
28     event Transfer(address indexed _from, address indexed _to, uint _value);
29     event Approval(address indexed _owner, address indexed _spender, uint _value);
30 }
31 
32 
33 /**
34  * @title Ownable
35  * @notice The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39 
40   address public owner;
41 
42   /**
43    * @notice The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50   /**
51    * @notice Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   /**
59    * @notice Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     require(newOwner != address(0));
64     owner = newOwner;
65   }
66 }
67 
68 /**
69  * BitindiaVestingContract 
70  * This Contract is a custodian for Bitindia Tokens reserved for Founders
71  * Founders can claim as per fixed Vesting Schedule
72  * Founders can only claim the amount alloted to them before initialization
73  * The Contract gets into a locked state once initialized and no more founder address can be further added
74  * The Founder addresses are added using addVestingUser method and logs an Event AddUser on successful addition
75  * Only the contract owner can add the Vesting users and cannot change the address once inititialized
76  * Anyone can check the state inititialized, as its a public variable
77  * Once initialized, founders can anytime change their claim address, and this can be done only using their private key,
78  * No body else can change claimant address other than themselves.
79  * No kind of recovery is possible once the private key of any claimant is lost and any unclaimed tokens will be locked in this contract forever
80  */ 
81 contract BitindiaVestingContract is Ownable{
82 
83   IERC20 token;
84 
85   mapping (address => uint256) ownersMap;
86 
87   mapping (address => uint256) ownersMapFirstPeriod;    
88   mapping (address => uint256) ownersMapSecondPeriod;    
89   mapping (address => uint256) ownersMapThirdPeriod;   
90 
91   /**
92    * Can be initialized only once all the committed token amount is deposited to this contract
93    * Once initialized, it cannot be set False again
94    * Once initialized, no more founder address can be registered
95    */ 
96   bool public initialized = false;
97 
98   /**
99    * At any point displays total anount that is yet to be claimed
100    */
101   uint256 public totalCommitted;
102 
103   /**
104    * To avoid too many address changes,  * 
105    */ 
106   mapping (address => address)  originalAddressTraker;
107   mapping (address => uint) changeAddressAttempts;
108 
109   /**
110    *  Fixed Vesting Schedule   *
111    */
112   uint256 public constant firstDueDate = 1544486400;    // Human time (GMT): Tuesday, 11 December 2018 00:00:00
113   uint256 public constant secondDueDate = 1560211200;   // Human time (GMT): Tuesday, Tuesday, 11 June 2019 00:00:00
114   uint256 public constant thirdDueDate = 1576022400;    // Human time (GMT): Wednesday, 11 December 2019 00:00:00
115 
116   /**
117    * Address of the Token to be vested 
118    */
119   address public constant tokenAddress = 0x420335D3DEeF2D5b87524Ff9D0fB441F71EA621f;
120   
121   /**
122    * Event to log change of address request if successful, only the Actual owner can transfer its ownership
123    *  
124    */
125   event ChangeClaimAddress(address oldAddress, address newAddress);
126 
127   /**
128    * Event to log claimed amount once the vesting condition is met.
129    */
130   event AmountClaimed(address user, uint256 amount);
131 
132   /**
133    * Event to Log added user
134    */ 
135   event AddUser(address userAddress, uint256 amount);
136  
137   /**
138    * Cnstr BitindiaVestingContract
139    * Sets the vesting period in utc timestamp and the vesting token address
140    */
141   function BitindiaVestingContract() public {
142       token = IERC20(tokenAddress);
143       initialized = false;
144       totalCommitted = 0;
145   }
146 
147   /**
148    *    Initializes the contract only once 
149    *    Requires token balance to be atleast equal to total commited, any amount greater than commited is lost in the contract forever  
150    */ 
151   function initialize() public onlyOwner
152   {
153       require(totalCommitted>0);
154       require(totalCommitted <= token.balanceOf(this));
155       if(!initialized){
156             initialized = true;
157       }
158   }
159 
160   /**
161    * @notice To check if Contract is active
162    */
163   modifier whenContractIsActive() {
164     // Check if Contract is active
165     require(initialized);
166     _;
167   }
168 
169   /**
170    * @notice To check if Contract is not yet initialized
171    */
172   modifier preInitState() {
173     // Check if Contract is not initialized
174     require(!initialized);
175     _;
176   }
177 
178    /**
179    * @notice To check if Claimable
180    */
181   modifier whenClaimable() {
182     // Check if Contract is active
183     assert(now>firstDueDate);
184     _;
185   }
186   
187   /**
188    * Asserts the msg sender to have valid stake in the vesting schedule, else eat up their GAS 
189    * this is to discourage SPAMMERS
190    */ 
191   modifier checkValidUser(){
192     assert(ownersMap[msg.sender]>0);
193     _;
194   }
195 
196   /**
197    * @notice Can be called only before initialization
198    * Equal vesting in three periods
199    */
200   function addVestingUser(address user, uint256 amount) public onlyOwner preInitState {
201       uint256 oldAmount = ownersMap[user];
202       ownersMap[user] = amount;
203       ownersMapFirstPeriod[user] = amount/3;         
204       ownersMapSecondPeriod[user] = amount/3;
205       ownersMapThirdPeriod[user] = amount - ownersMapFirstPeriod[user] - ownersMapSecondPeriod[user];
206       originalAddressTraker[user] = user;
207       changeAddressAttempts[user] = 0;
208       totalCommitted += (amount - oldAmount);
209       AddUser(user, amount);
210   }
211   
212   /**
213    * This is to change the address of the claimant.
214    * SPRECIAL NOTE: ONLY THE VALID CLAIMANT CAN change its address and nobody else can do this  
215    */
216   function changeClaimAddress(address newAddress) public checkValidUser{
217 
218       // Validates if Change address is not meant to Spam
219       address origAddress = originalAddressTraker[msg.sender];
220       uint newCount = changeAddressAttempts[origAddress]+1;
221       assert(newCount<5);
222       changeAddressAttempts[origAddress] = newCount;
223       
224       // Do the address change transaction
225       uint256 balance = ownersMap[msg.sender];
226       ownersMap[msg.sender] = 0;
227       ownersMap[newAddress] = balance;
228 
229 
230       // Do the address change transaction for FirstPeriod
231       balance = ownersMapFirstPeriod[msg.sender];
232       ownersMapFirstPeriod[msg.sender] = 0;
233       ownersMapFirstPeriod[newAddress] = balance;
234 
235       // Do the address change transaction for SecondPeriod
236       balance = ownersMapSecondPeriod[msg.sender];
237       ownersMapSecondPeriod[msg.sender] = 0;
238       ownersMapSecondPeriod[newAddress] = balance;
239 
240 
241       // Do the address change transaction for FirstPeriod
242       balance = ownersMapThirdPeriod[msg.sender];
243       ownersMapThirdPeriod[msg.sender] = 0;
244       ownersMapThirdPeriod[newAddress] = balance;
245 
246 
247       // Update Original Address Tracker Map 
248       originalAddressTraker[newAddress] = origAddress;
249       ChangeClaimAddress(msg.sender, newAddress);
250   }
251 
252 
253   /**
254    * Admin function to restart attempt counts for a user
255    */
256   function updateChangeAttemptCount(address user) public onlyOwner{
257     address origAddress = originalAddressTraker[user];
258     changeAddressAttempts[origAddress] = 0;
259   }
260 
261   /**
262    * Check the balance of the Vesting Contract
263    */
264   function getBalance() public constant returns (uint256) {
265       return token.balanceOf(this);
266   }
267 
268   /**
269    * To claim the vesting amount
270    * Asserts the vesting condition is met
271    * Asserts callee to be valid vested user 
272    * Claims as per Vesting Schedule and remaining eligible balance
273    */
274   function claimAmount() internal whenContractIsActive whenClaimable checkValidUser{
275       uint256 amount = 0;
276       uint256 periodAmount = 0;
277       if(now>firstDueDate){
278         periodAmount = ownersMapFirstPeriod[msg.sender];
279         if(periodAmount > 0){
280           ownersMapFirstPeriod[msg.sender] = 0;
281           amount += periodAmount;
282         }
283       }
284 
285       if(now>secondDueDate){
286         periodAmount = ownersMapSecondPeriod[msg.sender];
287         if(periodAmount > 0){
288           ownersMapSecondPeriod[msg.sender] = 0;
289           amount += periodAmount;
290         }
291       }
292 
293       if(now>thirdDueDate){
294         periodAmount = ownersMapThirdPeriod[msg.sender];
295         if(periodAmount > 0){
296           ownersMapThirdPeriod[msg.sender] = 0;
297           amount += periodAmount;
298         }
299       }
300       require(amount>0);
301       ownersMap[msg.sender]= ownersMap[msg.sender]-amount;
302       token.transfer(msg.sender, amount);
303       totalCommitted -= amount;
304 
305   }
306 
307 
308    /**
309    * Main fallback to claim tokens after successful vesting
310    * Asserts the sender to be a valid owner of tokens and vesting period is over
311    */
312   function () external payable {
313       claimAmount();
314   }
315 
316 
317   /**
318    * To check total remaining claimable amount
319    */
320    function getClaimable() public constant returns (uint256){
321        return totalCommitted;
322    }
323    
324    /**
325     * Check Own Balance 
326     * Works only for transaction senders with valid Balance
327     */ 
328    function getMyBalance() public checkValidUser constant returns (uint256){
329        
330        return ownersMap[msg.sender];
331        
332    }
333    
334 
335 
336 }