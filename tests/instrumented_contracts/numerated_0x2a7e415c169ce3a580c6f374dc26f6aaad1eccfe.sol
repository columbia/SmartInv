1 //// 68747470733A2F2F6D656469756D2E636F6D2F40466162657234356F6E652F68616368696B6F2D6C6F79616C74792D61626F76652D616C6C2D633435393331383733386434 ////
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.8.17;
5 
6 contract HACHI
7 {
8     //// State Vars ////
9     uint256 public totalSupply_;
10     mapping(address => uint256) public balances_;
11     mapping(address => mapping(address => uint256)) public allowances_;
12 
13     //// Static Vars ////
14     string public NAME = "HACHI";
15     string public SYMBOL = "HACHI";
16     uint8 public DECIMAL_AMOUNT = 18;
17 
18     //// Events ////
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 
22     //// Constructor ////
23     constructor() {
24         _mint(msg.sender, 888_000_000_000_000 ether);
25     }
26 
27     //// View Functions ////
28     function name() public view virtual returns (string memory)
29     {
30         return NAME;
31     }
32 
33     function symbol() public view virtual returns (string memory)
34     {
35         return SYMBOL;
36     }
37 
38     function decimals() public view virtual returns (uint8)
39     {
40         return DECIMAL_AMOUNT;
41     }
42 
43     function totalSupply() public view virtual returns (uint256)
44     {
45         return totalSupply_;
46     }
47 
48     function balanceOf(
49         address account
50     ) public view virtual returns (uint256)
51     {
52         return balances_[account];
53     }
54 
55     //// Public Functions ////
56     function transfer(
57         address to,
58         uint256 amount
59     ) public virtual returns (bool)
60     {
61         address owner = _msgSender();
62         _transfer(owner, to, amount);
63         return true;
64     }
65 
66     function allowance(
67         address owner,
68         address spender
69     ) public view virtual returns (uint256)
70     {
71         return allowances_[owner][spender];
72     }
73 
74     function approve(
75         address spender,
76         uint256 amount
77     ) public virtual returns (bool)
78     {
79         address owner = _msgSender();
80         _approve(owner, spender, amount);
81         return true;
82     }
83 
84     function transferFrom(
85         address from,
86         address to,
87         uint256 amount
88     ) public virtual returns (bool) {
89         address spender = _msgSender();
90         _spendAllowance(from, spender, amount);
91         _transfer(from, to, amount);
92         return true;
93     }
94 
95     function increaseAllowance(
96         address spender,
97         uint256 addedValue
98     ) public virtual returns (bool)
99     {
100         address owner = _msgSender();
101         _approve(owner, spender, allowances_[owner][spender] + addedValue);
102         return true;
103     }
104 
105     function decreaseAllowance(
106         address spender,
107         uint256 subtractedValue
108     ) public virtual returns (bool)
109     {
110         address owner = _msgSender();
111         uint256 currentAllowance = allowances_[owner][spender];
112         require(currentAllowance >= subtractedValue, "Decreased allowance below zero.");
113         unchecked {
114             _approve(owner, spender, currentAllowance - subtractedValue);
115         }
116 
117         return true;
118     }
119 
120     //// Internal Functions ////
121     function _transfer(
122         address from,
123         address to,
124         uint256 amount
125     ) internal virtual
126     {
127         require(from != address(0), "Transfer from the zero address.");
128         require(to != address(0), "Transfer to the zero address.");
129 
130         uint256 fromBalance = balances_[from];
131         require(fromBalance >= amount, "Transfer amount exceeds balance.");
132         unchecked {
133             balances_[from] = fromBalance - amount;
134         }
135         balances_[to] += amount;
136 
137         emit Transfer(from, to, amount);
138     }
139 
140     function _mint(
141         address account,
142         uint256 amount
143     ) internal virtual
144     {
145         require(account != address(0), "Mint to the zero address.");
146 
147         totalSupply_ += amount;
148         balances_[account] += amount;
149         emit Transfer(address(0), account, amount);
150     }
151 
152     function _burn(
153         address account,
154         uint256 amount
155     ) internal virtual
156     {
157         require(account != address(0), "Burn from the zero address.");
158 
159         uint256 accountBalance = balances_[account];
160         require(accountBalance >= amount, "Burn amount exceeds balance.");
161         unchecked {
162             balances_[account] = accountBalance - amount;
163         }
164         totalSupply_ -= amount;
165 
166         emit Transfer(account, address(0), amount);
167     }
168 
169     function _approve(
170         address owner,
171         address spender,
172         uint256 amount
173     ) internal virtual
174     {
175         require(owner != address(0), "Approve from the zero address.");
176         require(spender != address(0), "Approve to the zero address.");
177 
178         allowances_[owner][spender] = amount;
179         emit Approval(owner, spender, amount);
180     }
181 
182     function _spendAllowance(
183         address owner,
184         address spender,
185         uint256 amount
186     ) internal virtual
187     {
188         uint256 currentAllowance = allowance(owner, spender);
189         if (currentAllowance != type(uint256).max) {
190             require(currentAllowance >= amount, "Insufficient allowance.");
191             unchecked {
192                 _approve(owner, spender, currentAllowance - amount);
193             }
194         }
195     }
196 
197     //// Context Functions ////
198     function _msgSender() internal view virtual returns (address) {
199         return msg.sender;
200     }
201 
202     function _msgData() internal view virtual returns (bytes calldata) {
203         return msg.data;
204     }
205 }