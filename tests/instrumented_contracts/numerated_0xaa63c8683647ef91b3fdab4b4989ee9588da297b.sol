1 pragma solidity ^0.4.18;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     function DSAuth() public {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSNote {
58     event LogNote(
59         bytes4   indexed  sig,
60         address  indexed  guy,
61         bytes32  indexed  foo,
62         bytes32  indexed  bar,
63         uint              wad,
64         bytes             fax
65     ) anonymous;
66 
67     modifier note {
68         bytes32 foo;
69         bytes32 bar;
70 
71         assembly {
72             foo := calldataload(4)
73             bar := calldataload(36)
74         }
75 
76         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
77 
78         _;
79     }
80 }
81 
82 // DSProxy
83 // Allows code execution using a persistant identity This can be very
84 // useful to execute a sequence of atomic actions. Since the owner of
85 // the proxy can be changed, this allows for dynamic ownership models
86 // i.e. a multisig
87 contract DSProxy is DSAuth, DSNote {
88     DSProxyCache public cache;  // global cache for contracts
89 
90     function DSProxy(address _cacheAddr) public {
91         require(setCache(_cacheAddr));
92     }
93 
94     function() public payable {
95     }
96 
97     // use the proxy to execute calldata _data on contract _code
98     function execute(bytes _code, bytes _data)
99         public
100         payable
101         returns (address target, bytes32 response)
102     {
103         target = cache.read(_code);
104         if (target == 0x0) {
105             // deploy contract & store its address in cache
106             target = cache.write(_code);
107         }
108 
109         response = execute(target, _data);
110     }
111 
112     function execute(address _target, bytes _data)
113         public
114         auth
115         note
116         payable
117         returns (bytes32 response)
118     {
119         require(_target != 0x0);
120 
121         // call contract in current context
122         assembly {
123             let succeeded := delegatecall(sub(gas, 5000), _target, add(_data, 0x20), mload(_data), 0, 32)
124             response := mload(0)      // load delegatecall output
125             switch iszero(succeeded)
126             case 1 {
127                 // throw if delegatecall failed
128                 revert(0, 0)
129             }
130         }
131     }
132 
133     //set new cache
134     function setCache(address _cacheAddr)
135         public
136         auth
137         note
138         returns (bool)
139     {
140         require(_cacheAddr != 0x0);        // invalid cache address
141         cache = DSProxyCache(_cacheAddr);  // overwrite cache
142         return true;
143     }
144 }
145 
146 // DSProxyFactory
147 // This factory deploys new proxy instances through build()
148 // Deployed proxy addresses are logged
149 contract DSProxyFactory {
150     event Created(address indexed sender, address proxy, address cache);
151     mapping(address=>bool) public isProxy;
152     DSProxyCache public cache = new DSProxyCache();
153 
154     // deploys a new proxy instance
155     // sets owner of proxy to caller
156     function build() public returns (DSProxy proxy) {
157         proxy = build(msg.sender);
158     }
159 
160     // deploys a new proxy instance
161     // sets custom owner of proxy
162     function build(address owner) public returns (DSProxy proxy) {
163         proxy = new DSProxy(cache);
164         Created(owner, address(proxy), address(cache));
165         proxy.setOwner(owner);
166         isProxy[proxy] = true;
167     }
168 }
169 
170 // DSProxyCache
171 // This global cache stores addresses of contracts previously deployed
172 // by a proxy. This saves gas from repeat deployment of the same
173 // contracts and eliminates blockchain bloat.
174 
175 // By default, all proxies deployed from the same factory store
176 // contracts in the same cache. The cache a proxy instance uses can be
177 // changed.  The cache uses the sha3 hash of a contract's bytecode to
178 // lookup the address
179 contract DSProxyCache {
180     mapping(bytes32 => address) cache;
181 
182     function read(bytes _code) public view returns (address) {
183         bytes32 hash = keccak256(_code);
184         return cache[hash];
185     }
186 
187     function write(bytes _code) public returns (address target) {
188         assembly {
189             target := create(0, add(_code, 0x20), mload(_code))
190             switch iszero(extcodesize(target))
191             case 1 {
192                 // throw if contract failed to deploy
193                 revert(0, 0)
194             }
195         }
196         bytes32 hash = keccak256(_code);
197         cache[hash] = target;
198     }
199 }
200 
201 // ProxyRegistry
202 // This Registry deploys new proxy instances through DSProxyFactory.build(address) and keeps a registry of owner => proxies
203 contract ProxyRegistry {
204     mapping(address=>DSProxy[]) public proxies;
205     mapping(address=>uint) public proxiesCount;
206     DSProxyFactory factory;
207 
208     function ProxyRegistry(DSProxyFactory factory_) public {
209         factory = factory_;
210     }
211 
212     // deploys a new proxy instance
213     // sets owner of proxy to caller
214     function build() public returns (DSProxy proxy) {
215         proxy = build(msg.sender);
216     }
217 
218     // deploys a new proxy instance
219     // sets custom owner of proxy
220     function build(address owner) public returns (DSProxy proxy) {
221         proxy = factory.build(owner);
222         proxies[owner].push(proxy);
223         proxiesCount[owner] ++;
224     }
225 }