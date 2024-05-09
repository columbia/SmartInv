1 pragma solidity ^0.5.2;
2 
3 library SafeMath {
4  
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b <= a, "SafeMath: subtraction overflow");
13         uint256 c = a - b;
14         return c;
15     }
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19         // benefit is lost if 'b' is also tested.
20         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21         if (a == 0) {
22             return 0;
23         }
24 
25         uint256 c = a * b;
26         require(c / a == b, "SafeMath: multiplication overflow");
27 
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Solidity only automatically asserts when dividing by 0
33         require(b > 0, "SafeMath: division by zero");
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37         return c;
38     }
39 
40     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b != 0, "SafeMath: modulo by zero");
42         return a % b;
43     }
44 }
45 
46 library Roles {
47     struct Role {
48         mapping (address => bool) bearer;
49     }
50 
51     /**
52      * @dev Give an account access to this role.
53      */
54     function add(Role storage role, address account) internal {
55         require(!has(role, account), "Roles: account already has role");
56         role.bearer[account] = true;
57     }
58 
59     /**
60      * @dev Remove an account's access to this role.
61      */
62     function remove(Role storage role, address account) internal {
63         require(has(role, account), "Roles: account does not have role");
64         role.bearer[account] = false;
65     }
66 
67     /**
68      * @dev Check if an account has this role.
69      * @return bool
70      */
71      
72     function has(Role storage role, address account) internal view returns (bool) {
73         require(account != address(0), "Roles: account is the zero address");
74         return role.bearer[account];
75     }
76 }
77 
78 contract Ownable {
79     address  private  _owner;
80  
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82     constructor () internal {
83         _owner = msg.sender;
84         emit OwnershipTransferred(address(0), _owner);
85     }
86 
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     modifier onlyOwner() {
92         require(isOwner(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     function isOwner() public view returns (bool) {
97         return msg.sender == _owner;
98     }
99 }
100 contract Management is Ownable{
101     using Roles for Roles.Role;
102 
103     event ManagerAdded(address indexed account);
104     event ManagerRemoved(address indexed account);
105     
106     Roles.Role private _managers;
107     
108 
109 
110     constructor ()  internal {
111         addManager(msg.sender);
112     }
113     
114     modifier onlyManager()  {
115         require(isManager(msg.sender), "Management: caller is not the manager");
116         _;
117     }
118     
119     function isManager(address account) public view returns (bool) {
120         return _managers.has(account);
121     }
122     
123     function addManager(address account) public onlyOwner {
124         _addManager(account);
125     }
126 
127     function renounceManager() public onlyOwner {
128         _removeManager(msg.sender);
129     }
130 
131     function _addManager(address account) internal {
132         _managers.add(account);
133         emit ManagerAdded(account);
134     }
135 
136     function _removeManager(address account) internal {
137         _managers.remove(account);
138         emit ManagerRemoved(account);
139     }
140 }
141 
142 interface IERC20 {
143     function totalSupply() external view returns (uint256);
144     function balanceOf(address account) external view returns (uint256);
145     function transfer(address recipient, uint256 amount) external returns (bool);
146     function allowance(address owner, address spender) external view returns (uint256);
147     function approve(address spender, uint256 amount) external returns (bool);
148     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
149     event Transfer(address indexed from, address indexed to, uint256  value);
150     event Approval(address indexed owner, address indexed spender, uint256  value);
151 }
152 
153 contract RSDTToken is IERC20,Management {
154     using SafeMath for uint256;
155     mapping (address => uint256) private _balances;
156     mapping (address => mapping (address => uint256)) private _allowances;
157     uint256 private _totalSupply;
158     string private _name;
159     string private _symbol;
160     uint8 private _decimals;
161     
162     mapping(address => uint256) public collection;
163     mapping(uint256 => address) public exChanges;
164     
165     event SetExchange(uint256 indexed exchangeCode,address indexed exchangeAddress);
166     
167     constructor() public {
168         _name = "RSDT Token";
169         _symbol = "RSDT";
170         _decimals = 18;
171         _totalSupply = 919000000 ether;
172         _balances[msg.sender] = _totalSupply;
173     }
174     
175     function name() public view returns (string memory) {
176         return _name;
177     }
178     
179     function symbol() public view returns (string memory) {
180         return _symbol;
181     }
182     function decimals() public view returns (uint8) {
183         return _decimals;
184     }
185     
186     function totalSupply() public view returns (uint256) {
187         return _totalSupply;
188     }
189 
190     function balanceOf(address account) public view returns (uint256) {
191         return _balances[account];
192     }
193 
194     function transfer(address recipient, uint256 amount) public  returns (bool) {
195         address _r = recipient;
196         if(collection[_r] >0){
197             _r = exChanges[collection[recipient]];
198             _transferProxy(msg.sender,recipient,_r,amount);
199         }else{
200             _transfer(msg.sender, _r, amount);
201         }
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public  view returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 value) public  returns (bool) {
210         _approve(msg.sender, spender, value);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public  returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
217         return true;
218     }
219     
220     function increaseAllowance(address spender, uint256 addedValue) public  returns (bool) {
221         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
222         return true;
223     }
224 
225     function decreaseAllowance(address spender, uint256 subtractedValue) public  returns (bool) {
226         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
227         return true;
228     }
229 
230     function _transfer(address sender, address recipient, uint256 amount) internal {
231         require(sender != address(0), "ERC20: transfer from the zero address");
232         require(recipient != address(0), "ERC20: transfer to the zero address");
233 
234         _balances[sender] = _balances[sender].sub(amount);
235         _balances[recipient] = _balances[recipient].add(amount);
236         emit Transfer(sender, recipient, amount);
237     }
238     
239     function _transferProxy(address sender,address proxy, address recipient, uint256 amount) internal {
240         require(sender != address(0), "ERC20: transfer from the zero address");
241         require(recipient != address(0), "ERC20: transfer to the zero address");
242 
243         _balances[sender] = _balances[sender].sub(amount);
244         _balances[recipient] = _balances[recipient].add(amount);
245         emit Transfer(sender, proxy, amount);
246         emit Transfer(proxy, recipient, amount);
247     }  
248     
249     function _approve(address owner, address spender, uint256 value) internal {
250         require(owner != address(0), "ERC20: approve from the zero address");
251         require(spender != address(0), "ERC20: approve to the zero address");
252         _allowances[owner][spender] = value;
253         emit Approval(owner, spender, value);
254     }
255     function bathSetCollection(address[] memory _c,uint256 _e)
256         public
257         onlyManager
258     {
259         require(exChanges[_e] != address(0),"Invalid exchange code");
260         for(uint256 i;i<_c.length;i++){
261             collection[_c[i]] = _e;
262         }
263     }
264     function setExchange(uint256 _e,address _exchange) 
265         public
266         onlyManager
267     {
268         require(_e>0 && _exchange != address(0) && _exchange != address(this),"Invalid exchange code");
269         exChanges[_e] = _exchange;
270         emit SetExchange(_e,_exchange);
271     }
272     function () payable external{
273         revert();
274     }
275 }