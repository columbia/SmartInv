1 pragma solidity ^0.6.6;
2 
3 abstract contract ERC20Interface {
4     
5     address public _owner;
6     
7     modifier onlyOwner() {
8         require(_owner == msg.sender, "Ownable: caller is not the owner");
9         _;
10     }
11     
12     function totalSupply() virtual public view returns (uint);
13     function balanceOf(address tokenOwner) virtual public view returns (uint balance);
14     function allowance(address tokenOwner, address spender) virtual public view returns (uint remaining);
15     function transfer(address to, uint tokens) virtual public returns (bool success);
16     function approve(address spender, uint tokens) virtual public returns (bool success);
17     function transferFrom(address from, address to, uint tokens) virtual public returns (bool success);
18     
19     event Transfer(address indexed from, address indexed to, uint tokens);
20     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
21     
22 }
23 
24 contract SafeMath {
25     
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31     
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35     
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41     
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50     
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54     
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60     
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         return mod(a, b, "SafeMath: modulo by zero");
63     }
64     
65     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b != 0, errorMessage);
67         return a % b;
68     }
69     
70 }
71 
72 contract Orbicular is ERC20Interface, SafeMath {
73     
74     string public name;
75     string public symbol;
76     uint8 public decimals;
77     uint private _totalSupply;
78     uint256 private constant DECIMALS = 9;
79     uint256 private constant MAX_UINT256 = ~uint256(0);
80     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 10**8 * 10**DECIMALS;
81     uint256 private _gonsPerFragment;
82     uint private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
83     uint256 private constant MAX_SUPPLY = ~uint128(0);
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86     
87     constructor() public {
88         name = "Orbicular";
89         symbol = "ORBI";
90         decimals = 9;
91         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
92         balances[msg.sender] = TOTAL_GONS;
93         _owner = msg.sender;
94         _gonsPerFragment = div(TOTAL_GONS, _totalSupply);
95         emit Transfer(address(0), msg.sender, _totalSupply);
96     }
97     
98     function rebase(uint256 epoch, uint256 supplyDelta, bool sub0add1) external onlyOwner returns (uint256) {
99         if (supplyDelta == 0) {
100             emit LogRebase(epoch, _totalSupply);
101             return _totalSupply;
102         }
103         
104         if (sub0add1 == false) {
105             _totalSupply = sub(_totalSupply, supplyDelta);
106         }
107         
108         if (sub0add1 == true) {
109             _totalSupply = add(_totalSupply, supplyDelta);
110         }
111         
112         if (_totalSupply > MAX_SUPPLY) {
113             _totalSupply = MAX_SUPPLY;
114         }
115 
116         _gonsPerFragment = div(TOTAL_GONS, _totalSupply);
117 
118         emit LogRebase(epoch, _totalSupply);
119         return _totalSupply;
120     }
121     
122     function totalSupply() override public view returns (uint) {
123         return _totalSupply - balances[address(0)];
124     }
125     
126     function balanceOf(address who) override public view returns (uint256) {
127         return div(balances[who], _gonsPerFragment);
128     }
129 
130     function transfer(address to, uint256 value) override public returns (bool) {
131         uint256 gonValue = mul(value, _gonsPerFragment);
132         balances[msg.sender] = sub(balances[msg.sender], gonValue);
133         balances[to] = add(balances[to], gonValue);
134         emit Transfer(msg.sender, to, value);
135         return true;
136     }
137 
138     function allowance(address owner_, address spender) override public view returns (uint256) {
139         return allowed[owner_][spender];
140     }
141 
142     function transferFrom(address from, address to, uint256 value) override public returns (bool) {
143         allowed[from][msg.sender] = sub(allowed[from][msg.sender], value);
144 
145         uint256 gonValue = mul(value, _gonsPerFragment);
146         balances[from] = sub(balances[from], gonValue);
147         balances[to] = add(balances[to], gonValue);
148         emit Transfer(from, to, value);
149 
150         return true;
151     }
152 
153     function approve(address spender, uint256 value) override public returns (bool) {
154         allowed[msg.sender][spender] = value;
155         emit Approval(msg.sender, spender, value);
156         return true;
157     }
158 
159     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
160         allowed[msg.sender][spender] = add(allowed[msg.sender][spender], addedValue);
161         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
162         return true;
163     }
164 
165     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
166         uint256 oldValue = allowed[msg.sender][spender];
167         if (subtractedValue >= oldValue) {
168             allowed[msg.sender][spender] = 0;
169         } else {
170             allowed[msg.sender][spender] = sub(oldValue, subtractedValue);
171         }
172         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
173         return true;
174     }
175     
176     event LogRebase(uint indexed epoch, uint totalSupply);
177     
178 }