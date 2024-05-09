1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 pragma solidity ^0.4.24;
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79   address private _owner;
80 
81   event OwnershipTransferred(
82     address indexed previousOwner,
83     address indexed newOwner
84   );
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   constructor() internal {
91     _owner = msg.sender;
92     emit OwnershipTransferred(address(0), _owner);
93   }
94 
95   /**
96    * @return the address of the owner.
97    */
98   function owner() public view returns(address) {
99     return _owner;
100   }
101 
102   /**
103    * @dev Throws if called by any account other than the owner.
104    */
105   modifier onlyOwner() {
106     require(isOwner());
107     _;
108   }
109 
110   /**
111    * @return true if `msg.sender` is the owner of the contract.
112    */
113   function isOwner() public view returns(bool) {
114     return msg.sender == _owner;
115   }
116 
117   /**
118    * @dev Allows the current owner to relinquish control of the contract.
119    * @notice Renouncing to ownership will leave the contract without an owner.
120    * It will not be possible to call the functions with the `onlyOwner`
121    * modifier anymore.
122    */
123   function renounceOwnership() public onlyOwner {
124     emit OwnershipTransferred(_owner, address(0));
125     _owner = address(0);
126   }
127 
128   /**
129    * @dev Allows the current owner to transfer control of the contract to a newOwner.
130    * @param newOwner The address to transfer ownership to.
131    */
132   function transferOwnership(address newOwner) public onlyOwner {
133     _transferOwnership(newOwner);
134   }
135 
136   /**
137    * @dev Transfers control of the contract to a newOwner.
138    * @param newOwner The address to transfer ownership to.
139    */
140   function _transferOwnership(address newOwner) internal {
141     require(newOwner != address(0));
142     emit OwnershipTransferred(_owner, newOwner);
143     _owner = newOwner;
144   }
145 }
146 
147 // File: contracts/lib/Select.sol
148 
149 pragma solidity ^0.4.24;
150 
151 
152 /**
153  * @title Select
154  * @dev Median Selection Library
155  */
156 library Select {
157     using SafeMath for uint256;
158 
159     /**
160      * @dev Sorts the input array up to the denoted size, and returns the median.
161      * @param array Input array to compute its median.
162      * @param size Number of elements in array to compute the median for.
163      * @return Median of array.
164      */
165     function computeMedian(uint256[] array, uint256 size)
166         internal
167         pure
168         returns (uint256)
169     {
170         require(size > 0 && array.length >= size);
171         for (uint256 i = 1; i < size; i++) {
172             for (uint256 j = i; j > 0 && array[j-1]  > array[j]; j--) {
173                 uint256 tmp = array[j];
174                 array[j] = array[j-1];
175                 array[j-1] = tmp;
176             }
177         }
178         if (size % 2 == 1) {
179             return array[size / 2];
180         } else {
181             return array[size / 2].add(array[size / 2 - 1]) / 2;
182         }
183     }
184 }
185 
186 // File: contracts/MedianOracle.sol
187 
188 pragma solidity 0.4.24;
189 
190 
191 
192 
193 
194 interface IOracle {
195     function getData() external returns (uint256, bool);
196 }
197 
198 
199 /**
200  * @title Median Oracle
201  *
202  * @notice Provides a value onchain that's aggregated from a whitelisted set of
203  *         providers.
204  */
205 contract MedianOracle is Ownable, IOracle {
206     using SafeMath for uint256;
207 
208     struct Report {
209         uint256 timestamp;
210         uint256 payload;
211     }
212 
213     // Addresses of providers authorized to push reports.
214     address[] public providers;
215 
216     // Reports indexed by provider address. Report[0].timestamp > 0
217     // indicates provider existence.
218     mapping (address => Report[2]) public providerReports;
219 
220     event ProviderAdded(address provider);
221     event ProviderRemoved(address provider);
222     event ReportTimestampOutOfRange(address provider);
223     event ProviderReportPushed(address indexed provider, uint256 payload, uint256 timestamp);
224 
225     // The number of seconds after which the report is deemed expired.
226     uint256 public reportExpirationTimeSec;
227 
228     // The number of seconds since reporting that has to pass before a report
229     // is usable.
230     uint256 public reportDelaySec;
231 
232     // The minimum number of providers with valid reports to consider the
233     // aggregate report valid.
234     uint256 public minimumProviders = 1;
235 
236     // Timestamp of 1 is used to mark uninitialized and invalidated data.
237     // This is needed so that timestamp of 1 is always considered expired.
238     uint256 private constant MAX_REPORT_EXPIRATION_TIME = 520 weeks;
239 
240     /**
241     * @param reportExpirationTimeSec_ The number of seconds after which the
242     *                                 report is deemed expired.
243     * @param reportDelaySec_ The number of seconds since reporting that has to
244     *                        pass before a report is usable
245     * @param minimumProviders_ The minimum number of providers with valid
246     *                          reports to consider the aggregate report valid.
247     */
248     constructor(uint256 reportExpirationTimeSec_,
249                 uint256 reportDelaySec_,
250                 uint256 minimumProviders_)
251         public
252     {
253         require(reportExpirationTimeSec_ <= MAX_REPORT_EXPIRATION_TIME);
254         require(minimumProviders_ > 0);
255         reportExpirationTimeSec = reportExpirationTimeSec_;
256         reportDelaySec = reportDelaySec_;
257         minimumProviders = minimumProviders_;
258     }
259 
260      /**
261      * @notice Sets the report expiration period.
262      * @param reportExpirationTimeSec_ The number of seconds after which the
263      *        report is deemed expired.
264      */
265     function setReportExpirationTimeSec(uint256 reportExpirationTimeSec_)
266         external
267         onlyOwner
268     {
269         require(reportExpirationTimeSec_ <= MAX_REPORT_EXPIRATION_TIME);
270         reportExpirationTimeSec = reportExpirationTimeSec_;
271     }
272 
273     /**
274     * @notice Sets the time period since reporting that has to pass before a
275     *         report is usable.
276     * @param reportDelaySec_ The new delay period in seconds.
277     */
278     function setReportDelaySec(uint256 reportDelaySec_)
279         external
280         onlyOwner
281     {
282         reportDelaySec = reportDelaySec_;
283     }
284 
285     /**
286     * @notice Sets the minimum number of providers with valid reports to
287     *         consider the aggregate report valid.
288     * @param minimumProviders_ The new minimum number of providers.
289     */
290     function setMinimumProviders(uint256 minimumProviders_)
291         external
292         onlyOwner
293     {
294         require(minimumProviders_ > 0);
295         minimumProviders = minimumProviders_;
296     }
297 
298     /**
299      * @notice Pushes a report for the calling provider.
300      * @param payload is expected to be 18 decimal fixed point number.
301      */
302     function pushReport(uint256 payload) external
303     {
304         address providerAddress = msg.sender;
305         Report[2] storage reports = providerReports[providerAddress];
306         uint256[2] memory timestamps = [reports[0].timestamp, reports[1].timestamp];
307 
308         require(timestamps[0] > 0);
309 
310         uint8 index_recent = timestamps[0] >= timestamps[1] ? 0 : 1;
311         uint8 index_past = 1 - index_recent;
312 
313         // Check that the push is not too soon after the last one.
314         require(timestamps[index_recent].add(reportDelaySec) <= now);
315 
316         reports[index_past].timestamp = now;
317         reports[index_past].payload = payload;
318 
319         emit ProviderReportPushed(providerAddress, payload, now);
320     }
321 
322     /**
323     * @notice Invalidates the reports of the calling provider.
324     */
325     function purgeReports() external
326     {
327         address providerAddress = msg.sender;
328         require (providerReports[providerAddress][0].timestamp > 0);
329         providerReports[providerAddress][0].timestamp=1;
330         providerReports[providerAddress][1].timestamp=1;
331     }
332 
333     /**
334     * @notice Computes median of provider reports whose timestamps are in the
335     *         valid timestamp range.
336     * @return AggregatedValue: Median of providers reported values.
337     *         valid: Boolean indicating an aggregated value was computed successfully.
338     */
339     function getData()
340         external
341         returns (uint256, bool)
342     {
343         uint256 reportsCount = providers.length;
344         uint256[] memory validReports = new uint256[](reportsCount);
345         uint256 size = 0;
346         uint256 minValidTimestamp =  now.sub(reportExpirationTimeSec);
347         uint256 maxValidTimestamp =  now.sub(reportDelaySec);
348 
349         for (uint256 i = 0; i < reportsCount; i++) {
350             address providerAddress = providers[i];
351             Report[2] memory reports = providerReports[providerAddress];
352 
353             uint8 index_recent = reports[0].timestamp >= reports[1].timestamp ? 0 : 1;
354             uint8 index_past = 1 - index_recent;
355             uint256 reportTimestampRecent = reports[index_recent].timestamp;
356             if (reportTimestampRecent > maxValidTimestamp) {
357                 // Recent report is too recent.
358                 uint256 reportTimestampPast = providerReports[providerAddress][index_past].timestamp;
359                 if (reportTimestampPast < minValidTimestamp) {
360                     // Past report is too old.
361                     emit ReportTimestampOutOfRange(providerAddress);
362                 } else if (reportTimestampPast > maxValidTimestamp) {
363                     // Past report is too recent.
364                     emit ReportTimestampOutOfRange(providerAddress);
365                 } else {
366                     // Using past report.
367                     validReports[size++] = providerReports[providerAddress][index_past].payload;
368                 }
369             } else {
370                 // Recent report is not too recent.
371                 if (reportTimestampRecent < minValidTimestamp) {
372                     // Recent report is too old.
373                     emit ReportTimestampOutOfRange(providerAddress);
374                 } else {
375                     // Using recent report.
376                     validReports[size++] = providerReports[providerAddress][index_recent].payload;
377                 }
378             }
379         }
380 
381         if (size < minimumProviders) {
382             return (0, false);
383         }
384 
385         return (Select.computeMedian(validReports, size), true);
386     }
387 
388     /**
389      * @notice Authorizes a provider.
390      * @param provider Address of the provider.
391      */
392     function addProvider(address provider)
393         external
394         onlyOwner
395     {
396         require(providerReports[provider][0].timestamp == 0);
397         providers.push(provider);
398         providerReports[provider][0].timestamp = 1;
399         emit ProviderAdded(provider);
400     }
401 
402     /**
403      * @notice Revokes provider authorization.
404      * @param provider Address of the provider.
405      */
406     function removeProvider(address provider)
407         external
408         onlyOwner
409     {
410         delete providerReports[provider];
411         for (uint256 i = 0; i < providers.length; i++) {
412             if (providers[i] == provider) {
413                 if (i + 1  != providers.length) {
414                     providers[i] = providers[providers.length-1];
415                 }
416                 providers.length--;
417                 emit ProviderRemoved(provider);
418                 break;
419             }
420         }
421     }
422 
423     /**
424      * @return The number of authorized providers.
425      */
426     function providersSize()
427         external
428         view
429         returns (uint256)
430     {
431         return providers.length;
432     }
433 }