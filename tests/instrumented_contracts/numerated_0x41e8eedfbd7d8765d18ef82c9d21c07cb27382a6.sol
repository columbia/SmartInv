1 pragma solidity ^0.4.18;
2 
3 /** ----------------------------------------------------------------------------------------------
4  * ENGINE_Token by GSC Limited.
5  * An ERC20 standard
6  *
7  * author: GSC Team
8  */
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error.
13  */
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 
44 /**
45  * @title Ownable
46  * @dev The Ownable contract has an owner address, and provides basic authorization control
47  * functions, this simplifies the implementation of "user permissions".
48  */
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 {
91   uint256 public totalSupply;
92   function balanceOf(address who) public view returns (uint256);
93   function transfer(address to, uint256 value) public returns (bool);
94   function allowance(address owner, address spender) public view returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 contract GSCToken is ERC20, Ownable {
102   using SafeMath for uint256;
103 
104   
105   // the controller of minting and destroying tokens
106   address public engDevAddress = 0x20d3596A9C0986995225770F95CCb4fB30411E33;
107   // the controller of approving of minting and withdraw tokens
108   address public engCommunityAddress = 0x20d3596A9C0986995225770F95CCb4fB30411E33;
109 
110   struct TokensWithLock {
111     uint256 value;
112     uint256 blockNumber;
113   }
114   // Balances for each account
115   mapping(address => uint256) balances;
116 
117   mapping(address => TokensWithLock) lockTokens;
118   
119   // Owner of account approves the transfer of an amount to another account
120   mapping(address => mapping (address => uint256)) allowed;
121   // Token Cap
122   uint256 public totalSupplyCap = 1e28;
123   // Token Info
124   string public name = "GSC_Token";
125   string public symbol = "GSC";
126   uint8 public decimals = 18;
127 
128   // True if transfers are allowed
129   bool public transferable = false;
130   // True if the transferable can be change
131   bool public canSetTransferable = true;
132 
133 
134   modifier only(address _address) {
135     require(msg.sender == _address);
136     _;
137   }
138 
139   modifier nonZeroAddress(address _address) {
140     require(_address != address(0));
141     _;
142   }
143 
144   modifier canTransfer() {
145     require(transferable == true);
146     _;
147   }
148 
149   /**
150    * @dev Fix for the ERC20 short address attack.
151    */
152   modifier onlyPayloadSize(uint size) {
153     if(msg.data.length < size + 4) {
154        revert();
155     }
156     _;
157   }
158 
159 
160 
161   event BurnTokens(address indexed _owner, uint256 _amount);
162   event SetTransferable(address indexed _address, bool _transferable);
163   event SetENGDevAddress(address indexed _old, address indexed _new);
164   event SetENGCommunityAddress(address indexed _old, address indexed _new);
165   event DisableSetTransferable(address indexed _address, bool _canSetTransferable);
166 
167  /**
168    * @dev transfer token for a specified address
169    * @param _to The address to transfer to.
170    * @param _value The amount to be transferred.
171    */
172   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
173     require(_to != address(0));
174     require(_value <= balances[msg.sender]);
175     require(_value >= 0);
176     require(balances[_to] + _value > balances[_to]);
177 
178     // SafeMath.sub will throw if there is not enough balance.
179     balances[msg.sender] = balances[msg.sender].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     Transfer(msg.sender, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Gets the balance of the specified address.
187    * @param _owner The address to query the the balance of.
188    * @return An uint256 representing the amount owned by the passed address.
189    */
190   function balanceOf(address _owner) public view returns (uint256 balance) {
191     return balances[_owner];
192   }
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param _from address The address which you want to send tokens from
197    * @param _to address The address which you want to transfer to
198    * @param _value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[_from]);
203     require(_value <= allowed[_from][msg.sender]);
204     require(_value > 0);
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    *
216    * Beware that changing an allowance with this method brings the risk that someone may use both the old
217    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220    * @param _spender The address which will spend the funds.
221    * @param _value The amount of tokens to be spent.
222    */
223   function approve(address _spender, uint256 _value) canTransfer public returns (bool) {
224     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
225     allowed[msg.sender][_spender] = _value;
226     Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public view returns (uint256) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    */
246   function increaseApproval(address _spender, uint256 _addedValue) canTransfer public returns (bool) {
247     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
248     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   function decreaseApproval(address _spender, uint256 _subtractedValue) canTransfer public returns (bool) {
253     uint256 oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Enables token holders to transfer their tokens freely if true
265    * @param _transferable True if transfers are allowed
266    */
267   function setTransferable(bool _transferable) only(engDevAddress) public {
268     require(canSetTransferable == true);
269     transferable = _transferable;
270     SetTransferable(msg.sender, _transferable);
271   }
272 
273   /**
274    * @dev disable the canSetTransferable
275    */
276   function disableSetTransferable() only(engDevAddress) public {
277     transferable = true;
278     canSetTransferable = false;
279     DisableSetTransferable(msg.sender, false);
280   }
281 
282   /**
283    * @dev Set the engAddress
284    * @param _engDevAddress The new engAddress
285    */
286   function setENGDevAddress(address _engDevAddress) only(engDevAddress) nonZeroAddress(_engDevAddress) public {
287     engDevAddress = _engDevAddress;
288     SetENGDevAddress(msg.sender, _engDevAddress);
289   }
290   /**
291    * @dev Set the engCommunityAddress
292    * @param _engCommunityAddress The new engCommunityAddress
293    */
294   function setENGCommunityAddress(address _engCommunityAddress) only(engCommunityAddress) nonZeroAddress(_engCommunityAddress) public {
295     engCommunityAddress = _engCommunityAddress;
296     SetENGCommunityAddress(msg.sender, _engCommunityAddress);
297   }
298 
299   /**
300    * @dev Get the quantity of locked tokens
301    * @param _owner The address of locked tokens
302    * @return the quantity and the lock time of locked tokens
303    */
304    function getLockTokens(address _owner) nonZeroAddress(_owner) view public returns (uint256 value, uint256 blockNumber) {
305      return (lockTokens[_owner].value, lockTokens[_owner].blockNumber);
306    }
307 
308   /**
309    * @dev Transfer tokens to multiple addresses
310    * @param _addresses The addresses that will receieve tokens
311    * @param _amounts The quantity of tokens that will be transferred
312    * @return True if the tokens are transferred correctly
313    */
314   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts) canTransfer public returns (bool) {
315     for (uint256 i = 0; i < _addresses.length; i++) {
316       require(_addresses[i] != address(0));
317       require(_amounts[i] <= balances[msg.sender]);
318       require(_amounts[i] > 0);
319 
320       // SafeMath.sub will throw if there is not enough balance.
321       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
322       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
323       Transfer(msg.sender, _addresses[i], _amounts[i]);
324     }
325     return true;
326   }
327 
328   /**
329    * @dev Burns `_amount` tokens from `_owner`
330    * @param _amount The quantity of tokens being burned
331    * @return True if the tokens are burned correctly
332    */
333   function burnTokens(uint256 _amount) public returns (bool) {
334     require(_amount > 0);
335     uint256 curTotalSupply = totalSupply;
336     require(curTotalSupply >= _amount);
337     uint256 previousBalanceTo = balanceOf(msg.sender);
338     require(previousBalanceTo >= _amount);
339     totalSupply = curTotalSupply.sub(_amount);
340     balances[msg.sender] = previousBalanceTo.sub(_amount);
341     BurnTokens(msg.sender, _amount);
342     Transfer(msg.sender, 0, _amount);
343     return true;
344   }
345 }