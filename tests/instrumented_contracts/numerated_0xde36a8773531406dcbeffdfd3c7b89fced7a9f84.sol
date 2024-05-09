1 // File: contracts/generic/SafeMath.sol
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 
7     TODO: check against ds-math: https://blog.dapphub.com/ds-math/
8     TODO: move roundedDiv to a sep lib? (eg. Math.sol)
9     TODO: more unit tests!
10 */
11 pragma solidity 0.4.24;
12 
13 
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a * b;
17         require(a == 0 || c / a == b, "mul overflow");
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
23         uint256 c = a / b;
24         // require(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         require(b <= a, "sub underflow");
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "add overflow");
36         return c;
37     }
38 
39     // Division, round to nearest integer, round half up
40     function roundedDiv(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
42         uint256 halfB = (b % 2 == 0) ? (b / 2) : (b / 2 + 1);
43         return (a % b >= halfB) ? (a / b + 1) : (a / b);
44     }
45 
46     // Division, always rounds up
47     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
48         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
49         return (a % b != 0) ? (a / b + 1) : (a / b);
50     }
51 
52     function min(uint256 a, uint256 b) internal pure returns (uint256) {
53         return a < b ? a : b;
54     }
55 
56     function max(uint256 a, uint256 b) internal pure returns (uint256) {
57         return a < b ? b : a;
58     }    
59 }
60 
61 // File: contracts/generic/MultiSig.sol
62 
63 /* Abstract multisig contract to allow multi approval execution of atomic contracts scripts
64         e.g. migrations or settings.
65     * Script added by signing a script address by a signer  (NEW state)
66     * Script goes to ALLOWED state once a quorom of signers sign it (quorom fx is defined in each derived contracts)
67     * Script can be signed even in APPROVED state
68     * APPROVED scripts can be executed only once.
69         - if script succeeds then state set to DONE
70         - If script runs out of gas or reverts then script state set to FAILEd and not allowed to run again
71           (To avoid leaving "behind" scripts which fail in a given state but eventually execute in the future)
72     * Scripts can be cancelled by an other multisig script approved and calling cancelScript()
73     * Adding/removing signers is only via multisig approved scripts using addSigners / removeSigners fxs
74 */
75 pragma solidity 0.4.24;
76 
77 
78 
79 contract MultiSig {
80     using SafeMath for uint256;
81 
82     mapping(address => bool) public isSigner;
83     address[] public allSigners; // all signers, even the disabled ones
84                                 // NB: it can contain duplicates when a signer is added, removed then readded again
85                                 //   the purpose of this array is to being able to iterate on signers in isSigner
86     uint public activeSignersCount;
87 
88     enum ScriptState {New, Approved, Done, Cancelled, Failed}
89 
90     struct Script {
91         ScriptState state;
92         uint signCount;
93         mapping(address => bool) signedBy;
94         address[] allSigners;
95     }
96 
97     mapping(address => Script) public scripts;
98     address[] public scriptAddresses;
99 
100     event SignerAdded(address signer);
101     event SignerRemoved(address signer);
102 
103     event ScriptSigned(address scriptAddress, address signer);
104     event ScriptApproved(address scriptAddress);
105     event ScriptCancelled(address scriptAddress);
106 
107     event ScriptExecuted(address scriptAddress, bool result);
108 
109     constructor() public {
110         // deployer address is the first signer. Deployer can configure new contracts by itself being the only "signer"
111         // The first script which sets the new contracts live should add signers and revoke deployer's signature right
112         isSigner[msg.sender] = true;
113         allSigners.push(msg.sender);
114         activeSignersCount = 1;
115         emit SignerAdded(msg.sender);
116     }
117 
118     function sign(address scriptAddress) public {
119         require(isSigner[msg.sender], "sender must be signer");
120         Script storage script = scripts[scriptAddress];
121         require(script.state == ScriptState.Approved || script.state == ScriptState.New,
122                 "script state must be New or Approved");
123         require(!script.signedBy[msg.sender], "script must not be signed by signer yet");
124 
125         if (script.allSigners.length == 0) {
126             // first sign of a new script
127             scriptAddresses.push(scriptAddress);
128         }
129 
130         script.allSigners.push(msg.sender);
131         script.signedBy[msg.sender] = true;
132         script.signCount = script.signCount.add(1);
133 
134         emit ScriptSigned(scriptAddress, msg.sender);
135 
136         if (checkQuorum(script.signCount)) {
137             script.state = ScriptState.Approved;
138             emit ScriptApproved(scriptAddress);
139         }
140     }
141 
142     function execute(address scriptAddress) public returns (bool result) {
143         // only allow execute to signers to avoid someone set an approved script failed by calling it with low gaslimit
144         require(isSigner[msg.sender], "sender must be signer");
145         Script storage script = scripts[scriptAddress];
146         require(script.state == ScriptState.Approved, "script state must be Approved");
147 
148         // passing scriptAddress to allow called script access its own public fx-s if needed
149         if (scriptAddress.delegatecall.gas(gasleft() - 23000)
150             (abi.encodeWithSignature("execute(address)", scriptAddress))) {
151             script.state = ScriptState.Done;
152             result = true;
153         } else {
154             script.state = ScriptState.Failed;
155             result = false;
156         }
157         emit ScriptExecuted(scriptAddress, result);
158     }
159 
160     function cancelScript(address scriptAddress) public {
161         require(msg.sender == address(this), "only callable via MultiSig");
162         Script storage script = scripts[scriptAddress];
163         require(script.state == ScriptState.Approved || script.state == ScriptState.New,
164                 "script state must be New or Approved");
165 
166         script.state = ScriptState.Cancelled;
167 
168         emit ScriptCancelled(scriptAddress);
169     }
170 
171     /* requires quorum so it's callable only via a script executed by this contract */
172     function addSigners(address[] signers) public {
173         require(msg.sender == address(this), "only callable via MultiSig");
174         for (uint i= 0; i < signers.length; i++) {
175             if (!isSigner[signers[i]]) {
176                 require(signers[i] != address(0), "new signer must not be 0x0");
177                 activeSignersCount++;
178                 allSigners.push(signers[i]);
179                 isSigner[signers[i]] = true;
180                 emit SignerAdded(signers[i]);
181             }
182         }
183     }
184 
185     /* requires quorum so it's callable only via a script executed by this contract */
186     function removeSigners(address[] signers) public {
187         require(msg.sender == address(this), "only callable via MultiSig");
188         for (uint i= 0; i < signers.length; i++) {
189             if (isSigner[signers[i]]) {
190                 require(activeSignersCount > 1, "must not remove last signer");
191                 activeSignersCount--;
192                 isSigner[signers[i]] = false;
193                 emit SignerRemoved(signers[i]);
194             }
195         }
196     }
197 
198     /* implement it in derived contract */
199     function checkQuorum(uint signersCount) internal view returns(bool isQuorum);
200 
201     function getAllSignersCount() view external returns (uint allSignersCount) {
202         return allSigners.length;
203     }
204 
205     // UI helper fx - Returns signers from offset as [signer id (index in allSigners), address as uint, isActive 0 or 1]
206     function getSigners(uint offset, uint16 chunkSize)
207     external view returns(uint[3][]) {
208         uint limit = SafeMath.min(offset.add(chunkSize), allSigners.length);
209         uint[3][] memory response = new uint[3][](limit.sub(offset));
210         for (uint i = offset; i < limit; i++) {
211             address signerAddress = allSigners[i];
212             response[i - offset] = [i, uint(signerAddress), isSigner[signerAddress] ? 1 : 0];
213         }
214         return response;
215     }
216 
217     function getScriptsCount() view external returns (uint scriptsCount) {
218         return scriptAddresses.length;
219     }
220 
221     // UI helper fx - Returns scripts from offset as
222     //  [scriptId (index in scriptAddresses[]), address as uint, state, signCount]
223     function getScripts(uint offset, uint16 chunkSize)
224     external view returns(uint[4][]) {
225         uint limit = SafeMath.min(offset.add(chunkSize), scriptAddresses.length);
226         uint[4][] memory response = new uint[4][](limit.sub(offset));
227         for (uint i = offset; i < limit; i++) {
228             address scriptAddress = scriptAddresses[i];
229             response[i - offset] = [i, uint(scriptAddress),
230                 uint(scripts[scriptAddress].state), scripts[scriptAddress].signCount];
231         }
232         return response;
233     }
234 }
235 
236 // File: contracts/StabilityBoardProxy.sol
237 
238 /* allows tx to execute if 50% +1 vote of active signers signed */
239 pragma solidity 0.4.24;
240 
241 
242 
243 contract StabilityBoardProxy is MultiSig {
244 
245     function checkQuorum(uint signersCount) internal view returns(bool isQuorum) {
246         isQuorum = signersCount > activeSignersCount / 2 ;
247     }
248 }