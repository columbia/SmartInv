1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 /**
31  * @title Ownable
32  */
33 contract Ownable {
34     address public owner;
35 
36     /**
37       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38       * account.
39       */
40     function Ownable() public {
41         owner = msg.sender;
42     }
43 
44     /**
45       * @dev Throws if called by any account other than the owner.
46       */
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52    
53     function transferOwnership(address newOwner) public onlyOwner {
54         if (newOwner != address(0)) {
55             owner = newOwner;
56         }
57     }
58 
59 }
60 
61 /**
62  * @title ERC20Basic
63  */
64 contract ERC20Basic {
65     uint public _totalSupply;
66     function totalSupply() public constant returns (uint);
67     function balanceOf(address who) public constant returns (uint);
68     function transfer(address to, uint value) public returns (bool);
69     event Transfer(address indexed from, address indexed to, uint value);
70 }
71 
72 /**
73  * @title ERC20 interface
74  */
75 contract ERC20 is ERC20Basic {
76     function allowance(address owner, address spender) public constant returns (uint);
77     function transferFrom(address from, address to, uint value) public returns (bool);
78     function approve(address spender, uint value) public;
79     event Approval(address indexed owner, address indexed spender, uint value);
80 }
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances.
85  */
86 contract BasicToken is Ownable, ERC20Basic {
87     using SafeMath for uint;
88     mapping(address => uint) public balances;
89 
90     /**
91     * @dev Fix for the ERC20 short address attack.
92     */
93     modifier onlyPayloadSize(uint size) {
94         require(!(msg.data.length < size + 4));
95         _;
96     }
97 
98     /**
99     * @dev transfer token for a specified address
100     * @param _to The address to transfer to.
101     * @param _value The amount to be transferred.
102     */
103     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32)  returns (bool) {
104         require(balances[msg.sender] >= _value);
105         
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         emit Transfer(msg.sender, _to, _value);
109         
110         return true;
111     }
112     
113     function batchTransfer(address[] _receivers, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
114       uint cnt = _receivers.length;
115       uint256 amount = _value.mul(uint256(cnt));
116       require(cnt > 0 && cnt <= 100);
117       require(_value > 0 && balances[msg.sender] >= amount);
118   
119       balances[msg.sender] = balances[msg.sender].sub(amount);
120       
121       for (uint i = 0; i < cnt; i++) {
122           balances[_receivers[i]] = balances[_receivers[i]].add(_value);
123           emit Transfer(msg.sender, _receivers[i], _value);
124       }
125       return true;
126     }
127 
128 
129 
130     /**
131     * @dev Gets the balance of the specified address.
132     */
133     function balanceOf(address _owner) public constant returns (uint balance) {
134         return balances[_owner];
135     }
136 
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  * @dev Implementation of the basic standard token.
142  */
143 contract StandardToken is BasicToken, ERC20 {
144 
145     mapping (address => mapping (address => uint)) public allowed;
146 
147     uint public constant MAX_UINT = 2**256 - 1;
148 
149     /**
150     * @dev Transfer tokens from one address to another
151     * @param _from address The address which you want to send tokens from
152     * @param _to address The address which you want to transfer to
153     * @param _value uint the amount of tokens to be transferred
154     */
155     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) returns (bool){
156         var _allowance = allowed[_from][msg.sender];
157         
158         require(_allowance >= _value);
159         require(balances[_from] >= _value);
160 
161         if (_allowance < MAX_UINT) {
162             allowed[_from][msg.sender] = _allowance.sub(_value);
163         }
164         balances[_from] = balances[_from].sub(_value);
165         balances[_to] = balances[_to].add(_value);
166         emit Transfer(_from, _to, _value);
167         
168         return true;
169     }
170 
171     /**
172     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173     * @param _spender The address which will spend the funds.
174     * @param _value The amount of tokens to be spent.
175     */
176     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
177 
178         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
179 
180         allowed[msg.sender][_spender] = _value;
181         emit Approval(msg.sender, _spender, _value);
182     }
183 
184     /**
185     * @dev Function to check the amount of tokens than an owner allowed to a spender.
186     * @param _owner address The address which owns the funds.
187     * @param _spender address The address which will spend the funds.
188     * @return A uint specifying the amount of tokens still available for the spender.
189     */
190     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
191         return allowed[_owner][_spender];
192     }
193 
194 }
195 
196 
197 /**
198  * @title Pausable
199  * @dev Base contract which allows children to implement an emergency stop mechanism.
200  */
201 contract Pausable is Ownable {
202   event Pause();
203   event Unpause();
204 
205   bool public paused = false;
206 
207 
208   /**
209    * @dev Modifier to make a function callable only when the contract is not paused.
210    */
211   modifier whenNotPaused() {
212     require(!paused);
213     _;
214   }
215 
216   /**
217    * @dev Modifier to make a function callable only when the contract is paused.
218    */
219   modifier whenPaused() {
220     require(paused);
221     _;
222   }
223 
224   /**
225    * @dev called by the owner to pause, triggers stopped state
226    */
227   function pause() onlyOwner whenNotPaused public {
228     paused = true;
229     emit Pause();
230   }
231 
232   /**
233    * @dev called by the owner to unpause, returns to normal state
234    */
235   function unpause() onlyOwner whenPaused public {
236     paused = false;
237     emit Unpause();
238   }
239 }
240 
241 contract BlackList is Ownable, BasicToken {
242 
243     function getBlackListStatus(address _maker) external constant returns (bool) {
244         return isBlackListed[_maker];
245     }
246 
247     function getOwner() external constant returns (address) {
248         return owner;
249     }
250 
251     mapping (address => bool) public isBlackListed;
252     
253     function addBlackList (address _evilUser) public onlyOwner {
254         isBlackListed[_evilUser] = true;
255         emit AddedBlackList(_evilUser);
256     }
257 
258     function removeBlackList (address _clearedUser) public onlyOwner {
259         isBlackListed[_clearedUser] = false;
260         emit RemovedBlackList(_clearedUser);
261     }
262 
263     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
264         require(isBlackListed[_blackListedUser]);
265         uint dirtyFunds = balanceOf(_blackListedUser);
266         balances[_blackListedUser] = 0;
267         _totalSupply -= dirtyFunds;
268         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
269     }
270 
271     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
272 
273     event AddedBlackList(address _user);
274 
275     event RemovedBlackList(address _user);
276 
277 }
278 
279 
280 contract SPAYToken is Pausable, StandardToken, BlackList {
281 
282     string public name;
283     string public symbol;
284     uint public decimals;
285 
286     // @param _balance Initial supply of the contract
287     // @param _name Token Name
288     // @param _symbol Token symbol
289     // @param _decimals Token decimals
290     function SPAYToken(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
291         _totalSupply = _initialSupply;
292         name = _name;
293         symbol = _symbol;
294         decimals = _decimals;
295         balances[owner] = _initialSupply;
296     }
297 
298     function transfer(address _to, uint _value) public whenNotPaused  returns (bool) {
299         require(!isBlackListed[msg.sender]);
300         return super.transfer(_to, _value);
301     }
302     
303     function batchTransfer (address[] _receivers,uint256 _value ) public whenNotPaused onlyOwner returns (bool)  {
304       return super.batchTransfer(_receivers, _value);
305     }
306 
307     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
308         require(!isBlackListed[_from]);
309         return super.transferFrom(_from, _to, _value);
310     }
311 
312     function balanceOf(address who) public constant returns (uint) {
313         return super.balanceOf(who);
314     }
315 
316     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
317        return super.approve(_spender, _value);
318     }
319 
320     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
321         return super.allowance(_owner, _spender);
322     }
323 
324     function totalSupply() public constant returns (uint) {
325         return _totalSupply;
326     }
327 
328     // Issue a new amount of tokens
329     // these tokens are deposited into the owner address
330     // @param _amount Number of tokens to be issued
331     function issue(uint amount) public onlyOwner {
332         require(_totalSupply + amount > _totalSupply);
333         require(balances[owner] + amount > balances[owner]);
334 
335         balances[owner] += amount;
336         _totalSupply += amount;
337         emit Issue(amount);
338     }
339 
340     // Redeem tokens.
341     // These tokens are withdrawn from the owner address
342     // @param _amount Number of tokens to be issued
343     function redeem(uint amount) public onlyOwner {
344         require(_totalSupply >= amount);
345         require(balances[owner] >= amount);
346 
347         _totalSupply -= amount;
348         balances[owner] -= amount;
349         emit Redeem(amount);
350     }
351 
352 
353     event Issue(uint amount);
354 
355     event Redeem(uint amount);
356 
357 }