1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 }
28 
29 contract Token {
30 
31     uint256 public totalSupply;
32 
33     function balanceOf(address _owner) constant public returns (uint256 balance);
34 
35     function transfer(address _to, uint256 _value) public returns (bool success);
36 
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
38 
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 
41     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 contract Auth {
48     address public owner = 0x00;
49     mapping (address => bool) public founders;
50     struct ProposeOwner {
51         address owner;
52         bool active;
53     }
54     ProposeOwner[] public proposes;
55 
56     function Auth () {
57         founders[0x18177d9743c1dfd9f4b9922986b3d7dbdc6683a6] = true;
58         founders[0x94fc42a2f94f998dfb07e077c8610f7b72977ce3] = true;
59     }
60 
61     function proposeChangeOwner (address _address) public isFounder {
62         proposes.push(ProposeOwner({
63             owner: _address,
64             active: true
65         }));
66     }
67 
68     function approveChangeOwner (uint _index) public isFounder {
69         assert(proposes[_index].owner != msg.sender);
70         assert(proposes[_index].active);
71 
72         proposes[_index].active = false;
73         owner = proposes[_index].owner;
74     }
75 
76     modifier auth {
77         assert(msg.sender == owner);
78         _;
79     }
80 
81     modifier isFounder() {
82         assert(founders[msg.sender]);
83         _;
84     }
85 }
86 
87 contract Stop is Auth {
88 
89     bool public stopped = false;
90 
91     modifier stoppable {
92         assert (!stopped);
93         _;
94     }
95 
96     function stop() auth {
97         stopped = true;
98     }
99 
100     function start() auth {
101         stopped = false;
102     }
103 
104 }
105 
106 contract StandardToken is Token, Stop {
107 
108     mapping (address => uint256) public balanceOf;
109     mapping (address => mapping (address => uint256)) allowed;
110 
111     function transfer(address _to, uint256 _value) public stoppable returns (bool success) {
112         require(_to != address(0));
113         require(_value <= balanceOf[msg.sender]);
114         require(balanceOf[_to] + _value > balanceOf[_to]);
115         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
116         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
117         Transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     function transferFrom(address _from, address _to, uint256 _value) public stoppable returns (bool success) {
122         require(_to != address(0));
123         require(_value <= balanceOf[_from]);
124         require(_value <= allowed[_from][msg.sender]);
125         require(balanceOf[_to] + _value > balanceOf[_to]);
126         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
127         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
128         allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);
129         Transfer(_from, _to, _value);
130         return true;
131     }
132 
133     function balanceOf(address _owner) constant public returns (uint256 balance) {
134         return balanceOf[_owner];
135     }
136 
137     function approve(address _spender, uint256 _value) public stoppable returns (bool success) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
144         return allowed[_owner][_spender];
145     }
146 }
147 
148 contract BSE is StandardToken {
149 
150     function () public {
151         revert();
152     }
153 
154     string public name = "BiSale";
155     uint8 public decimals = 18;
156     string public symbol = "BSE";
157     string public version = 'v0.1';
158     uint256 public totalSupply = 0;
159 
160     function BSE () {
161         owner = msg.sender;
162         totalSupply = 10000000000 * 10 ** uint256(decimals);
163         balanceOf[msg.sender] = totalSupply;
164     }
165 
166     function mint(address _target, uint256 _value) auth stoppable {
167         require(_target != address(0));
168         require(_value > 0);
169         balanceOf[_target] = SafeMath.safeAdd(balanceOf[_target], _value);
170         totalSupply = SafeMath.safeAdd(totalSupply, _value);
171     }
172 
173     function burn(uint256 _value) auth stoppable {
174         require(_value > 0);
175         require(balanceOf[msg.sender] >= _value);
176 
177         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
178         totalSupply = SafeMath.safeSub(totalSupply, _value);
179     }
180 }