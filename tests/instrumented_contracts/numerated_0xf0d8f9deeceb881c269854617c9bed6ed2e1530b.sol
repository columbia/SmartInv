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
57   function transfer(address _to, uint256 _value)  public IsWallet(_to) returns (bool) {
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
76   
77   modifier IsWallet(address _address) {
78 		/**
79 		* @dev Transfer tokens from msg.sender to another address.  
80 		* Cannot Allows execution if the transfer to address code size is 0
81 		* @param _address address to check that its not a contract
82 		*/		
83 		uint codeLength;
84 		assembly {
85             // Retrieve the size of the code on target address, this needs assembly .
86             codeLength := extcodesize(_address)
87         }
88 		require(codeLength==0);		
89         _; 
90    }
91 } 
92 
93 /** 
94  * @title Standard ERC20 token 
95  * 
96  * @dev Implementation of the basic standard token. 
97  * @dev https://github.com/ethereum/EIPs/issues/20 
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
99  */ 
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]); 
114     balances[_from] = balances[_from].sub(_value); 
115     balances[_to] = balances[_to].add(_value); 
116     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
117     emit Transfer(_from, _to, _value); 
118     
119     return true; 
120   } 
121 
122  /** 
123   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
124   * 
125   * Beware that changing an allowance with this method brings the risk that someone may use both the old 
126   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
127   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
128   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
129   * @param _spender The address which will spend the funds. 
130   * @param _value The amount of tokens to be spent. 
131   */ 
132   function approve(address _spender, uint256 _value) public returns (bool) { 
133     allowed[msg.sender][_spender] = _value; 
134     emit Approval(msg.sender, _spender, _value); 
135     return true; 
136   }
137 
138  /** 
139   * @dev Function to check the amount of tokens that an owner allowed to a spender. 
140   * @param _owner address The address which owns the funds. 
141   * @param _spender address The address which will spend the funds. 
142   * @return A uint256 specifying the amount of tokens still available for the spender. 
143   */ 
144   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { 
145     return allowed[_owner][_spender]; 
146   } 
147 
148  /** 
149   * approve should be called when allowed[_spender] == 0. To increment 
150   * allowed value is better to use this function to avoid 2 calls (and wait until 
151   * the first transaction is mined) * From MonolithDAO Token.sol 
152   */ 
153   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
154     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
155     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
156     return true; 
157   }
158 
159   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
160     uint oldValue = allowed[msg.sender][_spender]; 
161     if (_subtractedValue > oldValue) {
162       allowed[msg.sender][_spender] = 0;
163     } else {
164       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
165     }
166     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170   function () public payable {
171     revert();
172   }
173 
174 }
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182   address public owner;
183 
184   /**
185    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
186    * account.
187    */
188   constructor() public {
189     owner = msg.sender;
190   }
191 }
192 
193 
194 /**
195 * @dev Migrate version of ERC20 interface
196 */
197 contract ERC20migrate {
198     uint public totalSupply;
199     function balanceOf(address _who) public constant returns(uint);
200 }
201 
202 contract HeartBoutToken is StandardToken, Ownable {
203     
204     string public constant name = "HeartBout";
205     string public constant symbol = "HB";
206     uint32 public constant decimals = 18;
207     
208     uint256 public constant totalSupply = 63695267 * (10 ** 18);
209     
210     constructor(address _migrationSource, address [] _holders) public {
211         uint256 total = 0;
212         balances[0x80da2Af3A3ED3Ecd165D7aC76b4a0C10D2deCB13] = ERC20migrate(_migrationSource).balanceOf(0xbAc36D24b6641434C7cE8E48F89e79E1fb6bd497);
213         total += balances[0x80da2Af3A3ED3Ecd165D7aC76b4a0C10D2deCB13];
214         emit Transfer(address(this), 0x80da2Af3A3ED3Ecd165D7aC76b4a0C10D2deCB13, balance);
215         for(uint i=0; i<_holders.length; ++i) {
216             uint256 balance = ERC20migrate(_migrationSource).balanceOf(_holders[i]);
217             balances[_holders[i]] = balance;
218             total += balance;
219             emit Transfer(address(this), _holders[i], balance);
220         }
221         require(total == ERC20migrate(_migrationSource).totalSupply());
222     }
223     
224 }