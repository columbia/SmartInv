1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0;
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
47      * @dev Deprecated. This function has issues similar to the ones found in
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
135 contract IDO is Ownable {
136     using SafeMath for uint256;
137     using SafeBEP20 for IBEP20;
138     struct IDORecord {
139         uint256 issue;
140         IBEP20 idoToken;
141         IBEP20 receiveToken;
142         //decimals 18
143         uint256 price;
144         //IDO总量
145         uint256 idoTotal;
146         //开始时间
147         uint256 startTime;
148         //时长
149         uint256 duration;
150         uint256 maxLimit;
151         //接收的总量
152         uint256 receivedTotal;
153         mapping(address => uint256) payAmount;
154         mapping(address => bool) isWithdraw;
155     }
156 
157     uint256 public IDOIssue = 0;
158     mapping(uint256 => IDORecord) public IDODB;
159     mapping(uint256 => bool) private isCharge;
160     event IDOCreate(
161         uint256 issue,
162         address idoToken,
163         address receiveToken,
164         uint256 price,
165         uint256 maxLimit,
166         uint256 idoTotal,
167         uint256 startTime,
168         uint256 duration
169     );
170     event Staked(uint256 issue, address account, uint256 value);
171     event Withdraw(
172         uint256 issue,
173         address account,
174         uint256 idoValue,
175         uint256 backValue
176     );
177     event IDOCharge(uint256 issue, uint256 receiveValue, uint256 leftValue);
178 
179     event IDORemove(uint256 issue);
180 
181     function createIDO(
182         IBEP20 idoToken,
183         IBEP20 receiveToken,
184         uint256 price,
185         uint256 idoTotal,
186         uint256 maxLimit,
187         uint256 startTime,
188         uint256 duration
189     ) external onlyOwner {
190         require(
191             block.timestamp >
192                 IDODB[IDOIssue].startTime.add(IDODB[IDOIssue].duration),
193             "ido is not over yet."
194         );
195         require(
196             address(idoToken) != address(0),
197             "idoToken address cannot be 0"
198         );
199         require(
200             address(receiveToken) != address(0),
201             "receiveToken address cannot be 0"
202         );
203 
204         IDOIssue = IDOIssue.add(1);
205         IDORecord storage ido = IDODB[IDOIssue];
206         ido.issue = IDOIssue;
207         ido.idoToken = idoToken;
208         ido.receiveToken = receiveToken;
209         ido.price = price;
210         ido.maxLimit = maxLimit;
211         ido.idoTotal = idoTotal;
212         ido.startTime = startTime;
213         ido.duration = duration;
214 
215         idoToken.safeTransferFrom(msg.sender, address(this), idoTotal);
216         emit IDOCreate(
217             IDOIssue,
218             address(idoToken),
219             address(receiveToken),
220             price,
221             maxLimit,
222             idoTotal,
223             startTime,
224             duration
225         );
226     }
227 
228     function removeIDO() external onlyOwner {
229         require(
230             IDODB[IDOIssue].startTime > block.timestamp,
231             "There is no ido that can be deleted."
232         );
233         IDODB[IDOIssue].idoToken.safeTransfer(
234             msg.sender,
235             IDODB[IDOIssue].idoTotal
236         );
237         delete IDODB[IDOIssue];
238         emit IDORemove(IDOIssue);
239         IDOIssue = IDOIssue.sub(1);
240     }
241 
242     function chargeIDO(uint256 issue) external onlyOwner {
243         IDORecord storage record = IDODB[issue];
244         require(issue <= IDOIssue && issue > 0, "IDO that does not exist.");
245         require(!isCharge[issue], "Cannot claim repeatedly.");
246         require(
247             block.timestamp > record.startTime.add(record.duration),
248             "ido is not over yet."
249         );
250 
251         uint256 receiveValue;
252         uint256 backValue;
253 
254         isCharge[issue] = true;
255 
256         uint256 prop = record.receivedTotal.mul(1e36).div(
257             record.idoTotal.mul(record.price)
258         );
259         if (prop >= 1e18) {
260             receiveValue = record.idoTotal.mul(record.price).div(1e18);
261             record.receiveToken.safeTransfer(msg.sender, receiveValue);
262         } else {
263             receiveValue = record.receivedTotal;
264             record.receiveToken.safeTransfer(msg.sender, record.receivedTotal);
265             backValue = record.idoTotal.sub(
266                 record.idoTotal.mul(prop).div(1e18)
267             );
268             record.idoToken.safeTransfer(msg.sender, backValue);
269         }
270 
271         emit IDOCharge(issue, receiveValue, backValue);
272     }
273 
274     function stake(uint256 value) external {
275         require(IDOIssue > 0, "IDO that does not exist.");
276         IDORecord storage record = IDODB[IDOIssue];
277         require(
278             block.timestamp > record.startTime &&
279                 block.timestamp < record.startTime.add(record.duration),
280             "IDO is not in progress."
281         );
282         require(
283             record.payAmount[msg.sender].add(value) <= record.maxLimit,
284             "Limit Exceeded"
285         );
286 
287         record.payAmount[msg.sender] = record.payAmount[msg.sender].add(value);
288         record.receivedTotal = record.receivedTotal.add(value);
289         record.receiveToken.safeTransferFrom(msg.sender, address(this), value);
290         emit Staked(IDOIssue, msg.sender, value);
291     }
292 
293     function available(address account, uint256 issue)
294         public
295         view
296         returns (uint256 _idoAmount, uint256 _sendBack)
297     {
298         IDORecord storage record = IDODB[issue];
299         require(issue <= IDOIssue && issue > 0, "IDO that does not exist.");
300 
301         uint256 prop = record.receivedTotal.mul(1e36).div(
302             record.idoTotal.mul(record.price)
303         );
304 
305         if (prop > 1e18) {
306             _idoAmount = record.payAmount[account].mul(1e36).div(prop).div(
307                 record.price
308             );
309 
310             _sendBack = record.payAmount[account].sub(
311                 _idoAmount.mul(record.price).div(1e18)
312             );
313         } else {
314             _idoAmount = record.payAmount[account].mul(1e18).div(record.price);
315         }
316     }
317 
318     function userPayValue(uint256 issue, address account)
319         public
320         view
321         returns (uint256)
322     {
323         return IDODB[issue].payAmount[account];
324     }
325 
326     function isWithdraw(uint256 issue, address account)
327         public
328         view
329         returns (bool)
330     {
331         return IDODB[issue].isWithdraw[account];
332     }
333 
334     function withdraw(uint256 issue) external {
335         require(issue <= IDOIssue && issue > 0, "IDO that does not exist.");
336         IDORecord storage record = IDODB[issue];
337         require(
338             block.timestamp > IDODB[issue].startTime.add(record.duration),
339             "ido is not over yet."
340         );
341         require(!record.isWithdraw[msg.sender], "Cannot claim repeatedly.");
342 
343         uint256 idoAmount;
344         uint256 sendBack;
345 
346         record.isWithdraw[msg.sender] = true;
347 
348         (idoAmount, sendBack) = available(msg.sender, issue);
349 
350         record.idoToken.safeTransfer(msg.sender, idoAmount);
351         if (sendBack > 0) {
352             record.receiveToken.safeTransfer(msg.sender, sendBack);
353         }
354 
355         emit Withdraw(issue, msg.sender, idoAmount, sendBack);
356     }
357 }
