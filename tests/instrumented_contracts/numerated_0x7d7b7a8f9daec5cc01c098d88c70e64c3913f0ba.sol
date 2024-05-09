1 pragma solidity ^0.8.13;
2 
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(
11         address sender,
12         address recipient,
13         uint256 amount
14     ) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 library Address {
20     function isContract(address account) internal view returns (bool) {
21         uint256 size; assembly {
22             size := extcodesize(account)
23         } return size > 0;
24     }
25     function sendValue(address payable recipient, uint256 amount) internal {
26         require(address(this).balance >= amount, "Address: insufficient balance");
27         (bool success, ) = recipient.call{value: amount}("");
28         require(success, "Address: unable to send value, recipient may have reverted");
29     }
30     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
31         return functionCall(target, data, "Address: low-level call failed");
32     }
33     function functionCall(address target,bytes memory data,string memory errorMessage) internal returns (bytes memory) {
34         return functionCallWithValue(target, data, 0, errorMessage);
35     }
36     function functionCallWithValue(address target,bytes memory data,uint256 value) internal returns (bytes memory) {
37         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
38     }
39     function functionCallWithValue(address target,bytes memory data,uint256 value,string memory errorMessage) internal returns (bytes memory) {
40         require(address(this).balance >= value, "Address: insufficient balance for call");
41         require(isContract(target), "Address: call to non-contract");
42         (bool success, bytes memory returndata) = target.call{value: value}(data);
43         return verifyCallResult(success, returndata, errorMessage);
44     }
45     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
46         return functionStaticCall(target, data, "Address: low-level static call failed");
47     }
48     function functionStaticCall(address target,bytes memory data,string memory errorMessage) internal view returns (bytes memory) {
49         require(isContract(target), "Address: static call to non-contract");
50         (bool success, bytes memory returndata) = target.staticcall(data);
51         return verifyCallResult(success, returndata, errorMessage);
52     }
53     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
54         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
55     }
56     function functionDelegateCall(address target,bytes memory data,string memory errorMessage) internal returns (bytes memory) {
57         require(isContract(target), "Address: delegate call to non-contract");
58         (bool success, bytes memory returndata) = target.delegatecall(data);
59         return verifyCallResult(success, returndata, errorMessage);
60     }
61     function verifyCallResult(bool success,bytes memory returndata,string memory errorMessage) internal pure returns (bytes memory) {
62         if (success) {
63             return returndata;
64         } else {
65             if (returndata.length > 0) {
66                 assembly {
67                     let returndata_size := mload(returndata)
68                     revert(add(32, returndata), returndata_size)
69                 }
70             } else {
71                 revert(errorMessage);
72             }
73         }
74     }
75 }
76 library SafeERC20 {
77     using Address for address;
78     function safeTransfer(
79         IERC20 token,
80         address to,
81         uint256 value
82     ) internal {
83         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
84     }
85     function safeTransferFrom(
86         IERC20 token,
87         address from,
88         address to,
89         uint256 value
90     ) internal {
91         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
92     }
93     function safeApprove(
94         IERC20 token,
95         address spender,
96         uint256 value
97     ) internal {
98         require((value == 0) || (token.allowance(address(this), spender) == 0),
99             "SafeERC20: approve from non-zero to non-zero allowance");
100         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
101     }
102     function safeIncreaseAllowance(IERC20 token,address spender,uint256 value) internal {
103         uint256 newAllowance = token.allowance(address(this), spender) + value;
104         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
105     }
106     function safeDecreaseAllowance(IERC20 token,address spender,uint256 value) internal {
107         unchecked {
108             uint256 oldAllowance = token.allowance(address(this), spender);
109             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
110             uint256 newAllowance = oldAllowance - value;
111             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
112         }
113     }
114     function _callOptionalReturn(IERC20 token, bytes memory data) private {   
115         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
116         if (returndata.length > 0) {
117             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
118         }
119     }
120 }
121 library SafeMath {
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125         return c;
126     }
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b <= a, "SafeMath: subtraction overflow");
129         uint256 c = a - b;
130         return c;
131     }
132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133         if (a == 0) {
134             return 0;
135         }
136         uint256 c = a * b;
137         require(c / a == b, "SafeMath: multiplication overflow");
138         return c;
139     }
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b > 0, "SafeMath: division by zero");
142         uint256 c = a / b;
143         return c;
144     }
145 }
146 //libraries
147 struct User {
148     uint256 startDate;
149     uint256 divs;
150     uint256 refBonus;
151     uint256 totalInits;
152     uint256 totalWiths;
153     uint256 totalAccrued;
154     uint256 lastWith;
155     uint256 timesCmpd;
156     uint256 keyCounter;
157     Depo [] depoList;
158 }
159 struct Depo {
160     uint256 key;
161     uint256 depoTime;
162     uint256 amt;
163     address reffy;
164     bool initialWithdrawn;
165 }
166 struct Main {
167     uint256 ovrTotalDeps;
168     uint256 ovrTotalWiths;
169     uint256 users;
170     uint256 compounds;
171 }
172 struct DivPercs{
173     uint256 daysInSeconds; // updated to be in seconds
174     uint256 divsPercentage;
175 }
176 struct FeesPercs{
177     uint256 daysInSeconds;
178     uint256 feePercentage;
179 }
180 contract WealthMountainETH {
181     using SafeMath for uint256;
182     uint256 constant launch = 1657296000;
183   	uint256 constant hardDays = 86400;
184     uint256 constant percentdiv = 1000;
185     uint256 refPercentage = 30;
186     uint256 devPercentage = 100;
187     mapping (address => mapping(uint256 => Depo)) public DeposMap;
188     mapping (address => User) public UsersKey;
189     mapping (uint256 => DivPercs) public PercsKey;
190     mapping (uint256 => FeesPercs) public FeesKey;
191     mapping (uint256 => Main) public MainKey;
192     using SafeERC20 for IERC20;
193     IERC20 public USDC;
194     address public owner;
195 
196     constructor() {
197             owner = msg.sender;
198             PercsKey[10] = DivPercs(864000, 10);
199             PercsKey[20] = DivPercs(1728000, 20);
200             PercsKey[30] = DivPercs(2592000, 30);
201             PercsKey[40] = DivPercs(3456000, 40);
202             PercsKey[50] = DivPercs(4320000, 50);
203             FeesKey[10] = FeesPercs(864000, 100);
204             FeesKey[20] = FeesPercs(1728000, 80);
205             FeesKey[30] = FeesPercs(3456000, 50);
206             FeesKey[40] = FeesPercs(4320000, 20);
207            
208             USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
209 
210 
211     }
212     function stakeStablecoins(uint256 amtx, address ref) payable public {
213         require(block.timestamp >= launch || msg.sender == owner, "App did not launch yet.");
214         require(ref != msg.sender, "You cannot refer yourself!");
215         USDC.safeTransferFrom(msg.sender, address(this), amtx);
216         User storage user = UsersKey[msg.sender];
217         User storage user2 = UsersKey[ref];
218         Main storage main = MainKey[1];
219         if (user.lastWith == 0){
220             user.lastWith = block.timestamp;
221             user.startDate = block.timestamp;
222         }
223         uint256 userStakePercentAdjustment = 1000 - devPercentage;
224         uint256 adjustedAmt = amtx.mul(userStakePercentAdjustment).div(percentdiv);
225         uint256 stakeFee = amtx.mul(devPercentage).div(percentdiv); 
226         
227         user.totalInits += adjustedAmt; 
228         uint256 refAmtx = adjustedAmt.mul(refPercentage).div(percentdiv);
229         if (ref == 0x000000000000000000000000000000000000dEaD){
230             user2.refBonus += 0;
231             user.refBonus += 0;
232         } else {
233             user2.refBonus += refAmtx;
234             user.refBonus += refAmtx;
235         }
236 
237         user.depoList.push(Depo({
238             key: user.depoList.length,
239             depoTime: block.timestamp,
240             amt: adjustedAmt,
241             reffy: ref,
242             initialWithdrawn: false
243         }));
244 
245         user.keyCounter += 1;
246         main.ovrTotalDeps += 1;
247         main.users += 1;
248         
249         USDC.safeTransfer(owner, stakeFee);
250     }
251 
252     function userInfo() view external returns (Depo [] memory depoList){
253         User storage user = UsersKey[msg.sender];
254         return(
255             user.depoList
256         );
257     }
258 
259     function withdrawDivs() public returns (uint256 withdrawAmount){
260         User storage user = UsersKey[msg.sender];
261         Main storage main = MainKey[1];
262         uint256 x = calcdiv(msg.sender);
263       
264       	for (uint i = 0; i < user.depoList.length; i++){
265           if (user.depoList[i].initialWithdrawn == false) {
266             user.depoList[i].depoTime = block.timestamp;
267           }
268         }
269 
270         main.ovrTotalWiths += x;
271         user.lastWith = block.timestamp;
272 
273         USDC.safeTransfer(msg.sender, x);
274         return x;
275     }
276 
277     function withdrawInitial(uint256 keyy) public {
278       	  
279       	User storage user = UsersKey[msg.sender];
280 				
281       	require(user.depoList[keyy].initialWithdrawn == false, "This has already been withdrawn.");
282       
283         uint256 initialAmt = user.depoList[keyy].amt; 
284         uint256 currDays1 = user.depoList[keyy].depoTime; 
285         uint256 currTime = block.timestamp; 
286         uint256 currDays = currTime - currDays1;
287         uint256 transferAmt;
288       	
289         if (currDays < FeesKey[10].daysInSeconds){ // LESS THAN 10 DAYS STAKED
290             uint256 minusAmt = initialAmt.mul(FeesKey[10].feePercentage).div(percentdiv); //10% fee
291            	
292           	uint256 dailyReturn = initialAmt.mul(PercsKey[10].divsPercentage).div(percentdiv);
293             uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
294           	
295           	transferAmt = initialAmt + currentReturn - minusAmt;
296           
297             user.depoList[keyy].amt = 0;
298             user.depoList[keyy].initialWithdrawn = true;
299             user.depoList[keyy].depoTime = block.timestamp;
300 
301 
302             USDC.safeTransfer(msg.sender, transferAmt);
303             USDC.safeTransfer(owner, minusAmt);
304 
305 
306         } else if (currDays >= FeesKey[10].daysInSeconds && currDays < FeesKey[20].daysInSeconds){ // BETWEEN 20 and 30 DAYS
307             uint256 minusAmt = initialAmt.mul(FeesKey[20].feePercentage).div(percentdiv); //8% fee
308 						
309           	uint256 dailyReturn = initialAmt.mul(PercsKey[10].divsPercentage).div(percentdiv);
310             uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
311 						transferAmt = initialAmt + currentReturn - minusAmt;
312 
313             user.depoList[keyy].amt = 0;
314             user.depoList[keyy].initialWithdrawn = true;
315             user.depoList[keyy].depoTime = block.timestamp;
316 
317 
318             USDC.safeTransfer(msg.sender, transferAmt);
319             USDC.safeTransfer(owner, minusAmt);
320 
321 
322         } else if (currDays >= FeesKey[20].daysInSeconds && currDays < FeesKey[30].daysInSeconds){ // BETWEEN 30 and 40 DAYS
323             uint256 minusAmt = initialAmt.mul(FeesKey[30].feePercentage).div(percentdiv); //5% fee
324             
325           	uint256 dailyReturn = initialAmt.mul(PercsKey[20].divsPercentage).div(percentdiv);
326             uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
327 						transferAmt = initialAmt + currentReturn - minusAmt;
328 
329             user.depoList[keyy].amt = 0;
330             user.depoList[keyy].initialWithdrawn = true;
331             user.depoList[keyy].depoTime = block.timestamp;
332 
333             USDC.safeTransfer(msg.sender, transferAmt);
334             USDC.safeTransfer(owner, minusAmt);
335 
336         } else if (currDays >= FeesKey[30].daysInSeconds && currDays < FeesKey[40].daysInSeconds){ // BETWEEN 30 and 40 DAYS
337             uint256 minusAmt = initialAmt.mul(FeesKey[40].feePercentage).div(percentdiv); //5% fee
338             
339           	uint256 dailyReturn = initialAmt.mul(PercsKey[30].divsPercentage).div(percentdiv);
340             uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
341 						transferAmt = initialAmt + currentReturn - minusAmt;
342 
343             user.depoList[keyy].amt = 0;
344             user.depoList[keyy].initialWithdrawn = true;
345             user.depoList[keyy].depoTime = block.timestamp;
346 
347             USDC.safeTransfer(msg.sender, transferAmt);
348             USDC.safeTransfer(owner, minusAmt);
349           
350         } else if (currDays >= FeesKey[40].daysInSeconds && currDays < FeesKey[50].daysInSeconds){ // BETWEEN 30 and 40 DAYS
351             uint256 minusAmt = initialAmt.mul(FeesKey[40].feePercentage).div(percentdiv); //2% fee
352             
353           	uint256 dailyReturn = initialAmt.mul(PercsKey[40].divsPercentage).div(percentdiv);
354             uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
355 						transferAmt = initialAmt + currentReturn - minusAmt;
356 
357             user.depoList[keyy].amt = 0;
358             user.depoList[keyy].initialWithdrawn = true;
359             user.depoList[keyy].depoTime = block.timestamp;
360 
361             USDC.safeTransfer(msg.sender, transferAmt);
362             USDC.safeTransfer(owner, minusAmt);
363 
364         } else if (currDays >= FeesKey[50].daysInSeconds){ // 40+ DAYS
365             uint256 minusAmt = initialAmt.mul(FeesKey[40].feePercentage).div(percentdiv); //2% fee
366             
367           	uint256 dailyReturn = initialAmt.mul(PercsKey[50].divsPercentage).div(percentdiv);
368             uint256 currentReturn = dailyReturn.mul(currDays).div(hardDays);
369 						transferAmt = initialAmt + currentReturn - minusAmt;
370 
371             user.depoList[keyy].amt = 0;
372             user.depoList[keyy].initialWithdrawn = true;
373             user.depoList[keyy].depoTime = block.timestamp;
374             
375             USDC.safeTransfer(msg.sender, transferAmt);
376             USDC.safeTransfer(owner, minusAmt);
377 
378         } else {
379             revert("Could not calculate the # of days youv've been staked.");
380         }
381         
382     }
383     function withdrawRefBonus() public {
384         User storage user = UsersKey[msg.sender];
385         uint256 amtz = user.refBonus;
386         user.refBonus = 0;
387         USDC.safeTransfer(msg.sender, amtz);
388     }
389 
390     function stakeRefBonus() public { 
391         User storage user = UsersKey[msg.sender];
392         Main storage main = MainKey[1];
393         require(user.refBonus > 10);
394       	uint256 refferalAmount = user.refBonus;
395         user.refBonus = 0;
396         address ref = 0x000000000000000000000000000000000000dEaD; //DEAD ADDRESS
397 				
398         user.depoList.push(Depo({
399             key: user.keyCounter,
400             depoTime: block.timestamp,
401             amt: refferalAmount,
402             reffy: ref, 
403             initialWithdrawn: false
404         }));
405 
406         user.keyCounter += 1;
407         main.ovrTotalDeps += 1;
408     }
409 
410     function calcdiv(address dy) public view returns (uint256 totalWithdrawable){	
411         User storage user = UsersKey[dy];	
412 
413         uint256 with;
414         
415         for (uint256 i = 0; i < user.depoList.length; i++){	
416             uint256 elapsedTime = block.timestamp.sub(user.depoList[i].depoTime);
417 
418             uint256 amount = user.depoList[i].amt;
419             if (user.depoList[i].initialWithdrawn == false){
420                 if (elapsedTime <= PercsKey[20].daysInSeconds){ 
421                     uint256 dailyReturn = amount.mul(PercsKey[10].divsPercentage).div(percentdiv);
422                     uint256 currentReturn = dailyReturn.mul(elapsedTime).div(PercsKey[10].daysInSeconds / 10);
423                     with += currentReturn;
424                 }
425                 if (elapsedTime > PercsKey[20].daysInSeconds && elapsedTime <= PercsKey[30].daysInSeconds){
426                     uint256 dailyReturn = amount.mul(PercsKey[20].divsPercentage).div(percentdiv);
427                     uint256 currentReturn = dailyReturn.mul(elapsedTime).div(PercsKey[10].daysInSeconds / 10);
428                     with += currentReturn;
429                 }
430                 if (elapsedTime > PercsKey[30].daysInSeconds && elapsedTime <= PercsKey[40].daysInSeconds){
431                     uint256 dailyReturn = amount.mul(PercsKey[30].divsPercentage).div(percentdiv);
432                     uint256 currentReturn = dailyReturn.mul(elapsedTime).div(PercsKey[10].daysInSeconds / 10);
433                     with += currentReturn;
434                 }
435                 if (elapsedTime > PercsKey[40].daysInSeconds && elapsedTime <= PercsKey[50].daysInSeconds){
436                     uint256 dailyReturn = amount.mul(PercsKey[40].divsPercentage).div(percentdiv);
437                     uint256 currentReturn = dailyReturn.mul(elapsedTime).div(PercsKey[10].daysInSeconds / 10);
438                     with += currentReturn;
439                 }
440                 if (elapsedTime > PercsKey[50].daysInSeconds){
441                     uint256 dailyReturn = amount.mul(PercsKey[50].divsPercentage).div(percentdiv);
442                     uint256 currentReturn = dailyReturn.mul(elapsedTime).div(PercsKey[10].daysInSeconds / 10);
443                     with += currentReturn;
444                 }
445                 
446             } 
447         }
448         return with;
449     }
450   		function compound() public {
451         User storage user = UsersKey[msg.sender];
452         Main storage main = MainKey[1];
453 
454         uint256 y = calcdiv(msg.sender);
455 
456         for (uint i = 0; i < user.depoList.length; i++){
457           if (user.depoList[i].initialWithdrawn == false) {
458             user.depoList[i].depoTime = block.timestamp;
459           }
460         }
461 
462         user.depoList.push(Depo({
463               key: user.keyCounter,
464               depoTime: block.timestamp,
465               amt: y,
466               reffy: 0x000000000000000000000000000000000000dEaD, 
467               initialWithdrawn: false
468           }));
469 
470         user.keyCounter += 1;
471         main.ovrTotalDeps += 1;
472         main.compounds += 1;
473         user.lastWith = block.timestamp;  
474       }
475 }