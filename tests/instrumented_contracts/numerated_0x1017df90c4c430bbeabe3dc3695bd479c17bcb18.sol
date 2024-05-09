1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() public{
48     owner = msg.sender;
49   }
50   
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58   
59   /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         require(newOwner != address(0));
65         OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67     }
68 }
69 
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/179
74  */
75 contract ERC20Basic {
76     uint256 public totalSupply;
77     function balanceOf(address who) public view returns (uint256);
78     function transfer(address to, uint256 value) public returns (bool);
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 contract BasicToken is ERC20Basic, Ownable {
83     using SafeMath for uint256;
84     mapping(address => uint256) balances;
85     bool public stopped = false;
86 
87     /**
88    * @dev Throws if stopped is false
89    */
90     modifier isRunning {
91         require(!stopped);
92         _;
93     }
94     function stop() public isRunning onlyOwner {
95         stopped = true;
96     }
97 
98     function start() public isRunning onlyOwner {
99         stopped = false;
100     }
101 
102     /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107     function transfer(address _to, uint256 _value) isRunning public returns (bool) {
108         require(_value <= balances[msg.sender]);
109 
110         // SafeMath.sub will throw if there is not enough balance.
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         Transfer(msg.sender, _to, _value);
114         return true;
115     }
116     
117     function batchTransfer(address[] _addresses, uint256[] _value) isRunning public returns (bool) {
118         for (uint256 i = 0; i < _addresses.length; i++) {
119             require(transfer(_addresses[i], _value[i]));
120         }
121         return true;
122     }
123 
124     /**
125     * @dev Gets the balance of the specified address.
126     * @param _owner The address to query the the balance of.
127     * @return An uint256 representing the amount owned by the passed address.
128     */
129     function balanceOf(address _owner) public view returns (uint256 balance) {
130         return balances[_owner];
131     }
132 }
133 
134 contract ERC20 is ERC20Basic {
135     function allowance(address owner, address spender) public view returns (uint256);
136 
137     function transferFrom(address from, address to, uint256 value) public returns (bool);
138 
139     function approve(address spender, uint256 value) public returns (bool);
140 
141     event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153     mapping(address => mapping(address => uint256)) internal allowed;
154 
155     /**
156      * @dev Transfer tokens from one address to another
157      * @param _from address The address which you want to send tokens from
158      * @param _to address The address which you want to transfer to
159      * @param _value uint256 the amount of tokens to be transferred
160      */
161     function transferFrom(address _from, address _to, uint256 _value) isRunning public returns (bool) {
162         require(_value <= balances[_from]);
163         require(_value <= allowed[_from][msg.sender]);
164 
165         balances[_from] = balances[_from].sub(_value);
166         balances[_to] = balances[_to].add(_value);
167         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168         Transfer(_from, _to, _value);
169         return true;
170     }
171 
172     /**
173      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174      *
175      * Beware that changing an allowance with this method brings the risk that someone may use both the old
176      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179      * @param _spender The address which will spend the funds.
180      * @param _value The amount of tokens to be spent.
181      */
182     function approve(address _spender, uint256 _value) isRunning public returns (bool) {
183         allowed[msg.sender][_spender] = _value;
184         Approval(msg.sender, _spender, _value);
185         return true;
186     }
187 
188     /**
189      * @dev Function to check the amount of tokens that an owner allowed to a spender.
190      * @param _owner address The address which owns the funds.
191      * @param _spender address The address which will spend the funds.
192      * @return A uint256 specifying the amount of tokens still available for the spender.
193      */
194     function allowance(address _owner, address _spender) public view returns (uint256) {
195         return allowed[_owner][_spender];
196     }
197 
198     /**
199      * approve should be called when allowed[_spender] == 0. To increment
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      */
204     function increaseApproval(address _spender, uint _addedValue) isRunning public returns (bool) {
205         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207         return true;
208     }
209 
210     function decreaseApproval(address _spender, uint _subtractedValue) isRunning public returns (bool) {
211         uint oldValue = allowed[msg.sender][_spender];
212         if (_subtractedValue > oldValue) {
213             allowed[msg.sender][_spender] = 0;
214         }
215         else {
216             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217         }
218         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219         return true;
220     }
221 }
222 
223 contract DeepCoinToken is StandardToken {
224     uint256 public totalSupply = 100000000 * 60 * 10 ** 18;  // 6, 000, 000, 000
225     string  public name = "Deepfin Coin";
226     uint8   public decimals = 18;
227     string  public symbol = 'DFC';
228     string  public version = 'v1.0';
229     function DeepCoinToken() public{
230         balances[msg.sender] = totalSupply;
231     }
232 	/**
233 	* destroy coin, cap is 5 billion
234 	*/
235     function burn(uint256 _value) onlyOwner isRunning public {
236         require(balances[0x0].add(_value) <= 100000000 * 50 * 10 ** 18);
237         transfer(0x0, _value);
238     }
239     function burnBalance() onlyOwner public view returns (uint256) {
240         uint256 burnCap = 100000000 * 50 * 10 ** 18;
241         return burnCap.sub(balances[0x0]);
242     }
243 }