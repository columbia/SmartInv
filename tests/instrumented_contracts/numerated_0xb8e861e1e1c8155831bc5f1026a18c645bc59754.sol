1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9    function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10       uint256 c = a * b;
11       assert(a == 0 || c / a == b);
12       return c;
13    }
14 
15    function div(uint256 a, uint256 b) internal constant returns (uint256) {
16       // assert(b > 0); // Solidity automatically throws when dividing by 0
17       uint256 c = a / b;
18       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19       return c;
20    }
21 
22    function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23       assert(b <= a);
24       return a - b;
25    }
26 
27    function add(uint256 a, uint256 b) internal constant returns (uint256) {
28       uint256 c = a + b;
29       assert(c >= a);
30       return c;
31    }
32 
33    function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34       return a < b ? a : b;
35    }
36 }
37 
38 /**
39  * @title ERC20 interface
40  *
41  * @dev https://github.com/ethereum/EIPs/issues/20
42  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
43  */
44 contract ERC20Token {
45 
46    uint256 public totalSupply;
47    function balanceOf(address _owner) constant returns (uint256 balance);
48    function transfer(address _to, uint256 _value) returns (bool success);
49    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
50    function approve(address _spender, uint256 _value) returns (bool success);
51    function allowance(address _owner, address _spender) constant returns (uint256 remaining);
52    event Transfer(address indexed _from, address indexed _to, uint256 _value);
53    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 
57 /**
58  * @title ERC20 implementation
59  *
60  * @dev https://github.com/ethereum/EIPs/issues/20
61  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
62  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
63  */
64 contract StandardToken is ERC20Token {
65    using SafeMath for uint256;
66 
67    mapping (address => uint256) balances;
68    mapping (address => mapping (address => uint256)) allowed;
69 
70    /**
71     * @dev gets the balance of the specified address
72     * @param _owner The address to query the balance of
73     * @return uint256 The balance of the passed address
74     */
75    function balanceOf(address _owner) constant returns (uint256 balance) {
76       return balances[_owner];
77    }
78 
79    /**
80     * @dev transfer tokens to the specified address
81     * @param _to The address to transfer to
82     * @param _value The amount to be transferred
83     * @return bool A successful transfer returns true
84     */
85    function transfer(address _to, uint256 _value) returns (bool success) {
86       require(_to != address(0));
87 
88       // SafeMath.sub will throw if there is not enough balance.
89       balances[msg.sender] = balances[msg.sender].sub(_value);
90       balances[_to] = balances[_to].add(_value);
91       Transfer(msg.sender, _to, _value);
92       return true;
93    }
94 
95    /**
96     * @dev transfer tokens from one address to another
97     * @param _from address The address that you want to send tokens from
98     * @param _to address The address that you want to transfer to
99     * @param _value uint256 The amount to be transferred
100     * @return bool A successful transfer returns true
101     */
102    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
103       require(_to != address(0));
104 
105       uint256 _allowance = allowed[_from][msg.sender];
106       balances[_from] = balances[_from].sub(_value);
107       balances[_to] = balances[_to].add(_value);
108       allowed[_from][msg.sender] = _allowance.sub(_value);
109       Transfer(_from, _to, _value);
110       return true;
111    }
112 
113    /**
114     * @dev approve the passed address to spend the specified amount of tokens
115     * @dev Note that the approved value must first be set to zero in order for it to be changed
116     * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117     * @param _spender The address that will spend the funds
118     * @param _value The amount of tokens to be spent
119     * @return bool A successful approval returns true
120     */
121    function approve(address _spender, uint256 _value) returns (bool success) {
122 
123      //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124      require((_value == 0) || (allowed[msg.sender][_spender] == 0));
125 
126      allowed[msg.sender][_spender] = _value;
127      Approval(msg.sender, _spender, _value);
128      return true;
129    }
130 
131    /**
132     * @dev gets the amount of tokens that an owner has allowed an address to spend
133     * @param _owner The address that owns the funds
134     * @param _spender The address that will spend the funds
135     * @return uint256 The amount that is available to spend
136     */
137    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
138      return allowed[_owner][_spender];
139    }
140 }
141 
142 /**
143  * @title Ownable
144  * @dev The Ownable contract has an owner address, and provides basic authorization control
145  * functions, this simplifies the implementation of "user permissions".
146  */
147 contract Ownable {
148    address public owner;
149 
150    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152    /**
153    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
154    */
155    function Ownable() {
156       owner = msg.sender;
157    }
158 
159    /**
160    * @dev Throws if called by any account other than the owner.
161    */
162    modifier onlyOwner() {
163       require(msg.sender == owner);
164       _;
165    }
166 
167    /**
168    * @dev Allows the current owner to transfer control of the contract to a newOwner.
169    * @param newOwner The address to transfer ownership to.
170    */
171    function transferOwnership(address newOwner) onlyOwner {
172       require(newOwner != address(0));
173       OwnershipTransferred(owner, newOwner);
174       owner = newOwner;
175    }
176 }
177 
178 
179 /**
180  * @title Token holder contract
181  *
182  * @dev Allow the owner to transfer any ERC20 tokens accidentally sent to the contract address
183  */
184 contract TokenHolder is Ownable {
185 
186     /**
187      * @dev transfer tokens to the specified address
188      * @param _tokenAddress The address to transfer to
189      * @param _amount The amount to be transferred
190      * @return bool A successful transfer returns true
191      */
192     function transferAnyERC20Token(address _tokenAddress, uint256 _amount) onlyOwner returns (bool success) {
193         return ERC20Token(_tokenAddress).transfer(owner, _amount);
194     }
195 }
196 
197 
198 /**
199  * @title Kudos Token
200  * @author Ben Johnson
201  *
202  * @dev ERC20 Kudos Token (KUDOS)
203  *
204  * Kudos tokens are displayed using 18 decimal places of precision.
205  *
206  * The base units of Kudos tokens are referred to as "kutoas".
207  *
208  * In Swahili, kutoa means "to give".
209  * In Finnish, kutoa means "to weave" or "to knit".
210  *
211  * 1 KUDOS is equivalent to:
212  *
213  *    1,000,000,000,000,000,000 == 1 * 10**18 == 1e18 == One Quintillion kutoas
214  *
215  *
216  * All initial KUDOS kutoas are assigned to the creator of this contract.
217  *
218  */
219 contract KudosToken is StandardToken, Ownable, TokenHolder {
220 
221    string public constant name = "Kudos";
222    string public constant symbol = "KUDOS";
223    uint8 public constant decimals = 18;
224    string public constant version = "1.0";
225 
226    uint256 public constant tokenUnit = 10 ** 18;
227    uint256 public constant oneBillion = 10 ** 9;
228    uint256 public constant maxTokens = 10 * oneBillion * tokenUnit;
229 
230    function KudosToken() {
231       totalSupply = maxTokens;
232       balances[msg.sender] = maxTokens;
233    }
234 }