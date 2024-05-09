1 /*
2  * Kryptium Oracle Smart Contract v.1.0.0
3  * Copyright © 2018 Kryptium Team <info@kryptium.io>
4  * Author: Giannis Zarifis <jzarifis@kryptium.io>
5  * 
6  * The Oracle smart contract is used by the House smart contract (and, in turn, 
7  * the betting app) as a “trusted source of truth” for upcoming events and their 
8  * outcomes. It is managed by an entity trusted by the owner of the House.
9  *
10  * This program is free to use according the Terms and Conditions available at
11  * <https://kryptium.io/terms-and-conditions/>. You cannot resell it or copy any
12  * part of it or modify it without permission from the Kryptium Team.
13  *
14  * This program is distributed in the hope that it will be useful, but WITHOUT 
15  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
16  * FOR A PARTICULAR PURPOSE. See the Terms and Conditions for more details.
17  */
18 
19 pragma solidity ^0.5.0;
20 
21 /**
22  * SafeMath
23  * Math operations with safety checks that throw on error
24  */
25 contract SafeMath {
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a * b;
28         assert(a == 0 || c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b != 0); // Solidity automatically throws when dividing by 0
34         uint256 c = a / b;
35         assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50     function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal pure returns (uint256) {
51         return div(mul(number, numerator), denominator);
52     }
53 }
54 
55 contract Owned {
56 
57     address public owner;
58 
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address newOwner) onlyOwner public {
69         require(newOwner != address(0x0));
70         owner = newOwner;
71     }
72 }
73 
74 /*
75  * Kryptium Oracle Smart Contract.  
76  */
77 contract Oracle is SafeMath, Owned {
78 
79     enum EventOutputType { stringarray, numeric }
80 
81     uint private eventNextId;
82     uint private subcategoryNextId;
83 
84     struct Event { 
85         uint id;
86         string  title;
87         uint  startDateTime;   
88         uint  endDateTime;
89         uint  subcategoryId;   
90         uint  categoryId;   
91         uint closeDateTime;     
92         uint freezeDateTime;
93         bool isCancelled;
94         string announcement;
95         uint totalAvailableOutputs;
96     } 
97 
98     struct EventOutcome {
99         uint256 outcome1;
100         uint256 outcome2;
101         uint256 outcome3;
102         uint256 outcome4;
103         uint256 outcome5;
104         uint256 outcome6;
105     }
106 
107 
108 
109     struct EventOutput {
110         bool isSet;
111         string title;
112         uint possibleResultsCount;
113         EventOutputType  eventOutputType;
114         string announcement; 
115         uint decimals;
116     }
117 
118 
119     struct OracleData { 
120         string  name;
121         string  creatorName;
122         uint  closeBeforeStartTime;   
123         uint  closeEventOutcomeTime;
124         uint version;      
125     } 
126 
127     struct Subcategory {
128         uint id;
129         uint  categoryId; 
130         string name;
131         string country;
132         bool hidden;
133     }
134 
135     OracleData public oracleData;  
136 
137     // This creates an array with all sucategories
138     mapping (uint => Subcategory) public subcategories;
139 
140     // This creates an array with all events
141     mapping (uint => Event) public events;
142 
143     // Event output possible results
144     mapping (uint =>mapping (uint => mapping (uint => bytes32))) public eventOutputPossibleResults;  
145 
146     // Event output Outcome
147     mapping (uint => mapping (uint => EventOutput)) public eventOutputs;
148 
149     //Event output outcome
150     mapping (uint => mapping (uint => uint)) public eventOutcome;
151 
152     //Event output outcome numeric
153     mapping (uint => mapping (uint => EventOutcome)) public eventNumericOutcomes;
154 
155 
156 
157     // Notifies clients that a new Oracle was launched
158     event OracleCreated();
159 
160     // Notifies clients that the details of an Oracle were changed
161     event OraclePropertiesUpdated();    
162 
163     // Notifies clients that an Oracle subcategory was added
164     event OracleSubcategoryAdded(uint id);    
165 
166     // Notifies clients that an Oracle subcategory was changed
167     event OracleSubcategoryUpdated(uint id);    
168     
169     // Notifies clients that an Oracle Event was changed
170     event UpcomingEventUpdated(uint id,uint closeDateTime);
171 
172 
173 
174     /**
175      * Constructor function
176      * Initializes Oracle contract
177      */
178     constructor(string memory oracleName, string memory oracleCreatorName, uint closeBeforeStartTime, uint closeEventOutcomeTime, uint version) public {
179         oracleData.name = oracleName;
180         oracleData.creatorName = oracleCreatorName;
181         oracleData.closeBeforeStartTime = closeBeforeStartTime;
182         oracleData.closeEventOutcomeTime = closeEventOutcomeTime;
183         oracleData.version = version;
184         emit OracleCreated();
185     }
186 
187      /**
188      * Update Oracle Data function
189      *
190      * Updates Oracle Data
191      */
192     function updateOracleNames(string memory newName, string memory newCreatorName) onlyOwner public {
193         oracleData.name = newName;
194         oracleData.creatorName = newCreatorName;
195         emit OraclePropertiesUpdated();
196     }    
197 
198      /**
199      * Update Oracle Time Constants function
200      *
201      * Updates Oracle Time Constants
202      */
203     function setTimeConstants(uint closeBeforeStartTime, uint closeEventOutcomeTime) onlyOwner public {
204         oracleData.closeBeforeStartTime = closeBeforeStartTime;
205         oracleData.closeEventOutcomeTime = closeEventOutcomeTime;
206         emit OraclePropertiesUpdated();
207     }      
208 
209 
210     /**
211      * Adds an Oracle Subcategory
212      */
213     function setSubcategory(uint id, uint categoryId, string memory name,string memory country,bool hidden) onlyOwner public {
214         if (id==0) {
215             subcategoryNextId += 1;
216             id = subcategoryNextId;
217         }
218         subcategories[id].id = id;
219         subcategories[id].categoryId = categoryId;
220         subcategories[id].name = name;
221         subcategories[id].country = country;
222         subcategories[id].hidden = hidden;
223         emit OracleSubcategoryAdded(id);
224     }  
225 
226     /**
227      * Hides an Oracle Subcategory
228      */
229     function hideSubcategory(uint id) onlyOwner public {
230         subcategories[id].hidden = true;
231         emit OracleSubcategoryUpdated(id);
232     }   
233 
234 
235     /**
236      * Adds an Upcoming Event
237      */
238     function addUpcomingEvent(uint id, string memory title, uint startDateTime, uint endDateTime, uint subcategoryId, uint categoryId, string memory outputTitle, EventOutputType eventOutputType, bytes32[] memory _possibleResults,uint decimals) onlyOwner public {        
239         if (id==0) {
240             eventNextId += 1;
241             id = eventNextId;
242         }
243         
244         uint closeDateTime = startDateTime - oracleData.closeBeforeStartTime * 1 minutes;
245         uint freezeDateTime = endDateTime + oracleData.closeEventOutcomeTime * 1 minutes;
246         require(closeDateTime >= now,"Close time should be greater than now");
247         events[id].id = id;
248         events[id].title = title;
249         events[id].startDateTime = startDateTime;
250         events[id].endDateTime = endDateTime;
251         events[id].subcategoryId = subcategoryId;
252         events[id].categoryId = categoryId;
253         events[id].closeDateTime = closeDateTime;
254         events[id].freezeDateTime = freezeDateTime;
255         eventOutputs[id][0].title = outputTitle;
256         eventOutputs[id][0].possibleResultsCount = _possibleResults.length;
257         eventOutputs[id][0].eventOutputType = eventOutputType;
258         eventOutputs[id][0].decimals = decimals;
259         for (uint j = 0; j<_possibleResults.length; j++) {
260             eventOutputPossibleResults[id][0][j] = _possibleResults[j];            
261         }
262         if (events[id].totalAvailableOutputs < 1) {
263             events[id].totalAvailableOutputs = 1;
264         }      
265         emit UpcomingEventUpdated(id,closeDateTime);
266     }  
267 
268     /**
269      * Adds a new output to existing an Upcoming Event
270      */
271     function addUpcomingEventOutput(uint id, string memory outputTitle, EventOutputType eventOutputType, bytes32[] memory _possibleResults,uint decimals) onlyOwner public {
272         require(events[id].closeDateTime >= now,"Close time should be greater than now");
273         eventOutputs[id][events[id].totalAvailableOutputs].title = outputTitle;
274         eventOutputs[id][events[id].totalAvailableOutputs].possibleResultsCount = _possibleResults.length;
275         eventOutputs[id][events[id].totalAvailableOutputs].eventOutputType = eventOutputType;
276         eventOutputs[id][events[id].totalAvailableOutputs].decimals = decimals;
277         for (uint j = 0; j<_possibleResults.length; j++) {
278             eventOutputPossibleResults[id][events[id].totalAvailableOutputs][j] = _possibleResults[j];
279         }  
280         events[id].totalAvailableOutputs += 1;             
281         emit UpcomingEventUpdated(id,events[id].closeDateTime);
282     }
283 
284     /**
285      * Updates an Upcoming Event
286      */
287     function updateUpcomingEvent(uint id, string memory title, uint startDateTime, uint endDateTime, uint subcategoryId, uint categoryId) onlyOwner public {
288         uint closeDateTime = startDateTime - oracleData.closeBeforeStartTime * 1 minutes;
289         uint freezeDateTime = endDateTime + oracleData.closeEventOutcomeTime * 1 minutes;
290         events[id].title = title;
291         events[id].startDateTime = startDateTime;
292         events[id].endDateTime = endDateTime;
293         events[id].subcategoryId = subcategoryId;
294         events[id].categoryId = categoryId;
295         events[id].closeDateTime = closeDateTime;
296         events[id].freezeDateTime = freezeDateTime;
297         if (closeDateTime < now) {
298             events[id].isCancelled = true;
299         }  
300         emit UpcomingEventUpdated(id,closeDateTime); 
301     }     
302 
303     /**
304      * Cancels an Upcoming Event
305      */
306     function cancelUpcomingEvent(uint id) onlyOwner public {
307         require(events[id].freezeDateTime >= now,"Freeze time should be greater than now");
308         events[id].isCancelled = true;
309         emit UpcomingEventUpdated(id,events[id].closeDateTime); 
310     }  
311 
312 
313     /**
314      * Set the numeric type outcome of Event output
315      */
316     function setEventOutcomeNumeric(uint eventId, uint outputId, string memory announcement, bool setEventAnnouncement, uint256 outcome1, uint256 outcome2,uint256 outcome3,uint256 outcome4, uint256 outcome5, uint256 outcome6) onlyOwner public {
317         require(events[eventId].freezeDateTime > now,"Freeze time should be greater than now");
318         require(!events[eventId].isCancelled,"Cancelled Event");
319         require(eventOutputs[eventId][outputId].eventOutputType == EventOutputType.numeric,"Required numeric Event type");
320         eventNumericOutcomes[eventId][outputId].outcome1 = outcome1;
321         eventNumericOutcomes[eventId][outputId].outcome2 = outcome2;
322         eventNumericOutcomes[eventId][outputId].outcome3 = outcome3;
323         eventNumericOutcomes[eventId][outputId].outcome4 = outcome4;
324         eventNumericOutcomes[eventId][outputId].outcome5 = outcome5;
325         eventNumericOutcomes[eventId][outputId].outcome6 = outcome6;
326         eventOutputs[eventId][outputId].isSet = true;
327         eventOutputs[eventId][outputId].announcement = announcement;
328         if (setEventAnnouncement) {
329             events[eventId].announcement = announcement;
330         }     
331         emit UpcomingEventUpdated(eventId,events[eventId].closeDateTime); 
332     }  
333 
334      /**
335      * Set the outcome of Event output
336      */
337     function setEventOutcome(uint eventId, uint outputId, string memory announcement, bool setEventAnnouncement, uint _eventOutcome ) onlyOwner public {
338         require(events[eventId].freezeDateTime > now,"Freeze time should be greater than now");
339         require(!events[eventId].isCancelled,"Cancelled Event");
340         require(eventOutputs[eventId][outputId].eventOutputType == EventOutputType.stringarray,"Required array of options Event type");
341         eventOutputs[eventId][outputId].isSet = true;
342         eventOutcome[eventId][outputId] = _eventOutcome;
343         eventOutputs[eventId][outputId].announcement = announcement;
344         if (setEventAnnouncement) {
345             events[eventId].announcement = announcement;
346         } 
347         emit UpcomingEventUpdated(eventId,events[eventId].closeDateTime); 
348     } 
349 
350 
351     /**
352      * set a new freeze datetime of an Event
353      */
354     function freezeEventOutcome(uint id, uint newFreezeDateTime) onlyOwner public {
355         require(!events[id].isCancelled,"Cancelled Event");
356         if (newFreezeDateTime > now) {
357             events[id].freezeDateTime = newFreezeDateTime;
358         } else {
359             events[id].freezeDateTime = now;
360         }
361         emit UpcomingEventUpdated(id,events[id].closeDateTime);
362     } 
363 
364     /**
365      * Get event outcome numeric
366      */
367     function getEventOutcomeNumeric(uint eventId, uint outputId) public view returns(uint256 outcome1, uint256 outcome2,uint256 outcome3,uint256 outcome4, uint256 outcome5, uint256 outcome6) {
368         require(eventOutputs[eventId][outputId].isSet && eventOutputs[eventId][outputId].eventOutputType==EventOutputType.numeric);
369         return (eventNumericOutcomes[eventId][outputId].outcome1,eventNumericOutcomes[eventId][outputId].outcome2,eventNumericOutcomes[eventId][outputId].outcome3,eventNumericOutcomes[eventId][outputId].outcome4,eventNumericOutcomes[eventId][outputId].outcome5,eventNumericOutcomes[eventId][outputId].outcome6);
370     }
371 
372     /**
373      * Get event outcome
374      */
375     function getEventOutcome(uint eventId, uint outputId) public view returns(uint outcome) {
376         require(eventOutputs[eventId][outputId].isSet && eventOutputs[eventId][outputId].eventOutputType==EventOutputType.stringarray);
377         return (eventOutcome[eventId][outputId]);
378     }
379 
380      /**
381      * Get event outcome is Set
382      */
383     function getEventOutcomeIsSet(uint eventId, uint outputId) public view returns(bool isSet) {
384         return (eventOutputs[eventId][outputId].isSet);
385     }
386 
387 
388     /**
389      * Get event Info for Houses
390      */
391     function getEventForHousePlaceBet(uint id) public view returns(uint closeDateTime, uint freezeDateTime, bool isCancelled) {
392         return (events[id].closeDateTime,events[id].freezeDateTime, events[id].isCancelled);
393     }
394 
395 
396 }