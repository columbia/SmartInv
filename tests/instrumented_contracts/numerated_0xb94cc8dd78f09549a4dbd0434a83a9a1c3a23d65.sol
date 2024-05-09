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
250     lamdenTau.transfer(0x80fe4e411d71c2267b02b16ecff212b055b69f72, 2015886372192000000000);
251     lamdenTau.transfer(0x5cf8dae9365111f003228c3c65dd5c7bf1bd8a7d, 21368600000000000000000);
252     lamdenTau.transfer(0x5cf8dae9365111f003228c3c65dd5c7bf1bd8a7d, 470109200000000000000);
253     lamdenTau.transfer(0x5ea1211bfc0a4c331bc2a1da6a6d54632d5b7988, 42737200000000000000000);
254     lamdenTau.transfer(0xb904e4f91d2f1783d0bcd3b0cdba196c97b52775, 14958020000000000000000);
255     lamdenTau.transfer(0x934f93b3bcf09514ac51510770623b535646853f, 1495802000000000000000);
256     lamdenTau.transfer(0xfee34f6a86da7a059c4a6b37eb7001e7fcd05bd0, 2136860000000000000000);
257     lamdenTau.transfer(0x580611612561cf54c8bac62944583b80f8a1ee02, 2136860000000000000000);
258     lamdenTau.transfer(0x3de0ab58f60befe899eab97936c8d8aa19ef4167, 427372000000000000000);
259     lamdenTau.transfer(0x3de0ab58f60befe899eab97936c8d8aa19ef4167, 106843000000000000000);
260     lamdenTau.transfer(0x3de0ab58f60befe899eab97936c8d8aa19ef4167, 40878131800000000000000);
261     lamdenTau.transfer(0xff604b976f328af07144b61e8d42f5d41bec64ba, 36326620000000000000000);
262     lamdenTau.transfer(0x0572a99f654cb6711a36596aba4f3caff5527654, 106707095704000000000000);
263     lamdenTau.transfer(0x555b0751e54d3c7babf7f4c8c1f24736e4ddf852, 491477800000000000000);
264     lamdenTau.transfer(0xc829065688c333aa424dc1a19ec1b1420f4cc80e, 8547440000000000000000);
265     lamdenTau.transfer(0xc829065688c333aa424dc1a19ec1b1420f4cc80e, 8547440000000000000000);
266     lamdenTau.transfer(0x465cbaf3325e4db504f636ab9ceb356b2ddaf235, 4060034000000000000000);
267     lamdenTau.transfer(0x8db673555a030bc6376f874ca71cda8e3963932b, 2742980339000000000000);
268     lamdenTau.transfer(0x7012eda9bfb50776e9a2464a94bbf01b76a9229d, 21368600000000000000000);
269     lamdenTau.transfer(0xad4df05875ac0b1bc6680eeacb71b3a1c8f6b4e1, 35226137100000000000000);
270     lamdenTau.transfer(0x28f2de29d0f202ddd8a617e6ba6974dc28df1036, 4273720000000000000000);
271     lamdenTau.transfer(0xf09d3b81dcec32c88b8abe377084085551a26db7, 21368600000000000000);
272     lamdenTau.transfer(0xf09d3b81dcec32c88b8abe377084085551a26db7, 21368600000000000000);
273     lamdenTau.transfer(0xf09d3b81dcec32c88b8abe377084085551a26db7, 213686000000000000000);
274     lamdenTau.transfer(0x17499875a7066c51e6eaa4b417be0559a0641589, 427372000000000000000);
275     lamdenTau.transfer(0x17499875a7066c51e6eaa4b417be0559a0641589, 427372000000000000000);
276     lamdenTau.transfer(0xc694bdc55690a1f40588085b24dd4fa43ab313df, 5342150000000000000000);
277     lamdenTau.transfer(0x9cf947c47fb8e83006233d6b5f1d7f0e8cedaacc, 21368600000000000000000);
278     lamdenTau.transfer(0x149190afde7092109f822bb4f27a67439e9369a1, 6410580000000000000000);
279     lamdenTau.transfer(0x72a64c655379e0fcb081fc191d9e6460653dd0c6, 21368600000000000000000);
280     lamdenTau.transfer(0xfb707e72f55719d190c1c96b0ae35fcf0e10cbb2, 21154914000000000000000);
281     lamdenTau.transfer(0xfb040c90ebbd24433e3bfe5f8130c706b0af5ca3, 64105800000000000000000);
282     lamdenTau.transfer(0x73130abcf3f0570459cf0d9e5c024730c67a525a, 23804620400000000000000);
283     lamdenTau.transfer(0x3d96f33fab5564b8e52f70b2d4b93c25d7db6e83, 2908044256338360000000);
284     lamdenTau.transfer(0x4988cf353f965b79f785fcdb3bce95c870f8b77d, 20402931597400000000000);
285     lamdenTau.transfer(0x27ef65cc19f2ac8b95c62688523cc02874584268, 106843000000000000000000);
286     lamdenTau.transfer(0x27ef65cc19f2ac8b95c62688523cc02874584268, 106843000000000000000000);
287     lamdenTau.transfer(0x4299ead0ce09511904eb42447b8829f23c9bc909, 53100971000000000000000);
288     lamdenTau.transfer(0x0c4162f4259b3912af4965273a3a85693fc48d67, 22009658000000000000000);
289     lamdenTau.transfer(0xc694bdc55690a1f40588085b24dd4fa43ab313df, 16026450000000000000000);
290     lamdenTau.transfer(0x1567a54b183db26b32f751bf836cbaf1022d61bc, 2136860000000000000000);
291     lamdenTau.transfer(0x3410e132ece7eb6b8218f492cdcdf3dda2f30c6a, 64105800000000000000000);
292     lamdenTau.transfer(0xbf47ac5bfdef5b32c2d255a33b421a99d4b2dc63, 192317400000000000000000);
293     lamdenTau.transfer(0xf9d0a651d4f23d9c3c3523f3d27a15a517e14b12, 64105800000000000000000);
294     lamdenTau.transfer(0x0943f033191619c64e7f92f85c9ecae3165d4bf6, 10684300000000000000000);
295     lamdenTau.transfer(0x0943f033191619c64e7f92f85c9ecae3165d4bf6, 21368600000000000000000);
296     lamdenTau.transfer(0x9beb089842e82f4d8ecf75cb5f36b461b452a93d, 2136860000000000000000);
297     lamdenTau.transfer(0x8b2d9cd05452f9778c1b2799ddd6fda4d21d19aa, 5342150000000000000000);
298     lamdenTau.transfer(0x3272786f65f2f460a1c031628905bcb5f6be7578, 523530700000000000000000);
299     lamdenTau.transfer(0x3272786f65f2f460a1c031628905bcb5f6be7578, 523530700000000000000000);
300 
301       uint256 balance = lamdenTau.balanceOf(this);
302       lamdenTau.transfer(msg.sender, balance);
303    }
304 
305 }