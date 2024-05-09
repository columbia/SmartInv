1 /*
2  * Kryptium Oracle Smart Contract v.2.0.0
3  * Copyright © 2019 Kryptium Team <info@kryptium.io>
4  * Author: Giannis Zarifis <jzarifis@kryptium.io>
5  * 
6  * The Oracle smart contract is used by the House smart contract (and, in turn, 
7  * the betting app) as a “trusted source of truth” for upcoming events and their 
8  * outcomes. It is managed by an entity trusted by the owner of the House.
9  *
10  * This program is free to use according the Terms of Use available at
11  * <https://kryptium.io/terms-of-use/>. You cannot resell it or copy any
12  * part of it or modify it without permission from the Kryptium Team.
13  *
14  * This program is distributed in the hope that it will be useful, but WITHOUT 
15  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
16  * FOR A PARTICULAR PURPOSE. See the Terms of Use for more details.
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
57     address payable public owner;
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
68     function transferOwnership(address payable newOwner) onlyOwner public {
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
84 
85 
86     struct Event { 
87         string  title;
88         bool isCancelled;
89         uint256 dataCombined;
90         bytes32 announcement;
91     }
92 
93 
94 
95     struct EventOutcome {
96         uint256 outcome1;
97         uint256 outcome2;
98         uint256 outcome3;
99         uint256 outcome4;
100         uint256 outcome5;
101         uint256 outcome6;
102     }
103 
104 
105 
106     struct EventOutput {
107         uint256 dataCombined;
108         bool isSet;
109         bytes32 title;
110         //uint possibleResultsCount;
111         //uint outputDateTime;
112         EventOutputType  eventOutputType;
113         bytes32 announcement; 
114         //uint decimals;
115     }
116 
117 
118     struct OracleData { 
119         string  name;
120         string  creatorName;
121         uint version;      
122     } 
123 
124     struct Subcategory {
125         uint id;
126         uint  categoryId; 
127         string name;
128         string country;
129         bool hidden;
130     }
131 
132     OracleData public oracleData;  
133 
134     // This creates an array with all sucategories
135     mapping (uint => Subcategory) public subcategories;
136 
137     // This creates an array with all events
138     mapping (uint => Event) public events;
139 
140     // Event output possible results
141     mapping (uint =>mapping (uint => mapping (uint => bytes32))) public eventOutputPossibleResults;  
142 
143     // Event output Outcome
144     mapping (uint => mapping (uint => EventOutput)) public eventOutputs;
145 
146     //Event output outcome
147     mapping (uint => mapping (uint => uint)) public eventOutcome;
148 
149     //Event output outcome numeric
150     mapping (uint => mapping (uint => EventOutcome)) public eventNumericOutcomes;
151 
152 
153 
154     // Notifies clients that a new Oracle was launched
155     event OracleCreated();
156 
157     // Notifies clients that the details of an Oracle were changed
158     event OraclePropertiesUpdated();    
159 
160     // Notifies clients that an Oracle subcategory was added
161     event OracleSubcategoryAdded(uint id);    
162 
163     // Notifies clients that an Oracle subcategory was changed
164     event OracleSubcategoryUpdated(uint id);    
165     
166     // Notifies clients that an Oracle Event was changed
167     event UpcomingEventUpdated(uint id,uint closeDateTime);
168 
169 
170 
171     /**
172      * Constructor function
173      * Initializes Oracle contract
174      */
175     constructor(string memory oracleName, string memory oracleCreatorName, uint version) public {
176         oracleData.name = oracleName;
177         oracleData.creatorName = oracleCreatorName;
178         oracleData.version = version;
179         emit OracleCreated();
180     }
181 
182      /**
183      * Update Oracle Data function
184      *
185      * Updates Oracle Data
186      */
187     function updateOracleNames(string memory newName, string memory newCreatorName) onlyOwner public {
188         oracleData.name = newName;
189         oracleData.creatorName = newCreatorName;
190         emit OraclePropertiesUpdated();
191     }    
192 
193 
194 
195     /**
196      * Adds an Oracle Subcategory
197      */
198     function setSubcategory(uint id, uint categoryId, string memory name,string memory country,bool hidden) onlyOwner public {
199         if (id==0) {
200             subcategoryNextId += 1;
201             id = subcategoryNextId;
202         }
203         subcategories[id].id = id;
204         subcategories[id].categoryId = categoryId;
205         subcategories[id].name = name;
206         subcategories[id].country = country;
207         subcategories[id].hidden = hidden;
208         emit OracleSubcategoryAdded(id);
209     }  
210 
211     /**
212      * Hides an Oracle Subcategory
213      */
214     function hideSubcategory(uint id) onlyOwner public {
215         subcategories[id].hidden = true;
216         emit OracleSubcategoryUpdated(id);
217     }   
218   
219 
220     function setEventInternal(uint id, uint  startDateTime, uint  endDateTime, uint  subcategoryId, uint  categoryId, uint totalAvailableOutputs, uint timeStamp) private {
221         events[id].dataCombined = (startDateTime & 0xFFFFFFFF) | ((endDateTime & 0xFFFFFFFF) << 32) | ((subcategoryId & 0xFFFFFFFF) << 64) | ((categoryId & 0xFFFFFFFF) << 96) | ((totalAvailableOutputs & 0xFFFFFFFF) << 128) | ((timeStamp & 0xFFFFFFFF) << 160);
222     }
223 
224     function getEventInternal(uint id) public view returns (uint  startDateTime, uint  endDateTime, uint  subcategoryId, uint  categoryId, uint totalAvailableOutputs, uint timeStamp) {
225         uint256 dataCombined = events[id].dataCombined;
226         return (uint32(dataCombined), uint32(dataCombined >> 32), uint32(dataCombined >> 64), uint32(dataCombined >> 96), uint32(dataCombined >> 128), uint32(dataCombined >> 160));
227     }
228 
229     function setEventOutputInternal(uint eventId, uint eventOutputId, uint possibleResultsCount, uint outputDateTime, uint decimals) private {
230         eventOutputs[eventId][eventOutputId].dataCombined = (possibleResultsCount & 0xFFFFFFFF) | ((outputDateTime & 0xFFFFFFFF) << 32) | ((decimals & 0xFFFFFFFF) << 64);
231     }
232 
233     function getEventOutputInternal(uint eventId, uint eventOutputId) public view returns (uint possibleResultsCount, uint outputDateTime, uint decimals) {
234         uint256 dataCombined = eventOutputs[eventId][eventOutputId].dataCombined;
235         return (uint32(dataCombined), uint32(dataCombined >> 32), uint32(dataCombined >> 64));
236     }
237 
238     function setEventOutputDateTime(uint eventId, uint eventOutputId, uint outputDateTime) private {
239         (uint possibleResultsCount, , uint decimals) = getEventOutputInternal(eventId, eventOutputId);
240         eventOutputs[eventId][eventOutputId].dataCombined = (possibleResultsCount & 0xFFFFFFFF) | ((outputDateTime & 0xFFFFFFFF) << 32) | ((decimals & 0xFFFFFFFF) << 64);
241     }
242 
243     function getEventOutputDateTime(uint eventId, uint eventOutputId) private view returns (uint outputDateTime) {
244         return (uint32(eventOutputs[eventId][eventOutputId].dataCombined >> 32));
245     }
246 
247     /**
248      * Adds an Upcoming Event
249      */
250     function addUpcomingEvent(uint id, string memory title, uint startDateTime, uint endDateTime, uint subcategoryId, uint categoryId, bytes32 outputTitle, EventOutputType eventOutputType, bytes32[] memory _possibleResults, uint decimals, bool isCancelled) onlyOwner public {        
251         if (id==0) {
252             eventNextId += 1;
253             id = eventNextId;
254         }      
255         require(startDateTime > now,"Start time should be greater than now");
256         events[id].title = title;
257         events[id].isCancelled = isCancelled;
258         eventOutputs[id][0].title = outputTitle;
259         eventOutputs[id][0].eventOutputType = eventOutputType;
260         setEventOutputInternal(id,0,_possibleResults.length, endDateTime, decimals);
261         for (uint j = 0; j<_possibleResults.length; j++) {
262             eventOutputPossibleResults[id][0][j] = _possibleResults[j];            
263         }   
264         setEventInternal(id, startDateTime, endDateTime, subcategoryId, categoryId, 1, now); 
265         emit UpcomingEventUpdated(id,startDateTime);
266     }  
267 
268     // /**
269     //  * Adds a new output to existing an Upcoming Event
270     //  */
271     // function addUpcomingEventOutput(uint id, string memory outputTitle, EventOutputType eventOutputType, bytes32[] memory _possibleResults,uint decimals) onlyOwner public {
272     //     require(events[id].closeDateTime >= now,"Close time should be greater than now");
273     //     eventOutputs[id][events[id].totalAvailableOutputs].title = outputTitle;
274     //     eventOutputs[id][events[id].totalAvailableOutputs].possibleResultsCount = _possibleResults.length;
275     //     eventOutputs[id][events[id].totalAvailableOutputs].eventOutputType = eventOutputType;
276     //     eventOutputs[id][events[id].totalAvailableOutputs].decimals = decimals;
277     //     for (uint j = 0; j<_possibleResults.length; j++) {
278     //         eventOutputPossibleResults[id][events[id].totalAvailableOutputs][j] = _possibleResults[j];
279     //     }  
280     //     events[id].totalAvailableOutputs += 1;             
281     //     emit UpcomingEventUpdated(id,events[id].startDateTime);
282     // }
283 
284     /**
285      * Updates an Upcoming Event
286      */
287     function updateUpcomingEvent(uint id, string memory title, uint startDateTime, uint endDateTime, uint subcategoryId, uint categoryId) onlyOwner public {
288         if (startDateTime < now) {
289             events[id].isCancelled = true;
290         } else {       
291             events[id].title = title;
292             setEventInternal(id, startDateTime, endDateTime, subcategoryId, categoryId, 1, now); 
293         }
294 
295          
296         emit UpcomingEventUpdated(id,startDateTime); 
297     }     
298 
299     /**
300      * Cancels an Upcoming Event
301      */
302     function cancelUpcomingEvent(uint id) onlyOwner public {
303         (uint currentStartDateTime,,,,,) = getEventInternal(id);
304         events[id].isCancelled = true;
305         emit UpcomingEventUpdated(id,currentStartDateTime); 
306     }  
307 
308 
309     /**
310      * Set the numeric type outcome of Event output
311      */
312     function setEventOutcomeNumeric(uint eventId, uint outputId, bytes32 announcement, bool setEventAnnouncement, uint256 outcome1, uint256 outcome2,uint256 outcome3,uint256 outcome4, uint256 outcome5, uint256 outcome6) onlyOwner public {
313         (uint currentStartDateTime,,,,,) = getEventInternal(eventId);
314         require(currentStartDateTime < now,"Start time should be lower than now");
315         require(!events[eventId].isCancelled,"Cancelled Event");
316         require(eventOutputs[eventId][outputId].eventOutputType == EventOutputType.numeric,"Required numeric Event type");
317         eventNumericOutcomes[eventId][outputId].outcome1 = outcome1;
318         eventNumericOutcomes[eventId][outputId].outcome2 = outcome2;
319         eventNumericOutcomes[eventId][outputId].outcome3 = outcome3;
320         eventNumericOutcomes[eventId][outputId].outcome4 = outcome4;
321         eventNumericOutcomes[eventId][outputId].outcome5 = outcome5;
322         eventNumericOutcomes[eventId][outputId].outcome6 = outcome6;
323         eventOutputs[eventId][outputId].isSet = true;
324         eventOutputs[eventId][outputId].announcement = announcement;
325         setEventOutputDateTime(eventId, outputId, now);
326         if (setEventAnnouncement) {
327             events[eventId].announcement = announcement;
328         }     
329         emit UpcomingEventUpdated(eventId, currentStartDateTime); 
330     }  
331 
332      /**
333      * Set the outcome of Event output
334      */
335     function setEventOutcome(uint eventId, uint outputId, bytes32 announcement, bool setEventAnnouncement, uint _eventOutcome ) onlyOwner public {
336         (uint currentStartDateTime,,,,,) = getEventInternal(eventId);
337         require(currentStartDateTime < now,"Start time should be lower than now");
338         require(!events[eventId].isCancelled,"Cancelled Event");
339         require(eventOutputs[eventId][outputId].eventOutputType == EventOutputType.stringarray,"Required array of options Event type");
340         eventOutputs[eventId][outputId].isSet = true;
341         eventOutcome[eventId][outputId] = _eventOutcome;
342         setEventOutputDateTime(eventId, outputId, now);
343         eventOutputs[eventId][outputId].announcement = announcement;
344         if (setEventAnnouncement) {
345             events[eventId].announcement = announcement;
346         } 
347         emit UpcomingEventUpdated(eventId, currentStartDateTime); 
348     } 
349 
350 
351 
352 
353     /**
354      * Get event outcome numeric
355      */
356     function getEventOutcomeNumeric(uint eventId, uint outputId) public view returns(uint256 outcome1, uint256 outcome2,uint256 outcome3,uint256 outcome4, uint256 outcome5, uint256 outcome6) {
357         require(eventOutputs[eventId][outputId].isSet && eventOutputs[eventId][outputId].eventOutputType==EventOutputType.numeric);
358         return (eventNumericOutcomes[eventId][outputId].outcome1,eventNumericOutcomes[eventId][outputId].outcome2,eventNumericOutcomes[eventId][outputId].outcome3,eventNumericOutcomes[eventId][outputId].outcome4,eventNumericOutcomes[eventId][outputId].outcome5,eventNumericOutcomes[eventId][outputId].outcome6);
359     }
360 
361     /**
362      * Get event outcome
363      */
364     function getEventOutcome(uint eventId, uint outputId) public view returns(uint outcome) {
365         require(eventOutputs[eventId][outputId].isSet && eventOutputs[eventId][outputId].eventOutputType==EventOutputType.stringarray);
366         return (eventOutcome[eventId][outputId]);
367     }
368 
369      /**
370      * Get event outcome is Set
371      */
372     function getEventOutcomeIsSet(uint eventId, uint outputId) public view returns(bool isSet) {
373         return (eventOutputs[eventId][outputId].isSet);
374     }
375 
376 
377 
378     /**
379      * Get Event output possible results count
380     */
381     function getEventOutputPossibleResultsCount(uint id, uint outputId) public view returns(uint possibleResultsCount) {
382         return (uint32(eventOutputs[id][outputId].dataCombined));
383     }
384 
385     /**
386      * Get Oracle version
387     */
388     function getOracleVersion() public view returns(uint version) {
389         return oracleData.version;
390     }
391 
392     /**
393      * Get event start end info
394      */
395     function getEventDataForHouse(uint id, uint outputId) public view returns(uint startDateTime, uint outputDateTime, bool isCancelled, uint timeStamp) {
396         (uint currentStartDateTime,,,,,uint currentTimeStamp) = getEventInternal(id);
397         return (currentStartDateTime, getEventOutputDateTime(id, outputId), events[id].isCancelled, currentTimeStamp);
398     }
399 
400 
401 }