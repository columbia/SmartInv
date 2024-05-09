1 pragma solidity ^0.4.15;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function div(uint256 a, uint256 b) internal constant returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 contract ERC20Basic {
28   uint256 public totalSupply;
29   function balanceOf(address who) constant returns (uint256);
30   function transfer(address to, uint256 value) returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35   function allowance(address owner, address spender) constant returns (uint256);
36   function transferFrom(address from, address to, uint256 value) returns (bool);
37   function approve(address spender, uint256 value) returns (bool);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract BasicToken is ERC20Basic {
42   using SafeMath for uint256;
43 
44   mapping(address => uint256) balances;
45 
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) returns (bool) {
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   /**
59   * @dev Gets the balance of the specified address.
60   * @param _owner The address to query the the balance of.
61   * @return An uint256 representing the amount owned by the passed address.
62   */
63   function balanceOf(address _owner) constant returns (uint256 balance) {
64     return balances[_owner];
65   }
66 
67 }
68 
69 
70 contract StandardToken is ERC20, BasicToken {
71 
72   mapping (address => mapping (address => uint256)) allowed;
73 
74 
75   /**
76    * @dev Transfer tokens from one address to another
77    * @param _from address The address which you want to send tokens from
78    * @param _to address The address which you want to transfer to
79    * @param _value uint256 the amout of tokens to be transfered
80    */
81   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
82     var _allowance = allowed[_from][msg.sender];
83 
84     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
85     // require (_value <= _allowance);
86 
87     balances[_to] = balances[_to].add(_value);
88     balances[_from] = balances[_from].sub(_value);
89     allowed[_from][msg.sender] = _allowance.sub(_value);
90     Transfer(_from, _to, _value);
91     return true;
92   }
93 
94   /**
95    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
96    * @param _spender The address which will spend the funds.
97    * @param _value The amount of tokens to be spent.
98    */
99   function approve(address _spender, uint256 _value) returns (bool) {
100 
101     // To change the approve amount you first have to reduce the addresses`
102     //  allowance to zero by calling `approve(_spender, 0)` if it is not
103     //  already 0 to mitigate the race condition described here:
104     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
105     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
106 
107     allowed[msg.sender][_spender] = _value;
108     Approval(msg.sender, _spender, _value);
109     return true;
110   }
111 
112   /**
113    * @dev Function to check the amount of tokens that an owner allowed to a spender.
114    * @param _owner address The address which owns the funds.
115    * @param _spender address The address which will spend the funds.
116    * @return A uint256 specifing the amount of tokens still avaible for the spender.
117    */
118   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
119     return allowed[_owner][_spender];
120   }
121 
122 }
123 
124 
125 contract Ownable {
126   address public owner;
127 
128 
129   /**
130    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
131    * account.
132    */
133   function Ownable() {
134     owner = msg.sender;
135   }
136 
137 
138   /**
139    * @dev Throws if called by any account other than the owner.
140    */
141   modifier onlyOwner() {
142     require(msg.sender == owner);
143     _;
144   }
145 
146 
147   /**
148    * @dev Allows the current owner to transfer control of the contract to a newOwner.
149    * @param newOwner The address to transfer ownership to.
150    */
151   function transferOwnership(address newOwner) onlyOwner {
152     if (newOwner != address(0)) {
153       owner = newOwner;
154     }
155   }
156 
157 }
158 
159 contract MintableToken is StandardToken, Ownable {
160   event Mint(address indexed to, uint256 amount);
161   event MintFinished();
162 
163   bool public mintingFinished = false;
164 
165   modifier canMint() {
166     require(!mintingFinished);
167     _;
168   }
169 
170   /**
171    * @dev Function to mint tokens
172    * @param _to The address that will recieve the minted tokens.
173    * @param _amount The amount of tokens to mint.
174    * @return A boolean that indicates if the operation was successful.
175    */
176   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
177     totalSupply = totalSupply.add(_amount);
178     balances[_to] = balances[_to].add(_amount);
179     Transfer(0x0, _to, _amount);
180     Mint(_to, _amount);
181     return true;
182   }
183 
184   /**
185    * @dev Function to stop minting new tokens.
186    * @return True if the operation was successful.
187    */
188   function finishMinting() onlyOwner returns (bool) {
189     mintingFinished = true;
190     MintFinished();
191     return true;
192   }
193 }
194 
195 contract CVT2Token is MintableToken {
196 
197     uint256 constant D160 = 0x0010000000000000000000000000000000000000000;
198 
199     string public name = "Crypto Explorers CVT2 Token";
200     string public symbol = "CVT2";
201     uint256 public decimals = 0;
202 
203     // data is an array of uint256s. Each uint256 represents a transfer.
204     // The 160 LSB is the destination of the address that wants to be sent
205     // The 96 MSB is the amount of tokens that wants to be sent.
206     function multiMint(uint256[] data) public onlyOwner {
207       for (uint256 i = 0; i < data.length; i++) {
208         address addr = address(data[i] & (D160 - 1));
209         uint256 amount = data[i] / D160;
210         assert(mint(addr, amount));
211       }
212     }
213 
214 }