1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Symbol : ABC
6 // Name : ABC Token
7 // Total supply: 500000000
8 // Decimals : 18
9 //
10 // ----------------------------------------------------------------------------
11 
12 
13 library SafeMath {
14     function add(uint a, uint b) internal pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function sub(uint a, uint b) internal pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function mul(uint a, uint b) internal pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 
32 
33 contract ERC20Interface {
34     function totalSupply() public constant returns (uint);
35     function balanceOf(address tokenOwner) public constant returns (uint balance);
36     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
37     function transfer(address to, uint tokens) public returns (bool success);
38     function approve(address spender, uint tokens) public returns (bool success);
39     function transferFrom(address from, address to, uint tokens) public returns (bool success);
40 
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43     event Burn(address indexed from, uint256 value);
44 }
45 
46 
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49 }
50 
51 
52 contract Owned {
53     address public owner;
54     address public newOwner;
55 
56     event OwnershipTransferred(address indexed _from, address indexed _to);
57 
58     constructor() public {
59         owner = msg.sender;
60     }
61  
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address _newOwner) public onlyOwner {
68         newOwner = _newOwner;
69     }
70     function acceptOwnership() public {
71         require(msg.sender == newOwner);
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74         newOwner = address(0);
75     }
76 }
77 
78 
79 contract ABCToken is ERC20Interface, Owned {
80     using SafeMath for uint;
81 
82     string public symbol;
83     string public  name;
84     uint8 public decimals;
85     uint public _totalSupply;
86 
87     mapping(address => uint) balances;
88     mapping(address => mapping(address => uint)) allowed;
89 
90 
91     constructor() public {
92         symbol = "ABC";
93         name = "ABC Token";
94         decimals = 18;
95         _totalSupply = 500000000 * 10**uint(decimals);
96         balances[owner] = _totalSupply;
97         emit Transfer(address(0), owner, _totalSupply);
98     }
99 
100 
101     function totalSupply() public constant returns (uint) {
102         return _totalSupply  - balances[address(0)];
103     }
104  
105  
106     function balanceOf(address tokenOwner) public constant returns (uint balance) {
107         return balances[tokenOwner];
108     }
109 
110  
111     function transfer(address to, uint tokens) public returns (bool success) {
112         balances[msg.sender] = balances[msg.sender].sub(tokens);
113         balances[to] = balances[to].add(tokens);
114         emit Transfer(msg.sender, to, tokens);
115         return true;
116     }
117 
118 
119     function approve(address spender, uint tokens) public returns (bool success) {
120         allowed[msg.sender][spender] = tokens;
121         emit Approval(msg.sender, spender, tokens);
122         return true;
123     }
124 
125 
126     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
127         balances[from] = balances[from].sub(tokens);
128         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
129         balances[to] = balances[to].add(tokens);
130         emit Transfer(from, to, tokens);
131         return true;
132     }
133 
134 
135     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
136         return allowed[tokenOwner][spender];
137     }
138 
139 
140     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
141         allowed[msg.sender][spender] = tokens;
142         emit Approval(msg.sender, spender, tokens);
143         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
144         return true;
145     }
146     
147     function burn(uint256 _value) public returns (bool success) {
148         require(balances[msg.sender] >= _value);   
149         balances[msg.sender] -= _value;            
150         _totalSupply -= _value;                      
151         emit Burn(msg.sender, _value);
152         return true;
153     }
154     
155     function burnFrom(address _from, uint256 _value) public returns (bool success) {
156         require(balances[_from] >= _value);                
157         require(_value <= allowed[_from][msg.sender]);    
158         balances[_from] -= _value;                         
159         allowed[_from][msg.sender] -= _value;             
160         _totalSupply -= _value;                              
161         emit Burn(_from, _value);
162         return true;
163     }
164 
165 
166     function () public payable {
167         revert();
168     }
169 
170 
171     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
172         return ERC20Interface(tokenAddress).transfer(owner, tokens);
173     }
174 }