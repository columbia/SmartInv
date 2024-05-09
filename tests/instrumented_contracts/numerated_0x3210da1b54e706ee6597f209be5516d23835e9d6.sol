1 pragma solidity  ^0.4.24;
2 contract AllYours {
3 
4     // uint128 private _totalEth = 0.2 ether;
5 
6     // uint128 private _winTotalEth = 0.15 ether;
7 
8     // uint128 private _platformTotalEth = 0.05 ether;
9 
10     // uint16 private _needTimes = 4;
11 
12     // uint128 private _oneceEth = 0.05 ether;
13 
14      // uint24 private _needTimes = 10;
15 
16    
17 
18     address private _platformAddress = 0xbE9C1088FEEB8B48A96Da0231062eA757D0a9613;
19 
20     uint private _totalEth = 0.05 ether;
21 
22  
23 
24     uint128 private _oneceEth = 0.01 ether;
25 
26     uint256 private _period = 1;
27 
28     address private _owner;
29 
30     
31 
32     constructor() public{
33 
34         _owner = msg.sender;
35 
36     }
37 
38     
39 
40     // mapping(address => uint16) private _playerOfNumber;
41 
42     mapping(uint24 => address) private _allPlayer;
43 
44     address[] private _allAddress;
45 
46     uint16 private _currentJoinPersonNumber;
47 
48     string private _historyJoin;
49 
50     
51 
52     event drawCallback(address winnerAddress,uint period,uint balance,uint time );
53 
54     
55 
56     function getCurrentJoinPersonNumber() view public returns(uint24) {
57 
58         return _currentJoinPersonNumber;
59 
60     }
61 
62     
63 
64     // function getAddressJoinPersonNumber() view public returns(uint24) {
65 
66     // return _playerOfNumber[msg.sender];
67 
68     // }
69 
70     
71 
72     
73 
74     
75 
76     function getHistory() view public returns(string) {
77 
78         return _historyJoin;
79 
80     }
81 
82     
83 
84     function getPeriod() view public returns(uint256) {
85 
86         return _period;
87 
88     }
89 
90     function getCurrentBalance() view public returns(uint256) {
91 
92         return address(this).balance;
93 
94     }
95 
96  
97 
98     
99 
100     function draw() internal view returns (uint24) {
101 
102         bytes32 hash = keccak256(abi.encodePacked(block.number));
103 
104         uint256 random = 0;
105 
106         for(uint i=hash.length-8;i<hash.length;i++) {
107 
108             random += uint256(hash[i])*(10**(hash.length-i));
109 
110         }
111 
112         
113 
114         random += now;
115 
116         
117 
118          bytes memory hashAddress=toBytes(_allAddress[0]); 
119 
120          for(uint j=0;j<8;j++) {
121 
122             random += uint(hashAddress[j])*(10**(8-j));
123 
124         }
125 
126         
127 
128         uint24 index = uint24(random % _allAddress.length);
129 
130         
131 
132         return index;
133 
134        
135 
136     }
137 
138     
139 
140     // 销毁当前合约
141 
142     function kill() public payable {
143 
144        
145 
146         if (_owner == msg.sender) {
147 
148              _platformAddress.transfer(address(this).balance);
149 
150             selfdestruct(_owner);
151 
152         }
153 
154 
155 
156 
157 
158     }
159 
160    
161 
162     function() public payable {
163 
164         require(msg.value >= _oneceEth);
165 
166         
167 
168         // _playerOfNumber[msg.sender] += 1;
169 
170         uint len = msg.value/_oneceEth;
171 
172         for(uint i=0;i<len;i++) {
173 
174             _allPlayer[_currentJoinPersonNumber ++] = msg.sender;
175 
176             _allAddress.push(msg.sender);
177 
178         }
179 
180         
181 
182         
183 
184         _historyJoin = strConcat(_historyJoin,"&",uint2str(now),"|",addressToString(msg.sender)) ;
185 
186         
187 
188         if(address(this).balance >= _totalEth) {
189 
190             
191 
192             uint24 index = draw();
193 
194             address drawAddress = _allPlayer[index];
195 
196             uint256 b = address(this).balance;
197 
198             uint256 pay = b*70/100;
199 
200             drawAddress.transfer(pay);
201 
202             _platformAddress.transfer(b*30/100);
203 
204             
205 
206             emit drawCallback(drawAddress,_period,pay,now);
207 
208             _period ++;
209 
210           clear();
211 
212            
213 
214    
215 
216         }
217 
218         
219 
220     }
221 
222     
223 
224     function clear() internal {
225 
226          for(uint16 i=0;i<_allAddress.length;i++) {
227 
228                 // delete _playerOfNumber[_allAddress[i]];
229 
230                 delete _allPlayer[i];
231 
232             }
233 
234             
235 
236            _currentJoinPersonNumber = 0;
237 
238           _historyJoin = "";
239 
240            delete _allAddress;
241 
242     }
243 
244     
245 
246     function toBytes(address x) internal pure returns (bytes b) {
247 
248          b = new bytes(20);
249 
250          for (uint i = 0; i < 20; i++)
251 
252                 b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
253 
254     }
255 
256     
257 
258     
259 
260    function addressToString(address _addr) internal pure returns (string) {
261 
262                bytes32 value = bytes32(uint256(_addr));
263 
264 
265 
266         bytes memory alphabet = "0123456789abcdef";
267 
268 
269 
270 
271 
272 
273 
274         bytes memory str = new bytes(42);
275 
276 
277 
278         str[0] = '0';
279 
280 
281 
282         str[1] = 'x';
283 
284 
285 
286         for (uint i = 0; i < 20; i++) {
287 
288 
289 
290             str[2+i*2] = alphabet[uint(value[i + 12] >> 4)];
291 
292 
293 
294             str[3+i*2] = alphabet[uint(value[i + 12] & 0x0f)];
295 
296 
297 
298         }
299 
300 
301 
302         return string(str);
303 
304     }
305 
306     
307 
308     function uint2str(uint256 i) internal pure returns (string){
309 
310         if (i == 0) return "0";
311 
312         uint j = i;
313 
314         uint len;
315 
316         while (j != 0){
317 
318             len++;
319 
320             j /= 10;
321 
322         }
323 
324         bytes memory bstr = new bytes(len);
325 
326         uint k = len - 1;
327 
328         while (i != 0){
329 
330             bstr[k--] = byte(48 + i % 10);
331 
332             i /= 10;
333 
334         }
335 
336         return string(bstr);
337 
338     }
339 
340     
341 
342     
343 
344     
345 
346      function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
347 
348         bytes memory _ba = bytes(_a);
349 
350         bytes memory _bb = bytes(_b);
351 
352         bytes memory _bc = bytes(_c);
353 
354         bytes memory _bd = bytes(_d);
355 
356         bytes memory _be = bytes(_e);
357 
358         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
359 
360         bytes memory babcde = bytes(abcde);
361 
362         uint k = 0;
363 
364         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
365 
366         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
367 
368         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
369 
370         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
371 
372         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
373 
374         return string(babcde);
375 
376     }
377 
378     
379 
380     
381 
382 }