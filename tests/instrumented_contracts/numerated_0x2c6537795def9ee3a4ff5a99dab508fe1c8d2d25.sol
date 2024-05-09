1 pragma solidity ^0.4.18;
2 
3 contract OldContract{
4   function balanceOf(address _owner) view returns (uint balance) {}
5 }
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34   address public owner;
35 
36 
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39 
40   /**
41    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42    * account.
43    */
44   function Ownable() {
45     owner = msg.sender;
46   }
47 
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) onlyOwner public {
63     require(newOwner != address(0));
64     OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 
68 }
69 
70 contract ERC20Basic {
71   uint256 public totalSupply;
72   function balanceOf(address who) public constant returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81   mapping(address => bool) transfered;
82   OldContract _oldContract;
83   
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     
93     if(balances[msg.sender] == 0 && transfered[msg.sender] == false){
94     	 uint256 oldFromBalance;
95   		 
96   		 oldFromBalance = CheckOldBalance(msg.sender);
97   		 
98   		 if (oldFromBalance > 0)
99        {
100        	  ImportBalance(msg.sender); 
101        }
102     }
103     
104     if(balances[_to] == 0 && transfered[_to] == false){
105     	 uint256 oldBalance;
106   		 
107   		 oldBalance = CheckOldBalance(_to);
108   		 
109   		 if (oldBalance > 0)
110        {
111        	  ImportBalance(_to); 
112        }
113     }
114     
115     require(_value <= balances[msg.sender]);
116 
117     // SafeMath.sub will throw if there is not enough balance.
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     Transfer(msg.sender, _to, _value);
121     return true;
122   }
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public constant returns (uint256 balance) {
129   	if(balances[_owner] == 0 && transfered[_owner] == false){
130   		 uint256 oldBalance;
131   		 
132   		 oldBalance = CheckOldBalance(_owner);
133   		 
134        if (oldBalance > 0)
135        {
136        	  return oldBalance;
137        }
138        else
139        {
140        		return balances[_owner];
141        }
142     }
143     else
144     {
145       return balances[_owner];
146     }
147   }
148 
149   
150   function ImportBalance(address _owner) internal {
151   	uint256 oldBalance;
152   	
153   	oldBalance = CheckOldBalance(_owner);
154     if(balances[_owner] == 0  && (oldBalance > 0) && transfered[_owner] == false){
155     	balances[_owner] = oldBalance;
156       transfered[_owner] = true;
157     }
158   }
159   
160   function CheckOldBalance(address _owner) internal view returns (uint256 balance) {
161   	if(balances[_owner] == 0 && transfered[_owner]==false){
162   		
163   		uint256 oldBalance;
164   		
165   		_oldContract = OldContract(0x3719dAc5E8aeEb886A0B49f5cbafe2DfA73A16A3);
166   		
167   		oldBalance = _oldContract.balanceOf(_owner);
168   		
169   		if (oldBalance > 0)
170   		{
171         return oldBalance;
172       }
173       else
174       {
175       	return balances[_owner];
176       }
177     }
178     else
179     {
180     return balances[_owner];
181     }
182 
183   }
184 
185 
186 }
187 
188 contract ERC20 is ERC20Basic {
189   function allowance(address owner, address spender) public constant returns (uint256);
190   function transferFrom(address from, address to, uint256 value) public returns (bool);
191   function approve(address spender, uint256 value) public returns (bool);
192   event Approval(address indexed owner, address indexed spender, uint256 value);
193 }
194 
195 contract StandardToken is ERC20, BasicToken {
196 
197   mapping (address => mapping (address => uint256)) internal allowed;
198   
199 
200   /**
201    * @dev Transfer tokens from one address to another
202    * @param _from address The address which you want to send tokens from
203    * @param _to address The address which you want to transfer to
204    * @param _value uint256 the amount of tokens to be transferred
205    */
206   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208     
209     if(balances[_from] == 0 && transfered[_from] == false){
210        uint256 oldFromBalance;
211 
212        oldFromBalance = CheckOldBalance(_from);
213 
214   		 if (oldFromBalance > 0)
215        {
216        	  ImportBalance(_from); 
217        }
218     }
219     
220     if(balances[_to] == 0 && transfered[_to] == false){
221     	 uint256 oldBalance;
222   		 
223   		 oldBalance = CheckOldBalance(_to);
224   		 
225   		 if (oldBalance > 0)
226        {
227        	  ImportBalance(_to); 
228        }
229     }
230     
231     require(_value <= balances[_from]);
232     require(_value <= allowed[_from][msg.sender]);
233 
234     balances[_from] = balances[_from].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237     Transfer(_from, _to, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    *
244    * Beware that changing an allowance with this method brings the risk that someone may use both the old
245    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
246    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
247    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248    * @param _spender The address which will spend the funds.
249    * @param _value The amount of tokens to be spent.
250    */
251   function approve(address _spender, uint256 _value) public returns (bool) {
252     allowed[msg.sender][_spender] = _value;
253     Approval(msg.sender, _spender, _value);
254     return true;
255   }
256 
257   /**
258    * @dev Function to check the amount of tokens that an owner allowed to a spender.
259    * @param _owner address The address which owns the funds.
260    * @param _spender address The address which will spend the funds.
261    * @return A uint256 specifying the amount of tokens still available for the spender.
262    */
263   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
264     return allowed[_owner][_spender];
265   }
266 
267   /**
268    * approve should be called when allowed[_spender] == 0. To increment
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    */
273   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
274     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
275     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
280     uint oldValue = allowed[msg.sender][_spender];
281     if (_subtractedValue > oldValue) {
282       allowed[msg.sender][_spender] = 0;
283     } else {
284       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285     }
286     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290 }
291 
292 contract BurnableToken is StandardToken, Ownable{
293     
294     mapping(address => uint256) public exchangequeue;
295     
296     event PutForExchange(address indexed from, uint256 value);
297 
298     function putForExchange(uint256 _value) public {
299     
300     require(_value > 0);
301     address sender = msg.sender;
302       
303     if(balances[sender] == 0 && transfered[sender] == false){
304     	 uint256 oldFromBalance;
305   		 
306   		 oldFromBalance = CheckOldBalance(sender);
307   		 
308   		 if (oldFromBalance > 0)
309        {
310        	  ImportBalance(sender); 
311        }
312     }
313     
314 	   require(_value <= balances[sender]);
315 
316     // SafeMath.sub will throw if there is not enough balance.
317     balances[sender] = balances[sender].sub(_value);
318     exchangequeue[sender] = exchangequeue[sender].add(_value);
319     totalSupply = totalSupply.sub(_value);
320     PutForExchange(sender, _value);
321   }
322   
323     function confirmExchange(address _address,uint256 _value) public onlyOwner {
324     
325     require(_value > 0);
326     require(_value <= exchangequeue[_address]); 
327         
328    
329     exchangequeue[_address] = exchangequeue[_address].sub(_value);
330     
331   }
332   
333 
334 }
335 
336 contract GameCoin is Ownable, BurnableToken {
337 
338   string public constant name = "GameCoin";
339   string public constant symbol = "GMC";
340   uint8 public constant decimals = 2;
341 
342   uint256 public constant INITIAL_SUPPLY = 25907002099;
343   
344   /**
345    * @dev Constructor that gives msg.sender all of existing tokens.
346    */
347   function GameCoin() {
348     totalSupply = INITIAL_SUPPLY;
349     
350   }
351 
352 }