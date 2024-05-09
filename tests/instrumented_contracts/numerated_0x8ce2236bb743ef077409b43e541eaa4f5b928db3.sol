1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20Basic {
10   uint public totalSupply;
11   function balanceOf(address who) constant returns (uint);
12   function transfer(address to, uint value);
13   event Transfer(address indexed from, address indexed to, uint value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   bool public isERC20 = true;
22 
23   function allowance(address owner, address spender) constant returns (uint);
24   function transferFrom(address from, address to, uint value);
25   function approve(address spender, uint value);
26   event Approval(address indexed owner, address indexed spender, uint value);
27 }
28 
29 
30 
31 /**
32  * Math operations with safety checks
33  */
34 library SafeMath {
35   function mul(uint a, uint b) internal returns (uint) {
36     uint c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint a, uint b) internal returns (uint) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint a, uint b) internal returns (uint) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint a, uint b) internal returns (uint) {
54     uint c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 
59   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
60     return a >= b ? a : b;
61   }
62 
63   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
64     return a < b ? a : b;
65   }
66 
67   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
68     return a >= b ? a : b;
69   }
70 
71   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
72     return a < b ? a : b;
73   }
74 
75   function assert(bool assertion) internal {
76     if (!assertion) {
77       throw;
78     }
79   }
80 }
81 
82 
83 /**
84  * @title Basic token
85  * @dev Basic version of StandardToken, with no allowances. 
86  */
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint;
89 
90   mapping(address => uint) balances;
91 
92   /**
93    * @dev Fix for the ERC20 short address attack.
94    */
95   modifier onlyPayloadSize(uint size) {
96      if(msg.data.length < size + 4) {
97        throw;
98      }
99      _;
100   }
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     Transfer(msg.sender, _to, _value);
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of. 
116   * @return An uint representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) constant returns (uint balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implemantation of the basic standart token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is BasicToken, ERC20 {
133 
134   mapping (address => mapping (address => uint)) allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint the amout of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
144     var _allowance = allowed[_from][msg.sender];
145 
146     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
147     // if (_value > _allowance) throw;
148 
149     balances[_to] = balances[_to].add(_value);
150     balances[_from] = balances[_from].sub(_value);
151     allowed[_from][msg.sender] = _allowance.sub(_value);
152     Transfer(_from, _to, _value);
153   }
154 
155   /**
156    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint _value) {
161 
162     // To change the approve amount you first have to reduce the addresses`
163     //  allowance to zero by calling `approve(_spender, 0)` if it is not
164     //  already 0 to mitigate the race condition described here:
165     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
167 
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens than an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint specifing the amount of tokens still avaible for the spender.
177    */
178   function allowance(address _owner, address _spender) constant returns (uint remaining) {
179     return allowed[_owner][_spender];
180   }
181 
182 }
183 
184 
185 
186 contract BunToken is StandardToken {
187     string public constant NAME = "BunToken";
188     string public constant SYMBOL = "BUN";
189     uint public constant DECIMALS = 18;
190 
191   
192 
193     /// This is where we hold ETH during this token sale. We will not transfer any Ether
194     /// out of this address before we invocate the `close` function to finalize the sale. 
195     /// This promise is not guanranteed by smart contract by can be verified with public
196     /// Ethereum transactions data available on several blockchain browsers.
197     /// This is the only address from which `start` and `close` can be invocated.
198     ///
199     /// Note: this will be initialized during the contract deployment.
200     address public target;
201 
202     /*
203      * MODIFIERS
204      */
205 
206     modifier onlyOwner {
207         if (target == msg.sender) {
208             _;
209         } else {
210            // InvalidCaller(msg.sender);
211             throw;
212         }
213     }
214 
215 
216     /**
217      * CONSTRUCTOR 
218      * 
219      * @dev Initialize the BUN Token
220      * @param _target The escrow account address, all ethers will
221      * be sent to this address.
222      * This address will be : 0x04485eb766dd6c9409503dd8f91186340c0526ba
223      *
224      * Pre-sale of BUN will coming soon.
225      *
226      */
227     function BunToken(address _target) {
228         target = _target;
229         totalSupply = 10 ** 28;
230         balances[target] = totalSupply;
231     }
232 
233   
234 
235     /// sending ether to this smart contract to fund Bun studio.
236     function () payable {
237        //Thank for your donation
238        target.send(msg.value);
239     }
240     
241     // withdraw Other ERC20
242     function withdrawOtherERC20Balance(uint256 amount, address _address) external onlyOwner {
243     		require(_address != address(this));
244         BasicToken candidateContract = BasicToken(_address);
245         uint256 realTotal = candidateContract.balanceOf(this);
246         require( realTotal >= amount );
247         candidateContract.transfer(target, amount);
248     }
249 
250    
251 
252 }