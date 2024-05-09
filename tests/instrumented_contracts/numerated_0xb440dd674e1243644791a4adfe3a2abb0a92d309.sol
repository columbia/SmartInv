1 /* ===============================================
2 * Flattened with Solidifier by Coinage
3 * 
4 * https://solidifier.coina.ge
5 * ===============================================
6 */
7 
8 
9 /*
10 -----------------------------------------------------------------
11 FILE INFORMATION
12 -----------------------------------------------------------------
13 
14 file:       Owned.sol
15 version:    1.1
16 author:     Anton Jurisevic
17             Dominic Romanowski
18 
19 date:       2018-2-26
20 
21 -----------------------------------------------------------------
22 MODULE DESCRIPTION
23 -----------------------------------------------------------------
24 
25 An Owned contract, to be inherited by other contracts.
26 Requires its owner to be explicitly set in the constructor.
27 Provides an onlyOwner access modifier.
28 
29 To change owner, the current owner must nominate the next owner,
30 who then has to accept the nomination. The nomination can be
31 cancelled before it is accepted by the new owner by having the
32 previous owner change the nomination (setting it to 0).
33 
34 -----------------------------------------------------------------
35 */
36 
37 pragma solidity 0.4.25;
38 
39 /**
40  * @title A contract with an owner.
41  * @notice Contract ownership can be transferred by first nominating the new owner,
42  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
43  */
44 contract Owned {
45     address public owner;
46     address public nominatedOwner;
47 
48     /**
49      * @dev Owned Constructor
50      */
51     constructor(address _owner)
52         public
53     {
54         require(_owner != address(0), "Owner address cannot be 0");
55         owner = _owner;
56         emit OwnerChanged(address(0), _owner);
57     }
58 
59     /**
60      * @notice Nominate a new owner of this contract.
61      * @dev Only the current owner may nominate a new owner.
62      */
63     function nominateNewOwner(address _owner)
64         external
65         onlyOwner
66     {
67         nominatedOwner = _owner;
68         emit OwnerNominated(_owner);
69     }
70 
71     /**
72      * @notice Accept the nomination to be owner.
73      */
74     function acceptOwnership()
75         external
76     {
77         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
78         emit OwnerChanged(owner, nominatedOwner);
79         owner = nominatedOwner;
80         nominatedOwner = address(0);
81     }
82 
83     modifier onlyOwner
84     {
85         require(msg.sender == owner, "Only the contract owner may perform this action");
86         _;
87     }
88 
89     event OwnerNominated(address newOwner);
90     event OwnerChanged(address oldOwner, address newOwner);
91 }
92 
93 
94 /*
95 -----------------------------------------------------------------
96 FILE INFORMATION
97 -----------------------------------------------------------------
98 
99 file:       Proxyable.sol
100 version:    1.1
101 author:     Anton Jurisevic
102 
103 date:       2018-05-15
104 
105 checked:    Mike Spain
106 approved:   Samuel Brooks
107 
108 -----------------------------------------------------------------
109 MODULE DESCRIPTION
110 -----------------------------------------------------------------
111 
112 A proxyable contract that works hand in hand with the Proxy contract
113 to allow for anyone to interact with the underlying contract both
114 directly and through the proxy.
115 
116 -----------------------------------------------------------------
117 */
118 
119 
120 // This contract should be treated like an abstract contract
121 contract Proxyable is Owned {
122     /* The proxy this contract exists behind. */
123     Proxy public proxy;
124 
125     /* The caller of the proxy, passed through to this contract.
126      * Note that every function using this member must apply the onlyProxy or
127      * optionalProxy modifiers, otherwise their invocations can use stale values. */ 
128     address messageSender; 
129 
130     constructor(address _proxy, address _owner)
131         Owned(_owner)
132         public
133     {
134         proxy = Proxy(_proxy);
135         emit ProxyUpdated(_proxy);
136     }
137 
138     function setProxy(address _proxy)
139         external
140         onlyOwner
141     {
142         proxy = Proxy(_proxy);
143         emit ProxyUpdated(_proxy);
144     }
145 
146     function setMessageSender(address sender)
147         external
148         onlyProxy
149     {
150         messageSender = sender;
151     }
152 
153     modifier onlyProxy {
154         require(Proxy(msg.sender) == proxy, "Only the proxy can call this function");
155         _;
156     }
157 
158     modifier optionalProxy
159     {
160         if (Proxy(msg.sender) != proxy) {
161             messageSender = msg.sender;
162         }
163         _;
164     }
165 
166     modifier optionalProxy_onlyOwner
167     {
168         if (Proxy(msg.sender) != proxy) {
169             messageSender = msg.sender;
170         }
171         require(messageSender == owner, "This action can only be performed by the owner");
172         _;
173     }
174 
175     event ProxyUpdated(address proxyAddress);
176 }
177 
178 
179 /*
180 -----------------------------------------------------------------
181 FILE INFORMATION
182 -----------------------------------------------------------------
183 
184 file:       Proxy.sol
185 version:    1.3
186 author:     Anton Jurisevic
187 
188 date:       2018-05-29
189 
190 -----------------------------------------------------------------
191 MODULE DESCRIPTION
192 -----------------------------------------------------------------
193 
194 A proxy contract that, if it does not recognise the function
195 being called on it, passes all value and call data to an
196 underlying target contract.
197 
198 This proxy has the capacity to toggle between DELEGATECALL
199 and CALL style proxy functionality.
200 
201 The former executes in the proxy's context, and so will preserve 
202 msg.sender and store data at the proxy address. The latter will not.
203 Therefore, any contract the proxy wraps in the CALL style must
204 implement the Proxyable interface, in order that it can pass msg.sender
205 into the underlying contract as the state parameter, messageSender.
206 
207 -----------------------------------------------------------------
208 */
209 
210 
211 contract Proxy is Owned {
212 
213     Proxyable public target;
214     bool public useDELEGATECALL;
215 
216     constructor(address _owner)
217         Owned(_owner)
218         public
219     {}
220 
221     function setTarget(Proxyable _target)
222         external
223         onlyOwner
224     {
225         target = _target;
226         emit TargetUpdated(_target);
227     }
228 
229     function setUseDELEGATECALL(bool value) 
230         external
231         onlyOwner
232     {
233         useDELEGATECALL = value;
234     }
235 
236     function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)
237         external
238         onlyTarget
239     {
240         uint size = callData.length;
241         bytes memory _callData = callData;
242 
243         assembly {
244             /* The first 32 bytes of callData contain its length (as specified by the abi). 
245              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
246              * in length. It is also leftpadded to be a multiple of 32 bytes.
247              * This means moving call_data across 32 bytes guarantees we correctly access
248              * the data itself. */
249             switch numTopics
250             case 0 {
251                 log0(add(_callData, 32), size)
252             } 
253             case 1 {
254                 log1(add(_callData, 32), size, topic1)
255             }
256             case 2 {
257                 log2(add(_callData, 32), size, topic1, topic2)
258             }
259             case 3 {
260                 log3(add(_callData, 32), size, topic1, topic2, topic3)
261             }
262             case 4 {
263                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
264             }
265         }
266     }
267 
268     function()
269         external
270         payable
271     {
272         if (useDELEGATECALL) {
273             assembly {
274                 /* Copy call data into free memory region. */
275                 let free_ptr := mload(0x40)
276                 calldatacopy(free_ptr, 0, calldatasize)
277 
278                 /* Forward all gas and call data to the target contract. */
279                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
280                 returndatacopy(free_ptr, 0, returndatasize)
281 
282                 /* Revert if the call failed, otherwise return the result. */
283                 if iszero(result) { revert(free_ptr, returndatasize) }
284                 return(free_ptr, returndatasize)
285             }
286         } else {
287             /* Here we are as above, but must send the messageSender explicitly 
288              * since we are using CALL rather than DELEGATECALL. */
289             target.setMessageSender(msg.sender);
290             assembly {
291                 let free_ptr := mload(0x40)
292                 calldatacopy(free_ptr, 0, calldatasize)
293 
294                 /* We must explicitly forward ether to the underlying contract as well. */
295                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
296                 returndatacopy(free_ptr, 0, returndatasize)
297 
298                 if iszero(result) { revert(free_ptr, returndatasize) }
299                 return(free_ptr, returndatasize)
300             }
301         }
302     }
303 
304     modifier onlyTarget {
305         require(Proxyable(msg.sender) == target, "Must be proxy target");
306         _;
307     }
308 
309     event TargetUpdated(Proxyable newTarget);
310 }
311 
