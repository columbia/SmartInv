1 /*
2 
3   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9   http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 */
17 pragma solidity ^0.6.6;
18 
19 /*
20 
21   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
22 
23   Licensed under the Apache License, Version 2.0 (the "License");
24   you may not use this file except in compliance with the License.
25   You may obtain a copy of the License at
26 
27   http://www.apache.org/licenses/LICENSE-2.0
28 
29   Unless required by applicable law or agreed to in writing, software
30   distributed under the License is distributed on an "AS IS" BASIS,
31   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
32   See the License for the specific language governing permissions and
33   limitations under the License.
34 */
35 
36 
37 /*
38 
39   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
40 
41   Licensed under the Apache License, Version 2.0 (the "License");
42   you may not use this file except in compliance with the License.
43   You may obtain a copy of the License at
44 
45   http://www.apache.org/licenses/LICENSE-2.0
46 
47   Unless required by applicable law or agreed to in writing, software
48   distributed under the License is distributed on an "AS IS" BASIS,
49   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
50   See the License for the specific language governing permissions and
51   limitations under the License.
52 */
53 
54 
55 
56 /// @title Ownable
57 /// @author Brecht Devos - <brecht@loopring.org>
58 /// @dev The Ownable contract has an owner address, and provides basic
59 ///      authorization control functions, this simplifies the implementation of
60 ///      "user permissions".
61 contract Ownable
62 {
63     address public owner;
64 
65     event OwnershipTransferred(
66         address indexed previousOwner,
67         address indexed newOwner
68     );
69 
70     /// @dev The Ownable constructor sets the original `owner` of the contract
71     ///      to the sender.
72     constructor()
73         public
74     {
75         owner = msg.sender;
76     }
77 
78     /// @dev Throws if called by any account other than the owner.
79     modifier onlyOwner()
80     {
81         require(msg.sender == owner, "UNAUTHORIZED");
82         _;
83     }
84 
85     /// @dev Allows the current owner to transfer control of the contract to a
86     ///      new owner.
87     /// @param newOwner The address to transfer ownership to.
88     function transferOwnership(
89         address newOwner
90         )
91         public
92         virtual
93         onlyOwner
94     {
95         require(newOwner != address(0), "ZERO_ADDRESS");
96         emit OwnershipTransferred(owner, newOwner);
97         owner = newOwner;
98     }
99 
100     function renounceOwnership()
101         public
102         onlyOwner
103     {
104         emit OwnershipTransferred(owner, address(0));
105         owner = address(0);
106     }
107 }
108 
109 
110 
111 /// @title Claimable
112 /// @author Brecht Devos - <brecht@loopring.org>
113 /// @dev Extension for the Ownable contract, where the ownership needs
114 ///      to be claimed. This allows the new owner to accept the transfer.
115 contract Claimable is Ownable
116 {
117     address public pendingOwner;
118 
119     /// @dev Modifier throws if called by any account other than the pendingOwner.
120     modifier onlyPendingOwner() {
121         require(msg.sender == pendingOwner, "UNAUTHORIZED");
122         _;
123     }
124 
125     /// @dev Allows the current owner to set the pendingOwner address.
126     /// @param newOwner The address to transfer ownership to.
127     function transferOwnership(
128         address newOwner
129         )
130         public
131         override
132         onlyOwner
133     {
134         require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
135         pendingOwner = newOwner;
136     }
137 
138     /// @dev Allows the pendingOwner address to finalize the transfer.
139     function claimOwnership()
140         public
141         onlyPendingOwner
142     {
143         emit OwnershipTransferred(owner, pendingOwner);
144         owner = pendingOwner;
145         pendingOwner = address(0);
146     }
147 }
148 
149 /*
150 
151   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
152 
153   Licensed under the Apache License, Version 2.0 (the "License");
154   you may not use this file except in compliance with the License.
155   You may obtain a copy of the License at
156 
157   http://www.apache.org/licenses/LICENSE-2.0
158 
159   Unless required by applicable law or agreed to in writing, software
160   distributed under the License is distributed on an "AS IS" BASIS,
161   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
162   See the License for the specific language governing permissions and
163   limitations under the License.
164 */
165 
166 
167 
168 /// @title ERC20 Token Interface
169 /// @dev see https://github.com/ethereum/EIPs/issues/20
170 /// @author Daniel Wang - <daniel@loopring.org>
171 abstract contract ERC20
172 {
173     function totalSupply()
174         public
175         view
176         virtual
177         returns (uint);
178 
179     function balanceOf(
180         address who
181         )
182         public
183         view
184         virtual
185         returns (uint);
186 
187     function allowance(
188         address owner,
189         address spender
190         )
191         public
192         view
193         virtual
194         returns (uint);
195 
196     function transfer(
197         address to,
198         uint value
199         )
200         public
201         virtual
202         returns (bool);
203 
204     function transferFrom(
205         address from,
206         address to,
207         uint    value
208         )
209         public
210         virtual
211         returns (bool);
212 
213     function approve(
214         address spender,
215         uint    value
216         )
217         public
218         virtual
219         returns (bool);
220 }
221 
222 /*
223 
224   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
225 
226   Licensed under the Apache License, Version 2.0 (the "License");
227   you may not use this file except in compliance with the License.
228   You may obtain a copy of the License at
229 
230   http://www.apache.org/licenses/LICENSE-2.0
231 
232   Unless required by applicable law or agreed to in writing, software
233   distributed under the License is distributed on an "AS IS" BASIS,
234   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
235   See the License for the specific language governing permissions and
236   limitations under the License.
237 */
238 
239 
240 
241 /// @title Utility Functions for uint
242 /// @author Daniel Wang - <daniel@loopring.org>
243 library MathUint
244 {
245     function mul(
246         uint a,
247         uint b
248         )
249         internal
250         pure
251         returns (uint c)
252     {
253         c = a * b;
254         require(a == 0 || c / a == b, "MUL_OVERFLOW");
255     }
256 
257     function sub(
258         uint a,
259         uint b
260         )
261         internal
262         pure
263         returns (uint)
264     {
265         require(b <= a, "SUB_UNDERFLOW");
266         return a - b;
267     }
268 
269     function add(
270         uint a,
271         uint b
272         )
273         internal
274         pure
275         returns (uint c)
276     {
277         c = a + b;
278         require(c >= a, "ADD_OVERFLOW");
279     }
280 }
281 
282 
283 
284 /// @title EmployeeTokenOwnershipPlan
285 /// @author Freeman Zhong - <kongliang@loopring.org>
286 contract EmployeeTokenOwnershipPlan is Claimable
287 {
288     using MathUint for uint;
289 
290     struct Record {
291         uint lastWithdrawTime;
292         uint rewarded;
293         uint withdrawn;
294     }
295 
296     uint    public constant vestPeriod = 2 * 365 days;
297     address public constant lrcAddress = 0xBBbbCA6A901c926F240b89EacB641d8Aec7AEafD;
298 
299     uint public totalReward;
300     uint public vestStart;
301     mapping (address => Record) public records;
302 
303     event Withdrawal(
304         address indexed transactor,
305         address indexed member,
306         uint            amount
307     );
308 
309     constructor() public
310     {
311         owner = 0x96f16FdB8Cd37C02DEeb7025C1C7618E1bB34d97;
312 
313         address payable[28] memory _members = [
314             0x056757881C358b8E1A3Cc6374f2cb545c587d3FA,
315             0x1fcBAb8012177540fb8e121d0073f81219Fc828E,
316             0xe865759DF485c11070504e76B900938D2d9A7738,
317             0x51cDF96c9b6EC28A0241c4Be433854bd3dc0bc79,
318             0xb18768c26f0922056b3550a24f421618Fe12D126,
319             0x2Ff7eD213B4E5Cf813048d3fBC50E77BA80B26B0,
320             0xd3725C997B580E36707f73880aC006B6757b5009,
321             0x522c9A3e5857a58373F072e127F00F7dac6D6969,
322             0x45a98C1B46d8a1D5c4cC52Cc18a4569b27F61939,
323             0xBe4C1cb10C2Be76798c4186ADbbC34356b358b52,
324             0x8db15c6883B61588C54961f1401CC71C6206Fe38,
325             0x6b1029C9AE8Aa5EEA9e045E8ba3C93d380D5BDDa,
326             0x95C6E2D5EAD1Aa2a5aAab33d735739c82D623C88,
327             0x07A7191de1BA70dBe875F12e744B020416a5712b,
328             0x59962c3078852Ff7757babf525F90CDffD3FdDf0,
329             0x7154a02BA6eEaB9300D056e25f3EEA3481680f87,
330             0x2bbFe5650e9876fb313D6b32352c6Dc5966A7B68,
331             0xB63b22F3dDcC7f469BCb757a5b64a3848f4c4f03,
332             0x378d6578Bb1F1C36914C64Ba267613393Aba2666,
333             0x3AC6061A50b8145b54b76Be9CF485c80DFF20589,
334             0x8d26A876917e79916E70e23b34A23aC91EC5E591,
335             0xebFF93D8ac49C037519e84a075bf231023224ddC,
336             0x63830F62C44BE28703B66e5679A42eBED1d48C8a,
337             0x0C3499a325B47b5950F731263fEA144AC95f6bbb,
338             0x64F2741920b7df046b7fE8df2e6b0bEad2452bea,
339             0x4f90c157CdA2856dB9780BafE13ccECB569cC74a,
340             0x2a14Ae2411B6D681c48781037F15f2610034ebFb,
341             0xd888B723b8C6BBA8b27ea9B0690094B3b564F618
342         ];
343 
344         uint88[28] memory _amounts = [
345             // pool 2 + pool 1
346             (5000000 ether + 2209239 ether),
347             (5000000 ether +  441848 ether),
348             (5000000 ether +       0),
349             (5000000 ether + 1767391 ether),
350             (1491300 ether + 1546467 ether),
351             (1491300 ether + 1215081 ether),
352             (1491300 ether +  883696 ether),
353             (1491300 ether +       0),
354             (1118400 ether +  883696 ether),
355             (1118400 ether +  883696 ether),
356             (1118400 ether +  331386 ether),
357             (1118400 ether +       0),
358             (1306600 ether + 1546467 ether),
359             (1006600 ether +  441848 ether),
360             ( 560000 ether +  331386 ether),
361             ( 248500 ether +  191099 ether),
362             ( 248500 ether +       0),
363             (      0 + 1325543 ether),
364             (      0 + 1104619 ether),
365             (      0 +  441848 ether),
366             (      0 +  331386 ether),
367             (      0 +  331386 ether),
368             (      0 +  331386 ether),
369             (      0 +  331386 ether),
370             (      0 +  331386 ether),
371             (      0 +  331386 ether),
372             (      0 +  110462 ether),
373             (      0 + 4546912 ether)
374         ];
375 
376         uint _totalReward = 56000000 ether;
377         vestStart = now;
378 
379         for (uint i = 0; i < _members.length; i++) {
380             Record memory record = Record(now, _amounts[i], 0);
381             records[_members[i]] = record;
382             totalReward = totalReward.add(_amounts[i]);
383         }
384         require(_totalReward == totalReward, "VALUE_MISMATCH");
385     }
386 
387     function withdrawFor(address recipient)
388         external
389     {
390         _withdraw(recipient);
391     }
392 
393     function vested(address recipient)
394         public
395         view
396         returns(uint)
397     {
398         return records[recipient].rewarded.mul(now.sub(vestStart)) / vestPeriod;
399     }
400 
401     function withdrawable(address recipient)
402         public
403         view
404         returns(uint)
405     {
406         return vested(recipient).sub(records[recipient].withdrawn);
407     }
408 
409     function _withdraw(address recipient)
410         internal
411     {
412         uint amount = withdrawable(recipient);
413         require(amount > 0, "INVALID_AMOUNT");
414 
415         Record storage r = records[recipient];
416         r.lastWithdrawTime = now;
417         r.withdrawn = r.withdrawn.add(amount);
418 
419         require(ERC20(lrcAddress).transfer(recipient, amount), "transfer failed");
420 
421         emit Withdrawal(msg.sender, recipient, amount);
422     }
423 
424     receive() external payable {
425         require(msg.value == 0, "INVALID_VALUE");
426         _withdraw(msg.sender);
427     }
428 
429     function collect()
430         external
431         onlyOwner
432     {
433         require(now > vestStart + vestPeriod + 60 days, "TOO_EARLY");
434         uint amount = ERC20(lrcAddress).balanceOf(address(this));
435         require(ERC20(lrcAddress).transfer(msg.sender, amount), "transfer failed");
436     }
437 }