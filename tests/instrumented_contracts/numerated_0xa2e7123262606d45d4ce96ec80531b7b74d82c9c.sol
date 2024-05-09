1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, February 12, 2019
3  (UTC) */
4 
5 pragma solidity 0.4.25;
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   uint256 public totalSupply;
14   function balanceOf(address who) public constant returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public constant returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a); 
37     return a - b; 
38   } 
39   
40   function add(uint256 a, uint256 b) internal pure returns (uint256) { 
41     uint256 c = a + b; assert(c >= a);
42     return c;
43   }
44 
45 }
46 
47 /**
48  * @title Basic token
49  * @dev Basic version of StandardToken, with no allowances.
50  */
51 contract BasicToken is ERC20Basic {
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55 
56   /**
57   * @dev transfer token for a specified address
58   * @param _to The address to transfer to.
59   * @param _value The amount to be transferred.
60   */
61   function transfer(address _to, uint256 _value)  public returns (bool) {
62     require(_to != address(0));
63     require(_value <= balances[msg.sender]); 
64     // SafeMath.sub will throw if there is not enough balance. 
65     balances[msg.sender] = balances[msg.sender].sub(_value); 
66     balances[_to] = balances[_to].add(_value); 
67     emit Transfer(msg.sender, _to, _value); 
68     
69     return true; 
70   } 
71 
72   /** 
73    * @dev Gets the balance of the specified address. 
74    * @param _owner The address to query the the balance of. 
75    * @return An uint256 representing the amount owned by the passed address. 
76    */ 
77   function balanceOf(address _owner) public constant returns (uint256 balance) { 
78     return balances[_owner]; 
79   }
80 } 
81 
82 /** 
83  * @title Standard ERC20 token 
84  * 
85  * @dev Implementation of the basic standard token. 
86  * @dev https://github.com/ethereum/EIPs/issues/20 
87  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
88  */ 
89 contract StandardToken is ERC20, BasicToken {
90 
91   mapping (address => mapping (address => uint256)) internal allowed;
92 
93   /**
94    * @dev Transfer tokens from one address to another
95    * @param _from address The address which you want to send tokens from
96    * @param _to address The address which you want to transfer to
97    * @param _value uint256 the amount of tokens to be transferred
98    */
99   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[_from]);
102     require(_value <= allowed[_from][msg.sender]); 
103     balances[_from] = balances[_from].sub(_value); 
104     balances[_to] = balances[_to].add(_value); 
105     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
106     emit Transfer(_from, _to, _value); 
107     
108     return true; 
109   } 
110 
111  /** 
112   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
113   * 
114   * Beware that changing an allowance with this method brings the risk that someone may use both the old 
115   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
116   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
117   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
118   * @param _spender The address which will spend the funds. 
119   * @param _value The amount of tokens to be spent. 
120   */ 
121   function approve(address _spender, uint256 _value) public returns (bool) { 
122     allowed[msg.sender][_spender] = _value; 
123     emit Approval(msg.sender, _spender, _value); 
124     return true; 
125   }
126 
127  /** 
128   * @dev Function to check the amount of tokens that an owner allowed to a spender. 
129   * @param _owner address The address which owns the funds. 
130   * @param _spender address The address which will spend the funds. 
131   * @return A uint256 specifying the amount of tokens still available for the spender. 
132   */ 
133   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { 
134     return allowed[_owner][_spender]; 
135   } 
136 
137  /** 
138   * approve should be called when allowed[_spender] == 0. To increment 
139   * allowed value is better to use this function to avoid 2 calls (and wait until 
140   * the first transaction is mined) * From MonolithDAO Token.sol 
141   */ 
142   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
143     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
144     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
145     return true; 
146   }
147 
148   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
149     uint oldValue = allowed[msg.sender][_spender]; 
150     if (_subtractedValue > oldValue) {
151       allowed[msg.sender][_spender] = 0;
152     } else {
153       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
154     }
155     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156     return true;
157   }
158 
159   function () public payable {
160     ///revert();
161   }
162 
163 }
164 
165 /**
166  * @title Ownable
167  * @dev The Ownable contract has an owner address, and provides basic authorization control
168  * functions, this simplifies the implementation of "user permissions".
169  */
170 contract Ownable {
171   address public owner;
172 
173   /**
174    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
175    * account.
176    */
177   constructor() public {
178     owner = msg.sender;
179   }
180   
181   /**
182    * @dev Throws if called by any account other than the owner.
183    */
184   modifier onlyOwner() {
185     require(msg.sender == owner);
186     _;
187   }
188   
189 }
190 
191 
192 contract MyctIcoToken is StandardToken, Ownable {
193     
194     string public constant name = "MyctIco";
195     string public constant symbol = "MYCT";
196     uint32 public constant decimals = 18;
197     
198     uint256 public constant totalSupply = 100000000 * (10 ** 18);
199     uint256 public totalTransferIco = 0;
200     
201     constructor() public {
202     }
203     
204     function transferSale(address addr, uint256 tokens) public onlyOwner {
205         require(addr != address(0));
206         require(balances[address(this)] >= tokens);
207         
208         balances[addr] = balances[addr].add(tokens);
209         balances[address(this)] = balances[address(this)].sub(tokens);
210         emit Transfer(address(this), addr, tokens);
211     } 
212     
213     function transferIco(address [] _holders, uint256 [] _tokens) public onlyOwner {
214         
215         for(uint i=0; i<_holders.length; ++i) {
216             balances[_holders[i]] = _tokens[i];
217             totalTransferIco += _tokens[i];
218             emit Transfer(address(this), _holders[i], _tokens[i]);
219         }
220         
221         require(totalTransferIco <= totalSupply);
222     } 
223 }