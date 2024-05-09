1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4     address public owner;
5 
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10     /**
11      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12      * account.
13      */
14     function Ownable() public {
15         owner = msg.sender;
16     }
17 
18     /**
19      * @dev Throws if called by any account other than the owner.
20      */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     /**
27      * @dev Allows the current owner to transfer control of the contract to a newOwner.
28      * @param newOwner The address to transfer ownership to.
29      */
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(0));
32         OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 
36 }
37 
38 library SafeMath {
39 
40     /**
41     * @dev Multiplies two numbers, throws on overflow.
42     */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         assert(c / a == b);
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two numbers, truncating the quotient.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return c;
60     }
61 
62     /**
63     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         assert(b <= a);
67         return a - b;
68     }
69 
70     /**
71     * @dev Adds two numbers, throws on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 
80 contract ERC20Basic {
81     function totalSupply() public view returns (uint256);
82     function balanceOf(address who) public view returns (uint256);
83     function transfer(address to, uint256 value) public returns (bool);
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract ERC20 is ERC20Basic {
88     function allowance(address owner, address spender) public view returns (uint256);
89     function transferFrom(address from, address to, uint256 value) public returns (bool);
90     function approve(address spender, uint256 value) public returns (bool);
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 contract BasicToken is ERC20Basic {
95     using SafeMath for uint256;
96 
97     mapping(address => uint256) balances;
98 
99     uint256 totalSupply_;
100 
101     /**
102     * @dev total number of tokens in existence
103     */
104     function totalSupply() public view returns (uint256) {
105         return totalSupply_;
106     }
107 
108     /**
109     * @dev transfer token for a specified address
110     * @param _to The address to transfer to.
111     * @param _value The amount to be transferred.
112     */
113     function transfer(address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[msg.sender]);
116 
117         // SafeMath.sub will throw if there is not enough balance.
118         balances[msg.sender] = balances[msg.sender].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         Transfer(msg.sender, _to, _value);
121         return true;
122     }
123 
124     /**
125     * @dev Gets the balance of the specified address.
126     * @param _owner The address to query the the balance of.
127     * @return An uint256 representing the amount owned by the passed address.
128     */
129     function balanceOf(address _owner) public view returns (uint256 balance) {
130         return balances[_owner];
131     }
132 
133 }
134 
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
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147         require(_to != address(0));
148         require(_value <= balances[_from]);
149         require(_value <= allowed[_from][msg.sender]);
150 
151         balances[_from] = balances[_from].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         Transfer(_from, _to, _value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      *
161      * Beware that changing an allowance with this method brings the risk that someone may use both the old
162      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      * @param _spender The address which will spend the funds.
166      * @param _value The amount of tokens to be spent.
167      */
168     function approve(address _spender, uint256 _value) public returns (bool) {
169         allowed[msg.sender][_spender] = _value;
170         Approval(msg.sender, _spender, _value);
171         return true;
172     }
173 
174     /**
175      * @dev Function to check the amount of tokens that an owner allowed to a spender.
176      * @param _owner address The address which owns the funds.
177      * @param _spender address The address which will spend the funds.
178      * @return A uint256 specifying the amount of tokens still available for the spender.
179      */
180     function allowance(address _owner, address _spender) public view returns (uint256) {
181         return allowed[_owner][_spender];
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      *
187      * approve should be called when allowed[_spender] == 0. To increment
188      * allowed value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      * @param _spender The address which will spend the funds.
192      * @param _addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 
200     /**
201      * @dev Decrease the amount of tokens that an owner allowed to a spender.
202      *
203      * approve should be called when allowed[_spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * @param _spender The address which will spend the funds.
208      * @param _subtractedValue The amount of tokens to decrease the allowance by.
209      */
210     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211         uint oldValue = allowed[msg.sender][_spender];
212         if (_subtractedValue > oldValue) {
213             allowed[msg.sender][_spender] = 0;
214         } else {
215             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216         }
217         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         return true;
219     }
220 
221 }
222 
223 contract LibraToken is StandardToken {
224 
225     string public constant name = "LibraToken"; // solium-disable-line uppercase
226     string public constant symbol = "LBA"; // solium-disable-line uppercase
227     uint8 public constant decimals = 18; // solium-disable-line uppercase
228 
229     uint256 public constant INITIAL_SUPPLY = (10 ** 9) * (10 ** uint256(decimals));
230 
231     /**
232     * @dev Constructor that gives msg.sender all of existing tokens.
233     */
234     function LibraToken() public {
235         totalSupply_ = INITIAL_SUPPLY;
236         balances[msg.sender] = INITIAL_SUPPLY;
237         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
238     }
239 
240 }
241 
242 contract AirdropLibraToken is Ownable {
243     using SafeMath for uint256;
244 
245 
246     uint256 decimal = 10**uint256(18);
247 
248     //How many tokens has been distributed
249     uint256 distributedTotal = 0;
250 
251     uint256 airdropStartTime;
252     uint256 airdropEndTime;
253 
254     // The LBA token
255     LibraToken private token;
256 
257     // List of admins
258     mapping (address => bool) public airdropAdmins;
259 
260 
261 
262     //the map that has been airdropped, key -- address ,value -- amount
263     mapping(address => uint256) public airdropDoneAmountMap;
264     //the list that has been airdropped addresses
265     address[] public airdropDoneList;
266 
267 
268     //airdrop event
269     event Airdrop(address _receiver, uint256 amount);
270 
271     event AddAdmin(address _admin);
272 
273     event RemoveAdmin(address _admin);
274 
275     event UpdateEndTime(address _operator, uint256 _oldTime, uint256 _newTime);
276 
277 
278 
279     modifier onlyOwnerOrAdmin() {
280         require(msg.sender == owner || airdropAdmins[msg.sender]);
281         _;
282     }
283 
284 
285     function addAdmin(address _admin) public onlyOwner {
286         airdropAdmins[_admin] = true;
287         AddAdmin(_admin);
288     }
289 
290     function removeAdmin(address _admin) public onlyOwner {
291         if(isAdmin(_admin)){
292             airdropAdmins[_admin] = false;
293             RemoveAdmin(_admin);
294         }
295     }
296 
297 
298     modifier onlyWhileAirdropPhaseOpen {
299         require(block.timestamp > airdropStartTime && block.timestamp < airdropEndTime);
300         _;
301     }
302 
303 
304     function AirdropLibraToken(
305         ERC20 _token,
306         uint256 _airdropStartTime,
307         uint256 _airdropEndTime
308     ) public {
309         token = LibraToken(_token);
310         airdropStartTime = _airdropStartTime;
311         airdropEndTime = _airdropEndTime;
312 
313     }
314 
315 
316     function airdropTokens(address _recipient, uint256 amount) public onlyOwnerOrAdmin onlyWhileAirdropPhaseOpen {
317         require(amount > 0);
318 
319         uint256 lbaBalance = token.balanceOf(this);
320 
321         require(lbaBalance >= amount);
322 
323         require(token.transfer(_recipient, amount));
324 
325 
326         //put address into has done list
327         airdropDoneList.push(_recipient);
328 
329         //update airdropped actually
330         uint256 airDropAmountThisAddr = 0;
331         if(airdropDoneAmountMap[_recipient] > 0){
332             airDropAmountThisAddr = airdropDoneAmountMap[_recipient].add(amount);
333         }else{
334             airDropAmountThisAddr = amount;
335         }
336 
337         airdropDoneAmountMap[_recipient] = airDropAmountThisAddr;
338 
339         distributedTotal = distributedTotal.add(amount);
340 
341         Airdrop(_recipient, amount);
342 
343     }
344 
345     //batch airdrop, key-- the receiver's address, value -- receiver's amount
346     function airdropTokensBatch(address[] receivers, uint256[] amounts) public onlyOwnerOrAdmin onlyWhileAirdropPhaseOpen{
347         require(receivers.length > 0 && receivers.length == amounts.length);
348         for (uint256 i = 0; i < receivers.length; i++){
349             airdropTokens(receivers[i], amounts[i]);
350         }
351     }
352 
353     function transferOutBalance() public onlyOwner view returns (bool){
354         address creator = msg.sender;
355         uint256 _balanceOfThis = token.balanceOf(this);
356         if(_balanceOfThis > 0){
357             LibraToken(token).approve(this, _balanceOfThis);
358             LibraToken(token).transferFrom(this, creator, _balanceOfThis);
359             return true;
360         }else{
361             return false;
362         }
363     }
364 
365     //How many tokens are left without payment
366     function balanceOfThis() public view returns (uint256){
367         return token.balanceOf(this);
368     }
369 
370     //how many tokens have been distributed
371     function getDistributedTotal() public view returns (uint256){
372         return distributedTotal;
373     }
374 
375 
376     function isAdmin(address _addr) public view returns (bool){
377         return airdropAdmins[_addr];
378     }
379 
380     function updateAirdropEndTime(uint256 _newEndTime) public onlyOwnerOrAdmin {
381         UpdateEndTime(msg.sender, airdropEndTime, _newEndTime);
382         airdropEndTime = _newEndTime;
383     }
384 
385     //get all addresses that has been airdropped
386     function getDoneAddresses() public constant returns (address[]){
387         return airdropDoneList;
388     }
389 
390     //get the amount has been dropped by user's address
391     function getDoneAirdropAmount(address _addr) public view returns (uint256){
392         return airdropDoneAmountMap[_addr];
393     }
394 
395 }