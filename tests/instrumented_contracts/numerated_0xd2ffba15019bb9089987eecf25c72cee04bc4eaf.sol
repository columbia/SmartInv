1 pragma solidity 0.4.25;
2 
3 library IdeaUint {
4 
5     function add(uint a, uint b) constant internal returns (uint result) {
6         uint c = a + b;
7 
8         assert(c >= a);
9 
10         return c;
11     }
12 
13     function sub(uint a, uint b) constant internal returns (uint result) {
14         uint c = a - b;
15 
16         assert(b <= a);
17 
18         return c;
19     }
20 
21     function mul(uint a, uint b) constant internal returns (uint result) {
22         uint c = a * b;
23 
24         assert(a == 0 || c / a == b);
25 
26         return c;
27     }
28 
29     function div(uint a, uint b) constant internal returns (uint result) {
30         uint c = a / b;
31 
32         return c;
33     }
34 }
35 
36 contract IdeaBasicCoin {
37     using IdeaUint for uint;
38 
39     string public name;
40     string public symbol;
41     uint8 public decimals;
42     uint public totalSupply;
43     mapping(address => uint) balances;
44     mapping(address => mapping(address => uint)) allowed;
45     address public owner;
46 
47     event Transfer(address indexed _from, address indexed _to, uint _value);
48     event Approval(address indexed _owner, address indexed _spender, uint _value);
49 
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     function balanceOf(address _owner) constant public returns (uint balance) {
56         return balances[_owner];
57     }
58 
59     function transfer(address _to, uint _value) public returns (bool success) {
60         balances[msg.sender] = balances[msg.sender].sub(_value);
61         balances[_to] = balances[_to].add(_value);
62 
63         emit Transfer(msg.sender, _to, _value);
64 
65         return true;
66     }
67 
68     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
69         uint _allowance = allowed[_from][msg.sender];
70 
71         balances[_from] = balances[_from].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         allowed[_from][msg.sender] = _allowance.sub(_value);
74 
75         emit Transfer(_from, _to, _value);
76 
77         return true;
78     }
79 
80     function approve(address _spender, uint _value) public returns (bool success) {
81         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
82 
83         allowed[msg.sender][_spender] = _value;
84 
85         emit Approval(msg.sender, _spender, _value);
86 
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant public returns (uint remaining) {
91         return allowed[_owner][_spender];
92     }
93 
94     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
95         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
96 
97         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98 
99         return true;
100     }
101 
102     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
103         uint oldValue = allowed[msg.sender][_spender];
104 
105         if (_subtractedValue > oldValue) {
106             allowed[msg.sender][_spender] = 0;
107         } else {
108             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
109         }
110 
111         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112 
113         return true;
114     }
115 }
116 
117 contract ShitCoin is IdeaBasicCoin {
118 
119     uint public earnedEthWei;
120     uint public soldShitWei;
121     uint public nextRoundReserve;
122     address public bank1;
123     address public bank2;
124     uint public bank1Val;
125     uint public bank2Val;
126     uint public bankValReserve;
127 
128     enum IcoStates {
129         Coming,
130         Ico,
131         Done
132     }
133 
134     IcoStates public icoState;
135 
136     constructor() public {
137         name = 'ShitCoin';
138         symbol = 'SHIT';
139         decimals = 18;
140         totalSupply = 100500 ether;
141 
142         owner = msg.sender;
143     }
144 
145     function() payable public {
146         uint tokens;
147         uint totalVal = msg.value + bankValReserve;
148         uint halfVal = totalVal / 2;
149 
150         if (icoState == IcoStates.Ico && soldShitWei < (totalSupply / 2)) {
151 
152             tokens = msg.value;
153             balances[msg.sender] += tokens;
154             soldShitWei += tokens;
155         } else {
156             revert();
157         }
158 
159         emit Transfer(msg.sender, 0x0, tokens);
160         earnedEthWei += msg.value;
161 
162         bank1Val += halfVal;
163         bank2Val += halfVal;
164         bankValReserve = totalVal - (halfVal * 2);
165     }
166 
167     function setBank(address _bank1, address _bank2) public onlyOwner {
168         require(bank1 == address(0x0));
169         require(bank2 == address(0x0));
170         require(_bank1 != address(0x0));
171         require(_bank2 != address(0x0));
172 
173         bank1 = _bank1;
174         bank2 = _bank2;
175 
176         balances[bank1] = 25627 ether;
177         balances[bank2] = 25627 ether;
178     }
179 
180     function startIco() public onlyOwner {
181         icoState = IcoStates.Ico;
182     }
183 
184     function stopIco() public onlyOwner {
185         icoState = IcoStates.Done;
186     }
187 
188     function withdrawEther() public {
189         require(msg.sender == bank1 || msg.sender == bank2);
190 
191         if (msg.sender == bank1) {
192             bank1.transfer(bank1Val);
193             bank1Val = 0;
194         }
195 
196         if (msg.sender == bank2) {
197             bank2.transfer(bank2Val);
198             bank2Val = 0;
199         }
200     }
201 }