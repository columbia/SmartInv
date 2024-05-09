1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18    
19     constructor() {
20         _transferOwnership(_msgSender());
21     }
22     
23     function owner() public view virtual returns (address) {
24         return _owner;
25     }
26    
27     modifier onlyOwner() {
28         require(owner() == _msgSender(), "Ownable: caller is not the owner");
29         _;
30     }
31   
32     function renounceOwnership() public virtual onlyOwner {
33         _transferOwnership(address(0));
34     }
35    
36     function transferOwnership(address newOwner) public virtual onlyOwner {
37         require(newOwner != address(0), "Ownable: new owner is the zero address");
38         _transferOwnership(newOwner);
39     }
40     
41     function _transferOwnership(address newOwner) internal virtual {
42         address oldOwner = _owner;
43         _owner = newOwner;
44         emit OwnershipTransferred(oldOwner, newOwner);
45     }
46 }
47 
48 interface IERC20 {
49 
50     function totalSupply() external view returns (uint256);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56 
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 contract TidexToken is Ownable, IERC20 {
62     
63     mapping (address => uint256) private _balances;
64     
65     mapping (address => mapping (address => uint256)) private _allowances;
66     
67     uint256 private _totalSupply;
68     uint8 private _decimals;
69     string private _symbol;
70     string private _name;
71     
72     constructor() {
73         _name = "Tidex Token";
74         _symbol = "TDX";
75         _decimals = 18;
76         _totalSupply = 150_000_000 * 10 ** 18;
77         _balances[_msgSender()] = _totalSupply;
78         
79         emit Transfer(address(0), _msgSender(), _totalSupply);
80     }
81 
82     function decimals() external view  returns (uint8) {
83         return _decimals;
84     }
85    
86     function symbol() external view  returns (string memory) {
87         return _symbol;
88     }
89    
90     function name() external view  returns (string memory) {
91         return _name;
92     }
93     
94     function totalSupply() external view override returns (uint256) {
95         return _totalSupply;
96     }
97     
98     function balanceOf(address account) external view override returns (uint256) {
99         return _balances[account];
100     }
101 
102     function transfer(address recipient, uint256 amount) public override  returns (bool) {
103         _transfer(_msgSender(), recipient, amount);
104         return true;
105     }
106     
107     function allowance(address owner, address spender) external view override returns (uint256) {
108         return _allowances[owner][spender];
109     }
110     
111     function approve(address spender, uint256 amount) public  override  returns (bool) {
112         _approve(_msgSender(), spender, amount);
113         return true;
114     }
115     
116     function transferFrom(
117         address sender,
118         address recipient,
119         uint256 amount
120     ) public override  returns (bool) {
121         _transfer(sender, recipient, amount);
122         _approve(
123             sender,
124             _msgSender(),
125             _allowances[sender][_msgSender()] - amount
126         );
127         return true;
128     }
129     
130     function increaseAllowance(address spender, uint256 addedValue)
131         public
132         
133         returns (bool)
134     {
135         _approve(
136             _msgSender(),
137             spender,
138             _allowances[_msgSender()][spender] + addedValue
139         );
140         return true;
141     }
142     
143     function decreaseAllowance(address spender, uint256 subtractedValue)
144         public
145         
146         returns (bool)
147     {
148         _approve(
149             _msgSender(),
150             spender,
151             _allowances[_msgSender()][spender] - subtractedValue
152         );
153 
154         return true;
155     }
156     
157     function _transfer(address sender, address recipient, uint256 amount) internal {
158         require(sender != address(0), "ERC20: transfer from the zero address");
159         require(recipient != address(0), "ERC20: transfer to the zero address");
160         
161         _balances[sender] = _balances[sender] - amount;
162         _balances[recipient] = _balances[recipient] + amount;
163         emit Transfer(sender, recipient, amount);
164     }
165 
166     function withdrawToken(address _tokenContract, uint256 _amount) external onlyOwner {
167         IERC20 token = IERC20(_tokenContract);       
168         token.transfer(msg.sender, _amount);
169     }
170      
171     function _approve(address owner, address spender, uint256 amount) internal {
172         require(owner != address(0), "ERC20: approve from the zero address");
173         require(spender != address(0), "ERC20: approve to the zero address");
174         
175         _allowances[owner][spender] = amount;
176         emit Approval(owner, spender, amount);
177     }
178 
179     function burn(uint256 amount) public {
180         _burn(msg.sender, amount);
181     }
182 
183     function _burn(address from, uint value) internal {
184         _balances[from] = _balances[from] - value;
185         _totalSupply = _totalSupply - value;
186         emit Transfer(from, address(0), value);
187     }
188 }