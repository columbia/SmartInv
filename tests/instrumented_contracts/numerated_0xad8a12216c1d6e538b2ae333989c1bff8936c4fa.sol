1 // SPDX-License-Identifier: MIT
2 
3 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&*#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#.,(.*&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%*..,(...(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(....,(....,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&,.....,(......(&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(.......,(........%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@%.........,(.........(&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
11 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&/..........,(...........%@@@@@@@@@@@@@@@@@@@@@@@@@@@
12 // @@@@@@@@@@@@@@@@@@@@@@@@@@#,...........,(............*&@@@@@@@@@@@@@@@@@@@@@@@@@
13 // @@@@@@@@@@@@@@@@@@@@@@@@&,.............,(..............%@@@@@@@@@@@@@@@@@@@@@@@@
14 // @@@@@@@@@@@@@@@@@@@@@@@#,..............,(...............*&@@@@@@@@@@@@@@@@@@@@@@
15 // @@@@@@@@@@@@@@@@@@@@@&*................,(.................(@@@@@@@@@@@@@@@@@@@@@
16 // @@@@@@@@@@@@@@@@@@@@(..................,(..................,&@@@@@@@@@@@@@@@@@@@
17 // @@@@@@@@@@@@@@@@@@&*...................,(....................(&@@@@@@@@@@@@@@@@@
18 // @@@@@@@@@@@@@@@@&(.....................,(......................%@@@@@@@@@@@@@@@@
19 // @@@@@@@@@@@@@@@%.......................,(......................./&@@@@@@@@@@@@@@
20 // @@@@@@@@@@@@@&/........................,(........................,%@@@@@@@@@@@@@
21 // @@@@@@@@@@@&%,.........................,(........................../&@@@@@@@@@@@
22 // @@@@@@@@@@&*.......................*/((*#*((*........................#@@@@@@@@@@
23 // @@@@@@@@@%....................*%(*******#,,,,,,*%(....................*&@@@@@@@@
24 // @@@@@@@&*...............*#(/************#,,,,,,,,,,,*/((................#@@@@@@@
25 // @@@@@@(...........,/#(******************#,,,,,,,,,,,,,,,,,*#(,...........,&@@@@@
26 // @@@@%,.......*%(/***********************#,,,,,,,,,,,,,,,,,,,,,,,*#(........#@@@@
27 // @@&(...*(#(*****************************#,,,,,,,,,,,,,,,,,,,,,,,,,,,,*((*...,%@@
28 // @%/#(***********************************#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*#(#@
29 // @@&#/***********************************#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(%@@
30 // @@@@@@&%(*******************************#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*#&@@@@@@
31 // @@@@@@@@@@@&#***************************#,,,,,,,,,,,,,,,,,,,,,,,,,,/%&@@@@@@@@@@
32 // @&&%@@@@@@@@@@@&#/**********************#,,,,,,,,,,,,,,,,,,,,,*(&@@@@@@@@@@@&%&@
33 // @@@&/.*%&@@@@@@@@@@&&(******************#,,,,,,,,,,,,,,,,,*%&@@@@@@@@@@&&(,,%@@@
34 // @@@@@%*...,(&&@@@@@@@@@@&#/*************#,,,,,,,,,,,,,/%&@@@@@@@@@@&%/,,,,#@@@@@
35 // @@@@@@@%,......(%&@@@@@@@@@@&%/*********#,,,,,,,,*(&&@@@@@@@@@@&#*,,,,,,(&@@@@@@
36 // @@@@@@@@@%........,*%&@@@@@@@@@@@&(*****#,,,,/%&@@@@@@@@@@@&(*,,,,,,,,(&@@@@@@@@
37 // @@@@@@@@@@&(...........*#&@@@@@@@@@@@&#/#(%@@@@@@@@@@@&%(,,,,,,,,,,,/&@@@@@@@@@@
38 // @@@@@@@@@@@@&/..............(&@@@@@@@@@@@@@@@@@@@@&%*,,,,,,,,,,,,,,%@@@@@@@@@@@@
39 // @@@@@@@@@@@@@@&*...............,/%&@@@@@@@@@@@&#*,,,,,,,,,,,,,,,,#@@@@@@@@@@@@@@
40 // @@@@@@@@@@@@@@@@&,..................*%&@@@%(,,,,,,,,,,,,,,,,,,,(&@@@@@@@@@@@@@@@
41 // @@@@@@@@@@@@@@@@@@%....................,#,,,,,,,,,,,,,,,,,,,,/&@@@@@@@@@@@@@@@@@
42 // @@@@@@@@@@@@@@@@@@@&(..................,#,,,,,,,,,,,,,,,,,,*&@@@@@@@@@@@@@@@@@@@
43 // @@@@@@@@@@@@@@@@@@@@@&/................,#,,,,,,,,,,,,,,,,,%@@@@@@@@@@@@@@@@@@@@@
44 // @@@@@@@@@@@@@@@@@@@@@@@&*..............,#,,,,,,,,,,,,,,,#@@@@@@@@@@@@@@@@@@@@@@@
45 // @@@@@@@@@@@@@@@@@@@@@@@@@%,............,#,,,,,,,,,,,,,(&@@@@@@@@@@@@@@@@@@@@@@@@
46 // @@@@@@@@@@@@@@@@@@@@@@@@@@@#...........,#,,,,,,,,,,,/&@@@@@@@@@@@@@@@@@@@@@@@@@@
47 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@&(.........,#,,,,,,,,,*&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
48 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&/.......,#,,,,,,,,%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
49 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&*.....,#,,,,,,#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
50 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%,...,#,,,,(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
51 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#..,#,,/&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
52 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(,#*&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
53 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
54 
55 pragma solidity ^0.8.0;
56 
57 interface IERC20 {
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(
60         address indexed owner,
61         address indexed spender,
62         uint256 value
63     );
64     function totalSupply() external view returns (uint256);
65     function balanceOf(address account) external view returns (uint256);
66     function transfer(address to, uint256 amount) external returns (bool);
67     function allowance(address owner, address spender)
68         external
69         view
70         returns (uint256);
71     function approve(address spender, uint256 amount) external returns (bool);
72     function transferFrom(
73         address from,
74         address to,
75         uint256 amount
76     ) external returns (bool);
77 }
78 
79 interface IERC20Metadata is IERC20 {
80     function name() external view returns (string memory);
81     function symbol() external view returns (string memory);
82     function decimals() external view returns (uint8);
83 }
84 
85 abstract contract Context {
86     function _msgSender() internal view virtual returns (address) {
87         return msg.sender;
88     }
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 contract ERC20 is Context, IERC20, IERC20Metadata {
95     mapping(address => uint256) private _balances;
96     mapping(address => mapping(address => uint256)) private _allowances;
97 
98     uint256 private _totalSupply;
99     string private _name;
100     string private _symbol;
101 
102     constructor(string memory name_, string memory symbol_) {
103         _name = name_;
104         _symbol = symbol_;
105     }
106 
107     function name() public view virtual override returns (string memory) {
108         return _name;
109     }
110 
111     function symbol() public view virtual override returns (string memory) {
112         return _symbol;
113     }
114 
115     function decimals() public view virtual override returns (uint8) {
116         return 18;
117     }
118 
119     function totalSupply() public view virtual override returns (uint256) {
120         return _totalSupply;
121     }
122 
123     function balanceOf(address account)
124         public
125         view
126         virtual
127         override
128         returns (uint256)
129     {
130         return _balances[account];
131     }
132 
133     function transfer(address to, uint256 amount)
134         public
135         virtual
136         override
137         returns (bool)
138     {
139         address owner = _msgSender();
140         _transfer(owner, to, amount);
141         return true;
142     }
143 
144     function allowance(address owner, address spender)
145         public
146         view
147         virtual
148         override
149         returns (uint256)
150     {
151         return _allowances[owner][spender];
152     }
153 
154     function approve(address spender, uint256 amount)
155         public
156         virtual
157         override
158         returns (bool)
159     {
160         address owner = _msgSender();
161         _approve(owner, spender, amount);
162         return true;
163     }
164 
165     function transferFrom(
166         address from,
167         address to,
168         uint256 amount
169     ) public virtual override returns (bool) {
170         address spender = _msgSender();
171         _spendAllowance(from, spender, amount);
172         _transfer(from, to, amount);
173         return true;
174     }
175 
176     function increaseAllowance(address spender, uint256 addedValue)
177         public
178         virtual
179         returns (bool)
180     {
181         address owner = _msgSender();
182         _approve(owner, spender, allowance(owner, spender) + addedValue);
183         return true;
184     }
185 
186     function decreaseAllowance(address spender, uint256 subtractedValue)
187         public
188         virtual
189         returns (bool)
190     {
191         address owner = _msgSender();
192         uint256 currentAllowance = allowance(owner, spender);
193         require(
194             currentAllowance >= subtractedValue,
195             "ERC20: decreased allowance below zero"
196         );
197         unchecked {
198             _approve(owner, spender, currentAllowance - subtractedValue);
199         }
200 
201         return true;
202     }
203 
204     function _transfer(
205         address from,
206         address to,
207         uint256 amount
208     ) internal virtual {
209         require(from != address(0), "ERC20: transfer from the zero address");
210         require(to != address(0), "ERC20: transfer to the zero address");
211 
212         _beforeTokenTransfer(from, to, amount);
213 
214         uint256 fromBalance = _balances[from];
215         require(
216             fromBalance >= amount,
217             "ERC20: transfer amount exceeds balance"
218         );
219         unchecked {
220             _balances[from] = fromBalance - amount;
221             _balances[to] += amount;
222         }
223 
224         emit Transfer(from, to, amount);
225 
226         _afterTokenTransfer(from, to, amount);
227     }
228 
229     function _mint(address account, uint256 amount) internal virtual {
230         require(account != address(0), "ERC20: mint to the zero address");
231 
232         _beforeTokenTransfer(address(0), account, amount);
233 
234         _totalSupply += amount;
235         unchecked {
236             _balances[account] += amount;
237         }
238         emit Transfer(address(0), account, amount);
239 
240         _afterTokenTransfer(address(0), account, amount);
241     }
242 
243     function _burn(address account, uint256 amount) internal virtual {
244         require(account != address(0), "ERC20: burn from the zero address");
245 
246         _beforeTokenTransfer(account, address(0), amount);
247 
248         uint256 accountBalance = _balances[account];
249         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
250         unchecked {
251             _balances[account] = accountBalance - amount;
252             _totalSupply -= amount;
253         }
254 
255         emit Transfer(account, address(0), amount);
256 
257         _afterTokenTransfer(account, address(0), amount);
258     }
259 
260     function _approve(
261         address owner,
262         address spender,
263         uint256 amount
264     ) internal virtual {
265         require(owner != address(0), "ERC20: approve from the zero address");
266         require(spender != address(0), "ERC20: approve to the zero address");
267 
268         _allowances[owner][spender] = amount;
269         emit Approval(owner, spender, amount);
270     }
271 
272     function _spendAllowance(
273         address owner,
274         address spender,
275         uint256 amount
276     ) internal virtual {
277         uint256 currentAllowance = allowance(owner, spender);
278         if (currentAllowance != type(uint256).max) {
279             require(
280                 currentAllowance >= amount,
281                 "ERC20: insufficient allowance"
282             );
283             unchecked {
284                 _approve(owner, spender, currentAllowance - amount);
285             }
286         }
287     }
288 
289     function _beforeTokenTransfer(
290         address from,
291         address to,
292         uint256 amount
293     ) internal virtual {}
294 
295     function _afterTokenTransfer(
296         address from,
297         address to,
298         uint256 amount
299     ) internal virtual {}
300 }
301 
302 contract MergeToken is ERC20 {
303     constructor() ERC20("The Merge", "MERGE") {
304         _mint(msg.sender, 1438269988 * 10**decimals());
305     }
306 }