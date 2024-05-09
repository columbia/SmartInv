1 pragma solidity ^0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     function Owned() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address _newOwner) public onlyOwner {
22         newOwner = _newOwner;
23     }
24     function acceptOwnership() public {
25         require(msg.sender == newOwner);
26         emit OwnershipTransferred(owner, newOwner);
27         owner = newOwner;
28         newOwner = address(0);
29     }
30 }
31 
32 // ----------------------------------------------------------------------------
33 // Safe maths
34 // ----------------------------------------------------------------------------
35 library SafeMath {
36     function add(uint a, uint b) internal pure returns (uint c) {
37         c = a + b;
38         require(c >= a);
39     }
40     function sub(uint a, uint b) internal pure returns (uint c) {
41         require(b <= a);
42         c = a - b;
43     }
44     function mul(uint a, uint b) internal pure returns (uint c) {
45         c = a * b;
46         require(a == 0 || c / a == b);
47     }
48     function div(uint a, uint b) internal pure returns (uint c) {
49         require(b > 0);
50         c = a / b;
51     }
52 }
53 
54 // ----------------------------------------------------------------------------
55 // ERC Token Standard #20 Interface
56 // ----------------------------------------------------------------------------
57 contract ERC20Interface {
58     function totalSupply() public constant returns (uint);
59     function balanceOf(address tokenOwner) public constant returns (uint balance);
60     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
61     function transfer(address to, uint tokens) public returns (bool success);
62     function approve(address spender, uint tokens) public returns (bool success);
63     function transferFrom(address from, address to, uint tokens) public returns (bool success);
64 
65     event Transfer(address indexed from, address indexed to, uint tokens);
66     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
67 }
68 
69 contract NeoToken is ERC20Interface, Owned{
70     using SafeMath for uint;
71 
72     string public symbol;
73     string public name;
74     uint8 public decimals;
75     uint public _totalSupply;
76     mapping(address => uint) balances;
77     mapping(address => mapping(address => uint)) allowed;
78 
79     // ------------------------------------------------------------------------
80     // Constructor
81     // ------------------------------------------------------------------------
82     function NeoToken() public{
83         owner = 0x0c4BdfE0aEbF69dE4975a957A2d4FE72633BBC1a;
84         symbol = "NOC";
85         name = "NEO CLASSIC";
86         decimals = 18;
87         _totalSupply = totalSupply();
88         balances[owner] = _totalSupply;
89         emit Transfer(address(0),owner,_totalSupply);
90     }
91 
92     function totalSupply() public constant returns (uint){ 
93        return 200000000 * 10**uint(decimals);
94     }
95 
96     // ------------------------------------------------------------------------
97     // Get the token balance for account `tokenOwner`
98     // ------------------------------------------------------------------------
99     function balanceOf(address tokenOwner) public constant returns (uint balance) {
100         return balances[tokenOwner];
101     }
102 
103     // ------------------------------------------------------------------------
104     // Transfer the balance from token owner's account to `to` account
105     // - Owner's account must have sufficient balance to transfer
106     // - 0 value transfers are allowed
107     // ------------------------------------------------------------------------
108     function transfer(address to, uint tokens) public returns (bool success){
109         // prevent transfer to 0x0, use burn instead
110         require(to != 0x0);
111         require(balances[msg.sender] >= tokens );
112         require(balances[to] + tokens >= balances[to]);
113         balances[msg.sender] = balances[msg.sender].sub(tokens);
114         balances[to] = balances[to].add(tokens);
115         emit Transfer(msg.sender,to,tokens);
116         return true;
117     }
118     
119     function buyToken(address to, uint tokens) public returns (bool success) {
120         tokenPurchase(to, tokens);
121         return true;
122     }
123     
124     function tokenPurchase(address to, uint tokens) internal {
125         // prevent transfer to 0x0, use burn instead
126         require(to != 0x0);
127         require(balances[owner] >= tokens );
128         require(balances[to] + tokens >= balances[to]);
129         balances[owner] = balances[owner].sub(tokens);
130         balances[to] = balances[to].add(tokens);
131         emit Transfer(owner,to,tokens);
132     } 
133     // ------------------------------------------------------------------------
134     // Token owner can approve for `spender` to transferFrom(...) `tokens`
135     // from the token owner's account
136     // ------------------------------------------------------------------------
137     function approve(address spender, uint tokens) public returns (bool success){
138         allowed[msg.sender][spender] = tokens;
139         emit Approval(msg.sender,spender,tokens);
140         return true;
141     }
142 
143     // ------------------------------------------------------------------------
144     // Transfer `tokens` from the `from` account to the `to` account
145     // 
146     // The calling account must already have sufficient tokens approve(...)-d
147     // for spending from the `from` account and
148     // - From account must have sufficient balance to transfer
149     // - Spender must have sufficient allowance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152     function transferFrom(address from, address to, uint tokens) public returns (bool success){
153         require(tokens <= allowed[from][msg.sender]); //check allowance
154         require(balances[from] >= tokens);
155         balances[from] = balances[from].sub(tokens);
156         balances[to] = balances[to].add(tokens);
157         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
158         emit Transfer(from,to,tokens);
159         return true;
160     }
161 
162     // ------------------------------------------------------------------------
163     // Returns the amount of tokens approved by the owner that can be
164     // transferred to the spender's account
165     // ------------------------------------------------------------------------
166     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
167         return allowed[tokenOwner][spender];
168     }
169 
170 }