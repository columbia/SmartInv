1 pragma solidity ^0.4.21;
2 
3 contract colors {
4     
5     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6     address public owner;
7     
8     mapping (uint => string) private messageLog;
9     mapping (uint => address) private senderLog;
10     mapping (uint => string) private senderColor;
11     mapping (address => string) private myColor;
12     mapping (address => uint) private colorCount;
13     uint private messageCount;
14     
15     uint private red;
16     uint private orange;
17     uint private yellow;
18     uint private green;
19     uint private blue;
20     uint private teal;
21     uint private purple;
22     uint private pink;
23     uint private black;
24     uint private white;
25     
26     function colors () public {
27         owner = msg.sender;
28         messageCount = 20;
29     }
30       
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35     
36     function transferOwnership(address newOwner) public onlyOwner {
37         require(newOwner != address(0));
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41     
42     function withdraw() external onlyOwner {
43 	    owner.transfer(this.balance);
44 	}
45 	
46 	modifier onlyRegistered () {
47 	    require (colorCount[msg.sender] > 0);
48 	    _;
49 	}
50 	
51 	function sendMessage (string _message) external onlyRegistered {
52 	    if (messageCount == 70) {
53 	        messageCount = 20;
54 	    }
55 	    messageCount++;
56 	    senderLog[messageCount] = (msg.sender);
57 	    senderColor[messageCount] = (myColor[msg.sender]);
58 	    messageLog[messageCount] = (_message);
59 	}
60 	
61 	
62 	function view22 () view public returns (address, string, string, address, string, string) {
63 	    return (senderLog[21], senderColor[21], messageLog[21], senderLog[22], senderColor[22], messageLog[22]);
64 	}
65 	
66 	function view24 () view public returns (address, string, string, address, string, string) {
67 	    return (senderLog[23], senderColor[23], messageLog[23], senderLog[24], senderColor[24], messageLog[24]);
68 	}
69 	
70 	function view26 () view public returns (address, string, string, address, string, string) {
71 	    return (senderLog[25], senderColor[25], messageLog[25], senderLog[26], senderColor[26], messageLog[26]);
72 	}
73 	
74 	function view28 () view public returns (address, string, string, address, string, string) {
75 	    return (senderLog[27], senderColor[27], messageLog[27], senderLog[28], senderColor[28], messageLog[28]);
76 	}
77 	
78 	function view30 () view public returns (address, string, string, address, string, string) {
79 	    return (senderLog[29], senderColor[29], messageLog[29], senderLog[30], senderColor[30], messageLog[30]);
80 	}
81 	
82 	function view32 () view public returns (address, string, string, address, string, string) {
83 	    return (senderLog[31], senderColor[31], messageLog[31], senderLog[32], senderColor[32], messageLog[32]);
84 	}
85 	
86 	function view34 () view public returns (address, string, string, address, string, string) {
87 	    return (senderLog[33], senderColor[33], messageLog[33], senderLog[34], senderColor[34], messageLog[34]);
88 	}
89 	
90 	function view36 () view public returns (address, string, string, address, string, string) {
91 	    return (senderLog[35], senderColor[35], messageLog[35], senderLog[36], senderColor[36], messageLog[36]);
92 	}
93 	
94 	function view38 () view public returns (address, string, string, address, string, string) {
95 	    return (senderLog[37], senderColor[37], messageLog[37], senderLog[38], senderColor[38], messageLog[38]);
96 	}
97 	
98 	function view40 () view public returns (address, string, string, address, string, string) {
99 	    return (senderLog[39], senderColor[39], messageLog[39], senderLog[40], senderColor[40], messageLog[40]);
100 	}
101 	
102 	function view42 () view public returns (address, string, string, address, string, string) {
103 	    return (senderLog[41], senderColor[41], messageLog[41], senderLog[42], senderColor[42], messageLog[42]);
104 	}
105 	
106 	function view44 () view public returns (address, string, string, address, string, string) {
107 	    return (senderLog[43], senderColor[43], messageLog[43], senderLog[44], senderColor[44], messageLog[44]);
108 	}
109 	
110 	function view46 () view public returns (address, string, string, address, string, string) {
111 	    return (senderLog[45], senderColor[45], messageLog[45], senderLog[46], senderColor[46], messageLog[46]);
112 	}
113 	
114 	function view48 () view public returns (address, string, string, address, string, string) {
115 	    return (senderLog[47], senderColor[47], messageLog[47], senderLog[48], senderColor[48], messageLog[48]);
116 	}
117 	
118 	function view50 () view public returns (address, string, string, address, string, string) {
119 	    return (senderLog[49], senderColor[49], messageLog[49], senderLog[50], senderColor[50], messageLog[50]);
120 	}
121 	
122 	function view52 () view public returns (address, string, string, address, string, string) {
123 	    return (senderLog[51], senderColor[51], messageLog[51], senderLog[52], senderColor[52], messageLog[52]);
124 	}
125 	
126 	function view54 () view public returns (address, string, string, address, string, string) {
127 	    return (senderLog[53], senderColor[53], messageLog[53], senderLog[54], senderColor[54], messageLog[54]);
128 	}
129 	
130 	function view56 () view public returns (address, string, string, address, string, string) {
131 	    return (senderLog[55], senderColor[55], messageLog[55], senderLog[56], senderColor[56], messageLog[56]);
132 	}
133 	
134 	function view58 () view public returns (address, string, string, address, string, string) {
135 	   return (senderLog[57], senderColor[57], messageLog[57], senderLog[58], senderColor[58], messageLog[58]);
136 	}
137 	
138 	function view60 () view public returns (address, string, string, address, string, string) {
139 	    return (senderLog[59], senderColor[59], messageLog[59], senderLog[60], senderColor[60], messageLog[60]);
140 	}
141 	
142 	function view62 () view public returns (address, string, string, address, string, string) {
143 	    return (senderLog[61], senderColor[61], messageLog[61], senderLog[62], senderColor[62], messageLog[62]);
144 	}
145 	
146 	function view64 () view public returns (address, string, string, address, string, string) {
147 	    return (senderLog[63], senderColor[63], messageLog[63], senderLog[64], senderColor[64], messageLog[64]);
148 	}
149 	
150 	function view66 () view public returns (address, string, string, address, string, string) {
151 	    return (senderLog[65], senderColor[65], messageLog[65], senderLog[66], senderColor[66], messageLog[66]);
152 	}
153 	
154 	function view68 () view public returns (address, string, string, address, string, string) {
155 	   return (senderLog[67], senderColor[67], messageLog[67], senderLog[68], senderColor[68], messageLog[68]);
156 	}
157 	
158 	function view70 () view public returns (address, string, string, address, string, string) {
159 	    return (senderLog[69], senderColor[69], messageLog[69], senderLog[70], senderColor[70], messageLog[70]);
160 	}
161 	
162 	modifier noColor () {
163 	    require (colorCount[msg.sender] == 0);
164 	    require (msg.value == 0.0025 ether);
165 	    _;
166 	}
167 	
168 	function setColorRed () external payable noColor {
169 	    red++;
170 	    colorCount[msg.sender]++;
171 	    myColor[msg.sender] = "#ff383b";
172 	}
173 	
174 	function setColorOrange () external payable noColor {
175 	    orange++;
176 	    colorCount[msg.sender]++;
177 	    myColor[msg.sender] = "#f8ac28";
178 	}
179 	
180 	function setColorYellow () external payable noColor {
181 	    yellow++;
182 	    colorCount[msg.sender]++;
183 	    myColor[msg.sender] = "#ead353";
184 	}
185 	
186 	function setColorGreen () external payable noColor {
187 	    green++;
188 	    colorCount[msg.sender]++;
189 	    myColor[msg.sender] = "#67d75c";
190 	}
191 	
192 	function setColorBlue () external payable noColor {
193 	    blue++;
194 	    colorCount[msg.sender]++;
195 	    myColor[msg.sender] = "#476ef2";
196 	}
197 	
198 	function setColorTeal () external payable noColor {
199 	    teal++;
200 	    colorCount[msg.sender]++;
201 	    myColor[msg.sender] = "#86e3db";
202 	}
203 	
204 	function setColorPurple () external payable noColor {
205 	    purple++;
206 	    colorCount[msg.sender]++;
207 	    myColor[msg.sender] = "#9b5aea";
208 	}
209 	
210 	function setColorPink () external payable noColor {
211 	    pink++;
212 	    colorCount[msg.sender]++;
213 	    myColor[msg.sender] = "#e96de8";
214 	}
215 	
216 	function setColorBlack () external payable noColor {
217 	    black++;
218 	    colorCount[msg.sender]++;
219 	    myColor[msg.sender] = "#212121";
220 	}
221 	
222 	function setColorWhite () external payable noColor {
223 	    white++;
224 	    colorCount[msg.sender]++;
225 	    myColor[msg.sender] = "#cecece";
226 	}
227 	
228 	modifier hasColor () {
229 	    require (colorCount[msg.sender] > 0);
230 	    require (msg.value == 0.00125 ether);
231 	    _;
232 	}
233 	
234 	function changeColorRed () external payable hasColor {
235 	    red++;
236 	    colorCount[msg.sender]++;
237 	    myColor[msg.sender] = "#ff383b";
238 	}
239 	
240 	function changeColorOrange () external payable hasColor {
241 	    orange++;
242 	    colorCount[msg.sender]++;
243 	    myColor[msg.sender] = "#f8ac28";
244 	}
245 	
246 	function changeColorYellow () external payable hasColor {
247 	    yellow++;
248 	    colorCount[msg.sender]++;
249 	    myColor[msg.sender] = "#ead353";
250 	}
251 	
252 	function changeColorGreen () external payable hasColor {
253 	    green++;
254 	    colorCount[msg.sender]++;
255 	    myColor[msg.sender] = "#67d75c";
256 	}
257 	
258 	function changeColorBlue () external payable hasColor {
259 	    blue++;
260 	    colorCount[msg.sender]++;
261 	    myColor[msg.sender] = "#476ef2";
262 	}
263 	
264 	function changeColorTeal () external payable hasColor {
265 	    teal++;
266 	    colorCount[msg.sender]++;
267 	    myColor[msg.sender] = "#86e3db";
268 	}
269 	
270 	function changeColorPurple () external payable hasColor {
271 	    purple++;
272 	    colorCount[msg.sender]++;
273 	    myColor[msg.sender] = "#9b5aea";
274 	}
275 	
276 	function changeColorPink () external payable hasColor {
277 	    pink++;
278 	    colorCount[msg.sender]++;
279 	    myColor[msg.sender] = "#e96de8";
280 	}
281 	
282 	function changeColorBlack () external payable hasColor {
283 	    black++;
284 	    colorCount[msg.sender]++;
285 	    myColor[msg.sender] = "#212121";
286 	}
287 	
288 	function changeColorWhite () external payable hasColor {
289 	    white++;
290 	    colorCount[msg.sender]++;
291 	    myColor[msg.sender] = "#cecece";
292 	}
293 	
294 	function myColorIs () public view returns (string) {
295         return myColor[msg.sender];
296     }
297     
298     function colorLeaderboard () public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {
299         return (colorCount[msg.sender], red, orange, yellow, green, blue, teal, purple, pink, black, white, messageCount);
300     }
301 }