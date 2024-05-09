1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-04
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 // ----------------------------------------------------------------------------
8 // 'OASCHAIN' token contract
9 // ----------------------------------------------------------------------------
10 
11 // ----------------------------------------------------------------------------
12 // Safe maths
13 // ----------------------------------------------------------------------------
14 contract SafeMath {
15     function safeAdd(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function safeSub(uint a, uint b) internal pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function safeMul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function safeDiv(uint a, uint b) internal pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 
34 // ----------------------------------------------------------------------------
35 // ERC Token Standard #20 Interface
36 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
37 // ----------------------------------------------------------------------------
38 contract ERC20Interface {
39     function totalSupply() public view returns (uint);
40     function balanceOf(address tokenOwner) public view returns (uint balance);
41     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Owned {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     function Owned() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) public onlyOwner {
70         newOwner = _newOwner;
71     }
72     function acceptOwnership() public {
73         require(msg.sender == newOwner);
74         OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76         newOwner = address(0);
77     }
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // ERC20 Token, with the addition of symbol, name and decimals and assisted
83 // token transfers
84 // ----------------------------------------------------------------------------
85 contract OASToken is ERC20Interface, Owned, SafeMath {
86     string public name = "OASCHAIN";
87     string public symbol = "OAS";
88     uint8 public decimals = 18;
89     uint public _totalSupply;
90     uint public startDate;
91     bool public isLocked;
92 
93     mapping(address => uint) balances;
94     mapping(address => mapping(address => uint)) allowed;
95 
96 
97     // ------------------------------------------------------------------------
98     // Constructor
99     // ------------------------------------------------------------------------
100     function OASToken(uint tokens) public {
101         _totalSupply = tokens;
102         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
103         isLocked = false;
104     }
105     
106     modifier isNotLocked {
107         require(!isLocked);
108         _;
109     }
110     
111     function setIsLocked(bool _isLocked) public {
112         isLocked = _isLocked;
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Total supply
118     // ------------------------------------------------------------------------
119     function totalSupply() public view returns (uint) {
120         return _totalSupply  - balances[address(0)];
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Get the token balance for account `tokenOwner`
126     // ------------------------------------------------------------------------
127     function balanceOf(address tokenOwner) public view returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Transfer the balance from token owner's account to `to` account
134     // - Owner's account must have sufficient balance to transfer
135     // - 0 value transfers are allowed
136     // ------------------------------------------------------------------------
137     function transfer(address to, uint tokens) public isNotLocked returns (bool success) {
138         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
139         balances[to] = safeAdd(balances[to], tokens);
140         Transfer(msg.sender, to, tokens);
141         return true;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Token owner can approve for `spender` to transferFrom(...) `tokens`
147     // from the token owner's account
148     //
149     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
150     // recommends that there are no checks for the approval double-spend attack
151     // as this should be implemented in user interfaces
152     // ------------------------------------------------------------------------
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Transfer `tokens` from the `from` account to the `to` account
162     //
163     // The calling account must already have sufficient tokens approve(...)-d
164     // for spending from the `from` account and
165     // - From account must have sufficient balance to transfer
166     // - Spender must have sufficient allowance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transferFrom(address from, address to, uint tokens) public isNotLocked returns (bool success) {
170         balances[from] = safeSub(balances[from], tokens);
171         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
172         balances[to] = safeAdd(balances[to], tokens);
173         Transfer(from, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Returns the amount of tokens approved by the owner that can be
180     // transferred to the spender's account
181     // ------------------------------------------------------------------------
182     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
183         return allowed[tokenOwner][spender];
184     }
185 
186 
187     function () external payable {
188         revert();
189     }
190 
191     // ------------------------------------------------------------------------
192     // INCREASE token supply
193     // ------------------------------------------------------------------------
194     function mint(address to, uint value) public onlyOwner returns (bool) {
195         require(value > 0);
196         _totalSupply = safeAdd(_totalSupply, value);
197         balances[to] = safeAdd(balances[to], value);
198         Transfer(0, to, value);
199         return true;
200     }
201 
202     // ------------------------------------------------------------------------
203     // DECREASE token supply
204     // ------------------------------------------------------------------------
205     function burn(address from, uint value) public onlyOwner returns (bool) {
206         require(value > 0);
207         require(balances[from] >= value);
208         balances[from] = safeSub(balances[from], value);
209         _totalSupply = safeSub(_totalSupply, value);
210         Transfer(from, 0, value);
211         return true;
212     }
213 
214 }