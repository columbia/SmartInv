1 pragma solidity 0.5.10;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
30     uint256 c = add(a,m);
31     uint256 d = sub(c,1);
32     return mul(div(d,m),m);
33   }
34 }
35 
36 
37 interface IERC20 {
38 
39     function totalSupply() external view returns (uint256);
40 
41     function balanceOf(address account) external view returns (uint256);
42 
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 
57 contract MaxumToken is IERC20 {
58     using SafeMath for uint256;
59 
60     mapping (address => uint256) private _balances;
61 
62     mapping (address => mapping (address => uint256)) private _allowances;
63 
64     uint256 public _burnRate;
65     uint256 private _totalSupply;
66     
67 
68     string public constant name = "Maxum";
69     string public constant symbol = "MUM";
70     uint256 public constant decimals = 0;
71 
72     uint256 public constant INITIAL_SUPPLY = 200000000000 * 10**decimals;
73 
74   /**
75    * @dev Contructor
76    */
77   constructor() public {
78     _totalSupply = INITIAL_SUPPLY;
79     _balances[0x7C1A414C71D2dCc7440901c0Adf49c34039E496b ] = INITIAL_SUPPLY;
80     emit Transfer(address(0), 0x7C1A414C71D2dCc7440901c0Adf49c34039E496b ,_totalSupply);
81     
82   }
83 
84 
85     function totalSupply() public view returns (uint256) {
86         return _totalSupply;
87     }
88 
89 
90     function balanceOf(address account) public view returns (uint256) {
91         return _balances[account];
92     }
93 
94     function transfer(address recipient, uint256 amount) public returns (bool) {
95         _transfer(msg.sender, recipient, amount);
96         return true;
97     }
98 
99 
100     function allowance(address owner, address spender) public view returns (uint256) {
101         return _allowances[owner][spender];
102     }
103 
104 
105     function approve(address spender, uint256 value) public returns (bool) {
106         _approve(msg.sender, spender, value);
107         return true;
108     }
109 
110     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
111         _transfer(sender, recipient, amount);
112         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
113         return true;
114     }
115 
116 
117     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
118         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
119         return true;
120     }
121 
122 
123     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
124         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
125         return true;
126     }
127 
128 
129     function _transfer(address sender, address recipient, uint256 amount) internal {
130         require(sender != address(0), "ERC20: transfer from the zero address");
131         require(recipient != address(0), "ERC20: transfer to the zero address");
132         
133         
134         uint256 tokensToBurn = _tokenToBurn(amount);
135         uint256 tokensToTransfer = amount.sub(tokensToBurn);
136         
137         _balances[sender] = _balances[sender].sub(amount);
138         _balances[recipient] = _balances[recipient].add(tokensToTransfer);
139 
140         _totalSupply = _totalSupply.sub(tokensToBurn);
141         
142         emit Transfer(sender, recipient, tokensToTransfer);
143         emit Transfer(sender, address(0), tokensToBurn);
144     }
145     
146 
147     function _approve(address owner, address spender, uint256 value) internal {
148         require(owner != address(0), "ERC20: approve from the zero address");
149         require(spender != address(0), "ERC20: approve to the zero address");
150 
151         _allowances[owner][spender] = value;
152         emit Approval(owner, spender, value);
153     }
154 
155     
156     function burnRate() public returns(uint256) {
157         if (_totalSupply > 180000000000) {
158             _burnRate = 2;
159         } else if(_totalSupply <= 180000000000 && _totalSupply > 160000000000) {
160             _burnRate = 4;
161         } else if(_totalSupply <= 160000000000 && _totalSupply > 140000000000) {
162             _burnRate = 6;
163         } else if(_totalSupply <= 140000000000 && _totalSupply > 120000000000) {
164             _burnRate = 8;
165         } else if(_totalSupply <= 120000000000 && _totalSupply > 100000000000) {
166             _burnRate = 10;
167         } else if(_totalSupply <= 100000000000 && _totalSupply > 80000000000) {
168             _burnRate = 12;
169         } else if(_totalSupply <= 80000000000 && _totalSupply > 60000000000) {
170             _burnRate = 14;
171         } else if(_totalSupply <= 60000000000 && _totalSupply > 30000000000) {
172             _burnRate = 16;
173         } else if(_totalSupply <= 30000000000 && _totalSupply > 10000000000) {
174             _burnRate = 20;
175         }  else if(_totalSupply <= 10000000000 && _totalSupply > 1000000000) {
176             _burnRate = 24;
177         } else if(_totalSupply <= 1000000000) {
178             _burnRate = 30;
179         } 
180         
181         return _burnRate;
182     }
183 
184     
185     function _tokenToBurn(uint256 value) public returns(uint256){ 
186         uint256 _burnerRate = burnRate();
187         uint256 roundValue = value.ceil(_burnerRate);
188         uint256 _myTokensToBurn = roundValue.mul(_burnerRate).div(100);
189         return _myTokensToBurn;
190     }
191     
192 }