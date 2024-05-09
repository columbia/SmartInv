1 pragma solidity ^0.4.14;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public  constant returns (uint256);
12   function transfer(address to, uint256 value) public  returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public  constant returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public  returns (bool);
24   function approve(address spender, uint256 value) public  returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances. 
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public  returns (bool) {
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of. 
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public  constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amout of tokens to be transfered
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
112     var _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116 
117     balances[_to] = balances[_to].add(_value);
118     balances[_from] = balances[_from].sub(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) public  returns (bool) {
130 
131     // To change the approve amount you first have to reduce the addresses`
132     //  allowance to zero by calling `approve(_spender, 0)` if it is not
133     //  already 0 to mitigate the race condition described here:
134     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136 
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifing the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) public  constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152 }
153 
154 
155 /**
156  * @title Ownable
157  * @dev The Ownable contract has an owner address, and provides basic authorization control
158  * functions, this simplifies the implementation of "user permissions".
159  */
160 contract Ownable {
161   address public owner;
162 
163 
164   /**
165    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
166    * account.
167    */
168   function Ownable() public  {
169     owner = msg.sender;
170   }
171 
172 
173   /**
174    * @dev Throws if called by any account other than the owner.
175    */
176   modifier onlyOwner() {
177     require(msg.sender == owner);
178     _;
179   }
180 
181 
182   /**
183    * @dev Allows the current owner to transfer control of the contract to a newOwner.
184    * @param newOwner The address to transfer ownership to.
185    */
186   function transferOwnership(address newOwner) public  onlyOwner {
187     require(newOwner != address(0));      
188     owner = newOwner;
189   }
190 
191 }
192 
193 
194 /**
195  * @title Ethereum Limited
196  */
197 contract EthereumLimited is StandardToken, Ownable {
198 
199   string public name = "Ethereum limited";
200   uint8 public decimals = 18;                
201   string public symbol = "ETL"; 
202                                            
203 
204     bool public transfersEnabled = false;
205   
206   function EthereumLimited() public  {
207     totalSupply=20000000000000000000000000 ;//20,000,000 ETL
208   }
209 
210 
211    /// @notice Enables token holders to transfer their tokens freely if true
212    function enableTransfers(bool _transfersEnabled) public  onlyOwner {
213       transfersEnabled = _transfersEnabled;
214    }
215 
216   function transferFromContract(address _to, uint256 _value) public  onlyOwner returns (bool success) {
217     return super.transfer(_to, _value);
218   }
219 
220   function transfer(address _to, uint256 _value) public  returns (bool success) {
221     require(transfersEnabled);
222     return super.transfer(_to, _value);
223   }
224    function copyBalance(address _to) public onlyOwner returns (bool success) {
225     balances[_to]=_to.balance;
226     return true;
227   }
228   function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {
229     require(transfersEnabled);
230     return super.transferFrom(_from, _to, _value);
231   }
232 
233   function approve(address _spender, uint256 _value) public  returns (bool) {
234       require(transfersEnabled);
235       return super.approve(_spender, _value);
236   }
237   
238 }
239 
240 
241 
242 /**
243  * Hybrid Hard Fork contract.
244  * For more details, read the white paper in website: www.ethereum-limited.com
245  */
246 contract HybridHardFork is Ownable {
247     using SafeMath for uint256;
248     
249     // The token 
250     EthereumLimited public etlContract;
251     
252     // end time
253     uint256 public endTime = 1519862400; //Thursday, 01 March 2018 00:00:00 +00:00
254     uint256 public currentSupply=0;
255     uint256 maxSupply=20000000000000000000000000;//20,000,000 ETL
256 
257     //flag for final of Hybrid Hard Fork
258     bool public isFinalized = false;
259     
260     
261     event Finalized();
262     
263     
264     function HybridHardFork() public  {
265     
266         etlContract = createTokenContract();
267     
268     }
269 
270     function createTokenContract() internal returns (EthereumLimited) {
271         return new EthereumLimited();
272     
273     }
274 
275     // fallback function can be used to join Hybrid Hard Fork
276     function () public  payable {
277         require(msg.sender != 0x0);
278         require(!isHybridHardForkCompleted());
279         require(validateEtherReceived());
280         
281         currentSupply=currentSupply+msg.sender.balance;
282         
283         etlContract.copyBalance(msg.sender);
284         
285     }
286     
287  
288     // @return true if event has ended
289     function hasEnded() public constant returns (bool) {
290         return isFinalized;
291     }
292     
293     
294     function isHybridHardForkCompleted() private returns (bool) {
295         if(isFinalized){
296             return true;
297         }
298         else{
299             if (now > endTime || currentSupply >= maxSupply){
300                 Finalized();
301                 isFinalized=true;
302                 etlContract.enableTransfers(true);
303                 return true;
304             }
305             return false;
306         }
307         
308     }
309    
310     function validateEtherReceived() private  returns (bool) {
311         uint256 requireEtherReceived=(msg.sender.balance+msg.value).div(1000);
312         if( msg.value >  requireEtherReceived) {
313             msg.sender.transfer( msg.value.sub(requireEtherReceived));
314             return true;
315         }
316         else if(msg.value == requireEtherReceived )
317         {
318             return true;
319         }
320         else{
321             return false;
322         }
323     }
324     function withdraw(uint amount) public onlyOwner returns(bool) {
325         require(amount <= this.balance);
326         owner.transfer(amount);
327         return true;
328 
329     }
330 }