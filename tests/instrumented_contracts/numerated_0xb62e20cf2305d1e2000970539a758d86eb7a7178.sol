1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }/**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 {
54     function totalSupply() public view returns (uint256);
55     function balanceOf(address who) public view returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     function allowance(address owner, address spender) public view returns (uint256);
59 
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61 
62     function approve(address spender, uint256 value) public returns (bool);
63     event Approval(
64       address indexed owner,
65       address indexed spender,
66       uint256 value
67     );
68 }/**
69  * @title SimpleToken
70  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
71  * Note they can later distribute these tokens as they wish using `transfer` and other
72  * `StandardToken` functions.
73  */
74 contract PostboyToken is ERC20 {
75     using SafeMath for uint256;
76 
77     struct Account {
78         uint256 balance;
79         uint256 lastDividends;
80     }
81 
82     string public constant name = "PostboyToken"; // solium-disable-line uppercase
83     string public constant symbol = "PBY"; // solium-disable-line uppercase
84     uint8 public constant decimals = 0; // solium-disable-line uppercase
85 
86     uint256 public constant INITIAL_SUPPLY = 100000;
87 
88     uint256 public totalDividends;
89     uint256 totalSupply_;
90     
91     mapping (address => Account) accounts;
92     mapping (address => mapping (address => uint256)) internal allowed;
93 
94     address public admin;
95     address public payer;
96 
97   /**
98    * @dev Constructor that gives msg.sender all of existing tokens.
99    */
100     constructor() public {
101         totalSupply_ = INITIAL_SUPPLY;
102         totalDividends = 0;
103         accounts[msg.sender].balance = INITIAL_SUPPLY;
104         admin = msg.sender;
105         payer = address(0);
106         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
107     }
108 
109     /**
110     * @dev Total number of tokens in existence
111     */
112     function totalSupply() public view returns (uint256) {
113         return totalSupply_;
114     }
115 
116     /**
117     * @dev Transfer token for a specified address
118     * @param _to The address to transfer to.
119     * @param _value The amount to be transferred.
120     */
121     function transfer(address _to, uint256 _value) public returns (bool) {
122         _transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     /**
127     * @dev Transfer tokens from one address to another
128     * @param _from address The address which you want to send tokens from
129     * @param _to address The address which you want to transfer to
130     * @param _value uint256 the amount of tokens to be transferred
131     */
132     function transferFrom(
133         address _from,
134         address _to,
135         uint256 _value
136     )
137       public
138       returns (bool)
139     {
140         require(_value <= allowed[_from][msg.sender]);
141 
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143         _transfer(_from, _to, _value);
144 
145         return true;
146     }
147 
148     /**
149     * @dev Gets the balance of the specified address.
150     * @param _owner The address to query the the balance of.
151     * @return An uint256 representing the amount owned by the passed address.
152     */
153     function balanceOf(address _owner) public view returns (uint256) {
154         return accounts[_owner].balance;
155     }
156 
157     /**
158     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159     * Beware that changing an allowance with this method brings the risk that someone may use both the old
160     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163     * @param _spender The address which will spend the funds.
164     * @param _value The amount of tokens to be spent.
165     */
166     function approve(address _spender, uint256 _value) public returns (bool) {
167         allowed[msg.sender][_spender] = _value;
168         emit Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     /**
173     * @dev Function to check the amount of tokens that an owner allowed to a spender.
174     * @param _owner address The address which owns the funds.
175     * @param _spender address The address which will spend the funds.
176     * @return A uint256 specifying the amount of tokens still available for the spender.
177     */
178     function allowance(
179         address _owner,
180         address _spender
181     )
182       public
183       view
184       returns (uint256)
185     {
186         return allowed[_owner][_spender];
187     }
188 
189     /**
190     * @dev Increase the amount of tokens that an owner allowed to a spender.
191     * approve should be called when allowed[_spender] == 0. To increment
192     * allowed value is better to use this function to avoid 2 calls (and wait until
193     * the first transaction is mined)
194     * From MonolithDAO Token.sol
195     * @param _spender The address which will spend the funds.
196     * @param _addedValue The amount of tokens to increase the allowance by.
197     */
198     function increaseApproval(
199         address _spender,
200         uint256 _addedValue
201     )
202       public
203       returns (bool)
204     {
205         allowed[msg.sender][_spender] = (
206             allowed[msg.sender][_spender].add(_addedValue));
207         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209     }
210 
211     /**
212     * @dev Decrease the amount of tokens that an owner allowed to a spender.
213     * approve should be called when allowed[_spender] == 0. To decrement
214     * allowed value is better to use this function to avoid 2 calls (and wait until
215     * the first transaction is mined)
216     * From MonolithDAO Token.sol
217     * @param _spender The address which will spend the funds.
218     * @param _subtractedValue The amount of tokens to decrease the allowance by.
219     */
220     function decreaseApproval(
221         address _spender,
222         uint256 _subtractedValue
223     )
224       public
225       returns (bool)
226     {
227         uint256 oldValue = allowed[msg.sender][_spender];
228         if (_subtractedValue > oldValue) {
229             allowed[msg.sender][_spender] = 0;
230         } else {
231             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232         }
233         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237     /**
238     * @dev Get dividents sum by address
239     */
240     function dividendBalanceOf(address account) public view returns (uint256) {
241         uint256 newDividends = totalDividends.sub(accounts[account].lastDividends);
242         uint256 product = accounts[account].balance.mul(newDividends);
243         return product.div(totalSupply_);
244     }
245 
246     /**
247     * @dev Withdraw dividends
248     */
249     function claimDividend() public {
250         uint256 owing = dividendBalanceOf(msg.sender);
251         if (owing > 0) {
252             accounts[msg.sender].lastDividends = totalDividends;
253             msg.sender.transfer(owing);
254         }
255     }
256 
257 
258     /**
259     * @dev Tokens transfer will not work if sender or recipient has dividends
260     */
261     function _transfer(address _from, address _to, uint256 _value) internal {
262         require(_to != address(0));
263         require(_value <= accounts[_from].balance);
264         require(accounts[_to].balance + _value >= accounts[_to].balance);
265     
266         uint256 fromOwing = dividendBalanceOf(_from);
267         uint256 toOwing = dividendBalanceOf(_to);
268         require(fromOwing <= 0 && toOwing <= 0);
269     
270         accounts[_from].balance = accounts[_from].balance.sub(_value);
271         accounts[_to].balance = accounts[_to].balance.add(_value);
272     
273         accounts[_to].lastDividends = accounts[_from].lastDividends;
274     
275         emit Transfer(_from, _to, _value);
276     }
277 
278     function changePayer(address _payer) public returns (bool) {
279         require(msg.sender == admin);
280         payer = _payer;
281     }
282 
283     function sendDividends() public payable {
284         require(msg.sender == payer);
285         
286         totalDividends = totalDividends.add(msg.value);
287     }
288 
289     function () external payable {
290         require(false);
291     }
292 }