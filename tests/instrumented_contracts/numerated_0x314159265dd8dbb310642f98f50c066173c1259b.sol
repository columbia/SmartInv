1 ;;; --------------------------------------------------------------------------- 
2 ;;; @title The Ethereum Name Service registry. 
3 ;;; @author Daniel Ellison <daniel@syrinx.net> 
4  
5 (seq 
6  
7   ;; -------------------------------------------------------------------------- 
8   ;; Constant definitions. 
9  
10   ;; Memory layout. 
11   (def 'node-bytes  0x00) 
12   (def 'label-bytes 0x20) 
13   (def 'call-result 0x40) 
14  
15   ;; Struct: Record 
16   (def 'resolver 0x00) ; address 
17   (def 'owner    0x20) ; address 
18   (def 'ttl      0x40) ; uint64 
19  
20   ;; Precomputed function IDs. 
21   (def 'get-node-owner    0x02571be3) ; owner(bytes32) 
22   (def 'get-node-resolver 0x0178b8bf) ; resolver(bytes32) 
23   (def 'get-node-ttl      0x16a25cbd) ; ttl(bytes32) 
24   (def 'set-node-owner    0x5b0fc9c3) ; setOwner(bytes32,address) 
25   (def 'set-subnode-owner 0x06ab5923) ; setSubnodeOwner(bytes32,bytes32,address) 
26   (def 'set-node-resolver 0x1896f70a) ; setResolver(bytes32,address) 
27   (def 'set-node-ttl      0x14ab9038) ; setTTL(bytes32,uint64) 
28  
29   ;; Jumping here causes an EVM error. 
30   (def 'invalid-location 0x02) 
31  
32   ;; -------------------------------------------------------------------------- 
33   ;; @notice Shifts the leftmost 4 bytes of a 32-byte number right by 28 bytes. 
34   ;; @param input A 32-byte number. 
35  
36   (def 'shift-right (input) 
37     (div input (exp 2 224))) 
38  
39   ;; -------------------------------------------------------------------------- 
40   ;; @notice Determines whether the supplied function ID matches a known 
41   ;;         function hash and executes <code-body> if so. 
42   ;; @dev The function ID is in the leftmost four bytes of the call data. 
43   ;; @param function-hash The four-byte hash of a known function signature. 
44   ;; @param code-body The code to run in the case of a match. 
45  
46   (def 'function (function-hash code-body) 
47     (when (= (shift-right (calldataload 0x00)) function-hash) 
48       code-body)) 
49  
50   ;; -------------------------------------------------------------------------- 
51   ;; @notice Calculates record location for the node and label passed in. 
52   ;; @param node The parent node. 
53   ;; @param label The hash of the subnode label. 
54  
55   (def 'get-record (node label) 
56     (seq 
57       (mstore node-bytes node) 
58       (mstore label-bytes label) 
59       (sha3 node-bytes 64))) 
60  
61   ;; -------------------------------------------------------------------------- 
62   ;; @notice Retrieves owner from node record. 
63   ;; @param node Get owner of this node. 
64  
65   (def 'get-owner (node) 
66     (sload (+ node owner))) 
67  
68   ;; -------------------------------------------------------------------------- 
69   ;; @notice Stores new owner in node record. 
70   ;; @param node Set owner of this node. 
71   ;; @param new-owner New owner of this node. 
72  
73   (def 'set-owner (node new-owner) 
74     (sstore (+ node owner) new-owner)) 
75  
76   ;; -------------------------------------------------------------------------- 
77   ;; @notice Stores new subnode owner in node record. 
78   ;; @param node Set owner of this node. 
79   ;; @param label The hash of the label specifying the subnode. 
80   ;; @param new-owner New owner of the subnode. 
81  
82   (def 'set-subowner (node label new-owner) 
83     (sstore (+ (get-record node label) owner) new-owner)) 
84  
85   ;; -------------------------------------------------------------------------- 
86   ;; @notice Retrieves resolver from node record. 
87   ;; @param node Get resolver of this node. 
88  
89   (def 'get-resolver (node) 
90     (sload node)) 
91  
92   ;; -------------------------------------------------------------------------- 
93   ;; @notice Stores new resolver in node record. 
94   ;; @param node Set resolver of this node. 
95   ;; @param new-resolver New resolver for this node. 
96  
97   (def 'set-resolver (node new-resolver) 
98     (sstore node new-resolver)) 
99  
100   ;; -------------------------------------------------------------------------- 
101   ;; @notice Retrieves TTL From node record. 
102   ;; @param node Get TTL of this node. 
103  
104   (def 'get-ttl (node) 
105     (sload (+ node ttl))) 
106  
107   ;; -------------------------------------------------------------------------- 
108   ;; @notice Stores new TTL in node record. 
109   ;; @param node Set TTL of this node. 
110   ;; @param new-resolver New TTL for this node. 
111  
112   (def 'set-ttl (node new-ttl) 
113     (sstore (+ node ttl) new-ttl)) 
114  
115   ;; -------------------------------------------------------------------------- 
116   ;; @notice Checks that the caller is the node owner. 
117   ;; @param node Check owner of this node. 
118  
119   (def 'only-node-owner (node) 
120     (when (!= (caller) (get-owner node)) 
121       (jump invalid-location))) 
122  
123   ;; -------------------------------------------------------------------------- 
124   ;; INIT 
125  
126   ;; Set the owner of the root node (0x00) to the deploying account. 
127   (set-owner 0x00 (caller)) 
128  
129   ;; -------------------------------------------------------------------------- 
130   ;; CODE 
131  
132   (returnlll 
133     (seq 
134  
135       ;; ---------------------------------------------------------------------- 
136       ;; @notice Returns the address of the resolver for the specified node. 
137       ;; @dev Signature: resolver(bytes32) 
138       ;; @param node Return this node's resolver. 
139       ;; @return The associated resolver. 
140  
141       (def 'node (calldataload 0x04)) 
142  
143       (function get-node-resolver 
144         (seq 
145  
146           ;; Get the node's resolver and save it. 
147           (mstore call-result (get-resolver node)) 
148  
149           ;; Return result. 
150           (return call-result 32))) 
151  
152       ;; ---------------------------------------------------------------------- 
153       ;; @notice Returns the address that owns the specified node. 
154       ;; @dev Signature: owner(bytes32) 
155       ;; @param node Return this node's owner. 
156       ;; @return The associated address. 
157  
158       (def 'node (calldataload 0x04)) 
159  
160       (function get-node-owner 
161         (seq 
162  
163           ;; Get the node's owner and save it. 
164           (mstore call-result (get-owner node)) 
165  
166           ;; Return result. 
167           (return call-result 32))) 
168  
169       ;; ---------------------------------------------------------------------- 
170       ;; @notice Returns the TTL of a node and any records associated with it. 
171       ;; @dev Signature: ttl(bytes32) 
172       ;; @param node Return this node's TTL. 
173       ;; @return The node's TTL. 
174  
175       (def 'node (calldataload 0x04)) 
176  
177       (function get-node-ttl 
178         (seq 
179  
180           ;; Get the node's TTL and save it. 
181           (mstore call-result (get-ttl node)) 
182  
183           ;; Return result. 
184           (return call-result 32))) 
185  
186       ;; ---------------------------------------------------------------------- 
187       ;; @notice Transfers ownership of a node to a new address. May only be 
188       ;;         called by the current owner of the node. 
189       ;; @dev Signature: setOwner(bytes32,address) 
190       ;; @param node The node to transfer ownership of. 
191       ;; @param new-owner The address of the new owner. 
192  
193       (def 'node (calldataload 0x04)) 
194       (def 'new-owner (calldataload 0x24)) 
195  
196       (function set-node-owner 
197         (seq (only-node-owner node) 
198  
199           ;; Transfer ownership by storing passed-in address. 
200           (set-owner node new-owner) 
201  
202           ;; Emit an event about the transfer. 
203           ;; Transfer(bytes32 indexed node, address owner); 
204           (mstore call-result new-owner) 
205           (log2 call-result 32 
206               (sha3 0x00 (lit 0x00 "Transfer(bytes32,address)")) node) 
207  
208           ;; Nothing to return. 
209           (stop))) 
210  
211       ;; ---------------------------------------------------------------------- 
212       ;; @notice Transfers ownership of a subnode to a new address. May only be 
213       ;;         called by the owner of the parent node. 
214       ;; @dev Signature: setSubnodeOwner(bytes32,bytes32,address) 
215       ;; @param node The parent node. 
216       ;; @param label The hash of the label specifying the subnode. 
217       ;; @param new-owner The address of the new owner. 
218  
219       (def 'node (calldataload 0x04)) 
220       (def 'label (calldataload 0x24)) 
221       (def 'new-owner (calldataload 0x44)) 
222  
223       (function set-subnode-owner 
224         (seq (only-node-owner node) 
225  
226           ;; Transfer ownership by storing passed-in address. 
227           (set-subowner node label new-owner) 
228  
229           ;; Emit an event about the transfer. 
230           ;; NewOwner(bytes32 indexed node, bytes32 indexed label, address owner); 
231           (mstore call-result new-owner) 
232           (log3 call-result 32 
233               (sha3 0x00 (lit 0x00 "NewOwner(bytes32,bytes32,address)")) 
234               node label) 
235  
236           ;; Nothing to return. 
237           (stop))) 
238  
239       ;; ---------------------------------------------------------------------- 
240       ;; @notice Sets the resolver address for the specified node. 
241       ;; @dev Signature: setResolver(bytes32,address) 
242       ;; @param node The node to update. 
243       ;; @param new-resolver The address of the resolver. 
244  
245       (def 'node (calldataload 0x04)) 
246       (def 'new-resolver (calldataload 0x24)) 
247  
248       (function set-node-resolver 
249         (seq (only-node-owner node) 
250  
251           ;; Transfer ownership by storing passed-in address. 
252           (set-resolver node new-resolver) 
253  
254           ;; Emit an event about the change of resolver. 
255           ;; NewResolver(bytes32 indexed node, address resolver); 
256           (mstore call-result new-resolver) 
257           (log2 call-result 32 
258               (sha3 0x00 (lit 0x00 "NewResolver(bytes32,address)")) node) 
259  
260           ;; Nothing to return. 
261           (stop))) 
262  
263       ;; ---------------------------------------------------------------------- 
264       ;; @notice Sets the TTL for the specified node. 
265       ;; @dev Signature: setTTL(bytes32,uint64) 
266       ;; @param node The node to update. 
267       ;; @param ttl The TTL in seconds. 
268  
269       (def 'node (calldataload 0x04)) 
270       (def 'new-ttl (calldataload 0x24)) 
271  
272       (function set-node-ttl 
273         (seq (only-node-owner node) 
274  
275           ;; Set new TTL by storing passed-in time. 
276           (set-ttl node new-ttl) 
277  
278           ;; Emit an event about the change of TTL. 
279           ;; NewTTL(bytes32 indexed node, uint64 ttl); 
280           (mstore call-result new-ttl) 
281           (log2 call-result 32 
282               (sha3 0x00 (lit 0x00 "NewTTL(bytes32,uint64)")) node) 
283  
284           ;; Nothing to return. 
285           (stop))) 
286  
287       ;; ---------------------------------------------------------------------- 
288       ;; @notice Fallback: No functions matched the function ID provided. 
289  
290       (jump invalid-location))) 
291  
292 )