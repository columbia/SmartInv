1 pragma solidity ^0.4.4;
2 
3 /**
4  * The ENS registry contract.
5  */
6 contract ENS {
7     // Logged when the owner of a node assigns a new owner to a subnode.
8     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
9 
10     // Logged when the owner of a node transfers ownership to a new account.
11     event Transfer(bytes32 indexed node, address owner);
12 
13     // Logged when the resolver for a node changes.
14     event NewResolver(bytes32 indexed node, address resolver);
15 
16     // Logged when the TTL of a node changes
17     event NewTTL(bytes32 indexed node, uint64 ttl);
18 
19     struct Record {
20         address owner;
21         address resolver;
22         uint64 ttl;
23     }
24 
25     mapping(bytes32=>Record) records;
26 
27     // Permits modifications only by the owner of the specified node.
28     modifier only_owner(bytes32 node) {
29         if (records[node].owner != msg.sender) throw;
30         _;
31     }
32 
33     /**
34      * Constructs a new ENS registrar.
35      */
36     function ENS() {
37         records[0].owner = msg.sender;
38     }
39 
40     /**
41      * Returns the address that owns the specified node.
42      */
43     function owner(bytes32 node) constant returns (address) {
44         return records[node].owner;
45     }
46 
47     /**
48      * Returns the address of the resolver for the specified node.
49      */
50     function resolver(bytes32 node) constant returns (address) {
51         return records[node].resolver;
52     }
53 
54     /**
55      * Returns the TTL of a node, and any records associated with it.
56      */
57     function ttl(bytes32 node) constant returns (uint64) {
58         return records[node].ttl;
59     }
60 
61     /**
62      * Transfers ownership of a node to a new address. May only be called by the current
63      * owner of the node.
64      * @param node The node to transfer ownership of.
65      * @param owner The address of the new owner.
66      */
67     function setOwner(bytes32 node, address owner) only_owner(node) {
68         Transfer(node, owner);
69         records[node].owner = owner;
70     }
71 
72     /**
73      * Transfers ownership of a subnode sha3(node, label) to a new address. May only be
74      * called by the owner of the parent node.
75      * @param node The parent node.
76      * @param label The hash of the label specifying the subnode.
77      * @param owner The address of the new owner.
78      */
79     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) only_owner(node) {
80         var subnode = sha3(node, label);
81         NewOwner(node, label, owner);
82         records[subnode].owner = owner;
83     }
84 
85     /**
86      * Sets the resolver address for the specified node.
87      * @param node The node to update.
88      * @param resolver The address of the resolver.
89      */
90     function setResolver(bytes32 node, address resolver) only_owner(node) {
91         NewResolver(node, resolver);
92         records[node].resolver = resolver;
93     }
94 
95     /**
96      * Sets the TTL for the specified node.
97      * @param node The node to update.
98      * @param ttl The TTL in seconds.
99      */
100     function setTTL(bytes32 node, uint64 ttl) only_owner(node) {
101         NewTTL(node, ttl);
102         records[node].ttl = ttl;
103     }
104 }
105 
106 /**
107  * @dev A basic interface for ENS resolvers.
108  */
109 contract Resolver {
110   function supportsInterface(bytes4 interfaceID) public pure returns (bool);
111   function addr(bytes32 node) public view returns (address);
112   function setAddr(bytes32 node, address addr) public;
113 }
114 
115 contract RegistrarInterface {
116   event OwnerChanged(bytes32 indexed label, address indexed oldOwner, address indexed newOwner);
117   event DomainConfigured(bytes32 indexed label);
118   event DomainUnlisted(bytes32 indexed label);
119   event NewRegistration(bytes32 indexed label, string subdomain, address indexed owner, address indexed referrer, uint price);
120   event RentPaid(bytes32 indexed label, string subdomain, uint amount, uint expirationDate);
121 
122   // InterfaceID of these four methods is 0xc1b15f5a
123   function query(bytes32 label, string subdomain) view returns(string domain, uint signupFee, uint rent, uint referralFeePPM);
124   function register(bytes32 label, string subdomain, address owner, address referrer, address resolver) public payable;
125 
126   function rentDue(bytes32 label, string subdomain) public view returns(uint timestamp);
127   function payRent(bytes32 label, string subdomain) public payable;
128 }
129 /**
130  * @dev Implements an ENS registrar that sells subdomains on behalf of their owners.
131  *
132  * Users may register a subdomain by calling `register` with the name of the domain
133  * they wish to register under, and the label hash of the subdomain they want to
134  * register. They must also specify the new owner of the domain, and the referrer,
135  * who is paid an optional finder's fee. The registrar then configures a simple
136  * default resolver, which resolves `addr` lookups to the new owner, and sets
137  * the `owner` account as the owner of the subdomain in ENS.
138  *
139  * New domains may be added by calling `configureDomain`, then transferring
140  * ownership in the ENS registry to this contract. Ownership in the contract
141  * may be transferred using `transfer`, and a domain may be unlisted for sale
142  * using `unlistDomain`. There is (deliberately) no way to recover ownership
143  * in ENS once the name is transferred to this registrar.
144  *
145  * Critically, this contract does not check two key properties of a listed domain:
146  *
147  * - Is the name UTS46 normalised?
148  * - Is the Deed held by an appropriate custodian contract?
149  *
150  * User applications MUST check these two elements for each domain before
151  * offering them to users for registration.
152  *
153  * Applications should additionally check that the domains they are offering to
154  * register are controlled by this registrar, since calls to `register` will
155  * fail if this is not the case.
156  */
157 contract SubdomainRegistrar is RegistrarInterface {
158   // namehash('eth')
159   bytes32 constant public TLD_NODE = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
160 
161   ENS public ens;
162 
163   struct Domain {
164     string name;
165     address owner;
166     uint price;
167     uint referralFeePPM;
168   }
169 
170   mapping(bytes32=>Domain) domains;
171 
172   function SubdomainRegistrar(ENS _ens) public {
173     ens = _ens;
174   }
175 
176   /**
177    * @dev owner returns the address of the account that controls a domain.
178    *      Initially this is the owner of the name in ENS. If the name has been
179    *      transferred to this contract, then the internal mapping is consulted
180    *      to determine who controls it.
181    * @param label The label hash of the deed to check.
182    * @return The address owning the deed.
183    */
184   function owner(bytes32 label) public view returns(address ret) {
185       ret = ens.owner(keccak256(TLD_NODE, label));
186       if(ret == address(this)) {
187         ret = domains[label].owner;
188       }
189   }
190 
191   modifier owner_only(bytes32 label) {
192       require(owner(label) == msg.sender);
193       _;
194   }
195 
196   /**
197    * @dev Transfers internal control of a name to a new account. Does not update
198    *      ENS.
199    * @param name The name to transfer.
200    * @param newOwner The address of the new owner.
201    */
202   function transfer(string name, address newOwner) public owner_only(keccak256(name)) {
203     var label = keccak256(name);
204     OwnerChanged(keccak256(name), domains[label].owner, newOwner);
205     domains[label].owner = newOwner;
206   }
207 
208   /**
209    * @dev Sets the resolver record for a name in ENS.
210    * @param name The name to set the resolver for.
211    * @param resolver The address of the resolver
212    */
213   function setResolver(string name, address resolver) public owner_only(keccak256(name)) {
214     var label = keccak256(name);
215     var node = keccak256(TLD_NODE, label);
216     ens.setResolver(node, resolver);
217   }
218 
219   /**
220    * @dev Configures a domain for sale.
221    * @param name The name to configure.
222    * @param price The price in wei to charge for subdomain registrations
223    * @param referralFeePPM The referral fee to offer, in parts per million
224    */
225   function configureDomain(string name, uint price, uint referralFeePPM) public owner_only(keccak256(name)) {
226     var label = keccak256(name);
227     var domain = domains[label];
228 
229     if(keccak256(domain.name) != label) {
230       // New listing
231       domain.name = name;
232     }
233     if(domain.owner != msg.sender) {
234       domain.owner = msg.sender;
235     }
236     domain.price = price;
237     domain.referralFeePPM = referralFeePPM;
238     DomainConfigured(label);
239   }
240 
241   /**
242    * @dev Unlists a domain
243    * May only be called by the owner.
244    * @param name The name of the domain to unlist.
245    */
246   function unlistDomain(string name) public owner_only(keccak256(name)) {
247     var label = keccak256(name);
248     var domain = domains[label];
249     DomainUnlisted(label);
250 
251     domain.name = '';
252     domain.owner = owner(label);
253     domain.price = 0;
254     domain.referralFeePPM = 0;
255   }
256 
257   /**
258    * @dev Returns information about a subdomain.
259    * @param label The label hash for the domain.
260    * @param subdomain The label for the subdomain.
261    * @return domain The name of the domain, or an empty string if the subdomain
262    *                is unavailable.
263    * @return price The price to register a subdomain, in wei.
264    * @return rent The rent to retain a subdomain, in wei per second.
265    * @return referralFeePPM The referral fee for the dapp, in ppm.
266    */
267   function query(bytes32 label, string subdomain) view returns(string domain, uint price, uint rent, uint referralFeePPM) {
268     var node = keccak256(TLD_NODE, label);
269     var subnode = keccak256(node, keccak256(subdomain));
270 
271     if(ens.owner(subnode) != 0) {
272       return ('', 0, 0, 0);
273     }
274 
275     var data = domains[label];
276     return (data.name, data.price, 0, data.referralFeePPM);
277   }
278 
279   /**
280    * @dev Registers a subdomain.
281    * @param label The label hash of the domain to register a subdomain of.
282    * @param subdomain The desired subdomain label.
283    * @param subdomainOwner The account that should own the newly configured subdomain.
284    * @param referrer The address of the account to receive the referral fee.
285    */
286   function register(bytes32 label, string subdomain, address subdomainOwner, address resolver, address referrer) public payable {
287     var domainNode = keccak256(TLD_NODE, label);
288     var subdomainLabel = keccak256(subdomain);
289 
290     // Subdomain must not be registered already.
291     require(ens.owner(keccak256(domainNode, subdomainLabel)) == address(0));
292 
293     var domain = domains[label];
294 
295     // Domain must be available for registration
296     require(keccak256(domain.name) == label);
297 
298     // User must have paid enough
299     require(msg.value >= domain.price);
300 
301     // Send any extra back
302     if(msg.value > domain.price) {
303       msg.sender.transfer(msg.value - domain.price);
304     }
305 
306     // Send any referral fee
307     var total = domain.price;
308     if(domain.referralFeePPM * domain.price > 0 && referrer != 0 && referrer != domain.owner) {
309       var referralFee = (domain.price * domain.referralFeePPM) / 1000000;
310       referrer.transfer(referralFee);
311       total -= referralFee;
312     }
313 
314     // Send the registration fee
315     if(total > 0) {
316       domain.owner.transfer(total);
317     }
318 
319     // Register the domain
320     if(subdomainOwner == 0) {
321       subdomainOwner = msg.sender;
322     }
323     doRegistration(domainNode, subdomainLabel, subdomainOwner, Resolver(resolver));
324 
325     NewRegistration(label, subdomain, subdomainOwner, referrer, domain.price);
326   }
327 
328   function doRegistration(bytes32 node, bytes32 label, address subdomainOwner, Resolver resolver) internal {
329     // Get the subdomain so we can configure it
330     ens.setSubnodeOwner(node, label, this);
331 
332     var subnode = keccak256(node, label);
333     // Set the subdomain's resolver
334     ens.setResolver(subnode, resolver);
335 
336     // Set the address record on the resolver
337     resolver.setAddr(subnode, subdomainOwner);
338 
339     // Pass ownership of the new subdomain to the registrant
340     ens.setOwner(subnode, subdomainOwner);
341   }
342 
343   function supportsInterface(bytes4 interfaceID) constant returns (bool) {
344     return (
345          (interfaceID == 0x01ffc9a7) // supportsInterface(bytes4)
346       || (interfaceID == 0xc1b15f5a) // RegistrarInterface
347     );
348   }
349 
350   function rentDue(bytes32 label, string subdomain) public view returns(uint timestamp) {
351     return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
352   }
353 
354   function payRent(bytes32 label, string subdomain) public payable {
355     revert();
356   }
357 }