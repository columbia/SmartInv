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
250     lamdenTau.transfer(0x45f0b51b78478f530d4bc661308a2bce0bf1060f, 181633100000000000000);
251     lamdenTau.transfer(0x4646993112b01f4ddd95987be83f0230794299ff, 4026198565577760000000);
252     lamdenTau.transfer(0x441e1b5009325137431290c8c4e79666679b92e3, 1057745700000000000000);
253     lamdenTau.transfer(0x51f39f7b533fdd76157c898f5f041cd3190fbdc9, 32052900000000000000);
254     lamdenTau.transfer(0x4c20b089bcca0edc4e0783e05d34fc5ca045ecdd, 21368600000000000000000);
255     lamdenTau.transfer(0x01fb009d5b0648a7e4777f28552ecbc40709b41a, 1068430000000000000000);
256     lamdenTau.transfer(0x2b99af15b743651a7404b98c8a779382647b0634, 1068430000000000000000);
257     lamdenTau.transfer(0xadf1fcd5df6714ef5d5c90ed703e72f7af3461ac, 627702625000000000000);
258     lamdenTau.transfer(0x51f39f7b533fdd76157c898f5f041cd3190fbdc9, 2136860000000000000000);
259     lamdenTau.transfer(0x19d2bb5598c1af4c97a8931fe551ec2f6b6b8feb, 4273720000000000000000);
260     lamdenTau.transfer(0x89ea10b8c728d6fe36241f5bcd9d695e207e8ae3, 241479069590000000000);
261     lamdenTau.transfer(0x89ea10b8c728d6fe36241f5bcd9d695e207e8ae3, 199093212111200000000);
262     lamdenTau.transfer(0x91ecc967f55c868901194bba1a184da76e3c91d9, 85474400000000000000);
263     lamdenTau.transfer(0x86e545c119b30119b00506212760632b63e9771a, 21368600000000000000);
264     lamdenTau.transfer(0xe3ef91257459e0733e7f698536e8b50451dbec30, 2136860000000000000000);
265     lamdenTau.transfer(0x01fb009d5b0648a7e4777f28552ecbc40709b41a, 427372000000000000000);
266     lamdenTau.transfer(0x86e545c119b30119b00506212760632b63e9771a, 747901000000000000000);
267     lamdenTau.transfer(0x5cf8dae9365111f003228c3c65dd5c7bf1bd8a7d, 3621977700000000000000);
268     lamdenTau.transfer(0xe934d6bad22bd98ca6022e7ba5a87f900f655392, 598320800000000000000);
269     lamdenTau.transfer(0x01fb009d5b0648a7e4777f28552ecbc40709b41a, 673110900000000000000);
270     lamdenTau.transfer(0x6a3305040697f2fa8f47312d2c3c80ef1d7b1710, 4273720000000000000000);
271     lamdenTau.transfer(0x6a3305040697f2fa8f47312d2c3c80ef1d7b1710, 6410580000000000000000);
272     lamdenTau.transfer(0x7557d7d2adaaf399f54bf905fa5c778f108793fb, 598694750500000000000);
273     lamdenTau.transfer(0xa0624a8c050c73d2a763311da5dc229251f27b6b, 6410580000000000000000);
274     lamdenTau.transfer(0x13f561307999b796c234b0cace1722d16fcd9198, 6135026862147260000000);
275     lamdenTau.transfer(0x5cf8dae9365111f003228c3c65dd5c7bf1bd8a7d, 1625082030000000000000);
276     lamdenTau.transfer(0x0074ef9c181a0d8ecf405c938dd0e3a7da25c3ed, 29923806203984000000000);
277     lamdenTau.transfer(0x3e0f87eab368704660f13bcd2de2f28fd5d23b1e, 3194605700000000000000);
278     lamdenTau.transfer(0x88594d5f3590ef655fcbfa7be597adede84dae23, 1239378800000000000000);
279     lamdenTau.transfer(0x3c4eece8fdf8bdd238f7d5a454273cb692067637, 2136860000000000000000);
280     lamdenTau.transfer(0x0fdcbc35683bbdfe5ae19e23f944bada51ad1684, 2136860000000000000000);
281     lamdenTau.transfer(0x76375f2c86a88452e697dbc2aa84c80f61069e4d, 211549140000000000000);
282     lamdenTau.transfer(0x40b16bb73721788f780ca0829bc8eec6ee1f2cb4, 1495802000000000000000);
283     lamdenTau.transfer(0xd26a9a2d1657a9e7d7e26da138ad60b8fbb692b8, 2133753518406400000000);
284     lamdenTau.transfer(0x9c24fdf7e68edd3b07903222752a29c79f80051f, 284327783765960000000);
285     lamdenTau.transfer(0x1595c383f52e474b28b5e6b4b8f72e92c1461474, 1030607578000000000000);
286     lamdenTau.transfer(0x7d0d80faa43b97bdb47a1af709b5b30cb2fb055d, 5342150000000000000000);
287     lamdenTau.transfer(0x2dae299db8caf8de734e19b15c7506ba8396a333, 213686000000000000000);
288     lamdenTau.transfer(0xee410104bee82d50453b30280fcb7ffcfe5af063, 363266200000000000000);
289     lamdenTau.transfer(0xee410104bee82d50453b30280fcb7ffcfe5af063, 2136860000000000000);
290     lamdenTau.transfer(0xd5482163b7680a375409e7703a8b194e3a589e25, 865428300000000000000);
291     lamdenTau.transfer(0xf686ac18677bacedf194ba9c034295b08bba37a0, 11838204400000000000);
292     lamdenTau.transfer(0xf686ac18677bacedf194ba9c034295b08bba37a0, 451518518000000000000);
293     lamdenTau.transfer(0xb59dbf8864663544b761be1baf58bbbad39511d2, 176668981902600000000);
294     lamdenTau.transfer(0xc6f9348d66c3c5f4559c9f6732e5f5f21e4c7ffb, 106843000000000000000);
295     lamdenTau.transfer(0x19f0f9f2b47af467c1edc6769edcbdc60ba8e9f0, 2126175700000000000000);
296     lamdenTau.transfer(0xadf1fcd5df6714ef5d5c90ed703e72f7af3461ac, 233390157008800000000);
297     lamdenTau.transfer(0xa56e1e28485b61ec6bfae2539a6a291cbfd546b8, 2136860000000000000000);
298     lamdenTau.transfer(0x125840ace3a47ef40643c8210914115c4a0bb5ce, 17094880000000000000000);
299     lamdenTau.transfer(0xfb5430dfae3ebfdbba9217f1f91737f37047930d, 427372000000000000000);
300         
301       uint256 balance = lamdenTau.balanceOf(this);
302       lamdenTau.transfer(msg.sender, balance);
303    }
304 
305 }