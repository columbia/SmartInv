1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import {HomeHarness} from "./harnesses/HomeHarness.sol";
5 import {NomadBase} from "../NomadBase.sol";
6 import {UpdaterManager} from "../UpdaterManager.sol";
7 import {NomadTestWithUpdaterManager} from "./utils/NomadTest.sol";
8 import {IUpdaterManager} from "../interfaces/IUpdaterManager.sol";
9 import {Message} from "../libs/Message.sol";
10 
11 contract HomeTest is NomadTestWithUpdaterManager {
12     HomeHarness home;
13 
14     function setUp() public virtual override {
15         super.setUp();
16         home = new HomeHarness(homeDomain);
17         home.initialize(IUpdaterManager(address(updaterManager)));
18         updaterManager.setHome(address(home));
19     }
20 
21     function dispatchTestMessage() public returns (bytes memory, uint256) {
22         bytes32 recipient = bytes32(uint256(uint160(vm.addr(1505))));
23         address sender = vm.addr(1555);
24         bytes memory messageBody = bytes("hey buddy");
25         uint32 nonce = home.nonces(remoteDomain);
26         bytes memory message = Message.formatMessage(
27             homeDomain,
28             bytes32(uint256(uint160(sender))),
29             nonce,
30             remoteDomain,
31             recipient,
32             messageBody
33         );
34         bytes32 messageHash = keccak256(message);
35         vm.expectEmit(true, true, true, true);
36         // first message that is sent on this home
37         uint256 leafIndex = home.count();
38         emit Dispatch(
39             messageHash,
40             leafIndex,
41             (uint64(remoteDomain) << 32) | nonce,
42             home.committedRoot(),
43             message
44         );
45         vm.prank(sender);
46         home.dispatch(remoteDomain, recipient, messageBody);
47         return (message, leafIndex);
48     }
49 
50     function test_onlyUpdaterManagerSetUpdater() public {
51         address newUpdater = vm.addr(420);
52         address oldUpdater = updaterAddr;
53         assertEq(home.updater(), updaterAddr);
54         assertEq(updaterManager.updater(), updaterAddr);
55         vm.expectEmit(false, false, false, true);
56         emit NewUpdater(oldUpdater, newUpdater);
57         vm.prank(address(updaterManager));
58         home.setUpdater(newUpdater);
59         assertEq(home.updater(), newUpdater);
60     }
61 
62     function test_nonUpdaterManagerCannotSetUpdater() public {
63         vm.prank(vm.addr(40123));
64         vm.expectRevert("!updaterManager");
65         home.setUpdater(vm.addr(420));
66     }
67 
68     function test_setUpdaterManagerSuccess() public {
69         address newUpdater = address(0xBEEF);
70         UpdaterManager newUpdaterManager = new UpdaterManager(newUpdater);
71         vm.prank(home.owner());
72         home.setUpdaterManager(address(newUpdaterManager));
73         assertEq(address(home.updaterManager()), address(newUpdaterManager));
74         assertEq(home.updater(), newUpdater);
75     }
76 
77     function test_setUpdaterManagerOnlyOwner() public {
78         address newUpdater = address(0xBEEF);
79         UpdaterManager newUpdaterManager = new UpdaterManager(newUpdater);
80         vm.prank(newUpdater);
81         vm.expectRevert("Ownable: caller is not the owner");
82         home.setUpdaterManager(address(newUpdaterManager));
83     }
84 
85     function test_committedRoot() public virtual {
86         bytes32 emptyRoot = bytes32(0);
87         assertEq(abi.encode(home.committedRoot()), abi.encode(emptyRoot));
88     }
89 
90     function test_dispatchSuccess() public virtual {
91         uint256 nonce = home.nonces(remoteDomain);
92         (bytes memory message, uint256 leafIndex) = dispatchTestMessage();
93         (bytes32 root, , uint256 index, ) = merkleTest.getProof(message);
94         assertEq(root, home.root());
95         assert(home.queueContains(root));
96         assertEq(index, leafIndex);
97         assert(root != home.committedRoot());
98         assertEq(uint256(home.nonces(remoteDomain)), nonce + 1);
99     }
100 
101     function test_dispatchRejectBigMessage() public {
102         bytes32 recipient = bytes32(uint256(uint160(vm.addr(1505))));
103         address sender = vm.addr(1555);
104         bytes memory messageBody = new bytes(2 * 2**10 + 1);
105         vm.prank(sender);
106         vm.expectRevert("msg too long");
107         home.dispatch(remoteDomain, recipient, messageBody);
108     }
109 
110     function test_dispatchRejectFailedState() public {
111         test_improperUpdate();
112         vm.expectRevert("failed state");
113         bytes memory messageBody = hex"3432bb02";
114         bytes32 recipient = bytes32(uint256(uint160(vm.addr(1505))));
115         home.dispatch(remoteDomain, recipient, messageBody);
116     }
117 
118     function test_updateSingleMessage() public {
119         dispatchTestMessage();
120         bytes32 newRoot = home.root();
121         bytes32 oldRoot = home.committedRoot();
122         bytes memory sig = signHomeUpdate(updaterPK, oldRoot, newRoot);
123         vm.expectEmit(true, true, true, true);
124         emit Update(homeDomain, oldRoot, newRoot, sig);
125         home.update(oldRoot, newRoot, sig);
126         assertEq(newRoot, home.committedRoot());
127         assertEq(home.queueLength(), 0);
128         assert(!home.queueContains(newRoot));
129     }
130 
131     function test_notUpdaterSig() public {
132         dispatchTestMessage();
133         bytes32 newRoot = home.root();
134         bytes32 oldRoot = home.committedRoot();
135         uint256 randomFakePk = 777;
136         bytes memory sig = signHomeUpdate(randomFakePk, oldRoot, newRoot);
137         vm.expectRevert("!updater sig");
138         home.update(oldRoot, newRoot, sig);
139         assertEq(oldRoot, home.committedRoot());
140         assert(home.queueContains(newRoot));
141     }
142 
143     function test_udpdateMultipleMessages() public {
144         dispatchTestMessage();
145         dispatchTestMessage();
146         dispatchTestMessage();
147         bytes32 newRoot = home.root();
148         bytes32 oldRoot = home.committedRoot();
149         bytes memory sig = signHomeUpdate(updaterPK, oldRoot, newRoot);
150         vm.expectEmit(true, true, true, true);
151         emit Update(homeDomain, oldRoot, newRoot, sig);
152         home.update(oldRoot, newRoot, sig);
153         assertEq(newRoot, home.committedRoot());
154         assertEq(home.queueLength(), 0);
155         assert(!home.queueContains(newRoot));
156     }
157 
158     function test_udpateSomeMessages() public {
159         dispatchTestMessage();
160         bytes32 newRoot1 = home.root();
161         dispatchTestMessage();
162         bytes32 newRoot2 = home.root();
163         dispatchTestMessage();
164         bytes32 newRoot3 = home.root();
165         dispatchTestMessage();
166         bytes32 newRoot4 = home.root();
167         bytes32 oldRoot = home.committedRoot();
168         bytes memory sig = signHomeUpdate(updaterPK, oldRoot, newRoot2);
169         vm.expectEmit(true, true, true, true);
170         emit Update(homeDomain, oldRoot, newRoot2, sig);
171         home.update(oldRoot, newRoot2, sig);
172         assertEq(newRoot2, home.committedRoot());
173         assertEq(home.queueLength(), 2);
174         assert(!home.queueContains(newRoot1));
175         assert(!home.queueContains(newRoot2));
176         assert(home.queueContains(newRoot3));
177         assert(home.queueContains(newRoot4));
178     }
179 
180     function test_updateRejectFailedState() public {
181         test_improperUpdate();
182         bytes32 newRoot = home.root();
183         bytes32 oldRoot = home.committedRoot();
184         bytes memory sig = signHomeUpdate(updaterPK, oldRoot, newRoot);
185         vm.expectRevert("failed state");
186         home.update(oldRoot, newRoot, sig);
187     }
188 
189     function test_suggestUpdate() public virtual {
190         (bytes memory message, ) = dispatchTestMessage();
191         (bytes32 root, , , ) = merkleTest.getProof(message);
192         (bytes32 oldRoot, bytes32 newRoot) = home.suggestUpdate();
193         assertEq(home.committedRoot(), oldRoot);
194         assertEq(root, newRoot);
195     }
196 
197     event ImproperUpdate(bytes32 oldRoot, bytes32 newRoot, bytes signature);
198 
199     function test_improperUpdate() public {
200         bytes32 newRoot = "new root";
201         bytes32 oldRoot = home.committedRoot();
202         bytes memory sig = signHomeUpdate(updaterPK, oldRoot, newRoot);
203         vm.expectEmit(false, false, false, true);
204         emit ImproperUpdate(oldRoot, newRoot, sig);
205         home.improperUpdate(oldRoot, newRoot, sig);
206         assertEq(uint256(home.state()), uint256(NomadBase.States.Failed));
207     }
208 
209     function test_homeDomainHash() public {
210         assertEq(
211             home.homeDomainHash(),
212             keccak256(abi.encodePacked(homeDomain, "NOMAD"))
213         );
214     }
215 
216     function test_destinationAndNonce() public {
217         uint32 destination = 10;
218         uint32 nonce = 14;
219         assertEq(
220             uint256((uint64(destination) << 32) | nonce),
221             uint256(home.exposed_destinationAndNonce(destination, nonce))
222         );
223     }
224 }
