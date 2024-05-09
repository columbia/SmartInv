1 /**
2 * @title SafeMath
3 * @dev Math operations with safety checks that throw on error
4 */
5 pragma solidity 0.4.24;
6 
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b, "mul overflow");
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
17         uint256 c = a / b;
18         // require(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a, "sub underflow");
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "add overflow");
30         return c;
31     }
32 
33     function roundedDiv(uint a, uint b) internal pure returns (uint256) {
34         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
35         uint256 z = a / b;
36         if (a % b >= b / 2) {
37             z++;  // no need for safe add b/c it can happen only if we divided the input
38         }
39         return z;
40     }
41 }
42 
43 contract MultiSig {
44     using SafeMath for uint256;
45 
46     uint public constant CHUNK_SIZE = 100;
47 
48     mapping(address => bool) public isSigner;
49     address[] public allSigners; // all signers, even the disabled ones
50                                 // NB: it can contain duplicates when a signer is added, removed then readded again
51                                 //   the purpose of this array is to being able to iterate on signers in isSigner
52     uint public activeSignersCount;
53 
54     enum ScriptState {New, Approved, Done, Cancelled, Failed}
55 
56     struct Script {
57         ScriptState state;
58         uint signCount;
59         mapping(address => bool) signedBy;
60         address[] allSigners;
61     }
62 
63     mapping(address => Script) public scripts;
64     address[] public scriptAddresses;
65 
66     event SignerAdded(address signer);
67     event SignerRemoved(address signer);
68 
69     event ScriptSigned(address scriptAddress, address signer);
70     event ScriptApproved(address scriptAddress);
71     event ScriptCancelled(address scriptAddress);
72 
73     event ScriptExecuted(address scriptAddress, bool result);
74 
75     constructor() public {
76         // deployer address is the first signer. Deployer can configure new contracts by itself being the only "signer"
77         // The first script which sets the new contracts live should add signers and revoke deployer's signature right
78         isSigner[msg.sender] = true;
79         allSigners.push(msg.sender);
80         activeSignersCount = 1;
81         emit SignerAdded(msg.sender);
82     }
83 
84     function sign(address scriptAddress) public {
85         require(isSigner[msg.sender], "sender must be signer");
86         Script storage script = scripts[scriptAddress];
87         require(script.state == ScriptState.Approved || script.state == ScriptState.New,
88                 "script state must be New or Approved");
89         require(!script.signedBy[msg.sender], "script must not be signed by signer yet");
90 
91         if(script.allSigners.length == 0) {
92             // first sign of a new script
93             scriptAddresses.push(scriptAddress);
94         }
95 
96         script.allSigners.push(msg.sender);
97         script.signedBy[msg.sender] =  true;
98         script.signCount = script.signCount.add(1);
99 
100         emit ScriptSigned(scriptAddress, msg.sender);
101 
102         if(checkQuorum(script.signCount)){
103             script.state = ScriptState.Approved;
104             emit ScriptApproved(scriptAddress);
105         }
106     }
107 
108     function execute(address scriptAddress) public returns (bool result) {
109         // only allow execute to signers to avoid someone set an approved script failed by calling it with low gaslimit
110         require(isSigner[msg.sender], "sender must be signer");
111         Script storage script = scripts[scriptAddress];
112         require(script.state == ScriptState.Approved, "script state must be Approved");
113 
114         /* init to failed because if delegatecall rans out of gas we won't have enough left to set it.
115            NB: delegatecall leaves 63/64 part of gasLimit for the caller.
116                 Therefore the execute might revert with out of gas, leaving script in Approved state
117                 when execute() is called with small gas limits.
118         */
119         script.state = ScriptState.Failed;
120 
121         // passing scriptAddress to allow called script access its own public fx-s if needed
122         if(scriptAddress.delegatecall(bytes4(keccak256("execute(address)")), scriptAddress)) {
123             script.state = ScriptState.Done;
124             result = true;
125         } else {
126             result = false;
127         }
128         emit ScriptExecuted(scriptAddress, result);
129     }
130 
131     function cancelScript(address scriptAddress) public {
132         require(msg.sender == address(this), "only callable via MultiSig");
133         Script storage script = scripts[scriptAddress];
134         require(script.state == ScriptState.Approved || script.state == ScriptState.New,
135                 "script state must be New or Approved");
136 
137         script.state= ScriptState.Cancelled;
138 
139         emit ScriptCancelled(scriptAddress);
140     }
141 
142     /* requires quorum so it's callable only via a script executed by this contract */
143     function addSigners(address[] signers) public {
144         require(msg.sender == address(this), "only callable via MultiSig");
145         for (uint i= 0; i < signers.length; i++) {
146             if (!isSigner[signers[i]]) {
147                 require(signers[i] != address(0), "new signer must not be 0x0");
148                 activeSignersCount++;
149                 allSigners.push(signers[i]);
150                 isSigner[signers[i]] = true;
151                 emit SignerAdded(signers[i]);
152             }
153         }
154     }
155 
156     /* requires quorum so it's callable only via a script executed by this contract */
157     function removeSigners(address[] signers) public {
158         require(msg.sender == address(this), "only callable via MultiSig");
159         for (uint i= 0; i < signers.length; i++) {
160             if (isSigner[signers[i]]) {
161                 require(activeSignersCount > 1, "must not remove last signer");
162                 activeSignersCount--;
163                 isSigner[signers[i]] = false;
164                 emit SignerRemoved(signers[i]);
165             }
166         }
167     }
168 
169     /* implement it in derived contract */
170     function checkQuorum(uint signersCount) internal view returns(bool isQuorum);
171 
172     function getAllSignersCount() view external returns (uint allSignersCount) {
173         return allSigners.length;
174     }
175 
176     // UI helper fx - Returns signers from offset as [signer id (index in allSigners), address as uint, isActive 0 or 1]
177     function getAllSigners(uint offset) external view returns(uint[3][CHUNK_SIZE] signersResult) {
178         for (uint8 i = 0; i < CHUNK_SIZE && i + offset < allSigners.length; i++) {
179             address signerAddress = allSigners[i + offset];
180             signersResult[i] = [ i + offset, uint(signerAddress), isSigner[signerAddress] ? 1 : 0 ];
181         }
182     }
183 
184     function getScriptsCount() view external returns (uint scriptsCount) {
185         return scriptAddresses.length;
186     }
187 
188     // UI helper fx - Returns scripts from offset as
189     //  [scriptId (index in scriptAddresses[]), address as uint, state, signCount]
190     function getAllScripts(uint offset) external view returns(uint[4][CHUNK_SIZE] scriptsResult) {
191         for (uint8 i = 0; i < CHUNK_SIZE && i + offset < scriptAddresses.length; i++) {
192             address scriptAddress = scriptAddresses[i + offset];
193             scriptsResult[i] = [ i + offset, uint(scriptAddress), uint(scripts[scriptAddress].state),
194                             scripts[scriptAddress].signCount ];
195         }
196     }
197 
198 }
199 
200 contract StabilityBoardProxy is MultiSig {
201 
202     function checkQuorum(uint signersCount) internal view returns(bool isQuorum) {
203         isQuorum = signersCount > activeSignersCount / 2 ;
204     }
205 }