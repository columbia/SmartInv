1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     
5 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6     if (_a == 0) {
7         return 0;
8     }
9     
10     uint256 c = _a * _b;
11     require(c / _a == _b);
12     return c;
13 }
14 
15 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
16     require(_b > 0);
17     uint256 c = _a / _b;
18     return c;
19 }
20 
21 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
22     require(_b <= _a);
23     return _a - _b;
24 }
25 
26 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
27     uint256 c = _a + _b;
28     require(c >= _a);
29     return c;
30 }
31 
32 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33     require(b != 0);
34     return a % b;
35     
36     }
37 }
38 
39 contract Ownable {
40     address public owner;
41     address public newOwner;
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43     
44 constructor() public {
45     owner = msg.sender;
46     newOwner = address(0);
47 }
48 
49 modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52 }
53 
54 modifier onlyNewOwner() {
55     require(msg.sender != address(0));
56     require(msg.sender == newOwner);
57     _;
58 }
59 
60 function transferOwnership(address _newOwner) public onlyOwner {
61     require(_newOwner != address(0));
62     newOwner = _newOwner;
63 }
64 
65 function acceptOwnership() public onlyNewOwner {
66     emit OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68 }
69 }
70 
71 contract ERC20 {
72     function totalSupply() public view returns (uint256);
73     function balanceOf(address who) public view returns (uint256);
74     function allowance(address owner, address spender) public view returns (uint256);
75     function transfer(address to, uint256 value) public returns (bool);
76     function transferFrom(address from, address to, uint256 value) public returns (bool);
77     function approve(address spender, uint256 value) public returns (bool);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 interface TokenRecipient {
83 
84 function receiveApproval(address _from, uint256 _value, address _token, bytes calldata) external;
85 
86 }
87 
88 contract XIDO is ERC20, Ownable {
89     
90     using SafeMath for uint256;
91     
92     string public name;
93     string public symbol;
94     uint8 public decimals;
95     uint256 internal initialSupply;
96     uint256 internal totalSupply_;
97     mapping(address => uint256) internal balances;
98     mapping(address => bool) public frozen;
99     mapping(address => mapping(address => uint256)) internal allowed;
100     
101     event Burn(address indexed owner, uint256 value);
102     event Freeze(address indexed holder);
103     event Unfreeze(address indexed holder);
104     
105     modifier notFrozen(address _holder) {
106         require(!frozen[_holder]);
107         _;
108     }
109     
110 constructor() public {
111     name = "XIDO FINANCE";
112     symbol = "XIDO";
113     decimals = 18;
114     initialSupply = 100000000;
115     totalSupply_ = initialSupply * 10 ** uint(decimals);
116     balances[owner] = totalSupply_;
117     emit Transfer(address(0), owner, totalSupply_);
118 }
119 
120 function() external payable {
121     revert();
122 }
123 
124 function totalSupply() public view returns (uint256) {
125     return totalSupply_;
126 }
127 
128 function _transfer(address _from, address _to, uint _value) internal {
129     require(_to != address(0));
130     require(_value <= balances[_from]);
131     require(_value <= allowed[_from][msg.sender]);
132     balances[_from] = balances[_from].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135     emit Transfer(_from, _to, _value);
136 }
137 
138 function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[msg.sender]);
141     balances[msg.sender] = balances[msg.sender].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     emit Transfer(msg.sender, _to, _value);
144     return true;
145 }
146 
147 function balanceOf(address _holder) public view returns (uint256 balance) {
148     return balances[_holder];
149 }
150 
151 function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[_from]);
154     require(_value <= allowed[_from][msg.sender]);
155     _transfer(_from, _to, _value);
156     return true;
157 }
158 
159 function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     emit Approval(msg.sender, _spender, _value);
162     return true;
163 }
164 
165 function allowance(address _holder, address _spender) public view returns (uint256) {
166     return allowed[_holder][_spender];
167 }
168 
169 function freezeAccount(address _holder) public onlyOwner returns (bool) {
170     require(!frozen[_holder]);
171     frozen[_holder] = true;
172     emit Freeze(_holder);
173     return true;
174 }
175 
176 function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
177     require(frozen[_holder]);
178     frozen[_holder] = false;
179     emit Unfreeze(_holder);
180     return true;
181 }
182 
183 function burn(uint256 _value) public onlyOwner returns (bool) {
184     require(_value <= balances[msg.sender]);
185     address burner = msg.sender;
186     balances[burner] = balances[burner].sub(_value);
187     totalSupply_ = totalSupply_.sub(_value);
188     emit Burn(burner, _value);
189     
190     return true;
191 }
192 
193 function isContract(address addr) internal view returns (bool) {
194     uint size;
195     assembly{size := extcodesize(addr)}
196     return size > 0;
197 }
198 }