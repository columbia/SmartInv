1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 contract SafeMath {
9     uint256 constant public MAX_UINT256 =
10     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14 
15     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
16         if (x > MAX_UINT256 - y) revert();
17         return x + y;
18     }
19 
20     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
21         if (x < y) revert();
22         return x - y;
23     }
24 
25     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
26         if (y == 0) return 0;
27         if (x > MAX_UINT256 / y) revert();
28         return x * y;
29     }
30 
31 }
32 
33 
34 //contract for defining owener and to transfer owenership to others
35 contract Ownable {
36     address public owner; // contract creator will be the owner
37     function Ownable() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0)); 
48         owner = newOwner;
49     }
50 }
51  /* New ERC223 contract interface */
52  
53 
54 contract ERC223Interface {
55     uint256 public totalSupply;
56 
57     function balanceOf(address who) public view returns (uint256);
58   
59 
60     function transfer(address to, uint256 value, bytes data) public returns (bool ok);
61     function transfer(address to, uint256 value, bytes data, string custom_fallback) public returns (bool ok);
62   
63     event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
64 }
65 
66 
67 contract ERC20Interface {
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed from, address indexed spender, uint256 value);
70     
71     function transfer(address to, uint256 value) public returns (bool ok);
72     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
73     function approve(address _spender, uint256 _value) public returns(bool success);
74     function allowance(address _owner, address _spender) public constant returns(uint256 remaining);
75 
76 }
77 
78 
79 contract ContractReceiver {
80      
81     struct TKN {
82         address sender;
83         uint value;
84         bytes data;
85         bytes4 sig;
86     }
87         
88     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
89         TKN memory tkn;
90         tkn.sender = _from;
91         tkn.value = _value;
92         tkn.data = _data;
93         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
94         tkn.sig = bytes4(u);
95       
96       /* tkn variable is analogue of msg variable of Ether transaction
97       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
98       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
99       *  tkn.data is data of token transaction   (analogue of msg.data)
100       *  tkn.sig is 4 bytes signature of function
101       *  if data of token transaction is a function execution
102       */
103     }
104 }
105 
106 
107 contract StandardToken is ERC223Interface, ERC20Interface, SafeMath, ContractReceiver {
108     mapping(address => uint) balances;
109     mapping (address => mapping (address => uint256)) allowed;
110 
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113         uint256 _allowance = allowed[_from][msg.sender];
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116     
117         balances[_from] = safeSub(balanceOf(_from), _value); 
118     
119         balances[_to] = safeAdd(balanceOf(_to), _value);
120         allowed[_from][msg.sender] = safeSub(_allowance, _value);
121         emit Transfer(_from, _to, _value);
122         return true;
123     }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130     function approve(address _spender, uint256 _value) public returns (bool) {
131         allowed[msg.sender][_spender] = _value;
132         emit Approval(msg.sender, _spender, _value);
133         return true;
134     }
135   /**
136    * @dev Function to check the amount of tokens that an owner allowed to a spender.
137    * @param _owner address The address which owns the funds.
138    * @param _spender address The address which will spend the funds.
139    * @return A uint256 specifying the amount of tokens still available for the spender.
140    */
141 
142     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
143         return allowed[_owner][_spender];
144   }
145 
146     // @dev function to increaseApproval to the spender
147   function increaseApproval (address _spender, uint256 _addedValue) public returns (bool success) {
148     allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender],_addedValue);
149     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150     return true;
151   }
152   // @dev function to decreaseApproval to spender
153   function decreaseApproval (address _spender, uint256 _subtractedValue) public returns (bool success) {
154     uint256 oldValue = allowed[msg.sender][_spender];
155     if (_subtractedValue > oldValue) {
156       allowed[msg.sender][_spender] = 0;
157     } else {
158       allowed[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);
159     }
160     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163   
164   
165   //@dev  function that is called when a user or another contract wants to transfer funds .
166     function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public returns (bool success) {
167         if (isContract(_to)) {
168             if (balanceOf(msg.sender) < _value) {  
169                 revert();
170             }
171             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
172             balances[_to] = safeAdd(balanceOf(_to), _value);
173             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
174             emit Transfer(msg.sender, _to, _value, _data);
175             return true;
176         }
177         else {
178             return transferToAddress(_to, _value, _data);
179         }
180     }
181   
182   // Function that is called when a user or another contract wants to transfer funds .
183     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
184     
185         if (isContract(_to)) {
186             return transferToContract(_to, _value, _data);
187         }
188         else {
189             return transferToAddress(_to, _value, _data);
190         }
191     }
192   
193   // Standard function transfer similar to ERC20 transfer with no _data .
194   // Added due to backwards compatibility reasons .
195     function transfer(address _to, uint256 _value) public returns (bool success) {
196       
197     //standard function transfer similar to ERC20 transfer with no _data
198     //added due to backwards compatibility reasons
199         bytes memory empty;
200         if (isContract(_to)) {
201             return transferToContract(_to, _value, empty);
202         }
203         else {
204             return transferToAddress(_to, _value, empty);
205         }
206     }
207 
208   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
209     function isContract(address _addr) private view returns (bool is_contract) {
210         uint length;
211         assembly {
212             //retrieve the size of the code on target address, this needs assembly
213             length := extcodesize(_addr)
214         }
215         return (length > 0);
216     }
217 
218   //function that is called when transaction target is an address
219     function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool) {
220         
221         if (balanceOf(msg.sender) < _value) revert();
222         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
223         balances[_to] = safeAdd(balanceOf(_to), _value);
224         emit Transfer(msg.sender, _to, _value);
225         return true;
226     }
227   
228   //function that is called when transaction target is a contract
229     function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
230         if (balanceOf(msg.sender) < _value) revert();
231         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
232         balances[_to] = safeAdd(balanceOf(_to), _value);
233         ContractReceiver receiver = ContractReceiver(_to);
234         receiver.tokenFallback(msg.sender, _value, _data);
235         emit Transfer(msg.sender, _to, _value, _data);
236         return true;
237     }
238 
239     function balanceOf(address _owner) public view returns (uint balance) {
240         return balances[_owner];
241     }
242 }
243 
244 
245 // @dev contract that can burn tokens or can reduce the totalSupply tokens
246 contract BurnableToken is StandardToken,Ownable {
247     event Burn(address indexed burner, uint256 value);
248     /**
249      * @dev Burns a specific amount of tokens.
250      * @param _value The amount of token to be burned.
251      */
252 
253     function burn(uint256 _value)  onlyOwner public  returns (bool) {
254         require(_value > 0);
255         require(_value <= balances[msg.sender]);
256         // no need to require value <= totalSupply, since that would imply the
257         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
258         address burner = msg.sender;
259         balances[burner] = safeSub(balances[burner], _value);
260         totalSupply = safeSub(totalSupply, _value);
261         emit Burn(burner, _value);
262         return true;
263     }
264 }
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  */
270 
271 contract MintableToken is BurnableToken {
272     event Mint(address indexed to, uint256 amount);
273     event MintFinished();
274 
275     bool public mintingFinished = false;
276 
277     modifier canMint() {
278         require(!mintingFinished);
279         _;
280     }
281 
282   /**
283    * @dev Function to mint tokens
284    * @param _to The address that will receive the minted tokens.
285    * @param _amount The amount of tokens to mint.
286    * @return A boolean that indicates if the operation was successful.
287    */
288     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
289         bytes memory empty;
290 
291         require ( _amount > 0);
292 
293         // if (balanceOf(msg.sender) < _value) revert();
294         // if( safeAdd(circulatingCoins, _amount) > totalSupply ) revert();
295         
296         totalSupply = safeAdd(totalSupply, _amount);
297         balances[_to] = safeAdd(balances[_to], _amount);
298         emit Mint(_to, _amount);
299         emit Transfer(address(0), _to, _amount, empty);
300         return true;
301     }
302 
303   /**
304    * @dev Function to stop minting new tokens.
305    * @return True if the operation was successful.
306    */
307     function finishMinting() onlyOwner canMint public returns (bool) {
308         mintingFinished = true;
309         emit MintFinished();
310         return true;
311     }
312 }
313 
314 
315 contract EMIToken is StandardToken, MintableToken {
316     string public name = "EMITOKEN";
317     string public symbol = "EMI";
318     uint8 public decimals = 8;
319     uint256 public initialSupply = 600000000 * (10 ** uint256(decimals));
320     function EMIToken() public{
321 
322         totalSupply = initialSupply;
323         balances[msg.sender] = initialSupply; // Send all tokens to owner
324 
325         emit Transfer(0x0, msg.sender, initialSupply);
326     }
327 }