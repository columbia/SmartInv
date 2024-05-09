1 pragma solidity 0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public constant returns (uint);
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 // ----------------------------------------------------------------------------
42 // Owned contract
43 // ----------------------------------------------------------------------------
44 contract Owned {
45     address public owner;
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54 
55 }
56 
57 /**
58  * @title MapCoin 
59  */
60 contract MapCoin is ERC20Interface, Owned {
61   using SafeMath for uint256;
62   string  public symbol; 
63   string  public name;
64   uint8   public decimals;
65   uint    internal _totalSupply;
66   
67   mapping(address => uint) balances;
68   mapping(address => mapping(address => uint)) allowed;
69   
70     // ------------------------------------------------------------------------
71     // Constructor
72     // ------------------------------------------------------------------------
73     constructor (address _owner) public {
74         symbol = "MAP";
75         name = "MapCoin";
76         decimals = 18;
77         owner = _owner;
78         _totalSupply = 1e9; // 1 billion
79         balances[owner] = totalSupply();
80         emit Transfer(address(0),owner, totalSupply());
81     }
82     
83     // donot accept any ethers
84     function () external payable {
85         revert();
86     }
87 
88     /* ERC20Interface function's implementation */
89     function totalSupply() public constant returns (uint){
90        return _totalSupply* 10**uint(decimals);
91     }
92     
93     // ------------------------------------------------------------------------
94     // Get the token balance for account `tokenOwner`
95     // ------------------------------------------------------------------------
96     function balanceOf(address tokenOwner) public constant returns (uint balance) {
97         return balances[tokenOwner];
98     }
99 
100     // ------------------------------------------------------------------------
101     // Transfer the balance from token owner's account to `to` account
102     // - Owner's account must have sufficient balance to transfer
103     // - 0 value transfers are allowed
104     // ------------------------------------------------------------------------
105     function transfer(address to, uint tokens) public returns (bool success) {
106         // prevent transfer to 0x0, use burn instead
107         require(to != 0x0);
108         require(balances[msg.sender] >= tokens );
109         require(balances[to] + tokens >= balances[to]);
110         balances[msg.sender] = balances[msg.sender].sub(tokens);
111         balances[to] = balances[to].add(tokens);
112         emit Transfer(msg.sender,to,tokens);
113         return true;
114     }
115     
116     // ------------------------------------------------------------------------
117     // Token owner can approve for `spender` to transferFrom(...) `tokens`
118     // from the token owner's account
119     // ------------------------------------------------------------------------
120     function approve(address spender, uint tokens) public returns (bool success){
121         allowed[msg.sender][spender] = tokens;
122         emit Approval(msg.sender,spender,tokens);
123         return true;
124     }
125 
126     // ------------------------------------------------------------------------
127     // Transfer `tokens` from the `from` account to the `to` account
128     // 
129     // The calling account must already have sufficient tokens approve(...)-d
130     // for spending from the `from` account and
131     // - From account must have sufficient balance to transfer
132     // - Spender must have sufficient allowance to transfer
133     // - 0 value transfers are allowed
134     // ------------------------------------------------------------------------
135     function transferFrom(address from, address to, uint tokens) public returns (bool success){
136         require(tokens <= allowed[from][msg.sender]); //check allowance
137         require(balances[from] >= tokens);
138         balances[from] = balances[from].sub(tokens);
139         balances[to] = balances[to].add(tokens);
140         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
141         emit Transfer(from,to,tokens);
142         return true;
143     }
144     // ------------------------------------------------------------------------
145     // Returns the amount of tokens approved by the owner that can be
146     // transferred to the spender's account
147     // ------------------------------------------------------------------------
148     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
149         return allowed[tokenOwner][spender];
150     }
151 
152 }