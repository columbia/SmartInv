1 pragma solidity ^0.4.18;
2 
3 /************************************************** */
4 /* WhenHub TokenVesting Contract                    */
5 /* Author: Nik Kalyani  nik@whenhub.com             */
6 /* Copyright (c) 2018 CalendarTree, Inc.            */
7 /* https://interface.whenhub.com                    */
8 /************************************************** */
9 contract TokenVesting {
10     using SafeMath for uint256;
11 
12 
13     /* VestingGrant is used to implement business rules regarding token vesting       */
14     struct VestingGrant {
15         bool isGranted;                                                 // Flag to indicate grant was issued
16         address issuer;                                                 // Account that issued grant
17         address beneficiary;                                            // Beneficiary of grant
18         uint256 grantJiffys;                                            // Number of Jiffys granted
19         uint256 startTimestamp;                                         // Start date/time of vesting
20         uint256 cliffTimestamp;                                         // Cliff date/time for vesting
21         uint256 endTimestamp;                                           // End date/time of vesting
22         bool isRevocable;                                               // Whether issuer can revoke and reclaim Jiffys
23         uint256 releasedJiffys;                                         // Number of Jiffys already released
24     }
25 
26     mapping(address => VestingGrant) private vestingGrants;             // Token grants subject to vesting
27     address[] private vestingGrantLookup;                               // Lookup table of token grants
28 
29     uint private constant GENESIS_TIMESTAMP = 1514764800;                       // Jan 1, 2018 00:00:00 UTC (arbitrary date/time for timestamp validation)
30     uint private constant ONE_MONTH = 2629743;
31     uint private constant ONE_YEAR = 31556926;
32     uint private constant TWO_YEARS = 63113852;
33     uint private constant THREE_YEARS = 94670778;
34 
35     bool private initialized = false;
36 
37     /* Vesting Events */
38     event Grant             // Fired when an account grants tokens to another account on a vesting schedule
39                             (
40                                 address indexed owner, 
41                                 address indexed beneficiary, 
42                                 uint256 valueVested,
43                                 uint256 valueUnvested
44                             );
45 
46     event Revoke            // Fired when an account revokes previously granted unvested tokens to another account
47                             (
48                                 address indexed owner, 
49                                 address indexed beneficiary, 
50                                 uint256 value
51                             );
52 
53     // This contract does not accept any Ether
54     function() public {
55         revert();
56     }
57 
58     string public name = "TokenVesting";
59 
60     // Controlling WHENToken contract (cannot be changed)
61     WHENToken whenContract;
62 
63     modifier requireIsOperational() 
64     {
65         require(whenContract.isOperational());
66         _;
67     }
68 
69     /**
70     * @dev Constructor
71     *
72     * @param whenTokenContract Address of the WHENToken contract
73     */
74     function TokenVesting
75                                 (
76                                     address whenTokenContract
77                                 ) 
78                                 public
79     {
80         whenContract = WHENToken(whenTokenContract);
81 
82     }
83 
84      /**
85     * @dev Initial token grants for various accounts
86     *
87     * @param companyAccount Account representing the Company for granting tokens
88     * @param partnerAccount Account representing the Partner for granting tokens
89     * @param foundationAccount Account representing the Foundation for granting tokens
90     */    
91     function initialize         (
92                                     address companyAccount,
93                                     address partnerAccount, 
94                                     address foundationAccount
95                                 )
96                                 external
97     {
98         require(!initialized);
99 
100         initialized = true;
101 
102         uint256 companyJiffys;
103         uint256 partnerJiffys;
104         uint256 foundationJiffys;
105         (companyJiffys, partnerJiffys, foundationJiffys) = whenContract.getTokenAllocations();
106 
107         // Grant tokens for current and future use of company
108         // One-third initial grant; two-year vesting for balance starting after one year
109         uint256 companyInitialGrant = companyJiffys.div(3);
110         grant(companyAccount, companyInitialGrant, companyInitialGrant.mul(2), GENESIS_TIMESTAMP + ONE_YEAR, 0, TWO_YEARS, false);
111 
112         // Grant vesting tokens to partner account for use in incentivizing partners
113         // Three-year vesting, with six-month cliff
114         grant(partnerAccount, 0, partnerJiffys, GENESIS_TIMESTAMP, ONE_MONTH.mul(6), THREE_YEARS, true);
115 
116         // Grant vesting tokens to foundation account for charitable use
117         // Three-year vesting, with six-month cliff
118         grant(foundationAccount, 0, foundationJiffys, GENESIS_TIMESTAMP, ONE_MONTH.mul(6), THREE_YEARS, true);
119     }
120 
121     /**
122     * @dev Grants a beneficiary Jiffys using a vesting schedule
123     *
124     * @param beneficiary The account to whom Jiffys are being granted
125     * @param vestedJiffys Fully vested Jiffys that will be granted
126     * @param unvestedJiffys Jiffys that are granted but not vested
127     * @param startTimestamp Date/time when vesting begins
128     * @param cliffSeconds Date/time prior to which tokens vest but cannot be released
129     * @param vestingSeconds Vesting duration (also known as vesting term)
130     * @param revocable Indicates whether the granting account is allowed to revoke the grant
131     */   
132     function grant
133                             (
134                                 address beneficiary, 
135                                 uint256 vestedJiffys,
136                                 uint256 unvestedJiffys, 
137                                 uint256 startTimestamp, 
138                                 uint256 cliffSeconds, 
139                                 uint256 vestingSeconds, 
140                                 bool revocable
141                             ) 
142                             public 
143                             requireIsOperational
144     {
145         require(beneficiary != address(0));
146         require(!vestingGrants[beneficiary].isGranted);         // Can't have multiple grants for same account
147         require((vestedJiffys > 0) || (unvestedJiffys > 0));    // There must be Jiffys that are being granted
148 
149         require(startTimestamp >= GENESIS_TIMESTAMP);           // Just a way to prevent really old dates
150         require(vestingSeconds > 0);
151         require(cliffSeconds >= 0);
152         require(cliffSeconds < vestingSeconds);
153 
154         whenContract.vestingGrant(msg.sender, beneficiary, vestedJiffys, unvestedJiffys);
155 
156         // The vesting grant is added to the beneficiary and the vestingGrant lookup table is updated
157         vestingGrants[beneficiary] = VestingGrant({
158                                                     isGranted: true,
159                                                     issuer: msg.sender,                                                   
160                                                     beneficiary: beneficiary, 
161                                                     grantJiffys: unvestedJiffys,
162                                                     startTimestamp: startTimestamp,
163                                                     cliffTimestamp: startTimestamp + cliffSeconds,
164                                                     endTimestamp: startTimestamp + vestingSeconds,
165                                                     isRevocable: revocable,
166                                                     releasedJiffys: 0
167                                                 });
168 
169         vestingGrantLookup.push(beneficiary);
170 
171         Grant(msg.sender, beneficiary, vestedJiffys, unvestedJiffys);   // Fire event
172 
173         // If the cliff time has already passed or there is no cliff, then release
174         // any Jiffys for which the beneficiary is already eligible
175         if (vestingGrants[beneficiary].cliffTimestamp <= now) {
176             releaseFor(beneficiary);
177         }
178     }
179 
180     /**
181     * @dev Gets current grant balance for caller
182     *
183     */ 
184     function getGrantBalance() 
185                             external 
186                             view 
187                             returns(uint256) 
188     {
189        return getGrantBalanceOf(msg.sender);        
190     }
191 
192     /**
193     * @dev Gets current grant balance for an account
194     *
195     * The return value subtracts Jiffys that have previously
196     * been released.
197     *
198     * @param account Account whose grant balance is returned
199     *
200     */ 
201     function getGrantBalanceOf
202                             (
203                                 address account
204                             ) 
205                             public 
206                             view 
207                             returns(uint256) 
208     {
209         require(account != address(0));
210         require(vestingGrants[account].isGranted);
211         
212         return(vestingGrants[account].grantJiffys.sub(vestingGrants[account].releasedJiffys));
213     }
214 
215 
216     /**
217     * @dev Releases Jiffys that have been vested for caller
218     *
219     */ 
220     function release() 
221                             public 
222     {
223         releaseFor(msg.sender);
224     }
225 
226     /**
227     * @dev Releases Jiffys that have been vested for an account
228     *
229     * @param account Account whose Jiffys will be released
230     *
231     */ 
232     function releaseFor
233                             (
234                                 address account
235                             ) 
236                             public 
237                             requireIsOperational 
238     {
239         require(account != address(0));
240         require(vestingGrants[account].isGranted);
241         require(vestingGrants[account].cliffTimestamp <= now);
242         
243         // Calculate vesting rate per second        
244         uint256 jiffysPerSecond = (vestingGrants[account].grantJiffys.div(vestingGrants[account].endTimestamp.sub(vestingGrants[account].startTimestamp)));
245 
246         // Calculate how many jiffys can be released
247         uint256 releasableJiffys = now.sub(vestingGrants[account].startTimestamp).mul(jiffysPerSecond).sub(vestingGrants[account].releasedJiffys);
248 
249         // If the additional released Jiffys would cause the total released to exceed total granted, then
250         // cap the releasable Jiffys to whatever was granted.
251         if ((vestingGrants[account].releasedJiffys.add(releasableJiffys)) > vestingGrants[account].grantJiffys) {
252             releasableJiffys = vestingGrants[account].grantJiffys.sub(vestingGrants[account].releasedJiffys);
253         }
254 
255         if (releasableJiffys > 0) {
256             // Update the released Jiffys counter
257             vestingGrants[account].releasedJiffys = vestingGrants[account].releasedJiffys.add(releasableJiffys);
258             whenContract.vestingTransfer(vestingGrants[account].issuer, account, releasableJiffys);
259         }
260     }
261 
262     /**
263     * @dev Returns a lookup table of all vesting grant beneficiaries
264     *
265     */ 
266     function getGrantBeneficiaries() 
267                             external 
268                             view 
269                             returns(address[]) 
270     {
271         return vestingGrantLookup;        
272     }
273 
274     /**
275     * @dev Revokes previously issued vesting grant
276     *
277     * For a grant to be revoked, it must be revocable.
278     * In addition, only the unreleased tokens can be revoked.
279     *
280     * @param account Account for which a prior grant will be revoked
281     */ 
282     function revoke
283                             (
284                                 address account
285                             ) 
286                             public 
287                             requireIsOperational 
288     {
289         require(account != address(0));
290         require(vestingGrants[account].isGranted);
291         require(vestingGrants[account].isRevocable);
292         require(vestingGrants[account].issuer == msg.sender); // Only the original issuer can revoke a grant
293 
294         // Set the isGranted flag to false to prevent any further
295         // actions on this grant from ever occurring
296         vestingGrants[account].isGranted = false;        
297         
298         // Get the remaining balance of the grant
299         uint256 balanceJiffys = vestingGrants[account].grantJiffys.sub(vestingGrants[account].releasedJiffys);
300         Revoke(vestingGrants[account].issuer, account, balanceJiffys);
301 
302         // If there is any balance left, return it to the issuer
303         if (balanceJiffys > 0) {
304             whenContract.vestingTransfer(msg.sender, msg.sender, balanceJiffys);
305         }
306     }
307 
308 }
309 
310 contract WHENToken {
311 
312     function isOperational() public view returns(bool);
313     function vestingGrant(address owner, address beneficiary, uint256 vestedJiffys, uint256 unvestedJiffys) external;
314     function vestingTransfer(address owner, address beneficiary, uint256 jiffys) external;
315     function getTokenAllocations() external view returns(uint256, uint256, uint256);
316 }
317 
318 /*
319 LICENSE FOR SafeMath and TokenVesting
320 
321 The MIT License (MIT)
322 
323 Copyright (c) 2016 Smart Contract Solutions, Inc.
324 
325 Permission is hereby granted, free of charge, to any person obtaining
326 a copy of this software and associated documentation files (the
327 "Software"), to deal in the Software without restriction, including
328 without limitation the rights to use, copy, modify, merge, publish,
329 distribute, sublicense, and/or sell copies of the Software, and to
330 permit persons to whom the Software is furnished to do so, subject to
331 the following conditions:
332 
333 The above copyright notice and this permission notice shall be included
334 in all copies or substantial portions of the Software.
335 
336 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
337 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
338 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
339 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
340 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
341 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
342 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
343 */
344 
345 
346 library SafeMath {
347 /* Copyright (c) 2016 Smart Contract Solutions, Inc. */
348 /* See License at end of file                        */
349 
350     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
351         if (a == 0) {
352         return 0;
353         }
354         uint256 c = a * b;
355         assert(c / a == b);
356         return c;
357     }
358 
359     function div(uint256 a, uint256 b) internal pure returns (uint256) {
360         // assert(b > 0); // Solidity automatically throws when dividing by 0
361         uint256 c = a / b;
362         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
363         return c;
364     }
365 
366     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
367         assert(b <= a);
368         return a - b;
369     }
370 
371     function add(uint256 a, uint256 b) internal pure returns (uint256) {
372         uint256 c = a + b;
373         assert(c >= a);
374         return c;
375     }
376 }