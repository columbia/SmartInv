1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract TrueTogetherToken {
31 
32     string public constant name = "TRUE Together Token";
33     string public constant symbol = "TTR";
34     uint256 public constant decimals = 18;
35     uint256 _totalSupply = 100000000 * 10 ** decimals;
36     address public founder = 0x0;
37     uint256 public voteEndTime;
38     uint256 airdropNum = 1 ether;
39     uint256 public distributed = 0;
40 
41     mapping (address => bool) touched;
42     mapping (address => uint256) public balances;
43     mapping (address => uint256) public frozen;
44     mapping (address => uint256) public totalVotes;
45 	
46     mapping (address => mapping (address => uint256)) public votingInfo;
47     mapping (address => mapping (address => uint256)) allowed;
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Vote(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 
53     constructor() public { 
54         founder = msg.sender;
55         voteEndTime = 1534348800;
56     }
57 
58     function totalSupply() view public returns (uint256 supply) {
59         return _totalSupply;
60     }
61 
62     function balanceOf(address _owner) public returns (uint256 balance) {
63         if (!touched[_owner] && SafeMath.add(distributed, airdropNum) < _totalSupply && now < voteEndTime) {
64             touched[_owner] = true;
65             distributed = SafeMath.add(distributed, airdropNum);
66             balances[_owner] = SafeMath.add(balances[_owner], airdropNum);
67             emit Transfer(this, _owner, airdropNum);
68         }
69         return balances[_owner];
70     }
71 
72     function transfer(address _to, uint256 _value) public returns (bool success) {
73         require (_to != 0x0);
74 
75         if (now > voteEndTime) {
76             require((balances[msg.sender] >= _value));
77             balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
78             balances[_to] = SafeMath.add(balances[_to], _value);
79             emit Transfer(msg.sender, _to, _value);
80             return true;	 
81         } else {
82             require(balances[msg.sender] >= SafeMath.add(frozen[msg.sender], _value));
83             balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
84             balances[_to] = SafeMath.add(balances[_to], _value);
85             emit Transfer(msg.sender, _to, _value);
86             return true;	 
87         }
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require (_to != 0x0);
92 
93         if (now > voteEndTime) {
94             require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
95             balances[_from] = SafeMath.sub(balances[_from], _value);
96             balances[_to] = SafeMath.add(balances[_to], _value);
97             emit Transfer(_from, _to, _value);
98             return true;	 
99         } else {
100             require(balances[_from] >= SafeMath.add(frozen[_from], _value) && allowed[_from][msg.sender] >= _value);
101             balances[_from] = SafeMath.sub(balances[_from], _value);
102             balances[_to] = SafeMath.add(balances[_to], _value);
103             emit Transfer(_from, _to, _value);
104             return true;	 
105         }
106     }
107 
108     function approve(address _spender, uint256 _value) public returns (bool success) {
109         allowed[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
115         return allowed[_owner][_spender];
116     }
117 
118     function distribute(address _to, uint256 _amount) public returns (bool success) {
119         require(msg.sender == founder);
120         require(SafeMath.add(distributed, _amount) <= _totalSupply);
121 
122         distributed = SafeMath.add(distributed, _amount);
123         balances[_to] = SafeMath.add(balances[_to], _amount);
124         touched[_to] = true;
125         emit Transfer(this, _to, _amount);
126         return true;
127     }
128 	
129     function distributeMultiple(address[] _tos, uint256[] _values) public returns (bool success) {
130         require(msg.sender == founder);
131 		
132         uint256 total = 0;
133         uint256 i = 0; 
134         for (i = 0; i < _tos.length; i++) {
135             total = SafeMath.add(total, _values[i]);
136         }
137 
138         require(SafeMath.add(distributed, total) < _totalSupply);
139 
140         for (i = 0; i < _tos.length; i++) {
141             distributed = SafeMath.add(distributed, _values[i]);
142             balances[_tos[i]] = SafeMath.add(balances[_tos[i]], _values[i]);
143             touched[_tos[i]] = true;
144             emit Transfer(this, _tos[i], _values[i]);
145         }
146 
147         return true;
148     }
149 
150     function vote(address _to, uint256 _value) public returns (bool success) {
151         require(_to != 0x0 && now < voteEndTime);
152         require(balances[msg.sender] >= SafeMath.add(frozen[msg.sender], _value));
153 
154         frozen[msg.sender] = SafeMath.add(frozen[msg.sender], _value);
155         totalVotes[_to] = SafeMath.add(totalVotes[_to], _value);
156         votingInfo[_to][msg.sender] = SafeMath.add(votingInfo[_to][msg.sender], _value);
157         emit Vote(msg.sender, _to, _value);
158         return true;
159     }
160 
161     function voteAll(address _to) public returns (bool success) {
162         require(_to != 0x0 && now < voteEndTime);
163         require(balances[msg.sender] > frozen[msg.sender]);
164         
165         uint256 votesNum = SafeMath.sub(balances[msg.sender], frozen[msg.sender]);
166         frozen[msg.sender] = balances[msg.sender];
167         totalVotes[_to] = SafeMath.add(totalVotes[_to], votesNum);
168         votingInfo[_to][msg.sender] = SafeMath.add(votingInfo[_to][msg.sender], votesNum);
169         emit Vote(msg.sender, _to, votesNum);
170         return true;
171     }
172 	
173     function setEndTime(uint256 _endTime) public {
174         require(msg.sender == founder);
175         voteEndTime = _endTime;
176     }
177 	
178     function ticketsOf(address _owner) view public returns (uint256 tickets) {
179         return SafeMath.sub(balances[_owner], frozen[_owner]);
180     }
181 
182     function changeFounder(address newFounder) public {
183         require(msg.sender == founder);
184 
185         founder = newFounder;
186     }
187 
188     function kill() public {
189         require(msg.sender == founder);
190 
191         selfdestruct(founder);
192     }
193 }