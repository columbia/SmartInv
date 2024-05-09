1 pragma solidity ^0.4.18;
2 // -----------------------------------------------------------------------
3 // COS Token by Contentos.
4 // As ERC20 standard
5 // Release tokens as a temporary measure
6 // Creator: Asa17
7 contract ERC20 {
8     // the total token supply
9     uint256 public totalSupply;
10  
11     // Get the account balance of another account with address _owner
12     function balanceOf(address _owner) public constant returns (uint256 balance);
13  
14     // Send _value amount of tokens to address _to
15     function transfer(address _to, uint256 _value) public returns (bool success);
16     
17     // transfer _value amount of token approved by address _from
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19     // approve an address with _value amount of tokens
20     function approve(address _spender, uint256 _value) public returns (bool success);
21     // get remaining token approved by _owner to _spender
22     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
23   
24     // Triggered when tokens are transferred.
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26  
27     // Triggered whenever approve(address _spender, uint256 _value) is called.
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29     // Trigger when the owner resign and transfer his balance to successor.
30     event TransferOfPower(address indexed _from, address indexed _to);
31 }
32 interface TokenRecipient {
33     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
34 }
35 
36 contract COSAuth {
37     address      public  owner;
38     constructor () public {
39          owner = msg.sender;
40     }
41     
42     modifier auth {
43         require(isAuthorized(msg.sender) == true);
44         _;
45     }
46     
47     function isAuthorized(address src) internal view returns (bool) {
48         if(src == owner){
49             return true;
50         } else {
51             return false;
52         }
53     }
54 }
55 
56 contract COSStop is COSAuth{
57 
58     bool public stopped;
59 
60     modifier stoppable {
61         require(stopped == false);
62         _;
63     }
64     function stop() auth internal {
65         stopped = true;
66     }
67     function start() auth internal {
68         stopped = false;
69     }
70 }
71 
72 contract Freezeable is COSAuth{
73 
74     // internal variables
75     mapping(address => bool) _freezeList;
76 
77     // events
78     event Freezed(address indexed freezedAddr);
79     event UnFreezed(address indexed unfreezedAddr);
80 
81     // public functions
82     function freeze(address addr) auth public returns (bool) {
83       require(true != _freezeList[addr]);
84 
85       _freezeList[addr] = true;
86 
87       emit Freezed(addr);
88       return true;
89     }
90 
91     function unfreeze(address addr) auth public returns (bool) {
92       require(true == _freezeList[addr]);
93 
94       _freezeList[addr] = false;
95 
96       emit UnFreezed(addr);
97       return true;
98     }
99 
100     modifier whenNotFreezed(address addr) {
101         require(true != _freezeList[addr]);
102         _;
103     }
104 
105     function isFreezing(address addr) public view returns (bool) {
106         if (true == _freezeList[addr]) {
107             return true;
108         } else {
109             return false;
110         }
111     }
112 }
113 
114 contract COSTokenBase is ERC20, COSStop, Freezeable{
115     // Public variables of the token
116     string public name;
117     string public symbol;
118     uint8  public decimals = 18;
119     //address public administrator;
120     // 18 decimals is the strongly suggested default, avoid changing it
121     // Balances
122     mapping (address => uint256) balances;
123     // Allowances
124     mapping (address => mapping (address => uint256)) allowances;
125     //register map
126     mapping (address => string)                  public  register_map;
127     // ----- Events -----
128     event Burn(address indexed from, uint256 value);
129     event LogRegister (address indexed user, string key);
130     event LogStop   ();
131     /**
132      * Constructor function
133      */
134     constructor(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
135         name = _tokenName;                                   // Set the name for display purposes
136         symbol = _tokenSymbol;                               // Set the symbol for display purposes
137         decimals = _decimals;
138         //owner = msg.sender;
139         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
140         balances[owner] = totalSupply;                // Give the creator all initial tokens
141     }
142     function balanceOf(address _owner) public view returns(uint256) {
143         return balances[_owner];
144     }
145     function allowance(address _owner, address _spender) public view returns (uint256) {
146         return allowances[_owner][_spender];
147     }
148     /**
149      * Internal transfer, only can be called by this contract
150      */
151     function _transfer(address _from, address _to, uint _value) whenNotFreezed(_from) internal returns(bool) {
152         // Prevent transfer to 0x0 address. Use burn() instead
153         require(_to != 0x0);
154         // Check if the sender has enough
155         require(balances[_from] >= _value);
156         // Check for overflows
157         require(balances[_to] + _value > balances[_to]);
158         // Save this for an assertion in the future
159         uint previousBalances = balances[_from] + balances[_to];
160         // Subtract from the sender
161         balances[_from] -= _value;
162         // Add the same to the recipient
163         balances[_to] += _value;
164         emit Transfer(_from, _to, _value);
165         // Asserts are used to use static analysis to find bugs in your code. They should never fail
166         assert(balances[_from] + balances[_to] == previousBalances);
167         return true;
168     }
169     /**
170      * Transfer tokens
171      *
172      * Send `_value` tokens to `_to` from your account
173      *
174      * @param _to The address of the recipient
175      * @param _value the amount to send
176      */
177     function transfer(address _to, uint256 _value) stoppable public returns(bool) {
178         return _transfer(msg.sender, _to, _value);
179     }
180     /**
181      * Transfer tokens from other address
182      *
183      * Send `_value` tokens to `_to` in behalf of `_from`
184      *
185      * @param _from The address of the sender
186      * @param _to The address of the recipient
187      * @param _value the amount to send
188      */
189     function transferFrom(address _from, address _to, uint256 _value) stoppable public returns(bool) {
190         require(_value <= allowances[_from][msg.sender]);     // Check allowance
191         allowances[_from][msg.sender] -= _value;
192         return _transfer(_from, _to, _value);
193     }
194     /**
195      * Set allowance for other address
196      *
197      * Allows `_spender` to spend no more than `_value` tokens in your behalf
198      *
199      * @param _spender The address authorized to spend
200      * @param _value the max amount they can spend
201      */
202     function approve(address _spender, uint256 _value) stoppable public returns(bool) {
203         allowances[msg.sender][_spender] = _value;
204         emit Approval(msg.sender, _spender, _value);
205         return true;
206     }
207     /**
208      * Set allowance for other address and notify
209      *
210      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
211      *
212      * @param _spender The address authorized to spend
213      * @param _value the max amount they can spend
214      * @param _extraData some extra information to send to the approved contract
215      */
216     function approveAndCall(address _spender, uint256 _value, bytes _extraData) stoppable public returns(bool) {
217         if (approve(_spender, _value)) {
218             TokenRecipient spender = TokenRecipient(_spender);
219             spender.receiveApproval(msg.sender, _value, this, _extraData);
220             return true;
221         }
222         return false;
223     }
224     /**
225      * Destroy tokens
226      *
227      * Remove `_value` tokens from the system irreversibly
228      *
229      * @param _value the amount of money to burn
230      */
231     function burn(uint256 _value) stoppable public returns(bool)  {
232         require(balances[msg.sender] >= _value);   // Check if the sender has enough
233         balances[msg.sender] -= _value;            // Subtract from the sender
234         totalSupply -= _value;                      // Updates totalSupply
235         emit Burn(msg.sender, _value);
236         return true;
237     }
238     
239     /**
240      * Mint tokens
241      *
242      * generate more tokens
243      *
244      * @param _value amount of money to mint
245      */
246     function mint(uint256 _value) auth stoppable public returns(bool){
247         require(balances[msg.sender] + _value > balances[msg.sender]);
248         require(totalSupply + _value > totalSupply);
249         balances[msg.sender] += _value;
250         totalSupply += _value;
251         return true;
252     }
253     
254     /**
255      * Destroy tokens from other account
256      *
257      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
258      *
259      * @param _from the address of the sender
260      * @param _value the amount of money to burn
261      */
262     function burnFrom(address _from, uint256 _value) stoppable public returns(bool) {
263         require(balances[_from] >= _value);                // Check if the targeted balance is enough
264         require(_value <= allowances[_from][msg.sender]);    // Check allowance
265         balances[_from] -= _value;                         // Subtract from the targeted balance
266         allowances[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
267         totalSupply -= _value;                              // Update totalSupply
268         emit Burn(_from, _value);
269         return true;
270     }
271     /**
272      * Transfer owner's power to others
273      *
274      * @param _to the address of the successor
275      */
276     function transferOfPower(address _to) auth stoppable public returns (bool) {
277         require(msg.sender == owner);
278         uint value = balances[msg.sender];
279         _transfer(msg.sender, _to, value);
280         owner = _to;
281         emit TransferOfPower(msg.sender, _to);
282         return true;
283     }
284     /**
285      * approve should be called when allowances[_spender] == 0. To increment
286      * allowances value is better to use this function to avoid 2 calls (and wait until
287      * the first transaction is mined)
288      * From MonolithDAO Token.sol
289      */
290     function increaseApproval(address _spender, uint _addedValue) stoppable public returns (bool) {
291         // Check for overflows
292         require(allowances[msg.sender][_spender] + _addedValue > allowances[msg.sender][_spender]);
293         allowances[msg.sender][_spender] += _addedValue;
294         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
295         return true;
296     }
297     function decreaseApproval(address _spender, uint _subtractedValue) stoppable public returns (bool) {
298         uint oldValue = allowances[msg.sender][_spender];
299         if (_subtractedValue > oldValue) {
300             allowances[msg.sender][_spender] = 0;
301         } else {
302             allowances[msg.sender][_spender] = oldValue - _subtractedValue;
303         }
304         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
305         return true;
306     }
307 }
308 contract COSToken is COSTokenBase {
309     
310     constructor() COSTokenBase(10000000000, "Contentos", "COS", 18) public {
311     }
312     
313     function finish() public{
314         stop();
315         emit LogStop();
316     }
317     
318     function register(string key) public {
319         require(bytes(key).length <= 64);
320         require(balances[msg.sender] > 0);
321         register_map[msg.sender] = key;
322         emit LogRegister(msg.sender, key);
323     }
324 }