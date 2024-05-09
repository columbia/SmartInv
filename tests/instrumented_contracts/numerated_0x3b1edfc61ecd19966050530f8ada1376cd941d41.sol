1 pragma solidity ^0.4.15;
2 
3 contract Owned {
4 
5     address public owner;
6 
7     function Owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function setOwner(address _newOwner) onlyOwner public {
17         owner = _newOwner;
18     }
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 
46   function toUINT112(uint256 a) internal pure returns(uint112) {
47     assert(uint112(a) == a);
48     return uint112(a);
49   }
50 
51   function toUINT120(uint256 a) internal pure returns(uint120) {
52     assert(uint120(a) == a);
53     return uint120(a);
54   }
55 
56   function toUINT128(uint256 a) internal pure returns(uint128) {
57     assert(uint128(a) == a);
58     return uint128(a);
59   }
60 }
61 
62 contract ERC20Basic {
63   uint256 public totalSupply;
64   function balanceOf(address who) public constant returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public constant returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 contract BasicToken is ERC20Basic, Owned {
77   event SetLock(bool _locked);
78   using SafeMath for uint256;
79 
80   bool locked;
81   address impl;
82   mapping(address => uint256) balances;
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(!locked);
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public constant returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110   function burn(uint256 _value) public returns (bool) {
111     require(_value <= balances[msg.sender]);
112     balances[msg.sender] -= _value;            // Subtract from the sender
113     totalSupply -= _value;                      // Updates totalSupply
114     emit Transfer(msg.sender, address(0), _value);
115     return true;
116   }
117   
118   function setLocked(bool _locked) public onlyOwner
119   {
120     locked = _locked;
121     emit SetLock(_locked);
122   }
123   
124   function getLocked() public constant returns (bool) {
125     return locked;
126   }
127   
128   function SetImpl(address _address) public onlyOwner {
129     impl = _address;
130   }
131 
132   function getImpl() public constant returns (address) {
133     return impl;
134   }
135   
136   /**
137    * for o2 exchange
138   */
139   function transferOrigin(address _to, uint256 _value) public returns (bool) {
140     require(!locked);
141     require(_to != address(0));
142     require(msg.sender == impl);
143     require(_value <= balances[tx.origin]);
144 
145     // SafeMath.sub will throw if there is not enough balance.
146     balances[tx.origin] = balances[tx.origin].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     emit Transfer(tx.origin, _to, _value);
149     return true;
150   }
151     
152 }
153 
154 contract StandardToken is ERC20, BasicToken {
155 
156   mapping (address => mapping (address => uint256)) internal allowed;
157 
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[_from]);
168     require(_value <= allowed[_from][msg.sender]);
169 
170     balances[_from] = balances[_from].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173     emit Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    *
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint256 _value) public returns (bool) {
188     require((_value == 0) || (allowed[msg.sender][_spender] == 0 ));
189     allowed[msg.sender][_spender] = _value;
190     emit Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
201     return allowed[_owner][_spender];
202   }
203 
204 }
205 
206 contract O2Token is StandardToken {
207 
208   string public constant name = "O2 Token";
209   string public constant symbol = "O2";
210   uint8 public constant decimals = 18;
211 
212 
213   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
214 
215   /**
216    * @dev Constructor that gives msg.sender all of existing tokens.
217    */
218   constructor() public {
219     locked = false;
220     setOwner(msg.sender);
221     totalSupply = INITIAL_SUPPLY;
222     balances[0xE60a38E821C2868e54Fa4388cFf6F8844E046c8C] = 1000000000 * (10 ** uint256(decimals));
223     emit Transfer(msg.sender, 0xE60a38E821C2868e54Fa4388cFf6F8844E046c8C, 1000000000 * (10 ** uint256(decimals)));
224   }
225   
226   function () public payable {        
227     msg.sender.transfer(msg.value);
228   }
229 
230 }