1 /* Simple token - simple token for PreICO and ICO
2    Copyright (C) 2017  Sergey Sherkunov <leinlawun@leinlawun.org>
3    Copyright (C) 2017  OOM.AG <info@oom.ag>
4 
5    This file is part of simple token.
6 
7    Token is free software: you can redistribute it and/or modify
8    it under the terms of the GNU General Public License as published by
9    the Free Software Foundation, either version 3 of the License, or
10    (at your option) any later version.
11 
12    This program is distributed in the hope that it will be useful,
13    but WITHOUT ANY WARRANTY; without even the implied warranty of
14    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15    GNU General Public License for more details.
16 
17    You should have received a copy of the GNU General Public License
18    along with this program.  If not, see <https://www.gnu.org/licenses/>.  */
19 
20 pragma solidity ^0.4.18;
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25 
26         assert(c >= a);
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         assert(b <= a);
31 
32         c = a - b;
33     }
34 
35     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
36         c = a * b;
37 
38         assert(c / a == b);
39     }
40 
41     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a / b;
43     }
44 
45     function mod(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         c = a % b;
47     }
48 
49     function min(uint256 a, uint256 b) internal pure returns (uint256 c) {
50         c = a;
51 
52         if(a > b)
53            c = b;
54     }
55 }
56 
57 contract ABXToken {
58     using SafeMath for uint256;
59 
60     address public owner;
61 
62     address public minter;
63 
64     string public name;
65 
66     string public symbol;
67 
68     uint8 public decimals;
69 
70     uint256 public totalSupply;
71 
72     mapping(address => uint256) public balanceOf;
73 
74     mapping(address => mapping(address => uint256)) public allowance;
75 
76     event Transfer(address indexed oldTokensHolder,
77                    address indexed newTokensHolder, uint256 tokensNumber);
78 
79     //An Attack Vector on Approve/TransferFrom Methods:
80     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81     event Transfer(address indexed tokensSpender,
82                    address indexed oldTokensHolder,
83                    address indexed newTokensHolder, uint256 tokensNumber);
84 
85     event Approval(address indexed tokensHolder, address indexed tokensSpender,
86                    uint256 newTokensNumber);
87 
88     //An Attack Vector on Approve/TransferFrom Methods:
89     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
90     event Approval(address indexed tokensHolder, address indexed tokensSpender,
91                    uint256 oldTokensNumber, uint256 newTokensNumber);
92 
93     modifier onlyOwner {
94         require(owner == msg.sender);
95 
96         _;
97     }
98 
99     //ERC20 Short Address Attack:
100     //https://vessenes.com/the-erc20-short-address-attack-explained
101     //https://blog.golemproject.net/how-to-find-10m-by-just-reading-blockchain-6ae9d39fcd95
102     //https://ericrafaloff.com/analyzing-the-erc20-short-address-attack
103     modifier checkPayloadSize(uint256 size) {
104         require(msg.data.length == size + 4);
105 
106         _;
107     }
108 
109     modifier onlyNotNullTokenHolder(address tokenHolder) {
110         require(tokenHolder != address(0));
111 
112         _;
113     }
114 
115     function ABXToken(string _name, string _symbol, uint8 _decimals,
116                       uint256 _totalSupply) public {
117         owner = msg.sender;
118         name = _name;
119         symbol = _symbol;
120         decimals = _decimals;
121         totalSupply = _totalSupply.mul(10 ** uint256(decimals));
122 
123         require(decimals <= 77);
124 
125         balanceOf[this] = totalSupply;
126     }
127 
128     function setOwner(address _owner) public onlyOwner returns(bool) {
129         owner = _owner;
130 
131         return true;
132     }
133 
134     function setMinter(address _minter) public onlyOwner returns(bool) {
135         safeApprove(this, minter, 0);
136 
137         minter = _minter;
138 
139         safeApprove(this, minter, balanceOf[this]);
140 
141         return true;
142     }
143 
144     //ERC20 Short Address Attack:
145     //https://vessenes.com/the-erc20-short-address-attack-explained
146     //https://blog.golemproject.net/how-to-find-10m-by-just-reading-blockchain-6ae9d39fcd95
147     //https://ericrafaloff.com/analyzing-the-erc20-short-address-attack
148     function transfer(address newTokensHolder, uint256 tokensNumber) public
149                      checkPayloadSize(2 * 32) returns(bool) {
150         transfer(msg.sender, newTokensHolder, tokensNumber);
151 
152         return true;
153     }
154 
155     //An Attack Vector on Approve/TransferFrom Methods:
156     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157     //
158     //ERC20 Short Address Attack:
159     //https://vessenes.com/the-erc20-short-address-attack-explained
160     //https://blog.golemproject.net/how-to-find-10m-by-just-reading-blockchain-6ae9d39fcd95
161     //https://ericrafaloff.com/analyzing-the-erc20-short-address-attack
162     function transferFrom(address oldTokensHolder, address newTokensHolder,
163                           uint256 tokensNumber) public checkPayloadSize(3 * 32)
164                          returns(bool) {
165         allowance[oldTokensHolder][msg.sender] =
166             allowance[oldTokensHolder][msg.sender].sub(tokensNumber);
167 
168         transfer(oldTokensHolder, newTokensHolder, tokensNumber);
169 
170         Transfer(msg.sender, oldTokensHolder, newTokensHolder, tokensNumber);
171 
172         return true;
173     }
174 
175     //ERC20 Short Address Attack:
176     //https://vessenes.com/the-erc20-short-address-attack-explained
177     //https://blog.golemproject.net/how-to-find-10m-by-just-reading-blockchain-6ae9d39fcd95
178     //https://ericrafaloff.com/analyzing-the-erc20-short-address-attack
179     function approve(address tokensSpender, uint256 newTokensNumber) public
180                     checkPayloadSize(2 * 32) returns(bool) {
181         safeApprove(msg.sender, tokensSpender, newTokensNumber);
182 
183         return true;
184     }
185 
186     //An Attack Vector on Approve/TransferFrom Methods:
187     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188     //
189     //ERC20 Short Address Attack:
190     //https://vessenes.com/the-erc20-short-address-attack-explained
191     //https://blog.golemproject.net/how-to-find-10m-by-just-reading-blockchain-6ae9d39fcd95
192     //https://ericrafaloff.com/analyzing-the-erc20-short-address-attack
193     function approve(address tokensSpender, uint256 oldTokensNumber,
194                      uint256 newTokensNumber) public checkPayloadSize(3 * 32)
195                     returns(bool) {
196         require(allowance[msg.sender][tokensSpender] == oldTokensNumber);
197 
198         unsafeApprove(msg.sender, tokensSpender, newTokensNumber);
199 
200         Approval(msg.sender, tokensSpender, oldTokensNumber, newTokensNumber);
201 
202         return true;
203     }
204 
205     function transfer(address oldTokensHolder, address newTokensHolder,
206                       uint256 tokensNumber) private
207                       onlyNotNullTokenHolder(oldTokensHolder) {
208         balanceOf[oldTokensHolder] =
209             balanceOf[oldTokensHolder].sub(tokensNumber);
210 
211         balanceOf[newTokensHolder] =
212             balanceOf[newTokensHolder].add(tokensNumber);
213 
214         Transfer(oldTokensHolder, newTokensHolder, tokensNumber);
215     }
216 
217     //An Attack Vector on Approve/TransferFrom Methods:
218     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219     function unsafeApprove(address tokensHolder, address tokensSpender,
220                            uint256 newTokensNumber) private
221                           onlyNotNullTokenHolder(tokensHolder) {
222         allowance[tokensHolder][tokensSpender] = newTokensNumber;
223 
224         Approval(msg.sender, tokensSpender, newTokensNumber);
225     }
226     
227     //An Attack Vector on Approve/TransferFrom Methods:
228     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229     function safeApprove(address tokensHolder, address tokensSpender,
230                          uint256 newTokensNumber) private {
231         require(allowance[tokensHolder][tokensSpender] == 0 ||
232                 newTokensNumber == 0);
233 
234         unsafeApprove(tokensHolder, tokensSpender, newTokensNumber);
235     }
236 }
237 
238 contract Minter {
239     using SafeMath for uint256;
240 
241     enum MinterState {
242         tokenSaleWait,
243         tokenSaleStarted,
244         Over
245     }
246 
247     struct Tokensale {
248         uint256 startTime;
249         uint256 endTime;
250         uint256 tokensMinimumNumberForBuy;
251         uint256 tokensCost;
252     }
253 
254     address public owner;
255 
256     address public manager;
257 
258     bool public paused = false;
259 
260     mapping(address => bool) public whiteList;
261 
262     ABXToken public token;
263 
264     Tokensale public tokenSale;
265 
266     modifier onlyOwner {
267         require(owner == msg.sender);
268 
269         _;
270     }
271 
272     modifier onlyNotPaused {
273         require(!paused);
274 
275         _;
276     }
277 
278     modifier onlyDuringTokensale {
279         require(minterState() == MinterState.tokenSaleStarted);
280 
281         _;
282     }
283 
284     modifier onlyAfterTokensaleOver {
285         require(minterState() == MinterState.Over);
286 
287         _;
288     }
289 
290     modifier onlyWhiteList {
291         require(whiteList[msg.sender]);
292 
293         _;
294     }
295 
296     modifier checkLimitsToBuyTokens {
297         require(tokenSale.tokensMinimumNumberForBuy <=
298                 tokensNumberForBuy().div(10 ** uint256(token.decimals())));
299 
300         _;
301     }
302 
303     function Minter(address _manager, ABXToken _token,
304                     uint256 tokenSaleStartTime, uint256 tokenSaleEndTime,
305                     uint256 tokenSaleTokensMinimumNumberForBuy) public {
306         owner = msg.sender;
307         manager = _manager;
308         token = _token;
309         tokenSale.startTime = tokenSaleStartTime;
310         tokenSale.endTime = tokenSaleEndTime;
311         tokenSale.tokensMinimumNumberForBuy =
312             tokenSaleTokensMinimumNumberForBuy;
313     }
314 
315     function setOwner(address _owner) public onlyOwner {
316         owner = _owner;
317     }
318 
319     function setManager(address _manager) public onlyOwner {
320         manager = _manager;
321     }
322 
323     function setPaused(bool _paused) public onlyOwner {
324         paused = _paused;
325     }
326 
327     function addWhiteList(address tokensHolder) public onlyOwner {
328         whiteList[tokensHolder] = true;
329     }
330 
331     function removeWhiteList(address tokensHolder) public onlyOwner {
332         whiteList[tokensHolder] = false;
333     }
334 
335     function setTokenSaleStartTime(uint256 timestamp) public onlyOwner {
336         tokenSale.startTime = timestamp;
337     }
338 
339     function setTokenSaleEndTime(uint256 timestamp) public onlyOwner {
340         tokenSale.endTime = timestamp;
341     }
342 
343     function setTokenSaleTokensMinimumNumberForBuy(uint256 tokensNumber) public
344                                                onlyOwner {
345         tokenSale.tokensMinimumNumberForBuy = tokensNumber;
346     }
347 
348     function setTokenSaleTokensCost(uint256 tokensCost) public onlyOwner {
349         tokenSale.tokensCost = tokensCost;
350     }
351 
352     function transferRestTokensToOwner() public onlyOwner
353                                       onlyAfterTokensaleOver {
354         token.transferFrom(token, msg.sender, token.allowance(token, this));
355     }
356 
357     function () public payable onlyDuringTokensale onlyNotPaused onlyWhiteList
358                 checkLimitsToBuyTokens {
359         uint256 tokensNumber = tokensNumberForBuy();
360 
361         uint256 aviableTokensNumber =
362             token.balanceOf(token).min(token.allowance(token, this));
363 
364         uint256 restCoins = 0;
365 
366         if(tokensNumber >= aviableTokensNumber) {
367             uint256 restTokensNumber = tokensNumber.sub(aviableTokensNumber);
368 
369             restCoins =
370                 restTokensNumber.mul(tokenSale.tokensCost)
371                                 .div(10 ** uint256(token.decimals()));
372 
373             tokensNumber = aviableTokensNumber;
374         }
375 
376         token.transferFrom(token, msg.sender, tokensNumber);
377 
378         msg.sender.transfer(restCoins);
379 
380         manager.transfer(msg.value.sub(restCoins));
381     }
382 
383     function minterState() private constant returns(MinterState) {
384         if(tokenSale.startTime > now) {
385             return MinterState.tokenSaleWait;
386         } else if(tokenSale.endTime > now) {
387             return MinterState.tokenSaleStarted;
388         } else {
389             return MinterState.Over;
390         }
391     }
392 
393     function tokensNumberForBuy() private constant returns(uint256) {
394         return msg.value.mul(10 ** uint256(token.decimals()))
395                         .div(tokenSale.tokensCost);
396     }
397 }