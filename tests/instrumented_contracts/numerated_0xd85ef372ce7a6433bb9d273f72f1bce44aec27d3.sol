1 pragma solidity ^0.4.8;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
12     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (_a == 0) {
16       return 0;
17     }
18 
19     c = _a * _b;
20     assert(c / _a == _b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
28     // assert(_b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = _a / _b;
30     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
31     return _a / _b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
38     assert(_b <= _a);
39     return _a - _b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
46     c = _a + _b;
47     assert(c >= _a);
48     return c;
49   }
50 }
51 
52 contract CryptoFishing {
53     
54     using SafeMath for uint256;
55     
56     address lastBonusPlayer;
57     uint256 lastBonusAmount;
58     
59     address owner;
60     
61     event finishFishing(address player, uint256 awardAmount, uint awardType);
62     
63     constructor() public {
64         owner = msg.sender;
65     }
66     
67     function getLastBonus() public view returns (address, uint256) {
68         return (lastBonusPlayer, lastBonusAmount);
69     }
70     
71     function randomBonus(uint256 a, uint256 b, uint256 fee) private view returns (uint256) {
72         uint256 bonus = randomRange(a, b) * fee / 10;
73         return bonus;
74     }
75     
76     function calcBonus(uint poolType, uint256 fee) private view returns (uint256, uint) {
77         uint256 rn = random() % 1000000;
78         
79         uint256 bonus = 0;
80         uint fishId = 0;
81         
82         if(rn <= 100) {
83             uint256 total = address(this).balance;
84             bonus = total.div(2);
85             fishId = 90001;
86         } else if(poolType == 1) {
87             if(rn < 200000) {
88                 bonus = 0;
89                 fishId = 0;
90             } else if(rn < 400000) {
91                 bonus = randomBonus(1, 5, fee);
92                 fishId = 10001;
93             } else if(rn < 550000) {
94                 bonus = randomBonus(6, 10, fee);
95                 fishId = 10002;
96             } else if(rn < 750000) {
97                 bonus = randomBonus(11, 11, fee);
98                 fishId = 10003;
99             } else if(rn < 878000) {
100                 bonus = randomBonus(12, 12, fee);
101                 fishId = 10004;
102             } else if(rn < 928000) {
103                 bonus = randomBonus(13, 13, fee);
104                 fishId = 10005;
105             } else if(rn < 948000) {
106                 bonus = randomBonus(14, 14, fee);
107                 fishId = 10006;
108             } else if(rn < 958000) {
109                 bonus = randomBonus(15, 15, fee);
110                 fishId = 10007;
111             } else if(rn < 961000) {
112                 bonus = randomBonus(16, 20, fee);
113                 fishId = 10008;
114             } else if(rn < 971000) {
115                 bonus = randomBonus(21, 30, fee);
116                 fishId = 10009;
117             } else if(rn < 981000) {
118                 bonus = randomBonus(31, 40, fee);
119                 fishId = 10010;
120             } else if(rn < 986000) {
121                 bonus = randomBonus(41, 50, fee);
122                 fishId = 10011;
123             } else if(rn < 990000) {
124                 bonus = randomBonus(51, 60, fee);
125                 fishId = 10012; 
126             } else if(rn < 994000) {
127                 bonus = randomBonus(61, 70, fee);
128                 fishId = 10013; 
129             } else if(rn < 997000) {
130                 bonus = randomBonus(71, 80, fee);
131                 fishId = 10014; 
132             } else if(rn < 999000) {
133                 bonus = randomBonus(81, 90, fee);
134                 fishId = 10015; 
135             } else if(rn < 1000000) {
136                 bonus = randomBonus(91, 100, fee);
137                 fishId = 10016; 
138             }
139         } else if(poolType == 2) {   
140             if(rn < 100000) {
141                 bonus = 0;
142                 fishId = 0;
143             } else if(rn < 300000) {
144                 bonus = randomBonus(1, 5, fee);
145                 fishId = 20001;
146             } else if(rn < 543000) {
147                 bonus = randomBonus(6, 10, fee);
148                 fishId = 20002;
149             } else if(rn < 743000) {
150                 bonus = randomBonus(11, 11, fee);
151                 fishId = 20003;
152             } else if(rn < 893000) {
153                 bonus = randomBonus(12, 12, fee);
154                 fishId = 20004;
155             } else if(rn < 963000) {
156                 bonus = randomBonus(13, 13, fee);
157                 fishId = 20005;
158             } else if(rn < 983000) {
159                 bonus = randomBonus(14, 14, fee);
160                 fishId = 20006;
161             } else if(rn < 993000) {
162                 bonus = randomBonus(15, 15, fee);
163                 fishId = 20007;
164             } else if(rn < 996000) {
165                 bonus = randomBonus(16, 20, fee);
166                 fishId = 20008;
167             } else if(rn < 997000) {
168                 bonus = randomBonus(21, 50, fee);
169                 fishId = 20009;
170             } else if(rn < 998000) {
171                 bonus = randomBonus(51, 100, fee);
172                 fishId = 20010;
173             } else if(rn < 998800) {
174                 bonus = randomBonus(101, 150, fee);
175                 fishId = 20011;
176             } else if(rn < 999100) {
177                 bonus = randomBonus(151, 200, fee);
178                 fishId = 20012;
179             } else if(rn < 999300) {
180                 bonus = randomBonus(201, 250, fee);
181                 fishId = 20013;
182             } else if(rn < 999500) {
183                 bonus = randomBonus(251, 300, fee);
184                 fishId = 20014;
185             } else if(rn < 999700) {
186                 bonus = randomBonus(301, 350, fee);
187                 fishId = 20015;
188             } else if(rn < 999800) {
189                 bonus = randomBonus(351, 400, fee);
190                 fishId = 20016;
191             } else if(rn < 999900) {
192                 bonus = randomBonus(401, 450, fee);
193                 fishId = 20017;
194             } else if(rn < 1000000) {
195                 bonus = randomBonus(451, 500, fee);
196                 fishId = 20018;
197             } 
198         } else if(poolType == 3) {     
199             if(rn < 300000) {
200                 bonus = randomBonus(1, 5, fee);
201                 fishId = 30001;
202             } else if(rn < 600000) {
203                 bonus = randomBonus(6, 10, fee);
204                 fishId = 30002;
205             } else if(rn < 800000) {
206                 bonus = randomBonus(11, 11, fee);
207                 fishId = 30003;
208             } else if(rn < 917900) {
209                 bonus = randomBonus(12, 12, fee);
210                 fishId = 30004;
211             } else if(rn < 967900) {
212                 bonus = randomBonus(13, 13, fee);
213                 fishId = 30005;
214             } else if(rn < 982900) {
215                 bonus = randomBonus(14, 14, fee);
216                 fishId = 30006;
217             } else if(rn < 989900) {
218                 bonus = randomBonus(15, 15, fee);
219                 fishId = 30007;
220             } else if(rn < 993900) {
221                 bonus = randomBonus(16, 20, fee);
222                 fishId = 30008;
223             } else if(rn < 995900) {
224                 bonus = randomBonus(21, 50, fee);
225                 fishId = 30009;
226             } else if(rn < 997900) {
227                 bonus = randomBonus(51, 100, fee);
228                 fishId = 30010;
229             } else if(rn < 998200) {
230                 bonus = randomBonus(101, 150, fee);
231                 fishId = 30011;
232             } else if(rn < 998500) {
233                 bonus = randomBonus(151, 200, fee);
234                 fishId = 30012;
235             } else if(rn < 998700) {
236                 bonus = randomBonus(201, 250, fee);
237                 fishId = 30013;
238             } else if(rn < 998900) {
239                 bonus = randomBonus(251, 300, fee);
240                 fishId = 30014;
241             } else if(rn < 999100) {
242                 bonus = randomBonus(301, 350, fee);
243                 fishId = 30015;
244             } else if(rn < 999200) {
245                 bonus = randomBonus(351, 400, fee);
246                 fishId = 30016;
247             } else if(rn < 999300) {
248                 bonus = randomBonus(401, 450, fee);
249                 fishId = 30017;
250             } else if(rn < 999400) {
251                 bonus = randomBonus(451, 500, fee);
252                 fishId = 30018;
253             } else if(rn < 999500) {
254                 bonus = randomBonus(501, 550, fee);
255                 fishId = 30019;
256             } else if(rn < 999600) {
257                 bonus = randomBonus(551, 600, fee);
258                 fishId = 30020;
259             } else if(rn < 999650) {
260                 bonus = randomBonus(601, 650, fee);
261                 fishId = 30021;
262             } else if(rn < 999700) {
263                 bonus = randomBonus(651, 700, fee);
264                 fishId = 30022;
265             } else if(rn < 999750) {
266                 bonus = randomBonus(701, 750, fee);
267                 fishId = 30023;
268             } else if(rn < 999800) {
269                 bonus = randomBonus(751, 800, fee);
270                 fishId = 30024;
271             } else if(rn < 999850) {
272                 bonus = randomBonus(801, 850, fee);
273                 fishId = 30025;
274             } else if(rn < 999900) {
275                 bonus = randomBonus(851, 900, fee);
276                 fishId = 30026;
277             } else if(rn < 999950) {
278                 bonus = randomBonus(901, 950, fee);
279                 fishId = 30027;
280             } else if(rn < 1000000) {
281                 bonus = randomBonus(951, 1000, fee);
282                 fishId = 30028;
283             }
284         }
285         
286         return (bonus, fishId);
287     }
288         
289     function doFishing(uint poolType) public payable {
290         uint256 fee = msg.value;
291         
292         require( (poolType == 1 && fee == 0.05 ether)
293                   || (poolType == 2 && fee == 0.25 ether)
294                   || (poolType == 3 && fee == 0.5 ether)
295                   , 'error eth amount');
296         
297         uint256 reserveFee = fee.div(20);
298         owner.transfer(reserveFee);
299         
300         uint256 bonus;
301         uint fishId;
302         
303         (bonus,fishId) = calcBonus(poolType, fee);
304         
305         uint256 nowBalance = address(this).balance;
306         
307         uint256 minRemain = uint256(0.1 ether);
308 
309         if(bonus + minRemain > nowBalance) {
310             if(nowBalance > minRemain) {
311                 bonus = nowBalance - minRemain;
312             } else {
313                 bonus = 0;
314             }
315         }
316         
317         if(bonus > 0) {
318             lastBonusPlayer = msg.sender;
319             lastBonusAmount = bonus;
320             msg.sender.transfer(bonus);
321         }
322         
323         emit finishFishing(msg.sender, bonus, fishId);
324     }
325     
326     function charge() public payable {
327     }
328     
329     function randomRange(uint256 a, uint256 b) private view returns (uint256) {
330         assert(a <= b);
331         uint256 rn = random();
332         return a + rn % (b - a + 1);
333     } 
334     
335     function random() private view returns (uint256) {
336         return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, lastBonusPlayer, lastBonusAmount)));
337     }
338 }