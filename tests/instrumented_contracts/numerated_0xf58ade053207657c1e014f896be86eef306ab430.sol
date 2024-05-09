1 pragma solidity ^0.5.2;
2 
3 
4 // library that we use in this contract for valuation
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         assert(b > 0); 
13         uint256 c = a / b;
14         assert(a == b * c + a % b); 
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 // interface of your Customize token
29 interface ERC20Interface {
30 
31     function balanceOf(address _owner) external view returns (uint256 balance);
32     function transfer(address _to, uint256 _value) external returns(bool); 
33     function transferFrom(address _from, address _to, uint256 _value) external returns(bool);
34     function totalSupply() external view returns (uint256);
35     function approve(address _spender, uint256 _value) external returns(bool);
36     function allowance(address _owner, address _spender) external view returns(uint256);
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // ERC20 Token, with the addition of symbol, name and decimals and assisted
46 // token transfers
47 // ----------------------------------------------------------------------------
48 contract ERC20 is ERC20Interface {
49     using SafeMath for uint256;
50 
51     string public symbol;
52     string public  name;
53     uint8 public decimals;
54     uint256 internal _totalSupply;
55     address owner;
56     
57     mapping(address => uint256) balances;
58     mapping(address => mapping(address => uint256)) allowed;
59 
60     // functions with this modifier can only be executed by the owner
61     modifier onlyOwner() {
62         if (msg.sender != owner) {
63             revert();
64         }
65          _;
66     }
67 
68 
69     
70 
71     // ------------------------------------------------------------------------
72     // Total supply
73     // ------------------------------------------------------------------------
74     function totalSupply() public view returns (uint256) {
75         return _totalSupply.sub(balances[address(0)]);
76     }
77 
78 
79     // ------------------------------------------------------------------------
80     // Get the token balance for account `tokenOwner`
81     // ------------------------------------------------------------------------
82     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
83         return balances[tokenOwner];
84     }
85 
86 
87     // ------------------------------------------------------------------------
88     // Transfer the balance from token owner's account to `to` account
89     // - Owner's account must have sufficient balance to transfer
90     // - 0 value transfers are allowed
91     // ------------------------------------------------------------------------
92     function transfer(address to, uint256 tokens) public returns (bool success) {
93         balances[msg.sender] = balances[msg.sender].sub(tokens);
94         balances[to] = balances[to].add(tokens);
95         emit Transfer(msg.sender, to, tokens);
96         return true;
97     }
98 
99 
100     // ------------------------------------------------------------------------
101     // Token owner can approve for `spender` to transferFrom(...) `tokens`
102     // from the token owner's account
103     //
104     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
105     // recommends that there are no checks for the approval double-spend attack
106     // as this should be implemented in user interfaces
107     // ------------------------------------------------------------------------
108     function approve(address spender, uint tokens) public returns (bool success) {
109         allowed[msg.sender][spender] = tokens;
110         emit Approval(msg.sender, spender, tokens);
111         return true;
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Transfer `tokens` from the `from` account to the `to` account
117     //
118     // The calling account must already have sufficient tokens approve(...)-d
119     // for spending from the `from` account and
120     // - From account must have sufficient balance to transfer
121     // - Spender must have sufficient allowance to transfer
122     // - 0 value transfers are allowed
123     // ------------------------------------------------------------------------
124     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
125         balances[from] = balances[from].sub(tokens);
126         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
127         balances[to] = balances[to].add(tokens);
128         emit Transfer(from, to, tokens);
129         return true;
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Returns the amount of tokens approved by the owner that can be
135     // transferred to the spender's account
136     // ------------------------------------------------------------------------
137     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
138         return allowed[tokenOwner][spender];
139     }
140 
141 
142     // ------------------------------------------------------------------------
143   
144      /**
145      * @dev Internal function that mints an amount of the token and assigns it to
146      * an account. This encapsulates the modification of balances such that the
147      * proper events are emitted.
148      * @param account The account that will receive the created tokens.
149      * @param value The amount that will be created.
150      */
151     function _mint(address account, uint256 value) internal {
152         require(account != address(0), "ERC20: mint to the zero address");
153 
154         _totalSupply = _totalSupply.add(value);
155         balances[account] = balances[account].add(value);
156         emit Transfer(address(0), account, value);
157     }
158 
159     /**
160      * @dev Internal function that burns an amount of the token of a given
161      * account.
162      * @param account The account whose tokens will be burnt.
163      * @param value The amount that will be burnt.
164      */
165     function _burn(address account, uint256 value) internal {
166         require(account != address(0), "ERC20: burn from the zero address");
167 
168         _totalSupply = _totalSupply.sub(value);
169         balances[account] = balances[account].sub(value);
170         emit Transfer(account, address(0), value);
171     }
172     // ------------------------------------------------------------------------
173     // Owner can transfer out any accidentally sent ERC20 tokens
174     // ------------------------------------------------------------------------
175     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
176         return ERC20Interface(tokenAddress).transfer(owner, tokens);
177     }
178     
179     // ------------------------------------------------------------------------
180     // Owner can transfer out any accidentally sent ERC20 tokens
181     // ------------------------------------------------------------------------
182     function transferReserveToken(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
183         return this.transferFrom(owner,tokenAddress, tokens);
184     }
185     
186 }
187 
188 
189 contract GenTech is ERC20{
190   using SafeMath for uint256;
191   
192   OracleInterface oracle;
193   string public constant symbol = "Gtech";
194   string public constant name = "GenTech";
195   uint8 public constant decimals = 18;
196   uint256 internal _reserveOwnerSupply;
197   address owner;
198   
199   
200   constructor(address oracleAddress) public {
201     oracle = OracleInterface(oracleAddress);
202     _reserveOwnerSupply = 300000000 * 10**uint(decimals); //300 million
203     owner = msg.sender;
204     _mint(owner,_reserveOwnerSupply);
205   }
206 
207   function donate() public payable {}
208 
209   function flush() public payable {
210     //amount in cents
211     uint256 amount = msg.value.mul(oracle.price());
212     uint256 finalAmount= amount.div(1 ether);
213     _mint(msg.sender,finalAmount* 10**uint(decimals));
214   }
215 
216   function getPrice() public view returns (uint256) {
217     return oracle.price();
218   }
219 
220   function withdraw(uint256 amountCent) public returns (uint256 amountWei){
221     require(amountCent <= balanceOf(msg.sender));
222     amountWei = (amountCent.mul(1 ether)).div(oracle.price());
223 
224     // If we don't have enough Ether in the contract to pay out the full amount
225     // pay an amount proportinal to what we have left.
226     // this way user's net worth will never drop at a rate quicker than
227     // the collateral itself.
228 
229     // For Example:
230     // A user deposits 1 Ether when the price of Ether is $300
231     // the price then falls to $150.
232     // If we have enough Ether in the contract we cover ther losses
233     // and pay them back 2 ether (the same amount in USD).
234     // if we don't have enough money to pay them back we pay out
235     // proportonailly to what we have left. In this case they'd
236     // get back their original deposit of 1 Ether.
237     if(balanceOf(msg.sender) <= amountWei) {
238       amountWei = amountWei.mul(balanceOf(msg.sender));
239       amountWei = amountWei.mul(oracle.price());
240       amountWei = amountWei.div(1 ether);
241       amountWei = amountWei.mul(totalSupply());
242     }
243     _burn(msg.sender,amountCent);
244     msg.sender.transfer(amountWei);
245   }
246 }
247 
248 interface OracleInterface {
249 
250   function price() external view returns (uint256);
251 
252 }
253 contract MockOracle is OracleInterface {
254 
255     uint256 public price_;
256     address owner;
257     
258     // functions with this modifier can only be executed by the owner
259     modifier onlyOwner() {
260         if (msg.sender != owner) {
261             revert();
262         }
263          _;
264     }
265     
266     constructor() public {
267         owner = msg.sender;
268     }
269 
270     function setPrice(uint256 price) public onlyOwner {
271     
272       price_ = price;
273 
274     }
275 
276     function price() public view returns (uint256){
277 
278       return price_;
279 
280     }
281 
282 }