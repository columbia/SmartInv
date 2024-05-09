1 pragma solidity 0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that throw on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, throws on overflow.
44   */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48     }
49         uint256 c = a * b;
50         assert(c / a == b);
51         return c;
52     }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     // uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61         return a / b;
62     }
63 
64   /**
65   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         assert(b <= a);
69         return a - b;
70     }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         assert(c >= a);
78         return c;
79     }
80 }
81 
82     /**
83     * @title Standard ERC20 token
84     *
85     * @dev Implementation of the basic standard token.
86     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
87     * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
88     */
89 contract ERC20 is IERC20 {
90     using SafeMath for uint256;
91 
92     mapping (address => uint256) private _balances;
93 
94     mapping (address => mapping (address => uint256)) private _allowed;
95 
96     uint256 private _totalSupply;
97     string public name;
98     string public symbol;
99     uint8 public decimals;
100 
101     /**
102     * @dev Total number of tokens in existence
103     */
104     function totalSupply() public view returns (uint256) {
105         return _totalSupply;
106     }
107 
108     /**
109     * @dev Gets the balance of the specified address.
110     * @param owner The address to query the the balance of.
111     * @return An uint256 representing the amount owned by the passed address.
112     */
113     function balanceOf(address owner) public view returns (uint256) {
114         return _balances[owner];
115     }
116 
117     /**
118     * @dev Function to check the amount of tokens that an owner allowed to a spender.
119     * @param owner address The address which owns the funds.
120     * @param spender address The address which will spend the funds.
121     * @return A uint256 specifying the amount of tokens still available for the spender.
122     */
123     function allowance(
124         address owner,
125         address spender
126     )
127         public
128         view
129         returns (uint256)
130     {
131         return _allowed[owner][spender];
132     }
133 
134 
135     /**
136     * @dev Transfer token for a specified address
137     * @param to The address to transfer to.
138     * @param value The amount to be transferred.
139     */
140     function transfer(address to, uint256 value) public returns (bool) {
141         require(value <= _balances[msg.sender]);
142         require(to != address(0));
143 
144         _balances[msg.sender] = _balances[msg.sender].sub(value);
145         _balances[to] = _balances[to].add(value);
146         emit Transfer(msg.sender, to, value);
147         return true;
148     }
149 
150     /**
151     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152     * Beware that changing an allowance with this method brings the risk that someone may use both the old
153     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156     * @param spender The address which will spend the funds.
157     * @param value The amount of tokens to be spent.
158     */
159     function approve(address spender, uint256 value) public returns (bool) {
160         require(spender != address(0));
161 
162         _allowed[msg.sender][spender] = value;
163         emit Approval(msg.sender, spender, value);
164         return true;
165     }
166 
167     /**
168     * @dev Transfer tokens from one address to another
169     * @param from address The address which you want to send tokens from
170     * @param to address The address which you want to transfer to
171     * @param value uint256 the amount of tokens to be transferred
172     */
173     function transferFrom(
174         address from,
175         address to,
176         uint256 value
177     )
178         public
179         returns (bool)
180     {
181         require(value <= _balances[from]);
182         require(value <= _allowed[from][msg.sender]);
183         require(to != address(0));
184 
185         _balances[from] = _balances[from].sub(value);
186         _balances[to] = _balances[to].add(value);
187         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
188         emit Transfer(from, to, value);
189         return true;
190     }
191 
192     /**
193     * @dev Increase the amount of tokens that an owner allowed to a spender.
194     * approve should be called when allowed_[_spender] == 0. To increment
195     * allowed value is better to use this function to avoid 2 calls (and wait until
196     * the first transaction is mined)
197     * From MonolithDAO Token.sol
198     * @param spender The address which will spend the funds.
199     * @param addedValue The amount of tokens to increase the allowance by.
200     */
201     function increaseAllowance(
202         address spender,
203         uint256 addedValue
204     )
205         public
206         returns (bool)
207     {
208         require(spender != address(0));
209 
210         _allowed[msg.sender][spender] = (
211         _allowed[msg.sender][spender].add(addedValue));
212         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
213         return true;
214     }
215 
216     /**
217     * @dev Decrease the amount of tokens that an owner allowed to a spender.
218     * approve should be called when allowed_[_spender] == 0. To decrement
219     * allowed value is better to use this function to avoid 2 calls (and wait until
220     * the first transaction is mined)
221     * From MonolithDAO Token.sol
222     * @param spender The address which will spend the funds.
223     * @param subtractedValue The amount of tokens to decrease the allowance by.
224     */
225     function decreaseAllowance(
226         address spender,
227         uint256 subtractedValue
228     )
229         public
230         returns (bool)
231     {
232         require(spender != address(0));
233 
234         _allowed[msg.sender][spender] = (
235         _allowed[msg.sender][spender].sub(subtractedValue));
236         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
237         return true;
238     }
239 
240     /**
241     * @dev Internal function that mints an amount of the token and assigns it to
242     * an account. This encapsulates the modification of balances such that the
243     * proper events are emitted.
244     * @param account The account that will receive the created tokens.
245     * @param amount The amount that will be created.
246     */
247     function _mint(address account, uint256 amount) internal {
248         require(account != address(0));
249         _totalSupply = _totalSupply.add(amount);
250         _balances[account] = _balances[account].add(amount);
251         emit Transfer(address(0), account, amount);
252     }
253 
254     /**
255     * @dev Internal function that burns an amount of the token of a given
256     * account.
257     * @param account The account whose tokens will be burnt.
258     * @param amount The amount that will be burnt.
259     */
260     function _burn(address account, uint256 amount) internal {
261         require(account != address(0));
262         require(amount <= _balances[account]);
263 
264         _totalSupply = _totalSupply.sub(amount);
265         _balances[account] = _balances[account].sub(amount);
266         emit Transfer(account, address(0), amount);
267     }
268 
269     /**
270     * @dev Internal function that burns an amount of the token of a given
271     * account, deducting from the sender's allowance for said account. Uses the
272     * internal burn function.
273     * @param account The account whose tokens will be burnt.
274     * @param amount The amount that will be burnt.
275     */
276     function _burnFrom(address account, uint256 amount) internal {
277         require(amount <= _allowed[account][msg.sender]);
278 
279         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
280         // this function needs to emit an event with the updated approval.
281         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
282         amount);
283         _burn(account, amount);
284     }
285 
286     function burnFrom(address account, uint256 amount) public {
287         _burnFrom(account, amount);
288     }
289 }
290 
291 /**
292  * @title Template contract for social money, to be used by TokenFactory
293  * @author Jake Goh Si Yuan @ jakegsy, jake@jakegsy.com
294  */
295 
296 
297 
298 contract SocialMoney is ERC20 {
299 
300     /**
301      * @dev Constructor on SocialMoney
302      * @param _name string Name parameter of Token
303      * @param _symbol string Symbol parameter of Token
304      * @param _decimals uint8 Decimals parameter of Token
305      * @param _proportions uint256[3] Parameter that dictates how totalSupply will be divvied up,
306                             _proportions[0] = Vesting Beneficiary Initial Supply
307                             _proportions[1] = Turing Supply
308                             _proportions[2] = Vesting Beneficiary Vesting Supply
309      * @param _vestingBeneficiary address Address of the Vesting Beneficiary
310      * @param _platformWallet Address of Turing platform wallet
311      * @param _tokenVestingInstance address Address of Token Vesting contract
312      */
313     constructor(
314         string memory _name,
315         string memory _symbol,
316         uint8 _decimals,
317         uint256[3] memory _proportions,
318         address _vestingBeneficiary,
319         address _platformWallet,
320         address _tokenVestingInstance
321     )
322     public
323     {
324         name = _name;
325         symbol = _symbol;
326         decimals = _decimals;
327 
328         uint256 totalProportions = _proportions[0].add(_proportions[1]).add(_proportions[2]);
329 
330         _mint(_vestingBeneficiary, _proportions[0]);
331         _mint(_platformWallet, _proportions[1]);
332         _mint(_tokenVestingInstance, _proportions[2]);
333 
334         //Sanity check that the totalSupply is exactly where we want it to be
335         assert(totalProportions == totalSupply());
336     }
337 }