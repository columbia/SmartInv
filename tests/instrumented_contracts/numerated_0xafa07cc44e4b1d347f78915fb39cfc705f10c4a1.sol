1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal  pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal  pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Owned {
28 
29     address public owner;
30     address newOwner;
31 
32     modifier only(address _allowed) {
33         require(msg.sender == _allowed);
34         _;
35     }
36 
37     function Owned() public {
38         owner = msg.sender;
39     }
40 
41     function transferOwnership(address _newOwner) only(owner) public {
42         newOwner = _newOwner;
43     }
44 
45     function acceptOwnership() only(newOwner) public {
46         emit OwnershipTransferred(owner, newOwner);
47         owner = newOwner;
48     }
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52 }
53 
54 contract ERC20 is Owned {
55     using SafeMath for uint;
56 
57     uint public totalSupply;
58     bool public isStarted = false;
59     mapping (address => uint) balances;
60     mapping (address => mapping (address => uint)) allowed;
61 
62     modifier isStartedOnly() {
63         require(isStarted);
64         _;
65     }
66 
67     modifier isNotStartedOnly() {
68         require(!isStarted);
69         _;
70     }
71 
72     event Transfer(address indexed _from, address indexed _to, uint _value);
73     event Approval(address indexed _owner, address indexed _spender, uint _value);
74 
75     function transfer(address _to, uint _value) isStartedOnly public returns (bool success) {
76         require(_to != address(0));
77         balances[msg.sender] = balances[msg.sender].sub(_value);
78         balances[_to] = balances[_to].add(_value);
79         emit Transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     function transferFrom(address _from, address _to, uint _value) isStartedOnly public returns (bool success) {
84         require(_to != address(0));
85         balances[_from] = balances[_from].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88         emit Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     function balanceOf(address _owner) public view returns (uint balance) {
93         return balances[_owner];
94     }
95 
96     function approve_fixed(address _spender, uint _currentValue, uint _value) isStartedOnly public returns (bool success) {
97         if(allowed[msg.sender][_spender] == _currentValue){
98             allowed[msg.sender][_spender] = _value;
99             emit Approval(msg.sender, _spender, _value);
100             return true;
101         } else {
102             return false;
103         }
104     }
105 
106     function approve(address _spender, uint _value) isStartedOnly public returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         emit Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) public view returns (uint remaining) {
113         return allowed[_owner][_spender];
114     }
115 
116 }
117 
118 contract Token is ERC20 {
119     using SafeMath for uint;
120 
121     string public name;
122     string public symbol;
123     uint8 public decimals;
124 
125     function Token(string _name, string _symbol, uint8 _decimals) public {
126         name = _name;
127         symbol = _symbol;
128         decimals = _decimals;
129     }
130 
131     function start() public only(owner) isNotStartedOnly {
132         isStarted = true;
133     }
134 
135     //================= Crowdsale Only =================
136     function mint(address _to, uint _amount) public only(owner) isNotStartedOnly returns(bool) {
137         totalSupply = totalSupply.add(_amount);
138         balances[_to] = balances[_to].add(_amount);
139         emit Transfer(msg.sender, _to, _amount);
140         return true;
141     }
142 
143     function multimint(address[] dests, uint[] values) public only(owner) isNotStartedOnly returns (uint) {
144         uint i = 0;
145         while (i < dests.length) {
146            mint(dests[i], values[i]);
147            i += 1;
148         }
149         return(i);
150     }
151 }
152 
153 contract TokenWithoutStart is Owned {
154     using SafeMath for uint;
155 
156     mapping (address => uint) balances;
157     mapping (address => mapping (address => uint)) allowed;
158     string public name;
159     string public symbol;
160     uint8 public decimals;
161     uint public totalSupply;
162 
163     event Transfer(address indexed _from, address indexed _to, uint _value);
164     event Approval(address indexed _owner, address indexed _spender, uint _value);
165 
166     function TokenWithoutStart(string _name, string _symbol, uint8 _decimals) public {
167         name = _name;
168         symbol = _symbol;
169         decimals = _decimals;
170     }
171 
172     function transfer(address _to, uint _value) public returns (bool success) {
173         require(_to != address(0));
174         balances[msg.sender] = balances[msg.sender].sub(_value);
175         balances[_to] = balances[_to].add(_value);
176         emit Transfer(msg.sender, _to, _value);
177         return true;
178     }
179 
180     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
181         require(_to != address(0));
182         balances[_from] = balances[_from].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185         emit Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     function balanceOf(address _owner) public view returns (uint balance) {
190         return balances[_owner];
191     }
192 
193     function approve_fixed(address _spender, uint _currentValue, uint _value) public returns (bool success) {
194         if(allowed[msg.sender][_spender] == _currentValue){
195             allowed[msg.sender][_spender] = _value;
196             emit Approval(msg.sender, _spender, _value);
197             return true;
198         } else {
199             return false;
200         }
201     }
202 
203     function approve(address _spender, uint _value) public returns (bool success) {
204         allowed[msg.sender][_spender] = _value;
205         emit Approval(msg.sender, _spender, _value);
206         return true;
207     }
208 
209     function allowance(address _owner, address _spender) public view returns (uint remaining) {
210         return allowed[_owner][_spender];
211     }
212 
213     function mint(address _to, uint _amount) public only(owner) returns(bool) {
214         totalSupply = totalSupply.add(_amount);
215         balances[_to] = balances[_to].add(_amount);
216         emit Transfer(msg.sender, _to, _amount);
217         return true;
218     }
219 
220     function multimint(address[] dests, uint[] values) public only(owner) returns (uint) {
221         uint i = 0;
222         while (i < dests.length) {
223            mint(dests[i], values[i]);
224            i += 1;
225         }
226         return(i);
227     }
228 
229 }
230 
231 
232 
233 //This contract is used to distribute tokens reserved for Jury.Online team the terms of distirbution are following:
234 //after the end of ICO tokens are frozen for 6 months and afterwards each months 10% of tokens is unfrozen
235 
236 contract Vesting {
237 
238     //1. Alexander Shevtsov            0x4C67EB86d70354731f11981aeE91d969e3823c39
239     //2. Anastasia Bormotova           0x450Eb50Cc83B155cdeA8b6d47Be77970Cf524368
240     //3. Artemiy Pirozhkov             0x9CFf3408a1eB46FE1F9de91f932FDCfEC34A568f
241     //4. Konstantin Kudryavtsev        0xA14d9fa5B1b46206026eA51A98CeEd182A91a190
242     //5. Marina Kobyakova              0x0465f2fA674bF20Fe9484dB70D8570617495b352
243     //6. Nikita Alekseev               0x07F8a6Fb0Ad63abBe21e8ef33523D8368618cd10
244     //7. Nikolay Prudnikov             0xF29fE8e258b084d40D9cF1dCF02E5CB29837b6D5
245     //8. Valeriy Strechen              0x64B557EaED227B841DcEd9f70918cd8f5ca2Bdab
246     //9. Igor Lavrenov                 0x05d1e624eaDF70bb7F8A2B11D39A8a5635e5D007
247     
248     uint public constant interval = 30 days;
249     uint public constant distributionStart = 1540994400; //1st of November
250     uint public currentStage;
251     uint public stageAmount;
252     uint public toSendLeft;
253 
254     address[] public team;
255     Token public token;
256 
257     constructor(address[] _team, address _token) {
258         token = Token(_token);
259         for(uint i=0; i<_team.length; i++) {
260             team.push(_team[i]);
261         }
262     }
263 
264     function makePayouts() {
265         require(toSendLeft != 0);
266         if (now > interval*currentStage + distributionStart) {
267 			uint balance = stageAmount/team.length;
268             for(uint i=0; i<team.length; i++) {
269                 toSendLeft -= balance;
270                 require(token.transfer(team[i], balance));
271             }
272         currentStage+=1;
273         }
274     }
275 
276     function setToSendLeft() {
277         require(toSendLeft == 0);
278         toSendLeft = token.balanceOf(address(this));
279         stageAmount = toSendLeft/10;
280     }
281 
282 
283 
284 }