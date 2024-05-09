1 /*
2 
3  ██████╗ ███████╗██╗
4 ██╔═══██╗██╔════╝██║
5 ██║   ██║█████╗  ██║
6 ██║   ██║██╔══╝  ██║
7 ╚██████╔╝██║     ██║
8  ╚═════╝ ╚═╝     ╚═╝
9 
10 *First Bitcoin Ordinals Lending & Borrow Protocol
11 
12 Website: https://ordin.finance/
13 
14 Discord: https://discord.gg/xY2RQT45Tm 
15 Twitter: https://twitter.com/ordinalsfinance
16 Website: http://ordin.finance/
17 Channel: https://t.me/OFIChannel
18 Telegram: https://t.me/OrdinalsFinance
19 */
20 
21 // SPDX-License-Identifier: MIT
22 
23 pragma solidity 0.6.12;
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint);
27     function balanceOf(address account) external view returns (uint);
28     function transfer(address recipient, uint amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint);
30     function approve(address spender, uint amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint value);
33     event Approval(address indexed owner, address indexed spender, uint value);
34 }
35 
36 library SafeMath {
37 
38     function add(uint a, uint b) internal pure returns (uint) {
39         uint c = a + b;
40         require(c >= a, "add: +");
41 
42         return c;
43     }
44 
45     function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
46         uint c = a + b;
47         require(c >= a, errorMessage);
48 
49         return c;
50     }
51 
52     function sub(uint a, uint b) internal pure returns (uint) {
53         return sub(a, b, "sub: -");
54     }
55 
56     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
57         require(b <= a, errorMessage);
58         uint c = a - b;
59 
60         return c;
61     }
62 
63     function mul(uint a, uint b) internal pure returns (uint) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint c = a * b;
72         require(c / a == b, "mul: *");
73 
74         return c;
75     }
76 
77     function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint c = a * b;
86         require(c / a == b, errorMessage);
87 
88         return c;
89     }
90 
91     function div(uint a, uint b) internal pure returns (uint) {
92         return div(a, b, "div: /");
93     }
94 
95     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
96         // Solidity only automatically asserts when dividing by 0
97         require(b > 0, errorMessage);
98         uint c = a / b;
99         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101         return c;
102     }
103 
104     function mod(uint a, uint b) internal pure returns (uint) {
105         return mod(a, b, "mod: %");
106     }
107 
108     function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
109         require(b != 0, errorMessage);
110         return a % b;
111     }
112 }
113 
114 pragma solidity ^0.6.0;
115 
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address payable) {
118         return msg.sender;
119     }
120 
121     function _msgData() internal view virtual returns (bytes memory) {
122         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
123         return msg.data;
124     }
125 }
126 
127 contract Ownable is Context {
128     address private _owner;
129 
130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132     constructor () internal {
133         address msgSender = _msgSender();
134         _owner = msgSender;
135         emit OwnershipTransferred(address(0), msgSender);
136     }
137 
138     function owner() public view returns (address) {
139         return _owner;
140     }
141 
142     modifier onlyOwner() {
143         require(_owner == _msgSender(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     function renounceOwnership() public virtual onlyOwner {
148         emit OwnershipTransferred(_owner, address(0));
149         _owner = address(0);
150     }
151 
152     function transferOwnership(address newOwner) public virtual onlyOwner {
153         require(newOwner != address(0), "Ownable: new owner is the zero address");
154         emit OwnershipTransferred(_owner, newOwner);
155         _owner = newOwner;
156     }
157 }
158 
159 // y = f(x)
160 
161 // 2 = f(10)
162 // 42 = f(180)
163 // 100 = f(365)
164 // y = 0.04366 + 0.19343*x + 0.00022*x^2
165 
166 
167 interface SavingInterface {
168     function votingPowerOf(address acc, uint256 until) external view returns(uint256);
169 }
170 
171 contract OFIStaking is Ownable, SavingInterface {
172     using SafeMath for uint256;
173     IERC20 public OFI;
174 
175     bool isClosed = false;
176 
177     // quadratic reward curve constants
178     // a + b*x + c*x^2
179     uint256 public A = 4366; // 0.04366
180     uint256 public B = 19343;  // 0.19343*x
181     uint256 public C = 22;    // 0.00022*x^2
182 
183     uint256 public maxDays = 180;
184     uint256 public minDays = 9;
185 
186     uint256 public totalSaved = 0;
187     uint256 public totalRewards = 0;
188 
189     uint256 public earlyExit = 0;
190 
191     struct SaveInfo {
192         uint256 reward;
193         uint256 initial;
194         uint256 payday;
195         uint256 startday;
196     }
197 
198     mapping (address=>SaveInfo) public saves;
199 
200     constructor(address _OFI) public {
201         OFI = IERC20(_OFI);
202     }
203 
204     function deposit(uint256 _amount, uint256 _days) public {
205         require(_days > minDays, "less than minimum saving period");
206         require(_days < maxDays, "more than maximum saving period");
207         require(saves[msg.sender].payday == 0, "already saved");
208         require(_amount > 100 * 1e9 && _amount < 10000000 * 1e9, "the number of stakes must be greater than 100 and less than 10m OFI");
209         require(!isClosed, "saving is closed");
210 
211         // calculate reward
212         uint256 _reward = calculateReward(_amount, _days);
213 
214         // contract must have funds to keep this commitment
215         require(OFI.balanceOf(address(this)) > totalOwedValue().add(_reward).add(_amount), "insufficient contract bal");
216 
217         require(OFI.transferFrom(msg.sender, address(this), _amount), "transfer failed");
218 
219         saves[msg.sender].payday = block.timestamp.add(_days * (1 days));
220         saves[msg.sender].reward = _reward;
221         saves[msg.sender].startday = block.timestamp;
222         saves[msg.sender].initial = _amount;
223 
224         // update stats
225         totalSaved = totalSaved.add(_amount);
226         totalRewards = totalRewards.add(_reward);
227     }
228 
229     function withdraw() public {
230         require(owedBalance(msg.sender) > 0, "nothing to withdraw");
231         require(block.timestamp > saves[msg.sender].payday.sub(earlyExit), "too early");
232 
233         uint256 owed = saves[msg.sender].reward.add(saves[msg.sender].initial);
234 
235         // update stats
236         totalSaved = totalSaved.sub(saves[msg.sender].initial);
237         totalRewards = totalRewards.sub(saves[msg.sender].reward);
238 
239         saves[msg.sender].initial = 0;
240         saves[msg.sender].reward = 0;
241         saves[msg.sender].payday = 0;
242         saves[msg.sender].startday = 0;
243 
244         require(OFI.transfer(msg.sender, owed), "transfer failed");
245     }
246 
247     function calculateReward(uint256 _amount, uint256 _days) public view returns (uint256) {
248         uint256 _multiplier = _quadraticRewardCurveY(_days);
249         uint256 _AY = _amount.mul(_multiplier);
250         return _AY.div(10000000);
251 
252     }
253 
254     // a + b*x + c*x^2
255     function _quadraticRewardCurveY(uint256 _x) public view returns (uint256) {
256         uint256 _bx = _x.mul(B);
257         uint256 _x2 = _x.mul(_x);
258         uint256 _cx2 = C.mul(_x2);
259         return A.add(_bx).add(_cx2);
260     }
261 
262     // helpers:
263     function totalOwedValue() public view returns (uint256) {
264         return totalSaved.add(totalRewards);
265     }
266 
267     function owedBalance(address acc) public view returns(uint256) {
268         return saves[acc].initial.add(saves[acc].reward);
269     }
270 
271     function votingPowerOf(address acc, uint256 until) external override view returns(uint256) {
272         if (saves[acc].payday > until) {
273             return 0;
274         }
275 
276         return owedBalance(acc);
277     }
278 
279     // owner functions:
280     function setLimits(uint256 _minDays, uint256 _maxDays) public onlyOwner {
281         minDays = _minDays;
282         maxDays = _maxDays;
283     }
284 
285     function setCurve(uint256 _A, uint256 _B, uint256 _C) public onlyOwner {
286         A = _A;
287         B = _B;
288         C = _C;
289     }
290 
291     function setEarlyExit(uint256 _earlyExit) public onlyOwner {
292         require(_earlyExit < 2000000, "too big");
293         close(true);
294         earlyExit = _earlyExit;
295     }
296 
297     function close(bool closed) public onlyOwner {
298         isClosed = closed;
299     }
300 
301     function ownerRewithdraw(uint256 _amount) public onlyOwner {
302         require(_amount < OFI.balanceOf(address(this)).sub(totalOwedValue()), "cannot withdraw owed funds");
303         OFI.transfer(msg.sender, _amount);
304     }
305 
306     function flushETH() public onlyOwner {
307         uint256 bal = address(this).balance.sub(1);
308         msg.sender.transfer(bal);
309     }
310 
311 }