1 pragma solidity ^0.4.24;
2 //
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 //
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
191 interface IOracle {
192     function getData() external returns (uint256, bool);
193 }
194 
195 
196 /**
197  * @title Median Oracle
198  *
199  * @notice Provides a value onchain that's aggregated from a whitelisted set of
200  *         providers.
201  */
202 contract MedianOracle is Ownable, IOracle {
203     using SafeMath for uint256;
204 
205     struct Report {
206         uint256 timestamp;
207         uint256 payload;
208     }
209 
210     // Addresses of providers authorized to push reports.
211     address[] public providers;
212 
213     // Reports indexed by provider address. Report[0].timestamp > 0
214     // indicates provider existence.
215     mapping (address => Report[2]) public providerReports;
216 
217     event ProviderAdded(address provider);
218     event ProviderRemoved(address provider);
219     event ReportTimestampOutOfRange(address provider);
220     event ProviderReportPushed(address indexed provider, uint256 payload, uint256 timestamp);
221 
222     // The number of seconds after which the report is deemed expired.
223     uint256 public reportExpirationTimeSec;
224 
225     // The number of seconds since reporting that has to pass before a report
226     // is usable.
227     uint256 public reportDelaySec;
228 
229     // The minimum number of providers with valid reports to consider the
230     // aggregate report valid.
231     uint256 public minimumProviders = 1;
232 
233     // Timestamp of 1 is used to mark uninitialized and invalidated data.
234     // This is needed so that timestamp of 1 is always considered expired.
235     uint256 private constant MAX_REPORT_EXPIRATION_TIME = 520 weeks;
236 
237     /**
238     * @param reportExpirationTimeSec_ The number of seconds after which the
239     *                                 report is deemed expired.
240     * @param reportDelaySec_ The number of seconds since reporting that has to
241     *                        pass before a report is usable
242     * @param minimumProviders_ The minimum number of providers with valid
243     *                          reports to consider the aggregate report valid.
244     */
245     constructor(uint256 reportExpirationTimeSec_,
246                 uint256 reportDelaySec_,
247                 uint256 minimumProviders_)
248         public
249     {
250         require(reportExpirationTimeSec_ <= MAX_REPORT_EXPIRATION_TIME);
251         require(minimumProviders_ > 0);
252         reportExpirationTimeSec = reportExpirationTimeSec_;
253         reportDelaySec = reportDelaySec_;
254         minimumProviders = minimumProviders_;
255     }
256 
257      /**
258      * @notice Sets the report expiration period.
259      * @param reportExpirationTimeSec_ The number of seconds after which the
260      *        report is deemed expired.
261      */
262     function setReportExpirationTimeSec(uint256 reportExpirationTimeSec_)
263         external
264         onlyOwner
265     {
266         require(reportExpirationTimeSec_ <= MAX_REPORT_EXPIRATION_TIME);
267         reportExpirationTimeSec = reportExpirationTimeSec_;
268     }
269 
270     /**
271     * @notice Sets the time period since reporting that has to pass before a
272     *         report is usable.
273     * @param reportDelaySec_ The new delay period in seconds.
274     */
275     function setReportDelaySec(uint256 reportDelaySec_)
276         external
277         onlyOwner
278     {
279         reportDelaySec = reportDelaySec_;
280     }
281 
282     /**
283     * @notice Sets the minimum number of providers with valid reports to
284     *         consider the aggregate report valid.
285     * @param minimumProviders_ The new minimum number of providers.
286     */
287     function setMinimumProviders(uint256 minimumProviders_)
288         external
289         onlyOwner
290     {
291         require(minimumProviders_ > 0);
292         minimumProviders = minimumProviders_;
293     }
294 
295     /**
296      * @notice Pushes a report for the calling provider.
297      * @param payload is expected to be 18 decimal fixed point number.
298      */
299     function pushReport(uint256 payload) external
300     {
301         address providerAddress = msg.sender;
302         Report[2] storage reports = providerReports[providerAddress];
303         uint256[2] memory timestamps = [reports[0].timestamp, reports[1].timestamp];
304 
305         require(timestamps[0] > 0);
306 
307         uint8 index_recent = timestamps[0] >= timestamps[1] ? 0 : 1;
308         uint8 index_past = 1 - index_recent;
309 
310         // Check that the push is not too soon after the last one.
311         require(timestamps[index_recent].add(reportDelaySec) <= now);
312 
313         reports[index_past].timestamp = now;
314         reports[index_past].payload = payload;
315 
316         emit ProviderReportPushed(providerAddress, payload, now);
317     }
318 
319     /**
320     * @notice Invalidates the reports of the calling provider.
321     */
322     function purgeReports() external
323     {
324         address providerAddress = msg.sender;
325         require (providerReports[providerAddress][0].timestamp > 0);
326         providerReports[providerAddress][0].timestamp=1;
327         providerReports[providerAddress][1].timestamp=1;
328     }
329 
330     /**
331     * @notice Computes median of provider reports whose timestamps are in the
332     *         valid timestamp range.
333     * @return AggregatedValue: Median of providers reported values.
334     *         valid: Boolean indicating an aggregated value was computed successfully.
335     */
336     function getData()
337         external
338         returns (uint256, bool)
339     {
340         uint256 reportsCount = providers.length;
341         uint256[] memory validReports = new uint256[](reportsCount);
342         uint256 size = 0;
343         uint256 minValidTimestamp =  now.sub(reportExpirationTimeSec);
344         uint256 maxValidTimestamp =  now.sub(reportDelaySec);
345 
346         for (uint256 i = 0; i < reportsCount; i++) {
347             address providerAddress = providers[i];
348             Report[2] memory reports = providerReports[providerAddress];
349 
350             uint8 index_recent = reports[0].timestamp >= reports[1].timestamp ? 0 : 1;
351             uint8 index_past = 1 - index_recent;
352             uint256 reportTimestampRecent = reports[index_recent].timestamp;
353             if (reportTimestampRecent > maxValidTimestamp) {
354                 // Recent report is too recent.
355                 uint256 reportTimestampPast = providerReports[providerAddress][index_past].timestamp;
356                 if (reportTimestampPast < minValidTimestamp) {
357                     // Past report is too old.
358                     emit ReportTimestampOutOfRange(providerAddress);
359                 } else if (reportTimestampPast > maxValidTimestamp) {
360                     // Past report is too recent.
361                     emit ReportTimestampOutOfRange(providerAddress);
362                 } else {
363                     // Using past report.
364                     validReports[size++] = providerReports[providerAddress][index_past].payload;
365                 }
366             } else {
367                 // Recent report is not too recent.
368                 if (reportTimestampRecent < minValidTimestamp) {
369                     // Recent report is too old.
370                     emit ReportTimestampOutOfRange(providerAddress);
371                 } else {
372                     // Using recent report.
373                     validReports[size++] = providerReports[providerAddress][index_recent].payload;
374                 }
375             }
376         }
377 
378         if (size < minimumProviders) {
379             return (0, false);
380         }
381 
382         return (Select.computeMedian(validReports, size), true);
383     }
384 
385     /**
386      * @notice Authorizes a provider.
387      * @param provider Address of the provider.
388      */
389     function addProvider(address provider)
390         external
391         onlyOwner
392     {
393         require(providerReports[provider][0].timestamp == 0);
394         providers.push(provider);
395         providerReports[provider][0].timestamp = 1;
396         emit ProviderAdded(provider);
397     }
398 
399     /**
400      * @notice Revokes provider authorization.
401      * @param provider Address of the provider.
402      */
403     function removeProvider(address provider)
404         external
405         onlyOwner
406     {
407         delete providerReports[provider];
408         for (uint256 i = 0; i < providers.length; i++) {
409             if (providers[i] == provider) {
410                 if (i + 1  != providers.length) {
411                     providers[i] = providers[providers.length-1];
412                 }
413                 providers.length--;
414                 emit ProviderRemoved(provider);
415                 break;
416             }
417         }
418     }
419 
420     /**
421      * @return The number of authorized providers.
422      */
423     function providersSize()
424         external
425         view
426         returns (uint256)
427     {
428         return providers.length;
429     }
430 }