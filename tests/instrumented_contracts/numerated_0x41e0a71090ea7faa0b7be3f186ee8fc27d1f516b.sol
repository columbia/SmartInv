1 pragma solidity 0.4.23;
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
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82     /// Total amount of tokens
83   uint256 public totalSupply;
84   
85   function balanceOf(address _owner) public view returns (uint256 balance);
86   
87   function transfer(address _to, uint256 _amount) public returns (bool success);
88   
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20 is ERC20Basic {
97   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
98   
99   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
100   
101   function approve(address _spender, uint256 _amount) public returns (bool success);
102   
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  */
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   //balance in each address account
114   mapping(address => uint256) balances;
115 
116   /**
117   * @dev transfer token for a specified address
118   * @param _to The address to transfer to.
119   * @param _amount The amount to be transferred.
120   */
121   function transfer(address _to, uint256 _amount) public returns (bool success) {
122     require(_to != address(0));
123     require(balances[msg.sender] >= _amount && _amount > 0
124         && balances[_to].add(_amount) > balances[_to]);
125 
126     // SafeMath.sub will throw if there is not enough balance.
127     balances[msg.sender] = balances[msg.sender].sub(_amount);
128     balances[_to] = balances[_to].add(_amount);
129     emit Transfer(msg.sender, _to, _amount);
130     return true;
131   }
132 
133   /**
134   * @dev Gets the balance of the specified address.
135   * @param _owner The address to query the the balance of.
136   * @return An uint256 representing the amount owned by the passed address.
137   */
138   function balanceOf(address _owner) public view returns (uint256 balance) {
139     return balances[_owner];
140   }
141 
142 }
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  */
150 contract StandardToken is ERC20, BasicToken {
151   
152   
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _amount uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
163     require(_to != address(0));
164     require(balances[_from] >= _amount);
165     require(allowed[_from][msg.sender] >= _amount);
166     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
167 
168     balances[_from] = balances[_from].sub(_amount);
169     balances[_to] = balances[_to].add(_amount);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
171     emit Transfer(_from, _to, _amount);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _amount The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _amount) public returns (bool success) {
186     allowed[msg.sender][_spender] = _amount;
187     emit Approval(msg.sender, _spender, _amount);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
198     return allowed[_owner][_spender];
199   }
200 
201 }
202 
203 /**
204  * @title CLX Token
205  * @dev Token representing CLX.
206  */
207  contract CLXToken is StandardToken, Ownable{
208      string public name ;
209      string public symbol ;
210      uint8 public decimals = 8 ;
211      
212      /**
213      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
214      */
215      function ()public payable {
216          revert();
217      }
218      
219      /**
220      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
221      * @param initialSupply The initial supply of tokens which will be fixed through out
222      * @param tokenName The name of the token
223      * @param tokenSymbol The symbol of the token
224      */
225      function CLXToken(
226             uint256 initialSupply,
227             string tokenName,
228             string tokenSymbol
229          ) public {
230          totalSupply = initialSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount
231          name = tokenName;
232          symbol = tokenSymbol;
233          balances[msg.sender] = totalSupply;
234          
235          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
236          emit Transfer(address(0), msg.sender, totalSupply);
237      }
238      
239      /**
240      *@dev helper method to get token details, name, symbol and totalSupply in one go
241      */
242     function getTokenDetail() public view returns (string, string, uint256) {
243 	    return (name, symbol, totalSupply);
244     }
245 }