1 pragma solidity ^0.4.20;
2 
3 // File: contracts/ERC20Token.sol
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal  pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal  pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Owned {
30 
31     address public owner;
32     address newOwner;
33 
34     modifier only(address _allowed) {
35         require(msg.sender == _allowed);
36         _;
37     }
38 
39     constructor() public {
40         owner = msg.sender;
41     }
42 
43     function transferOwnership(address _newOwner) only(owner) public {
44         newOwner = _newOwner;
45     }
46 
47     function acceptOwnership() only(newOwner) public {
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54 }
55 
56 contract ERC20 is Owned {
57     using SafeMath for uint;
58 
59     uint public totalSupply;
60     bool public isStarted = false;
61     mapping (address => uint) balances;
62     mapping (address => mapping (address => uint)) allowed;
63 
64     modifier isStartedOnly() {
65         require(isStarted);
66         _;
67     }
68 
69     modifier isNotStartedOnly() {
70         require(!isStarted);
71         _;
72     }
73 
74     event Transfer(address indexed _from, address indexed _to, uint _value);
75     event Approval(address indexed _owner, address indexed _spender, uint _value);
76 
77     function transfer(address _to, uint _value) isStartedOnly public returns (bool success) {
78         require(_to != address(0));
79         balances[msg.sender] = balances[msg.sender].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         emit Transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     function transferFrom(address _from, address _to, uint _value) isStartedOnly public returns (bool success) {
86         require(_to != address(0));
87         balances[_from] = balances[_from].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
90         emit Transfer(_from, _to, _value);
91         return true;
92     }
93 
94     function balanceOf(address _owner) public view returns (uint balance) {
95         return balances[_owner];
96     }
97 
98     function approve_fixed(address _spender, uint _currentValue, uint _value) isStartedOnly public returns (bool success) {
99         if(allowed[msg.sender][_spender] == _currentValue){
100             allowed[msg.sender][_spender] = _value;
101             emit Approval(msg.sender, _spender, _value);
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     function approve(address _spender, uint _value) isStartedOnly public returns (bool success) {
109         allowed[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) public view returns (uint remaining) {
115         return allowed[_owner][_spender];
116     }
117 
118 }
119 
120 contract Token is ERC20 {
121     using SafeMath for uint;
122 
123     string public name;
124     string public symbol;
125     uint8 public decimals;
126 
127     constructor(string _name, string _symbol, uint8 _decimals) public {
128         name = _name;
129         symbol = _symbol;
130         decimals = _decimals;
131     }
132 
133     function start() public only(owner) isNotStartedOnly {
134         isStarted = true;
135     }
136 
137     //================= Crowdsale Only =================
138     function mint(address _to, uint _amount) public only(owner) isNotStartedOnly returns(bool) {
139         totalSupply = totalSupply.add(_amount);
140         balances[_to] = balances[_to].add(_amount);
141         emit Transfer(msg.sender, _to, _amount);
142         return true;
143     }
144 
145     function multimint(address[] dests, uint[] values) public only(owner) isNotStartedOnly returns (uint) {
146         uint i = 0;
147         while (i < dests.length) {
148            mint(dests[i], values[i]);
149            i += 1;
150         }
151         return(i);
152     }
153 }
154 
155 contract TokenWithoutStart is Owned {
156     using SafeMath for uint;
157 
158     mapping (address => uint) balances;
159     mapping (address => mapping (address => uint)) allowed;
160     string public name;
161     string public symbol;
162     uint8 public decimals;
163     uint public totalSupply;
164 
165     event Transfer(address indexed _from, address indexed _to, uint _value);
166     event Approval(address indexed _owner, address indexed _spender, uint _value);
167 
168     constructor(string _name, string _symbol, uint8 _decimals) public {
169         name = _name;
170         symbol = _symbol;
171         decimals = _decimals;
172     }
173 
174     function transfer(address _to, uint _value) public returns (bool success) {
175         require(_to != address(0));
176         balances[msg.sender] = balances[msg.sender].sub(_value);
177         balances[_to] = balances[_to].add(_value);
178         emit Transfer(msg.sender, _to, _value);
179         return true;
180     }
181 
182     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
183         require(_to != address(0));
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         emit Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     function balanceOf(address _owner) public view returns (uint balance) {
192         return balances[_owner];
193     }
194 
195     function approve_fixed(address _spender, uint _currentValue, uint _value) public returns (bool success) {
196         if(allowed[msg.sender][_spender] == _currentValue){
197             allowed[msg.sender][_spender] = _value;
198             emit Approval(msg.sender, _spender, _value);
199             return true;
200         } else {
201             return false;
202         }
203     }
204 
205     function approve(address _spender, uint _value) public returns (bool success) {
206         allowed[msg.sender][_spender] = _value;
207         emit Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     function allowance(address _owner, address _spender) public view returns (uint remaining) {
212         return allowed[_owner][_spender];
213     }
214 
215     function mint(address _to, uint _amount) public only(owner) returns(bool) {
216         totalSupply = totalSupply.add(_amount);
217         balances[_to] = balances[_to].add(_amount);
218         emit Transfer(msg.sender, _to, _amount);
219         return true;
220     }
221 
222     function multimint(address[] dests, uint[] values) public only(owner) returns (uint) {
223         uint i = 0;
224         while (i < dests.length) {
225            mint(dests[i], values[i]);
226            i += 1;
227         }
228         return(i);
229     }
230 
231 }