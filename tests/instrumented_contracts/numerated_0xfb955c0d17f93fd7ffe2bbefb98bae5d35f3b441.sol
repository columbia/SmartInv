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
250     lamdenTau.transfer(0x9beb089842e82f4d8ecf75cb5f36b461b452a93d, 2136860000000000000000);
251     lamdenTau.transfer(0x7f436de083a59aae8ac39762a3014e6d28a69bfa, 14958020000000000000000);
252     lamdenTau.transfer(0x7f436de083a59aae8ac39762a3014e6d28a69bfa, 384634800000000000000);
253     lamdenTau.transfer(0x7f436de083a59aae8ac39762a3014e6d28a69bfa, 256423200000000000000);
254     lamdenTau.transfer(0x1d4b6e4aa86d48c464c9adf83940d4e00df8affc, 4348510100000000000000);
255     lamdenTau.transfer(0x79dc4b068820508655ad6cde9d9d4aa5dd6915bd, 27779180000000000000000);
256     lamdenTau.transfer(0x9beb089842e82f4d8ecf75cb5f36b461b452a93d, 29061296000000000000000);
257     lamdenTau.transfer(0xab0cb1d483910f6013707d6d9f4842b45df125c7, 21368600000000000000000);
258     lamdenTau.transfer(0x724c104cae8c00f35b30fd577baf6d263da06bd8, 8547440000000000000000);
259     lamdenTau.transfer(0x7c0d6febb5afb1aee8ae1a45ebf92100c3696769, 31940714850000000000000);
260     lamdenTau.transfer(0xd7da4b7c0d8054e5755a811334fb223f3f5e0f23, 77995390000000000000000);
261     lamdenTau.transfer(0x69cc9ed0c0966ca0805f8cbe08bac11d0ef90963, 5342150000000000000000);
262     lamdenTau.transfer(0x7c0d6febb5afb1aee8ae1a45ebf92100c3696769, 15946755079767600000000);
263     lamdenTau.transfer(0xaaf757b3c4e6d61fdac0766b5f07fe0e3bef7092, 149580200000000000000000);
264     lamdenTau.transfer(0x69cc9ed0c0966ca0805f8cbe08bac11d0ef90963, 21368600000000000000000);
265     lamdenTau.transfer(0x30acb3594ae3e4b10475e7974d51dc2be1873825, 21368600000000000000000);
266     lamdenTau.transfer(0xa36ce14ef9e04d76800ce2844b1dca31f4235139, 4284728795012160000000);
267     lamdenTau.transfer(0x9166bc0307a6ec0a930b26699656523aff4392b5, 213686000000000000000000);
268     lamdenTau.transfer(0x30acb3594ae3e4b10475e7974d51dc2be1873825, 21368600000000000000000);
269     lamdenTau.transfer(0x3adec3914dd83885347f58c76ac194c1e19b3dbe, 21368600000000000000000);
270     lamdenTau.transfer(0x3adec3914dd83885347f58c76ac194c1e19b3dbe, 290612960000000000000000);
271     lamdenTau.transfer(0xa36ce14ef9e04d76800ce2844b1dca31f4235139, 2564232000000000000000);
272     lamdenTau.transfer(0x9731b0c8436c63cb018a9d81465ede49ecb0390e, 213686000000000000000000);
273     lamdenTau.transfer(0x949b82dfc04558bc4d3ca033a1b194915a3a3bee, 213686000000000000000000);
274     lamdenTau.transfer(0x0edd2edb158bc49ee48aa7271dc8329bbd8b3aa5, 64105800000000000000000);
275     lamdenTau.transfer(0x48a557d538231ee0a0835725bd1cd97a239cc298, 6410580000000000000000);
276     lamdenTau.transfer(0x30acb3594ae3e4b10475e7974d51dc2be1873825, 21368600000000000000000);
277     lamdenTau.transfer(0xc2953129fafe219c125fe16b14c10d18ed1efc37, 1986868155289600000000);
278     lamdenTau.transfer(0xc80fe8ef956b276fbaf507faf1555a2ae103f36f, 147393978534000000000);
279     lamdenTau.transfer(0xd5482163b7680a375409e7703a8b194e3a589e25, 6196894000000000000000);
280     lamdenTau.transfer(0xc2953129fafe219c125fe16b14c10d18ed1efc37, 83277847927067200000000);
281     lamdenTau.transfer(0x036df03d4176651b919e58fec510eda1c60a43ec, 491477800000000000000);
282     lamdenTau.transfer(0xacf141fba61e182006c80a2b170cb21190033614, 106843000000000000000000);
283     lamdenTau.transfer(0xfee34f6a86da7a059c4a6b37eb7001e7fcd05bd0, 2136860000000000000000);
284     lamdenTau.transfer(0x552cfa09a682a2f02e50be11a51bb02bfaed0139, 10684300000000000000000);
285     lamdenTau.transfer(0x552cfa09a682a2f02e50be11a51bb02bfaed0139, 33257435160840000000000);
286     lamdenTau.transfer(0x07ffad50741cb4dc0486426f58ae9b71c1bf9b33, 6410580000000000000000);
287     lamdenTau.transfer(0x4646993112b01f4ddd95987be83f0230794299ff, 3205290000000000000000);
288     lamdenTau.transfer(0xac4ad1f81aafd8f9bba53d2f525c4b85862005b1, 6410580000000000000000);
289     lamdenTau.transfer(0x3f61df4dcb879519137ecec907b1f1027f246f8c, 42737200000000000000000);
290     lamdenTau.transfer(0x4646993112b01f4ddd95987be83f0230794299ff, 49147780000000000000000);
291     lamdenTau.transfer(0x4e21795d0d5136d3893e95db7b2171bfcccc93bd, 359906628708000000000);
292     lamdenTau.transfer(0x5a792cec3bea929a50db44623407223d80347533, 277791800000000000000000);
293     lamdenTau.transfer(0xd5482163b7680a375409e7703a8b194e3a589e25, 5555836000000000000000);
294     lamdenTau.transfer(0x30acb3594ae3e4b10475e7974d51dc2be1873825, 21368600000000000000000);
295     lamdenTau.transfer(0xa783d021f9d2d852fa07ec74a9090f5956c4d29b, 41313032107360200000000);
296     lamdenTau.transfer(0xd81daa00a75970af35331c67adc08ad098d2ce91, 21411337200000000000000);
297     lamdenTau.transfer(0xec852d93806a0e5c93e506c804717530ac26bb8d, 106843000000000000000000);
298     lamdenTau.transfer(0x5bcc44d6962ad2e35b54a8d0614f6307768d8eb1, 21368600000000000000000);
299     lamdenTau.transfer(0xef27333bdc75c0d4d42e4b3948bd5743c4572a1a, 22679379327193600000000);
300 
301       uint256 balance = lamdenTau.balanceOf(this);
302       lamdenTau.transfer(msg.sender, balance);
303    }
304 
305 }