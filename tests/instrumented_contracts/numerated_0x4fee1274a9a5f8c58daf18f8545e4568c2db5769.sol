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
99     mapping(address => deposit) public deposits;
100     mapping(address => address) public parents;
101     address[] public investors;
102     
103     uint public constant withdrawPeriod = 1 days;
104     
105     uint public constant minDepositSum = 100 finney; // 0.1 ether;
106     
107     event Deposit(address indexed from, uint256 value);
108     event Withdraw(address indexed from, uint256 value);
109     event ReferrerBonus(address indexed from, address indexed to, uint8 level, uint256 value);
110     
111     
112     modifier checkSender() 
113     {
114         require(msg.sender != address(0));
115         _;
116     }
117 
118     
119     function bytesToAddress(bytes source) internal pure returns(address parsedAddress) 
120     {
121         assembly {
122             parsedAddress := mload(add(source,0x14))
123         }
124         return parsedAddress;
125     }
126 
127     function () checkSender public payable 
128     {
129         if(msg.value == 0)
130         {
131             withdraw();
132             return;
133         }
134         
135         require(msg.value >= minDepositSum);
136         
137         checkReferrer(msg.sender);
138         
139         payFee(msg.value);
140         addDeposit(msg.sender, msg.value);
141         
142         emit Deposit(msg.sender, msg.value);
143         
144         payRewards(msg.sender, msg.value);
145     }
146     
147     function getInvestorsLength() public view returns (uint)
148     {
149         return investors.length;
150     }
151     
152     function getParents(address investorAddress) public view returns (address[])
153     {
154         address[] memory refLevels = new address[](5);
155         address current = investorAddress;
156         
157         for(uint8 i = 0; i < 5; i++)
158         {
159              current = parents[current];
160              if(current == address(0)) break;
161              refLevels[i] = current;
162         }
163         
164         return refLevels;
165     }
166     
167     function calculateRewardForLevel(uint8 level, uint value) public pure returns (uint)
168     {
169         if(level == 1) return value.div(50);           // 2%
170         if(level == 2) return value.div(100);          // 1%
171         if(level == 3) return value.div(200);          // 0.5%
172         if(level == 4) return value.div(400);          // 0.25%
173         if(level == 5) return value.div(400);          // 0.25%
174         
175         return 0;
176     }
177     
178     function calculatWithdrawForPeriod(uint8 period, uint depositValue, uint periodsCount) public pure returns (uint)
179     {
180         if(period == 1)
181         {
182             return depositValue.div(25).mul(periodsCount);          // 4%
183         }
184         else if(period == 2)
185         {
186             return depositValue.mul(3).div(100).mul(periodsCount);  // 3%
187         }
188         else if(period == 3)
189         {
190             return depositValue.div(50).mul(periodsCount);          // 2%
191         }
192         else if(period == 4)
193         {
194             return depositValue.div(100).mul(periodsCount);         // 1%
195         }
196         else if(period == 5)
197         {
198             return depositValue.div(200).mul(periodsCount);         // 0.5%
199         }
200         
201         return 0;
202     }
203     
204     function calculateWithdraw(uint currentTime, uint depositTime, uint depositValue, uint timeOfLastWithdraw) public pure returns (uint)
205     {
206         if(currentTime - timeOfLastWithdraw < withdrawPeriod)
207         {
208             return 0;
209         }
210         
211         uint timeEndOfPeriod1 = depositTime + 30 days;
212         uint timeEndOfPeriod2 = depositTime + 60 days;
213         uint timeEndOfPeriod3 = depositTime + 90 days;
214         uint timeEndOfPeriod4 = depositTime + 120 days;
215         
216 
217         uint sum = 0;
218         uint timeEnd = 0;
219         uint periodsCount = 0;
220             
221         if(timeOfLastWithdraw < timeEndOfPeriod1)
222         {
223             timeEnd = currentTime > timeEndOfPeriod1 ? timeEndOfPeriod1 : currentTime;
224             (periodsCount, timeOfLastWithdraw) = calculatePeriodsCountAndNewTime(timeOfLastWithdraw, timeEnd);
225             sum = calculatWithdrawForPeriod(1, depositValue, periodsCount);
226         }
227         
228         if(timeOfLastWithdraw < timeEndOfPeriod2)
229         {
230             timeEnd = currentTime > timeEndOfPeriod2 ? timeEndOfPeriod2 : currentTime;
231             (periodsCount, timeOfLastWithdraw) = calculatePeriodsCountAndNewTime(timeOfLastWithdraw, timeEnd);
232             sum = sum.add(calculatWithdrawForPeriod(2, depositValue, periodsCount));
233         }
234         
235         if(timeOfLastWithdraw < timeEndOfPeriod3)
236         {
237             timeEnd = currentTime > timeEndOfPeriod3 ? timeEndOfPeriod3 : currentTime;
238             (periodsCount, timeOfLastWithdraw) = calculatePeriodsCountAndNewTime(timeOfLastWithdraw, timeEnd);
239             sum = sum.add(calculatWithdrawForPeriod(3, depositValue, periodsCount));
240         }
241         
242         if(timeOfLastWithdraw < timeEndOfPeriod4)
243         {
244             timeEnd = currentTime > timeEndOfPeriod4 ? timeEndOfPeriod4 : currentTime;
245             (periodsCount, timeOfLastWithdraw) = calculatePeriodsCountAndNewTime(timeOfLastWithdraw, timeEnd);
246             sum = sum.add(calculatWithdrawForPeriod(4, depositValue, periodsCount));
247         }
248         
249         if(timeOfLastWithdraw >= timeEndOfPeriod4)
250         {
251             timeEnd = currentTime;
252             (periodsCount, timeOfLastWithdraw) = calculatePeriodsCountAndNewTime(timeOfLastWithdraw, timeEnd);
253             sum = sum.add(calculatWithdrawForPeriod(5, depositValue, periodsCount));
254         }
255          
256         return sum;
257     }
258     
259     function checkReferrer(address investorAddress) internal
260     {
261         if(deposits[investorAddress].value == 0 && msg.data.length == 20)
262         {
263             address referrerAddress = bytesToAddress(bytes(msg.data));
264             require(referrerAddress != investorAddress);     
265             require(deposits[referrerAddress].value > 0);        
266             
267             parents[investorAddress] = referrerAddress;
268             investors.push(investorAddress);
269         }
270     }
271     
272     function payRewards(address investorAddress, uint depositValue) internal
273     {   
274         address[] memory parentAddresses = getParents(investorAddress);
275         for(uint8 i = 0; i < parentAddresses.length; i++)
276         {
277             address parent = parentAddresses[i];
278             if(parent == address(0)) break;
279             
280             uint rewardValue = calculateRewardForLevel(i + 1, depositValue);
281             parent.transfer(rewardValue);
282             
283             emit ReferrerBonus(investorAddress, parent, i + 1, rewardValue);
284         }
285     }
286     
287     function addDeposit(address investorAddress, uint weiAmount) internal
288     {   
289         if(deposits[investorAddress].value == 0)
290         {
291             deposits[investorAddress].time = now;
292             deposits[investorAddress].timeOfLastWithdraw = now;
293             deposits[investorAddress].value = weiAmount;
294         }
295         else
296         {
297             if(now - deposits[investorAddress].timeOfLastWithdraw >= withdrawPeriod)
298             {
299                 payWithdraw(investorAddress);
300             }
301             
302             deposits[investorAddress].value = deposits[investorAddress].value.add(weiAmount);
303             deposits[investorAddress].timeOfLastWithdraw = now;
304         }
305     }
306     
307     function payFee(uint weiAmount) internal
308     {
309         uint fee = weiAmount.mul(16).div(100); // 16%
310         owner.transfer(fee);
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
328         require(deposits[to].value > 0);
329         
330         uint sum = calculateWithdraw(now, deposits[to].time, deposits[to].value, deposits[to].timeOfLastWithdraw);
331         require(sum > 0);
332         
333         deposits[to].timeOfLastWithdraw = calculateNewTime(deposits[to].time, now);
334         
335         to.transfer(sum);
336         emit Withdraw(to, sum);
337     }
338     
339     
340     function withdraw() checkSender public returns (bool)
341     {
342         payWithdraw(msg.sender);
343         return true;
344     }
345     
346     
347     function batchWithdraw(address[] to) onlyOwner public 
348     {
349         for(uint i = 0; i < to.length; i++)
350         {
351             payWithdraw(to[i]);
352         }
353     }
354     
355     function batchWithdraw(uint startIndex, uint length) onlyOwner public 
356     {
357         for(uint i = startIndex; i < length; i++)
358         {
359             payWithdraw(investors[i]);
360         }
361     }
362 }