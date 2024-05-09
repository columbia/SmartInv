1 pragma solidity ^0.5.7;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7     /**
8      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9      * account.
10      */
11     constructor() public{
12         owner = msg.sender;
13     }
14 
15     /**
16      * @dev Throws if called by any account other than the owner.
17      */
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     /**
24      * @dev Allows the current owner to transfer control of the contract to a newOwner.
25      * @param newOwner The address to transfer ownership to.
26      */
27     function transferOwnership(address newOwner) onlyOwner public {
28         require(newOwner != address(0));
29         emit OwnershipTransferred(owner, newOwner);
30         owner = newOwner;
31     }
32 
33 }
34 
35 contract User is Ownable {
36 
37     event UserRegistered(address internal_wallet_address, address external_wallet_address, address referrer, bytes32 nick_name, bytes32 geo_location);
38 
39     event UserNickNameUpdated(address external_wallet_address, bytes32 old_nick_name, bytes32 new_nick_name);
40 
41     event UserGeoLocationUpdated(address external_wallet_address, bytes32 old_geo_location, bytes32 new_geo_location);
42 
43     struct UserDetails {
44         bytes32 nick_name;
45         address payable referrer;
46         bytes32 geo_location;
47     }
48 
49     // address details
50     mapping(address => UserDetails) public users;
51 
52     // mapping of internal wallet to external wallet
53     mapping(address => address) public internal_to_external;
54 
55     // mapping of external wallet to internal wallet
56     mapping(address => address) public external_to_internal;
57 
58     // all referees for an address
59     mapping(address => address[]) public referees;
60 
61     constructor() public {
62         UserDetails memory root = UserDetails({
63             nick_name : "new",
64             referrer : address(0),
65             geo_location : "51.507351,-0.127758" // London
66             });
67         users[msg.sender] = root;
68         internal_to_external[msg.sender] = msg.sender;
69     }
70 
71     /**
72      * @dev method to register users, can be called by admin only
73      * @param _internal_wallet_addresses internal wallet addresses array
74      * @param _external_wallet_addresses external wallet addresses array
75      * @param _referrers referrers array
76      * @param _nick_names nick names array
77      * @param _geo_locations geo locations array
78      */
79     function registerUsers(
80         address payable[] calldata _internal_wallet_addresses,
81         address payable[] calldata _external_wallet_addresses,
82         address payable[] calldata _referrers,
83         bytes32[] calldata _nick_names,
84         bytes32[] calldata _geo_locations) external onlyOwner() {
85         for (uint256 i; i < _internal_wallet_addresses.length; i++) {
86             UserDetails memory ud = UserDetails({
87                 nick_name : _nick_names[i],
88                 referrer : _referrers[i],
89                 geo_location : _geo_locations[i]
90                 });
91             users[_external_wallet_addresses[i]] = ud;
92             referees[_referrers[i]].push(_external_wallet_addresses[i]);
93             internal_to_external[_internal_wallet_addresses[i]] = _external_wallet_addresses[i];
94             external_to_internal[_external_wallet_addresses[i]] = _internal_wallet_addresses[i];
95             emit UserRegistered(_internal_wallet_addresses[i], _external_wallet_addresses[i], _referrers[i], _nick_names[i], _geo_locations[i]);
96         }
97     }
98 
99     /**
100      * @dev method to register user, can be called by admin only
101      * @param _internal_wallet_address internal wallet address
102      * @param _external_wallet_address external wallet address
103      * @param _referrer referrer
104      * @param _nick_name nick name
105      * @param _geo_location geo location
106      */
107     function registerUser(
108         address payable _internal_wallet_address,
109         address payable _external_wallet_address,
110         address payable _referrer,
111         bytes32 _nick_name,
112         bytes32 _geo_location) external onlyOwner() {
113         UserDetails memory ud = UserDetails({
114             nick_name : _nick_name,
115             referrer : _referrer,
116             geo_location : _geo_location
117             });
118         users[_external_wallet_address] = ud;
119         referees[_referrer].push(_external_wallet_address);
120         internal_to_external[_internal_wallet_address] = _external_wallet_address;
121         external_to_internal[_external_wallet_address] = _internal_wallet_address;
122         emit UserRegistered(_internal_wallet_address, _external_wallet_address, _referrer, _nick_name, _geo_location);
123     }
124 
125     /**
126      * @dev method to update users nick name, can be called external address only
127      * @param _nick_name new nick name
128      */
129     function updateNickname(bytes32 _nick_name) external {
130         require(external_to_internal[msg.sender] != address(0));
131         UserDetails memory ud = users[msg.sender];
132         require(ud.nick_name != bytes32(0), "user does not esist!");
133         bytes32 old_nick_name = ud.nick_name;
134         ud.nick_name = _nick_name;
135         users[msg.sender] = ud;
136         emit UserNickNameUpdated(msg.sender, old_nick_name, _nick_name);
137     }
138 
139     /**
140      * @dev method to update users geo location, can be called external address only
141      * @param _geo_location new geo location
142      */
143     function updateGeoLocation(bytes32 _geo_location) external {
144         require(external_to_internal[msg.sender] != address(0));
145         UserDetails memory ud = users[msg.sender];
146         require(ud.nick_name != bytes32(0), "user does not esist!");
147         bytes32 old_geo_location = ud.geo_location;
148         ud.geo_location = _geo_location;
149         users[msg.sender] = ud;
150         emit UserGeoLocationUpdated(msg.sender, old_geo_location, _geo_location);
151     }
152 
153     /**
154        * @dev Throws if called by any account other than the internal wallet.
155        */
156     modifier onlyInternalWallets() {
157         require(internal_to_external[msg.sender] != address(0));
158         _;
159     }
160 }
161 
162 contract SuperOneSpots is User {
163 
164     event Withdrawal(address wallet, uint256 weiAmount);
165     event CommissionSent(address indexed from, address to, uint256 amount);
166 
167     // coordinates to Spot index first is level(x) then mapping of y to owner address
168     mapping(uint256 => mapping(uint256 => address)) public coordinates;
169 
170     // mapping to return what to add according to x index
171     mapping(uint256 => uint256) public x_addition;
172 
173     // mapping to return what to add according to y index
174     mapping(uint256 => uint256) public y_addition;
175 
176     // Constructor to bootstartp the contract
177     constructor() public {
178         // initial coordinates belongs to owner
179         coordinates[0][0] = msg.sender;
180         uint256 x_factor = 1;
181         uint256 y_factor;
182         //pre fill x_addition for level calculation in the tree
183         for (uint256 i; i < 128; i++) {
184             // for x_addition
185             if ((i + 2) >= (2 * (2 ** x_factor))) {
186                 x_factor += 1;
187                 y_factor = 1;
188             } else {
189                 y_factor += 1;
190             }
191             x_addition[i] = x_factor;
192             y_addition[i] = y_factor - 1;
193         }
194 
195     }
196 
197     /**
198      * @dev method to assign spots, can be called by admin only
199      * @param coord_x coordinate x of the tree to start
200      * @param coord_y coordinate y of the tree to start
201      * @param _count count of spots to be assigned
202      */
203     function assignSpotsByAdmin(uint256 coord_x, uint256 coord_y, uint _count, address external_wallet_address) external onlyOwner() {
204         require(_count < 128);
205         coordinates[coord_x][coord_y] = external_wallet_address;
206         for (uint256 i; i < _count - 1; i++) {
207             coordinates[coord_x + x_addition[i]][coord_y * (2 * (2 ** (x_addition[i] - 1))) + y_addition[i]] = external_wallet_address;
208         }
209     }
210 
211     /**
212      * @dev method to assign spots, can be called by internal wallets only
213      * @param coord_x coordinate x of the tree to start
214      * @param coord_y coordinate y of the tree to start
215      * @param _count count of spots to be assigned
216      */
217     function assignSpots(uint256 coord_x, uint256 coord_y, uint _count) external onlyInternalWallets() {
218         require(_count < 128);
219         address wallet = internal_to_external[msg.sender];
220         coordinates[coord_x][coord_y] = wallet;
221         for (uint256 i; i < _count - 1; i++) {
222             coordinates[coord_x + x_addition[i]][coord_y * (2 * (2 ** (x_addition[i] - 1))) + y_addition[i]] = wallet;
223         }
224     }
225 
226     /**
227      * @dev method to distribute Comission, can be called by internal wallets only
228      * @param beneficiaries address to which funds will be transferred
229      * @param amounts the amount of index wise benificiaries
230      */
231     function distributeCommission(address payable[] calldata beneficiaries, uint256[] calldata amounts) external payable onlyInternalWallets() {
232         require(beneficiaries.length == amounts.length);
233         for (uint256 i; i < beneficiaries.length; i++) {
234             beneficiaries[i].transfer(amounts[i]);
235             emit CommissionSent(internal_to_external[msg.sender], beneficiaries[i], amounts[i]);
236         }
237     }
238 
239     /**
240      * @dev method to withdraw funds only by owner
241      * @param _wallet address to which funds will be transferred
242      */
243     function withdraw(address payable _wallet) onlyOwner() public {
244         uint256 weiAmount = address(this).balance;
245         require(weiAmount > 0);
246         _wallet.transfer(weiAmount);
247         emit Withdrawal(_wallet, weiAmount);
248     }
249 
250     function checkSpots(uint256[] calldata x, uint256[] calldata y) external view returns (address[] memory){
251         address[] memory addresses;
252         for (uint256 i; i < x.length; i++) {
253             addresses[i] = coordinates[x[i]][y[i]];
254         }
255         return addresses;
256     }
257 
258 }