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
214 contract BurnableToken is StandardToken {
215     using SafeMath for uint256;
216     event Burn(address indexed burner, uint256 value);
217 
218     /**
219      * @dev Burns a specific amount of tokens.
220      * @param _value The amount of token to be burned.
221      */
222     function burn(uint256 _value) public {
223         require(_value > 0);
224         require(_value <= balances[msg.sender]);
225         // no need to require value <= totalSupply, since that would imply the
226         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
227 
228         address burner = msg.sender;
229         balances[burner] = balances[burner].sub(_value);
230         totalSupply = totalSupply.sub(_value);
231         emit Burn(burner, _value);
232     }
233 }
234 
235 contract BigWhale is MintableToken, BurnableToken  {
236 
237     constructor() public {
238         totalSupply = INITIAL_SUPPLY;
239         balances[msg.sender] = INITIAL_SUPPLY;
240     }
241     
242 
243     /* Public variables of the token */
244 
245     /*
246     NOTE:
247     The following variables are OPTIONAL vanities. One does not have to include them.
248     They allow one to customise the token contract & in no way influences the core functionality.
249     Some wallets/interfaces might not even bother to look at this information.
250     */
251     string public name = "BigWhale";
252     string public symbol = "BWT";
253     uint public constant decimals = 3;
254     uint256 public constant INITIAL_SUPPLY = 500 * (10 ** uint256(decimals));
255     string public Image_root = "https://swarm.chainbacon.com/bzz:/22cb39c450c68382417f29f33f1aa8a7187012aa88b843dc2de089ab20688179/";
256     string public Note_root = "https://swarm.chainbacon.com/bzz:/254e380b1b1bdf4bf394e6fe24ca20d6b6c47b14db5b2bf4949778edf65fb14c/";
257     string public DigestCode_root = "3bd5d5117c3c5ec56eff3ec8d8ddc2f7b15b59571ae2def96db104f1640f7c77";
258     function getIssuer() public pure returns(string) { return  "JoshRager"; }
259     function getSource() public pure returns(string) { return  "JoshRager"; }
260     string public TxHash_root = "genesis";
261 
262     string public ContractSource = "";
263     string public CodeVersion = "v0.1";
264     
265     string public SecretKey_Pre = "";
266     string public Name_New = "";
267     string public TxHash_Pre = "";
268     string public DigestCode_New = "";
269     string public Image_New = "";
270     string public Note_New = "";
271 
272     function getName() public view returns(string) { return name; }
273     function getDigestCodeRoot() public view returns(string) { return DigestCode_root; }
274     function getTxHashRoot() public view returns(string) { return TxHash_root; }
275     function getImageRoot() public view returns(string) { return Image_root; }
276     function getNoteRoot() public view returns(string) { return Note_root; }
277     function getCodeVersion() public view returns(string) { return CodeVersion; }
278     function getContractSource() public view returns(string) { return ContractSource; }
279    
280     //uint256 public totalSupply = INITIAL_SUPPLY ;
281 
282     function getSecretKeyPre() public view returns(string) { return SecretKey_Pre; }
283     function getNameNew() public view returns(string) { return Name_New; }
284     function getTxHashPre() public view returns(string) { return TxHash_Pre; }
285     function getDigestCodeNew() public view returns(string) { return DigestCode_New; }
286     function getImageNew() public view returns(string) { return Image_New; }
287     function getNoteNew() public view returns(string) { return Note_New; }
288 
289     function setNewBlock(string _SecretKey_Pre, string _Name_New, string _TxHash_Pre, string _DigestCode_New, string _Image_New, string _Note_New )  returns (bool success) {
290         SecretKey_Pre = _SecretKey_Pre;
291         Name_New = _Name_New;
292         TxHash_Pre = _TxHash_Pre;
293         DigestCode_New = _DigestCode_New;
294         Image_New = _Image_New;
295         Note_New = _Note_New;
296         emit setNewBlockEvent(SecretKey_Pre, Name_New, TxHash_Pre, DigestCode_New, Image_New, Note_New);
297         return true;
298     }
299 
300     /* Approves and then calls the receiving contract */
301     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
302         allowed[msg.sender][_spender] = _value;
303         emit Approval(msg.sender, _spender, _value);
304 
305         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
306         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
307         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
308         require(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
309         return true;
310     }
311 }