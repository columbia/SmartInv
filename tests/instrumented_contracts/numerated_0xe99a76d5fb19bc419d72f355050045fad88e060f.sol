1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function add(uint a, uint b) pure internal returns (uint) {
5         uint c = a + b;
6         assert(c >= a && c >= b);
7         return c;
8     }
9 
10     function sub(uint a, uint b) pure internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function mul(uint a, uint b) pure internal returns (uint) {
16         uint c = a * b;
17         assert(a == 0 || c / a == b);
18         return c;
19     }
20 
21     function div(uint a, uint b) pure internal returns (uint) {
22         uint c = a / b;
23         return c;
24     }
25 }
26 
27 //ECR20 standard interface
28 contract ERC20 {
29     function totalSupply() public constant returns (uint);
30     function balanceOf(address account) public constant returns (uint balance);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33     function approve(address spender, uint tokens) public returns (bool success);
34     function allowance(address owner, address spender) public constant returns (uint remaining);
35     event Transfer(address indexed from, address indexed to, uint value);
36     event Approval(address indexed tokenOwner, address indexed spender, uint value);
37 }
38 
39 contract Owned {
40     address public owner = 0x0;
41     address public parentContract = 0x0;
42     address public thisContract = 0x0;
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }        
48 }
49 
50 // ------------------------------------------------------------------------
51 // RARTokens is the base contract for RAX, AVY and RAZ tokens
52 // ------------------------------------------------------------------------
53 contract RARTokens is ERC20, Owned  {
54     using SafeMath for uint;
55     
56     uint private _totalSupply;
57     
58     string public symbol;
59     string public name;
60     uint public decimals;  
61     
62     mapping(address => uint) balances;
63     
64     mapping(address => mapping (address => uint)) allowed;
65 
66     //Constructor receiving the parrent address and the total supply 
67     function RARTokens(address parent, uint maxSupply) public {
68         _totalSupply = maxSupply;  
69         balances[msg.sender] = maxSupply;  
70         owner = msg.sender;  
71         parentContract= parent;
72         thisContract = this;        
73     }
74 
75     //token total supply
76     function totalSupply() public constant returns (uint) {
77         return _totalSupply;
78     }
79     
80     //Gets the balance of the specified address.
81     function balanceOf(address account) public constant returns (uint balance) {
82         return balances[account];
83     }
84 
85     //transfer token for a specified address
86     function transfer(address to, uint tokens) public returns (bool success) {
87         require(to != address(0));
88         require(tokens <= balances[msg.sender]);
89         balances[msg.sender] = balances[msg.sender].sub(tokens);
90         balances[to] = balances[to].add(tokens);
91         Transfer(msg.sender, to, tokens);
92         return true;
93     }
94 
95     //Transfer tokens from one address to another
96     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
97         require(to != address(0));
98         require(tokens <= balances[from]);
99         require(tokens <= allowed[from][msg.sender]);
100         
101         balances[from] = balances[from].sub(tokens);
102         balances[to] = balances[to].add(tokens);
103         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
104         Transfer(from, to, tokens);
105         return true;
106     }    
107 
108     //Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
109     function approve(address spender, uint tokens) public returns (bool success) {
110         allowed[msg.sender][spender] = tokens;
111         Approval(msg.sender, spender, tokens);
112         return true;
113     }
114     
115     //Function to check the amount of tokens that an owner allowed to a spender.
116     function allowance(address owner, address spender ) public constant returns (uint remaining)
117     {
118         return allowed[owner][spender];
119     }
120     
121     // ------------------------------------------------------------------------
122     // Owner can transfer out any accidentally sent ERC20 tokens
123     // Borrowed from BokkyPooBah   
124     // ------------------------------------------------------------------------
125     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
126         return ERC20(tokenAddress).transfer(owner, tokens);
127     }
128 }
129 
130 // ------------------------------------------------------------------------
131 // RAX Token is on the top of RAR Tokens family.
132 // ------------------------------------------------------------------------ 
133 contract RAXToken is RARTokens{
134     
135     //set the max supply for RAX Token
136     uint private  _maxSupply =  23600000 * 10**18;    
137     
138     //Constructor passing the parent address and the total supply 
139     function RAXToken() RARTokens (this, _maxSupply) public {
140         
141          symbol = "RAX";
142          name = "RAX Token";
143          decimals = 18;
144     }
145 }
146 
147 // ------------------------------------------------------------------------
148 // AVY Token sit in between RAX and RAZ Tokens. 
149 // ------------------------------------------------------------------------ 
150 contract AVYToken is RARTokens{
151 
152     //set the max supply for AVY Tokens
153     uint private  _maxSupply =  38200000 * 10**18;    
154     
155     //Constructor passing the parent address and the total supply 
156     //parent here is RAX Token
157     function AVYToken(address parent) RARTokens (parent, _maxSupply) public {
158         
159         symbol = "AVY";
160         name = "AVY Token";
161         decimals = 18; 
162     } 
163 }
164 
165 
166 // ------------------------------------------------------------------------
167 // RAZ Token is at the bottom of RAR Tokens family.
168 // ------------------------------------------------------------------------ 
169 contract RAZToken is RARTokens{
170 
171     //set the max supply for RAZ Token
172     uint private  _maxSupply =  61800000 * 10**18;    
173 
174     //Constructor passing the parent address and the total supply 
175     //parent here is AVY Token
176     function RAZToken(address parent) RARTokens (parent, _maxSupply) public {
177         
178         symbol = "RAZ";
179         name = "RAZ Token";
180         decimals = 18;   
181     }
182 }