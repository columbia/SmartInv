1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 // END OF library SafeMath
32 
33 contract Roles {
34     // Master Key access, always ONE and ONE ONLY 
35     address public superAdmin ;
36 
37     address public canary ; 
38 
39 
40     // initiators and validators can be many
41     mapping (address => bool) public initiators ; 
42     mapping (address => bool) public validators ;  
43     address[] validatorsAcct ; 
44 
45     // keep track of the current qty. of initiators around 
46     uint public qtyInitiators ; 
47 
48     // hard-code the max amount of validators/voters in the system 
49     // this is required to initialize the storage for each new proposal 
50     uint constant public maxValidators = 20 ; 
51 
52     // keep track of the current qty. of active validators around 
53     uint public qtyValidators ; 
54 
55     event superAdminOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56     event initiatorAdded(address indexed newInitiator);
57     event validatorAdded(address indexed newValidator);
58     event initiatorRemoved(address indexed removedInitiator);
59     event validatorRemoved(address indexed addedValidator);
60     event canaryOwnershipTransferred(address indexed previousOwner, address indexed newOwner) ; 
61 
62 
63     
64     constructor() public 
65     { 
66       superAdmin = msg.sender ;
67       
68     }
69 
70     modifier onlySuperAdmin {
71         require( msg.sender == superAdmin );
72         _;
73     }
74 
75     modifier onlyCanary {
76         require( msg.sender == canary );
77         _;
78     }
79 
80     modifier onlyInitiators {
81         require( initiators[msg.sender] );
82         _;
83     }
84     
85     modifier onlyValidators {
86         require( validators[msg.sender] );
87         _;
88     }
89     
90 
91 function transferSuperAdminOwnership(address newOwner) public onlySuperAdmin 
92 {
93   require(newOwner != address(0)) ;
94   superAdmin = newOwner ;
95   emit superAdminOwnershipTransferred(superAdmin, newOwner) ;  
96 }
97 
98 function transferCanaryOwnership(address newOwner) public onlySuperAdmin 
99 {
100   require(newOwner != address(0)) ;
101   canary = newOwner ;
102   emit canaryOwnershipTransferred(canary, newOwner) ;  
103 }
104 
105 
106 function addValidator(address _validatorAddr) public onlySuperAdmin 
107 {
108   require(_validatorAddr != address(0));
109   require(!validators[_validatorAddr]) ; 
110   validators[_validatorAddr] = true ; 
111   validatorsAcct.push(_validatorAddr) ; 
112   qtyValidators++ ; 
113   emit validatorAdded(_validatorAddr) ;  
114 }
115 
116 function revokeValidator(address _validatorAddr) public onlySuperAdmin
117 {
118   require(_validatorAddr != address(0));
119   require(validators[_validatorAddr]) ; 
120   validators[_validatorAddr] = false ; 
121   
122   for(uint i = 0 ; i < qtyValidators ; i++ ) 
123     {
124       if (validatorsAcct[i] == _validatorAddr)
125          validatorsAcct[i] = address(0) ; 
126     }
127   qtyValidators-- ; 
128   emit validatorRemoved(_validatorAddr) ;  
129 }
130 
131 function addInitiator(address _initiatorAddr) public onlySuperAdmin
132 {
133   require(_initiatorAddr != address(0));
134   require(!initiators[_initiatorAddr]) ;
135   initiators[_initiatorAddr] = true ; 
136   qtyInitiators++ ; 
137   emit initiatorAdded(_initiatorAddr) ; 
138 }
139 
140 function revokeInitiator(address _initiatorAddr) public onlySuperAdmin
141 {
142   require(_initiatorAddr != address(0));
143   require(initiators[_initiatorAddr]) ; 
144   initiators[_initiatorAddr] = false ;
145   qtyInitiators-- ; 
146   emit initiatorRemoved(_initiatorAddr) ; 
147 }
148   
149 
150 } // END OF Roles contract 
151 
152 
153 contract Storage {
154 
155   // We store here the whole storage implementation, decoupling the logic 
156   // which will be defined in FKXIdentitiesV1, FKXIdentitiesV2..., FKXIdentitiesV1n
157 
158 uint scoringThreshold ; 
159 
160 struct Proposal 
161   {
162     string ipfsAddress ; 
163     uint timestamp ; 
164     uint totalAffirmativeVotes ; 
165     uint totalNegativeVotes ; 
166     uint totalVoters ; 
167     address[] votersAcct ; 
168     mapping (address => uint) votes ; 
169   }
170 
171 // storage to keep track of all the proposals 
172 mapping (bytes32 => Proposal) public proposals ; 
173 uint256 totalProposals ; 
174 
175 // helper array to keep track of all rootHashes proposals
176 bytes32[] rootHashesProposals ; 
177 
178 
179 // storage records the final && immutable ipfsAddresses validated by majority consensus of validators
180 mapping (bytes32 => string) public ipfsAddresses ; 
181 
182 // Helper vector to track all keys (rootHasshes) added to ipfsAddresses
183 bytes32[] ipfsAddressesAcct ;
184 
185 }
186 
187 
188 contract Registry is Storage, Roles {
189 
190     address public logic_contract;
191 
192     function setLogicContract(address _c) public onlySuperAdmin returns (bool success){
193         logic_contract = _c;
194         return true;
195     }
196 
197     function () payable public {
198         address target = logic_contract;
199         assembly {
200             let ptr := mload(0x40)
201             calldatacopy(ptr, 0, calldatasize)
202             let result := delegatecall(gas, target, ptr, calldatasize, 0, 0)
203             let size := returndatasize
204             returndatacopy(ptr, 0, size)
205             switch result
206             case 0 { revert(ptr, size) }
207             case 1 { return(ptr, size) }
208         }
209     }
210 }
211 
212 
213 contract FKXIdentitiesV1 is Storage, Roles {
214 
215 using SafeMath for uint256;
216 
217 event newProposalLogged(address indexed initiator, bytes32 rootHash, string ipfsAddress ) ; 
218 event newVoteLogged(address indexed voter, bool vote) ;
219 event newIpfsAddressAdded(bytes32 rootHash, string ipfsAddress ) ; 
220 
221 
222 constructor() public 
223 {
224   qtyInitiators = 0 ; 
225   qtyValidators = 0 ; 
226   scoringThreshold = 10 ;
227 }
228 
229 // Set the score parameter that once reached would eliminate/revoke
230 // validators with scores greater than _scoreMax from the list of authorized validators
231 function setScoringThreshold(uint _scoreMax) public onlySuperAdmin
232 {
233   scoringThreshold = _scoreMax ; 
234 }
235 
236 
237 // An initiator writes a new proposal in the proposal storage area 
238 
239 function propose(bytes32 _rootHash, string _ipfsAddress) public onlyInitiators
240 {
241   // proposal should not be present already, i.e timestamp has to be in an uninitialized state, i.e. zero 
242   require(proposals[_rootHash].timestamp == 0 ) ;
243 
244   // writes the proposal for the _ipfsAddress, timestamp it 'now' and set the qty to zero (i.e. no votes yet)
245   address[] memory newVoterAcct = new address[](maxValidators) ; 
246   Proposal memory newProposal = Proposal( _ipfsAddress , now, 0, 0, 0, newVoterAcct ) ; 
247   proposals[_rootHash] = newProposal ; 
248   emit newProposalLogged(msg.sender, _rootHash, _ipfsAddress ) ; 
249   rootHashesProposals.push(_rootHash) ; 
250   totalProposals++ ; 
251 }
252 
253 
254 // obtain, for a given rootHash, the definitive immutable stored _ipfsAddress 
255 function getIpfsAddress(bytes32 _rootHash) constant public returns (string _ipfsAddress)
256 {
257   return ipfsAddresses[_rootHash] ; 
258 }
259 
260 // obtain, for a given rootHash, the proposed (not definitively voted yet) _ipfsAddress
261 function getProposedIpfs(bytes32 _rootHash) constant public returns (string _ipfsAddress)
262 {
263   return proposals[_rootHash].ipfsAddress ; 
264 }
265 
266 // how many voters have voted for a given proposal? 
267 function howManyVoters(bytes32 _rootHash) constant public returns (uint)
268 {
269   return proposals[_rootHash].totalVoters ; 
270 }
271 
272 // Validator casts one vote to the proposed ipfsAddress stored in the _rootHash key in the proposals storage area 
273 // if _vote == true means voting affirmatively, else if _vote == false, means voting negatively
274 function vote(bytes32 _rootHash, bool _vote) public onlyValidators
275 {
276   // if timestamp == 0 it means such proposal does not exist, i.e. was never timestamped hence 
277   //  contains the 'zero' uninitialized value
278   require(proposals[_rootHash].timestamp > 0) ;
279 
280   // checks this validator have not already voted for this proposal
281   // 0 no voted yet
282   // 1 voted affirmatively
283   // 2 voted negatively 
284 
285   require(proposals[_rootHash].votes[msg.sender]==0) ; 
286 
287   // add this validator address to the array of voters. 
288   proposals[_rootHash].votersAcct.push(msg.sender) ; 
289 
290   if (_vote ) 
291     { 
292       proposals[_rootHash].votes[msg.sender] = 1 ; // 1 means votes affirmatively
293       proposals[_rootHash].totalAffirmativeVotes++ ; 
294     } 
295        else 
296         { proposals[_rootHash].votes[msg.sender] = 2 ; // 2 means votes negatively
297           proposals[_rootHash].totalNegativeVotes++ ; 
298         } 
299 
300   emit newVoteLogged(msg.sender, _vote) ;
301   proposals[_rootHash].totalVoters++ ; 
302 
303   // check if a majority consensus was obtained and if so, it records the final result in the definitive 
304   // immutable storage area: ipfsAddresses 
305   if ( isConsensusObtained(proposals[_rootHash].totalAffirmativeVotes) )
306   {
307   // need to make sure the consensuated vote had not already been written to the storage area ipfsAddresses
308   // so we don't write duplicate info again, just to save some gas :) and also b/c it's the right thing to do 
309   // to minimize entropy in the universe... hence, we need to check for an empty string
310     bytes memory tempEmptyString = bytes(ipfsAddresses[_rootHash]) ; 
311     if ( tempEmptyString.length == 0 ) 
312       { 
313         ipfsAddresses[_rootHash] = proposals[_rootHash].ipfsAddress ;  
314         emit newIpfsAddressAdded(_rootHash, ipfsAddresses[_rootHash] ) ;
315         ipfsAddressesAcct.push(_rootHash) ; 
316 
317       } 
318 
319   }
320 
321 } 
322 
323 
324 // returns the total number of ipfsAddresses ever stored in the definitive immutable storage 'ipfsAddresses'
325 function getTotalQtyIpfsAddresses() constant public returns (uint)
326 { 
327   return ipfsAddressesAcct.length ; 
328 }
329 
330 // returns one rootHash which is stored at a specific _index position
331 function getOneByOneRootHash(uint _index) constant public returns (bytes32 _rootHash )
332 {
333   require( _index <= (getTotalQtyIpfsAddresses()-1) ) ; 
334   return ipfsAddressesAcct[_index] ; 
335 }
336 
337 // consensus obtained it is true if and only if n+1 validators voted affirmatively for a proposal 
338 // where n == the total qty. of validators (qtyValidators)
339 function isConsensusObtained(uint _totalAffirmativeVotes) constant public returns (bool)
340 {
341  // multiplying by 10000 (10 thousand) for decimal precision management
342  // note: This scales up to 9999 validators only
343 
344  require (qtyValidators > 0) ; // prevents division by zero 
345  uint dTotalVotes = _totalAffirmativeVotes * 10000 ; 
346  return (dTotalVotes / qtyValidators > 5000 ) ;
347 
348 }
349 
350 
351 // Validators:
352 // returns one proposal (the first one) greater than, STRICTLY GREATER THAN the given _timestampFrom 
353 // timestamp > _timestampFrom 
354 function getProposals(uint _timestampFrom) constant public returns (bytes32 _rootHash)
355 {
356    // returns the first rootHash corresponding to a timestamp greater than the parameter 
357    uint max = rootHashesProposals.length ; 
358 
359    for(uint i = 0 ; i < max ; i++ ) 
360     {
361       if (proposals[rootHashesProposals[i]].timestamp > _timestampFrom)
362          return rootHashesProposals[i] ; 
363     }
364 
365 }
366 
367 // returns, for one proposal 
368 // identified by a rootHash, the timestamp UNIX epoch time associated with it
369 
370 function getTimestampProposal(bytes32 _rootHash) constant public returns (uint _timeStamp) 
371 {
372   return proposals[_rootHash].timestamp ; 
373 }
374 
375 
376 
377 // returns the total quantity of active validators
378 // only 'active' ones quantity  
379 function getQtyValidators() constant public returns (uint)
380 {
381   return qtyValidators ; 
382 }
383 
384 // It returns the address of an active validator in the specific '_t' vector position of active validators 
385 // vector positions start at zero and ends at 'getQtyValidators - 1' so in order to get all vaidators 
386 // you have to iterate one by one from 0 to ' getQtyValidators -1 '
387 function getValidatorAddress(int _t) constant public returns (address _validatorAddr)
388 {
389    int x = -1 ; 
390    uint size = validatorsAcct.length ; 
391 
392    for ( uint i = 0 ; i < size ; i++ )
393    {
394 
395       if ( validators[validatorsAcct[i]] ) x++ ; 
396       if ( x == _t ) return (validatorsAcct[i]) ;  
397    }
398 }
399  
400 // returns true if the rootHash was impacted, i.e. it's available and exists in the ipfsAddresses array
401 // and false if otherwise
402 
403 function getStatusForRootHash(bytes32 _rootHash) constant public returns (bool)
404 {
405  bytes memory tempEmptyStringTest = bytes(ipfsAddresses[_rootHash]); // Uses memory
406  if (tempEmptyStringTest.length == 0) {
407     // emptyStringTest is an empty string, hence the _rootHash was not impacted there so does not exist
408     return false ; 
409 } else {
410     // emptyStringTest is not an empty string
411     return true ; 
412 }
413 
414 } 
415 
416 } // END OF FKXIdentities contract 
417 
418 
419 // DEBUG info below IGNORE 
420 // rootHash examples below, always 32 bytes in the format:
421 // 0x12207D5A99F603F231D53A4F39D1521F98D2E8BB279CF29BEBFD0687DC98458E
422 // 0x12207D5A99F603F231D53A4F39D1521F98D2E8BB279CF29BEBFD0687DC98458F
423 // ipfs address, string: "whatever here",
424 
425 // JUN-5 v1 contract deployed at https://rinkeby.etherscan.io/address/0xbe2ee825339c25749fb8ff8f6621d304fb2e2be5
426 // JUN-5 v1 contract deployed at https://ropsten.etherscan.io/address/0xbe2ee825339c25749fb8ff8f6621d304fb2e2be5
427 
428 // SuperOwner account is: 0xFA8f851b63E3742Eb5909C0735017C75b999B043 (macbook chrome)
429 
430 
431 // returns the vote status for a given proposal for a specific validator Address 
432 // 0 no voted yet / blank vote 
433 // 1 voted affirmatively
434 // 2 voted negatively 
435 // function getVoterStatus(bytes32 _rootHash, address _validatorAddr) constant public returns (uint _voteStatus)
436 // {
437 
438  // proposals[_rootHash].votes[_validatorAddr] ; 
439 
440 // }