1 pragma solidity ^0.4.15;
2 
3 contract AccessControlled {
4   address public owner = msg.sender;
5   
6   /**
7    * @dev Throws if called by any account other than the argument. 
8    */
9   modifier onlyBy(address _account)
10   {
11     require(msg.sender == _account);
12     _;
13   }
14   
15   /**
16    * @dev Throws if called by any account other than either of the two arguments. 
17    */
18   modifier onlyByOr(address _account1, address _account2)
19   {
20     require(msg.sender == _account1 || msg.sender == _account2);
21     _;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner. 
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 }
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal constant returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 contract TarynToken is AccessControlled {
58   using SafeMath for uint256;
59 
60   string public constant name     = "TarynToken";
61   string public constant symbol   = "TA";
62   uint8  public constant decimals = 18;
63   
64   uint256 public constant INITIAL_SUPPLY = 0;
65   uint256 public totalSupply;
66 
67   mapping(address => uint256) balances;
68   mapping(uint256 => address) public addresses;
69   mapping(address => uint256) public indexes;
70   //index starts at 1 so that first item has index of 1, which differentiates
71   //it from non-existing items with values of 0. 
72   uint public index = 1;
73   
74   /**
75    * @dev Contructor that gives msg.sender all of existing tokens. FIXME: this is simply for initial testing.
76    */
77   function TarynToken() public {
78     totalSupply = INITIAL_SUPPLY;
79   }
80   
81   event Mint(address indexed to, uint256 amount);
82 
83   function mint(address _to, uint256 _amount) onlyOwner public returns (bool){
84     totalSupply = totalSupply.add(_amount);
85     balances[_to] = balances[_to].add(_amount);
86     addToAddresses(_to);
87     Mint(_to, _amount);
88     return true;
89   }
90   
91   function addToAddresses(address _address) private {
92       if (indexes[_address] == 0) {
93         addresses[index] = _address;
94         indexes[_address] = index;
95         index++;
96      }
97   }
98   
99   event Distribute(address owner, uint256 balance, uint256 value, uint ind);
100 
101   function distribute() payable public returns(bool){
102    for (uint i = 1; i < index; i++) {
103      uint256 balance = balances[addresses[i]];
104      uint256 giveAmount = balance.mul(msg.value).div(totalSupply);
105      Distribute(addresses[i], balance, giveAmount, i);
106      addresses[i].transfer(giveAmount);
107    }
108    return true;
109   }
110   
111   function isRegistered(address _address) private constant returns (bool) {
112       return (indexes[_address] != 0);
113   }
114   // Basics
115 
116   /**
117    * @dev transfer token for a specified address
118    * @param _to The address to transfer to.
119    * @param _value The amount to be transferred.
120    */
121   function transfer(address _to, uint256 _value) public returns (bool) {
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     Transfer(msg.sender, _to, _value);
125     addToAddresses(_to);
126     return true;
127   }
128   
129 
130   event Transfer(address indexed from, address indexed to, uint256 value);
131   
132   /**
133    * @dev Gets the balance of the specified address.
134    * @param _owner The address to query the the balance of. 
135    * @return An uint256 representing the amount owned by the passed address.
136    */
137   function balanceOf(address _owner) public constant returns (uint256 balance) {
138     return balances[_owner];
139   }
140 
141   
142   // Allowances
143 
144   mapping (address => mapping (address => uint256)) allowed;
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
153     var _allowance = allowed[_from][msg.sender];
154   
155     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
156     // require (_value <= _allowance);
157   
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = _allowance.sub(_value);
161     Transfer(_from, _to, _value);
162     return true;
163   }
164   
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * @param _spender The address which will spend the funds.
168    * @param _value The amount of tokens to be spent.
169    */
170   function approve(address _spender, uint256 _value) public returns (bool) {
171   
172     // To change the approve amount you first have to reduce the addresses`
173     //  allowance to zero by calling `approve(_spender, 0)` if it is not
174     //  already 0 to mitigate the race condition described here:
175     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
177   
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182   
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
190     return allowed[_owner][_spender];
191   }
192   
193     /*
194      * approve should be called when allowed[_spender] == 0. To increment
195      * allowed value is better to use this function to avoid 2 calls (and wait until 
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      */
199   function increaseApproval (address _spender, uint _addedValue) 
200     public
201     returns (bool success) {
202     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206   
207   function decreaseApproval (address _spender, uint _subtractedValue) 
208     public
209     returns (bool success) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219   
220   event Approval(address indexed owner, address indexed spender, uint256 value);
221 }