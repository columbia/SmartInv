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