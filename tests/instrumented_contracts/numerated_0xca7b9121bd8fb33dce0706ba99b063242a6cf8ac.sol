1 pragma solidity ^0.4.8;
2 
3 contract Rubik {
4 
5     event Submission(address submitter, uint8[] moves);
6     event NewLeader(address submitter, uint8[] moves);
7 
8     enum Color {Red, Blue, Yellow, Green, White, Orange}
9     Color[9][6] state;
10 
11     address public owner = msg.sender;
12 
13     /* This variable tracks the current winner
14      e.g. the player/address who has submitted a valid solution
15      having the lowest number of moves
16 
17      Initialize the address to owner so the creator can withdraw
18      the funds in case nobody submits a valid solution.
19      */
20     address public currentWinner = msg.sender;
21 
22     /*
23         Keep the track of the number of moves that is
24         found in the current winning solution. Set the initial
25         value to something very large so that any valid solution
26         will override it.
27     */
28     uint currentWinnerMoveCount = 9000;
29 
30 
31     /*
32       The time when the contest ends. After this time it is not
33       possible to submit new solutions and the current winner can
34       claim the reward.
35 
36       The the end time to 30 days after the contract has been deployed.
37     */
38     uint contestEndTime = now + 2592000;
39 
40     uint8 constant FRONT = 0;
41     uint8 constant LEFT = 1;
42     uint8 constant UP = 2;
43     uint8 constant RIGHT = 3;
44     uint8 constant DOWN = 4;
45     uint8 constant BACK = 5;
46 
47     /*
48         Set the initial state for the cube in the constructor.
49         This is the puzzle you have to solve.
50     */
51 
52     function Rubik() public {
53         state[FRONT][0] = Color.Green;
54         state[FRONT][1] = Color.Green;
55         state[FRONT][2] = Color.Red;
56         state[FRONT][3] = Color.Yellow;
57         state[FRONT][4] = Color.Red;
58         state[FRONT][5] = Color.Green;
59         state[FRONT][6] = Color.Red;
60         state[FRONT][7] = Color.Yellow;
61         state[FRONT][8] = Color.Blue;
62 
63         state[LEFT][0] = Color.White;
64         state[LEFT][1] = Color.White;
65         state[LEFT][2] = Color.Yellow;
66         state[LEFT][3] = Color.Red;
67         state[LEFT][4] = Color.Blue;
68         state[LEFT][5] = Color.White;
69         state[LEFT][6] = Color.Red;
70         state[LEFT][7] = Color.Red;
71         state[LEFT][8] = Color.Blue;
72 
73         state[UP][0] = Color.Green;
74         state[UP][1] = Color.Blue;
75         state[UP][2] = Color.Yellow;
76         state[UP][3] = Color.White;
77         state[UP][4] = Color.Yellow;
78         state[UP][5] = Color.Orange;
79         state[UP][6] = Color.White;
80         state[UP][7] = Color.Blue;
81         state[UP][8] = Color.Blue;
82 
83         state[RIGHT][0] = Color.Yellow;
84         state[RIGHT][1] = Color.Red;
85         state[RIGHT][2] = Color.Orange;
86         state[RIGHT][3] = Color.Orange;
87         state[RIGHT][4] = Color.Green;
88         state[RIGHT][5] = Color.White;
89         state[RIGHT][6] = Color.Blue;
90         state[RIGHT][7] = Color.Orange;
91         state[RIGHT][8] = Color.Orange;
92 
93         state[DOWN][0] = Color.White;
94         state[DOWN][1] = Color.Red;
95         state[DOWN][2] = Color.Orange;
96         state[DOWN][3] = Color.Yellow;
97         state[DOWN][4] = Color.White;
98         state[DOWN][5] = Color.Yellow;
99         state[DOWN][6] = Color.Yellow;
100         state[DOWN][7] = Color.Blue;
101         state[DOWN][8] = Color.Green;
102 
103         state[BACK][0] = Color.Green;
104         state[BACK][1] = Color.Green;
105         state[BACK][2] = Color.Red;
106         state[BACK][3] = Color.Blue;
107         state[BACK][4] = Color.Orange;
108         state[BACK][5] = Color.Orange;
109         state[BACK][6] = Color.White;
110         state[BACK][7] = Color.Green;
111         state[BACK][8] = Color.Orange;
112     }
113 
114     function getOwner() view public returns (address)  {
115        return owner;
116     }
117 
118     function getCurrentWinner() view public returns (address)  {
119        return currentWinner;
120     }
121 
122     function getCurrentWinnerMoveCount() view public returns (uint)  {
123        return currentWinnerMoveCount;
124     }
125 
126     function getBalance() view public returns (uint256) {
127         return this.balance;
128     }
129 
130     function getContestEndTime() view public returns (uint256) {
131         return contestEndTime;
132     }
133 
134     /*
135      This function is used to set the reward for the winner.
136      Only the owner of the contract is allowed to set the reward
137     */
138     function addBalance() public payable {
139         require(msg.sender == owner);
140     }
141 
142 
143     /*
144      Checks that a given side is of correct color.
145     */
146 
147     function verifySide(Color[9][6] memory aState, uint8 FACE, Color expectedColor) internal pure returns (bool) {
148         return aState[FACE][0] == expectedColor &&
149         aState[FACE][1] == expectedColor &&
150         aState[FACE][2] == expectedColor &&
151         aState[FACE][3] == expectedColor &&
152         aState[FACE][4] == expectedColor &&
153         aState[FACE][5] == expectedColor &&
154         aState[FACE][6] == expectedColor &&
155         aState[FACE][7] == expectedColor &&
156         aState[FACE][8] == expectedColor;
157     }
158 
159 
160     /*
161     Checks if the given state is in solved state.
162     The cube is solved if the state equals:
163     [[0, 0, 0, 0, 0, 0, 0, 0, 0], [1, 1, 1, 1, 1, 1, 1, 1, 1], [2, 2, 2, 2, 2, 2, 2, 2, 2], [3, 3, 3, 3, 3, 3, 3, 3, 3], [4, 4, 4, 4, 4, 4, 4, 4, 4], [5, 5, 5, 5, 5, 5, 5, 5, 5]]
164     */
165 
166     function isSolved(Color[9][6] memory aState) public pure returns (bool) {
167         return verifySide(aState, FRONT, Color.Red) &&
168         verifySide(aState, LEFT, Color.Blue) &&
169         verifySide(aState, UP, Color.Yellow) &&
170         verifySide(aState, RIGHT, Color.Green) &&
171         verifySide(aState, DOWN, Color.White) &&
172         verifySide(aState, BACK, Color.Orange);
173     }
174 
175     function getInitialState() public view returns (Color[9][6])  {
176         return state;
177     }
178 
179 
180     /*
181      Shuffles a single side of a face. For instance:
182 
183          1 2 3       7 4 1
184          4 5 6   ->  8 5 2
185          7 8 9       9 6 3
186 
187      Calling only this function does not leave the cube in a valid state as
188      also the "sides" of the cubes must move.
189     */
190 
191     function shuffleFace(Color[9][6] memory aState, uint FACE) pure internal {
192         Color[9] memory swap;
193         swap[0] = aState[FACE][0];
194         swap[1] = aState[FACE][1];
195         swap[2] = aState[FACE][2];
196         swap[3] = aState[FACE][3];
197         swap[4] = aState[FACE][4];
198         swap[5] = aState[FACE][5];
199         swap[6] = aState[FACE][6];
200         swap[7] = aState[FACE][7];
201         swap[8] = aState[FACE][8];
202 
203         aState[FACE][0] = swap[2];
204         aState[FACE][1] = swap[5];
205         aState[FACE][2] = swap[8];
206         aState[FACE][3] = swap[1];
207         aState[FACE][4] = swap[4];
208         aState[FACE][5] = swap[7];
209         aState[FACE][6] = swap[0];
210         aState[FACE][7] = swap[3];
211         aState[FACE][8] = swap[6];
212     }
213 
214     function shuffleDown(Color[9][6] memory aState) pure internal {
215         shuffleFace(aState, DOWN);
216         Color[12] memory swap;
217         swap[0] = aState[FRONT][2];
218         swap[1] = aState[FRONT][5];
219         swap[2] = aState[FRONT][8];
220 
221         swap[3] = aState[RIGHT][2];
222         swap[4] = aState[RIGHT][5];
223         swap[5] = aState[RIGHT][8];
224 
225         swap[6] = aState[BACK][6];
226         swap[7] = aState[BACK][3];
227         swap[8] = aState[BACK][0];
228 
229         swap[9] = aState[LEFT][2];
230         swap[10] = aState[LEFT][5];
231         swap[11] = aState[LEFT][8];
232 
233         aState[FRONT][2] = swap[9];
234         aState[FRONT][5] = swap[10];
235         aState[FRONT][8] = swap[11];
236 
237         aState[RIGHT][2] = swap[0];
238         aState[RIGHT][5] = swap[1];
239         aState[RIGHT][8] = swap[2];
240 
241         aState[BACK][6] = swap[3];
242         aState[BACK][3] = swap[4];
243         aState[BACK][0] = swap[5];
244 
245         aState[LEFT][2] = swap[6];
246         aState[LEFT][5] = swap[7];
247         aState[LEFT][8] = swap[8];
248     }
249 
250 
251     function shuffleRight(Color[9][6] memory aState) pure internal {
252         shuffleFace(aState, RIGHT);
253         Color[12] memory swap;
254         swap[0] = aState[UP][8];
255         swap[1] = aState[UP][7];
256         swap[2] = aState[UP][6];
257 
258         swap[3] = aState[BACK][8];
259         swap[4] = aState[BACK][7];
260         swap[5] = aState[BACK][6];
261 
262         swap[6] = aState[DOWN][8];
263         swap[7] = aState[DOWN][7];
264         swap[8] = aState[DOWN][6];
265 
266         swap[9] = aState[FRONT][8];
267         swap[10] = aState[FRONT][7];
268         swap[11] = aState[FRONT][6];
269 
270         aState[UP][8] = swap[9];
271         aState[UP][7] = swap[10];
272         aState[UP][6] = swap[11];
273 
274         aState[BACK][8] = swap[0];
275         aState[BACK][7] = swap[1];
276         aState[BACK][6] = swap[2];
277 
278         aState[DOWN][8] = swap[3];
279         aState[DOWN][7] = swap[4];
280         aState[DOWN][6] = swap[5];
281 
282         aState[FRONT][8] = swap[6];
283         aState[FRONT][7] = swap[7];
284         aState[FRONT][6] = swap[8];
285     }
286 
287     function shuffleUp(Color[9][6] memory aState) pure internal {
288         shuffleFace(aState, UP);
289         Color[12] memory swap;
290         swap[0] = aState[BACK][2];
291         swap[1] = aState[BACK][5];
292         swap[2] = aState[BACK][8];
293 
294         swap[3] = aState[RIGHT][6];
295         swap[4] = aState[RIGHT][3];
296         swap[5] = aState[RIGHT][0];
297 
298         swap[6] = aState[FRONT][6];
299         swap[7] = aState[FRONT][3];
300         swap[8] = aState[FRONT][0];
301 
302         swap[9] = aState[LEFT][6];
303         swap[10] = aState[LEFT][3];
304         swap[11] = aState[LEFT][0];
305 
306         aState[BACK][2] = swap[9];
307         aState[BACK][5] = swap[10];
308         aState[BACK][8] = swap[11];
309 
310         aState[RIGHT][6] = swap[0];
311         aState[RIGHT][3] = swap[1];
312         aState[RIGHT][0] = swap[2];
313 
314         aState[FRONT][6] = swap[3];
315         aState[FRONT][3] = swap[4];
316         aState[FRONT][0] = swap[5];
317 
318         aState[LEFT][6] = swap[6];
319         aState[LEFT][3] = swap[7];
320         aState[LEFT][0] = swap[8];
321     }
322 
323 
324     function shuffleLeft(Color[9][6] memory aState) pure internal {
325         shuffleFace(aState, LEFT);
326         Color[12] memory swap;
327 
328         swap[0] = aState[UP][0];
329         swap[1] = aState[UP][1];
330         swap[2] = aState[UP][2];
331 
332         swap[3] = aState[FRONT][0];
333         swap[4] = aState[FRONT][1];
334         swap[5] = aState[FRONT][2];
335 
336         swap[6] = aState[DOWN][0];
337         swap[7] = aState[DOWN][1];
338         swap[8] = aState[DOWN][2];
339 
340         swap[9] = aState[BACK][0];
341         swap[10] = aState[BACK][1];
342         swap[11] = aState[BACK][2];
343 
344         aState[UP][0] = swap[9];
345         aState[UP][1] = swap[10];
346         aState[UP][2] = swap[11];
347 
348         aState[FRONT][0] = swap[0];
349         aState[FRONT][1] = swap[1];
350         aState[FRONT][2] = swap[2];
351 
352         aState[DOWN][0] = swap[3];
353         aState[DOWN][1] = swap[4];
354         aState[DOWN][2] = swap[5];
355 
356         aState[BACK][0] = swap[6];
357         aState[BACK][1] = swap[7];
358         aState[BACK][2] = swap[8];
359     }
360 
361     function shuffleFront(Color[9][6] memory aState) pure internal {
362         shuffleFace(aState, FRONT);
363         Color[12] memory swap;
364 
365         swap[0] = aState[UP][2];
366         swap[1] = aState[UP][5];
367         swap[2] = aState[UP][8];
368 
369         swap[3] = aState[RIGHT][0];
370         swap[4] = aState[RIGHT][1];
371         swap[5] = aState[RIGHT][2];
372 
373         swap[6] = aState[DOWN][6];
374         swap[7] = aState[DOWN][3];
375         swap[8] = aState[DOWN][0];
376 
377         swap[9] = aState[LEFT][8];
378         swap[10] = aState[LEFT][7];
379         swap[11] = aState[LEFT][6];
380 
381         aState[UP][2] = swap[9];
382         aState[UP][5] = swap[10];
383         aState[UP][8] = swap[11];
384 
385         aState[RIGHT][0] = swap[0];
386         aState[RIGHT][1] = swap[1];
387         aState[RIGHT][2] = swap[2];
388 
389         aState[DOWN][6] = swap[3];
390         aState[DOWN][3] = swap[4];
391         aState[DOWN][0] = swap[5];
392 
393         aState[LEFT][8] = swap[6];
394         aState[LEFT][7] = swap[7];
395         aState[LEFT][6] = swap[8];
396     }
397 
398     /*
399         Returns the state of the cube after performing the given moves.
400 
401         The moves parameter defines a set of moves that are applied to the cube
402         in its initial state.
403 
404         Only 5 types of moves are possible.
405      */
406     function trySolution(uint8[] moves) public view returns (Color[9][6]) {
407         Color[9][6] memory aState = state;
408 
409         for (uint i = 0; i < moves.length; i++) {
410             if (moves[i] == FRONT) {
411                 shuffleFront(aState);
412             } else if (moves[i] == LEFT) {
413                 shuffleLeft(aState);
414             } else if (moves[i] == UP) {
415                 shuffleUp(aState);
416             } else if (moves[i] == RIGHT) {
417                 shuffleRight(aState);
418             } else if (moves[i] == DOWN) {
419                 shuffleDown(aState);
420             } else {
421                 //invalid move;
422                 require(false);
423             }
424         }
425         return aState;
426     }
427 
428 
429     /*
430         The function that is used to submit the solution to the blockchain
431     */
432     function submitSolution(uint8[] moves) public {
433 
434         Submission(msg.sender, moves);
435         //don't allow submissions after contest time has passed
436         require(now < contestEndTime);
437         Color[9][6] memory stateAfterMoves = trySolution(moves);
438 
439         //the cube must be in a solved state
440         if (isSolved(stateAfterMoves)) {
441 
442             //the new leader is set if the solution has fewer moves than the current winner
443             if(moves.length < currentWinnerMoveCount) {
444                 currentWinnerMoveCount = moves.length;
445                 currentWinner = msg.sender;
446                 NewLeader(msg.sender, moves);
447             }
448         }
449     }
450 
451 /*
452     The function that allows the winner of the contest to
453     claim the reward after the contest has ended
454 */
455     function claim() public {
456         require(now >= contestEndTime);
457         require(msg.sender == currentWinner);
458         msg.sender.transfer(this.balance);
459     }
460 
461 }