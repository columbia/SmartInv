1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6       if (a == 0) {
7         return 0;
8       }
9       uint256 c = a * b;
10       assert(c / a == b);
11       return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15       // assert(b > 0); // Solidity automatically throws when dividing by 0
16       uint256 c = a / b;
17       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18       return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22       assert(b <= a);
23       return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27       uint256 c = a + b;
28       assert(c >= a);
29       return c;
30     }
31 }
32 
33 contract BETR_TOKEN {
34     using SafeMath for uint256;
35 
36     string public constant name = "Better Betting";
37     string public symbol = "BETR";
38     uint256 public constant decimals = 18;
39 
40     uint256 public hardCap = 650000000 * (10 ** decimals);
41     uint256 public totalSupply;
42 
43     address public escrow; // reference to escrow contract for transaction and authorization
44     address public owner; // reference to the contract creator
45     address public tgeIssuer = 0xba81ACCC7074B5D9ABDAa25c30DbaD96BF44D660;
46 
47     bool public tgeActive;
48     uint256 public tgeDuration = 30 days;
49     uint256 public tgeStartTime;
50 
51     mapping (address => uint256) balances;
52     mapping (address => mapping (address => uint256)) allowed; // third party authorisations for token transfering
53     mapping (address => bool) public escrowAllowed; // per address switch authorizing the escrow to escrow user tokens
54 
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 
58     function BETR_TOKEN() public {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     modifier onlyTgeIssuer {
68         require(msg.sender == tgeIssuer);
69         _;
70     }
71 
72     modifier onlyEscrow {
73         require(msg.sender == escrow);
74         _;
75     }
76 
77     modifier tgeRunning {
78         require(tgeActive && block.timestamp < tgeStartTime + tgeDuration);
79         _;
80     }
81 
82     function transfer(address _to, uint256 _value) public returns (bool) {
83         require(
84             _to != address(0) &&
85             balances[msg.sender] >= _value &&
86             balances[_to] + _value > balances[_to]
87         );
88         balances[msg.sender] = balances[msg.sender].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         Transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
95         require (
96           _from != address(0) &&
97           _to != address(0) &&
98           balances[_from] >= _value &&
99           allowed[_from][msg.sender] >= _value &&
100           balances[_to] + _value > balances[_to]
101         );
102         balances[_from] = balances[_from].sub(_value);
103         balances[_to] = balances[_to].add(_value);
104         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105         Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function approve(address _spender, uint256 _value) public returns (bool) {
110         require(_spender != address(0));
111         allowed[msg.sender][_spender] = _value;
112         Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     function allowEscrow(bool _choice) external returns(bool) {
117       escrowAllowed[msg.sender] = _choice;
118       return true;
119     }
120 
121     function escrowFrom(address _from, uint256 _value) external onlyEscrow returns(bool) {
122       require (
123         _from != address(0) &&
124         balances[_from] >= _value &&
125         escrowAllowed[_from] &&
126         _value > 0
127       );
128       balances[_from] = balances[_from].sub(_value);
129       balances[escrow] = balances[escrow].add(_value);
130       Transfer(_from, escrow, _value);
131       return true;
132     }
133 
134     function escrowReturn(address _to, uint256 _value, uint256 _fee) external onlyEscrow returns(bool) {
135         require(
136             _to != address(0) &&
137             _value > 0
138         );
139         if(_fee > 0) {
140             require(_fee < totalSupply && _fee < balances[escrow]);
141             totalSupply = totalSupply.sub(_fee);
142             balances[escrow] = balances[escrow].sub(_fee);
143         }
144         require(transfer(_to, _value));
145         return true;
146     }
147 
148     function mint(address _user, uint256 _tokensAmount) public onlyTgeIssuer tgeRunning returns(bool) {
149         uint256 newSupply = totalSupply.add(_tokensAmount);
150         require(
151             _user != address(0) &&
152             _tokensAmount > 0 &&
153              newSupply < hardCap
154         );
155         balances[_user] = balances[_user].add(_tokensAmount);
156         totalSupply = newSupply;
157         Transfer(0x0, _user, _tokensAmount);
158         return true;
159     }
160 
161     function reserveTokensGroup(address[] _users, uint256[] _tokensAmounts) external onlyOwner {
162         require(_users.length == _tokensAmounts.length);
163         uint256 newSupply;
164         for(uint8 i = 0; i < _users.length; i++){
165             newSupply = totalSupply.add(_tokensAmounts[i].mul(10 ** decimals));
166             require(
167                 _users[i] != address(0) &&
168                 _tokensAmounts[i] > 0 &&
169                 newSupply < hardCap
170             );
171             balances[_users[i]] = balances[_users[i]].add(_tokensAmounts[i].mul(10 ** decimals));
172             totalSupply = newSupply;
173             Transfer(0x0, _users[i], _tokensAmounts[i]);
174         }
175     }
176 
177     function reserveTokens(address _user, uint256 _tokensAmount) external onlyOwner {
178         uint256 newSupply = totalSupply.add(_tokensAmount.mul(10 ** decimals));
179         require(
180             _user != address(0) &&
181             _tokensAmount > 0 &&
182             newSupply < hardCap
183         );
184         balances[_user] = balances[_user].add(_tokensAmount.mul(10 ** decimals));
185         totalSupply = newSupply;
186         Transfer(0x0, _user, _tokensAmount);
187     }
188 
189     function startTge() external onlyOwner {
190         tgeActive = true;
191         if(tgeStartTime == 0) tgeStartTime = block.timestamp;
192     }
193 
194     function stopTge(bool _restart) external onlyOwner {
195       tgeActive = false;
196       if(_restart) tgeStartTime = 0;
197     }
198 
199     function extendTge(uint256 _time) external onlyOwner {
200       tgeDuration = tgeDuration.add(_time);
201     }
202 
203     function setEscrow(address _escrow) external onlyOwner {
204         escrow = _escrow;
205     }
206 
207     function setTgeIssuer(address _tgeIssuer) external onlyOwner {
208         tgeIssuer = _tgeIssuer;
209     }
210 
211     function balanceOf(address _owner) external view returns (uint256) {
212         return balances[_owner];
213     }
214 
215     function allowance(address _owner, address _spender) external view returns (uint256) {
216         return allowed[_owner][_spender];
217     }
218 }