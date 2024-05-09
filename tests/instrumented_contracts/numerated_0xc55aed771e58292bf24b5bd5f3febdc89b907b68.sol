1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() public {
43     owner = msg.sender;
44   }
45 
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55 
56   /**
57    * @dev Allows the current owner to transfer control of the contract to a newOwner.
58    * @param newOwner The address to transfer ownership to.
59    */
60   function transferOwnership(address newOwner) public onlyOwner {
61     require(newOwner != address(0));
62     OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 
66 }
67 
68 contract HasNoEther is Ownable {
69 
70   /**
71   * @dev Constructor that rejects incoming Ether
72   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
73   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
74   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
75   * we could use assembly to access msg.value.
76   */
77   function HasNoEther() public payable {
78     require(msg.value == 0);
79   }
80 
81   /**
82    * @dev Disallows direct send by settings a default function without the `payable` flag.
83    */
84   function() external {
85   }
86 
87   /**
88    * @dev Transfer all Ether held by the contract to the owner.
89    */
90   function reclaimEther() external onlyOwner {
91     assert(owner.send(this.balance));
92   }
93 }
94 
95 contract ERC20Basic {
96   uint256 public totalSupply;
97   function balanceOf(address who) public view returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) public view returns (uint256);
136   function transferFrom(address from, address to, uint256 value) public returns (bool);
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) internal allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156 
157     balances[_from] = balances[_from].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160     Transfer(_from, _to, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    *
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(address _owner, address _spender) public view returns (uint256) {
187     return allowed[_owner][_spender];
188   }
189 
190   /**
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    */
196   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
197     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
203     uint oldValue = allowed[msg.sender][_spender];
204     if (_subtractedValue > oldValue) {
205       allowed[msg.sender][_spender] = 0;
206     } else {
207       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208     }
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213 }
214 
215 contract BurnableToken is StandardToken {
216 
217     event Burn(address indexed burner, uint256 value);
218 
219     /**
220      * @dev Burns a specific amount of tokens.
221      * @param _value The amount of token to be burned.
222      */
223     function burn(uint256 _value) public {
224         require(_value > 0);
225         require(_value <= balances[msg.sender]);
226         // no need to require value <= totalSupply, since that would imply the
227         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
228 
229         address burner = msg.sender;
230         balances[burner] = balances[burner].sub(_value);
231         totalSupply = totalSupply.sub(_value);
232         Burn(burner, _value);
233     }
234 	
235 
236 }
237 
238 contract VoteToken is HasNoEther, BurnableToken {
239 	
240     struct stSuggestion {
241 		string  text;	//suggestion text (question)
242 		uint256 total_yes;	//votes score
243 		uint256 total_no;	//votes score
244 		uint256 timeStop; //timestamp
245 		bool 	finished;
246 		uint	voters_count;
247 		mapping(uint 	 => address) voters_addrs; //Voted addresses
248 		mapping(address  => uint256) voters_value; //Voted values
249     }
250 	
251 	// List of all suggestions
252 	uint lastID;
253     mapping (uint => stSuggestion) suggestions;
254 	
255 	// Price per Suggestion
256     uint256 public Price;
257 	
258 	function setSuggPrice( uint256 newPrice ) public onlyOwner 
259     {
260         Price = newPrice;
261     }
262 
263 	function getListSize() public view returns (uint count) 
264     {
265         return lastID;
266     }
267 	
268 	function addSuggestion(string s, uint  forDays) public returns (uint newID)
269     {
270         require ( Price <= balances[msg.sender] );
271        
272 		newID = lastID++;
273         suggestions[newID].text = s;
274         suggestions[newID].total_yes = 0;
275         suggestions[newID].total_no  = 0;
276         suggestions[newID].timeStop =  now + forDays * 1 days;
277         suggestions[newID].finished = false;
278         suggestions[newID].voters_count = 0;
279 
280 		balances[msg.sender] = balances[msg.sender].sub(Price);
281         totalSupply = totalSupply.sub(Price);
282     }
283 	
284 	function getSuggestion(uint id) public constant returns(string, uint256, uint256, uint256, bool, uint )
285     {
286 		require ( id <= lastID );
287         return (
288             suggestions[id].text,
289             suggestions[id].total_yes,
290             suggestions[id].total_no,
291             suggestions[id].timeStop,
292             suggestions[id].finished,
293             suggestions[id].voters_count
294             );
295     } 
296 	
297 	function isSuggestionNeedToFinish(uint id) public view returns ( bool ) 
298     {
299 		if ( id > lastID ) return false;
300 		if ( suggestions[id].finished ) return false;
301 		if ( now <= suggestions[id].timeStop ) return false;
302 		
303         return true;
304     } 
305 	
306 	function finishSuggestion( uint id ) public returns (bool)
307 	{
308 	    
309 		if ( !isSuggestionNeedToFinish(id) ) return false;
310 		
311 		uint i;
312 		address addr;
313 		uint256 val;
314 		for ( i = 1; i <= suggestions[id].voters_count; i++){
315 			addr = suggestions[id].voters_addrs[i];
316 			val  = suggestions[id].voters_value[addr];
317 			
318 			balances[addr] = balances[addr].add( val );
319 			totalSupply = totalSupply.add( val );
320 		}
321 		suggestions[id].finished = true;
322 		
323 		return true;
324 	}
325 	
326 	function Vote( uint id, bool MyVote, uint256 Value ) public returns (bool)
327 	{
328 		if ( id > lastID ) return false;
329 		if ( Value > balances[msg.sender] ) return false;
330 		if ( suggestions[id].finished ) return false;
331 	
332 		if (MyVote)
333 			suggestions[id].total_yes += Value;
334 		else
335 			suggestions[id].total_no  += Value;
336 		
337 		suggestions[id].voters_count++;
338 		suggestions[id].voters_addrs[ suggestions[id].voters_count ] = msg.sender;
339 		suggestions[id].voters_value[msg.sender] = suggestions[id].voters_value[msg.sender].add(Value);
340 		
341 		balances[msg.sender] = balances[msg.sender].sub(Value);
342 		
343 		totalSupply = totalSupply.sub(Value);
344 		
345 		return true;
346 	}
347 	
348 	
349 }
350 
351 
352 
353 contract YourVoteMatters is VoteToken {
354 
355     string public constant name = "YourVoteMatters";
356     string public constant symbol = "YVM";
357     uint8 public constant decimals = 18;
358     uint256 constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
359 
360     /**
361     * @dev Constructor that gives msg.sender all of existing tokens.
362     */
363     function YourVoteMatters() public {
364         totalSupply = INITIAL_SUPPLY;
365         balances[msg.sender] = INITIAL_SUPPLY;
366         Transfer(address(0), msg.sender, totalSupply);
367     }
368 
369     /**
370     * @dev transfer token for a specified address
371     * @param _to The address to transfer to.
372     * @param _value The amount to be transferred.
373     */
374     function transfer(address _to, uint256 _value) public returns (bool) {
375         return super.transfer(_to, _value);
376     }
377 
378     /**
379     * @dev Transfer tokens from one address to another
380     * @param _from address The address which you want to send tokens from
381     * @param _to address The address which you want to transfer to
382     * @param _value uint256 the amount of tokens to be transferred
383     */
384     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
385         return super.transferFrom(_from, _to, _value);
386     }
387 
388     function multiTransfer(address[] recipients, uint256[] amounts) public {
389         require(recipients.length == amounts.length);
390         for (uint i = 0; i < recipients.length; i++) {
391             transfer(recipients[i], amounts[i]);
392         }
393     }
394 	
395 	/**
396 	* @dev Create `mintedAmount` tokens
397     * @param mintedAmount The amount of tokens it will minted
398 	**/
399     function mintToken(uint256 mintedAmount) public onlyOwner {
400 			totalSupply += mintedAmount;
401 			balances[owner] += mintedAmount;
402 			Transfer(address(0), owner, mintedAmount);
403     }
404 }