1 pragma solidity ^0.4.23;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b > 0);
16         // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         assert(a == b * c);
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a - b;
24         assert(b <= a);
25         assert(a == c + b);
26         return c;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         assert(a == c - b);
33         return c;
34     }
35 }
36 
37 
38 
39 library Roles {
40     struct Role {
41         mapping(address => bool) bearer;
42     }
43 
44     function add(Role storage role, address addr) internal {
45         role.bearer[addr] = true;
46     }
47 
48     function remove(Role storage role, address addr) internal {
49         role.bearer[addr] = false;
50     }
51 
52     function check(Role storage role, address addr) view internal {
53         require(has(role, addr));
54     }
55 
56     function has(Role storage role, address addr) view internal returns (bool) {
57         return role.bearer[addr];
58     }
59 }
60 
61 
62 contract RBAC {
63 
64     address initialOwner;
65 
66     using Roles for Roles.Role;
67 
68     mapping(string => Roles.Role) private roles;
69 
70     event RoleAdded(address addr, string roleName);
71     event RoleRemoved(address addr, string roleName);
72 
73     modifier onlyOwner() {
74         require(msg.sender == initialOwner);
75         _;
76     }
77 
78     function checkRole(address addr, string roleName) view public {
79         roles[roleName].check(addr);
80     }
81 
82     function hasRole(address addr, string roleName) view public returns (bool) {
83         return roles[roleName].has(addr);
84     }
85 
86     function addRole(address addr, string roleName) public onlyOwner {
87         roles[roleName].add(addr);
88         emit RoleAdded(addr, roleName);
89     }
90 
91     function removeRole(address addr, string roleName) public onlyOwner {
92         roles[roleName].remove(addr);
93         emit RoleRemoved(addr, roleName);
94     }
95 
96     modifier onlyRole(string roleName) {
97         checkRole(msg.sender, roleName);
98         _;
99     }
100 }
101 
102 
103 contract PrimasToken is RBAC {
104 
105     using SafeMath for uint256;
106 
107     string public name;
108     uint256 public decimals;
109     string public symbol;
110     string public version;
111     uint256 public totalSupply;
112     uint256 initialAmount;
113     uint256 deployTime;
114     uint256 lastInflationDayStart;
115     uint256 incentivesPool;
116 
117     mapping(address => uint256) private userLockedTokens;
118     mapping(address => uint256) balances;
119     mapping(address => mapping(address => uint256)) allowed;
120 
121     event Transfer(address indexed _from, address indexed _to, uint256 _value);
122     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
123     event Lock(address userAddress, uint256 amount);
124     event Unlock(address userAddress,uint256 amount);
125     event Inflate (uint256 incentivesPoolValue);
126 
127     constructor() public {
128         name = "Primas Token";
129         decimals = 18;
130         symbol = "PST";
131         version = "V2.0";
132         initialAmount = 100000000 * 10 ** decimals;
133         balances[msg.sender] = initialAmount;
134         totalSupply = initialAmount;
135         initialOwner = msg.sender;
136         deployTime = block.timestamp;
137         incentivesPool = 0;
138         lastInflationDayStart = 0;
139         emit Transfer(address(0), msg.sender, initialAmount);
140     }
141 
142     function inflate() public onlyRole("InflationOperator") returns (uint256)  {
143         uint256 currentTime = block.timestamp;
144         uint256 currentDayStart = currentTime / 1 days;
145         uint256 inflationAmount;
146         require(lastInflationDayStart != currentDayStart);
147         lastInflationDayStart = currentDayStart;
148         uint256 createDurationYears = (currentTime - deployTime) / 1 years;
149         if (createDurationYears < 1) {
150             inflationAmount = initialAmount / 10 / 365;
151         } else if (createDurationYears >= 20) {
152             inflationAmount = 0;
153         } else {
154             inflationAmount = initialAmount * (100 - (5 * createDurationYears)) / 365 * 1000;
155         }
156         incentivesPool = incentivesPool.add(inflationAmount);
157         totalSupply = totalSupply.add(inflationAmount);
158         emit Inflate(incentivesPool);
159         return incentivesPool;
160     }
161 
162     function getIncentivesPool() view public returns (uint256) {
163         return incentivesPool;
164     }
165 
166     function incentivesIn(address[] _users, uint256[] _values) public onlyRole("IncentivesCollector") returns (bool success) {
167         require(_users.length == _values.length);
168         for (uint256 i = 0; i < _users.length; i++) {
169             incentivesPool = incentivesPool.add(_values[i]);
170             balances[_users[i]] = balances[_users[i]].sub(_values[i]);
171             userLockedTokens[_users[i]] = userLockedTokens[_users[i]].sub(_values[i]);
172             emit Transfer(_users[i], address(0), _values[i]);
173         }
174         return true;
175     }
176 
177     function incentivesOut(address[] _users, uint256[] _values) public onlyRole("IncentivesDistributor") returns (bool success) {
178         require(_users.length == _values.length);
179         for (uint256 i = 0; i < _users.length; i++) {
180             incentivesPool = incentivesPool.sub(_values[i]);
181             balances[_users[i]] = balances[_users[i]].add(_values[i]);
182             emit Transfer(address(0), _users[i], _values[i]);
183         }
184         return true;
185     }
186 
187     function tokenLock(address _userAddress, uint256 _amount) public onlyRole("Locker") {
188         require(balanceOf(_userAddress) >= _amount);
189         userLockedTokens[_userAddress] = userLockedTokens[_userAddress].add(_amount);
190         emit Lock(_userAddress, _amount);
191     }
192 
193     function tokenUnlock(address _userAddress, uint256 _amount, address _to, uint256 _toAmount) public onlyRole("Unlocker") {
194         require(_amount >= _toAmount);
195         require(userLockedTokens[_userAddress] >= _amount);
196         userLockedTokens[_userAddress] = userLockedTokens[_userAddress].sub(_amount);
197         emit Unlock(_userAddress, _amount);
198         if (_to != address(0) && _toAmount != 0) {
199             balances[_userAddress] = balances[_userAddress].sub(_toAmount);
200             balances[_to] = balances[_to].add(_toAmount);
201             emit Transfer(_userAddress, _to, _toAmount);
202         }
203     }
204 
205     function transferAndLock(address _userAddress, address _to, uint256 _amount) public onlyRole("Locker")  {
206         require(balanceOf(_userAddress) >= _amount);
207         balances[_userAddress] = balances[_userAddress].sub(_amount);
208         balances[_to] = balances[_to].add(_amount);
209         userLockedTokens[_to] = userLockedTokens[_to].add(_amount);
210         emit Transfer(_userAddress, _to, _amount);
211         emit Lock(_to, _amount);
212     }
213 
214     function balanceOf(address _owner) view public returns (uint256 balance) {
215         return balances[_owner] - userLockedTokens[_owner];
216     }
217 
218     function transfer(address _to, uint256 _value) public returns (bool success) {
219         require(balanceOf(msg.sender) >= _value);
220         balances[msg.sender] = balances[msg.sender].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         emit Transfer(msg.sender, _to, _value);
223         return true;
224     }
225 
226     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
227         require(balanceOf(_from) >= _value && allowed[_from][msg.sender] >= _value);
228         balances[_from] = balances[_from].sub(_value);
229         balances[_to] = balances[_to].add(_value);
230         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231         emit Transfer(_from, _to, _value);
232         return true;
233     }
234 
235     function approve(address _spender, uint256 _value) public returns (bool success) {
236         allowed[msg.sender][_spender] = _value;
237         emit Approval(msg.sender, _spender, _value);
238         return true;
239     }
240 
241     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
242         return allowed[_owner][_spender];
243     }
244 }