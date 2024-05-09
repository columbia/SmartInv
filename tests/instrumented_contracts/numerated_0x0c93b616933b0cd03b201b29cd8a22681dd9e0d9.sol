1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43   /**
44    * @dev The constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47     constructor() public
48     {
49        owner = msg.sender;
50     }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner public {
66     require(newOwner != address(0));
67     emit OwnershipTransferred(owner, newOwner);
68     owner = newOwner;
69   }
70 }
71 
72 contract Token {
73 
74     /// @return total amount of tokens
75     function totalSupply() constant returns (uint256 supply) {}
76 
77     /// @param _owner The address from which the balance will be retrieved
78     /// @return The balance
79     function balanceOf(address _owner) constant returns (uint256 balance) {}
80 
81     /// @notice send `_value` token to `_to` from `msg.sender`
82     /// @param _to The address of the recipient
83     /// @param _value The amount of token to be transferred
84     /// @return Whether the transfer was successful or not
85     function transfer(address _to, uint256 _value) returns (bool success) {}
86 
87     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
88     /// @param _from The address of the sender
89     /// @param _to The address of the recipient
90     /// @param _value The amount of token to be transferred
91     /// @return Whether the transfer was successful or not
92     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
93 
94     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
95     /// @param _spender The address of the account able to transfer the tokens
96     /// @param _value The amount of wei to be approved for transfer
97     /// @return Whether the approval was successful or not
98     function approve(address _spender, uint256 _value) returns (bool success) {}
99 
100     /// @param _owner The address of the account owning tokens
101     /// @param _spender The address of the account able to transfer the tokens
102     /// @return Amount of remaining tokens allowed to spent
103     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
104 
105     event Transfer(address indexed _from, address indexed _to, uint256 _value);
106     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
107     event setNewBlockEvent(string SecretKey_Pre, string Name_New, string TxHash_Pre, string DigestCode_New, string Image_New, string Note_New);
108 }
109 
110 contract StandardToken is Token {
111 
112     function transfer(address _to, uint256 _value) returns (bool success) {
113         //Default assumes totalSupply can't be over max (2^256 - 1).
114         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
115         //Replace the if with this one instead.
116         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
117         if (balances[msg.sender] >= _value && _value > 0) {
118             balances[msg.sender] -= _value;
119             balances[_to] += _value;
120             emit Transfer(msg.sender, _to, _value);
121             return true;
122         } else { return false; }
123     }
124 
125     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
126         //same as above. Replace this line with the following if you want to protect against wrapping uints.
127         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
128         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
129             balances[_to] += _value;
130             balances[_from] -= _value;
131             allowed[_from][msg.sender] -= _value;
132             emit Transfer(_from, _to, _value);
133             return true;
134         } else { return false; }
135     }
136 
137     function balanceOf(address _owner) constant returns (uint256 balance) {
138         return balances[_owner];
139     }
140 
141     function approve(address _spender, uint256 _value) returns (bool success) {
142         allowed[msg.sender][_spender] = _value;
143         emit Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
148         return allowed[_owner][_spender];
149     }
150 
151     mapping (address => uint256) balances;
152     mapping (address => mapping (address => uint256)) allowed;
153     uint256 public totalSupply;
154 }
155 
156 /**
157  * @title Mintable token
158  * @dev Simple ERC20 Token example, with mintable token creation
159  */
160 contract MintableToken is StandardToken, Ownable {
161   event Mint(address indexed to, uint256 amount);
162   event MintFinished();
163 
164   using SafeMath for uint256;
165   bool public mintingFinished = false;
166 
167 
168   modifier canMint() {
169     require(!mintingFinished);
170     _;
171   }
172 
173   modifier hasMintPermission() {
174     require(msg.sender == owner);
175     _;
176   }
177 
178   /**
179    * @dev Function to mint tokens
180    * @param _to The address that will receive the minted tokens.
181    * @param _amount The amount of tokens to mint.
182    * @return A boolean that indicates if the operation was successful.
183    */
184   function mint(
185     address _to,
186     uint256 _amount
187   )
188     public
189     hasMintPermission
190     canMint
191     returns (bool)
192   {
193     totalSupply = totalSupply.add(_amount);
194     balances[_to] = balances[_to].add(_amount);
195     emit Mint(_to, _amount);
196     emit Transfer(address(0), _to, _amount);
197     return true;
198   }
199 
200   /**
201    * @dev Function to stop minting new tokens.
202    * @return True if the operation was successful.
203    */
204   function finishMinting() public onlyOwner canMint returns (bool) {
205     mintingFinished = true;
206     emit MintFinished();
207     return true;
208   }
209 }
210 /**
211  * @title Burnable Token
212  * @dev Token that can be irreversibly burned (destroyed).
213  */
214 contract BurnableToken is StandardToken, Ownable {
215     using SafeMath for uint256;
216     event Burn(address indexed burner, uint256 value);
217 
218     modifier hasBurnPermission() {
219       require(msg.sender == owner);
220       _;
221     }
222     
223     function burnPermission(
224         address _spender,
225         uint256 _value
226     ) 
227     public 
228     hasBurnPermission
229     returns (bool)
230     {
231         require(_value > 0);
232         require(_value <= balances[_spender]);
233         // no need to require value <= totalSupply, since that would imply the
234         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
235 
236         address burner = _spender;
237         balances[_spender] = balances[_spender].sub(_value);
238         totalSupply = totalSupply.sub(_value);
239         emit Burn(burner, _value);
240       return true;
241     }
242     /**
243      * @dev Burns a specific amount of tokens.
244      * @param _value The amount of token to be burned.
245      */
246     function burn(uint256 _value) 
247     public 
248     {
249         require(_value > 0);
250         require(_value <= balances[msg.sender]);
251         // no need to require value <= totalSupply, since that would imply the
252         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
253 
254         address burner = msg.sender;
255         balances[burner] = balances[burner].sub(_value);
256         totalSupply = totalSupply.sub(_value);
257         emit Burn(burner, _value);
258     }
259 }
260 
261 
262 contract HGOLD is MintableToken, BurnableToken  {
263 
264     constructor() public {
265         totalSupply = INITIAL_SUPPLY;
266         balances[msg.sender] = INITIAL_SUPPLY;
267     }
268     
269 
270     /* Public variables of the token */
271 
272     /*
273     NOTE:
274     The following variables are OPTIONAL vanities. One does not have to include them.
275     They allow one to customise the token contract & in no way influences the core functionality.
276     Some wallets/interfaces might not even bother to look at this information.
277     */
278     string public name = "HGOLD";
279     string public symbol = "HGOLD";
280     uint public constant decimals = 8;
281     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
282     string public Image_root = "https://swarm.chainbacon.com/bzz:/0132e80619e20fda25977d12e870721829aaf49cb4f31493e87642ed68b411a9/";
283     string public Note_root = "https://swarm.chainbacon.com/bzz:/77a6ec4bf43a47fa94daf229bd2ac16d468fa80ee9c90686f800443a2d8597a2/";
284     string public Document_root = "";
285     string public DigestCode_root = "0d449179d62d1803422aa923ccac327f8f4bab4e8009759b6a5f4feb99db3103";
286     function getIssuer() public pure returns(string) { return  "HOLLY_GOLD_PTE_LTD"; }
287     function getManager() public pure returns(string) { return  "HOLLY_GOLD_PTE_LTD"; }
288     string public TxHash_root = "genesis";
289 
290     string public ContractSource = "";
291     string public CodeVersion = "v0.1";
292     
293     string public SecretKey_Pre = "";
294     string public Name_New = "";
295     string public TxHash_Pre = "";
296     string public DigestCode_New = "";
297     string public Image_New = "";
298     string public Note_New = "";
299     string public Document_New = "";
300 
301     function getName() public view returns(string) { return name; }
302     function getDigestCodeRoot() public view returns(string) { return DigestCode_root; }
303     function getTxHashRoot() public view returns(string) { return TxHash_root; }
304     function getImageRoot() public view returns(string) { return Image_root; }
305     function getNoteRoot() public view returns(string) { return Note_root; }
306     function getDocumentRoot() public view returns(string) { return Document_root; }
307 
308     function getCodeVersion() public view returns(string) { return CodeVersion; }
309     function getContractSource() public view returns(string) { return ContractSource; }
310 
311     function getSecretKeyPre() public view returns(string) { return SecretKey_Pre; }
312     function getNameNew() public view returns(string) { return Name_New; }
313     function getTxHashPre() public view returns(string) { return TxHash_Pre; }
314     function getDigestCodeNew() public view returns(string) { return DigestCode_New; }
315     function getImageNew() public view returns(string) { return Image_New; }
316     function getNoteNew() public view returns(string) { return Note_New; }
317     function getDocumentNew() public view returns(string) { return Document_New; }
318     
319     function setNewBlock(string _SecretKey_Pre, string _Name_New, string _TxHash_Pre, string _DigestCode_New, string _Image_New, string _Note_New )  returns (bool success) {
320         SecretKey_Pre = _SecretKey_Pre;
321         Name_New = _Name_New;
322         TxHash_Pre = _TxHash_Pre;
323         DigestCode_New = _DigestCode_New;
324         Image_New = _Image_New;
325         Note_New = _Note_New;
326         emit setNewBlockEvent(SecretKey_Pre, Name_New, TxHash_Pre, DigestCode_New, Image_New, Note_New);
327         return true;
328     }
329 
330     /* Approves and then calls the receiving contract */
331     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
332         allowed[msg.sender][_spender] = _value;
333         emit Approval(msg.sender, _spender, _value);
334 
335         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
336         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
337         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
338         require(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
339         return true;
340     }
341 }