1 // SPDX-License-Identifier: Apache-2.0
2 pragma solidity ^0.7.0;
3 // File: contracts/Ownable.sol
4 
5 
6 
7 /// @title Ownable
8 /// @author Brecht Devos - <brecht@loopring.org>
9 /// @dev The Ownable contract has an owner address, and provides basic
10 ///      authorization control functions, this simplifies the implementation of
11 ///      "user permissions".
12 contract Ownable
13 {
14     address public owner;
15 
16     event OwnershipTransferred(
17         address indexed previousOwner,
18         address indexed newOwner
19     );
20 
21     /// @dev The Ownable constructor sets the original `owner` of the contract
22     ///      to the sender.
23     constructor()
24     {
25         owner = msg.sender;
26     }
27 
28     /// @dev Throws if called by any account other than the owner.
29     modifier onlyOwner()
30     {
31         require(msg.sender == owner, "UNAUTHORIZED");
32         _;
33     }
34 
35     /// @dev Allows the current owner to transfer control of the contract to a
36     ///      new owner.
37     /// @param newOwner The address to transfer ownership to.
38     function transferOwnership(
39         address newOwner
40         )
41         public
42         virtual
43         onlyOwner
44     {
45         require(newOwner != address(0), "ZERO_ADDRESS");
46         emit OwnershipTransferred(owner, newOwner);
47         owner = newOwner;
48     }
49 
50     function renounceOwnership()
51         public
52         onlyOwner
53     {
54         emit OwnershipTransferred(owner, address(0));
55         owner = address(0);
56     }
57 }
58 
59 // File: contracts/Claimable.sol
60 
61 
62 
63 
64 /// @title Claimable
65 /// @author Brecht Devos - <brecht@loopring.org>
66 /// @dev Extension for the Ownable contract, where the ownership needs
67 ///      to be claimed. This allows the new owner to accept the transfer.
68 contract Claimable is Ownable
69 {
70     address public pendingOwner;
71 
72     /// @dev Modifier throws if called by any account other than the pendingOwner.
73     modifier onlyPendingOwner() {
74         require(msg.sender == pendingOwner, "UNAUTHORIZED");
75         _;
76     }
77 
78     /// @dev Allows the current owner to set the pendingOwner address.
79     /// @param newOwner The address to transfer ownership to.
80     function transferOwnership(
81         address newOwner
82         )
83         public
84         override
85         onlyOwner
86     {
87         require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
88         pendingOwner = newOwner;
89     }
90 
91     /// @dev Allows the pendingOwner address to finalize the transfer.
92     function claimOwnership()
93         public
94         onlyPendingOwner
95     {
96         emit OwnershipTransferred(owner, pendingOwner);
97         owner = pendingOwner;
98         pendingOwner = address(0);
99     }
100 }
101 
102 // File: contracts/ERC20.sol
103 
104 
105 
106 /// @title ERC20 Token Interface
107 /// @dev see https://github.com/ethereum/EIPs/issues/20
108 /// @author Daniel Wang - <daniel@loopring.org>
109 abstract contract ERC20
110 {
111     function totalSupply()
112         public
113         view
114         virtual
115         returns (uint);
116 
117     function balanceOf(
118         address who
119         )
120         public
121         view
122         virtual
123         returns (uint);
124 
125     function allowance(
126         address owner,
127         address spender
128         )
129         public
130         view
131         virtual
132         returns (uint);
133 
134     function transfer(
135         address to,
136         uint value
137         )
138         public
139         virtual
140         returns (bool);
141 
142     function transferFrom(
143         address from,
144         address to,
145         uint    value
146         )
147         public
148         virtual
149         returns (bool);
150 
151     function approve(
152         address spender,
153         uint    value
154         )
155         public
156         virtual
157         returns (bool);
158 }
159 
160 // File: contracts/MathUint.sol
161 
162 
163 
164 /// @title Utility Functions for uint
165 /// @author Daniel Wang - <daniel@loopring.org>
166 library MathUint
167 {
168     function mul(
169         uint a,
170         uint b
171         )
172         internal
173         pure
174         returns (uint c)
175     {
176         c = a * b;
177         require(a == 0 || c / a == b, "MUL_OVERFLOW");
178     }
179 
180     function sub(
181         uint a,
182         uint b
183         )
184         internal
185         pure
186         returns (uint)
187     {
188         require(b <= a, "SUB_UNDERFLOW");
189         return a - b;
190     }
191 
192     function add(
193         uint a,
194         uint b
195         )
196         internal
197         pure
198         returns (uint c)
199     {
200         c = a + b;
201         require(c >= a, "ADD_OVERFLOW");
202     }
203 }
204 
205 // File: contracts/BaseTokenOwnershipPlan.sol
206 
207 
208 
209 
210 
211 
212 /// @title EmployeeTokenOwnershipPlan
213 /// @author Freeman Zhong - <kongliang@loopring.org>
214 /// added at 2021-02-19
215 abstract contract BaseTokenOwnershipPlan is Claimable
216 {
217     using MathUint for uint;
218 
219     struct Record {
220         uint lastWithdrawTime;
221         uint rewarded;
222         uint withdrawn;
223     }
224 
225     uint    public constant vestPeriod = 2 * 365 days;
226     address public constant lrcAddress = 0xBBbbCA6A901c926F240b89EacB641d8Aec7AEafD;
227 
228     uint public totalReward;
229     uint public vestStart;
230     mapping (address => Record) public records;
231 
232     event Withdrawal(
233         address indexed transactor,
234         address indexed member,
235         uint            amount
236     );
237     event MemberAddressChanged(
238         address oldAddress,
239         address newAddress
240     );
241 
242     function withdrawFor(address recipient)
243         external
244     {
245         _withdraw(recipient);
246     }
247 
248     function updateRecipient(address oldRecipient, address newRecipient)
249         external
250     {
251         require(canChangeAddressFor(oldRecipient), "UNAUTHORIZED");
252         require(newRecipient != address(0), "INVALID_ADDRESS");
253         require(records[newRecipient].rewarded == 0, "INVALID_NEW_RECIPIENT");
254 
255         Record storage r = records[oldRecipient];
256         require(r.rewarded > 0, "INVALID_OLD_RECIPIENT");
257 
258         records[newRecipient] = r;
259         delete records[oldRecipient];
260         emit MemberAddressChanged(oldRecipient, newRecipient);
261     }
262 
263     function vested(address recipient)
264         public
265         view
266         returns(uint)
267     {
268         if (block.timestamp.sub(vestStart) < vestPeriod) {
269             return records[recipient].rewarded.mul(block.timestamp.sub(vestStart)) / vestPeriod;
270         } else {
271             return records[recipient].rewarded;
272         }
273     }
274 
275     function withdrawable(address recipient)
276         public
277         view
278         returns(uint)
279     {
280         return vested(recipient).sub(records[recipient].withdrawn);
281     }
282 
283     function _withdraw(address recipient)
284         internal
285     {
286         uint amount = withdrawable(recipient);
287         require(amount > 0, "INVALID_AMOUNT");
288 
289         Record storage r = records[recipient];
290         r.lastWithdrawTime = block.timestamp;
291         r.withdrawn = r.withdrawn.add(amount);
292 
293         require(ERC20(lrcAddress).transfer(recipient, amount), "transfer failed");
294 
295         emit Withdrawal(msg.sender, recipient, amount);
296     }
297 
298     receive() external payable {
299         require(msg.value == 0, "INVALID_VALUE");
300         _withdraw(msg.sender);
301     }
302 
303     function collect()
304         external
305         onlyOwner
306     {
307         require(block.timestamp > vestStart + vestPeriod + 60 days, "TOO_EARLY");
308         uint amount = ERC20(lrcAddress).balanceOf(address(this));
309         require(ERC20(lrcAddress).transfer(msg.sender, amount), "transfer failed");
310     }
311 
312     function canChangeAddressFor(address who)
313         internal
314         view
315         virtual
316         returns (bool);
317 }
318 
319 // File: contracts/CancellableEmployeeTokenOwnershipPlan.sol
320 
321 
322 
323 
324 
325 /// @title EmployeeTokenOwnershipPlan2
326 /// added at 2021-02-14
327 /// @author Freeman Zhong - <kongliang@loopring.org>
328 contract CancellableEmployeeTokenOwnershipPlan is BaseTokenOwnershipPlan
329 {
330     using MathUint for uint;
331 
332     constructor()
333     {
334         owner = 0x96f16FdB8Cd37C02DEeb7025C1C7618E1bB34d97;
335 
336         address payable[35] memory _members = [
337             0xFF6f7B2afdd33671503705098dd3c4c26a0F0705,
338             0xf493af7DFd0e47869Aac4770B2221a259CA77Ac8,
339             0xf21e66578372Ea62BCb0D1cDfC070f231CF56898,
340             0xEBE85822e75D2B4716e228818B54154E4AfFD202,
341             0xeB4c50dF06cEb2Ea700ea127eA589A99a3aAe1Ec,
342             0xe0807d8E14F2BCbF3Cc58637259CCF3fDd1D3ce5,
343             0xD984D096B4bF9DCF5fd75D9cBaf052D00EBe74c4,
344             0xd3725C997B580E36707f73880aC006B6757b5009,
345             0xBc5F996840118B580C4452440351b601862c5672,
346             0xad05c57e06a80b8EC92383b3e10Fea0E2b4e571D,
347             0xa26cFCeCb07e401547be07eEe26E6FD608f77d1a,
348             0x933650184994CFce9D64A9F3Ed14F1Fd017fF89A,
349             0x813C12326A0E8C2aC91d584f025E50072CDb4467,
350             0x7F81D533B2ea31BE2591d89394ADD9A12499ff17,
351             0x7F6Dd0c1BeB26CFf8ABA5B020E78D7C0Ed54B8Cc,
352             0x7b3B1F252169Ff83E3E91106230c36bE672aFdE3,
353             0x7809D08edBBBC401c430e5D3862a1Fdfcb8094A2,
354             0x7154a02BA6eEaB9300D056e25f3EEA3481680f87,
355             0x650EACf9AD1576680f1af6eC6cC598A484d796Ad,
356             0x5a092E52B9b3109372B9905Fa5c0655417F0f1a5,
357             0x5a03a928b332EC269f68684A8e9c1881b4Da5f3d,
358             0x55634e271BCa62dDFb9B5f7eae19f3Ae94Fb96b7,
359             0x4c381276F4847255C675Eab90c3409FA2fce68bC,
360             0x4bA63ac57b45087d03Abfd8E98987705Fa56B1ab,
361             0x474A2F53D11c73Ef2343322d69dCAE93cd63Dd9e,
362             0x41cDd7034AD6b2a5d24397189802048E97b6532D,
363             0x33CDbeB3e060bf6973e28492BE3D469C05D32786,
364             0x2a791a837D70E6D6e35073Dd61a9Af878Ac231A5,
365             0x2234C96681E9533FDfD122baCBBc634EfbafA0F0,
366             0x21870650F40Fe8249DECc96525249a43829E9A32,
367             0x1F28F10176F89F4E9985873B84d14e75751BB3D1,
368             0x11a8632b5089c6a061760F0b03285e2cC1388E36,
369             0x10Bd72a6AfbF8860ec90f7aeCdB8e937a758f351,
370             0x07A7191de1BA70dBe875F12e744B020416a5712b,
371             0x067eceAd820BC54805A2412B06946b184d11CB4b
372         ];
373 
374         uint80[35] memory _amounts = [
375             187520 ether,
376             256002 ether,
377             538180 ether,
378             340060 ether,
379             289314 ether,
380             176782 ether,
381             308310 ether,
382             398740 ether,
383             31254 ether,
384             82284 ether,
385             435961 ether,
386             459366 ether,
387             453078 ether,
388             150296 ether,
389             500972 ether,
390             375040 ether,
391             283528 ether,
392             155765 ether,
393             316840 ether,
394             38873 ether,
395             89970 ether,
396             549381 ether,
397             150834 ether,
398             501058 ether,
399             77746 ether,
400             145641 ether,
401             173213 ether,
402             573800 ether,
403             539572 ether,
404             110258 ether,
405             58022 ether,
406             398740 ether,
407             561054 ether,
408             221724 ether,
409             485991 ether
410         ];
411 
412         uint _totalReward = 10415169 ether;
413         vestStart = block.timestamp;
414 
415         for (uint i = 0; i < _members.length; i++) {
416             require(records[_members[i]].rewarded == 0, "DUPLICATED_MEMBER");
417 
418             Record memory record = Record(block.timestamp, _amounts[i], 0);
419             records[_members[i]] = record;
420             totalReward = totalReward.add(_amounts[i]);
421         }
422         require(_totalReward == totalReward, "VALUE_MISMATCH");
423     }
424 
425     function canChangeAddressFor(address who)
426         internal
427         view
428         override
429         returns (bool) {
430         return msg.sender == who || msg.sender == owner;
431     }
432 
433 }