1 pragma solidity ^0.5.0;
2 
3 
4 //Functions for retrieving min and Max in 51 length array (requestQ)
5 //Taken partly from: https://github.com/modular-network/ethereum-libraries-array-utils/blob/master/contracts/Array256Lib.sol
6 
7 library Utilities{
8 
9     /**
10     * @dev Returns the minimum value in an array.
11     */
12     function getMax(uint[51] memory data) internal pure returns(uint256 max,uint256 maxIndex) {
13         max = data[1];
14         maxIndex;
15         for(uint i=1;i < data.length;i++){
16             if(data[i] > max){
17                 max = data[i];
18                 maxIndex = i;
19                 }
20         }
21     }
22 
23     /**
24     * @dev Returns the minimum value in an array.
25     */
26     function getMin(uint[51] memory data) internal pure returns(uint256 min,uint256 minIndex) {
27         minIndex = data.length - 1;
28         min = data[minIndex];
29         for(uint i = data.length-1;i > 0;i--) {
30             if(data[i] < min) {
31                 min = data[i];
32                 minIndex = i;
33             }
34         }
35   }
36 
37 
38 
39 
40   // /// @dev Returns the minimum value and position in an array.
41   // //@note IT IGNORES THE 0 INDEX
42   //   function getMin(uint[51] memory arr) internal pure returns (uint256 min, uint256 minIndex) {
43   //     assembly {
44   //         minIndex := 50
45   //         min := mload(add(arr, mul(minIndex , 0x20)))
46   //         for {let i := 49 } gt(i,0) { i := sub(i, 1) } {
47   //             let item := mload(add(arr, mul(i, 0x20)))
48   //             if lt(item,min){
49   //                 min := item
50   //                 minIndex := i
51   //             }
52   //         }
53   //     }
54   //   }
55 
56 
57   
58   // function getMax(uint256[51] memory arr) internal pure returns (uint256 max, uint256 maxIndex) {
59   //     assembly {
60   //         for { let i := 0 } lt(i,51) { i := add(i, 1) } {
61   //             let item := mload(add(arr, mul(i, 0x20)))
62   //             if lt(max, item) {
63   //                 max := item
64   //                 maxIndex := i
65   //             }
66   //         }
67   //     }
68   //   }
69 
70 
71 
72 
73 
74   }
75 
76 
77 /**
78 * @title Tellor Getters Library
79 * @dev This is the getter library for all variables in the Tellor Tributes system. TellorGetters references this 
80 * libary for the getters logic
81 */
82 library TellorGettersLibrary{
83     using SafeMath for uint256;
84 
85     event NewTellorAddress(address _newTellor); //emmited when a proposed fork is voted true
86 
87     /*Functions*/
88 
89     //The next two functions are onlyOwner functions.  For Tellor to be truly decentralized, we will need to transfer the Deity to the 0 address.
90     //Only needs to be in library
91     /**
92     * @dev This function allows us to set a new Deity (or remove it) 
93     * @param _newDeity address of the new Deity of the tellor system 
94     */
95     function changeDeity(TellorStorage.TellorStorageStruct storage self, address _newDeity) internal{
96         require(self.addressVars[keccak256("_deity")] == msg.sender);
97         self.addressVars[keccak256("_deity")] =_newDeity;
98     }
99 
100 
101     //Only needs to be in library
102     /**
103     * @dev This function allows the deity to upgrade the Tellor System
104     * @param _tellorContract address of new updated TellorCore contract
105     */
106     function changeTellorContract(TellorStorage.TellorStorageStruct storage self,address _tellorContract) internal{
107         require(self.addressVars[keccak256("_deity")] == msg.sender);
108         self.addressVars[keccak256("tellorContract")]= _tellorContract;
109         emit NewTellorAddress(_tellorContract);
110     }
111 
112 
113     /*Tellor Getters*/
114 
115     /**
116     * @dev This function tells you if a given challenge has been completed by a given miner
117     * @param _challenge the challenge to search for
118     * @param _miner address that you want to know if they solved the challenge
119     * @return true if the _miner address provided solved the 
120     */
121     function didMine(TellorStorage.TellorStorageStruct storage self, bytes32 _challenge,address _miner) internal view returns(bool){
122         return self.minersByChallenge[_challenge][_miner];
123     }
124     
125 
126     /**
127     * @dev Checks if an address voted in a dispute
128     * @param _disputeId to look up
129     * @param _address of voting party to look up
130     * @return bool of whether or not party voted
131     */
132     function didVote(TellorStorage.TellorStorageStruct storage self,uint _disputeId, address _address) internal view returns(bool){
133         return self.disputesById[_disputeId].voted[_address];
134     }
135 
136 
137     /**
138     * @dev allows Tellor to read data from the addressVars mapping
139     * @param _data is the keccak256("variable_name") of the variable that is being accessed. 
140     * These are examples of how the variables are saved within other functions:
141     * addressVars[keccak256("_owner")]
142     * addressVars[keccak256("tellorContract")]
143     */
144     function getAddressVars(TellorStorage.TellorStorageStruct storage self, bytes32 _data) view internal returns(address){
145         return self.addressVars[_data];
146     }
147 
148 
149     /**
150     * @dev Gets all dispute variables
151     * @param _disputeId to look up
152     * @return bytes32 hash of dispute 
153     * @return bool executed where true if it has been voted on
154     * @return bool disputeVotePassed
155     * @return bool isPropFork true if the dispute is a proposed fork
156     * @return address of reportedMiner
157     * @return address of reportingParty
158     * @return address of proposedForkAddress
159     * @return uint of requestId
160     * @return uint of timestamp
161     * @return uint of value
162     * @return uint of minExecutionDate
163     * @return uint of numberOfVotes
164     * @return uint of blocknumber
165     * @return uint of minerSlot
166     * @return uint of quorum
167     * @return uint of fee
168     * @return int count of the current tally
169     */
170     function getAllDisputeVars(TellorStorage.TellorStorageStruct storage self,uint _disputeId) internal view returns(bytes32, bool, bool, bool, address, address, address,uint[9] memory, int){
171         TellorStorage.Dispute storage disp = self.disputesById[_disputeId];
172         return(disp.hash,disp.executed, disp.disputeVotePassed, disp.isPropFork, disp.reportedMiner, disp.reportingParty,disp.proposedForkAddress,[disp.disputeUintVars[keccak256("requestId")], disp.disputeUintVars[keccak256("timestamp")], disp.disputeUintVars[keccak256("value")], disp.disputeUintVars[keccak256("minExecutionDate")], disp.disputeUintVars[keccak256("numberOfVotes")], disp.disputeUintVars[keccak256("blockNumber")], disp.disputeUintVars[keccak256("minerSlot")], disp.disputeUintVars[keccak256("quorum")],disp.disputeUintVars[keccak256("fee")]],disp.tally);
173     }
174 
175 
176     /**
177     * @dev Getter function for variables for the requestId being currently mined(currentRequestId)
178     * @return current challenge, curretnRequestId, level of difficulty, api/query string, and granularity(number of decimals requested), total tip for the request 
179     */
180     function getCurrentVariables(TellorStorage.TellorStorageStruct storage self) internal view returns(bytes32, uint, uint,string memory,uint,uint){    
181         return (self.currentChallenge,self.uintVars[keccak256("currentRequestId")],self.uintVars[keccak256("difficulty")],self.requestDetails[self.uintVars[keccak256("currentRequestId")]].queryString,self.requestDetails[self.uintVars[keccak256("currentRequestId")]].apiUintVars[keccak256("granularity")],self.requestDetails[self.uintVars[keccak256("currentRequestId")]].apiUintVars[keccak256("totalTip")]);
182     }
183 
184 
185     /**
186     * @dev Checks if a given hash of miner,requestId has been disputed
187     * @param _hash is the sha256(abi.encodePacked(_miners[2],_requestId));
188     * @return uint disputeId
189     */
190     function getDisputeIdByDisputeHash(TellorStorage.TellorStorageStruct storage self,bytes32 _hash) internal view returns(uint){
191         return  self.disputeIdByDisputeHash[_hash];
192     }
193 
194 
195     /**
196     * @dev Checks for uint variables in the disputeUintVars mapping based on the disuputeId
197     * @param _disputeId is the dispute id;
198     * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is 
199     * the variables/strings used to save the data in the mapping. The variables names are  
200     * commented out under the disputeUintVars under the Dispute struct
201     * @return uint value for the bytes32 data submitted
202     */
203     function getDisputeUintVars(TellorStorage.TellorStorageStruct storage self,uint _disputeId,bytes32 _data) internal view returns(uint){
204         return self.disputesById[_disputeId].disputeUintVars[_data];
205     }
206 
207     
208     /**
209     * @dev Gets the a value for the latest timestamp available
210     * @return value for timestamp of last proof of work submited
211     * @return true if the is a timestamp for the lastNewValue
212     */
213     function getLastNewValue(TellorStorage.TellorStorageStruct storage self) internal view returns(uint,bool){
214         return (retrieveData(self,self.requestIdByTimestamp[self.uintVars[keccak256("timeOfLastNewValue")]], self.uintVars[keccak256("timeOfLastNewValue")]),true);
215     }
216 
217 
218     /**
219     * @dev Gets the a value for the latest timestamp available
220     * @param _requestId being requested
221     * @return value for timestamp of last proof of work submited and if true if it exist or 0 and false if it doesn't
222     */
223     function getLastNewValueById(TellorStorage.TellorStorageStruct storage self,uint _requestId) internal view returns(uint,bool){
224         TellorStorage.Request storage _request = self.requestDetails[_requestId]; 
225         if(_request.requestTimestamps.length > 0){
226             return (retrieveData(self,_requestId,_request.requestTimestamps[_request.requestTimestamps.length - 1]),true);
227         }
228         else{
229             return (0,false);
230         }
231     }
232 
233 
234     /**
235     * @dev Gets blocknumber for mined timestamp 
236     * @param _requestId to look up
237     * @param _timestamp is the timestamp to look up blocknumber
238     * @return uint of the blocknumber which the dispute was mined
239     */
240     function getMinedBlockNum(TellorStorage.TellorStorageStruct storage self,uint _requestId, uint _timestamp) internal view returns(uint){
241         return self.requestDetails[_requestId].minedBlockNum[_timestamp];
242     }
243 
244 
245     /**
246     * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp 
247     * @param _requestId to look up
248     * @param _timestamp is the timestamp to look up miners for
249     * @return the 5 miners' addresses
250     */
251     function getMinersByRequestIdAndTimestamp(TellorStorage.TellorStorageStruct storage self, uint _requestId, uint _timestamp) internal view returns(address[5] memory){
252         return self.requestDetails[_requestId].minersByValue[_timestamp];
253     }
254 
255 
256     /**
257     * @dev Get the name of the token
258     * @return string of the token name
259     */
260     function getName(TellorStorage.TellorStorageStruct storage self) internal pure returns(string memory){
261         return "Tellor Tributes";
262     }
263 
264 
265     /**
266     * @dev Counts the number of values that have been submited for the request 
267     * if called for the currentRequest being mined it can tell you how many miners have submitted a value for that
268     * request so far
269     * @param _requestId the requestId to look up
270     * @return uint count of the number of values received for the requestId
271     */
272     function getNewValueCountbyRequestId(TellorStorage.TellorStorageStruct storage self, uint _requestId) internal view returns(uint){
273         return self.requestDetails[_requestId].requestTimestamps.length;
274     }
275 
276 
277     /**
278     * @dev Getter function for the specified requestQ index
279     * @param _index to look up in the requestQ array
280     * @return uint of reqeuestId
281     */
282     function getRequestIdByRequestQIndex(TellorStorage.TellorStorageStruct storage self, uint _index) internal view returns(uint){
283         require(_index <= 50);
284         return self.requestIdByRequestQIndex[_index];
285     }
286 
287 
288     /**
289     * @dev Getter function for requestId based on timestamp 
290     * @param _timestamp to check requestId
291     * @return uint of reqeuestId
292     */
293     function getRequestIdByTimestamp(TellorStorage.TellorStorageStruct storage self, uint _timestamp) internal view returns(uint){    
294         return self.requestIdByTimestamp[_timestamp];
295     }
296 
297 
298     /**
299     * @dev Getter function for requestId based on the qeuaryHash
300     * @param _queryHash hash(of string api and granularity) to check if a request already exists
301     * @return uint requestId
302     */
303     function getRequestIdByQueryHash(TellorStorage.TellorStorageStruct storage self, bytes32 _queryHash) internal view returns(uint){    
304         return self.requestIdByQueryHash[_queryHash];
305     }
306 
307 
308     /**
309     * @dev Getter function for the requestQ array
310     * @return the requestQ arrray
311     */
312     function getRequestQ(TellorStorage.TellorStorageStruct storage self) view internal returns(uint[51] memory){
313         return self.requestQ;
314     }
315 
316 
317     /**
318     * @dev Allowes access to the uint variables saved in the apiUintVars under the requestDetails struct
319     * for the requestId specified
320     * @param _requestId to look up
321     * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is 
322     * the variables/strings used to save the data in the mapping. The variables names are  
323     * commented out under the apiUintVars under the requestDetails struct
324     * @return uint value of the apiUintVars specified in _data for the requestId specified
325     */
326     function getRequestUintVars(TellorStorage.TellorStorageStruct storage self,uint _requestId,bytes32 _data) internal view returns(uint){
327         return self.requestDetails[_requestId].apiUintVars[_data];
328     }
329 
330 
331     /**
332     * @dev Gets the API struct variables that are not mappings
333     * @param _requestId to look up
334     * @return string of api to query
335     * @return string of symbol of api to query
336     * @return bytes32 hash of string
337     * @return bytes32 of the granularity(decimal places) requested
338     * @return uint of index in requestQ array
339     * @return uint of current payout/tip for this requestId
340     */
341     function getRequestVars(TellorStorage.TellorStorageStruct storage self,uint _requestId) internal view returns(string memory,string memory, bytes32,uint, uint, uint) {
342         TellorStorage.Request storage _request = self.requestDetails[_requestId]; 
343         return (_request.queryString,_request.dataSymbol,_request.queryHash, _request.apiUintVars[keccak256("granularity")],_request.apiUintVars[keccak256("requestQPosition")],_request.apiUintVars[keccak256("totalTip")]);
344     }
345 
346 
347     /**
348     * @dev This function allows users to retireve all information about a staker
349     * @param _staker address of staker inquiring about
350     * @return uint current state of staker
351     * @return uint startDate of staking
352     */
353     function getStakerInfo(TellorStorage.TellorStorageStruct storage self,address _staker) internal view returns(uint,uint){
354         return (self.stakerDetails[_staker].currentStatus,self.stakerDetails[_staker].startDate);
355     }
356 
357 
358     /**
359     * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp 
360     * @param _requestId to look up
361     * @param _timestamp is the timestampt to look up miners for
362     * @return address[5] array of 5 addresses ofminers that mined the requestId
363     */
364     function getSubmissionsByTimestamp(TellorStorage.TellorStorageStruct storage self, uint _requestId, uint _timestamp) internal view returns(uint[5] memory){
365         return self.requestDetails[_requestId].valuesByTimestamp[_timestamp];
366     }
367 
368     /**
369     * @dev Get the symbol of the token
370     * @return string of the token symbol
371     */
372     function getSymbol(TellorStorage.TellorStorageStruct storage self) internal pure returns(string memory){
373         return "TT";
374     } 
375 
376 
377     /**
378     * @dev Gets the timestamp for the value based on their index
379     * @param _requestID is the requestId to look up
380     * @param _index is the value index to look up
381     * @return uint timestamp
382     */
383     function getTimestampbyRequestIDandIndex(TellorStorage.TellorStorageStruct storage self,uint _requestID, uint _index) internal view returns(uint){
384         return self.requestDetails[_requestID].requestTimestamps[_index];
385     }
386 
387 
388     /**
389     * @dev Getter for the variables saved under the TellorStorageStruct uintVars variable
390     * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is 
391     * the variables/strings used to save the data in the mapping. The variables names are  
392     * commented out under the uintVars under the TellorStorageStruct struct
393     * This is an example of how data is saved into the mapping within other functions: 
394     * self.uintVars[keccak256("stakerCount")]
395     * @return uint of specified variable  
396     */ 
397     function getUintVar(TellorStorage.TellorStorageStruct storage self,bytes32 _data) view internal returns(uint){
398         return self.uintVars[_data];
399     }
400 
401 
402     /**
403     * @dev Getter function for next requestId on queue/request with highest payout at time the function is called
404     * @return onDeck/info on request with highest payout-- RequestId, Totaltips, and API query string
405     */
406     function getVariablesOnDeck(TellorStorage.TellorStorageStruct storage self) internal view returns(uint, uint,string memory){ 
407         uint newRequestId = getTopRequestID(self);
408         return (newRequestId,self.requestDetails[newRequestId].apiUintVars[keccak256("totalTip")],self.requestDetails[newRequestId].queryString);
409     }
410 
411 
412     /**
413     * @dev Getter function for the request with highest payout. This function is used within the getVariablesOnDeck function
414     * @return uint _requestId of request with highest payout at the time the function is called
415     */
416     function getTopRequestID(TellorStorage.TellorStorageStruct storage self) internal view returns(uint _requestId){
417             uint _max;
418             uint _index;
419             (_max,_index) = Utilities.getMax(self.requestQ);
420              _requestId = self.requestIdByRequestQIndex[_index];
421     }
422 
423 
424     /**
425     * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp 
426     * @param _requestId to look up
427     * @param _timestamp is the timestamp to look up miners for
428     * @return bool true if requestId/timestamp is under dispute
429     */
430     function isInDispute(TellorStorage.TellorStorageStruct storage self, uint _requestId, uint _timestamp) internal view returns(bool){
431         return self.requestDetails[_requestId].inDispute[_timestamp];
432     }
433 
434 
435     /**
436     * @dev Retreive value from oracle based on requestId/timestamp
437     * @param _requestId being requested
438     * @param _timestamp to retreive data/value from
439     * @return uint value for requestId/timestamp submitted
440     */
441     function retrieveData(TellorStorage.TellorStorageStruct storage self, uint _requestId, uint _timestamp) internal view returns (uint) {
442         return self.requestDetails[_requestId].finalValues[_timestamp];
443     }
444 
445 
446     /**
447     * @dev Getter for the total_supply of oracle tokens
448     * @return uint total supply
449     */
450     function totalSupply(TellorStorage.TellorStorageStruct storage self) internal view returns (uint) {
451        return self.uintVars[keccak256("total_supply")];
452     }
453 
454 }
455 
456 
457 
458 
459 
460 
461 
462 pragma solidity ^0.5.0;
463 
464 //Slightly modified SafeMath library - includes a min and max function, removes useless div function
465 library SafeMath {
466 
467   function add(uint256 a, uint256 b) internal pure returns (uint256) {
468     uint256 c = a + b;
469     assert(c >= a);
470     return c;
471   }
472 
473   function add(int256 a, int256 b) internal pure returns (int256 c) {
474     if(b > 0){
475       c = a + b;
476       assert(c >= a);
477     }
478     else{
479       c = a + b;
480       assert(c <= a);
481     }
482 
483   }
484 
485   function max(uint a, uint b) internal pure returns (uint256) {
486     return a > b ? a : b;
487   }
488 
489   function max(int256 a, int256 b) internal pure returns (uint256) {
490     return a > b ? uint(a) : uint(b);
491   }
492 
493   function min(uint a, uint b) internal pure returns (uint256) {
494     return a < b ? a : b;
495   }
496   
497   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
498     uint256 c = a * b;
499     assert(a == 0 || c / a == b);
500     return c;
501   }
502 
503   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
504     assert(b <= a);
505     return a - b;
506   }
507 
508   function sub(int256 a, int256 b) internal pure returns (int256 c) {
509     if(b > 0){
510       c = a - b;
511       assert(c <= a);
512     }
513     else{
514       c = a - b;
515       assert(c >= a);
516     }
517 
518   }
519 
520 }
521 
522 
523 
524 /**
525  * @title Tellor Oracle Storage Library
526  * @dev Contains all the variables/structs used by Tellor
527  */
528 
529 library TellorStorage {
530     //Internal struct for use in proof-of-work submission
531     struct Details {
532         uint value;
533         address miner;
534     }
535 
536     struct Dispute {
537         bytes32 hash;//unique hash of dispute: keccak256(_miner,_requestId,_timestamp)
538         int tally;//current tally of votes for - against measure
539         bool executed;//is the dispute settled
540         bool disputeVotePassed;//did the vote pass?
541         bool isPropFork; //true for fork proposal NEW
542         address reportedMiner; //miner who alledgedly submitted the 'bad value' will get disputeFee if dispute vote fails
543         address reportingParty;//miner reporting the 'bad value'-pay disputeFee will get reportedMiner's stake if dispute vote passes
544         address proposedForkAddress;//new fork address (if fork proposal)
545         mapping(bytes32 => uint) disputeUintVars;
546         //Each of the variables below is saved in the mapping disputeUintVars for each disputeID
547         //e.g. TellorStorageStruct.DisputeById[disputeID].disputeUintVars[keccak256("requestId")]
548         //These are the variables saved in this mapping:
549             // uint keccak256("requestId");//apiID of disputed value
550             // uint keccak256("timestamp");//timestamp of distputed value
551             // uint keccak256("value"); //the value being disputed
552             // uint keccak256("minExecutionDate");//7 days from when dispute initialized
553             // uint keccak256("numberOfVotes");//the number of parties who have voted on the measure
554             // uint keccak256("blockNumber");// the blocknumber for which votes will be calculated from
555             // uint keccak256("minerSlot"); //index in dispute array
556             // uint keccak256("quorum"); //quorum for dispute vote NEW
557             // uint keccak256("fee"); //fee paid corresponding to dispute
558         mapping (address => bool) voted; //mapping of address to whether or not they voted
559     }
560 
561     struct StakeInfo {
562         uint currentStatus;//0-not Staked, 1=Staked, 2=LockedForWithdraw 3= OnDispute
563         uint startDate; //stake start date
564     }
565 
566     //Internal struct to allow balances to be queried by blocknumber for voting purposes
567     struct  Checkpoint {
568         uint128 fromBlock;// fromBlock is the block number that the value was generated from
569         uint128 value;// value is the amount of tokens at a specific block number
570     }
571 
572     struct Request {
573         string queryString;//id to string api
574         string dataSymbol;//short name for api request
575         bytes32 queryHash;//hash of api string and granularity e.g. keccak256(abi.encodePacked(_sapi,_granularity))
576         uint[]  requestTimestamps; //array of all newValueTimestamps requested
577         mapping(bytes32 => uint) apiUintVars;
578         //Each of the variables below is saved in the mapping apiUintVars for each api request
579         //e.g. requestDetails[_requestId].apiUintVars[keccak256("totalTip")]
580         //These are the variables saved in this mapping:
581             // uint keccak256("granularity"); //multiplier for miners
582             // uint keccak256("requestQPosition"); //index in requestQ
583             // uint keccak256("totalTip");//bonus portion of payout
584         mapping(uint => uint) minedBlockNum;//[apiId][minedTimestamp]=>block.number
585         mapping(uint => uint) finalValues;//This the time series of finalValues stored by the contract where uint UNIX timestamp is mapped to value
586         mapping(uint => bool) inDispute;//checks if API id is in dispute or finalized.
587         mapping(uint => address[5]) minersByValue;
588         mapping(uint => uint[5])valuesByTimestamp;
589     }
590 
591     struct TellorStorageStruct {
592         bytes32 currentChallenge; //current challenge to be solved
593         uint[51]  requestQ; //uint50 array of the top50 requests by payment amount
594         uint[]  newValueTimestamps; //array of all timestamps requested
595         Details[5]  currentMiners; //This struct is for organizing the five mined values to find the median
596         mapping(bytes32 => address) addressVars;
597         //Address fields in the Tellor contract are saved the addressVars mapping
598         //e.g. addressVars[keccak256("tellorContract")] = address
599         //These are the variables saved in this mapping:
600             // address keccak256("tellorContract");//Tellor address
601             // address  keccak256("_owner");//Tellor Owner address
602             // address  keccak256("_deity");//Tellor Owner that can do things at will
603         mapping(bytes32 => uint) uintVars; 
604         //uint fields in the Tellor contract are saved the uintVars mapping
605         //e.g. uintVars[keccak256("decimals")] = uint
606         //These are the variables saved in this mapping:
607             // keccak256("decimals");    //18 decimal standard ERC20
608             // keccak256("disputeFee");//cost to dispute a mined value
609             // keccak256("disputeCount");//totalHistoricalDisputes
610             // keccak256("total_supply"); //total_supply of the token in circulation
611             // keccak256("stakeAmount");//stakeAmount for miners (we can cut gas if we just hardcode it in...or should it be variable?)
612             // keccak256("stakerCount"); //number of parties currently staked
613             // keccak256("timeOfLastNewValue"); // time of last challenge solved
614             // keccak256("difficulty"); // Difficulty of current block
615             // keccak256("currentTotalTips"); //value of highest api/timestamp PayoutPool
616             // keccak256("currentRequestId"); //API being mined--updates with the ApiOnQ Id
617             // keccak256("requestCount"); // total number of requests through the system
618             // keccak256("slotProgress");//Number of miners who have mined this value so far
619             // keccak256("miningReward");//Mining Reward in PoWo tokens given to all miners per value
620             // keccak256("timeTarget"); //The time between blocks (mined Oracle values)
621         mapping(bytes32 => mapping(address=>bool)) minersByChallenge;//This is a boolean that tells you if a given challenge has been completed by a given miner
622         mapping(uint => uint) requestIdByTimestamp;//minedTimestamp to apiId
623         mapping(uint => uint) requestIdByRequestQIndex; //link from payoutPoolIndex (position in payout pool array) to apiId
624         mapping(uint => Dispute) disputesById;//disputeId=> Dispute details
625         mapping (address => Checkpoint[]) balances; //balances of a party given blocks
626         mapping(address => mapping (address => uint)) allowed; //allowance for a given party and approver
627         mapping(address => StakeInfo)  stakerDetails;//mapping from a persons address to their staking info
628         mapping(uint => Request) requestDetails;//mapping of apiID to details
629         mapping(bytes32 => uint) requestIdByQueryHash;// api bytes32 gets an id = to count of requests array
630         mapping(bytes32 => uint) disputeIdByDisputeHash;//maps a hash to an ID for each dispute
631     }
632 }
633 
634 
635 /**
636 * @title Tellor Transfer
637 * @dev Contais the methods related to transfers and ERC20. Tellor.sol and TellorGetters.sol
638 * reference this library for function's logic.
639 */
640 library TellorTransfer {
641     using SafeMath for uint256;
642 
643     event Approval(address indexed _owner, address indexed _spender, uint256 _value);//ERC20 Approval event
644     event Transfer(address indexed _from, address indexed _to, uint256 _value);//ERC20 Transfer Event
645 
646     /*Functions*/
647     
648     /**
649     * @dev Allows for a transfer of tokens to _to
650     * @param _to The address to send tokens to
651     * @param _amount The amount of tokens to send
652     * @return true if transfer is successful
653     */
654     function transfer(TellorStorage.TellorStorageStruct storage self, address _to, uint256 _amount) public returns (bool success) {
655         doTransfer(self,msg.sender, _to, _amount);
656         return true;
657     }
658 
659 
660     /**
661     * @notice Send _amount tokens to _to from _from on the condition it
662     * is approved by _from
663     * @param _from The address holding the tokens being transferred
664     * @param _to The address of the recipient
665     * @param _amount The amount of tokens to be transferred
666     * @return True if the transfer was successful
667     */
668     function transferFrom(TellorStorage.TellorStorageStruct storage self, address _from, address _to, uint256 _amount) public returns (bool success) {
669         require(self.allowed[_from][msg.sender] >= _amount);
670         self.allowed[_from][msg.sender] -= _amount;
671         doTransfer(self,_from, _to, _amount);
672         return true;
673     }
674 
675 
676     /**
677     * @dev This function approves a _spender an _amount of tokens to use
678     * @param _spender address
679     * @param _amount amount the spender is being approved for
680     * @return true if spender appproved successfully
681     */
682     function approve(TellorStorage.TellorStorageStruct storage self, address _spender, uint _amount) public returns (bool) {
683         require(allowedToTrade(self,msg.sender,_amount));
684         require(_spender != address(0));
685         self.allowed[msg.sender][_spender] = _amount;
686         emit Approval(msg.sender, _spender, _amount);
687         return true;
688     }
689 
690 
691     /**
692     * @param _user address of party with the balance
693     * @param _spender address of spender of parties said balance
694     * @return Returns the remaining allowance of tokens granted to the _spender from the _user
695     */
696     function allowance(TellorStorage.TellorStorageStruct storage self,address _user, address _spender) public view returns (uint) {
697        return self.allowed[_user][_spender]; 
698     }
699 
700 
701     /**
702     * @dev Completes POWO transfers by updating the balances on the current block number
703     * @param _from address to transfer from
704     * @param _to addres to transfer to
705     * @param _amount to transfer
706     */
707     function doTransfer(TellorStorage.TellorStorageStruct storage self, address _from, address _to, uint _amount) public {
708         require(_amount > 0);
709         require(_to != address(0));
710         require(allowedToTrade(self,_from,_amount)); //allowedToTrade checks the stakeAmount is removed from balance if the _user is staked
711         uint previousBalance = balanceOfAt(self,_from, block.number);
712         updateBalanceAtNow(self.balances[_from], previousBalance - _amount);
713         previousBalance = balanceOfAt(self,_to, block.number);
714         require(previousBalance + _amount >= previousBalance); // Check for overflow
715         updateBalanceAtNow(self.balances[_to], previousBalance + _amount);
716         emit Transfer(_from, _to, _amount);
717     }
718 
719 
720     /**
721     * @dev Gets balance of owner specified
722     * @param _user is the owner address used to look up the balance
723     * @return Returns the balance associated with the passed in _user
724     */
725     function balanceOf(TellorStorage.TellorStorageStruct storage self,address _user) public view returns (uint) {
726         return balanceOfAt(self,_user, block.number);
727     }
728 
729 
730     /**
731     * @dev Queries the balance of _user at a specific _blockNumber
732     * @param _user The address from which the balance will be retrieved
733     * @param _blockNumber The block number when the balance is queried
734     * @return The balance at _blockNumber specified
735     */
736     function balanceOfAt(TellorStorage.TellorStorageStruct storage self,address _user, uint _blockNumber) public view returns (uint) {
737         if ((self.balances[_user].length == 0) || (self.balances[_user][0].fromBlock > _blockNumber)) {
738                 return 0;
739         }
740      else {
741         return getBalanceAt(self.balances[_user], _blockNumber);
742      }
743     }
744 
745 
746     /**
747     * @dev Getter for balance for owner on the specified _block number
748     * @param checkpoints gets the mapping for the balances[owner]
749     * @param _block is the block number to search the balance on
750     * @return the balance at the checkpoint
751     */
752     function getBalanceAt(TellorStorage.Checkpoint[] storage checkpoints, uint _block) view public returns (uint) {
753         if (checkpoints.length == 0) return 0;
754         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
755             return checkpoints[checkpoints.length-1].value;
756         if (_block < checkpoints[0].fromBlock) return 0;
757         // Binary search of the value in the array
758         uint min = 0;
759         uint max = checkpoints.length-1;
760         while (max > min) {
761             uint mid = (max + min + 1)/ 2;
762             if (checkpoints[mid].fromBlock<=_block) {
763                 min = mid;
764             } else {
765                 max = mid-1;
766             }
767         }
768         return checkpoints[min].value;
769     }
770 
771 
772     /**
773     * @dev This function returns whether or not a given user is allowed to trade a given amount 
774     * and removing the staked amount from their balance if they are staked
775     * @param _user address of user
776     * @param _amount to check if the user can spend
777     * @return true if they are allowed to spend the amount being checked
778     */
779     function allowedToTrade(TellorStorage.TellorStorageStruct storage self,address _user,uint _amount) public view returns(bool) {
780         if(self.stakerDetails[_user].currentStatus >0){
781             //Removes the stakeAmount from balance if the _user is staked
782             if(balanceOf(self,_user).sub(self.uintVars[keccak256("stakeAmount")]).sub(_amount) >= 0){
783                 return true;
784             }
785         }
786         else if(balanceOf(self,_user).sub(_amount) >= 0){
787                 return true;
788         }
789         return false;
790     }
791     
792 
793     /**
794     * @dev Updates balance for from and to on the current block number via doTransfer
795     * @param checkpoints gets the mapping for the balances[owner]
796     * @param _value is the new balance
797     */
798     function updateBalanceAtNow(TellorStorage.Checkpoint[] storage checkpoints, uint _value) public {
799         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
800                TellorStorage.Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
801                newCheckPoint.fromBlock =  uint128(block.number);
802                newCheckPoint.value = uint128(_value);
803         } else {
804                TellorStorage.Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
805                oldCheckPoint.value = uint128(_value);
806         }
807     }
808 }
809 
810 
811 
812 
813 //import "./SafeMath.sol";
814 
815 /**
816 * @title Tellor Dispute
817 * @dev Contais the methods related to disputes. Tellor.sol references this library for function's logic.
818 */
819 
820 
821 library TellorDispute {
822     using SafeMath for uint256;
823     using SafeMath for int256;
824 
825     event NewDispute(uint indexed _disputeId, uint indexed _requestId, uint _timestamp, address _miner);//emitted when a new dispute is initialized
826     event Voted(uint indexed _disputeID, bool _position, address indexed _voter);//emitted when a new vote happens
827     event DisputeVoteTallied(uint indexed _disputeID, int _result,address indexed _reportedMiner,address _reportingParty, bool _active);//emitted upon dispute tally
828     event NewTellorAddress(address _newTellor); //emmited when a proposed fork is voted true
829 
830     /*Functions*/
831     
832     /**
833     * @dev Helps initialize a dispute by assigning it a disputeId
834     * when a miner returns a false on the validate array(in Tellor.ProofOfWork) it sends the
835     * invalidated value information to POS voting
836     * @param _requestId being disputed
837     * @param _timestamp being disputed
838     * @param _minerIndex the index of the miner that submitted the value being disputed. Since each official value
839     * requires 5 miners to submit a value.
840     */
841     function beginDispute(TellorStorage.TellorStorageStruct storage self,uint _requestId, uint _timestamp,uint _minerIndex) public {
842         TellorStorage.Request storage _request = self.requestDetails[_requestId];
843         //require that no more than a day( (24 hours * 60 minutes)/10minutes=144 blocks) has gone by since the value was "mined"
844         require(block.number- _request.minedBlockNum[_timestamp]<= 144);
845         require(_request.minedBlockNum[_timestamp] > 0);
846         require(_minerIndex < 5);
847         
848         //_miner is the miner being disputed. For every mined value 5 miners are saved in an array and the _minerIndex
849         //provided by the party initiating the dispute
850         address _miner = _request.minersByValue[_timestamp][_minerIndex];
851         bytes32 _hash = keccak256(abi.encodePacked(_miner,_requestId,_timestamp));
852         
853         //Ensures that a dispute is not already open for the that miner, requestId and timestamp
854         require(self.disputeIdByDisputeHash[_hash] == 0);
855         TellorTransfer.doTransfer(self, msg.sender,address(this), self.uintVars[keccak256("disputeFee")]);
856         
857         //Increase the dispute count by 1
858         self.uintVars[keccak256("disputeCount")] =  self.uintVars[keccak256("disputeCount")] + 1;
859         
860         //Sets the new disputeCount as the disputeId
861         uint disputeId = self.uintVars[keccak256("disputeCount")];
862         
863         //maps the dispute hash to the disputeId
864         self.disputeIdByDisputeHash[_hash] = disputeId;
865         //maps the dispute to the Dispute struct
866         self.disputesById[disputeId] = TellorStorage.Dispute({
867             hash:_hash,
868             isPropFork: false,
869             reportedMiner: _miner,
870             reportingParty: msg.sender,
871             proposedForkAddress:address(0),
872             executed: false,
873             disputeVotePassed: false,
874             tally: 0
875             });
876         
877         //Saves all the dispute variables for the disputeId
878         self.disputesById[disputeId].disputeUintVars[keccak256("requestId")] = _requestId;
879         self.disputesById[disputeId].disputeUintVars[keccak256("timestamp")] = _timestamp;
880         self.disputesById[disputeId].disputeUintVars[keccak256("value")] = _request.valuesByTimestamp[_timestamp][_minerIndex];
881         self.disputesById[disputeId].disputeUintVars[keccak256("minExecutionDate")] = now + 7 days;
882         self.disputesById[disputeId].disputeUintVars[keccak256("blockNumber")] = block.number;
883         self.disputesById[disputeId].disputeUintVars[keccak256("minerSlot")] = _minerIndex;
884         self.disputesById[disputeId].disputeUintVars[keccak256("fee")]  = self.uintVars[keccak256("disputeFee")];
885         
886         //Values are sorted as they come in and the official value is the median of the first five
887         //So the "official value" miner is always minerIndex==2. If the official value is being 
888         //disputed, it sets its status to inDispute(currentStatus = 3) so that users are made aware it is under dispute
889         if(_minerIndex == 2){
890             self.requestDetails[_requestId].inDispute[_timestamp] = true;
891         }
892         self.stakerDetails[_miner].currentStatus = 3;
893         emit NewDispute(disputeId,_requestId,_timestamp,_miner);
894     }
895 
896 
897     /**
898     * @dev Allows token holders to vote
899     * @param _disputeId is the dispute id
900     * @param _supportsDispute is the vote (true=the dispute has basis false = vote against dispute)
901     */
902     function vote(TellorStorage.TellorStorageStruct storage self, uint _disputeId, bool _supportsDispute) public {
903         TellorStorage.Dispute storage disp = self.disputesById[_disputeId];
904         
905         //Get the voteWeight or the balance of the user at the time/blockNumber the disupte began
906         uint voteWeight = TellorTransfer.balanceOfAt(self,msg.sender,disp.disputeUintVars[keccak256("blockNumber")]);
907         
908         //Require that the msg.sender has not voted
909         require(disp.voted[msg.sender] != true);
910         
911         //Requre that the user had a balance >0 at time/blockNumber the disupte began
912         require(voteWeight > 0);
913         
914         //ensures miners that are under dispute cannot vote
915         require(self.stakerDetails[msg.sender].currentStatus != 3);
916         
917         //Update user voting status to true
918         disp.voted[msg.sender] = true;
919         
920         //Update the number of votes for the dispute
921         disp.disputeUintVars[keccak256("numberOfVotes")] += 1;
922         
923         //Update the quorum by adding the voteWeight
924         disp.disputeUintVars[keccak256("quorum")] += voteWeight; 
925         
926         //If the user supports the dispute increase the tally for the dispute by the voteWeight
927         //otherwise decrease it
928         if (_supportsDispute) {
929             disp.tally = disp.tally.add(int(voteWeight));
930         } else {
931             disp.tally = disp.tally.sub(int(voteWeight));
932         }
933         
934         //Let the network know the user has voted on the dispute and their casted vote
935         emit Voted(_disputeId,_supportsDispute,msg.sender);
936     }
937 
938 
939     /**
940     * @dev tallies the votes.
941     * @param _disputeId is the dispute id
942     */
943     function tallyVotes(TellorStorage.TellorStorageStruct storage self, uint _disputeId) public {
944         TellorStorage.Dispute storage disp = self.disputesById[_disputeId];
945         TellorStorage.Request storage _request = self.requestDetails[disp.disputeUintVars[keccak256("requestId")]];
946 
947         //Ensure this has not already been executed/tallied
948         require(disp.executed == false);
949 
950         //Ensure the time for voting has elapsed
951         require(now > disp.disputeUintVars[keccak256("minExecutionDate")]);  
952 
953         //If the vote is not a proposed fork 
954         if (disp.isPropFork== false){
955         TellorStorage.StakeInfo storage stakes = self.stakerDetails[disp.reportedMiner];  
956             //If the vote for disputing a value is succesful(disp.tally >0) then unstake the reported 
957             // miner and transfer the stakeAmount and dispute fee to the reporting party 
958             if (disp.tally > 0 ) { 
959 
960                 //Changing the currentStatus and startDate unstakes the reported miner and allows for the
961                 //transfer of the stakeAmount
962                 stakes.currentStatus = 0;
963                 stakes.startDate = now -(now % 86400);
964 
965                 //Decreases the stakerCount since the miner's stake is being slashed
966                 self.uintVars[keccak256("stakerCount")]--;
967                 updateDisputeFee(self);
968 
969                 //Transfers the StakeAmount from the reporded miner to the reporting party
970                 TellorTransfer.doTransfer(self, disp.reportedMiner,disp.reportingParty, self.uintVars[keccak256("stakeAmount")]);
971                 
972                 //Returns the dispute fee to the reportingParty
973                 TellorTransfer.doTransfer(self, address(this),disp.reportingParty,disp.disputeUintVars[keccak256("fee")]);
974                 
975                 //Set the dispute state to passed/true
976                 disp.disputeVotePassed = true;
977 
978                 //If the dispute was succeful(miner found guilty) then update the timestamp value to zero
979                 //so that users don't use this datapoint
980                 if(_request.inDispute[disp.disputeUintVars[keccak256("timestamp")]] == true){
981                     _request.finalValues[disp.disputeUintVars[keccak256("timestamp")]] = 0;
982                 }
983 
984             //If the vote for disputing a value is unsuccesful then update the miner status from being on 
985             //dispute(currentStatus=3) to staked(currentStatus =1) and tranfer the dispute fee to the miner
986             } else {
987                 //Update the miner's current status to staked(currentStatus = 1)
988                 stakes.currentStatus = 1;              
989                 //tranfer the dispute fee to the miner
990                 TellorTransfer.doTransfer(self,address(this),disp.reportedMiner,disp.disputeUintVars[keccak256("fee")]);
991                 if(_request.inDispute[disp.disputeUintVars[keccak256("timestamp")]] == true){
992                     _request.inDispute[disp.disputeUintVars[keccak256("timestamp")]] = false;
993                 }
994             }
995         //If the vote is for a proposed fork require a 20% quorum before excecuting the update to the new tellor contract address
996         } else {
997             if(disp.tally > 0 ){
998                 require(disp.disputeUintVars[keccak256("quorum")] >  (self.uintVars[keccak256("total_supply")] * 20 / 100));
999                 self.addressVars[keccak256("tellorContract")] = disp.proposedForkAddress;
1000                 disp.disputeVotePassed = true;
1001                 emit NewTellorAddress(disp.proposedForkAddress);
1002             }
1003         }
1004         
1005         //update the dispute status to executed
1006         disp.executed = true;
1007         emit DisputeVoteTallied(_disputeId,disp.tally,disp.reportedMiner,disp.reportingParty,disp.disputeVotePassed);
1008     }
1009 
1010 
1011     /**
1012     * @dev Allows for a fork to be proposed
1013     * @param _propNewTellorAddress address for new proposed Tellor
1014     */
1015     function proposeFork(TellorStorage.TellorStorageStruct storage self, address _propNewTellorAddress) public {
1016         bytes32 _hash = keccak256(abi.encodePacked(_propNewTellorAddress));
1017         require(self.disputeIdByDisputeHash[_hash] == 0);
1018         TellorTransfer.doTransfer(self, msg.sender,address(this), self.uintVars[keccak256("disputeFee")]);//This is the fork fee
1019         self.uintVars[keccak256("disputeCount")]++;
1020         uint disputeId = self.uintVars[keccak256("disputeCount")];
1021         self.disputeIdByDisputeHash[_hash] = disputeId;
1022         self.disputesById[disputeId] = TellorStorage.Dispute({
1023             hash: _hash,
1024             isPropFork: true,
1025             reportedMiner: msg.sender, 
1026             reportingParty: msg.sender, 
1027             proposedForkAddress: _propNewTellorAddress,
1028             executed: false,
1029             disputeVotePassed: false,
1030             tally: 0
1031             }); 
1032         self.disputesById[disputeId].disputeUintVars[keccak256("blockNumber")] = block.number;
1033         self.disputesById[disputeId].disputeUintVars[keccak256("fee")]  = self.uintVars[keccak256("disputeFee")];
1034         self.disputesById[disputeId].disputeUintVars[keccak256("minExecutionDate")] = now + 7 days;
1035     }
1036     
1037 
1038     /**
1039     * @dev this function allows the dispute fee to fluctuate based on the number of miners on the system.
1040     * The floor for the fee is 15e18.
1041     */
1042     function updateDisputeFee(TellorStorage.TellorStorageStruct storage self) public {
1043             //if the number of staked miners divided by the target count of staked miners is less than 1
1044             if(self.uintVars[keccak256("stakerCount")]*1000/self.uintVars[keccak256("targetMiners")] < 1000){
1045                 //Set the dispute fee at stakeAmt * (1- stakerCount/targetMiners)
1046                 //or at the its minimum of 15e18 
1047                 self.uintVars[keccak256("disputeFee")] = SafeMath.max(15e18,self.uintVars[keccak256("stakeAmount")].mul(1000 - self.uintVars[keccak256("stakerCount")]*1000/self.uintVars[keccak256("targetMiners")])/1000);
1048             }
1049             else{
1050                 //otherwise set the dispute fee at 15e18 (the floor/minimum fee allowed)
1051                 self.uintVars[keccak256("disputeFee")] = 15e18;
1052             }
1053     }
1054 }
1055 
1056 
1057 /**
1058 * itle Tellor Dispute
1059 * @dev Contais the methods related to miners staking and unstaking. Tellor.sol 
1060 * references this library for function's logic.
1061 */
1062 
1063 library TellorStake {
1064     event NewStake(address indexed _sender);//Emits upon new staker
1065     event StakeWithdrawn(address indexed _sender);//Emits when a staker is now no longer staked
1066     event StakeWithdrawRequested(address indexed _sender);//Emits when a staker begins the 7 day withdraw period
1067 
1068     /*Functions*/
1069     
1070     /**
1071     * @dev This function stakes the five initial miners, sets the supply and all the constant variables.
1072     * This function is called by the constructor function on TellorMaster.sol
1073     */
1074     function init(TellorStorage.TellorStorageStruct storage self) public{
1075         require(self.uintVars[keccak256("decimals")] == 0);
1076         //Give this contract 6000 Tellor Tributes so that it can stake the initial 6 miners
1077         TellorTransfer.updateBalanceAtNow(self.balances[address(this)], 2**256-1 - 6000e18);
1078 
1079         // //the initial 5 miner addresses are specfied below
1080         // //changed payable[5] to 6
1081         address payable[6] memory _initalMiners = [address(0x4c49172A499D18eA3093D59A304eEF63F9754e25),
1082         address(0xbfc157b09346AC15873160710B00ec8d4d520C5a),
1083         address(0xa3792188E76c55b1A649fE5Df77DDd4bFD6D03dB),
1084         address(0xbAF31Bbbba24AF83c8a7a76e16E109d921E4182a),
1085         address(0x8c9841fEaE5Fc2061F2163033229cE0d9DfAbC71),
1086         address(0xc31Ef608aDa4003AaD4D2D1ec2Be72232A9E2A86)];
1087         //Stake each of the 5 miners specified above
1088         for(uint i=0;i<6;i++){//6th miner to allow for dispute
1089             //Miner balance is set at 1000e18 at the block that this function is ran
1090             TellorTransfer.updateBalanceAtNow(self.balances[_initalMiners[i]],1000e18);
1091 
1092             newStake(self, _initalMiners[i]);
1093         }
1094 
1095         //update the total suppply
1096         self.uintVars[keccak256("total_supply")] += 6000e18;//6th miner to allow for dispute
1097         //set Constants
1098         self.uintVars[keccak256("decimals")] = 18;
1099         self.uintVars[keccak256("targetMiners")] = 200;
1100         self.uintVars[keccak256("stakeAmount")] = 1000e18;
1101         self.uintVars[keccak256("disputeFee")] = 970e18;
1102         self.uintVars[keccak256("timeTarget")]= 600;
1103         self.uintVars[keccak256("timeOfLastNewValue")] = now - now  % self.uintVars[keccak256("timeTarget")];
1104         self.uintVars[keccak256("difficulty")] = 1;
1105     }
1106 
1107 
1108     /**
1109     * @dev This function allows stakers to request to withdraw their stake (no longer stake)
1110     * once they lock for withdraw(stakes.currentStatus = 2) they are locked for 7 days before they
1111     * can withdraw the deposit
1112     */
1113     function requestStakingWithdraw(TellorStorage.TellorStorageStruct storage self) public {
1114         TellorStorage.StakeInfo storage stakes = self.stakerDetails[msg.sender];
1115         //Require that the miner is staked
1116         require(stakes.currentStatus == 1);
1117 
1118         //Change the miner staked to locked to be withdrawStake
1119         stakes.currentStatus = 2;
1120 
1121         //Change the startDate to now since the lock up period begins now
1122         //and the miner can only withdraw 7 days later from now(check the withdraw function)
1123         stakes.startDate = now -(now % 86400);
1124 
1125         //Reduce the staker count
1126         self.uintVars[keccak256("stakerCount")] -= 1;
1127         TellorDispute.updateDisputeFee(self);
1128         emit StakeWithdrawRequested(msg.sender);
1129     }
1130 
1131 
1132     /**
1133     * @dev This function allows users to withdraw their stake after a 7 day waiting period from request 
1134     */
1135     function withdrawStake(TellorStorage.TellorStorageStruct storage self) public {
1136         TellorStorage.StakeInfo storage stakes = self.stakerDetails[msg.sender];
1137         //Require the staker has locked for withdraw(currentStatus ==2) and that 7 days have 
1138         //passed by since they locked for withdraw
1139         require(now - (now % 86400) - stakes.startDate >= 7 days);
1140         require(stakes.currentStatus == 2);
1141         stakes.currentStatus = 0;
1142         emit StakeWithdrawn(msg.sender);
1143     }
1144 
1145 
1146     /**
1147     * @dev This function allows miners to deposit their stake.
1148     */
1149     function depositStake(TellorStorage.TellorStorageStruct storage self) public {
1150       newStake(self, msg.sender);
1151       //self adjusting disputeFee
1152       TellorDispute.updateDisputeFee(self);
1153     }
1154 
1155     /**
1156     * @dev This function is used by the init function to succesfully stake the initial 5 miners.
1157     * The function updates their status/state and status start date so they are locked it so they can't withdraw
1158     * and updates the number of stakers in the system.
1159     */
1160     function newStake(TellorStorage.TellorStorageStruct storage self, address staker) internal {
1161         require(TellorTransfer.balanceOf(self,staker) >= self.uintVars[keccak256("stakeAmount")]);
1162         //Ensure they can only stake if they are not currrently staked or if their stake time frame has ended
1163         //and they are currently locked for witdhraw
1164         require(self.stakerDetails[staker].currentStatus == 0 || self.stakerDetails[staker].currentStatus == 2);
1165         self.uintVars[keccak256("stakerCount")] += 1;
1166         self.stakerDetails[staker] = TellorStorage.StakeInfo({
1167             currentStatus: 1,
1168             //this resets their stake start date to today
1169             startDate: now - (now % 86400)
1170         });
1171         emit NewStake(staker);
1172     }
1173 }
1174 
1175 
1176 /**
1177 * @title Tellor Getters
1178 * @dev Oracle contract with all tellor getter functions. The logic for the functions on this contract 
1179 * is saved on the TellorGettersLibrary, TellorTransfer, TellorGettersLibrary, and TellorStake
1180 */
1181 contract TellorGetters{
1182     using SafeMath for uint256;
1183 
1184     using TellorTransfer for TellorStorage.TellorStorageStruct;
1185     using TellorGettersLibrary for TellorStorage.TellorStorageStruct;
1186     using TellorStake for TellorStorage.TellorStorageStruct;
1187 
1188     TellorStorage.TellorStorageStruct tellor;
1189     
1190     /**
1191     * @param _user address
1192     * @param _spender address
1193     * @return Returns the remaining allowance of tokens granted to the _spender from the _user
1194     */
1195     function allowance(address _user, address _spender) external view returns (uint) {
1196        return tellor.allowance(_user,_spender);
1197     }
1198 
1199     /**
1200     * @dev This function returns whether or not a given user is allowed to trade a given amount  
1201     * @param _user address
1202     * @param _amount uint of amount
1203     * @return true if the user is alloed to trade the amount specified
1204     */
1205     function allowedToTrade(address _user,uint _amount) external view returns(bool){
1206         return tellor.allowedToTrade(_user,_amount);
1207     }
1208 
1209     /**
1210     * @dev Gets balance of owner specified
1211     * @param _user is the owner address used to look up the balance
1212     * @return Returns the balance associated with the passed in _user
1213     */
1214     function balanceOf(address _user) external view returns (uint) { 
1215         return tellor.balanceOf(_user);
1216     }
1217 
1218     /**
1219     * @dev Queries the balance of _user at a specific _blockNumber
1220     * @param _user The address from which the balance will be retrieved
1221     * @param _blockNumber The block number when the balance is queried
1222     * @return The balance at _blockNumber
1223     */
1224     function balanceOfAt(address _user, uint _blockNumber) external view returns (uint) {
1225         return tellor.balanceOfAt(_user,_blockNumber);
1226     }
1227 
1228     /**
1229     * @dev This function tells you if a given challenge has been completed by a given miner
1230     * @param _challenge the challenge to search for
1231     * @param _miner address that you want to know if they solved the challenge
1232     * @return true if the _miner address provided solved the 
1233     */
1234     function didMine(bytes32 _challenge, address _miner) external view returns(bool){
1235         return tellor.didMine(_challenge,_miner);
1236     }
1237 
1238 
1239     /**
1240     * @dev Checks if an address voted in a given dispute
1241     * @param _disputeId to look up
1242     * @param _address to look up
1243     * @return bool of whether or not party voted
1244     */
1245     function didVote(uint _disputeId, address _address) external view returns(bool){
1246         return tellor.didVote(_disputeId,_address);
1247     }
1248 
1249 
1250     /**
1251     * @dev allows Tellor to read data from the addressVars mapping
1252     * @param _data is the keccak256("variable_name") of the variable that is being accessed. 
1253     * These are examples of how the variables are saved within other functions:
1254     * addressVars[keccak256("_owner")]
1255     * addressVars[keccak256("tellorContract")]
1256     */
1257     function getAddressVars(bytes32 _data) view external returns(address){
1258         return tellor.getAddressVars(_data);
1259     }
1260 
1261 
1262     /**
1263     * @dev Gets all dispute variables
1264     * @param _disputeId to look up
1265     * @return bytes32 hash of dispute 
1266     * @return bool executed where true if it has been voted on
1267     * @return bool disputeVotePassed
1268     * @return bool isPropFork true if the dispute is a proposed fork
1269     * @return address of reportedMiner
1270     * @return address of reportingParty
1271     * @return address of proposedForkAddress
1272     * @return uint of requestId
1273     * @return uint of timestamp
1274     * @return uint of value
1275     * @return uint of minExecutionDate
1276     * @return uint of numberOfVotes
1277     * @return uint of blocknumber
1278     * @return uint of minerSlot
1279     * @return uint of quorum
1280     * @return uint of fee
1281     * @return int count of the current tally
1282     */
1283     function getAllDisputeVars(uint _disputeId) public view returns(bytes32, bool, bool, bool, address, address, address,uint[9] memory, int){
1284         return tellor.getAllDisputeVars(_disputeId);
1285     }
1286     
1287 
1288     /**
1289     * @dev Getter function for variables for the requestId being currently mined(currentRequestId)
1290     * @return current challenge, curretnRequestId, level of difficulty, api/query string, and granularity(number of decimals requested), total tip for the request 
1291     */
1292     function getCurrentVariables() external view returns(bytes32, uint, uint,string memory,uint,uint){    
1293         return tellor.getCurrentVariables();
1294     }
1295 
1296     /**
1297     * @dev Checks if a given hash of miner,requestId has been disputed
1298     * @param _hash is the sha256(abi.encodePacked(_miners[2],_requestId));
1299     * @return uint disputeId
1300     */
1301     function getDisputeIdByDisputeHash(bytes32 _hash) external view returns(uint){
1302         return  tellor.getDisputeIdByDisputeHash(_hash);
1303     }
1304     
1305 
1306     /**
1307     * @dev Checks for uint variables in the disputeUintVars mapping based on the disuputeId
1308     * @param _disputeId is the dispute id;
1309     * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is 
1310     * the variables/strings used to save the data in the mapping. The variables names are  
1311     * commented out under the disputeUintVars under the Dispute struct
1312     * @return uint value for the bytes32 data submitted
1313     */
1314     function getDisputeUintVars(uint _disputeId,bytes32 _data) external view returns(uint){
1315         return tellor.getDisputeUintVars(_disputeId,_data);
1316     }
1317 
1318 
1319     /**
1320     * @dev Gets the a value for the latest timestamp available
1321     * @return value for timestamp of last proof of work submited
1322     * @return true if the is a timestamp for the lastNewValue
1323     */
1324     function getLastNewValue() external view returns(uint,bool){
1325         return tellor.getLastNewValue();
1326     }
1327 
1328 
1329     /**
1330     * @dev Gets the a value for the latest timestamp available
1331     * @param _requestId being requested
1332     * @return value for timestamp of last proof of work submited and if true if it exist or 0 and false if it doesn't
1333     */
1334     function getLastNewValueById(uint _requestId) external view returns(uint,bool){
1335         return tellor.getLastNewValueById(_requestId);
1336     }
1337         
1338 
1339     /**
1340     * @dev Gets blocknumber for mined timestamp 
1341     * @param _requestId to look up
1342     * @param _timestamp is the timestamp to look up blocknumber
1343     * @return uint of the blocknumber which the dispute was mined
1344     */
1345     function getMinedBlockNum(uint _requestId, uint _timestamp) external view returns(uint){
1346         return tellor.getMinedBlockNum(_requestId,_timestamp);
1347     }
1348 
1349 
1350     /**
1351     * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp 
1352     * @param _requestId to look up
1353     * @param _timestamp is the timestamp to look up miners for
1354     * @return the 5 miners' addresses
1355     */
1356     function getMinersByRequestIdAndTimestamp(uint _requestId, uint _timestamp) external view returns(address[5] memory){
1357         return tellor.getMinersByRequestIdAndTimestamp(_requestId,_timestamp);
1358     }
1359 
1360 
1361     /**
1362     * @dev Get the name of the token
1363     * return string of the token name
1364     */
1365     function getName() external view returns(string memory){
1366         return tellor.getName();
1367     }
1368 
1369 
1370     /**
1371     * @dev Counts the number of values that have been submited for the request 
1372     * if called for the currentRequest being mined it can tell you how many miners have submitted a value for that
1373     * request so far
1374     * @param _requestId the requestId to look up
1375     * @return uint count of the number of values received for the requestId
1376     */
1377     function getNewValueCountbyRequestId(uint _requestId) external view returns(uint){
1378         return tellor.getNewValueCountbyRequestId(_requestId);
1379     }
1380 
1381 
1382     /**
1383     * @dev Getter function for the specified requestQ index
1384     * @param _index to look up in the requestQ array
1385     * @return uint of reqeuestId
1386     */
1387     function getRequestIdByRequestQIndex(uint _index) external view returns(uint){
1388         return tellor.getRequestIdByRequestQIndex(_index);
1389     }
1390 
1391 
1392     /**
1393     * @dev Getter function for requestId based on timestamp 
1394     * @param _timestamp to check requestId
1395     * @return uint of reqeuestId
1396     */
1397     function getRequestIdByTimestamp(uint _timestamp) external view returns(uint){    
1398         return tellor.getRequestIdByTimestamp(_timestamp);
1399     }
1400 
1401     /**
1402     * @dev Getter function for requestId based on the queryHash
1403     * @param _request is the hash(of string api and granularity) to check if a request already exists
1404     * @return uint requestId
1405     */
1406     function getRequestIdByQueryHash(bytes32 _request) external view returns(uint){    
1407         return tellor.getRequestIdByQueryHash(_request);
1408     }
1409 
1410 
1411     /**
1412     * @dev Getter function for the requestQ array
1413     * @return the requestQ arrray
1414     */
1415     function getRequestQ() view public returns(uint[51] memory){
1416         return tellor.getRequestQ();
1417     }
1418 
1419 
1420     /**
1421     * @dev Allowes access to the uint variables saved in the apiUintVars under the requestDetails struct
1422     * for the requestId specified
1423     * @param _requestId to look up
1424     * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is 
1425     * the variables/strings used to save the data in the mapping. The variables names are  
1426     * commented out under the apiUintVars under the requestDetails struct
1427     * @return uint value of the apiUintVars specified in _data for the requestId specified
1428     */
1429     function getRequestUintVars(uint _requestId,bytes32 _data) external view returns(uint){
1430         return tellor.getRequestUintVars(_requestId,_data);
1431     }
1432 
1433 
1434     /**
1435     * @dev Gets the API struct variables that are not mappings
1436     * @param _requestId to look up
1437     * @return string of api to query
1438     * @return string of symbol of api to query
1439     * @return bytes32 hash of string
1440     * @return bytes32 of the granularity(decimal places) requested
1441     * @return uint of index in requestQ array
1442     * @return uint of current payout/tip for this requestId
1443     */
1444     function getRequestVars(uint _requestId) external view returns(string memory, string memory,bytes32,uint, uint, uint) {
1445         return tellor.getRequestVars(_requestId);
1446     }
1447 
1448 
1449     /**
1450     * @dev This function allows users to retireve all information about a staker
1451     * @param _staker address of staker inquiring about
1452     * @return uint current state of staker
1453     * @return uint startDate of staking
1454     */
1455     function getStakerInfo(address _staker) external view returns(uint,uint){
1456         return tellor.getStakerInfo(_staker);
1457     }
1458     
1459     /**
1460     * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp 
1461     * @param _requestId to look up
1462     * @param _timestamp is the timestampt to look up miners for
1463     * @return address[5] array of 5 addresses ofminers that mined the requestId
1464     */    
1465     function getSubmissionsByTimestamp(uint _requestId, uint _timestamp) external view returns(uint[5] memory){
1466         return tellor.getSubmissionsByTimestamp(_requestId,_timestamp);
1467     }
1468 
1469     /**
1470     * @dev Get the symbol of the token
1471     * return string of the token symbol
1472     */
1473     function getSymbol() external view returns(string memory){
1474         return tellor.getSymbol();
1475     } 
1476 
1477     /**
1478     * @dev Gets the timestamp for the value based on their index
1479     * @param _requestID is the requestId to look up
1480     * @param _index is the value index to look up
1481     * @return uint timestamp
1482     */
1483     function getTimestampbyRequestIDandIndex(uint _requestID, uint _index) external view returns(uint){
1484         return tellor.getTimestampbyRequestIDandIndex(_requestID,_index);
1485     }
1486 
1487 
1488     /**
1489     * @dev Getter for the variables saved under the TellorStorageStruct uintVars variable
1490     * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is 
1491     * the variables/strings used to save the data in the mapping. The variables names are  
1492     * commented out under the uintVars under the TellorStorageStruct struct
1493     * This is an example of how data is saved into the mapping within other functions: 
1494     * self.uintVars[keccak256("stakerCount")]
1495     * @return uint of specified variable  
1496     */ 
1497     function getUintVar(bytes32 _data) view public returns(uint){
1498         return tellor.getUintVar(_data);
1499     }
1500 
1501 
1502     /**
1503     * @dev Getter function for next requestId on queue/request with highest payout at time the function is called
1504     * @return onDeck/info on request with highest payout-- RequestId, Totaltips, and API query string
1505     */
1506     function getVariablesOnDeck() external view returns(uint, uint,string memory){    
1507         return tellor.getVariablesOnDeck();
1508     }
1509 
1510     
1511     /**
1512     * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp 
1513     * @param _requestId to look up
1514     * @param _timestamp is the timestamp to look up miners for
1515     * @return bool true if requestId/timestamp is under dispute
1516     */
1517     function isInDispute(uint _requestId, uint _timestamp) external view returns(bool){
1518         return tellor.isInDispute(_requestId,_timestamp);
1519     }
1520     
1521 
1522     /**
1523     * @dev Retreive value from oracle based on timestamp
1524     * @param _requestId being requested
1525     * @param _timestamp to retreive data/value from
1526     * @return value for timestamp submitted
1527     */
1528     function retrieveData(uint _requestId, uint _timestamp) external view returns (uint) {
1529         return tellor.retrieveData(_requestId,_timestamp);
1530     }
1531 
1532 
1533     /**
1534     * @dev Getter for the total_supply of oracle tokens
1535     * @return uint total supply
1536     */
1537     function totalSupply() external view returns (uint) {
1538        return tellor.totalSupply();
1539     }
1540 
1541 
1542 }
1543 
1544 /**
1545 * @title Tellor Master
1546 * @dev This is the Master contract with all tellor getter functions and delegate call to Tellor. 
1547 * The logic for the functions on this contract is saved on the TellorGettersLibrary, TellorTransfer, 
1548 * TellorGettersLibrary, and TellorStake
1549 */
1550 contract TellorMaster is TellorGetters{
1551     
1552     event NewTellorAddress(address _newTellor);
1553 
1554     /**
1555     * @dev The constructor sets the original `tellorStorageOwner` of the contract to the sender
1556     * account, the tellor contract to the Tellor master address and owner to the Tellor master owner address 
1557     * @param _tellorContract is the address for the tellor contract
1558     */
1559     constructor (address _tellorContract)  public{
1560         tellor.init();
1561         tellor.addressVars[keccak256("_owner")] = msg.sender;
1562         tellor.addressVars[keccak256("_deity")] = msg.sender;
1563         tellor.addressVars[keccak256("tellorContract")]= _tellorContract;
1564         emit NewTellorAddress(_tellorContract);
1565     }
1566     
1567 
1568     /**
1569     * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp 
1570     * @dev Only needs to be in library
1571     * @param _newDeity the new Deity in the contract
1572     */
1573 
1574     function changeDeity(address _newDeity) external{
1575         tellor.changeDeity(_newDeity);
1576     }
1577 
1578 
1579     /**
1580     * @dev  allows for the deity to make fast upgrades.  Deity should be 0 address if decentralized
1581     * @param _tellorContract the address of the new Tellor Contract
1582     */
1583     function changeTellorContract(address _tellorContract) external{
1584         tellor.changeTellorContract(_tellorContract);
1585     }
1586   
1587 
1588     /**
1589     * @dev This is the fallback function that allows contracts to call the tellor contract at the address stored
1590     */
1591     function () external payable {
1592         address addr = tellor.addressVars[keccak256("tellorContract")];
1593         bytes memory _calldata = msg.data;
1594         assembly {
1595             let result := delegatecall(not(0), addr, add(_calldata, 0x20), mload(_calldata), 0, 0)
1596             let size := returndatasize
1597             let ptr := mload(0x40)
1598             returndatacopy(ptr, 0, size)
1599             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
1600             // if the call returned error data, forward it
1601             switch result case 0 { revert(ptr, size) }
1602             default { return(ptr, size) }
1603         }
1604     }
1605 }