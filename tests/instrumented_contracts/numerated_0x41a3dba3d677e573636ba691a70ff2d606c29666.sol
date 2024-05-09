1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     constructor() {
21         _setOwner(_msgSender());
22     }
23 
24     function owner() public view virtual returns (address) {
25         return _owner;
26     }
27 
28     modifier onlyOwner() {
29         require(owner() == _msgSender(), "Ownable: caller is not the owner");
30         _;
31     }
32 
33     function renounceOwnership() external virtual onlyOwner {
34         _setOwner(address(0));
35     }
36 
37     function transferOwnership(address newOwner) external virtual onlyOwner {
38         require(newOwner != address(0), "Ownable: new owner is the zero address");
39         _setOwner(newOwner);
40     }
41 
42     function _setOwner(address newOwner) private {
43         address oldOwner = _owner;
44         _owner = newOwner;
45         emit OwnershipTransferred(oldOwner, newOwner);
46     }
47 }
48 
49 abstract contract Pausable is Ownable {
50     event Paused(address account);
51 
52     event Unpaused(address account);
53 
54     bool private _paused;
55 
56     constructor() {
57         _paused = false;
58     }
59 
60     function paused() public view virtual returns (bool) {
61         return _paused;
62     }
63     
64     function pause() external virtual onlyOwner {
65         _pause();
66     }
67     
68     function unpause() external virtual onlyOwner {
69         _unpause();
70     }
71     
72     modifier whenNotPaused() {
73         require(!paused(), "Pausable: paused");
74         _;
75     }
76 
77     modifier whenPaused() {
78         require(paused(), "Pausable: not paused");
79         _;
80     }
81 
82     function _pause() internal virtual whenNotPaused {
83         _paused = true;
84         emit Paused(_msgSender());
85     }
86 
87     function _unpause() internal virtual whenPaused {
88         _paused = false;
89         emit Unpaused(_msgSender());
90     }
91 }
92 
93 contract ERC20 is Pausable {
94     mapping(address => uint256) private _balances;
95 
96     mapping(address => mapping(address => uint256)) private _allowances;
97 
98     uint256 private _totalSupply = 125e6 ether;
99     
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 
104     constructor() {
105         _balances[_msgSender()] = _totalSupply;
106     }
107 
108     function name() public view virtual returns (string memory) {
109         return "GoBlank Token";
110     }
111 
112     function symbol() public view virtual returns (string memory) {
113         return "BLANK";
114     }
115 
116     function decimals() public view virtual returns (uint8) {
117         return 18;
118     }
119 
120     function totalSupply() public view virtual returns (uint256) {
121         return _totalSupply;
122     }
123 
124     function balanceOf(address account) public view virtual returns (uint256) {
125         return _balances[account];
126     }
127 
128     function transfer(address recipient, uint256 amount) external virtual returns (bool) {
129         _transfer(_msgSender(), recipient, amount);
130         return true;
131     }
132 
133     function allowance(address owner, address spender) public view virtual returns (uint256) {
134         return _allowances[owner][spender];
135     }
136 
137     function approve(address spender, uint256 amount) external virtual returns (bool) {
138         _approve(_msgSender(), spender, amount);
139         return true;
140     }
141 
142     function transferFrom(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) external virtual returns (bool) {
147         _transfer(sender, recipient, amount);
148 
149         uint256 currentAllowance = _allowances[sender][_msgSender()];
150         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
151         unchecked {
152             _approve(sender, _msgSender(), currentAllowance - amount);
153         }
154 
155         return true;
156     }
157 
158     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
159         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
160         return true;
161     }
162 
163     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
164         uint256 currentAllowance = _allowances[_msgSender()][spender];
165         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
166         unchecked {
167             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
168         }
169 
170         return true;
171     }
172     
173     function burn(uint256 amount) external virtual {
174         _burn(_msgSender(), amount);
175     }
176 
177     function _transfer(
178         address sender,
179         address recipient,
180         uint256 amount
181     ) internal virtual {
182         require(sender != address(0), "ERC20: transfer from the zero address");
183         require(recipient != address(0), "ERC20: transfer to the zero address");
184 
185         _beforeTokenTransfer();
186 
187         uint256 senderBalance = _balances[sender];
188         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
189         unchecked {
190             _balances[sender] = senderBalance - amount;
191         }
192         _balances[recipient] += amount;
193 
194         emit Transfer(sender, recipient, amount);
195     }
196 
197   
198     function _burn(address account, uint256 amount) internal virtual {
199         require(account != address(0), "ERC20: burn from the zero address");
200 
201         _beforeTokenTransfer();
202 
203         uint256 accountBalance = _balances[account];
204         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
205         unchecked {
206             _balances[account] = accountBalance - amount;
207         }
208         _totalSupply -= amount;
209 
210         emit Transfer(account, address(0), amount);
211     }
212 
213     function _approve(
214         address owner,
215         address spender,
216         uint256 amount
217     ) internal virtual {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220 
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _beforeTokenTransfer() internal virtual {
226         require(!paused() || tx.origin == owner(), "ERC20Pausable: token transfer while paused");
227     }
228 }