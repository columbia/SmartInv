1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.2;
3 
4 library SafeMath {
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         require(b <= a, "SafeMath: subtraction overflow");
14         uint256 c = a - b;
15 
16         return c;
17     }
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26 
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0, "SafeMath: division by zero");
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39 }
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed from, address indexed _to);
46 
47     constructor(address _owner) {
48         owner = _owner;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) external onlyOwner {
57         newOwner = _newOwner;
58     }
59     function acceptOwnership() external {
60         require(msg.sender == newOwner);
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 abstract contract Pausable is Owned {
68     event Pause();
69     event Unpause();
70 
71     bool public paused = false;
72 
73     modifier whenNotPaused() {
74       require(!paused, "all transaction has been paused");
75       _;
76     }
77 
78     modifier whenPaused() {
79       require(paused, "transaction is current opened");
80       _;
81     }
82 
83     function pause() onlyOwner whenNotPaused external {
84       paused = true;
85       emit Pause();
86     }
87 
88     function unpause() onlyOwner whenPaused external {
89       paused = false;
90       emit Unpause();
91     }
92 }
93 
94 interface IERC20 {
95     function totalSupply() external view returns (uint256);
96     
97     function balanceOf(address account) external view returns (uint256);
98     
99     function transfer(address recipient, uint256 amount) external returns (bool);
100     
101     function allowance(address owner, address spender) external view returns (uint256);
102 
103     function approve(address spender, uint256 amount) external returns (bool);
104 
105     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
106 
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 abstract contract ERC20 is IERC20, Pausable {
113     using SafeMath for uint256;
114 
115     mapping (address => uint256) private _balances;
116 
117     mapping (address => mapping (address => uint256)) private _allowances;
118 
119     uint256 private _totalSupply;
120 
121     function totalSupply() public override view returns (uint256) {
122         return _totalSupply;
123     }
124 
125     function balanceOf(address account) public override view returns (uint256) {
126         return _balances[account];
127     }
128 
129     function allowance(address owner, address spender) public override view returns (uint256) {
130         return _allowances[owner][spender];
131     }
132 
133     function approve(address spender, uint256 value) public override returns (bool) {
134         _approve(msg.sender, spender, value);
135         return true;
136     }
137 
138     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
139         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
140         return true;
141     }
142 
143     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
144         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
145         return true;
146     }
147 
148     function _transfer(address sender, address recipient, uint256 amount) internal {
149         require(sender != address(0), "ERC20: transfer from the zero address");
150         require(recipient != address(0), "ERC20: transfer to the zero address");
151 
152         _balances[sender] = _balances[sender].sub(amount);
153         _balances[recipient] = _balances[recipient].add(amount);
154         emit Transfer(sender, recipient, amount);
155     }
156 
157     function _mint(address account, uint256 amount) internal {
158         require(account != address(0), "ERC20: mint to the zero address");
159 
160         _totalSupply = _totalSupply.add(amount);
161         _balances[account] = _balances[account].add(amount);
162         emit Transfer(address(0), account, amount);
163     }
164 
165     function _burn(address account, uint256 value) internal {
166         require(account != address(0), "ERC20: burn from the zero address");
167 
168         _totalSupply = _totalSupply.sub(value);
169         _balances[account] = _balances[account].sub(value);
170         emit Transfer(account, address(0), value);
171     }
172 
173     function _transferFrom(address sender, address recipient, uint256 amount) internal whenNotPaused returns (bool) {
174         _transfer(sender, recipient, amount);
175         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
176         return true;
177     }
178 
179     function _approve(address owner, address spender, uint256 value) internal {
180         require(owner != address(0), "ERC20: approve from the zero address");
181         require(spender != address(0), "ERC20: approve to the zero address");
182 
183         _allowances[owner][spender] = value;
184         emit Approval(owner, spender, value);
185     }
186 
187 }
188 
189 contract SimpleCoin is ERC20 {
190 
191     using SafeMath for uint256;
192     string  public  name;
193     string  public  symbol;
194     uint8   public decimals;
195 
196     uint256 public totalMinted;
197     uint256 public totalBurnt;
198 
199     constructor(string memory _name, string memory _symbol) Owned(msg.sender) {
200         name = _name;
201         symbol = _symbol;
202         decimals = 18;
203         _mint(msg.sender, 1000 ether);
204         totalMinted = totalSupply();
205         totalBurnt = 0;
206     }
207     
208     function burn(uint256 _amount) external whenNotPaused returns (bool) {
209        super._burn(msg.sender, _amount);
210        totalBurnt = totalBurnt.add(_amount);
211        return true;
212    }
213 
214     function transfer(address _recipient, uint256 _amount) public override whenNotPaused returns (bool) {
215         if(totalSupply() <= 500 ether) {
216             super._transfer(msg.sender, _recipient, _amount);
217             return true;
218         }
219         
220         uint _amountToBurn = _amount.mul(3).div(100);
221         _burn(msg.sender, _amountToBurn);
222         totalBurnt = totalBurnt.add(_amountToBurn);
223         uint _unBurntToken = _amount.sub(_amountToBurn);
224         super._transfer(msg.sender, _recipient, _unBurntToken);
225         return true;
226     }
227 
228     function transferFrom(address _sender, address _recipient, uint256 _amount) public override whenNotPaused returns (bool) {
229         super._transferFrom(_sender, _recipient, _amount);
230         return true;
231     }
232     
233     function mint(address _account, uint _amount) external onlyOwner {
234         totalMinted = totalMinted.add(_amount);
235         super._mint(_account, _amount);
236     }
237     
238     receive() external payable {
239         uint _amount = msg.value;
240         msg.sender.transfer(_amount);
241     }
242 }