1 pragma solidity ^0.4.18;
2 
3 
4 contract ERC20Interface {
5   
6    // Get the total token supply
7     function totalSupply() public constant returns (uint total);
8 
9     // Get the account balance of another account with address _owner
10     function balanceOf(address _owner) public constant returns (uint balance);
11 
12     // Send _value amount of tokens to address _to
13     function transfer(address _to, uint256 _value) public  returns (bool success);
14 
15     // Send _value amount of tokens from address _from to address _to
16     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
17 
18     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
19     // If this function is called again it overwrites the current allowance with _value.
20     // this function is required for some DEX functionality
21     function approve(address _spender, uint256 _value) public returns (bool success);
22 
23     // Returns the amount which _spender is still allowed to withdraw from _owner
24     function allowance(address _owner, address _spender) public constant returns (uint remaining);
25 
26     // Triggered when tokens are transferred.
27     event Transfer(address indexed _from, address indexed _to, uint _value);
28 
29     // Triggered whenever approve(address _spender, uint256 _value) is called.
30     event Approval(address indexed _owner, address indexed _spender, uint _value);
31 }
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38     function add(uint a, uint b) internal pure returns (uint c) {
39         c = a + b;
40         require(c >= a);
41     }
42     
43     function sub(uint a, uint b) internal pure returns (uint c) {
44         require(b <= a);
45         c = a - b;
46     }
47     
48     function mul(uint a, uint b) internal pure returns (uint c) {
49         c = a * b;
50         require(a == 0 || c / a == b);
51     }
52     
53     function div(uint a, uint b) internal pure returns (uint c) {
54         require(b > 0);
55         c = a / b;
56     }
57 }
58 // ----------------------------------------------------------------------------
59 // Owned contract
60 // ----------------------------------------------------------------------------
61 contract Owned {
62     address public owner;
63     address public newOwner;
64 
65     event OwnershipTransferred(address indexed _from, address indexed _to);
66 
67     function Owned() public {
68         owner = msg.sender;
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     function transferOwnership(address _newOwner) public onlyOwner {
77         newOwner = _newOwner;
78     }
79     function acceptOwnership() public {
80         require(msg.sender == newOwner);
81         OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83         newOwner = address(0);
84     }
85 }
86 contract TreatzCoin is ERC20Interface, Owned {
87     using SafeMath for uint;
88 
89     string public symbol;
90     string public name;
91     uint8 public decimals;
92     uint public _totalSupply;
93 
94     mapping(address => uint256) balances;
95     mapping(address => mapping(address => uint256)) allowed;
96  
97     // ------------------------------------------------------------------------
98     // Constructor
99     // ------------------------------------------------------------------------
100     function TreatzCoin() public {
101         symbol ="TRTZ";
102         name = "Treatz Coin";
103         decimals = 2;
104         _totalSupply = 20000000 * 10**uint(decimals);
105 
106         balances[owner] = _totalSupply;
107         Transfer(address(0), owner, _totalSupply);
108     }
109     
110     // ------------------------------------------------------------------------
111     // Total supply
112     // ------------------------------------------------------------------------
113     function totalSupply() public constant returns (uint) {
114         return _totalSupply  - balances[address(0)];
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Get the token balance for account `tokenOwner`
120     // ------------------------------------------------------------------------
121     function balanceOf(address tokenOwner) public constant returns (uint balance) {
122         return balances[tokenOwner];
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Transfer the balance from token owner's account to `to` account
128     // - Owner's account must have sufficient balance to transfer
129     // - 0 value transfers are allowed
130     // ------------------------------------------------------------------------
131     function transfer(address to, uint tokens) public returns (bool success) {
132         balances[msg.sender] = balances[msg.sender].sub(tokens);
133         balances[to] = balances[to].add(tokens);
134         Transfer(msg.sender, to, tokens);
135         return true;
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Token owner can approve for `spender` to transferFrom(...) `tokens`
141     // from the token owner's account
142     //
143     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
144     // recommends that there are no checks for the approval double-spend attack
145     // as this should be implemented in user interfaces 
146     // ------------------------------------------------------------------------
147     function approve(address spender, uint tokens) public returns (bool success) {
148         allowed[msg.sender][spender] = tokens;
149         Approval(msg.sender, spender, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Transfer `tokens` from the `from` account to the `to` account
156     // 
157     // The calling account must already have sufficient tokens approve(...)-d
158     // for spending from the `from` account and
159     // - From account must have sufficient balance to transfer
160     // - Spender must have sufficient allowance to transfer
161     // - 0 value transfers are allowed
162     // ------------------------------------------------------------------------
163     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
164         balances[from] = balances[from].sub(tokens);
165         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
166         balances[to] = balances[to].add(tokens);
167         Transfer(from, to, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Returns the amount of tokens approved by the owner that can be
174     // transferred to the spender's account
175     // ------------------------------------------------------------------------
176     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
177         return allowed[tokenOwner][spender];
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     //    transform with fee of treatz token.
183     //    This function targets the treatz only wallet for exchange service.
184     // ------------------------------------------------------------------------
185     function transferFromWithFee(
186     address from,
187     address to,
188     uint256 tokens,
189     uint256 fee
190     ) public returns (bool success) {
191         balances[from] = balances[from].sub(tokens + fee);
192         if (msg.sender != owner)
193             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens + fee);
194         balances[to] = balances[to].add(tokens);
195         Transfer(from, to, tokens);
196 
197         balances[owner] = balances[owner].add(fee);
198         Transfer(from, owner, fee);
199         return true;
200     }
201 
202     // ------------------------------------------------------------------------
203     // Don't accept ETH
204     // ------------------------------------------------------------------------
205     function () public payable {
206         revert();
207     }
208 }