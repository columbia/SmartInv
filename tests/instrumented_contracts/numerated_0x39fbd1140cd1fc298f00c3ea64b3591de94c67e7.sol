1 pragma solidity ^0.4.19;
2 
3 //ERC20 Token
4 contract Token {
5   function totalSupply() public constant returns (uint);
6   function balanceOf(address _owner) public constant returns (uint);
7   function transfer(address _to, uint _value) public returns (bool);
8   function transferFrom(address _from, address _to, uint _value) public returns (bool);
9   function approve(address _spender, uint _value) public returns (bool);
10   function allowance(address _owner, address _spender) public constant returns (uint);
11   event Transfer(address indexed _from, address indexed _to, uint _value);
12   event Approval(address indexed _owner, address indexed _spender, uint _value);
13 }
14 
15 contract SafeMath {
16   function safeMul(uint a, uint b) internal pure returns (uint256) {
17     uint c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function safeDiv(uint a, uint b) internal pure returns (uint256) {
23     uint c = a / b;
24     return c;
25   }
26 
27   function safeSub(uint a, uint b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function safeAdd(uint a, uint b) internal pure returns (uint256) {
33     uint c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract BitEyeExchange is SafeMath {
40   mapping (address => mapping (address => uint256)) public balances;
41   mapping (bytes32 => bool) public traded;
42   mapping (bytes32 => uint256) public orderFills;
43   address public owner;
44   address public feeAccount;
45   mapping (address => bool) public signers;
46   mapping (address => uint256) public cancels;
47   mapping (bytes32 => bool) public withdraws;
48 
49   uint256 public teamLocked = 300000000 * 1e18;
50   uint256 public teamClaimed = 0;
51   uint256 public totalForMining = 600000000 * 1e18;
52   uint256 public unmined = 600000000 * 1e18;
53   mapping (address => uint256) public mined;
54   address public BEY;
55   mapping (address => uint256) public miningRate;
56   bool public paused = false;
57   
58   event Deposit(address token, address user, uint256 amount, uint256 balance);
59   event Withdraw(address token, address user, uint256 amount, uint256 balance);
60   event Trade(address baseToken, address quoteToken, uint256 volume, uint256 fund, uint256 nonce, address buyer, address seller);
61   event Cancel(address user, bytes32 orderHash, uint256 nonce);
62   event Claim(address user, uint256 amount);
63 
64   function BitEyeExchange(address _feeAccount) public {
65     owner = msg.sender;
66     feeAccount = _feeAccount;
67   }
68 
69   function transferOwnership(address _newOwner) public onlyOwner {
70     if (_newOwner != address(0)) {
71       owner = _newOwner;
72     }
73   }
74 
75   function setFeeAccount(address _newFeeAccount) public onlyOwner {
76     feeAccount = _newFeeAccount;
77   }
78 
79   function addSigner(address _signer) public onlyOwner {
80     signers[_signer] = true;
81   }
82 
83   function removeSigner(address _signer) public onlyOwner {
84     signers[_signer] = false;
85   }
86 
87   function setBEY(address _addr) public onlyOwner {
88     BEY = _addr;
89   }
90 
91   function setMiningRate(address _quoteToken, uint256 _rate) public onlyOwner {
92     miningRate[_quoteToken] = _rate;
93   }
94 
95   function setPaused(bool _paused) public onlyOwner {
96     paused = _paused;
97   }
98 
99   modifier onlyOwner() {
100     require(msg.sender == owner);
101     _;
102   }
103 
104   modifier onlySigner() {
105     require(signers[msg.sender]);
106     _; 
107   }
108 
109   modifier onlyNotPaused() {
110     require(!paused);
111     _;
112   }
113 
114   function() external {
115     revert();
116   }
117 
118   function depositToken(address token, uint amount) public {
119     balances[token][msg.sender] = safeAdd(balances[token][msg.sender], amount);
120     require(Token(token).transferFrom(msg.sender, this, amount));
121     Deposit(token, msg.sender, amount, balances[token][msg.sender]);
122   }
123 
124   function deposit() public payable {
125     balances[address(0)][msg.sender] = safeAdd(balances[address(0)][msg.sender], msg.value);
126     Deposit(address(0), msg.sender, msg.value, balances[address(0)][msg.sender]);
127   }
128 
129   function withdraw(address token, uint amount, uint nonce, address _signer, uint8 v, bytes32 r, bytes32 s) public {
130     require(balances[token][msg.sender] >= amount);
131     require(signers[_signer]);
132     bytes32 hash = keccak256(this, msg.sender, token, amount, nonce);
133     require(isValidSignature(_signer, hash, v, r, s));
134     require(!withdraws[hash]);
135     withdraws[hash] = true;
136 
137     balances[token][msg.sender] = safeSub(balances[token][msg.sender], amount);
138     if (token == address(0)) {
139       require(msg.sender.send(amount));
140     } else {
141       require(Token(token).transfer(msg.sender, amount));
142     }
143     Withdraw(token, msg.sender, amount, balances[token][msg.sender]);
144   }
145 
146   function balanceOf(address token, address user) public view returns(uint) {
147     return balances[token][user];
148   }
149 
150   function updateCancels(address user, uint256 nonce) public onlySigner {
151     require(nonce > cancels[user]);
152     cancels[user] = nonce;
153   }
154 
155   function getMiningRate(address _quoteToken) public view returns(uint256) {
156     uint256 initialRate = miningRate[_quoteToken];
157     if (unmined > 500000000e18){
158       return initialRate;
159     } else if (unmined > 400000000e18 && unmined <= 500000000e18){
160       return initialRate * 9e17 / 1e18;
161     } else if (unmined > 300000000e18 && unmined <= 400000000e18){
162       return initialRate * 8e17 / 1e18;
163     } else if (unmined > 200000000e18 && unmined <= 300000000e18){
164       return initialRate * 7e17 / 1e18;
165     } else if (unmined > 100000000e18 && unmined <= 200000000e18){
166       return initialRate * 6e17 / 1e18;
167     } else if(unmined <= 100000000e18) {
168       return initialRate * 5e17 / 1e18;
169     }
170   }
171 
172   function trade(
173       address[5] addrs,
174       uint[11] vals,
175       uint8[3] v,
176       bytes32[6] rs
177     ) public onlyNotPaused
178     returns (bool)
179 
180     // addrs:
181     // addrs[0] baseToken
182     // addrs[1] quoteToken
183     // addrs[2] buyer
184     // addrs[3] seller
185     // addrs[4] signer
186 
187     // vals:
188     // vals[0] buyVolume
189     // vals[1] buyFund
190     // vals[2] buyNonce
191 
192     // vals[3] sellVolume
193     // vals[4] sellFund
194     // vals[5] sellNonce
195 
196     // vals[6] tradeVolume
197     // vals[7] tradeFund
198     // vals[8] tradeNonce
199 
200     // vals[9] buyerFee
201     // vals[10] sellerFee
202 
203     // v:
204     // v[0] buyV
205     // v[1] sellV
206     // v[2] tradeV
207 
208     // rs:
209     // rs[0] buyR
210     // rs[1] buyS
211     // rs[2] sellR
212     // rs[3] sellS
213     // rs[4] tradeR
214     // rs[5] tradeS
215   {
216     require(signers[addrs[4]]);
217     require(cancels[addrs[2]] < vals[2]);
218     require(cancels[addrs[3]] < vals[5]);
219 
220     require(vals[6] > 0 && vals[7] > 0 && vals[8] > 0);
221     require(vals[1] >= vals[7] && vals[4] >= vals[7]);
222     require(msg.sender == addrs[2] || msg.sender == addrs[3] || msg.sender == addrs[4]);
223 
224     bytes32 buyHash = keccak256(address(this), addrs[0], addrs[1], addrs[2], vals[0], vals[1], vals[2]);
225     bytes32 sellHash = keccak256(address(this), addrs[0], addrs[1], addrs[3], vals[3], vals[4], vals[5]);
226 
227     require(isValidSignature(addrs[2], buyHash, v[0], rs[0], rs[1]));
228     require(isValidSignature(addrs[3], sellHash, v[1], rs[2], rs[3]));
229 
230     bytes32 tradeHash = keccak256(this, buyHash, sellHash, addrs[4], vals[6], vals[7], vals[8], vals[9], vals[10]);
231     require(isValidSignature(addrs[4], tradeHash, v[2], rs[4], rs[5]));
232     
233     require(!traded[tradeHash]);
234     traded[tradeHash] = true;
235     
236     require(safeAdd(orderFills[buyHash], vals[6]) <= vals[0]);
237     require(safeAdd(orderFills[sellHash], vals[6]) <= vals[3]);
238 
239     // balances[quoteToken][buyer] > tradeFund
240     require(balances[addrs[1]][addrs[2]] >= vals[7]);
241 
242     // balances[quoteToken][buyer] -= tradeFund
243     balances[addrs[1]][addrs[2]] = safeSub(balances[addrs[1]][addrs[2]], vals[7]);
244 
245     // balances[baseToken][seller] > tradeVolume
246     require(balances[addrs[0]][addrs[3]] >= vals[6]);
247 
248     // balances[baseToken][seller] -= tradeVolume
249     balances[addrs[0]][addrs[3]] = safeSub(balances[addrs[0]][addrs[3]], vals[6]);
250 
251     // balances[baseToken][buyer] += tradeVolume - tradeVolume * buyFee
252     balances[addrs[0]][addrs[2]] = safeAdd(balances[addrs[0]][addrs[2]], safeSub(vals[6], (safeMul(vals[6], vals[9]) / 1 ether)));
253 
254     // balances[quoteToken][seller] += tradeFund - tradeFund * sellFee
255     balances[addrs[1]][addrs[3]] = safeAdd(balances[addrs[1]][addrs[3]], safeSub(vals[7], (safeMul(vals[7], vals[10]) / 1 ether)));
256     
257     balances[addrs[0]][feeAccount] = safeAdd(balances[addrs[0]][feeAccount], safeMul(vals[6], vals[9]) / 1 ether);
258     balances[addrs[1]][feeAccount] = safeAdd(balances[addrs[1]][feeAccount], safeMul(vals[7], vals[10]) / 1 ether);
259 
260     orderFills[buyHash] = safeAdd(orderFills[buyHash], vals[6]);
261     orderFills[sellHash] = safeAdd(orderFills[sellHash], vals[6]);
262 
263     Trade(addrs[0], addrs[1], vals[6], vals[7], vals[8], addrs[2], addrs[3]);
264 
265     // Reward BEYs to buyer and seller
266     if(unmined > 0) {
267       if(miningRate[addrs[1]] > 0){
268         uint256 minedBEY = safeMul(safeMul(vals[7], getMiningRate(addrs[1])), 2) / (1 ether);
269         if(unmined > minedBEY) {
270           mined[addrs[2]] = safeAdd(mined[addrs[2]], safeSub(minedBEY, minedBEY / 2));
271           mined[addrs[3]] = safeAdd(mined[addrs[3]], minedBEY / 2);
272           unmined = safeSub(unmined, minedBEY);
273         } else {
274           mined[addrs[2]] = safeAdd(mined[addrs[2]], safeSub(unmined, unmined / 2));
275           mined[addrs[3]] = safeAdd(mined[addrs[3]], unmined / 2);
276           unmined = 0;
277         }
278       }
279     }
280 
281     return true;
282   }
283 
284   function claim() public returns(bool) {
285     require(mined[msg.sender] > 0);
286     require(BEY != address(0));
287     uint256 amount = mined[msg.sender];
288     mined[msg.sender] = 0;
289     require(Token(BEY).transfer(msg.sender, amount));
290     Claim(msg.sender, amount);
291     return true;
292   }
293 
294   function claimByTeam() public onlyOwner returns(bool) {
295     uint256 totalMined = safeSub(totalForMining, unmined);
296     require(totalMined > 0);
297     uint256 released = safeMul(teamLocked, totalMined) / totalForMining;
298     uint256 amount = safeSub(released, teamClaimed);
299     require(amount > 0);
300     teamClaimed = released;
301     require(Token(BEY).transfer(msg.sender, amount));
302     Claim(msg.sender, amount);
303     return true;
304   }
305 
306   function cancel(
307     address baseToken, 
308     address quoteToken, 
309     address user,
310     uint volume,
311     uint fund,
312     uint nonce,
313     uint8 v,
314     bytes32 r,
315     bytes32 s) public onlySigner returns(bool)
316   {
317 
318     bytes32 hash = keccak256(this, baseToken, quoteToken, user, volume, fund, nonce);
319     require(isValidSignature(user, hash, v, r, s));
320     orderFills[hash] = volume;
321     Cancel(user, hash, nonce);
322     return true;
323   }
324   
325   function isValidSignature(
326         address signer,
327         bytes32 hash,
328         uint8 v,
329         bytes32 r,
330         bytes32 s)
331         public
332         pure
333         returns (bool)
334   {
335     return signer == ecrecover(
336       keccak256("\x19Ethereum Signed Message:\n32", hash),
337       v,
338       r,
339       s
340     );
341   }
342 }