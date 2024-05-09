1 pragma solidity ^0.4.18;
2 
3 
4 contract Owned {
5 
6  
7     address public owner;
8 
9   
10     address public newOwner;
11 
12     
13     event OwnershipTransferred(address indexed _from, address indexed _to);
14 
15    
16     function Owned() public {
17         owner = msg.sender;
18     }
19 
20     
21     modifier onlyOwner {
22         require(msg.sender == owner);
23         _;
24     }
25 
26   
27     function transferOwnership(address _newOwner) public onlyOwner {
28         newOwner = _newOwner;
29     }
30 
31 
32     function acceptOwnership() public {
33         require(msg.sender == newOwner);
34         emit OwnershipTransferred(owner, newOwner);
35         owner = newOwner;
36         newOwner = address(0);
37     }
38 }
39 
40 
41 library SafeMath {
42     function add(uint a, uint b) internal pure returns (uint c) {
43         c = a + b;
44         require(c >= a);
45     }
46     function sub(uint a, uint b) internal pure returns (uint c) {
47         require(b <= a);
48         c = a - b;
49     }
50     function mul(uint a, uint b) internal pure returns (uint c) {
51         c = a * b;
52         require(a == 0 || c / a == b);
53     }
54     function div(uint a, uint b) internal pure returns (uint c) {
55         require(b > 0);
56         c = a / b;
57     }
58 }
59 
60 // ----------------------------------------------------------------------------
61 // ERC Token Standard #20 Interface
62 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
63 // ----------------------------------------------------------------------------
64 contract ERC20Interface {
65     function totalSupply() public constant returns (uint);
66     function balanceOf(address tokenOwner) public constant returns (uint balance);
67     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
68     function transfer(address to, uint tokens) public returns (bool success);
69     function approve(address spender, uint tokens) public returns (bool success);
70     function transferFrom(address from, address to, uint tokens) public returns (bool success);
71 
72     event Transfer(address indexed from, address indexed to, uint tokens);
73     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
74 }
75 
76 
77 
78 // ----------------------------------------------------------------------------
79 // Contract function to receive approval and execute function in one call
80 // Borrowed from MiniMeToken
81 // ----------------------------------------------------------------------------
82 contract ApproveAndCallFallBack {
83     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
84 }
85 
86 
87 
88 
89 contract FunWorldCoinToken is ERC20Interface, Owned {
90 
91 
92   
93     string  public  symbol;
94 
95 
96     string  public  name;
97 
98 
99   
100     uint8 public decimals;
101 
102 
103     uint  _totalSupply;
104 
105 
106     mapping(address => uint) balances;
107 
108 
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     using SafeMath for uint;
113 
114 
115 
116     function FunWorldCoinToken() public {
117         symbol = "FWC";
118         name = "FunWorldCoin Token";
119         decimals = 18;
120         _totalSupply = 1 * (10 ** 10) * (10 ** uint(decimals));
121         balances[owner] = _totalSupply;
122         emit Transfer(address(0), owner, _totalSupply);
123     }
124 
125 
126     function totalSupply() public constant returns (uint) {
127         return _totalSupply - balances[address(0)];
128     }
129 
130 
131     function balanceOf(address tokenOwner) public constant returns (uint balance) {
132         return balances[tokenOwner];
133     }
134 
135 
136 
137     function transfer(address to, uint tokens) public returns (bool success) {
138         balances[msg.sender] = balances[msg.sender].sub(tokens);
139         balances[to] = balances[to].add(tokens);
140         emit Transfer(msg.sender, to, tokens);
141         return true;
142     }
143 
144 
145 
146     function approve(address spender, uint tokens) public returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         emit Approval(msg.sender, spender, tokens);
149         return true;
150     }
151 
152 
153     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
154         balances[from] = balances[from].sub(tokens);
155         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
156         balances[to] = balances[to].add(tokens);
157         emit Transfer(from, to, tokens);
158         return true;
159     }
160 
161 
162     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
163         return allowed[tokenOwner][spender];
164     }
165 
166 
167     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         emit Approval(msg.sender, spender, tokens);
170         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
171         return true;
172     }
173 
174 
175     function() public payable {
176         revert();
177     }
178 
179 
180   
181     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
182         return ERC20Interface(tokenAddress).transfer(owner, tokens);
183     }
184 
185 }