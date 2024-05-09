1 pragma solidity 0.4.25;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a); 
33     return a - b; 
34   } 
35   
36   function add(uint256 a, uint256 b) internal pure returns (uint256) { 
37     uint256 c = a + b; assert(c >= a);
38     return c;
39   }
40 
41 }
42 
43 /**
44  * @title Basic token
45  * @dev Basic version of StandardToken, with no allowances.
46  */
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   /**
53   * @dev transfer token for a specified address
54   * @param _to The address to transfer to.
55   * @param _value The amount to be transferred.
56   */
57   function transfer(address _to, uint256 _value)  public returns (bool) {
58     require(_to != address(0));
59     require(_value <= balances[msg.sender]); 
60     // SafeMath.sub will throw if there is not enough balance. 
61     balances[msg.sender] = balances[msg.sender].sub(_value); 
62     balances[_to] = balances[_to].add(_value); 
63     emit Transfer(msg.sender, _to, _value); 
64     
65     return true; 
66   } 
67 
68   /** 
69    * @dev Gets the balance of the specified address. 
70    * @param _owner The address to query the the balance of. 
71    * @return An uint256 representing the amount owned by the passed address. 
72    */ 
73   function balanceOf(address _owner) public constant returns (uint256 balance) { 
74     return balances[_owner]; 
75   }
76 } 
77 
78 /** 
79  * @title Standard ERC20 token 
80  * 
81  * @dev Implementation of the basic standard token. 
82  * @dev https://github.com/ethereum/EIPs/issues/20 
83  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
84  */ 
85 contract StandardToken is ERC20, BasicToken {
86 
87   mapping (address => mapping (address => uint256)) internal allowed;
88 
89   /**
90    * @dev Transfer tokens from one address to another
91    * @param _from address The address which you want to send tokens from
92    * @param _to address The address which you want to transfer to
93    * @param _value uint256 the amount of tokens to be transferred
94    */
95   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[_from]);
98     require(_value <= allowed[_from][msg.sender]); 
99     balances[_from] = balances[_from].sub(_value); 
100     balances[_to] = balances[_to].add(_value); 
101     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
102     emit Transfer(_from, _to, _value); 
103     
104     return true; 
105   } 
106 
107  /** 
108   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
109   * 
110   * Beware that changing an allowance with this method brings the risk that someone may use both the old 
111   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
112   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
113   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
114   * @param _spender The address which will spend the funds. 
115   * @param _value The amount of tokens to be spent. 
116   */ 
117   function approve(address _spender, uint256 _value) public returns (bool) { 
118     allowed[msg.sender][_spender] = _value; 
119     emit Approval(msg.sender, _spender, _value); 
120     return true; 
121   }
122 
123  /** 
124   * @dev Function to check the amount of tokens that an owner allowed to a spender. 
125   * @param _owner address The address which owns the funds. 
126   * @param _spender address The address which will spend the funds. 
127   * @return A uint256 specifying the amount of tokens still available for the spender. 
128   */ 
129   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { 
130     return allowed[_owner][_spender]; 
131   } 
132 
133  /** 
134   * approve should be called when allowed[_spender] == 0. To increment 
135   * allowed value is better to use this function to avoid 2 calls (and wait until 
136   * the first transaction is mined) * From MonolithDAO Token.sol 
137   */ 
138   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
139     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
140     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
141     return true; 
142   }
143 
144   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
145     uint oldValue = allowed[msg.sender][_spender]; 
146     if (_subtractedValue > oldValue) {
147       allowed[msg.sender][_spender] = 0;
148     } else {
149       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
150     }
151     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152     return true;
153   }
154 
155   function () public payable {
156     ///revert();
157   }
158 
159 }
160 
161 /**
162  * @title Ownable
163  * @dev The Ownable contract has an owner address, and provides basic authorization control
164  * functions, this simplifies the implementation of "user permissions".
165  */
166 contract Ownable {
167   address public owner;
168 
169   /**
170    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
171    * account.
172    */
173   constructor() public {
174     owner = msg.sender;
175   }
176   
177   /**
178    * @dev Throws if called by any account other than the owner.
179    */
180   modifier onlyOwner() {
181     require(msg.sender == owner);
182     _;
183   }
184   
185 }
186 
187 
188 contract GoodPriceToken is StandardToken, Ownable {
189     
190     string public constant name = "GoodPrice";
191     string public constant symbol = "GPS";
192     uint32 public constant decimals = 18;
193     
194     uint256 public constant totalSupply = 300000000 * (10 ** 18);
195     
196     constructor(address [] _holders, uint256 [] _tokens) public {
197         uint256 total = 0;
198         for(uint i=0; i<_holders.length; ++i) {
199             balances[_holders[i]] = _tokens[i];
200             total += _tokens[i];
201             emit Transfer(address(this), _holders[i], _tokens[i]);
202         }
203         require(total == totalSupply);
204     }
205     
206     function transferSale(address addr, uint256 tokens) public onlyOwner {
207         require(addr != address(0));
208         require(balances[address(this)] >= tokens);
209         
210         balances[addr] = balances[addr].add(tokens);
211         balances[address(this)] = balances[address(this)].sub(tokens);
212         emit Transfer(address(this), addr, tokens);
213     }    
214 }