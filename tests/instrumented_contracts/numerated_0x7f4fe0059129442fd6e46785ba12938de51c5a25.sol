1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address public owner;
5     function Owned() public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address newOwner) onlyOwner public {
15         owner = newOwner;
16     }
17 }
18 
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint _value, address _token, bytes _extraData) public; }
21 
22 contract TokenBase is Owned {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     uint public totalSupply;
27     uint public tokenUnit = 10 ** uint(decimals);
28     uint public wanUnit = 10000 * tokenUnit;
29     uint public foundingTime;
30 
31     mapping (address => uint) public balanceOf;
32     mapping (address => mapping (address => uint)) public allowance;
33 
34     event Transfer(address indexed _from, address indexed _to, uint _value);
35 
36     function TokenBase() public {
37         foundingTime = now;
38     }
39 
40     function _transfer(address _from, address _to, uint _value) internal {
41         require(_to != 0x0);
42         require(balanceOf[_from] >= _value);
43         require(balanceOf[_to] + _value > balanceOf[_to]);
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         balanceOf[_from] -= _value;
46         balanceOf[_to] += _value;
47         Transfer(_from, _to, _value);
48         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
49     }
50 
51     function transfer(address _to, uint _value) public {
52         _transfer(msg.sender, _to, _value);
53     }
54 
55     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
56         require(_value <= allowance[_from][msg.sender]);
57         allowance[_from][msg.sender] -= _value;
58         _transfer(_from, _to, _value);
59         return true;
60     }
61 
62     function approve(address _spender, uint _value) public returns (bool success) {
63         allowance[msg.sender][_spender] = _value;
64         return true;
65     }
66 
67     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
68         tokenRecipient spender = tokenRecipient(_spender);
69         if (approve(_spender, _value)) {
70             spender.receiveApproval(msg.sender, _value, this, _extraData);
71             return true;
72         }
73     }
74 }
75 
76 
77 contract WorkProff is TokenBase {
78     uint public oneYear = 1 years;
79     uint public minerTotalSupply = 3900 * wanUnit;
80     uint public minerTotalYears = 20;
81     uint public minerTotalTime = minerTotalYears * oneYear;
82     uint public minerPreSupply = minerTotalSupply / 2;
83     uint public minerPreTime = 7 days;
84     uint public minerTotalReward = 0;
85     uint public minerTimeOfLastProof;
86     uint public minerDifficulty = 10 ** 32;
87     bytes32 public minerCurrentChallenge;
88 
89     function WorkProff() public {
90         minerTimeOfLastProof = now;
91     }
92     
93     function proofOfWork(uint nonce) public {
94         require(minerTotalReward < minerTotalSupply);
95         bytes8 n = bytes8(sha3(nonce, minerCurrentChallenge));
96         require(n >= bytes8(minerDifficulty));
97 
98         uint timeSinceLastProof = (now - minerTimeOfLastProof);
99         require(timeSinceLastProof >= 5 seconds);
100         
101         uint reward = 0;
102         uint difficuty = 0;
103         if (now - foundingTime < minerPreTime) {
104             reward = timeSinceLastProof * minerPreSupply / minerPreTime;
105             difficuty = 0;
106         } else {
107             reward = timeSinceLastProof * (minerTotalSupply - minerPreSupply) / minerTotalTime;
108             difficuty = minerDifficulty;
109         }
110 
111         balanceOf[msg.sender] += reward;
112         totalSupply += reward;
113         minerDifficulty = minerDifficulty * 10 minutes / timeSinceLastProof + 1;
114         minerTimeOfLastProof = now;
115         minerCurrentChallenge = sha3(nonce, minerCurrentChallenge, block.blockhash(block.number - 1));
116         Transfer(0, this, reward);
117         Transfer(this, msg.sender, reward);
118     }
119 }
120 
121 
122 contract Option is WorkProff {
123     uint public optionTotalSupply;
124     uint public optionInitialSupply = 6600 * wanUnit;
125     uint public optionTotalTimes = 5;
126     uint public optionExerciseSpan = 1 years;
127 
128     mapping (address => uint) public optionOf;
129     mapping (address => uint) public optionExerciseOf;
130 
131     event OptionTransfer(address indexed from, address indexed to, uint option, uint exercised);
132     event OptionExercise(address indexed addr, uint value);
133 
134     function Option() public {
135         optionTotalSupply = optionInitialSupply;
136         optionOf[msg.sender] = optionInitialSupply;
137         optionExerciseOf[msg.sender] = 0;
138     }
139 
140     function min(uint a, uint b) private returns (uint) {
141         return a < b ? a : b;
142     }
143 
144     function _checkOptionExercise(uint option, uint exercised) internal returns (bool) {
145         uint canExercisedTimes = min(optionTotalTimes, (now - foundingTime) / optionExerciseSpan + 1);
146         return exercised <= option * canExercisedTimes / optionTotalTimes;
147     }
148 
149     function _optionTransfer(address _from, address _to, uint _option, uint _exercised) internal {
150         require(_to != 0x0);
151         require(optionOf[_from] >= _option);
152         require(optionOf[_to] + _option > optionOf[_to]);
153         require(optionExerciseOf[_from] >= _exercised);
154         require(optionExerciseOf[_to] + _exercised > optionExerciseOf[_to]);
155         require(_checkOptionExercise(_option, _exercised));
156         require(_checkOptionExercise(optionOf[_from] - _option, optionExerciseOf[_from] - _exercised));
157 
158         uint previousOptions = optionOf[_from] + optionOf[_to];
159         uint previousExercised = optionExerciseOf[_from] + optionExerciseOf[_to];
160         optionOf[_from] -= _option;
161         optionOf[_to] += _option;
162         optionExerciseOf[_from] -= _exercised;
163         optionExerciseOf[_to] += _exercised;
164         OptionTransfer(_from, _to, _option, _exercised);
165         assert(optionOf[_from] + optionOf[_to] == previousOptions);
166         assert(optionExerciseOf[_from] + optionExerciseOf[_to] == previousExercised);
167     }
168 
169     function optionTransfer(address _to, uint _option, uint _exercised) public {
170         _optionTransfer(msg.sender, _to, _option, _exercised);
171     }
172 
173     function optionExercise(uint value) public {
174         require(_checkOptionExercise(optionOf[msg.sender], optionExerciseOf[msg.sender] + value));
175         optionExerciseOf[msg.sender] += value;
176         balanceOf[msg.sender] += value;
177         totalSupply += value;
178         Transfer(0, this, value);
179         Transfer(this, msg.sender, value);
180         OptionExercise(msg.sender, value);
181     }
182 }
183 
184 contract Token is Option {
185     uint public initialSupply = 0 * wanUnit;
186     uint public reserveSupply = 10500 * wanUnit;
187     uint public sellSupply = 9000 * wanUnit;
188 
189     function Token() public {
190         totalSupply = initialSupply;
191         balanceOf[msg.sender] = initialSupply;
192         name = "ZBC";
193         symbol = "ZBC";
194     }
195 
196     function releaseReserve(uint value) onlyOwner public {
197         require(reserveSupply >= value);
198         balanceOf[owner] += value;
199         totalSupply += value;
200         reserveSupply -= value;
201         Transfer(0, this, value);
202         Transfer(this, owner, value);
203     }
204 
205     function releaseSell(uint value) onlyOwner public {
206         require(sellSupply >= value);
207         balanceOf[owner] += value;
208         totalSupply += value;
209         sellSupply -= value;
210         Transfer(0, this, value);
211         Transfer(this, owner, value);
212     }
213 }