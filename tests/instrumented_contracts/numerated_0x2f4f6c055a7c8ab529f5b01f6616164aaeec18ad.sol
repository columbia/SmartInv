1 pragma solidity ^0.4.18;
2 
3 /** ----------------------------------------------------------------------------------------------
4  * ENGINE_Token by ENGINE Limited.
5  * An ERC20 standard
6  *
7  * author: ENGINE Team
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
101 contract EEEToken is ERC20, Ownable {
102 
103   using SafeMath for uint256;
104 
105   
106   // the controller of minting and destroying tokens
107   address public engDevAddress = 0x6d3E0B5abFc141cAa674a3c11e1580e6fff2a0B9;
108   // the controller of approving of minting and withdraw tokens
109   address public engCommunityAddress = 0x4885B422656D4B316C9C7Abc0c0Ab31A2677d9f0;
110 
111   struct TokensWithLock {
112     uint256 value;
113     uint256 blockNumber;
114   }
115   // Balances for each account
116   mapping(address => uint256) balances;
117 
118   mapping(address => TokensWithLock) lockTokens;
119   
120   mapping (address => mapping (address => uint256)) public allowance;
121   
122   // Owner of account approves the transfer of an amount to another account
123   mapping(address => mapping (address => uint256)) allowed;
124   // Token Cap
125   uint256 public totalSupplyCap = 1e28;
126   // Token Info
127   string public name = "EEE_Token";
128   string public symbol = "EEE";
129   uint8 public decimals = 18;
130 
131   // True if transfers are allowed
132   bool public transferable = false;
133   // True if the transferable can be change
134   bool public canSetTransferable = true;
135 
136 
137   modifier only(address _address) {
138     require(msg.sender == _address);
139     _;
140   }
141 
142   modifier nonZeroAddress(address _address) {
143     require(_address != address(0));
144     _;
145   }
146 
147   modifier canTransfer() {
148     require(transferable == true);
149     _;
150   }
151 
152   /**
153    * @dev Fix for the ERC20 short address attack.
154    */
155   modifier onlyPayloadSize(uint size) {
156     if(msg.data.length < size + 4) {
157        revert();
158     }
159     _;
160   }
161 
162 
163 
164   event Burn(address indexed from, uint256 value);
165   event SetTransferable(address indexed _address, bool _transferable);
166   event SetENGDevAddress(address indexed _old, address indexed _new);
167   event SetENGCommunityAddress(address indexed _old, address indexed _new);
168   event DisableSetTransferable(address indexed _address, bool _canSetTransferable);
169 
170  /**
171    * @dev transfer token for a specified address
172    * @param _to The address to transfer to.
173    * @param _value The amount to be transferred.
174    */
175   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[msg.sender]);
178     require(_value >= 0);
179     require(balances[_to] + _value > balances[_to]);
180 
181     // SafeMath.sub will throw if there is not enough balance.
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Gets the balance of the specified address.
190    * @param _owner The address to query the the balance of.
191    * @return An uint256 representing the amount owned by the passed address.
192    */
193   function balanceOf(address _owner) public view returns (uint256 balance) {
194     return balances[_owner];
195   }
196 
197   /**
198    * @dev Transfer tokens from one address to another
199    * @param _from address The address which you want to send tokens from
200    * @param _to address The address which you want to transfer to
201    * @param _value uint256 the amount of tokens to be transferred
202    */
203   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
204     require(_to != address(0));
205     require(_value <= balances[_from]);
206     require(_value > 0);
207 
208     balances[_from] = balances[_from].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211     Transfer(_from, _to, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    *
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    * @param _spender The address which will spend the funds.
223    * @param _value The amount of tokens to be spent.
224    */
225   function approve(address _spender, uint256 _value) canTransfer public returns (bool) {
226     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
227     allowed[msg.sender][_spender] = _value;
228     Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public view returns (uint256) {
239     return allowed[_owner][_spender];
240   }
241 
242   /**
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    */
248   function increaseApproval(address _spender, uint256 _addedValue) canTransfer public returns (bool) {
249     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254   function decreaseApproval(address _spender, uint256 _subtractedValue) canTransfer public returns (bool) {
255     uint256 oldValue = allowed[msg.sender][_spender];
256     if (_subtractedValue > oldValue) {
257       allowed[msg.sender][_spender] = 0;
258     } else {
259       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
260     }
261     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 
265   /**
266    * @dev Enables token holders to transfer their tokens freely if true
267    * @param _transferable True if transfers are allowed
268    */
269   function setTransferable(bool _transferable) only(engDevAddress) public {
270     require(canSetTransferable == true);
271     transferable = _transferable;
272     SetTransferable(msg.sender, _transferable);
273   }
274 
275   /**
276    * @dev disable the canSetTransferable
277    */
278   function disableSetTransferable() only(engDevAddress) public {
279     transferable = true;
280     canSetTransferable = false;
281     DisableSetTransferable(msg.sender, false);
282   }
283 
284   /**
285    * @dev Set the engAddress
286    * @param _engDevAddress The new engAddress
287    */
288   function setENGDevAddress(address _engDevAddress) only(engDevAddress) nonZeroAddress(_engDevAddress) public {
289     engDevAddress = _engDevAddress;
290     SetENGDevAddress(msg.sender, _engDevAddress);
291   }
292   /**
293    * @dev Set the engCommunityAddress
294    * @param _engCommunityAddress The new engCommunityAddress
295    */
296   function setENGCommunityAddress(address _engCommunityAddress) only(engCommunityAddress) nonZeroAddress(_engCommunityAddress) public {
297     engCommunityAddress = _engCommunityAddress;
298     SetENGCommunityAddress(msg.sender, _engCommunityAddress);
299   }
300 
301   /**
302    * @dev Get the quantity of locked tokens
303    * @param _owner The address of locked tokens
304    * @return the quantity and the lock time of locked tokens
305    */
306    function getLockTokens(address _owner) nonZeroAddress(_owner) view public returns (uint256 value, uint256 blockNumber) {
307      return (lockTokens[_owner].value, lockTokens[_owner].blockNumber);
308    }
309 
310   /**
311    * @dev Transfer tokens to multiple addresses
312    * @param _addresses The addresses that will receieve tokens
313    * @param _amounts The quantity of tokens that will be transferred
314    * @return True if the tokens are transferred correctly
315    */
316   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts) canTransfer public returns (bool) {
317     for (uint256 i = 0; i < _addresses.length; i++) {
318       require(_addresses[i] != address(0));
319       require(_amounts[i] <= balances[msg.sender]);
320       require(_amounts[i] > 0);
321 
322       // SafeMath.sub will throw if there is not enough balance.
323       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
324       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
325       Transfer(msg.sender, _addresses[i], _amounts[i]);
326     }
327     return true;
328   }
329 
330   /**
331      * Destroy tokens
332      *
333      * Remove `_value` tokens from the system irreversibly
334      *
335      * @param _value the amount of money to burn
336      */
337     function burn(uint256 _value) public returns (bool success) {
338         require(balances[msg.sender] >= _value);   // Check if the sender has enough
339         balances[msg.sender] -= _value;            // Subtract from the sender
340         totalSupply -= _value;                      // Updates totalSupply
341         Burn(msg.sender, _value);
342         return true;
343     }
344 
345     /**
346      * Destroy tokens from other account
347      *
348      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
349      *
350      * @param _from the address of the sender
351      * @param _value the amount of money to burn
352      */
353     function burnFrom(address _from, uint256 _value) public returns (bool success) {
354         require(balances[_from] >= _value);                // Check if the targeted balance is enough
355         require(_value <= allowance[_from][msg.sender]);    // Check allowance
356         balances[_from] -= _value;                         // Subtract from the targeted balance
357         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
358         totalSupply -= _value;                              // Update totalSupply
359         Burn(_from, _value);
360         return true;
361     }
362 }