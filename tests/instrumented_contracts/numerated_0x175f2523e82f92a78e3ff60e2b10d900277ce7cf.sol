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
250       lamdenTau.transfer(0xF37E181Cea4A71236dADF6E6D6978b222685A3ae, 828000000000000000000);
251       lamdenTau.transfer(0x976f5AcE7Aa74e0aF12F25b6aF534c4915FC945a, 24000000000000000000);
252       lamdenTau.transfer(0x6C716B6A1d36C881c43Fa493AacD2609D52E9ce1, 84000000000000000000);
253       lamdenTau.transfer(0x8B2180c8EeBb9edFCc1F532AB8Efe51EBa6b5253, 228000000000000000000);
254       lamdenTau.transfer(0x141CF68Ad37F924Cfe7501caB5469440b96AB6e3, 600000000000000000000);
255       lamdenTau.transfer(0x4230D0704cDDd9242A0C98418138Dd068D52c8A1, 204000000000000000000);
256       lamdenTau.transfer(0xFfcD4AC9de1657aa3E229BE2e8361ED2C2aab60b, 156000000000000000000);
257       lamdenTau.transfer(0x739724bA3c5Dbb4fa6E663A68035cA4b24Edd2f5, 240000000000000000000);
258       lamdenTau.transfer(0xcB72AefCDf99F8D77BE256170e69abc0990E8CeD, 198000000000000000000);
259       lamdenTau.transfer(0x8Fd8cfEf175CeED446B2c024c1648476A7B850f5, 252000000000000000000);
260       lamdenTau.transfer(0x790622728897B6367b7A8709c5f69d3DbD105072, 120000000000000000000);
261       lamdenTau.transfer(0xfD1f27E81012f201eb4747E042D719c2623E9fbA, 972000000000000000000);
262       lamdenTau.transfer(0x5c5dE2b62678709AC81Fb6d88a71B4BAe106Dc4c, 486000000000000000000);
263       lamdenTau.transfer(0xE4321372c368cd74539c923Bc381328547e8aA09, 144000000000000000000);
264       lamdenTau.transfer(0x68Fc5e25C190A2aAe021dD91cbA8090A2845f759, 252000000000000000000);
265       lamdenTau.transfer(0x1D828851050C968bd6e3697Fc89995576017C35F, 120000000000000000000);
266       lamdenTau.transfer(0x37187CA8a37B49643057ed8E3Df9b2AE80E0252b, 228000000000000000000);
267       lamdenTau.transfer(0xA95A746424f781c4413bf34480C9Ef3630bD53A9, 144000000000000000000);
268       lamdenTau.transfer(0xE4Baa1588397D9F8b409955497c647b2edE9dEfb, 168000000000000000000);
269       lamdenTau.transfer(0x260e4a5d0a4a7f48D7a8367c3C1fbAE180a2B812, 624000000000000000000);
270       lamdenTau.transfer(0x60c4C2A46979c6AA8D3B6A34a27f95516ef4e353, 252000000000000000000);
271       lamdenTau.transfer(0xA91CeEF3A5eF473484eB3EcC804A4b5744F08008, 48000000000000000000);
272       lamdenTau.transfer(0x2Cbc78b7DB97576674cC4e442d3F4d792b43A3a9, 240000000000000000000);
273       lamdenTau.transfer(0x36e096F0F7fF02706B651d047755e3321D964909, 72000000000000000000);
274       lamdenTau.transfer(0xb214ef136446A354eE0E81EA76D7F7329Bf6E839, 276000000000000000000);
275       lamdenTau.transfer(0x9e1719aB0a58D5cA128fFeC252daA0712eEBaF91, 120000000000000000000);
276       lamdenTau.transfer(0x18A8769dF875e830BEF960E1b82729b5180461CE, 240000000000000000000);
277       lamdenTau.transfer(0xfa2a0c45f383cafb6a634e798b138ccfcdae424f, 60000000000000000000);
278       lamdenTau.transfer(0x62207baE3460215e55ff7eB464110e60b00E23b7, 72000000000000000000);
279       lamdenTau.transfer(0x0C4162f4259b3912af4965273A3a85693FC48d67, 108000000000000000000);
280       lamdenTau.transfer(0xcF385E9b7A6080a7CC768F5B0E2D5dcE593e1Eb0, 48000000000000000000);
281       lamdenTau.transfer(0x0c49d7f01E51FCC23FBFd175beDD6A571b29B27A, 96000000000000000000);
282       uint256 balance = lamdenTau.balanceOf(this);
283       lamdenTau.transfer(msg.sender, balance);
284    }
285 
286 }