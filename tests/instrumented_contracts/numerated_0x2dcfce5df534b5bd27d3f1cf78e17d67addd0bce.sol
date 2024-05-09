1 pragma solidity ^0.4.24;
2 
3 // 防止整数溢出
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert((c >= a) && (c >= b));
24         return c;
25     }
26 }
27 
28 /*  标准 token */
29 contract StandardToken {
30     using SafeMath for uint256;
31 
32     string public name; // 代币名称
33     string public symbol; // 代币缩写
34     uint8 public decimals; // 小数位
35     uint256 public totalSupply; // 发行量
36     string public version; // 版本
37 
38     /* 合约行为 */
39 
40     // 发起方(调用者)转账 _value 到 address _to
41     function transfer(address _to, uint256 _value)  returns (bool success);
42 
43     // 从 _from 账户转出 _value 数量的代币到 _to 账户
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) ;
45 
46     // 交易发起方把 _value 数量的代币使用权交给 _spender, 由 _spender 调用 transferFrom 将币转给另一个账户
47     function approve(address _spender, uint256 _value) returns (bool success);
48 
49     // 查询 _spender 目前还有多少 _owner 账户代币使用权
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining) ;
51 
52     // 转账成功事件
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     // 使用权委托成功事件
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56 }
57 
58 contract Owned {
59      modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64    address public owner;
65 
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     address newOwner=0x0;
71 
72     event OwnerUpdate(address _prevOwner, address _newOwner);
73 
74     function changeOwner(address _newOwner) public onlyOwner {
75         require(_newOwner != owner);
76         newOwner = _newOwner;
77     }
78 
79     function acceptOwnership() public{
80         require(msg.sender == newOwner);
81         emit OwnerUpdate(owner, newOwner);
82         owner = newOwner;
83         newOwner = 0x0;
84     }
85 }
86 
87 contract Controlled is Owned {
88     constructor() public {
89         setExclude(msg.sender,true);
90     }
91 
92     bool public transferEnabled = true;
93 
94     bool lockFlag=true;
95 
96     mapping(address => bool) locked;
97 
98     mapping(address => bool) exclude;
99 
100     function enableTransfer(bool _enable) public onlyOwner returns (bool success){
101         transferEnabled=_enable;
102 		return true;
103     }
104 
105     function disableLock(bool _enable) public onlyOwner returns (bool success){
106         lockFlag=_enable;
107         return true;
108     }
109 
110     function addLock(address _addr) public onlyOwner returns (bool success){
111         require(lockFlag == true);
112         require(_addr != msg.sender);
113         locked[_addr]=true;
114         return true;
115     }
116 
117     function setExclude(address _addr,bool _enable) public onlyOwner returns (bool success){
118         exclude[_addr]=_enable;
119         return true;
120     }
121 
122     function removeLock(address _addr) public onlyOwner returns (bool success){
123         locked[_addr]=false;
124         return true;
125     }
126 
127     modifier transferAllowed(address _addr) {
128         if (!exclude[_addr]) {
129             require(transferEnabled,"transfer is not enabeled now!");
130             if(lockFlag){
131                 require(!locked[_addr],"you are locked!");
132             }
133         }
134         _;
135     }
136 }
137 
138 contract DmToken is StandardToken,Controlled {
139 	mapping (address => uint256) public balanceOf;
140 	mapping (address => mapping (address => uint256)) internal allowed;
141 
142     constructor() public {
143         totalSupply = 96000000 * 1000000;
144         name = "Xystus";
145         symbol = "xys";
146         decimals = 6;
147         version = "1.0";
148         balanceOf[msg.sender] = totalSupply;
149     }
150 
151     function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool success) {
152 		require(_to != address(0));
153 		require(_value <= balanceOf[msg.sender]);
154 
155         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
156         balanceOf[_to] = balanceOf[_to].add(_value);
157         emit Transfer(msg.sender, _to, _value);
158         return true;
159     }
160 
161     function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(_from) returns (bool success) {
162         require(_to != address(0));
163         require(_value <= balanceOf[_from]);
164         require(_value <= allowed[_from][msg.sender]);
165 
166         balanceOf[_from] = balanceOf[_from].sub(_value);
167         balanceOf[_to] = balanceOf[_to].add(_value);
168         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169         emit Transfer(_from, _to, _value);
170         return true;
171     }
172 
173     function approve(address _spender, uint256 _value) public returns (bool success) {
174         allowed[msg.sender][_spender] = _value;
175         emit Approval(msg.sender, _spender, _value);
176         return true;
177     }
178 
179     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
180         return allowed[_owner][_spender];
181     }
182 }