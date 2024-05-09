1 pragma solidity ^0.5.16;
2 
3 // interface ERC20 {
4 //   function totalSupply() external view returns (uint256);
5 //   function balanceOf(address who) external view returns (uint256);
6 //   function allowance(address owner, address spender) external view returns (uint256);
7 //   function transfer(address to, uint256 value) external returns (bool);
8 //   function approve(address spender, uint256 value) external returns (bool);
9 // //   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
10 //   function transferFrom(address from, address to, uint256 value) external returns (bool);
11 
12 //   event Transfer(address indexed from, address indexed to, uint256 value);
13 //   event Approval(address indexed owner, address indexed spender, uint256 value);
14 // }
15 
16 // interface ApproveAndCallFallBack {
17 //     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
18 // }
19 
20 contract owned {
21     address  payable public owner;
22     address payable internal newOwner;
23 
24     event OwnershipTransferred(address indexed _from, address indexed _to);
25 
26     constructor() public {
27         owner = msg.sender;
28         emit OwnershipTransferred(address(0), owner);
29     }
30 
31     modifier onlyOwner {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function transferOwnership(address payable _newOwner) public onlyOwner {
37         newOwner = _newOwner;
38     }
39 
40     //this flow is to prevent transferring ownership to wrong wallet by mistake
41     function acceptOwnership() public {
42         require(msg.sender == newOwner);
43         emit OwnershipTransferred(owner, newOwner);
44         owner = newOwner;
45         newOwner = address(0);
46     }
47 }
48 
49 
50 contract UniTopia is owned {
51   using SafeMath for uint256;
52   
53   bool public safeGuard=false;
54 
55   mapping (address => uint256) private balances;
56   mapping (address => mapping (address => uint256)) private allowed;
57   string public constant name  = "UniTopia";
58   string public constant symbol = "uTOPIA";
59   uint8 public constant decimals = 18;
60   
61 //   address owner = msg.sender;
62 
63   uint256 public _totalSupply;
64   uint256 public tokenPrice;
65   uint256 public soldTokens;
66   
67   mapping(address=>uint256) public Pool;
68   
69   event Transfer(address indexed from, address indexed to, uint256 value);
70   event TransferPoolamount(address _from, address _to, uint256 _ether);
71   event Approval(address _from, address _spender, uint256 _tokenAmt);
72 
73   constructor(uint256 _supply,uint256 _price) public {
74      _totalSupply= _supply * (10 ** 18);
75      tokenPrice=_price;
76     //balances[msg.sender] = _totalSupply;
77     //emit Transfer(address(0), msg.sender, _totalSupply);
78   }
79   
80   
81   function buyToken() payable public returns(bool)
82   {
83       require(msg.value!=0,"Invalid Amount");
84       
85       uint256 one=10**18/tokenPrice;
86       
87       uint256 tknAmount=one*msg.value;
88       
89       require(soldTokens.add(tknAmount)<=_totalSupply,"Token Not Available");
90       
91       balances[msg.sender]+=tknAmount;
92       //_totalSupply-=tknAmount;
93       Pool[owner]+=msg.value;
94       soldTokens+=tknAmount;
95       
96       emit Transfer(address(this),msg.sender,tknAmount);
97   }
98   
99   function withDraw() public onlyOwner{
100       
101       require(Pool[owner]!=0,"No Ether Available");
102       owner.transfer(Pool[owner]);
103       
104       emit TransferPoolamount(address(this),owner,Pool[owner]);
105       Pool[owner]=0;
106   }
107   
108   function tokenSold() public view returns(uint256)
109   {
110       return soldTokens;
111   }
112   
113   function totalEther() public view returns(uint256)
114   {
115       return Pool[owner];
116   }
117   
118   function availableToken() public view returns(uint256)
119   {
120       return _totalSupply.sub(soldTokens);
121   }
122 
123   function totalSupply() public view returns (uint256) {
124     return _totalSupply;
125   }
126 
127   function balanceOf(address player) public view returns (uint256) {
128     return balances[player];
129   }
130 
131   function allowance(address player, address spender) public view returns (uint256) {
132     return allowed[player][spender];
133   }
134 
135 
136   function transfer(address to, uint256 value) public returns (bool) {
137     require(safeGuard==true,'Transfer Is Not Available');
138     require(value <= balances[msg.sender]);
139     require(to != address(0));
140 
141     balances[msg.sender] = balances[msg.sender].sub(value);
142     balances[to] = balances[to].add(value);
143 
144     emit Transfer(msg.sender, to, value);
145     return true;
146   }
147 
148   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
149     for (uint256 i = 0; i < receivers.length; i++) {
150       transfer(receivers[i], amounts[i]);
151     }
152   }
153 
154   function approve(address spender, uint256 value) public returns (bool) {
155     require(spender != address(0));
156     allowed[msg.sender][spender] = value;
157     emit Approval(msg.sender, spender, value);
158     return true;
159   }
160 
161 //   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
162 //         allowed[msg.sender][spender] = tokens;
163 //         emit Approval(msg.sender, spender, tokens);
164 //         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
165 //         return true;
166 //     }
167 
168   function transferFrom(address from, address to, uint256 value) public returns (bool) {
169     require(value <= balances[from]);
170     require(value <= allowed[from][msg.sender]);
171     require(to != address(0));
172     
173     balances[from] = balances[from].sub(value);
174     balances[to] = balances[to].add(value);
175     
176     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
177     
178     emit Transfer(from, to, value);
179     return true;
180   }
181 
182   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
183     require(spender != address(0));
184     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
185     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
186     return true;
187   }
188 
189   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
190     require(spender != address(0));
191     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
192     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
193     return true;
194   }
195 
196   function burn(uint256 amount) external {
197     require(amount != 0);
198     require(amount <= balances[msg.sender]);
199     _totalSupply = _totalSupply.sub(amount);
200     balances[msg.sender] = balances[msg.sender].sub(amount);
201     emit Transfer(msg.sender, address(0), amount);
202   }
203   
204   function changeSafeGuard() public onlyOwner{
205       safeGuard=true;
206   }
207 
208 }
209 
210 
211 
212 
213 library SafeMath {
214   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
215     if (a == 0) {
216       return 0;
217     }
218     uint256 c = a * b;
219     require(c / a == b);
220     return c;
221   }
222 
223   function div(uint256 a, uint256 b) internal pure returns (uint256) {
224     uint256 c = a / b;
225     return c;
226   }
227 
228   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229     require(b <= a);
230     return a - b;
231   }
232 
233   function add(uint256 a, uint256 b) internal pure returns (uint256) {
234     uint256 c = a + b;
235     require(c >= a);
236     return c;
237   }
238 
239   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
240     uint256 c = add(a,m);
241     uint256 d = sub(c,1);
242     return mul(div(d,m),m);
243   }
244 }