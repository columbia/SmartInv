1 pragma solidity ^0.4.14;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 //Interface declaration from: https://github.com/ethereum/eips/issues/20
34 contract ERC20Interface {
35     //from: https://github.com/OpenZeppelin/zeppelin-solidity/blob/b395b06b65ce35cac155c13d01ab3fc9d42c5cfb/contracts/token/ERC20Basic.sol
36     uint256 public totalSupply; //tokens that can vote, transfer, receive dividend
37     function balanceOf(address who) public constant returns (uint256);
38     function transfer(address to, uint256 value) public returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     //from: https://github.com/OpenZeppelin/zeppelin-solidity/blob/b395b06b65ce35cac155c13d01ab3fc9d42c5cfb/contracts/token/ERC20.sol
41     function allowance(address owner, address spender) public constant returns (uint256);
42     function transferFrom(address from, address to, uint256 value) public returns (bool);
43     function approve(address spender, uint256 value) public returns (bool);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract ModumToken is ERC20Interface {
48 
49     using SafeMath for uint256;
50 
51     address public owner;
52 
53     mapping(address => mapping (address => uint256)) public allowed;
54 
55     enum UpdateMode{Wei, Vote, Both} //update mode for the account
56     struct Account {
57         uint256 lastProposalStartTime; //For checking at which proposal valueModVote was last updated
58         uint256 lastAirdropWei; //For checking after which airDrop bonusWei was last updated
59         uint256 lastAirdropClaimTime; //for unclaimed airdrops, re-airdrop
60         uint256 bonusWei;      //airDrop/Dividend payout available for withdrawal.
61         uint256 valueModVote;  // votes available for voting on active Proposal
62         uint256 valueMod;      // the owned tokens
63     }
64     mapping(address => Account) public accounts;
65 
66     //Airdorp
67     uint256 public totalDropPerUnlockedToken = 0;     //totally airdropped eth per unlocked token
68     uint256 public rounding = 0;                      //airdrops not accounted yet to make system rounding error proof
69 
70     //Token locked/unlocked - totalSupply/max
71     uint256 public lockedTokens = 9 * 1100 * 1000;   //token that need to be unlocked by voting
72     uint256 public constant maxTokens = 30 * 1000 * 1000;      //max distributable tokens
73 
74     //minting phase running if false, true otherwise. Many operations can only be called when
75     //minting phase is over
76     bool public mintDone = false;
77     uint256 public constant redistributionTimeout = 548 days; //18 month
78 
79     //as suggested in https://theethereum.wiki/w/index.php/ERC20_Token_Standard
80     string public constant name = "Modum Token";
81     string public constant symbol = "MOD";
82     uint8 public constant decimals = 0;
83 
84     //Voting
85     struct Proposal {
86         string addr;        //Uri for more info
87         bytes32 hash;       //Hash of the uri content for checking
88         uint256 valueMod;      //token to unlock: proposal with 0 amount is invalid
89         uint256 startTime;
90         uint256 yay;
91         uint256 nay;
92     }
93     Proposal public currentProposal;
94     uint256 public constant votingDuration = 2 weeks;
95     uint256 public lastNegativeVoting = 0;
96     uint256 public constant blockingDuration = 90 days;
97 
98     event Voted(address _addr, bool option, uint256 votes); //called when a vote is casted
99     event Payout(uint256 weiPerToken); //called when an someone payed ETHs to this contract, that can be distributed
100 
101     function ModumToken() public {
102         owner = msg.sender;
103     }
104 
105     /**
106      * In case an owner account gets compromised, it should be possible to move control
107      * over to another account. This helps in cases like the Parity multisig exploit: As
108      * soon as an exploit becomes known, the affected parties might have a small time
109      * window before being attacked.
110      */
111     function transferOwnership(address _newOwner) public {
112         require(msg.sender == owner);
113         require(_newOwner != address(0));
114         owner = _newOwner;
115     }
116 
117     //*************************** Voting *****************************************
118     /*
119      * In addition to the the vode with address/URL and its hash, we also set the value
120      * of tokens to be transfered from the locked tokens to the modum account.
121      */
122     function votingProposal(string _addr, bytes32 _hash, uint256 _value) public {
123         require(msg.sender == owner); // proposal ony by onwer
124         require(!isProposalActive()); // no proposal is active, cannot vote in parallel
125         require(_value <= lockedTokens); //proposal cannot be larger than remaining locked tokens
126         require(_value > 0); //there needs to be locked tokens to make proposal, at least 1 locked token
127         require(_hash != bytes32(0)); //hash need to be set
128         require(bytes(_addr).length > 0); //the address need to be set and non-empty
129         require(mintDone); //minting phase needs to be over
130         //in case of negative vote, wait 90 days. If no lastNegativeVoting have
131         //occured, lastNegativeVoting is 0 and now is always larger than 14.1.1970
132         //(1.1.1970 plus blockingDuration).
133         require(now >= lastNegativeVoting.add(blockingDuration));
134 
135         currentProposal = Proposal(_addr, _hash, _value, now, 0, 0);
136     }
137 
138     function vote(bool _vote) public returns (uint256) {
139         require(isVoteOngoing()); // vote needs to be ongoing
140         Account storage account = updateAccount(msg.sender, UpdateMode.Vote);
141         uint256 votes = account.valueModVote; //available votes
142         require(votes > 0); //voter must have a vote left, either by not voting yet, or have modum tokens
143 
144         if(_vote) {
145             currentProposal.yay = currentProposal.yay.add(votes);
146         }
147         else {
148             currentProposal.nay = currentProposal.nay.add(votes);
149         }
150 
151         account.valueModVote = 0;
152         Voted(msg.sender, _vote, votes);
153         return votes;
154     }
155 
156     function showVotes(address _addr) public constant returns (uint256) {
157         Account memory account = accounts[_addr];
158         if(account.lastProposalStartTime < currentProposal.startTime || // the user did set his token power yet
159             (account.lastProposalStartTime == 0 && currentProposal.startTime == 0)) {
160             return account.valueMod;
161         }
162         return account.valueModVote;
163     }
164 
165     // The voting can be claimed by the owner of this contract
166     function claimVotingProposal() public {
167         require(msg.sender == owner); //only owner can claim proposal
168         require(isProposalActive()); // proposal active
169         require(isVotingPhaseOver()); // voting has already ended
170 
171         if(currentProposal.yay > currentProposal.nay && currentProposal.valueMod > 0) {
172             //Vote was accepted
173             Account storage account = updateAccount(owner, UpdateMode.Both);
174             uint256 valueMod = currentProposal.valueMod;
175             account.valueMod = account.valueMod.add(valueMod); //add tokens to owner
176             totalSupply = totalSupply.add(valueMod);
177             lockedTokens = lockedTokens.sub(valueMod);
178         } else if(currentProposal.yay <= currentProposal.nay) {
179             //in case of a negative vote, set the time of this negative
180             //vote to the end of the negative voting period.
181             //This will prevent any new voting to be conducted.
182             lastNegativeVoting = currentProposal.startTime.add(votingDuration);
183         }
184         delete currentProposal; //proposal ended
185     }
186 
187     function isProposalActive() public constant returns (bool)  {
188         return currentProposal.hash != bytes32(0);
189     }
190 
191     function isVoteOngoing() public constant returns (bool)  {
192         return isProposalActive()
193             && now >= currentProposal.startTime
194             && now < currentProposal.startTime.add(votingDuration);
195         //its safe to use it for longer periods:
196         //https://ethereum.stackexchange.com/questions/6795/is-block-timestamp-safe-for-longer-time-periods
197     }
198 
199     function isVotingPhaseOver() public constant returns (bool)  {
200         //its safe to use it for longer periods:
201         //https://ethereum.stackexchange.com/questions/6795/is-block-timestamp-safe-for-longer-time-periods
202         return now >= currentProposal.startTime.add(votingDuration);
203     }
204 
205     //*********************** Minting *****************************************
206     function mint(address[] _recipient, uint256[] _value) public {
207         require(msg.sender == owner); //only owner can claim proposal
208         require(!mintDone); //only during minting
209         //require(_recipient.length == _value.length); //input need to be of same size
210         //we know what we are doing... remove check to save gas
211 
212         //we want to mint a couple of accounts
213         for (uint8 i=0; i<_recipient.length; i++) {
214             
215             //require(lockedTokens.add(totalSupply).add(_value[i]) <= maxTokens);
216             //do the check in the mintDone
217 
218             //121 gas can be saved by creating temporary variables
219             address tmpRecipient = _recipient[i];
220             uint tmpValue = _value[i];
221 
222             //no need to update account, as we have not set minting to true. This means
223             //nobody can start a proposal (isVoteOngoing() is always false) and airdrop
224             //cannot be done either totalDropPerUnlockedToken is 0 thus, bonus is always
225             //zero.
226             Account storage account = accounts[tmpRecipient];
227             account.valueMod = account.valueMod.add(tmpValue);
228             //if this remains 0, we cannot calculate the time period when the user claimed
229             //his airdrop, thus, set it to now
230             account.lastAirdropClaimTime = now;
231             totalSupply = totalSupply.add(tmpValue); //create the tokens and add to recipient
232             Transfer(msg.sender, tmpRecipient, tmpValue);
233         }
234     }
235 
236     function setMintDone() public {
237         require(msg.sender == owner);
238         require(!mintDone); //only in minting phase
239         //here we check that we never exceed the 30mio max tokens. This includes
240         //the locked and the unlocked tokens.
241         require(lockedTokens.add(totalSupply) <= maxTokens);
242         mintDone = true; //end the minting
243     }
244 
245     //updates an account for voting or airdrop or both. This is required to be able to fix the amount of tokens before
246     //a vote or airdrop happend.
247     function updateAccount(address _addr, UpdateMode mode) internal returns (Account storage){
248         Account storage account = accounts[_addr];
249         if(mode == UpdateMode.Vote || mode == UpdateMode.Both) {
250             if(isVoteOngoing() && account.lastProposalStartTime < currentProposal.startTime) {// the user did set his token power yet
251                 account.valueModVote = account.valueMod;
252                 account.lastProposalStartTime = currentProposal.startTime;
253             }
254         }
255 
256         if(mode == UpdateMode.Wei || mode == UpdateMode.Both) {
257             uint256 bonus = totalDropPerUnlockedToken.sub(account.lastAirdropWei);
258             if(bonus != 0) {
259                 account.bonusWei = account.bonusWei.add(bonus.mul(account.valueMod));
260                 account.lastAirdropWei = totalDropPerUnlockedToken;
261             }
262         }
263 
264         return account;
265     }
266 
267     //*********************** Airdrop ************************************************
268     //default function to pay bonus, anybody that sends eth to this contract will distribute the wei
269     //to their token holders
270     //Dividend payment / Airdrop
271     function() public payable {
272         require(mintDone); //minting needs to be over
273         require(msg.sender == owner); //ETH payment need to be one-way only, from modum to tokenholders, confirmed by Lykke
274         payout(msg.value);
275     }
276     
277     //anybody can pay and add address that will be checked if they
278     //can be added to the bonus
279     function payBonus(address[] _addr) public payable {
280         require(msg.sender == owner);  //ETH payment need to be one-way only, from modum to tokenholders, confirmed by Lykke
281         uint256 totalWei = 0;
282         for (uint8 i=0; i<_addr.length; i++) {
283             Account storage account = updateAccount(_addr[i], UpdateMode.Wei);
284             if(now >= account.lastAirdropClaimTime + redistributionTimeout) {
285                 totalWei += account.bonusWei;
286                 account.bonusWei = 0;
287                 account.lastAirdropClaimTime = now;
288             } else {
289                 revert();
290             }
291         }
292         payout(msg.value.add(totalWei));
293     }
294     
295     function payout(uint256 valueWei) internal {
296         uint256 value = valueWei.add(rounding); //add old rounding
297         rounding = value % totalSupply; //ensure no rounding error
298         uint256 weiPerToken = value.sub(rounding).div(totalSupply);
299         totalDropPerUnlockedToken = totalDropPerUnlockedToken.add(weiPerToken); //account for locked tokens and add the drop
300         Payout(weiPerToken);
301     }
302 
303     function showBonus(address _addr) public constant returns (uint256) {
304         uint256 bonus = totalDropPerUnlockedToken.sub(accounts[_addr].lastAirdropWei);
305         if(bonus != 0) {
306             return accounts[_addr].bonusWei.add(bonus.mul(accounts[_addr].valueMod));
307         }
308         return accounts[_addr].bonusWei;
309     }
310 
311     function claimBonus() public returns (uint256) {
312         require(mintDone); //minting needs to be over
313 
314         Account storage account = updateAccount(msg.sender, UpdateMode.Wei);
315         uint256 sendValue = account.bonusWei; //fetch the values
316 
317         if(sendValue != 0) {
318             account.bonusWei = 0; //set to zero (before, against reentry)
319             account.lastAirdropClaimTime = now; //mark as collected now
320             msg.sender.transfer(sendValue); //send the bonus to the correct account
321             return sendValue;
322         }
323         return 0;
324     }
325 
326     //****************************** ERC20 ************************************
327 
328     // Get the account balance of another account with address _owner
329     function balanceOf(address _owner) public constant returns (uint256 balance) {
330         return accounts[_owner].valueMod;
331     }
332 
333     // Send _value amount of tokens to address _to
334     function transfer(address _to, uint256 _value) public returns (bool success) {
335         require(mintDone);
336         require(_value > 0);
337         Account memory tmpFrom = accounts[msg.sender];
338         require(tmpFrom.valueMod >= _value);
339 
340         Account storage from = updateAccount(msg.sender, UpdateMode.Both);
341         Account storage to = updateAccount(_to, UpdateMode.Both);
342         from.valueMod = from.valueMod.sub(_value);
343         to.valueMod = to.valueMod.add(_value);
344         Transfer(msg.sender, _to, _value);
345         return true;
346     }
347 
348     // Send _value amount of tokens from address _from to address _to
349     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
350         require(mintDone);
351         require(_value > 0);
352         Account memory tmpFrom = accounts[_from];
353         require(tmpFrom.valueMod >= _value);
354         require(allowed[_from][msg.sender] >= _value);
355 
356         Account storage from = updateAccount(_from, UpdateMode.Both);
357         Account storage to = updateAccount(_to, UpdateMode.Both);
358         from.valueMod = from.valueMod.sub(_value);
359         to.valueMod = to.valueMod.add(_value);
360         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
361         Transfer(msg.sender, _to, _value);
362         return true;
363     }
364 
365     // ********************** approve, allowance, increaseApproval, and decreaseApproval used from:
366     // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/StandardToken.sol
367     //
368     // changed from uint to uint256 as this is considered to be best practice.
369 
370     /**
371      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
372      * @param _spender The address which will spend the funds.
373      * @param _value The amount of tokens to be spent.
374      */
375     function approve(address _spender, uint256 _value) public returns (bool) {
376         // To change the approve amount you first have to reduce the addresses`
377         //  allowance to zero by calling `approve(_spender, 0)` if it is not
378         //  already 0 to mitigate the race condition described here:
379         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
380         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
381 
382         allowed[msg.sender][_spender] = _value;
383         Approval(msg.sender, _spender, _value);
384         return true;
385     }
386 
387     /**
388      * @dev Function to check the amount of tokens that an owner allowed to a spender.
389      * @param _owner address The address which owns the funds.
390      * @param _spender address The address which will spend the funds.
391      * @return A uint256 specifying the amount of tokens still available for the spender.
392      */
393     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
394         return allowed[_owner][_spender];
395     }
396 
397     /*
398      * approve should be called when allowed[_spender] == 0. To increment
399      * allowed value is better to use this function to avoid 2 calls (and wait until
400      * the first transaction is mined)
401      * From MonolithDAO Token.sol
402      */
403     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
404         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
405         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
406         return true;
407     }
408 
409     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
410         uint256 oldValue = allowed[msg.sender][_spender];
411         if(_subtractedValue > oldValue) {
412             allowed[msg.sender][_spender] = 0;
413         } else {
414             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
415         }
416         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
417         return true;
418     }
419 }