1 contract Ownable {
2     address public owner;
3 
4     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner, "Function can only be performed by the owner");
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         require(newOwner != address(0), "Invalid address");
17         emit OwnershipTransferred(owner, newOwner);
18         owner = newOwner;
19     }
20 }
21 
22 library SafeMath {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 contract Token is Ownable {
52     using SafeMath for uint;
53 
54     string public name = "Virtual Token";
55     string public symbol = "VITO";
56     uint8 public decimals = 4;
57     uint256 public totalSupply = 100000000000000;
58 
59     mapping (address => Balance) private _balances;
60     address[] private _hodlers;
61 
62     mapping (address => mapping (address => uint256)) private allowed;
63 
64     //0.6 * 10 ** 4 (decimals)
65     uint256 public pa = 600; //6% pa
66     uint256 public rate = 16; //per day
67 
68     uint256 private _min = 50000 * 10 ** decimals;
69 
70     uint256 public _start;
71 
72     struct Balance {
73         uint256 timestamp;
74         uint256 amount;
75         uint index;
76     }
77 
78     constructor () public {
79         _start = now;
80         insertHodler(msg.sender);
81 
82         _balances[msg.sender].timestamp = _start;
83         _balances[msg.sender].amount = totalSupply;
84     }
85 
86     function balanceOf(address who) public view returns (uint256) {
87         if (who == owner) {
88             uint256 incirculation = _getInCirculation();
89             return totalSupply.sub(incirculation);
90         } else {
91             return _getBalance(who, now);
92         }
93     }
94 
95     function transfer(address to, uint256 value) public returns (bool) {
96         require(balanceOf(msg.sender) >= value, "Insufficient balance");
97 
98         insertHodler(to);
99 
100         uint256 timestamp = now;
101         if (msg.sender == owner) {
102             _balances[owner].amount = _balances[owner].amount.sub(value);
103         } else {
104             _balances[msg.sender].timestamp = timestamp;
105             _balances[msg.sender].amount = _getBalance(msg.sender, timestamp).sub(value);
106         }
107 
108         if (to == owner) {
109             _balances[owner].amount = _balances[owner].amount.add(value);
110         } else {
111             _balances[to].timestamp = timestamp;
112             _balances[to].amount = _getBalance(to, timestamp).add(value);
113         }
114 
115         emit Transfer(msg.sender, to, value);
116         return true;
117     }
118 
119     function transferFrom(address from, address to, uint256 value) public returns (bool) {
120         uint256 timestamp = now;
121 
122         require(_getBalance(from, timestamp) >= value, "Insufficient balance");
123         require(_getBalance(to, timestamp).add(value) >= _getBalance(to, timestamp), "Insufficient balance");
124         require(allowed[from][msg.sender] >= value, "Insufficient balance");
125         
126         _balances[from].timestamp = now;
127         _balances[from].amount = _getBalance(from, timestamp).sub(value);
128 
129         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
130 
131         _balances[to].timestamp = now;
132         _balances[to].amount = _getBalance(to, timestamp).add(value);
133 
134         emit Transfer(from, to, value);
135         return true;
136     }
137 
138     function approve(address spender, uint256 amount) public returns (bool) {
139         require(spender != address(0), "Invalid address");
140 
141         allowed[msg.sender][spender] = amount;
142         emit Approval(msg.sender, spender, amount);
143         return true;
144     }
145 
146     function delta(uint256 from, uint256 to) public pure returns (uint256) {
147         require(to >= from, "To must be greater than from");
148         return to - from;
149     }
150 
151     function calcInterest(uint256 amount, uint256 _days) public view returns (uint256) {
152         uint256 perYear = (_days * uint256(10) ** decimals) / 365;
153         return (amount * pa * perYear) / uint256(10) ** (decimals * 2);
154     }
155 
156     function _getBalance(address who, uint256 timestamp) private view returns(uint256) {
157         if (_balances[who].amount < _min) {
158             return _balances[who].amount;
159         } else {
160             uint256 _delta = delta(_balances[who].timestamp, timestamp);
161             _delta = _delta.div(24 * 60 * 60);
162 
163             return _balances[who].amount + calcInterest(_balances[who].amount, _delta);
164         }
165     }
166 
167     function _getInCirculation() public view returns(uint256) {
168         uint256 cumlative = 0;
169         uint256 timestamp = now;
170 
171         for (uint256 i = 0; i < _hodlers.length; i++) {
172             address who = _hodlers[i];
173 
174             if (who != owner) {
175                 uint256 balance = _getBalance(who, timestamp);
176                 cumlative = cumlative.add(balance);
177             }
178         }
179 
180         return cumlative;
181     }
182 
183     function isHodler(address who) public view returns(bool) {
184         if(_hodlers.length == 0) return false;
185         return (_hodlers[_balances[who].index] == who);
186     }
187 
188     function insertHodler(address who) public returns(uint index) {
189         if(!isHodler(who)) {
190             _balances[who].index = _hodlers.push(who) - 1;
191             return _hodlers.length - 1;
192         }
193 
194         return 0;
195     }
196 
197     event Approval(address indexed owner, address indexed spender, uint256 value);
198     event Transfer(address indexed from, address indexed to, uint256 value);
199 }