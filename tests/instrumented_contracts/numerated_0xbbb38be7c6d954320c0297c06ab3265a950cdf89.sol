1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-11
3 */
4 
5 pragma solidity ^0.6.8;
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
34     uint256 c = add(a,m);
35     uint256 d = sub(c,1);
36     return mul(div(d,m),m);
37   }
38 }
39 
40 abstract contract ERC20Token {
41   function approve(address spender, uint256 value) public virtual returns (bool);
42   function transferFrom (address from, address to, uint value) public virtual returns (bool);
43 }
44 
45 contract Ownable {
46     address public owner;
47 
48     event TransferOwnership(address _from, address _to);
49 
50     constructor() public {
51         owner = msg.sender;
52         emit TransferOwnership(address(0), msg.sender);
53     }
54 
55     modifier onlyOwner() {
56         require(msg.sender == owner, "only owner");
57         _;
58     }
59 
60     function setOwner(address _owner) external onlyOwner {
61         emit TransferOwnership(owner, _owner);
62         owner = _owner;
63     }
64 }
65 
66 contract WrappedBOMB is Ownable {
67    
68     using SafeMath for uint256;
69   
70     string public name     = "Wrapped BOMB";
71     string public symbol   = "WBOMB";
72     uint8  public decimals = 0;
73     
74     address BOMB_CONTRACT = 0x1C95b093d6C236d3EF7c796fE33f9CC6b8606714;
75     
76     uint256 public _totalSupply = 0;
77     uint256 basePercent = 100;
78     
79     event Approval(address indexed src, address indexed guy, uint256 amount);
80     event Transfer(address indexed src, address indexed to, uint256 amount);
81     event Deposit(address indexed to, uint256 amount);
82     event Withdrawal(address indexed src, uint256 amount);
83     event WhitelistFrom(address _addr, bool _whitelisted);
84     event WhitelistTo(address _addr, bool _whitelisted);
85     
86 
87     mapping (address => uint256)                       public  balanceOf;
88     mapping (address => mapping (address => uint256))  public  allowance;
89     
90  
91     mapping(address => bool) public whitelistFrom;
92     mapping(address => bool) public whitelistTo;
93 
94     fallback()  external payable {
95         revert();
96     }
97     
98     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
99         return whitelistFrom[_from]||whitelistTo[_to];
100     }
101 
102     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
103         emit WhitelistTo(_addr, _whitelisted);
104         whitelistTo[_addr] = _whitelisted;
105     }
106 
107     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
108         emit WhitelistFrom(_addr, _whitelisted);
109         whitelistFrom[_addr] = _whitelisted;
110     }
111     
112     function deposit(uint256 amount) public returns(uint256){ //deposit burn is intrinsic to BOMB
113     
114         require(ERC20Token(BOMB_CONTRACT).transferFrom(address(msg.sender),address(this),amount),"TransferFailed");
115             
116         //calc actual deposit amount due to BOMB burn
117         uint256 tokensToBurn = findOnePercent(amount);
118         uint256 actual = amount.sub(tokensToBurn);
119         
120         balanceOf[msg.sender] += actual;
121         _totalSupply += actual;
122         emit Deposit(msg.sender, amount);
123         emit Transfer(address(this), address(msg.sender), actual);
124         return actual;
125         
126         
127     }
128     
129     function withdraw(uint256 amount) public returns(uint256){ //
130         require(balanceOf[msg.sender] >= amount,"NotEnoughBalance");
131         balanceOf[msg.sender] -= amount;
132         _totalSupply -= amount;
133         emit Withdrawal(msg.sender, amount);
134         emit Transfer(address(msg.sender), address(this), amount);
135         ERC20Token(BOMB_CONTRACT).approve(address(this),amount);
136         ERC20Token(BOMB_CONTRACT).transferFrom(address(this),address(msg.sender),amount);
137         return amount;
138         
139     }
140 
141     function totalSupply() public view returns (uint256) {
142         return _totalSupply;
143     }
144 
145     function approve(address guy, uint256 amount) public returns (bool) {
146         allowance[msg.sender][guy] = amount;
147         emit Approval(msg.sender, guy, amount);
148         return true;
149     }
150 
151     function transfer(address to, uint256 amount) public returns (bool) { //unibombs
152         return transferFrom(msg.sender, to, amount);
153     }
154     
155     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
156         for (uint256 i = 0; i < receivers.length; i++) {
157             transfer(receivers[i], amounts[i]);
158         }
159     }
160     
161     function findOnePercent(uint256 value) public view returns (uint256)  {
162         uint256 roundValue = value.ceil(basePercent);
163         uint256 onePercent = roundValue.mul(basePercent).div(10000);
164         return onePercent;
165     }
166     
167     function transferFrom(address from, address to, uint256 value) public returns (bool) {
168         require(value <= balanceOf[from],"NotEnoughBalance");
169 
170         if (from != msg.sender && allowance[from][msg.sender] != uint(-1)) {
171             require(allowance[from][msg.sender] >= value);
172             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
173         }
174         
175         balanceOf[from] = balanceOf[from].sub(value);
176 
177         if(!_isWhitelisted(from, to)){
178             uint256 tokensToBurn = findOnePercent(value);
179             uint256 tokensToTransfer = value.sub(tokensToBurn);
180 
181             balanceOf[to] = balanceOf[to].add(tokensToTransfer);
182             _totalSupply = _totalSupply.sub(tokensToBurn);
183 
184             emit Transfer(from, to, tokensToTransfer);
185             emit Transfer(from, address(0), tokensToBurn);
186             ERC20Token(BOMB_CONTRACT).approve(address(this),value);
187             ERC20Token(BOMB_CONTRACT).transferFrom(address(this),address(this),value); //burn
188             //
189             }
190         
191         else{
192           //  uint256 tokensToTransfer = .sub(tokensToBurn);
193 
194             balanceOf[to] = balanceOf[to].add(value);
195             
196             emit Transfer(from, to, value);
197        }
198         return true;
199     }
200     
201     
202     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
203         require(spender != address(0));
204         allowance[msg.sender][spender] = (allowance[msg.sender][spender].add(addedValue));
205         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
206         return true;
207     }
208 
209     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
210         require(spender != address(0));
211         allowance[msg.sender][spender] = (allowance[msg.sender][spender].sub(subtractedValue));
212         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
213         return true;
214     }
215 
216     function burn(uint256 amount) external {
217         _burn(msg.sender, amount);
218     }
219 
220     function _burn(address account, uint256 amount) internal {
221         require(amount != 0);
222         require(amount <= balanceOf[account]);
223         _totalSupply = _totalSupply.sub(amount);
224         balanceOf[account] = balanceOf[account].sub(amount);
225         emit Transfer(account, address(0), amount);
226     }
227 
228     function burnFrom(address account, uint256 amount) external {
229         require(amount <= allowance[account][msg.sender]);
230         allowance[account][msg.sender] = allowance[account][msg.sender].sub(amount);
231         _burn(account, amount);
232     }
233 
234 }