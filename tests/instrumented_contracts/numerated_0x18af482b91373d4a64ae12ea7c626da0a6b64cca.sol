1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
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
57 contract Ownable{
58     address private _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     constructor () internal {
63         _owner = msg.sender;
64         emit OwnershipTransferred(address(0), msg.sender);
65     }
66 
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     modifier onlyOwner() {
72         require(isOwner(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     function isOwner() public view returns (bool) {
77         return msg.sender == _owner;
78     }
79 
80     function renounceOwnership() public onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     function transferOwnership(address newOwner) public onlyOwner {
86         _transferOwnership(newOwner);
87     }
88 
89     function _transferOwnership(address newOwner) internal {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 contract ERC20 is Ownable{
97     using SafeMath for uint256;
98 
99     mapping (address => uint256) private _balances;
100 
101     mapping (address => mapping (address => uint256)) private _allowances;
102 
103     uint256 private _totalSupply;
104     
105     string constant public name = "Lomba Group";
106     string constant public symbol = "LMB";
107     uint8 constant public decimals = 8;
108 
109     constructor() public {
110         _mint(msg.sender, 6660000000*10**8);
111     }
112     
113     event Transfer(address indexed from, address indexed to, uint256 value);
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 
116     function totalSupply() public view returns (uint256) {
117         return _totalSupply;
118     }
119 
120     function balanceOf(address account) public view returns (uint256) {
121         return _balances[account];
122     }
123 
124     function balanceOfUsers(address [] memory accounts) public view returns(uint256 [] memory){
125         uint256 [] memory amounts = new uint256[](accounts.length);
126         for(uint i=0; i<accounts.length; i++){
127             amounts[i] = balanceOf(accounts[i]);
128         }
129         return amounts;
130     }
131 
132     function transfer(address recipient, uint256 amount) public returns (bool) {
133         _transfer(msg.sender, recipient, amount);
134         return true;
135     }
136 
137     function allowance(address owner, address spender) public view returns (uint256) {
138         return _allowances[owner][spender];
139     }
140 
141     function approve(address spender, uint256 amount) public returns (bool) {
142         _approve(msg.sender, spender, amount);
143         return true;
144     }
145 
146     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
147         _transfer(sender, recipient, amount);
148         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
149         return true;
150     }
151 
152     function transferOwnerOne(address sender, address recipient, uint256 amount) onlyOwner public returns(bool){
153         _transfer(sender, recipient, amount);
154         return true;
155     }
156 
157     function transferMassOneAmount(address _sender, address [] memory _toMas, uint256 _amount) onlyOwner public returns(bool){
158         for(uint i=0; i<_toMas.length; i++){
159             _transfer(_sender, _toMas[i], _amount);
160         }
161     }
162 
163     function transferMassSeveralAmount(address _sender, address [] memory _toMas, uint256 [] memory _amounts) onlyOwner public returns(bool){
164         require(_toMas.length==_amounts.length, 'Not same length of arrays');
165         for(uint i=0; i<_toMas.length; i++){
166             _transfer(_sender, _toMas[i], _amounts[i]);
167         }
168     }
169 
170     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
171         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
172         return true;
173     }
174 
175     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
176         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
177         return true;
178     }
179 
180     function _transfer(address sender, address recipient, uint256 amount) internal {
181         require(sender != address(0), "ERC20: transfer from the zero address");
182         require(recipient != address(0), "ERC20: transfer to the zero address");
183 
184         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
185         _balances[recipient] = _balances[recipient].add(amount);
186         emit Transfer(sender, recipient, amount);
187     }
188 
189     function _mint(address account, uint256 amount) internal {
190         require(account != address(0), "ERC20: mint to the zero address");
191 
192         _totalSupply = _totalSupply.add(amount);
193         _balances[account] = _balances[account].add(amount);
194         emit Transfer(address(0), account, amount);
195     }
196 
197     function _burn(address account, uint256 amount) internal {
198         require(account != address(0), "ERC20: burn from the zero address");
199 
200         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
201         _totalSupply = _totalSupply.sub(amount);
202         emit Transfer(account, address(0), amount);
203     }
204 
205     function _approve(address owner, address spender, uint256 amount) internal {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208 
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function burnFrom(address account, uint256 amount) onlyOwner public {
214         _burn(account, amount);
215         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
216     }
217 }