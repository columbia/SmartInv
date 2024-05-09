1 //////////////////////////////////////////////////////////////////////////////////////////
2 //																						//
3 //	Title: 						Clipper Coin Creation Contract							//
4 //	Author: 					Marko Valentin Micic									//
5 //	Version: 					v0.1													//
6 //	Date of current version:	2017/09/01												//
7 //	Brief Description:			The smart contract that will create tokens. The tokens	//
8 //								will be apportioned according to the results of the 	//
9 //								ICO conducted on ico.info earlier. Results of the ICO	// 
10 //								can be viewed at https://ico.info/projects/19 and are 	//
11 //								summarized below:										//
12 //								BTC raised: 386.808										//
13 //								ETH raised: 24451.896									//
14 //								EOS raised: 1468860										//
15 //								In accordance with Clipper Coin Venture's plan (also	//
16 //								viewable on the same website), the appropriate 			//
17 //								proportion of coins will be delivered to ICOInfo, a 	//
18 //								certain proportion will be deleted, and the rest held 	//
19 //								in reserve for uses that will be determined by later	//
20 //								smart contracts. 										//
21 //																						//
22 //////////////////////////////////////////////////////////////////////////////////////////
23 pragma solidity ^0.4.11;
24 
25 contract ERC20Protocol {
26 /* This is a slight change to the ERC20 base standard.
27     function totalSupply() constant returns (uint supply);
28     is replaced with:
29     uint public totalSupply;
30     This automatically creates a getter function for the totalSupply.
31     This is moved to the base contract since public getter functions are not
32     currently recognised as an implementation of the matching abstract
33     function by the compiler.
34     */
35     /// total amount of tokens
36     uint public totalSupply;
37 
38     /// @param _owner The address from which the balance will be retrieved
39     /// @return The balance
40     function balanceOf(address _owner) constant returns (uint balance);
41 
42     /// @notice send `_value` token to `_to` from `msg.sender`
43     /// @param _to The address of the recipient
44     /// @param _value The amount of token to be transferred
45     /// @return Whether the transfer was successful or not
46     function transfer(address _to, uint _value) returns (bool success);
47 
48     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
49     /// @param _from The address of the sender
50     /// @param _to The address of the recipient
51     /// @param _value The amount of token to be transferred
52     /// @return Whether the transfer was successful or not
53     function transferFrom(address _from, address _to, uint _value) returns (bool success);
54 
55     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
56     /// @param _spender The address of the account able to transfer the tokens
57     /// @param _value The amount of tokens to be approved for transfer
58     /// @return Whether the approval was successful or not
59     function approve(address _spender, uint _value) returns (bool success);
60 
61     /// @param _owner The address of the account owning tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @return Amount of remaining tokens allowed to spent
64     function allowance(address _owner, address _spender) constant returns (uint remaining);
65 
66     event Transfer(address indexed _from, address indexed _to, uint _value);
67     event Approval(address indexed _owner, address indexed _spender, uint _value);
68 }
69 
70 /**
71  * Math operations with safety checks
72  */
73 library SafeMath {
74   function mul(uint a, uint b) internal returns (uint) {
75     uint c = a * b;
76     assert(a == 0 || c / a == b);
77     return c;
78   }
79 
80   function div(uint a, uint b) internal returns (uint) {
81     assert(b > 0);
82     uint c = a / b;
83     assert(a == b * c + a % b);
84     return c;
85   }
86 
87   function sub(uint a, uint b) internal returns (uint) {
88     assert(b <= a);
89     return a - b;
90   }
91 
92   function add(uint a, uint b) internal returns (uint) {
93     uint c = a + b;
94     assert(c >= a);
95     return c;
96   }
97 
98   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
99     return a >= b ? a : b;
100   }
101 
102   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
103     return a < b ? a : b;
104   }
105 
106   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
107     return a >= b ? a : b;
108   }
109 
110   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
111     return a < b ? a : b;
112   }
113 }
114 
115 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
116 ///  later changed
117 contract Owned {
118 
119     /// @dev `owner` is the only address that can call a function with this
120     /// modifier
121     modifier onlyOwner() {
122         require(msg.sender == owner);
123         _;
124     }
125 
126     address public owner;
127 
128     /// @notice The Constructor assigns the message sender to be `owner`
129     function Owned() {
130         owner = msg.sender;
131     }
132 
133     address public newOwner;
134 
135     /// @notice `owner` can step down and assign some other address to this role
136     /// @param _newOwner The address of the new owner. 0x0 can be used to create
137     ///  an unowned neutral vault, however that cannot be undone
138     function changeOwner(address _newOwner) onlyOwner {
139         newOwner = _newOwner;
140     }
141 
142 
143     function acceptOwnership() {
144         if (msg.sender == newOwner) {
145             owner = newOwner;
146         }
147     }
148 }
149 
150 contract StandardToken is ERC20Protocol {
151     using SafeMath for uint;
152 
153     /**
154     * @dev Fix for the ERC20 short address attack.
155     */
156     modifier onlyPayloadSize(uint size) {
157         require(msg.data.length >= size + 4);
158         _;
159     }
160 
161     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
162         //Default assumes totalSupply can't be over max (2^256 - 1).
163         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
164         //Replace the if with this one instead.
165         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
166         if (balances[msg.sender] >= _value) {
167             balances[msg.sender] -= _value;
168             balances[_to] += _value;
169             Transfer(msg.sender, _to, _value);
170             return true;
171         } else { return false; }
172     }
173 
174     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {
175         //same as above. Replace this line with the following if you want to protect against wrapping uints.
176         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
177         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
178             balances[_to] += _value;
179             balances[_from] -= _value;
180             allowed[_from][msg.sender] -= _value;
181             Transfer(_from, _to, _value);
182             return true;
183         } else { return false; }
184     }
185 
186     function balanceOf(address _owner) constant returns (uint balance) {
187         return balances[_owner];
188     }
189 
190     function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
191         // To change the approve amount you first have to reduce the addresses`
192         //  allowance to zero by calling `approve(_spender, 0)` if it is not
193         //  already 0 to mitigate the race condition described here:
194         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195         assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
196 
197         allowed[msg.sender][_spender] = _value;
198         Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     function allowance(address _owner, address _spender) constant returns (uint remaining) {
203       return allowed[_owner][_spender];
204     }
205 
206     mapping (address => uint) balances;
207     mapping (address => mapping (address => uint)) allowed;
208 }
209 
210 contract tokenRecipient { 
211 	function receiveApproval(
212 		address _from, 
213 		uint256 _value, 
214 		address _token, 
215 		bytes _extraData); 
216 }
217 
218 contract ClipperCoin is Owned{
219     using SafeMath for uint;
220 
221     /// Constant token specific fields
222     string public name = "Clipper Coin";
223     string public symbol = "CCCT";
224     uint public decimals = 18;
225 
226     /// Total supply of Clipper Coin
227     uint public totalSupply = 200000000 ether;
228     
229     /// Create an array with all balances
230     mapping (address => uint256) public balanceOf;
231     mapping (address => mapping (address => uint256)) public allowance;
232     
233     /// Generate public event on the blockchain that will notify clients of transfers
234     event Transfer(address indexed from, address indexed to, uint256 value);
235     
236     /// Generate public event on the blockchain that notifies clients how much CCC has 
237     /// been destroyed
238     event Burn(address indexed from, uint256 value);
239     
240     /// Initialize contract with initial supply of tokens sent to the creator of the 
241     /// contract, who is defined as the minter of the coin
242     function ClipperCoin(
243     	uint256 initialSupply,
244     	string tokenName,
245     	uint8 tokenDecimals,
246     	string tokenSymbol
247     	) {
248     	    
249     	//Give creator all initial tokens
250     	balanceOf[msg.sender]  = initialSupply;
251     	
252     	// Set the total supply of all Clipper Coins
253     	totalSupply  = initialSupply;
254     	
255     	// Set the name of Clipper Coins
256     	name = tokenName;
257     	
258     	// Set the symbol of Clipper Coins: CCC
259     	symbol = tokenSymbol;
260     	
261     	// Set the amount of decimal places present in Clipper Coin: 18
262     	// Note: 18 is the ethereum standard
263     	decimals = tokenDecimals;
264     }
265     
266     
267     /// Internal transfers, which can only be called by this contract.
268     function _transfer(
269     	address _from,
270     	address _to,
271     	uint _value)
272     	internal {
273     	    
274     	// Prevent transfers to the 0x0 address. Use burn() instead to 
275     	// permanently remove Clipper Coins from the Blockchain
276     	require (_to != 0x0);
277     	
278     	// Check that the account has enough Clipper Coins to be transferred
279         require (balanceOf[_from] > _value);                
280         
281         // Check that the subraction of coins is not occuring
282         require (balanceOf[_to] + _value > balanceOf[_to]); 
283         balanceOf[_from] -= _value;                         
284         balanceOf[_to] += _value;                           
285         Transfer(_from, _to, _value);
286     }
287     
288     /// @notice Send `_value` tokens to `_to` from your account
289     /// @param _to The address of the recipient
290     /// @param _value the amount to send
291     function transfer(
292     	address _to, 
293     	uint256 _value) {
294         _transfer(msg.sender, _to, _value);
295     }
296 
297     /// @notice Send `_value` tokens to `_to` on behalf of `_from`
298     /// @param _from The address of the sender
299     /// @param _to The address of the recipient
300     /// @param _value the amount to send
301     function transferFrom(
302     	address _from, 
303     	address _to, 
304     	uint256 _value) returns (bool success) {
305         require (_value < allowance[_from][msg.sender]);     
306         allowance[_from][msg.sender] -= _value;
307         _transfer(_from, _to, _value);
308         return true;
309     }
310 
311     /// @notice Allows `_spender` to spend no more than `_value` tokens on your behalf
312     /// @param _spender The address authorized to spend
313     /// @param _value the max amount they can spend
314     function approve(
315     	address _spender, 
316     	uint256 _value) returns (bool success) {
317         allowance[msg.sender][_spender] = _value;
318         return true;
319     }
320 
321     /// @notice Allows `_spender` to spend no more than `_value` tokens on your behalf, 
322     ///			and then ping the contract about it
323     /// @param _spender The address authorized to spend
324     /// @param _value the max amount they can spend
325     /// @param _extraData some extra information to send to the approved contract
326     function approveAndCall(
327     	address _spender, 
328     	uint256 _value, 
329     	bytes _extraData) returns (bool success) {
330         tokenRecipient spender = tokenRecipient(_spender);
331         if (approve(_spender, _value)) {
332             spender.receiveApproval(msg.sender, _value, this, _extraData);
333             return true;
334         }
335     }        
336 
337     /// @notice Remove `_value` tokens from the system irreversibly
338     /// @param _value the amount of money to burn
339     function burn(uint256 _value) returns (bool success) {
340         require (balanceOf[msg.sender] > _value);            
341         balanceOf[msg.sender] -= _value;                      
342         totalSupply -= _value;                                
343         Burn(msg.sender, _value);
344         return true;
345     }
346 
347     function burnFrom(
348     	address _from, 
349     	uint256 _value) returns (bool success) {
350         require(balanceOf[_from] >= _value);                
351         require(_value <= allowance[_from][msg.sender]);    
352         balanceOf[_from] -= _value;                         
353         allowance[_from][msg.sender] -= _value;             
354         totalSupply -= _value;                              
355         Burn(_from, _value);
356         return true;
357     }
358 }