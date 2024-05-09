1 pragma solidity ^0.4.19;
2 
3 //ERC20 Token
4 contract Token {
5   function totalSupply() constant returns (uint) {}
6   function balanceOf(address _owner) constant returns (uint) {}
7   function transfer(address _to, uint _value) returns (bool) {}
8   function transferFrom(address _from, address _to, uint _value) returns (bool) {}
9   function approve(address _spender, uint _value) returns (bool) {}
10   function allowance(address _owner, address _spender) constant returns (uint) {}
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
39 contract BitEyeEx is SafeMath {
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
58 
59   event Deposit(address token, address user, uint256 amount, uint256 balance);
60   event Withdraw(address token, address user, uint256 amount, uint256 balance);
61   event Cancel(address user, bytes32 orderHash, uint256 nonce);
62   event Mine(address user, uint256 amount);
63   event Release(address user, uint256 amount);
64 
65   function BitEyeEx(address _feeAccount) public {
66     owner = msg.sender;
67     feeAccount = _feeAccount;
68   }
69 
70   function transferOwnership(address _newOwner) public onlyOwner {
71     if (_newOwner != address(0)) {
72       owner = _newOwner;
73     }
74   }
75 
76   function setFeeAccount(address _newFeeAccount) public onlyOwner {
77     feeAccount = _newFeeAccount;
78   }
79 
80   function addSigner(address _signer) public onlyOwner {
81     signers[_signer] = true;
82   }
83 
84   function removeSigner(address _signer) public onlyOwner {
85     signers[_signer] = false;
86   }
87 
88   function setBEY(address _addr) public onlyOwner {
89     BEY = _addr;
90   }
91 
92   function setMiningRate(address _quoteToken, uint256 _rate) public onlyOwner {
93     miningRate[_quoteToken] = _rate;
94   }
95 
96   function setPaused(bool _paused) public onlyOwner {
97     paused = _paused;
98   }
99 
100   modifier onlyOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104 
105   modifier onlySigner() {
106     require(signers[msg.sender]);
107     _; 
108   }
109 
110   modifier onlyNotPaused() {
111     require(!paused);
112     _;
113   }
114 
115   function() external {
116     revert();
117   }
118 
119   function depositToken(address token, uint amount) public {
120     balances[token][msg.sender] = safeAdd(balances[token][msg.sender], amount);
121     require(Token(token).transferFrom(msg.sender, this, amount));
122     Deposit(token, msg.sender, amount, balances[token][msg.sender]);
123   }
124 
125   function deposit() public payable {
126     balances[address(0)][msg.sender] = safeAdd(balances[address(0)][msg.sender], msg.value);
127     Deposit(address(0), msg.sender, msg.value, balances[address(0)][msg.sender]);
128   }
129 
130   function withdraw(address token, uint amount, uint nonce, address _signer, uint8 v, bytes32 r, bytes32 s) public {
131     require(balances[token][msg.sender] >= amount);
132     require(signers[_signer]);
133     bytes32 hash = keccak256(this, msg.sender, token, amount, nonce);
134     require(isValidSignature(_signer, hash, v, r, s));
135     require(!withdraws[hash]);
136     withdraws[hash] = true;
137 
138     balances[token][msg.sender] = safeSub(balances[token][msg.sender], amount);
139     if (token == address(0)) {
140       require(msg.sender.send(amount));
141     } else {
142       require(Token(token).transfer(msg.sender, amount));
143     }
144     Withdraw(token, msg.sender, amount, balances[token][msg.sender]);
145   }
146 
147   function balanceOf(address token, address user) public view returns(uint) {
148     return balances[token][user];
149   }
150 
151   function updateCancels(address user, uint256 nonce) public onlySigner {
152     require(nonce > cancels[user]);
153     cancels[user] = nonce;
154   }
155 
156   function getMiningRate(address _quoteToken) public view returns(uint256) {
157     uint256 initialRate = miningRate[_quoteToken];
158     if (unmined > 500000000e18){
159       return initialRate;
160     } else if (unmined > 400000000e18 && unmined <= 500000000e18){
161       return initialRate * 9e17 / 1e18;
162     } else if (unmined > 300000000e18 && unmined <= 400000000e18){
163       return initialRate * 8e17 / 1e18;
164     } else if (unmined > 200000000e18 && unmined <= 300000000e18){
165       return initialRate * 7e17 / 1e18;
166     } else if (unmined > 100000000e18 && unmined <= 200000000e18){
167       return initialRate * 6e17 / 1e18;
168     } else if(unmined <= 100000000e18) {
169       return initialRate * 5e17 / 1e18;
170     }
171   }
172 
173   function trade(
174       address[5] addrs,
175       uint[11] vals,
176       uint8[3] v,
177       bytes32[6] rs
178     ) public onlyNotPaused
179     returns (bool)
180   {
181     require(signers[addrs[4]]);
182     require(cancels[addrs[2]] < vals[2]);
183     require(cancels[addrs[3]] < vals[5]);
184 
185     require(vals[6] > 0 && vals[7] > 0 && vals[8] > 0);
186     require(vals[1] >= vals[7] && vals[4] >= vals[7]);
187     require(msg.sender == addrs[2] || msg.sender == addrs[3] || msg.sender == addrs[4]);
188 
189     bytes32 buyHash = keccak256(address(this), addrs[0], addrs[1], addrs[2], vals[0], vals[1], vals[2]);
190     bytes32 sellHash = keccak256(address(this), addrs[0], addrs[1], addrs[3], vals[3], vals[4], vals[5]);
191 
192     require(isValidSignature(addrs[2], buyHash, v[0], rs[0], rs[1]));
193     require(isValidSignature(addrs[3], sellHash, v[1], rs[2], rs[3]));
194 
195     bytes32 tradeHash = keccak256(this, buyHash, sellHash, addrs[4], vals[6], vals[7], vals[8], vals[9], vals[10]);
196     require(isValidSignature(addrs[4], tradeHash, v[2], rs[4], rs[5]));
197     
198     require(!traded[tradeHash]);
199     traded[tradeHash] = true;
200     
201     require(safeAdd(orderFills[buyHash], vals[6]) <= vals[0]);
202     require(safeAdd(orderFills[sellHash], vals[6]) <= vals[3]);
203     require(balances[addrs[1]][addrs[2]] >= vals[7]);
204 
205     balances[addrs[1]][addrs[2]] = safeSub(balances[addrs[1]][addrs[2]], vals[7]);
206     require(balances[addrs[0]][addrs[3]] >= vals[6]);
207     balances[addrs[0]][addrs[3]] = safeSub(balances[addrs[0]][addrs[3]], vals[6]);
208     balances[addrs[0]][addrs[2]] = safeAdd(balances[addrs[0]][addrs[2]], safeSub(vals[6], (safeMul(vals[6], vals[9]) / 1 ether)));
209     balances[addrs[1]][addrs[3]] = safeAdd(balances[addrs[1]][addrs[3]], safeSub(vals[7], (safeMul(vals[7], vals[10]) / 1 ether)));
210     
211     balances[addrs[0]][feeAccount] = safeAdd(balances[addrs[0]][feeAccount], safeMul(vals[6], vals[9]) / 1 ether);
212     balances[addrs[1]][feeAccount] = safeAdd(balances[addrs[1]][feeAccount], safeMul(vals[7], vals[10]) / 1 ether);
213 
214     orderFills[buyHash] = safeAdd(orderFills[buyHash], vals[6]);
215     orderFills[sellHash] = safeAdd(orderFills[sellHash], vals[6]);
216 
217     // mining BEYs
218     if(unmined > 0) {
219       if(miningRate[addrs[1]] > 0){
220         uint256 minedBEY = safeMul(safeMul(vals[7], getMiningRate(addrs[1])), 2) / 1 ether;
221         if(unmined > minedBEY) {
222           mined[addrs[2]] = safeAdd(mined[addrs[2]], minedBEY / 2);
223           mined[addrs[3]] = safeAdd(mined[addrs[3]], minedBEY / 2);
224           unmined = safeSub(unmined, minedBEY);
225         } else {
226           mined[addrs[2]] = safeAdd(mined[addrs[2]], unmined / 2);
227           mined[addrs[3]] = safeAdd(mined[addrs[3]], safeSub(unmined, unmined / 2));
228           unmined = 0;
229         }
230       }
231     }
232     return true;
233   }
234 
235   function claim() public returns(bool) {
236     require(mined[msg.sender] > 0);
237     require(BEY != address(0));
238     uint256 amount = mined[msg.sender];
239     mined[msg.sender] = 0;
240     require(Token(BEY).transfer(msg.sender, amount));
241     Mine(msg.sender, amount);
242     return true;
243   }
244 
245   function claimByTeam() public onlyOwner returns(bool) {
246     uint256 totalMined = safeSub(totalForMining, unmined);
247     require(totalMined > 0);
248     uint256 released = safeMul(teamLocked, totalMined) / totalForMining;
249     uint256 amount = safeSub(released, teamClaimed);
250     require(amount > 0);
251     teamClaimed = released;
252     require(Token(BEY).transfer(msg.sender, amount));
253     Release(msg.sender, amount);
254     return true;
255   }
256 
257   function cancel(
258     address baseToken, 
259     address quoteToken, 
260     address user,
261     uint volume,
262     uint fund,
263     uint nonce,
264     uint8 v,
265     bytes32 r,
266     bytes32 s) public onlySigner returns(bool)
267   {
268 
269     bytes32 hash = keccak256(this, baseToken, quoteToken, user, volume, fund, nonce);
270     require(isValidSignature(user, hash, v, r, s));
271     orderFills[hash] = volume;
272     Cancel(user, hash, nonce);
273     return true;
274   }
275   
276   function isValidSignature(
277         address signer,
278         bytes32 hash,
279         uint8 v,
280         bytes32 r,
281         bytes32 s)
282         public
283         pure
284         returns (bool)
285   {
286     return signer == ecrecover(
287       keccak256("\x19Ethereum Signed Message:\n32", hash),
288       v,
289       r,
290       s
291     );
292   }
293 }