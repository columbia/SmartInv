1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function add(uint256 _a, uint256 _b) pure internal returns (uint256) {
5         uint256 c = _a + _b;
6         assert(c >= _a && c >= _b);
7         
8         return c;
9     }
10 
11     function sub(uint256 _a, uint256 _b) pure internal returns (uint256) {
12         assert(_b <= _a);
13 
14         return _a - _b;
15     }
16 
17     function mul(uint256 _a, uint256 _b) pure internal returns (uint256) {
18         uint256 c = _a * _b;
19         assert(_a == 0 || c / _a == _b);
20 
21         return c;
22     }
23 
24     function div(uint256 _a, uint256 _b) pure internal returns (uint256) {
25         assert(_b == 0);
26 
27         return _a / _b;
28     }
29 }
30 
31 interface tokenRecipient {
32     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
33 }
34 
35 contract Token {
36     string public name;
37     string public symbol;
38     uint256 public decimals;
39     uint256 public totalSupply;
40     mapping (address => uint256) public balanceOf;
41     mapping (address => mapping (address => uint256)) public allowance;
42 
43     function transfer(address _to, uint256 _value) public returns (bool _success);
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success);
45     function approve(address _spender, uint256 _value) public returns (bool _success);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 contract TrexCoin is Token {
52     using SafeMath for uint256;
53 
54     address public owner;
55     uint256 public maxSupply;
56     bool public stopped = false;
57 
58     event Burn(address indexed from, uint256 value);
59     event Mint(address indexed to, uint256 value);
60     event Stop();
61     event Start();
62     event Rename(string name, string symbol);
63 
64     modifier isOwner {
65         assert(msg.sender == owner);
66         _;
67     }
68 
69     modifier isRunning {
70         assert(!stopped);
71         _;
72     }
73 
74     modifier isValidAddress {
75         assert(msg.sender != 0x0);
76         _;
77     }
78 
79     modifier hasPayloadSize(uint256 size) {
80         assert(msg.data.length >= size + 4);
81         _;
82     }    
83 
84     function TrexCoin(uint256 _totalSupply, uint256 _maxSupply, string _name, string _symbol, uint8 _decimals) public {
85         owner = msg.sender;
86         decimals = _decimals;
87         maxSupply = _maxSupply;
88         name = _name;
89         symbol = _symbol;
90         _mint(owner, _totalSupply);
91     }
92 
93     function _transfer(address _from, address _to, uint256 _value) private returns (bool _success) {
94         require(_to != 0x0);
95         require(balanceOf[_from] >= _value);
96         require(balanceOf[_to] + _value >= balanceOf[_to]);
97         balanceOf[_from] = balanceOf[_from].sub(_value);
98         balanceOf[_to] = balanceOf[_to].add(_value);
99 
100         emit Transfer(_from, _to, _value);
101 
102         return true;
103     }
104 
105     function transfer(address _to, uint256 _value) public isRunning isValidAddress hasPayloadSize(2 * 32) returns (bool _success) {
106         return _transfer(msg.sender, _to, _value);
107     }
108 
109     function transferFrom(address _from, address _to, uint256 _value) public isRunning isValidAddress hasPayloadSize(3 * 32) returns (bool _success) {
110         require(_value <= allowance[_from][msg.sender]);
111         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
112         
113         return _transfer(_from, _to, _value);
114     }
115 
116     function _approve(address _owner, address _spender, uint256 _value) private returns (bool _success) {
117         allowance[_owner][_spender] = _value;
118 
119         emit Approval(_owner, _spender, _value);
120         
121         return true;
122     }
123 
124     function approve(address _spender, uint256 _value) public isRunning isValidAddress hasPayloadSize(2 * 32) returns (bool _success) {
125         return _approve(msg.sender, _spender, _value);
126     }
127 
128     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public isRunning isValidAddress hasPayloadSize(4 * 32) returns (bool _success) {
129         tokenRecipient spender = tokenRecipient(_spender);
130         if (_approve(msg.sender, _spender, _value)) {
131             spender.receiveApproval(msg.sender, _value, this, _extraData);
132 
133             return true;
134         }
135 
136         return false;
137     }
138 
139     function _burn(address _from, uint256 _value) private returns (bool _success) {
140         require(balanceOf[_from] >= _value);
141         balanceOf[_from] = balanceOf[_from].sub(_value);
142         totalSupply = totalSupply.sub(_value);
143 
144         emit Burn(_from, _value);
145 
146         return true;
147     }
148 
149     function burn(uint256 _value) public isRunning isValidAddress hasPayloadSize(32) returns (bool _success) {
150         return _burn(msg.sender, _value);
151     }
152 
153     function burnFrom(address _from, uint256 _value) public isRunning isValidAddress hasPayloadSize(2 * 32) returns (bool _success) {
154         require(_value <= allowance[_from][msg.sender]);
155         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
156 
157         return _burn(_from, _value);
158     }
159 
160     function _mint(address _to, uint256 _value) private {
161         require(_to != 0x0);
162         require(totalSupply + _value <= maxSupply);
163         if (_value > 0) {
164             totalSupply = totalSupply.add(_value);
165             balanceOf[_to] = balanceOf[_to].add(_value);
166 
167             emit Mint(_to, _value);
168         }
169     }
170 
171     function mint(uint256 _value) public isOwner {
172         _mint(owner, _value);
173     }
174 
175     function mintTo(address _to, uint256 _value) public isOwner {
176         _mint(_to, _value);
177     }
178 
179     function start() public isOwner {
180         stopped = false;
181 
182         emit Start();
183     }
184     
185     function stop() public isOwner {
186         stopped = true;
187 
188         emit Stop();
189     }
190 
191     function rename(string _name, string _symbol) public isOwner {
192         name = _name;
193         symbol = _symbol;
194 
195         emit Rename(_name, _symbol);
196     }
197 }