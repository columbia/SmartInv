1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         c = a + b;
9         require(c >= a);
10     }
11 
12     function safeSub(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         require(b <= a);
14         c = a - b;
15     }
16 
17     function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21 
22     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 // ----------------------------------------------------------------------------
29 // Owned contract
30 // ----------------------------------------------------------------------------
31 contract Owned {
32     address public owner;
33     address public newOwner;
34 
35     event OwnershipTransferred(address indexed _from, address indexed _to);
36 
37     constructor () public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address _newOwner) public onlyOwner {
47         newOwner = _newOwner;
48     }
49     function acceptOwnership() public {
50         require(msg.sender == newOwner);
51         emit OwnershipTransferred(owner, newOwner);
52         owner = newOwner;
53         newOwner = address(0);
54     }
55 }
56 
57 // ----------------------------------------------------------------------------
58 // ERC Token Standard #20 Interface
59 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
60 // ----------------------------------------------------------------------------
61 contract ERC20Interface {
62     function totalSupply() public view returns (uint);
63     function balanceOf(address tokenOwner) public view returns (uint balance);
64     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
65     function transfer(address to, uint tokens) public returns (bool success);
66     function approve(address spender, uint tokens) public returns (bool success);
67     function transferFrom(address from, address to, uint tokens) public returns (bool success);
68 
69     event Transfer(address indexed from, address indexed to, uint tokens);
70     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
71 }
72 
73 // ----------------------------------------------------------------------------
74 // ERC20 Token, with the addition of symbol, name and decimals and assisted
75 // token transfers
76 // ----------------------------------------------------------------------------
77 contract CFSToken is ERC20Interface, Owned, SafeMath {
78     string  public symbol;
79     string  public name;
80     uint8   public decimals;
81     uint256 public totalSupply;
82     bool    public isStop;
83 
84     mapping(address => uint256) balances;
85     mapping(address => mapping(address => uint256)) allowed;
86 
87     modifier runnable {
88         require(isStop == false);
89         _;
90     }
91 
92     event Burn(address indexed from, uint256 value);
93 
94     // ------------------------------------------------------------------------
95     // Constructor
96     // ------------------------------------------------------------------------
97     constructor () public {
98         decimals = 18;                                     // Amount of decimals for display purposes
99         totalSupply = 10000000000 * 10**uint(decimals);    //total supply (Generate 1 billion tokens)
100         balances[msg.sender] = totalSupply;                
101         name = "Crypto Future SAFT";                       // Set the name for display purposes
102         symbol = "CFS";                                    // Set the symbol for display purposes
103         isStop = false;
104     }
105 
106     function totalSupply() public view returns (uint) {
107         return totalSupply;
108     }
109 
110     // ------------------------------------------------------------------------
111     // Get the token balance for account tokenOwner
112     // ------------------------------------------------------------------------
113     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
114         return balances[tokenOwner];
115     }
116 
117     function transfer(address to, uint256 value) public runnable returns (bool success) {
118         assert(balances[msg.sender] >= value);
119         balances[msg.sender] = safeSub(balances[msg.sender], value);
120         balances[to] = safeAdd(balances[to], value);
121         emit Transfer(msg.sender, to, value);
122         return true;
123     }
124 
125     function approve(address spender, uint256 tokens) public runnable returns (bool success) {
126         allowed[msg.sender][spender] = tokens;
127         emit Approval(msg.sender, spender, tokens);
128         return true;
129     }
130 
131     function transferFrom(address from, address to, uint256 tokens) public runnable returns (bool success) {        
132         allowed[from][to] = safeSub(allowed[from][to], tokens);
133         balances[from] = safeSub(balances[from], tokens);        
134         balances[to] = safeAdd(balances[to], tokens);
135         emit Transfer(from, to, tokens);
136         return true;
137     }
138 
139     function allowance(address tokenOwner, address spender) public runnable view returns (uint256 remaining) {
140         return allowed[tokenOwner][spender];
141     }
142 
143     function stop() public onlyOwner {
144         require(isStop == false);
145         isStop = true;
146     }
147 
148     function restart() public onlyOwner {
149         require(isStop == true);
150         isStop = false;
151     }
152 
153     function supplement(uint256 value) public runnable onlyOwner {
154         balances[msg.sender] = safeAdd(balances[msg.sender], value);
155         totalSupply = safeAdd(totalSupply, value);
156     }
157     
158     function burn(uint256 value) public runnable onlyOwner{
159         assert(balances[msg.sender] >= value);
160         balances[msg.sender] = safeSub(balances[msg.sender], value);
161         totalSupply = safeSub(totalSupply, value);
162         emit Burn(msg.sender, value);
163     }
164 
165     function burnFrom(address from, uint256 value) public runnable onlyOwner returns (bool success) {
166         assert(balances[from] >= value);
167         assert(value <= allowed[from][msg.sender]);
168         balances[from] = safeSub(balances[from], value);
169         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);
170         totalSupply = safeSub(totalSupply, value);
171         emit Burn(from, value);
172         return true;
173     }
174 
175     // ------------------------------------------------------------------------
176     // Don't accept ETH
177     // ------------------------------------------------------------------------
178     function () public payable {
179         revert();
180     }
181 }