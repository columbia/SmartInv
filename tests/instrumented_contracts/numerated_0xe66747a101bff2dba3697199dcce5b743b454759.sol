1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public view returns (uint256);
24     function balanceOf(address tokenOwner) public view returns (uint256 balance);
25     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
26     function transfer(address to, uint256 value) public returns (bool success);
27     function approve(address spender, uint256 value) public returns (bool success);
28     function transferFrom(address from, address to, uint256 value) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
32 }
33 
34 contract GateChainToken is ERC20Interface {
35     using SafeMath for uint256;
36     string public symbol;
37     string public name;
38     uint8 public decimals;
39     uint256 _totalSupply;
40     address public owner;
41     bool public activeStatus = true;
42 
43     event Active(address msgSender);
44     event Reset(address msgSender);
45     event Burn(address indexed from, uint256 value);
46     event Freeze(address indexed from, uint256 value);
47     event Unfreeze(address indexed from, uint256 value);
48 
49     mapping(address => uint256) public balances;
50     mapping(address => uint256) public freezeOf;
51     mapping(address => mapping(address => uint256)) public allowed;
52 
53     constructor() public {
54         symbol = "GT";
55         name = "GateChainToken";
56         decimals = 18;
57         _totalSupply = 300000000 * 10**uint(decimals);
58         owner = msg.sender;
59         balances[owner] = _totalSupply;
60         emit Transfer(address(0), owner, _totalSupply);
61     }
62 
63     function isOwner(address add) public view returns (bool) {
64       if (add == owner) {
65         return true;
66       } else return false;
67     }
68 
69     modifier onlyOwner {
70     if (!isOwner(msg.sender)) {
71             revert();
72          }
73     _;
74     }
75 
76     modifier onlyActive {
77      if (!activeStatus) {
78             revert();
79         }
80     _;
81     }
82 
83     function activeMode() public onlyOwner {
84         activeStatus = true;
85         emit Active(msg.sender);
86     }
87 
88     function resetMode() public onlyOwner {
89         activeStatus = false;
90         emit Reset(msg.sender);
91     }
92 
93     function totalSupply() public view returns (uint256) {
94         return _totalSupply;
95     }
96 
97     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
98         return balances[tokenOwner];
99     }
100 
101     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
102         return allowed[tokenOwner][spender];
103     }
104 
105     function transfer(address to, uint256 value) public onlyActive returns (bool success) {
106         if (to == address(0)) {
107             revert();
108         }
109     	if (value <= 0) {
110     		revert();
111         }
112         if (balances[msg.sender] < value) {
113             revert();
114         }
115         balances[msg.sender] = balances[msg.sender].sub(value);
116         balances[to] = balances[to].add(value);
117         emit Transfer(msg.sender, to, value);
118         return true;
119     }
120 
121     function approve(address spender, uint256 value) public onlyActive returns (bool success) {
122         if (value <= 0) {
123             revert();
124         }
125         allowed[msg.sender][spender] = value;
126         emit Approval(msg.sender, spender, value);
127         return true;
128     }
129 
130     function transferFrom(address from, address to, uint256 value) public onlyActive returns (bool success) {
131         if (to == address(0)) {
132             revert();
133         }
134         if (value <= 0) {
135             revert();
136         }
137         if (balances[from] < value) {
138             revert();
139         }
140         if (value > allowed[from][msg.sender]) {
141             revert();
142         }
143         balances[from] = balances[from].sub(value);
144         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
145         balances[to] = balances[to].add(value);
146         emit Transfer(from, to, value);
147         return true;
148     }
149 
150     function burn(uint256 value) public onlyActive returns (bool success) {
151         if (balances[msg.sender] < value) {
152             revert();
153         }
154 		if (value <= 0) {
155 		    revert();
156 		}
157         balances[msg.sender] = balances[msg.sender].sub(value);
158         _totalSupply = _totalSupply.sub(value);
159         emit Burn(msg.sender, value);
160         return true;
161     }
162 
163 	function freeze(uint256 value) public onlyActive returns (bool success) {
164         if (balances[msg.sender] < value) {
165             revert();
166         }
167 		if (value <= 0){
168 		    revert();
169 		}
170         balances[msg.sender] = balances[msg.sender].sub(value);
171         freezeOf[msg.sender] = freezeOf[msg.sender].add(value);
172         emit Freeze(msg.sender, value);
173         return true;
174     }
175 
176 	function unfreeze(uint256 value) public onlyActive returns (bool success) {
177         if (freezeOf[msg.sender] < value) {
178             revert();
179         }
180 		if (value <= 0) {
181 		    revert();
182 		}
183         freezeOf[msg.sender] = freezeOf[msg.sender].sub(value);
184 		balances[msg.sender] = balances[msg.sender].add(value);
185         emit Unfreeze(msg.sender, value);
186         return true;
187     }
188 
189     function () external payable {
190         revert();
191     }
192 }