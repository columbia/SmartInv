1 pragma solidity ^0.5.1;
2 
3 library SafeMath{
4     
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30 
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37 
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         // Solidity only automatically asserts when dividing by 0
40         require(b > 0, errorMessage);
41         uint256 c = a / b;
42         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43 
44         return c;
45     }
46 
47     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
48         return mod(a, b, "SafeMath: modulo by zero");
49     }
50 
51     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b != 0, errorMessage);
53         return a % b;
54     }
55 }
56 
57 
58 
59 
60 contract ECOHETENCToken{
61     
62     using SafeMath for uint256;
63     mapping (address => uint256) public balanceOf;
64     mapping (address => bool) private transferable;
65     mapping(address => mapping (address => uint256)) allowed;
66     mapping(address => bool) private admin;
67     
68     uint256 private _totalSupply=1100000000000000000000000000;
69     string private _name= "ECO HETENC Token";
70     string private _symbol= "HETENC";
71     uint256 private _decimals = 18;
72     bool internal _lockall = false;
73     
74     constructor () public {
75 	admin[address(0xf7F84640861Fe95c22Ede9c62f77CF3bC0967f86)] = true;
76     balanceOf[address(0xf7F84640861Fe95c22Ede9c62f77CF3bC0967f86)] = _totalSupply;
77         }
78 
79     event Transfer(address indexed from, address indexed to, uint tokens);
80     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
81 
82         
83     function name() public view returns (string memory) {
84         return _name;
85     }
86     
87     function symbol() public view returns (string memory) {
88         return _symbol;
89     }
90     function decimals() public view returns (uint256) {
91         return _decimals;
92     }
93     
94     function totalSupply() public view returns (uint256) {
95         return _totalSupply;
96     }
97     
98     function _transfer(address _from, address _to, uint256 _value) internal {
99         
100         require(_from != address(0), "ERC20: transfer from the zero address");
101         require(_to != address(0), "ERC20: transfer to the zero address");
102         require(balanceOf[_from]>=_value);
103         require(balanceOf[_to] + _value >= balanceOf[_to]);
104         require(transfercheck(_from) == true);
105         require(_lockall == false);
106         balanceOf[_from] = balanceOf[_from].sub(_value,"ERC20: transfer amount exceeds balance");
107         balanceOf[_to] = balanceOf[_to].add(_value);
108         emit Transfer(_from, _to, _value);
109 
110     }
111     
112     
113     function transfer(address to, uint256 value) public {
114         _transfer(msg.sender, to, value);
115     }
116     
117     function transferFrom(address _from, uint256 amount) public {
118          
119        require(allowed[_from][msg.sender]>=amount);
120        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(amount);
121        _transfer(_from,msg.sender,amount);
122     }
123     
124     function transfercheck(address check) internal view returns(bool) {
125         if (transferable[check]==false){
126             return true;
127         }
128         return false;
129     }
130     
131     function AllowenceCheck(address spender, address approver) public view returns (uint256){
132         return allowed[approver][spender];
133     }
134     
135     
136     function approve(address spender, uint256 _value) public{
137         require(balanceOf[msg.sender]>=_value);
138         allowed[msg.sender][spender] = _value;
139         emit Approval(msg.sender, spender, _value);
140         
141     }
142     
143     function increaseAllowence(address spender, uint256 _value) public{
144         require(balanceOf[msg.sender]>=_value);
145         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(_value);
146         emit Approval(msg.sender, spender, _value);
147     }
148     
149     function decreaseAllowence(address spender, uint256 _value) public{
150         require(balanceOf[msg.sender]>=_value);
151         allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(_value);
152         emit Approval(msg.sender, spender, -_value);
153     }
154 
155     function lock(address lockee) public {
156         require(admin[msg.sender]==true);
157         transferable[lockee] = true;
158     }
159     
160     function unlock(address unlockee) public {
161         require(admin[msg.sender]==true);
162         transferable[unlockee] = false;
163     }
164     
165     function lockcheck(address checkee) public view returns (bool){
166         return transferable[checkee];
167     }
168     
169     
170     function _burn(address account, uint256 value) private {
171         require(admin[account]==true);
172         require(admin[msg.sender]==true);
173         require(balanceOf[account]>=value);
174         require(_totalSupply>=value);
175         balanceOf[account] =balanceOf[account].sub(value);
176         _totalSupply = _totalSupply.sub(value);
177     }
178     
179     
180     function burn(uint256 amount) public {
181         _burn(msg.sender, amount);
182     }
183 
184     function addadmin(address account) public{
185         require(admin[msg.sender]==true);
186         admin[account]=true;
187     }
188 
189     function deleteadmin(address account) public{
190         require(admin[msg.sender]==true);
191         admin[account]=false;
192     }
193 
194     function admincheck(address account) public view returns (bool){
195         return admin[account];
196     }
197     
198     function lockall(bool lockall) public {
199         require(admin[msg.sender]==true);
200         _lockall = lockall;
201     }
202     
203     function lockallcheck() public view returns (bool){
204         return _lockall;
205     }
206     
207     
208 }