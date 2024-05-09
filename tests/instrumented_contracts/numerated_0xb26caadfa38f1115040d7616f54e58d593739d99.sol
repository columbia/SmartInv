1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     emit Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     emit Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     emit Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164     uint oldValue = allowed[msg.sender][_spender];
165     if (_subtractedValue > oldValue) {
166       allowed[msg.sender][_spender] = 0;
167     } else {
168       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169     }
170     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174 }
175 
176 contract MdedicalChainCoin is StandardToken {
177     using SafeMath for uint256;
178     string public name = "MedicalChain Coin";
179     string public symbol = "MEDC";
180     uint public decimals = 6;
181 
182     address public address1 = 0x5E620AB21d107b9618d2e647C4CA03D9AfB41230;
183     address public address2 = 0xceC414C13954c11fdE359e0627b8b3F25c8472a5;
184     address public address3 = 0xd6dA34A87917d1e2F1A00a52Fbbd30aC4811F293;
185     uint256 public privateAmount = 2400000000 * (10 ** decimals); //定向募集上限30%， 24亿
186     uint256 public mangeFundAmount = 2000000000 * (10 ** decimals); //管理基金会预留25%，20亿
187     uint256 public operationAmount = 2000000000 * (10 ** decimals); //生态建设基金25%，20亿
188     uint256 public lockAmount = 1600000000 * (10 ** decimals);  //剩余锁定20%, 16亿
189 
190     function MdedicalChainCoin() public {
191         balances[address1] = privateAmount;
192         emit Transfer(address(0), address1, privateAmount);
193         balances[address2] = mangeFundAmount.add(operationAmount);
194         emit Transfer(address(0), address2, mangeFundAmount.add(operationAmount));
195         balances[address3] = lockAmount;
196         emit Transfer(address(0), address3, lockAmount);
197         totalSupply = 8000000000 * (10 ** decimals);  //总共发行80亿
198     }
199 }