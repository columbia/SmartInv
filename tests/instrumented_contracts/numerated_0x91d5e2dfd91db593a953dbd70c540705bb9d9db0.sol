1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 contract Admin {
60   address public admin1;
61   address public admin2;
62 
63   event AdminshipTransferred(address indexed previousAdmin, address indexed newAdmin);
64 
65   function Admin() public {
66     admin1 = 0xD384CfA70Db590eab32f3C262B84C1E10f27EDa8;
67     admin2 = 0x263003A4CC5358aCebBad7E30C60167307dF1ccB;
68   }
69 
70   modifier onlyAdmin() {
71     require(msg.sender == admin1 || msg.sender == admin2);
72     _;
73   }
74 
75   function transferAdminship1(address newAdmin) public onlyAdmin {
76     require(newAdmin != address(0));
77     AdminshipTransferred(admin1, newAdmin);
78     admin1 = newAdmin;
79   }
80   function transferAdminship2(address newAdmin) public onlyAdmin {
81     require(newAdmin != address(0));
82     AdminshipTransferred(admin2, newAdmin);
83     admin2 = newAdmin;
84   }  
85 }
86 
87 contract FilterAddress is Admin{
88   mapping (address => uint) public AccessAddress;
89     
90   function SetAccess(address addr, uint access) onlyAdmin public{
91     AccessAddress[addr] = access;
92   }
93     
94   function GetAccess(address addr) public constant returns(uint){
95     return  AccessAddress[addr];
96   }
97     
98   modifier checkFilterAddress(){
99     require(AccessAddress[msg.sender] != 1);
100     _;
101   }
102 }
103 
104 contract Rewards is Admin{
105   using SafeMath for uint256;
106   uint public CoefRew;
107   uint public SummRew;
108   address public RewAddr;
109   
110   function SetCoefRew(uint newCoefRew) public onlyAdmin{
111     CoefRew = newCoefRew;
112   }
113   
114   function SetSummRew(uint newSummRew) public onlyAdmin{
115     SummRew = newSummRew;
116   }    
117   
118   function SetRewAddr(address newRewAddr) public onlyAdmin{
119     RewAddr = newRewAddr;
120   } 
121   
122   function GetSummReward(uint _value) public constant returns(uint){
123     return _value.mul(CoefRew).div(100).div(1000); 
124   }
125 }
126 
127 contract Fees is Admin{
128   using SafeMath for uint256;
129   uint public Fee;
130   address public FeeAddr1;
131   address public FeeAddr2;
132     
133   function SetFee(uint newFee) public onlyAdmin{
134     Fee = newFee;
135   }
136   function GetSummFee(uint _value) public constant returns(uint){
137     return _value.mul(Fee).div(100).div(1000).div(3);
138   } 
139 }
140 
141 /**
142  * @title Ownable
143  * @dev The Ownable contract has an owner address, and provides basic authorization control
144  * functions, this simplifies the implementation of "user permissions".
145  */
146 contract Ownable {
147   address public owner;
148   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
149 
150   /**
151    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
152    * account.
153    */
154   function Ownable() public {
155     owner = msg.sender;
156   }
157 
158   /**
159    * @dev Throws if called by any account other than the owner.
160    */
161   modifier onlyOwner() {
162     require(msg.sender == owner);
163     _;
164   }
165 
166   /**
167    * @dev Allows the current owner to transfer control of the contract to a newOwner.
168    * @param newOwner The address to transfer ownership to.
169    */
170   function transferOwnership(address newOwner) public onlyOwner {
171     require(newOwner != address(0));
172     OwnershipTransferred(owner, newOwner);
173     owner = newOwner;
174   }
175 }
176 
177 /**
178  * @title Basic token
179  * @dev Basic version of StandardToken, with no allowances.
180  */
181 contract BasicToken is ERC20Basic, FilterAddress, Fees, Rewards, Ownable {
182   using SafeMath for uint256;
183   mapping(address => uint256) balances;
184   mapping(address => uint256) allSummReward;
185   /**
186   * @dev transfer token for a specified address
187   * @param _to The address to transfer to.
188   * @param _value The amount to be transferred.
189   */
190   function transfer(address _to, uint256 _value) checkFilterAddress public returns (bool) {
191     uint256 _valueto;
192     uint fSummFee;
193     uint fSummReward;
194     require(_to != address(0));
195     require(_to != msg.sender);
196     require(_value <= balances[msg.sender]);
197     //fees
198     _valueto = _value;
199     if (msg.sender != owner){  
200       fSummFee = GetSummFee(_value);
201       fSummReward = GetSummReward(_value);
202         
203       balances[msg.sender] = balances[msg.sender].sub(fSummFee);
204       balances[FeeAddr1] = balances[FeeAddr1].add(fSummFee);
205       _valueto = _valueto.sub(fSummFee);  
206 
207       balances[msg.sender] = balances[msg.sender].sub(fSummFee);
208       balances[FeeAddr2] = balances[FeeAddr2].add(fSummFee);
209       _valueto = _valueto.sub(fSummFee); 
210     
211       balances[msg.sender] = balances[msg.sender].sub(fSummFee);
212       balances[RewAddr] = balances[RewAddr].add(fSummFee);
213       _valueto = _valueto.sub(fSummFee); 
214     //Rewards
215       allSummReward[msg.sender] = allSummReward[msg.sender].add(_value);    
216       if (allSummReward[msg.sender] >= SummRew && balances[RewAddr] >= fSummReward) {
217         balances[RewAddr] = balances[RewAddr].sub(fSummReward);
218         balances[msg.sender] = balances[msg.sender].add(fSummReward);
219         allSummReward[msg.sender] = 0;
220       }
221     }
222 
223     // SafeMath.sub will throw if there is not enough balance.
224     balances[msg.sender] = balances[msg.sender].sub(_valueto);
225     balances[_to] = balances[_to].add(_valueto);
226     Transfer(msg.sender, _to, _valueto);
227     return true;
228   }
229 
230   /**
231   * @dev Gets the balance of the specified address.
232   * @param _owner The address to query the the balance of.
233   * @return An uint256 representing the amount owned by the passed address.
234   */
235   function balanceOf(address _owner) public view returns (uint256 balance) {
236     return balances[_owner];
237   }
238 }
239 
240 /**
241  * @title Standard ERC20 token
242  *
243  * @dev Implementation of the basic standard token.
244  * @dev https://github.com/ethereum/EIPs/issues/20
245  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
246  */
247 contract StandardToken is ERC20, BasicToken {
248   mapping (address => mapping (address => uint256)) internal allowed;
249   /**
250    * @dev Transfer tokens from one address to another
251    * @param _from address The address which you want to send tokens from
252    * @param _to address The address which you want to transfer to
253    * @param _value uint256 the amount of tokens to be transferred
254    */
255   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
256     uint256 _valueto;  
257     require(_to != msg.sender);  
258     require(_to != address(0));
259     require(_value <= balances[_from]);
260     require(_value <= allowed[_from][msg.sender]);
261     uint fSummFee;
262     uint fSummReward;
263     _valueto = _value;
264     if (_from != owner){  
265       fSummFee = GetSummFee(_value);
266       fSummReward = GetSummReward(_value);
267         
268       balances[_from] = balances[_from].sub(fSummFee);
269       balances[FeeAddr1] = balances[FeeAddr1].add(fSummFee);
270       _valueto = _valueto.sub(fSummFee);  
271 
272       balances[_from] = balances[_from].sub(fSummFee);
273       balances[FeeAddr2] = balances[FeeAddr2].add(fSummFee);
274       _valueto = _valueto.sub(fSummFee); 
275     
276       balances[_from] = balances[_from].sub(fSummFee);
277       balances[RewAddr] = balances[RewAddr].add(fSummFee);
278       _valueto = _valueto.sub(fSummFee); 
279     //Rewards
280       allSummReward[_from] = allSummReward[_from].add(_value);
281       if (allSummReward[_from] >= SummRew && balances[RewAddr] >= fSummReward) {
282         balances[RewAddr] = balances[RewAddr].sub(fSummReward);
283         balances[_from] = balances[_from].add(fSummReward);
284         allSummReward[_from] = 0;
285       }
286     }
287     balances[_from] = balances[_from].sub(_valueto);
288     balances[_to] = balances[_to].add(_valueto);
289     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
290     Transfer(_from, _to, _valueto);
291     return true;
292   }
293   /**
294    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
295    *
296    * Beware that changing an allowance with this method brings the risk that someone may use both the old
297    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
298    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
299    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
300    * @param _spender The address which will spend the funds.
301    * @param _value The amount of tokens to be spent.
302    */
303   function approve(address _spender, uint256 _value) public returns (bool) {
304     allowed[msg.sender][_spender] = _value;
305     Approval(msg.sender, _spender, _value);
306     return true;
307   }
308   /**
309    * @dev Function to check the amount of tokens that an owner allowed to a spender.
310    * @param _owner address The address which owns the funds.
311    * @param _spender address The address which will spend the funds.
312    * @return A uint256 specifying the amount of tokens still available for the spender.
313    */
314   function allowance(address _owner, address _spender) public view returns (uint256) {
315     return allowed[_owner][_spender];
316   }
317   /**
318    * @dev Increase the amount of tokens that an owner allowed to a spender.
319    *
320    * approve should be called when allowed[_spender] == 0. To increment
321    * allowed value is better to use this function to avoid 2 calls (and wait until
322    * the first transaction is mined)
323    * From MonolithDAO Token.sol
324    * @param _spender The address which will spend the funds.
325    * @param _addedValue The amount of tokens to increase the allowance by.
326    */
327   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
328     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
329     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332   /**
333    * @dev Decrease the amount of tokens that an owner allowed to a spender.
334    *
335    * approve should be called when allowed[_spender] == 0. To decrement
336    * allowed value is better to use this function to avoid 2 calls (and wait until
337    * the first transaction is mined)
338    * From MonolithDAO Token.sol
339    * @param _spender The address which will spend the funds.
340    * @param _subtractedValue The amount of tokens to decrease the allowance by.
341    */
342   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
343     uint oldValue = allowed[msg.sender][_spender];
344     if (_subtractedValue > oldValue) {
345       allowed[msg.sender][_spender] = 0;
346     } else {
347       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
348     }
349     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353 }
354 
355 /**
356  * @title Burnable Token
357  * @dev Token that can be irreversibly burned (destroyed).
358  */
359 contract BurnableToken is StandardToken {
360     event Burn(address indexed burner, uint256 value);
361 
362     /**
363      * @dev Burns a specific amount of tokens.
364      * @param _value The amount of token to be burned.
365      */
366     function burn(uint256 _value) public {
367       require(_value <= balances[msg.sender]);
368       // no need to require value <= totalSupply, since that would imply the
369       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
370 
371       address burner = msg.sender;
372       balances[burner] = balances[burner].sub(_value);
373       totalSupply = totalSupply.sub(_value);
374       Burn(burner, _value);
375     }
376 }
377 
378 contract Guap is Ownable, BurnableToken {
379   using SafeMath for uint256;    
380   string public constant name = "Guap";
381   string public constant symbol = "Guap";
382   uint32 public constant decimals = 18;
383   uint256 public INITIAL_SUPPLY = 9999999999 * 1 ether;
384   function Guap() public {
385     totalSupply = INITIAL_SUPPLY;
386     balances[msg.sender] = INITIAL_SUPPLY;
387     //Rewards
388     RewAddr = 0xb94F2E7B4E37a8c03E9C2E451dec09Ce94Be2615;
389     CoefRew = 5; // decimals = 3;
390     SummRew = 90000 * 1 ether; 
391     //Fee
392     FeeAddr1 = 0xBe9517d10397D60eAD7da33Ea50A6431F5Be3790;
393     FeeAddr2 = 0xC90F698cc5803B21a04cE46eD1754655Bf2215E5;
394     Fee  = 15; // decimals = 3; 
395   }
396 }