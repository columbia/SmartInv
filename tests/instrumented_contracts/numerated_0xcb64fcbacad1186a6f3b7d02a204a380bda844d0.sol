1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * See https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68     function allowance(address owner, address spender)
69     public view returns (uint256);
70 
71     function transferFrom(address from, address to, uint256 value)
72     public returns (bool);
73 
74     function approve(address spender, uint256 value) public returns (bool);
75 
76     event Approval(
77         address indexed owner,
78         address indexed spender,
79         uint256 value
80     );
81 }
82 
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89     using SafeMath for uint256;
90 
91     mapping(address => uint256) balances;
92 
93     uint256 totalSupply_;
94 
95     /**
96     * @dev Total number of tokens in existence
97     */
98     function totalSupply() public view returns (uint256) {
99         return totalSupply_;
100     }
101 
102     /**
103     * @dev Transfer token for a specified address
104     * @param _to The address to transfer to.
105     * @param _value The amount to be transferred.
106     */
107     function transfer(address _to, uint256 _value) public returns (bool) {
108         require(_to != address(0));
109         require(_value <= balances[msg.sender]);
110 
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         emit Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param _owner The address to query the the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
122     function balanceOf(address _owner) public view returns (uint256) {
123         return balances[_owner];
124     }
125 
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140     /**
141      * @dev Transfer tokens from one address to another
142      * @param _from address The address which you want to send tokens from
143      * @param _to address The address which you want to transfer to
144      * @param _value uint256 the amount of tokens to be transferred
145      */
146     function transferFrom(
147         address _from,
148         address _to,
149         uint256 _value
150     )
151     public
152     returns (bool)
153     {
154         require(_to != address(0));
155         require(_value <= balances[_from]);
156         require(_value <= allowed[_from][msg.sender]);
157 
158         balances[_from] = balances[_from].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161         emit Transfer(_from, _to, _value);
162         return true;
163     }
164 
165     /**
166      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167      * Beware that changing an allowance with this method brings the risk that someone may use both the old
168      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      * @param _spender The address which will spend the funds.
172      * @param _value The amount of tokens to be spent.
173      */
174     function approve(address _spender, uint256 _value) public returns (bool) {
175         allowed[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     /**
181      * @dev Function to check the amount of tokens that an owner allowed to a spender.
182      * @param _owner address The address which owns the funds.
183      * @param _spender address The address which will spend the funds.
184      * @return A uint256 specifying the amount of tokens still available for the spender.
185      */
186     function allowance(
187         address _owner,
188         address _spender
189     )
190     public
191     view
192     returns (uint256)
193     {
194         return allowed[_owner][_spender];
195     }
196 
197     /**
198      * @dev Increase the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed[_spender] == 0. To increment
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * @param _spender The address which will spend the funds.
204      * @param _addedValue The amount of tokens to increase the allowance by.
205      */
206     function increaseApproval(
207         address _spender,
208         uint256 _addedValue
209     )
210     public
211     returns (bool)
212     {
213         allowed[msg.sender][_spender] = (
214         allowed[msg.sender][_spender].add(_addedValue));
215         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216         return true;
217     }
218 
219     /**
220      * @dev Decrease the amount of tokens that an owner allowed to a spender.
221      * approve should be called when allowed[_spender] == 0. To decrement
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      * @param _spender The address which will spend the funds.
226      * @param _subtractedValue The amount of tokens to decrease the allowance by.
227      */
228     function decreaseApproval(
229         address _spender,
230         uint256 _subtractedValue
231     )
232     public
233     returns (bool)
234     {
235         uint256 oldValue = allowed[msg.sender][_spender];
236         if (_subtractedValue > oldValue) {
237             allowed[msg.sender][_spender] = 0;
238         } else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245 }
246 
247 /**
248  * @title Burnable Token
249  * @dev Token that can be irreversibly burned (destroyed).
250  */
251 contract BurnableToken is BasicToken {
252 
253     event Burn(address indexed burner, uint256 value);
254 
255     /**
256      * @dev Burns a specific amount of tokens.
257      * @param _value The amount of token to be burned.
258      */
259     function burn(uint256 _value) public {
260         _burn(msg.sender, _value);
261     }
262 
263     function _burn(address _who, uint256 _value) internal {
264         require(_value <= balances[_who]);
265         // no need to require value <= totalSupply, since that would imply the
266         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
267 
268         balances[_who] = balances[_who].sub(_value);
269         totalSupply_ = totalSupply_.sub(_value);
270         emit Burn(_who, _value);
271         emit Transfer(_who, address(0), _value);
272     }
273 }
274 
275 /**
276  * @title Standard Burnable Token
277  * @dev Adds burnFrom method to ERC20 implementations
278  */
279 contract StandardBurnableToken is BurnableToken, StandardToken {
280 
281     /**
282      * @dev Burns a specific amount of tokens from the target address and decrements allowance
283      * @param _from address The address which you want to send tokens from
284      * @param _value uint256 The amount of token to be burned
285      */
286     function burnFrom(address _from, uint256 _value) public {
287         require(_value <= allowed[_from][msg.sender]);
288         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
289         // this function needs to emit an event with the updated approval.
290         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
291         _burn(_from, _value);
292     }
293 }
294 
295 /**
296  * @title Freezable Token
297  * @dev Token that can be Frozen.
298  */
299 contract FreezableToken is BasicToken {
300 
301     mapping (address => uint256) freezes;
302     event Freeze(address indexed from, uint256 value);
303     event Unfreeze(address indexed from, uint256 value);
304 
305     function freeze(uint256 _value) public returns (bool success) {
306         require(_value <= balances[msg.sender]);
307         balances[msg.sender] = balances[msg.sender].sub(_value);
308         freezes[msg.sender] = freezes[msg.sender].add(_value);
309         emit Freeze(msg.sender, _value);
310         return true;
311     }
312 
313     function unfreeze(uint256 _value) public returns (bool success) {
314         require(_value <= freezes[msg.sender]);
315         freezes[msg.sender] = freezes[msg.sender].sub(_value);
316         balances[msg.sender] = balances[msg.sender].add(_value);
317         emit Unfreeze(msg.sender, _value);
318         return true;
319     }
320     function freezeOf(address _owner) public view returns (uint256) {
321         return freezes[_owner];
322     }
323 }
324 
325 contract MusictumToken is StandardBurnableToken, FreezableToken {
326 
327     string public name;
328     string public symbol;
329     uint8 public decimals;
330     address public admin;
331 
332     constructor(address _teamWallet, uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
333         totalSupply_ = _initialSupply;
334         balances[_teamWallet] = _initialSupply;
335         name = _tokenName;
336         symbol = _tokenSymbol;
337         decimals = _decimals;
338         admin = msg.sender;
339     }
340 
341     /**
342      * withdraw foreign tokens
343      */
344     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
345         require(msg.sender == admin);
346         ERC20Basic token = ERC20Basic(_tokenContract);
347         uint256 amount = token.balanceOf(address(this));
348         return token.transfer(admin, amount);
349     }
350 
351 }