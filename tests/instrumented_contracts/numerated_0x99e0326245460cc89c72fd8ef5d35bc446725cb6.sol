1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10      * @dev Multiplies two numbers, throws on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two numbers, truncating the quotient.
27      */
28     function div(uint256 a, uint256 b) internal pure returns(uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37      */
38     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44      * @dev Adds two numbers, throws on overflow.
45      */
46     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     
60     address public owner;
61   
62     /**
63     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64     * account.
65     */
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     /**
71     * @dev Throws if called by any account other than the owner.
72     */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78 }
79 
80 /**
81  * @title Pausable
82  * @dev Base contract which allows children to implement an emergency stop mechanism.
83  */
84 contract Pausable is Ownable {
85     event Pause();
86     event Unpause();
87 
88     bool public paused = false;
89 
90     /**
91     * @dev Modifier to make a function callable only when the contract is not paused.
92     */
93     modifier whenNotPaused() {
94         require(!paused, "Contract Paused. Events/Transaction Paused until Further Notice");
95         _;
96     }
97 
98     /**
99     * @dev Modifier to make a function callable only when the contract is paused.
100     */
101     modifier whenPaused() {
102         require(paused, "Contract Functionality Resumed");
103         _;
104     }
105 
106     /**
107     * @dev called by the owner to pause, triggers stopped state
108     */
109     function pause() onlyOwner whenNotPaused public {
110         paused = true;
111         emit Pause();
112     }
113 
114     /**
115     * @dev called by the owner to unpause, returns to normal state
116     */
117     function unpause() onlyOwner whenPaused public {
118         paused = false;
119         emit Unpause();
120     }
121 }
122 
123 contract StandardToken is Pausable {
124 
125     using SafeMath for uint256;
126 
127     string public name;
128     string public symbol;
129     uint8 public decimals;
130     uint256 supply;
131     uint256 public initialSupply;
132     uint256 public totalSupply;
133 
134     mapping (address => uint256) balances;
135     mapping (address => mapping (address => uint256)) internal allowed;
136     mapping (address => uint256) public balanceOf;
137     
138     event Transfer(address indexed from, address indexed to, uint256 value);
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 
141     constructor() public {
142         name = "Valorem";
143         symbol = "VLR";
144         decimals = 18;
145         supply = 200000000;
146         
147         initialSupply = supply * (10 ** uint256(decimals));
148         totalSupply = initialSupply;
149         balances[owner] = totalSupply;
150         balanceOf[msg.sender] = initialSupply;
151         bountyTransfers();
152     }
153 
154     function bountyTransfers() internal {
155 
156         address reserveAccount;
157         address bountyAccount;
158 
159         uint256 reserveToken;
160         uint256 bountyToken;
161 
162 
163         reserveAccount = 0x000f1505CdAEb27197FB652FB2b1fef51cdc524e;
164         bountyAccount = 0x00892214999FdE327D81250407e96Afc76D89CB9;
165 
166         reserveToken = ( totalSupply * 25 ) / 100;
167         bountyToken = ( reserveToken * 7 ) / 100;
168 
169         balanceOf[msg.sender] = totalSupply - reserveToken;
170         balanceOf[bountyAccount] = bountyToken;
171         reserveToken = reserveToken - bountyToken;
172         balanceOf[reserveAccount] = reserveToken;
173 
174         emit Transfer(msg.sender,reserveAccount,reserveToken);
175         emit Transfer(msg.sender,bountyAccount,bountyToken);
176     }
177 
178     /**
179     * @dev Transfer token for a specified address
180     * @param _to The address to transfer to.
181     * @param _value The amount to be transferred.
182     */
183     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
184         require(_value <= balances[msg.sender]);
185         require(_to != address(0));
186 
187         balances[msg.sender] = balances[msg.sender].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189         emit Transfer(msg.sender, _to, _value);
190         return true;
191     }
192 
193     /**
194     * @dev Gets the balance of the specified address.
195     * @param _owner The address to query the the balance of.
196     * @return An uint256 representing the amount owned by the passed address.
197     */
198     function balanceOf(address _owner) public view whenNotPaused returns (uint256) {
199         return balances[_owner];
200     }
201 
202     /**
203     * @dev Transfer tokens from one address to another
204     * @param _from address The address which you want to send tokens from
205     * @param _to address The address which you want to transfer to
206     * @param _value uint256 the amount of tokens to be transferred
207     */
208     function transferFrom( address _from, address _to, uint256 _value ) public whenNotPaused returns (bool) {
209         require(_value <= balances[_from]);
210         require(_value <= allowed[_from][msg.sender]);
211         require(_to != address(0));
212 
213         balances[_from] = balances[_from].sub(_value);
214         balances[_to] = balances[_to].add(_value);
215         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216         emit Transfer(_from, _to, _value);
217         return true;
218     }
219 
220     /**
221     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222     * Beware that changing an allowance with this method brings the risk that someone may use both the old
223     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226     * @param _spender The address which will spend the funds.
227     * @param _value The amount of tokens to be spent.
228     */
229     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
230         allowed[msg.sender][_spender] = _value;
231         emit Approval(msg.sender, _spender, _value);
232         return true;
233     }
234 
235     /**
236     * @dev Function to check the amount of tokens that an owner allowed to a spender.
237     * @param _owner address The address which owns the funds.
238     * @param _spender address The address which will spend the funds.
239     * @return A uint256 specifying the amount of tokens still available for the spender.
240     */
241     function allowance(address _owner, address _spender) public view whenNotPaused returns (uint256) {
242         return allowed[_owner][_spender];
243     }
244 
245     /**
246     * @dev Increase the amount of tokens that an owner allowed to a spender.
247     * approve should be called when allowed[_spender] == 0. To increment
248     * allowed value is better to use this function to avoid 2 calls (and wait until
249     * the first transaction is mined)
250     * From MonolithDAO Token.sol
251     * @param _spender The address which will spend the funds.
252     * @param _addedValue The amount of tokens to increase the allowance by.
253     */
254     function increaseApproval( address _spender, uint256 _addedValue ) public whenNotPaused returns (bool) {
255         allowed[msg.sender][_spender] = ( allowed[msg.sender][_spender].add(_addedValue));
256         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257         return true;
258     }
259 
260     /**
261     * @dev Decrease the amount of tokens that an owner allowed to a spender.
262     * approve should be called when allowed[_spender] == 0. To decrement
263     * allowed value is better to use this function to avoid 2 calls (and wait until
264     * the first transaction is mined)
265     * From MonolithDAO Token.sol
266     * @param _spender The address which will spend the funds.
267     * @param _subtractedValue The amount of tokens to decrease the allowance by.
268     */
269     function decreaseApproval( address _spender, uint256 _subtractedValue ) public whenNotPaused returns (bool) {
270         uint256 oldValue = allowed[msg.sender][_spender];
271         if (_subtractedValue >= oldValue) {
272             allowed[msg.sender][_spender] = 0;
273         } else {
274             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
275         }
276         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277         return true;
278     }
279 
280 }
281 
282 contract Valorem is StandardToken {
283 
284     using SafeMath for uint256;
285 
286     mapping (address => uint256) public freezed;
287 
288     event Burn(address indexed burner, uint256 value);
289     event Mint(address indexed to, uint256 amount);
290     event Withdraw(address indexed _from, address indexed _to, uint256 _value);
291     event Freeze(address indexed from, uint256 value);
292     event Unfreeze(address indexed from, uint256 value);
293 
294     /**
295     * @dev Burns a specific amount of tokens.
296     * @param _value The amount of token to be burned.
297     */
298     function burn(uint256 _value) public onlyOwner whenNotPaused {
299         _burn(msg.sender, _value);
300     }
301 
302     function _burn(address _who, uint256 _value) internal {
303         require(_value <= balances[_who]);
304         // no need to require value <= totalSupply, since that would imply the
305         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
306         balances[_who] = balances[_who].sub(_value);
307         totalSupply = totalSupply.sub(_value);
308         emit Burn(_who, _value);
309         emit Transfer(_who, address(0), _value);
310     }
311 
312     function burnFrom(address _from, uint256 _value) public onlyOwner whenNotPaused {
313         require(_value <= allowed[_from][msg.sender]);
314         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
315         // this function needs to emit an event with the updated approval.
316         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
317         _burn(_from, _value);
318     }
319 
320     /**
321     * @dev Function to mint tokens
322     * @param _to The address that will receive the minted tokens.
323     * @param _amount The amount of tokens to mint.
324     * @return A boolean that indicates if the operation was successful.
325     */
326     function mint(address _to, uint256 _amount) public onlyOwner whenNotPaused returns (bool) {
327         totalSupply = totalSupply.add(_amount);
328         balances[_to] = balances[_to].add(_amount);
329         emit Mint(_to, _amount);
330         emit Transfer(address(0), _to, _amount);
331         return true;
332     }
333 
334     function freeze(address _spender,uint256 _value) public onlyOwner whenNotPaused returns (bool success) {
335         require(_value < balances[_spender]);
336         require(_value >= 0); 
337         balances[_spender] = balances[_spender].sub(_value);                     
338         freezed[_spender] = freezed[_spender].add(_value);                               
339         emit Freeze(_spender, _value);
340         return true;
341     }
342 	
343     function unfreeze(address _spender,uint256 _value) public onlyOwner whenNotPaused returns (bool success) {
344         require(freezed[_spender] < _value);
345         require(_value <= 0); 
346         freezed[_spender] = freezed[_spender].sub(_value);                      
347         balances[_spender] = balances[_spender].add(_value);
348         emit Unfreeze(_spender, _value);
349         return true;
350     }
351     
352     function withdrawEther(address _account) public onlyOwner whenNotPaused payable returns (bool success) {
353         _account.transfer(address(this).balance);
354 
355         emit Withdraw(this, _account, address(this).balance);
356         return true;
357     }
358     
359     function newTokens(address _owner, uint256 _value) onlyOwner public{
360         balanceOf[_owner] = balanceOf[_owner].add(_value);
361         totalSupply = totalSupply.add(_value);
362         emit Transfer(this, _owner, _value);
363     }
364 
365     function() public payable {
366         
367     }
368 }