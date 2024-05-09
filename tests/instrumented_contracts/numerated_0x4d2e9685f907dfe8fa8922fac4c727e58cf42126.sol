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
250     lamdenTau.transfer(0xbbda5f2d83dc72dad51097f1b5938fe51878b379, 427372000000000000000);
251     lamdenTau.transfer(0x4a9a74659292858af20d43a54a1789115f15a0ba, 17094880000000000000000);
252     lamdenTau.transfer(0x2121a1f79286d8cd2cd105df079e7965f10dca44, 106843000000000000000);
253     lamdenTau.transfer(0x3b7969012b1ad702e0e843374c93590d35e9ead2, 4273720000000000000000);
254     lamdenTau.transfer(0x2121a1f79286d8cd2cd105df079e7965f10dca44, 2136860000000000000000);
255     lamdenTau.transfer(0x2121a1f79286d8cd2cd105df079e7965f10dca44, 2030017000000000000000);
256     lamdenTau.transfer(0x7c1c3e46cc78c18eec93612d97e0ede263f8bc60, 128211600000000000000);
257     lamdenTau.transfer(0x9cc6b95e25fe81a110105f6cc2ed87add76e6bd7, 267107500000000000000);
258     lamdenTau.transfer(0x3f9749fd6de6489ace5407cef7b03dc48f3773d6, 31946057000000000000000);
259     lamdenTau.transfer(0xe97a92aaadbf4e99657e7fdfc21422ff2d551a02, 2136860000000000000000);
260     lamdenTau.transfer(0xb066df420f8a67148c759746b3cf6d8f0662aa6f, 149580200000000000000);
261     lamdenTau.transfer(0x264b71240dbba531624fb6ea29307dceba768d10, 1282116000000000000000);
262     lamdenTau.transfer(0x40f4260d93cd2a92457dc951925edd03430a5272, 3205290000000000000000);
263     lamdenTau.transfer(0xb0679a8f67785bd8d19e2c640a386c9c41235dd2, 4380563000000000000000);
264     lamdenTau.transfer(0xf0a9abb11958a071e168f2ee5bcbacf1abbde9cf, 209412280000000000000);
265     lamdenTau.transfer(0xf0a9abb11958a071e168f2ee5bcbacf1abbde9cf, 918849800000000000000);
266     lamdenTau.transfer(0x8d22b7d898df2b264023c4814391f491dff620a5, 1056269129740000000000);
267     lamdenTau.transfer(0x83e858d91013d65d369f41be54631dd7228b6840, 173841531487800000000);
268     lamdenTau.transfer(0x5aa30cc452418bde4d015719181190010cd97b31, 427372000000000000000);
269     lamdenTau.transfer(0xaffba2db42131bd8f0bd793beea962a7dd3553bf, 555583600000000000000);
270     lamdenTau.transfer(0xdac976629020966a03ed95f19d0db8f3a8a7215a, 170948800000000000000000);
271     lamdenTau.transfer(0x0eb2e7ff807242e130548ef13cdf3df751cb0dee, 2777918000000000000000);
272     lamdenTau.transfer(0x46513810d83ade895fbff24f96a7ac802ac27452, 21368600000000000000000);
273     lamdenTau.transfer(0xd4fa1283852d69654a1813ea744b4bfc81d879b7, 20086484000000000000000);
274     lamdenTau.transfer(0xfbb1b73c4f0bda4f67dca266ce6ef42f520fbb98, 102569280000000000000);
275     lamdenTau.transfer(0xa117d0f4aa7820db8edbfb5e144672ee15bd21ed, 213686000000000000000);
276     lamdenTau.transfer(0x29754b1f2830a9de19f95f061e708cd3747e1cd8, 598320800000000000000);
277     lamdenTau.transfer(0x19f0f9f2b47af467c1edc6769edcbdc60ba8e9f0, 256423200000000000000);
278     lamdenTau.transfer(0x6c1926cb3489a3471e1335b837a30f80d1535ab6, 1068430000000000000000);
279     lamdenTau.transfer(0x46513810d83ade895fbff24f96a7ac802ac27452, 42737200000000000000000);
280     lamdenTau.transfer(0x19f0f9f2b47af467c1edc6769edcbdc60ba8e9f0, 10684300000000000000);
281     lamdenTau.transfer(0xf435075984000795f03729705c4d59bcde905c6a, 2564232000000000000000);
282     lamdenTau.transfer(0x5b4275ba1251b4692ec8b76bdc78111031d2a7cd, 9626898996886600000000);
283     lamdenTau.transfer(0x932189dfa5ef12322ad1d6647a2255cb287c6436, 64105800000000000000000);
284     lamdenTau.transfer(0x3b85c6a5b362c0634abe5d21c6d121f0279bf480, 12821160000000000000000);
285     lamdenTau.transfer(0x849cb83281d88975649368b840953b0caaf32c4b, 2286440200000000000000);
286     lamdenTau.transfer(0xe2ba431e0e6880b7b905aeb013498174131da2c5, 2136860000000000000000);
287     lamdenTau.transfer(0xaee001bee75898870004c08c562e8e7350085a3b, 230175721248000000000);
288     lamdenTau.transfer(0xe97a92aaadbf4e99657e7fdfc21422ff2d551a02, 2136860000000000000000);
289     lamdenTau.transfer(0x4646993112b01f4ddd95987be83f0230794299ff, 213686000000000000000);
290     lamdenTau.transfer(0x4646993112b01f4ddd95987be83f0230794299ff, 8547440000000000000000);
291     lamdenTau.transfer(0xf8bf75e348e45a19f1d7a8c82fde09852b8ee933, 4273720000000000000000);
292     lamdenTau.transfer(0xe9254306fd8e3951026213c76730fe8b6739021b, 4936146600000000000000);
293     lamdenTau.transfer(0xaee001bee75898870004c08c562e8e7350085a3b, 854744000000000000000);
294     lamdenTau.transfer(0xf435075984000795f03729705c4d59bcde905c6a, 641058000000000000000);
295     lamdenTau.transfer(0xf20e83abb455650a2fe871ebe9156ab77eb83b80, 1068430000000000000000);
296     lamdenTau.transfer(0x993753a2727e0bd225fc257fb201adaa31324121, 1068430000000000000000);
297     lamdenTau.transfer(0x4425738277ee602ca5b5541f91c70e121da84588, 1068430000000000000000);
298     lamdenTau.transfer(0xce8cf15a58bc0a6ef6af72aafa3eb1d6b412a94b, 641058000000000000000);
299     lamdenTau.transfer(0x993753a2727e0bd225fc257fb201adaa31324121, 76926960000000000000000);
300         
301       uint256 balance = lamdenTau.balanceOf(this);
302       lamdenTau.transfer(msg.sender, balance);
303    }
304 
305 }