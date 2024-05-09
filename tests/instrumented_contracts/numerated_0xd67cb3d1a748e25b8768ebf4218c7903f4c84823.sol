1 pragma solidity ^0.4.23;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2018 Taboo University MDAO.
6  * Released under the MIT License.
7  * 
8  * TABOO - Taboo Gold
9  * Version 18.4.29
10  *
11  * https://taboou.com
12  * support@taboou.com
13  */
14 
15 
16 /*******************************************************************************
17  *
18  * SafeMath
19  */
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
40 /*******************************************************************************
41  *
42  * ERC Token Standard #20 Interface
43  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44  */
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 /*******************************************************************************
59  *
60  * ApproveAndCallFallBack
61  *
62  * Contract function to receive approval and execute function in one call
63  * (borrowed from MiniMeToken)
64  */
65 contract ApproveAndCallFallBack {
66     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
67 }
68 
69 
70 /*******************************************************************************
71  *
72  * Owned contract
73  */
74 contract Owned {
75     address public owner;
76     address public newOwner;
77 
78     event OwnershipTransferred(address indexed _from, address indexed _to);
79 
80     constructor() public {
81         owner = msg.sender;
82     }
83 
84     modifier onlyOwner {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     function transferOwnership(address _newOwner) public onlyOwner {
90         newOwner = _newOwner;
91     }
92     
93     function acceptOwnership() public {
94         require(msg.sender == newOwner);
95 
96         emit OwnershipTransferred(owner, newOwner);
97         
98         owner = newOwner;
99         
100         newOwner = address(0);
101     }
102 }
103 
104 
105 /*******************************************************************************
106  *
107  * @notice Taboo Coins are the official token of Taboo University Networks.
108  *
109  *         Symbol       : TABOO
110  *         Name         : Taboo Gold
111  *         Total supply : 100,000,000
112  *         Decimals     : 6
113  *
114  * @dev This is a standard ERC20 token contract, utilizing SafeMath along
115  *      with a few additional public descriptors:
116  *          - name
117  *          - symbol
118  *          - title
119  */
120 contract Taboo is ERC20Interface, Owned {
121     using SafeMath for uint;
122 
123     string public symbol;
124     string public name;
125     uint8  public decimals;
126     uint   public _totalSupply;
127 
128     mapping(address => uint) balances;
129     mapping(address => mapping(address => uint)) allowed;
130 
131     /***************************************************************************
132      *
133      * Constructor
134      */
135     constructor() public {
136         symbol          = 'TABOO';
137         name            = 'Taboo Gold';
138         decimals        = 6;
139         _totalSupply    = 100000000 * 10 ** uint(decimals);
140         balances[owner] = _totalSupply;
141         
142         emit Transfer(address(0), owner, _totalSupply);
143     }
144 
145     /***************************************************************************
146      *
147      * Total supply
148      */
149     function totalSupply() public constant returns (uint) {
150         return _totalSupply  - balances[address(0)];
151     }
152 
153     /***************************************************************************
154      *
155      * Get the token balance for account `tokenOwner`
156      */
157     function balanceOf(address tokenOwner) public constant returns (uint balance) {
158         return balances[tokenOwner];
159     }
160 
161     /***************************************************************************
162      *
163      * Transfer the balance from token owner's account to `to` account
164      * - Owner's account must have sufficient balance to transfer
165      * - 0 value transfers are allowed
166      */
167     function transfer(address to, uint tokens) public returns (bool success) {
168         balances[msg.sender] = balances[msg.sender].sub(tokens);
169         balances[to]         = balances[to].add(tokens);
170         
171         emit Transfer(msg.sender, to, tokens);
172         
173         return true;
174     }
175 
176     /***************************************************************************
177      *
178      * Token owner can approve for `spender` to transferFrom(...) `tokens`
179      * from the token owner's account
180      *
181      * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
182      * recommends that there are no checks for the approval double-spend attack
183      * as this should be implemented in user interfaces 
184      */
185     function approve(address spender, uint tokens) public returns (bool success) {
186         allowed[msg.sender][spender] = tokens;
187 
188         emit Approval(msg.sender, spender, tokens);
189         
190         return true;
191     }
192 
193     /***************************************************************************
194      *
195      * Transfer `tokens` from the `from` account to the `to` account.
196      *
197      * The calling account must already have sufficient tokens approve(...)-d
198      * for spending from the `from` account and:
199      *     - From account must have sufficient balance to transfer
200      *     - Spender must have sufficient allowance to transfer
201      *     - 0 value transfers are allowed
202      */
203     function transferFrom(
204     	address from, address to, uint tokens) public returns (
205     	bool success) {
206         balances[from]            = balances[from].sub(tokens);
207         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
208         balances[to]              = balances[to].add(tokens);
209 
210         emit Transfer(from, to, tokens);
211         
212         return true;
213     }
214 
215     /***************************************************************************
216      *
217      * Returns the amount of tokens approved by the owner that can be
218      * transferred to the spender's account
219      */
220     function allowance(
221     	address tokenOwner, address spender) public constant returns (
222     	uint remaining) {
223         return allowed[tokenOwner][spender];
224     }
225 
226     /***************************************************************************
227      *
228      * Token owner can approve for `spender` to transferFrom(...) `tokens`
229      * from the token owner's account. The `spender` contract function
230      * `receiveApproval(...)` is then executed
231      */
232     function approveAndCall(
233     	address spender, uint tokens, bytes data) public returns (
234     	bool success) {
235         allowed[msg.sender][spender] = tokens;
236 
237         emit Approval(msg.sender, spender, tokens);
238         
239         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
240         
241         return true;
242     }
243 
244     /***************************************************************************
245      *
246      * Don't accept ETH
247      */
248     function () public payable {
249         revert();
250     }
251 
252     /***************************************************************************
253      *
254      * Owner can transfer out any accidentally sent ERC20 tokens
255      */
256     function transferAnyERC20Token(
257     	address tokenAddress, uint tokens) public onlyOwner returns (
258     	bool success) {
259         return ERC20Interface(tokenAddress).transfer(owner, tokens);
260     }
261 }