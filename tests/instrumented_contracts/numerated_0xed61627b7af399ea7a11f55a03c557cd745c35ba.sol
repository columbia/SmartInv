1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     require(newOwner != address(0));
66     owner = newOwner;
67   }
68 }
69 
70 
71 
72 contract ERC20Basic {
73   uint256 public totalSupply;
74   function balanceOf(address who) constant returns (uint256);
75   function transfer(address to, uint256 value) returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 contract ERC20 is ERC20Basic {
80   function allowance(address owner, address spender) constant returns (uint256);
81   function transferFrom(address from, address to, uint256 value) returns (bool);
82   function approve(address spender, uint256 value) returns (bool);
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) balances;
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) returns (bool) {
97     // SafeMath.sub will throw if there is not enough balance.
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) constant returns (uint256 balance) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) allowed;
118 
119   /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amount of tokens to be transferred
124    */
125   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
126     var _allowance = allowed[_from][msg.sender];
127 
128     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
129     // require (_value <= _allowance);
130 
131     balances[_from] = balances[_from].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     allowed[_from][msg.sender] = _allowance.sub(_value);
134     Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    * @param _spender The address which will spend the funds.
141    * @param _value The amount of tokens to be spent.
142    */
143   function approve(address _spender, uint256 _value) returns (bool) {
144 
145     // To change the approve amount you first have to reduce the addresses`
146     //  allowance to zero by calling `approve(_spender, 0)` if it is not
147     //  already 0 to mitigate the race condition described here:
148     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
150 
151     allowed[msg.sender][_spender] = _value;
152     Approval(msg.sender, _spender, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Function to check the amount of tokens that an owner allowed to a spender.
158    * @param _owner address The address which owns the funds.
159    * @param _spender address The address which will spend the funds.
160    * @return A uint256 specifying the amount of tokens still available for the spender.
161    */
162   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
163     return allowed[_owner][_spender];
164   }
165 }
166 
167 contract BTCCToken is Ownable,StandardToken {
168 
169     uint public totalSupply = 3*10**27;
170     string public constant name = "BTCCToken";
171     string public constant symbol = "BTCC";
172     uint8 public constant decimals = 18;
173 
174     function BTCCToken() {
175         balances[msg.sender] = totalSupply;
176         Transfer(address(0), msg.sender, totalSupply);
177     }
178 
179     mapping (address => bool) stopTransfer;
180 
181     function setStopTransfer(address _to,bool stop) onlyOwner{
182         stopTransfer[_to] = stop;
183     }
184 
185     function getStopTransfer(address _to) constant public returns (bool) {
186         return stopTransfer[_to];
187     }
188 
189     function transfer(address _to, uint256 _value) public  returns (bool) {
190         require(!stopTransfer[msg.sender]);
191         bool result = super.transfer(_to, _value);
192         return result;
193     }
194 }