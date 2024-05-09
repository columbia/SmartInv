1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract ERC20Basic {
47     function totalSupply() public view returns (uint256);
48     function balanceOf(address who) public view returns (uint256);
49     function transfer(address to, uint256 value) public returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 
54 contract ERC20 is ERC20Basic {
55     function allowance(address owner, address spender) public view returns (uint256);
56     function transferFrom(address from, address to, uint256 value) public returns (bool);
57     function approve(address spender, uint256 value) public returns (bool);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 /// @title Intel contract
63 /// @author Pareto Admin
64 /// @notice Intel, A contract for creating, rewarding and distributing Intels
65 contract Intel{
66     
67     using SafeMath for uint256;
68     
69     struct IntelState {
70         address intelProvider;
71         uint depositAmount;
72         uint desiredReward;
73         // total balance of Pareto tokens given for this intel
74         // including the intel provider’s deposit
75         uint balance;
76         uint intelID;
77         // timestamp for when rewards can be collected
78         uint rewardAfter;
79         // flag indicating whether the rewards have been collected
80         bool rewarded;
81                 // stores how many Pareto tokens were given for this intel
82         // in case you want to enforce a max amount per contributor
83         address[] contributionsList;
84         mapping(address => uint) contributions;
85 
86     }
87 
88 
89     mapping(uint => IntelState) intelDB;
90     mapping(address => IntelState[]) public IntelsByProvider;
91     uint[] intelIndexes;
92     
93     uint public intelCount;
94     
95 
96     address public owner;    // Storage variable to hold the address of owner
97     
98     ERC20 public token;   // Storage variable of type ERC20 to hold Pareto token's address
99     address public ParetoAddress;
100 
101     
102     constructor(address _owner, address _token) public {
103         owner = _owner;  // owner is a Pareto wallet which should be able to perform admin functions
104         token = ERC20(_token);
105         ParetoAddress = _token;
106     }
107     
108 
109     // modifier to check of the sender of transaction is the owner
110     modifier onlyOwner(){
111         require(msg.sender == owner);
112         _;
113     }
114     
115 
116     event Reward( address sender, uint intelIndex, uint rewardAmount);
117     event NewIntel(address intelProvider, uint depositAmount, uint desiredReward, uint intelID, uint ttl);
118     event RewardDistributed(uint intelIndex, uint provider_amount, address provider, address distributor, uint distributor_amount);
119     event LogProxy(address destination, address account, uint amount, uint gasLimit);
120     
121 
122     /// @author Pareto Admin
123     /// @notice this function creates an Intel
124     /// @dev Uses 'now' for timestamps.
125     /// @param intelProvider is the address of the Intel's provider
126     /// @param depositAmount is the amount of Pareto tokens deposited by provider
127     /// @param desiredReward is the amount of Pareto tokens desired by provider as reward
128     /// @param intelID is the ID of Intel which is mapped against an Intel in IntelDB as well as the database external to Ethereum
129     /// @param ttl is the time in EPOCH format until the Intel remains active and accepts rewards
130     /// requires 210769 gas in Rinkeby Network
131     function create(address intelProvider, uint depositAmount, uint desiredReward, uint intelID, uint ttl) public {
132 
133         require(address(intelProvider) != address(0x0));
134         require(depositAmount > 0);
135         require(desiredReward > 0);
136         require(ttl > now);
137         
138         token.transferFrom(intelProvider, address(this), depositAmount);  // transfer token from caller to Intel contract
139         
140         address[] memory contributionsList;
141         IntelState memory newIntel = IntelState(intelProvider, depositAmount, desiredReward, depositAmount, intelID, ttl, false, contributionsList);
142         intelDB[intelID] = newIntel;
143         IntelsByProvider[intelProvider].push(newIntel);
144 
145         intelIndexes.push(intelID);
146         intelCount++;
147         
148 
149         emit NewIntel(intelProvider, depositAmount, desiredReward, intelID, ttl);
150         
151     }
152     
153 
154     /// @author Pareto Admin
155     /// @notice this function sends rewards to the Intel
156     /// @dev Uses 'now' for timestamps.
157     /// @param intelIndex is the ID of the Intel to send the rewards to
158     /// @param rewardAmount is the amount of Pareto tokens the rewarder wants to reward to the Intel
159     /// @return returns true in case of successfull completion
160     /// requires 72283 gas on Rinkeby Network
161     function sendReward(uint intelIndex, uint rewardAmount) public returns(bool success){
162 
163         IntelState storage intel = intelDB[intelIndex];
164         require(intel.intelProvider != address(0x0));  // make sure that Intel exists
165         require(msg.sender != intel.intelProvider); // rewarding address should not be an intel address
166         require(intel.rewardAfter > now);       //You cannot reward intel if the timestamp of the transaction is greater than rewardAfter
167         require(!intel.rewarded);  // You cannot reward intel if the intel’s rewards have already been distributed
168         
169 
170         token.transferFrom(msg.sender, address(this), rewardAmount);  // transfer token from caller to Intel contract
171         intel.balance = intel.balance.add(rewardAmount);
172 
173         if(intel.contributions[msg.sender] == 0){
174             intel.contributionsList.push(msg.sender);
175         }
176         
177         intel.contributions[msg.sender] = intel.contributions[msg.sender].add(rewardAmount);
178         
179 
180         emit Reward(msg.sender, intelIndex, rewardAmount);
181 
182 
183         return true;
184 
185     }
186     
187 
188     /// @author Pareto Admin
189     /// @notice this function distributes rewards to the Intel provider
190     /// @dev Uses 'now' for timestamps.
191     /// @param intelIndex is the ID of the Intel to distribute tokens to
192     /// @return returns true in case of successfull completion
193     /// requires 91837 gas on Rinkeby Network
194     function distributeReward(uint intelIndex) public returns(bool success){
195 
196         require(intelIndex > 0);
197         
198 
199         IntelState storage intel = intelDB[intelIndex];
200         
201         require(!intel.rewarded);
202         require(now >= intel.rewardAfter);
203         
204 
205         intel.rewarded = true;
206         uint distributed_amount = 0;
207 
208        
209 
210 
211         if (intel.balance > intel.desiredReward){         // check if the Intel's balance is greater than the reward desired by Provider
212             distributed_amount = intel.desiredReward;    // tarnsfer tokens to the provider's address equal to the desired reward
213 
214         } else {
215             distributed_amount = intel.balance;  // transfer token to the provider's address equal to Intel's balance
216         }
217 
218         uint fee = distributed_amount.div(10);    // calculate 10% as the fee for distribution
219         distributed_amount = distributed_amount.sub(fee);   // calculate final distribution amount
220 
221         token.transfer(intel.intelProvider, distributed_amount); // send Intel tokens to providers
222         token.transfer(msg.sender, fee);                     // send Intel tokens to the caller of distribute reward function
223         emit RewardDistributed(intelIndex, distributed_amount, intel.intelProvider, msg.sender, fee);
224 
225 
226         return true;
227 
228     }
229     
230     /// @author Pareto Admin
231     /// @notice this function sets the address of Pareto Token
232     /// @dev only owner can call it
233     /// @param _token is the Pareto token address
234     /// requires 63767 gas on Rinkeby Network
235     function setParetoToken(address _token) public onlyOwner{
236 
237         token = ERC20(_token);
238         ParetoAddress = _token;
239 
240     }
241     
242 
243     /// @author Pareto Admin
244     /// @notice this function sends back the mistankenly sent non-Pareto ERC20 tokens
245     /// @dev only owner can call it
246     /// @param destination is the contract address where the tokens were received from mistakenly
247     /// @param account is the external account's address which sent the wrong tokens
248     /// @param amount is the amount of tokens sent
249     /// @param gasLimit is the amount of gas to be sent along with external contract's transfer call
250     /// requires 27431 gas on Rinkeby Network
251     function proxy(address destination, address account, uint amount, uint gasLimit) public onlyOwner{
252 
253         require(destination != ParetoAddress);    // check that the destination is not the Pareto token contract
254 
255         // make the call to transfer function of the 'destination' contract
256         // if(!address(destination).call.gas(gasLimit)(bytes4(keccak256("transfer(address,uint256)")),account, amount)){
257         //     revert();
258         // }
259 
260 
261         // ERC20(destination).transfer(account,amount);
262 
263 
264         bytes4  sig = bytes4(keccak256("transfer(address,uint256)"));
265 
266         assembly {
267             let x := mload(0x40) //Find empty storage location using "free memory pointer"
268         mstore(x,sig) //Place signature at begining of empty storage 
269         mstore(add(x,0x04),account)
270         mstore(add(x,0x24),amount)
271 
272         let success := call(      //This is the critical change (Pop the top stack value)
273                             gasLimit, //5k gas
274                             destination, //To addr
275                             0,    //No value
276                             x,    //Inputs are stored at location x
277                             0x44, //Inputs are 68 bytes long
278                             x,    //Store output over input (saves space)
279                             0x0) //Outputs are 32 bytes long
280 
281         // Check return value and jump to bad destination if zero
282 		jumpi(0x02,iszero(success))
283 
284         }
285         emit LogProxy(destination, account, amount, gasLimit);
286     }
287 
288     /// @author Pareto Admin
289     /// @notice It's a fallback function supposed to return sent Ethers by reverting the transaction
290     function() external{
291         revert();
292     }
293 
294     /// @author Pareto Admin
295     /// @notice this function provide the Intel based on its index
296     /// @dev it's a constant function which can be called
297     /// @param intelIndex is the ID of Intel that is to be returned from intelDB
298     function getIntel(uint intelIndex) public view returns(address intelProvider, uint depositAmount, uint desiredReward, uint balance, uint intelID, uint rewardAfter, bool rewarded) {
299         
300         IntelState storage intel = intelDB[intelIndex];
301         intelProvider = intel.intelProvider;
302         depositAmount = intel.depositAmount;
303         desiredReward = intel.desiredReward;
304         balance = intel.balance;
305         rewardAfter = intel.rewardAfter;
306         intelID = intel.intelID;
307         rewarded = intel.rewarded;
308 
309     }
310 
311     function getAllIntel() public view returns (uint[] intelID, address[] intelProvider, uint[] depositAmount, uint[] desiredReward, uint[] balance, uint[] rewardAfter, bool[] rewarded){
312         
313         uint length = intelIndexes.length;
314         intelID = new uint[](length);
315         intelProvider = new address[](length);
316         depositAmount = new uint[](length);
317         desiredReward = new uint[](length);
318         balance = new uint[](length);
319         rewardAfter = new uint[](length);
320         rewarded = new bool[](length);
321 
322         for(uint i = 0; i < intelIndexes.length; i++){
323             intelID[i] = intelDB[intelIndexes[i]].intelID;
324             intelProvider[i] = intelDB[intelIndexes[i]].intelProvider;
325             depositAmount[i] = intelDB[intelIndexes[i]].depositAmount;
326             desiredReward[i] = intelDB[intelIndexes[i]].desiredReward;
327             balance[i] = intelDB[intelIndexes[i]].balance;
328             rewardAfter[i] = intelDB[intelIndexes[i]].rewardAfter;
329             rewarded[i] = intelDB[intelIndexes[i]].rewarded;
330         }
331     }
332 
333 
334       function getIntelsByProvider(address _provider) public view returns (uint[] intelID, address[] intelProvider, uint[] depositAmount, uint[] desiredReward, uint[] balance, uint[] rewardAfter, bool[] rewarded){
335         
336         uint length = IntelsByProvider[_provider].length;
337 
338         intelID = new uint[](length);
339         intelProvider = new address[](length);
340         depositAmount = new uint[](length);
341         desiredReward = new uint[](length);
342         balance = new uint[](length);
343         rewardAfter = new uint[](length);
344         rewarded = new bool[](length);
345 
346         IntelState[] memory intels = IntelsByProvider[_provider];
347 
348         for(uint i = 0; i < length; i++){
349             intelID[i] = intels[i].intelID;
350             intelProvider[i] = intels[i].intelProvider;
351             depositAmount[i] = intels[i].depositAmount;
352             desiredReward[i] = intels[i].desiredReward;
353             balance[i] = intels[i].balance;
354             rewardAfter[i] = intels[i].rewardAfter;
355             rewarded[i] = intels[i].rewarded;
356         }
357     }
358 
359     function contributionsByIntel(uint intelIndex) public view returns(address[] addresses, uint[] amounts){
360         IntelState storage intel = intelDB[intelIndex];
361                 
362         uint length = intel.contributionsList.length;
363 
364         addresses = new address[](length);
365         amounts = new uint[](length);
366 
367         for(uint i = 0; i < length; i++){
368             addresses[i] = intel.contributionsList[i]; 
369             amounts[i] = intel.contributions[intel.contributionsList[i]];       
370         }
371 
372     }
373 
374 }