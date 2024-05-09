1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4   
5    // Get the total token supply
6     function totalSupply() public constant returns (uint total);
7 
8     // Get the account balance of another account with address _owner
9     function balanceOf(address _owner) public constant returns (uint balance);
10 
11     // Send _value amount of tokens to address _to
12     function transfer(address _to, uint256 _value) public  returns (bool success);
13 
14     // Send _value amount of tokens from address _from to address _to
15     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
16 
17     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
18     // If this function is called again it overwrites the current allowance with _value.
19     // this function is required for some DEX functionality
20     function approve(address _spender, uint256 _value) public returns (bool success);
21 
22     // Returns the amount which _spender is still allowed to withdraw from _owner
23     function allowance(address _owner, address _spender) public constant returns (uint remaining);
24 
25     // Triggered when tokens are transferred.
26     event Transfer(address indexed _from, address indexed _to, uint _value);
27 
28     // Triggered whenever approve(address _spender, uint256 _value) is called.
29     event Approval(address indexed _owner, address indexed _spender, uint _value);
30 }
31 
32 // ----------------------------------------------------------------------------
33 // Owned contract
34 // ----------------------------------------------------------------------------
35 contract Owned {
36     address public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     function Owned() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address _newOwner) public onlyOwner {
51         newOwner = _newOwner;
52     }
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         newOwner = address(0);
58     }
59 }
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66     function add(uint a, uint b) internal pure returns (uint c) {
67         c = a + b;
68         require(c >= a);
69     }
70     
71     function sub(uint a, uint b) internal pure returns (uint c) {
72         require(b <= a);
73         c = a - b;
74     }
75     
76     function mul(uint a, uint b) internal pure returns (uint c) {
77         c = a * b;
78         require(a == 0 || c / a == b);
79     }
80     
81     function div(uint a, uint b) internal pure returns (uint c) {
82         require(b > 0);
83         c = a / b;
84     }
85 }
86 
87 contract TreatzCoin is ERC20Interface, Owned {
88     using SafeMath for uint;
89 
90     string public symbol;
91     string public name;
92     uint8 public decimals;
93     uint public _totalSupply;
94 
95     mapping(address => uint256) balances;
96     mapping(address => mapping(address => uint256)) allowed;
97  
98     // ------------------------------------------------------------------------
99     // Constructor
100     // ------------------------------------------------------------------------
101     function TreatzCoin() public {
102         symbol ="TRTZ";
103         name = "Treatz Coin";
104         decimals = 2;
105         _totalSupply = 20000000 * 10**uint(decimals);
106 
107         balances[owner] = _totalSupply;
108         Transfer(address(0), owner, _totalSupply);
109     }
110     
111     // ------------------------------------------------------------------------
112     // Total supply
113     // ------------------------------------------------------------------------
114     function totalSupply() public constant returns (uint) {
115         return _totalSupply  - balances[address(0)];
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Get the token balance for account `tokenOwner`
121     // ------------------------------------------------------------------------
122     function balanceOf(address tokenOwner) public constant returns (uint balance) {
123         return balances[tokenOwner];
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Transfer the balance from token owner's account to `to` account
129     // - Owner's account must have sufficient balance to transfer
130     // - 0 value transfers are allowed
131     // ------------------------------------------------------------------------
132     function transfer(address to, uint tokens) public returns (bool success) {
133         balances[msg.sender] = balances[msg.sender].sub(tokens);
134         balances[to] = balances[to].add(tokens);
135         Transfer(msg.sender, to, tokens);
136         return true;
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Token owner can approve for `spender` to transferFrom(...) `tokens`
142     // from the token owner's account
143     //
144     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
145     // recommends that there are no checks for the approval double-spend attack
146     // as this should be implemented in user interfaces 
147     // ------------------------------------------------------------------------
148     function approve(address spender, uint tokens) public returns (bool success) {
149         allowed[msg.sender][spender] = tokens;
150         Approval(msg.sender, spender, tokens);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Transfer `tokens` from the `from` account to the `to` account
157     // 
158     // The calling account must already have sufficient tokens approve(...)-d
159     // for spending from the `from` account and
160     // - From account must have sufficient balance to transfer
161     // - Spender must have sufficient allowance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
165         balances[from] = balances[from].sub(tokens);
166         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
167         balances[to] = balances[to].add(tokens);
168         Transfer(from, to, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Returns the amount of tokens approved by the owner that can be
175     // transferred to the spender's account
176     // ------------------------------------------------------------------------
177     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
178         return allowed[tokenOwner][spender];
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     //    transform with fee of treatz token.
184     //    This function targets the treatz only wallet for exchange service.
185     // ------------------------------------------------------------------------
186     function transferFromWithFee(
187     address from,
188     address to,
189     uint256 tokens,
190     uint256 fee
191     ) public returns (bool success) {
192         balances[from] = balances[from].sub(tokens + fee);
193         if (msg.sender != owner)
194             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens + fee);
195         balances[to] = balances[to].add(tokens);
196         Transfer(from, to, tokens);
197 
198         balances[owner] = balances[owner].add(fee);
199         Transfer(from, owner, fee);
200         return true;
201     }
202 
203     // ------------------------------------------------------------------------
204     // Don't accept ETH
205     // ------------------------------------------------------------------------
206     function () public payable {
207         revert();
208     }
209 }