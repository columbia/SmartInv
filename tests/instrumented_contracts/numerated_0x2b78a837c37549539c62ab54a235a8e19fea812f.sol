1 pragma solidity ^0.4.25;
2 
3 contract CentWallet {
4 
5     struct Wallet {
6         uint256 balance;
7         mapping(address => bool) linked;
8         // prevent signature replay:
9         uint64 debitNonce;
10         uint64 withdrawNonce;
11     }
12 
13     address[] public admins;
14 
15     mapping(bytes32 => Wallet) private wallets;
16     mapping(address => bool) private isAdmin;
17 
18     uint256 private escrowBalance;
19 
20     modifier onlyAdmin {
21         require(isAdmin[msg.sender]);
22         _;
23     }
24 
25     modifier onlyRootAdmin {
26         require(msg.sender == admins[0]);
27         _;
28     }
29 
30     event Deposit(
31         bytes32 indexed walletID,
32         address indexed sender,
33         uint256 indexed value
34     );
35 
36     event Link(
37         bytes32 indexed walletID,
38         address indexed agent
39     );
40 
41     event Debit(
42         bytes32 indexed walletID,
43         uint256 indexed nonce,
44         uint256 indexed value
45     );
46 
47     event Settle(
48         bytes32 indexed walletID,
49         uint256 indexed requestID,
50         uint256 indexed value
51     );
52 
53     event Withdraw(
54         bytes32 indexed walletID,
55         uint256 indexed nonce,
56         uint256 indexed value,
57         address recipient
58     );
59 
60     constructor() public
61     {
62         admins.push(msg.sender);
63         isAdmin[msg.sender] = true;
64     }
65 
66 //  PUBLIC CALLABLE BY ANYONE
67     /**
68      * Add funds to the wallet associated with an address + username
69      * Create a wallet if none exists.
70      */
71     function deposit(
72         bytes32 walletID) payable public
73     {
74         wallets[walletID].balance += msg.value;
75 
76         emit Deposit(walletID, msg.sender, msg.value);
77     }
78 
79 //  PUBLIC CALLABLE BY ADMIN
80     /**
81      * Add an authorized signer to a wallet.
82      */
83     function link(
84         bytes32[] walletIDs,
85         bytes32[] nameIDs,
86         address[] agents,
87         uint8[] v, bytes32[] r, bytes32[] s) onlyAdmin public
88     {
89         require(
90             walletIDs.length == nameIDs.length &&
91             walletIDs.length == agents.length &&
92             walletIDs.length == v.length &&
93             walletIDs.length == r.length &&
94             walletIDs.length == s.length
95         );
96 
97         for (uint i = 0; i < walletIDs.length; i++) {
98             bytes32 walletID = walletIDs[i];
99             address agent = agents[i];
100 
101             address signer = getMessageSigner(
102                 getLinkDigest(walletID, agent), v[i], r[i], s[i]
103             );
104 
105             Wallet storage wallet = wallets[walletID];
106 
107             if (wallet.linked[signer] || walletID == getWalletDigest(nameIDs[i], signer)) {
108                 wallet.linked[agent] = true;
109 
110                 emit Link(walletID, agent);
111             }
112         }
113     }
114 
115     /**
116      * Debit funds from a user's balance and add them to the escrow balance.
117      */
118     function debit(
119         bytes32[] walletIDs,
120         uint256[] values,
121         uint64[] nonces,
122         uint8[] v, bytes32[] r, bytes32[] s) onlyAdmin public
123     {
124         require(
125             walletIDs.length == values.length &&
126             walletIDs.length == nonces.length &&
127             walletIDs.length == v.length &&
128             walletIDs.length == r.length &&
129             walletIDs.length == s.length
130         );
131 
132         uint256 additionalEscrow = 0;
133 
134         for (uint i = 0; i < walletIDs.length; i++) {
135             bytes32 walletID = walletIDs[i];
136             uint256 value = values[i];
137             uint64 nonce = nonces[i];
138 
139             address signer = getMessageSigner(
140                 getDebitDigest(walletID, value, nonce), v[i], r[i], s[i]
141             );
142 
143             Wallet storage wallet = wallets[walletID];
144 
145             if (
146                 wallet.debitNonce < nonce &&
147                 wallet.balance >= value &&
148                 wallet.linked[signer]
149             ) {
150                 wallet.debitNonce = nonce;
151                 wallet.balance -= value;
152 
153                 emit Debit(walletID, nonce, value);
154 
155                 additionalEscrow += value;
156             }
157         }
158 
159         escrowBalance += additionalEscrow;
160     }
161 
162     /**
163      * Withdraws funds from this contract, debiting the user's wallet.
164      */
165     function withdraw(
166         bytes32[] walletIDs,
167         address[] recipients,
168         uint256[] values,
169         uint64[] nonces,
170         uint8[] v, bytes32[] r, bytes32[] s) onlyAdmin public
171     {
172         require(
173             walletIDs.length == recipients.length &&
174             walletIDs.length == values.length &&
175             walletIDs.length == nonces.length &&
176             walletIDs.length == v.length &&
177             walletIDs.length == r.length &&
178             walletIDs.length == s.length
179         );
180 
181         for (uint i = 0; i < walletIDs.length; i++) {
182             bytes32 walletID = walletIDs[i];
183             address recipient = recipients[i];
184             uint256 value = values[i];
185             uint64 nonce = nonces[i];
186 
187             address signer = getMessageSigner(
188                 getWithdrawDigest(walletID, recipient, value, nonce), v[i], r[i], s[i]
189             );
190 
191             Wallet storage wallet = wallets[walletID];
192 
193             if (
194                 wallet.withdrawNonce < nonce &&
195                 wallet.balance >= value &&
196                 wallet.linked[signer] &&
197                 recipient.send(value)
198             ) {
199                 wallet.withdrawNonce = nonce;
200                 wallet.balance -= value;
201 
202                 emit Withdraw(walletID, nonce, value, recipient);
203             }
204         }
205     }
206 
207     /**
208      * Settles funds from admin escrow into user wallets.
209      */
210     function settle(
211         bytes32[] walletIDs,
212         uint256[] requestIDs,
213         uint256[] values) onlyAdmin public
214     {
215         require(
216             walletIDs.length == requestIDs.length &&
217             walletIDs.length == values.length
218         );
219 
220         uint256 remainingEscrow = escrowBalance;
221 
222         for (uint i = 0; i < walletIDs.length; i++) {
223             bytes32 walletID = walletIDs[i];
224             uint256 value = values[i];
225 
226             require(value <= remainingEscrow);
227 
228             wallets[walletID].balance += value;
229             remainingEscrow -= value;
230 
231             emit Settle(walletID, requestIDs[i], value);
232         }
233 
234         escrowBalance = remainingEscrow;
235     }
236 
237 //  PURE GETTERS - FOR SIGNATURE GENERATION / VERIFICATION
238     function getMessageSigner(
239         bytes32 message,
240         uint8 v, bytes32 r, bytes32 s) public pure returns(address)
241     {
242         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
243         bytes32 prefixedMessage = keccak256(
244             abi.encodePacked(prefix, message)
245         );
246         return ecrecover(prefixedMessage, v, r, s);
247     }
248 
249     function getNameDigest(
250         string name) public pure returns (bytes32)
251     {
252         return keccak256(abi.encodePacked(name));
253     }
254 
255     function getWalletDigest(
256         bytes32 name,
257         address root) public pure returns (bytes32)
258     {
259         return keccak256(abi.encodePacked(
260             name, root
261         ));
262     }
263 
264     function getLinkDigest(
265         bytes32 walletID,
266         address agent) public pure returns (bytes32)
267     {
268         return keccak256(abi.encodePacked(
269             walletID, agent
270         ));
271     }
272 
273     function getDebitDigest(
274         bytes32 walletID,
275         uint256 value,
276         uint64 nonce) public pure returns (bytes32)
277     {
278         return keccak256(abi.encodePacked(
279             walletID, value, nonce
280         ));
281     }
282 
283     function getWithdrawDigest(
284         bytes32 walletID,
285         address recipient,
286         uint256 value,
287         uint64 nonce) public pure returns (bytes32)
288     {
289         return keccak256(abi.encodePacked(
290             walletID, recipient, value, nonce
291         ));
292     }
293 
294 //  VIEW GETTERS - READ WALLET STATE
295     function getDebitNonce(
296         bytes32 walletID) public view returns (uint256)
297     {
298         return wallets[walletID].debitNonce + 1;
299     }
300 
301     function getWithdrawNonce(
302         bytes32 walletID) public view returns (uint256)
303     {
304         return wallets[walletID].withdrawNonce + 1;
305     }
306 
307     function getLinkStatus(
308         bytes32 walletID,
309         address member) public view returns (bool)
310     {
311         return wallets[walletID].linked[member];
312     }
313 
314     function getBalance(
315         bytes32 walletID) public view returns (uint256)
316     {
317         return wallets[walletID].balance;
318     }
319 
320     function getEscrowBalance() public view returns (uint256)
321     {
322       return escrowBalance;
323     }
324 
325 //  ADMIN MANAGEMENT
326     function addAdmin(
327         address newAdmin) onlyRootAdmin public
328     {
329         require(!isAdmin[newAdmin]);
330 
331         isAdmin[newAdmin] = true;
332         admins.push(newAdmin);
333     }
334 
335     function removeAdmin(
336         address oldAdmin) onlyRootAdmin public
337     {
338         require(isAdmin[oldAdmin] && admins[0] != oldAdmin);
339 
340         bool found = false;
341         for (uint i = 1; i < admins.length - 1; i++) {
342             if (!found && admins[i] == oldAdmin) {
343                 found = true;
344             }
345             if (found) {
346                 admins[i] = admins[i + 1];
347             }
348         }
349 
350         admins.length--;
351         isAdmin[oldAdmin] = false;
352     }
353 
354     function changeRootAdmin(
355         address newRootAdmin) onlyRootAdmin public
356     {
357         if (isAdmin[newRootAdmin] && admins[0] != newRootAdmin) {
358             // Remove them & shorten the array so long as they are not currently root
359             removeAdmin(newRootAdmin);
360         }
361         admins[0] = newRootAdmin;
362         isAdmin[newRootAdmin] = true;
363     }
364 }