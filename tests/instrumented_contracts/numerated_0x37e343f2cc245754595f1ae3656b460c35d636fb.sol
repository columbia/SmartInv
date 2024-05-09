1 pragma solidity ^0.4.18;
2 
3  contract ERC223 {
4   uint public totalSupply;
5   function balanceOf(address who) public view returns (uint);
6   
7   function name() public view returns (string _name);
8   function symbol() public view returns (string _symbol);
9   function decimals() public view returns (uint8 _decimals);
10   function totalSupply() public view returns (uint256 _supply);
11 
12   function transfer(address to, uint value) public returns (bool ok);
13   function transfer(address to, uint value, bytes data) public returns (bool ok);
14   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
15   function transferFrom(address _from, address _to, uint _value) public returns (bool ok);
16   
17   event Transfer(address indexed from, address indexed to, uint value);
18 }
19 
20 
21 contract Ownable {
22     address public owner;
23     address public newOwnerCandidate;
24 
25     event OwnershipRequested(address indexed _by, address indexed _to);
26     event OwnershipTransferred(address indexed _from, address indexed _to);
27 
28     constructor() public {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner() { require(msg.sender == owner); _;}
33 
34     /// Proposes to transfer control of the contract to a newOwnerCandidate.
35     /// @param _newOwnerCandidate address The address to transfer ownership to.
36     function transferOwnership(address _newOwnerCandidate) external onlyOwner {
37         require(_newOwnerCandidate != address(0));
38 
39         newOwnerCandidate = _newOwnerCandidate;
40 
41         emit OwnershipRequested(msg.sender, newOwnerCandidate);
42     }
43 
44     /// Accept ownership transfer. This method needs to be called by the perviously proposed owner.
45     function acceptOwnership() external {
46         if (msg.sender == newOwnerCandidate) {
47             owner = newOwnerCandidate;
48             newOwnerCandidate = address(0);
49 
50             emit OwnershipTransferred(owner, newOwnerCandidate);
51         }
52     }
53 }
54 
55 
56 contract Serverable is Ownable {
57     address public server;
58 
59     modifier onlyServer() { require(msg.sender == server); _;}
60 
61     function setServerAddress(address _newServerAddress) external onlyOwner {
62         server = _newServerAddress;
63     }
64 }
65 
66 
67 contract BalanceManager is Serverable {
68     /** player balances **/
69     mapping(uint32 => uint64) public balances;
70     /** player blocked tokens number **/
71     mapping(uint32 => uint64) public blockedBalances;
72     /** wallet balances **/
73     mapping(address => uint64) public walletBalances;
74     /** adress users **/
75     mapping(address => uint32) public userIds;
76 
77     /** Dispatcher contract address **/
78     address public dispatcher;
79     /** service reward can be withdraw by owners **/
80     uint serviceReward;
81     /** service reward can be withdraw by owners **/
82     uint sentBonuses;
83     /** Token used to pay **/
84     ERC223 public gameToken;
85 
86     modifier onlyDispatcher() {require(msg.sender == dispatcher);
87         _;}
88 
89     event Withdraw(address _user, uint64 _amount);
90     event Deposit(address _user, uint64 _amount);
91 
92     constructor(address _gameTokenAddress) public {
93         gameToken = ERC223(_gameTokenAddress);
94     }
95 
96     function setDispatcherAddress(address _newDispatcherAddress) external onlyOwner {
97         dispatcher = _newDispatcherAddress;
98     }
99 
100     /**
101      * Deposits from user
102      */
103     function tokenFallback(address _from, uint256 _amount, bytes _data) public {
104         if (userIds[_from] > 0) {
105             balances[userIds[_from]] += uint64(_amount);
106         } else {
107             walletBalances[_from] += uint64(_amount);
108         }
109 
110         emit Deposit(_from, uint64(_amount));
111     }
112 
113     /**
114      * Register user
115      */
116     function registerUserWallet(address _user, uint32 _id) external onlyServer {
117         require(userIds[_user] == 0);
118         require(_user != owner);
119 
120         userIds[_user] = _id;
121         if (walletBalances[_user] > 0) {
122             balances[_id] += walletBalances[_user];
123             walletBalances[_user] = 0;
124         }
125     }
126 
127     /**
128      * Deposits tokens in game to some user
129      */
130     function sendTo(address _user, uint64 _amount) external {
131         require(walletBalances[msg.sender] >= _amount);
132         walletBalances[msg.sender] -= _amount;
133         if (userIds[_user] > 0) {
134             balances[userIds[_user]] += _amount;
135         } else {
136             walletBalances[_user] += _amount;
137         }
138         emit Deposit(_user, _amount);
139     }
140 
141     /**
142      * User can withdraw tokens manually in any time
143      */
144     function withdraw(uint64 _amount) external {
145         uint32 userId = userIds[msg.sender];
146         if (userId > 0) {
147             require(balances[userId] - blockedBalances[userId] >= _amount);
148             if (gameToken.transfer(msg.sender, _amount)) {
149                 balances[userId] -= _amount;
150                 emit Withdraw(msg.sender, _amount);
151             }
152         } else {
153             require(walletBalances[msg.sender] >= _amount);
154             if (gameToken.transfer(msg.sender, _amount)) {
155                 walletBalances[msg.sender] -= _amount;
156                 emit Withdraw(msg.sender, _amount);
157             }
158         }
159     }
160 
161     /**
162      * Server can withdraw tokens to user
163      */
164     function systemWithdraw(address _user, uint64 _amount) external onlyServer {
165         uint32 userId = userIds[_user];
166         require(balances[userId] - blockedBalances[userId] >= _amount);
167 
168         if (gameToken.transfer(_user, _amount)) {
169             balances[userId] -= _amount;
170             emit Withdraw(_user, _amount);
171         }
172     }
173 
174     /**
175      * Dispatcher can change user balance
176      */
177     function addUserBalance(uint32 _userId, uint64 _amount) external onlyDispatcher {
178         balances[_userId] += _amount;
179     }
180 
181     /**
182      * Dispatcher can change user balance
183      */
184     function spendUserBalance(uint32 _userId, uint64 _amount) external onlyDispatcher {
185         require(balances[_userId] >= _amount);
186         balances[_userId] -= _amount;
187         if (blockedBalances[_userId] > 0) {
188             if (blockedBalances[_userId] <= _amount)
189                 blockedBalances[_userId] = 0;
190             else
191                 blockedBalances[_userId] -= _amount;
192         }
193     }
194 
195     /**
196      * Server can add bonuses to users, they will take from owner balance
197      */
198     function addBonus(uint32[] _userIds, uint64[] _amounts) external onlyServer {
199         require(_userIds.length == _amounts.length);
200 
201         uint64 sum = 0;
202         for (uint32 i = 0; i < _amounts.length; i++)
203             sum += _amounts[i];
204 
205         require(walletBalances[owner] >= sum);
206         for (i = 0; i < _userIds.length; i++) {
207             balances[_userIds[i]] += _amounts[i];
208             blockedBalances[_userIds[i]] += _amounts[i];
209         }
210 
211         sentBonuses += sum;
212         walletBalances[owner] -= sum;
213     }
214 
215     /**
216      * Dispatcher can change user balance
217      */
218     function addServiceReward(uint _amount) external onlyDispatcher {
219         serviceReward += _amount;
220     }
221 
222     /**
223      * Owner withdraw service fee tokens 
224      */
225     function serviceFeeWithdraw() external onlyOwner {
226         require(serviceReward > 0);
227         if (gameToken.transfer(msg.sender, serviceReward))
228             serviceReward = 0;
229     }
230 
231     function viewSentBonuses() public view returns (uint) {
232         require(msg.sender == owner || msg.sender == server);
233         return sentBonuses;
234     }
235 
236     function viewServiceReward() public view returns (uint) {
237         require(msg.sender == owner || msg.sender == server);
238         return serviceReward;
239     }
240 }