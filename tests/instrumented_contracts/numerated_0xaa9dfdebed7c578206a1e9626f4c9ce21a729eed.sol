1 pragma solidity ^0.5.2;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: contracts/Adminable.sol
45 
46 contract Adminable {
47     using Roles for Roles.Role;
48 
49     event AdminAdded(address indexed account);
50     event AdminRemoved(address indexed account);
51 
52     Roles.Role private _admins;
53 
54     constructor () internal {
55         _addAdmin(msg.sender);
56     }
57 
58     modifier onlyAdmin() {
59         require(isAdmin(msg.sender));
60         _;
61     }
62 
63     function isAdmin(address account) public view returns (bool) {
64         return _admins.has(account);
65     }
66 
67     function addAdmin(address account) public onlyAdmin {
68         _addAdmin(account);
69     }
70 
71     function renounceAdmin() public {
72         _removeAdmin(msg.sender);
73     }
74 
75     function _addAdmin(address account) internal {
76         _admins.add(account);
77         emit AdminAdded(account);
78     }
79 
80     function _removeAdmin(address account) internal {
81         _admins.remove(account);
82         emit AdminRemoved(account);
83     }
84 }
85 
86 // File: contracts/Authorizable.sol
87 
88 contract Authorizable is Adminable {
89 
90     address public authorizedAddress;
91     
92     modifier onlyAuthorized() {
93         require(msg.sender == authorizedAddress);
94         _;
95     }
96 
97     function updateAuthorizedAddress(address _address) onlyAdmin public {
98         authorizedAddress = _address;
99     }
100 
101 }
102 
103 // File: contracts/SoarStorage.sol
104 
105 /**
106     @title Soar Storage
107     @author Marek Tlacbaba (marek@soar.earth)
108     @dev This smart contract behave as simple storage and can be 
109     accessed only by authorized caller who is responsible for any
110     checks and validation. The authorized caller can updated by 
111     admins so it allows to update application logic 
112     and keeping data and events untouched.
113 */
114 
115 //TODO
116 // use safeMath
117 contract SoarStorage is Authorizable {
118 
119     /**
120     Status: 
121         0 - unknown
122         1 - created
123         2 - updated
124         3 - deleted
125     */
126     struct ListingObject {
127         address owner;
128         address sponsor;
129         bytes12 geohash;
130         mapping (address => mapping (bytes32 => uint )) sales;
131         uint256 salesCount;
132         uint8 status;
133     }
134 
135     uint public counter = 0;
136     mapping (bytes32 => ListingObject) internal listings;
137 
138     event Listing (
139         bytes32 filehash,
140         address indexed owner,
141         address indexed sponsor,
142         string previewUrl, 
143         string url, 
144         string pointWKT,
145         bytes12 geohash, 
146         string metadata
147     );
148 
149     event ListingUpdated (
150         bytes32 filehash,
151         address indexed owner, 
152         address indexed sponsor,
153         string previewUrl, 
154         string url, 
155         string pointWKT,
156         bytes12 geohash, 
157         string metadata 
158     );
159 
160     event ListingDeleted (
161         bytes32 filehash,
162         address indexed owner,
163         address indexed sponsor
164     );
165 
166     event Sale(
167         address indexed buyer, 
168         bytes32 id, 
169         address indexed owner, 
170         address sponsor,
171         bytes32 indexed filehash,
172         uint price 
173     );
174 
175     function putListing (
176         bytes32 _filehash,
177         address _owner,
178         address _sponsor,
179         string memory _previewUrl, 
180         string memory _url, 
181         string memory _pointWKT, 
182         bytes12 _geohash, 
183         string memory _metadata
184     ) 
185         public 
186         onlyAuthorized 
187     {
188         listings[_filehash].owner = _owner;
189         listings[_filehash].sponsor = _sponsor;
190         listings[_filehash].geohash = _geohash;
191         listings[_filehash].status = 1;
192         counter++;
193         emit Listing(
194             _filehash, 
195             _owner,
196             _sponsor, 
197             _previewUrl, 
198             _url, 
199             _pointWKT, 
200             _geohash, 
201             _metadata
202         );
203     }
204 
205     function updateListing (
206         bytes32 _filehash,
207         address _owner,
208         address _sponsor,
209         string memory _previewUrl, 
210         string memory _url, 
211         string memory _pointWKT, 
212         bytes12 _geohash, 
213         string memory _metadata 
214     ) 
215         public 
216         onlyAuthorized 
217     {
218         listings[_filehash].geohash = _geohash;
219         listings[_filehash].status = 2;
220         emit ListingUpdated(
221             _filehash, 
222             _owner,
223             _sponsor, 
224             _previewUrl, 
225             _url, 
226             _pointWKT, 
227             _geohash, 
228             _metadata
229         );
230     }
231 
232     function deleteListing(
233         bytes32 _filehash 
234     )
235         public 
236         onlyAuthorized 
237     {
238         listings[_filehash].status = 3;
239         counter--;
240         emit ListingDeleted(_filehash, listings[_filehash].owner, listings[_filehash].sponsor);
241     }
242 
243     function putSale (
244         address _buyer,
245         bytes32 _id,
246         bytes32 _filehash, 
247         uint256 _price
248     ) 
249         public 
250         onlyAuthorized 
251     {
252         listings[_filehash].sales[_buyer][_id] = _price;
253         listings[_filehash].salesCount++;
254         emit Sale(_buyer, _id, listings[_filehash].owner, listings[_filehash].sponsor, _filehash, _price);
255     }
256 
257     function getListingDetails(bytes32 _filehash, address _user, bytes32 _id) 
258         public view
259         returns (
260             address owner_,
261             address sponsor_,
262             bytes12 geohash_,
263             uint8 status_,
264             uint256 sale_
265         )
266     {
267         owner_ = listings[_filehash].owner;
268         sponsor_ = listings[_filehash].sponsor;
269         geohash_ = listings[_filehash].geohash;
270         status_ = listings[_filehash].status;
271         sale_ = listings[_filehash].sales[_user][_id];
272     }
273 }