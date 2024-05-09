1 pragma solidity 0.4.23;
2 
3 /**
4  * ERC20 compliant interface
5  * See: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 **/
7 contract ERC20Interface {
8     function totalSupply() public view returns (uint256);
9     function balanceOf(address account) public view returns (uint256);
10     function allowance(address owner, address spender) public view returns (uint256);
11     function transfer(address recipient, uint256 amount) public returns (bool);
12     function transferFrom(address from, address to, uint256 amount) public returns (bool);
13     function approve(address spender, uint256 amount) public returns (bool);
14 
15     event Transfer(address indexed sender, address indexed recipient, uint256 amount);
16     event Approval(address indexed owner, address indexed spender, uint256 amount);
17 }
18 
19 /**
20  * @title SafeMath
21  * Math operations with safety checks that throw on error
22 **/
23 library SafeMath {
24 
25     /**
26      * Adds two numbers a and b, throws on overflow.
27     **/
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31 
32         return c;
33     }
34 
35     /**
36      * Subtracts two numbers a and b, throws on overflow (i.e. if b is greater than a).
37     **/
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a);
40 
41         return a - b;
42     }
43 
44     /**
45      * Multiplies two numbers, throws on overflow.
46     **/
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51 
52         uint256 c = a * b;
53         assert(c / a == b);
54 
55         return c;
56     }
57 
58     /**
59      * Divide of two numbers (a by b), truncating the quotient.
60     **/
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         // require(b > 0); // Solidity automatically throws when dividing by 0
63 
64         return a / b;
65     }
66 }
67 
68 /**
69  * ERC20 compliant token
70 **/
71 contract ERC20Token is ERC20Interface {
72     using SafeMath for uint256;
73 
74     uint256 _totalSupply;
75 
76     mapping(address => uint256) balances;
77     mapping(address => mapping(address => uint256)) internal allowed;
78 
79     /**
80      * Return total number of tokens in existence.
81     **/
82     function totalSupply() public view returns (uint256) {
83         return _totalSupply;
84     }
85 
86     /**
87      * Get the balance of the specified address.
88      * @param account - The address to query the the balance of.
89      * @return An uint256 representing the amount owned by the passed address.
90     **/
91     function balanceOf(address account) public view returns (uint256) {
92         return balances[account];
93     }
94 
95     /**
96      * Check the amount of tokens that an owner allowed to a spender.
97      * @param owner - The address which owns the funds.
98      * @param spender - The address which will spend the funds.
99      * @return An uint256 specifying the amount of tokens still available for the spender.
100     **/
101     function allowance(address owner, address spender) public view returns (uint256) {
102         return allowed[owner][spender];
103     }
104 
105     /**
106      * Transfer token to a specified address from 'msg.sender'.
107      * @param recipient - The address to transfer to.
108      * @param amount - The amount to be transferred.
109      * @return true if transfer is successfull, error otherwise.
110     **/
111     function transfer(address recipient, uint256 amount) public returns (bool) {
112         require(recipient != address(0) && recipient != address(this));
113         require(amount <= balances[msg.sender], "insufficient funds");
114 
115         balances[msg.sender] = balances[msg.sender].sub(amount);
116         balances[recipient] = balances[recipient].add(amount);
117 
118         emit Transfer(msg.sender, recipient, amount);
119 
120         return true;
121     }
122 
123     /**
124      * Transfer tokens from one address to another.
125      * @param from - The address which you want to send tokens from.
126      * @param to - The address which you want to transfer to.
127      * @param amount - The amount of tokens to be transferred.
128      * @return true if transfer is successfull, error otherwise.
129     **/
130     function transferFrom(address from, address to, uint256 amount) public returns (bool) {
131         require(to != address(0) && to != address(this));
132         require(amount <= balances[from] && amount <= allowed[from][msg.sender], "insufficient funds");
133 
134         balances[from] = balances[from].sub(amount);
135         balances[to] = balances[to].add(amount);
136         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
137 
138         emit Transfer(from, to, amount);
139         
140         return true;
141     }
142 
143     /**
144      * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145      * Beware that changing an allowance with this method brings the risk that someone may use both the old
146      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      * @param spender - The address which will spend the funds.
150      * @param amount - The amount of tokens to be spent.
151      * @return true if transfer is successfull, error otherwise.
152     **/
153     function approve(address spender, uint256 amount) public returns (bool) {
154         require(spender != address(0) && spender != address(this));
155         require(amount == 0 || allowed[msg.sender][spender] == 0); // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156 
157         allowed[msg.sender][spender] = amount;
158         emit Approval(msg.sender, spender, amount);
159 
160         return true;
161     }
162 }
163 
164 /**
165  * @title Ownable
166  * The Ownable contract has an owner address, and provides basic authorization control
167  * functions, this simplifies the implementation of "user permissions".
168 **/
169 contract Ownable {
170     address public owner;
171 
172     /**
173      * The Ownable constructor sets the original `owner` of the contract to the sender
174      * account.
175     **/
176     constructor() public {
177         owner = msg.sender;
178     }
179 
180     /**
181      * Throws if called by any account other than the owner.
182     **/
183     modifier onlyOwner() {
184         require(msg.sender == owner);
185         _;
186     }
187 }
188 
189 /**
190  * @title BurnableToken
191  * Implements a token contract in which the owner can burn tokens only from his account.
192 **/
193 contract BurnableToken is Ownable, ERC20Token {
194 
195     event Burn(address indexed burner, uint256 value);
196 
197     /**
198      * Owner can burn a specific amount of tokens from his account.
199      * @param amount - The amount of token to be burned.
200      * @return true if burning is successfull, error otherwise.
201     **/
202     function burn(uint256 amount) public onlyOwner returns (bool) {
203         require(amount <= balances[owner], "amount should be less than available balance");
204 
205         balances[owner] = balances[owner].sub(amount);
206         _totalSupply = _totalSupply.sub(amount);
207 
208         emit Burn(owner, amount);
209         emit Transfer(owner, address(0), amount);
210 
211         return true;
212     }
213 }
214 
215 /**
216  * @title PausableToken
217  * Implements a token contract that can be paused and resumed by owner.
218 **/
219 contract PausableToken is Ownable, ERC20Token {
220     event Pause();
221     event Unpause();
222 
223     bool public paused = false;
224 
225     /**
226      * Modifier to make a function callable only when the contract is not paused.
227     **/
228     modifier whenNotPaused() {
229         require(!paused);
230         _;
231     }
232 
233     /**
234      * Modifier to make a function callable only when the contract is paused.
235     **/
236     modifier whenPaused() {
237         require(paused);
238         _;
239     }
240 
241     /**
242      * Owner can pause the contract (Goes to paused state).
243     **/
244     function pause() onlyOwner whenNotPaused public {
245         paused = true;
246         emit Pause();
247     }
248 
249     /**
250      * Owner can unpause the contract (Goes to unpaused state).
251     **/
252     function unpause() onlyOwner whenPaused public {
253         paused = false;
254         emit Unpause();
255     }
256 
257     /**
258      * ERC20 specific 'transfer' is only allowed, if contract is not in paused state.
259     **/
260     function transfer(address recipient, uint256 amount) public whenNotPaused returns (bool) {
261         return super.transfer(recipient, amount);
262     }
263 
264     /**
265      * ERC20 specific 'transferFrom' is only allowed, if contract is not in paused state.
266     **/
267     function transferFrom(address from, address to, uint256 amount) public whenNotPaused returns (bool) {
268         return super.transferFrom(from, to, amount);
269     }
270 
271     /**
272      * ERC20 specific 'approve' is only allowed, if contract is not in paused state.
273     **/
274     function approve(address spender, uint256 amount) public whenNotPaused returns (bool) {
275         return super.approve(spender, amount);
276     }
277 }
278 
279 /**
280  * Bloxia Fixed Supply Token Contract
281 **/
282 contract BloxiaToken is Ownable, ERC20Token, PausableToken, BurnableToken {
283 
284     string public constant name = "Bloxia";
285     string public constant symbol = "BLOX";
286     uint8 public constant decimals = 18;
287 
288     uint256 constant initial_supply = 500000000 * (10 ** uint256(decimals)); // 500 Million
289 
290     /**
291      * Constructor that gives 'msg.sender' all of existing tokens.
292     **/
293     constructor() public {
294         _totalSupply = initial_supply;
295         balances[msg.sender] = initial_supply;
296         emit Transfer(0x0, msg.sender, initial_supply);
297     }
298 }