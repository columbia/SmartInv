1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      * @notice Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 /**
76  * @title Roles
77  * @dev Library for managing addresses assigned to a Role.
78  */
79 library Roles {
80     struct Role {
81         mapping (address => bool) bearer;
82     }
83 
84     /**
85      * @dev give an account access to this role
86      */
87     function add(Role storage role, address account) internal {
88         require(account != address(0));
89         require(!has(role, account));
90 
91         role.bearer[account] = true;
92     }
93 
94     /**
95      * @dev remove an account's access to this role
96      */
97     function remove(Role storage role, address account) internal {
98         require(account != address(0));
99         require(has(role, account));
100 
101         role.bearer[account] = false;
102     }
103 
104     /**
105      * @dev check if an account has this role
106      * @return bool
107      */
108     function has(Role storage role, address account) internal view returns (bool) {
109         require(account != address(0));
110         return role.bearer[account];
111     }
112 }
113 
114 contract PauserRole {
115     using Roles for Roles.Role;
116 
117     event PauserAdded(address indexed account);
118     event PauserRemoved(address indexed account);
119 
120     Roles.Role private _pausers;
121 
122     constructor () internal {
123         _addPauser(msg.sender);
124     }
125 
126     modifier onlyPauser() {
127         require(isPauser(msg.sender));
128         _;
129     }
130 
131     function isPauser(address account) public view returns (bool) {
132         return _pausers.has(account);
133     }
134 
135     function addPauser(address account) public onlyPauser {
136         _addPauser(account);
137     }
138 
139     function renouncePauser() public {
140         _removePauser(msg.sender);
141     }
142 
143     function _addPauser(address account) internal {
144         _pausers.add(account);
145         emit PauserAdded(account);
146     }
147 
148     function _removePauser(address account) internal {
149         _pausers.remove(account);
150         emit PauserRemoved(account);
151     }
152 }
153 
154 /**
155  * @title Pausable
156  * @dev Base contract which allows children to implement an emergency stop mechanism.
157  */
158 contract Pausable is PauserRole {
159     event Paused(address account);
160     event Unpaused(address account);
161 
162     bool private _paused;
163 
164     constructor () internal {
165         _paused = false;
166     }
167 
168     /**
169      * @return true if the contract is paused, false otherwise.
170      */
171     function paused() public view returns (bool) {
172         return _paused;
173     }
174 
175     /**
176      * @dev Modifier to make a function callable only when the contract is not paused.
177      */
178     modifier whenNotPaused() {
179         require(!_paused);
180         _;
181     }
182 
183     /**
184      * @dev Modifier to make a function callable only when the contract is paused.
185      */
186     modifier whenPaused() {
187         require(_paused);
188         _;
189     }
190 
191     /**
192      * @dev called by the owner to pause, triggers stopped state
193      */
194     function pause() public onlyPauser whenNotPaused {
195         _paused = true;
196         emit Paused(msg.sender);
197     }
198 
199     /**
200      * @dev called by the owner to unpause, returns to normal state
201      */
202     function unpause() public onlyPauser whenPaused {
203         _paused = false;
204         emit Unpaused(msg.sender);
205     }
206 }
207 
208 /** @title ProofBox. */
209 contract ProofBox is Ownable, Pausable {
210 
211     struct Device {
212       uint index;
213       address deviceOwner;
214       address txOriginator;
215 
216     }
217 
218     mapping (bytes32 => Device) private deviceMap;
219     mapping (address => bool) public authorized;
220     bytes32[] public deviceIds;
221 
222 
223 
224     event deviceCreated(bytes32 indexed deviceId, address indexed deviceOwner);
225     event txnCreated(bytes32 indexed deviceId, address indexed txnOriginator);
226     event deviceProof(bytes32 indexed deviceId, address indexed deviceOwner);
227     event deviceTransfer(bytes32 indexed deviceId, address indexed fromOwner, address indexed toOwner);
228     event deviceMessage(bytes32 indexed deviceId, address indexed deviceOwner, address indexed txnOriginator, string messageToWrite);
229     event deviceDestruct(bytes32 indexed deviceId, address indexed deviceOwner);
230     event ipfsHashtoAddress(bytes32 indexed deviceId, address indexed ownerAddress, string ipfskey);
231 
232 
233 
234     /** @dev Checks to see if device exist
235       * @param _deviceId ID of the device.
236       * @return isIndeed True if the device ID exists.
237       */
238     function isDeviceId(bytes32 _deviceId)
239        public
240        view
241        returns(bool isIndeed)
242      {
243        if(deviceIds.length == 0) return false;
244        return (deviceIds[deviceMap[_deviceId].index] == _deviceId);
245      }
246 
247     /** @dev returns the index of stored deviceID
248       * @param _deviceId ID of the device.
249       * @return _index index of the device.
250       */
251     function getDeviceId(bytes32 _deviceId)
252        public
253        view
254        deviceIdExist(_deviceId)
255        returns(uint _index)
256      {
257        return deviceMap[_deviceId].index;
258      }
259 
260      /** @dev returns address of device owner
261        * @param _deviceId ID of the device.
262        * @return deviceOwner device owner's address
263        */
264       function getOwnerByDevice(bytes32 _deviceId)
265            public
266            view
267            returns (address deviceOwner){
268 
269                return deviceMap[_deviceId].deviceOwner;
270 
271       }
272 
273       /** @dev returns up to 10 devices for the device owner
274         * @return _deviceIds device ID's of the owner
275         */
276       function getDevicesByOwner(bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
277               public
278               view
279               returns(bytes32[10] memory _deviceIds) {
280 
281           address signer = ecrecover(_message, _v, _r, _s);
282           uint numDevices;
283           bytes32[10] memory devicesByOwner;
284 
285           for(uint i = 0; i < deviceIds.length; i++) {
286 
287               if(addressEqual(deviceMap[deviceIds[i]].deviceOwner,signer)) {
288 
289                   devicesByOwner[numDevices] = deviceIds[i];
290                   if (numDevices == 10) {
291                     break;
292                   }
293                   numDevices++;
294 
295               }
296 
297           }
298 
299           return devicesByOwner;
300       }
301 
302       /** @dev returns up to 10 transactions of device owner
303         * @return _deviceIds device ID's of the msg.sender transactions
304         */
305       function getDevicesByTxn(bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
306               public
307               view
308               returns(bytes32[10] memory _deviceIds) {
309 
310           address signer = ecrecover(_message, _v, _r, _s);
311           uint numDevices;
312           bytes32[10] memory devicesByTxOriginator;
313 
314           for(uint i = 0; i < deviceIds.length; i++) {
315 
316               if(addressEqual(deviceMap[deviceIds[i]].txOriginator,signer)) {
317 
318                   devicesByTxOriginator[numDevices] = deviceIds[i];
319                   if (numDevices == 10) {
320                     break;
321                   }
322                   numDevices++;
323 
324               }
325 
326           }
327 
328           return devicesByTxOriginator;
329       }
330 
331 
332       modifier deviceIdExist(bytes32 _deviceId){
333           require(isDeviceId(_deviceId));
334           _;
335       }
336 
337       modifier deviceIdNotExist(bytes32 _deviceId){
338           require(!isDeviceId(_deviceId));
339           _;
340       }
341 
342       modifier authorizedUser() {
343           require(authorized[msg.sender] == true);
344           _;
345       }
346 
347       constructor() public {
348 
349           authorized[msg.sender]=true;
350       }
351 
352 
353     /** @dev when a new device ID is registered by a proxy owner by sending device owner signature
354       * @param _deviceId ID of the device.
355       * @return index of stored device
356       */
357     function registerProof (bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
358          public
359          whenNotPaused()
360          authorizedUser()
361          deviceIdNotExist(_deviceId)
362          returns(uint index) {
363 
364             address signer = ecrecover(_message, _v, _r, _s);
365 
366             deviceMap[_deviceId].deviceOwner = signer;
367             deviceMap[_deviceId].txOriginator = signer;
368             deviceMap[_deviceId].index = deviceIds.push(_deviceId)-1;
369 
370             emit deviceCreated(_deviceId, signer);
371 
372             return deviceIds.length-1;
373 
374     }
375 
376     /** @dev returns true if delete is successful
377       * @param _deviceId ID of the device.
378       * @return bool delete
379       */
380     function destructProof(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
381             public
382             whenNotPaused()
383             authorizedUser()
384             deviceIdExist(_deviceId)
385             returns(bool success) {
386 
387                 address signer = ecrecover(_message, _v, _r, _s);
388 
389                 require(deviceMap[_deviceId].deviceOwner == signer);
390 
391                 uint rowToDelete = deviceMap[_deviceId].index;
392                 bytes32 keyToMove = deviceIds[deviceIds.length-1];
393                 deviceIds[rowToDelete] = keyToMove;
394                 deviceMap[keyToMove].index = rowToDelete;
395                 deviceIds.length--;
396 
397                 emit deviceDestruct(_deviceId, signer);
398                 return true;
399 
400     }
401 
402     /** @dev returns request transfer of device
403       * @param _deviceId ID of the device.
404       * @return index of stored device
405       */
406     function requestTransfer(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
407           public
408           whenNotPaused()
409           deviceIdExist(_deviceId)
410           authorizedUser()
411           returns(uint index) {
412 
413             address signer = ecrecover(_message, _v, _r, _s);
414 
415             deviceMap[_deviceId].txOriginator=signer;
416 
417             emit txnCreated(_deviceId, signer);
418 
419             return deviceMap[_deviceId].index;
420 
421     }
422 
423     /** @dev returns approve transfer of device
424       * @param _deviceId ID of the device.
425       * @return bool approval
426       */
427     function approveTransfer (bytes32 _deviceId, address newOwner, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
428             public
429             whenNotPaused()
430             deviceIdExist(_deviceId)
431             authorizedUser()
432             returns(bool) {
433 
434                 address signer = ecrecover(_message, _v, _r, _s);
435 
436                 require(deviceMap[_deviceId].deviceOwner == signer);
437                 require(deviceMap[_deviceId].txOriginator == newOwner);
438 
439                 deviceMap[_deviceId].deviceOwner=newOwner;
440 
441                 emit deviceTransfer(_deviceId, signer, deviceMap[_deviceId].deviceOwner);
442 
443                 return true;
444 
445     }
446 
447     /** @dev returns write message success
448       * @param _deviceId ID of the device.
449       * @return bool true when write message is successful
450       */
451     function writeMessage (bytes32 _deviceId, string memory messageToWrite, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
452             public
453             whenNotPaused()
454             deviceIdExist(_deviceId)
455             authorizedUser()
456             returns(bool) {
457                 address signer = ecrecover(_message, _v, _r, _s);
458                 require(deviceMap[_deviceId].deviceOwner == signer);
459                 emit deviceMessage(_deviceId, deviceMap[_deviceId].deviceOwner, signer, messageToWrite);
460 
461                 return true;
462 
463     }
464 
465     /** @dev returns request proof of device
466       * @param _deviceId ID of the device.
467       * @return _index info of that device
468       */
469      function requestProof(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
470          public
471          whenNotPaused()
472          deviceIdExist(_deviceId)
473          authorizedUser()
474          returns(uint _index) {
475 
476              address signer = ecrecover(_message, _v, _r, _s);
477 
478              deviceMap[_deviceId].txOriginator=signer;
479 
480              emit txnCreated(_deviceId, signer);
481 
482              return deviceMap[_deviceId].index;
483      }
484 
485 
486      /** @dev returns approve proof of device
487        * @param _deviceId ID of the device.
488        * @return bool  - approval
489        */
490      function approveProof(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
491              public
492              whenNotPaused()
493              deviceIdExist(_deviceId)
494              authorizedUser()
495              returns(bool) {
496 
497                   address signer = ecrecover(_message, _v, _r, _s);
498                   deviceMap[_deviceId].txOriginator=signer;
499                   require(deviceMap[_deviceId].deviceOwner == signer);
500 
501                   emit deviceProof(_deviceId, signer);
502                   return true;
503      }
504 
505      /** @dev updates IPFS hash into device owner public address
506        * @param ipfskey -  ipfs hash for attachment.
507        */
508      function emitipfskey(bytes32 _deviceId, address ownerAddress, string memory ipfskey)
509               public
510               whenNotPaused()
511               deviceIdExist(_deviceId)
512               authorizedUser() {
513         emit ipfsHashtoAddress(_deviceId, ownerAddress, ipfskey);
514     }
515 
516     /** @dev Updates Authorization status of an address for executing functions
517     * on this contract
518     * @param target Address that will be authorized or not authorized
519     * @param isAuthorized New authorization status of address
520     */
521     function changeAuthStatus(address target, bool isAuthorized)
522             public
523             whenNotPaused()
524             onlyOwner() {
525 
526               authorized[target] = isAuthorized;
527     }
528 
529     /** @dev Updates Authorization status of an address for executing functions
530     * on this contract
531     * @param targets Address that will be authorized or not authorized in bulk
532     * @param isAuthorized New registration status of address
533     */
534     function changeAuthStatuses(address[] memory targets, bool isAuthorized)
535             public
536             whenNotPaused()
537             onlyOwner() {
538               for (uint i = 0; i < targets.length; i++) {
539                 changeAuthStatus(targets[i], isAuthorized);
540               }
541     }
542 
543     /*
544         NOTE: We explicitly do not define a fallback function, because there are
545         no ethers received by any funtion on this contract
546 
547     */
548 
549     //Helper Functions
550 
551     /** @dev compares two String equal or not
552       * @param a first string, b second string.
553       * @return bool true if match
554       */
555     function bytesEqual(bytes32 a, bytes32 b) private pure returns (bool) {
556        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
557      }
558 
559    /** @dev compares two address equal or not
560      * @param a first address, b second address.
561      * @return bool true if match
562      */
563    function addressEqual(address a, address b) private pure returns (bool) {
564       return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
565     }
566 
567 }