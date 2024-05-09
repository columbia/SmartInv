1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic {
83   uint256 public totalSupply;
84   function balanceOf(address who) public constant returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public constant returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118 
119     // SafeMath.sub will throw if there is not enough balance.
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public constant returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157 
158     uint256 _allowance = allowed[_from][msg.sender];
159 
160     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
161     // require (_value <= _allowance);
162 
163     balances[_from] = balances[_from].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     allowed[_from][msg.sender] = _allowance.sub(_value);
166     Transfer(_from, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    *
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param _spender The address which will spend the funds.
178    * @param _value The amount of tokens to be spent.
179    */
180   function approve(address _spender, uint256 _value) public returns (bool) {
181     allowed[msg.sender][_spender] = _value;
182     Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint256 specifying the amount of tokens still available for the spender.
191    */
192   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
193     return allowed[_owner][_spender];
194   }
195 
196   /**
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    */
202   function increaseApproval (address _spender, uint _addedValue)
203     returns (bool success) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   function decreaseApproval (address _spender, uint _subtractedValue)
210     returns (bool success) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 /**
224  * @title The TranchorToken contract
225  * @dev The TranchorToken Token contract
226  * @dev inherite from StandardToken and Ownable by Zeppelin
227  */
228 contract TranchorToken is StandardToken, Ownable {
229     string  public  constant name = "Tranchor Token";
230     string  public  constant symbol = "HKTT";
231     uint8    public  constant decimals = 18;
232 
233     uint    public  transferableStartTime;
234     address public  fullTokenWallet;
235 
236     modifier onlyWhenTransferEnabled()
237     {
238         if ( now < transferableStartTime ) {
239             require(msg.sender == fullTokenWallet || msg.sender == owner);
240         }
241         _;
242     }
243 
244     modifier validDestination(address to) 
245     {
246         require(to != address(this));
247         _;
248     }
249 
250     function TranchorToken(
251         uint tokenTotalAmount, 
252         uint _transferableStartTime, 
253         address _admin, 
254         address _fullTokenWallet) 
255     {
256         
257         // Mint all tokens. Then disable minting forever.
258         totalSupply = tokenTotalAmount * (10 ** uint256(decimals));
259 
260         balances[msg.sender] = totalSupply;
261         Transfer(address(0x0), msg.sender, totalSupply);
262 
263         transferableStartTime = _transferableStartTime;
264         fullTokenWallet = _fullTokenWallet;
265 
266         transferOwnership(_admin); // admin could drain tokens and eth that were sent here by mistake
267 
268     }
269 
270     /**
271      * @dev override transfer token for a specified address to add onlyWhenTransferEnabled and validDestination
272      * @param _to The address to transfer to.
273      * @param _value The amount to be transferred.
274      */
275     function transfer(address _to, uint _value)
276         public
277         validDestination(_to)
278         onlyWhenTransferEnabled
279         returns (bool) 
280     {
281         return super.transfer(_to, _value);
282     }
283 
284     /**
285      * @dev override transferFrom token for a specified address to add onlyWhenTransferEnabled and validDestination
286      * @param _from The address to transfer from.
287      * @param _to The address to transfer to.
288      * @param _value The amount to be transferred.
289      */
290     function transferFrom(address _from, address _to, uint _value)
291         public
292         validDestination(_to)
293         onlyWhenTransferEnabled
294         returns (bool) 
295     {
296         return super.transferFrom(_from, _to, _value);
297     }
298 
299     event Burn(address indexed _burner, uint _value);
300 
301     /**
302      * @dev burn tokens
303      * @param _value The amount to be burned.
304      * @return always true (necessary in case of override)
305      */
306     function burn(uint _value) 
307         public
308         onlyWhenTransferEnabled
309         onlyOwner
310         returns (bool)
311     {
312         balances[msg.sender] = balances[msg.sender].sub(_value);
313         totalSupply = totalSupply.sub(_value);
314         Burn(msg.sender, _value);
315         Transfer(msg.sender, address(0x0), _value);
316         return true;
317     }
318 
319     /**
320      * @dev burn tokens in the behalf of someone
321      * @param _from The address of the owner of the token.
322      * @param _value The amount to be burned.
323      * @return always true (necessary in case of override)
324      */
325     function burnFrom(address _from, uint256 _value) 
326         public
327         onlyWhenTransferEnabled
328         onlyOwner
329         returns(bool) 
330     {
331         assert(transferFrom(_from, msg.sender, _value));
332         return burn(_value);
333     }
334 
335     /**
336      * @dev transfer to owner any tokens send by mistake on this contracts
337      * @param token The address of the token to transfer.
338      * @param amount The amount to be transfered.
339      */
340     function emergencyERC20Drain(ERC20 token, uint amount )
341         public
342         onlyOwner 
343     {
344         token.transfer(owner, amount);
345     }
346 
347 }