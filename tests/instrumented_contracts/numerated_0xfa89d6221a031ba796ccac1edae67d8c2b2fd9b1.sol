1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // Symbol      : STONT
5 // Name        : STON Token
6 // Total supply: 100,000,0000.000000000000000000
7 // Decimals    : 18
8 // Copyright (c) 2018 <STO Network>. The MIT Licence.
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 library SafeMath {
16     function add(uint a, uint b) internal pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function sub(uint a, uint b) internal pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function mul(uint a, uint b) internal pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function div(uint a, uint b) internal pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 // ERC Token Standard #20 Interface
37 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
38 // ----------------------------------------------------------------------------
39 contract ERC20Interface {
40     function totalSupply() public view returns (uint);
41     function balanceOf(address tokenOwner) public view returns (uint balance);
42     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
43     function transfer(address to, uint _value) public returns (bool success);
44     function approve(address spender, uint _value) public returns (bool success);
45     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
46 
47     event Transfer(address indexed _from, address indexed _to, uint _value);
48     event Approval(address indexed tokenOwner, address indexed spender, uint _value);
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Contract function to receive approval and execute function in one call
54 //
55 // Borrowed from MiniMeToken
56 // ----------------------------------------------------------------------------
57 contract ApproveAndCallFallBack {
58     function receiveApproval(address _from, uint256 _value, address token, bytes memory data) public;
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Owned contract
64 // ----------------------------------------------------------------------------
65 contract Owned {
66     address public owner;
67     address public newOwner;
68 
69     event OwnershipTransferred(address indexed _from, address indexed _to);
70 
71     constructor() public {
72         owner = msg.sender;
73     }
74 
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     function transferOwnership(address _newOwner) public onlyOwner {
81         newOwner = _newOwner;
82     }
83     function acceptOwnership() public {
84         require(msg.sender == newOwner);
85         emit OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87         newOwner = address(0);
88     }
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // ERC20 Token, with the addition of symbol, name and decimals and a
94 // fixed supply
95 // ----------------------------------------------------------------------------
96 contract STONToken is ERC20Interface, Owned {
97     using SafeMath for uint;
98 
99     string public symbol;
100     string public  name;
101     uint8 public decimals;
102     uint _initialSupply;
103     uint _totalSupply;
104 
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107 
108 
109     // ------------------------------------------------------------------------
110     // Constructor
111     // ------------------------------------------------------------------------
112     constructor() public {
113         symbol = "STONT";
114         name = "STON Token";
115         decimals = 18;
116         _initialSupply = 1000000000;
117         _totalSupply = _initialSupply * 10 ** uint(decimals);
118         balances[owner] = _totalSupply;
119         emit Transfer(address(0), owner, _totalSupply);
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public view returns (uint) {
127         return _totalSupply.sub(balances[address(0)]);
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Get the token balance for account `tokenOwner`
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public view returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer the balance from token owner's account to `to` account
141     // - Owner's account must have sufficient balance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transfer(address _to, uint _value) public returns (bool success) {
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         emit Transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Token owner can approve for `spender` to transferFrom(...) `tokens`
154     // from the token owner's account
155     //
156     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
157     // recommends that there are no checks for the approval double-spend attack
158     // as this should be implemented in user interfaces
159     // ------------------------------------------------------------------------
160     function approve(address spender, uint _value) public returns (bool success) {
161         allowed[msg.sender][spender] = _value;
162         emit Approval(msg.sender, spender, _value);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Transfer `tokens` from the `from` account to the `to` account
169     //
170     // The calling account must already have sufficient tokens approve(...)-d
171     // for spending from the `from` account and
172     // - From account must have sufficient balance to transfer
173     // - Spender must have sufficient allowance to transfer
174     // - 0 value transfers are allowed
175     // ------------------------------------------------------------------------
176     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
177         require(balances[_from] >= _value);
178         require(allowed[_from][msg.sender] >= _value);
179         
180         balances[_from] = balances[_from].sub(_value);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         emit Transfer(_from, _to, _value);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Returns the amount of tokens approved by the owner that can be
190     // transferred to the spender's account
191     // ------------------------------------------------------------------------
192     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
193         return allowed[tokenOwner][spender];
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Token owner can approve for `spender` to transferFrom(...) `tokens`
199     // from the token owner's account. The `spender` contract function
200     // `receiveApproval(...)` is then executed
201     // ------------------------------------------------------------------------
202     function approveAndCall(address spender, uint _value, bytes memory data) public returns (bool success) {
203         allowed[msg.sender][spender] = _value;
204         emit Approval(msg.sender, spender, _value);
205         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, _value, address(this), data);
206         return true;
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Don't accept ETH
212     // ------------------------------------------------------------------------
213     function () external payable {
214         revert();
215     }
216 
217 
218     // ------------------------------------------------------------------------
219     // Owner can transfer out any accidentally sent ERC20 tokens
220     // ------------------------------------------------------------------------
221     function transferAnyERC20Token(address tokenAddress, uint _value) public onlyOwner returns (bool success) {
222         return ERC20Interface(tokenAddress).transfer(owner, _value);
223     }
224 }