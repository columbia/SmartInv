1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // FlexibleToken that allows the owner to update the symbol and name of the
5 // token, until the contract is locked down
6 //
7 // Deploy with the following:
8 // - string _symbol, e.g. 'FLX'
9 // - string _name, e.g. 'FlexibleToken'
10 // - uint8 _decimals, e.g. 18
11 // - uint _initialSupply, e.g. 1,000,000.000000000000000000 for 1 mil with 18
12 //   decimals
13 //
14 // Owner can call `setSymbol("xyz")` to update the symbol and
15 // `setName("xyz name")` to update the name. Once the owner calls `lock()`,
16 // the name and symbol can no longer be updated
17 //
18 // Note that blockchain explorers may not automatically update the symbol and
19 // name data when these are changed. You may have to contract them to perform
20 // a manual update
21 //
22 // Enjoy.
23 //
24 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
25 // ----------------------------------------------------------------------------
26 
27 
28 // ----------------------------------------------------------------------------
29 // Safe maths
30 // ----------------------------------------------------------------------------
31 library SafeMath {
32     function add(uint a, uint b) internal pure returns (uint c) {
33         c = a + b;
34         require(c >= a);
35     }
36     function sub(uint a, uint b) internal pure returns (uint c) {
37         require(b <= a);
38         c = a - b;
39     }
40     function mul(uint a, uint b) internal pure returns (uint c) {
41         c = a * b;
42         require(a == 0 || c / a == b);
43     }
44     function div(uint a, uint b) internal pure returns (uint c) {
45         require(b > 0);
46         c = a / b;
47     }
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // ERC Token Standard #20 Interface
53 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
54 // ----------------------------------------------------------------------------
55 contract ERC20Interface {
56     function totalSupply() public constant returns (uint);
57     function balanceOf(address tokenOwner) public constant returns (uint balance);
58     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
59     function transfer(address to, uint tokens) public returns (bool success);
60     function approve(address spender, uint tokens) public returns (bool success);
61     function transferFrom(address from, address to, uint tokens) public returns (bool success);
62 
63     event Transfer(address indexed from, address indexed to, uint tokens);
64     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Contract function to receive approval and execute function in one call,
70 // borrowed from MiniMeToken
71 // ----------------------------------------------------------------------------
72 contract ApproveAndCallFallBack {
73     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
74 }
75 
76 
77 // ----------------------------------------------------------------------------
78 // Owned contract
79 // ----------------------------------------------------------------------------
80 contract Owned {
81     address public owner;
82     address public newOwner;
83 
84     event OwnershipTransferred(address indexed _from, address indexed _to);
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     function Owned() public {
92         owner = msg.sender;
93     }
94     function transferOwnership(address _newOwner) public onlyOwner {
95         newOwner = _newOwner;
96     }
97     function acceptOwnership() public {
98         require(msg.sender == newOwner);
99         emit OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101         newOwner = address(0);
102     }
103 }
104 
105 
106 // ----------------------------------------------------------------------------
107 // ERC20 Token, with the addition of symbol, name and decimals and an
108 // initial fixed supply
109 // ----------------------------------------------------------------------------
110 contract FlexibleToken is ERC20Interface, Owned {
111     using SafeMath for uint;
112 
113     string public symbol;
114     string public  name;
115     uint8 public decimals;
116     uint public _totalSupply;
117     bool public locked = false;
118 
119     mapping(address => uint) balances;
120     mapping(address => mapping(address => uint)) allowed;
121 
122     event Locked();
123     event SymbolUpdated(string oldSymbol, string newSymbol);
124     event NameUpdated(string oldName, string newName);
125 
126     function FlexibleToken(string _symbol, string _name, uint8 _decimals, uint _initialSupply) public {
127         symbol = _symbol;
128         name = _name;
129         decimals = _decimals;
130         _totalSupply = _initialSupply;
131         balances[owner] = _totalSupply;
132         emit Transfer(address(0), owner, _totalSupply);
133     }
134     function lock() public onlyOwner {
135         require(!locked);
136         emit Locked();
137         locked = true;
138     }
139     function setSymbol(string _symbol) public onlyOwner {
140         require(!locked);
141         emit SymbolUpdated(symbol, _symbol);
142         symbol = _symbol;
143     }
144     function setName(string _name) public onlyOwner {
145         require(!locked);
146         emit NameUpdated(name, _name);
147         name = _name;
148     }
149 
150     function totalSupply() public constant returns (uint) {
151         return _totalSupply  - balances[address(0)];
152     }
153     function balanceOf(address tokenOwner) public constant returns (uint balance) {
154         return balances[tokenOwner];
155     }
156     function transfer(address to, uint tokens) public returns (bool success) {
157         balances[msg.sender] = balances[msg.sender].sub(tokens);
158         balances[to] = balances[to].add(tokens);
159         emit Transfer(msg.sender, to, tokens);
160         return true;
161     }
162     function approve(address spender, uint tokens) public returns (bool success) {
163         allowed[msg.sender][spender] = tokens;
164         emit Approval(msg.sender, spender, tokens);
165         return true;
166     }
167     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
168         balances[from] = balances[from].sub(tokens);
169         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
170         balances[to] = balances[to].add(tokens);
171         emit Transfer(from, to, tokens);
172         return true;
173     }
174     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
175         return allowed[tokenOwner][spender];
176     }
177 
178     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
179         allowed[msg.sender][spender] = tokens;
180         emit Approval(msg.sender, spender, tokens);
181         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
182         return true;
183     }
184 
185     function () public payable {
186         revert();
187     }
188     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
189         return ERC20Interface(tokenAddress).transfer(owner, tokens);
190     }
191 }