1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0);
32         // Solidity only automatically asserts when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 /**
70  * @title Roles
71  * @dev Library for managing addresses assigned to a Role.
72  */
73 library Roles {
74     struct Role {
75         mapping(address => bool) bearer;
76     }
77 
78     /**
79      * @dev give an account access to this role
80      */
81     function add(Role storage role, address account) internal {
82         require(account != address(0));
83         require(!has(role, account));
84 
85         role.bearer[account] = true;
86     }
87 
88     /**
89      * @dev remove an account's access to this role
90      */
91     function remove(Role storage role, address account) internal {
92         require(account != address(0));
93         require(has(role, account));
94 
95         role.bearer[account] = false;
96     }
97 
98     /**
99      * @dev check if an account has this role
100      * @return bool
101      */
102     function has(Role storage role, address account)
103     internal
104     view
105     returns (bool)
106     {
107         require(account != address(0));
108         return role.bearer[account];
109     }
110 }
111 
112 contract MinterRole {
113     using Roles for Roles.Role;
114 
115     event MinterAdded(address indexed account);
116     event MinterRemoved(address indexed account);
117 
118     Roles.Role private minters;
119 
120     constructor() internal {
121         _addMinter(msg.sender);
122     }
123 
124     modifier onlyMinter() {
125         require(isMinter(msg.sender));
126         _;
127     }
128 
129     function isMinter(address account) public view returns (bool) {
130         return minters.has(account);
131     }
132 
133     function addMinter(address account) public onlyMinter {
134         _addMinter(account);
135     }
136 
137     function renounceMinter() public {
138         _removeMinter(msg.sender);
139     }
140 
141     function _addMinter(address account) internal {
142         minters.add(account);
143         emit MinterAdded(account);
144     }
145 
146     function _removeMinter(address account) internal {
147         minters.remove(account);
148         emit MinterRemoved(account);
149     }
150 }
151 
152 
153 interface IQRToken {
154     function totalSupply() external view returns (uint256);
155 
156     function balanceOf(address who) external view returns (uint256);
157 
158     function allowance(address owner, address spender)
159     external view returns (uint256);
160 
161     function transfer(address to, uint256 value) external returns (bool);
162 
163     function approve(address spender, uint256 value)
164     external returns (bool);
165 
166     function transferFrom(address from, address to, uint256 value)
167     external returns (bool);
168 
169     function mint(address to, uint256 value)
170     external returns (bool);
171 
172     function addMinter(address account)
173     external;
174 
175     function frozenTime(address owner)
176     external view returns (uint);
177 
178     function setFrozenTime(address owner, uint newtime)
179     external;
180 }
181 
182 contract IQRSaleFirst is MinterRole {
183 
184     using SafeMath for uint256;
185 
186     uint256 private  _usdc_for_iqr;
187     uint256 private _usdc_for_eth;
188     uint256 private _leftToSale;
189 
190     address private _cold_wallet;
191 
192     IQRToken private _token;
193 
194     constructor() public  {
195         // price usd cents for one IQR. Default: 1 IQR = $0.06
196         _usdc_for_iqr = 6;
197         // usd cents for one ether. Default: 1 ETH = $130.92
198         _usdc_for_eth = 13092;
199         // MAX tokens to sale for this contract
200         _leftToSale = 200000000 ether;
201         // Address for ether
202         _cold_wallet = 0x5BAC0CE2276ebE6845c31C86499C6D7F5C9b0650;
203     }
204 
205     function() public payable {
206         require(msg.value > 0.1 ether);
207         require(_token != address(0x0));
208         require(_cold_wallet != address(0x0));
209 
210         uint256 received = msg.value;
211         uint256 tokens_to_send = received.mul(_usdc_for_eth).div(_usdc_for_iqr);
212         _leftToSale = _leftToSale.sub(tokens_to_send);
213         _token.mint(msg.sender, tokens_to_send);
214 
215         _cold_wallet.transfer(msg.value);
216     }
217 
218     function sendTokens(address beneficiary, uint256 tokens_to_send) public onlyMinter {
219         require(_token != address(0x0));
220         _leftToSale = _leftToSale.sub(tokens_to_send);
221         _token.mint(beneficiary, tokens_to_send);
222     }
223 
224     function sendTokensToManyAddresses(address[] beneficiaries, uint256 tokens_to_send) public onlyMinter {
225         require(_token != address(0x0));
226         _leftToSale = _leftToSale.sub(tokens_to_send * beneficiaries.length);
227         for (uint i = 0; i < beneficiaries.length; i++) {
228             _token.mint(beneficiaries[i], tokens_to_send);
229         }
230     }
231 
232     function setFrozenTime(address _owner, uint _newtime) public onlyMinter {
233         require(_token != address(0x0));
234         _token.setFrozenTime(_owner, _newtime);
235     }
236 
237     function setFrozenTimeToManyAddresses(address[] _owners, uint _newtime) public onlyMinter {
238         require(_token != address(0x0));
239         for (uint i = 0; i < _owners.length; i++) {
240             _token.setFrozenTime(_owners[i], _newtime);
241         }
242     }
243 
244     function unFrozen(address _owner) public onlyMinter {
245         require(_token != address(0x0));
246         _token.setFrozenTime(_owner, 0);
247     }
248 
249     function unFrozenManyAddresses(address[] _owners) public onlyMinter {
250         require(_token != address(0x0));
251         for (uint i = 0; i < _owners.length; i++) {
252             _token.setFrozenTime(_owners[i], 0);
253         }
254     }
255 
256     function usdc_for_iqr() public view returns (uint256) {
257         return _usdc_for_iqr;
258     }
259 
260     function usdc_for_eth() public view returns (uint256) {
261         return _usdc_for_eth;
262     }
263 
264     function leftToSale() public view returns (uint256) {
265         return _leftToSale;
266     }
267 
268     function cold_wallet() public view returns (address) {
269         return _cold_wallet;
270     }
271 
272     function token() public view returns (IQRToken) {
273         return _token;
274     }
275 
276     function setUSDCforIQR(uint256 _usdc_for_iqr_) public onlyMinter {
277         _usdc_for_iqr = _usdc_for_iqr_;
278     }
279 
280     function setUSDCforETH(uint256 _usdc_for_eth_) public onlyMinter {
281         _usdc_for_eth = _usdc_for_eth_;
282     }
283 
284     function setColdWallet(address _cold_wallet_) public onlyMinter {
285         _cold_wallet = _cold_wallet_;
286     }
287 
288     function setToken(IQRToken _token_) public onlyMinter {
289         _token = _token_;
290     }
291 
292 
293 }