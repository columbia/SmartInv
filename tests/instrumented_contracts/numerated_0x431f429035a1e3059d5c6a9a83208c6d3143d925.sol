1 pragma solidity 0.4.24;
2 
3 
4 contract DSNote {
5     event LogNote(
6         bytes4   indexed  sig,
7         address  indexed  guy,
8         bytes32  indexed  foo,
9         bytes32  indexed  bar,
10         uint              wad,
11         bytes             fax
12     ) anonymous;
13 
14     modifier note {
15         bytes32 foo;
16         bytes32 bar;
17 
18         assembly {
19             foo := calldataload(4)
20             bar := calldataload(36)
21         }
22 
23         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
24 
25         _;
26     }
27 }
28 
29 
30 contract DSAuthority {
31     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
32 }
33 
34 
35 contract DSAuthEvents {
36     event LogSetAuthority (address indexed authority);
37     event LogSetOwner     (address indexed owner);
38 }
39 
40 
41 contract DSAuth is DSAuthEvents {
42     DSAuthority  public  authority;
43     address      public  owner;
44 
45     constructor() public {
46         owner = msg.sender;
47         emit LogSetOwner(msg.sender);
48     }
49 
50     function setOwner(address owner_)
51         public
52         auth
53     {
54         owner = owner_;
55         emit LogSetOwner(owner);
56     }
57 
58     function setAuthority(DSAuthority authority_)
59         public
60         auth
61     {
62         authority = authority_;
63         emit LogSetAuthority(authority);
64     }
65 
66     modifier auth {
67         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
68         _;
69     }
70 
71     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
72         if (src == address(this)) {
73             return true;
74         } else if (src == owner) {
75             return true;
76         } else if (authority == DSAuthority(0)) {
77             return false;
78         } else {
79             return authority.canCall(src, this, sig);
80         }
81     }
82 }
83 
84 
85 contract WETH9 {
86     string public name     = "Wrapped Ether";
87     string public symbol   = "WETH";
88     uint8  public decimals = 18;
89 
90     event  Approval(address indexed _owner, address indexed _spender, uint _value);
91     event  Transfer(address indexed _from, address indexed _to, uint _value);
92     event  Deposit(address indexed _owner, uint _value);
93     event  Withdrawal(address indexed _owner, uint _value);
94 
95     mapping (address => uint)                       public  balanceOf;
96     mapping (address => mapping (address => uint))  public  allowance;
97 
98     function() public payable {
99         deposit();
100     }
101 
102     function deposit() public payable {
103         balanceOf[msg.sender] += msg.value;
104         Deposit(msg.sender, msg.value);
105     }
106 
107     function withdraw(uint wad) public {
108         require(balanceOf[msg.sender] >= wad);
109         balanceOf[msg.sender] -= wad;
110         msg.sender.transfer(wad);
111         Withdrawal(msg.sender, wad);
112     }
113 
114     function totalSupply() public view returns (uint) {
115         return this.balance;
116     }
117 
118     function approve(address guy, uint wad) public returns (bool) {
119         allowance[msg.sender][guy] = wad;
120         Approval(msg.sender, guy, wad);
121         return true;
122     }
123 
124     function transfer(address dst, uint wad) public returns (bool) {
125         return transferFrom(msg.sender, dst, wad);
126     }
127 
128     function transferFrom(address src, address dst, uint wad)
129         public
130         returns (bool)
131     {
132         require(balanceOf[src] >= wad);
133 
134         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
135             require(allowance[src][msg.sender] >= wad);
136             allowance[src][msg.sender] -= wad;
137         }
138 
139         balanceOf[src] -= wad;
140         balanceOf[dst] += wad;
141 
142         Transfer(src, dst, wad);
143 
144         return true;
145     }
146 }
147 
148 
149 contract Utils {
150 
151     modifier addressValid(address _address) {
152         require(_address != address(0), "Utils::_ INVALID_ADDRESS");
153         _;
154     }
155 
156 }
157 
158 
159 contract Config is DSNote, DSAuth, Utils {
160 
161     WETH9 public weth9;
162     mapping (address => bool) public isAccountHandler;
163     mapping (address => bool) public isAdmin;
164     address[] public admins;
165     bool public disableAdminControl = false;
166     
167     event LogAdminAdded(address indexed _admin, address _by);
168     event LogAdminRemoved(address indexed _admin, address _by);
169 
170     constructor() public {
171         admins.push(msg.sender);
172         isAdmin[msg.sender] = true;
173     }
174 
175     modifier onlyAdmin(){
176         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
177         _;
178     }
179 
180     function setWETH9
181     (
182         address _weth9
183     ) 
184         public
185         auth
186         note
187         addressValid(_weth9) 
188     {
189         weth9 = WETH9(_weth9);
190     }
191 
192     function setAccountHandler
193     (
194         address _accountHandler,
195         bool _isAccountHandler
196     )
197         public
198         auth
199         note
200         addressValid(_accountHandler)
201     {
202         isAccountHandler[_accountHandler] = _isAccountHandler;
203     }
204 
205     function toggleAdminsControl() 
206         public
207         auth
208         note
209     {
210         disableAdminControl = !disableAdminControl;
211     }
212 
213     function isAdminValid(address _admin)
214         public
215         view
216         returns (bool)
217     {
218         if(disableAdminControl) {
219             return true;
220         } else {
221             return isAdmin[_admin];
222         }
223     }
224 
225     function getAllAdmins()
226         public
227         view
228         returns(address[])
229     {
230         return admins;
231     }
232 
233     function addAdmin
234     (
235         address _admin
236     )
237         external
238         note
239         onlyAdmin
240         addressValid(_admin)
241     {   
242         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
243 
244         admins.push(_admin);
245         isAdmin[_admin] = true;
246 
247         emit LogAdminAdded(_admin, msg.sender);
248     }
249 
250     function removeAdmin
251     (
252         address _admin
253     ) 
254         external
255         note
256         onlyAdmin
257         addressValid(_admin)
258     {   
259         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
260         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
261 
262         isAdmin[_admin] = false;
263 
264         for (uint i = 0; i < admins.length - 1; i++) {
265             if (admins[i] == _admin) {
266                 admins[i] = admins[admins.length - 1];
267                 admins.length -= 1;
268                 break;
269             }
270         }
271 
272         emit LogAdminRemoved(_admin, msg.sender);
273     }
274 }