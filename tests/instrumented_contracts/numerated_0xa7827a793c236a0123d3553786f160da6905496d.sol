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
42     string public version = "1.10";
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
56     event TranferETH(address indexed _to, uint amount);
57 
58     function Owned() public {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66     
67     // Give KYC status, so token can be traded by this wallet
68     function changeKYCStatus(address inv, bool kycStatus) onlyOwner public returns (bool success) {
69         require(kycStatus == !investors[mapInvestors[inv]-1].kyced);
70         investors[mapInvestors[inv]-1].kyced = kycStatus;
71         return true;
72     }
73     
74     function setRewardPoolWallet(address rewardWallet) onlyOwner public returns(bool success) {
75         rewardPoolWallet = rewardWallet;
76         return true;
77     }
78     
79     function isExistInvestor(address inv) public constant returns (bool exist) {
80         return mapInvestors[inv] != 0;
81     }
82     
83     function isExistFounder(address _founder) public constant returns (bool exist) {
84         return founders[_founder];
85     }
86     
87     function removeFounder(address _founder) onlyOwner public returns (bool success) {
88         require(founders[_founder]);
89         founders[_founder] = false;
90         return true;
91     }
92     
93     function addFounder(address _founder) onlyOwner public returns (bool success) {
94         require(!founders[_founder]);
95         founders[_founder] = true;
96         return true;
97     }
98 
99     function transferOwnership(address _newOwner) public onlyOwner {
100         newOwner = _newOwner;
101     }
102     
103     function acceptOwnership() public {
104         require(msg.sender == newOwner);
105         OwnershipTransferred(owner, newOwner);
106         owner = newOwner;
107         newOwner = address(0);
108     }
109 }
110 
111 // ----------------------------------------------------------------------------
112 // ERC20 Token, with the addition of symbol, name and decimals and an
113 // initial fixed supply
114 // ----------------------------------------------------------------------------
115 contract ELOVEToken is ERC20Interface, Owned {
116     using SafeMath for uint;
117 
118     string public symbol;
119     string public name;
120     uint8 public decimals;
121     uint public _totalSupply;
122     
123     uint minInvest = 0.5 ether;
124     uint maxInvest = 500 ether;
125     
126     uint softcap = 5000 ether;
127     uint hardcap = 40000 ether;
128 
129     uint public icoStartDate;
130     
131     uint[4] public roundEnd;
132     uint[4] public roundTokenLeft;
133     uint[4] public roundBonus;
134     
135     uint public tokenLockTime;
136     uint public tokenFounderLockTime;
137     bool icoEnded = false;
138     bool kycCompleted = false;
139     
140     mapping(address => uint) balances;
141     mapping(address => mapping(address => uint)) allowed;
142 
143     uint etherExRate = 2000;
144 
145     // ------------------------------------------------------------------------
146     // Constructor
147     // ------------------------------------------------------------------------
148     function ELOVEToken(string tName, string tSymbol) public {
149         symbol = tSymbol;
150         name = tName;
151         decimals = 2;
152         _totalSupply = 200000000 * 10**uint(decimals); // 200.000.000 tokens
153         
154         icoStartDate            = 1518566401;   // 2018/02/14 00:00:01 AM
155         
156         // Ending time for each round
157         // pre-ICO round 1 : ends 28/02/2018, 10M tokens limit, 40% bonus
158         // pre-ICO round 2 : ends 15/03/2018, 10M tokens limit, 30% bonus
159         // crowdsale round 1 : ends 15/04/2018, 30M tokens limit, 10% bonus
160         // crowdsale round 2 : ends 30/04/2018, 30M tokens limit, 0% bonus
161         roundEnd = [1519862400, 1521158400, 1523836800, 1525132800];
162         roundTokenLeft = [1000000000, 1000000000, 3000000000, 3000000000];
163         roundBonus = [40, 30, 10, 0];
164         
165         // Founder can trade tokens 1 year after ICO ended
166         tokenFounderLockTime = roundEnd[3] + 365*24*3600;
167         
168         // Time to lock all ERC20 transfer 
169         tokenLockTime = 1572566400;     // 2019/11/01 after 18 months
170         
171         balances[owner] = _totalSupply;
172         Transfer(address(0), owner, _totalSupply);
173     }
174 
175     function setRoundEnd(uint round, uint newTime) onlyOwner public returns (bool success)  {
176         require(now<newTime);
177         if (round>0) {
178             require(newTime>roundEnd[round-1]);
179         } else {
180             require(newTime<roundEnd[1]);
181         }
182 
183         roundEnd[round] = newTime;
184         // If we change ICO ended time, we change also founder trading lock time
185         if (round == 3) {
186             tokenFounderLockTime = newTime + 365*24*3600;
187         }
188         return true;
189     }
190     
191     // refund ETH to non-KYCed investors
192     function refundNonKYCInvestor() onlyOwner public returns (bool success) {
193         require(!kycCompleted);
194         for(uint i = 0; i<investors.length; i++) {
195             if (!investors[i].kyced) {
196                 investors[i].sender.transfer(investors[i].amount);    
197                 investors[i].amount = 0;
198             }
199         }
200         kycCompleted = true;
201         return true;
202     }
203     
204     function setSoftCap(uint newSoftCap) onlyOwner public returns (bool success) {
205         softcap = newSoftCap;
206         return true;
207     }
208     
209     function setEthExRate(uint newExRate) onlyOwner public returns (bool success) {
210         etherExRate = newExRate;
211         return true;
212     }
213     
214     function setICOStartTime(uint newTime) onlyOwner public returns (bool success) {
215         icoStartDate = newTime;
216         return true;
217     }
218     
219     function setLockTime(uint newLockTime) onlyOwner public returns (bool success) {
220         require(now<newLockTime);
221         tokenLockTime = newLockTime;
222         return true;
223     }
224 
225     // ------------------------------------------------------------------------
226     // Total supply
227     // ------------------------------------------------------------------------
228     function totalSupply() public constant returns (uint) {
229         return _totalSupply - balances[address(0)];
230     }
231 
232     // ------------------------------------------------------------------------
233     // Get the token balance for account `tokenOwner`
234     // ------------------------------------------------------------------------
235     function balanceOf(address tokenOwner) public constant returns (uint balance) {
236         return balances[tokenOwner];
237     }
238     
239     // ------------------------------------------------------------------------
240     // Transfer the balance from token owner's account to `to` account
241     // - Owner's account must have sufficient balance to transfer
242     // - 0 value transfers are allowed
243     // ------------------------------------------------------------------------
244     function transfer(address to, uint tokens) public returns (bool success) {
245         require(icoEnded);
246         // transaction is in tradable period
247         require(now<tokenLockTime);
248         // either
249         // - is founder and current time > tokenFounderLockTime
250         // - is not founder but is rewardPoolWallet or sender was kyc-ed
251         require((founders[msg.sender] && now>tokenFounderLockTime) || (!founders[msg.sender] && (msg.sender == rewardPoolWallet || mapInvestors[msg.sender] == 0 || investors[mapInvestors[msg.sender]-1].kyced)));
252         // sender either is owner or recipient is not 0x0 address
253         require(msg.sender == owner || to != 0x0);
254         
255         balances[msg.sender] = balances[msg.sender].sub(tokens);
256         balances[to] = balances[to].add(tokens);
257         Transfer(msg.sender, to, tokens);
258         return true;
259     }
260 
261     // ------------------------------------------------------------------------
262     // Token owner can approve for `spender` to transferFrom(...) `tokens`
263     // from the token owner's account
264     //
265     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
266     // recommends that there are no checks for the approval double-spend attack
267     // as this should be implemented in user interfaces 
268     // ------------------------------------------------------------------------
269     function approve(address spender, uint tokens) public returns (bool success) {
270         allowed[msg.sender][spender] = tokens;
271         Approval(msg.sender, spender, tokens);
272         return true;
273     }
274 
275 
276     // ------------------------------------------------------------------------
277     // Transfer `tokens` from the `from` account to the `to` account
278     // 
279     // The calling account must already have sufficient tokens approve(...)-d
280     // for spending from the `from` account and
281     // - From account must have sufficient balance to transfer
282     // - Spender must have sufficient allowance to transfer
283     // - 0 value transfers are allowed
284     // ------------------------------------------------------------------------
285     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
286         require(icoEnded);
287         // either
288         // - is founder and current time > tokenFounderLockTime
289         // - is not founder but is rewardPoolWallet or sender was kyc-ed
290         require((founders[from] && now>tokenFounderLockTime) || (!founders[from] && (from == rewardPoolWallet || investors[mapInvestors[from]-1].kyced)));
291         
292         balances[from] = balances[from].sub(tokens);
293         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
294         balances[to] = balances[to].add(tokens);
295         Transfer(from, to, tokens);
296         return true;
297     }
298 
299     // ------------------------------------------------------------------------
300     // Returns the amount of tokens approved by the owner that can be
301     // transferred to the spender's account
302     // ------------------------------------------------------------------------
303     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
304         return allowed[tokenOwner][spender];
305     }
306 
307     // ------------------------------------------------------------------------
308     // Token owner can approve for `spender` to transferFrom(...) `tokens`
309     // from the token owner's account. The `spender` contract function
310     // `receiveApproval(...)` is then executed
311     // ------------------------------------------------------------------------
312     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
313         allowed[msg.sender][spender] = tokens;
314         Approval(msg.sender, spender, tokens);
315         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
316         return true;
317     }
318     
319     function processRound(uint round) internal {
320         // Token left for each round must be greater than 0
321         require(roundTokenLeft[round]>0);
322         // calculate number of tokens can be bought, given number of ether from sender, with discount rate accordingly
323         var tokenCanBeBought = (msg.value*10**uint(decimals)*etherExRate*(100+roundBonus[round])).div(100*10**18);
324         if (tokenCanBeBought<roundTokenLeft[round]) {
325             balances[owner] = balances[owner] - tokenCanBeBought;
326             balances[msg.sender] = balances[msg.sender] + tokenCanBeBought;
327             roundTokenLeft[round] = roundTokenLeft[round]-tokenCanBeBought;
328             
329             Transfer(owner, msg.sender, tokenCanBeBought);
330             
331             if (mapInvestors[msg.sender] > 0) {
332                 // if investors already existed, add amount to the invested sum
333                 investors[mapInvestors[msg.sender]-1].amount += msg.value;
334             } else {
335                 uint ind = investors.push(Investor(msg.sender, msg.value, false));                
336                 mapInvestors[msg.sender] = ind;
337             }
338         } else {
339             var neededEtherToBuy = (10**18*roundTokenLeft[round]*100).div(10**uint(decimals)).div(etherExRate*(100+roundBonus[round]));
340             balances[owner] = balances[owner] - roundTokenLeft[round];
341             balances[msg.sender] = balances[msg.sender] + roundTokenLeft[round];
342             roundTokenLeft[round] = 0;
343             
344             Transfer(owner, msg.sender, roundTokenLeft[round]);
345             
346             if (mapInvestors[msg.sender] > 0) {
347                 // if investors already existed, add amount to the invested sum
348                 investors[mapInvestors[msg.sender]-1].amount += neededEtherToBuy;
349             } else {
350                 uint index = investors.push(Investor(msg.sender, neededEtherToBuy, false));  
351                 mapInvestors[msg.sender] = index;
352             }
353             
354             // send back ether to sender 
355             msg.sender.transfer(msg.value-neededEtherToBuy);
356         }
357     }
358 
359     // ------------------------------------------------------------------------
360     // Accept ETH for this crowdsale
361     // ------------------------------------------------------------------------
362     function () public payable {
363         require(!icoEnded);
364         uint currentTime = now;
365         require (currentTime>icoStartDate);
366         require (msg.value>= minInvest && msg.value<=maxInvest);
367         
368         if (currentTime<roundEnd[0]) {
369             processRound(0);
370         } else if (currentTime<roundEnd[1]) {
371             processRound(1);
372         } else if (currentTime<roundEnd[2]) {
373             processRound(2);
374         } else if (currentTime<roundEnd[3]) {
375             processRound(3);
376         } else {
377             // crowdsale ends, check success conditions
378             if (this.balance<softcap) {
379                 // time to send back funds to investors
380                 for(uint i = 0; i<investors.length; i++) {
381                     investors[i].sender.transfer(investors[i].amount);
382                     TranferETH(investors[i].sender, investors[i].amount);
383                 }
384             } else {
385                 // send un-sold tokens to reward address
386                 require(rewardPoolWallet != address(0));
387                 uint sumToBurn = roundTokenLeft[0] + roundTokenLeft[1] + roundTokenLeft[2] + roundTokenLeft[3];
388                 balances[owner] = balances[owner] - sumToBurn;
389                 balances[rewardPoolWallet] += sumToBurn;
390                 
391                 Transfer(owner, rewardPoolWallet, sumToBurn);
392                 
393                 roundTokenLeft[0] = roundTokenLeft[1] = roundTokenLeft[2] = roundTokenLeft[3] = 0;
394             }
395             
396             // give back ETH to sender
397             msg.sender.transfer(msg.value);
398             TranferETH(msg.sender, msg.value);
399             icoEnded = true;
400         }
401     }
402     
403     function withdrawEtherToOwner() onlyOwner public {   
404         require(now>roundEnd[3] && this.balance>softcap);
405         owner.transfer(this.balance);
406         TranferETH(owner, this.balance);
407     }
408 
409     // ------------------------------------------------------------------------
410     // Owner can transfer out any accidentally sent ERC20 tokens
411     // ------------------------------------------------------------------------
412     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
413         return ERC20Interface(tokenAddress).transfer(owner, tokens);
414     }
415 }
416 
417 // ----------------------------------------------------------------------------
418 // Safe maths
419 // ----------------------------------------------------------------------------
420 library SafeMath {
421     function add(uint a, uint b) internal pure returns (uint c) {
422         c = a + b;
423         require(c >= a);
424     }
425     function sub(uint a, uint b) internal pure returns (uint c) {
426         require(b <= a);
427         c = a - b;
428     }
429     function mul(uint a, uint b) internal pure returns (uint c) {
430         c = a * b;
431         require(a == 0 || c / a == b);
432     }
433     function div(uint a, uint b) internal pure returns (uint c) {
434         require(b > 0);
435         c = a / b;
436     }
437 }