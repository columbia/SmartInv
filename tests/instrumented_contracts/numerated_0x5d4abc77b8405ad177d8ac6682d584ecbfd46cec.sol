1 pragma solidity ^0.4.23;
2 
3 library Roles {
4     struct Role {
5         mapping(address => bool) bearer;
6     }
7 
8     function add(Role storage role, address addr) internal {
9         role.bearer[addr] = true;
10     }
11 
12     function remove(Role storage role, address addr) internal {
13         role.bearer[addr] = false;
14     }
15 
16     function check(Role storage role, address addr) view internal {
17         require(has(role, addr));
18     }
19 
20     function has(Role storage role, address addr) view internal returns (bool) {
21         return role.bearer[addr];
22     }
23 }
24 
25 contract RBAC {
26 
27     address initialOwner;
28 
29     using Roles for Roles.Role;
30 
31     mapping(string => Roles.Role) private roles;
32 
33     event RoleAdded(address addr, string roleName);
34     event RoleRemoved(address addr, string roleName);
35 
36     modifier onlyOwner() {
37         require(msg.sender == initialOwner);
38         _;
39     }
40 
41     function checkRole(address addr, string roleName) view public {
42         roles[roleName].check(addr);
43     }
44 
45     function hasRole(address addr, string roleName) view public returns (bool) {
46         return roles[roleName].has(addr);
47     }
48 
49     function addRole(address addr, string roleName) public onlyOwner {
50         roles[roleName].add(addr);
51         emit RoleAdded(addr, roleName);
52     }
53 
54     function removeRole(address addr, string roleName) public onlyOwner {
55         roles[roleName].remove(addr);
56         emit RoleRemoved(addr, roleName);
57     }
58 
59     modifier onlyRole(string roleName) {
60         checkRole(msg.sender, roleName);
61         _;
62     }
63 }
64 
65 library SafeMath {
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         if (a == 0) {
68             return 0;
69         }
70         uint256 c = a * b;
71         assert(c / a == b);
72         return c;
73     }
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         assert(b > 0);
77         // Solidity automatically throws when dividing by 0
78         uint256 c = a / b;
79         assert(a == b * c);
80         return c;
81     }
82 
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a - b;
85         assert(b <= a);
86         assert(a == c + b);
87         return c;
88     }
89 
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         assert(c >= a);
93         assert(a == c - b);
94         return c;
95     }
96 }
97 
98 contract PrimasToken is RBAC {
99 
100     using SafeMath for uint256;
101 
102     string public name;
103     uint256 public decimals;
104     string public symbol;
105     string public version;
106     uint256 public totalSupply;
107     uint256 initialAmount;
108     uint256 deployTime;
109     uint256 lastInflationDayStart;
110     uint256 incentivesPool;
111 
112     mapping(address => uint256) private userLockedTokens;
113     mapping(address => uint256) balances;
114     mapping(address => mapping(address => uint256)) allowed;
115 
116     event Transfer(address indexed _from, address indexed _to, uint256 _value);
117     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
118     event Lock(address userAddress, uint256 amount);
119     event Unlock(address userAddress,uint256 amount);
120     event Inflate (uint256 incentivesPoolValue);
121 
122     constructor(uint256 _previouslyInflatedAmount) public {
123         name = "Primas Token";
124         decimals = 18;
125         symbol = "PST";
126         version = "V2.0";
127         initialAmount = 100000000 * 10 ** decimals;
128         initialOwner = msg.sender;
129         deployTime = block.timestamp;
130         lastInflationDayStart = 0;
131         incentivesPool = 0;
132 
133         // Primas token is deployed at 2018/06/01
134         // When upgrading after new deployment of the contract
135         // we need to add the inflated tokens back
136         // for system consistency.
137 
138         totalSupply = initialAmount.add(_previouslyInflatedAmount);
139         balances[msg.sender] = totalSupply;
140 
141         emit Transfer(address(0), msg.sender, totalSupply);
142     }
143 
144     function inflate() public onlyRole("InflationOperator") returns (uint256)  {
145         uint256 currentTime = block.timestamp;
146         uint256 currentDayStart = currentTime / 1 days;
147         uint256 inflationAmount;
148         require(lastInflationDayStart != currentDayStart);
149         lastInflationDayStart = currentDayStart;
150         uint256 createDurationYears = (currentTime - deployTime) / 1 years;
151         if (createDurationYears < 1) {
152             inflationAmount = initialAmount / 10 / 365;
153         } else if (createDurationYears >= 20) {
154             inflationAmount = 0;
155         } else {
156             inflationAmount = initialAmount * (100 - (5 * createDurationYears)) / 365 / 1000;
157         }
158         incentivesPool = incentivesPool.add(inflationAmount);
159         totalSupply = totalSupply.add(inflationAmount);
160         emit Inflate(incentivesPool);
161         return incentivesPool;
162     }
163 
164     function getIncentivesPool() view public returns (uint256) {
165         return incentivesPool;
166     }
167 
168     function incentivesIn(address[] _users, uint256[] _values) public onlyRole("IncentivesCollector") returns (bool success) {
169         require(_users.length == _values.length);
170         for (uint256 i = 0; i < _users.length; i++) {
171             userLockedTokens[_users[i]] = userLockedTokens[_users[i]].sub(_values[i]);
172             balances[_users[i]] = balances[_users[i]].sub(_values[i]);
173             incentivesPool = incentivesPool.add(_values[i]);
174             emit Transfer(_users[i], address(0), _values[i]);
175         }
176         return true;
177     }
178 
179     function incentivesOut(address[] _users, uint256[] _values) public onlyRole("IncentivesDistributor") returns (bool success) {
180         require(_users.length == _values.length);
181         for (uint256 i = 0; i < _users.length; i++) {
182             incentivesPool = incentivesPool.sub(_values[i]);
183             balances[_users[i]] = balances[_users[i]].add(_values[i]);
184             emit Transfer(address(0), _users[i], _values[i]);
185         }
186         return true;
187     }
188 
189     function tokenLock(address _userAddress, uint256 _amount) public onlyRole("Locker") {
190         require(balanceOf(_userAddress) >= _amount);
191         userLockedTokens[_userAddress] = userLockedTokens[_userAddress].add(_amount);
192         emit Lock(_userAddress, _amount);
193     }
194 
195     function tokenUnlock(address _userAddress, uint256 _amount, address _to, uint256 _toAmount) public onlyRole("Unlocker") {
196         require(_amount >= _toAmount);
197         require(userLockedTokens[_userAddress] >= _amount);
198         userLockedTokens[_userAddress] = userLockedTokens[_userAddress].sub(_amount);
199         emit Unlock(_userAddress, _amount);
200         if (_to != address(0) && _toAmount != 0) {
201             balances[_userAddress] = balances[_userAddress].sub(_toAmount);
202             balances[_to] = balances[_to].add(_toAmount);
203             emit Transfer(_userAddress, _to, _toAmount);
204         }
205     }
206 
207     function transferAndLock(address _userAddress, address _to, uint256 _amount) public onlyRole("Locker")  {
208         require(balanceOf(_userAddress) >= _amount);
209         balances[_userAddress] = balances[_userAddress].sub(_amount);
210         balances[_to] = balances[_to].add(_amount);
211         userLockedTokens[_to] = userLockedTokens[_to].add(_amount);
212         emit Transfer(_userAddress, _to, _amount);
213         emit Lock(_to, _amount);
214     }
215 
216     function balanceOf(address _owner) view public returns (uint256 balance) {
217         return balances[_owner] - userLockedTokens[_owner];
218     }
219 
220     function transfer(address _to, uint256 _value) public returns (bool success) {
221         require(balanceOf(msg.sender) >= _value);
222         balances[msg.sender] = balances[msg.sender].sub(_value);
223         balances[_to] = balances[_to].add(_value);
224         emit Transfer(msg.sender, _to, _value);
225         return true;
226     }
227 
228     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
229         require(balanceOf(_from) >= _value && allowed[_from][msg.sender] >= _value);
230         balances[_from] = balances[_from].sub(_value);
231         balances[_to] = balances[_to].add(_value);
232         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233         emit Transfer(_from, _to, _value);
234         return true;
235     }
236 
237     function approve(address _spender, uint256 _value) public returns (bool success) {
238         allowed[msg.sender][_spender] = _value;
239         emit Approval(msg.sender, _spender, _value);
240         return true;
241     }
242 
243     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
244         return allowed[_owner][_spender];
245     }
246 }