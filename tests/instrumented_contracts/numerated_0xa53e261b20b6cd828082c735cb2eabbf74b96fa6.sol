1 pragma solidity ^0.4.24;
2 interface Interfacemc {
3   
4   function balanceOf(address who) external view returns (uint256);
5   
6   function allowance(address owner, address spender)
7     external view returns (uint256);
8 
9   function transfer(address to, uint256 value) external returns (bool);
10   
11   function approve(address spender, uint256 value)
12     external returns (bool);
13 
14   function transferFrom(address from, address to, uint256 value)
15     external returns (bool);
16   
17   event Transfer(
18     address indexed from,
19     address indexed to,
20     uint256 value
21   );
22   
23   event Approval(
24     address indexed owner,
25     address indexed spender,
26     uint256 value
27   );
28   
29 }
30 
31 library SafeMath {
32 
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         if (a == 0) {
35             return 0;
36         }
37         uint256 c = a * b;
38         require(c / a == b);
39         return c;
40     }
41 
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b > 0);
44         uint256 c = a / b;
45         return c;
46     }
47 
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         require(b <= a);
51         uint256 c = a - b;
52 
53         return c;
54     }
55 
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a);
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 
69 contract Mundicoin is Interfacemc{
70     using SafeMath for uint256;
71     uint256 constant private MAX_UINT256 = 2**256 - 1;
72     mapping (address => uint256) private _balances;
73     mapping (address => mapping (address => uint256)) private _allowed;
74     uint256 public totalSupply;
75     string public name = "Mundicoin"; 
76     uint8 public decimals = 8; 
77     string public symbol = "MC";
78     address private _owner;
79     
80     mapping (address => bool) public _notransferible;
81     mapping (address => bool) private _administradores; 
82     
83     constructor() public{
84         _owner = msg.sender;
85         totalSupply = 10000000000000000;
86         _balances[_owner] = totalSupply;
87         _administradores[_owner] = true;
88     }
89 
90     function isAdmin(address dir) public view returns(bool){
91         return _administradores[dir];
92     }
93     
94     modifier OnlyOwner(){
95         require(msg.sender == _owner, "Not an admin");
96         _;
97     }
98 
99     function balanceOf(address owner) public view returns (uint256) {
100         return _balances[owner];
101     }
102     
103     function allowance(
104         address owner,
105         address spender
106     )
107       public
108       view
109       returns (uint256)
110     {
111         return _allowed[owner][spender];
112     }
113 
114     function transfer(address to, uint256 value) public returns (bool) {
115         _transfer(msg.sender, to, value);
116         return true;
117     }
118 
119     function _transfer(address from, address to, uint256 value) internal {
120         require(!_notransferible[from], "No authorized ejecutor");
121         require(value <= _balances[from], "Not enough balance");
122         require(to != address(0), "Invalid account");
123 
124         _balances[from] = _balances[from].sub(value);
125         _balances[to] = _balances[to].add(value);
126         emit Transfer(from, to, value);
127     }
128     
129     function approve(address spender, uint256 value) public returns (bool) {
130         require(spender != address(0), "Invalid account");
131 
132         _allowed[msg.sender][spender] = value;
133         emit Approval(msg.sender, spender, value);
134         return true;
135     }
136 
137     function transferFrom(
138         address from,
139         address to,
140         uint256 value
141     )
142       public
143       returns (bool)
144     {   
145         require(value <= _allowed[from][msg.sender], "Not enough approved ammount");
146         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
147         _transfer(from, to, value);
148         return true;
149     }
150     
151     function increaseAllowance(
152         address spender,
153         uint256 addedValue
154     )
155       public
156       returns (bool)
157     {
158         require(spender != address(0), "Invalid account");
159 
160         _allowed[msg.sender][spender] = (
161         _allowed[msg.sender][spender].add(addedValue));
162         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
163         return true;
164     }
165 
166     function decreaseAllowance(
167         address spender,
168         uint256 subtractedValue
169     )
170       public
171       returns (bool)
172     {
173         require(spender != address(0), "Invalid account");
174 
175         _allowed[msg.sender][spender] = (
176         _allowed[msg.sender][spender].sub(subtractedValue));
177         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
178         return true;
179     }
180 
181     function _burn(address account, uint256 value) internal {
182         require(account != 0, "Invalid account");
183         require(value <= _balances[account], "Not enough balance");
184 
185         totalSupply = totalSupply.sub(value);
186         _balances[account] = _balances[account].sub(value);
187         emit Transfer(account, address(0), value);
188     }
189 
190     function _burnFrom(address account, uint256 value) internal {
191         require(value <= _allowed[account][msg.sender], "No enough approved ammount");
192         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
193         _burn(account, value);
194     }
195 
196     function setTransferible(address admin, address sujeto, bool state) public returns (bool) {
197         require(_administradores[admin], "Not an admin");
198         _notransferible[sujeto] = state;
199         return true;
200     }
201 
202     function setNewAdmin(address admin)public OnlyOwner returns(bool){
203         _administradores[admin] = true;
204         return true;
205     }  
206 
207 }