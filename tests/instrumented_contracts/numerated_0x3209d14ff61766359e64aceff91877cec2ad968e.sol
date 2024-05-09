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
11     uint256 c = _a * _b;
12     require(c / _a == _b);
13     return c;
14 }
15 
16 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
17     require(_b > 0);
18     uint256 c = _a / _b;
19     return c;
20 
21 }
22 
23 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
24 
25     require(_b <= _a);
26     return _a - _b;
27 }
28 
29 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
30 
31     uint256 c = _a + _b;
32     require(c >= _a);
33     return c;
34 
35 }
36 
37 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b != 0);
39     return a % b;
40     }
41 }
42 
43 contract Ownable {
44 address public owner;
45 address public newOwner;
46 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
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
72     }
73 }
74 
75 contract ERC20 {
76 
77     function totalSupply() public view returns (uint256);
78     function balanceOf(address who) public view returns (uint256);
79     function allowance(address owner, address spender) public view returns (uint256);
80     function transfer(address to, uint256 value) public returns (bool);
81     function transferFrom(address from, address to, uint256 value) public returns (bool);
82     function approve(address spender, uint256 value) public returns (bool);
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 interface TokenRecipient {
88     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
89 }
90 
91 contract CouponBay is ERC20, Ownable {
92     
93     using SafeMath for uint256;
94 
95     string public name;
96     string public symbol;
97     uint8 public decimals;
98     uint256 internal initialSupply;
99     uint256 internal totalSupply_;
100     mapping(address => uint256) internal balances;
101     mapping(address => bool) public frozen;
102     mapping(address => mapping(address => uint256)) internal allowed;
103 
104     event Burn(address indexed owner, uint256 value);
105     event Freeze(address indexed holder);
106     event Unfreeze(address indexed holder);
107 
108     modifier notFrozen(address _holder) {
109     require(!frozen[_holder]);
110     _;
111 }
112 
113 constructor() public {
114     name = "CouponBay";
115     symbol = "CUP";
116     decimals = 18;
117     initialSupply = 1000000000;
118     totalSupply_ = initialSupply * 10 ** uint(decimals);
119     balances[owner] = totalSupply_;
120     emit Transfer(address(0), owner, totalSupply_);
121 }
122 
123 function () public payable {
124     revert();
125 }
126    
127 function totalSupply() public view returns (uint256) {
128     return totalSupply_;
129 }
130 
131 function _transfer(address _from, address _to, uint _value) internal {
132 
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
143 
144     require(_to != address(0));
145     require(_value <= balances[msg.sender]);
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     emit Transfer(msg.sender, _to, _value);
149     
150     return true;
151 }
152 
153 function balanceOf(address _holder) public view returns (uint256 balance) {
154     return balances[_holder];
155 }
156      
157 function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
158 
159     require(_to != address(0));
160     require(_value <= balances[_from]);
161     require(_value <= allowed[_from][msg.sender]);
162     _transfer(_from, _to, _value);
163     
164     return true;
165 }
166 
167 function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     emit Approval(msg.sender, _spender, _value);
170     
171     return true;
172 }
173 
174 function allowance(address _holder, address _spender) public view returns (uint256) {
175     return allowed[_holder][_spender];
176 
177 }
178 
179 function freezeAccount(address _holder) public onlyOwner returns (bool) {
180 
181     require(!frozen[_holder]);
182     frozen[_holder] = true;
183     emit Freeze(_holder);
184     
185     return true;
186 }
187 
188 function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
189 
190     require(frozen[_holder]);
191     frozen[_holder] = false;
192     emit Unfreeze(_holder);
193     
194     return true;
195 }
196 
197 function burn(uint256 _value) public onlyOwner returns (bool) {
198     
199     require(_value <= balances[msg.sender]);
200     address burner = msg.sender;
201     balances[burner] = balances[burner].sub(_value);
202     totalSupply_ = totalSupply_.sub(_value);
203     emit Burn(burner, _value);
204 
205     return true;
206 }
207 
208 function isContract(address addr) internal view returns (bool) {
209     
210     uint size;
211     assembly{size := extcodesize(addr)}
212     
213     return size > 0;
214     }
215 }