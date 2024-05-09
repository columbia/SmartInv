1 pragma solidity ^0.4.24;
2 contract SafeMath {
3     function safeAdd(uint a, uint b) public pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }
7     function safeSub(uint a, uint b) public pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }
11     function safeMul(uint a, uint b) public pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15     function safeDiv(uint a, uint b) public pure returns (uint c) {
16         require(b > 0);
17         c = a / b;
18     }
19 }
20 
21 
22 
23 contract ERC20Interface {
24     function totalSupply() public constant returns (uint);
25     function balanceOf(address tokenOwner) public constant returns (uint balance);
26     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
27     function transfer(address to, uint tokens) public returns (bool success);
28     function approve(address spender, uint tokens) public returns (bool success);
29     function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // Contract function to receive approval and execute function in one call
38 //
39 // Borrowed from MiniMeToken
40 // ----------------------------------------------------------------------------
41 contract ApproveAndCallFallBack {
42     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // Owned contract
48 // ----------------------------------------------------------------------------
49 contract Owned {
50     address public owner;
51     address public newOwner;
52 
53     event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55     constructor() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     function transferOwnership(address _newOwner) public onlyOwner {
65         newOwner = _newOwner;
66     }
67     function acceptOwnership() public {
68         require(msg.sender == newOwner);
69         emit OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71         newOwner = address(0);
72     }
73 }
74 
75 
76 // ----------------------------------------------------------------------------
77 // ERC20 Token, with the addition of symbol, name and decimals and assisted
78 // token transfers
79 // ----------------------------------------------------------------------------
80 contract Papino is ERC20Interface, Owned, SafeMath {
81     string public symbol;
82     string public  name;
83     uint8 public decimals;
84     uint public _totalSupply;
85 
86     mapping(address => uint) balances;
87     mapping(address => mapping(address => uint)) allowed;
88 
89 
90     // ------------------------------------------------------------------------
91     // Constructor
92     // ------------------------------------------------------------------------
93     constructor() public {
94         symbol = "PAP";
95         name = "PAPINO";
96         decimals = 18;
97         _totalSupply = 1 * 10**6 * 10**uint256(decimals);       
98  balances[0x495E2F6fBD5fD0462cC7a43c4B0B294fE9A7FB7C] = _totalSupply;
99         emit Transfer(address(0), 0x495E2F6fBD5fD0462cC7a43c4B0B294fE9A7FB7C, _totalSupply);
100     }
101 
102 
103     // ------------------------------------------------------------------------
104     // Total supply
105     // ------------------------------------------------------------------------
106     function totalSupply() public constant returns (uint) {
107         return _totalSupply  - balances[address(0)];
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Get the token balance for account tokenOwner
113     // ------------------------------------------------------------------------
114     function balanceOf(address tokenOwner) public constant returns (uint balance) {
115         return balances[tokenOwner];
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Transfer the balance from token owner's account to to account
121     // - Owner's account must have sufficient balance to transfer
122     // - 0 value transfers are allowed
123     // ------------------------------------------------------------------------
124     function transfer(address to, uint tokens) public returns (bool success) {
125         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
126         balances[to] = safeAdd(balances[to], tokens);
127         emit Transfer(msg.sender, to, tokens);
128         return true;
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // El propietario del token puede aprobar la transferencia de tokens de spender a (...)
134      // de la cuenta del propietario del token
135      // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
136      // recomienda que no haya controles para el ataque de doble gasto de aprobación
137      // ya que esto debería implementarse en interfaces de usuario   
138  // ------------------------------------------------------------------------
139     function approve(address spender, uint tokens) public returns (bool success) {
140         allowed[msg.sender][spender] = tokens;
141         emit Approval(msg.sender, spender, tokens);
142         return true;
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Transfer tokens from the from account to the to account
148     // 
149     // The calling account must already have sufficient tokens approve(...)-d
150     // for spending from the from account and
151     // - From account must have sufficient balance to transfer
152     // - el gastador debe tener suficiente permiso para transferir
153     // - Se permiten 0 transferencias de valor
154     // ------------------------------------------------------------------------
155     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
156         balances[from] = safeSub(balances[from], tokens);
157         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
158         balances[to] = safeAdd(balances[to], tokens);
159         emit Transfer(from, to, tokens);
160         return true;
161     }
162      // Devuelve la cantidad de tokens aprobados por el propietario que puede ser
163      // transferido a la cuenta del gastador
164 
165     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
166         return allowed[tokenOwner][spender];
167     }
168     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
169         allowed[msg.sender][spender] = tokens;
170         emit Approval(msg.sender, spender, tokens);
171         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
172         return true;
173     }
174     function () public payable {
175         revert();
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // El propietario puede transferir cualquier tokens ERC20 enviados accidentalmente
181     // ------------------------------------------------------------------------
182     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
183         return ERC20Interface(tokenAddress).transfer(owner, tokens);
184     }
185 }