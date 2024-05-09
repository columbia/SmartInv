1 pragma solidity ^0.4.18;
2 
3 // 管理员合约
4 contract Owned {
5     address public owner;
6     function Owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 
21 interface tokenRecipient { function receiveApproval(address _from, uint _value, address _token, bytes _extraData) public; }
22 
23 // 代币交易合约
24 contract TokenBase is Owned {
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;
28     uint public totalSupply;
29     uint public tokenUnit = 10 ** uint(decimals);
30     uint public wanUnit = 10000 * tokenUnit;
31     uint public foundingTime;
32 
33     mapping (address => uint) public balanceOf;
34     mapping (address => mapping (address => uint)) public allowance;
35 
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37 
38     function TokenBase() public {
39         foundingTime = now;
40     }
41 
42     function _transfer(address _from, address _to, uint _value) internal {
43         require(_to != 0x0);
44         require(balanceOf[_from] >= _value);
45         require(balanceOf[_to] + _value > balanceOf[_to]);
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         balanceOf[_from] -= _value;
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53     function transfer(address _to, uint _value) public {
54         _transfer(msg.sender, _to, _value);
55     }
56 
57     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
58         require(_value <= allowance[_from][msg.sender]);
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function approve(address _spender, uint _value) public returns (bool success) {
65         allowance[msg.sender][_spender] = _value;
66         return true;
67     }
68 
69     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
70         tokenRecipient spender = tokenRecipient(_spender);
71         if (approve(_spender, _value)) {
72             spender.receiveApproval(msg.sender, _value, this, _extraData);
73             return true;
74         }
75     }
76 }
77 
78 // 工作证明挖矿合约
79 contract WorkProff is TokenBase {
80     uint public oneYear = 1 years;
81     uint public minerTotalSupply = 3900 * wanUnit;              // 挖矿：总供应量
82     uint public minerTotalYears = 20;                           // 挖矿：挖完总年数
83     uint public minerTotalTime = minerTotalYears * oneYear;     // 挖矿：挖完总时间
84     uint public minerPreSupply = minerTotalSupply / 2;
85     uint public minerPreTime = 7 days;
86     uint public minerTotalReward = 0;                           // 挖矿：总奖励
87     uint public minerTimeOfLastProof;                           // 挖矿：上次奖励时间
88     uint public minerDifficulty = 10 ** 32;                     // 挖矿：难度
89     bytes32 public minerCurrentChallenge;
90 
91     function WorkProff() public {
92         minerTimeOfLastProof = now;
93     }
94     
95     function proofOfWork(uint nonce) public {
96         require(minerTotalReward < minerTotalSupply);
97         bytes8 n = bytes8(sha3(nonce, minerCurrentChallenge));
98         require(n >= bytes8(minerDifficulty));
99 
100         uint timeSinceLastProof = (now - minerTimeOfLastProof);
101         require(timeSinceLastProof >= 5 seconds);
102         
103         uint reward = 0;
104         uint difficuty = 0;
105         if (now - foundingTime < minerPreTime) {
106             reward = timeSinceLastProof * minerPreSupply / minerPreTime;
107             difficuty = 0;
108         } else {
109             reward = timeSinceLastProof * (minerTotalSupply - minerPreSupply) / minerTotalTime;
110             difficuty = minerDifficulty;
111         }
112 
113         balanceOf[msg.sender] += reward;
114         totalSupply += reward;
115         minerDifficulty = minerDifficulty * 10 minutes / timeSinceLastProof + 1;
116         minerTimeOfLastProof = now;
117         minerCurrentChallenge = sha3(nonce, minerCurrentChallenge, block.blockhash(block.number - 1));
118         Transfer(0, this, reward);
119         Transfer(this, msg.sender, reward);
120     }
121 }
122 
123 // 定期间隔期权合约
124 contract Option is WorkProff {
125     uint public optionTotalSupply;                          // 期权：总量
126     uint public optionInitialSupply = 6600 * wanUnit;       // 期权：初始期权供应量（4500 + 2100）
127     uint public optionTotalTimes = 5;                       // 期权：总行权次数
128     uint public optionExerciseSpan = 1 years;               // 期权：行权间隔
129 
130     mapping (address => uint) public optionOf;              // 期权：期权总数量
131     mapping (address => uint) public optionExerciseOf;      // 期权：已经行权的期权
132 
133     event OptionTransfer(address indexed from, address indexed to, uint option, uint exercised);
134     event OptionExercise(address indexed addr, uint value);
135 
136     function Option() public {
137         optionTotalSupply = optionInitialSupply;
138         optionOf[msg.sender] = optionInitialSupply;
139         optionExerciseOf[msg.sender] = 0;
140     }
141 
142     function min(uint a, uint b) private returns (uint) {
143         return a < b ? a : b;
144     }
145 
146     function _checkOptionExercise(uint option, uint exercised) internal returns (bool) {
147         uint canExercisedTimes = min(optionTotalTimes, (now - foundingTime) / optionExerciseSpan + 1);
148         return exercised <= option * canExercisedTimes / optionTotalTimes;
149     }
150 
151     function _optionTransfer(address _from, address _to, uint _option, uint _exercised) internal {
152         require(_to != 0x0);
153         require(optionOf[_from] >= _option);
154         require(optionOf[_to] + _option > optionOf[_to]);
155         require(optionExerciseOf[_from] >= _exercised);
156         require(optionExerciseOf[_to] + _exercised > optionExerciseOf[_to]);
157         require(_checkOptionExercise(_option, _exercised));
158         require(_checkOptionExercise(optionOf[_from] - _option, optionExerciseOf[_from] - _exercised));
159 
160         uint previousOptions = optionOf[_from] + optionOf[_to];
161         uint previousExercised = optionExerciseOf[_from] + optionExerciseOf[_to];
162         optionOf[_from] -= _option;
163         optionOf[_to] += _option;
164         optionExerciseOf[_from] -= _exercised;
165         optionExerciseOf[_to] += _exercised;
166         OptionTransfer(_from, _to, _option, _exercised);
167         assert(optionOf[_from] + optionOf[_to] == previousOptions);
168         assert(optionExerciseOf[_from] + optionExerciseOf[_to] == previousExercised);
169     }
170 
171     function optionTransfer(address _to, uint _option, uint _exercised) public {
172         _optionTransfer(msg.sender, _to, _option, _exercised);
173     }
174 
175     function optionExercise(uint value) public {
176         require(_checkOptionExercise(optionOf[msg.sender], optionExerciseOf[msg.sender] + value));
177         optionExerciseOf[msg.sender] += value;
178         balanceOf[msg.sender] += value;
179         totalSupply += value;
180         Transfer(0, this, value);
181         Transfer(this, msg.sender, value);
182         OptionExercise(msg.sender, value);
183     }
184 }
185 
186 contract Token is Option {
187     uint public initialSupply = 0 * wanUnit;        // 初始供应量
188     uint public reserveSupply = 10500 * wanUnit;    // 锁定：预留
189     uint public sellSupply = 9000 * wanUnit;        // 锁定：ICO
190 
191     function Token() public {
192         totalSupply = initialSupply;
193         balanceOf[msg.sender] = initialSupply;
194         name = "ZBC";
195         symbol = "ZBC";
196     }
197 
198     function releaseReserve(uint value) onlyOwner public {
199         require(reserveSupply >= value);
200         balanceOf[owner] += value;
201         totalSupply += value;
202         reserveSupply -= value;
203         Transfer(0, this, value);
204         Transfer(this, owner, value);
205     }
206 
207     function releaseSell(uint value) onlyOwner public {
208         require(sellSupply >= value);
209         balanceOf[owner] += value;
210         totalSupply += value;
211         sellSupply -= value;
212         Transfer(0, this, value);
213         Transfer(this, owner, value);
214     }
215 }