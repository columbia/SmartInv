1 /*
2     ___            _       ___  _                          
3     | .\ ___  _ _ <_> ___ | __><_>._ _  ___ ._ _  ___  ___ 
4     |  _// ._>| '_>| ||___|| _> | || ' |<_> || ' |/ | '/ ._>
5     |_|  \___.|_|  |_|     |_|  |_||_|_|<___||_|_|\_|_.\___.
6     
7 * PeriFinance: ProxyERC20.sol
8 *
9 * Latest source (may be newer): https://github.com/PeriFinance/periFinance/blob/master/contracts/ProxyERC20.sol
10 * Docs: Will be added in the future. /contracts/ProxyERC20
11 *
12 * Contract Dependencies: 
13 *	- IERC20
14 *	- Owned
15 *	- Proxy
16 * Libraries: (none)
17 *
18 * MIT License
19 * ===========
20 *
21 * Copyright (c) 2021 PeriFinance
22 *
23 * Permission is hereby granted, free of charge, to any person obtaining a copy
24 * of this software and associated documentation files (the "Software"), to deal
25 * in the Software without restriction, including without limitation the rights
26 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
27 * copies of the Software, and to permit persons to whom the Software is
28 * furnished to do so, subject to the following conditions:
29 *
30 * The above copyright notice and this permission notice shall be included in all
31 * copies or substantial portions of the Software.
32 *
33 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
34 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
35 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
36 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
37 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
38 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
39 */
40 
41 
42 
43 pragma solidity ^0.5.16;
44 
45 // https://docs.peri.finance/contracts/source/contracts/owned
46 contract Owned {
47     address public owner;
48     address public nominatedOwner;
49 
50     constructor(address _owner) public {
51         require(_owner != address(0), "Owner address cannot be 0");
52         owner = _owner;
53         emit OwnerChanged(address(0), _owner);
54     }
55 
56     function nominateNewOwner(address _owner) external onlyOwner {
57         nominatedOwner = _owner;
58         emit OwnerNominated(_owner);
59     }
60 
61     function acceptOwnership() external {
62         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
63         emit OwnerChanged(owner, nominatedOwner);
64         owner = nominatedOwner;
65         nominatedOwner = address(0);
66     }
67 
68     modifier onlyOwner {
69         _onlyOwner();
70         _;
71     }
72 
73     function _onlyOwner() private view {
74         require(msg.sender == owner, "Only the contract owner may perform this action");
75     }
76 
77     event OwnerNominated(address newOwner);
78     event OwnerChanged(address oldOwner, address newOwner);
79 }
80 
81 
82 // Inheritance
83 
84 
85 // Internal references
86 
87 
88 // https://docs.peri.finance/contracts/source/contracts/proxyable
89 contract Proxyable is Owned {
90     // This contract should be treated like an abstract contract
91 
92     /* The proxy this contract exists behind. */
93     Proxy public proxy;
94     Proxy public integrationProxy;
95 
96     /* The caller of the proxy, passed through to this contract.
97      * Note that every function using this member must apply the onlyProxy or
98      * optionalProxy modifiers, otherwise their invocations can use stale values. */
99     address public messageSender;
100 
101     constructor(address payable _proxy) internal {
102         // This contract is abstract, and thus cannot be instantiated directly
103         require(owner != address(0), "Owner must be set");
104 
105         proxy = Proxy(_proxy);
106         emit ProxyUpdated(_proxy);
107     }
108 
109     function setProxy(address payable _proxy) external onlyOwner {
110         proxy = Proxy(_proxy);
111         emit ProxyUpdated(_proxy);
112     }
113 
114     function setIntegrationProxy(address payable _integrationProxy) external onlyOwner {
115         integrationProxy = Proxy(_integrationProxy);
116     }
117 
118     function setMessageSender(address sender) external onlyProxy {
119         messageSender = sender;
120     }
121 
122     modifier onlyProxy {
123         _onlyProxy();
124         _;
125     }
126 
127     function _onlyProxy() private view {
128         require(Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy, "Only the proxy can call");
129     }
130 
131     modifier optionalProxy {
132         _optionalProxy();
133         _;
134     }
135 
136     function _optionalProxy() private {
137         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
138             messageSender = msg.sender;
139         }
140     }
141 
142     modifier optionalProxy_onlyOwner {
143         _optionalProxy_onlyOwner();
144         _;
145     }
146 
147     // solhint-disable-next-line func-name-mixedcase
148     function _optionalProxy_onlyOwner() private {
149         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
150             messageSender = msg.sender;
151         }
152         require(messageSender == owner, "Owner only function");
153     }
154 
155     event ProxyUpdated(address proxyAddress);
156 }
157 
158 
159 // Inheritance
160 
161 
162 // Internal references
163 
164 
165 // https://docs.peri.finance/contracts/source/contracts/proxy
166 contract Proxy is Owned {
167     Proxyable public target;
168 
169     constructor(address _owner) public Owned(_owner) {}
170 
171     function setTarget(Proxyable _target) external onlyOwner {
172         target = _target;
173         emit TargetUpdated(_target);
174     }
175 
176     function _emit(
177         bytes calldata callData,
178         uint numTopics,
179         bytes32 topic1,
180         bytes32 topic2,
181         bytes32 topic3,
182         bytes32 topic4
183     ) external onlyTarget {
184         uint size = callData.length;
185         bytes memory _callData = callData;
186 
187         assembly {
188             /* The first 32 bytes of callData contain its length (as specified by the abi).
189              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
190              * in length. It is also leftpadded to be a multiple of 32 bytes.
191              * This means moving call_data across 32 bytes guarantees we correctly access
192              * the data itself. */
193             switch numTopics
194                 case 0 {
195                     log0(add(_callData, 32), size)
196                 }
197                 case 1 {
198                     log1(add(_callData, 32), size, topic1)
199                 }
200                 case 2 {
201                     log2(add(_callData, 32), size, topic1, topic2)
202                 }
203                 case 3 {
204                     log3(add(_callData, 32), size, topic1, topic2, topic3)
205                 }
206                 case 4 {
207                     log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
208                 }
209         }
210     }
211 
212     // solhint-disable no-complex-fallback
213     function() external payable {
214         // Mutable call setting Proxyable.messageSender as this is using call not delegatecall
215         target.setMessageSender(msg.sender);
216 
217         assembly {
218             let free_ptr := mload(0x40)
219             calldatacopy(free_ptr, 0, calldatasize)
220 
221             /* We must explicitly forward ether to the underlying contract as well. */
222             let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
223             returndatacopy(free_ptr, 0, returndatasize)
224 
225             if iszero(result) {
226                 revert(free_ptr, returndatasize)
227             }
228             return(free_ptr, returndatasize)
229         }
230     }
231 
232     modifier onlyTarget {
233         require(Proxyable(msg.sender) == target, "Must be proxy target");
234         _;
235     }
236 
237     event TargetUpdated(Proxyable newTarget);
238 }
239 
240 
241 // https://docs.peri.finance/contracts/source/interfaces/ierc20
242 interface IERC20 {
243     // ERC20 Optional Views
244     function name() external view returns (string memory);
245 
246     function symbol() external view returns (string memory);
247 
248     function decimals() external view returns (uint8);
249 
250     // Views
251     function totalSupply() external view returns (uint);
252 
253     function balanceOf(address owner) external view returns (uint);
254 
255     function allowance(address owner, address spender) external view returns (uint);
256 
257     // Mutative functions
258     function transfer(address to, uint value) external returns (bool);
259 
260     function approve(address spender, uint value) external returns (bool);
261 
262     function transferFrom(
263         address from,
264         address to,
265         uint value
266     ) external returns (bool);
267 
268     // Events
269     event Transfer(address indexed from, address indexed to, uint value);
270 
271     event Approval(address indexed owner, address indexed spender, uint value);
272 }
273 
274 
275 // Inheritance
276 
277 
278 // https://docs.peri.finance/contracts/source/contracts/proxyerc20
279 contract ProxyERC20 is Proxy, IERC20 {
280     constructor(address _owner) public Proxy(_owner) {}
281 
282     // ------------- ERC20 Details ------------- //
283 
284     function name() public view returns (string memory) {
285         // Immutable static call from target contract
286         return IERC20(address(target)).name();
287     }
288 
289     function symbol() public view returns (string memory) {
290         // Immutable static call from target contract
291         return IERC20(address(target)).symbol();
292     }
293 
294     function decimals() public view returns (uint8) {
295         // Immutable static call from target contract
296         return IERC20(address(target)).decimals();
297     }
298 
299     // ------------- ERC20 Interface ------------- //
300 
301     /**
302      * @dev Total number of tokens in existence
303      */
304     function totalSupply() public view returns (uint256) {
305         // Immutable static call from target contract
306         return IERC20(address(target)).totalSupply();
307     }
308 
309     /**
310      * @dev Gets the balance of the specified address.
311      * @param account The address to query the balance of.
312      * @return An uint256 representing the amount owned by the passed address.
313      */
314     function balanceOf(address account) public view returns (uint256) {
315         // Immutable static call from target contract
316         return IERC20(address(target)).balanceOf(account);
317     }
318 
319     /**
320      * @dev Function to check the amount of tokens that an owner allowed to a spender.
321      * @param owner address The address which owns the funds.
322      * @param spender address The address which will spend the funds.
323      * @return A uint256 specifying the amount of tokens still available for the spender.
324      */
325     function allowance(address owner, address spender) public view returns (uint256) {
326         // Immutable static call from target contract
327         return IERC20(address(target)).allowance(owner, spender);
328     }
329 
330     /**
331      * @dev Transfer token for a specified address
332      * @param to The address to transfer to.
333      * @param value The amount to be transferred.
334      */
335     function transfer(address to, uint256 value) public returns (bool) {
336         // Mutable state call requires the proxy to tell the target who the msg.sender is.
337         target.setMessageSender(msg.sender);
338 
339         // Forward the ERC20 call to the target contract
340         IERC20(address(target)).transfer(to, value);
341 
342         // Event emitting will occur via PeriFinance.Proxy._emit()
343         return true;
344     }
345 
346     /**
347      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
348      * Beware that changing an allowance with this method brings the risk that someone may use both the old
349      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
350      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
351      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
352      * @param spender The address which will spend the funds.
353      * @param value The amount of tokens to be spent.
354      */
355     function approve(address spender, uint256 value) public returns (bool) {
356         // Mutable state call requires the proxy to tell the target who the msg.sender is.
357         target.setMessageSender(msg.sender);
358 
359         // Forward the ERC20 call to the target contract
360         IERC20(address(target)).approve(spender, value);
361 
362         // Event emitting will occur via PeriFinance.Proxy._emit()
363         return true;
364     }
365 
366     /**
367      * @dev Transfer tokens from one address to another
368      * @param from address The address which you want to send tokens from
369      * @param to address The address which you want to transfer to
370      * @param value uint256 the amount of tokens to be transferred
371      */
372     function transferFrom(
373         address from,
374         address to,
375         uint256 value
376     ) public returns (bool) {
377         // Mutable state call requires the proxy to tell the target who the msg.sender is.
378         target.setMessageSender(msg.sender);
379 
380         // Forward the ERC20 call to the target contract
381         IERC20(address(target)).transferFrom(from, to, value);
382 
383         // Event emitting will occur via PeriFinance.Proxy._emit()
384         return true;
385     }
386 }