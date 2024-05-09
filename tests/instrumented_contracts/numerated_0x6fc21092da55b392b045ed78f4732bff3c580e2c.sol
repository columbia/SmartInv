1 pragma solidity ^0.4.0;
2 
3 contract AbstractENS {
4     function owner(bytes32 node) constant returns(address);
5     function resolver(bytes32 node) constant returns(address);
6     function setOwner(bytes32 node, address owner);
7     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
8     function setResolver(bytes32 node, address resolver);
9 }
10 
11 contract Resolver {
12     function setAddr(bytes32 nodeHash, address addr);
13 }
14 contract ReverseRegistrar {
15     function claim(address owner) returns (bytes32 node);
16 }
17 
18 
19 /**
20  *  FireflyRegistrar
21  *
22  *  This registrar allows arbitrary labels below the root node for a fixed minimum fee.
23  *  Labels must conform to the regex /^[a-z0-9-]{4, 20}$/.
24  *
25  *  Admin priviledges:
26  *    - change the admin
27  *    - change the fee
28  *    - change the default resolver
29  *    - withdrawl funds
30  *
31  *  This resolver should is designed to be self-contained, so that in the future
32  *  switching to a new Resolver should not impact this one.
33  *
34  */
35 contract FireflyRegistrar {
36      // namehash('addr.reverse')
37      bytes32 constant RR_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
38 
39     // Admin triggered events
40     event adminChanged(address oldAdmin, address newAdmin);
41     event feeChanged(uint256 oldFee, uint256 newFee);
42     event defaultResolverChanged(address oldResolver, address newResolver);
43     event didWithdraw(address target, uint256 amount);
44 
45     // Registration
46     event nameRegistered(bytes32 indexed nodeHash, address owner, uint256 fee);
47 
48     // Donations
49     event donation(bytes32 indexed nodeHash, uint256 amount);
50 
51     AbstractENS _ens;
52     Resolver _defaultResolver;
53 
54     address _admin;
55     bytes32 _nodeHash;
56 
57     uint256 _fee;
58 
59     uint256 _totalPaid = 0;
60     uint256 _nameCount = 0;
61 
62     mapping (bytes32 => uint256) _donations;
63 
64     function FireflyRegistrar(address ens, bytes32 nodeHash, address defaultResolver) {
65         _ens = AbstractENS(ens);
66         _nodeHash = nodeHash;
67         _defaultResolver = Resolver(defaultResolver);
68 
69         _admin = msg.sender;
70 
71         _fee = 0.1 ether;
72 
73         // Give the admin access to the reverse entry
74         ReverseRegistrar(_ens.owner(RR_NODE)).claim(_admin);
75     }
76 
77     /**
78      *  setAdmin(admin)
79      *
80      *  Change the admin of this contract. This should be used shortly after
81      *  deployment and live testing to switch to a multi-sig contract.
82      */
83     function setAdmin(address admin) {
84         if (msg.sender != _admin) { throw; }
85 
86         adminChanged(_admin, admin);
87         _admin = admin;
88 
89         // Give the admin access to the reverse entry
90         ReverseRegistrar(_ens.owner(RR_NODE)).claim(admin);
91 
92         // Point the resolved addr to the new admin
93         Resolver(_ens.resolver(_nodeHash)).setAddr(_nodeHash, _admin);
94     }
95 
96     /**
97      *  setFee(fee)
98      *
99      *  This is useful if the price of ether sky-rockets or plummets, but
100      *  for the most part should remain unused
101      */
102     function setFee(uint256 fee) {
103         if (msg.sender != _admin) { throw; }
104         feeChanged(_fee, fee);
105         _fee = fee;
106     }
107 
108     /**
109      *  setDefaultResolver(resolver)
110      *
111      *  Allow the admin to change the default resolver that is setup with
112      *  new name registrations.
113      */
114     function setDefaultResolver(address defaultResolver) {
115         if (msg.sender != _admin) { throw; }
116         defaultResolverChanged(_defaultResolver, defaultResolver);
117         _defaultResolver = Resolver(defaultResolver);
118     }
119 
120     /**
121      *  withdraw(target, amount)
122      *
123      *  Allow the admin to withdrawl funds.
124      */
125     function withdraw(address target, uint256 amount) {
126         if (msg.sender != _admin) { throw; }
127         if (!target.send(amount)) { throw; }
128         didWithdraw(target, amount);
129     }
130 
131     /**
132      *  register(label)
133      *
134      *  Allows anyone to send *fee* ether to the contract with a name to register.
135      *
136      *  Note: A name must match the regex /^[a-z0-9-]{4,20}$/
137      */
138     function register(string label) payable {
139 
140         // Check the label is legal
141         uint256 position;
142         uint256 length;
143         assembly {
144             // The first word of a string is its length
145             length := mload(label)
146 
147             // The first character position is the beginning of the second word
148             position := add(label, 1)
149         }
150 
151         // Labels must be at least 4 characters and at most 20 characters
152         if (length < 4 || length > 20) { throw; }
153 
154         // Only allow /^[a-z0-9-]*$/
155         for (uint256 i = 0; i < length; i++) {
156             uint8 c;
157             assembly { c := and(mload(position), 0xFF) }
158             //       'a'         'z'           '0'         '9'           '-'
159             if ((c < 0x61 || c > 0x7a) && (c < 0x30 || c > 0x39) && c != 0x2d) {
160                 throw;
161             }
162             position++;
163         }
164 
165         // Paid too little; participants may pay more (as a donation)
166         if (msg.value < _fee) { throw; }
167 
168         // Compute the label and node hash
169         var labelHash = sha3(label);
170         var nodeHash = sha3(_nodeHash, labelHash);
171 
172         // This is already owned in ENS
173         if (_ens.owner(nodeHash) != address(0)) { throw; }
174 
175         // Make this registrar the owner (so we can set it up before giving it away)
176         _ens.setSubnodeOwner(_nodeHash, labelHash, this);
177 
178         // Set up the default resolver and point to the sender
179         _ens.setResolver(nodeHash, _defaultResolver);
180         _defaultResolver.setAddr(nodeHash, msg.sender);
181 
182         // Now give it to the sender
183         _ens.setOwner(nodeHash, msg.sender);
184 
185         _totalPaid += msg.value;
186         _nameCount++;
187 
188         _donations[nodeHash] += msg.value;
189 
190         nameRegistered(nodeHash, msg.sender, msg.value);
191         donation(nodeHash, msg.value);
192     }
193 
194     /**
195      *  donate(nodeHash)
196      *
197      *  Allow a registered name to donate more and get attribution. This may
198      *  be useful if special limited edition Firefly devices are awarded to
199      *  certain tiers of donors or such.
200      */
201     function donate(bytes32 nodeHash) payable {
202         _donations[nodeHash] += msg.value;
203         donation(nodeHash, msg.value);
204     }
205 
206     /**
207      *  config()
208      *
209      *  Get the configuration of this registrar.
210      */
211     function config() constant returns (address ens, bytes32 nodeHash, address admin, uint256 fee, address defaultResolver) {
212         ens = _ens;
213         nodeHash = _nodeHash;
214         admin = _admin;
215         fee = _fee;
216         defaultResolver = _defaultResolver;
217     }
218 
219     /**
220      *  stats()
221      *
222      *  Get some statistics for this registrar.
223      */
224     function stats() constant returns (uint256 nameCount, uint256 totalPaid, uint256 balance) {
225         nameCount = _nameCount;
226         totalPaid = _totalPaid;
227         balance = this.balance;
228     }
229 
230     /**
231      *  donations(nodeHash)
232      *
233      *  Returns the amount of donations a nodeHash has provided.
234      */
235     function donations(bytes32 nodeHash) constant returns (uint256 donation) {
236         return _donations[nodeHash];
237     }
238 
239     /**
240      *  fee()
241      *
242      *  The current fee forregistering a name.
243      */
244     function fee() constant returns (uint256 fee) {
245         return _fee;
246     }
247 
248     /**
249      *  Allow anonymous donations.
250      */
251     function () payable {
252         _donations[0] += msg.value;
253         donation(0, msg.value);
254     }
255 }