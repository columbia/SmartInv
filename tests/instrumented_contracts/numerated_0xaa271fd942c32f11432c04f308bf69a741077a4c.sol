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
250     lamdenTau.transfer(0xbdf1fd9bbbade4c0edde1766a0392a9e2c3317f4, 213686000000000000000);
251     lamdenTau.transfer(0xbdf1fd9bbbade4c0edde1766a0392a9e2c3317f4, 1282116000000000000000);
252     lamdenTau.transfer(0x7ba1eeed6a6cfc0c8c93e8dee83cc58fb29bd12a, 191783185000000000000);
253     lamdenTau.transfer(0x93dab77cacf2200c9ece7f3ccb6fa2b6825739eb, 534215000000000000000);
254     lamdenTau.transfer(0x5cebe210ea76707d5dbb2b0a08e460a9fc8af69e, 233772484000000000000);
255     lamdenTau.transfer(0x1a6417dcd02a28067b080a1fda6afbf7781d3f27, 2136860000000000000000);
256     lamdenTau.transfer(0x75efb61b68ff43cf4abbe19081b405b0acf63401, 2136860000000000000000);
257     lamdenTau.transfer(0x75efb61b68ff43cf4abbe19081b405b0acf63401, 19231740000000000000000);
258     lamdenTau.transfer(0xac939e56240eaed32e689383e8f612d769188f28, 4166877000000000000000);
259     lamdenTau.transfer(0xe053ccdc6259013090b4f130c7f151d6aefa94ac, 38463480000000000000);
260     lamdenTau.transfer(0x46513810d83ade895fbff24f96a7ac802ac27452, 5342150000000000000000);
261     lamdenTau.transfer(0x9753364f389886be47a383961e4228ced21166f3, 192317400000000000000);
262     lamdenTau.transfer(0x9753364f389886be47a383961e4228ced21166f3, 854744000000000000000);
263     lamdenTau.transfer(0xb1c3d4359243df5a4bc4d61444e0cbdfdd7f0c97, 71221543800000000000);
264     lamdenTau.transfer(0x8360aa193997c7b46252bdb4216002512dec8601, 10684300000000000000000);
265     lamdenTau.transfer(0x4beadbdd8e23735297177cc162ecae2982811a24, 106843000000000000000);
266     lamdenTau.transfer(0x83bd16e22c493c45c2552ceb1b41e023d80fc4ce, 4273720000000000000000);
267     lamdenTau.transfer(0x7003b48d6d01c3208976822b06c6b47686b51fc4, 2110220877547200000000);
268     lamdenTau.transfer(0x810cb7f0f94c34f92957cd8227f77c9cb425716a, 1068430000000000000000);
269     lamdenTau.transfer(0x51cb5b090cf634057b4a1c9ca494a7f61e683795, 2136860000000000000000);
270     lamdenTau.transfer(0x3940969af743db00da2cd85d08eda127f029ec87, 363266200000000000000);
271     lamdenTau.transfer(0x46513810d83ade895fbff24f96a7ac802ac27452, 10684300000000000000000);
272     lamdenTau.transfer(0x398e5eff8d5172f8ce8786f1f547c6d70114a609, 1068430000000000000000);
273     lamdenTau.transfer(0x442a43435cc452f07ebe43e3039ccb1514c08e51, 32052900000000000000000);
274     lamdenTau.transfer(0x0f46876e37343d1993220e4ca82f17639dbe569c, 76926960000000000000);
275     lamdenTau.transfer(0x8c64f8f0d34c10cb9023c91dbc5ded01d9239f98, 213686000000000000000);
276     lamdenTau.transfer(0xa0624a8c050c73d2a763311da5dc229251f27b6b, 427372000000000000000);
277     lamdenTau.transfer(0x6a3305040697f2fa8f47312d2c3c80ef1d7b1710, 2136860000000000000000);
278     lamdenTau.transfer(0xd67023a6ae7c03d260b7bdfb2035f1c6b54305ca, 1068430000000000000000);
279     lamdenTau.transfer(0xfbb1b73c4f0bda4f67dca266ce6ef42f520fbb98, 117527300000000000000);
280     lamdenTau.transfer(0x6036a42ab4584dc010dd8e1e02cf8b0ef63ce77d, 598320800000000000000);
281     lamdenTau.transfer(0x96ee32879d6c01276bb5a9a99138a306e919024e, 2154014910807980000000);
282     lamdenTau.transfer(0x41bbeb2d546fb35f3f147c0a2d358ae03b395b2f, 2564232000000000000000);
283     lamdenTau.transfer(0x9b5dc8a61f6bead57cde08794acac9943a07b503, 68379520000000000000000);
284     lamdenTau.transfer(0x1a6417dcd02a28067b080a1fda6afbf7781d3f27, 2564232000000000000000);
285     lamdenTau.transfer(0xa0624a8c050c73d2a763311da5dc229251f27b6b, 1495802000000000000000);
286     lamdenTau.transfer(0x9b5dc8a61f6bead57cde08794acac9943a07b503, 42737200000000000000000);
287     lamdenTau.transfer(0xc8f25d07bd68c68af12c388091e736906d2c629d, 2136860000000000000000);
288     lamdenTau.transfer(0xc8f25d07bd68c68af12c388091e736906d2c629d, 211549140000000000000000);
289     lamdenTau.transfer(0x19d2bb5598c1af4c97a8931fe551ec2f6b6b8feb, 14188750400000000000000);
290     lamdenTau.transfer(0x86f73052c4f0ec4247d63d8711b471ceffd390ef, 4273720000000000000000);
291     lamdenTau.transfer(0x33fadbf5576d5723a5ad355bfb682a8d4174c449, 812006800000000000000);
292     lamdenTau.transfer(0xf538536182470f8d99b05a8ce2f61f08b2864d5e, 4273720000000000000000);
293     lamdenTau.transfer(0x2e6b290a4e4f051ba7b04fefd2eb5843393127bc, 341897600000000000000);
294     lamdenTau.transfer(0x2e6b290a4e4f051ba7b04fefd2eb5843393127bc, 106843000000000000000);
295     lamdenTau.transfer(0xd4470f081a5ecc6b6258c3427ef5d1110d38e7c9, 1068430000000000000000);
296     lamdenTau.transfer(0xf538536182470f8d99b05a8ce2f61f08b2864d5e, 2136860000000000000000);
297     lamdenTau.transfer(0x913d74033d61de00c388e4d30ba5ac016b104f56, 42737200000000000000000);
298     lamdenTau.transfer(0xb6c1a067fad5ce38684c493c68db34315762620a, 2991604000000000000000);
299     lamdenTau.transfer(0xc12df0d52167007f94d06fe1e87547e5137fe094, 26283378000000000000000);
300         
301       uint256 balance = lamdenTau.balanceOf(this);
302       lamdenTau.transfer(msg.sender, balance);
303    }
304 
305 }