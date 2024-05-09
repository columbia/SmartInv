1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20Basic {
5     function totalSupply() public view returns (uint256);
6     function balanceOf(address who) public view returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12     function allowance(address owner, address spender)
13         public view returns (uint256);
14 
15     function transferFrom(address from, address to, uint256 value)
16         public returns (bool);
17 
18     function approve(address spender, uint256 value) public returns (bool);
19     event Approval(
20         address indexed owner,
21         address indexed spender,
22         uint256 value
23     );
24 }
25 
26 contract BasicToken is ERC20Basic {
27     using SafeMath for uint256;
28 
29     mapping(address => uint256) public balances;
30 
31     uint256 public totalSupply_;
32 
33     function totalSupply() public view returns (uint256) {
34         return totalSupply_;
35     }
36 
37     /**
38     * Transfer token for a specified address
39     * @param _to The address to transfer to.
40     * @param _value The amount to be transferred.
41     */
42     function transfer(address _to, uint256 _value) public returns (bool) {
43         require(_to != address(0));
44         require(_value <= balances[msg.sender]);
45 
46         balances[msg.sender] = balances[msg.sender].sub(_value);
47         balances[_to] = balances[_to].add(_value);
48         emit Transfer(msg.sender, _to, _value);
49         return true;
50     }
51 
52     /**
53     * Gets the balance of the specified address.
54     * @param _owner The address to query the the balance of.
55     * @return An uint256 representing the amount owned by the passed address.
56     */
57     function balanceOf(address _owner) public view returns (uint256) {
58         return balances[_owner];
59     }
60 }
61 
62 
63 /**
64  * @title Ownable
65  * The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69     address public owner;
70 
71 
72     event OwnershipRenounced(address indexed previousOwner);
73     event OwnershipTransferred(
74         address indexed previousOwner,
75         address indexed newOwner
76     );
77 
78 
79     /**
80     * The Ownable constructor sets the original `owner` of the contract to the sender
81     * account.
82     */
83     constructor() public {
84         owner = msg.sender;
85     }
86 
87     /**
88     * Throws if called by any account other than the owner.
89     */
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }
94 
95     /**
96     * Allows the current owner to relinquish control of the contract.
97     * @notice Renouncing to ownership will leave the contract without an owner.
98     * It will not be possible to call the functions with the `onlyOwner`
99     * modifier anymore.
100     */
101     function renounceOwnership() public onlyOwner {
102         emit OwnershipRenounced(owner);
103         owner = address(0);
104     }
105 
106     /**
107     * Allows the current owner to transfer control of the contract to a newOwner.
108     * @param _newOwner The address to transfer ownership to.
109     */
110     function transferOwnership(address _newOwner) public onlyOwner {
111         _transferOwnership(_newOwner);
112     }
113 
114     /**
115     * Transfers control of the contract to a newOwner.
116     * @param _newOwner The address to transfer ownership to.
117     */
118     function _transferOwnership(address _newOwner) internal {
119         require(_newOwner != address(0));
120         emit OwnershipTransferred(owner, _newOwner);
121         owner = _newOwner;
122     }
123 }
124 
125 /**
126  * @title SafeMath
127  * Math operations with safety checks that throw on error
128  */
129 library SafeMath {
130 
131     /**
132     * Multiplies two numbers, throws on overflow.
133     */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
135         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.       
137         if (a == 0) {
138             return 0;
139         }
140 
141         c = a * b;
142         assert(c / a == b);
143         return c;
144     }
145 
146     /**
147     * Integer division of two numbers, truncating the quotient.
148     */
149     function div(uint256 a, uint256 b) internal pure returns (uint256) {
150         // assert(b > 0); // Solidity automatically throws when dividing by 0
151         // uint256 c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153         return a / b;
154     }
155 
156     /**
157     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
158     */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         assert(b <= a);
161         return a - b;
162     }
163 
164     /**
165     * Adds two numbers, throws on overflow.
166     */
167     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
168         c = a + b;
169         assert(c >= a);
170         return c;
171     }
172 }
173 
174 contract StandardToken is ERC20, BasicToken {
175 
176     mapping (address => mapping (address => uint256)) internal allowed;
177     /**
178     * Transfer tokens from one address to another
179     * @param _from address The address which you want to send tokens from
180     * @param _to address The address which you want to transfer to
181     * @param _value uint256 the amount of tokens to be transferred
182     */
183     function transferFrom(
184         address _from,
185         address _to,
186         uint256 _value
187     )
188         public
189         returns (bool)
190     {
191         require(_to != address(0));
192         require(_value <= balances[_from]);
193         require(_value <= allowed[_from][msg.sender]);
194 
195         balances[_from] = balances[_from].sub(_value);
196         balances[_to] = balances[_to].add(_value);
197         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198         emit Transfer(_from, _to, _value);
199         return true;
200     }
201 
202     /**
203     * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204     * Beware that changing an allowance with this method brings the risk that someone may use both the old
205     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:  
207     * @param _spender The address which will spend the funds.
208     * @param _value The amount of tokens to be spent.
209     */
210     function approve(address _spender, uint256 _value) public returns (bool) {
211         allowed[msg.sender][_spender] = _value;
212         emit Approval(msg.sender, _spender, _value);
213         return true;
214     }
215 
216     /**
217     * Function to check the amount of tokens that an owner allowed to a spender.
218     * @param _owner address The address which owns the funds.
219     * @param _spender address The address which will spend the funds.
220     * @return A uint256 specifying the amount of tokens still available for the spender.
221     */
222     function allowance(
223         address _owner,
224         address _spender
225     )
226         public
227         view
228         returns (uint256)
229     {
230         return allowed[_owner][_spender];
231     }
232 
233     /**
234     * Increase the amount of tokens that an owner allowed to a spender.
235     * approve should be called when allowed[_spender] == 0. To increment
236     * allowed value is better to use this function to avoid 2 calls (and wait until
237     * the first transaction is mined) 
238     * @param _spender The address which will spend the funds.
239     * @param _addedValue The amount of tokens to increase the allowance by.
240     */
241     function increaseApproval(
242         address _spender,
243         uint256 _addedValue
244     )
245         public
246         returns (bool)
247     {
248         allowed[msg.sender][_spender] = (
249         allowed[msg.sender][_spender].add(_addedValue));
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254     /**
255     * Decrease the amount of tokens that an owner allowed to a spender.
256     * approve should be called when allowed[_spender] == 0. To decrement
257     * allowed value is better to use this function to avoid 2 calls (and wait until
258     * the first transaction is mined)   
259     * @param _spender The address which will spend the funds.
260     * @param _subtractedValue The amount of tokens to decrease the allowance by.
261     */
262     function decreaseApproval(
263         address _spender,
264         uint256 _subtractedValue
265     )
266         public
267         returns (bool)
268     {
269         uint256 oldValue = allowed[msg.sender][_spender];
270         if (_subtractedValue > oldValue) {
271             allowed[msg.sender][_spender] = 0;
272         } else {
273             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274         }
275         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276         return true;
277     }
278 }
279 
280 
281 contract MintableToken is StandardToken, Ownable {
282     event Mint(address indexed to, uint256 amount);
283     event MintFinished();
284 
285     bool public mintingFinished = false;
286 
287 
288     modifier canMint() {
289         require(!mintingFinished);
290         _;
291     }
292 
293     modifier hasMintPermission() {
294         require(msg.sender == owner);
295         _;
296     }
297 
298     /**
299     * Function to mint tokens
300     * @param _to The address that will receive the minted tokens.
301     * @param _amount The amount of tokens to mint.
302     * @return A boolean that indicates if the operation was successful.
303     */
304     function mint(
305         address _to,
306         uint256 _amount
307     )
308         hasMintPermission
309         canMint
310         public
311         returns (bool)
312     {
313         totalSupply_ = totalSupply_.add(_amount);
314         balances[_to] = balances[_to].add(_amount);
315         emit Mint(_to, _amount);
316         emit Transfer(address(0), _to, _amount);
317         return true;
318     }
319 
320     /**
321     * Function to stop minting new tokens.
322     * @return True if the operation was successful.
323     */
324     function finishMinting() onlyOwner canMint public returns (bool) {
325         mintingFinished = true;
326         emit MintFinished();
327         return true;
328     }
329 }
330 
331 contract SUREToken is MintableToken {
332     address private deployedAddress = 0x65E5fF263Dd264b78ADcb08c1788c4CEC8910B4B; //Replace this address by the Ethereum main net
333     string public name = "SURETY Token";
334     string public symbol = "SURE";    
335     uint public decimals = 6;
336     uint public totalSupplyToken = 500000000;  
337 
338     /* The finalizer contract that allows unlift the transfer limits on this token */
339     address public releaseAgent;
340 
341     /* A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
342     bool public released = false;
343 
344      /* Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
345     mapping (address => bool) public transferAgents;
346 
347      /* A contract can release SURETY.AI team members/advisors to transfertoken. If false we are are in transfer lock up period.*/
348     bool public releasedTeam = false;
349 
350      /* Map of SURETY.AI's team members/advisors. */
351     mapping (address => bool) public teamMembers;
352     
353     constructor() public {                    
354         totalSupply_ = totalSupplyToken * (10 ** decimals);
355         balances[deployedAddress] = totalSupply_;
356         transferAgents[deployedAddress] = true;        
357         releaseAgent = deployedAddress;
358         emit Transfer(address(0), deployedAddress, totalSupply_);
359     }   
360    
361     /**
362     * Limit token transfer until the crowdsale is over.    
363     */
364     modifier canTransfer(address _sender) {
365 
366         if(!released) {
367             if(!transferAgents[_sender]) {
368                 revert("The token is in the locking period");
369             }
370         }
371         else if (!releasedTeam && teamMembers[_sender])
372         {
373             revert("Team members/advisors cannot trade during this period.");
374         }    
375         _;
376     }
377 
378     /**
379     * Set the contract that can call release and make the token transferable.  
380     */
381     function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {      
382         releaseAgent = addr;
383     }
384 
385     /**
386     * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
387     */
388     function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
389         require (!teamMembers[addr], "Error! This address is a team member/advisor address.");
390         transferAgents[addr] = state;       
391     }
392 
393      /**
394     * Owner can add the team member/advisor address.
395     */
396     function setTeamMember(address addr, bool state) onlyOwner inReleaseState(false) public {
397         require (!transferAgents[addr], "Error! This address is in the transfer agent list.");
398         teamMembers[addr] = state;            
399     }
400 
401 
402     /**
403     * End locking state
404     */
405     function releaseTokenTransfer() public onlyReleaseAgent {
406         released = true;
407     }
408 
409     /**
410     * Resume locking state.
411     */
412     function stopTokenTransfer() public onlyReleaseAgent {
413         released = false;
414     }
415 
416      /**
417     * End locking state for team member/advisor.
418     */
419     function releaseTeamTokenTransfer() public onlyReleaseAgent {
420         releasedTeam = true;
421     }
422 
423     /**
424     * Resume locking state for team member/advisor.
425     */
426     function stopTeamTokenTransfer() public onlyReleaseAgent {
427         releasedTeam = false;
428     }
429 
430     /** The function can be called only before or after the tokens have been releasesd */
431     modifier inReleaseState(bool releaseState) {
432         if(releaseState != released) {
433             revert();
434         }
435         _;
436     }
437 
438     /** The function can be called only by a whitelisted release agent. */
439     modifier onlyReleaseAgent() {
440         if(msg.sender != releaseAgent) {
441             revert();
442         }
443         _;
444     }
445 
446     function transfer(address _to, uint256 _value) canTransfer(msg.sender) public returns (bool success) {        
447         return super.transfer(_to, _value);
448     }
449 
450     function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {        
451         return super.transferFrom(_from, _to, _value);
452     }
453 }