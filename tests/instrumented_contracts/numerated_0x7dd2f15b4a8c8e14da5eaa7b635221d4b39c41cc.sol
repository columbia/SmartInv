1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5     * @dev Math operations with safety checks that throw on error
6        */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35     * @dev The Ownable contract has an owner address, and provides basic authorization control
36        * functions, this simplifies the implementation of "user permissions".
37           */
38 contract Ownable {
39   address public owner;
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44         * account.
45              */
46   constructor() public {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53         */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62         * @param newOwner The address to transfer ownership to.
63              */
64   function transferOwnership(address newOwner) public onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 
70 }
71 
72 
73 /**
74  * @title ERC20Basic
75     * @dev Simpler version of ERC20 interface
76        * @dev see https://github.com/ethereum/EIPs/issues/179
77           */
78 contract ERC20Basic {
79   uint256 public totalSupply;
80   function balanceOf(address who) constant public returns (uint256);
81   function transfer(address to, uint256 value) public returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 /**
86  * @title Basic token
87     * @dev Basic version of StandardToken, with no allowances.
88        */
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   /**
95   * @dev transfer token for a specified address
96       * @param _to The address to transfer to.
97           * @param _value The amount to be transferred.
98               */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     emit Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108       * @param _owner The address to query the the balance of.
109           * @return An uint256 representing the amount owned by the passed address.
110               */
111   function balanceOf(address _owner) constant public returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 
118 /**
119  * @title ERC20 interface
120     * @dev see https://github.com/ethereum/EIPs/issues/20
121        */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender) constant public returns (uint256);
124   function transferFrom(address from, address to, uint256 value) public returns (bool);
125   function approve(address spender, uint256 value) public returns (bool);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 /**
130  * @title Standard ERC20 token
131     *
132       * @dev Implementation of the basic standard token.
133          * @dev https://github.com/ethereum/EIPs/issues/20
134             * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135                */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143         * @param _from address The address which you want to send tokens from
144              * @param _to address The address which you want to transfer to
145                   * @param _value uint256 the amout of tokens to be transfered
146                        */
147   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148     uint256 _allowance = allowed[_from][msg.sender];
149 
150     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
151     // require (_value <= _allowance);
152 
153     balances[_to] = balances[_to].add(_value);
154     balances[_from] = balances[_from].sub(_value);
155     allowed[_from][msg.sender] = _allowance.sub(_value);
156     emit Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
162         * @param _spender The address which will spend the funds.
163              * @param _value The amount of tokens to be spent.
164                   */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166 
167     // To change the approve amount you first have to reduce the addresses`
168     //  allowance to zero by calling `approve(_spender, 0)` if it is not
169     //  already 0 to mitigate the race condition described here:
170     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
172 
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180         * @param _owner address The address which owns the funds.
181              * @param _spender address The address which will spend the funds.
182                   * @return A uint256 specifing the amount of tokens still avaible for the spender.
183                        */
184   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
185     return allowed[_owner][_spender];
186   }
187 
188 }
189 
190 
191 contract TreeCoin is StandardToken, Ownable {
192     using SafeMath for uint256;
193 
194     // Token Info.
195     string  public constant name = "Tree Coin";
196     string  public constant symbol = "TRC";
197     uint8   public constant decimals = 18;
198 
199     // Address where funds are collected.
200     address public wallet;
201 
202     // Event
203     event TokenPushed(address indexed buyer, uint256 amount);
204 
205     // Modifiers
206     modifier uninitialized() {
207         require(wallet == 0x0);
208         _;
209     }
210 
211     constructor() public {
212     }
213 
214     function initialize(address _wallet, uint256 _totalSupply) public onlyOwner uninitialized {
215         require(_wallet != 0x0);
216         require(_totalSupply > 0);
217 
218         wallet = _wallet;
219         totalSupply = _totalSupply;
220 
221         balances[wallet] = totalSupply;
222     }
223 
224     function push(address buyer, uint256 amount) public onlyOwner {
225         require(balances[wallet] >= amount);
226 
227         // Transfer
228         balances[wallet] = balances[wallet].sub(amount);
229         balances[buyer] = balances[buyer].add(amount);
230         emit TokenPushed(buyer, amount);
231     }
232 }