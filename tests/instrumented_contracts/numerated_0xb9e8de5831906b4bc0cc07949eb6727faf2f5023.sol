1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.ft
6  *  
7  *              ____    _______    _____        __   _ 
8  *             |  _ \  |__   __|  / ____|      / _| (_)
9  *        ___  | |_) |    | |    | |          | |_   _ 
10  *       / __| |  _ <     | |    | |          |  _| | |
11  *       \__ \ | |_) |    | |    | |____   _  | |   | |
12  *       |___/ |____/     |_|     \_____| (_) |_|   |_|                                              
13  *  
14  *        Unfolding the Power of Soft Bitcoin Economy.
15  *                                         
16  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.ft                                     
17  *
18 **/
19 
20 
21 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that revert on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, reverts on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     uint256 c = a * b;
41     require(c / a == b);
42 
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     require(b > 0); // Solidity only automatically asserts when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53 
54     return c;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b <= a);
62     uint256 c = a - b;
63 
64     return c;
65   }
66 
67   /**
68   * @dev Adds two numbers, reverts on overflow.
69   */
70   function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     require(c >= a);
73 
74     return c;
75   }
76 
77   /**
78   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
79   * reverts when dividing by zero.
80   */
81   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82     require(b != 0);
83     return a % b;
84   }
85 }
86 
87 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
88 
89 pragma solidity ^0.4.24;
90 
91 /**
92  * @title Ownable
93  * @dev The Ownable contract has an owner address, and provides basic authorization control
94  * functions, this simplifies the implementation of "user permissions".
95  */
96 contract Ownable {
97   address private _owner;
98 
99   event OwnershipTransferred(
100     address indexed previousOwner,
101     address indexed newOwner
102   );
103 
104   /**
105    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
106    * account.
107    */
108   constructor() internal {
109     _owner = msg.sender;
110     emit OwnershipTransferred(address(0), _owner);
111   }
112 
113   /**
114    * @return the address of the owner.
115    */
116   function owner() public view returns(address) {
117     return _owner;
118   }
119 
120   /**
121    * @dev Throws if called by any account other than the owner.
122    */
123   modifier onlyOwner() {
124     require(isOwner());
125     _;
126   }
127 
128   /**
129    * @return true if `msg.sender` is the owner of the contract.
130    */
131   function isOwner() public view returns(bool) {
132     return msg.sender == _owner;
133   }
134 
135   /**
136    * @dev Allows the current owner to relinquish control of the contract.
137    * @notice Renouncing to ownership will leave the contract without an owner.
138    * It will not be possible to call the functions with the `onlyOwner`
139    * modifier anymore.
140    */
141   function renounceOwnership() public onlyOwner {
142     emit OwnershipTransferred(_owner, address(0));
143     _owner = address(0);
144   }
145 
146   /**
147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
148    * @param newOwner The address to transfer ownership to.
149    */
150   function transferOwnership(address newOwner) public onlyOwner {
151     _transferOwnership(newOwner);
152   }
153 
154   /**
155    * @dev Transfers control of the contract to a newOwner.
156    * @param newOwner The address to transfer ownership to.
157    */
158   function _transferOwnership(address newOwner) internal {
159     require(newOwner != address(0));
160     emit OwnershipTransferred(_owner, newOwner);
161     _owner = newOwner;
162   }
163 }
164 
165 // File: contracts/lib/Select.sol
166 
167 pragma solidity ^0.4.24;
168 
169 
170 /**
171  * @title Select
172  * @dev Median Selection Library
173  */
174 library Select {
175     using SafeMath for uint256;
176 
177     /**
178      * @dev Sorts the input array up to the denoted size, and returns the median.
179      * @param array Input array to compute its median.
180      * @param size Number of elements in array to compute the median for.
181      * @return Median of array.
182      */
183     function computeMedian(uint256[] array, uint256 size)
184         internal
185         pure
186         returns (uint256)
187     {
188         require(size > 0 && array.length >= size);
189         for (uint256 i = 1; i < size; i++) {
190             for (uint256 j = i; j > 0 && array[j-1]  > array[j]; j--) {
191                 uint256 tmp = array[j];
192                 array[j] = array[j-1];
193                 array[j-1] = tmp;
194             }
195         }
196         if (size % 2 == 1) {
197             return array[size / 2];
198         } else {
199             return array[size / 2].add(array[size / 2 - 1]) / 2;
200         }
201     }
202 }
203 
204 // File: contracts/MedianOracle.sol
205 
206 pragma solidity 0.4.24;
207 
208 /**
209  *
210  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.ft
211  *  
212  *           ____  _______  _____      __  _ 
213  *          |  _ \|__   __|/ ____|    / _|(_)
214  *      ___ | |_) |  | |  | |        | |_  _ 
215  *     / __||  _ <   | |  | |        |  _|| |
216  *     \__ \| |_) |  | |  | |____  _ | |  | |
217  *     |___/|____/   |_|   \_____|(_)|_|  |_|
218  *  
219  *   Unfolding the Power of Soft Bitcoin Economy.
220  *                                         
221  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.ft                                     
222  *
223 **/
224 
225 
226 
227 
228 
229 interface IOracle {
230     function getData() external returns (uint256, bool);
231 }
232 
233 
234 /**
235  * @title Median Oracle
236  *
237  * @notice Provides a value onchain that's aggregated from a whitelisted set of
238  *         providers.
239  */
240 contract MedianOracle is Ownable, IOracle {
241     using SafeMath for uint256;
242 
243     struct Report {
244         uint256 timestamp;
245         uint256 payload;
246     }
247 
248     // Addresses of providers authorized to push reports.
249     address[] public providers;
250 
251     // Reports indexed by provider address. Report[0].timestamp > 0
252     // indicates provider existence.
253     mapping (address => Report[2]) public providerReports;
254 
255     event ProviderAdded(address provider);
256     event ProviderRemoved(address provider);
257     event ReportTimestampOutOfRange(address provider);
258     event ProviderReportPushed(address indexed provider, uint256 payload, uint256 timestamp);
259 
260     // The number of seconds after which the report is deemed expired.
261     uint256 public reportExpirationTimeSec;
262 
263     // The number of seconds since reporting that has to pass before a report
264     // is usable.
265     uint256 public reportDelaySec;
266 
267     // The minimum number of providers with valid reports to consider the
268     // aggregate report valid.
269     uint256 public minimumProviders = 1;
270 
271     // Timestamp of 1 is used to mark uninitialized and invalidated data.
272     // This is needed so that timestamp of 1 is always considered expired.
273     uint256 private constant MAX_REPORT_EXPIRATION_TIME = 520 weeks;
274 
275     /**
276     * @param reportExpirationTimeSec_ The number of seconds after which the
277     *                                 report is deemed expired.
278     * @param reportDelaySec_ The number of seconds since reporting that has to
279     *                        pass before a report is usable
280     * @param minimumProviders_ The minimum number of providers with valid
281     *                          reports to consider the aggregate report valid.
282     */
283     constructor(uint256 reportExpirationTimeSec_,
284                 uint256 reportDelaySec_,
285                 uint256 minimumProviders_)
286         public
287     {
288         require(reportExpirationTimeSec_ <= MAX_REPORT_EXPIRATION_TIME);
289         require(minimumProviders_ > 0);
290         reportExpirationTimeSec = reportExpirationTimeSec_;
291         reportDelaySec = reportDelaySec_;
292         minimumProviders = minimumProviders_;
293     }
294 
295      /**
296      * @notice Sets the report expiration period.
297      * @param reportExpirationTimeSec_ The number of seconds after which the
298      *        report is deemed expired.
299      */
300     function setReportExpirationTimeSec(uint256 reportExpirationTimeSec_)
301         external
302         onlyOwner
303     {
304         require(reportExpirationTimeSec_ <= MAX_REPORT_EXPIRATION_TIME);
305         reportExpirationTimeSec = reportExpirationTimeSec_;
306     }
307 
308     /**
309     * @notice Sets the time period since reporting that has to pass before a
310     *         report is usable.
311     * @param reportDelaySec_ The new delay period in seconds.
312     */
313     function setReportDelaySec(uint256 reportDelaySec_)
314         external
315         onlyOwner
316     {
317         reportDelaySec = reportDelaySec_;
318     }
319 
320     /**
321     * @notice Sets the minimum number of providers with valid reports to
322     *         consider the aggregate report valid.
323     * @param minimumProviders_ The new minimum number of providers.
324     */
325     function setMinimumProviders(uint256 minimumProviders_)
326         external
327         onlyOwner
328     {
329         require(minimumProviders_ > 0);
330         minimumProviders = minimumProviders_;
331     }
332 
333     /**
334      * @notice Pushes a report for the calling provider.
335      * @param payload is expected to be 18 decimal fixed point number.
336      */
337     function pushReport(uint256 payload) external
338     {
339         address providerAddress = msg.sender;
340         Report[2] storage reports = providerReports[providerAddress];
341         uint256[2] memory timestamps = [reports[0].timestamp, reports[1].timestamp];
342 
343         require(timestamps[0] > 0);
344 
345         uint8 index_recent = timestamps[0] >= timestamps[1] ? 0 : 1;
346         uint8 index_past = 1 - index_recent;
347 
348         // Check that the push is not too soon after the last one.
349         require(timestamps[index_recent].add(reportDelaySec) <= now);
350 
351         reports[index_past].timestamp = now;
352         reports[index_past].payload = payload;
353 
354         emit ProviderReportPushed(providerAddress, payload, now);
355     }
356 
357     /**
358     * @notice Invalidates the reports of the calling provider.
359     */
360     function purgeReports() external
361     {
362         address providerAddress = msg.sender;
363         require (providerReports[providerAddress][0].timestamp > 0);
364         providerReports[providerAddress][0].timestamp=1;
365         providerReports[providerAddress][1].timestamp=1;
366     }
367 
368     /**
369     * @notice Computes median of provider reports whose timestamps are in the
370     *         valid timestamp range.
371     * @return AggregatedValue: Median of providers reported values.
372     *         valid: Boolean indicating an aggregated value was computed successfully.
373     */
374     function getData()
375         external
376         returns (uint256, bool)
377     {
378         uint256 reportsCount = providers.length;
379         uint256[] memory validReports = new uint256[](reportsCount);
380         uint256 size = 0;
381         uint256 minValidTimestamp =  now.sub(reportExpirationTimeSec);
382         uint256 maxValidTimestamp =  now.sub(reportDelaySec);
383 
384         for (uint256 i = 0; i < reportsCount; i++) {
385             address providerAddress = providers[i];
386             Report[2] memory reports = providerReports[providerAddress];
387 
388             uint8 index_recent = reports[0].timestamp >= reports[1].timestamp ? 0 : 1;
389             uint8 index_past = 1 - index_recent;
390             uint256 reportTimestampRecent = reports[index_recent].timestamp;
391             if (reportTimestampRecent > maxValidTimestamp) {
392                 // Recent report is too recent.
393                 uint256 reportTimestampPast = providerReports[providerAddress][index_past].timestamp;
394                 if (reportTimestampPast < minValidTimestamp) {
395                     // Past report is too old.
396                     emit ReportTimestampOutOfRange(providerAddress);
397                 } else if (reportTimestampPast > maxValidTimestamp) {
398                     // Past report is too recent.
399                     emit ReportTimestampOutOfRange(providerAddress);
400                 } else {
401                     // Using past report.
402                     validReports[size++] = providerReports[providerAddress][index_past].payload;
403                 }
404             } else {
405                 // Recent report is not too recent.
406                 if (reportTimestampRecent < minValidTimestamp) {
407                     // Recent report is too old.
408                     emit ReportTimestampOutOfRange(providerAddress);
409                 } else {
410                     // Using recent report.
411                     validReports[size++] = providerReports[providerAddress][index_recent].payload;
412                 }
413             }
414         }
415 
416         if (size < minimumProviders) {
417             return (0, false);
418         }
419 
420         return (Select.computeMedian(validReports, size), true);
421     }
422 
423     /**
424      * @notice Authorizes a provider.
425      * @param provider Address of the provider.
426      */
427     function addProvider(address provider)
428         external
429         onlyOwner
430     {
431         require(providerReports[provider][0].timestamp == 0);
432         providers.push(provider);
433         providerReports[provider][0].timestamp = 1;
434         emit ProviderAdded(provider);
435     }
436 
437     /**
438      * @notice Revokes provider authorization.
439      * @param provider Address of the provider.
440      */
441     function removeProvider(address provider)
442         external
443         onlyOwner
444     {
445         delete providerReports[provider];
446         for (uint256 i = 0; i < providers.length; i++) {
447             if (providers[i] == provider) {
448                 if (i + 1  != providers.length) {
449                     providers[i] = providers[providers.length-1];
450                 }
451                 providers.length--;
452                 emit ProviderRemoved(provider);
453                 break;
454             }
455         }
456     }
457 
458     /**
459      * @return The number of authorized providers.
460      */
461     function providersSize()
462         external
463         view
464         returns (uint256)
465     {
466         return providers.length;
467     }
468 }