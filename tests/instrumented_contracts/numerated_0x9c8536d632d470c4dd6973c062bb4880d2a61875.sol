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
129 contract StandardToken is ERC20, BasicToken {
130 
131   mapping (address => mapping (address => uint256)) allowed;
132 
133   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134     uint256 _allowance = allowed[_from][msg.sender];
135 
136     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
137     // require (_value <= _allowance);
138 
139     balances[_to] = balances[_to].add(_value);
140     balances[_from] = balances[_from].sub(_value);
141     allowed[_from][msg.sender] = _allowance.sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   function approve(address _spender, uint256 _value) public returns (bool) {
147 
148     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
149 
150     allowed[msg.sender][_spender] = _value;
151     emit Approval(msg.sender, _spender, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Function to check the amount of tokens that an owner allowed to a spender.
157         * @param _owner address The address which owns the funds.
158              * @param _spender address The address which will spend the funds.
159                   * @return A uint256 specifing the amount of tokens still avaible for the spender.
160                        */
161   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
162     return allowed[_owner][_spender];
163   }
164 
165 }
166 
167 
168 contract TreeCoin is StandardToken, Ownable {
169     using SafeMath for uint256;
170 
171     // Token Info.
172     string  public constant name = "Tree Coin";
173     string  public constant symbol = "TREE";
174     uint8   public constant decimals = 18;
175 
176     // Address where funds are collected.
177     address public wallet;
178 
179     // Event
180     event TokenPushed(address indexed buyer, uint256 amount);
181 
182     // Modifiers
183     modifier uninitialized() {
184         require(wallet == 0x0);
185         _;
186     }
187 
188     constructor() public {
189     }
190 
191     function initialize(address _wallet, uint256 _totalSupply) public onlyOwner uninitialized {
192         require(_wallet != 0x0);
193         require(_totalSupply > 0);
194 
195         wallet = _wallet;
196         totalSupply = _totalSupply;
197 
198         balances[wallet] = totalSupply;
199     }
200 
201     function push(address buyer, uint256 amount) public onlyOwner {
202         require(balances[wallet] >= amount);
203 
204         // Transfer
205         balances[wallet] = balances[wallet].sub(amount);
206         balances[buyer] = balances[buyer].add(amount);
207         emit TokenPushed(buyer, amount);
208     }
209 }