1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4     function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {
5       uint256 z = x + y;
6       assert((z >= x) && (z >= y));
7       return z;
8     }
9 
10     function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
11       assert(x >= y);
12       uint256 z = x - y;
13       return z;
14     }
15 
16     function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {
17       uint256 z = x * y;
18       assert((x == 0)||(z/x == y));
19       return z;
20     }
21 
22 }
23 
24 contract ERC721 {
25    // ERC20 compatible functions
26    function totalSupply() public view returns (uint256 total);
27    function balanceOf(address _owner) public view returns (uint balance);
28    // Functions that define ownership
29    function ownerOf(uint256 _tokenId) public view returns (address owner);
30    function approve(address _to, uint256 _tokenId) external;
31    function transfer(address _to, uint256 _tokenId) external;
32    function tokensOfOwner(address _owner) public view returns (uint256[] ownerTokens);
33    // Token metadata
34    //function tokenMetadata(uint256 _tokenId) view returns (string infoUrl);
35    // Events
36    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
37    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
38 }
39 
40 contract FMWorldAccessControl {
41     address public ceoAddress;
42     address public cooAddress;
43     
44     bool public pause = false;
45 
46     modifier onlyCEO() {
47         require(msg.sender == ceoAddress);
48         _;
49     }
50 
51     modifier onlyCOO() {
52         require(msg.sender == cooAddress);
53         _;
54     }
55 
56     modifier onlyC() {
57         require(
58             msg.sender == cooAddress ||
59             msg.sender == ceoAddress
60         );
61         _;
62     }
63 
64     modifier notPause() {
65         require(!pause);
66         _;
67     }
68     
69     function setCEO(address _newCEO) external onlyCEO {
70         require(_newCEO != address(0));
71         ceoAddress = _newCEO;
72     }
73     
74     function setCOO(address _newCOO) external onlyCEO {
75         require(_newCOO != address(0));
76 
77         cooAddress = _newCOO;
78     }
79 
80 
81     function setPause(bool _pause) external onlyC {
82         pause = _pause;
83     }
84     
85 
86 }
87 
88 contract CatalogPlayers is FMWorldAccessControl
89 {
90     struct ClassPlayer
91     {
92         uint32 talent;
93         uint32 tactics;
94         uint32 dribbling;
95         uint32 kick;
96         uint32 speed;
97         uint32 pass;
98         uint32 selection;
99     }
100 
101     struct boxPlayer
102     {
103         uint256 price;
104         uint256 countSales;
105         ClassPlayer[] classPlayers;
106     }
107     
108     function _set1() onlyCEO public {
109         //init for dev, def-2
110         newClassPlayer(2,2,5,10,2,3,5,5,10);
111         newClassPlayer(2,2,6,10,2,3,6,6,7);
112         newClassPlayer(2,2,5,14,5,2,6,3,5);
113         newClassPlayer(2,2,6,8,4,4,9,4,7);
114         newClassPlayer(2,2,5,15,1,1,3,5,12);
115         newClassPlayer(2,2,6,9,3,3,6,6,9);
116         newClassPlayer(2,2,5,11,1,2,6,5,10);
117         newClassPlayer(2,2,6,9,3,3,7,7,5);
118         newClassPlayer(2,2,5,9,2,4,6,4,8);
119         newClassPlayer(2,2,7,14,3,1,5,6,9);
120         setBoxPrice(2,2,390000000000000000);
121         //
122     }
123     
124     function _set2() onlyCEO public {
125         newClassPlayer(1,2,3,7,1,1,5,5,8);
126         newClassPlayer(1,2,4,7,1,2,4,4,6);
127         newClassPlayer(1,2,3,11,2,1,4,2,5);
128         newClassPlayer(1,2,4,5,2,2,7,3,7);
129         newClassPlayer(1,2,3,10,1,1,2,3,10);
130         newClassPlayer(1,2,4,4,2,2,6,6,6);
131         newClassPlayer(1,2,3,8,1,2,1,3,10);
132         newClassPlayer(1,2,4,5,3,3,5,5,3);
133         newClassPlayer(1,2,3,6,2,2,4,3,6);
134         newClassPlayer(1,2,5,5,2,1,5,6,9);
135         setBoxPrice(1,2,90000000000000000);
136         //
137     }
138     
139     function _set3() onlyCEO public {
140         //init for dev, def-3
141         newClassPlayer(3,2,7,14,2,3,6,6,13);
142         newClassPlayer(3,2,8,15,3,2,6,6,12);
143         newClassPlayer(3,2,7,21,3,2,4,3,12);
144         newClassPlayer(3,2,8,15,4,4,9,4,10);
145         newClassPlayer(3,2,7,20,1,1,2,4,19);
146         newClassPlayer(3,2,8,12,6,6,6,6,10);
147         newClassPlayer(3,2,7,16,1,2,8,5,13);
148         newClassPlayer(3,2,8,15,3,3,8,7,8);
149         newClassPlayer(3,2,8,16,2,4,6,4,17);
150         newClassPlayer(3,2,9,14,3,1,8,9,15);
151         setBoxPrice(3,2,690000000000000000);
152         //
153     }    
154     
155     function _set4() onlyCEO public {
156         // //gk-1
157         newClassPlayer(1,1,3,0,0,0,27,0,0);
158         newClassPlayer(1,1,4,0,0,0,24,0,0);
159         newClassPlayer(1,1,3,0,0,0,25,0,0);
160         newClassPlayer(1,1,4,0,0,0,26,0,0);
161         newClassPlayer(1,1,3,0,0,0,27,0,0);
162         newClassPlayer(1,1,4,0,0,0,26,0,0);
163         newClassPlayer(1,1,3,0,0,0,25,0,0);
164         newClassPlayer(1,1,4,0,0,0,24,0,0);
165         newClassPlayer(1,1,3,0,0,0,23,0,0);
166         newClassPlayer(1,1,5,0,0,0,28,0,0);
167         setBoxPrice(1,1,190000000000000000);
168         //
169     }
170 
171     function _set5() onlyCEO public {
172         // //gk-2
173         newClassPlayer(2,1,5,0,0,0,35,0,0);
174         newClassPlayer(2,1,6,0,0,0,34,0,0);
175         newClassPlayer(2,1,5,0,0,0,35,0,0);
176         newClassPlayer(2,1,6,0,0,0,36,0,0);
177         newClassPlayer(2,1,5,0,0,0,37,0,0);
178         newClassPlayer(2,1,6,0,0,0,36,0,0);
179         newClassPlayer(2,1,5,0,0,0,35,0,0);
180         newClassPlayer(2,1,6,0,0,0,34,0,0);
181         newClassPlayer(2,1,5,0,0,0,33,0,0);
182         newClassPlayer(2,1,7,0,0,0,38,0,0);
183         setBoxPrice(2,1,490000000000000000);
184         //
185     }
186 
187     function _set6() onlyCEO public {
188         // //gk-3
189         newClassPlayer(3,1,7,0,0,0,44,0,0);
190         newClassPlayer(3,1,8,0,0,0,44,0,0);
191         newClassPlayer(3,1,7,0,0,0,45,0,0);
192         newClassPlayer(3,1,8,0,0,0,46,0,0);
193         newClassPlayer(3,1,7,0,0,0,47,0,0);
194         newClassPlayer(3,1,8,0,0,0,46,0,0);
195         newClassPlayer(3,1,7,0,0,0,45,0,0);
196         newClassPlayer(3,1,8,0,0,0,44,0,0);
197         newClassPlayer(3,1,8,0,0,0,49,0,0);
198         newClassPlayer(3,1,9,0,0,0,50,0,0);
199         setBoxPrice(3,1,790000000000000000);
200         //
201     }
202 
203     function _set7() onlyCEO public {
204         //mid-1
205         newClassPlayer(1,3,3,5,2,3,4,7,6);
206         newClassPlayer(1,3,4,6,3,3,2,7,3);
207         newClassPlayer(1,3,3,5,2,2,3,11,2);
208         newClassPlayer(1,3,4,6,2,3,2,9,4);
209         newClassPlayer(1,3,3,10,1,2,3,10,1);
210         newClassPlayer(1,3,4,7,3,3,5,4,4);
211         newClassPlayer(1,3,3,9,2,3,2,8,2);
212         newClassPlayer(1,3,4,6,3,3,3,6,3);
213         newClassPlayer(1,3,3,7,2,2,3,6,1);
214         newClassPlayer(1,3,5,8,2,3,3,8,4);
215         setBoxPrice(1,3,250000000000000000);
216     }
217     
218     function _set8() onlyCEO public {
219         //mid-2
220         newClassPlayer(2,3,5,10,3,4,3,10,5);
221         newClassPlayer(2,3,6,9,2,4,5,10,4);
222         newClassPlayer(2,3,5,13,3,3,1,14,1);
223         newClassPlayer(2,3,6,9,2,3,12,8,2);
224         newClassPlayer(2,3,5,14,1,1,3,15,3);
225         newClassPlayer(2,3,6,10,1,2,6,9,8);
226         newClassPlayer(2,3,5,12,2,2,3,11,2);
227         newClassPlayer(2,3,6,11,3,3,2,9,4);
228         newClassPlayer(2,3,5,12,3,3,3,9,3);
229         newClassPlayer(2,3,7,15,2,3,3,14,1);
230         setBoxPrice(2,3,550000000000000000);
231     }
232     
233     function _set11() onlyCEO public {
234         //mid-3
235         newClassPlayer(3,3,7,4,5,5,5,20,5);
236         newClassPlayer(3,3,8,15,3,4,7,8,7);
237         newClassPlayer(3,3,7,10,3,2,10,10,10);
238         newClassPlayer(3,3,8,15,3,2,10,8,8);
239         newClassPlayer(3,3,7,8,2,2,9,16,10);
240         newClassPlayer(3,3,8,13,3,4,10,8,8);
241         newClassPlayer(3,3,7,12,4,4,7,16,2);
242         newClassPlayer(3,3,8,12,3,1,5,12,11);
243         newClassPlayer(3,3,8,12,3,3,10,11,10);
244         newClassPlayer(3,3,9,17,1,2,10,15,5);
245         setBoxPrice(3,3,850000000000000000);
246     }    
247     
248     function _set9() onlyCEO public {
249         //fw-1
250         newClassPlayer(1,4,3,2,6,7,8,2,2);
251         newClassPlayer(1,4,4,5,3,7,6,1,2);
252         newClassPlayer(1,4,3,1,4,11,5,2,2);
253         newClassPlayer(1,4,4,3,3,6,7,2,5);
254         newClassPlayer(1,4,3,1,5,10,9,1,1);
255         newClassPlayer(1,4,4,2,5,7,8,2,2);
256         newClassPlayer(1,4,3,1,3,8,10,1,2);
257         newClassPlayer(1,4,4,5,2,5,5,4,3);
258         newClassPlayer(1,4,3,2,5,6,6,2,2);
259         newClassPlayer(1,4,5,2,4,9,11,1,1);
260         setBoxPrice(1,4,350000000000000000);
261     }    
262 
263     function _set10() onlyCEO public {
264         //fw-2
265         newClassPlayer(2,4,5,3,3,12,11,3,3);
266         newClassPlayer(2,4,6,1,5,12,12,2,2);
267         newClassPlayer(2,4,5,1,1,14,14,2,3);
268         newClassPlayer(2,4,6,4,6,9,13,2,2);
269         newClassPlayer(2,4,5,1,4,15,15,1,1);
270         newClassPlayer(2,4,6,3,3,10,10,5,5);
271         newClassPlayer(2,4,5,2,2,15,13,1,2);
272         newClassPlayer(2,4,6,4,4,11,13,1,1);
273         newClassPlayer(2,4,5,2,8,9,9,2,3);
274         newClassPlayer(2,4,7,1,14,7,14,1,1);
275         setBoxPrice(2,4,650000000000000000);
276     }
277     
278     function CatalogPlayers() public {
279         ceoAddress = msg.sender;
280         cooAddress = msg.sender;
281 
282         //fw-3
283         newClassPlayer(3,4,7,3,14,4,14,4,5);
284         newClassPlayer(3,4,8,2,8,15,15,3,1);
285         newClassPlayer(3,4,7,3,9,10,21,1,1);
286         newClassPlayer(3,4,8,3,12,15,12,2,2);
287         newClassPlayer(3,4,7,4,15,8,15,3,2);
288         newClassPlayer(3,4,8,3,12,13,10,5,3);
289         newClassPlayer(3,4,7,1,10,12,16,3,3);
290         newClassPlayer(3,4,8,1,12,12,11,6,2);
291         newClassPlayer(3,4,8,2,13,12,16,4,2);
292         newClassPlayer(3,4,9,1,16,17,13,2,1);
293         setBoxPrice(3,4,950000000000000000);
294 
295     }
296 
297     mapping(uint256 => mapping(uint256 => boxPlayer)) public boxPlayers;
298 
299     function newClassPlayer(
300         uint256 _league,
301         uint256 _position,
302         uint32 _talent,
303         uint32 _tactics,
304         uint32 _dribbling,
305         uint32 _kick,
306         uint32 _speed,
307         uint32 _pass,
308         uint32 _selection
309     )
310         public onlyCEO returns(uint256)
311     {
312         ClassPlayer memory player = ClassPlayer({
313             talent: _talent,
314             tactics: _tactics,
315             dribbling: _dribbling,
316             kick: _kick,
317             speed: _speed,
318             pass: _pass,
319             selection: _selection
320         });
321         return boxPlayers[_league][_position].classPlayers.push(player) - 1;
322 
323     }
324 
325     function getClassPlayers(uint256 _league, uint256 _position, uint256 _index) public view returns(uint32[7] skills)
326     {
327         ClassPlayer memory classPlayer = boxPlayers[_league][_position].classPlayers[_index];
328         skills[0] = classPlayer.talent;
329         skills[1] = classPlayer.tactics;
330         skills[2] = classPlayer.dribbling;
331         skills[3] = classPlayer.kick;
332         skills[4] = classPlayer.speed;
333         skills[5] = classPlayer.pass;
334         skills[6] = classPlayer.selection;
335     }
336 
337     function getLengthClassPlayers(uint256 _league, uint256 _position) public view returns (uint256)
338     {
339         return boxPlayers[_league][_position].classPlayers.length;
340     }
341 
342     function setBoxPrice(uint256 _league, uint256 _position, uint256 _price) onlyCEO public
343     {
344         boxPlayers[_league][_position].price = _price;
345     }
346 
347     function getBoxPrice(uint256 _league, uint256 _position) public view returns (uint256)
348     {
349         return boxPlayers[_league][_position].price + ((boxPlayers[_league][_position].countSales / 10) * (boxPlayers[_league][_position].price / 100));
350     }
351     
352     function incrementCountSales(uint256 _league, uint256 _position) public onlyCOO {
353         boxPlayers[_league][_position].countSales++;
354     }
355     
356     function getCountSales(uint256 _league, uint256 _position) public view returns(uint256) {
357         return boxPlayers[_league][_position].countSales;
358     }
359 }