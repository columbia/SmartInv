1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    */
46   function renounceOwnership() public onlyOwner {
47     emit OwnershipRenounced(owner);
48     owner = address(0);
49   }
50 }
51 // ================= ERC20 Token Contract start =========================
52 /*
53  * ERC20 interface
54  * see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 {
57   uint public totalSupply;
58   function balanceOf(address who) public constant returns (uint);
59   function allowance(address owner, address spender) public constant returns (uint);
60 
61   function transfer(address to, uint value) public returns (bool status);
62   function transferFrom(address from, address to, uint value) public returns (bool status);
63   function approve(address spender, uint value) public returns (bool status);
64   event Transfer(address indexed from, address indexed to, uint value);
65   event Approval(address indexed owner, address indexed spender, uint value);
66 }
67 
68 
69 
70 
71 
72 
73 
74 contract StandardToken is ERC20{
75   
76    /*Define SafeMath library here for uint256*/
77    
78    using SafeMath for uint256; 
79        
80   /**
81   * @dev Fix for the ERC20 short address attack.
82    */
83   modifier onlyPayloadSize(uint size) {
84     require(msg.data.length >= size + 4) ;
85     _;
86   }
87 
88   mapping(address => uint) accountBalances;
89   mapping (address => mapping (address => uint)) allowed;
90 
91   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32)  returns (bool success){
92     accountBalances[msg.sender] = accountBalances[msg.sender].sub(_value);
93     accountBalances[_to] = accountBalances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) returns (bool success) {
99     uint _allowance = allowed[_from][msg.sender];
100 
101     accountBalances[_to] = accountBalances[_to].add(_value);
102     accountBalances[_from] = accountBalances[_from].sub(_value);
103     allowed[_from][msg.sender] = _allowance.sub(_value);
104     emit Transfer(_from, _to, _value);
105     return true;
106   }
107 
108   function balanceOf(address _owner) public constant returns (uint balance) {
109     return accountBalances[_owner];
110   }
111 
112   function approve(address _spender, uint _value) public returns (bool success) {
113     allowed[msg.sender][_spender] = _value;
114     emit Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
119     return allowed[_owner][_spender];
120   }
121 }
122 
123 
124 
125 /**
126  * @title SafeMath
127  * @dev Math operations with safety checks that throw on error
128  */
129 library SafeMath {
130 
131   /**
132   * @dev Multiplies two numbers, throws on overflow.
133   */
134   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
135     if (a == 0) {
136       return 0;
137     }
138     c = a * b;
139     assert(c / a == b);
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers, truncating the quotient.
145   */
146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
147     // assert(b > 0); // Solidity automatically throws when dividing by 0
148     // uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150     return a / b;
151   }
152 
153   /**
154   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
155   */
156   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157     assert(b <= a);
158     return a - b;
159   }
160 
161   /**
162   * @dev Adds two numbers, throws on overflow.
163   */
164   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
165     c = a + b;
166     assert(c >= a);
167     return c;
168   }
169 }
170 
171 
172 
173 
174 
175 
176 /**
177  * @title Pausable
178  * @dev Base contract which allows children to implement an emergency stop mechanism.
179  */
180 contract Pausable is Ownable {
181   event Pause();
182   event Unpause();
183 
184   bool public paused = false;
185 
186 
187   /**
188    * @dev Modifier to make a function callable only when the contract is not paused.
189    */
190   modifier whenNotPaused() {
191     require(!paused);
192     _;
193   }
194 
195   /**
196    * @dev Modifier to make a function callable only when the contract is paused.
197    */
198   modifier whenPaused() {
199     require(paused);
200     _;
201   }
202 
203   /**
204    * @dev called by the owner to pause, triggers stopped state
205    */
206   function pause() onlyOwner whenNotPaused public {
207     paused = true;
208     emit Pause();
209   }
210 
211   /**
212    * @dev called by the owner to unpause, returns to normal state
213    */
214   function unpause() onlyOwner whenPaused public {
215     paused = false;
216     emit Unpause();
217   }
218 }
219 
220 contract IcoToken is StandardToken, Pausable{
221     /*define SafeMath library for uint256*/
222     using SafeMath for uint256;
223     
224     string public name;
225     string public symbol;
226     string public version;
227     uint public decimals;
228     address public icoSaleDeposit;
229     address public icoContract;
230     
231     constructor(string _name, string _symbol, uint256 _decimals, string _version) public {
232         name = _name;
233         symbol = _symbol;
234         decimals = _decimals;
235         version = _version;
236     }
237     
238     function transfer(address _to, uint _value) public whenNotPaused returns (bool success) {
239         return super.transfer(_to,_value);
240     }
241     
242     function approve(address _spender, uint _value) public whenNotPaused returns (bool success) {
243         return super.approve(_spender,_value);
244     }
245     
246     function balanceOf(address _owner) public view returns (uint balance){
247         return super.balanceOf(_owner);
248     }
249     
250     function setIcoContract(address _icoContract) public onlyOwner {
251         if(_icoContract != address(0)){
252             icoContract = _icoContract;           
253         }
254     }
255     
256     function sell(address _recipient, uint256 _value) public whenNotPaused returns (bool success){
257         assert(_value > 0);
258         require(msg.sender == icoContract);
259         
260         accountBalances[_recipient] = accountBalances[_recipient].add(_value);
261         totalSupply = totalSupply.add(_value);
262         
263         emit Transfer(0x0,owner,_value);
264         emit Transfer(owner,_recipient,_value);
265         return true;
266     }
267     
268 }