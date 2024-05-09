1 pragma solidity ^0.4.23;
2 
3 /* Team Littafi
4 **/
5 
6  
7 /**
8  * Math operations with safety checks
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) public pure returns (uint256) {
12      if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert( c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) public pure returns (uint256) {
21     //assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     //assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) public pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) public pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 
38   function max64(uint64 a, uint64 b) public pure returns (uint64) {
39     return a >= b ? a : b;
40   }
41 
42   function min64(uint64 a, uint64 b) public pure returns (uint64) {
43     return a < b ? a : b;
44   }
45 
46   function max256(uint256 a, uint256 b) external pure returns (uint256) {
47     return a >= b ? a : b;
48   }
49 
50   function min256(uint256 a, uint256 b) external pure returns (uint256) {
51     return a < b ? a : b;
52   }
53 
54 }
55 
56 
57  contract LittafiOwned {
58     address public owner;
59     address public newOwner;
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62      constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) onlyOwner public{
72         newOwner = _newOwner;
73     }
74 
75     function acceptOnwership() public {
76         require(msg.sender == newOwner);
77         emit OwnershipTransferred(owner,newOwner);
78         owner=newOwner;
79         newOwner=address(0);
80     }
81 
82 }
83 
84  contract Littafi is LittafiOwned{
85 
86       using SafeMath for uint256;
87 
88       uint256   public littID=0;
89       uint256   public littClientId=1;
90       bool      public sentinel=true;
91       uint256   public littafiAccount=0;
92       uint256   public littAdmins;
93 
94       littafiContents[] public littafi;
95 
96       mapping(bytes32 => address) littClientAddress;
97 
98       mapping(bytes32 => string)  littIPFS;
99 
100       mapping(bytes32 => uint256) littHashID;
101 
102       mapping(bytes32 => uint256) littCapsule;
103 
104       mapping(address => littafiAdmin) admins;
105 
106       mapping(address => littafiSubscribtion) subscriber;
107 
108       mapping(address => bool) subscriberStatus;
109 
110       mapping(uint256 => address) poolAdmin;
111 
112       mapping(uint256 => address) setPoolAdmin;
113 
114       mapping(address => bool) isDelegateAdmin;
115 
116       mapping(uint256 => string)  poolName;
117 
118       mapping(address => bytes32[]) subscriberContentHashes;
119 
120       mapping(address => uint256)  subscriberContentCount;
121       
122       mapping(address => bool) transferred;
123 
124       struct littafiContents{
125           uint256 id;
126           bytes32 hash;
127           string  ipfs;
128           string timestamp;
129           string  metadata;
130           string  unique;
131           uint256 clientPool;
132           bool    access;
133       }
134 
135       struct littafiAdmin{
136           uint256 poolID;
137           bool isAdmin;
138           string poolName;
139       }
140 
141       struct littafiSubscribtion{
142           uint256 subID;
143           uint256 clientPool;
144       }
145 
146       modifier onlyLittafiAdmin(uint256 _poolID){
147           require(admins[msg.sender].isAdmin == true && admins[msg.sender].poolID == _poolID && msg.sender != owner);
148           _;
149       }
150 
151       modifier onlyLittafiSubscribed(){
152           require(msg.value > 0 && subscriber[msg.sender].subID > 0 && msg.sender != owner);
153           _;
154       }
155 
156       modifier onlyLittafiNonSubscribed(){
157           require(msg.value > 0 && subscriber[msg.sender].subID == 0 && msg.sender != owner);
158           _;
159       }
160 
161       modifier onlyDelegate(){
162           require(msg.sender == owner || isDelegateAdmin[msg.sender] == true);
163           _;
164       }
165 
166       modifier onlyLittafiContentOwner(bytes32 _hash){
167           require(msg.sender == littClientAddress[_hash]);
168           _;
169       }
170 
171       event littContent(address indexed _address,bytes32 _hash, string _ipfs, string _timestamp, string _metadata, string unique, uint256 _poolID, bool _access, bool success);
172 
173       event littClientSubscribed(address indexed _address, string _timestamp,uint256 _fee,uint256 _poolID,bool success);
174 
175       event littafiAssignedID(address indexed _adminAddress, string _timestamp, uint256 _poolID, address indexed _address);
176 
177       event littafiAdminReassigned(address indexed _previousAdmin,address indexed _newAdmin,string _timestamp,uint256 _assignedID);
178 
179       event littafiDelegateAdmin(address indexed _admin, address indexed _delegate,bool _state,string _timestamp);
180 
181       event littContentAccessModified(address indexed _admin,bytes32 _hash, uint256 _poolID,bool _access);
182 
183       event littPoolModified(address indexed _address,string _poolName,uint256 _poolID);
184 
185       event littContentOwnershipTransferred(bytes32 _hash, address indexed _address, string _timestamp);
186 
187       constructor() public{
188           LittafiOwned(msg.sender);
189       }
190 
191       function subscribtionLittafi(uint256 _assignedID,string _timestamp, string _poolName) public payable onlyLittafiNonSubscribed(){
192 
193           if(_assignedID > 0 && setPoolAdmin[_assignedID] == msg.sender){
194              subscriber[msg.sender].subID=littClientId;
195              subscriber[msg.sender].clientPool=_assignedID;
196              subscriberStatus[msg.sender]=true;
197              admins[msg.sender].poolID=_assignedID;
198              admins[msg.sender].isAdmin=true;
199              admins[msg.sender].poolName=_poolName;
200              poolAdmin[_assignedID]=msg.sender;
201              poolName[_assignedID]=_poolName;
202              littClientId++;
203              littAdmins++;
204              owner.transfer(msg.value);
205              littafiAccount.add(msg.value);
206 
207              emit littClientSubscribed(msg.sender,_timestamp,msg.value,_assignedID,true);
208              return;
209           }else{
210               subscriber[msg.sender].subID=littClientId;
211               subscriber[msg.sender].clientPool=0;
212               subscriberStatus[msg.sender]=true;
213               littClientId++;
214               owner.transfer(msg.value);
215 
216               emit littClientSubscribed(msg.sender,_timestamp,msg.value,0,true);
217               return;
218           }
219       }
220 
221       function littafiContentCommit(bytes32 _hash,string _ipfs,string _timestamp,string _metadata,string _unique,bool _sentinel) public payable onlyLittafiSubscribed(){
222 
223              uint256 id=littHashID[_hash];
224              if (littClientAddress[_hash] != address(0)){
225                 emit littContent(littClientAddress[_hash],_hash,littIPFS[_hash],littafi[id].timestamp,littafi[id].metadata,littafi[id].unique,littafi[id].clientPool,littafi[id].access,true);
226                 return;
227              }else{
228 
229               if(admins[msg.sender].isAdmin == true) sentinel=_sentinel;
230 
231               littafiContents memory commit=littafiContents(littID,_hash,_ipfs,_timestamp,_metadata,_unique,subscriber[msg.sender].clientPool,sentinel);
232               littafi.push(commit);
233 
234               subscriberContentCount[msg.sender]++;
235               subscriberContentHashes[msg.sender].push(_hash);
236               littClientAddress[_hash]=msg.sender;
237               littIPFS[_hash]=_ipfs;
238               littHashID[_hash]=littID;
239               littID++;
240               owner.transfer(msg.value);
241 
242               emit littContent(msg.sender,_hash,_ipfs,_timestamp,_metadata,_unique,subscriber[msg.sender].clientPool,sentinel,true);
243               return;
244              }
245 
246       }
247 
248       function littafiTimeCapsule(bytes32 _hash,string _ipfs,string _timestamp,string _metadata,string _unique,uint256 _capsuleRelease) public payable onlyLittafiSubscribed(){
249 
250              uint256 id=littHashID[_hash];
251              if (littClientAddress[_hash] != address(0)){
252                 emit littContent(littClientAddress[_hash],_hash,littIPFS[_hash],littafi[id].timestamp,littafi[id].metadata,littafi[id].unique,littafi[id].clientPool,littafi[id].access,true);
253                 return;
254              }else{
255 
256               littafiContents memory commit=littafiContents(littID,_hash,_ipfs,_timestamp,_metadata,_unique,subscriber[msg.sender].clientPool,sentinel);
257               littafi.push(commit);
258 
259               subscriberContentCount[msg.sender]++;
260               littCapsule[_hash]=_capsuleRelease;
261               littClientAddress[_hash]=msg.sender;
262               littIPFS[_hash]=_ipfs;
263               littHashID[_hash]=littID;
264               littID++;
265               owner.transfer(msg.value);
266 
267               emit littContent(msg.sender,_hash,_ipfs,_timestamp,_metadata,_unique,subscriber[msg.sender].clientPool,sentinel,true);
268               return;
269              }
270 
271       }
272 
273       function transferContentOwnership(bytes32 _hash, address _address, string _timestamp) public {
274           require(littClientAddress[_hash] == msg.sender);
275           littClientAddress[_hash]=_address;
276           emit littContentOwnershipTransferred(_hash,_address,_timestamp);
277           return;
278       }
279 
280       function getLittafiContent(bytes32 _hash,uint256 _poolID) public payable{
281         if (littClientAddress[_hash] != address(0) && littafi[littHashID[_hash]].clientPool==_poolID){
282             owner.transfer(msg.value);
283             emit littContent(littClientAddress[_hash],_hash,littIPFS[_hash],littafi[littHashID[_hash]].timestamp,littafi[littHashID[_hash]].metadata,littafi[littHashID[_hash]].unique,littafi[littHashID[_hash]].clientPool,littafi[littHashID[_hash]].access,true);
284             return;
285         }
286       }
287 
288       function setDelegateAdmin(address _address, string _timestamp, bool _state) public onlyOwner() returns(bool){
289           require(admins[_address].isAdmin == false);
290           isDelegateAdmin[_address]=_state;
291           emit littafiDelegateAdmin(msg.sender,_address,_state,_timestamp);
292           return true;
293       }
294 
295       function setAssignedID(address _address,uint256 _assignedID, string _timestamp) public onlyDelegate(){
296           require(setPoolAdmin[_assignedID] == address(0));
297           setPoolAdmin[_assignedID]=_address;
298           emit littafiAssignedID(msg.sender,_timestamp,_assignedID,_address);
299           return;
300       }
301 
302       function changeAssignedAdmin(address _newAdmin, uint256 _assignedID, string _timestamp) public onlyOwner(){
303           address _previousAdmin=poolAdmin[_assignedID];
304 
305           admins[_previousAdmin].isAdmin=false;
306           admins[_previousAdmin].poolID=0;
307           subscriber[_previousAdmin].clientPool=0;
308 
309           if(!subscriberStatus[_newAdmin])
310              subscriber[_newAdmin].subID=littID;
311              subscriber[_newAdmin].clientPool=_assignedID;
312 
313           admins[_newAdmin].isAdmin=true;
314           admins[_newAdmin].poolID=_assignedID;
315           littID++;
316 
317           emit littafiAdminReassigned(_previousAdmin,_newAdmin,_timestamp,_assignedID);
318           return;
319       }
320 
321       function getPoolAdmin(uint256 _poolID) public view onlyDelegate() returns(address){
322           return poolAdmin[_poolID];
323       }
324 
325       function modifyContentAccess(bytes32 _hash, bool _access, uint256 _poolID)public onlyLittafiAdmin(_poolID){
326          littafi[littHashID[_hash]].access=_access;
327          emit littContentAccessModified(msg.sender,_hash,_poolID,_access);
328          return;
329       }
330 
331       function getClientCount() public view returns(uint256){
332           return littClientId;
333       }
334 
335       function getContentCount() public view returns(uint256){
336           return littID;
337       }
338 
339       function getLittAdminCount() public view onlyDelegate() returns(uint256){
340           return littAdmins;
341       }
342 
343       function setPoolName(string _poolName,uint256 _poolID) public onlyLittafiAdmin(_poolID){
344           admins[msg.sender].poolName=_poolName;
345           emit littPoolModified(msg.sender,_poolName,_poolID);
346           return;
347       }
348 
349       function getPoolName(uint256 _poolID) public view onlyLittafiAdmin(_poolID) returns(string){
350           return admins[msg.sender].poolName;
351       }
352 
353       function getPoolNameByID(uint256 _poolID) public view returns(string){
354           return poolName[_poolID];
355       }
356 
357       function getPoolID() public view returns(uint256){
358           return subscriber[msg.sender].clientPool;
359       }
360 
361       function getSubscriberType() public view returns(bool){
362           return admins[msg.sender].isAdmin;
363       }
364 
365       function getSubscriberStatus() public view returns(bool){
366           return subscriberStatus[msg.sender];
367       }
368 
369       function getSubscriberContentCount() public view returns(uint256){
370           return subscriberContentCount[msg.sender];
371       }
372 
373       function getSubscriberContentHashes() public view returns(bytes32[]){
374           return subscriberContentHashes[msg.sender];
375       }
376 
377       function getDelegate() public view returns(bool){
378           return isDelegateAdmin[msg.sender];
379       }
380 
381       function littContentExists(bytes32 _hash) public view returns(bool){
382           return littClientAddress[_hash] == address(0) ? false : true;
383       }
384 
385       function littPoolIDExists(uint256 _poolID) public view returns(bool){
386           return poolAdmin[_poolID] == address(0) ? false : true;
387       }
388 
389       function littIsCapsule(bytes32 _hash) public view returns(bool){
390           return littCapsule[_hash] == 0 ? false : true;
391       }
392 
393       function littCapsuleGet(bytes32 _hash) public view returns(uint256){
394           return littIsCapsule(_hash) == true ? littCapsule[_hash] : 0;
395       }
396       
397 }