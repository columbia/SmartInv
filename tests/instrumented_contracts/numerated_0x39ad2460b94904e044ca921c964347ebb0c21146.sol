1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   constructor () public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 contract EtherLife is Ownable
90 {   
91     using SafeMath for uint;
92     
93     struct deposit {
94         uint time;
95         uint value;
96         uint timeOfLastWithdraw;
97     }
98     
99     mapping(address => deposit[]) public deposits;
100     mapping(address => address) public parents;
101     address[] public investors;
102     
103     address public constant rootParentAddress = 0xcf9E764539Ae0eE0fA316AAD30A870447C349b46;
104     address public constant feeAddress = 0xcf9E764539Ae0eE0fA316AAD30A870447C349b46;
105     uint public constant withdrawPeriod = 1 days;
106     
107     uint public constant minDepositSum = 100 finney; // 0.1 ether;
108     
109     event Deposit(address indexed from, uint256 value);
110     event Withdraw(address indexed from, uint256 value);
111     event ReferrerBonus(address indexed from, address indexed to, uint8 level, uint256 value);
112     
113     
114     modifier checkSender() 
115     {
116         require(msg.sender != address(0));
117         _;
118     }
119 
120     
121     function bytesToAddress(bytes source) internal pure returns(address parsedAddress) 
122     {
123         assembly {
124             parsedAddress := mload(add(source,0x14))
125         }
126         return parsedAddress;
127     }
128 
129     function () checkSender public payable 
130     {
131         if(msg.value == 0)
132         {
133             withdraw();
134             return;
135         }
136         
137         require(msg.value >= minDepositSum);
138         
139         checkReferrer(msg.sender);
140         
141         payFee(msg.value);
142         addDeposit(msg.sender, msg.value);
143         
144         emit Deposit(msg.sender, msg.value);
145         
146         payRewards(msg.sender, msg.value);
147     }
148     
149     function getInvestorsLength() public view returns (uint)
150     {
151         return investors.length;
152     }
153     
154     function getDepositsLength(address investorAddress) public view returns (uint)
155     {
156         return deposits[investorAddress].length;
157     }
158     
159     function getDepositByIndex(address investorAddress, uint index) public view returns (uint, uint)
160     {
161         return (deposits[investorAddress][index].time, deposits[investorAddress][index].value);
162     }
163     
164     function getParents(address investorAddress) public view returns (address[])
165     {
166         address[] memory refLevels = new address[](5);
167         address current = investorAddress;
168         
169         for(uint8 i = 0; i < 5; i++)
170         {
171              current = parents[current];
172              if(current == address(0)) break;
173              refLevels[i] = current;
174         }
175         
176         return refLevels;
177     }
178     
179     function calculateRewardForLevel(uint8 level, uint value) public pure returns (uint)
180     {
181         if(level == 1) return value.mul(2).div(100);   // 2%
182         if(level == 2) return value.div(100);          // 1%
183         if(level == 3) return value.div(200);          // 0.5%
184         if(level == 4) return value.div(400);          // 0.25%
185         if(level == 5) return value.div(400);          // 0.25%
186         
187         return 0;
188     }
189     
190     function calculatWithdrawForPeriod(uint8 period, uint depositValue, uint periodsCount) public pure returns (uint)
191     {
192         if(period == 1)
193         {
194             return depositValue.mul(4).div(100).mul(periodsCount);  // 4%
195         }
196         else if(period == 2)
197         {
198             return depositValue.mul(3).div(100).mul(periodsCount);  // 3%
199         }
200         else if(period == 3)
201         {
202             return depositValue.mul(2).div(100).mul(periodsCount);  // 2%
203         }
204         else if(period == 4)
205         {
206             return depositValue.div(100).mul(periodsCount);         // 1%
207         }
208         else if(period == 5)
209         {
210             return depositValue.div(200).mul(periodsCount);         // 0.5%
211         }
212         
213         return 0;
214     }
215     
216     function calculateWithdraw(uint currentTime, uint depositTime, uint depositValue, uint timeOfLastWithdraw) public pure returns (uint)
217     {
218         if(currentTime - timeOfLastWithdraw < withdrawPeriod)
219         {
220             return 0;
221         }
222         
223         uint timeEndOfPeriod1 = depositTime + 30 days;
224         uint timeEndOfPeriod2 = depositTime + 60 days;
225         uint timeEndOfPeriod3 = depositTime + 90 days;
226         uint timeEndOfPeriod4 = depositTime + 120 days;
227         
228 
229         uint sum = 0;
230         uint timeEnd = 0;
231         uint periodsCount = 0;
232             
233         if(timeOfLastWithdraw < timeEndOfPeriod1)
234         {
235             timeEnd = currentTime > timeEndOfPeriod1 ? timeEndOfPeriod1 : currentTime;
236             (periodsCount, timeOfLastWithdraw) = calculatePeriodsCountAndNewTime(timeOfLastWithdraw, timeEnd);
237             sum = calculatWithdrawForPeriod(1, depositValue, periodsCount);
238         }
239         
240         if(timeOfLastWithdraw >= timeEndOfPeriod1)
241         {
242             timeEnd = currentTime > timeEndOfPeriod2 ? timeEndOfPeriod2 : currentTime;
243             (periodsCount, timeOfLastWithdraw) = calculatePeriodsCountAndNewTime(timeOfLastWithdraw, timeEnd);
244             sum = sum.add(calculatWithdrawForPeriod(2, depositValue, periodsCount));
245         }
246         
247         if(timeOfLastWithdraw >= timeEndOfPeriod2)
248         {
249             timeEnd = currentTime > timeEndOfPeriod3 ? timeEndOfPeriod3 : currentTime;
250             (periodsCount, timeOfLastWithdraw) = calculatePeriodsCountAndNewTime(timeOfLastWithdraw, timeEnd);
251             sum = sum.add(calculatWithdrawForPeriod(3, depositValue, periodsCount));
252         }
253         
254         if(timeOfLastWithdraw >= timeEndOfPeriod3)
255         {
256             timeEnd = currentTime > timeEndOfPeriod4 ? timeEndOfPeriod4 : currentTime;
257             (periodsCount, timeOfLastWithdraw) = calculatePeriodsCountAndNewTime(timeOfLastWithdraw, timeEnd);
258             sum = sum.add(calculatWithdrawForPeriod(4, depositValue, periodsCount));
259         }
260         
261         if(timeOfLastWithdraw >= timeEndOfPeriod4)
262         {
263             timeEnd = currentTime;
264             (periodsCount, timeOfLastWithdraw) = calculatePeriodsCountAndNewTime(timeOfLastWithdraw, timeEnd);
265             sum = sum.add(calculatWithdrawForPeriod(5, depositValue, periodsCount));
266         }
267          
268         return sum;
269     }
270     
271     function checkReferrer(address investorAddress) internal
272     {
273         if(deposits[investorAddress].length == 0)
274         {
275             require(msg.data.length == 20, "you must specify referer address"); 
276             
277             address referrerAddress = bytesToAddress(bytes(msg.data));
278             
279             require(referrerAddress != investorAddress, "address must be different from your own"); 
280             require(deposits[referrerAddress].length > 0 || referrerAddress == rootParentAddress, "address must be an active investor");
281             
282             parents[investorAddress] = referrerAddress;
283             investors.push(investorAddress);
284         }
285     }
286     
287     function payRewards(address investorAddress, uint depositValue) internal
288     {   
289         address[] memory parentAddresses = getParents(investorAddress);
290         for(uint8 i = 0; i < parentAddresses.length; i++)
291         {
292             address parent = parentAddresses[i];
293             if(parent == address(0)) break;
294             
295             uint rewardValue = calculateRewardForLevel(i + 1, depositValue);
296             parent.transfer(rewardValue);
297             
298             emit ReferrerBonus(investorAddress, parent, i + 1, rewardValue);
299         }
300     }
301     
302     function addDeposit(address investorAddress, uint weiAmount) internal
303     {
304         deposits[investorAddress].push(deposit(now, weiAmount, now));
305     }
306     
307     function payFee(uint weiAmount) internal
308     {
309         uint fee = weiAmount.mul(16).div(100); // 16%
310         feeAddress.transfer(fee);
311     }
312     
313     function calculateNewTime(uint startTime, uint endTime) public pure returns (uint) 
314     {
315         uint periodsCount = endTime.sub(startTime).div(withdrawPeriod);
316         return startTime.add(withdrawPeriod.mul(periodsCount));
317     }
318     
319     function calculatePeriodsCountAndNewTime(uint startTime, uint endTime) public pure returns (uint, uint) 
320     {
321         uint periodsCount = endTime.sub(startTime).div(withdrawPeriod);
322         uint newTime = startTime.add(withdrawPeriod.mul(periodsCount));
323         return (periodsCount, newTime);
324     }
325     
326     function payWithdraw(address to) internal
327     {
328         require(deposits[to].length > 0);
329         
330         uint sum = 0;
331         
332         for(uint i = 0; i < deposits[to].length; i++)
333         {
334             uint value = calculateWithdraw(now, deposits[to][i].time, deposits[to][i].value, deposits[to][i].timeOfLastWithdraw);
335             if(value > 0) 
336             {
337                 deposits[to][i].timeOfLastWithdraw = calculateNewTime(deposits[to][i].timeOfLastWithdraw, now);
338             }
339             sum = sum.add(value);
340         }
341         
342         require(sum > 0);
343         
344         to.transfer(sum);
345         
346         emit Withdraw(to, sum);
347     }
348     
349     
350     function withdraw() checkSender public returns (bool)
351     {
352         payWithdraw(msg.sender);
353         return true;
354     }
355     
356     function batchWithdraw(address[] to) onlyOwner public 
357     {
358         for(uint i = 0; i < to.length; i++)
359         {
360             payWithdraw(to[i]);
361         }
362     }
363     
364     function batchWithdraw(uint startIndex, uint length) onlyOwner public 
365     {
366         for(uint i = startIndex; i < length; i++)
367         {
368             payWithdraw(investors[i]);
369         }
370     }
371 }