1 pragma solidity ^0.4.11;
2 
3 /*  Copyright 2017 GoInto, LLC
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9         http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 */
17 
18 /**
19  * Storage contract for Etherep to store ratings and score data.  It's been 
20  * separated from the main contract because this is much less likely to change
21  * than the other parts.  It would allow for upgrading the main contract without
22  * losing data.
23  */
24 contract RatingStore {
25 
26     struct Score {
27         bool exists;
28         int cumulativeScore;
29         uint totalRatings;
30     }
31 
32     bool internal debug;
33     mapping (address => Score) internal scores;
34     // The manager with full access
35     address internal manager;
36     // The contract that has write accees
37     address internal controller;
38 
39     /// Events
40     event Debug(string message);
41 
42     /**
43      * Only the manager or controller can use this method
44      */
45     modifier restricted() { 
46         require(msg.sender == manager || tx.origin == manager || msg.sender == controller);
47         _; 
48     }
49 
50     /**
51      * Only a certain address can use this modified method
52      * @param by The address that can use the method
53      */
54     modifier onlyBy(address by) { 
55         require(msg.sender == by);
56         _; 
57     }
58 
59     /**
60      * Constructor
61      * @param _manager The address that has full access to the contract
62      * @param _controller The contract that can make write calls to this contract
63      */
64     function RatingStore(address _manager, address _controller) {
65         manager = _manager;
66         controller = _controller;
67         debug = false;
68     }
69 
70     /**
71      * Set a Score
72      * @param target The address' score we're setting
73      * @param cumulative The cumulative score for the address
74      * @param total Total individual ratings for the address
75      * @return success If the set was completed successfully
76      */
77     function set(address target, int cumulative, uint total) external restricted {
78         if (!scores[target].exists) {
79             scores[target] = Score(true, 0, 0);
80         }
81         scores[target].cumulativeScore = cumulative;
82         scores[target].totalRatings = total;
83     }
84 
85     /**
86      * Add a rating
87      * @param target The address' score we're adding to
88      * @param wScore The weighted rating to add to the score
89      * @return success
90      */
91     function add(address target, int wScore) external restricted {
92         if (!scores[target].exists) {
93             scores[target] = Score(true, 0, 0);
94         }
95         scores[target].cumulativeScore += wScore;
96         scores[target].totalRatings += 1;
97     }
98 
99     /**
100      * Get the score for an address
101      * @param target The address' score to return
102      * @return cumulative score
103      * @return total ratings
104      */
105     function get(address target) external constant returns (int, uint) {
106         if (scores[target].exists == true) {
107             return (scores[target].cumulativeScore, scores[target].totalRatings);
108         } else {
109             return (0,0);
110         }
111     }
112 
113     /**
114      * Reset an entire score storage
115      * @param target The address we're wiping clean
116      */
117     function reset(address target) external onlyBy(manager) {
118         scores[target] = Score(true, 0,0);
119     }
120 
121     /**
122      * Return the manager
123      * @return address The manager address
124      */
125     function getManager() external constant returns (address) {
126         return manager;
127     }
128 
129     /**
130      * Change the manager
131      * @param newManager The address we're setting as manager
132      */
133     function setManager(address newManager) external onlyBy(manager) {
134         manager = newManager;
135     }
136 
137     /**
138      * Return the controller
139      * @return address The manager address
140      */
141     function getController() external constant returns (address) {
142         return controller;
143     }
144 
145     /**
146      * Change the controller
147      * @param newController The address we're setting as controller
148      */
149     function setController(address newController) external onlyBy(manager) {
150         controller = newController;
151     }
152 
153     /**
154      * Return the debug setting
155      * @return bool debug
156      */
157     function getDebug() external constant returns (bool) {
158         return debug;
159     }
160 
161     /**
162      * Set debug
163      * @param _debug The bool value debug should be set to
164      */
165     function setDebug(bool _debug) external onlyBy(manager) {
166         debug = _debug;
167     }
168 
169 }
170 
171 /** Etherep - Simple Ethereum reputation by address
172 
173     Contract that takes ratings and calculates a reputation score.  It uses the 
174     RatingStore contract as its data storage.
175 
176     Ratings can be from -5(worst) to 5(best) and are weighted according to the 
177     score of the rater. This weight can have a significant skewing towards the
178     positive or negative but the representative score can not be below -5 or 
179     above 5.  Raters can not rate more often than waitTime, nor can they rate 
180     themselves.
181 
182     Scores are returned as a false-float, where 425 = 4.25 on the Etherep scale.
183  */
184 contract Etherep {
185 
186     bool internal debug;
187     address internal manager;
188     uint internal fee;
189     address internal storageAddress;
190     uint internal waitTime;
191     mapping (address => uint) internal lastRating;
192 
193     /// Events
194     event Error(
195         address sender,
196         string message
197     );
198     event Debug(string message);
199     event DebugInt(int message);
200     event DebugUint(uint message);
201     event Rating(
202         address by, 
203         address who, 
204         int rating
205     );
206     event FeeChanged(uint f);
207     event DelayChanged(uint d);
208 
209     /**
210      * Only a certain address can use this modified method
211      * @param by The address that can use the method
212      */
213     modifier onlyBy(address by) { 
214         require(msg.sender == by);
215         _; 
216     }
217 
218     /**
219      * Delay ratings to be at least waitTime apart
220      */
221     modifier delay() {
222         if (debug == false && lastRating[msg.sender] > now - waitTime) {
223             revert();
224         }
225         _;
226     }
227 
228     /**
229      * Require the minimum fee to be met
230      */
231     modifier requireFee() {
232         require(msg.value >= fee);
233         _;
234     }
235 
236     /** 
237      * Constructor
238      * @param _manager The key that can make changes to this contract
239      * @param _fee The variable fee that will be charged per rating
240      * @param _storageAddress The address to the storage contract
241      * @param _wait The minimum time in seconds a user has to wait between ratings
242      */
243     function Etherep(address _manager, uint _fee, address _storageAddress, uint _wait) {
244         manager = _manager;
245         fee = _fee;
246         storageAddress = _storageAddress;
247         waitTime = _wait;
248         debug = false;
249     }
250 
251     /**
252      * Set debug
253      * @param d The debug value that should be set
254      */
255     function setDebug(bool d) external onlyBy(manager) {
256         debug = d;
257     }
258 
259     /**
260      * Get debug
261      * @return debug
262      */
263     function getDebug() external constant returns (bool) {
264         return debug;
265     }
266 
267     /**
268      * Change the fee
269      * @param newFee New rating fee in Wei
270      */
271     function setFee(uint newFee) external onlyBy(manager) {
272         fee = newFee;
273         FeeChanged(fee);
274     }
275 
276     /**
277      * Get the fee
278      * @return fee The current fee in Wei
279      */
280     function getFee() external constant returns (uint) {
281         return fee;
282     }
283 
284     /**
285      * Change the rating delay
286      * @param _delay Delay in seconds
287      */
288     function setDelay(uint _delay) external onlyBy(manager) {
289         waitTime = _delay;
290         DelayChanged(waitTime);
291     }
292 
293     /**
294      * Get the delay time
295      * @return delay The current rating delay time in seconds
296      */
297     function getDelay() external constant returns (uint) {
298         return waitTime;
299     }
300 
301     /**
302      * Change the manager
303      * @param who The address of the new manager
304      */
305     function setManager(address who) external onlyBy(manager) {
306         manager = who;
307     }
308 
309     /**
310      * Get the manager
311      * @return manager The address of this contract's manager
312      */
313     function getManager() external constant returns (address) {
314         return manager;
315     }
316 
317     /**
318      * Drain fees
319      */
320     function drain() external onlyBy(manager) {
321         require(this.balance > 0);
322         manager.transfer(this.balance);
323     }
324 
325     /** 
326      * Adds a rating to an address' cumulative score
327      * @param who The address that is being rated
328      * @param rating The rating(-5 to 5)
329      * @return success If the rating was processed successfully
330      */
331     function rate(address who, int rating) external payable delay requireFee {
332 
333         // Check rating for sanity
334         require(rating <= 5 && rating >= -5);
335 
336         // A rater can not rate himself
337         require(who != msg.sender);
338 
339         // Get an instance of the RatingStore contract
340         RatingStore store = RatingStore(storageAddress);
341         
342         // Standard weight
343         int weight = 0;
344 
345         // Convert rating into a fake-float
346         int workRating = rating * 100;
347 
348         // We need the absolute value
349         int absRating;
350         if (rating >= 0) {
351             absRating = workRating;
352         } else {
353             absRating = -workRating;
354         }
355 
356         // Get details on sender if available
357         int senderScore;
358         uint senderRatings;
359         int senderCumulative = 0;
360         (senderScore, senderRatings) = store.get(msg.sender);
361 
362         // Calculate cumulative score if available for use in weighting. We're 
363         // acting as-if the two right-most places are decimals
364         if (senderScore != 0) {
365             senderCumulative = (senderScore / (int(senderRatings) * 100)) * 100;
366         }
367 
368         // Calculate the weight if the sender has a positive rating
369         if (senderCumulative > 0 && absRating != 0) {
370 
371             // Calculate a weight to add to the final rating calculation.  Only 
372             // raters who have a positive cumulative score will have any extra 
373             // weight.  Final weight should be between 40 and 100 and scale down
374             // depending on how strong the rating is.
375             weight = (senderCumulative + absRating) / 10;
376 
377             // We need the final weight to be signed the same as the rating
378             if (rating < 0) {
379                 weight = -weight;
380             }
381 
382         }
383         
384         // Add the weight to the rating
385         workRating += weight;
386 
387         // Set last rating timestamp
388         lastRating[msg.sender] = now;
389 
390         // Send event of the rating
391         Rating(msg.sender, who, workRating);
392 
393         // Add the new rating to their score
394         store.add(who, workRating);
395 
396     }
397 
398     /**
399      * Returns the cumulative score for an address
400      * @param who The address to lookup
401      * @return score The cumulative score
402      */
403     function getScore(address who) external constant returns (int score) {
404 
405         // Get an instance of our storage contract: RatingStore
406         RatingStore store = RatingStore(storageAddress);
407         
408         int cumulative;
409         uint ratings;
410 
411         // Get the raw scores from RatingStore
412         (cumulative, ratings) = store.get(who);
413         
414         // Calculate the score as a false-float as an average of all ratings
415         score = cumulative / int(ratings);
416 
417         // We only want to display a maximum of 500 or minimum of -500, even 
418         // if it's weighted outside of that range
419         if (score > 500) {
420             score = 500;
421         } else if (score < -500) {
422             score = -500;
423         }
424 
425     }
426 
427     /**
428      * Returns the cumulative score and count of ratings for an address
429      * @param who The address to lookup
430      * @return score The cumulative score
431      * @return count How many ratings have been made
432      */
433     function getScoreAndCount(address who) external constant returns (int score, uint ratings) {
434 
435         // Get an instance of our storage contract: RatingStore
436         RatingStore store = RatingStore(storageAddress);
437         
438         int cumulative;
439 
440         // Get the raw scores from RatingStore
441         (cumulative, ratings) = store.get(who);
442         
443         // The score should have room for 2 decimal places, but ratings is a 
444         // single count
445         score = cumulative / int(ratings);
446 
447     }
448 
449 }