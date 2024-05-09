1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
11   */
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         assert(b <= a);
14         return a - b;
15     }
16 
17   /**
18   * @dev Adds two numbers, throws on overflow.
19   */
20     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 /**
27  * @title ERC20 interface
28  * @dev see https://github.com/ethereum/EIPs/issues/20
29  */
30 contract ERC20 {
31     function allowance(address owner, address spender) public view returns (uint256);
32     function transferFrom(address from, address to, uint256 value) public returns (bool);
33     function approve(address spender, uint256 value) public returns (bool);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 
36     function totalSupply() public view returns (uint256);
37     function balanceOf(address who) public view returns (uint256);
38     function transfer(address to, uint256 value) public returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 /**
43  * @title Standard ERC20 token
44  *
45  * @dev Implementation of the basic standard token.
46  * @dev https://github.com/ethereum/EIPs/issues/20
47  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
48  */
49 contract StandardToken is ERC20 {
50 
51     using SafeMath for uint256;
52 
53     mapping(address => uint256) balances;
54 
55     uint256 totalSupply_;
56     mapping (address => mapping (address => uint256)) internal allowed;
57 
58 
59   /**
60    * @dev Transfer tokens from one address to another
61    * @param _from address The address which you want to send tokens from
62    * @param _to address The address which you want to transfer to
63    * @param _value uint256 the amount of tokens to be transferred
64    */
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
66         require(_to != address(0));
67         require(_value <= balances[_from]);
68         require(_value <= allowed[_from][msg.sender]);
69 
70         balances[_from] = balances[_from].sub(_value);
71         balances[_to] = balances[_to].add(_value);
72         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
73         emit Transfer(_from, _to, _value);
74         return true;
75     }
76 
77   /**
78    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
79    *
80    * Beware that changing an allowance with this method brings the risk that someone may use both the old
81    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
82    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
83    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84    * @param _spender The address which will spend the funds.
85    * @param _value The amount of tokens to be spent.
86    */
87     function approve(address _spender, uint256 _value) public returns (bool) {
88         allowed[msg.sender][_spender] = _value;
89         emit Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93   /**
94    * @dev Function to check the amount of tokens that an owner allowed to a spender.
95    * @param _owner address The address which owns the funds.
96    * @param _spender address The address which will spend the funds.
97    * @return A uint256 specifying the amount of tokens still available for the spender.
98    */
99     function allowance(address _owner, address _spender) public view returns (uint256) {
100         return allowed[_owner][_spender];
101     }
102 
103   /**
104    * @dev Increase the amount of tokens that an owner allowed to a spender.
105    *
106    * approve should be called when allowed[_spender] == 0. To increment
107    * allowed value is better to use this function to avoid 2 calls (and wait until
108    * the first transaction is mined)
109    * From MonolithDAO Token.sol
110    * @param _spender The address which will spend the funds.
111    * @param _addedValue The amount of tokens to increase the allowance by.
112    */
113     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
114         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
115         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116         return true;
117     }
118 
119   /**
120    * @dev Decrease the amount of tokens that an owner allowed to a spender.
121    *
122    * approve should be called when allowed[_spender] == 0. To decrement
123    * allowed value is better to use this function to avoid 2 calls (and wait until
124    * the first transaction is mined)
125    * From MonolithDAO Token.sol
126    * @param _spender The address which will spend the funds.
127    * @param _subtractedValue The amount of tokens to decrease the allowance by.
128    */
129     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
130         uint oldValue = allowed[msg.sender][_spender];
131         if (_subtractedValue > oldValue) {
132             allowed[msg.sender][_spender] = 0;
133         } else {
134             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
135         }
136         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137         return true;
138     }
139 
140      /**
141   * @dev total number of tokens in existence
142   */
143     function totalSupply() public view returns (uint256) {
144         return totalSupply_;
145     }
146 
147   /**
148   * @dev transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152     function transfer(address _to, uint256 _value) public returns (bool) {
153         require(_to != address(0));
154         require(_value <= balances[msg.sender]);
155 
156         balances[msg.sender] = balances[msg.sender].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         emit Transfer(msg.sender, _to, _value);
159         return true;
160     }
161 
162   /**
163   * @dev Gets the balance of the specified address.
164   * @param _owner The address to query the the balance of.
165   * @return An uint256 representing the amount owned by the passed address.
166   */
167     function balanceOf(address _owner) public view returns (uint256 balance) {
168         return balances[_owner];
169     }
170 
171 }
172 
173 contract RotoToken is StandardToken {
174 
175     string public constant name = "Roto"; // token name
176     string public constant symbol = "ROTO"; // token symbol
177     uint8 public constant decimals = 18; // token decimal
178 
179     uint256 public constant INITIAL_SUPPLY = 21000000 * (10 ** uint256(decimals));
180     address owner;
181     address roto = this;
182     address manager;
183 
184     // keeps track of the ROTO currently staked in a tournament
185     // the format is user address -> the tournament they staked in -> how much they staked
186     mapping (address => mapping (bytes32 => uint256)) stakes;
187     uint256 owner_transfer = 2000000 * (10** uint256(decimals));
188   /**
189    * @dev Constructor that gives msg.sender all of existing tokens.
190    */
191 
192     modifier onlyOwner {
193         require(msg.sender==owner);
194         _;
195     }
196 
197     modifier onlyManager {
198       require(msg.sender==manager);
199       _;
200     }
201 
202     event ManagerChanged(address _contract);
203     event RotoStaked(address _user, uint256 stake);
204     event RotoReleased(address _user, uint256 stake);
205     event RotoDestroyed(address _user, uint256 stake);
206     event RotoRewarded(address _contract, address _user, uint256 reward);
207 
208     constructor() public {
209         owner = msg.sender;
210         totalSupply_ = INITIAL_SUPPLY;
211         balances[roto] = INITIAL_SUPPLY;
212         emit Transfer(0x0, roto, INITIAL_SUPPLY);
213     }
214 
215     
216     /**
217      *  @dev A function that can only be called by RotoHive, transfers Roto Tokens out of the contract.
218         @param _to address, the address that the ROTO will be transferred to
219         @param _value ROTO, amount to transfer
220         @return - whether the Roto was transferred succesfully
221      */
222     function transferFromContract(address _to, uint256 _value) public onlyOwner returns(bool) {
223         require(_to!=address(0));
224         require(_value<=balances[roto]);
225         require(owner_transfer > 0);
226 
227         owner_transfer = owner_transfer.sub(_value);
228         
229         balances[roto] = balances[roto].sub(_value);
230         balances[_to] = balances[_to].add(_value);
231 
232         emit Transfer(roto, _to, _value);
233         return true;
234     }
235 
236     /**
237         @dev updates the helper contract(which will manage the tournament) with the new version
238         @param _contract address, the address of the manager contract
239         @return - whether the contract was successfully set
240     */
241     function setManagerContract(address _contract) external onlyOwner returns(bool) {
242       //checks that the address sent isn't the 0 address, the owner or the token contract
243       require(_contract!=address(0)&&_contract!=roto);
244 
245       // requires that the address sent be a contract
246       uint size;
247       assembly { size := extcodesize(_contract) }
248       require(size > 0);
249 
250       manager = _contract;
251 
252       emit ManagerChanged(_contract);
253       return true;
254     }
255 
256     /**
257         @dev - called by the manager contract to add back to the user their roto in the event that their submission was successful
258         @param  _user address, the address of the user who submitted the rankings
259         @param _tournamentID identifier
260         @return boolean value, whether the roto were successfully released
261     */
262     function releaseRoto(address _user, bytes32 _tournamentID) external onlyManager returns(bool) {
263         require(_user!=address(0));
264         uint256 value = stakes[_user][_tournamentID];
265         require(value > 0);
266 
267         stakes[_user][_tournamentID] = 0;
268         balances[_user] = balances[_user].add(value);
269 
270         emit RotoReleased(_user, value);
271         return true;
272     }
273 
274     /**
275         @dev - function called by manager contract to process the accounting aspects of the destroyRoto function
276         @param  _user address, the address of the user who's stake will be destroyed
277         @param _tournamentID identifier
278         @return - a boolean value that reflects whether the roto were successfully destroyed
279     */
280     function destroyRoto(address _user, bytes32 _tournamentID) external onlyManager returns(bool) {
281         require(_user!=address(0));
282         uint256 value = stakes[_user][_tournamentID];
283         require(value > 0);
284 
285         stakes[_user][_tournamentID] = 0;
286         balances[roto] = balances[roto].add(value);
287 
288         emit RotoDestroyed(_user, value);
289         return true;
290     }
291 
292     /**
293         @dev - called by the manager contract, runs the accounting portions of the staking process
294         @param  _user address, the address of the user staking ROTO
295         @param _tournamentID identifier
296         @param _value ROTO, the amount the user is staking
297         @return - whether the staking process went successfully
298     */
299     function stakeRoto(address _user, bytes32 _tournamentID, uint256 _value) external onlyManager returns(bool) {
300         require(_user!=address(0));
301         require(_value<=balances[_user]);
302         require(stakes[_user][_tournamentID] == 0);
303 
304         balances[_user] = balances[_user].sub(_value);
305         stakes[_user][_tournamentID] = _value;
306 
307         emit RotoStaked(_user, _value);
308         return true;
309     }
310     
311     /**
312       @dev - called by the manager contract, used to reward non-staked submissions by users
313       @param _user address, the address that will receive the rewarded ROTO
314       @param _value ROTO, the amount of ROTO that they'll be rewarded
315      */
316     function rewardRoto(address _user, uint256 _value) external onlyManager returns(bool successful) {
317       require(_user!=address(0));
318       require(_value<=balances[roto]);
319 
320       balances[_user] = balances[_user].add(_value);
321       balances[roto] = balances[roto].sub(_value);
322 
323       emit RotoRewarded(roto, _user, _value);
324       return true;
325     }
326     /**
327         @dev - to be called by the manager contract to check if a given user has enough roto to
328             stake the given amount
329         @param  _user address, the address of the user who's attempting to stake ROTO
330         @param _value ROTO, the amount they are attempting to stake
331         @return - whether the user has enough balance to stake the received amount
332     */
333     function canStake(address _user, uint256 _value) public view onlyManager returns(bool) {
334       require(_user!=address(0));
335       require(_value<=balances[_user]);
336 
337       return true;
338     }
339 
340     /**
341       @dev Getter function for manager
342      */
343     function getManager() public view returns (address _manager) {
344       return manager;
345     }
346 
347     /**
348       @dev - sets the owner address to a new one
349       @param  _newOwner address
350       @return - true if the address was changed successful
351      */
352     function changeOwner(address _newOwner) public onlyOwner returns(bool) {
353       owner = _newOwner;
354     }
355 }