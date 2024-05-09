1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.1;
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         require(b <= a, "SafeMath: subtraction overflow");
14         uint256 c = a - b;
15         return c;
16     }
17 
18      function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         require(c / a == b, "SafeMath: multiplication overflow");
24         return c;
25     }
26 
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         require(b > 0, "SafeMath: division by zero");
29         uint256 c = a / b;
30         return c;
31     }
32 
33 }
34 
35 contract ERC20 {
36     using SafeMath for uint256;
37 
38     string public name;
39     string public symbol;
40     uint256 public totalBurnValue;
41     uint256 _totalSupply;
42     uint256 _totalDevSupply;
43     uint256 public devSupply;
44     uint8 public constant decimals = 18;
45     uint256 public constant distSupply = 100 * (10**6) * 10**decimals;   // 100m tokens for distribution
46     uint256 public constant devSupplyCap = 5 * (10**6) * 10**decimals;   // 5m tokens for community distribution
47     bool public hardCapAchieved;
48 
49     mapping(address => uint256) _balances;
50     mapping(address => uint256) _burnBalances;
51 
52     mapping(address => mapping(address => uint256)) _allowances;
53     mapping(address => mapping(address => uint256)) _burnAllowances;
54 
55     event Purchase(address indexed from, uint256 ethValue, uint256 tokenValue);
56     event Claim(address indexed from, uint256 ethValue);
57     event Burn(address indexed from, uint256 tokenValue);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event CommunityTransfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed TokenOwner, address indexed spender, uint256 value);
61     event burnApproval(address indexed TokenOwner, address indexed spender, uint256 value);
62 
63     function totalSupply() public virtual view returns (uint256) {
64         return _totalSupply;
65     }
66 
67     function totalDevSupply() public virtual view returns (uint256) {
68         return _totalDevSupply;
69     }
70 
71     function balanceOf(address account) public virtual view returns (uint256) {
72         return _balances[account];
73     }
74 
75     function burnBalanceOf(address account) public virtual view returns (uint256) {
76         return _burnBalances[account];
77     }
78 
79     function transfer(address recipient, uint256 amount) public virtual returns (bool) {
80         _transfer(msg.sender, recipient, amount);
81         return true;
82     }
83 
84     function allowance(address TokenOwner, address spender) public virtual view returns (uint256) {
85         return _allowances[TokenOwner][spender];
86     }
87 
88     function burnAllowance(address TokenOwner, address spender) public virtual view returns (uint256) {
89         return _burnAllowances[TokenOwner][spender];
90     }
91 
92     function approve(address spender, uint256 value) public virtual returns (bool) {
93         _approve(msg.sender, spender, value);
94         return true;
95     }
96 
97     function approveBurn(address spender, uint256 value) public virtual returns (bool) {
98         _approveBurn(msg.sender, spender, value);
99         return true;
100     }
101 
102     function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool) {
103         require(_allowances[sender][msg.sender] >= amount,"Insufficient balance in delegation.");
104 
105         _transfer(sender, recipient, amount);
106         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
107         return true;
108     }
109 
110     function burnFrom(address sender, uint256 amount) public virtual returns (bool) {
111         require(_burnAllowances[sender][msg.sender] >= amount,"Insufficient balance in delegation.");
112 
113         _burn(sender, amount);
114         _approveBurn(sender, msg.sender, _burnAllowances[sender][msg.sender].sub(amount));
115         return true;
116     }
117 
118     function _transfer(address sender,address recipient,uint256 amount) internal{
119         require(sender != address(0), "Invalid sender address.");
120         require(recipient != address(0), "Invalid recipient address.");
121         require(_balances[sender] >= amount, "Insufficient balance.");
122         require(amount >0, "Invalid transfer amount.");
123 
124         _balances[sender] = _balances[sender].sub(amount);
125         _balances[recipient] = _balances[recipient].add(amount);
126         emit Transfer(sender, recipient, amount);
127     }
128 
129     function _mint(address account, uint256 amount) internal {
130         require(account != address(0), "Invalid recipient address.");
131         require(hardCapAchieved==false, "New tokens cannot be generated as contract hardcap is over.");
132 
133         if (_totalSupply.add(amount) >= distSupply) {
134             if (_totalSupply.add(amount) > distSupply) {
135                 amount = distSupply.sub(_totalSupply); // calculate difference
136             }
137             hardCapAchieved=true; // no more mint is allowed
138         }
139 
140         _totalSupply = _totalSupply.add(amount);
141         _balances[account] = _balances[account].add(amount);
142 
143         if (devSupply != devSupplyCap) {
144             if (_totalSupply.div(10) < devSupplyCap) 
145                 devSupply = _totalSupply.div(10); // devSupply capped at 10% of totalSupply
146             else
147                 devSupply = devSupplyCap;
148         }
149         
150         emit Transfer(address(0), account, amount);
151     }
152 
153     function _mintForCommunity(address account, uint256 amount) internal {
154         require(account != address(0), "Invalid recipient address.");
155         require(amount >0,"Please specefiy the amount of coins to be minted.");
156         require(devSupply > _totalDevSupply, "No Balance is left in community bucket for distribution.");
157 
158         if (_totalDevSupply.add(amount) > devSupply) {
159             amount = devSupply.sub(_totalDevSupply); // calculate difference
160         }
161 
162         _totalDevSupply = _totalDevSupply.add(amount);
163         _balances[account] = _balances[account].add(amount);
164 
165         emit CommunityTransfer(address(0), account, amount);
166     }
167 
168     function _burn(address account, uint256 value) internal {
169         require(account != address(0), "Invalid account address.");
170         require(hardCapAchieved==true, 'Burn is allowed only after the contract hardcap is achieved.');
171         require(_balances[account] >= value, "Insufficient balance.");
172 
173         _totalSupply = _totalSupply.sub(value);
174         _balances[account] = _balances[account].sub(value);
175         _burnBalances[account] = _burnBalances[account].add(value);
176         totalBurnValue = totalBurnValue.add(value);
177 
178         emit Transfer(account, address(0), value);
179         emit Burn(account,value);
180     }
181 
182     function _approve(address TokenOwner,address spender,uint256 value) internal {
183         require(TokenOwner != address(0),"Invalid sender address.");
184         require(spender != address(0), "Invalid recipient address.");
185 
186         _allowances[TokenOwner][spender] = value;
187         emit Approval(TokenOwner, spender, value);
188     }
189 
190     function _approveBurn(address TokenOwner,address spender,uint256 value) internal {
191         require(TokenOwner != address(0),"Invalid sender address.");
192         require(spender != address(0), "Invalid recipient address.");
193 
194         _burnAllowances[TokenOwner][spender] = value;
195         emit burnApproval(TokenOwner, spender, value);
196     }
197 }
198 
199 contract NBTCToken is ERC20 {
200     address OwnerAddress;
201     uint256 public hardCapValidTime;
202 
203     modifier isOwner() {
204         require(msg.sender == OwnerAddress);
205         _;
206     }
207 
208     modifier isContractActive(){
209         require(hardCapAchieved == false,"Contract is currently inactive as hardCap period/volume is over.");
210         _;
211     }
212 
213     function checkHardCap() public  {
214         if (block.timestamp > hardCapValidTime && hardCapAchieved==false) {
215             hardCapAchieved=true; // no more mint is allowed
216         }
217     }
218 
219     constructor() {
220         OwnerAddress=msg.sender;
221         hardCapAchieved=false;
222         _totalSupply=0;
223         totalBurnValue=0;
224         devSupply=0;
225     } 
226 }
227 
228 contract ReentrancyGuard {
229   bool private reentrancyLock = false;
230   
231   modifier nonReentrant() {
232     require(!reentrancyLock);
233     reentrancyLock = true;
234     _;
235     reentrancyLock = false;
236   }
237 }
238 
239 contract NBTC is NBTCToken,ReentrancyGuard {
240     using SafeMath for uint256;
241 
242     mapping (address => User) public users;
243     mapping (uint8 => Slab) public mulfact;
244     mapping (uint8 => uint8) public levelComm;
245     mapping (uint8 => uint256) public levelVolume;
246 
247     uint256 public totalUsers;
248     uint8 public mfIndex;
249 
250     struct User {
251         uint8 level;
252         uint256 directVolume;
253         uint256 indirectVolume;
254         uint32 directCount;
255         uint32 indirectCount;
256         uint256 claimed;  
257         address parent;
258         uint256 ethBalance; 
259         uint256 ethInvest;
260     }
261 
262     struct Slab {
263         uint256 saleVolume;
264         uint16 mulFactor;
265     }
266 
267     constructor(string memory cName, string memory cSymbol,uint256 expireSeconds) {
268         name=cName;
269         symbol=cSymbol;
270 
271         levelComm[1] = 50;
272         levelComm[2] = 60;
273         levelComm[3] = 65;
274         levelComm[4] = 70;
275         levelComm[5] = 75;
276         levelComm[6] = 80;
277         levelComm[7] = 85;
278         levelComm[8] = 90;
279         levelComm[9] = 95;
280         levelComm[10] = 100;
281 
282         levelVolume[1] = 0;
283         levelVolume[2] = 1000 * 10**decimals; // 1k tokens
284         levelVolume[3] = 10000 * 10**decimals; // 10k lakh tokens
285         levelVolume[4] = 100000 * 10**decimals; // 1 lakh tokens
286         levelVolume[5] = 200000 * 10**decimals; // 2 lakh tokens
287         levelVolume[6] = 400000 * 10**decimals; // 4 lakh tokens
288         levelVolume[7] = 800000 * 10**decimals; // 8 lakh tokens
289         levelVolume[8] = 1600000 * 10**decimals; // 16 lakh tokens
290         levelVolume[9] = 3200000 * 10**decimals; // 32 lakh tokens
291         levelVolume[10] = 6400000 * 10**decimals; // 64 lakh tokens
292         
293         mulfact[1] = Slab({ saleVolume: 500000 * 10**decimals, mulFactor: 500 }); // 5 lakh token, 0.5 mil
294         mulfact[2] = Slab({ saleVolume: 2500000 * 10**decimals, mulFactor: 300 }); // 25 lakh token, 2.5 mil
295         mulfact[3] = Slab({ saleVolume: 5000000 * 10**decimals, mulFactor: 250 }); // 50 lakh token, 5 mil
296         mulfact[4] = Slab({ saleVolume: 10000000 * 10**decimals, mulFactor: 200 }); // 1 cr token, 10 mil
297         mulfact[5] = Slab({ saleVolume: 20000000 * 10**decimals, mulFactor: 175 }); // 2 cr token, 20 mil,
298         mulfact[6] = Slab({ saleVolume: 30000000 * 10**decimals, mulFactor: 150 }); // 3 cr token, 30 mil
299         mulfact[7] = Slab({ saleVolume: 40000000 * 10**decimals, mulFactor: 125 }); // 4 cr token, 40 mil
300         mulfact[8] = Slab({ saleVolume: 50000000 * 10**decimals, mulFactor: 100 }); // 5 cr token, 50 mil,
301         mulfact[9] = Slab({ saleVolume: 100000000 * 10**decimals, mulFactor: 50 }); // 10 cr token, 100 mil
302 
303         mfIndex=1;
304         totalUsers=0;
305 
306         hardCapValidTime = block.timestamp.add(expireSeconds);  // expire in one day ie in 86400 seconds
307 
308         users[OwnerAddress] = User({
309         level: 10,
310         directVolume: 0,
311         indirectVolume: 0,
312         directCount:0,
313         indirectCount:0,
314         claimed:0,
315         parent: OwnerAddress,
316         ethBalance:0,
317         ethInvest:0
318         });
319     }
320 
321     modifier userRegistered() {
322         require(users[msg.sender].level != 0, 'User does not exist');
323         _;
324     }
325 
326     /* Dont accept eth*/  
327     receive() external payable {
328         revert("The contract does not accept direct payment, please use the purchase method with a referral address.");
329     }
330 
331     function mintForCommunity(address account, uint256 amount) public isOwner {
332         _mintForCommunity(account,amount) ;
333     }
334 
335     function burn(uint256 amount) public returns (bool) {
336         require(balanceOf(msg.sender) >= amount,'Insufficient tokens to burn');
337         require(hardCapAchieved == true,"You can not burn token as hardcap is not achieved.");       
338 
339         _burn(msg.sender, amount);
340         return true;
341     }
342 
343     function withdraw(uint256 amount) external userRegistered nonReentrant{
344         require(users[msg.sender].ethBalance >=amount,'insufficient balance for withdrawl.');
345         require(amount > 0,'Invalid withdrawal amount.');
346     
347         users[msg.sender].ethBalance = users[msg.sender].ethBalance.sub(amount);
348         users[msg.sender].claimed = users[msg.sender].claimed.add(amount);
349         (bool success,  ) = msg.sender.call{value: amount}("");
350         require(success, "Transfer failed.");
351         emit Claim(msg.sender,amount);
352     }
353 
354     function purchase(address refAddress) external payable isContractActive {
355         require(refAddress != address(0), 'Referral Address is mandatory.');
356         require(users[refAddress].level != 0, 'Referral Address is not registered.');
357         require(msg.value >=100000000000000000,'Minimum purchase amount is 0.1 eth');
358         require(msg.value <=100000000000000000000,'Maximum purchase amount is 100 eth.');
359 
360         bool isNewUser= false;
361         uint256 tokenVol;
362 
363         uint commLeft;
364         uint commPer;
365         uint commGiven;
366         uint comm;
367         uint commVal;
368         address userAddr;
369         address parentAddr;
370 
371         tokenVol= gettokenCount(msg.value); //msg.value.mul(100);
372 
373         if (users[msg.sender].level == 0) {
374             register(refAddress);
375             isNewUser = true;
376         }
377         else
378             require(refAddress == users[msg.sender].parent, "Sender belongs to different referral address");
379 
380         _mint(msg.sender, tokenVol);
381 
382         // update eth balance and reserve 75 % 
383         users[msg.sender].ethInvest = users[msg.sender].ethInvest.add(msg.value);
384         commLeft=100;
385         commGiven=0;
386         userAddr=msg.sender;
387 
388         //distribute eth to parent heirarchy until level10
389         while (commLeft > 0) {
390             parentAddr=users[userAddr].parent;
391             commPer=levelComm[users[parentAddr].level];  // commission percentage at parent level
392             comm=commPer.sub(commGiven);              // comm to give  
393             commGiven=commGiven.add(comm);
394             commVal= msg.value.mul(comm).div(100);
395             users[parentAddr].ethBalance=users[parentAddr].ethBalance.add(commVal);
396             commLeft = commLeft.sub(comm);
397             userAddr=parentAddr;
398         }
399         
400         parentAddr=users[msg.sender].parent;
401 
402         // add Volume to immediate parent node
403         users[parentAddr].directVolume=users[parentAddr].directVolume.add(tokenVol);
404         upgradelevel(parentAddr);
405         
406         //upgrade level and volume of the heirarchy till top node
407         userAddr = parentAddr;
408         
409         while (userAddr !=users[parentAddr].parent)
410         {
411             parentAddr=users[userAddr].parent;
412             users[parentAddr].indirectVolume=users[parentAddr].indirectVolume.add(tokenVol);
413             if (isNewUser)
414                 users[parentAddr].indirectCount+=1;
415             upgradelevel(parentAddr);
416             userAddr=parentAddr;
417         }
418 
419         checkHardCap();
420         emit Purchase(msg.sender,msg.value,tokenVol);
421     }
422 
423     function upgradelevel(address refAddr) internal
424     {
425             uint256 totVolume;
426             uint8 idx;
427             
428             totVolume = users[refAddr].directVolume.add(users[refAddr].indirectVolume);
429             idx =users[refAddr].level;
430 
431             while (idx <=10)
432             {
433                 if(totVolume >= levelVolume[idx]) 
434                     users[refAddr].level = idx;  
435                 else    
436                     break;
437 
438                 idx++;
439             }
440     }
441 
442     function register(address refAddr) internal
443     {
444         users[msg.sender] = User({
445             level: 1,
446             directVolume: 0,
447             indirectVolume: 0,
448             directCount:0,
449             indirectCount:0,
450             claimed:0,
451             parent: refAddr,
452             ethBalance:0,
453             ethInvest:0
454         });
455         
456         users[refAddr].directCount+=1;
457         totalUsers=totalUsers.add(1);
458     }
459     
460     function estimateTokenCount(uint256 ethVal) public view returns (uint256) {
461         require(ethVal >=100000000000000000,'Minimum estimation value is 0.1 ethereum.');
462         require(ethVal <=100000000000000000000,'Maximum estimation value is 100 ethereum.');
463 
464         uint16 mf;
465         uint256 tokenCnt;
466         uint256 postSupply;
467         uint256 diff;
468         uint256 ethUsed;
469         uint256 ethLeft;
470         
471         mf = mulfact[mfIndex].mulFactor;
472         tokenCnt=ethVal.mul(mf);
473         postSupply=_totalSupply.add(tokenCnt);
474 
475         if (postSupply > mulfact[mfIndex].saleVolume && mfIndex !=9)
476         {
477             diff = mulfact[mfIndex].saleVolume.sub(_totalSupply);
478             ethUsed= diff.div(mf);
479             ethLeft = ethVal.sub(ethUsed);
480             mf = mulfact[mfIndex+1].mulFactor;
481             tokenCnt=diff.add(ethLeft.mul(mf));
482             postSupply=_totalSupply.add(tokenCnt);
483         }
484 
485         if (postSupply >distSupply) {
486             tokenCnt = distSupply.sub(_totalSupply);
487         }
488         return tokenCnt;
489     }
490 
491     function gettokenCount(uint256 ethVal) internal returns (uint256) {
492         uint16 mf;
493         uint256 tokenCnt;
494         uint256 postSupply;
495         uint256 diff;
496         uint256 ethUsed;
497         uint256 ethLeft;
498         
499         mf = mulfact[mfIndex].mulFactor;
500         tokenCnt=ethVal.mul(mf);
501         postSupply=_totalSupply.add(tokenCnt);
502 
503         if (postSupply > mulfact[mfIndex].saleVolume && mfIndex !=9)
504         {
505             diff = mulfact[mfIndex].saleVolume.sub(_totalSupply);
506             ethUsed= diff.div(mf);
507             ethLeft = ethVal.sub(ethUsed);
508             mf = mulfact[mfIndex+1].mulFactor;
509             tokenCnt=diff.add(ethLeft.mul(mf));
510             postSupply=_totalSupply.add(tokenCnt);
511             mfIndex +=1;
512         }
513 
514         if (postSupply >distSupply) {
515             tokenCnt = distSupply.sub(_totalSupply);
516         }
517         return tokenCnt;
518     }
519 
520     function calculateEthValue(uint256 tokenVal) public view returns (uint256) {
521         require(tokenVal >=5000000000000000000,'Minimum estimation value is 5 nbtc tokens.');
522         require(tokenVal <=50000000000000000000000,'Maximum estimation value is 50000 nbtc tokens.');
523 
524         uint16 mf;
525         uint256 ethVal;
526         uint256 postSupply;
527         uint256 diff;
528         uint256 ethUsed;
529         uint256 tokenLeft;
530         
531         mf = mulfact[mfIndex].mulFactor;
532         ethVal=tokenVal.div(mf);
533         postSupply=_totalSupply.add(tokenVal);
534 
535         if (postSupply > mulfact[mfIndex].saleVolume && mfIndex !=9) {
536             diff = mulfact[mfIndex].saleVolume.sub(_totalSupply);
537             ethUsed= diff.div(mf);
538             tokenLeft = tokenVal.sub(diff);
539             mf = mulfact[mfIndex+1].mulFactor;
540             ethVal= ethUsed.add(tokenLeft.div(mf));
541         }
542         
543         return ethVal;
544     }
545 }