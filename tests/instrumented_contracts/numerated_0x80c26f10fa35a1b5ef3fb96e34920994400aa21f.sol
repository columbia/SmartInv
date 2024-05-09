1 /**
2  * LockRule.sol
3  * Rule to lock all tokens on a schedule and define a whitelist of exceptions.
4 
5  * More info about MPS : https://github.com/MtPelerin/MtPelerin-share-MPS
6 
7  * The unflattened code is available through this github tag:
8  * https://github.com/MtPelerin/MtPelerin-protocol/tree/etherscan-verify-batch-2
9 
10  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
11 
12  * @notice All matters regarding the intellectual property of this code 
13  * @notice or software are subject to Swiss Law without reference to its 
14  * @notice conflicts of law rules.
15 
16  * @notice License for each contract is available in the respective file
17  * @notice or in the LICENSE.md file.
18  * @notice https://github.com/MtPelerin/
19 
20  * @notice Code by OpenZeppelin is copyrighted and licensed on their repository:
21  * @notice https://github.com/OpenZeppelin/openzeppelin-solidity
22  */
23 
24 
25  pragma solidity ^0.4.24;
26 
27 // File: contracts/zeppelin/ownership/Ownable.sol
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipRenounced(address indexed previousOwner);
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   constructor() public {
50     owner = msg.sender;
51   }
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to relinquish control of the contract.
63    */
64   function renounceOwnership() public onlyOwner {
65     emit OwnershipRenounced(owner);
66     owner = address(0);
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address _newOwner) public onlyOwner {
74     _transferOwnership(_newOwner);
75   }
76 
77   /**
78    * @dev Transfers control of the contract to a newOwner.
79    * @param _newOwner The address to transfer ownership to.
80    */
81   function _transferOwnership(address _newOwner) internal {
82     require(_newOwner != address(0));
83     emit OwnershipTransferred(owner, _newOwner);
84     owner = _newOwner;
85   }
86 }
87 
88 // File: contracts/Authority.sol
89 
90 /**
91  * @title Authority
92  * @dev The Authority contract has an authority address, and provides basic authorization control
93  * functions, this simplifies the implementation of "user permissions".
94  * Authority means to represent a legal entity that is entitled to specific rights
95  *
96  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
97  *
98  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
99  * @notice Please refer to the top of this file for the license.
100  *
101  * Error messages
102  * AU01: Message sender must be an authority
103  */
104 contract Authority is Ownable {
105 
106   address authority;
107 
108   /**
109    * @dev Throws if called by any account other than the authority.
110    */
111   modifier onlyAuthority {
112     require(msg.sender == authority, "AU01");
113     _;
114   }
115 
116   /**
117    * @dev Returns the address associated to the authority
118    */
119   function authorityAddress() public view returns (address) {
120     return authority;
121   }
122 
123   /** Define an address as authority, with an arbitrary name included in the event
124    * @dev returns the authority of the
125    * @param _name the authority name
126    * @param _address the authority address.
127    */
128   function defineAuthority(string _name, address _address) public onlyOwner {
129     emit AuthorityDefined(_name, _address);
130     authority = _address;
131   }
132 
133   event AuthorityDefined(
134     string name,
135     address _address
136   );
137 }
138 
139 // File: contracts/interface/IRule.sol
140 
141 /**
142  * @title IRule
143  * @dev IRule interface
144  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
145  *
146  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
147  * @notice Please refer to the top of this file for the license.
148  **/
149 interface IRule {
150   function isAddressValid(address _address) external view returns (bool);
151   function isTransferValid(address _from, address _to, uint256 _amount)
152     external view returns (bool);
153 }
154 
155 // File: contracts/rule/LockRule.sol
156 
157 /**
158  * @title LockRule
159  * @dev LockRule contract
160  * This rule allow to lock assets for a period of time
161  * for event such as investment vesting
162  *
163  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
164  *
165  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
166  * @notice Please refer to the top of this file for the license.
167  *
168  * Error messages
169  * LOR01: definePass() call have failed
170  * LOR02: startAt must be before or equal to endAt
171  */
172 contract LockRule is IRule, Authority {
173 
174   enum Direction {
175     NONE,
176     RECEIVE,
177     SEND,
178     BOTH
179   }
180 
181   struct ScheduledLock {
182     Direction restriction;
183     uint256 startAt;
184     uint256 endAt;
185     bool scheduleInverted;
186   }
187 
188   mapping(address => Direction) individualPasses;
189   ScheduledLock lock = ScheduledLock(
190     Direction.NONE,
191     0,
192     0,
193     false
194   );
195 
196   /**
197    * @dev hasSendDirection
198    */
199   function hasSendDirection(Direction _direction) public pure returns (bool) {
200     return _direction == Direction.SEND || _direction == Direction.BOTH;
201   }
202 
203   /**
204    * @dev hasReceiveDirection
205    */
206   function hasReceiveDirection(Direction _direction)
207     public pure returns (bool)
208   {
209     return _direction == Direction.RECEIVE || _direction == Direction.BOTH;
210   }
211 
212   /**
213    * @dev restriction
214    */
215   function restriction() public view returns (Direction) {
216     return lock.restriction;
217   }
218 
219   /**
220    * @dev scheduledStartAt
221    */
222   function scheduledStartAt() public view returns (uint256) {
223     return lock.startAt;
224   }
225 
226   /**
227    * @dev scheduledEndAt
228    */
229   function scheduledEndAt() public view returns (uint256) {
230     return lock.endAt;
231   }
232 
233   /**
234    * @dev lock inverted
235    */
236   function isScheduleInverted() public view returns (bool) {
237     return lock.scheduleInverted;
238   }
239 
240   /**
241    * @dev isLocked
242    */
243   function isLocked() public view returns (bool) {
244     // solium-disable-next-line security/no-block-members
245     return (lock.startAt <= now && lock.endAt > now)
246       ? !lock.scheduleInverted : lock.scheduleInverted;
247   }
248 
249   /**
250    * @dev individualPass
251    */
252   function individualPass(address _address)
253     public view returns (Direction)
254   {
255     return individualPasses[_address];
256   }
257 
258   /**
259    * @dev can the address send
260    */
261   function canSend(address _address) public view returns (bool) {
262     if (isLocked() && hasSendDirection(lock.restriction)) {
263       return hasSendDirection(individualPasses[_address]);
264     }
265     return true;
266   }
267 
268   /**
269    * @dev can the address receive
270    */
271   function canReceive(address _address) public view returns (bool) {
272     if (isLocked() && hasReceiveDirection(lock.restriction)) {
273       return hasReceiveDirection(individualPasses[_address]);
274     }
275     return true;
276   }
277 
278   /**
279    * @dev allow authority to provide a pass to an address
280    */
281   function definePass(address _address, uint256 _lock)
282     public onlyAuthority returns (bool)
283   {
284     individualPasses[_address] = Direction(_lock);
285     emit PassDefinition(_address, Direction(_lock));
286     return true;
287   }
288 
289   /**
290    * @dev allow authority to provide addresses with lock passes
291    */
292   function defineManyPasses(address[] _addresses, uint256 _lock)
293     public onlyAuthority returns (bool)
294   {
295     for (uint256 i = 0; i < _addresses.length; i++) {
296       require(definePass(_addresses[i], _lock), "LOR01");
297     }
298     return true;
299   }
300 
301   /**
302    * @dev schedule lock
303    */
304   function scheduleLock(
305     Direction _restriction,
306     uint256 _startAt, uint256 _endAt, bool _scheduleInverted)
307     public onlyAuthority returns (bool)
308   {
309     require(_startAt <= _endAt, "LOR02");
310     lock = ScheduledLock(
311       _restriction,
312       _startAt,
313       _endAt,
314       _scheduleInverted
315     );
316     emit LockDefinition(
317       lock.restriction, lock.startAt, lock.endAt, lock.scheduleInverted);
318   }
319 
320   /**
321    * @dev validates an address
322    */
323   function isAddressValid(address /*_address*/) public view returns (bool) {
324     return true;
325   }
326 
327   /**
328    * @dev validates a transfer of ownership
329    */
330   function isTransferValid(address _from, address _to, uint256 /* _amount */)
331     public view returns (bool)
332   {
333     return (canSend(_from) && canReceive(_to));
334   }
335 
336   event LockDefinition(
337     Direction restriction,
338     uint256 startAt,
339     uint256 endAt,
340     bool scheduleInverted
341   );
342   event PassDefinition(address _address, Direction pass);
343 }