1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function mul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint a, uint b) internal returns (uint) {
11         assert(b > 0);
12         uint c = a / b;
13         assert(a == b * c + a % b);
14         return c;
15     }
16 
17     function sub(uint a, uint b) internal returns (uint) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint a, uint b) internal returns (uint) {
23         uint c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29         return a >= b ? a : b;
30     }
31 
32     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33         return a < b ? a : b;
34     }
35 
36     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37         return a >= b ? a : b;
38     }
39 
40     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41         return a < b ? a : b;
42     }
43 
44     function assert(bool assertion) internal {
45         if (!assertion) {
46             throw;
47         }
48     }
49 }
50 
51 contract ownable {
52 
53     address public owner;
54 
55     modifier onlyOwner {
56         if (!isOwner(msg.sender)) throw;
57         _;
58     }
59 
60     function ownable() {
61         owner = msg.sender;
62     }
63 
64     function transferOwnership(address _newOwner) onlyOwner {
65         owner = _newOwner;
66     }
67 
68     function isOwner(address _address) returns (bool) {
69         return owner == _address;
70     }
71 }
72 
73 
74 contract Burnable {
75 
76     event Burn(address indexed owner, uint amount);
77     function burn(address _owner, uint _amount) public;
78 
79 }
80 
81 
82 contract ERC20 {
83     uint public totalSupply;
84     
85     function totalSupply() constant returns (uint);
86     function balanceOf(address _owner) constant returns (uint);
87     function allowance(address _owner, address _spender) constant returns (uint);
88     function transfer(address _to, uint _value) returns (bool);
89     function transferFrom(address _from, address _to, uint _value) returns (bool);
90     function approve(address _spender, uint _value) returns (bool);
91     
92     event Approval(address indexed owner, address indexed spender, uint value);
93     event Transfer(address indexed from, address indexed to, uint value);
94 }
95 
96 
97 contract Mintable {
98 
99     event Mint(address indexed to, uint value);
100     function mint(address _to, uint _amount) public;
101 }
102 
103 contract Token is ERC20, Mintable, Burnable, ownable {
104     using SafeMath for uint;
105 
106     string public name;
107     string public symbol;
108 
109     uint public decimals = 18;
110     uint public maxSupply;
111     uint public totalSupply;
112     uint public freezeMintUntil;
113 
114     mapping (address => mapping (address => uint)) allowed;
115     mapping (address => uint) balances;
116 
117     modifier canMint {
118         require(totalSupply < maxSupply);
119         _;
120     }
121 
122     modifier mintIsNotFrozen {
123         require(freezeMintUntil < now);
124         _;
125     }
126 
127     function Token(string _name, string _symbol, uint _maxSupply) {
128         name = _name;
129         symbol = _symbol;
130         maxSupply = _maxSupply;
131         totalSupply = 0;
132         freezeMintUntil = 0;
133     }
134 
135     function totalSupply() constant returns (uint) {
136         return totalSupply;
137     }
138 
139     function balanceOf(address _owner) constant returns (uint) {
140         return balances[_owner];
141     }
142 
143     function allowance(address _owner, address _spender) constant returns (uint) {
144         return allowed[_owner][_spender];
145     }
146 
147     function transfer(address _to, uint _value) returns (bool) {
148         if (_value <= 0) {
149             return false;
150         }
151 
152         balances[msg.sender] = balances[msg.sender].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154 
155         Transfer(msg.sender, _to, _value);
156         return true;
157     }
158 
159     function transferFrom(address _from, address _to, uint _value) returns (bool) {
160         if (_value <= 0) {
161             return false;
162         }
163 
164         balances[_from] = balances[_from].sub(_value);
165         balances[_to] = balances[_to].add(_value);
166 
167         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168         Transfer(_from, _to, _value);
169         return true;
170     }
171 
172     function approve(address _spender, uint _value) returns (bool) {
173         allowed[msg.sender][_spender] = _value;
174         Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     function mint(address _to, uint _amount) public canMint mintIsNotFrozen onlyOwner {
179         if (maxSupply < totalSupply.add(_amount)) throw;
180 
181         totalSupply = totalSupply.add(_amount);
182         balances[_to] = balances[_to].add(_amount);
183 
184         Mint(_to, _amount);
185     }
186 
187     function burn(address _owner, uint _amount) public onlyOwner {
188         totalSupply = totalSupply.sub(_amount);
189         balances[_owner] = balances[_owner].sub(_amount);
190 
191         Burn(_owner, _amount);
192     }
193 
194     function freezeMintingFor(uint _weeks) public onlyOwner {
195         freezeMintUntil = now + _weeks * 1 weeks;
196     }
197 }