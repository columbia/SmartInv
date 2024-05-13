1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 pragma abicoder v2;
4 
5 // solhint-disable quotes
6 
7 import {GovernanceMessage} from "@nomad-xyz/contracts-core/contracts/governance/GovernanceMessage.sol";
8 import {GovernanceRouter} from "@nomad-xyz/contracts-core/contracts/governance/GovernanceRouter.sol";
9 import {TypeCasts} from "@nomad-xyz/contracts-core/contracts/XAppConnectionManager.sol";
10 
11 import {JsonWriter} from "./JsonWriter.sol";
12 
13 import "forge-std/Script.sol";
14 import "forge-std/Vm.sol";
15 
16 abstract contract CallBatch {
17     using JsonWriter for JsonWriter.Buffer;
18     using JsonWriter for string;
19 
20     Vm private constant vm =
21         Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
22 
23     string localDomainName;
24     uint32 public localDomain;
25     GovernanceMessage.Call[] public localCalls;
26     uint32[] public remoteDomains;
27     mapping(uint32 => GovernanceMessage.Call[]) public remoteCalls;
28 
29     bool public written;
30     JsonWriter.File batchOutput;
31 
32     function __CallBatch_initialize(
33         string memory _localDomainName,
34         uint32 _localDomain,
35         string memory _batchOutput,
36         bool _overwrite
37     ) public {
38         require(localDomain == 0, "already initialized");
39         require(_localDomain != 0, "can't pass zero domain");
40         localDomainName = _localDomainName;
41         localDomain = _localDomain;
42         batchOutput.overwrite = _overwrite;
43         batchOutput.path = string(abi.encodePacked("./actions/", _batchOutput));
44     }
45 
46     function pushRemote(
47         address to,
48         bytes memory data,
49         uint32 domain
50     ) public {
51         require(!written, "callbatch has been completed");
52         // if no calls have been pushed for this domain previously, add to array of remote domains
53         if (remoteCalls[domain].length == 0) {
54             remoteDomains.push(domain);
55         }
56         // push to array of calls for this domain
57         remoteCalls[domain].push(
58             GovernanceMessage.Call(TypeCasts.addressToBytes32(to), data)
59         );
60     }
61 
62     function pushLocal(address to, bytes memory data) public {
63         pushLocal(TypeCasts.addressToBytes32(to), data);
64     }
65 
66     function pushLocal(bytes32 to, bytes memory data) public {
67         require(!written, "callbatch has been completed");
68         localCalls.push(GovernanceMessage.Call(to, data));
69     }
70 
71     // only works if recovery is not active and localDomain is governor domain
72     function prankExecuteGovernor(address router) public {
73         if (localCalls.length == 0 && remoteDomains.length == 0) {
74             return;
75         }
76         // prank governor
77         address gov = GovernanceRouter(router).governor();
78         require(gov != address(0), "!gov chain");
79         vm.prank(gov);
80         // execute local & remote calls
81         // NOTE: remote calls will be sent as Nomad message
82         GovernanceRouter(router).executeGovernanceActions(
83             localCalls,
84             remoteDomains,
85             buildRemoteCalls()
86         );
87         delete localCalls;
88         for (uint32 i = 0; i < remoteDomains.length; i++) {
89             delete remoteCalls[remoteDomains[i]];
90         }
91         delete remoteDomains;
92     }
93 
94     // only works if recovery is active on specified domain
95     function prankExecuteRecoveryManager(address router, uint32 domain) public {
96         // prank recovery manager
97         address rm = GovernanceRouter(router).recoveryManager();
98         require(GovernanceRouter(router).inRecovery(), "!in recovery");
99         vm.prank(rm);
100         // get calls only for specified domain
101         GovernanceMessage.Call[] memory _domainCalls;
102         if (domain == localDomain) {
103             _domainCalls = localCalls;
104         } else {
105             _domainCalls = remoteCalls[domain];
106         }
107         if (_domainCalls.length == 0) return;
108         // execute local calls
109         GovernanceRouter(router).executeGovernanceActions(
110             _domainCalls,
111             new uint32[](0),
112             new GovernanceMessage.Call[][](0)
113         );
114         delete localCalls;
115     }
116 
117     function writeCall(
118         JsonWriter.Buffer memory buffer,
119         string memory indent,
120         GovernanceMessage.Call storage call,
121         bool terminal
122     ) private view {
123         buffer.writeObjectOpen(indent);
124         string memory inner = indent.nextIndent();
125         buffer.writeKv(
126             inner,
127             "to",
128             vm.toString(TypeCasts.bytes32ToAddress(call.to)),
129             false
130         );
131         buffer.writeKv(inner, "data", vm.toString(call.data), true);
132         buffer.writeObjectClose(indent, terminal);
133     }
134 
135     function writeCallList(
136         JsonWriter.Buffer memory buffer,
137         string memory indent,
138         GovernanceMessage.Call[] storage calls
139     ) private view {
140         for (uint32 i = 0; i < calls.length; i++) {
141             writeCall(
142                 buffer,
143                 indent.nextIndent(),
144                 calls[i],
145                 i == calls.length - 1
146             );
147         }
148     }
149 
150     function writeLocal(JsonWriter.Buffer memory buffer, string memory indent)
151         private
152         view
153     {
154         buffer.writeArrayOpen(indent, "local");
155         writeCallList(buffer, indent, localCalls);
156         buffer.writeArrayClose(indent, false);
157     }
158 
159     function writeRemotes(JsonWriter.Buffer memory buffer, string memory indent)
160         private
161         view
162     {
163         if (remoteDomains.length == 0) return;
164         buffer.writeObjectOpen(indent, "remote");
165         for (uint256 j; j < remoteDomains.length; j++) {
166             string memory inner = indent.nextIndent();
167             buffer.writeArrayOpen(
168                 inner,
169                 vm.toString(uint256(remoteDomains[j]))
170             );
171             writeCallList(buffer, inner, remoteCalls[remoteDomains[j]]);
172             bool terminal = j == remoteDomains.length - 1;
173             buffer.writeArrayClose(inner, terminal);
174         }
175         buffer.writeObjectClose(indent, false);
176     }
177 
178     function writeRecoveryData(
179         JsonWriter.Buffer memory buffer,
180         string memory indent,
181         uint32 domain,
182         GovernanceMessage.Call[] memory calls,
183         bool isLastDomain
184     ) private pure {
185         buffer.writeObjectOpen(indent, vm.toString(uint256(domain)));
186         bytes memory data = abi.encodeWithSelector(
187             GovernanceRouter.executeGovernanceActions.selector,
188             calls,
189             new uint32[](0),
190             new GovernanceMessage.Call[][](0)
191         );
192         string memory inner = indent.nextIndent();
193         buffer.writeKv(inner, "data", vm.toString(data), true);
194         buffer.writeObjectClose(indent, isLastDomain);
195     }
196 
197     function writeGovernorData(
198         JsonWriter.Buffer memory buffer,
199         string memory indent
200     ) private {
201         bytes memory data = abi.encodeWithSelector(
202             GovernanceRouter.executeGovernanceActions.selector,
203             localCalls,
204             remoteDomains,
205             buildRemoteCalls()
206         );
207         buffer.writeKv(indent, "data", vm.toString(data), true);
208     }
209 
210     function writeBuilt(
211         JsonWriter.Buffer memory buffer,
212         string memory indent,
213         bool recovery
214     ) private {
215         buffer.writeObjectOpen(indent, "built");
216         string memory inner = indent.nextIndent();
217         if (recovery) {
218             // write local domain built
219             bool isLastDomain = remoteDomains.length == 0;
220             writeRecoveryData(
221                 buffer,
222                 inner,
223                 localDomain,
224                 localCalls,
225                 isLastDomain
226             );
227             // write remote domains built
228             for (uint256 j; j < remoteDomains.length; j++) {
229                 isLastDomain = j == remoteDomains.length - 1;
230                 writeRecoveryData(
231                     buffer,
232                     inner,
233                     remoteDomains[j],
234                     remoteCalls[remoteDomains[j]],
235                     isLastDomain
236                 );
237             }
238         } else {
239             writeGovernorData(buffer, inner);
240         }
241         buffer.writeObjectClose(indent, true);
242     }
243 
244     GovernanceMessage.Call[][] private builtRemoteCalls;
245 
246     function buildRemoteCalls()
247         private
248         returns (GovernanceMessage.Call[][] memory _remoteCalls)
249     {
250         for (uint256 i; i < remoteDomains.length; i++) {
251             builtRemoteCalls.push(remoteCalls[remoteDomains[i]]);
252         }
253         _remoteCalls = builtRemoteCalls;
254     }
255 
256     function writeCallBatch(bool recovery) public {
257         require(localDomain != 0, "must initialize");
258         require(!written, "already written");
259         require(
260             localCalls.length != 0 || remoteDomains.length != 0,
261             "no calls pushed"
262         );
263         // write raw local & remote calls to file
264         JsonWriter.Buffer memory buffer = JsonWriter.newBuffer();
265         string memory indent = "";
266         string memory inner = indent.nextIndent();
267         buffer.writeObjectOpen(indent);
268         writeLocal(buffer, inner);
269         writeRemotes(buffer, inner);
270         writeBuilt(buffer, inner, recovery);
271         buffer.writeObjectClose(indent, true);
272         buffer.flushTo(batchOutput);
273         // finish
274         written = true;
275     }
276 }
277 
278 contract TestCallBatch is CallBatch {
279     // multi chain calls, recovery mode
280     function writeRecoveryMulti() public {
281         string memory localName = "ethereum";
282         uint32 local = 1111;
283         __CallBatch_initialize(localName, local, "upgradeActions.json", true);
284         bytes memory data = hex"0101";
285         pushLocal(address(0xBEEF), data);
286         pushRemote(address(0xBEEEEF), data, 2222);
287         pushRemote(address(0xBEEEEEEEF), data, 3333);
288         writeCallBatch(true);
289     }
290 
291     // multi chain calls, governance mode
292     function writeGovernanceMulti() public {
293         string memory localName = "ethereum";
294         uint32 local = 1111;
295         __CallBatch_initialize(localName, local, "upgradeActions.json", true);
296         bytes memory data = hex"0101";
297         pushLocal(address(0xBEEF), data);
298         pushRemote(address(0xBEEEEF), data, 2222);
299         pushRemote(address(0xBEEEEEEEF), data, 3333);
300         writeCallBatch(false);
301     }
302 
303     // single chain calls, recovery mode
304     function writeRecoverySingle() public {
305         string memory localName = "ethereum";
306         uint32 local = 1111;
307         __CallBatch_initialize(localName, local, "upgradeActions.json", true);
308         pushLocal(address(3), bytes("abcd"));
309         pushLocal(address(3), bytes("abcd"));
310         pushLocal(address(3), bytes("abcd"));
311         pushLocal(address(3), bytes("abcd"));
312         pushLocal(address(3), bytes("abcd"));
313         pushLocal(address(3), bytes("abcd"));
314         writeCallBatch(true);
315     }
316 
317     // single chain calls, governance mode
318     // (data should be same as single chain recovery mode)
319     function writeGovernanceSingle() public {
320         string memory localName = "ethereum";
321         uint32 local = 1111;
322         __CallBatch_initialize(localName, local, "upgradeActions.json", true);
323         pushLocal(address(3), bytes("abcd"));
324         pushLocal(address(3), bytes("abcd"));
325         pushLocal(address(3), bytes("abcd"));
326         pushLocal(address(3), bytes("abcd"));
327         pushLocal(address(3), bytes("abcd"));
328         pushLocal(address(3), bytes("abcd"));
329         writeCallBatch(false);
330     }
331 }
