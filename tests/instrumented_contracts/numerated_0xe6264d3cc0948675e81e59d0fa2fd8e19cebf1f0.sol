1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9 }
10 
11 abstract contract Ownable is Context {
12     address private _owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     constructor() {
17         _transferOwnership(_msgSender());
18     }
19 
20     function owner() public view virtual returns (address) {
21         return _owner;
22     }
23 
24     modifier onlyOwner() {
25         require(owner() == _msgSender(), "Ownable: caller is not the owner");
26         _;
27     }
28 
29     function renounceOwnership() public virtual onlyOwner {
30         _transferOwnership(address(0));
31     }
32 
33     function transferOwnership(address newOwner) public virtual onlyOwner {
34         require(newOwner != address(0), "Ownable: new owner is the zero address");
35         _transferOwnership(newOwner);
36     }
37 
38     function _transferOwnership(address newOwner) internal virtual {
39         address oldOwner = _owner;
40         _owner = newOwner;
41         emit OwnershipTransferred(oldOwner, newOwner);
42     }
43 }
44 
45 contract CHUPACABRA is Ownable {
46     mapping(address => uint256) private _balances;
47 
48     mapping(address => mapping(address => uint256)) private _allowances;
49 
50     string private constant _name = "CHUPACABRA";
51     string private constant _symbol = "CHUPA";
52     uint8 private constant _decimals = 18;
53     uint256 private constant _totalSupply = 1000000000000000 * 10**18;
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     event Approval(
58         address indexed owner,
59         address indexed spender,
60         uint256 value
61     );
62 
63     constructor() {
64         _balances[msg.sender] = _totalSupply;
65         emit Transfer(address(0), msg.sender, _totalSupply);
66     }
67 
68     function name() external view virtual returns (string memory) {
69         return _name;
70     }
71 
72     function symbol() external view virtual returns (string memory) {
73         return _symbol;
74     }
75 
76     function decimals() external view virtual returns (uint8) {
77         return _decimals;
78     }
79 
80     function totalSupply() external view virtual returns (uint256) {
81         return _totalSupply;
82     }
83 
84     function balanceOf(address account)
85         external
86         view
87         virtual
88         returns (uint256)
89     {
90         return _balances[account];
91     }
92 
93     function transfer(address to, uint256 amount)
94         external
95         virtual
96         returns (bool)
97     {
98         address owner = msg.sender;
99         require(owner != to, "ERC20: transfer to address cannot be owner");
100         _transfer(owner, to, amount);
101         return true;
102     }
103 
104     function allowance(address owner, address spender)
105         public
106         view
107         virtual
108         returns (uint256)
109     {
110         return _allowances[owner][spender];
111     }
112 
113     function approve(address spender, uint256 amount)
114         external
115         virtual
116         returns (bool)
117     {
118         address owner = msg.sender;
119         _approve(owner, spender, amount);
120         return true;
121     }
122 
123     function transferFrom(
124         address from,
125         address to,
126         uint256 amount
127     ) external virtual returns (bool) {
128         address spender = msg.sender;
129         require(
130             spender != from,
131             "ERC20: transferFrom spender can not be the from"
132         );
133         _spendAllowance(from, spender, amount);
134         _transfer(from, to, amount);
135         return true;
136     }
137 
138     function increaseAllowance(address spender, uint256 addedValue)
139         external
140         virtual
141         returns (bool)
142     {
143         address owner = msg.sender;
144         _approve(owner, spender, allowance(owner, spender) + addedValue);
145         return true;
146     }
147 
148     function decreaseAllowance(address spender, uint256 subtractedValue)
149         external
150         virtual
151         returns (bool)
152     {
153         address owner = msg.sender;
154         uint256 currentAllowance = allowance(owner, spender);
155         require(
156             currentAllowance >= subtractedValue,
157             "ERC20: decreased allowance below zero"
158         );
159         unchecked {
160             _approve(owner, spender, currentAllowance - subtractedValue);
161         }
162 
163         return true;
164     }
165 
166     function _transfer(
167         address from,
168         address to,
169         uint256 amount
170     ) internal virtual {
171         require(from != address(0), "ERC20: transfer from the zero address");
172         require(to != address(0), "ERC20: transfer to the zero address");
173         require(amount > 0, "ERC20: transfer amount must be greater than zero");
174 
175         uint256 fromBalance = _balances[from];
176         require(
177             fromBalance >= amount,
178             "ERC20: transfer amount exceeds balance"
179         );
180         unchecked {
181             _balances[from] = fromBalance - amount;
182         }
183         _balances[to] += amount;
184 
185         emit Transfer(from, to, amount);
186     }
187 
188     function _approve(
189         address owner,
190         address spender,
191         uint256 amount
192     ) internal virtual {
193         require(owner != address(0), "ERC20: approve from the zero address");
194         require(spender != address(0), "ERC20: approve to the zero address");
195 
196         _allowances[owner][spender] = amount;
197         emit Approval(owner, spender, amount);
198     }
199 
200     function _spendAllowance(
201         address owner,
202         address spender,
203         uint256 amount
204     ) internal virtual {
205         uint256 currentAllowance = allowance(owner, spender);
206         if (currentAllowance != type(uint256).max) {
207             require(
208                 currentAllowance >= amount,
209                 "ERC20: insufficient allowance"
210             );
211             unchecked {
212                 _approve(owner, spender, currentAllowance - amount);
213             }
214         }
215     }
216 }