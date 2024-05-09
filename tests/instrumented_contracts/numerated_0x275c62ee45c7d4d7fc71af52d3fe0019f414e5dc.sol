1 pragma solidity ^0.4.24;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that revert on error
6 */
7 library SafeMath {
8   function add(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a + b;
10     require(c >= a);
11 
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     require(b <= a);
17     uint256 c = a - b;
18 
19     return c;
20   }
21 
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25 
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 }
37 
38 interface IERC20 {
39   function totalSupply() external view returns (uint256);
40 
41   function balanceOf(address who) external view returns (uint256);
42 
43   function allowance(address owner, address spender) external view returns (uint256);
44 
45   function transfer(address to, uint256 value) external returns (bool);
46 
47   function approve(address spender, uint256 value) external returns (bool);
48 
49   function transferFrom(address from, address to, uint256 value) external returns (bool);
50 
51   event Transfer(
52     address indexed from,
53     address indexed to,
54     uint256 value
55   );
56 
57   event Approval(
58     address indexed owner,
59     address indexed spender,
60     uint256 value
61   );
62 }
63 
64 library SafeERC20 {
65   function safeTransfer(IERC20 token, address to, uint256 value) internal{
66     require(token.transfer(to, value));
67   }
68 
69   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
70     require(token.transferFrom(from, to, value));
71   }
72 
73   function safeApprove(IERC20 token, address spender, uint256 value) internal {
74     require(token.approve(spender, value));
75   }
76 }
77 
78 contract Ownable {
79   address public owner;
80 
81   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83   constructor() public {
84     owner = msg.sender;
85   }
86 
87   modifier onlyOwner {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   function transferOwnership(address newOwner) onlyOwner public {
93     require(newOwner != address(0));
94     emit OwnershipTransferred(owner, newOwner);
95     owner = newOwner;
96   }
97 }
98 
99 contract TalaRCrowdsale is Ownable {
100   using SafeMath for uint256;
101   using SafeERC20 for IERC20;
102 
103   // The token being sold
104   IERC20 private _token;
105 
106   // Address where funds are collected
107   address private _wallet;
108 
109   // How many token units a buyer gets per wei.
110   uint256 private _rate;
111 
112   // Same as _rate but in bonus time
113   uint256 private _bonusRate;
114 
115   // bonus cap in wei
116   uint256 private _bonusCap;
117 
118   // Amount of wei raised
119   uint256 private _weiRaised;
120 
121   // Timestamps
122   uint256 private _openingTime;
123   uint256 private _bonusEndTime;
124   uint256 private _closingTime;
125 
126   // Minimal contribution - 0.05 ETH
127   uint256 private constant MINIMAL_CONTRIBUTION = 50000000000000000;
128 
129   event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
130 
131   constructor(uint256 rate, uint256 bonusRate, uint256 bonusCap, uint256 openingTime, uint256 bonusEndTime, uint256 closingTime, address wallet, IERC20 token) public {
132     require(rate > 0);
133     require(bonusRate > 0);
134     require(bonusCap > 0);
135     require(openingTime >= block.timestamp);
136     require(bonusEndTime >= openingTime);
137     require(closingTime >= bonusEndTime);
138     require(wallet != address(0));
139 
140     _rate = rate;
141     _bonusRate = bonusRate;
142     _bonusCap = bonusCap;
143     _wallet = wallet;
144     _token = token;
145     _openingTime = openingTime;
146     _closingTime = closingTime;
147     _bonusEndTime = bonusEndTime;
148   }
149 
150   function () external payable {
151     buyTokens(msg.sender);
152   }
153 
154   function token() public view returns(IERC20) {
155     return _token;
156   }
157 
158   function wallet() public view returns(address) {
159     return _wallet;
160   }
161 
162   function rate() public view returns(uint256) {
163     return _rate;
164   }
165 
166   function bonusRate() public view returns(uint256) {
167     return _bonusRate;
168   }
169 
170   function bonusCap() public view returns(uint256) {
171     return _bonusCap;
172   }
173 
174   function weiRaised() public view returns (uint256) {
175     return _weiRaised;
176   }
177 
178   function openingTime() public view returns(uint256) {
179     return _openingTime;
180   }
181 
182   function closingTime() public view returns(uint256) {
183     return _closingTime;
184   }
185 
186   function bonusEndTime() public view returns(uint256) {
187     return _bonusEndTime;
188   }
189 
190   function buyTokens(address beneficiary) public payable {
191     uint256 weiAmount = msg.value;
192     _preValidatePurchase(beneficiary, weiAmount);
193 
194     uint256 tokenAmount = _getTokenAmount(weiAmount);
195 
196     _weiRaised = _weiRaised.add(weiAmount);
197 
198     _token.safeTransfer(beneficiary, tokenAmount);
199     emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokenAmount);
200 
201     _forwardFunds();
202   }
203 
204   function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal {
205     require(isOpen());
206     require(beneficiary != address(0));
207     require(weiAmount >= MINIMAL_CONTRIBUTION);
208   }
209 
210   function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
211     return weiAmount.mul(_getCurrentRate());
212   }
213 
214   function _forwardFunds() internal {
215     _wallet.transfer(msg.value);
216   }
217 
218   function _getCurrentRate() internal view returns (uint256) {
219     return isBonusTime() ? _bonusRate : _rate;
220   }
221 
222   function isOpen() public view returns (bool) {
223     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
224   }
225 
226   function hasClosed() public view returns (bool) {
227     return block.timestamp > _closingTime;
228   }
229 
230   function isBonusTime() public view returns (bool) {
231     return block.timestamp >= _openingTime && block.timestamp <= _bonusEndTime && _weiRaised <= _bonusCap;
232   }
233 
234   // ETH balance is always expected to be 0.
235   // but in case something went wrong, owner can extract ETH
236   function emergencyETHDrain() external onlyOwner {
237     _wallet.transfer(address(this).balance);
238   }
239 
240   // owner can drain tokens that are sent here by mistake
241   function emergencyERC20Drain(IERC20 tokenDrained, uint amount) external onlyOwner {
242     tokenDrained.transfer(owner, amount);
243   }
244 
245   // when sale is closed owner can drain any tokens left 
246   function tokensLeftDrain(uint amount) external onlyOwner {
247     require(hasClosed());
248     _token.transfer(owner, amount);
249   }
250 }