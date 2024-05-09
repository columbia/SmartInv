1 pragma solidity ^0.4.18;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2018 CryptoKitty Go MDAO.
6  * Released under the MIT License.
7  * 
8  * CKGO - CryptoKitty Go Catnip Contract
9  * Version 18.1.5
10  *
11  * https://cryptokittygo.com
12  * support@cryptokittygo.com
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
80     function Owned() public {
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
92     function acceptOwnership() public {
93         require(msg.sender == newOwner);
94 
95         OwnershipTransferred(owner, newOwner);
96         
97         owner = newOwner;
98         
99         newOwner = address(0);
100     }
101 }
102 
103 
104 /*******************************************************************************
105  *
106  * @notice Catnip is the official token of the CryptoKitty Go mobile game.
107  *         Players can earn catnip within the app, which can be used for
108  *         a variety of in-game features (including breeding new kitties).
109  *
110  *         Symbol       : CKGO
111  *         Name         : CryptoKitty Go Catnip
112  *         Total supply : 1,000,000,000
113  *         Decimals     : 0
114  *
115  * @dev This is a standard ERC20 token contract, utilizing SafeMath along
116  *      with a few additional public descriptors:
117  *          - name
118  *          - symbol
119  *          - title
120  */
121 contract Catnip is ERC20Interface, Owned {
122     using SafeMath for uint;
123 
124     string public symbol;
125     string public name;
126     uint8  public decimals;
127     uint   public _totalSupply;
128 
129     mapping(address => uint) balances;
130     mapping(address => mapping(address => uint)) allowed;
131 
132     /***************************************************************************
133      *
134      * Constructor
135      */
136     function Catnip() public {
137         symbol          = 'CKGO';
138         name            = 'CryptoKitty Go Catnip';
139         decimals        = 0;
140         _totalSupply    = 1000000000 * 10 ** uint(decimals);
141         balances[owner] = _totalSupply;
142         
143         Transfer(address(0), owner, _totalSupply);
144     }
145 
146     /***************************************************************************
147      *
148      * Total supply
149      */
150     function totalSupply() public constant returns (uint) {
151         return _totalSupply  - balances[address(0)];
152     }
153 
154     /***************************************************************************
155      *
156      * Get the token balance for account `tokenOwner`
157      */
158     function balanceOf(address tokenOwner) public constant returns (uint balance) {
159         return balances[tokenOwner];
160     }
161 
162     /***************************************************************************
163      *
164      * Transfer the balance from token owner's account to `to` account
165      * - Owner's account must have sufficient balance to transfer
166      * - 0 value transfers are allowed
167      */
168     function transfer(address to, uint tokens) public returns (bool success) {
169         balances[msg.sender] = balances[msg.sender].sub(tokens);
170         balances[to]         = balances[to].add(tokens);
171         
172         Transfer(msg.sender, to, tokens);
173         
174         return true;
175     }
176 
177     /***************************************************************************
178      *
179      * Token owner can approve for `spender` to transferFrom(...) `tokens`
180      * from the token owner's account
181      *
182      * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
183      * recommends that there are no checks for the approval double-spend attack
184      * as this should be implemented in user interfaces 
185      */
186     function approve(address spender, uint tokens) public returns (bool success) {
187         allowed[msg.sender][spender] = tokens;
188 
189         Approval(msg.sender, spender, tokens);
190         
191         return true;
192     }
193 
194     /***************************************************************************
195      *
196      * Transfer `tokens` from the `from` account to the `to` account.
197      *
198      * The calling account must already have sufficient tokens approve(...)-d
199      * for spending from the `from` account and:
200      *     - From account must have sufficient balance to transfer
201      *     - Spender must have sufficient allowance to transfer
202      *     - 0 value transfers are allowed
203      */
204     function transferFrom(
205     	address from, address to, uint tokens) public returns (
206     	bool success) {
207         balances[from]            = balances[from].sub(tokens);
208         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
209         balances[to]              = balances[to].add(tokens);
210 
211         Transfer(from, to, tokens);
212         
213         return true;
214     }
215 
216     /***************************************************************************
217      *
218      * Returns the amount of tokens approved by the owner that can be
219      * transferred to the spender's account
220      */
221     function allowance(
222     	address tokenOwner, address spender) public constant returns (
223     	uint remaining) {
224         return allowed[tokenOwner][spender];
225     }
226 
227     /***************************************************************************
228      *
229      * Token owner can approve for `spender` to transferFrom(...) `tokens`
230      * from the token owner's account. The `spender` contract function
231      * `receiveApproval(...)` is then executed
232      */
233     function approveAndCall(
234     	address spender, uint tokens, bytes data) public returns (
235     	bool success) {
236         allowed[msg.sender][spender] = tokens;
237 
238         Approval(msg.sender, spender, tokens);
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