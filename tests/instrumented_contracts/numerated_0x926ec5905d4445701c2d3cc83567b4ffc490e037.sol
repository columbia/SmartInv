1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // EROS token
5 //
6 // Symbol      : ELOVE
7 // Name        : ELOVE Token for eLOVE Social Network
8 // Total supply: 200,000,000
9 // Decimals    : 2
10 
11 contract ERC20Interface {
12     function totalSupply() public constant returns (uint);
13     function balanceOf(address tokenOwner) public constant returns (uint balance);
14     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
15     function transfer(address to, uint tokens) public returns (bool success);
16     function approve(address spender, uint tokens) public returns (bool success);
17     function transferFrom(address from, address to, uint tokens) public returns (bool success);
18 
19     event Transfer(address indexed from, address indexed to, uint tokens);
20     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
21     event Burn(address indexed burner, uint256 value);
22 }
23 
24 // ----------------------------------------------------------------------------
25 // Contract function to receive approval and execute function in one call
26 // Borrowed from MiniMeToken
27 contract ApproveAndCallFallBack {
28     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
29 }
30 
31 // ----------------------------------------------------------------------------
32 // Owned contract
33 contract Owned {
34     
35     struct Investor {
36         address sender;
37         uint amount;
38         bool kyced;
39     }
40     
41     // version of this smart contract
42     string public version = "1.9";
43     
44     address public owner;
45     address public newOwner;
46     // reward pool wallet, un-sold tokens will be burned to this address
47     address public rewardPoolWallet;
48     
49     // List of investors with invested amount in ETH
50     Investor[] public investors;
51     
52     mapping(address => uint) public mapInvestors;
53     mapping(address => bool) public founders;
54     
55     event OwnershipTransferred(address indexed _from, address indexed _to);
56 
57     function Owned() public {
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65     
66     // Give KYC status, so token can be traded by this wallet
67     function changeKYCStatus(address inv, bool kycStatus) onlyOwner public returns (bool success) {
68         require(kycStatus == !investors[mapInvestors[inv]-1].kyced);
69         investors[mapInvestors[inv]-1].kyced = kycStatus;
70         return true;
71     }
72     
73     function setRewardPoolWallet(address rewardWallet) onlyOwner public returns(bool success) {
74         rewardPoolWallet = rewardWallet;
75         return true;
76     }
77     
78     function isExistInvestor(address inv) public constant returns (bool exist) {
79         return mapInvestors[inv] != 0;
80     }
81     
82     function isExistFounder(address _founder) public constant returns (bool exist) {
83         return founders[_founder];
84     }
85     
86     function removeFounder(address _founder) onlyOwner public returns (bool success) {
87         require(founders[_founder]);
88         founders[_founder] = false;
89         return true;
90     }
91     
92     function addFounder(address _founder) onlyOwner public returns (bool success) {
93         require(!founders[_founder]);
94         founders[_founder] = true;
95         return true;
96     }
97 
98     function transferOwnership(address _newOwner) public onlyOwner {
99         newOwner = _newOwner;
100     }
101     
102     function acceptOwnership() public {
103         require(msg.sender == newOwner);
104         OwnershipTransferred(owner, newOwner);
105         owner = newOwner;
106         newOwner = address(0);
107     }
108 }
109 
110 // ----------------------------------------------------------------------------
111 // ERC20 Token, with the addition of symbol, name and decimals and an
112 // initial fixed supply
113 // ----------------------------------------------------------------------------
114 contract ELOVEToken is ERC20Interface, Owned {
115     using SafeMath for uint;
116 
117     string public symbol;
118     string public name;
119     uint8 public decimals;
120     uint public _totalSupply;
121     
122     uint minInvest = 0.5 ether;
123     uint maxInvest = 500 ether;
124     
125     uint softcap = 5000 ether;
126     uint hardcap = 40000 ether;
127 
128     uint public icoStartDate;
129     
130     uint[4] public roundEnd;
131     uint[4] public roundTokenLeft;
132     uint[4] public roundBonus;
133     
134     uint public tokenLockTime;
135     uint public tokenFounderLockTime;
136     bool icoEnded = false;
137     bool kycCompleted = false;
138     
139     mapping(address => uint) balances;
140     mapping(address => mapping(address => uint)) allowed;
141 
142     uint etherExRate = 2000;
143 
144     // ------------------------------------------------------------------------
145     // Constructor
146     // ------------------------------------------------------------------------
147     function ELOVEToken(string tName, string tSymbol) public {
148         symbol = tSymbol;
149         name = tName;
150         decimals = 2;
151         _totalSupply = 200000000 * 10**uint(decimals); // 200.000.000 tokens
152         
153         icoStartDate            = 1518566401;   // 2018/02/14 00:00:01 AM
154         
155         // Ending time for each round
156         // pre-ICO round 1 : ends 28/02/2018, 10M tokens limit, 40% bonus
157         // pre-ICO round 2 : ends 15/03/2018, 10M tokens limit, 30% bonus
158         // crowdsale round 1 : ends 15/04/2018, 30M tokens limit, 10% bonus
159         // crowdsale round 2 : ends 30/04/2018, 30M tokens limit, 0% bonus
160         roundEnd = [1519862400, 1521158400, 1523836800, 1525132800];
161         roundTokenLeft = [1000000000, 1000000000, 3000000000, 3000000000];
162         roundBonus = [40, 30, 10, 0];
163         
164         // Founder can trade tokens 1 year after ICO ended
165         tokenFounderLockTime = roundEnd[3] + 365*24*3600;
166         
167         // Time to lock all ERC20 transfer 
168         tokenLockTime = 1572566400;     // 2019/11/01 after 18 months
169         
170         balances[owner] = _totalSupply;
171         Transfer(address(0), owner, _totalSupply);
172     }
173 
174     function setRoundEnd(uint round, uint newTime) onlyOwner public returns (bool success)  {
175         require(now<newTime);
176         if (round>0) {
177             require(newTime>roundEnd[round-1]);
178         } else {
179             require(newTime<roundEnd[1]);
180         }
181 
182         roundEnd[round] = newTime;
183         // If we change ICO ended time, we change also founder trading lock time
184         if (round == 3) {
185             tokenFounderLockTime = newTime + 365*24*3600;
186         }
187         return true;
188     }
189     
190     // refund ETH to non-KYCed investors
191     function refundNonKYCInvestor() onlyOwner public returns (bool success) {
192         require(!kycCompleted);
193         for(uint i = 0; i<investors.length; i++) {
194             if (!investors[i].kyced) {
195                 investors[i].sender.transfer(investors[i].amount);    
196                 investors[i].amount = 0;
197             }
198         }
199         kycCompleted = true;
200         return true;
201     }
202     
203     function setSoftCap(uint newSoftCap) onlyOwner public returns (bool success) {
204         softcap = newSoftCap;
205         return true;
206     }
207     
208     function setEthExRate(uint newExRate) onlyOwner public returns (bool success) {
209         etherExRate = newExRate;
210         return true;
211     }
212     
213     function setICOStartTime(uint newTime) onlyOwner public returns (bool success) {
214         icoStartDate = newTime;
215         return true;
216     }
217     
218     function setLockTime(uint newLockTime) onlyOwner public returns (bool success) {
219         require(now<newLockTime);
220         tokenLockTime = newLockTime;
221         return true;
222     }
223 
224     // ------------------------------------------------------------------------
225     // Total supply
226     // ------------------------------------------------------------------------
227     function totalSupply() public constant returns (uint) {
228         return _totalSupply - balances[address(0)];
229     }
230 
231     // ------------------------------------------------------------------------
232     // Get the token balance for account `tokenOwner`
233     // ------------------------------------------------------------------------
234     function balanceOf(address tokenOwner) public constant returns (uint balance) {
235         return balances[tokenOwner];
236     }
237     
238     // ------------------------------------------------------------------------
239     // Transfer the balance from token owner's account to `to` account
240     // - Owner's account must have sufficient balance to transfer
241     // - 0 value transfers are allowed
242     // ------------------------------------------------------------------------
243     function transfer(address to, uint tokens) public returns (bool success) {
244         require(icoEnded);
245         // transaction is in tradable period
246         require(now<tokenLockTime);
247         // either
248         // - is founder and current time > tokenFounderLockTime
249         // - is not founder but is rewardPoolWallet or sender was kyc-ed
250         require((founders[msg.sender] && now>tokenFounderLockTime) || (!founders[msg.sender] && (msg.sender == rewardPoolWallet || mapInvestors[msg.sender] == 0 || investors[mapInvestors[msg.sender]-1].kyced)));
251         // sender either is owner or recipient is not 0x0 address
252         require(msg.sender == owner || to != 0x0);
253         
254         balances[msg.sender] = balances[msg.sender].sub(tokens);
255         balances[to] = balances[to].add(tokens);
256         Transfer(msg.sender, to, tokens);
257         return true;
258     }
259 
260     // ------------------------------------------------------------------------
261     // Token owner can approve for `spender` to transferFrom(...) `tokens`
262     // from the token owner's account
263     //
264     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
265     // recommends that there are no checks for the approval double-spend attack
266     // as this should be implemented in user interfaces 
267     // ------------------------------------------------------------------------
268     function approve(address spender, uint tokens) public returns (bool success) {
269         allowed[msg.sender][spender] = tokens;
270         Approval(msg.sender, spender, tokens);
271         return true;
272     }
273 
274 
275     // ------------------------------------------------------------------------
276     // Transfer `tokens` from the `from` account to the `to` account
277     // 
278     // The calling account must already have sufficient tokens approve(...)-d
279     // for spending from the `from` account and
280     // - From account must have sufficient balance to transfer
281     // - Spender must have sufficient allowance to transfer
282     // - 0 value transfers are allowed
283     // ------------------------------------------------------------------------
284     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
285         require(icoEnded);
286         // either
287         // - is founder and current time > tokenFounderLockTime
288         // - is not founder but is rewardPoolWallet or sender was kyc-ed
289         require((founders[from] && now>tokenFounderLockTime) || (!founders[from] && (from == rewardPoolWallet || investors[mapInvestors[from]-1].kyced)));
290         
291         balances[from] = balances[from].sub(tokens);
292         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
293         balances[to] = balances[to].add(tokens);
294         Transfer(from, to, tokens);
295         return true;
296     }
297 
298     // ------------------------------------------------------------------------
299     // Returns the amount of tokens approved by the owner that can be
300     // transferred to the spender's account
301     // ------------------------------------------------------------------------
302     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
303         return allowed[tokenOwner][spender];
304     }
305 
306     // ------------------------------------------------------------------------
307     // Token owner can approve for `spender` to transferFrom(...) `tokens`
308     // from the token owner's account. The `spender` contract function
309     // `receiveApproval(...)` is then executed
310     // ------------------------------------------------------------------------
311     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
312         allowed[msg.sender][spender] = tokens;
313         Approval(msg.sender, spender, tokens);
314         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
315         return true;
316     }
317     
318     function processRound(uint round) internal {
319         // Token left for each round must be greater than 0
320         require(roundTokenLeft[round]>0);
321         // calculate number of tokens can be bought, given number of ether from sender, with discount rate accordingly
322         var tokenCanBeBought = (msg.value*10**uint(decimals)*etherExRate*(100+roundBonus[round])).div(100*10**18);
323         if (tokenCanBeBought<roundTokenLeft[round]) {
324             balances[owner] = balances[owner] - tokenCanBeBought;
325             balances[msg.sender] = balances[msg.sender] + tokenCanBeBought;
326             roundTokenLeft[round] = roundTokenLeft[round]-tokenCanBeBought;
327             
328             if (mapInvestors[msg.sender] > 0) {
329                 // if investors already existed, add amount to the invested sum
330                 investors[mapInvestors[msg.sender]-1].amount += msg.value;
331             } else {
332                 uint ind = investors.push(Investor(msg.sender, msg.value, false));                
333                 mapInvestors[msg.sender] = ind;
334             }
335         } else {
336             var neededEtherToBuy = (10**18*roundTokenLeft[round]*100).div(10**uint(decimals)).div(etherExRate*(100+roundBonus[round]));
337             balances[owner] = balances[owner] - roundTokenLeft[round];
338             balances[msg.sender] = balances[msg.sender] + roundTokenLeft[round];
339             roundTokenLeft[round] = 0;
340             
341             if (mapInvestors[msg.sender] > 0) {
342                 // if investors already existed, add amount to the invested sum
343                 investors[mapInvestors[msg.sender]-1].amount += neededEtherToBuy;
344             } else {
345                 uint index = investors.push(Investor(msg.sender, neededEtherToBuy, false));  
346                 mapInvestors[msg.sender] = index;
347             }
348             
349             // send back ether to sender 
350             msg.sender.transfer(msg.value-neededEtherToBuy);
351         }
352     }
353 
354     // ------------------------------------------------------------------------
355     // Accept ETH for this crowdsale
356     // ------------------------------------------------------------------------
357     function () public payable {
358         require(!icoEnded);
359         uint currentTime = now;
360         require (currentTime>icoStartDate);
361         require (msg.value>= minInvest && msg.value<=maxInvest);
362         
363         if (currentTime<roundEnd[0]) {
364             processRound(0);
365         } else if (currentTime<roundEnd[1]) {
366             processRound(1);
367         } else if (currentTime<roundEnd[2]) {
368             processRound(2);
369         } else if (currentTime<roundEnd[3]) {
370             processRound(3);
371         } else {
372             // crowdsale ends, check success conditions
373             if (this.balance<softcap) {
374                 // time to send back funds to investors
375                 for(uint i = 0; i<investors.length; i++) {
376                     investors[i].sender.transfer(investors[i].amount);
377                 }
378             } else {
379                 // send un-sold tokens to reward address
380                 require(rewardPoolWallet != address(0));
381                 uint sumToBurn = roundTokenLeft[0] + roundTokenLeft[1] + roundTokenLeft[2] + roundTokenLeft[3];
382                 balances[owner] = balances[owner] - sumToBurn;
383                 balances[rewardPoolWallet] += sumToBurn;
384                 
385                 roundTokenLeft[0] = roundTokenLeft[1] = roundTokenLeft[2] = roundTokenLeft[3] = 0;
386             }
387             
388             // give back ETH to sender
389             msg.sender.transfer(msg.value);
390             icoEnded = true;
391         }
392     }
393     
394     function withdrawEtherToOwner() onlyOwner public {   
395         require(now>roundEnd[3] && this.balance>softcap);
396         owner.transfer(this.balance);
397     }
398 
399     // ------------------------------------------------------------------------
400     // Owner can transfer out any accidentally sent ERC20 tokens
401     // ------------------------------------------------------------------------
402     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
403         return ERC20Interface(tokenAddress).transfer(owner, tokens);
404     }
405 }
406 
407 // ----------------------------------------------------------------------------
408 // Safe maths
409 // ----------------------------------------------------------------------------
410 library SafeMath {
411     function add(uint a, uint b) internal pure returns (uint c) {
412         c = a + b;
413         require(c >= a);
414     }
415     function sub(uint a, uint b) internal pure returns (uint c) {
416         require(b <= a);
417         c = a - b;
418     }
419     function mul(uint a, uint b) internal pure returns (uint c) {
420         c = a * b;
421         require(a == 0 || c / a == b);
422     }
423     function div(uint a, uint b) internal pure returns (uint c) {
424         require(b > 0);
425         c = a / b;
426     }
427 }