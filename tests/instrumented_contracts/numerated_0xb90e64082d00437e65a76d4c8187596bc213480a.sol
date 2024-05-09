1 /**
2  *  StickerRegistry
3  *
4  *  This is a simple contract to implement a demo of a collectible blockchain
5  *  item.
6  *
7  *  As part of the Firefly Crowdsale, backers and participants of various events
8  *  will receive limited edition Firefly stickers. Each sticker is procedurally
9  *  generated and unique. The ownership of the sticker is tracked by an instance
10  *  of this contract.
11  *
12  *  Since many people will likely not care about the actual sticker, ownership
13  *  and all that jazz, this has been designed to be very gas effecient from the
14  *  project owner's point of view.
15  *
16  *  When a new series is minted, the entire series manifest is made public, along with
17  *  a list of faux owners. Each faux owner is an address, for which there exists a
18  *  secret, which can be used to generate a private key and claim the sticker by
19  *  signing a message (the destination address) and calling this contract.
20  *
21  *  All the faux owners along with their sticker serial number are used to create a
22  *  merkle tree, of which only the merkle root is registered with the set.
23  *
24  *  Nomenclature
25  *   - Serial Number:  1-indexed (human ordinal) index into the list of items/redeem codes
26  *   - item index:     0-indexed (mchine ordinal) representation of the Serial Number
27  */
28 
29 /**
30  *  Why use ENS?
31  *   - Enforces series name uniqueness
32  *   - Offloads series ownership and name collision disputes
33  *   - Hierarchical (e.g. weatherlight.mtg.wotc.eth)
34  *   - Strong authenticity and identity
35  *   - Prevents spam
36  *   - A well-adopted standard that will be maintained and extended
37  */
38 
39 // See: https://github.com/firefly/stickers
40 
41 
42 pragma solidity ^0.4.16;
43 
44 // This is only used to enable token withdrawl incase this contract is
45 // somehow given some (e.g. airdopped)
46 contract Token {
47     function approve(address, uint256) returns (bool);
48 }
49 
50 // We use ENS to manage series ownership
51 contract AbstractENS {
52     function owner(bytes32) constant returns(address);
53     function resolver(bytes32) constant returns(address);
54 }
55 
56 contract Resolver {
57     function addr(bytes32);
58 }
59 
60 contract ReverseRegistrar {
61     function claim(address) returns (bytes32);
62 }
63 
64 
65 
66 contract StickerRegistry {
67 
68     // namehash('addr.reverse')
69     bytes32 constant RR_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
70 
71     event seriesCreated(bytes32 indexed nodehash);
72 
73     event itemTransferred(
74         bytes32 indexed nodehash,
75         uint256 itemIndex,
76         address indexed oldOwner,
77         address indexed newOwner
78     );
79 
80 
81     struct Series {
82         // The name of the series (the namehash of this should resovle to the nodehash)
83         string name;
84 
85         // The merkle root of all stikers in the series
86         bytes32 rootHash;
87 
88         // The initial number of cards issued
89         uint256 initialCount;
90 
91         // How many have been claimed
92         uint256 issuedCount;
93 
94         // The total number in existance after taking provable burning into account
95         uint256 currentCount;
96 
97         // Maps a serial number to an owner
98         mapping (uint256 => address) owners;
99     }
100 
101     AbstractENS _ens;
102 
103     address _owner;
104 
105     mapping (bytes32 => Series) _series;
106 
107 
108     function StickerRegistry(address ens) {
109         _owner = msg.sender;
110         _ens = AbstractENS(ens);
111 
112         // Give the owner access to the reverse entry
113         ReverseRegistrar(_ens.owner(RR_NODE)).claim(_owner);
114     }
115 
116     function setOwner(address newOwner) {
117         require(msg.sender == _owner);
118         _owner = newOwner;
119 
120         // Give the owner access to the reverse entry
121         ReverseRegistrar(_ens.owner(RR_NODE)).claim(_owner);
122     }
123 
124     // Bailout - Just in case this contract ever receives funds
125     function withdraw(address target, uint256 amount) {
126         require(msg.sender == _owner);
127         assert(target.send(amount));
128     }
129 
130     // Bailout - Just in case this contract ever received tokens
131     function approveToken(address token, uint256 amount) {
132         require(msg.sender == _owner);
133         assert(Token(token).approve(_owner, amount));
134     }
135 
136 
137     // Create a new series
138     function createSeries(bytes32 nodehash, string seriesName, bytes32 rootHash, uint256 initialCount) returns (bool success) {
139 
140         // Only the ENS owner of the nodehash may create this series
141         if (msg.sender != _ens.owner(nodehash)) { return false; }
142 
143         if (rootHash == 0x00) { return false; }
144 
145         Series storage series = _series[nodehash];
146 
147         // Already exists!
148         if (series.rootHash != 0x00) { return false; }
149 
150         series.name = seriesName;
151         series.rootHash = rootHash;
152         series.initialCount = initialCount;
153         series.currentCount = initialCount;
154 
155         seriesCreated(nodehash);
156     }
157 
158     // Allow the owner to transfer un-claimed items (they already have the
159     // redeem codes, so there is no additional trust required)
160     function bestow(bytes32 nodehash, uint256 itemIndex, address owner) returns (bool success) {
161 
162         // Only the ENS owner of nodehash may bestow
163         if (_ens.owner(nodehash) != msg.sender) { return false; }
164 
165         Series storage series = _series[nodehash];
166 
167         if (itemIndex >= series.initialCount) { return false; }
168 
169         // Already claimed
170         if (series.owners[itemIndex] != 0) { return false; }
171 
172         // Burning...
173         if (owner == 0xdead) { series.currentCount--; }
174 
175         series.issuedCount++;
176 
177         series.owners[itemIndex] = owner;
178 
179         itemTransferred(nodehash, itemIndex, 0x0, owner);
180     }
181 
182     // Allow a user to claim an item using their redeem code
183     function claim(bytes32 nodehash, uint256 itemIndex, address owner, uint8 sigV, bytes32 sigR, bytes32 sigS,  bytes32[] merkleProof) returns (bool success) {
184         Series storage series = _series[nodehash];
185 
186         if (itemIndex >= series.initialCount) { return false; }
187 
188         // Already claimed
189         if (series.owners[itemIndex] != 0) { return false; }
190 
191         uint256 path = itemIndex;
192 
193         // Compute the redeem code address from the provided proof
194         address fauxOwner = ecrecover(bytes32(owner), sigV, sigR, sigS);
195 
196         // Verify the merkle proof
197         bytes32 node = keccak256(nodehash, itemIndex, bytes32(fauxOwner));
198         for (uint16 i = 0; i < merkleProof.length; i++) {
199             if ((path & 0x01) == 1) {
200                 node = keccak256(merkleProof[i], node);
201             } else {
202                 node = keccak256(node, merkleProof[i]);
203             }
204             path /= 2;
205         }
206 
207         // Failed merkle proof
208         if (node != series.rootHash) { return false; }
209 
210         // Assign the caller as the owner
211         series.owners[itemIndex] = owner;
212 
213         // One more has been issued
214         series.issuedCount++;
215 
216         itemTransferred(nodehash, itemIndex, 0x0, owner);
217 
218         return true;
219     }
220 
221     // Allow item owners to transfer to another account
222     function transfer(bytes32 nodehash, uint256 itemIndex, address newOwner) returns (bool success) {
223 
224         // Do not allow transfering to 0 (would allow claiming again)
225         if (newOwner == 0) { return false; }
226 
227         Series storage series = _series[nodehash];
228 
229         address currentOwner = series.owners[itemIndex];
230 
231         // Only the owner can transfer a item
232         if (currentOwner != msg.sender) {
233             return false;
234         }
235 
236         // Burining! Anyone may choose to destroy a sticker to provably lower
237         // its total supply
238         if (newOwner == 0xdead) { series.currentCount--; }
239 
240         itemTransferred(nodehash, itemIndex, currentOwner, newOwner);
241 
242         // Assign the new owner
243         series.owners[itemIndex] = newOwner;
244 
245         return true;
246     }
247 
248 
249     // Get the contract owner
250     function owner() constant returns (address) {
251         return _owner;
252     }
253 
254     // Get details about a given series
255     function seriesInfo(bytes32 nodehash) constant returns (string name, bytes32 rootHash, uint256 initialCount, uint256 issuedCount, uint256 currentCount) {
256         Series storage series = _series[nodehash];
257         return (series.name, series.rootHash, series.initialCount, series.issuedCount, series.currentCount);
258     }
259 
260     // Get the owner of an item
261     function itemOwner(bytes32 nodehash, uint256 itemIndex) constant returns (address) {
262         return _series[nodehash].owners[itemIndex];
263     }
264 }