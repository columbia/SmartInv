1 pragma solidity ^0.4.8;
2 
3 //This contract is backed by the constitution of superDAO deployed at : .
4 //The constitution of the superDAO is the social contract, terms, founding principles and definitions of the vision,
5 //mission, anti-missions, rules and operation guidelines of superDAO.
6 //The total number of 3,000,000 represents 3% of 100,000,000 immutable number of superDAO tokens,
7 //which is the alloted budget of operation for the earliest funding activities.
8 //Every prommissory token is exchangeable for the real superDAO tokens on a one on one basis.
9 //Promissiory contract will be deployed with the actual superDAO token contract.
10 //Early backers can call the "redeem" function on the actual token contract to exchange promissory tokens for the final tokens.
11 
12 /**
13  * @title Promisory Token Contract
14  * @author ola
15  * --- Collaborators ---
16  * @author zlatinov
17  * @author panos
18  * @author yemi
19  * @author archil
20  * @author anthony
21  */
22 contract PromissoryToken {
23 
24     event FounderSwitchRequestEvent(address _newFounderAddr);
25     event FounderSwitchedEvent(address _newFounderAddr);
26     event CofounderSwitchedEvent(address _newCofounderAddr);
27 
28     event AddedPrepaidTokensEvent(address backer, uint index, uint price, uint amount);
29     event PrepaidTokensClaimedEvent(address backer, uint index, uint price, uint amount);
30     event TokensClaimedEvent(address backer, uint index, uint price, uint amount);
31 
32     event RedeemEvent(address backer, uint amount);
33 
34     event WithdrawalCreatedEvent(uint withdrawalId, uint amount, bytes reason);
35     event WithdrawalVotedEvent(uint withdrawalId, address backer, uint backerStakeWeigth, uint totalStakeWeight);
36     event WithdrawalApproved(uint withdrawalId, uint stakeWeight, bool isMultiPayment, uint amount, bytes reason);
37 
38     address founder; //deployer of constitution and PromissoryToken
39     bytes32 founderHash; // hash must be confirmed in order to replace founder address
40     mapping(address => bytes32) tempHashes; // structure to contain new address to hash storage,
41     address cofounder;//helper to aid founder key exchange in case of key loss
42     address [] public previousFounders; //list of addresses replaced using the switching process.
43     uint constant discountAmount = 60; //discount amount
44     uint constant divisor = 100; //divisor to get discount value
45 
46     uint public constant minimumPrepaidClaimedPercent = 65;
47     uint public promissoryUnits = 3000000; //amount of tokens contants set
48     uint public prepaidUnits = 0; //prepaid and set by founder out of 3 million tokens
49     uint public claimedUnits = 0; //claimed tokens out of 3 million tokens
50     uint public claimedPrepaidUnits = 0; //claimed tokens out of the early backer's tokens/prepaidUnits
51     uint public redeemedTokens = 0; //number of tokens out of claimed tokens, redeemed by superDAO token call
52     uint public lastPrice = 0; //latest price of token acquired by backer in Wei
53     uint public numOfBackers; //number of early backers
54 
55     struct backerData {
56        uint tokenPrice;
57        uint tokenAmount;
58        bytes32 privateHash;
59        bool prepaid;
60        bool claimed;
61        uint backerRank;
62     }
63 
64     address[] public earlyBackerList; //addresses of earliest backers
65     address[] public backersAddresses; //addresses of all backers
66     mapping(address => backerData[]) public backers;// backer address to backer info mapping
67     mapping(address => bool) public backersRedeemed;
68 
69     struct withdrawalData {
70        uint Amount;
71        bool approved;
72        bool spent;
73        bytes reason;
74        address[] backerApprovals;
75        uint totalStake;
76        address[] destination;
77     }
78 
79     withdrawalData[] public withdrawals; // Data structure specifying withdrawal
80     mapping(address => mapping(uint => bool)) public withdrawalsVotes;
81 
82     /**
83     * @notice Deploy PromissoryToken contract with `msg.sender.address()` as founder with `_prepaidBackers.number()` prepaid backers
84     * @dev This is the constructor of the promisory token contract
85     * @param _founderHash Founders password hash, preferable a message digest to further obfuscate duplicaion
86     * @param _cofounderAddress The helper cofounder to aid founder key exchange in case of key loss/
87     * @param _numOfBackers The number of Early backers. Will be used to control setting early backers
88     */
89     function PromissoryToken( bytes32 _founderHash, address _cofounderAddress, uint _numOfBackers){
90         founder = msg.sender;
91         founderHash = sha3(_founderHash);
92         cofounder = _cofounderAddress;
93         numOfBackers = _numOfBackers;
94     }
95 
96     /**
97     * @notice `msg.sender.address()` updating cofounder address to `_newFounderAddr.address()`
98     * @dev allows cofounder to switch out addres for a new one.Can be repeated as many times as needed
99     * @param _newCofounderAddr New Address of Cofounder
100     * @return True if the coFounder address successfully updated
101     */
102     function cofounderSwitchAddress(address _newCofounderAddr) external returns (bool success){
103         if (msg.sender != cofounder) throw;
104 
105         cofounder = _newCofounderAddr;
106         CofounderSwitchedEvent(_newCofounderAddr);
107 
108         return true;
109     }
110 
111     /**
112     * @notice Founder address update to `_newFounderAddr.address()` is being requested
113     * @dev founderSwitchAddress founder indicates intent to switch addresses with new address,
114     * hash of pass phrase and a "onetime shared phrase shared with coufounder"
115     * @param _founderHash Secret Key to be used to confirm Address update
116     * @param _oneTimesharedPhrase Shared pre-hashed Secret key for offline trust to be shared with coFounder to approve Address update
117     * @return True if Address switch request successfully created and Temporary hash Values set
118     */
119     function founderSwitchRequest(bytes32 _founderHash, bytes32 _oneTimesharedPhrase) returns (bool success){
120         if(sha3(_founderHash) != founderHash) throw;
121 
122         tempHashes[msg.sender] = sha3(msg.sender, founderHash, _oneTimesharedPhrase);
123         FounderSwitchRequestEvent(msg.sender);
124 
125         return true;
126     }
127 
128    /**
129     * @notice `msg.sender.address()` approving `_newFounderAddr.address()` as new founder address
130     * @dev CofounderSwitchAddress which allows previously set cofounder to approve address
131     * switch by founder. Must have a one time shared phrase thats is shared with founder that corresponding with a
132     * hashed value.
133     * @param _newFounderAddr The address of Founder to be newly set
134     * @param _oneTimesharedPhrase Shared pre-hashed Secret key for offline trust, to provide access to the approval function
135     * @return True if new Founder address successfully approved
136     */
137     function cofounderApproveSwitchRequest(address _newFounderAddr, bytes32 _oneTimesharedPhrase) external returns (bool success){
138         if(msg.sender != cofounder || sha3(_newFounderAddr, founderHash, _oneTimesharedPhrase) != tempHashes[_newFounderAddr]) throw;
139 
140         previousFounders.push(founder);
141         founder = _newFounderAddr;
142         FounderSwitchedEvent(_newFounderAddr);
143 
144         return true;
145     }
146 
147     /**
148     * @notice Adding `_backer.address()` as an early backer
149     * @dev Add Early backers to Contract setting the transacton details
150     * @param _backer The address of the superDAO backer
151     * @param _tokenPrice The price/rate at which the superDAO tokens were bought
152     * @param _tokenAmount The total number of superDAO token purcgased at the indicated rate
153     * @param _privatePhrase Shared pre-hashed Secret key for offline price negotiation to online attestation of SuperDAO tokens ownership
154     * @param _backerRank Rank of the backer in the backers list
155     * @return Thre index of _backer  in the backers list
156     */
157     function setPrepaid(address _backer, uint _tokenPrice, uint _tokenAmount, string _privatePhrase, uint _backerRank)
158         external
159         founderCall
160         returns (uint)
161     {
162         if (_tokenPrice == 0 || _tokenAmount == 0 || claimedPrepaidUnits>0 ||
163             _tokenAmount + prepaidUnits + claimedUnits > promissoryUnits) throw;
164         if (earlyBackerList.length == numOfBackers && backers[_backer].length == 0) throw ;
165         if (backers[_backer].length == 0) {
166             earlyBackerList.push(_backer);
167             backersAddresses.push(_backer);
168         }
169         backers[_backer].push(backerData(_tokenPrice, _tokenAmount, sha3(_privatePhrase, _backer), true, false, _backerRank));
170 
171         prepaidUnits +=_tokenAmount;
172         lastPrice = _tokenPrice;
173 
174         AddedPrepaidTokensEvent(_backer, backers[_backer].length - 1, _tokenPrice, _tokenAmount);
175 
176         return backers[_backer].length - 1;
177     }
178 
179     /**
180     * @notice Claiming `_tokenAmount.number()` superDAO tokens by `msg.sender.address()`
181     * @dev Claim superDAO Early backer tokens
182     * @param _index index of tokens to claim
183     * @param _boughtTokensPrice Price at which the superDAO tokens were bought
184     * @param _tokenAmount Number of superDAO tokens to be claimed
185     * @param _privatePhrase Shared pre-hashed Secret key for offline price negotiation to online attestation of SuperDAO tokens ownership
186     * @param _backerRank Backer rank of the backer in the superDAO
187     */
188     function claimPrepaid(uint _index, uint _boughtTokensPrice, uint _tokenAmount, string _privatePhrase, uint _backerRank)
189         external
190         EarliestBackersSet
191     {
192         if(backers[msg.sender][_index].prepaid == true &&
193            backers[msg.sender][_index].claimed == false &&
194            backers[msg.sender][_index].tokenAmount == _tokenAmount &&
195            backers[msg.sender][_index].tokenPrice == _boughtTokensPrice &&
196            backers[msg.sender][_index].privateHash == sha3( _privatePhrase, msg.sender) &&
197            backers[msg.sender][_index].backerRank == _backerRank)
198         {
199             backers[msg.sender][_index].claimed = true;
200             claimedPrepaidUnits += _tokenAmount;
201 
202             PrepaidTokensClaimedEvent(msg.sender, _index, _boughtTokensPrice, _tokenAmount);
203         } else {
204             throw;
205         }
206     }
207 
208     /**
209     * @notice `msg.sender.address()` is Purchasing `(msg.value / lastPrice).toFixed(0)` superDAO Tokens at `lastPrice`
210     * @dev Purchase new superDAO Tokens if the amount of tokens are still available for purchase
211     */
212     function claim()
213         payable
214         external
215         MinimumBackersClaimed
216    {
217         if (lastPrice == 0) throw;
218 
219         //don`t accept transactions with zero value
220         if (msg.value == 0) throw;
221 
222 
223         //Effective discount for Pre-crowdfunding backers of 40% Leaving effective rate of 60%
224         uint discountPrice = lastPrice * discountAmount / divisor;
225 
226         uint tokenAmount = (msg.value / discountPrice);//Effect the discount rate 0f 40%
227 
228         if (tokenAmount + claimedUnits + prepaidUnits > promissoryUnits) throw;
229 
230         if (backers[msg.sender].length == 0) {
231             backersAddresses.push(msg.sender);
232         }
233         backers[msg.sender].push(backerData(discountPrice, tokenAmount, sha3(msg.sender), false, true, 0));
234 
235         claimedUnits += tokenAmount;
236 
237         TokensClaimedEvent(msg.sender, backers[msg.sender].length - 1, discountPrice, tokenAmount);
238     }
239 
240     /**
241      * @notice checking `_backerAddress.address()` superDAO Token balance: `index`
242      * @dev Check Token balance by index of backer, return values can be used to instantiate a backerData struct
243      * @param _backerAddress The Backer's address
244      * @param index The balance to check
245      * @return tokenPrice The Price at which the tokens were bought
246      * @return tokenAmount The number of tokens that were bought
247      * @return Shared pre-hashed Secret key for offline price negotiation 
248      * @return prepaid True if backer is an early backer
249      * @return claimed True if the Token has already been claimed by the backer
250      */
251     function checkBalance(address _backerAddress, uint index) constant returns (uint, uint, bytes32, bool, bool){
252         return (
253             backers[_backerAddress][index].tokenPrice,
254             backers[_backerAddress][index].tokenAmount,
255             backers[_backerAddress][index].privateHash,
256             backers[_backerAddress][index].prepaid,
257             backers[_backerAddress][index].claimed
258             );
259     }
260 
261     /**
262     * @notice Approving withdrawal `_withdrawalID`
263     * @dev Approve a withdrawal from the superDAO and mark the withdrawal as spent
264     * @param _withdrawalID The ID of the withdrawal
265     */
266     function approveWithdraw(uint _withdrawalID)
267         external
268         backerCheck(_withdrawalID)
269     {
270         withdrawalsVotes[msg.sender][_withdrawalID] = true;
271 
272         uint backerStake = 0;
273         for (uint i = 0; i < backers[msg.sender].length; i++) {
274             backerStake += backers[msg.sender][i].tokenAmount;
275         }
276         withdrawals[_withdrawalID].backerApprovals.push(msg.sender);
277         withdrawals[_withdrawalID].totalStake += backerStake;
278 
279         WithdrawalVotedEvent(_withdrawalID, msg.sender, backerStake, withdrawals[_withdrawalID].totalStake);
280 
281         if(withdrawals[_withdrawalID].totalStake >= (claimedPrepaidUnits + claimedUnits) / 3) {
282             uint amountPerAddr;
283             bool isMultiPayment = withdrawals[_withdrawalID].destination.length > 1;
284 
285             if(isMultiPayment == false){
286                 amountPerAddr = withdrawals[_withdrawalID].Amount;
287             }
288             else {
289                 amountPerAddr = withdrawals[_withdrawalID].Amount / withdrawals[_withdrawalID].destination.length;
290             }
291 
292             withdrawals[_withdrawalID].approved = true;
293             withdrawals[_withdrawalID].spent = true;
294 
295             for(i = 0; i < withdrawals[_withdrawalID].destination.length; i++){
296                 if(!withdrawals[_withdrawalID].destination[i].send(amountPerAddr)) throw;
297             }
298 
299             WithdrawalApproved(_withdrawalID,
300                 withdrawals[_withdrawalID].totalStake,
301                 isMultiPayment,
302                 withdrawals[_withdrawalID].Amount,
303                 withdrawals[_withdrawalID].reason);
304         }
305     }
306 
307     /**
308     * @notice Requestng withdrawal of `_totalAmount` to `_destination.address()`
309     * @dev Create a new withdrawal request
310     * @param _totalAmount The total amount of tokens to be withdrawan, should be equal to the total number of owned tokens
311     * @param _reason Reason/Description for the withdrawal
312     * @param _destination The receiving address
313     */
314     function withdraw(uint _totalAmount, bytes _reason, address[] _destination)
315         external
316         founderCall
317     {
318         if (this.balance < _totalAmount) throw;
319 
320         uint withdrawalID = withdrawals.length++;
321 
322         withdrawals[withdrawalID].Amount = _totalAmount;
323         withdrawals[withdrawalID].reason = _reason;
324         withdrawals[withdrawalID].destination = _destination;
325         withdrawals[withdrawalID].approved = false;
326         withdrawals[withdrawalID].spent = false;
327 
328         WithdrawalCreatedEvent(withdrawalID, _totalAmount, _reason);
329     }
330 
331     /**
332     * @notice Backer `_bacherAddr.address()` is redeeming `_amount` superDAO Tokens
333     * @dev Check if backer tokens have been claimed but not redeemed, then redeem them
334     * @param _amount The total number of redeemable tokens
335     * @param _backerAddr The address of the backer
336     * @return True if tokens were successfully redeemed else false
337     */
338     function redeem(uint _amount, address _backerAddr) returns(bool){
339         if (backersRedeemed[_backerAddr] == true) {
340             return false;
341         }
342 
343         uint totalTokens = 0;
344 
345         for (uint i = 0; i < backers[_backerAddr].length; i++) {
346             if (backers[_backerAddr][i].claimed == false) {
347                 return false;
348             }
349             totalTokens += backers[_backerAddr][i].tokenAmount;
350         }
351 
352         if (totalTokens == _amount){
353             backersRedeemed[_backerAddr] = true;
354 
355             RedeemEvent(_backerAddr, totalTokens);
356 
357             return true;
358         }
359         else {
360             return false;
361         }
362     }
363 
364     /**
365     * @notice check withdrawal status of `_withdrawalID`
366     * @dev Get the withdrawal of a withdrawal. Return values can be used to instantiate a withdrawalData struct
367     * @param _withdrawalID The ID of the withdrawal
368     * @return Amount The Amount requested in the withdrawal
369     * @return approved True if the withdrawal has been approved
370     * @return reason Reason/Description of the Withdrawal
371     * @return backerApprovals Addresses of backers who approved the withdrawal
372     * @return totalStake Total number of tokens which backed the withdrawal(Total number of tokens owned by backers who approved the withdrawal)
373     * @return destination Receiving address of the withdrawal
374     */
375     function getWithdrawalData(uint _withdrawalID) constant public returns (uint, bool, bytes, address[], uint, address[]){
376         return (
377             withdrawals[_withdrawalID].Amount,
378             withdrawals[_withdrawalID].approved,
379             withdrawals[_withdrawalID].reason,
380             withdrawals[_withdrawalID].backerApprovals,
381             withdrawals[_withdrawalID].totalStake,
382             withdrawals[_withdrawalID].destination);
383     }
384 
385     modifier founderCall{
386         if (msg.sender != founder) throw;
387         _;
388     }
389 
390     modifier backerCheck(uint _withdrawalID){
391         if(backers[msg.sender].length == 0 || withdrawals[_withdrawalID].spent == true || withdrawalsVotes[msg.sender][_withdrawalID] == true) throw;
392         _;
393     }
394 
395     modifier EarliestBackersSet{
396        if(earlyBackerList.length < numOfBackers) throw;
397        _;
398     }
399 
400     modifier MinimumBackersClaimed(){
401       if(prepaidUnits == 0 ||
402         claimedPrepaidUnits == 0 ||
403         (claimedPrepaidUnits * divisor / prepaidUnits) < minimumPrepaidClaimedPercent) {
404             throw;
405         }
406       _;
407     }
408 
409     /*
410      * Safeguard function.
411      * This function gets executed if a transaction with invalid data is sent to
412      * the contract or just ether without data.
413      */
414     function () {
415         throw;
416     }
417 
418 }