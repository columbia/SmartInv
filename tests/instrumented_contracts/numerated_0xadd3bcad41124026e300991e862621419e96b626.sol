1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-09
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 library SafeMath {
8     
9 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
10     if (_a == 0) {
11         return 0;
12     }
13     
14     uint256 c = _a * _b;
15     require(c / _a == _b);
16     return c;
17 }
18 
19 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
20     require(_b > 0);
21     uint256 c = _a / _b;
22     return c;
23 }
24 
25 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
26     require(_b <= _a);
27     return _a - _b;
28 }
29 
30 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     uint256 c = _a + _b;
32     require(c >= _a);
33     return c;
34 }
35 
36 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b != 0);
38     return a % b;
39     
40     }
41 }
42 
43 contract Ownable {
44     address public owner;
45     address public newOwner;
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47     
48 constructor() public {
49     owner = msg.sender;
50     newOwner = address(0);
51 }
52 
53 modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56 }
57 
58 modifier onlyNewOwner() {
59     require(msg.sender != address(0));
60     require(msg.sender == newOwner);
61     _;
62 }
63 
64 function transferOwnership(address _newOwner) public onlyOwner {
65     require(_newOwner != address(0));
66     newOwner = _newOwner;
67 }
68 
69 function acceptOwnership() public onlyNewOwner {
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72 }
73 }
74 
75 contract ERC20 {
76     function totalSupply() public view returns (uint256);
77     function balanceOf(address who) public view returns (uint256);
78     function allowance(address owner, address spender) public view returns (uint256);
79     function transfer(address to, uint256 value) public returns (bool);
80     function transferFrom(address from, address to, uint256 value) public returns (bool);
81     function approve(address spender, uint256 value) public returns (bool);
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 interface TokenRecipient {
87 
88 function receiveApproval(address _from, uint256 _value, address _token, bytes calldata) external;
89 
90 }
91 
92 contract QVING is ERC20, Ownable {
93     
94     using SafeMath for uint256;
95     
96     string public name;
97     string public symbol;
98     uint8 public decimals;
99     uint256 internal initialSupply;
100     uint256 internal totalSupply_;
101     mapping(address => uint256) internal balances;
102     mapping(address => bool) public frozen;
103     mapping(address => mapping(address => uint256)) internal allowed;
104     
105     event Burn(address indexed owner, uint256 value);
106     event Freeze(address indexed holder);
107     event Unfreeze(address indexed holder);
108     
109     modifier notFrozen(address _holder) {
110         require(!frozen[_holder]);
111         _;
112     }
113     
114 constructor() public {
115     name = "Qving";
116     symbol = "QVI";
117     decimals = 18;
118     initialSupply = 500000000;
119     totalSupply_ = initialSupply * 10 ** uint(decimals);
120     balances[owner] = totalSupply_;
121     emit Transfer(address(0), owner, totalSupply_);
122 }
123 
124 function() external payable {
125     revert();
126 }
127 
128 function totalSupply() public view returns (uint256) {
129     return totalSupply_;
130 }
131 
132 function _transfer(address _from, address _to, uint _value) internal {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136     balances[_from] = balances[_from].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139     emit Transfer(_from, _to, _value);
140 }
141 
142 function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     emit Transfer(msg.sender, _to, _value);
148     return true;
149 }
150 
151 function balanceOf(address _holder) public view returns (uint256 balance) {
152     return balances[_holder];
153 }
154 
155 function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159     _transfer(_from, _to, _value);
160     return true;
161 }
162 
163 function approve(address _spender, uint256 _value) public returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     emit Approval(msg.sender, _spender, _value);
166     return true;
167 }
168 
169 function allowance(address _holder, address _spender) public view returns (uint256) {
170     return allowed[_holder][_spender];
171 }
172 
173 function freezeAccount(address _holder) public onlyOwner returns (bool) {
174     require(!frozen[_holder]);
175     frozen[_holder] = true;
176     emit Freeze(_holder);
177     return true;
178 }
179 
180 function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
181     require(frozen[_holder]);
182     frozen[_holder] = false;
183     emit Unfreeze(_holder);
184     return true;
185 }
186 
187 function burn(uint256 _value) public onlyOwner returns (bool) {
188     require(_value <= balances[msg.sender]);
189     address burner = msg.sender;
190     balances[burner] = balances[burner].sub(_value);
191     totalSupply_ = totalSupply_.sub(_value);
192     emit Burn(burner, _value);
193     
194     return true;
195 }
196 
197 function isContract(address addr) internal view returns (bool) {
198     uint size;
199     assembly{size := extcodesize(addr)}
200     return size > 0;
201 }
202 }