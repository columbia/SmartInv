1 pragma solidity ^0.5.1;
2 
3 /*
4     email 
5     info@realt.to
6 
7     Facebbok 
8     https://www.facebook.com/Real-T-323544031677341/
9 
10     Twitter 
11     https://twitter.com/realtstable
12 **/
13 
14 
15 
16 library SafeMath {
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 /**
46  * @title Ownable
47  * @dev The Ownable contract has an owner address, and provides basic authorization control
48  * functions, this simplifies the implementation of "user permissions".
49  */
50 contract Ownable {
51     address public owner;
52 
53     /**
54       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55       * account.
56       */
57     constructor() public {
58         owner = msg.sender;
59     }
60 
61     /**
62       * @dev Throws if called by any account other than the owner.
63       */
64     modifier onlyOwner() {
65         require(msg.sender == owner, "Sender is not the owner.");
66         _;
67     }
68 
69     /**
70     * @dev Allows the current owner to transfer control of the contract to a newOwner.
71     * @param newOwner The address to transfer ownership to.
72     */
73     function transferOwnership(address newOwner) public onlyOwner {
74         if (newOwner != address(0)) {
75             owner = newOwner;
76         }
77     }
78 
79 }
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20Basic {
87     uint public _totalSupply;
88     function totalSupply() public view returns (uint);
89     function balanceOf(address who) public view returns (uint);
90     function transfer(address to, uint value) public;
91     event Transfer(address indexed from, address indexed to, uint value);
92 }
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 is ERC20Basic {
99     function allowance(address owner, address spender) public view returns (uint);
100     function transferFrom(address from, address to, uint value) public;
101     function approve(address spender, uint value) public;
102     event Approval(address indexed owner, address indexed spender, uint value);
103 }
104 
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  */
110 contract BasicToken is Ownable, ERC20Basic {
111     using SafeMath for uint;
112 
113     mapping(address => uint) public balances;
114 
115     /**
116     * @dev Fix for the ERC20 short address attack.
117     */
118     modifier onlyPayloadSize(uint size) {
119         require(!(msg.data.length < size + 4), "Payload size is incorrect.");
120         _;
121     }
122 
123     /**
124     * @dev transfer token for a specified address
125     * @param _to The address to transfer to.
126     * @param _value The amount to be transferred.
127     */
128     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
129         require(_to != address(0), "_to address is invalid.");
130 
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         emit Transfer(msg.sender, _to, _value);
134     }
135 
136     /**
137     * @dev Gets the balance of the specified address.
138     * @param _owner The address to query the the balance of.
139     * @return An uint representing the amount owned by the passed address.
140     */
141     function balanceOf(address _owner) public view returns (uint balance) {
142         return balances[_owner];
143     }
144 
145 }
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * @dev https://github.com/ethereum/EIPs/issues/20
152  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract StandardToken is BasicToken, ERC20 {
155 
156     mapping (address => mapping (address => uint)) public allowed;
157 
158     uint public constant MAX_UINT = 2**256 - 1;
159 
160     /**
161     * @dev Transfer tokens from one address to another
162     * @param _from address The address which you want to send tokens from
163     * @param _to address The address which you want to transfer to
164     * @param _value uint the amount of tokens to be transferred
165     */
166     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
167         require(_from != address(0), "_from address is invalid.");
168         require(_to != address(0), "_to address is invalid.");
169 
170         uint _allowance = allowed[_from][msg.sender];
171 
172         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
173         // if (_value > _allowance) throw;
174 
175         if (_allowance < MAX_UINT) {
176             allowed[_from][msg.sender] = _allowance.sub(_value);
177         }
178         balances[_from] = balances[_from].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180 
181         emit Transfer(_from, _to, _value);
182     }
183 
184     /**
185     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186     * @param _spender The address which will spend the funds.
187     * @param _value The amount of tokens to be spent.
188     */
189     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
190 
191         // To change the approve amount you first have to reduce the addresses`
192         //  allowance to zero by calling `approve(_spender, 0)` if it is not
193         //  already 0 to mitigate the race condition described here:
194         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)), "Invalid function arguments.");
196 
197         allowed[msg.sender][_spender] = _value;
198         emit Approval(msg.sender, _spender, _value);
199     }
200 
201     /**
202     * @dev Function to check the amount of tokens than an owner allowed to a spender.
203     * @param _owner address The address which owns the funds.
204     * @param _spender address The address which will spend the funds.
205     * @return A uint specifying the amount of tokens still available for the spender.
206     */
207     function allowance(address _owner, address _spender) public view returns (uint remaining) {
208         return allowed[_owner][_spender];
209     }
210 
211 }
212 
213 
214 
215 /**
216  * @title Pausable
217  * @dev Base contract which allows children to implement an emergency stop mechanism.
218  */
219 contract Pausable is Ownable {
220     event Pause();
221     event Unpause();
222 
223     bool public paused = false;
224 
225 
226     /**
227     * @dev Modifier to make a function callable only when the contract is not paused.
228     */
229     modifier whenNotPaused() {
230         require(!paused, "Token is paused.");
231         _;
232     }
233 
234     /**
235     * @dev Modifier to make a function callable only when the contract is paused.
236     */
237     modifier whenPaused() {
238         require(paused, "Token is unpaused.");
239         _;
240     }
241 
242     /**
243     * @dev called by the owner to pause, triggers stopped state
244     */
245     function pause() public onlyOwner whenNotPaused {
246         paused = true;
247         emit Pause();
248     }
249 
250     /**
251     * @dev called by the owner to unpause, returns to normal state
252     */
253     function unpause() public onlyOwner whenPaused {
254         paused = false;
255         emit Unpause();
256     }
257 }
258 
259 contract REALT is Pausable, StandardToken {
260 
261     string public name;
262     string public symbol;
263     uint public decimals;
264 
265     mapping(address => bool) public authorized;
266     mapping(address => bool) public blacklisted;
267 
268     //  The contract can be initialized with a number of tokens
269     //  All the tokens are deposited to the owner address
270     //
271     // @param _balance Initial supply of the contract
272     // @param _name Token Name
273     // @param _symbol Token symbol
274     // @param _decimals Token decimals
275     constructor() public {
276         name = "REAL-T";
277         symbol = "REALT";
278         decimals = 4;
279         setAuthorization(0xd17Ecd9F35cBfd9f673Cb4E6aC6Ce5fcCD084dd9);
280         transferOwnership(0xd17Ecd9F35cBfd9f673Cb4E6aC6Ce5fcCD084dd9);
281     }
282 
283     modifier onlyAuthorized() {
284         require(authorized[msg.sender], "msg.sender is not authorized");
285         _;
286     }
287 
288     event AuthorizationSet(address _address);
289     function setAuthorization(address _address) public onlyOwner {
290         require(_address != address(0), "Provided address is invalid.");
291         require(!authorized[_address], "Address is already authorized.");
292         
293         authorized[_address] = true;
294 
295         emit AuthorizationSet(_address);
296     }
297 
298     event AuthorizationRevoked(address _address);
299     function revokeAuthorization(address _address) public onlyOwner {
300         require(_address != address(0), "Provided address is invalid.");
301         require(authorized[_address], "Address is already unauthorized.");
302 
303         authorized[_address] = false;
304 
305         emit AuthorizationRevoked(_address);
306     }
307 
308     modifier NotBlacklisted(address _address) {
309         require(!blacklisted[_address], "The provided address is blacklisted.");
310         _;
311     }
312     
313     event BlacklistAdded(address _address);
314     function addBlacklist(address _address) public onlyAuthorized {
315         require(_address != address(0), "Provided address is invalid.");
316         require(!blacklisted[_address], "The provided address is already blacklisted");
317         blacklisted[_address] = true;
318         
319         emit BlacklistAdded(_address);
320     }
321 
322     event BlacklistRemoved(address _address);
323     function removeBlacklist(address _address) public onlyAuthorized {
324         require(_address != address(0), "Provided address is invalid.");
325         require(blacklisted[_address], "The provided address is already not blacklisted");
326         blacklisted[_address] = false;
327         
328         emit BlacklistRemoved(_address);
329     }
330     
331     function transfer(address _to, uint _value) public NotBlacklisted(_to) NotBlacklisted(msg.sender) whenNotPaused {
332         return super.transfer(_to, _value);
333     }
334 
335     function transferFrom(address _from, address _to, uint _value) public NotBlacklisted(_to) NotBlacklisted(_from) NotBlacklisted(msg.sender) whenNotPaused {
336         return super.transferFrom(_from, _to, _value);
337     }
338 
339     function balanceOf(address who) public view returns (uint) {
340         return super.balanceOf(who);
341     }
342 
343     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
344         return super.approve(_spender, _value);
345     }
346 
347     function allowance(address _owner, address _spender) public view returns (uint remaining) {
348         return super.allowance(_owner, _spender);
349     }
350 
351 
352     function totalSupply() public view returns (uint) {
353         return _totalSupply;
354     }
355 
356     // Issue a new amount of tokens
357     // these tokens are deposited into the owner address
358     //
359     // @param _amount Number of tokens to be issued
360     function issue(uint amount) public onlyAuthorized {
361         _totalSupply = _totalSupply.add(amount);
362         balances[msg.sender] = balances[msg.sender].add(amount);
363         
364         emit Issue(amount);
365     }
366 
367     // Redeem tokens.
368     // These tokens are withdrawn from the owner address
369     // if the balance must be enough to cover the redeem
370     // or the call will fail.
371     // @param _amount Number of tokens to be issued
372     function redeem(uint amount) public onlyAuthorized {
373         require(_totalSupply >= amount, "Redeem amount is greater than total supply.");
374         require(balances[msg.sender] >= amount, "Redeem amount is greater than sender's balance.");
375 
376         _totalSupply = _totalSupply.sub(amount);
377         balances[msg.sender] = balances[msg.sender].sub(amount);
378         emit Redeem(amount);
379     }
380 
381     // Called when new token are issued
382     event Issue(uint amount);
383 
384     // Called when tokens are redeemed
385     event Redeem(uint amount);
386 
387 }