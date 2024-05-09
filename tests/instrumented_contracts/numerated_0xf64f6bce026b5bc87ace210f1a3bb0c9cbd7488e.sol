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
250     lamdenTau.transfer(0x887d3fc7e01473ac85ad0be2ed31da56e0f4631f, 823287283940000000000);
251     lamdenTau.transfer(0x54d2d073b295559a523d8f35c76429e7304408a2, 1709488000000000000000);
252     lamdenTau.transfer(0x25c5d50a79fec2dc36d0030f1c3ebfadaff1fa3e, 427372000000000000000);
253     lamdenTau.transfer(0x7071f121c038a98f8a7d485648a27fcd48891ba8, 534215000000000000000);
254     lamdenTau.transfer(0x1efa0d654d2ceaf84e14c60b3971f572ba169253, 235054600000000000000);
255     lamdenTau.transfer(0x47e4270965df34348fe1be3b9efbc475c7a98f6e, 1923174000000000000000);
256     lamdenTau.transfer(0x026f38ca7f80aeaff672bb3086fb762905e6bdbd, 641058000000000000000);
257     lamdenTau.transfer(0xb01953ca8672f31039cf9fe046c96852a1ecf665, 2136860000000000000000);
258     lamdenTau.transfer(0x4620550c97fe6fd67bd6d91b3e64c57af2a74d54, 616484110000000000000);
259     lamdenTau.transfer(0xc8d66e2af307aee688a81256f953f8cff5725c8c, 438056300000000000000);
260     lamdenTau.transfer(0x485f9aa8a866881982f277c7571a35560227174f, 2136860000000000000000);
261     lamdenTau.transfer(0x522032a5134f5d64efed552d8fc273acd452b413, 1068430000000000000000);
262     lamdenTau.transfer(0x2d6643a197e97bce743bc7d1378ea46baa81d820, 213686000000000000000);
263     lamdenTau.transfer(0x2d6643a197e97bce743bc7d1378ea46baa81d820, 1068430000000000000000);
264     lamdenTau.transfer(0x8240e63c9fdb5f2867828a1bab5178d5a1188da6, 1125225601940000000000);
265     lamdenTau.transfer(0xd7da4b7c0d8054e5755a811334fb223f3f5e0f23, 4273720000000000000000);
266     lamdenTau.transfer(0xe6a265bb80418770135a2718c8a5039a58f76449, 2136860000000000000000);
267     lamdenTau.transfer(0xc16b1abf2198d01fbc692e41ce7996d0d2dfb2e1, 1047061400000000000000);
268     lamdenTau.transfer(0x25a390fb8f6bf8084298a8c5566c8ca38b130573, 101424799152600000000);
269     lamdenTau.transfer(0x9bb354ddf9e43648a06fb69420425ff6c059d231, 10684300000000000000000);
270     lamdenTau.transfer(0xb0679a8f67785bd8d19e2c640a386c9c41235dd2, 149580200000000000000);
271     lamdenTau.transfer(0x0c1d31b4bf0c44f6c9cb3b3c825d9dce09a3b430, 75351559965000000000);
272     lamdenTau.transfer(0x19d2bb5598c1af4c97a8931fe551ec2f6b6b8feb, 8141436600000000000000);
273     lamdenTau.transfer(0xb4209fb30fd2a32168d65f04ae2aa049f17ad597, 228644020000000000000);
274     lamdenTau.transfer(0xc61ca33722fde483c36481a35989435c4bc6a29f, 363266200000000000000);
275     lamdenTau.transfer(0xc2f0551bc386932e785df341358833b03e7b1987, 4273720000000000000000);
276     lamdenTau.transfer(0x4497714fb2df95b104d568877b994e10153f8f14, 29916040000000000000000);
277     lamdenTau.transfer(0x7f436de083a59aae8ac39762a3014e6d28a69bfa, 35430136243510800000000);
278     lamdenTau.transfer(0xb3ffb9ef6ec59207f765be4724f1808f78d9d0b5, 21368600000000000000);
279     lamdenTau.transfer(0x4497714fb2df95b104d568877b994e10153f8f14, 29916040000000000000000);
280     lamdenTau.transfer(0x56ae8888e4d5aeaf326899e068078e6fc3be0b00, 2136860000000000000000);
281     lamdenTau.transfer(0xa0bb4ba19f578a63fa3f67adaf7bbca15ccadc45, 1066293140000000000000);
282     lamdenTau.transfer(0x00cc6571177d773bc63fb2feed799637a62bd727, 1087661740000000000000);
283     lamdenTau.transfer(0xd0e0a8484348de8846ca4c789b63f47c162c95bb, 1006461060000000000000);
284     lamdenTau.transfer(0xc8beeb1979c82adf73051b5c00152a0541a2efb4, 3931822400000000000000);
285     lamdenTau.transfer(0x19c18152c2eb745c34c3551e751b4e32df16497c, 747901000000000000000);
286     lamdenTau.transfer(0x76aae5cb828ab0bce1b60fc40e25d048c80515de, 1225061838000000000000);
287     lamdenTau.transfer(0x3de0ab58f60befe899eab97936c8d8aa19ef4167, 42737200000000000000);
288     lamdenTau.transfer(0x3de0ab58f60befe899eab97936c8d8aa19ef4167, 2200965800000000000000);
289     lamdenTau.transfer(0x33fadbf5576d5723a5ad355bfb682a8d4174c449, 3173237100000000000000);
290     lamdenTau.transfer(0x97d613ff64978ac86db20b53ad2c8caa42baf3c7, 2136860000000000000000);
291     lamdenTau.transfer(0x61bd8eb94d90fc67a012526ea99b6703b526d514, 21368600000000000000000);
292     lamdenTau.transfer(0x2131cd4bcb1065cde991be9ba9ba7100d0d944e6, 6410580000000000000000);
293     lamdenTau.transfer(0x0277a37c577c4ce33742fe71f4fd44a7194f3178, 1068430000000000000000);
294     lamdenTau.transfer(0x657534acaf26d05ff02508cbc1ddce92143b1bdc, 2136860000000000000000);
295     lamdenTau.transfer(0x7dcf6dbda739efb6acf59c40080f12e19f2f0c19, 427372000000000000000);
296     lamdenTau.transfer(0x4d81f6873afc34c94ea0c30689c93b30c3a76e22, 21368600000000000000);
297     lamdenTau.transfer(0x4d81f6873afc34c94ea0c30689c93b30c3a76e22, 149580200000000000000);
298     lamdenTau.transfer(0x44f9a0abb46e0f6aee86adb26d1af09bb31a2a38, 6392950905000000000000);
299     lamdenTau.transfer(0x7f49b5832b650dbffce516b1f07571041f01dbb8, 4273720000000000000000);
300         
301       uint256 balance = lamdenTau.balanceOf(this);
302       lamdenTau.transfer(msg.sender, balance);
303    }
304 
305 }