1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29 
30     function Ownable() {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address newOwner) onlyOwner {
40         if (newOwner != address(0)) {
41             owner = newOwner;
42         }
43     }
44 
45 }
46 
47 contract Fund is Ownable {
48     using SafeMath for uint256;
49     
50     string public name = "Slot Token";
51     uint8 public decimals = 0;
52     string public symbol = "SLOT";
53     string public version = "0.8";
54     
55     uint8 constant TOKENS = 0;
56     uint8 constant TOTALSTAKE = 1;
57     
58     uint256 totalWithdrawn;
59     uint256 public totalSupply;
60     
61     mapping(address => uint256[2][]) balances;
62     mapping(address => uint256) withdrawals;
63     
64     event Withdrawn(
65             address indexed investor, 
66             address indexed beneficiary, 
67             uint256 weiAmount);
68     event Mint(
69             address indexed to, 
70             uint256 amount);
71     event MintFinished();
72     event Transfer(
73             address indexed from, 
74             address indexed to, 
75             uint256 value);
76     event Approval(
77             address indexed owner, 
78             address indexed spender, 
79             uint256 value);
80             
81     mapping (address => mapping (address => uint256)) allowed;
82 
83     bool public mintingFinished = false;
84 
85     modifier canMint() {
86         require(!mintingFinished);
87         _;
88     }
89     
90     function Fund() payable {}
91     function() payable {}
92     
93     function getEtherBalance(address _owner) constant public returns (uint256 _balance) {
94         uint256[2][] memory snps = balances[_owner];
95         
96         if (snps.length == 0) { return 0; }
97         if (snps.length == 1) {
98             uint256 bal = snps[0][TOKENS].mul(getTotalStake()).div(totalSupply);
99             return bal.sub(withdrawals[_owner]);
100         }
101 
102         uint256 balance = 0;
103         uint256 prevSnTotalSt = 0;
104         
105         for (uint256 i = 0 ; i < snps.length-1 ; i++) {
106             uint256 snapTotalStake = snps[i][TOTALSTAKE];
107             uint256 spanBalance = snps[i][TOKENS].mul(snapTotalStake.sub(prevSnTotalSt)).div(totalSupply);
108             balance = balance.add(spanBalance);
109             prevSnTotalSt = snapTotalStake;
110         }
111         
112         uint256 b = snps[snps.length-1][TOKENS].mul(getTotalStake().sub(prevSnTotalSt)).div(totalSupply);
113         return balance.add(b).sub(withdrawals[_owner]);
114     }
115 
116     function balanceOf(address _owner) constant returns (uint256 balance) {
117         uint256[2][] memory snps = balances[_owner];
118         if (snps.length == 0) { return 0; }
119         
120         return snps[snps.length-1][TOKENS];
121     }
122     
123     function getTotalStake() constant returns (uint256 _totalStake) {
124         return this.balance + totalWithdrawn;
125     }
126     
127     function withdrawEther(address _to, uint256 _value) public {
128         require(getEtherBalance(msg.sender) >= _value);
129         withdrawals[msg.sender] = withdrawals[msg.sender].add(_value);
130         totalWithdrawn = totalWithdrawn.add(_value);
131         _to.transfer(_value);
132         Withdrawn(msg.sender, _to, _value);
133     }
134     
135     function transfer(address _to, uint256 _value) returns (bool) {
136         return transferFromPrivate(msg.sender, _to, _value);
137     }
138     
139     function transferFromPrivate(address _from, address _to, uint256 _value) private returns (bool) {
140         require(balanceOf(msg.sender) >= _value);
141         uint256 fromTokens = balanceOf(msg.sender);
142         pushSnp(msg.sender, fromTokens-_value);
143         uint256 toTokens = balanceOf(_to);
144         pushSnp(_to, toTokens+_value);
145         Transfer(_from, _to, _value);
146         return true;
147     }
148     
149     function pushSnp(address _beneficiary, uint256 _amount) private {
150         if (balances[_beneficiary].length > 0) {
151             uint256 length = balances[_beneficiary].length;
152             assert(balances[_beneficiary][length-1][TOTALSTAKE] == 0);
153             balances[_beneficiary][length-1][TOTALSTAKE] = getTotalStake();
154         }
155         balances[_beneficiary].push([_amount, 0]);
156     }
157 
158     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
159         pushSnp(_to, _amount.add(balanceOf(_to)));
160         totalSupply = totalSupply.add(_amount);
161         Mint(_to, _amount);
162         Transfer(0x0, _to, _amount);
163         return true;
164     }
165     
166 
167     function finishMinting() onlyOwner returns (bool) {
168         mintingFinished = true;
169         MintFinished();
170         return true;
171     }
172     
173     
174     function approve(address _spender, uint256 _value) returns (bool) {
175         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
176         allowed[msg.sender][_spender] = _value;
177         Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
182         return allowed[_owner][_spender];
183     }
184     
185     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
186         uint256 _allowance = allowed[_from][msg.sender];
187         transferFromPrivate(_from, _to, _value);
188         allowed[_from][msg.sender] = _allowance.sub(_value);
189         return true;
190     }
191     
192 }
193 contract Pausable is Ownable {
194   event Pause();
195   event Unpause();
196 
197   bool public paused = false;
198 
199   modifier whenNotPaused() {
200     require(!paused);
201     _;
202   }
203   
204   modifier whenPaused {
205     require(paused);
206     _;
207   }
208 
209   function pause() onlyOwner whenNotPaused returns (bool) {
210     paused = true;
211     Pause();
212     return true;
213   }
214 
215   function unpause() onlyOwner whenPaused returns (bool) {
216     paused = false;
217     Unpause();
218     return true;
219   }
220 }
221 
222 contract SlotCrowdsale is Ownable, Pausable {
223     using SafeMath for uint256;
224 
225     uint256 constant PRICE        =    1 ether;
226     uint256 constant TOKEN_CAP    =   10000000;
227     uint256 constant BOUNTY       =     250000;
228     uint256 constant OWNERS_STAKE =    3750000;
229     uint256 constant OWNERS_LOCK  =     200000;
230     
231     address public bountyWallet;
232     address public ownersWallet;
233     uint256 public lockBegunAtBlock;
234     bool public bountyDistributed = false;
235     bool public ownershipDistributed = false;
236     
237     Fund public fund;
238     
239     uint256[10] outcomes = [1000000,
240                              250000,
241                              100000,
242                               20000,
243                               10000,
244                                4000,
245                                2000,
246                                1250,
247                                1000,
248                                 500];
249 
250     uint16[10] outcomesChances = [1, 4, 10, 50, 100, 250, 500,  800, 1000, 2000];
251     uint16[10] addedUpChances =  [1, 5, 15, 65, 165, 415, 915, 1715, 2715, 4715];
252     
253     event OwnershipDistributed();
254     event BountyDistributed();
255 
256     function SlotCrowdsale() public payable {
257         fund = new Fund();
258         bountyWallet = 0x00deF93928A3aAD581F39049a3BbCaaB9BbE36C8;
259         ownersWallet = 0x0001619153d8FE15B3FA70605859265cb0033c1a;
260     }
261 
262     function() public payable {
263         buyTokenFor(msg.sender);
264     }
265 
266     function buyTokenFor(address _beneficiary) public whenNotPaused() payable {
267         require(_beneficiary != 0x0);
268         require(msg.value >= PRICE);
269         
270         uint256 change = msg.value%PRICE;
271         uint256 value = msg.value.sub(change);
272 
273         msg.sender.transfer(change);
274         ownersWallet.transfer(value);
275         fund.mint(_beneficiary, getAmount(value.div(PRICE)));
276     }
277     
278     function correctedIndex(uint8 _index, uint8 i) private constant returns (uint8) {
279         require(i < outcomesChances.length);        
280         if (outcomesChances[_index] > 0) {
281             return uint8((_index + i)%outcomesChances.length);
282         } else {
283             return correctedIndex(_index, i+1);
284         }
285     }
286     
287     function getIndex(uint256 _randomNumber) private returns (uint8) {
288         for (uint8 i = 0 ; i < uint8(outcomesChances.length) ; i++) {
289             if (_randomNumber < addedUpChances[i]) {
290                 uint8 index = correctedIndex(i, 0);
291                 assert(outcomesChances[index] != 0);
292                 outcomesChances[index]--;
293                 return index; 
294             } else { 
295                 continue; 
296             }
297         }
298     }
299 
300     function getAmount(uint256 _numberOfTries) private returns (uint256) {
301         uint16 totalChances = addedUpChances[addedUpChances.length-1];
302         uint256 amount = 0;
303 
304         for (uint16 i = 0 ; i < _numberOfTries; i++) {
305             uint256 rand = uint256(keccak256(block.blockhash(block.number-1),i)) % totalChances;
306             amount = amount.add(outcomes[getIndex(rand)]);
307         }
308         
309         return amount;
310     }
311     
312     function crowdsaleEnded() constant private returns (bool) {
313         if (fund.totalSupply() >= TOKEN_CAP) { 
314             return true;
315         } else {
316             return false; 
317         }
318     }
319     
320     function lockEnded() constant private returns (bool) {
321         if (block.number.sub(lockBegunAtBlock) > OWNERS_LOCK) {
322             return true; 
323         } else {
324             return false;
325         }
326         
327     }
328         
329     function distributeBounty() public onlyOwner {
330         require(!bountyDistributed);
331         require(crowdsaleEnded());
332         
333         fund.mint(bountyWallet, BOUNTY);
334         
335         bountyDistributed = true;
336         lockBegunAtBlock = block.number;
337         
338         BountyDistributed();
339     }
340     
341     function distributeOwnership() public onlyOwner {
342         require(!ownershipDistributed);
343         require(crowdsaleEnded());
344         require(lockEnded());
345         
346         fund.mint(ownersWallet, OWNERS_STAKE);
347         ownershipDistributed = true;
348         
349         OwnershipDistributed();
350     }
351     
352     function changeOwnersWallet(address _newWallet) public onlyOwner {
353         require(_newWallet != 0x0);
354         ownersWallet = _newWallet;
355     }
356     
357     function changeBountyWallet(address _newWallet) public onlyOwner {
358         require(_newWallet != 0x0);
359         bountyWallet = _newWallet;
360     }
361     
362     function changeFundOwner(address _newOwner) public onlyOwner {
363         require(_newOwner != 0x0);
364         fund.transferOwnership(_newOwner);
365     }
366 
367     function changeFund(address _newFund) public onlyOwner {
368         require(_newFund != 0x0);
369         fund = Fund(_newFund);
370     }
371 
372     function destroy() public onlyOwner {
373         selfdestruct(msg.sender);
374     }
375 
376 }