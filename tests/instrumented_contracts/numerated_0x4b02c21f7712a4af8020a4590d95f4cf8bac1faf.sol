1 pragma solidity >=0.4.22 <0.6.0;
2 
3     // ----------------------------------------------------------------------------
4     // Safe maths
5     // ----------------------------------------------------------------------------
6     library SafeMath {
7         function add(uint a, uint b) internal pure returns (uint c) {
8             c = a + b;
9             require(c >= a);
10         }
11         function sub(uint a, uint b) internal pure returns (uint c) {
12             require(b <= a);
13             c = a - b;
14         }
15         function mul(uint a, uint b) internal pure returns (uint c) {
16             c = a * b;
17             require(a == 0 || c / a == b);
18         }
19         function div(uint a, uint b) internal pure returns (uint c) {
20             require(b > 0);
21             c = a / b;
22         }
23     }
24 
25     // ----------------------------------------------------------------------------
26     // ERC Token Standard #20 Interface
27     // ----------------------------------------------------------------------------
28     contract ERC20Interface {
29         function totalSupply() public view returns (uint);
30         function balanceOf(address tokenOwner) public view returns (uint balance);
31         function allowance(address tokenOwner, address spender) public view returns (uint remaining);
32         function transfer(address to, uint tokens) public returns (bool success);
33         function approve(address spender, uint tokens) public returns (bool success);
34         function transferFrom(address from, address to, uint tokens) public returns (bool success);
35 
36         event Transfer(address indexed from, address indexed to, uint tokens);
37         event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38     }
39 
40     // ----------------------------------------------------------------------------
41     // Bimin Token Contract
42     // ----------------------------------------------------------------------------
43     contract BIMIN is ERC20Interface{
44         using SafeMath for uint;
45         
46         string public symbol;
47         string public name;
48         uint8 public decimals;
49         uint _totalSupply;
50         mapping(address => uint) balances;
51         mapping(address => mapping(address => uint)) allowed;
52 
53         // ------------------------------------------------------------------------
54         // Constructor
55         // ------------------------------------------------------------------------
56         constructor(address _owner) public{
57             symbol = "BM";
58             name = "Bimin Token";
59             decimals = 18;
60             _totalSupply = 100e8; //10,000,000,000
61             balances[_owner] = totalSupply();
62             emit Transfer(address(0),_owner,totalSupply());
63         }
64 
65         function totalSupply() public view returns (uint){
66         return _totalSupply * 10**uint(decimals);
67         }
68 
69         // ------------------------------------------------------------------------
70         // Get the token balance for account `tokenOwner`
71         // ------------------------------------------------------------------------
72         function balanceOf(address tokenOwner) public view returns (uint balance) {
73             return balances[tokenOwner];
74         }
75 
76         // ------------------------------------------------------------------------
77         // Transfer the balance from token owner's account to `to` account
78         // - Owner's account must have sufficient balance to transfer
79         // - 0 value transfers are allowed
80         // ------------------------------------------------------------------------
81         function transfer(address to, uint tokens) public returns (bool success) {
82             // prevent transfer to 0x0, use burn instead
83             require(to != address(0));
84             require(balances[msg.sender] >= tokens );
85             require(balances[to] + tokens >= balances[to]);
86             balances[msg.sender] = balances[msg.sender].sub(tokens);
87             balances[to] = balances[to].add(tokens);
88             emit Transfer(msg.sender,to,tokens);
89             return true;
90         }
91         
92         // ------------------------------------------------------------------------
93         // Token owner can approve for `spender` to transferFrom(...) `tokens`
94         // from the token owner's account
95         // ------------------------------------------------------------------------
96         function approve(address spender, uint tokens) public returns (bool success){
97             allowed[msg.sender][spender] = tokens;
98             emit Approval(msg.sender,spender,tokens);
99             return true;
100         }
101 
102         // ------------------------------------------------------------------------
103         // Transfer `tokens` from the `from` account to the `to` account
104         // 
105         // The calling account must already have sufficient tokens approve(...)
106         // for spending from the `from` account and
107         // - From account must have sufficient balance to transfer
108         // - Spender must have sufficient allowance to transfer
109         // - 0 value transfers are allowed
110         // ------------------------------------------------------------------------
111         function transferFrom(address from, address to, uint tokens) public returns (bool success){
112             require(tokens <= allowed[from][msg.sender]); //check allowance
113             require(balances[from] >= tokens);
114             balances[from] = balances[from].sub(tokens);
115             balances[to] = balances[to].add(tokens);
116             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
117             emit Transfer(from,to,tokens);
118             return true;
119         }
120         // ------------------------------------------------------------------------
121         // Returns the amount of tokens approved by the owner that can be
122         // transferred to the spender's account
123         // ------------------------------------------------------------------------
124         function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
125             return allowed[tokenOwner][spender];
126         }
127     }