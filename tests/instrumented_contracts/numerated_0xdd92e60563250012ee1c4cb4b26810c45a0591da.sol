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
136 
137     event Transfer(address indexed from, address indexed to, uint256 value);
138     event Approval(address indexed owner, address indexed spender, uint256 value);
139 
140     constructor() public {
141         name = "Firetoken";
142         symbol = "FPWR";
143         decimals = 18;
144         supply = 1800000000;
145         initialSupply = supply * (10 ** uint256(decimals));
146 
147         totalSupply = initialSupply;
148         balances[owner] = totalSupply;
149 
150         bountyTransfers();
151     }
152 
153     function bountyTransfers() internal {
154 
155         address marketingReserve;
156         address devteamReserve;
157         address bountyReserve;
158         address teamReserve;
159 
160         uint256 marketingToken;
161         uint256 devteamToken;
162         uint256 bountyToken;
163         uint256 teamToken;
164 
165         marketingReserve = 0x00Fe8117437eeCB51782b703BD0272C14911ECdA;
166         bountyReserve = 0x0089F23EeeCCF6bd677C050E59697D1f6feB6227;
167         teamReserve = 0x00FD87f78843D7580a4c785A1A5aaD0862f6EB19;
168         devteamReserve = 0x005D4Fe4DAf0440Eb17bc39534929B71a2a13F48;
169 
170         marketingToken = ( totalSupply * 10 ) / 100;
171         bountyToken = ( totalSupply * 10 ) / 100;
172         teamToken = ( totalSupply * 26 ) / 100;
173         devteamToken = ( totalSupply * 10 ) / 100;
174 
175         balances[msg.sender] = totalSupply - marketingToken - teamToken - devteamToken - bountyToken;
176         balances[teamReserve] = teamToken;
177         balances[devteamReserve] = devteamToken;
178         balances[bountyReserve] = bountyToken;
179         balances[marketingReserve] = marketingToken;
180 
181         emit Transfer(msg.sender, marketingReserve, marketingToken);
182         emit Transfer(msg.sender, bountyReserve, bountyToken);
183         emit Transfer(msg.sender, teamReserve, teamToken);
184         emit Transfer(msg.sender, devteamReserve, devteamToken);
185     }
186 
187     /**
188     * @dev Transfer token for a specified address
189     * @param _to The address to transfer to.
190     * @param _value The amount to be transferred.
191     */
192     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
193         require(_value <= balances[msg.sender]);
194         require(_to != address(0));
195 
196         balances[msg.sender] = balances[msg.sender].sub(_value);
197         balances[_to] = balances[_to].add(_value);
198         emit Transfer(msg.sender, _to, _value);
199         return true;
200     }
201 
202     /**
203     * @dev Gets the balance of the specified address.
204     * @param _owner The address to query the the balance of.
205     * @return An uint256 representing the amount owned by the passed address.
206     */
207     function balanceOf(address _owner) public view whenNotPaused returns (uint256) {
208         return balances[_owner];
209     }
210 
211     /**
212     * @dev Transfer tokens from one address to another
213     * @param _from address The address which you want to send tokens from
214     * @param _to address The address which you want to transfer to
215     * @param _value uint256 the amount of tokens to be transferred
216     */
217     function transferFrom( address _from, address _to, uint256 _value ) public whenNotPaused returns (bool) {
218         require(_value <= balances[_from]);
219         require(_value <= allowed[_from][msg.sender]);
220         require(_to != address(0));
221 
222         balances[_from] = balances[_from].sub(_value);
223         balances[_to] = balances[_to].add(_value);
224         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225         emit Transfer(_from, _to, _value);
226         return true;
227     }
228 
229     /**
230     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231     * Beware that changing an allowance with this method brings the risk that someone may use both the old
232     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235     * @param _spender The address which will spend the funds.
236     * @param _value The amount of tokens to be spent.
237     */
238     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
239         allowed[msg.sender][_spender] = _value;
240         emit Approval(msg.sender, _spender, _value);
241         return true;
242     }
243 
244     /**
245     * @dev Function to check the amount of tokens that an owner allowed to a spender.
246     * @param _owner address The address which owns the funds.
247     * @param _spender address The address which will spend the funds.
248     * @return A uint256 specifying the amount of tokens still available for the spender.
249     */
250     function allowance(address _owner, address _spender) public view whenNotPaused returns (uint256) {
251         return allowed[_owner][_spender];
252     }
253 
254     /**
255     * @dev Increase the amount of tokens that an owner allowed to a spender.
256     * approve should be called when allowed[_spender] == 0. To increment
257     * allowed value is better to use this function to avoid 2 calls (and wait until
258     * the first transaction is mined)
259     * From MonolithDAO Token.sol
260     * @param _spender The address which will spend the funds.
261     * @param _addedValue The amount of tokens to increase the allowance by.
262     */
263     function increaseApproval( address _spender, uint256 _addedValue ) public whenNotPaused returns (bool) {
264         allowed[msg.sender][_spender] = ( allowed[msg.sender][_spender].add(_addedValue));
265         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266         return true;
267     }
268 
269     /**
270     * @dev Decrease the amount of tokens that an owner allowed to a spender.
271     * approve should be called when allowed[_spender] == 0. To decrement
272     * allowed value is better to use this function to avoid 2 calls (and wait until
273     * the first transaction is mined)
274     * From MonolithDAO Token.sol
275     * @param _spender The address which will spend the funds.
276     * @param _subtractedValue The amount of tokens to decrease the allowance by.
277     */
278     function decreaseApproval( address _spender, uint256 _subtractedValue ) public whenNotPaused returns (bool) {
279         uint256 oldValue = allowed[msg.sender][_spender];
280         if (_subtractedValue >= oldValue) {
281             allowed[msg.sender][_spender] = 0;
282         } else {
283             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
284         }
285         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286         return true;
287     }
288 
289 }
290 
291 contract Firetoken is StandardToken {
292 
293     using SafeMath for uint256;
294 
295     mapping (address => uint256) public freezed;
296 
297     event Burn(address indexed burner, uint256 value);
298     event Mint(address indexed to, uint256 amount);
299     event Withdraw(address indexed _from, address indexed _to, uint256 _value);
300     event Freeze(address indexed from, uint256 value);
301     event Unfreeze(address indexed from, uint256 value);
302 
303     /**
304     * @dev Burns a specific amount of tokens.
305     * @param _value The amount of token to be burned.
306     */
307     function burn(uint256 _value) public onlyOwner whenNotPaused {
308         _burn(msg.sender, _value);
309     }
310 
311     function _burn(address _who, uint256 _value) internal {
312         require(_value <= balances[_who]);
313         // no need to require value <= totalSupply, since that would imply the
314         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
315         balances[_who] = balances[_who].sub(_value);
316         totalSupply = totalSupply.sub(_value);
317         emit Burn(_who, _value);
318         emit Transfer(_who, address(0), _value);
319     }
320 
321     function burnFrom(address _from, uint256 _value) public onlyOwner whenNotPaused {
322         require(_value <= allowed[_from][msg.sender]);
323         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
324         // this function needs to emit an event with the updated approval.
325         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
326         _burn(_from, _value);
327     }
328 
329     /**
330     * @dev Function to mint tokens
331     * @param _to The address that will receive the minted tokens.
332     * @param _amount The amount of tokens to mint.
333     * @return A boolean that indicates if the operation was successful.
334     */
335     function mint(address _to, uint256 _amount) public onlyOwner whenNotPaused returns (bool) {
336         totalSupply = totalSupply.add(_amount);
337         balances[_to] = balances[_to].add(_amount);
338         emit Mint(_to, _amount);
339         emit Transfer(address(0), _to, _amount);
340         return true;
341     }
342 
343     function freeze(address _spender,uint256 _value) public onlyOwner whenNotPaused returns (bool success) {
344         require(_value < balances[_spender]);
345         require(_value >= 0); 
346         balances[_spender] = balances[_spender].sub(_value);                     
347         freezed[_spender] = freezed[_spender].add(_value);                               
348         emit Freeze(_spender, _value);
349         return true;
350     }
351 	
352     function unfreeze(address _spender,uint256 _value) public onlyOwner whenNotPaused returns (bool success) {
353         require(freezed[_spender] < _value);
354         require(_value <= 0); 
355         freezed[_spender] = freezed[_spender].sub(_value);                      
356         balances[_spender] = balances[_spender].add(_value);
357         emit Unfreeze(_spender, _value);
358         return true;
359     }
360     
361     function withdrawEther(address _account) public onlyOwner whenNotPaused payable returns (bool success) {
362         _account.transfer(address(this).balance);
363 
364         emit Withdraw(this, _account, address(this).balance);
365         return true;
366     }
367 
368     function() public payable {
369         
370     }
371 
372 }