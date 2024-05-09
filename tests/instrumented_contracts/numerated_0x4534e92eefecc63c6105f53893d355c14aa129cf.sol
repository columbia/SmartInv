1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: SystemStatus.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/SystemStatus.sol
11 * Docs: https://docs.synthetix.io/contracts/SystemStatus
12 *
13 * Contract Dependencies: 
14 *	- Owned
15 * Libraries: (none)
16 *
17 * MIT License
18 * ===========
19 *
20 * Copyright (c) 2020 Synthetix
21 *
22 * Permission is hereby granted, free of charge, to any person obtaining a copy
23 * of this software and associated documentation files (the "Software"), to deal
24 * in the Software without restriction, including without limitation the rights
25 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
26 * copies of the Software, and to permit persons to whom the Software is
27 * furnished to do so, subject to the following conditions:
28 *
29 * The above copyright notice and this permission notice shall be included in all
30 * copies or substantial portions of the Software.
31 *
32 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
33 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
34 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
35 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
36 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
37 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
38 */
39 
40 /* ===============================================
41 * Flattened with Solidifier by Coinage
42 * 
43 * https://solidifier.coina.ge
44 * ===============================================
45 */
46 
47 
48 pragma solidity 0.4.25;
49 
50 
51 // https://docs.synthetix.io/contracts/Owned
52 contract Owned {
53     address public owner;
54     address public nominatedOwner;
55 
56     /**
57      * @dev Owned Constructor
58      */
59     constructor(address _owner) public {
60         require(_owner != address(0), "Owner address cannot be 0");
61         owner = _owner;
62         emit OwnerChanged(address(0), _owner);
63     }
64 
65     /**
66      * @notice Nominate a new owner of this contract.
67      * @dev Only the current owner may nominate a new owner.
68      */
69     function nominateNewOwner(address _owner) external onlyOwner {
70         nominatedOwner = _owner;
71         emit OwnerNominated(_owner);
72     }
73 
74     /**
75      * @notice Accept the nomination to be owner.
76      */
77     function acceptOwnership() external {
78         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
79         emit OwnerChanged(owner, nominatedOwner);
80         owner = nominatedOwner;
81         nominatedOwner = address(0);
82     }
83 
84     modifier onlyOwner {
85         require(msg.sender == owner, "Only the contract owner may perform this action");
86         _;
87     }
88 
89     event OwnerNominated(address newOwner);
90     event OwnerChanged(address oldOwner, address newOwner);
91 }
92 
93 
94 // https://docs.synthetix.io/contracts/SystemStatus
95 contract SystemStatus is Owned {
96     struct Status {
97         bool canSuspend;
98         bool canResume;
99     }
100 
101     mapping(bytes32 => mapping(address => Status)) public accessControl;
102 
103     struct Suspension {
104         bool suspended;
105         // reason is an integer code,
106         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
107         uint248 reason;
108     }
109 
110     uint248 public constant SUSPENSION_REASON_UPGRADE = 1;
111 
112     bytes32 public constant SECTION_SYSTEM = "System";
113     bytes32 public constant SECTION_ISSUANCE = "Issuance";
114     bytes32 public constant SECTION_EXCHANGE = "Exchange";
115     bytes32 public constant SECTION_SYNTH = "Synth";
116 
117     Suspension public systemSuspension;
118 
119     Suspension public issuanceSuspension;
120 
121     Suspension public exchangeSuspension;
122 
123     mapping(bytes32 => Suspension) public synthSuspension;
124 
125     constructor(address _owner) public Owned(_owner) {
126         _internalUpdateAccessControl(SECTION_SYSTEM, _owner, true, true);
127         _internalUpdateAccessControl(SECTION_ISSUANCE, _owner, true, true);
128         _internalUpdateAccessControl(SECTION_EXCHANGE, _owner, true, true);
129         _internalUpdateAccessControl(SECTION_SYNTH, _owner, true, true);
130     }
131 
132     /* ========== VIEWS ========== */
133     function requireSystemActive() external view {
134         _internalRequireSystemActive();
135     }
136 
137     function requireIssuanceActive() external view {
138         // Issuance requires the system be active
139         _internalRequireSystemActive();
140         require(!issuanceSuspension.suspended, "Issuance is suspended. Operation prohibited");
141     }
142 
143     function requireExchangeActive() external view {
144         // Issuance requires the system be active
145         _internalRequireSystemActive();
146         require(!exchangeSuspension.suspended, "Exchange is suspended. Operation prohibited");
147     }
148 
149     function requireSynthActive(bytes32 currencyKey) external view {
150         // Synth exchange and transfer requires the system be active
151         _internalRequireSystemActive();
152         require(!synthSuspension[currencyKey].suspended, "Synth is suspended. Operation prohibited");
153     }
154 
155     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view {
156         // Synth exchange and transfer requires the system be active
157         _internalRequireSystemActive();
158 
159         require(
160             !synthSuspension[sourceCurrencyKey].suspended && !synthSuspension[destinationCurrencyKey].suspended,
161             "One or more synths are suspended. Operation prohibited"
162         );
163     }
164 
165     function isSystemUpgrading() external view returns (bool) {
166         return systemSuspension.suspended && systemSuspension.reason == SUSPENSION_REASON_UPGRADE;
167     }
168 
169     function getSynthSuspensions(bytes32[] synths)
170         external
171         view
172         returns (bool[] memory suspensions, uint256[] memory reasons)
173     {
174         suspensions = new bool[](synths.length);
175         reasons = new uint256[](synths.length);
176 
177         for (uint i = 0; i < synths.length; i++) {
178             suspensions[i] = synthSuspension[synths[i]].suspended;
179             reasons[i] = synthSuspension[synths[i]].reason;
180         }
181     }
182 
183     /* ========== MUTATIVE FUNCTIONS ========== */
184     function updateAccessControl(bytes32 section, address account, bool canSuspend, bool canResume) external onlyOwner {
185         _internalUpdateAccessControl(section, account, canSuspend, canResume);
186     }
187 
188     function suspendSystem(uint256 reason) external {
189         _requireAccessToSuspend(SECTION_SYSTEM);
190         systemSuspension.suspended = true;
191         systemSuspension.reason = uint248(reason);
192         emit SystemSuspended(systemSuspension.reason);
193     }
194 
195     function resumeSystem() external {
196         _requireAccessToResume(SECTION_SYSTEM);
197         systemSuspension.suspended = false;
198         emit SystemResumed(uint256(systemSuspension.reason));
199         systemSuspension.reason = 0;
200     }
201 
202     function suspendIssuance(uint256 reason) external {
203         _requireAccessToSuspend(SECTION_ISSUANCE);
204         issuanceSuspension.suspended = true;
205         issuanceSuspension.reason = uint248(reason);
206         emit IssuanceSuspended(reason);
207     }
208 
209     function resumeIssuance() external {
210         _requireAccessToResume(SECTION_ISSUANCE);
211         issuanceSuspension.suspended = false;
212         emit IssuanceResumed(uint256(issuanceSuspension.reason));
213         issuanceSuspension.reason = 0;
214     }
215 
216     function suspendExchange(uint256 reason) external {
217         _requireAccessToSuspend(SECTION_EXCHANGE);
218         exchangeSuspension.suspended = true;
219         exchangeSuspension.reason = uint248(reason);
220         emit ExchangeSuspended(reason);
221     }
222 
223     function resumeExchange() external {
224         _requireAccessToResume(SECTION_EXCHANGE);
225         exchangeSuspension.suspended = false;
226         emit ExchangeResumed(uint256(exchangeSuspension.reason));
227         exchangeSuspension.reason = 0;
228     }
229 
230     function suspendSynth(bytes32 currencyKey, uint256 reason) external {
231         _requireAccessToSuspend(SECTION_SYNTH);
232         synthSuspension[currencyKey].suspended = true;
233         synthSuspension[currencyKey].reason = uint248(reason);
234         emit SynthSuspended(currencyKey, reason);
235     }
236 
237     function resumeSynth(bytes32 currencyKey) external {
238         _requireAccessToResume(SECTION_SYNTH);
239         emit SynthResumed(currencyKey, uint256(synthSuspension[currencyKey].reason));
240         delete synthSuspension[currencyKey];
241     }
242 
243     /* ========== INTERNAL FUNCTIONS ========== */
244 
245     function _requireAccessToSuspend(bytes32 section) internal view {
246         require(accessControl[section][msg.sender].canSuspend, "Restricted to access control list");
247     }
248 
249     function _requireAccessToResume(bytes32 section) internal view {
250         require(accessControl[section][msg.sender].canResume, "Restricted to access control list");
251     }
252 
253     function _internalRequireSystemActive() internal view {
254         require(
255             !systemSuspension.suspended,
256             systemSuspension.reason == SUSPENSION_REASON_UPGRADE
257                 ? "Synthetix is suspended, upgrade in progress... please stand by"
258                 : "Synthetix is suspended. Operation prohibited"
259         );
260     }
261 
262     function _internalUpdateAccessControl(bytes32 section, address account, bool canSuspend, bool canResume) internal {
263         require(
264             section == SECTION_SYSTEM ||
265                 section == SECTION_ISSUANCE ||
266                 section == SECTION_EXCHANGE ||
267                 section == SECTION_SYNTH,
268             "Invalid section supplied"
269         );
270         accessControl[section][account].canSuspend = canSuspend;
271         accessControl[section][account].canResume = canResume;
272         emit AccessControlUpdated(section, account, canSuspend, canResume);
273     }
274 
275     /* ========== EVENTS ========== */
276 
277     event SystemSuspended(uint256 reason);
278     event SystemResumed(uint256 reason);
279 
280     event IssuanceSuspended(uint256 reason);
281     event IssuanceResumed(uint256 reason);
282 
283     event ExchangeSuspended(uint256 reason);
284     event ExchangeResumed(uint256 reason);
285 
286     event SynthSuspended(bytes32 currencyKey, uint256 reason);
287     event SynthResumed(bytes32 currencyKey, uint256 reason);
288 
289     event AccessControlUpdated(bytes32 indexed section, address indexed account, bool canSuspend, bool canResume);
290 }
291 
292 
293     