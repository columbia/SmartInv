1 /**
2  * Ether sheet music
3  */
4 
5 pragma solidity ^0.4.21;
6 
7 
8 /**
9  * Ownable contract base
10  */
11 
12 contract OwnableContract {
13 
14     address private owner;
15 
16     function OwnableContract() public {
17 
18         owner = msg.sender;
19 
20     }
21 
22     modifier onlyOwner() {
23 
24         require( msg.sender == owner );
25         _;
26 
27     }
28 
29     function getOwner() public view returns ( address ) {
30 
31         return owner;
32 
33     }
34 
35     function changeOwner( address newOwner ) onlyOwner public {
36 
37         owner = newOwner;
38 
39     }
40 }
41 
42 
43 /**
44  * Main sheet music contract
45  */
46 
47 contract SheetMusic is OwnableContract {
48 
49     /**
50      * Note lengths
51      */
52 
53     enum NoteLength {
54 
55         WHOLE_NOTE,
56 
57         DOTTED_HALF_NOTE,
58 
59         HALF_NOTE,
60 
61         DOTTED_QUARTER_NOTE,
62 
63         QUARTER_NOTE,
64 
65         DOTTED_EIGHTH_NOTE,
66 
67         EIGHTH_NOTE,
68 
69         DOTTED_SIXTEENTH_NOTE,
70 
71         SIXTEENTH_NOTE
72 
73     }
74 
75 
76     /**
77      * Note struct
78      */
79 
80     struct Beat {
81 
82         address maker;
83 
84         uint8[] midiNotes;
85 
86         NoteLength length;
87 
88         uint donation; //In weis
89 
90     }
91 
92 
93     /**
94      * Internal props
95      */
96 
97     mapping( uint => Beat ) private notes;
98 
99     uint private numNotes;
100 
101     address private donatee;
102 
103 
104     //Values donated toward goal and milestone
105 
106     uint private totalValue;
107 
108     uint private milestoneValue;
109 
110 
111     //Goals
112 
113     uint constant DONATION_GOAL = 100 ether;
114 
115     uint private minDonation = 0.005 ether;
116 
117 
118     //Transfer after a certain amount
119 
120     uint private milestoneGoal = 5 ether;
121 
122 
123     //Full donation goal met
124 
125     bool private donationMet = false;
126 
127 
128     /**
129      * Midi requirements
130      */
131 
132     uint8 constant MIDI_LOWEST_NOTE = 21;
133 
134     uint8 constant MIDI_HIGHEST_NOTE = 108;
135 
136 
137     /**
138      * Events
139      */
140 
141     event NoteCreated( address indexed maker, uint id, uint donation );
142 
143     event DonationCreated( address indexed maker, uint donation );
144 
145     event DonationTransfered( address donatee, uint value );
146 
147     event DonationGoalReached( address MrCool );
148 
149     event MilestoneMet( address donater );
150 
151 
152     /**
153      * Construct
154      */
155 
156     function SheetMusic( address donateeArg ) public {
157 
158         donatee = donateeArg;
159 
160     }
161 
162 
163     /**
164      * Main create note
165      * There is no 0 note. First one is 1
166      */
167 
168     function createBeat( uint8[] midiNotes, NoteLength length ) external payable {
169 
170         totalValue += msg.value;
171         milestoneValue += msg.value;
172 
173 
174         //Check note min value
175 
176         require( msg.value >= minDonation );
177 
178 
179         //Check valid notes
180 
181         checkMidiNotesValue( midiNotes );
182 
183 
184         //Create note
185 
186         Beat memory newBeat = Beat({
187             maker: msg.sender,
188             donation: msg.value,
189             midiNotes: midiNotes,
190             length: length
191         });
192 
193         notes[ ++ numNotes ] = newBeat;
194 
195         emit NoteCreated( msg.sender, numNotes, msg.value );
196 
197         checkGoal( msg.sender );
198 
199     }
200 
201 
202     /**
203      * Create passage or number of beats
204      * Nested array unimplemented right now
205      */
206 
207     function createPassage( uint8[] userNotes, uint[] userDivider, NoteLength[] lengths )
208         external
209         payable
210     {
211 
212         //Add values regardless if valid
213 
214         totalValue += msg.value;
215         milestoneValue += msg.value;
216 
217         uint userNumberBeats = userDivider.length;
218         uint userNumberLength = lengths.length;
219 
220 
221         //Check note min value and lengths equal eachother
222         //Check valid midi notes
223 
224         require( userNumberBeats == userNumberLength );
225 
226         require( msg.value >= ( minDonation * userNumberBeats ) );
227 
228         checkMidiNotesValue( userNotes );
229 
230 
231         //Create beats
232 
233         uint noteDonation = msg.value / userNumberBeats;
234         uint lastDivider = 0;
235 
236         for( uint i = 0; i < userNumberBeats; ++ i ) {
237 
238             uint divide = userDivider[ i ];
239             NoteLength length = lengths[ i ];
240 
241             uint8[] memory midiNotes = splice( userNotes, lastDivider, divide );
242 
243             Beat memory newBeat = Beat({
244                 maker: msg.sender,
245                 donation: noteDonation,
246                 midiNotes: midiNotes,
247                 length: length
248             });
249 
250             lastDivider = divide;
251 
252             notes[ ++ numNotes ] = newBeat;
253 
254             emit NoteCreated( msg.sender, numNotes, noteDonation );
255 
256         }
257 
258         checkGoal( msg.sender );
259 
260     }
261 
262 
263     /**
264      * Random value add to contract
265      */
266 
267     function () external payable {
268 
269         totalValue += msg.value;
270         milestoneValue += msg.value;
271 
272         checkGoal( msg.sender );
273 
274     }
275 
276 
277     /**
278      * Donate with intent
279      */
280 
281     function donate() external payable {
282 
283         totalValue += msg.value;
284         milestoneValue += msg.value;
285 
286         emit DonationCreated( msg.sender, msg.value );
287 
288         checkGoal( msg.sender );
289 
290     }
291 
292 
293     /**
294      * Check if goal reached
295      */
296 
297     function checkGoal( address maker ) internal {
298 
299         if( totalValue >= DONATION_GOAL && ! donationMet ) {
300 
301             donationMet = true;
302 
303             emit DonationGoalReached( maker );
304 
305         }
306 
307         if( milestoneValue >= milestoneGoal ) {
308 
309             transferMilestone();
310             milestoneValue = 0;
311 
312         }
313 
314     }
315 
316 
317     /**
318      * Getters for notes
319      */
320 
321     function getNumberOfBeats() external view returns ( uint ) {
322 
323         return numNotes;
324 
325     }
326 
327     function getBeat( uint id ) external view returns (
328         address,
329         uint8[],
330         NoteLength,
331         uint
332     ) {
333 
334         Beat storage beat = notes[ id ];
335 
336         return (
337             beat.maker,
338             beat.midiNotes,
339             beat.length,
340             beat.donation
341         );
342 
343     }
344 
345 
346     /**
347      * Stats getter
348      */
349 
350     function getDonationStats() external view returns (
351         uint goal,
352         uint minimum,
353         uint currentValue,
354         uint milestoneAmount,
355         address donateeAddr
356     ) {
357 
358         return (
359             DONATION_GOAL,
360             minDonation,
361             totalValue,
362             milestoneGoal,
363             donatee
364         );
365 
366     }
367 
368     function getTotalDonated() external view returns( uint ) {
369 
370         return totalValue;
371 
372     }
373 
374     function getDonatee() external view returns( address ) {
375 
376         return donatee;
377 
378     }
379 
380 
381     /**
382      * Finishers
383      */
384 
385     function transferMilestone() internal {
386 
387         uint balance = address( this ).balance;
388 
389         donatee.transfer( balance );
390 
391         emit DonationTransfered( donatee, balance );
392 
393     }
394 
395 
396     /**
397      * Internal checks and requires for valid notes
398      */
399 
400     function checkMidiNoteValue( uint8 midi ) pure internal {
401 
402         require( midi >= MIDI_LOWEST_NOTE && midi <= MIDI_HIGHEST_NOTE );
403 
404     }
405 
406     function checkMidiNotesValue( uint8[] midis ) pure internal {
407 
408         uint num = midis.length;
409 
410         //require less or equal to all notes allowed
411 
412         require( num <= ( MIDI_HIGHEST_NOTE - MIDI_LOWEST_NOTE ) );
413 
414         for( uint i = 0; i < num; ++ i ) {
415 
416             checkMidiNoteValue( midis[ i ] );
417 
418         }
419 
420     }
421 
422 
423     /**
424      * Owner setters for future proofing
425      */
426 
427     function setMinDonation( uint newMin ) onlyOwner external {
428 
429         minDonation = newMin;
430 
431     }
432 
433     function setMilestone( uint newMile ) onlyOwner external {
434 
435         milestoneGoal = newMile;
436 
437     }
438 
439 
440     /**
441      * Array splice function
442      */
443 
444     function splice( uint8[] arr, uint index, uint to )
445         pure
446         internal
447         returns( uint8[] )
448     {
449 
450         uint8[] memory output = new uint8[]( to - index );
451         uint counter = 0;
452 
453         for( uint i = index; i < to; ++ i ) {
454 
455             output[ counter ] = arr[ i ];
456 
457             ++ counter;
458 
459         }
460 
461         return output;
462 
463     }
464 
465 }