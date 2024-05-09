1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     
5     function transfer(address to, uint256 value) external returns (bool);
6 
7     function approve(address spender, uint256 value) external returns (bool);
8 
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23 
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28 
29         uint256 c = a * b;
30         require(c / a == b, "SafeMath: multiplication overflow");
31 
32         return c;
33     }
34 
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b > 0, "SafeMath: division by zero");
37         uint256 c = a / b;
38         
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55 
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b != 0, "SafeMath: modulo by zero");
58         
59         return a % b;
60     }
61 }
62 
63 contract Ownerable {
64     
65     address private _owner;
66     address private _newOwner;
67 
68     event OwnershipTransfer(address indexed previousOwner, address indexed newOwner);
69     event OwnershipConfirmed(address indexed newOwner);
70 
71     constructor () internal {
72         _owner = msg.sender;
73         emit OwnershipTransfer(address(0), _owner);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(isOwner(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function isOwner() public view returns (bool) {
86         return msg.sender == _owner;
87     }
88 
89     function acceptOwnership() public {
90         _acceptOwnership(msg.sender);
91     }
92 
93     function _acceptOwnership(address newOwner) internal {
94         require(newOwner == _newOwner, "Ownable: caller is not the newOwner");
95         _owner = newOwner;
96         _newOwner = address(0);
97         emit OwnershipConfirmed(_newOwner);
98     }
99 
100     function transferOwnership(address newOwner) public onlyOwner {
101         _transferOwnership(newOwner);
102     }
103 
104     function _transferOwnership(address newOwner) internal {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         _newOwner = newOwner;
107         emit OwnershipTransfer(msg.sender, newOwner);
108     }
109 }
110 
111 contract Pausable is Ownerable {
112     
113     event Paused(address account);
114     event Unpaused(address account);
115 
116     bool private _paused;
117 
118     constructor () internal {
119         _paused = false;
120     }
121 
122     function paused() public view returns (bool) {
123         return _paused;
124     }
125 
126     modifier whenNotPaused() {
127         require(!_paused, "Pausable: paused");
128         _;
129     }
130 
131     modifier whenPaused() {
132         require(_paused, "Pausable: not paused");
133         _;
134     }
135 
136     function pause() public onlyOwner whenNotPaused {
137         _paused = true;
138         emit Paused(msg.sender);
139     }
140 
141     function unpause() public onlyOwner whenPaused {
142         _paused = false;
143         emit Unpaused(msg.sender);
144     }
145 }
146 
147 contract APToken is IERC20, Pausable {
148     
149     using SafeMath for uint256;
150     
151     mapping (address => uint256) private _balances;
152     mapping (address => mapping (address => uint256)) private _allowances;
153     uint256 private _totalSupply;
154     
155     string public symbol;
156     string public name;
157     uint8 public decimals;
158     
159     constructor(uint256 initialSupply, uint8 decimalUnits, string memory tokenSymbol, string memory tokenName) public {
160         _balances[msg.sender] = initialSupply;
161         _totalSupply = initialSupply;
162         decimals = decimalUnits;
163         name = tokenName;
164         symbol = tokenSymbol;
165     }
166 
167     function totalSupply() public view returns (uint256) {
168         return _totalSupply;
169     }
170 
171     function balanceOf(address owner) public view returns (uint256) {
172         return _balances[owner];
173     }
174 
175     function allowance(address owner, address spender) public view returns (uint256) {
176         return _allowances[owner][spender];
177     }
178 
179     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
180         _transfer(msg.sender, to, value);
181         return true;
182     }
183 
184     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
185         _approve(msg.sender, spender, value);
186         return true;
187     }
188 
189     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
190         _transfer(from, to, value);
191         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
192         return true;
193     }
194     
195     function burn(uint256 amount) public whenNotPaused returns (bool){
196         _burn(msg.sender, amount);
197         return true;
198     }
199 
200     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
201         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
202         return true;
203     }
204 
205     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
206         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
207         return true;
208     }
209 
210     function _transfer(address from, address to, uint256 value) internal {
211         require(from != address(0), "ERC20: transfer from the zero address");
212         require(to != address(0), "ERC20: transfer to the zero address");
213 
214         _balances[from] = _balances[from].sub(value);
215         _balances[to] = _balances[to].add(value);
216         emit Transfer(from, to, value);
217     }
218 
219     function _approve(address owner, address spender, uint256 value) internal {
220         require(owner != address(0), "ERC20: approve from the zero address");
221         require(spender != address(0), "ERC20: approve to the zero address");
222 
223         _allowances[owner][spender] = value;
224         emit Approval(owner, spender, value);
225     }
226     
227     function _burn(address account, uint256 value) internal {
228         require(account != address(0), "ERC20: burn from the zero address");
229 
230         _totalSupply = _totalSupply.sub(value);
231         _balances[account] = _balances[account].sub(value);
232         emit Transfer(account, address(0), value);
233     }
234 }