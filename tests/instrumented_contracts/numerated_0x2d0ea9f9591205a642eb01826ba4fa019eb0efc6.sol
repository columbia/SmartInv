1 pragma  solidity ^0.4.24;
2 
3 //0x2d0Ea9F9591205A642eb01826Ba4Fa019eB0efc6 token address
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public constant returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 /**
48  * @title Basic token
49  * @dev Basic version of StandardToken, with no allowances.
50  */
51 contract BasicToken is ERC20Basic {
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55 
56   /**
57   * @dev transfer token for a specified address
58   * @param _to The address to transfer to.
59   * @param _value The amount to be transferred.
60   */
61   function transfer(address _to, uint256 _value) public returns (bool) {
62     require(_to != address(0));
63     require(_value <= balances[msg.sender]);
64 
65     // SafeMath.sub will throw if there is not enough balance.
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   /**
73   * @dev Gets the balance of the specified address.
74   * @param _owner The address to query the the balance of.
75   * @return An uint256 representing the amount owned by the passed address.
76   */
77   function balanceOf(address _owner) public constant returns (uint256 balance) {
78     return balances[_owner];
79   }
80 
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public constant returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) internal allowed;
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amount of tokens to be transferred
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    *
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * approve should be called when allowed[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    */
156   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
157     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
163     uint oldValue = allowed[msg.sender][_spender];
164     if (_subtractedValue > oldValue) {
165       allowed[msg.sender][_spender] = 0;
166     } else {
167       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168     }
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173 }
174 
175 /**
176  * @title Ownable
177  * @dev The Ownable contract has an owner address, and provides basic authorization control
178  * functions, this simplifies the implementation of "user permissions".
179  */
180 contract Ownable {
181   address public owner;
182 
183 
184   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186 
187   /**
188    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189    * account.
190    */
191   function Ownable() {
192     owner = msg.sender;
193   }
194 
195 
196   /**
197    * @dev Throws if called by any account other than the owner.
198    */
199   modifier onlyOwner() {
200     require(msg.sender == owner);
201     _;
202   }
203 
204 
205   /**
206    * @dev Allows the current owner to transfer control of the contract to a newOwner.
207    * @param newOwner The address to transfer ownership to.
208    */
209   function transferOwnership(address newOwner) onlyOwner public {
210     require(newOwner != address(0));
211     OwnershipTransferred(owner, newOwner);
212     owner = newOwner;
213   }
214 
215 }
216 
217 contract BBTToken is StandardToken, Ownable {
218     string constant public name = "Bao Bao Token";
219     string constant public symbol = "BBT";
220     uint8 constant public decimals = 18;
221     //bool public isLocked = true;
222 
223     function BBTToken(address chachawallet) {
224         totalSupply = 1 * 10 ** (8+18);
225         balances[chachawallet] = totalSupply;
226     }
227 
228     //modifier illegalWhenLocked() {
229     //    require(!isLocked || msg.sender == owner);
230     //    _;
231     //}
232 
233      //should be called by crowdSale when crowdSale is finished
234     //function unlock() onlyOwner public{
235     //    isLocked = true;
236     //}
237 
238     function transfer(address _to, uint256 _value)public returns (bool){
239         return super.transfer(_to, _value);
240     }
241 
242     function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
243         return super.transferFrom(_from, _to, _value);
244     }
245 }