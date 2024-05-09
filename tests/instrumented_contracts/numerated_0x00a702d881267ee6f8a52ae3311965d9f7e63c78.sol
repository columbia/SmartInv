1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Eben' token contract
5 //
6 // Deployed to : 0xab9ba405e8e6dcffe3654668b44683d14488463c
7 // Symbol      : EBEN
8 // Name        : Eben
9 // Total supply: 6000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 library SafeMath {
21     function add(uint a, uint b) internal pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function mul(uint a, uint b) internal pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function div(uint a, uint b) internal pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 // ERC20 Token, with the addition of symbol, name and decimals and assisted
89 // token transfers
90 // ----------------------------------------------------------------------------
91 contract Eben is ERC20Interface, Owned {
92     using SafeMath for uint256;
93     string public symbol;
94     string public  name;
95     uint8 public decimals;
96     uint public _totalSupply;
97 
98     mapping(address => uint) balances;
99     mapping(address => mapping(address => uint)) allowed;
100 
101 
102     // ------------------------------------------------------------------------
103     // Constructor
104     // ------------------------------------------------------------------------
105     constructor() public {
106         symbol = "EBEN";
107         name = "Eben";
108         decimals = 18;
109         _totalSupply = 6000000; // 6 million
110         balances[0xab9ba405e8e6dcffe3654668b44683d14488463c] = totalSupply();
111         emit Transfer(address(0), 0xab9ba405e8e6dcffe3654668b44683d14488463c, totalSupply());
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Total supply
117     // ------------------------------------------------------------------------
118     function totalSupply() public constant returns (uint) {
119         return _totalSupply * 10 **uint(decimals);
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Get the token balance for account `tokenOwner`
125     // ------------------------------------------------------------------------
126     function balanceOf(address tokenOwner) public constant returns (uint balance) {
127         return balances[tokenOwner];
128     }
129 
130     // ------------------------------------------------------------------------
131     // Transfer the balance from token owner's account to `to` account
132     // - Owner's account must have sufficient balance to transfer
133     // - 0 value transfers are allowed
134     // ------------------------------------------------------------------------
135     function transfer(address to, uint tokens) public returns (bool success) {
136         // prevent transfer to 0x0, use burn instead
137         require(to != 0x0);
138         require(balances[msg.sender] >= tokens );
139         require(balances[to] + tokens >= balances[to]);
140         balances[msg.sender] = balances[msg.sender].sub(tokens);
141         balances[to] = balances[to].add(tokens);
142         emit Transfer(msg.sender,to,tokens);
143         return true;
144     }
145     
146     // ------------------------------------------------------------------------
147     // Token owner can approve for `spender` to transferFrom(...) `tokens`
148     // from the token owner's account
149     // ------------------------------------------------------------------------
150     function approve(address spender, uint tokens) public returns (bool success){
151         allowed[msg.sender][spender] = tokens;
152         emit Approval(msg.sender,spender,tokens);
153         return true;
154     }
155 
156     // ------------------------------------------------------------------------
157     // Transfer `tokens` from the `from` account to the `to` account
158     // 
159     // The calling account must already have sufficient tokens approve(...)-d
160     // for spending from the `from` account and
161     // - From account must have sufficient balance to transfer
162     // - Spender must have sufficient allowance to transfer
163     // - 0 value transfers are allowed
164     // ------------------------------------------------------------------------
165     function transferFrom(address from, address to, uint tokens) public returns (bool success){
166         require(tokens <= allowed[from][msg.sender]); //check allowance
167         require(balances[from] >= tokens);
168         balances[from] = balances[from].sub(tokens);
169         balances[to] = balances[to].add(tokens);
170         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
171         emit Transfer(from,to,tokens);
172         return true;
173     }
174     // ------------------------------------------------------------------------
175     // Returns the amount of tokens approved by the owner that can be
176     // transferred to the spender's account
177     // ------------------------------------------------------------------------
178     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
179         return allowed[tokenOwner][spender];
180     }
181 
182     // ------------------------------------------------------------------------
183     // Don't accept ETH
184     // ------------------------------------------------------------------------
185     function () public payable {
186         revert();
187     }
188 
189     function multipleTokensSend (address[] _addresses, uint256[] _values) public onlyOwner {
190 	    for (uint i = 0; i < _addresses.length; i++){
191 	    	_transfer(_addresses[i], _values[i]*10**uint(decimals));
192 	    }
193     }
194     
195     function _transfer(address _beneficiary, uint256 _tokens) internal{
196         require(_beneficiary != address(0));
197         require(_tokens != 0);
198         transfer(_beneficiary, _tokens);
199     }
200 
201 }