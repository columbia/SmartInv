1 /*
2 The MIT License
3 
4 Copyright (c) 2017 ZLA Pte. Ltd. https://zla.io
5 
6 Permission is hereby granted, free of charge, to any person obtaining a copy
7 of this software and associated documentation files (the "Software"), to deal
8 in the Software without restriction, including without limitation the rights
9 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
10 copies of the Software, and to permit persons to whom the Software is
11 furnished to do so, subject to the following conditions:
12 
13 The above copyright notice and this permission notice shall be included in
14 all copies or substantial portions of the Software.
15 
16 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
19 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
21 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
22 THE SOFTWARE.
23 */
24 
25 pragma solidity 0.4.25;
26 
27 // ----------------------------------------------------------------------------
28 // Safe maths
29 // ----------------------------------------------------------------------------
30 library SafeMath {
31     function add(uint a, uint b) internal pure returns (uint c) {
32         c = a + b;
33         require(c >= a);
34     }
35     
36     function sub(uint a, uint b) internal pure returns (uint c) {
37         require(b <= a);
38         c = a - b;
39     }
40     
41     function mul(uint a, uint b) internal pure returns (uint c) {
42         c = a * b;
43         require(a == 0 || c / a == b);
44     }
45     
46     function div(uint a, uint b) internal pure returns (uint c) {
47         require(b > 0);
48         c = a / b;
49     }
50 }
51 
52 // ----------------------------------------------------------------------------
53 // ERC Token Standard #20 Interface
54 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
55 // ----------------------------------------------------------------------------
56 contract ERC20Interface {
57     function totalSupply() public constant returns (uint);
58     function balanceOf(address tokenOwner) public constant returns (uint balance);
59     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
60     function transfer(address to, uint tokens) public returns (bool success);
61     function approve(address spender, uint tokens) public returns (bool success);
62     function transferFrom(address from, address to, uint tokens) public returns (bool success);
63 
64     event Transfer(address indexed from, address indexed to, uint tokens);
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66 }
67 
68 // ----------------------------------------------------------------------------
69 // Contract function to receive approval and execute function in one call
70 //
71 // Borrowed from MiniMeToken
72 // ----------------------------------------------------------------------------
73 contract ApproveAndCallFallBack {
74     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
75 }
76 
77 
78 // ----------------------------------------------------------------------------
79 // Owned contract
80 // ----------------------------------------------------------------------------
81 contract Owned {
82     address public owner;
83     address public newOwner;
84 
85     event OwnershipTransferred(address indexed _from, address indexed _to);
86 
87     constructor() public {
88         owner = msg.sender;
89     }
90 
91     modifier onlyOwner {
92         require(msg.sender == owner);
93         _;
94     }
95 
96     function transferOwnership(address _newOwner) public onlyOwner {
97         newOwner = _newOwner;
98     }
99     
100     function acceptOwnership() public {
101         require(msg.sender == newOwner);
102         emit OwnershipTransferred(owner, newOwner);
103         owner = newOwner;
104         newOwner = address(0);
105     }
106 }
107 
108 contract EducationalTokenContract is ERC20Interface, Owned {
109 
110     using SafeMath for uint;
111 
112     string public symbol;
113     string public  name;
114     uint8 public decimals;
115     uint _totalSupply;
116 
117     mapping(address => uint) balances;
118     mapping(address => mapping(address => uint)) allowed;
119 
120     // ------------------------------------------------------------------------
121     // Constructor
122     // ------------------------------------------------------------------------
123     constructor(string s, string n, uint8 d, uint supply, address o) public {
124         symbol = s;
125         name = n;
126         decimals = d;
127         owner = o;
128         _totalSupply = supply * 10**uint(decimals);
129         balances[owner] = _totalSupply;
130         emit Transfer(address(0), owner, _totalSupply);
131     }
132 
133     // ------------------------------------------------------------------------
134     // Total supply
135     // ------------------------------------------------------------------------
136     function totalSupply() public view returns (uint) {
137         return _totalSupply.sub(balances[address(0)]);
138     }
139 
140     // ------------------------------------------------------------------------
141     // Get the token balance for account `tokenOwner`
142     // ------------------------------------------------------------------------
143     function balanceOf(address tokenOwner) public view returns (uint balance) {
144         return balances[tokenOwner];
145     }
146 
147     // ------------------------------------------------------------------------
148     // Transfer the balance from token owner's account to `to` account
149     // - Owner's account must have sufficient balance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152     function transfer(address to, uint tokens) public returns (bool success) {
153         balances[msg.sender] = balances[msg.sender].sub(tokens);
154         balances[to] = balances[to].add(tokens);
155         emit Transfer(msg.sender, to, tokens);
156         return true;
157     }
158 
159     // ------------------------------------------------------------------------
160     // Token owner can approve for `spender` to transferFrom(...) `tokens`
161     // from the token owner's account
162     //
163     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
164     // recommends that there are no checks for the approval double-spend attack
165     // as this should be implemented in user interfaces
166     // ------------------------------------------------------------------------
167     function approve(address spender, uint tokens) public returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         emit Approval(msg.sender, spender, tokens);
170         return true;
171     }
172 
173     // ------------------------------------------------------------------------
174     // Transfer `tokens` from the `from` account to the `to` account
175     //
176     // The calling account must already have sufficient tokens approve(...)-d
177     // for spending from the `from` account and
178     // - From account must have sufficient balance to transfer
179     // - Spender must have sufficient allowance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
183         balances[from] = balances[from].sub(tokens);
184         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
185         balances[to] = balances[to].add(tokens);
186         emit Transfer(from, to, tokens);
187         return true;
188     }
189 
190     // ------------------------------------------------------------------------
191     // Returns the amount of tokens approved by the owner that can be
192     // transferred to the spender's account
193     // ------------------------------------------------------------------------
194     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
195         return allowed[tokenOwner][spender];
196     }
197 
198     // ------------------------------------------------------------------------
199     // Token owner can approve for `spender` to transferFrom(...) `tokens`
200     // from the token owner's account. The `spender` contract function
201     // `receiveApproval(...)` is then executed
202     // ------------------------------------------------------------------------
203     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
204         allowed[msg.sender][spender] = tokens;
205         emit Approval(msg.sender, spender, tokens);
206         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
207         return true;
208     }
209 
210     // ------------------------------------------------------------------------
211     // Don't accept ETH
212     // ------------------------------------------------------------------------
213     function () public payable {
214         revert();
215     }
216 
217     function kill() public {
218         if (msg.sender == owner) {
219             selfdestruct(owner);
220         }
221     }
222 }