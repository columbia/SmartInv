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
171 /** Ethereum Reputation
172 
173     Contract that takes ratings and calculates a reputation score
174  */
175 contract Etherep {
176 
177     bool internal debug;
178     address internal manager;
179     uint internal fee;
180     address internal storageAddress;
181     uint internal waitTime;
182     mapping (address => uint) internal lastRating;
183 
184     /// Events
185     event Error(
186         address sender,
187         string message
188     );
189     event Debug(string message);
190     event DebugInt(int message);
191     event DebugUint(uint message);
192     event Rating(
193         address by, 
194         address who, 
195         int rating
196     );
197     event FeeChanged(uint f);
198     event DelayChanged(uint d);
199 
200     /**
201      * Only a certain address can use this modified method
202      * @param by The address that can use the method
203      */
204     modifier onlyBy(address by) { 
205         require(msg.sender == by);
206         _; 
207     }
208 
209     /**
210      * Delay ratings to be at least waitTime apart
211      */
212     modifier delay() {
213         if (debug == false && lastRating[msg.sender] > now - waitTime) {
214             Error(msg.sender, "Rating too often");
215             revert();
216         }
217         _;
218     }
219 
220     /**
221      * Require the minimum fee to be met
222      */
223     modifier requireFee() {
224         require(msg.value >= fee);
225         _;
226     }
227 
228     /** 
229      * Constructor
230      * @param _manager The key that can make changes to this contract
231      * @param _fee The variable fee that will be charged per rating
232      * @param _storageAddress The address to the storage contract
233      * @param _wait The minimum time in seconds a user has to wait between ratings
234      */
235     function Etherep(address _manager, uint _fee, address _storageAddress, uint _wait) {
236         manager = _manager;
237         fee = _fee;
238         storageAddress = _storageAddress;
239         waitTime = _wait;
240         debug = false;
241     }
242 
243     /**
244      * Set debug
245      * @param d The debug value that should be set
246      */
247     function setDebug(bool d) external onlyBy(manager) {
248         debug = d;
249     }
250 
251     /**
252      * Get debug
253      * @return debug
254      */
255     function getDebug() external constant returns (bool) {
256         return debug;
257     }
258 
259     /**
260      * Change the fee
261      * @param newFee New rating fee in Wei
262      */
263     function setFee(uint newFee) external onlyBy(manager) {
264         fee = newFee;
265         FeeChanged(fee);
266     }
267 
268     /**
269      * Get the fee
270      * @return fee The current fee in Wei
271      */
272     function getFee() external constant returns (uint) {
273         return fee;
274     }
275 
276     /**
277      * Change the rating delay
278      * @param _delay Delay in seconds
279      */
280     function setDelay(uint _delay) external onlyBy(manager) {
281         waitTime = _delay;
282         DelayChanged(waitTime);
283     }
284 
285     /**
286      * Get the delay time
287      * @return delay The current rating delay time in seconds
288      */
289     function getDelay() external constant returns (uint) {
290         return waitTime;
291     }
292 
293     /**
294      * Change the manager
295      * @param who The address of the new manager
296      */
297     function setManager(address who) external onlyBy(manager) {
298         manager = who;
299     }
300 
301     /**
302      * Get the manager
303      * @return manager The address of this contract's manager
304      */
305     function getManager() external constant returns (address) {
306         return manager;
307     }
308 
309     /**
310      * Drain fees
311      */
312     function drain() external onlyBy(manager) {
313         require(this.balance > 0);
314         manager.transfer(this.balance);
315     }
316 
317     /** 
318      * Adds a rating to an address' cumulative score
319      * @param who The address that is being rated
320      * @param rating The rating(-5 to 5)
321      * @return success If the rating was processed successfully
322      */
323     function rate(address who, int rating) external payable delay requireFee {
324 
325         require(rating <= 5 && rating >= -5);
326         require(who != msg.sender);
327 
328         RatingStore store = RatingStore(storageAddress);
329         
330         // Starting weight
331         int weight = 0;
332 
333         // Rating multiplier
334         int multiplier = 100;
335 
336         // We need the absolute value
337         int absRating = rating;
338         if (absRating < 0) {
339             absRating = -rating;
340         }
341 
342         // Get details on sender if available
343         int senderScore;
344         uint senderRatings;
345         int senderCumulative = 0;
346         (senderScore, senderRatings) = store.get(msg.sender);
347 
348         // Calculate cumulative score if available
349         if (senderScore != 0) {
350             senderCumulative = (senderScore / (int(senderRatings) * 100)) * 100;
351         }
352 
353         // Calculate the weight if the sender is rated above 0
354         if (senderCumulative > 0) {
355             weight = (((senderCumulative / 5) * absRating) / 10) + multiplier;
356         }
357         // Otherwise, unweighted
358         else {
359             weight = multiplier;
360         }
361         
362         // Calculate weighted rating
363         int workRating = rating * weight;
364 
365         // Set last rating timestamp
366         lastRating[msg.sender] = now;
367 
368         Rating(msg.sender, who, workRating);
369 
370         // Add the new rating to their score
371         store.add(who, workRating);
372 
373     }
374 
375     /**
376      * Returns the cumulative score for an address
377      * @param who The address to lookup
378      * @return score The cumulative score
379      */
380     function getScore(address who) external constant returns (int score) {
381 
382         RatingStore store = RatingStore(storageAddress);
383         
384         int cumulative;
385         uint ratings;
386         (cumulative, ratings) = store.get(who);
387         
388         // The score should have room for 2 decimal places, but ratings is a 
389         // single count
390         score = cumulative / int(ratings);
391 
392     }
393 
394     /**
395      * Returns the cumulative score and count of ratings for an address
396      * @param who The address to lookup
397      * @return score The cumulative score
398      * @return count How many ratings have been made
399      */
400     function getScoreAndCount(address who) external constant returns (int score, uint ratings) {
401 
402         RatingStore store = RatingStore(storageAddress);
403         
404         int cumulative;
405         (cumulative, ratings) = store.get(who);
406         
407         // The score should have room for 2 decimal places, but ratings is a 
408         // single count
409         score = cumulative / int(ratings);
410 
411     }
412 
413 }