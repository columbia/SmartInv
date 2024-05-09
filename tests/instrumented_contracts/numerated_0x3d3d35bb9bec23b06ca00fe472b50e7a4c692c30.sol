1 pragma solidity ^0.5.17;
2 
3 /*
4   _______                   ____  _____  
5  |__   __|                 |___ \|  __ \ 
6     | | ___  __ _ _ __ ___   __) | |  | |
7     | |/ _ \/ _` | '_ ` _ \ |__ <| |  | |
8     | |  __/ (_| | | | | | |___) | |__| |
9     |_|\___|\__,_|_| |_| |_|____/|_____/ 
10     
11 */
12 interface ERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address who) external view returns (uint256);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function transfer(address to, uint256 value) external returns (bool);
17     function approve(address spender, uint256 value) external returns (bool);
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 
24 interface ApproveAndCallFallBack {
25     function receiveApproval(address from, uint tokens, address token, bytes calldata data) external;
26 }
27 
28 
29 contract Presale {
30     mapping (address => uint256) public balances;
31     address[] public keys;
32     uint public initialTokens;
33 }
34 
35 
36 contract Team3D is ERC20 {
37     using SafeMath for uint256;
38 
39     mapping (address => uint256) private balances;
40     mapping (address => mapping (address => uint256)) private allowed;
41     string public constant name  = "Vidya";
42     string public constant symbol = "VIDYA";
43     uint8 public constant decimals = 18;
44 
45     address owner;
46     bool initialized;
47     uint256 startBlock;
48     uint256 _totalSupply = 50000000 * (10 ** 18);
49     Presale presale;
50 
51     modifier fairStart() {
52         require(block.number > startBlock + 5);
53         if (block.number < startBlock + 10) {
54             require(tx.gasprice <= 2000000000000);
55         }
56         _;
57     }
58 
59     function initialize(address _presaleAddr) public {
60         require(!initialized);
61         owner = tx.origin;
62         presale = Presale(_presaleAddr);
63         balances[tx.origin] = presale.initialTokens();
64         balances[msg.sender] =  _totalSupply - presale.initialTokens();
65         
66         startBlock = block.number;
67         initialized = true;
68 
69         emit Transfer(address(0), tx.origin, presale.initialTokens());
70         emit Transfer(address(0), msg.sender, _totalSupply - presale.initialTokens());
71     }
72 
73     function distributePresale(uint _min, uint _max) public {
74         require(msg.sender==owner);
75         for (uint i=_min; i < _max; i++) {
76             address _addr = presale.keys(i);
77             transfer(_addr, presale.balances(_addr));
78             }
79         }
80 
81     function totalSupply() public view returns (uint256) {
82         return _totalSupply;
83     }
84 
85     function balanceOf(address addr) public view returns (uint256) {
86         return balances[addr];
87     }
88 
89     function allowance(address addr, address spender) public view returns (uint256) {
90         return allowed[addr][spender];
91     }
92 
93     function transfer(address to, uint256 value) public fairStart returns (bool) {
94         require(value <= balances[msg.sender]);
95         require(to != address(0));
96 
97         balances[msg.sender] = balances[msg.sender].sub(value);
98         balances[to] = balances[to].add(value);
99 
100         emit Transfer(msg.sender, to, value);
101         return true;
102     }
103 
104     function approve(address spender, uint256 value) public returns (bool) {
105         require(spender != address(0));
106         allowed[msg.sender][spender] = value;
107         emit Approval(msg.sender, spender, value);
108         return true;
109     }
110 
111     function approveAndCall(address spender, uint256 tokens, bytes calldata data) external returns (bool) {
112         allowed[msg.sender][spender] = tokens;
113         emit Approval(msg.sender, spender, tokens);
114         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
115         return true;
116     }
117 
118     function transferFrom(address from, address to, uint256 value) public returns (bool) {
119         require(value <= balances[from]);
120         require(value <= allowed[from][msg.sender]);
121         require(to != address(0));
122 
123         balances[from] = balances[from].sub(value);
124         balances[to] = balances[to].add(value);
125 
126         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
127 
128         emit Transfer(from, to, value);
129         return true;
130     }
131 
132     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
133         require(spender != address(0));
134         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
135         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
136         return true;
137     }
138 
139     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
140         require(spender != address(0));
141         allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
142         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
143         return true;
144     }
145 
146 }
147 
148 library SafeMath {
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         if (a == 0) {
151           return 0;
152         }
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155         return c;
156     }
157 
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         uint256 c = a / b;
160         return c;
161     }
162 
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b <= a, "SafeMath: subtraction overflow");
165         return a - b;
166     }
167 
168     function add(uint256 a, uint256 b) internal pure returns (uint256) {
169         uint256 c = a + b;
170         require(c >= a, "SafeMath: addition overflow");
171         return c;
172     }
173 }