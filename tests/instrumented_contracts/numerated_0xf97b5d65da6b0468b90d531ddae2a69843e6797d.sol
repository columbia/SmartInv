1 pragma solidity ^0.5.2;
2 
3 //////////////////////////////////////////
4 //                                      //
5 //              SafeMath                //
6 //                                      //
7 //                                      //
8 //////////////////////////////////////////
9 
10 /**
11  * @title SafeMath
12  * @dev Unsigned math operations with safety checks that revert on error
13  */
14 library SafeMath {
15     /**
16      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
17      */
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b <= a);
20         uint256 c = a - b;
21 
22         return c;
23     }
24 
25     /**
26      * @dev Adds two unsigned integers, reverts on overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a);
31         return c;
32     }
33 }
34 
35 
36 //////////////////////////////////////////
37 //                                      //
38 //          Token interface             //
39 //                                      //
40 //                                      //
41 //////////////////////////////////////////
42 
43 
44 /**
45  * @title ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/20
47  */
48 interface IERC20 {
49     function name() external view returns (string memory);
50     function symbol() external view returns (string memory);
51     function decimals() external view returns (uint8);
52 
53     function totalSupply() external view returns (uint256);
54     function balanceOf(address who) external view returns (uint256);
55 
56     function transfer(address to, uint256 value) external returns (bool);   
57     function transferFrom(address from, address to, uint256 value) external returns (bool);
58     
59     function approve(address spender, uint256 value) external returns (bool);
60     function allowance(address owner, address spender) external view returns (uint256);
61     
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 /**
67  * @title Standard ERC20 token
68  *
69  * @dev Implementation of the basic standard token.
70  */
71 contract LEOcoin is IERC20 {
72     using SafeMath for uint256;
73 
74     // 
75     string private _name;
76     string private _symbol;
77     uint8 private _decimals;
78 
79     mapping (address => uint256) private _balances;
80     mapping (address => mapping (address => uint256)) private _allowed;
81     uint256 private _totalSupply;
82 
83     address private _isMinter;
84     uint256 private _cap;
85 
86 
87     constructor (address masterAccount, uint256 premined, address minterAccount) public {
88         _name = "LEOcoin";
89         _symbol = "LEO";
90         _decimals = 18;
91         _cap = 4000000000*1E18;
92 
93         _isMinter = minterAccount;
94 
95         _totalSupply = _totalSupply.add(premined);
96         _balances[masterAccount] = _balances[masterAccount].add(premined);
97         emit Transfer(address(0), masterAccount, premined);
98     }
99 
100     /**
101      * @return the name of the token.
102      */
103     function name() public view returns (string memory) {
104         return _name;
105     }
106 
107     /**
108      * @return the symbol of the token.
109      */
110     function symbol() public view returns (string memory) {
111         return _symbol;
112     }
113 
114     /**
115      * @return the number of decimals of the token.
116      */
117     function decimals() public view returns (uint8) {
118         return _decimals;
119     }
120 
121     /**
122      * @dev Total number of tokens in existence
123      */
124     function totalSupply() public view returns (uint256) {
125         return _totalSupply;
126     }
127 
128     /**
129      * @dev Gets the balance of the specified address.
130      * @param owner The address to query the balance of.
131      * @return An uint256 representing the amount owned by the passed address.
132      */
133     function balanceOf(address owner) public view returns (uint256) {
134         return _balances[owner];
135     }
136 
137     /**
138      * @dev Function to check the amount of tokens that an owner allowed to a spender.
139      * @param owner address The address which owns the funds.
140      * @param spender address The address which will spend the funds.
141      * @return A uint256 specifying the amount of tokens still available for the spender.
142      */
143     function allowance(address owner, address spender) public view returns (uint256) {
144         return _allowed[owner][spender];
145     }
146 
147     /**
148      * @dev Transfer token for a specified address
149      * @param to The address to transfer to.
150      * @param value The amount to be transferred.
151      */
152     function transfer(address to, uint256 value) public returns (bool) {
153         _transfer(msg.sender, to, value);
154         return true;
155     }
156 
157     /**
158      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159      * Beware that changing an allowance with this method brings the risk that someone may use both the old
160      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      * @param spender The address which will spend the funds.
164      * @param value The amount of tokens to be spent.
165      */
166     function approve(address spender, uint256 value) public returns (bool) {
167         _approve(msg.sender, spender, value);
168         return true;
169     }
170 
171     /**
172      * @dev Transfer tokens from one address to another.
173      * Note that while this function emits an Approval event, this is not required as per the specification,
174      * and other compliant implementations may not emit the event.
175      * @param from address The address which you want to send tokens from
176      * @param to address The address which you want to transfer to
177      * @param value uint256 the amount of tokens to be transferred
178      */
179     function transferFrom(address from, address to, uint256 value) public returns (bool) {
180         _transfer(from, to, value);
181         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
182         return true;
183     }
184 
185     /**
186      * @dev Increase the amount of tokens that an owner allowed to a spender.
187      * approve should be called when allowed_[_spender] == 0. To increment
188      * allowed value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      * Emits an Approval event.
192      * @param spender The address which will spend the funds.
193      * @param addedValue The amount of tokens to increase the allowance by.
194      */
195     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
196         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
197         return true;
198     }
199 
200     /**
201      * @dev Decrease the amount of tokens that an owner allowed to a spender.
202      * approve should be called when allowed_[_spender] == 0. To decrement
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * Emits an Approval event.
207      * @param spender The address which will spend the funds.
208      * @param subtractedValue The amount of tokens to decrease the allowance by.
209      */
210     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
211         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
212         return true;
213     }
214 
215     /**
216      * @dev Transfer token for a specified addresses
217      * @param from The address to transfer from.
218      * @param to The address to transfer to.
219      * @param value The amount to be transferred.
220      */
221     function _transfer(address from, address to, uint256 value) internal {
222         require(to != address(0));
223 
224         _balances[from] = _balances[from].sub(value);
225         _balances[to] = _balances[to].add(value);
226         emit Transfer(from, to, value);
227     }
228 
229     /**
230      * @dev Approve an address to spend another addresses' tokens.
231      * @param owner The address that owns the tokens.
232      * @param spender The address that will spend the tokens.
233      * @param value The number of tokens that can be spent.
234      */
235     function _approve(address owner, address spender, uint256 value) internal {
236         require(spender != address(0));
237         require(owner != address(0));
238 
239         _allowed[owner][spender] = value;      
240     }
241 
242     /**
243      * @dev Function to mint tokens
244      * @param account The address that will receive the minted tokens.
245      * @param value The amount of tokens to mint.
246      * @return A boolean that indicates if the operation was successful.
247      */
248     function mint(address account, uint256 value) public onlyMinter  {
249         require(account != address(0));
250         require(totalSupply().add(value) <= _cap);
251 
252         _totalSupply = _totalSupply.add(value);
253         _balances[account] = _balances[account].add(value);
254         emit Transfer(address(0), account, value);
255     }
256 
257 
258     /**
259      * @return the cap for the token minting.
260      */
261     function cap() external view returns (uint256) {
262         return _cap;
263     }
264 
265     /**
266      * @return the address that can mint tokens.
267      */
268     function currentMinter() external view returns (address) {
269         return _isMinter;
270     }
271 
272 
273     /**
274      * @dev Function to change minter address
275      * @param newMinter The address that will be able to mint tokens from now on
276      */
277     function changeMinter(address newMinter) external onlyMinter {
278         _isMinter = newMinter;
279     } 
280 
281     modifier onlyMinter() {
282         require(msg.sender==_isMinter);
283         _;
284     }
285 
286 
287     function batchTransfer(address[] memory accounts, uint256[] memory values) public {
288         for (uint i=0; i<accounts.length; i++) {
289             // check to!=0 to prevent reversion
290             if (accounts[i]==address(0)) {
291                 continue;
292             }
293             transfer(accounts[i], values[i]);
294         }
295     }
296 
297     function batchMint(address[] memory accounts, uint256[] memory values) public {
298         for (uint i=0; i<accounts.length; i++) {
299             // check to!=0 to prevent reversion
300             if (accounts[i]==address(0)) {
301                 continue;
302             }
303 
304             mint(accounts[i], values[i]);
305         }   
306     }
307 
308 
309 }