1 pragma solidity ^0.4.18;
2 
3 
4 contract owned {
5     address public owner;
6     address private ownerCandidate;
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         assert(owner == msg.sender);
14         _;
15     }
16 
17     modifier onlyOwnerCandidate() {
18         assert(msg.sender == ownerCandidate);
19         _;
20     }
21 
22     function transferOwnership(address candidate) external onlyOwner {
23         ownerCandidate = candidate;
24     }
25 
26     function acceptOwnership() external onlyOwnerCandidate {
27         owner = ownerCandidate;
28     }
29 }
30 
31 
32 
33 contract SafeMath {
34     function safeMul(uint a, uint b) pure internal returns (uint) {
35         uint c = a * b;
36         assert(a == 0 || c / a == b);
37         return c;
38     }
39 
40     function safeDiv(uint a, uint b) pure internal returns (uint) {
41         uint c = a / b;
42         assert(b == 0);
43         return c;
44     }
45 
46     function safeSub(uint a, uint b) pure internal returns (uint) {
47         assert(b <= a);
48         return a - b;
49     }
50 
51     function safeAdd(uint a, uint b) pure internal returns (uint) {
52         uint c = a + b;
53         assert(c >= a && c >= b);
54         return c;
55     }
56 }
57 
58 
59 
60 
61 
62 
63 
64 contract Token is SafeMath, owned {
65 
66     string public name;    //  token name
67     string public symbol;      //  token symbol
68     uint public decimals = 8;  //  token digit
69 
70     mapping (address => uint) public balanceOf;
71     mapping (address => mapping (address => uint)) public allowance;
72     mapping (address => uint) limitAddress;
73 
74     uint public totalSupply = 1 * 10000 * 10000 * 10 ** uint256(decimals);
75 
76     modifier validAddress(address _address) {
77         assert(0x0 != _address);
78         _;
79     }
80 
81     function addLimitAddress(address _a)
82         public
83         validAddress(_a)
84         onlyOwner
85     {
86         limitAddress[_a] = 1;
87     }
88 
89     function delLitAddress(address _a)
90         public
91         validAddress(_a)
92         onlyOwner
93     {
94         limitAddress[_a] = 0;
95     }
96 
97     function Token(string _name, string _symbol)
98         public
99     {
100         name = _name;
101         symbol = _symbol;
102         owner = msg.sender;
103         balanceOf[this] = totalSupply;
104         Transfer(0x0, this, totalSupply);
105     }
106 
107     function transfer(address _to, uint _value)
108         public
109         validAddress(_to)
110         returns (bool success)
111     {
112         require(balanceOf[msg.sender] >= _value);
113         require(balanceOf[_to] + _value >= balanceOf[_to]);
114         balanceOf[msg.sender] -= _value;
115         balanceOf[_to] += _value;
116         Transfer(msg.sender, _to, _value);
117         return true;
118     }
119 
120     function batchtransfer(address[] _to, uint256[] _amount) public returns(bool success) {
121         for(uint i = 0; i < _to.length; i++){
122             require(transfer(_to[i], _amount[i]));
123         }
124         return true;
125     }
126 
127     function transferInner(address _to, uint _value)
128         private
129         returns (bool success)
130     {
131         balanceOf[this] -= _value;
132         balanceOf[_to] += _value;
133         Transfer(this, _to, _value);
134         return true;
135     }
136 
137     function transferFrom(address _from, address _to, uint _value)
138         public
139         validAddress(_from)
140         validAddress(_to)
141         returns (bool success)
142     {
143         require(balanceOf[_from] >= _value);
144         require(balanceOf[_to] + _value >= balanceOf[_to]);
145         require(allowance[_from][msg.sender] >= _value);
146         balanceOf[_to] += _value;
147         balanceOf[_from] -= _value;
148         allowance[_from][msg.sender] -= _value;
149         Transfer(_from, _to, _value);
150         return true;
151     }
152 
153     function approve(address _spender, uint _value)
154         public
155         validAddress(_spender)
156         returns (bool success)
157     {
158         require(_value == 0 || allowance[msg.sender][_spender] == 0);
159         allowance[msg.sender][_spender] = _value;
160         Approval(msg.sender, _spender, _value);
161         return true;
162     }
163 
164     function ()
165         public
166         payable
167     {
168 
169     }
170 
171     function mint(address _to, uint _amount) public validAddress(_to)
172     {
173         //white address
174         if(limitAddress[msg.sender] != 1) return;
175         // send token 1:10000
176         uint supply = _amount;
177         // overflow
178         if(balanceOf[this] < supply) {
179             supply = balanceOf[this];
180         }
181         require(transferInner(_to, supply));
182         //notify
183         Mint(_to, supply);
184     }
185 
186     function withdraw(uint amount)
187         public
188         onlyOwner
189     {
190         require(this.balance >= amount);
191         msg.sender.transfer(amount);
192     }
193 
194     event Mint(address _to, uint _amount);
195     event Transfer(address indexed _from, address indexed _to, uint _value);
196     event Approval(address indexed _owner, address indexed _spender, uint _value);
197 
198 }