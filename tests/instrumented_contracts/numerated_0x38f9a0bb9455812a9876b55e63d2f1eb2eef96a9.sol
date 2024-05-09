1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     
5 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6 
7     if (_a == 0) {
8     return 0;
9 }
10 
11 
12     uint256 c = _a * _b;
13     require(c / _a == _b);
14     return c;
15 }
16 
17 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
18     require(_b > 0);
19     uint256 c = _a / _b;
20     return c;
21 
22 }
23 
24 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
25 
26     require(_b <= _a);
27     return _a - _b;
28 }
29 
30 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
31 
32     uint256 c = _a + _b;
33     require(c >= _a);
34     return c;
35 
36 }
37 
38 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39     require(b != 0);
40     return a % b;
41     }
42 }
43 
44 contract Ownable {
45 address public owner;
46 address public newOwner;
47 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 constructor() public {
50     owner = msg.sender;
51     newOwner = address(0);
52 }
53 
54 modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57 }
58 
59 modifier onlyNewOwner() {
60     require(msg.sender != address(0));
61     require(msg.sender == newOwner);
62     _;
63 }
64 
65 function transferOwnership(address _newOwner) public onlyOwner {
66     require(_newOwner != address(0));
67     newOwner = _newOwner;
68 }
69 
70 function acceptOwnership() public onlyNewOwner {
71     emit OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73     }
74 }
75 
76 contract ERC20 {
77 
78     function totalSupply() public view returns (uint256);
79     function balanceOf(address who) public view returns (uint256);
80     function allowance(address owner, address spender) public view returns (uint256);
81     function transfer(address to, uint256 value) public returns (bool);
82     function transferFrom(address from, address to, uint256 value) public returns (bool);
83     function approve(address spender, uint256 value) public returns (bool);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 interface TokenRecipient {
89     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
90 }
91 
92 contract PicaArtMoney is ERC20, Ownable {
93     
94     using SafeMath for uint256;
95 
96     string public name;
97     string public symbol;
98     uint8 public decimals;
99     uint256 internal initialSupply;
100     uint256 internal totalSupply_;
101     mapping(address => uint256) internal balances;
102     mapping(address => mapping(address => uint256)) internal allowed;
103     event Burn(address indexed owner, uint256 value);
104 
105 constructor() public {
106     name = "PicaArtMoney";
107     symbol = "PICA";
108     decimals = 18;
109     initialSupply = 903679668;
110     totalSupply_ = initialSupply * 10 ** uint(decimals);
111     balances[owner] = totalSupply_;
112     emit Transfer(address(0), owner, totalSupply_);
113 }
114 
115 function () public payable {
116     revert();
117 }
118    
119 function totalSupply() public view returns (uint256) {
120     return totalSupply_;
121 }
122 
123 function _transfer(address _from, address _to, uint _value) internal {
124 
125     require(_to != address(0));
126     require(_value <= balances[_from]);
127     require(_value <= allowed[_from][msg.sender]);
128     balances[_from] = balances[_from].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131     emit Transfer(_from, _to, _value);
132 }
133  
134 function transfer(address _to, uint256 _value) public returns (bool) {
135 
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138     balances[msg.sender] = balances[msg.sender].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     emit Transfer(msg.sender, _to, _value);
141     
142     return true;
143 }
144 
145 function balanceOf(address _holder) public view returns (uint256 balance) {
146     return balances[_holder];
147 }
148      
149 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150 
151     require(_to != address(0));
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154     _transfer(_from, _to, _value);
155     
156     return true;
157 }
158 
159 function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     emit Approval(msg.sender, _spender, _value);
162     
163     return true;
164 }
165 
166 function allowance(address _holder, address _spender) public view returns (uint256) {
167     return allowed[_holder][_spender];
168 
169 }
170 
171 function burn(uint256 _value) public onlyOwner returns (bool) {
172     
173     require(_value <= balances[msg.sender]);
174     address burner = msg.sender;
175     balances[burner] = balances[burner].sub(_value);
176     totalSupply_ = totalSupply_.sub(_value);
177     emit Burn(burner, _value);
178 
179     return true;
180 }
181 
182 function isContract(address addr) internal view returns (bool) {
183     
184     uint size;
185     assembly{size := extcodesize(addr)}
186     
187     return size > 0;
188     }
189 }