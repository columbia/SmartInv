1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract AimiToken {
6     //---------------------------------------变量---------------------------------------- 
7     string public name = "艾米币";//代币名字
8     string public symbol = "AT"; //代币符号
9     uint8 public decimals = 8; //代币小数位
10     uint256 public _totalSupply ; //代币总量10亿
11      mapping(address => uint256) balances;
12     //用一个映射类型的变量，来记录被冻结的账户
13     mapping(address=>bool) public frozenATAccount;
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15     bool  transfersEnabled = false ;//是否激活代币交易 ，true为激活，默认不激活 
16     mapping (address => mapping (address => uint256)) internal allowed;
17     address public owner;
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20   /**
21    * @dev Transfer tokens from one address to another
22    * @param _from address The address which you want to send tokens from
23    * @param _to address The address which you want to transfer to
24    * @param _value uint256 the amount of tokens to be transferred
25    */
26   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
27     require(_to != address(0));
28     require(_value <= balances[_from]);
29     require(_value <= allowed[_from][msg.sender]);
30     require(frozenATAccount[_to]==false);
31     require(frozenATAccount[msg.sender]==false);
32     require(transfersEnabled==true);
33     balances[_from] = sub(balances[_from],_value);
34     balances[_to] = add(balances[_to],_value);
35     allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],_value);
36     emit Transfer(_from, _to, _value);
37     return true;
38   }
39 
40   /**
41    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
42    *
43    * Beware that changing an allowance with this method brings the risk that someone may use both the old
44    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
45    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
46    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47    * @param _spender The address which will spend the funds.
48    * @param _value The amount of tokens to be spent.
49    */
50   function approve(address _spender, uint256 _value) public returns (bool) {
51     allowed[msg.sender][_spender] = _value;
52     emit Approval(msg.sender, _spender, _value);
53     return true;
54   }
55 
56   /**
57    * @dev Function to check the amount of tokens that an owner allowed to a spender.
58    * @param _owner address The address which owns the funds.
59    * @param _spender address The address which will spend the funds.
60    * @return A uint256 specifying the amount of tokens still available for the spender.
61    */
62   function allowance(address _owner, address _spender) public view returns (uint256) {
63     return allowed[_owner][_spender];
64   }
65 
66   /**
67    * @dev Increase the amount of tokens that an owner allowed to a spender.
68    *
69    * approve should be called when allowed[_spender] == 0. To increment
70    * allowed value is better to use this function to avoid 2 calls (and wait until
71    * the first transaction is mined)
72    * From MonolithDAO Token.sol
73    * @param _spender The address which will spend the funds.
74    * @param _addedValue The amount of tokens to increase the allowance by.
75    */
76   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
77     allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender],_addedValue);
78     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
79     return true;
80   }
81 
82   /**
83    * @dev Decrease the amount of tokens that an owner allowed to a spender.
84    *
85    * approve should be called when allowed[_spender] == 0. To decrement
86    * allowed value is better to use this function to avoid 2 calls (and wait until
87    * the first transaction is mined)
88    * From MonolithDAO Token.sol
89    * @param _spender The address which will spend the funds.
90    * @param _subtractedValue The amount of tokens to decrease the allowance by.
91    */
92   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
93     uint oldValue = allowed[msg.sender][_spender];
94     if (_subtractedValue > oldValue) {
95       allowed[msg.sender][_spender] = 0;
96     } else {
97       allowed[msg.sender][_spender] = sub(oldValue,_subtractedValue);
98     }
99     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100     return true;
101   }
102 
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111     require(_value <= balances[msg.sender]);
112     require(frozenATAccount[_to]==false);
113     require(frozenATAccount[msg.sender]==false);
114     require(transfersEnabled==true);
115     // SafeMath.sub will throw if there is not enough balance.
116     balances[msg.sender] = sub(balances[msg.sender],_value);
117     balances[_to] = add(balances[_to],_value);
118     emit Transfer(msg.sender, _to, _value);
119     return true;
120   }
121 
122   /**
123   * @dev Gets the balance of the specified address.
124   * @param _owner The address to query the the balance of.
125   * @return An uint256 representing the amount owned by the passed address.
126   */
127   function balanceOf(address _owner) public view returns (uint256 balance) {
128     return balances[_owner];
129   }
130   /**
131   * @dev total number of tokens in existence
132   */
133     function totalSupply() public view returns (uint256) {
134        return _totalSupply;
135     }
136  
137 
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147   /**
148    * @dev Allows the current owner to transfer control of the contract to a newOwner.
149    * @param newOwner The address to transfer ownership to.
150    */
151   function transferOwnership(address newOwner) public onlyOwner {
152     require(newOwner != address(0));
153     emit OwnershipTransferred(owner, newOwner);
154     owner = newOwner;
155   }
156   
157    /**
158   * @dev Multiplies two numbers, throws on overflow.
159   */
160   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161     if (a == 0) {
162       return 0;
163     }
164     uint256 c = a * b;
165     assert(c / a == b);
166     return c;
167   }
168 
169   /**
170   * @dev Integer division of two numbers, truncating the quotient.
171   */
172   function div(uint256 a, uint256 b) internal pure returns (uint256) {
173     // assert(b > 0); // Solidity automatically throws when dividing by 0
174     uint256 c = a / b;
175     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
176     return c;
177   }
178 
179   /**
180   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
181   */
182   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183     assert(b <= a);
184     return a - b;
185   }
186 
187   /**
188   * @dev Adds two numbers, throws on overflow.
189   */
190   function add(uint256 a, uint256 b) internal pure returns (uint256) {
191     uint256 c = a + b;
192     assert(c >= a);
193     return c;
194   }
195   
196   
197   
198   
199     
200     //-----------------------------------------构造方法--------------------------------------------- 
201     //构造函数,
202     function AimiToken(address _sentM,uint256 __totalSupply) public payable{
203         //手动指定代币的拥有者，如果不填，则默认为合约的部署者
204         if(_sentM !=0){
205             owner = _sentM;
206         }
207         if(__totalSupply!=0){
208             _totalSupply = __totalSupply;
209         }
210         //初始化合约的拥有者全部代币 
211         balances[owner] = _totalSupply;
212    
213     }
214  
215  function frozenAccount(address froze_address) public onlyOwner{
216      frozenATAccount[froze_address]=true;
217  } 
218   function unfrozenATAccount(address unfroze_address) public onlyOwner{
219      frozenATAccount[unfroze_address]=false;
220  } 
221  
222    function openTransfer() public onlyOwner{
223     transfersEnabled=true;
224  } 
225    function closeTransfer() public onlyOwner{
226      transfersEnabled=true;
227  } 
228 }