1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.10;
7 
8 /*************************************************************************
9  * import "./ITokenPool.sol" : start
10  *************************************************************************/
11 
12 /*************************************************************************
13  * import "./ERC20StandardToken.sol" : start
14  *************************************************************************/
15 
16 /*************************************************************************
17  * import "./IERC20Token.sol" : start
18  *************************************************************************/
19 
20 /**@dev ERC20 compliant token interface. 
21 https://theethereum.wiki/w/index.php/ERC20_Token_Standard 
22 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md */
23 contract IERC20Token {
24 
25     // these functions aren't abstract since the compiler emits automatically generated getter functions as external    
26     function name() public constant returns (string _name) { _name; }
27     function symbol() public constant returns (string _symbol) { _symbol; }
28     function decimals() public constant returns (uint8 _decimals) { _decimals; }
29     
30     function totalSupply() constant returns (uint total) {total;}
31     function balanceOf(address _owner) constant returns (uint balance) {_owner; balance;}    
32     function allowance(address _owner, address _spender) constant returns (uint remaining) {_owner; _spender; remaining;}
33 
34     function transfer(address _to, uint _value) returns (bool success);
35     function transferFrom(address _from, address _to, uint _value) returns (bool success);
36     function approve(address _spender, uint _value) returns (bool success);
37     
38 
39     event Transfer(address indexed _from, address indexed _to, uint _value);
40     event Approval(address indexed _owner, address indexed _spender, uint _value);
41 }
42 /*************************************************************************
43  * import "./IERC20Token.sol" : end
44  *************************************************************************/
45 /*************************************************************************
46  * import "../common/SafeMath.sol" : start
47  *************************************************************************/
48 
49 /**dev Utility methods for overflow-proof arithmetic operations 
50 */
51 contract SafeMath {
52 
53     /**dev Returns the sum of a and b. Throws an exception if it exceeds uint256 limits*/
54     function safeAdd(uint256 a, uint256 b) internal returns (uint256) {        
55         uint256 c = a + b;
56         assert(c >= a);
57 
58         return c;
59     }
60 
61     /**dev Returns the difference of a and b. Throws an exception if a is less than b*/
62     function safeSub(uint256 a, uint256 b) internal returns (uint256) {
63         assert(a >= b);
64         return a - b;
65     }
66 
67     /**dev Returns the product of a and b. Throws an exception if it exceeds uint256 limits*/
68     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
69         uint256 z = x * y;
70         assert((x == 0) || (z / x == y));
71         return z;
72     }
73 
74     function safeDiv(uint256 x, uint256 y) internal returns (uint256) {
75         assert(y != 0);
76         return x / y;
77     }
78 }/*************************************************************************
79  * import "../common/SafeMath.sol" : end
80  *************************************************************************/
81 
82 /**@dev Standard ERC20 compliant token implementation */
83 contract ERC20StandardToken is IERC20Token, SafeMath {
84     string public name;
85     string public symbol;
86     uint8 public decimals;
87 
88     //tokens already issued
89     uint256 tokensIssued;
90     //balances for each account
91     mapping (address => uint256) balances;
92     //one account approves the transfer of an amount to another account
93     mapping (address => mapping (address => uint256)) allowed;
94 
95     function ERC20StandardToken() {
96      
97     }    
98 
99     //
100     //IERC20Token implementation
101     // 
102 
103     function totalSupply() constant returns (uint total) {
104         total = tokensIssued;
105     }
106  
107     function balanceOf(address _owner) constant returns (uint balance) {
108         balance = balances[_owner];
109     }
110 
111     function transfer(address _to, uint256 _value) returns (bool) {
112         require(_to != address(0));
113 
114         // safeSub inside doTransfer will throw if there is not enough balance.
115         doTransfer(msg.sender, _to, _value);        
116         Transfer(msg.sender, _to, _value);
117         return true;
118     }
119 
120     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
121         require(_to != address(0));
122         
123         // Check for allowance is not needed because sub(_allowance, _value) will throw if this condition is not met
124         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);        
125         // safeSub inside doTransfer will throw if there is not enough balance.
126         doTransfer(_from, _to, _value);        
127         Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     function approve(address _spender, uint256 _value) returns (bool success) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
138         remaining = allowed[_owner][_spender];
139     }    
140 
141     //
142     // Additional functions
143     //
144     /**@dev Gets real token amount in the smallest token units */
145     function getRealTokenAmount(uint256 tokens) constant returns (uint256) {
146         return tokens * (uint256(10) ** decimals);
147     }
148 
149     //
150     // Internal functions
151     //    
152     
153     function doTransfer(address _from, address _to, uint256 _value) internal {
154         balances[_from] = safeSub(balances[_from], _value);
155         balances[_to] = safeAdd(balances[_to], _value);
156     }
157 }/*************************************************************************
158  * import "./ERC20StandardToken.sol" : end
159  *************************************************************************/
160 
161 /**@dev Token pool that manages its tokens by designating trustees */
162 contract ITokenPool {    
163 
164     /**@dev Token to be managed */
165     ERC20StandardToken public token;
166 
167     /**@dev Changes trustee state */
168     function setTrustee(address trustee, bool state);
169 
170     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
171     /**@dev Returns remaining token amount */
172     function getTokenAmount() constant returns (uint256 tokens) {tokens;}
173 }/*************************************************************************
174  * import "./ITokenPool.sol" : end
175  *************************************************************************/
176 /*************************************************************************
177  * import "../common/Manageable.sol" : start
178  *************************************************************************/
179 
180 /*************************************************************************
181  * import "../common/Owned.sol" : start
182  *************************************************************************/
183 
184 
185 contract Owned {
186     address public owner;        
187 
188     function Owned() {
189         owner = msg.sender;
190     }
191 
192     // allows execution by the owner only
193     modifier ownerOnly {
194         assert(msg.sender == owner);
195         _;
196     }
197 
198     /**@dev allows transferring the contract ownership. */
199     function transferOwnership(address _newOwner) public ownerOnly {
200         require(_newOwner != owner);
201         owner = _newOwner;
202     }
203 }
204 /*************************************************************************
205  * import "../common/Owned.sol" : end
206  *************************************************************************/
207 
208 ///A token that have an owner and a list of managers that can perform some operations
209 ///Owner is always a manager too
210 contract Manageable is Owned {
211 
212     event ManagerSet(address manager, bool state);
213 
214     mapping (address => bool) public managers;
215 
216     function Manageable() Owned() {
217         managers[owner] = true;
218     }
219 
220     /**@dev Allows execution by managers only */
221     modifier managerOnly {
222         assert(managers[msg.sender]);
223         _;
224     }
225 
226     function transferOwnership(address _newOwner) public ownerOnly {
227         super.transferOwnership(_newOwner);
228 
229         managers[_newOwner] = true;
230         managers[msg.sender] = false;
231     }
232 
233     function setManager(address manager, bool state) ownerOnly {
234         managers[manager] = state;
235         ManagerSet(manager, state);
236     }
237 }/*************************************************************************
238  * import "../common/Manageable.sol" : end
239  *************************************************************************/
240 
241 /**@dev Token pool that manages its tokens by designating trustees */
242 contract TokenPool is Manageable, ITokenPool {    
243 
244     function TokenPool(ERC20StandardToken _token) {
245         token = _token;
246     }
247 
248     /**@dev ITokenPool override */
249     function setTrustee(address trustee, bool state) managerOnly {
250         if (state) {
251             token.approve(trustee, token.balanceOf(this));
252         } else {
253             token.approve(trustee, 0);
254         }
255     }
256 
257     /**@dev ITokenPool override */
258     function getTokenAmount() constant returns (uint256 tokens) {
259         tokens = token.balanceOf(this);
260     }
261 
262     /**@dev Returns all tokens back to owner */
263     function returnTokensTo(address to) managerOnly {
264         token.transfer(to, token.balanceOf(this));
265     }
266 }