1 pragma solidity ^0.4.24;
2 
3 contract CryptoFishing {
4     
5     using SafeMath for uint256;
6     
7     uint    private lastBonusTime;
8     uint256 private rnSeed;
9     
10     address owner;
11     
12     event finishFishing(address player, uint256 awardAmount, uint awardType);
13     
14     constructor() public {
15         owner = msg.sender;
16     }
17     
18     modifier isHuman() {
19         address _addr = msg.sender;
20         uint256 _codeLength;
21         
22         assembly {_codeLength := extcodesize(_addr)}
23         require(_codeLength == 0, "humans only");
24         require(tx.origin == msg.sender);
25         _;
26     }
27     
28     function randomBonus(uint256 a, uint256 b, uint256 fee) private view returns (uint256) {
29         uint256 bonus = randomRange(a, b) * fee / 10;
30         return bonus;
31     }
32     
33     function calcBonus(uint8 poolType, uint256 fee) private returns (uint256, uint) {
34         uint256 rn = random() % 1000000;
35         
36         uint256 bonus = 0;
37         uint fishId = 0;
38         
39         randomSeed();
40         
41         if(poolType == 1) {
42             if(rn < 200000) {
43                 bonus = 0;
44                 fishId = 0;
45             } else if(rn < 400000) {
46                 bonus = randomBonus(1, 5, fee);
47                 fishId = 10001;
48             } else if(rn < 550000) {
49                 bonus = randomBonus(6, 10, fee);
50                 fishId = 10002;
51             } else if(rn < 750000) {
52                 bonus = randomBonus(11, 11, fee);
53                 fishId = 10003;
54             } else if(rn < 878000) {
55                 bonus = randomBonus(12, 12, fee);
56                 fishId = 10004;
57             } else if(rn < 928000) {
58                 bonus = randomBonus(13, 13, fee);
59                 fishId = 10005;
60             } else if(rn < 948000) {
61                 bonus = randomBonus(14, 14, fee);
62                 fishId = 10006;
63             } else if(rn < 958000) {
64                 bonus = randomBonus(15, 15, fee);
65                 fishId = 10007;
66             } else if(rn < 961000) {
67                 bonus = randomBonus(16, 20, fee);
68                 fishId = 10008;
69             } else if(rn < 971000) {
70                 bonus = randomBonus(21, 30, fee);
71                 fishId = 10009;
72             } else if(rn < 981000) {
73                 bonus = randomBonus(31, 40, fee);
74                 fishId = 10010;
75             } else if(rn < 986000) {
76                 bonus = randomBonus(41, 50, fee);
77                 fishId = 10011;
78             } else if(rn < 990000) {
79                 bonus = randomBonus(51, 60, fee);
80                 fishId = 10012; 
81             } else if(rn < 994000) {
82                 bonus = randomBonus(61, 70, fee);
83                 fishId = 10013; 
84             } else if(rn < 997000) {
85                 bonus = randomBonus(71, 80, fee);
86                 fishId = 10014; 
87             } else if(rn < 999000) {
88                 bonus = randomBonus(81, 90, fee);
89                 fishId = 10015; 
90             } else if(rn < 1000000) {
91                 bonus = randomBonus(91, 100, fee);
92                 fishId = 10016; 
93             }
94         } else if(poolType == 2) {   
95             if(rn < 100000) {
96                 bonus = 0;
97                 fishId = 0;
98             } else if(rn < 300000) {
99                 bonus = randomBonus(1, 5, fee);
100                 fishId = 20001;
101             } else if(rn < 543000) {
102                 bonus = randomBonus(6, 10, fee);
103                 fishId = 20002;
104             } else if(rn < 743000) {
105                 bonus = randomBonus(11, 11, fee);
106                 fishId = 20003;
107             } else if(rn < 893000) {
108                 bonus = randomBonus(12, 12, fee);
109                 fishId = 20004;
110             } else if(rn < 963000) {
111                 bonus = randomBonus(13, 13, fee);
112                 fishId = 20005;
113             } else if(rn < 983000) {
114                 bonus = randomBonus(14, 14, fee);
115                 fishId = 20006;
116             } else if(rn < 993000) {
117                 bonus = randomBonus(15, 15, fee);
118                 fishId = 20007;
119             } else if(rn < 996000) {
120                 bonus = randomBonus(16, 20, fee);
121                 fishId = 20008;
122             } else if(rn < 997000) {
123                 bonus = randomBonus(21, 50, fee);
124                 fishId = 20009;
125             } else if(rn < 998000) {
126                 bonus = randomBonus(51, 100, fee);
127                 fishId = 20010;
128             } else if(rn < 998800) {
129                 bonus = randomBonus(101, 150, fee);
130                 fishId = 20011;
131             } else if(rn < 999100) {
132                 bonus = randomBonus(151, 200, fee);
133                 fishId = 20012;
134             } else if(rn < 999300) {
135                 bonus = randomBonus(201, 250, fee);
136                 fishId = 20013;
137             } else if(rn < 999500) {
138                 bonus = randomBonus(251, 300, fee);
139                 fishId = 20014;
140             } else if(rn < 999700) {
141                 bonus = randomBonus(301, 350, fee);
142                 fishId = 20015;
143             } else if(rn < 999800) {
144                 bonus = randomBonus(351, 400, fee);
145                 fishId = 20016;
146             } else if(rn < 999900) {
147                 bonus = randomBonus(401, 450, fee);
148                 fishId = 20017;
149             } else if(rn < 1000000) {
150                 bonus = randomBonus(451, 500, fee);
151                 fishId = 20018;
152             } 
153         } else if(poolType == 3) {     
154             if(rn <= 100) {
155                 uint256 total = address(this).balance;
156                 bonus = total.div(2);
157                 fishId = 90001;
158             } else if(rn < 300000) {
159                 bonus = randomBonus(1, 5, fee);
160                 fishId = 30001;
161             } else if(rn < 600000) {
162                 bonus = randomBonus(6, 10, fee);
163                 fishId = 30002;
164             } else if(rn < 800000) {
165                 bonus = randomBonus(11, 11, fee);
166                 fishId = 30003;
167             } else if(rn < 917900) {
168                 bonus = randomBonus(12, 12, fee);
169                 fishId = 30004;
170             } else if(rn < 967900) {
171                 bonus = randomBonus(13, 13, fee);
172                 fishId = 30005;
173             } else if(rn < 982900) {
174                 bonus = randomBonus(14, 14, fee);
175                 fishId = 30006;
176             } else if(rn < 989900) {
177                 bonus = randomBonus(15, 15, fee);
178                 fishId = 30007;
179             } else if(rn < 993900) {
180                 bonus = randomBonus(16, 20, fee);
181                 fishId = 30008;
182             } else if(rn < 995900) {
183                 bonus = randomBonus(21, 50, fee);
184                 fishId = 30009;
185             } else if(rn < 997900) {
186                 bonus = randomBonus(51, 100, fee);
187                 fishId = 30010;
188             } else if(rn < 998200) {
189                 bonus = randomBonus(101, 150, fee);
190                 fishId = 30011;
191             } else if(rn < 998500) {
192                 bonus = randomBonus(151, 200, fee);
193                 fishId = 30012;
194             } else if(rn < 998700) {
195                 bonus = randomBonus(201, 250, fee);
196                 fishId = 30013;
197             } else if(rn < 998900) {
198                 bonus = randomBonus(251, 300, fee);
199                 fishId = 30014;
200             } else if(rn < 999100) {
201                 bonus = randomBonus(301, 350, fee);
202                 fishId = 30015;
203             } else if(rn < 999200) {
204                 bonus = randomBonus(351, 400, fee);
205                 fishId = 30016;
206             } else if(rn < 999300) {
207                 bonus = randomBonus(401, 450, fee);
208                 fishId = 30017;
209             } else if(rn < 999400) {
210                 bonus = randomBonus(451, 500, fee);
211                 fishId = 30018;
212             } else if(rn < 999500) {
213                 bonus = randomBonus(501, 550, fee);
214                 fishId = 30019;
215             } else if(rn < 999600) {
216                 bonus = randomBonus(551, 600, fee);
217                 fishId = 30020;
218             } else if(rn < 999650) {
219                 bonus = randomBonus(601, 650, fee);
220                 fishId = 30021;
221             } else if(rn < 999700) {
222                 bonus = randomBonus(651, 700, fee);
223                 fishId = 30022;
224             } else if(rn < 999750) {
225                 bonus = randomBonus(701, 750, fee);
226                 fishId = 30023;
227             } else if(rn < 999800) {
228                 bonus = randomBonus(751, 800, fee);
229                 fishId = 30024;
230             } else if(rn < 999850) {
231                 bonus = randomBonus(801, 850, fee);
232                 fishId = 30025;
233             } else if(rn < 999900) {
234                 bonus = randomBonus(851, 900, fee);
235                 fishId = 30026;
236             } else if(rn < 999950) {
237                 bonus = randomBonus(901, 950, fee);
238                 fishId = 30027;
239             } else if(rn < 1000000) {
240                 bonus = randomBonus(951, 1000, fee);
241                 fishId = 30028;
242             }
243         }
244         
245         return (bonus, fishId);
246     }
247     
248     function randomSeed() private {
249         rnSeed += 1;
250         uint256 idx = (rnSeed % 200) + 1;
251         uint256 bh = uint256(blockhash(block.number - idx));
252         rnSeed = bh;
253         rnSeed += 1;
254     }
255         
256     function doFishing(uint8 poolType) isHuman() public payable {   
257         require(tx.origin == msg.sender);
258         
259         uint256 fee = msg.value;
260         
261         require( (poolType == 1 && fee == 0.05 ether)
262                   || (poolType == 2 && fee == 0.25 ether)
263                   || (poolType == 3 && fee == 0.5 ether)
264                   , 'error eth amount');
265         
266         uint256 reserveFee = fee.div(20);
267         owner.transfer(reserveFee);
268         
269         uint256 bonus;
270         uint fishId;
271         
272         randomSeed(); 
273         
274         (bonus,fishId) = calcBonus(poolType, fee);
275         
276         uint256 nowBalance = address(this).balance;
277         
278         uint256 minRemain = uint256(0.1 ether);
279 
280         if(bonus + minRemain > nowBalance) {
281             if(nowBalance > minRemain) {
282                 bonus = nowBalance - minRemain;
283             } else {
284                 bonus = 0;
285             }
286         }
287          
288         if(bonus > 0) {
289             lastBonusTime   = block.timestamp;
290             msg.sender.transfer(bonus);
291         }
292         
293         emit finishFishing(msg.sender, bonus, fishId);
294     }
295     
296     function charge() public payable {
297     }
298     
299     function recycle() public payable {
300         require(msg.sender == owner);
301         
302         uint threeMonth = 3600 * 24 * 30 * 3;
303         require(block.timestamp >= lastBonusTime + threeMonth);
304         
305         owner.transfer(address(this).balance);
306     }
307     
308     function randomRange(uint256 a, uint256 b) private view returns (uint256) {
309         assert(a <= b);
310         uint256 rn = random();
311         return a + rn % (b - a + 1);
312     } 
313     
314     function random() private view returns (uint256) {
315         return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, rnSeed)));
316     }
317 }
318 
319 /**
320  * @title SafeMath
321  * @dev Math operations with safety checks that throw on error
322  */
323 library SafeMath {
324 
325   /**
326   * @dev Multiplies two numbers, throws on overflow.
327   */
328   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
329     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
330     // benefit is lost if 'b' is also tested.
331     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
332     if (_a == 0) {
333       return 0;
334     }
335 
336     c = _a * _b;
337     assert(c / _a == _b);
338     return c;
339   }
340 
341   /**
342   * @dev Integer division of two numbers, truncating the quotient.
343   */
344   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
345     // assert(_b > 0); // Solidity automatically throws when dividing by 0
346     // uint256 c = _a / _b;
347     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
348     return _a / _b;
349   }
350 
351   /**
352   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
353   */
354   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
355     assert(_b <= _a);
356     return _a - _b;
357   }
358 
359   /**
360   * @dev Adds two numbers, throws on overflow.
361   */
362   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
363     c = _a + _b;
364     assert(c >= _a);
365     return c;
366   }
367 }