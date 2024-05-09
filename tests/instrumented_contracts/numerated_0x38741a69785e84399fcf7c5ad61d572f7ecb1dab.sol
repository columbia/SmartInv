1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.3;
3 pragma abicoder v2;
4 
5 contract EverPay {
6     // Event
7     event Submission(
8         bytes32 indexed id,
9         uint256 indexed proposalID,
10         bytes32 indexed everHash,
11         address owner,
12         address to,
13         uint256 value,
14         bytes data
15     );
16     event SubmissionFailure(
17         bytes32 indexed id,
18         uint256 indexed proposalID,
19         bytes32 indexed everHash,
20         address owner,
21         address to,
22         uint256 value,
23         bytes data
24     );
25     event Execution(
26         bytes32 indexed id,
27         uint256 indexed proposalID,
28         bytes32 indexed everHash,
29         address to,
30         uint256 value,
31         bytes data
32     );
33     event ExecutionFailure(
34         bytes32 indexed id,
35         uint256 indexed proposalID,
36         bytes32 indexed everHash,
37         address to,
38         uint256 value,
39         bytes data
40     );
41     // event Revocation(address indexed sender, bytes32 indexed id); // TODO
42     event Deposit(address indexed sender, uint256 value);
43     event OwnerAddition(address indexed owner);
44     event OwnerRemoval(address indexed owner);
45     event RequirementChange(uint256 required);
46 
47     event OperatorChange(address indexed operator);
48     event PausedChange(bool paused);
49     // Event End
50 
51     // Storage & Struct
52     uint256 public chainID;
53     bool public paused;
54     address public operator;
55     uint256 public required;
56     address[] public owners;
57     mapping(address => bool) public isOwner;
58 
59     mapping(bytes32 => bool) public executed;// tx id => bool
60     mapping(bytes32 => mapping(address => bool)) public confirmations;
61     // Storage & Struct End
62 
63     // Modifier
64     modifier validRequirement(uint256 ownerCount, uint256 _required) {
65         require(
66             ownerCount >= _required && ownerCount != 0 && _required != 0,
67             "invalid_required"
68         );
69         _;
70     }
71 
72     modifier onlyWallet() {
73         require(msg.sender == address(this), "not_wallet");
74         _;
75     }
76 
77     modifier onlyOperator() {
78         require(msg.sender == operator, "not_operator");
79         _;
80     }
81 
82     modifier whenNotPaused() {
83         require(!paused, "paused");
84         _;
85     }
86 
87     // Modifier End
88 
89     // Manage
90     function getPaused() public view returns (bool) {
91         return paused;
92     }
93 
94     function getOperator() public view returns (address) {
95         return operator;
96     }
97 
98     function getOwners() public view returns (address[] memory) {
99         return owners;
100     }
101 
102     function getRequire() public view returns (uint256) {
103         return required;
104     }
105 
106     function setOperator(address _operator) public onlyWallet {
107         require(_operator != address(0), "null_address");
108 
109         operator = _operator;
110 
111         emit OperatorChange(operator);
112     }
113 
114     function setPaused(bool _paused) public onlyOperator {
115         paused = _paused;
116 
117         emit PausedChange(paused);
118     }
119 
120     function addOwner(address owner) public onlyWallet {
121         require(owner != address(0), "null_address");
122 
123         isOwner[owner] = true;
124         owners.push(owner);
125 
126         emit OwnerAddition(owner);
127     }
128 
129     function removeOwner(address owner) public onlyWallet {
130         require(isOwner[owner], "no_owner_found");
131 
132         isOwner[owner] = false;
133         for (uint256 i = 0; i < owners.length - 1; i++) {
134             if (owners[i] == owner) {
135                 owners[i] = owners[owners.length - 1];
136                 break;
137             }
138         }
139         owners.pop();
140 
141         if (required > owners.length) {
142             changeRequirement(owners.length);
143         }
144 
145         OwnerRemoval(owner);
146     }
147 
148     function replaceOwner(address owner, address newOwner) public onlyWallet {
149         require(isOwner[owner], "no_owner_found");
150         require(newOwner != address(0), "null_address");
151 
152         for (uint256 i = 0; i < owners.length; i++) {
153             if (owners[i] == owner) {
154                 owners[i] = newOwner;
155                 break;
156             }
157         }
158         isOwner[owner] = false;
159         isOwner[newOwner] = true;
160 
161         OwnerRemoval(owner);
162         OwnerAddition(newOwner);
163     }
164 
165     function changeRequirement(uint256 _required)
166         public
167         onlyWallet
168         validRequirement(owners.length, _required)
169     {
170         required = _required;
171         emit RequirementChange(_required);
172     }
173 
174     // Manage End
175 
176     // Base
177     receive() external payable {
178         if (msg.value != 0) emit Deposit(msg.sender, msg.value);
179     }
180 
181     constructor(address[] memory _owners, uint256 _required) validRequirement(_owners.length, _required)
182     {
183         for (uint256 i = 0; i < _owners.length; i++) {
184             isOwner[_owners[i]] = true;
185         }
186 
187         owners = _owners;
188         required = _required;
189 
190         uint256 _chainID;
191         assembly {
192             _chainID := chainid()
193         }
194         chainID = _chainID;
195     }
196 
197     function submit(
198         uint256 proposalID, // ar tx id
199         bytes32 everHash,
200         address to,
201         uint256 value,
202         bytes memory data,
203         bytes[] memory sigs
204     ) public whenNotPaused returns (bytes32, bool) {
205         bytes32 id = txHash(proposalID, everHash, to, value, data);
206         require(!executed[id], "tx_executed");
207 
208         for (uint256 i = 0; i < sigs.length; i++) {
209             address owner = ecAddress(id, sigs[i]);
210             if (!isOwner[owner]) {
211                 emit SubmissionFailure(id, proposalID, everHash, owner, to, value, data);
212                 continue;
213             }
214 
215             confirmations[id][owner] = true;
216             emit Submission(id, proposalID, everHash, owner, to, value, data);
217         }
218 
219         if (!isConfirmed(id)) return (id, false);
220         executed[id] = true;
221 
222         (bool ok, ) = to.call{value: value}(data);
223         if (ok) {
224             emit Execution(id, proposalID, everHash, to, value, data);
225         } else {
226             emit ExecutionFailure(id, proposalID, everHash, to, value, data);
227         }
228 
229         return (id, true);
230     }
231 
232     // execute multi calls
233     function executes(address[] memory tos, uint256[] memory values, bytes[] memory datas) payable public onlyWallet {
234         require(tos.length == values.length, "invalid_length");
235         require(tos.length == datas.length, "invalid_length");
236 
237         for (uint256 i = 0; i < tos.length; i++) {
238           (bool ok, ) = tos[i].call{value: values[i]}(datas[i]);
239           require(ok, "executed_falied");
240         }
241     }
242 
243     function isConfirmed(bytes32 id) public view returns (bool) {
244         uint256 count = 0;
245         for (uint256 i = 0; i < owners.length; i++) {
246             if (confirmations[id][owners[i]]) count += 1;
247             if (count >= required) return true;
248         }
249 
250         return false;
251     }
252 
253     // Base End
254 
255     // Utils
256     function txHash(uint256 proposalID, bytes32 everHash, address to, uint256 value, bytes memory data) public view returns (bytes32) {
257         return keccak256(abi.encodePacked(chainID, address(this), proposalID, everHash, to, value, data));
258     }
259 
260     function ecAddress(bytes32 id, bytes memory sig)
261         public
262         pure
263         returns (address)
264     {
265         require(sig.length == 65, "invalid_sig_len");
266 
267         uint8 v;
268         bytes32 r;
269         bytes32 s;
270 
271         assembly {
272             r := mload(add(sig, 0x20))
273             s := mload(add(sig, 0x40))
274             v := byte(0, mload(add(sig, 0x60)))
275         }
276 
277         require(v == 27 || v == 28, "invalid_sig_v");
278 
279         return
280             ecrecover(
281                 keccak256(
282                     abi.encodePacked("\x19Ethereum Signed Message:\n32", id)
283                 ), v, r, s
284             );
285     }
286     // Utils End
287 }