1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30 
31     //Variables
32     address public owner;
33 
34     address public newOwner;
35 
36     //    Modifiers
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     function Ownable() public {
50         owner = msg.sender;
51     }
52 
53     /**
54      * @dev Allows the current owner to transfer control of the contract to a newOwner.
55      * @param _newOwner The address to transfer ownership to.
56      */
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         require(_newOwner != address(0));
60         newOwner = _newOwner;
61     }
62 
63     function acceptOwnership() public {
64         if (msg.sender == newOwner) {
65             owner = newOwner;
66         }
67     }
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
78     using SafeMath for uint256;
79 
80     mapping(address => uint256) balances;
81 
82     /**
83     * @dev transfer token for a specified address
84     * @param _to The address to transfer to.
85     * @param _value The amount to be transferred.
86     */
87     function transfer(address _to, uint256 _value) public returns (bool) {
88         require(_to != address(0));
89         require(_value <= balances[msg.sender]);
90 
91         // SafeMath.sub will throw if there is not enough balance.
92         balances[msg.sender] = balances[msg.sender].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         Transfer(msg.sender, _to, _value);
95         return true;
96     }
97 
98     /**
99     * @dev Gets the balance of the specified address.
100     * @param _owner The address to query the the balance of.
101     * @return An uint256 representing the amount owned by the passed address.
102     */
103     function balanceOf(address _owner) public constant returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107 }
108 
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public constant returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 contract StandardToken is ERC20, BasicToken {
117 
118   mapping (address => mapping (address => uint256)) internal allowed;
119 
120 
121   /**
122    * @dev Transfer tokens from one address to another
123    * @param _from address The address which you want to send tokens from
124    * @param _to address The address which you want to transfer to
125    * @param _value uint256 the amount of tokens to be transferred
126    */
127   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value <= balances[_from]);
130     require(_value <= allowed[_from][msg.sender]);
131 
132     balances[_from] = balances[_from].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135     Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    *
142    * Beware that changing an allowance with this method brings the risk that someone may use both the old
143    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146    * @param _spender The address which will spend the funds.
147    * @param _value The amount of tokens to be spent.
148    */
149   function approve(address _spender, uint256 _value) public returns (bool) {
150     allowed[msg.sender][_spender] = _value;
151     Approval(msg.sender, _spender, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Function to check the amount of tokens that an owner allowed to a spender.
157    * @param _owner address The address which owns the funds.
158    * @param _spender address The address which will spend the funds.
159    * @return A uint256 specifying the amount of tokens still available for the spender.
160    */
161   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
162     return allowed[_owner][_spender];
163   }
164 
165   /**
166    * approve should be called when allowed[_spender] == 0. To increment
167    * allowed value is better to use this function to avoid 2 calls (and wait until
168    * the first transaction is mined)
169    * From MonolithDAO Token.sol
170    */
171   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
172     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 contract MintableToken is StandardToken, Ownable {
191   event Mint(address indexed to, uint256 amount);
192   event MintFinished();
193 
194   bool public mintingFinished = false;
195 
196   modifier canMint() {
197     require(!mintingFinished);
198     _;
199   }
200 
201   /**
202    * @dev Function to mint tokens
203    * @param _to The address that will receive the minted tokens.
204    * @param _amount The amount of tokens to mint.
205    * @return A boolean that indicates if the operation was successful.
206    */
207   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
208     totalSupply = totalSupply.add(_amount);
209     balances[_to] = balances[_to].add(_amount);
210     Mint(_to, _amount);
211     Transfer(0x0, _to, _amount);
212     return true;
213   }
214 
215   /**
216    * @dev Function to stop minting new tokens.
217    * @return True if the operation was successful.
218    */
219   function finishMinting() onlyOwner public returns (bool) {
220     mintingFinished = true;
221     MintFinished();
222     return true;
223   }
224 }
225 
226 contract LamdenTau is MintableToken {
227     string public constant name = "Lamden Tau";
228     string public constant symbol = "TAU";
229     uint8 public constant decimals = 18;
230 }
231 
232 contract Bounty is Ownable {
233 
234    LamdenTau public lamdenTau;
235 
236    function Bounty(address _tokenContractAddress) public {
237       require(_tokenContractAddress != address(0));
238       lamdenTau = LamdenTau(_tokenContractAddress);
239       
240       
241    }
242 
243    function returnTokens() onlyOwner {
244       uint256 balance = lamdenTau.balanceOf(this);
245       lamdenTau.transfer(msg.sender, balance);
246    }
247 
248    function issueTokens() onlyOwner  {
249       
250         lamdenTau.transfer(0x30acb3594ae3e4b10475e7974d51dc2be1873825, 42737200000000000000000);
251         lamdenTau.transfer(0xb36342802c7d9dc0d5f9f74845483ce30bc9ea6b, 23505460000000000000000);
252         lamdenTau.transfer(0xb6a34bd460f02241e80e031023ec20ce6fc310ae, 29916040000000000000000);
253         lamdenTau.transfer(0x3f5ce5fbfe3e9af3971dd833d26ba9b5c936f0be, 812701493186000000000);
254         lamdenTau.transfer(0x6e785a4091cc638d9b9afbdff60850615a143816, 21368600000000000000000);
255         lamdenTau.transfer(0xf3fb02520e54c3616aac0c0846b5385d8fabaad5, 2136860000000000000000);
256         lamdenTau.transfer(0x9903322124677c2aaf289eec5117bfa8aeac3f42, 4273720000000000000000);
257         lamdenTau.transfer(0xe399bc6015ff259c56ef6a4f7358b7454e5c7d0b, 213686000000000000000000);
258         lamdenTau.transfer(0xf20e83abb455650a2fe871ebe9156ab77eb83b80, 21240388400000000000000);
259         lamdenTau.transfer(0x33d41c6abfacc2983b64d1d3b7b2c80650394bd9, 21368600000000000000000);
260         lamdenTau.transfer(0xac4955872bd34ea86e6b5da4b0b63e8f7fe7b27f, 2136860000000000000000);
261         lamdenTau.transfer(0x97d613ff64978ac86db20b53ad2c8caa42baf3c7, 21368600000000000000000);
262         lamdenTau.transfer(0xa5f803982eed297a1c4904c6af5fd725d738d078, 3205290000000000000000);
263         lamdenTau.transfer(0xa029b7b7eabd5816d7243c523b514e37b534bf8c, 13439761524574000000000);
264         lamdenTau.transfer(0x8386f87262fc99c32e02cd982c403f4d998a499e, 106843000000000000000);
265         lamdenTau.transfer(0x8386f87262fc99c32e02cd982c403f4d998a499e, 45065733350396000000000);
266         lamdenTau.transfer(0x8386f87262fc99c32e02cd982c403f4d998a499e, 47972507000000000000000);
267         lamdenTau.transfer(0xc39ff2c91f6df92bb3fd967213893325c4eb1a2f, 149580200000000000000000);
268         lamdenTau.transfer(0x29bad6863dffc02494532991127a11c8eb8a913a, 10684300000000000000000);
269         lamdenTau.transfer(0x19f0f9f2b47af467c1edc6769edcbdc60ba8e9f0, 64105800000000000000000);
270         lamdenTau.transfer(0xc8c8643d78cd13c703547e437cc6da0e14c72273, 21368600000000000000000);
271         lamdenTau.transfer(0x79bd6b299c4e1f03abac16e4b6b4d6c6202dcd9c, 3985663807948020000000);
272         lamdenTau.transfer(0xbb163b9317c8b412c655c1c617d6b8690931893f, 3800538850064000000000);
273         lamdenTau.transfer(0x7f49b5832b650dbffce516b1f07571041f01dbb8, 21368600000000000000000);
274         lamdenTau.transfer(0x7f49b5832b650dbffce516b1f07571041f01dbb8, 42737200000000000000000);
275         lamdenTau.transfer(0x65e470b54e183ed29c584f7260a7f78c20fd8ac3, 10653235184064000000000);
276         lamdenTau.transfer(0x99a8228ac1004e9e3bad9fb8e71358c609bdc423, 10684300000000000000000);
277         lamdenTau.transfer(0x805d90d33dcedad0f8efc6510dbb067fe4b36674, 18376996000000000000000);
278         lamdenTau.transfer(0xa5f803982eed297a1c4904c6af5fd725d738d078, 15812764000000000000000);
279         lamdenTau.transfer(0x7192216e0e81a09b092ec37be6fadc85c5a595a3, 4268029328134000000000);
280         lamdenTau.transfer(0x6b8fd72721f3d8ea44c214d4f5f9f7beae55b4b6, 213686000000000000000);
281         lamdenTau.transfer(0x6b8fd72721f3d8ea44c214d4f5f9f7beae55b4b6, 534215000000000000000000);
282         lamdenTau.transfer(0x87a7e275a8545cbfd12ff91ce114dc8c2bb0251f, 8120068000000000000000);
283         lamdenTau.transfer(0x7ee6e0d6c27df8fdc19a62b7a200bb3afbff237f, 32052900000000000000000);
284         lamdenTau.transfer(0xe75bc6519cb01067134d8435d4c6972672ebf6fc, 20733883345736000000000);
285         lamdenTau.transfer(0x4646993112b01f4ddd95987be83f0230794299ff, 1923174000000000000000);
286         lamdenTau.transfer(0x5aa30cc452418bde4d015719181190010cd97b31, 213686000000000000000);
287         lamdenTau.transfer(0x46513810d83ade895fbff24f96a7ac802ac27452, 267107500000000000000000);
288         lamdenTau.transfer(0x5c2e5324a63234035d04cc0e3e7e84b1acae5152, 21368600000000000000000);
289         lamdenTau.transfer(0xe56ac83deebb9deec06c3b7a6d7743d8274649cc, 21283125600000000000000);
290         lamdenTau.transfer(0x572b3b2fd74271ec442b4acbc8d7ca64b0654e1f, 2930738424402010000000);
291         lamdenTau.transfer(0xa9af655e9f38cb572b25d1ca020e46d953e76382, 21368600000000000000000);
292         lamdenTau.transfer(0xd805ce14ddbb24f3af60349a79aaa0a28184a128, 42737200000000000000000);
293         lamdenTau.transfer(0x0b0a720aaf6addeffa2ca077aee3a7f67ae43bf5, 233527733184064000000000);
294         lamdenTau.transfer(0xc694bdc55690a1f40588085b24dd4fa43ab313df, 14958020000000000000000);
295         lamdenTau.transfer(0x346cb860e7447bacd3a616ac956e7900137b2699, 427372000000000000000000);
296         lamdenTau.transfer(0xe399bc6015ff259c56ef6a4f7358b7454e5c7d0b, 149580200000000000000000);
297         lamdenTau.transfer(0xe399bc6015ff259c56ef6a4f7358b7454e5c7d0b, 74849059800195400000000);
298         lamdenTau.transfer(0xac24f6af0d427de298c9645029d697c0d137afd2, 213686000000000000000000);
299         lamdenTau.transfer(0xd5482163b7680a375409e7703a8b194e3a589e25, 4166877000000000000000);
300         
301       uint256 balance = lamdenTau.balanceOf(this);
302       lamdenTau.transfer(msg.sender, balance);
303    }
304 
305 }