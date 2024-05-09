1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4 
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
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Owned {
30     address public owner;
31     address public proposedOwner;
32     event OwnershipTransferInitiated(address indexed _proposedOwner);
33     event OwnershipTransferCompleted(address indexed _newOwner);
34 
35 
36     function Owned() public {
37         owner = msg.sender;
38     }
39     modifier onlyOwner() {
40         require(isOwner(msg.sender));
41         _;
42     }
43 
44     function isOwner(address _address) internal view returns (bool) {
45         return (_address == owner);
46     }
47 
48     function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
49         proposedOwner = _proposedOwner;
50         OwnershipTransferInitiated(_proposedOwner);
51         return true;
52     }
53 
54     function completeOwnershipTransfer() public returns (bool) {
55         require(msg.sender == proposedOwner);
56         owner = proposedOwner;
57         proposedOwner = address(0);
58         OwnershipTransferCompleted(owner);
59         return true;
60     }
61 }
62 
63 contract SkipdayConfig {
64     string  public constant TOKEN_SYMBOL   = "SKIPDAY";
65     string  public constant TOKEN_NAME     = "Skipday";
66     uint8   public constant TOKEN_DECIMALS = 18;
67     uint256 public constant DECIMALSFACTOR = 10**uint256(TOKEN_DECIMALS);
68     uint256 public constant TOKENS_MAX     = 314159265 * DECIMALSFACTOR;
69 }
70 
71 contract ERC20Interface {
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74     function name() public view returns (string);
75     function symbol() public view returns (string);
76     function decimals() public view returns (uint8);
77     function totalSupply() public view returns (uint256);
78     function balanceOf(address _owner) public view returns (uint256 balance);
79     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
80     function transfer(address _to, uint256 _value) public returns (bool success);
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
82     function approve(address _spender, uint256 _value) public returns (bool success);
83 }
84 
85 contract ERC20Token is ERC20Interface, Owned {
86     using SafeMath for uint256;
87     string  private tokenName;
88     string  private tokenSymbol;
89     uint8   private tokenDecimals;
90     uint256 internal tokenTotalSupply;
91     mapping(address => uint256) balances;
92     mapping(address => mapping (address => uint256)) allowed;
93 
94 
95     function ERC20Token(string _symbol, string _name, uint8 _decimals, uint256 _totalSupply) public Owned(){
96         tokenSymbol      = _symbol;
97         tokenName        = _name;
98         tokenDecimals    = _decimals;
99         tokenTotalSupply = _totalSupply;
100         balances[owner]  = _totalSupply;
101         Transfer(0x0, owner, _totalSupply);
102     }
103 
104 
105     function name() public view returns (string) {
106         return tokenName;
107     }
108 
109 
110     function symbol() public view returns (string) {
111         return tokenSymbol;
112     }
113 
114 
115     function decimals() public view returns (uint8) {
116         return tokenDecimals;
117     }
118 
119 
120     function totalSupply() public view returns (uint256) {
121         return tokenTotalSupply;
122     }
123 
124 
125     function balanceOf(address _owner) public view returns (uint256) {
126         return balances[_owner];
127     }
128 
129 
130     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
131         return allowed[_owner][_spender];
132     }
133 
134 
135     function transfer(address _to, uint256 _value) public returns (bool success) {
136         balances[msg.sender] = balances[msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         Transfer(msg.sender, _to, _value);
139         return true;
140     }
141 
142 
143     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
144         balances[_from] = balances[_from].sub(_value);
145         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         Transfer(_from, _to, _value);
148         return true;
149     }
150 
151 
152     function approve(address _spender, uint256 _value) public returns (bool success) {
153         allowed[msg.sender][_spender] = _value;
154         Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158 }
159 
160 contract OpsManaged is Owned {
161     address public opsAddress;
162     address public adminAddress;
163     event AdminAddressChanged(address indexed _newAddress);
164     event OpsAddressChanged(address indexed _newAddress);
165 
166 
167     function OpsManaged() public Owned(){
168     }
169 
170     modifier onlyAdmin() {
171         require(isAdmin(msg.sender));
172         _;
173     }
174 
175     modifier onlyAdminOrOps() {
176         require(isAdmin(msg.sender) || isOps(msg.sender));
177         _;
178     }
179 
180     modifier onlyOwnerOrAdmin() {
181         require(isOwner(msg.sender) || isAdmin(msg.sender));
182         _;
183     }
184 
185     modifier onlyOps() {
186         require(isOps(msg.sender));
187         _;
188     }
189 
190     function isAdmin(address _address) internal view returns (bool) {
191         return (adminAddress != address(0) && _address == adminAddress);
192     }
193 
194     function isOps(address _address) internal view returns (bool) {
195         return (opsAddress != address(0) && _address == opsAddress);
196     }
197 
198     function isOwnerOrOps(address _address) internal view returns (bool) {
199         return (isOwner(_address) || isOps(_address));
200     }
201 
202     function setAdminAddress(address _adminAddress) external onlyOwnerOrAdmin returns (bool) {
203         require(_adminAddress != owner);
204         require(_adminAddress != address(this));
205         require(!isOps(_adminAddress));
206         adminAddress = _adminAddress;
207         AdminAddressChanged(_adminAddress);
208         return true;
209     }
210 
211     function setOpsAddress(address _opsAddress) external onlyOwnerOrAdmin returns (bool) {
212         require(_opsAddress != owner);
213         require(_opsAddress != address(this));
214         require(!isAdmin(_opsAddress));
215         opsAddress = _opsAddress;
216         OpsAddressChanged(_opsAddress);
217         return true;
218     }
219 }
220 
221 
222 
223 contract Skipday is ERC20Token, OpsManaged, SkipdayConfig {
224     bool public finalized;
225     event Burnt(address indexed _from, uint256 _amount);
226     event Finalized();
227 
228     function Skipday() public ERC20Token(TOKEN_SYMBOL, TOKEN_NAME, TOKEN_DECIMALS, TOKENS_MAX) OpsManaged(){
229         finalized = false;
230     }
231 
232     function transfer(address _to, uint256 _value) public returns (bool success) {
233         checkTransferAllowed(msg.sender, _to);
234         return super.transfer(_to, _value);
235     }
236 
237     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
238         checkTransferAllowed(msg.sender, _to);
239         return super.transferFrom(_from, _to, _value);
240     }
241 
242     function checkTransferAllowed(address _sender, address _to) private view {
243         if (finalized) {
244             return;
245         }
246         require(isOwnerOrOps(_sender) || _to == owner);
247     }
248 
249     function burn(uint256 _value) public returns (bool success) {
250         require(_value <= balances[msg.sender]);
251         balances[msg.sender] = balances[msg.sender].sub(_value);
252         tokenTotalSupply = tokenTotalSupply.sub(_value);
253         Burnt(msg.sender, _value);
254         return true;
255     }
256 
257     function finalize() external onlyAdmin returns (bool success) {
258         require(!finalized);
259         finalized = true;
260         Finalized();
261         return true;
262     }
263 }