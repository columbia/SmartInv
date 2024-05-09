1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // This is the new token contract for TBE (TowerBee) 
6 // The old token address is 0xf18b97b312EF48C5d2b5C21c739d499B7c65Cf96
7 // Official contact details: support@towerbee.io , support@towerx.co
8 // Symbol : TBE
9 // Name : TowerBee
10 // Total supply: 500000000
11 // Decimals : 18
12 //
13 // ----------------------------------------------------------------------------
14 
15 
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function sub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 contract ERC20Interface {
37     function totalSupply() public constant returns (uint);
38     function balanceOf(address tokenOwner) public constant returns (uint balance);
39     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
40     function transfer(address to, uint tokens) public returns (bool success);
41     function approve(address spender, uint tokens) public returns (bool success);
42     function transferFrom(address from, address to, uint tokens) public returns (bool success);
43 
44     event Transfer(address indexed from, address indexed to, uint tokens);
45     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
46     event Burn(address indexed from, uint256 value);
47 }
48 
49 
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
52 }
53 
54 
55 contract Owned {
56     address public owner;
57     address public newOwner;
58 
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61     constructor() public {
62         owner = msg.sender;
63     }
64  
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         newOwner = _newOwner;
72     }
73     function acceptOwnership() public {
74         require(msg.sender == newOwner);
75         emit OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77         newOwner = address(0);
78     }
79 }
80 
81 
82 contract TBEToken is ERC20Interface, Owned {
83     using SafeMath for uint;
84 
85     string public symbol;
86     string public  name;
87     uint8 public decimals;
88     uint public _totalSupply;
89 
90     mapping(address => uint) balances;
91     mapping(address => mapping(address => uint)) allowed;
92 
93 
94     constructor() public {
95         symbol = "TBE";
96         name = "TowerBee";
97         decimals = 18;
98         _totalSupply = 500000000 * 10**uint(decimals);
99         balances[owner] = _totalSupply;
100         emit Transfer(address(0), owner, _totalSupply);
101     }
102 
103 
104     function totalSupply() public constant returns (uint) {
105         return _totalSupply  - balances[address(0)];
106     }
107  
108  
109     function balanceOf(address tokenOwner) public constant returns (uint balance) {
110         return balances[tokenOwner];
111     }
112 
113  
114     function transfer(address to, uint tokens) public returns (bool success) {
115         balances[msg.sender] = balances[msg.sender].sub(tokens);
116         balances[to] = balances[to].add(tokens);
117         emit Transfer(msg.sender, to, tokens);
118         return true;
119     }
120 
121 
122     function approve(address spender, uint tokens) public returns (bool success) {
123         allowed[msg.sender][spender] = tokens;
124         emit Approval(msg.sender, spender, tokens);
125         return true;
126     }
127 
128 
129     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
130         balances[from] = balances[from].sub(tokens);
131         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
132         balances[to] = balances[to].add(tokens);
133         emit Transfer(from, to, tokens);
134         return true;
135     }
136 
137 
138     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
139         return allowed[tokenOwner][spender];
140     }
141 
142 
143     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
144         allowed[msg.sender][spender] = tokens;
145         emit Approval(msg.sender, spender, tokens);
146         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
147         return true;
148     }
149     
150     function burn(uint256 _value) public returns (bool success) {
151         require(balances[msg.sender] >= _value);   
152         balances[msg.sender] -= _value;            
153         _totalSupply -= _value;                      
154         emit Burn(msg.sender, _value);
155         return true;
156     }
157     
158     function burnFrom(address _from, uint256 _value) public returns (bool success) {
159         require(balances[_from] >= _value);                
160         require(_value <= allowed[_from][msg.sender]);    
161         balances[_from] -= _value;                         
162         allowed[_from][msg.sender] -= _value;             
163         _totalSupply -= _value;                              
164         emit Burn(_from, _value);
165         return true;
166     }
167 
168 
169     function () public payable {
170         revert();
171     }
172 
173 
174     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
175         return ERC20Interface(tokenAddress).transfer(owner, tokens);
176     }
177 }