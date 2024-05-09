1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         // uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return a / b;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract ERC20Basic {
34     function totalSupply() public view returns (uint256);
35     function balanceOf(address who) public view returns (uint256);
36     function transfer(address to, uint256 value) public returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41     function allowance(address owner, address spender) public view returns (uint256);
42     function transferFrom(address from, address to, uint256 value) public returns (bool);
43     function approve(address spender, uint256 value) public returns (bool);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract BasicToken is ERC20Basic {
48     using SafeMath for uint256;
49 
50     mapping(address => uint256) balances;
51 
52     uint256 totalSupply_;
53 
54     function totalSupply() public view returns (uint256) {
55         return totalSupply_;
56     }
57 
58     function transfer(address _to, uint256 _value) public returns (bool) {
59         require(_to != address(0));
60         require(_value <= balances[msg.sender]);
61 
62         balances[msg.sender] = balances[msg.sender].sub(_value);
63         balances[_to] = balances[_to].add(_value);
64         emit Transfer(msg.sender, _to, _value);
65         return true;
66     }
67 
68     function balanceOf(address _owner) public view returns (uint256) {
69         return balances[_owner];
70     }
71 
72 }
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76     mapping (address => mapping (address => uint256)) internal allowed;
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79         require(_to != address(0));
80         require(_value <= balances[_from]);
81         require(_value <= allowed[_from][msg.sender]);
82 
83         balances[_from] = balances[_from].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86         emit Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function approve(address _spender, uint256 _value) public returns (bool) {
91         allowed[msg.sender][_spender] = _value;
92         emit Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function allowance(address _owner, address _spender) public view returns (uint256) {
97         return allowed[_owner][_spender];
98     }
99 
100     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
101         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
102         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
103         return true;
104     }
105 
106     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
107         uint oldValue = allowed[msg.sender][_spender];
108         if (_subtractedValue > oldValue) {
109             allowed[msg.sender][_spender] = 0;
110         } else {
111             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
112         }
113         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114         return true;
115     }
116 
117 }
118 
119 contract Ozinex is StandardToken {
120     // 基本信息
121     string public TOKEN_NAME = "Ozinex";
122     string public SYMBOL = "OZI";
123     uint256 public INITIAL_SUPPLY = 500000000;
124     uint8 public DECIMALS = 8;
125 
126     // 锁定和冻结
127     mapping(address => bool) private lockAccount;
128     mapping(address => uint256) private frozenTimestamp;
129 
130     // 合约所有者
131     address public owner;
132 
133     // 单个消息结构体
134     struct Msg {
135         uint256 timestamp;
136         address sender;
137         string content;
138     }
139 
140     // 记录发送消息
141     Msg[] private msgs;
142 
143     mapping(uint => address) public msgToOwner;
144     mapping(address => uint) ownerMsgCount;
145 
146     // 事件
147     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
148     event Transfer(address indexed _from, address indexed _to, uint256 _value);
149     event SendMsgEvent(address indexed _from, string _content);
150 
151     // 构造函数, 不需要参数
152     constructor() public {
153         totalSupply_ = INITIAL_SUPPLY;
154         balances[msg.sender] = INITIAL_SUPPLY;
155         owner = msg.sender;
156     }
157 
158     // 标准修改器, 仅所有者可调用
159     modifier onlyOwner {
160         require(msg.sender == owner, "onlyOwner method called by non-owner.");
161         _;
162     }
163 
164     function setOwner(address _newOwner) external onlyOwner {
165         owner = _newOwner;
166     }
167 
168     // 锁定帐户
169     function lock(address _target, bool _freeze) external onlyOwner returns (bool) {
170         require(_target != address(0));
171         lockAccount[_target] = _freeze;
172         return true;
173     }
174 
175     // 冻结帐户
176     function freezeByTimestamp(address _target, uint256 _timestamp) external onlyOwner returns (bool) {
177         require(_target != address(0));
178         frozenTimestamp[_target] = _timestamp;
179         return true;
180     }
181 
182     // 查询冻结帐户结束时间
183     function getFrozenTimestamp(address _target) external onlyOwner view returns (uint256) {
184         require(_target != address(0));
185         return frozenTimestamp[_target];
186     }
187 
188     // 转帐
189     function transfer(address _to, uint256 _amount) public returns (bool) {
190         require(_to != address(0));
191         require(lockAccount[msg.sender] != true);
192         require(frozenTimestamp[msg.sender] < now);
193         require(balances[msg.sender] >= _amount);
194 
195         balances[msg.sender] = balances[msg.sender].sub(_amount);
196         balances[_to] = balances[_to].add(_amount);
197 
198         emit Transfer(msg.sender, _to, _amount);
199         return true;
200     }
201 }