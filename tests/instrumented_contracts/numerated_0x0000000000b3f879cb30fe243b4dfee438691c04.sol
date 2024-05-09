1 pragma solidity ^0.4.10;
2 
3 contract GasToken2 {
4     //////////////////////////////////////////////////////////////////////////
5     // RLP.sol
6     // Due to some unexplained bug, we get a slightly different bytecode if 
7     // we use an import, and are then unable to verify the code in Etherscan
8     //////////////////////////////////////////////////////////////////////////
9     
10     uint256 constant ADDRESS_BYTES = 20;
11     uint256 constant MAX_SINGLE_BYTE = 128;
12     uint256 constant MAX_NONCE = 256**9 - 1;
13 
14     // count number of bytes required to represent an unsigned integer
15     function count_bytes(uint256 n) constant internal returns (uint256 c) {
16         uint i = 0;
17         uint mask = 1;
18         while (n >= mask) {
19             i += 1;
20             mask *= 256;
21         }
22 
23         return i;
24     }
25 
26     function mk_contract_address(address a, uint256 n) constant internal returns (address rlp) {
27         /*
28          * make sure the RLP encoding fits in one word:
29          * total_length      1 byte
30          * address_length    1 byte
31          * address          20 bytes
32          * nonce_length      1 byte (or 0)
33          * nonce           1-9 bytes
34          *                ==========
35          *                24-32 bytes
36          */
37         require(n <= MAX_NONCE);
38 
39         // number of bytes required to write down the nonce
40         uint256 nonce_bytes;
41         // length in bytes of the RLP encoding of the nonce
42         uint256 nonce_rlp_len;
43 
44         if (0 < n && n < MAX_SINGLE_BYTE) {
45             // nonce fits in a single byte
46             // RLP(nonce) = nonce
47             nonce_bytes = 1;
48             nonce_rlp_len = 1;
49         } else {
50             // RLP(nonce) = [num_bytes_in_nonce nonce]
51             nonce_bytes = count_bytes(n);
52             nonce_rlp_len = nonce_bytes + 1;
53         }
54 
55         // [address_length(1) address(20) nonce_length(0 or 1) nonce(1-9)]
56         uint256 tot_bytes = 1 + ADDRESS_BYTES + nonce_rlp_len;
57 
58         // concatenate all parts of the RLP encoding in the leading bytes of
59         // one 32-byte word
60         uint256 word = ((192 + tot_bytes) * 256**31) +
61                        ((128 + ADDRESS_BYTES) * 256**30) +
62                        (uint256(a) * 256**10);
63 
64         if (0 < n && n < MAX_SINGLE_BYTE) {
65             word += n * 256**9;
66         } else {
67             word += (128 + nonce_bytes) * 256**9;
68             word += n * 256**(9 - nonce_bytes);
69         }
70 
71         uint256 hash;
72 
73         assembly {
74             let mem_start := mload(0x40)        // get a pointer to free memory
75             mstore(0x40, add(mem_start, 0x20))  // update the pointer
76 
77             mstore(mem_start, word)             // store the rlp encoding
78             hash := sha3(mem_start,
79                          add(tot_bytes, 1))     // hash the rlp encoding
80         }
81 
82         // interpret hash as address (20 least significant bytes)
83         return address(hash);
84     }
85     
86     //////////////////////////////////////////////////////////////////////////
87     // Generic ERC20
88     //////////////////////////////////////////////////////////////////////////
89 
90     // owner -> amount
91     mapping(address => uint256) s_balances;
92     // owner -> spender -> max amount
93     mapping(address => mapping(address => uint256)) s_allowances;
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 
99     // Spec: Get the account balance of another account with address `owner`
100     function balanceOf(address owner) public constant returns (uint256 balance) {
101         return s_balances[owner];
102     }
103 
104     function internalTransfer(address from, address to, uint256 value) internal returns (bool success) {
105         if (value <= s_balances[from]) {
106             s_balances[from] -= value;
107             s_balances[to] += value;
108             Transfer(from, to, value);
109             return true;
110         } else {
111             return false;
112         }
113     }
114 
115     // Spec: Send `value` amount of tokens to address `to`
116     function transfer(address to, uint256 value) public returns (bool success) {
117         address from = msg.sender;
118         return internalTransfer(from, to, value);
119     }
120 
121     // Spec: Send `value` amount of tokens from address `from` to address `to`
122     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
123         address spender = msg.sender;
124         if(value <= s_allowances[from][spender] && internalTransfer(from, to, value)) {
125             s_allowances[from][spender] -= value;
126             return true;
127         } else {
128             return false;
129         }
130     }
131 
132     // Spec: Allow `spender` to withdraw from your account, multiple times, up
133     // to the `value` amount. If this function is called again it overwrites the
134     // current allowance with `value`.
135     function approve(address spender, uint256 value) public returns (bool success) {
136         address owner = msg.sender;
137         if (value != 0 && s_allowances[owner][spender] != 0) {
138             return false;
139         }
140         s_allowances[owner][spender] = value;
141         Approval(owner, spender, value);
142         return true;
143     }
144 
145     // Spec: Returns the `amount` which `spender` is still allowed to withdraw
146     // from `owner`.
147     // What if the allowance is higher than the balance of the `owner`?
148     // Callers should be careful to use min(allowance, balanceOf) to make sure
149     // that the allowance is actually present in the account!
150     function allowance(address owner, address spender) public constant returns (uint256 remaining) {
151         return s_allowances[owner][spender];
152     }
153 
154     //////////////////////////////////////////////////////////////////////////
155     // GasToken specifics
156     //////////////////////////////////////////////////////////////////////////
157 
158     uint8 constant public decimals = 2;
159     string constant public name = "Gastoken.io";
160     string constant public symbol = "GST2";
161 
162     // We build a queue of nonces at which child contracts are stored. s_head is
163     // the nonce at the head of the queue, s_tail is the nonce behind the tail
164     // of the queue. The queue grows at the head and shrinks from the tail.
165     // Note that when and only when a contract CREATEs another contract, the
166     // creating contract's nonce is incremented.
167     // The first child contract is created with nonce == 1, the second child
168     // contract is created with nonce == 2, and so on...
169     // For example, if there are child contracts at nonces [2,3,4],
170     // then s_head == 4 and s_tail == 1. If there are no child contracts,
171     // s_head == s_tail.
172     uint256 s_head;
173     uint256 s_tail;
174 
175     // totalSupply gives  the number of tokens currently in existence
176     // Each token corresponds to one child contract that can be SELFDESTRUCTed
177     // for a gas refund.
178     function totalSupply() public constant returns (uint256 supply) {
179         return s_head - s_tail;
180     }
181 
182     // Creates a child contract that can only be destroyed by this contract.
183     function makeChild() internal returns (address addr) {
184         assembly {
185             // EVM assembler of runtime portion of child contract:
186             //     ;; Pseudocode: if (msg.sender != 0x0000000000b3f879cb30fe243b4dfee438691c04) { throw; }
187             //     ;;             suicide(msg.sender)
188             //     PUSH15 0xb3f879cb30fe243b4dfee438691c04 ;; hardcoded address of this contract
189             //     CALLER
190             //     XOR
191             //     PC
192             //     JUMPI
193             //     CALLER
194             //     SELFDESTRUCT
195             // Or in binary: 6eb3f879cb30fe243b4dfee438691c043318585733ff
196             // Since the binary is so short (22 bytes), we can get away
197             // with a very simple initcode:
198             //     PUSH22 0x6eb3f879cb30fe243b4dfee438691c043318585733ff
199             //     PUSH1 0
200             //     MSTORE ;; at this point, memory locations mem[10] through
201             //            ;; mem[31] contain the runtime portion of the child
202             //            ;; contract. all that's left to do is to RETURN this
203             //            ;; chunk of memory.
204             //     PUSH1 22 ;; length
205             //     PUSH1 10 ;; offset
206             //     RETURN
207             // Or in binary: 756eb3f879cb30fe243b4dfee438691c043318585733ff6000526016600af3
208             // Almost done! All we have to do is put this short (31 bytes) blob into
209             // memory and call CREATE with the appropriate offsets.
210             let solidity_free_mem_ptr := mload(0x40)
211             mstore(solidity_free_mem_ptr, 0x00756eb3f879cb30fe243b4dfee438691c043318585733ff6000526016600af3)
212             addr := create(0, add(solidity_free_mem_ptr, 1), 31)
213         }
214     }
215 
216     // Mints `value` new sub-tokens (e.g. cents, pennies, ...) by creating `value`
217     // new child contracts. The minted tokens are owned by the caller of this
218     // function.
219     function mint(uint256 value) public {
220         for (uint256 i = 0; i < value; i++) {
221             makeChild();
222         }
223         s_head += value;
224         s_balances[msg.sender] += value;
225     }
226 
227     // Destroys `value` child contracts and updates s_tail.
228     //
229     // This function is affected by an issue in solc: https://github.com/ethereum/solidity/issues/2999
230     // The `mk_contract_address(this, i).call();` doesn't forward all available gas, but only GAS - 25710.
231     // As a result, when this line is executed with e.g. 30000 gas, the callee will have less than 5000 gas
232     // available and its SELFDESTRUCT operation will fail leading to no gas refund occurring.
233     // The remaining ~29000 gas left after the call is enough to update s_tail and the caller's balance.
234     // Hence tokens will have been destroyed without a commensurate gas refund.
235     // Fortunately, there is a simple workaround:
236     // Whenever you call free, freeUpTo, freeFrom, or freeUpToFrom, ensure that you pass at least
237     // 25710 + `value` * (1148 + 5722 + 150) gas. (It won't all be used)
238     function destroyChildren(uint256 value) internal {
239         uint256 tail = s_tail;
240         // tail points to slot behind the last contract in the queue
241         for (uint256 i = tail + 1; i <= tail + value; i++) {
242             mk_contract_address(this, i).call();
243         }
244 
245         s_tail = tail + value;
246     }
247 
248     // Frees `value` sub-tokens (e.g. cents, pennies, ...) belonging to the
249     // caller of this function by destroying `value` child contracts, which
250     // will trigger a partial gas refund.
251     // You should ensure that you pass at least 25710 + `value` * (1148 + 5722 + 150) gas
252     // when calling this function. For details, see the comment above `destroyChilden`.
253     function free(uint256 value) public returns (bool success) {
254         uint256 from_balance = s_balances[msg.sender];
255         if (value > from_balance) {
256             return false;
257         }
258 
259         destroyChildren(value);
260 
261         s_balances[msg.sender] = from_balance - value;
262 
263         return true;
264     }
265 
266     // Frees up to `value` sub-tokens. Returns how many tokens were freed.
267     // Otherwise, identical to free.
268     // You should ensure that you pass at least 25710 + `value` * (1148 + 5722 + 150) gas
269     // when calling this function. For details, see the comment above `destroyChilden`.
270     function freeUpTo(uint256 value) public returns (uint256 freed) {
271         uint256 from_balance = s_balances[msg.sender];
272         if (value > from_balance) {
273             value = from_balance;
274         }
275 
276         destroyChildren(value);
277 
278         s_balances[msg.sender] = from_balance - value;
279 
280         return value;
281     }
282 
283     // Frees `value` sub-tokens owned by address `from`. Requires that `msg.sender`
284     // has been approved by `from`.
285     // You should ensure that you pass at least 25710 + `value` * (1148 + 5722 + 150) gas
286     // when calling this function. For details, see the comment above `destroyChilden`.
287     function freeFrom(address from, uint256 value) public returns (bool success) {
288         address spender = msg.sender;
289         uint256 from_balance = s_balances[from];
290         if (value > from_balance) {
291             return false;
292         }
293 
294         mapping(address => uint256) from_allowances = s_allowances[from];
295         uint256 spender_allowance = from_allowances[spender];
296         if (value > spender_allowance) {
297             return false;
298         }
299 
300         destroyChildren(value);
301 
302         s_balances[from] = from_balance - value;
303         from_allowances[spender] = spender_allowance - value;
304 
305         return true;
306     }
307 
308     // Frees up to `value` sub-tokens owned by address `from`. Returns how many tokens were freed.
309     // Otherwise, identical to `freeFrom`.
310     // You should ensure that you pass at least 25710 + `value` * (1148 + 5722 + 150) gas
311     // when calling this function. For details, see the comment above `destroyChilden`.
312     function freeFromUpTo(address from, uint256 value) public returns (uint256 freed) {
313         address spender = msg.sender;
314         uint256 from_balance = s_balances[from];
315         if (value > from_balance) {
316             value = from_balance;
317         }
318 
319         mapping(address => uint256) from_allowances = s_allowances[from];
320         uint256 spender_allowance = from_allowances[spender];
321         if (value > spender_allowance) {
322             value = spender_allowance;
323         }
324 
325         destroyChildren(value);
326 
327         s_balances[from] = from_balance - value;
328         from_allowances[spender] = spender_allowance - value;
329 
330         return value;
331     }
332 }