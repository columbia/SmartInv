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
250     lamdenTau.transfer(0xf2e99bc068ac16c3ba545c6f38126ab0193185ed, 27779180000000000000000);
251     lamdenTau.transfer(0x147e57b7cef2408c2d6e0c945ede1976f24f4659, 213686000000000000000);
252     lamdenTau.transfer(0x147e57b7cef2408c2d6e0c945ede1976f24f4659, 4096686277464000000000);
253     lamdenTau.transfer(0xb8eb8b9d4ec233bd36e6b38ecbea9be0553745c8, 641058000000000000000);
254     lamdenTau.transfer(0xfb707e72f55719d190c1c96b0ae35fcf0e10cbb2, 2158228600000000000000);
255     lamdenTau.transfer(0x568f739c811eac61aa4ea2390801574c3914eb02, 6410580000000000000000);
256     lamdenTau.transfer(0x3fc1d20e15c2563269c35bbbd003845502144eaa, 4273720000000000000000);
257     lamdenTau.transfer(0x323a3ea7720424d4765cdea61f0d93664cb94536, 6410580000000000000000);
258     lamdenTau.transfer(0xce6d09baa855f686bf3311f1be7878c5ddcfd1a2, 1923174000000000000000);
259     lamdenTau.transfer(0x59b31add002f70e7fe170f2801a3dbb4e950d289, 4273720000000000000000);
260     lamdenTau.transfer(0xa832b7f0dc564d19a810276b0b24aa5aa4092291, 6410580000000000000000);
261     lamdenTau.transfer(0x8dc1f3761b1ad8df632bed3102bacb2cfaa4719a, 4285387255600000000000);
262     lamdenTau.transfer(0x247d3fafca20716ecdfb82e24e38ec8ba123df0d, 1599810711633200000000);
263     lamdenTau.transfer(0x29754b1f2830a9de19f95f061e708cd3747e1cd8, 42737200000000000000);
264     lamdenTau.transfer(0x29754b1f2830a9de19f95f061e708cd3747e1cd8, 598320800000000000000);
265     lamdenTau.transfer(0xc82b1cb83644117ab72cb88a65b75af26ab8044e, 4701092000000000000000);
266     lamdenTau.transfer(0x88051b9171377cbc861fa88d3c6505829f7e36e8, 2136860000000000000000);
267     lamdenTau.transfer(0xa2a47b77672a9ee0f97831531d03c84403fcce28, 2136860000000000000000);
268     lamdenTau.transfer(0x5a8eb9a3f09053537698c6fef1d33f451a6cec41, 1709488000000000000000);
269     lamdenTau.transfer(0x441914a89a7f43e493b85eb002c9f9ff9895709d, 4273720000000000000000);
270     lamdenTau.transfer(0x88594d5f3590ef655fcbfa7be597adede84dae23, 864915453600000000000);
271     lamdenTau.transfer(0x02f509d5bbac1e6e0beec29e2f8a62222f41ead8, 4273720000000000000000);
272     lamdenTau.transfer(0x6e4053f2497bb1b3444445d2d96f8bce9e7db7cf, 3485018902053480000000);
273     lamdenTau.transfer(0x9166bc0307a6ec0a930b26699656523aff4392b5, 32052900000000000000000);
274     lamdenTau.transfer(0x6a3305040697f2fa8f47312d2c3c80ef1d7b1710, 4273720000000000000000);
275     lamdenTau.transfer(0xc6964aba1478d4c853277c69bb1c5f7a54d91acf, 6080648816000000000000);
276     lamdenTau.transfer(0x19f0f9f2b47af467c1edc6769edcbdc60ba8e9f0, 1773593800000000000000);
277     lamdenTau.transfer(0xf20e83abb455650a2fe871ebe9156ab77eb83b80, 2136860000000000000000);
278     lamdenTau.transfer(0xdd6d2526c7f1b518acb443f31deaec7422b97d9c, 27365312057718800000000);
279     lamdenTau.transfer(0x02f509d5bbac1e6e0beec29e2f8a62222f41ead8, 12145505616910600000000);
280     lamdenTau.transfer(0x194bd8b3db2332e5caa7d67aa541e1d49c919cba, 2136860000000000000000);
281     lamdenTau.transfer(0xb550fe698a863d189a0f6806a7bccd4afd7eca1d, 1057745700000000000000);
282     lamdenTau.transfer(0x194bd8b3db2332e5caa7d67aa541e1d49c919cba, 106843000000000000000000);
283     lamdenTau.transfer(0x194bd8b3db2332e5caa7d67aa541e1d49c919cba, 104706140000000000000000);
284     lamdenTau.transfer(0x194bd8b3db2332e5caa7d67aa541e1d49c919cba, 309844700000000000000000);
285         
286       uint256 balance = lamdenTau.balanceOf(this);
287       lamdenTau.transfer(msg.sender, balance);
288    }
289 
290 }