1 /*
2 
3  ▄▄▄▄▄▄   ▄███▄      ▄▄▄▄▄      ▄▄▄▄▀ 
4 ▀   ▄▄▀   █▀   ▀    █     ▀▄ ▀▀▀ █    
5  ▄▀▀   ▄▀ ██▄▄    ▄  ▀▀▀▀▄       █    
6  ▀▀▀▀▀▀   █▄   ▄▀  ▀▄▄▄▄▀       █     
7           ▀███▀                ▀      
8 
9 Don't get squeezed.
10 */
11 pragma solidity ^0.5.2;
12 
13 library SafeMath {
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         require(c / a == b);
20         return c;
21     }
22 
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b > 0);
25         uint256 c = a / b;
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b <= a);
31         uint256 c = a - b;
32         return c;
33     }
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a);
38         return c;
39     }
40 
41     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b != 0);
43         return a % b;
44     }
45 }
46 
47 contract Ownable {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     constructor () internal {
53         _owner = msg.sender;
54         emit OwnershipTransferred(address(0), _owner);
55     }
56 
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     modifier onlyOwner() {
62         require(isOwner(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     function isOwner() public view returns (bool) {
67         return msg.sender == _owner;
68     }
69 
70     function renounceOwnership() public onlyOwner {
71         emit OwnershipTransferred(_owner, address(0));
72         _owner = address(0);
73     }
74 
75     function transferOwnership(address newOwner) public onlyOwner {
76         _transferOwnership(newOwner);
77     }
78 
79     function _transferOwnership(address newOwner) internal {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         emit OwnershipTransferred(_owner, newOwner);
82         _owner = newOwner;
83     }
84 }
85 
86 contract ERC20 is Ownable {
87     using SafeMath for uint256;
88     mapping (address => uint256) private _balances;
89     mapping (address => mapping (address => uint256)) private _allowed;
90     uint256 private _totalSupply;
91     
92     event Transfer(address indexed from, address indexed to, uint tokens);
93     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
94     
95     string public constant name = "Zest";
96     string public constant symbol = "Z";
97     uint8 public constant decimals = 18;
98     
99     bool minting;
100     
101     modifier currentlyMinting() {
102         require(minting);
103         _;
104     }
105     
106     constructor() public {
107         minting = true;
108     }
109 
110     function totalSupply() public view returns (uint256) {
111         return _totalSupply;
112     }
113 
114     function balanceOf(address account) public view returns (uint256) {
115         return _balances[account];
116     }
117 
118     function allowance(address account, address spender) public view returns (uint256) {
119         return _allowed[account][spender];
120     }
121 
122     function transfer(address to, uint256 value) public returns (bool) {
123         _transfer(msg.sender, to, value);
124         return true;
125     }
126 
127     function approve(address spender, uint256 value) public returns (bool) {
128         _approve(msg.sender, spender, value);
129         return true;
130     }
131 
132     function transferFrom(address from, address to, uint256 value) public returns (bool) {
133         _transfer(from, to, value);
134         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
135         return true;
136     }
137 
138     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
139         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
140         return true;
141     }
142 
143     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
144         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
145         return true;
146     }
147     
148     function mint(address to, uint256 value) public onlyOwner currentlyMinting returns (bool) {
149         _mint(to, value);
150         return true;
151     }
152     
153     function burn(uint256 value) public {
154         _burn(msg.sender, value);
155     }
156     
157     function burnFrom(address from, uint256 value) public {
158         _burnFrom(from, value);
159     }
160     
161     function endMinting() onlyOwner public {
162         minting = false;
163     }
164 
165     function _transfer(address from, address to, uint256 value) internal {
166         require(to != address(0));
167 
168         _balances[from] = _balances[from].sub(value);
169         _balances[to] = _balances[to].add(value);
170         emit Transfer(from, to, value);
171     }
172 
173     function _mint(address account, uint256 value) internal {
174         require(account != address(0));
175 
176         _totalSupply = _totalSupply.add(value);
177         _balances[account] = _balances[account].add(value);
178         emit Transfer(address(0), account, value);
179     }
180 
181     function _burn(address account, uint256 value) internal {
182         require(account != address(0));
183 
184         _totalSupply = _totalSupply.sub(value);
185         _balances[account] = _balances[account].sub(value);
186         emit Transfer(account, address(0), value);
187     }
188 
189     function _approve(address account, address spender, uint256 value) internal {
190         require(spender != address(0));
191         require(account != address(0));
192 
193         _allowed[account][spender] = value;
194         emit Approval(account, spender, value);
195     }
196 
197     function _burnFrom(address account, uint256 value) internal {
198         _burn(account, value);
199         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
200     }
201 }