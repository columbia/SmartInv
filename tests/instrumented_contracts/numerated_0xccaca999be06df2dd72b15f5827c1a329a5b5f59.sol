1 pragma solidity ^0.5.2;
2 
3 // File: /Users/anxo/code/gnosis/dx-price-oracle/contracts/IDutchX.sol
4 
5 interface DutchX {
6 
7     function approvedTokens(address)
8         external
9         view
10         returns (bool);
11 
12     function getAuctionIndex(
13         address token1,
14         address token2
15     )
16         external
17         view
18         returns (uint auctionIndex);
19 
20     function getClearingTime(
21         address token1,
22         address token2,
23         uint auctionIndex
24     )
25         external
26         view
27         returns (uint time);
28 
29     function getPriceInPastAuction(
30         address token1,
31         address token2,
32         uint auctionIndex
33     )
34         external
35         view
36         // price < 10^31
37         returns (uint num, uint den);
38 }
39 
40 // File: /Users/anxo/code/gnosis/dx-price-oracle/contracts/DutchXPriceOracle.sol
41 
42 /// @title A contract that uses the DutchX platform to provide a reliable price oracle for any token traded on the DutchX
43 /// @author Dominik Teiml - dominik@gnosis.pm
44 
45 contract DutchXPriceOracle {
46 
47     DutchX public dutchX;
48     address public ethToken;
49     
50     /// @notice constructor takes DutchX proxy address and WETH token address
51     /// @param _dutchX address of DutchX proxy
52     /// @param _ethToken address of WETH token
53     constructor(DutchX _dutchX, address _ethToken)
54         public
55     {
56         dutchX = _dutchX;
57         ethToken = _ethToken;
58     }
59 
60     /// @notice Get price, in ETH, of an ERC-20 token `token.address()`
61     /// @param token address of ERC-20 token in question
62     /// @return The numerator of the price of the token
63     /// @return The denominator of the price of the token
64     function getPrice(address token)
65         public
66         view
67         returns (uint num, uint den)
68     {
69         (num, den) = getPriceCustom(token, 0, true, 4.5 days, 9);
70     }
71 
72     /// @dev More fine-grained price oracle for token `token.address()`
73     /// @param token address of ERC-20 token in question
74     /// @param time 0 for current price, a Unix timestamp for a price at any point in time
75     /// @param requireWhitelisted Require the token be whitelisted on the DutchX? (Unwhitelisted addresses might not conform to the ERC-20 standard and/or might be malicious)
76     /// @param maximumTimePeriod maximum time period between clearing time of last auction and `time`
77     /// @param numberOfAuctions how many auctions to consider. Contract is safe only for odd numbers.
78     /// @return The numerator of the price of the token
79     /// @return The denominator of the price of the token
80     function getPriceCustom(
81         address token,
82         uint time,
83         bool requireWhitelisted,
84         uint maximumTimePeriod,
85         uint numberOfAuctions
86     )
87         public
88         view
89         returns (uint num, uint den)
90     {
91         // Whitelist check
92         if (requireWhitelisted && !isWhitelisted(token)) {
93             return (0, 0);
94         }
95 
96         address ethTokenMem = ethToken;
97 
98         uint auctionIndex;
99         uint latestAuctionIndex = dutchX.getAuctionIndex(token, ethTokenMem);
100 
101         if (time == 0) {
102             auctionIndex = latestAuctionIndex;
103             time = now;
104         } else {
105             // We need to add one at the end, because the way getPricesAndMedian works, it starts from 
106             // the previous auction (see below for why it does that)
107             auctionIndex = computeAuctionIndex(token, 1, 
108                 latestAuctionIndex - 1, latestAuctionIndex - 1, time) + 1;
109         }
110 
111         // Activity check
112         uint clearingTime = dutchX.getClearingTime(token, ethTokenMem, auctionIndex - numberOfAuctions - 1);
113 
114         if (time - clearingTime > maximumTimePeriod) {
115             return (0, 0);
116         } else {
117             (num, den) = getPricesAndMedian(token, numberOfAuctions, auctionIndex);
118         }
119     }
120 
121     /// @notice gets prices, starting 
122     /// @dev search starts at auctionIndex - 1. The reason for this is we expect the most common use case to be the latest auction index and for that the clearingTime is not available yet. So we need to start at the one before
123     /// @param token address of ERC-20 token in question
124     /// @param numberOfAuctions how many auctions to consider. Contract is safe only for add numbers
125     /// @param auctionIndex search will begin at auctionIndex - 1
126     /// @return The numerator of the price of the token
127     /// @return The denominator of the price of the token
128     function getPricesAndMedian(
129         address token,
130         uint numberOfAuctions,
131         uint auctionIndex
132     )
133         public
134         view
135         returns (uint, uint)
136     {
137         // This function repeatedly calls dutchX.getPriceInPastAuction
138         // (which is a weighted average of the two closing prices for one auction pair)
139         // and saves them in nums[] and dens[]
140         // It keeps a linked list of indices of the sorted prices so that there is no array shifting
141         // Whenever a new price is added, we traverse the indices until we find a smaller price
142         // then we update the linked list in O(1)
143         // (It could be viewed as a linked list version of insertion sort)
144 
145         uint[] memory nums = new uint[](numberOfAuctions);
146         uint[] memory dens = new uint[](numberOfAuctions);
147         uint[] memory linkedListOfIndices = new uint[](numberOfAuctions);
148         uint indexOfSmallest;
149 
150         for (uint i = 0; i < numberOfAuctions; i++) {
151             // Loop begins by calling auctionIndex - 1 and ends by calling auctionIndex - numberOfAcutions
152             // That gives numberOfAuctions calls
153             (uint num, uint den) = dutchX.getPriceInPastAuction(token, ethToken, auctionIndex - 1 - i);
154 
155             (nums[i], dens[i]) = (num, den);
156 
157             // We begin by comparing latest price to smallest price
158             // Smallest price is given by prices[linkedListOfIndices.indexOfLargest]
159             uint previousIndex;
160             uint index = linkedListOfIndices[indexOfSmallest];
161 
162             for (uint j = 0; j < i; j++) {
163                 if (isSmaller(num, den, nums[index], dens[index])) {
164 
165                     // Update new term to point to next term
166                     linkedListOfIndices[i] = index;
167 
168                     if (j == 0) {
169                         // Loop is at first iteration
170                         linkedListOfIndices[indexOfSmallest] = i;
171                     } else {
172                         // Update current term to point to new term
173                         // Current term is given by 
174                         linkedListOfIndices[previousIndex] = i;
175                     }
176 
177                     break;
178                 }
179 
180                 if (j == i - 1) {
181                     // Loop is at last iteration
182                     linkedListOfIndices[i] = linkedListOfIndices[indexOfSmallest];
183                     linkedListOfIndices[index] = i;
184                     indexOfSmallest = i;
185                 } else {
186                     // Nothing happened, update temp vars and run body again
187                     previousIndex = index;
188                     index = linkedListOfIndices[index];
189                 }
190             }
191         }
192 
193         // Array is fully sorted
194 
195         uint index = indexOfSmallest;
196 
197         // Traverse array to find median
198         for (uint i = 0; i < (numberOfAuctions + 1) / 2; i++) {
199             index = linkedListOfIndices[index];
200         }
201 
202         // We return floor-of-half value 
203         // The reason is if we computed arithmetic average of the two middle values
204         // as a traditional median does, that would increase the order of the numbers
205         // DutchX price oracle gives a fraction with num & den at an order of 10^30
206         // If instead of a/b we do (a/b + c/d)/2 = (ad+bc)/(2bd), we see the order
207         // would become 10^60. That would increase chance of overflow in contracts 
208         // that depend on this price oracle
209         // This also means the Price Oracle is safe only for odd values of numberOfAuctions!
210 
211         return (nums[index], dens[index]);
212     }
213 
214     /// @dev compute largest auctionIndex with clearing time smaller than desired time. Use case: user provides a time and this function will find the largest auctionIndex that had a cleared auction before that time. It is used to get historical price oracle values
215     /// @param token address of ERC-20 token in question
216     /// @param lowerBound lowerBound of result. Recommended that it is > 0, because 0th price is set by whoever adds token pair
217     /// @param initialUpperBound initial upper bound when this recursive fn is called for the first time
218     /// @param upperBound current upper bound of result
219     /// @param time desired time
220     /// @return largest auctionIndex s.t. clearingTime[auctionIndex] <= time
221     function computeAuctionIndex(
222         address token,
223         uint lowerBound, 
224         uint initialUpperBound,
225         uint upperBound,
226         uint time
227     )
228         public
229         view
230         returns (uint)
231     {
232         // computeAuctionIndex works by recursively lowering lower and upperBound
233         // The result begins in [lowerBound, upperBound] (invariant)
234         // If we never decrease the upperBound, it will stay in that range
235         // If we ever decrease it, the result will be in [lowerBound, upperBound - 1]
236 
237         uint clearingTime;
238 
239         if (upperBound - lowerBound == 1) {
240             // Recursion base case
241 
242             if (lowerBound <= 1) {
243                 clearingTime = dutchX.getClearingTime(token, ethToken, lowerBound); 
244 
245                 if (time < clearingTime) {
246                     revert("time too small");
247                 }
248             }
249 
250             if (upperBound == initialUpperBound) {
251                 clearingTime = dutchX.getClearingTime(token, ethToken, upperBound);
252 
253                 if (time < clearingTime) {
254                     return lowerBound;
255                 } else {
256                     // Can only happen if answer is initialUpperBound
257                     return upperBound;
258                 }            
259             } else {
260                 // In most cases, we'll have bounds [loweBound, loweBound + 1), which results in lowerBound
261                 return lowerBound;
262             }
263         }
264 
265         uint mid = (lowerBound + upperBound) / 2;
266         clearingTime = dutchX.getClearingTime(token, ethToken, mid);
267 
268         if (time < clearingTime) {
269             // Answer is in lower half
270             return computeAuctionIndex(token, lowerBound, initialUpperBound, mid, time);
271         } else if (time == clearingTime) {
272             // We found answer
273             return mid;
274         } else {
275             // Answer is in upper half
276             return computeAuctionIndex(token, mid, initialUpperBound, upperBound, time);
277         }
278     }
279 
280     /// @notice compares two fractions and returns if first is smaller
281     /// @param num1 Numerator of first fraction
282     /// @param den1 Denominator of first fraction
283     /// @param num2 Numerator of second fraction
284     /// @param den2 Denominator of second fraction
285     /// @return bool - whether first fraction is (strictly) smaller than second
286     function isSmaller(uint num1, uint den1, uint num2, uint den2)
287         public
288         pure
289         returns (bool)
290     {
291         // Safe math
292         require(den1 != 0, "undefined fraction");
293         require(den2 != 0, "undefined fraction");
294         require(num1 * den2 / den2 == num1, "overflow");
295         require(num2 * den1 / den1 == num2, "overflow");
296 
297         return (num1 * den2 < num2 * den1);
298     }
299 
300     /// @notice determines whether token has been approved (whitelisted) on DutchX
301     /// @param token address of ERC-20 token in question
302     /// @return bool - whether token has been approved (whitelisted)
303     function isWhitelisted(address token) 
304         public
305         view
306         returns (bool) 
307     {
308         return dutchX.approvedTokens(token);
309     }
310 }
311 
312 // File: /Users/anxo/code/gnosis/dx-price-oracle/node_modules/@gnosis.pm/dx-contracts/contracts/base/AuctioneerManaged.sol
313 
314 contract AuctioneerManaged {
315     // auctioneer has the power to manage some variables
316     address public auctioneer;
317 
318     function updateAuctioneer(address _auctioneer) public onlyAuctioneer {
319         require(_auctioneer != address(0), "The auctioneer must be a valid address");
320         auctioneer = _auctioneer;
321     }
322 
323     // > Modifiers
324     modifier onlyAuctioneer() {
325         // Only allows auctioneer to proceed
326         // R1
327         // require(msg.sender == auctioneer, "Only auctioneer can perform this operation");
328         require(msg.sender == auctioneer, "Only the auctioneer can nominate a new one");
329         _;
330     }
331 }
332 
333 // File: @gnosis.pm/dx-contracts/contracts/base/TokenWhitelist.sol
334 
335 contract TokenWhitelist is AuctioneerManaged {
336     // Mapping that stores the tokens, which are approved
337     // Only tokens approved by auctioneer generate frtToken tokens
338     // addressToken => boolApproved
339     mapping(address => bool) public approvedTokens;
340 
341     event Approval(address indexed token, bool approved);
342 
343     /// @dev for quick overview of approved Tokens
344     /// @param addressesToCheck are the ERC-20 token addresses to be checked whether they are approved
345     function getApprovedAddressesOfList(address[] calldata addressesToCheck) external view returns (bool[] memory) {
346         uint length = addressesToCheck.length;
347 
348         bool[] memory isApproved = new bool[](length);
349 
350         for (uint i = 0; i < length; i++) {
351             isApproved[i] = approvedTokens[addressesToCheck[i]];
352         }
353 
354         return isApproved;
355     }
356     
357     function updateApprovalOfToken(address[] memory token, bool approved) public onlyAuctioneer {
358         for (uint i = 0; i < token.length; i++) {
359             approvedTokens[token[i]] = approved;
360             emit Approval(token[i], approved);
361         }
362     }
363 
364 }
365 
366 // File: contracts/WhitelistPriceOracle.sol
367 
368 /// @title A DutchXPriceOracle that uses it's own whitelisted tokens instead of the ones of the DutchX
369 /// @author Angel Rodriguez - angel@gnosis.pm
370 contract WhitelistPriceOracle is TokenWhitelist, DutchXPriceOracle {
371     constructor(DutchX _dutchX, address _ethToken, address _auctioneer)
372         DutchXPriceOracle(_dutchX, _ethToken)
373         public
374     {
375         auctioneer = _auctioneer;
376     }
377 
378     function isWhitelisted(address token) 
379         public
380         view
381         returns (bool) 
382     {
383         return approvedTokens[token];
384     }
385 }