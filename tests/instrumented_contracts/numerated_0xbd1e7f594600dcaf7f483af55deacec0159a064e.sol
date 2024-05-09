1 pragma solidity ^0.5.0;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     constructor() internal {
9         _owner = msg.sender;
10         emit OwnershipTransferred(address(0), _owner);
11     }
12 
13     modifier onlyOwner() {
14         require(isOwner(), "Ownable: caller is not the owner");
15         _;
16     }
17 
18     function isOwner() public view returns (bool) {
19         return msg.sender == _owner;
20     }    
21 
22     function owner() public view returns (address) {
23         return _owner;
24     }
25 
26     function transferOwnership(address newOwner) public onlyOwner {
27         require(newOwner != address(0), "Ownable: new owner is the zero address");
28         emit OwnershipTransferred(_owner, newOwner);
29         _owner = newOwner;
30     }
31 }
32 
33 
34 library SafeMath {
35     function mul(uint a, uint b) internal pure returns (uint) {
36         uint c = a * b;
37         assert(a == 0 || c / a == b);
38         return c;
39     }
40 
41     function div(uint a, uint b) internal pure returns (uint) {
42         assert(b > 0);
43         uint c = a / b;
44         assert(a == b * c + a % b);
45         return c;
46     }
47 
48     function sub(uint a, uint b) internal pure returns (uint) {
49         assert(b <= a);
50         return a - b;
51     }
52 
53     function add(uint a, uint b) internal pure returns (uint) {
54         uint c = a + b;
55         assert(c >= a);
56         return c;
57     }
58 }
59 
60 contract Pausable is Ownable {
61     bool private _paused;
62 
63     event Paused(address account);
64     event Unpaused(address account);
65 
66     constructor () internal {
67         _paused = false;
68     }
69 
70     function paused() public view returns (bool) {
71         return _paused;
72     }
73 
74     modifier whenNotPaused() {
75         require(!_paused, "Pausable: paused");
76         _;
77     }
78 
79     modifier whenPaused() {
80         require(_paused, "Pausable: not paused");
81         _;
82     }
83 
84     function pause() public onlyOwner whenNotPaused {
85         _paused = true;
86         emit Paused(msg.sender);
87     }
88 
89     function unpause() public onlyOwner whenPaused {
90         _paused = false;
91         emit Unpaused(msg.sender);
92     }    
93 }
94 
95 contract EIP20Interface {
96     function transfer(address to, uint256 value) public returns (bool);
97     function approve(address spender, uint256 value) public returns (bool);
98     function transferFrom(address from, address to, uint256 value) public returns (bool);
99     function totalSupply() public view returns (uint256);
100     function balanceOf(address who) public view returns (uint256);
101     function allowance(address owner, address spender) public view returns (uint256);
102     
103     event Transfer(address indexed from, address indexed to, uint256 value);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 contract ERC20 is Ownable, Pausable, EIP20Interface {
109     using SafeMath for uint256;
110     
111     uint256 private _totalSupply;
112     string private _name;
113     string private _symbol;
114     uint8 private _decimals;
115     
116     
117     mapping (address => uint256) private _balances;
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     constructor() public {
121         _name = "Qobit.com Token";
122         _symbol = "QOB";
123         _decimals = 8;
124         _totalSupply = 1500000000 * 10 ** uint256(_decimals);
125         _balances[msg.sender] = _totalSupply;
126     }
127     
128     // erc20
129     function totalSupply() public view returns (uint256) {
130         return _totalSupply;
131     }
132 
133     function balanceOf(address owner) public view returns (uint256) {
134         return _balances[owner];
135     }
136 
137     function allowance(address owner, address spender) public view returns (uint256) {
138         return _allowed[owner][spender];
139     }    
140 
141     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
142         _transfer(msg.sender, to, value);
143         return true;
144     }
145 
146     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
147         require(value > 0);
148         _approve(msg.sender, spender, value);
149         return true;
150     }    
151 
152     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
153         _transfer(from, to, value);
154         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
155         return true;
156     }
157 
158     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
159         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
160         return true;
161     }
162 
163     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
164         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
165         return true;
166     }    
167     
168     function _transfer(address from, address to, uint256 value) internal {
169         require(to != address(0), "ERC20: transfer to the zero address");
170         
171         _balances[from] = _balances[from].sub(value);
172         _balances[to] = _balances[to].add(value);
173         emit Transfer(from, to, value);
174     }
175 
176     function _approve(address owner, address spender, uint256 value) internal {
177         require(owner != address(0), "ERC20: approve from the zero address");
178         require(spender != address(0), "ERC20: approve to the zero address");
179 
180         _allowed[owner][spender] = value;
181         emit Approval(owner, spender, value);
182     }    
183     
184     // details
185     function name() public view returns (string memory) {
186         return _name;
187     }
188 
189     function symbol() public view returns (string memory) {
190         return _symbol;
191     }
192 
193     function decimals() public view returns (uint8) {
194         return _decimals;
195     }
196 }