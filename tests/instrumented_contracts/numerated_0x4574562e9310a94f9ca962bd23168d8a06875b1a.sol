1 /**
2  *Submitted for verification at Etherscan.io on 2019-11-28
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 contract ERC20Interface {
27     function totalSupply() public view returns (uint256);
28     function balanceOf(address tokenOwner) public view returns (uint256 balance);
29     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
30     function transfer(address to, uint256 value) public returns (bool success);
31     function approve(address spender, uint256 value) public returns (bool success);
32     function transferFrom(address from, address to, uint256 value) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
36 }
37 
38 contract TROY is ERC20Interface {
39     using SafeMath for uint256;
40     string public symbol;
41     string public name;
42     uint8 public decimals;
43     uint256 _totalSupply;
44     address public owner;
45     bool public activeStatus = true;
46 
47     event Active(address msgSender);
48     event Reset(address msgSender);
49     event Freeze(address indexed from, uint256 value);
50     event Unfreeze(address indexed from, uint256 value);
51 
52     mapping(address => uint256) public balances;
53     mapping(address => uint256) public freezeOf;
54     mapping(address => mapping(address => uint256)) public allowed;
55 
56     constructor() public {
57         symbol = "TROY";
58         name = "TROY";
59         decimals = 18;
60         _totalSupply = 10000000000 * 10**uint(decimals);
61         owner = msg.sender;
62         balances[owner] = _totalSupply;
63         emit Transfer(address(0), owner, _totalSupply);
64     }
65 
66     function isOwner(address add) public view returns (bool) {
67       if (add == owner) {
68         return true;
69       } else return false;
70     }
71 
72     modifier onlyOwner {
73     if (!isOwner(msg.sender)) {
74             revert();
75          }
76     _;
77     }
78 
79     modifier onlyActive {
80      if (!activeStatus) {
81             revert();
82         }
83     _;
84     }
85 
86     function activeMode() public onlyOwner {
87         activeStatus = true;
88         emit Active(msg.sender);
89     }
90 
91     function resetMode() public onlyOwner {
92         activeStatus = false;
93         emit Reset(msg.sender);
94     }
95 
96     function totalSupply() public view returns (uint256) {
97         return _totalSupply;
98     }
99 
100     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
101         return balances[tokenOwner];
102     }
103 
104     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
105         return allowed[tokenOwner][spender];
106     }
107 
108     function transfer(address to, uint256 value) public onlyActive returns (bool success) {
109         if (to == address(0)) {
110             revert();
111         }
112     	if (value <= 0) {
113     		revert();
114         }
115         if (balances[msg.sender] < value) {
116             revert();
117         }
118         balances[msg.sender] = balances[msg.sender].sub(value);
119         balances[to] = balances[to].add(value);
120         emit Transfer(msg.sender, to, value);
121         return true;
122     }
123 
124     function approve(address spender, uint256 value) public onlyActive returns (bool success) {
125         if (value <= 0) {
126             revert();
127         }
128         allowed[msg.sender][spender] = value;
129         emit Approval(msg.sender, spender, value);
130         return true;
131     }
132 
133     function transferFrom(address from, address to, uint256 value) public onlyActive returns (bool success) {
134         if (to == address(0)) {
135             revert();
136         }
137         if (value <= 0) {
138             revert();
139         }
140         if (balances[from] < value) {
141             revert();
142         }
143         if (value > allowed[from][msg.sender]) {
144             revert();
145         }
146         balances[from] = balances[from].sub(value);
147         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
148         balances[to] = balances[to].add(value);
149         emit Transfer(from, to, value);
150         return true;
151     }
152 
153 	function freeze(uint256 value) public onlyActive returns (bool success) {
154         if (balances[msg.sender] < value) {
155             revert();
156         }
157 		if (value <= 0){
158 		    revert();
159 		}
160         balances[msg.sender] = balances[msg.sender].sub(value);
161         freezeOf[msg.sender] = freezeOf[msg.sender].add(value);
162         emit Freeze(msg.sender, value);
163         return true;
164     }
165 
166 	function unfreeze(uint256 value) public onlyActive returns (bool success) {
167         if (freezeOf[msg.sender] < value) {
168             revert();
169         }
170 		if (value <= 0) {
171 		    revert();
172 		}
173         freezeOf[msg.sender] = freezeOf[msg.sender].sub(value);
174 		balances[msg.sender] = balances[msg.sender].add(value);
175         emit Unfreeze(msg.sender, value);
176         return true;
177     }
178 
179     function () external payable {
180         revert();
181     }
182 }