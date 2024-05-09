1 pragma solidity ^0.4.23;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2018 Decentralization Authority MDAO.
6  * Released under the MIT License.
7  *
8  * 0GOLD - ZeroGold
9  * Version 18.7.4
10  *
11  * https://d14na.org
12  * support@d14na.org
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
107  * @notice ZeroGold DOES NOT HOLD ANY "OFFICIAL" AFFILIATION with ZeroNet Core,
108  *         ZeroNet.io nor any of its brands and affiliates.
109  *
110  *         ZeroGold DOES currently stand as the "OFFICIAL" token of
111  *         Zeronet Explorer, Zer0net.com, 0net.io and each of their
112  *         respective brands and affiliates.
113  *
114  *         Symbol       : 0GOLD
115  *         Name         : ZeroGold
116  *         Total supply : 21,000,000
117  *         Decimals     : 8
118  *
119  * @dev This is a standard ERC20 token contract, utilizing SafeMath along
120  *      with a few additional public descriptors:
121  *          - name
122  *          - symbol
123  *          - title
124  */
125 contract ZeroGold is ERC20Interface, Owned {
126     using SafeMath for uint;
127 
128     string public symbol;
129     string public name;
130     uint8  public decimals;
131     uint   public _totalSupply;
132 
133     mapping(address => uint) balances;
134     mapping(address => mapping(address => uint)) allowed;
135 
136     /***************************************************************************
137      *
138      * Constructor
139      */
140     constructor() public {
141         symbol          = '0GOLD';
142         name            = 'ZeroGold';
143         decimals        = 8;
144         _totalSupply    = 21000000 * 10 ** uint(decimals);
145         balances[owner] = _totalSupply;
146 
147         emit Transfer(address(0), owner, _totalSupply);
148     }
149 
150     /***************************************************************************
151      *
152      * Total supply
153      */
154     function totalSupply() public constant returns (uint) {
155         return _totalSupply  - balances[address(0)];
156     }
157 
158     /***************************************************************************
159      *
160      * Get the token balance for account `tokenOwner`
161      */
162     function balanceOf(address tokenOwner) public constant returns (uint balance) {
163         return balances[tokenOwner];
164     }
165 
166     /***************************************************************************
167      *
168      * Transfer the balance from token owner's account to `to` account
169      * - Owner's account must have sufficient balance to transfer
170      * - 0 value transfers are allowed
171      */
172     function transfer(address to, uint tokens) public returns (bool success) {
173         balances[msg.sender] = balances[msg.sender].sub(tokens);
174         balances[to]         = balances[to].add(tokens);
175 
176         emit Transfer(msg.sender, to, tokens);
177 
178         return true;
179     }
180 
181     /***************************************************************************
182      *
183      * Token owner can approve for `spender` to transferFrom(...) `tokens`
184      * from the token owner's account
185      *
186      * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
187      * recommends that there are no checks for the approval double-spend attack
188      * as this should be implemented in user interfaces
189      */
190     function approve(address spender, uint tokens) public returns (bool success) {
191         allowed[msg.sender][spender] = tokens;
192 
193         emit Approval(msg.sender, spender, tokens);
194 
195         return true;
196     }
197 
198     /***************************************************************************
199      *
200      * Transfer `tokens` from the `from` account to the `to` account.
201      *
202      * The calling account must already have sufficient tokens approve(...)-d
203      * for spending from the `from` account and:
204      *     - From account must have sufficient balance to transfer
205      *     - Spender must have sufficient allowance to transfer
206      *     - 0 value transfers are allowed
207      */
208     function transferFrom(
209         address from, address to, uint tokens) public returns (
210         bool success) {
211         balances[from]            = balances[from].sub(tokens);
212         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
213         balances[to]              = balances[to].add(tokens);
214 
215         emit Transfer(from, to, tokens);
216 
217         return true;
218     }
219 
220     /***************************************************************************
221      *
222      * Returns the amount of tokens approved by the owner that can be
223      * transferred to the spender's account
224      */
225     function allowance(
226         address tokenOwner, address spender) public constant returns (
227         uint remaining) {
228         return allowed[tokenOwner][spender];
229     }
230 
231     /***************************************************************************
232      *
233      * Token owner can approve for `spender` to transferFrom(...) `tokens`
234      * from the token owner's account. The `spender` contract function
235      * `receiveApproval(...)` is then executed
236      */
237     function approveAndCall(
238         address spender, uint tokens, bytes data) public returns (
239         bool success) {
240         allowed[msg.sender][spender] = tokens;
241 
242         emit Approval(msg.sender, spender, tokens);
243 
244         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
245 
246         return true;
247     }
248 
249     /***************************************************************************
250      *
251      * Don't accept ETH
252      */
253     function () public payable {
254         revert();
255     }
256 
257     /***************************************************************************
258      *
259      * Owner can transfer out any accidentally sent ERC20 tokens
260      */
261     function transferAnyERC20Token(
262         address tokenAddress, uint tokens) public onlyOwner returns (
263         bool success) {
264         return ERC20Interface(tokenAddress).transfer(owner, tokens);
265     }
266 }