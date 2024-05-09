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
134    
135 
136     address public marketingReserve;
137     address public bountyReserve;
138     address public teamReserve;
139     
140     uint256 marketingToken;
141     uint256 bountyToken;
142     uint256 teamToken;
143     
144     mapping (address => uint256) balances;
145     mapping (address => mapping (address => uint256)) internal allowed;
146 
147     event Transfer(address indexed from, address indexed to, uint256 value);
148     event Approval(address indexed owner, address indexed spender, uint256 value);
149 
150     constructor() public {
151         name = "Bitbose";
152         symbol = "BOSE";
153         decimals = 18;
154         supply = 300000000;
155         initialSupply = supply * (10 ** uint256(decimals));
156 
157         totalSupply = initialSupply;
158         balances[owner] = totalSupply;
159 
160         bountyTransfers();
161     }
162 
163     function bountyTransfers() internal {
164         
165         marketingReserve = 0x0093126Cc5Db9BaFe75EdEB19F305E724E28213D;
166         bountyReserve = 0x00E3b0794F69015fc4a8635F788A41F11d88Aa07;
167         teamReserve = 0x004f678A05E41D2df20041D70dd5aca493369904;
168 
169         marketingToken = ( totalSupply * 12 ) / 100;
170         bountyToken = ( totalSupply * 2 ) / 100;
171         teamToken = ( totalSupply * 16 ) / 100;
172 
173         balances[msg.sender] = totalSupply - marketingToken - teamToken - bountyToken;
174         balances[teamReserve] = teamToken;
175         balances[bountyReserve] = bountyToken;
176         balances[marketingReserve] = marketingToken;
177 
178         Transfer(msg.sender, marketingReserve, marketingToken);
179         Transfer(msg.sender, bountyReserve, bountyToken);
180         Transfer(msg.sender, teamReserve, teamToken);
181     }
182     /**
183     * @dev Transfer token for a specified address
184     * @param _to The address to transfer to.
185     * @param _value The amount to be transferred.
186     */
187     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
188         require(_value <= balances[msg.sender]);
189         require(_to != address(0));
190 
191         balances[msg.sender] = balances[msg.sender].sub(_value);
192         balances[_to] = balances[_to].add(_value);
193         emit Transfer(msg.sender, _to, _value);
194         return true;
195     }
196 
197     /**
198     * @dev Gets the balance of the specified address.
199     * @param _owner The address to query the the balance of.
200     * @return An uint256 representing the amount owned by the passed address.
201     */
202     function balanceOf(address _owner) public view whenNotPaused returns (uint256) {
203         return balances[_owner];
204     }
205 
206     /**
207     * @dev Transfer tokens from one address to another
208     * @param _from address The address which you want to send tokens from
209     * @param _to address The address which you want to transfer to
210     * @param _value uint256 the amount of tokens to be transferred
211     */
212     function transferFrom( address _from, address _to, uint256 _value ) public whenNotPaused returns (bool) {
213         require(_value <= balances[_from]);
214         require(_value <= allowed[_from][msg.sender]);
215         require(_to != address(0));
216 
217         balances[_from] = balances[_from].sub(_value);
218         balances[_to] = balances[_to].add(_value);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220         emit Transfer(_from, _to, _value);
221         return true;
222     }
223 
224     /**
225     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226     * Beware that changing an allowance with this method brings the risk that someone may use both the old
227     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230     * @param _spender The address which will spend the funds.
231     * @param _value The amount of tokens to be spent.
232     */
233     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
234         allowed[msg.sender][_spender] = _value;
235         emit Approval(msg.sender, _spender, _value);
236         return true;
237     }
238 
239     /**
240     * @dev Function to check the amount of tokens that an owner allowed to a spender.
241     * @param _owner address The address which owns the funds.
242     * @param _spender address The address which will spend the funds.
243     * @return A uint256 specifying the amount of tokens still available for the spender.
244     */
245     function allowance(address _owner, address _spender) public view whenNotPaused returns (uint256) {
246         return allowed[_owner][_spender];
247     }
248 
249     /**
250     * @dev Increase the amount of tokens that an owner allowed to a spender.
251     * approve should be called when allowed[_spender] == 0. To increment
252     * allowed value is better to use this function to avoid 2 calls (and wait until
253     * the first transaction is mined)
254     * From MonolithDAO Token.sol
255     * @param _spender The address which will spend the funds.
256     * @param _addedValue The amount of tokens to increase the allowance by.
257     */
258     function increaseApproval( address _spender, uint256 _addedValue ) public whenNotPaused returns (bool) {
259         allowed[msg.sender][_spender] = ( allowed[msg.sender][_spender].add(_addedValue));
260         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261         return true;
262     }
263 
264     /**
265     * @dev Decrease the amount of tokens that an owner allowed to a spender.
266     * approve should be called when allowed[_spender] == 0. To decrement
267     * allowed value is better to use this function to avoid 2 calls (and wait until
268     * the first transaction is mined)
269     * From MonolithDAO Token.sol
270     * @param _spender The address which will spend the funds.
271     * @param _subtractedValue The amount of tokens to decrease the allowance by.
272     */
273     function decreaseApproval( address _spender, uint256 _subtractedValue ) public whenNotPaused returns (bool) {
274         uint256 oldValue = allowed[msg.sender][_spender];
275         if (_subtractedValue >= oldValue) {
276             allowed[msg.sender][_spender] = 0;
277         } else {
278             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
279         }
280         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281         return true;
282     }
283 
284 }
285 
286 contract Bitbose is StandardToken {
287 
288     using SafeMath for uint256;
289 
290     mapping (address => uint256) public freezed;
291 
292     event Burn(address indexed burner, uint256 value);
293     event Mint(address indexed to, uint256 amount);
294     event Withdraw(address indexed _from, address indexed _to, uint256 _value);
295     event Freeze(address indexed from, uint256 value);
296     event Unfreeze(address indexed from, uint256 value);
297 
298     /**
299     * @dev Burns a specific amount of tokens.
300     * @param _value The amount of token to be burned.
301     */
302     function burn(uint256 _value) public onlyOwner whenNotPaused {
303         _burn(msg.sender, _value);
304     }
305 
306     function _burn(address _who, uint256 _value) internal {
307         require(_value <= balances[_who]);
308         // no need to require value <= totalSupply, since that would imply the
309         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
310         balances[_who] = balances[_who].sub(_value);
311         totalSupply = totalSupply.sub(_value);
312         emit Burn(_who, _value);
313         emit Transfer(_who, address(0), _value);
314     }
315 
316     function burnFrom(address _from, uint256 _value) public onlyOwner whenNotPaused {
317         require(_value <= allowed[_from][msg.sender]);
318         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
319         // this function needs to emit an event with the updated approval.
320         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
321         _burn(_from, _value);
322     }
323 
324     /**
325     * @dev Function to mint tokens
326     * @param _to The address that will receive the minted tokens.
327     * @param _amount The amount of tokens to mint.
328     * @return A boolean that indicates if the operation was successful.
329     */
330     function mint(address _to, uint256 _amount) public onlyOwner whenNotPaused returns (bool) {
331         totalSupply = totalSupply.add(_amount);
332         balances[_to] = balances[_to].add(_amount);
333         emit Mint(_to, _amount);
334         emit Transfer(address(0), _to, _amount);
335         return true;
336     }
337 
338     function freeze(address _spender,uint256 _value) public onlyOwner whenNotPaused returns (bool success) {
339         require(_value < balances[_spender]);
340         require(_value >= 0); 
341         balances[_spender] = balances[_spender].sub(_value);                     
342         freezed[_spender] = freezed[_spender].add(_value);                               
343         emit Freeze(_spender, _value);
344         return true;
345     }
346 	
347     function unfreeze(address _spender,uint256 _value) public onlyOwner whenNotPaused returns (bool success) {
348         require(freezed[_spender] < _value);
349         require(_value <= 0); 
350         freezed[_spender] = freezed[_spender].sub(_value);                      
351         balances[_spender] = balances[_spender].add(_value);
352         emit Unfreeze(_spender, _value);
353         return true;
354     }
355     
356     function withdrawEther(address _account) public onlyOwner whenNotPaused payable returns (bool success) {
357         _account.transfer(address(this).balance);
358 
359         emit Withdraw(this, _account, address(this).balance);
360         return true;
361     }
362 
363     function() public payable {
364         
365     }
366 
367 }