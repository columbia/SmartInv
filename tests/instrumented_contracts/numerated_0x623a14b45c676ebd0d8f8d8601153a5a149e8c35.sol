1 pragma solidity ^0.4.24;
2 
3 // ------ TTT ----- //
4 contract RBAC {
5     event RoleAdded(address indexed operator, string role);
6     event RoleRemoved(address indexed operator, string role);
7     function checkRole(address _operator, string _role) view public;
8     function hasRole(address _operator, string _role) view public returns (bool);
9     function addRole(address _operator, string _role) internal;
10     function removeRole(address _operator, string _role) internal;
11 }
12 contract Ownable {
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14     function transferOwnership(address _newOwner) external;
15 }
16 contract Superuser is Ownable, RBAC {
17     function addRoleForUser(address _user, string _role) public;
18     function delRoleForUser(address _user, string _role) public;
19 }
20 contract ApproveAndCallFallBack {
21     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) external;
22 }
23 contract OwnerSellContract {
24     function createOrder(address _owner, uint _amount, uint _price, address _buyer, uint _date) external returns (bool);
25     function cancelOrder(address _buyer) external returns (bool);
26 }
27 contract RealtyContract {
28     function freezeTokens(address _owner, uint _amount) external returns (bool);
29     function acceptRequest(address _owner) external returns (bool);
30     function cancelRequest(address _owner) external returns (bool);
31 }
32 contract TTTToken is Superuser {
33     struct  Checkpoint {}
34     event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
35     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
37     function transfer(address _to, uint256 _amount) external returns (bool);
38     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);
39     function doTransfer(address _from, address _to, uint _amount) internal;
40     function balanceOf(address _owner) public view returns (uint256 balance);
41     function approve(address _spender, uint256 _amount) public returns (bool);
42     function increaseApproval(address _spender, uint _addedAmount) external returns (bool);
43     function decreaseApproval(address _spender, uint _subtractedAmount) external returns (bool);
44     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
45     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) external returns (bool);
46     function totalSupply() public view returns (uint);
47     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint);
48     function totalSupplyAt(uint _blockNumber) public view returns(uint);
49     function enableTransfers(bool _transfersEnabled) public returns (bool);
50     function getValueAt(Checkpoint[] storage checkpoints, uint _block) view internal returns (uint);
51     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal;
52     function destroyTokens(address _owner, uint _amount) public returns (bool);
53     function _doDestroyTokens(address _owner, uint _amount) internal;
54     function closeProject(uint _price) public;
55     function getRealty(address _contract, uint _val) public;
56     function acceptRequest(address _contract, address _owner) public;
57     function cancelRequest(address _contract, address _owner) public;
58     function changeTokens() public returns (bool);
59     function createOrder(address _contract, uint _amount, uint _price, address _buyer, uint _date) public returns (bool);
60     function cancelOrder(address _contract, address _buyer) public returns (bool);
61     function min(uint a, uint b) pure internal returns (uint);
62     function () payable public;
63     function claimTokens(address _token) external;
64 }
65 // ------ TTT ----- //
66 
67 // ------ USDT ----- //
68 contract ERC20Basic {
69     function totalSupply() public constant returns (uint);
70     function balanceOf(address who) public constant returns (uint);
71     function transfer(address to, uint value) public;
72     event Transfer(address indexed from, address indexed to, uint value);
73 }
74 contract ERC20 is ERC20Basic {
75     function allowance(address owner, address spender) public constant returns (uint);
76     function transferFrom(address from, address to, uint value) public;
77     function approve(address spender, uint value) public;
78     event Approval(address indexed owner, address indexed spender, uint value);
79 }
80 contract BasicToken is Ownable, ERC20Basic {
81     function transfer(address _to, uint _value) public;
82     function balanceOf(address _owner) public constant returns (uint balance);
83 }
84 contract StandardToken is BasicToken, ERC20 {
85     function transferFrom(address _from, address _to, uint _value) public;
86     function approve(address _spender, uint _value) public;
87     function allowance(address _owner, address _spender) public constant returns (uint remaining);
88 }
89 contract Pausable is Ownable {
90   event Pause();
91   event Unpause();
92   function pause() public;
93   function unpause() public;
94 }
95 contract BlackList is Ownable, BasicToken {
96     function getBlackListStatus(address _maker) external constant returns (bool);
97     function getOwner() external constant returns (address);
98     function addBlackList (address _evilUser) public;
99     function removeBlackList (address _clearedUser) public;
100     function destroyBlackFunds (address _blackListedUser) public;
101     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
102     event AddedBlackList(address _user);
103     event RemovedBlackList(address _user);
104 }
105 contract UpgradedStandardToken is StandardToken{
106     function transferByLegacy(address from, address to, uint value) public;
107     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
108     function approveByLegacy(address from, address spender, uint value) public;
109 }
110 contract TetherToken is Pausable, StandardToken, BlackList {
111     function transfer(address _to, uint _value) public;
112     function transferFrom(address _from, address _to, uint _value) public;
113     function balanceOf(address who) public constant returns (uint);
114     function approve(address _spender, uint _value) public;
115     function allowance(address _owner, address _spender) public constant returns (uint remaining);
116     function deprecate(address _upgradedAddress) public;
117     function totalSupply() public constant returns (uint);
118     function issue(uint amount) public;
119     function redeem(uint amount) public;
120     function setParams(uint newBasisPoints, uint newMaxFee) public;
121     event Issue(uint amount);
122     event Redeem(uint amount);
123     event Deprecate(address newAddress);
124     event Params(uint feeBasisPoints, uint maxFee);
125 }
126 // ------ USDT ----- //
127 
128 /**
129  * @title SafeMath
130  * @dev Math operations with safety checks that revert on error
131  */
132 library SafeMath {
133 
134     /**
135     * @dev Multiplies two numbers, reverts on overflow.
136     */
137     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
138         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139         // benefit is lost if 'b' is also tested.
140         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
141         if (_a == 0) {
142             return 0;
143         }
144 
145         uint256 c = _a * _b;
146         require(c / _a == _b);
147 
148         return c;
149     }
150 
151     /**
152     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
153     */
154     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
155         require(_b > 0); // Solidity only automatically asserts when dividing by 0
156         uint256 c = _a / _b;
157         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
158 
159         return c;
160     }
161 
162     /**
163     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
164     */
165     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
166         require(_b <= _a);
167         uint256 c = _a - _b;
168 
169         return c;
170     }
171 
172     /**
173     * @dev Adds two numbers, reverts on overflow.
174     */
175     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
176         uint256 c = _a + _b;
177         require(c >= _a);
178 
179         return c;
180     }
181 
182     /**
183     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
184     * reverts when dividing by zero.
185     */
186     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
187         require(b != 0);
188         return a % b;
189     }
190 }
191 
192 contract TTTExchange {
193     using SafeMath for uint;
194 
195     TTTToken public tokenTTT = TTTToken(0xF92d38De8e30151835b9Ebe327E52878b4115CBF);
196     TetherToken public tokenUSD = TetherToken(0xdac17f958d2ee523a2206206994597c13d831ec7);
197 
198     address owner;
199 
200     uint priceUSD;
201     uint priceETH;
202 
203     modifier onlyOwner() {
204         require(msg.sender == owner);
205         _;
206     }
207 
208     function transferOwnership(address _newOwner) external onlyOwner {
209         require(_newOwner != address(0));
210         owner = _newOwner;
211     }
212 
213     constructor(uint _priceETH, uint _priceUSD) public {
214         owner = msg.sender;
215         priceETH = _priceETH;
216         priceUSD = _priceUSD;
217     }
218 
219     function getInfo(address _address) external view returns(uint PriceETH, uint PriceUSD, uint BalanceTTT, uint Approved, uint toETH, uint toUSD) {
220         PriceETH = priceETH;
221         PriceUSD = priceUSD;
222         BalanceTTT = tokenTTT.balanceOf(_address);
223         Approved = tokenTTT.allowance(_address, address(this));
224         toETH = Approved * priceETH;
225         toUSD = Approved * priceUSD;
226     }
227 
228     function amIReady(address _address) external view returns(bool) {
229         uint _a = tokenTTT.allowance(_address, address(this));
230         if (_a > 0) {
231             return true;
232         } else {
233             return false;
234         }
235     }
236 
237     function() external payable {
238         msg.sender.transfer(msg.value);
239         if (uint(bytes(msg.data)[0]) == 1) {
240             toETH();
241         }
242         if (uint(bytes(msg.data)[0]) == 2) {
243             toUSD();
244         }
245     }
246 
247     function setPriceETH(uint _newPriceETH) external onlyOwner {
248         require(_newPriceETH != 0);
249         priceETH = _newPriceETH;
250     }
251 
252     function setPriceUSD(uint _newPriceUSD) external onlyOwner {
253         require(_newPriceUSD != 0);
254         priceUSD = _newPriceUSD;
255     }
256 
257     function toETH() public {
258         uint _value = tokenTTT.allowance(msg.sender, address(this));
259         if (_value > 0) {
260             tokenTTT.transferFrom(msg.sender, owner, _value);
261             msg.sender.transfer(_value.mul(priceETH));
262         }
263     }
264 
265     function toUSD() public {
266         uint _value = tokenTTT.allowance(msg.sender, address(this));
267         if (_value > 0) {
268             tokenTTT.transferFrom(msg.sender, owner, _value);
269             tokenUSD.transfer(msg.sender, _value.mul(priceUSD));
270         }
271     }
272 
273     function getBalance(address _recipient) external onlyOwner {
274         uint _balance = tokenTTT.balanceOf(address(this));
275         tokenTTT.transfer(_recipient, _balance);
276     }
277 }