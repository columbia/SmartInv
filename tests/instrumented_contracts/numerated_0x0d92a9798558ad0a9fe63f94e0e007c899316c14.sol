1 pragma solidity ^0.5.0;
2 
3 contract MainContract {
4     function getUserInvestInfo(address addr) public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256);
5 }
6 
7 contract AOQFund {
8 
9     using SafeMath for *;
10 
11     uint ethWei = 1 ether;
12     uint256  fundValue;
13     uint256  gradeOne;
14     uint256  gradeTwo;
15     uint256  gradeThree;
16     address public mainContract;
17     bool public canWithdraw = false;
18     address owner;
19     uint256 public totalInvestorCount;
20 
21     address payable projectAddress = 0x64d7d8AA5F785FF3Fb894Ac3b505Bd65cFFC562F;
22 
23     uint256 closeTime;
24 
25     uint256 public gradeThreeCount;
26     uint256 public gradeTwoCount;
27     uint256 public gradeOneCount;
28 
29     uint256 public gradeThreeCountLimit = 10;
30     uint256 public gradeTwoCountLimit = 90;
31 
32     struct Invest {
33         uint256 level;
34         bool withdrawed;
35         uint256 lastInvestTime;
36         uint256 grade;
37     }
38 
39     mapping(uint256 => uint256) gradeDistribute;
40     mapping(address => Invest) public projectInvestor;
41     mapping(address => bool) admin;
42 
43     constructor () public {
44         owner = msg.sender;
45         admin[msg.sender] = true;
46 
47         gradeDistribute[3] = 250;
48         gradeDistribute[2] = 350;
49         gradeDistribute[1] = 400;
50 
51     }
52 
53     //modifier
54     modifier onlyOwner() {
55         require(msg.sender == owner, "only owner allowed");
56         _;
57     }
58 
59     modifier isHuman() {
60         address addr = msg.sender;
61         uint codeLength;
62 
63         assembly {codeLength := extcodesize(addr)}
64         require(codeLength == 0, "sorry humans only");
65         require(tx.origin == msg.sender, "sorry, human only");
66         _;
67     }
68 
69     modifier onlyAdmin(){
70         require(admin[msg.sender] == true, 'only admin can call');
71         _;
72     }
73 
74     modifier onlyMainContract(){
75         require(msg.sender == mainContract, 'only Main Contract');
76         _;
77     }
78 
79     modifier isContract() {
80         address _addr = msg.sender;
81         uint256 _codeLength;
82 
83         assembly {_codeLength := extcodesize(_addr)}
84         require(_codeLength != 0, "ERROR_ONLY_CONTRACT");
85         _;
86     }
87 
88     function setAdmin(address addr)
89     public
90     onlyOwner()
91     {
92         admin[addr] = true;
93     }
94 
95     function setCloseTime(uint256 cTime)
96     public
97     onlyAdmin()
98     {
99         closeTime = cTime;
100     }
101 
102     function setProjectAddress(address payable pAddress)
103     public
104     onlyAdmin()
105     {
106         projectAddress = pAddress;
107     }
108 
109     function setMainContract(address addr)
110     public
111     onlyAdmin()
112     {
113         mainContract = addr;
114     }
115 
116     function() external payable {
117 
118     }
119 
120     function setGradeCountLimit(uint256 gradeThreeLimit, uint256 gradeTwoLimit)
121     public
122     onlyAdmin()
123     {
124         gradeThreeCountLimit = gradeThreeLimit;
125         gradeTwoCountLimit = gradeTwoLimit;
126     }
127 
128     function countDownOverSet()
129     public
130     onlyMainContract()
131     isContract()
132     {
133         fundValue = address(this).balance;
134         gradeThree = fundValue.mul(gradeDistribute[3]).div(1000);
135         gradeTwo = fundValue.mul(gradeDistribute[2]).div(1000);
136         gradeOne = fundValue.sub(gradeThree).sub(gradeTwo);
137         closeTime = now + 3 days;
138     }
139 
140     function getFundInfo()
141     public
142     view
143     returns (uint256, uint256, uint256, uint256)
144     {
145         return (fundValue, gradeThree, gradeTwo, gradeOne);
146     }
147 
148     function receiveInvest(address investor, uint256 level, bool isNew)
149     public
150     onlyMainContract()
151     isContract()
152     {
153         uint codeLength;
154 
155         assembly {codeLength := extcodesize(investor)}
156         require(codeLength == 0, "not a valid human address");
157 
158         projectInvestor[investor].level = level;
159         projectInvestor[investor].lastInvestTime = now;
160 
161         if (isNew) {
162             totalInvestorCount = totalInvestorCount.add(1);
163         }
164     }
165 
166     function setFrontInvestors(address investor, uint256 grade)
167     public
168     onlyAdmin()
169     {
170 
171         Invest storage investInfo = projectInvestor[investor];
172 
173         require(investInfo.level >= 1 && investInfo.withdrawed == false, 'invalid investor');
174         require(canWithdraw == false, 'invalid period');
175         require(grade < 4, 'invalid grade');
176 
177         if (grade == 3 && investInfo.grade != 3) {
178             require(gradeThreeCount <= gradeThreeCountLimit, 'only 10 count allowed');
179             gradeThreeCount = gradeThreeCount.add(1);
180             if (investInfo.grade == 2) {
181                 gradeTwoCount = gradeTwoCount.sub(1);
182             }
183         }
184         if (grade == 2 && investInfo.grade != 2) {
185             require(gradeTwoCount <= gradeTwoCountLimit, 'only 90 count allowed');
186             gradeTwoCount = gradeTwoCount.add(1);
187             if (investInfo.grade == 3) {
188                 gradeThreeCount = gradeThreeCount.sub(1);
189             }
190         }
191         if (grade < 2 && investInfo.grade >= 2) {
192             if (investInfo.grade == 2) {
193                 gradeTwoCount = gradeTwoCount.sub(1);
194             }
195             if (investInfo.grade == 3) {
196                 gradeThreeCount = gradeThreeCount.sub(1);
197             }
198         }
199 
200         investInfo.grade = grade;
201 
202     }
203 
204     function setGradeOne(uint256 num)
205     public
206     onlyAdmin()
207     {
208         gradeOneCount = num;
209     }
210 
211     function openCanWithdraw(uint256 open)
212     public
213     onlyAdmin()
214     {
215         if (open == 1) {
216             canWithdraw = true;
217         } else {
218             canWithdraw = false;
219         }
220     }
221 
222     function getInvest(address investor) internal view returns (uint256){
223         MainContract mainContractIns = MainContract(mainContract);
224         uint256 three;
225         (,,three,,,,,,,) = mainContractIns.getUserInvestInfo(investor);
226         return three;
227     }
228 
229     function withdrawFund()
230     public
231     isHuman()
232     {
233         require(canWithdraw == true, 'can not withdraw now');
234 
235         Invest storage investInfo = projectInvestor[msg.sender];
236         require(investInfo.withdrawed == false, 'withdrawed address');
237 
238         uint256 withdrawAmount;
239 
240         withdrawAmount = getFundReward(msg.sender);
241 
242         if (withdrawAmount > 0) {
243             investInfo.withdrawed = true;
244         }
245 
246         msg.sender.transfer(withdrawAmount);
247 
248     }
249 
250     function getFundReward(address addr)
251     public
252     view
253     isHuman()
254     returns (uint256)
255     {
256 
257         Invest storage investInfo = projectInvestor[addr];
258 
259         uint256 withdrawAmount = 0;
260 
261         uint256 freeze;
262         freeze = getInvest(addr);
263 
264         if (canWithdraw != false && investInfo.withdrawed != true && freeze > 0) {
265 
266             if (investInfo.grade == 3 && gradeThreeCount > 0) {
267                 withdrawAmount = gradeThree.div(gradeThreeCount);
268             } else if (investInfo.grade == 2 && gradeTwoCount > 0) {
269                 withdrawAmount = gradeTwo.div(gradeTwoCount);
270             }
271 
272             if (investInfo.grade < 2 && gradeOneCount > 0) {
273                 withdrawAmount = gradeOne.div(gradeOneCount);
274             }
275         }
276 
277         return withdrawAmount;
278 
279     }
280 
281     function close() public
282     onlyOwner()
283     {
284         require(canWithdraw == true && gradeThreeCount > 0, 'Game is not start over now!');
285         require(now > closeTime, 'only 3 days later Game Over');
286         selfdestruct(projectAddress);
287     }
288 
289 }
290 
291 /**
292  * @title SafeMath
293  * @dev Math operations with safety checks that revert on error
294  */
295 library SafeMath {
296 
297     /**
298     * @dev Multiplies two numbers, reverts on overflow.
299     */
300     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
301         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
302         // benefit is lost if 'b' is also tested.
303         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
304         if (a == 0) {
305             return 0;
306         }
307 
308         uint256 c = a * b;
309         require(c / a == b, "mul overflow");
310 
311         return c;
312     }
313 
314     /**
315     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
316     */
317     function div(uint256 a, uint256 b) internal pure returns (uint256) {
318         require(b > 0, "div zero");
319         // Solidity only automatically asserts when dividing by 0
320         uint256 c = a / b;
321         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
322 
323         return c;
324     }
325 
326     /**
327     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
328     */
329     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
330         require(b <= a, "lower sub bigger");
331         uint256 c = a - b;
332 
333         return c;
334     }
335 
336     /**
337     * @dev Adds two numbers, reverts on overflow.
338     */
339     function add(uint256 a, uint256 b) internal pure returns (uint256) {
340         uint256 c = a + b;
341         require(c >= a, "overflow");
342 
343         return c;
344     }
345 
346     /**
347     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
348     * reverts when dividing by zero.
349     */
350     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
351         require(b != 0, "mod zero");
352         return a % b;
353     }
354 }