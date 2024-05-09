1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract Ownable {
35     address public owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     /**
40      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41      * account.
42      */
43     function Ownable() public {
44         owner = msg.sender;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         require(newOwner != address(0));
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63     }
64 
65 }
66 
67 
68 contract PoolRole is Ownable {
69     mapping (address => bool) internal poolRoleBearer;
70 
71     event PoolRoleGranted(address indexed addr);
72     event PoolRoleRevoked(address indexed addr);
73 
74     /**
75     * @dev give an address access to this role
76     */
77     function grantPoolRole(address addr) public onlyOwner {
78         poolRoleBearer[addr] = true;
79         emit PoolRoleGranted(addr);
80     }
81 
82     /**
83     * @dev remove an address access to this role
84     */
85     function revokePoolRole(address addr) public onlyOwner {
86         poolRoleBearer[addr] = false;
87         emit PoolRoleRevoked(addr);
88     }
89 
90     /**
91     * @dev check if an address has this role
92     * @return bool
93     */
94     function hasPoolRole(address addr) view public returns (bool)
95     {
96         return poolRoleBearer[addr];
97     }
98 
99 }
100 
101 
102 contract HasNoEther is Ownable, PoolRole {
103 
104     /**
105     * @dev Constructor that rejects incoming Ether
106     * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
107     * leave out payable, then Solidity will allow inheriting contracts to implement a payable
108     * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
109     * we could use assembly to access msg.value.
110     */
111     function HasNoEther() public payable {
112         require(msg.value == 0);
113     }
114 
115     /**
116      * @dev Disallows direct send by settings a default function without the `payable` flag.
117      */
118     function() external {
119     }
120 
121     /**
122      * @dev Transfer all Ether held by the contract to the owner.
123      */
124     function reclaimEther() external onlyOwner {
125         assert(owner.send(address(this).balance));
126     }
127 }
128 
129 
130 contract ERC20Basic {
131     uint256 public totalSupply;
132     function balanceOf(address who) public view returns (uint256);
133     function transfer(address to, uint256 value) public returns (bool);
134     event Transfer(address indexed from, address indexed to, uint256 value);
135 }
136 
137 
138 contract BasicToken is ERC20Basic {
139     using SafeMath for uint256;
140 
141     mapping(address => uint256) balances;
142 
143     /**
144     * @dev transfer token for a specified address
145     * @param _to The address to transfer to.
146     * @param _value The amount to be transferred.
147     */
148     function transfer(address _to, uint256 _value) public returns (bool) {
149         require(_to != address(0));
150         require(_value <= balances[msg.sender]);
151 
152         // SafeMath.sub will throw if there is not enough balance.
153         balances[msg.sender] = balances[msg.sender].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         emit Transfer(msg.sender, _to, _value);
156         return true;
157     }
158 
159     /**
160     * @dev Gets the balance of the specified address.
161     * @param _owner The address to query the the balance of.
162     * @return An uint256 representing the amount owned by the passed address.
163     */
164     function balanceOf(address _owner) public view returns (uint256 balance) {
165         return balances[_owner];
166     }
167 
168 }
169 
170 
171 contract ERC20 is ERC20Basic {
172     function allowance(address owner, address spender) public view returns (uint256);
173     function transferFrom(address from, address to, uint256 value) public returns (bool);
174     function approve(address spender, uint256 value) public returns (bool);
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 
179 contract StandardToken is ERC20, BasicToken {
180 
181     mapping (address => mapping (address => uint256)) internal allowed;
182 
183 
184     /**
185      * @dev Transfer tokens from one address to another
186      * @param _from address The address which you want to send tokens from
187      * @param _to address The address which you want to transfer to
188      * @param _value uint256 the amount of tokens to be transferred
189      */
190     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
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
203     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204     *
205     * Beware that changing an allowance with this method brings the risk that someone may use both the old
206     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209 
210     * To change the approve amount you first have to reduce the addresses`
211     * allowance to zero by calling `approve(_spender,0)` if it is not
212     * already 0 to mitigate the race condition described here:
213     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214 
215     * @param _spender The address which will spend the funds.
216     * @param _value The amount of tokens to be spent.
217     */
218     function approve(address _spender, uint256 _value) public returns (bool) {
219         //  To change the approve amount you first have to reduce the addresses`
220         //  allowance to zero by calling `approve(_spender,0)` if it is not
221         //  already 0 to mitigate the race condition described here:
222         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
224 
225         allowed[msg.sender][_spender] = _value;
226         emit Approval(msg.sender, _spender, _value);
227         return true;
228     }
229 
230     /**
231      * @dev Function to check the amount of tokens that an owner allowed to a spender.
232      * @param _owner address The address which owns the funds.
233      * @param _spender address The address which will spend the funds.
234      * @return A uint256 specifying the amount of tokens still available for the spender.
235      */
236     function allowance(address _owner, address _spender) public view returns (uint256) {
237         return allowed[_owner][_spender];
238     }
239 
240     /**
241      * approve should be called when allowed[_spender] == 0. To increment
242      * allowed value is better to use this function to avoid 2 calls (and wait until
243      * the first transaction is mined)
244      * From MonolithDAO Token.sol
245      */
246     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
247         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
248         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249         return true;
250     }
251 
252     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253         uint oldValue = allowed[msg.sender][_spender];
254         if (_subtractedValue > oldValue) {
255             allowed[msg.sender][_spender] = 0;
256         } else {
257             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258         }
259         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260         return true;
261     }
262 
263 }
264 
265 
266 contract BurnableToken is StandardToken, Ownable {
267 
268     event Burn(address indexed burner, uint256 value);
269 
270     /**
271      * @dev Burns a specific amount of tokens.
272      * @param _value The amount of token to be burned.
273      */
274     function burn(uint256 _value) onlyOwner public {
275         require(_value > 0);
276         require(_value <= balances[msg.sender]);
277         // no need to require value <= totalSupply, since that would imply the
278         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
279 
280         balances[msg.sender] = balances[msg.sender].sub(_value);
281         totalSupply = totalSupply.sub(_value);
282         emit Burn(msg.sender, _value);
283     }
284 }
285 
286 
287 contract MintableToken is StandardToken, Ownable {
288 
289     event Mint(address indexed to, uint256 amount);
290     event MintFinished();
291 
292     bool public mintingFinished = false;
293 
294     modifier canMint() {
295         require(!mintingFinished);
296         _;
297     }
298 
299     /**
300      * @dev Mint a specific amount of tokens to owner.
301      * @param _amount The amount of token to be minted.
302      */
303     function mint(uint256 _amount) onlyOwner canMint public {
304         totalSupply = totalSupply.add(_amount);
305         balances[msg.sender] = balances[msg.sender].add(_amount);
306         emit Mint(msg.sender, _amount);
307         emit Transfer(address(0), msg.sender, _amount);
308     }
309 
310     /**
311      * @dev Disable minting forever
312      */
313     function finishMinting() onlyOwner canMint public {
314         mintingFinished = true;
315         emit MintFinished();
316     }
317 }
318 
319 
320 /**
321  * @title EngagementToken
322  * @dev ERC20 EGT Token
323  *
324  * EGT are displayed using 18 decimal places of precision.
325  *
326  * 1 Billion EGT Token total supply:
327  */
328 contract EngagementToken is BurnableToken, MintableToken, HasNoEther {
329 
330     string public constant name = "EngagementToken";
331 
332     string public constant symbol = "EGT";
333 
334     uint8 public constant decimals = 18;
335 
336     uint256 public constant INITIAL_SUPPLY = 1e9 * (10 ** uint256(decimals));
337 
338     // 06/14/2018 @ 11:59pm (UTC)
339     uint256 public constant FREEZE_END = 1529020799;
340 
341     /**
342     * @dev Constructor that gives msg.sender all of existing tokens.
343     */
344     function EngagementToken() public {
345         totalSupply = INITIAL_SUPPLY;
346         balances[msg.sender] = INITIAL_SUPPLY;
347         emit Transfer(address(0), msg.sender, totalSupply);
348     }
349 
350     /**
351     * @dev transfer token for a specified address
352     * @param _to The address to transfer to.
353     * @param _value The amount to be transferred.
354     */
355     function transfer(address _to, uint256 _value) public returns (bool) {
356         require(now >= FREEZE_END || msg.sender == owner || hasPoolRole(_to) || hasPoolRole(msg.sender));
357         return super.transfer(_to, _value);
358     }
359 
360     /**
361     * @dev Transfer tokens from one address to another
362     * @param _from address The address which you want to send tokens from
363     * @param _to address The address which you want to transfer to
364     * @param _value uint256 the amount of tokens to be transferred
365     */
366     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
367         require(now >= FREEZE_END || msg.sender == owner || hasPoolRole(_to) || hasPoolRole(msg.sender));
368         return super.transferFrom(_from, _to, _value);
369     }
370 
371     function multiTransfer(address[] recipients, uint256[] amounts) public {
372         require(recipients.length == amounts.length);
373         for (uint i = 0; i < recipients.length; i++) {
374             transfer(recipients[i], amounts[i]);
375         }
376     }
377 }