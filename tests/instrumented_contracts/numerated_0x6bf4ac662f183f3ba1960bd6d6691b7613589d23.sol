1 /**
2  * @title ERC20 interface
3  * @dev see https://github.com/ethereum/EIPs/issues/20
4  */
5 contract ERC20 {
6     function totalSupply() public view returns (uint256);
7     function balanceOf(address who) public view returns (uint256);
8     function transfer(address to, uint256 value) public returns (bool);
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     function allowance(address owner, address spender) public view returns (uint256);
11 
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13 
14     function approve(address spender, uint256 value) public returns (bool);
15     event Approval(
16       address indexed owner,
17       address indexed spender,
18       uint256 value
19     );
20 }/**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, throws on overflow.
28   */
29   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
30     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
31     // benefit is lost if 'b' is also tested.
32     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33     if (a == 0) {
34       return 0;
35     }
36 
37     c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     // uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return a / b;
50   }
51 
52   /**
53   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 /**
70  * @title SimpleToken
71  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
72  * Note they can later distribute these tokens as they wish using `transfer` and other
73  * `StandardToken` functions.
74  */
75 contract PostboyToken is ERC20 {
76     using SafeMath for uint256;
77 
78     struct Account {
79         uint256 balance;
80         uint256 lastDividends;
81     }
82 
83     string public constant name = "PostboyToken"; // solium-disable-line uppercase
84     string public constant symbol = "PBY"; // solium-disable-line uppercase
85     uint8 public constant decimals = 0; // solium-disable-line uppercase
86 
87     uint256 public constant INITIAL_SUPPLY = 100000;
88 
89     uint256 public totalDividends;
90     uint256 totalSupply_;
91     
92     mapping (address => Account) accounts;
93     mapping (address => mapping (address => uint256)) internal allowed;
94 
95     address public admin;
96     address public payer;
97 
98   /**
99    * @dev Constructor that gives msg.sender all of existing tokens.
100    */
101     constructor() public {
102         totalSupply_ = INITIAL_SUPPLY;
103         totalDividends = 0;
104         accounts[msg.sender].balance = INITIAL_SUPPLY;
105         admin = msg.sender;
106         payer = address(0);
107         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
108     }
109 
110     /**
111     * @dev Total number of tokens in existence
112     */
113     function totalSupply() public view returns (uint256) {
114         return totalSupply_;
115     }
116 
117     /**
118     * @dev Transfer token for a specified address
119     * @param _to The address to transfer to.
120     * @param _value The amount to be transferred.
121     */
122     function transfer(address _to, uint256 _value) public returns (bool) {
123         _transfer(msg.sender, _to, _value);
124         return true;
125     }
126 
127     /**
128     * @dev Transfer tokens from one address to another
129     * @param _from address The address which you want to send tokens from
130     * @param _to address The address which you want to transfer to
131     * @param _value uint256 the amount of tokens to be transferred
132     */
133     function transferFrom(
134         address _from,
135         address _to,
136         uint256 _value
137     )
138       public
139       returns (bool)
140     {
141         require(_value <= allowed[_from][msg.sender]);
142 
143         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144         _transfer(_from, _to, _value);
145 
146         return true;
147     }
148 
149     /**
150     * @dev Gets the balance of the specified address.
151     * @param _owner The address to query the the balance of.
152     * @return An uint256 representing the amount owned by the passed address.
153     */
154     function balanceOf(address _owner) public view returns (uint256) {
155         return accounts[_owner].balance;
156     }
157 
158     /**
159     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160     * Beware that changing an allowance with this method brings the risk that someone may use both the old
161     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164     * @param _spender The address which will spend the funds.
165     * @param _value The amount of tokens to be spent.
166     */
167     function approve(address _spender, uint256 _value) public returns (bool) {
168         allowed[msg.sender][_spender] = _value;
169         emit Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     /**
174     * @dev Function to check the amount of tokens that an owner allowed to a spender.
175     * @param _owner address The address which owns the funds.
176     * @param _spender address The address which will spend the funds.
177     * @return A uint256 specifying the amount of tokens still available for the spender.
178     */
179     function allowance(
180         address _owner,
181         address _spender
182     )
183       public
184       view
185       returns (uint256)
186     {
187         return allowed[_owner][_spender];
188     }
189 
190     /**
191     * @dev Increase the amount of tokens that an owner allowed to a spender.
192     * approve should be called when allowed[_spender] == 0. To increment
193     * allowed value is better to use this function to avoid 2 calls (and wait until
194     * the first transaction is mined)
195     * From MonolithDAO Token.sol
196     * @param _spender The address which will spend the funds.
197     * @param _addedValue The amount of tokens to increase the allowance by.
198     */
199     function increaseApproval(
200         address _spender,
201         uint256 _addedValue
202     )
203       public
204       returns (bool)
205     {
206         allowed[msg.sender][_spender] = (
207             allowed[msg.sender][_spender].add(_addedValue));
208         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209         return true;
210     }
211 
212     /**
213     * @dev Decrease the amount of tokens that an owner allowed to a spender.
214     * approve should be called when allowed[_spender] == 0. To decrement
215     * allowed value is better to use this function to avoid 2 calls (and wait until
216     * the first transaction is mined)
217     * From MonolithDAO Token.sol
218     * @param _spender The address which will spend the funds.
219     * @param _subtractedValue The amount of tokens to decrease the allowance by.
220     */
221     function decreaseApproval(
222         address _spender,
223         uint256 _subtractedValue
224     )
225       public
226       returns (bool)
227     {
228         uint256 oldValue = allowed[msg.sender][_spender];
229         if (_subtractedValue > oldValue) {
230             allowed[msg.sender][_spender] = 0;
231         } else {
232             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233         }
234         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235         return true;
236     }
237 
238     /**
239     * @dev Get dividents sum by address
240     */
241     function dividendBalanceOf(address account) public view returns (uint256) {
242         uint256 newDividends = totalDividends.sub(accounts[account].lastDividends);
243         uint256 product = accounts[account].balance.mul(newDividends);
244         return product.div(totalSupply_);
245     }
246 
247     /**
248     * @dev Withdraw dividends
249     */
250     function claimDividend() public {
251         uint256 owing = dividendBalanceOf(msg.sender);
252         if (owing > 0) {
253             accounts[msg.sender].lastDividends = totalDividends;
254             msg.sender.transfer(owing);
255         }
256     }
257 
258 
259     /**
260     * @dev Tokens transfer will not work if sender or recipient has dividends
261     */
262     function _transfer(address _from, address _to, uint256 _value) internal {
263         require(_to != address(0));
264         require(_value <= accounts[_from].balance);
265         require(accounts[_to].balance + _value >= accounts[_to].balance);
266     
267         uint256 fromOwing = dividendBalanceOf(_from);
268         uint256 toOwing = dividendBalanceOf(_to);
269         require(fromOwing <= 0 && toOwing <= 0);
270     
271         accounts[_from].balance = accounts[_from].balance.sub(_value);
272         accounts[_to].balance = accounts[_to].balance.add(_value);
273     
274         accounts[_to].lastDividends = accounts[_from].lastDividends;
275     
276         emit Transfer(_from, _to, _value);
277     }
278 
279     function changePayer(address _payer) public returns (bool) {
280         require(msg.sender == admin);
281         payer = _payer;
282     }
283 
284     function sendDividends() public payable {
285         require(msg.sender == payer);
286         
287         totalDividends = totalDividends.add(msg.value);
288     }
289 
290     function () external payable {
291         require(false);
292     }
293 }
294 contract PostboyTokenMiddleware {
295    
296     address public adminAddress_1;
297     address public adminAddress_2;
298     address public adminAddress_3;
299 
300     PostboyToken public token;
301 
302     modifier isAdmin() {
303         require(msg.sender == adminAddress_1 || msg.sender == adminAddress_2 || msg.sender == adminAddress_3);
304         _;
305     }
306 
307     constructor(address admin_1, address admin_2, address admin_3, PostboyToken _token) public {
308         adminAddress_1 = admin_1;
309         adminAddress_2 = admin_2;
310         adminAddress_3 = admin_3;
311 
312         token = _token;
313     }
314 
315     function transferDividends() isAdmin public {
316         token.sendDividends.value(address(this).balance)();
317     }
318 
319     function () external payable {
320     }
321 }