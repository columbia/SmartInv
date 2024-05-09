1 pragma solidity >=0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/179
48  */
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) public view returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72 
73   /**
74   * @dev Multiplies two numbers, throws on overflow.
75   */
76   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77     if (a == 0) {
78       return 0;
79     }
80     uint256 c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return c;
93   }
94 
95   /**
96   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 a, uint256 b) internal pure returns (uint256) {
107     uint256 c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances.
117  */
118 contract BasicToken is ERC20Basic {
119   using SafeMath for uint256;
120 
121   mapping(address => uint256) balances;
122 
123   uint256 totalSupply_;
124 
125   /**
126   * @dev total number of tokens in existence
127   */
128   function totalSupply() public view returns (uint256) {
129     return totalSupply_;
130   }
131 
132   /**
133   * @dev transfer token for a specified address
134   * @param _to The address to transfer to.
135   * @param _value The amount to be transferred.
136   */
137   function transfer(address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[msg.sender]);
140 
141     // SafeMath.sub will throw if there is not enough balance.
142     balances[msg.sender] = balances[msg.sender].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public view returns (uint256 balance) {
154     return balances[_owner];
155   }
156 
157 }
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract StandardToken is ERC20, BasicToken {
167 
168   mapping (address => mapping (address => uint256)) internal allowed;
169 
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185     Transfer(_from, _to, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191    *
192    * Beware that changing an allowance with this method brings the risk that someone may use both the old
193    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196    * @param _spender The address which will spend the funds.
197    * @param _value The amount of tokens to be spent.
198    */
199   function approve(address _spender, uint256 _value) public returns (bool) {
200     allowed[msg.sender][_spender] = _value;
201     Approval(msg.sender, _spender, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Function to check the amount of tokens that an owner allowed to a spender.
207    * @param _owner address The address which owns the funds.
208    * @param _spender address The address which will spend the funds.
209    * @return A uint256 specifying the amount of tokens still available for the spender.
210    */
211   function allowance(address _owner, address _spender) public view returns (uint256) {
212     return allowed[_owner][_spender];
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    *
218    * approve should be called when allowed[_spender] == 0. To increment
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _addedValue The amount of tokens to increase the allowance by.
224    */
225   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
242     uint oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue > oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 
254 contract LociBackend is Ownable {    
255 
256     StandardToken token; // LOCIcoin deployed contract
257 
258     mapping (address => bool) internal allowedOverrideAddresses;
259 
260     modifier onlyOwnerOrOverride() {
261         // owner or any addresses listed in the overrides
262         // can perform token transfers while inactive
263         require(msg.sender == owner || allowedOverrideAddresses[msg.sender]);
264         _;
265     }
266     
267     mapping (bytes32 => Claim) public claims;
268     // {
269     //     "ClaimID": "9b2eea39-4c08-4c2a-a243-f5d8158bacb0",
270     //     "claimCreateDate": "20170925204742",
271     //     "disclosureDate": "20170925204742",
272     //     "userID": "cb8ea133-def4-4062-8cac-9d7ef46221bf"
273     //     "disclosureHash": "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
274     // }
275     // l.addNewClaim("9b2eea39-4c08-4c2a-a243-f5d8158bacb0", 20170925204742, 20170925204742, "cb8ea133-def4-4062-8cac-9d7ef46221bf", "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad");
276     bytes32[] public claimKeys;    
277 
278     struct Claim {
279         string claimID;
280         uint256 claimCreateDate;
281         uint256 disclosureDate;
282         uint256 timestamp;
283         string userId;
284         string disclosureHash;
285     }
286 
287     event ClaimAdded(bytes32 indexed key, string claimID);
288 
289     function LociBackend() public {
290         owner = msg.sender;
291         token = StandardToken(0x9c23D67AEA7B95D80942e3836BCDF7E708A747C2); // LOCIcoin address
292     }
293 
294     function getClaimKeys() view public returns(bytes32[]) {
295         return claimKeys;
296     }
297     
298     function getClaimKeysCount() view public returns(uint256) {
299         return claimKeys.length;
300     }
301 
302     function claimExist(string _claimID) public constant returns (bool) {
303 
304         return claims[keccak256(_claimID)].timestamp != 0x0;
305     }
306 
307     function addNewClaim(string _claimID, uint256 _claimCreateDate, uint256 _disclosureDate, 
308                         string _userId, string _disclosureHash) onlyOwnerOrOverride external {
309                 
310         bytes32 key = keccak256(_claimID);
311         require( claims[key].timestamp == 0x0 );
312 
313         claims[key] = Claim({claimID: _claimID, claimCreateDate: _claimCreateDate, 
314             disclosureDate: _disclosureDate, timestamp: now, userId: _userId, disclosureHash: _disclosureHash});
315 
316         ClaimAdded(key, _claimID);
317 
318         claimKeys.push(key);
319     }
320 
321     function getClaim(string _claimID) public view returns (string, uint256, uint256, uint256, string, string) {
322         bytes32 key = keccak256(_claimID);
323         require( claims[key].timestamp != 0x0 );
324         Claim memory claim = claims[key];
325         return ( claim.claimID, claim.claimCreateDate, claim.disclosureDate, claim.timestamp, claim.userId, claim.disclosureHash );
326     }
327 
328     function ownerSetOverride(address _address, bool enable) external onlyOwner {
329         allowedOverrideAddresses[_address] = enable;
330     }
331 
332     function isAllowedOverrideAddress(address _addr) external constant returns (bool) {
333         return allowedOverrideAddresses[_addr];
334     }
335 
336     // enable recovery of ether sent to this contract
337     function ownerTransferWei(address _beneficiary, uint256 _value) external onlyOwner {
338         require(_beneficiary != 0x0);
339         require(_beneficiary != address(token));        
340 
341         // if zero requested, send the entire amount, otherwise the amount requested
342         uint256 _amount = _value > 0 ? _value : this.balance;
343 
344         _beneficiary.transfer(_amount);
345     }
346 
347     // enable recovery of LOCIcoin sent to this contract
348     function ownerRecoverTokens(address _beneficiary) external onlyOwner {
349         require(_beneficiary != 0x0);            
350         require(_beneficiary != address(token));        
351 
352         uint256 _tokensRemaining = token.balanceOf(address(this));
353         if (_tokensRemaining > 0) {
354             token.transfer(_beneficiary, _tokensRemaining);
355         }
356     }
357 }