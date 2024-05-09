1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal constant returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   uint256 public totalSupply;
79   function balanceOf(address who) constant returns (uint256);
80   function transfer(address to, uint256 value) returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) returns (bool) {
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) constant returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) constant returns (uint256);
122   function transferFrom(address from, address to, uint256 value) returns (bool);
123   function approve(address spender, uint256 value) returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 
128  contract StandardToken is ERC20, BasicToken {
129 
130    mapping (address => mapping (address => uint256)) allowed;
131 
132 
133    /**
134     * @dev Transfer tokens from one address to another
135     * @param _from address The address which you want to send tokens from
136     * @param _to address The address which you want to transfer to
137     * @param _value uint256 the amout of tokens to be transfered
138     */
139    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
140      var _allowance = allowed[_from][msg.sender];
141 
142      // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
143      // require (_value <= _allowance);
144 
145      balances[_to] = balances[_to].add(_value);
146      balances[_from] = balances[_from].sub(_value);
147      allowed[_from][msg.sender] = _allowance.sub(_value);
148      Transfer(_from, _to, _value);
149      return true;
150    }
151 
152    /**
153     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
154     * @param _spender The address which will spend the funds.
155     * @param _value The amount of tokens to be spent.
156     */
157    function approve(address _spender, uint256 _value) returns (bool) {
158 
159      // To change the approve amount you first have to reduce the addresses`
160      //  allowance to zero by calling `approve(_spender, 0)` if it is not
161      //  already 0 to mitigate the race condition described here:
162      //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      require((_value == 0) || (allowed[msg.sender][_spender] == 0));
164 
165      allowed[msg.sender][_spender] = _value;
166      Approval(msg.sender, _spender, _value);
167      return true;
168    }
169 
170    /**
171     * @dev Function to check the amount of tokens that an owner allowed to a spender.
172     * @param _owner address The address which owns the funds.
173     * @param _spender address The address which will spend the funds.
174     * @return A uint256 specifing the amount of tokens still avaible for the spender.
175     */
176    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
177      return allowed[_owner][_spender];
178    }
179 
180  }
181 
182 contract MintableToken is StandardToken, Ownable {
183   event MintFinished();
184 
185   bool public mintingFinished = false;
186 
187 
188   modifier canMint() {
189     require(!mintingFinished);
190     _;
191   }
192 
193   /**
194    * @dev Function to mint tokens
195    * @param _to The address that will recieve the minted tokens.
196    * @param _amount The amount of tokens to mint.
197    * @return A boolean that indicates if the operation was successful.
198    */
199   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
200     require(totalSupply.add(_amount) <= 21000000 * 1 ether);
201     totalSupply = totalSupply.add(_amount);
202     balances[_to] = balances[_to].add(_amount);
203     Transfer(0X0, _to, _amount);
204     return true;
205   }
206 
207   /**
208    * @dev Function to stop minting new tokens.
209    * @return True if the operation was successful.
210    */
211   function finishMinting() onlyOwner returns (bool) {
212     mintingFinished = true;
213     MintFinished();
214     return true;
215   }
216 }
217 
218 contract HotExchangeCoin is MintableToken {
219   string public name = "HotExchangeCoin";
220   string public symbol = "HTEC";
221   uint256 public decimals = 18;
222 
223   /**
224    * @dev Allows anyone to transfer the tokens
225    * @param _to the recipient address of the tokens.
226    * @param _value number of tokens to be transfered.
227    */
228   function transfer(address _to, uint _value) returns (bool){
229     return super.transfer(_to, _value);
230   }
231 
232   /**
233    * @dev Allows anyone to transfer the tokens
234    * @param _from address The address which you want to send tokens from
235    * @param _to address The address which you want to transfer to
236    * @param _value uint the amout of tokens to be transfered
237    */
238   function transferFrom(address _from, address _to, uint _value) returns (bool){
239     return super.transferFrom(_from, _to, _value);
240   }
241 }