1 pragma solidity 0.4.21;
2 
3 // Wolf Crypto presale pooling contract
4 // written by @iamdefinitelyahuman
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) return 0;
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 interface ERC20 {
31   function balanceOf(address _owner) external returns (uint256 balance);
32   function transfer(address _to, uint256 _value) external returns (bool success);
33 }
34 
35 interface WhiteList {
36    function checkMemberLevel (address addr) external view returns (uint);
37 }
38 
39 library PresaleLib {
40 	
41   using SafeMath for uint;
42   
43   WhiteList constant whitelistContract = WhiteList(0x8D95B038cA80A986425FA240C3C17Fb2B6e9bc63);
44   uint constant contributionMin = 100000000000000000;
45   uint constant maxGasPrice = 50000000000;
46   
47   struct Contributor {
48     uint16 claimedTokensIndex;
49     uint balance;
50   }
51   
52   struct Data {
53     address owner;
54     address receiver;
55     address[] withdrawToken;
56     bool poolSubmitted;
57     bool locked;
58     uint addressSetTime;
59     uint fee;
60     uint contractCap;
61     uint finalBalance;
62     uint[] withdrawAmount;
63     uint[] capAmounts;
64     uint32[] capTimes;
65     mapping (address => uint) tokenBalances;
66     mapping (address => uint) individualCaps;
67     mapping (address => Contributor) contributorMap;
68   }
69   
70   event ContributorBalanceChanged (address contributor, uint totalBalance);
71   event ReceiverAddressSet ( address addr);
72   event PoolSubmitted (address receiver, uint amount);
73   event WithdrawalAvailable (address token);
74   event WithdrawalClaimed (address receiver, address token, uint amount);
75   
76   modifier onlyOwner (Data storage self) {
77     require (msg.sender == self.owner);
78     _;
79   }
80   
81   modifier noReentrancy(Data storage self) {
82     require(!self.locked);
83     self.locked = true;
84     _;
85     self.locked = false;
86   }
87   
88   function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {
89     return numerator.mul(10 ** 20).div(denominator);
90   }
91   
92   function _applyPct (uint numerator, uint pct) internal pure returns (uint) {
93     return numerator.mul(pct).div(10 ** 20);
94   }
95   
96   function newPool (Data storage self, uint _fee, address _receiver, uint _contractCap, uint _individualCap) public {
97     require (_fee < 1000);
98     self.owner = msg.sender;
99     self.receiver = _receiver;
100     self.contractCap = _contractCap;
101     self.capTimes.push(0);
102     self.capAmounts.push(_individualCap);
103     self.fee = _toPct(_fee,1000);
104   }
105 	
106   function deposit (Data storage self) public {
107 	  assert (!self.poolSubmitted);
108     require (tx.gasprice <= maxGasPrice);
109     Contributor storage c = self.contributorMap[msg.sender];
110     uint cap = _getCap(self, msg.sender);
111     require (cap >= c.balance.add(msg.value));
112     if (self.contractCap < address(this).balance) {
113       require (address(this).balance.sub(msg.value) < self.contractCap);
114       uint excess = address(this).balance.sub(self.contractCap);
115       c.balance = c.balance.add(msg.value.sub(excess));
116       msg.sender.transfer(excess);
117     } else {
118       c.balance = c.balance.add(msg.value);
119     }
120     require (c.balance >= contributionMin);
121     emit ContributorBalanceChanged(msg.sender, c.balance);
122   }
123   
124   function receiveRefund (Data storage self) public {
125     assert (self.poolSubmitted);
126     require (msg.sender == self.receiver || msg.sender == self.owner);
127     require (msg.value >= 1 ether);
128     self.withdrawToken.push(0x00);
129     self.withdrawAmount.push(msg.value);
130     emit WithdrawalAvailable(0x00);
131   }
132   
133   function withdraw (Data storage self) public {
134     assert (msg.value == 0);
135     Contributor storage c = self.contributorMap[msg.sender];
136     require (c.balance > 0);
137     if (!self.poolSubmitted) {
138       uint balance = c.balance;
139       c.balance = 0;
140       msg.sender.transfer(balance);
141       emit ContributorBalanceChanged(msg.sender, 0);
142       return;
143     }
144     require (c.claimedTokensIndex < self.withdrawToken.length);
145     uint pct = _toPct(c.balance,self.finalBalance);
146     uint amount;
147     address token;
148     for (uint16 i = c.claimedTokensIndex; i < self.withdrawToken.length; i++) {
149       amount = _applyPct(self.withdrawAmount[i],pct);
150       token = self.withdrawToken[i];
151       c.claimedTokensIndex++;
152       if (amount > 0) {  
153         if (token == 0x00) {
154           msg.sender.transfer(amount);
155         } else {
156           require (ERC20(token).transfer(msg.sender, amount));
157           self.tokenBalances[token] = self.tokenBalances[token].sub(amount);  
158         }
159         emit WithdrawalClaimed(msg.sender, token, amount);
160       }
161     }
162   }
163   
164   function setIndividualCaps (Data storage self, address[] addr, uint[] cap) public onlyOwner(self) {
165     require (addr.length == cap.length);
166     for (uint8 i = 0; i < addr.length; i++) {
167       self.individualCaps[addr[i]] = cap[i];
168     }  
169   }
170   
171   function setCaps (Data storage self, uint32[] times, uint[] caps) public onlyOwner(self) {
172     require (caps.length > 0);
173     require (caps.length == times.length);
174     self.capTimes = [0];
175     self.capAmounts = [self.capAmounts[0]];
176     for (uint8 i = 0; i < caps.length; i++) {
177       require (times[i] > self.capTimes[self.capTimes.length.sub(1)]);
178       self.capTimes.push(times[i]);
179       self.capAmounts.push(caps[i]);
180     }
181   }
182   
183   function setContractCap (Data storage self, uint amount) public onlyOwner(self) {
184     require (amount >= address(this).balance);
185     self.contractCap = amount;
186   }
187   
188   function _getCap (Data storage self, address addr) internal view returns (uint) {
189     if (self.individualCaps[addr] > 0) return self.individualCaps[addr];
190     if (whitelistContract.checkMemberLevel(msg.sender) == 0) return 0;
191     return getCapAtTime(self,now);
192   }
193   
194   function getCapAtTime (Data storage self, uint time) public view returns (uint) {
195     if (time == 0) time = now;
196     for (uint i = 1; i < self.capTimes.length; i++) {
197       if (self.capTimes[i] > time) return self.capAmounts[i-1];
198     }
199     return self.capAmounts[self.capAmounts.length-1];
200   }
201   
202   function getPoolInfo (Data storage self) view public returns (uint balance, uint remaining, uint cap) {
203     if (!self.poolSubmitted) return (address(this).balance, self.contractCap.sub(address(this).balance), self.contractCap);
204     return (address(this).balance, 0, self.contractCap);
205   }
206   
207   function getContributorInfo (Data storage self, address addr) view public returns (uint balance, uint remaining, uint cap) {
208     cap = _getCap(self, addr);
209     Contributor storage c = self.contributorMap[addr];
210     if (self.poolSubmitted || cap <= c.balance) return (c.balance, 0, cap);
211     if (cap.sub(c.balance) > self.contractCap.sub(address(this).balance)) return (c.balance, self.contractCap.sub(address(this).balance), cap);
212     return (c.balance, cap.sub(c.balance), cap);
213   }
214   
215   function checkWithdrawalAvailable (Data storage self, address addr) view public returns (bool) {
216     return self.contributorMap[addr].claimedTokensIndex < self.withdrawToken.length;
217   }
218   
219   function setReceiverAddress (Data storage self, address _receiver) public onlyOwner(self) {
220     require (!self.poolSubmitted);
221     self.receiver = _receiver;
222     self.addressSetTime = now;
223     emit ReceiverAddressSet(_receiver);
224   }
225   
226   function submitPool (Data storage self, uint amountInWei) public onlyOwner(self) noReentrancy(self) {
227     require (!self.poolSubmitted);
228     require (now > self.addressSetTime.add(86400));
229     if (amountInWei == 0) amountInWei = address(this).balance;
230     self.finalBalance = address(this).balance;
231     self.poolSubmitted = true;
232     require (self.receiver.call.value(amountInWei).gas(gasleft().sub(5000))());
233     if (address(this).balance > 0) {
234       self.withdrawToken.push(0x00);
235       self.withdrawAmount.push(address(this).balance);
236       emit WithdrawalAvailable(0x00);
237     }
238     emit PoolSubmitted(self.receiver, amountInWei);
239   }
240   
241   function enableWithdrawals (Data storage self, address tokenAddress, address feeAddress) public onlyOwner(self) noReentrancy(self) {
242     require (self.poolSubmitted);
243     if (feeAddress == 0x00) feeAddress = self.owner;
244     ERC20 token = ERC20(tokenAddress);
245     uint amount = token.balanceOf(this).sub(self.tokenBalances[tokenAddress]);
246     require (amount > 0);
247     if (self.fee > 0) {
248       require (token.transfer(feeAddress, _applyPct(amount,self.fee)));
249       amount = token.balanceOf(this).sub(self.tokenBalances[tokenAddress]);
250     }
251     self.tokenBalances[tokenAddress] = token.balanceOf(this);
252     self.withdrawToken.push(tokenAddress);
253     self.withdrawAmount.push(amount);
254     emit WithdrawalAvailable(tokenAddress);
255   }
256 
257 }
258 contract PresalePool {
259 	
260 	using PresaleLib for PresaleLib.Data;
261 	PresaleLib.Data data;
262   
263   event ERC223Received (address token, uint value, bytes data);
264 	
265 	function PresalePool (uint fee, address receiver, uint contractCap, uint individualCap) public {
266     data.newPool(fee, receiver, contractCap, individualCap);
267 	}
268 	
269 	function () public payable {
270     if (msg.value > 0) {
271       if (!data.poolSubmitted) {
272         data.deposit();
273       } else {
274         data.receiveRefund();
275       }
276     } else {
277       data.withdraw();
278     }
279 	}
280   
281   function setIndividualCaps (address[] addr, uint[] cap) public {
282     data.setIndividualCaps(addr, cap); 
283   }
284   
285   function setCaps (uint32[] times, uint[] caps) public {
286     data.setCaps(times,caps);
287   }
288   
289   function setContractCap (uint amount) public {
290     data.setContractCap(amount);
291   }
292   
293   function getPoolInfo () view public returns (uint balance, uint remaining, uint cap) {
294     return data.getPoolInfo();
295   }
296   
297   function getContributorInfo (address addr) view public returns (uint balance, uint remaining, uint cap) {
298     return data.getContributorInfo(addr);
299   }
300   
301   function getCapAtTime (uint32 time) view public returns (uint) {
302     return data.getCapAtTime(time);
303   }
304   
305   function checkWithdrawalAvailable (address addr) view public returns (bool) {
306     return data.checkWithdrawalAvailable(addr);
307   }
308   
309   function setReceiverAddress (address receiver) public {
310     data.setReceiverAddress(receiver);
311   }
312   
313   function submitPool (uint amountInWei) public {
314     data.submitPool(amountInWei);
315   }
316   
317   function enableWithdrawals (address tokenAddress, address feeAddress) public {
318     data.enableWithdrawals(tokenAddress, feeAddress);
319   }
320   
321   function tokenFallback (address from, uint value, bytes calldata) public {
322     emit ERC223Received(from, value, calldata);
323   }
324 	
325 }