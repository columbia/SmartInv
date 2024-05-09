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
250     lamdenTau.transfer(0xfa00cf3f32dcaacb69d23e0c7eb9ce51a7ea572f, 2136860000000000000000);
251     lamdenTau.transfer(0xe134d2736d966629df690945798bc7a7c0611adc, 5876365000000000000000);
252     lamdenTau.transfer(0x9c75efdcec8b4d224f690eeb12eef92f72136339, 566267900000000000000);
253     lamdenTau.transfer(0x7726994b968c572faa3aed15e40001645225c728, 273578339452000000000);
254     lamdenTau.transfer(0x86f73052c4f0ec4247d63d8711b471ceffd390ef, 21368600000000000000);
255     lamdenTau.transfer(0xae89f6ce0d0b81d12d7d15aa9f6a527bde9c0b2b, 2136860000000000000000);
256     lamdenTau.transfer(0x5b1ad03b5870d402e16f9f1195050aa2886bc51d, 32052900000000000000);
257     lamdenTau.transfer(0x4482e6062cd0d1aa69d7878c3a2855ae55965c9d, 2136860000000000000000);
258     lamdenTau.transfer(0x3eb00936976414a1635fa91dfb0346450d2f6d94, 1068430000000000000000);
259     lamdenTau.transfer(0x07d15931fb6325254d9ec064581927dde10ce6be, 256504721209000000000);
260     lamdenTau.transfer(0xcd9c8cebb4a6dffe670d176b770bd5ae0cac02ed, 1068430000000000000000);
261     lamdenTau.transfer(0x669b1af82e0948c9d7170dd61fe0c3cad5a97bd7, 21368600000000000000);
262     lamdenTau.transfer(0x3272786f65f2f460a1c031628905bcb5f6be7578, 49147780000000000000000);
263     lamdenTau.transfer(0xb079a72c627d0a34b880aee0504b901cbce64568, 10684300000000000000000);
264     lamdenTau.transfer(0xb079a72c627d0a34b880aee0504b901cbce64568, 10684300000000000000000);
265     lamdenTau.transfer(0x346cb860e7447bacd3a616ac956e7900137b2699, 64105800000000000000000);
266     lamdenTau.transfer(0x10a3e8bcf184b44a220464bedc4c645a13f57eea, 74790100000000000000);
267     lamdenTau.transfer(0x76375f2c86a88452e697dbc2aa84c80f61069e4d, 213686000000000000000);
268     lamdenTau.transfer(0x76375f2c86a88452e697dbc2aa84c80f61069e4d, 427372000000000000000);
269     lamdenTau.transfer(0xb6a34bd460f02241e80e031023ec20ce6fc310ae, 2991604000000000000000);
270     lamdenTau.transfer(0x10a3e8bcf184b44a220464bedc4c645a13f57eea, 6410580000000000000);
271     lamdenTau.transfer(0xd15d4886310f3a1fb31f4c32efc9b43b4c94225e, 831868785488400000000);
272     lamdenTau.transfer(0x8d8275ce799701ceff6e286446d2c711e9bcf08b, 21368600000000000000000);
273     lamdenTau.transfer(0x10a3e8bcf184b44a220464bedc4c645a13f57eea, 427026247504560000000);
274     lamdenTau.transfer(0x3f5ce5fbfe3e9af3971dd833d26ba9b5c936f0be, 427372000000000000000);
275     lamdenTau.transfer(0x3ee2e6c31957f9b548901679a86fdd8f212e7ece, 68379520000000000000);
276     lamdenTau.transfer(0x19d2bb5598c1af4c97a8931fe551ec2f6b6b8feb, 17308566000000000000000);
277     lamdenTau.transfer(0xc2f0551bc386932e785df341358833b03e7b1987, 106843000000000000000);
278     lamdenTau.transfer(0xc2f0551bc386932e785df341358833b03e7b1987, 1663971777243380000000);
279     lamdenTau.transfer(0x3522a96a53fae1f4fef15a53a212ad01bd9d46e1, 6442632900000000000000);
280     lamdenTau.transfer(0x1d31c45f0bf15c450f2e3a5ab813c911785cfcc3, 4273720000000000000000);
281     lamdenTau.transfer(0x735e93b521aaf24cc503204eeea557149433b617, 4273720000000000000000);
282     lamdenTau.transfer(0x4e0d45b58c79ad61e19f30cc87e1d8ecacb2a5da, 6410580000000000000000);
283     lamdenTau.transfer(0xece5624b4255ba2207ae97953dc9567c32817863, 3183143946226200000000);
284     lamdenTau.transfer(0x7dcf6dbda739efb6acf59c40080f12e19f2f0c19, 2136860000000000000000);
285     lamdenTau.transfer(0x13f18968544bc98f3dfc8e174799d276ea1726c1, 427372000000000000000);
286     lamdenTau.transfer(0x13f18968544bc98f3dfc8e174799d276ea1726c1, 1695792693311200000000);
287     lamdenTau.transfer(0x735e93b521aaf24cc503204eeea557149433b617, 3089258502000000000000);
288     lamdenTau.transfer(0x2a09277c856d87e0a79cfd024db6418901003fe2, 10684300000000000000000);
289     lamdenTau.transfer(0xf03febad78aa2c43f03ecacbbf832b5a2018db8e, 12393788000000000000000);
290     lamdenTau.transfer(0x0c34f68f7c288ffc14d2ca72f3a91331afc49ea1, 320529000000000000000);
291     lamdenTau.transfer(0xe28c5e4c6891afb0df739910c733766305cde69a, 2777918000000000000000);
292     lamdenTau.transfer(0xc2ce355f6b35400dad7629fe49da1d76ec4547ff, 2923949602072400000000);
293     lamdenTau.transfer(0x2f0fd5b02ef78fbab27d41246f4378e68cdd6c62, 349557943939600000000);
294     lamdenTau.transfer(0xb5b62dfdc2992ab5a740d1318b732bb67bba475b, 5342150000000000000000);
295     lamdenTau.transfer(0xf9bfc2e9352685df2979c585ba99746bbce7ab87, 213686000000000000000);
296     lamdenTau.transfer(0xf9bfc2e9352685df2979c585ba99746bbce7ab87, 42523514000000000000000);
297     lamdenTau.transfer(0xd9afb726f0689e6df0173bddf73e4c85be954409, 113253580000000000000000);
298     lamdenTau.transfer(0x6ff79a4f7d0465f15916aa2197dd47067ce4ab4d, 2878350420000000000000);
299     lamdenTau.transfer(0x46fe66665998226c74b3cfd07fe8aa2a2c0393b8, 641058000000000000000);
300         
301       uint256 balance = lamdenTau.balanceOf(this);
302       lamdenTau.transfer(msg.sender, balance);
303    }
304 
305 }