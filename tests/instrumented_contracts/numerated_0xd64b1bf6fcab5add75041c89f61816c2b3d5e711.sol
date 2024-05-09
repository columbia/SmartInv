1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 /**
70  * Utility library of inline functions on addresses
71  */
72 library Address {
73 
74   /**
75    * Returns whether the target address is a contract
76    * @dev This function will return false if invoked during the constructor of a contract,
77    * as the code is not actually created until after the constructor finishes.
78    * @param account address of the account to check
79    * @return whether the target address is a contract
80    */
81   function isContract(address account) internal view returns (bool) {
82     uint256 size;
83     // XXX Currently there is no better way to check if there is a contract in an address
84     // than to check the size of the code at that address.
85     // See https://ethereum.stackexchange.com/a/14016/36603
86     // for more details about how this works.
87     // TODO Check this again before the Serenity release, because all addresses will be
88     // contracts then.
89     // solium-disable-next-line security/no-inline-assembly
90     assembly { size := extcodesize(account) }
91     return size > 0;
92   }
93 
94 }
95 
96 
97 interface IOrbsGuardians {
98 
99     event GuardianRegistered(address indexed guardian);
100     event GuardianLeft(address indexed guardian);
101     event GuardianUpdated(address indexed guardian);
102 
103     /// @dev register a new guardian. You will need to transfer registrationDepositWei amount of ether.
104     /// @param name string The name of the guardian
105     /// @param website string The website of the guardian
106     function register(string name, string website) external payable;
107 
108     /// @dev update guardian details. only msg.sender can update it's own guardian details.
109     /// @param name string The name of the guardian
110     /// @param website string The website of the guardianfunction update(string name, string website) external;
111     function update(string name, string website) external;
112 
113     /// @dev Delete the guardian and take back the locked ether. only msg.sender can leave.
114     function leave() external;
115 
116     /// @dev Returns if the address belongs to a guardian
117     /// @param guardian address the guardian address
118     function isGuardian(address guardian) external view returns (bool);
119 
120     /// @dev Returns name and website for  a specific guardian.
121     /// @param guardian address the guardian address
122     function getGuardianData(address guardian)
123         external
124         view
125         returns (string name, string website);
126 
127     /// @dev Returns in which block the guardian registered, and in which block it was last updated.
128     /// @param guardian address the guardian address
129     function getRegistrationBlockNumber(address guardian)
130         external
131         view
132         returns (uint registeredOn, uint lastUpdatedOn);
133 
134     /// @dev Returns an array of guardians.
135     /// @param offset uint offset from which to start getting guardians from the array
136     /// @param limit uint limit of guardians to be returned.
137     function getGuardians(uint offset, uint limit)
138         external
139         view
140         returns (address[]);
141 
142     /// @dev Similar to getGuardians, but returns addresses represented as byte20.
143     /// @param offset uint offset from which to start getting guardians from the array
144     /// @param limit uint limit of guardians to be returned.
145     function getGuardiansBytes20(uint offset, uint limit)
146         external
147         view
148         returns (bytes20[]);
149 }
150 
151 
152 contract OrbsGuardians is IOrbsGuardians {
153     using SafeMath for uint256;
154 
155     struct GuardianData {
156         string name;
157         string website;
158         uint index;
159         uint registeredOnBlock;
160         uint lastUpdatedOnBlock;
161         uint registeredOn;
162     }
163 
164     // The version of the current Guardian smart contract.
165     uint public constant VERSION = 1;
166 
167     // Amount of Ether in Wei need to be locked when registering - this will be set to 1.
168     uint public registrationDepositWei;
169     // The amount of time needed to wait until a guardian can leave and get registrationDepositWei_
170     uint public registrationMinTime;
171 
172     // Iterable array to get a list of all guardians
173     address[] internal guardians;
174 
175     // Mapping between address and the guardian data.
176     mapping(address => GuardianData) internal guardiansData;
177 
178     /// @dev Check that the caller is a guardian.
179     modifier onlyGuardian() {
180         require(isGuardian(msg.sender), "You must be a registered guardian");
181         _;
182     }
183 
184     /// @dev Check that the caller is not a contract.
185     modifier onlyEOA() {
186         require(!Address.isContract(msg.sender),"Only EOA may register as Guardian");
187         _;
188     }
189 
190     /// @dev Constructor that initializes the amount of ether needed to lock when registering. This will be set to 1.
191     /// @param registrationDepositWei_ uint the amount of ether needed to lock when registering.
192     /// @param registrationMinTime_ uint the amount of time needed to wait until a guardian can leave and get registrationDepositWei_
193     constructor(uint registrationDepositWei_, uint registrationMinTime_) public {
194         require(registrationDepositWei_ > 0, "registrationDepositWei_ must be positive");
195 
196         registrationMinTime = registrationMinTime_;
197         registrationDepositWei = registrationDepositWei_;
198     }
199 
200     /// @dev register a new guardian. You will need to transfer registrationDepositWei amount of ether.
201     /// @param name string The name of the guardian
202     /// @param website string The website of the guardian
203     function register(string name, string website)
204         external
205         payable
206         onlyEOA
207     {
208         address sender = msg.sender;
209         require(bytes(name).length > 0, "Please provide a valid name");
210         require(bytes(website).length > 0, "Please provide a valid website");
211         require(!isGuardian(sender), "Cannot be a guardian");
212         require(msg.value == registrationDepositWei, "Please provide the exact registration deposit");
213 
214         uint index = guardians.length;
215         guardians.push(sender);
216         guardiansData[sender] = GuardianData({
217             name: name,
218             website: website,
219             index: index ,
220             registeredOnBlock: block.number,
221             lastUpdatedOnBlock: block.number,
222             registeredOn: now
223         });
224 
225         emit GuardianRegistered(sender);
226     }
227 
228     /// @dev update guardian details. only msg.sender can update it's own guardian details.
229     /// @param name string The name of the guardian
230     /// @param website string The website of the guardian
231     function update(string name, string website)
232         external
233         onlyGuardian
234         onlyEOA
235     {
236         address sender = msg.sender;
237         require(bytes(name).length > 0, "Please provide a valid name");
238         require(bytes(website).length > 0, "Please provide a valid website");
239 
240 
241         guardiansData[sender].name = name;
242         guardiansData[sender].website = website;
243         guardiansData[sender].lastUpdatedOnBlock = block.number;
244 
245         emit GuardianUpdated(sender);
246     }
247 
248     /// @dev Delete the guardian and take back the locked ether. only msg.sender can leave.
249     function leave() external onlyGuardian onlyEOA {
250         address sender = msg.sender;
251         require(now >= guardiansData[sender].registeredOn.add(registrationMinTime), "Minimal guardian time didnt pass");
252 
253         uint i = guardiansData[sender].index;
254 
255         assert(guardians[i] == sender); // Will consume all available gas.
256 
257         // Replace with last element and remove from end
258         guardians[i] = guardians[guardians.length - 1]; // Switch with last
259         guardiansData[guardians[i]].index = i; // Update it's lookup index
260         guardians.length--; // Remove the last one
261 
262         // Clear data
263         delete guardiansData[sender];
264 
265         // Refund deposit
266         sender.transfer(registrationDepositWei);
267 
268         emit GuardianLeft(sender);
269     }
270 
271     /// @dev Similar to getGuardians, but returns addresses represented as byte20.
272     /// @param offset uint offset from which to start getting guardians from the array
273     /// @param limit uint limit of guardians to be returned.
274     function getGuardiansBytes20(uint offset, uint limit)
275         external
276         view
277         returns (bytes20[])
278     {
279         address[] memory guardianAddresses = getGuardians(offset, limit);
280         uint guardianAddressesLength = guardianAddresses.length;
281 
282         bytes20[] memory result = new bytes20[](guardianAddressesLength);
283 
284         for (uint i = 0; i < guardianAddressesLength; i++) {
285             result[i] = bytes20(guardianAddresses[i]);
286         }
287 
288         return result;
289     }
290 
291     /// @dev Returns in which block the guardian registered, and in which block it was last updated.
292     /// @param guardian address the guardian address
293     function getRegistrationBlockNumber(address guardian)
294         external
295         view
296         returns (uint registeredOn, uint lastUpdatedOn)
297     {
298         require(isGuardian(guardian), "Please provide a listed Guardian");
299 
300         GuardianData storage entry = guardiansData[guardian];
301         registeredOn = entry.registeredOnBlock;
302         lastUpdatedOn = entry.lastUpdatedOnBlock;
303     }
304 
305     /// @dev Returns an array of guardians.
306     /// @param offset uint offset from which to start getting guardians from the array
307     /// @param limit uint limit of guardians to be returned.
308     function getGuardians(uint offset, uint limit)
309         public
310         view
311         returns (address[] memory)
312     {
313         if (offset >= guardians.length) { // offset out of bounds
314             return new address[](0);
315         }
316 
317         if (offset.add(limit) > guardians.length) { // clip limit to array size
318             limit = guardians.length.sub(offset);
319         }
320 
321         address[] memory result = new address[](limit);
322 
323         uint resultLength = result.length;
324         for (uint i = 0; i < resultLength; i++) {
325             result[i] = guardians[offset.add(i)];
326         }
327 
328         return result;
329     }
330 
331     /// @dev Returns name and website for  a specific guardian.
332     /// @param guardian address the guardian address
333     function getGuardianData(address guardian)
334         public
335         view
336         returns (string memory name, string memory website)
337     {
338         require(isGuardian(guardian), "Please provide a listed Guardian");
339         name = guardiansData[guardian].name;
340         website = guardiansData[guardian].website;
341     }
342 
343     /// @dev Returns if the address belongs to a guardian
344     /// @param guardian address the guardian address
345     function isGuardian(address guardian) public view returns (bool) {
346         return guardiansData[guardian].registeredOnBlock > 0;
347     }
348 }