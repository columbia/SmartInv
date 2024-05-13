1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.4;
4 import "@openzeppelin/contracts/access/Ownable.sol";
5 
6 import "../interfaces/IBEP20.sol";
7 import "../libraries/SafeMath.sol";
8 import "../libraries/Address.sol";
9 
10 /**
11  * @title SafeBEP20
12  * @dev Wrappers around BEP20 operations that throw on failure (when the token
13  * contract returns false). Tokens that return no value (and instead revert or
14  * throw on failure) are also supported, non-reverting calls are assumed to be
15  * successful.
16  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
17  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
18  */
19 library SafeBEP20 {
20     using SafeMath for uint256;
21     using Address for address;
22 
23     function safeTransfer(
24         IBEP20 token,
25         address to,
26         uint256 value
27     ) internal {
28         _callOptionalReturn(
29             token,
30             abi.encodeWithSelector(token.transfer.selector, to, value)
31         );
32     }
33 
34     function safeTransferFrom(
35         IBEP20 token,
36         address from,
37         address to,
38         uint256 value
39     ) internal {
40         _callOptionalReturn(
41             token,
42             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
43         );
44     }
45 
46     /**
47      * @dev Deprecated. This function has ids similar to the ones found in
48      * {IBEP20-approve}, and its usage is discouraged.
49      *
50      * Whenever possible, use {safeIncreaseAllowance} and
51      * {safeDecreaseAllowance} instead.
52      */
53     function safeApprove(
54         IBEP20 token,
55         address spender,
56         uint256 value
57     ) internal {
58         // safeApprove should only be called when setting an initial allowance,
59         // or when resetting it to zero. To increase and decrease it, use
60         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
61         // solhint-disable-next-line max-line-length
62         require(
63             (value == 0) || (token.allowance(address(this), spender) == 0),
64             "SafeBEP20: approve from non-zero to non-zero allowance"
65         );
66         _callOptionalReturn(
67             token,
68             abi.encodeWithSelector(token.approve.selector, spender, value)
69         );
70     }
71 
72     function safeIncreaseAllowance(
73         IBEP20 token,
74         address spender,
75         uint256 value
76     ) internal {
77         uint256 newAllowance = token.allowance(address(this), spender).add(
78             value
79         );
80         _callOptionalReturn(
81             token,
82             abi.encodeWithSelector(
83                 token.approve.selector,
84                 spender,
85                 newAllowance
86             )
87         );
88     }
89 
90     function safeDecreaseAllowance(
91         IBEP20 token,
92         address spender,
93         uint256 value
94     ) internal {
95         uint256 newAllowance = token.allowance(address(this), spender).sub(
96             value,
97             "SafeBEP20: decreased allowance below zero"
98         );
99         _callOptionalReturn(
100             token,
101             abi.encodeWithSelector(
102                 token.approve.selector,
103                 spender,
104                 newAllowance
105             )
106         );
107     }
108 
109     /**
110      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
111      * on the return value: the return value is optional (but if data is returned, it must not be false).
112      * @param token The token targeted by the call.
113      * @param data The call data (encoded using abi.encode or one of its variants).
114      */
115     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
116         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
117         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
118         // the target address contains contract code and also asserts for success in the low-level call.
119 
120         bytes memory returndata = address(token).functionCall(
121             data,
122             "SafeBEP20: low-level call failed"
123         );
124         if (returndata.length > 0) {
125             // Return data is optional
126             // solhint-disable-next-line max-line-length
127             require(
128                 abi.decode(returndata, (bool)),
129                 "SafeBEP20: BEP20 operation did not succeed"
130             );
131         }
132     }
133 }
134 
135 contract IFO is Ownable {
136     using SafeMath for uint256;
137     using SafeBEP20 for IBEP20;
138     struct IFOInfo {
139         uint256 id;
140         IBEP20 exhibits;
141         IBEP20 currency;
142         address recipient;
143         uint256 price;
144         uint256 totalSupply;
145         uint256 totalAmount;
146         uint256 startTime;
147         uint256 duration;
148         uint256 hardcap;
149         uint256 incomeTotal;
150         mapping(address => uint256) payAmount;
151         mapping(address => bool) isCollected;
152     }
153     uint256 public constant MAX = uint256(-1);
154     uint256 public constant ROUND = 10**18;
155     uint256 public idIncrement = 0;
156     mapping(uint256 => IFOInfo) public ifoInfos;
157     mapping(uint256 => bool) private isWithdraw;
158     event IFOLaunch(
159         uint256 id,
160         address exhibits,
161         address currency,
162         address recipient,
163         uint256 price,
164         uint256 hardcap,
165         uint256 totalSupply,
166         uint256 totalAmount,
167         uint256 startTime,
168         uint256 duration
169     );
170     event Staked(uint256 id, address account, uint256 value);
171     event Collected(
172         uint256 id,
173         address account,
174         uint256 ifoValue,
175         uint256 fee,
176         uint256 backValue
177     );
178     event IFOWithdraw(uint256 id, uint256 receiveValue, uint256 leftValue);
179 
180     event IFORemove(uint256 id);
181 
182     function launch(
183         IBEP20 exhibits,
184         IBEP20 currency,
185         address recipient,
186         uint256 totalAmount,
187         uint256 totalSupply,
188         uint256 hardcap,
189         uint256 startTime,
190         uint256 duration
191     ) external onlyOwner {
192         require(
193             address(recipient) != address(0),
194             "IFO: recipient address cannot be 0"
195         );
196         require(
197             startTime > block.timestamp,
198             "IFO: startTime should be later than now"
199         );
200         require(
201             block.timestamp >
202                 ifoInfos[idIncrement].startTime.add(
203                     ifoInfos[idIncrement].duration
204                 ),
205             "IFO: ifo is not over yet."
206         );
207         require(
208             address(exhibits) != address(0),
209             "IFO: exhibits address cannot be 0"
210         );
211         require(
212             address(currency) != address(0),
213             "IFO: currency address cannot be 0"
214         );
215   
216 
217         idIncrement = idIncrement.add(1);
218         IFOInfo storage ifo = ifoInfos[idIncrement];
219         ifo.id = idIncrement;
220         ifo.exhibits = exhibits;
221         ifo.currency = currency;
222         ifo.recipient = recipient;
223         ifo.totalAmount = totalAmount;
224         ifo.price = totalAmount.mul(ROUND).div(totalSupply);
225         ifo.hardcap = hardcap;
226         ifo.totalSupply = totalSupply;
227         ifo.startTime = startTime;
228         ifo.duration = duration;
229 
230         exhibits.safeTransferFrom(msg.sender, address(this), totalSupply);
231         emit IFOLaunch(
232             idIncrement,
233             address(exhibits),
234             address(currency),
235             recipient,
236             ifo.price,
237             hardcap,
238             totalSupply,
239             totalAmount,
240             startTime,
241             duration
242         );
243     }
244 
245     function removeIFO() external onlyOwner {
246         require(
247             ifoInfos[idIncrement].startTime > block.timestamp,
248             "IFO: there is no ifo that can be deleted."
249         );
250         ifoInfos[idIncrement].exhibits.safeTransfer(
251             msg.sender,
252             ifoInfos[idIncrement].totalSupply
253         );
254         delete ifoInfos[idIncrement];
255         emit IFORemove(idIncrement);
256         idIncrement = idIncrement.sub(1);
257     }
258 
259     function withdraw(uint256 id) external onlyOwner {
260         IFOInfo storage record = ifoInfos[id];
261         require(id <= idIncrement && id > 0, "IFO: ifo that does not exist.");
262         require(!isWithdraw[id], "IFO: cannot claim repeatedly.");
263         require(
264             block.timestamp > record.startTime.add(record.duration),
265             "IFO: ifo is not over yet."
266         );
267 
268         uint256 receiveValue;
269         uint256 backValue;
270 
271         isWithdraw[id] = true;
272 
273         uint256 prop = record.incomeTotal.mul(ROUND).mul(ROUND).div(
274             record.totalSupply.mul(record.price)
275         );
276         if (prop >= ROUND) {
277             receiveValue = record.totalSupply.mul(record.price).div(ROUND);
278             record.currency.safeTransfer(record.recipient, receiveValue);
279         } else {
280             receiveValue = record.incomeTotal;
281             record.currency.safeTransfer(record.recipient, receiveValue);
282             backValue = record.totalSupply.sub(
283                 record.totalSupply.mul(prop).div(ROUND)
284             );
285             record.exhibits.safeTransfer(record.recipient, backValue);
286         }
287 
288         emit IFOWithdraw(id, receiveValue, backValue);
289     }
290 
291     function stake(uint256 value) external {
292         require(idIncrement > 0, "IFO: ifo that does not exist.");
293         IFOInfo storage record = ifoInfos[idIncrement];
294         require(
295             block.timestamp > record.startTime &&
296                 block.timestamp < record.startTime.add(record.duration),
297             "IFO: ifo is not in progress."
298         );
299         require(
300             record.payAmount[msg.sender].add(value) <= record.hardcap,
301             "IFO: limit exceeded"
302         );
303 
304         record.payAmount[msg.sender] = record.payAmount[msg.sender].add(value);
305         record.incomeTotal = record.incomeTotal.add(value);
306         record.currency.safeTransferFrom(msg.sender, address(this), value);
307         emit Staked(idIncrement, msg.sender, value);
308     }
309 
310     function available(address account, uint256 id)
311         public
312         view
313         returns (uint256 _ifoAmount, uint256 _sendBack)
314     {
315         IFOInfo storage record = ifoInfos[id];
316         require(id <= idIncrement && id > 0, "IFO: ifo that does not exist.");
317 
318         uint256 prop = record.incomeTotal.mul(ROUND).mul(ROUND).div(
319             record.totalSupply.mul(record.price)
320         );
321 
322         if (prop > ROUND) {
323             _ifoAmount = record
324                 .payAmount[account]
325                 .mul(ROUND)
326                 .mul(ROUND)
327                 .div(prop)
328                 .div(record.price);
329             _sendBack = record
330                 .payAmount[account]
331                 .mul(ROUND.sub(ROUND.mul(ROUND).add(prop).sub(1).div(prop)))
332                 .div(ROUND);
333         } else {
334             _ifoAmount = record.payAmount[account].mul(ROUND).div(record.price);
335         }
336     }
337 
338     function userPayValue(uint256 id, address account)
339         public
340         view
341         returns (uint256)
342     {
343         return ifoInfos[id].payAmount[account];
344     }
345 
346     function isCollected(uint256 id, address account)
347         public
348         view
349         returns (bool)
350     {
351         return ifoInfos[id].isCollected[account];
352     }
353 
354     function collect(uint256 id) external {
355         require(id <= idIncrement && id > 0, "IFO: ifo that does not exist.");
356         IFOInfo storage record = ifoInfos[id];
357         require(
358             block.timestamp > ifoInfos[id].startTime.add(record.duration),
359             "IFO: ifo is not over yet."
360         );
361         require(
362             !record.isCollected[msg.sender],
363             "IFO: cannot claim repeatedly."
364         );
365 
366         uint256 ifoAmount;
367         uint256 sendBack;
368 
369         record.isCollected[msg.sender] = true;
370 
371         (ifoAmount, sendBack) = available(msg.sender, id);
372 
373         record.exhibits.safeTransfer(msg.sender, ifoAmount);
374         uint256 fee;
375         if (sendBack > 0) {
376             uint256 rateFee = getFeeRate(id);
377             fee = sendBack.mul(rateFee).div(ROUND);
378             if (fee > 0) {
379                 record.currency.safeTransfer(owner(), fee);
380                 sendBack = sendBack.sub(fee);
381             }
382             record.currency.safeTransfer(msg.sender, sendBack);
383         }
384 
385         emit Collected(id, msg.sender, ifoAmount, fee, sendBack);
386     }
387 
388     function getFeeRate(uint256 id) public view returns (uint256) {
389         if (ifoInfos[id].hardcap != MAX) {
390             return 0;
391         }
392         uint256 x = ifoInfos[id].incomeTotal.div(ifoInfos[id].totalAmount);
393         if (x >= 500) {
394             return ROUND.mul(20).div(10000);
395         } else if (x >= 250) {
396             return ROUND.mul(25).div(10000);
397         } else if (x >= 100) {
398             return ROUND.mul(30).div(10000);
399         } else if (x >= 50) {
400             return ROUND.mul(50).div(10000);
401         } else {
402             return ROUND.mul(100).div(10000);
403         }
404     }
405 }
