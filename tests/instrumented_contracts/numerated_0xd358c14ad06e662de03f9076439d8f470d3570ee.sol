1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31   
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   function Ownable() {
37     owner = msg.sender;
38   }
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner {
53     if (newOwner != address(0)) {
54       owner = newOwner;
55     }
56   }
57 
58 }
59 
60 contract ERC20Basic {
61   uint256 public totalSupply;
62   function balanceOf(address who) constant returns (uint256);
63   function transfer(address to, uint256 value) returns (bool);
64 //   event Transfer(address indexed _from, address indexed _to, uint _value);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint256 _value) returns (bool) {
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of. 
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) constant returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender) constant returns (uint256);
98   function transferFrom(address from, address to, uint256 value) returns (bool);
99   function approve(address spender, uint256 value) returns (bool);
100   
101   // KYBER-NOTE! code changed to comply with ERC20 standard
102   event Approval(address indexed _owner, address indexed _spender, uint _value);
103   //event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) allowed;
109   
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amout of tokens to be transfered
115    */
116   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
117     var _allowance = allowed[_from][msg.sender];
118 
119     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
120     // require (_value <= _allowance);
121 
122     // KYBER-NOTE! code changed to comply with ERC20 standard
123     balances[_from] = balances[_from].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     //balances[_from] = balances[_from].sub(_value); // this was removed
126     allowed[_from][msg.sender] = _allowance.sub(_value);
127     Transfer(_from, _to, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint256 _value) returns (bool) {
137 
138     // To change the approve amount you first have to reduce the addresses`
139     //  allowance to zero by calling `approve(_spender, 0)` if it is not
140     //  already 0 to mitigate the race condition described here:
141     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
143 
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Function to check the amount of tokens that an owner allowed to a spender.
151    * @param _owner address The address which owns the funds.
152    * @param _spender address The address which will spend the funds.
153    * @return A uint256 specifing the amount of tokens still avaible for the spender.
154    */
155   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
156     return allowed[_owner][_spender];
157   }
158 
159 }
160 
161 contract JOP is StandardToken, Ownable {
162     string public constant name = "JopCoin";
163     string public constant symbol = "JOP";
164     uint public constant decimals = 18;
165     
166     uint public price ;
167     uint public mintTimes;
168     address public receiver;
169     
170     mapping(address=>bool) public freezeList;
171     
172     //代币增发
173     event DoMint(uint n,uint number);
174     event Burn(address indexed from, uint256 value);
175     
176     function JOP(uint _price){
177         receiver = msg.sender;
178         price =_price; //代币的兑换比例 数值为正整数
179         totalSupply=500*(10**4)*10**decimals; //5000000
180         //代币数量转入指定以太地址
181         balances[msg.sender] = totalSupply; 
182         Transfer(address(0x0), msg.sender, totalSupply);
183     }
184     
185     modifier validUser(address addr){
186         if(freezeList[addr] || addr ==address(0x0)) throw;
187         _;
188     }
189     
190     function addFreezeList(address addr) onlyOwner returns(bool)  {
191         if(!freezeList[addr]){
192             freezeList[addr] =true;
193             return true;
194         }else{
195             return false;
196         }
197     }
198     
199     //解除冻结账户
200     function deleteFreezeList(address addr) onlyOwner returns(bool){
201         if(freezeList[addr]){
202             delete freezeList[addr];
203             return true;
204         }else{
205             return false;
206         }
207     }
208     
209     function setPrice(uint _price) onlyOwner{
210         require( _price > 0);
211         price= _price;
212     }
213     
214     function destroy() onlyOwner{
215         suicide(owner);
216     }
217     
218     function transfer(address _to, uint _value) validUser(msg.sender) returns (bool){
219         if(_value <= 10**decimals/10) throw; //转账金额需要大于0.1
220         balances[msg.sender] = balances[msg.sender].sub(_value);
221         balances[_to] = balances[_to].add(_value - 10**decimals/10);
222         balances[receiver] = balances[receiver].add(10**decimals/10);
223         Transfer(msg.sender, _to, _value - 10**decimals/10);
224         return true;
225     }
226     
227     function mint(uint num) onlyOwner{
228         balances[owner] = balances[owner].add(num*(10**decimals));
229         totalSupply = totalSupply.add(num*(10**decimals));
230         DoMint(mintTimes++,num*(10**decimals));
231     }
232     
233     function burn(uint256 _value) public returns (bool success) {
234         require(balances[msg.sender] >= _value); 
235         balances[msg.sender] -= _value; 
236         totalSupply -= _value;   
237         Transfer(msg.sender, address(0x0), _value);
238         Burn(msg.sender, _value);
239         return true;
240     }
241     
242     function changeReceiver(address _receiver) onlyOwner{
243         if(_receiver == address(0x0)) throw;
244         receiver = _receiver;
245     }
246     
247     function () payable{
248         uint tokens = price.mul(msg.value);
249         if(tokens <= balances[owner]){
250             balances[owner] = balances[owner].sub(tokens);
251             balances[msg.sender] = balances[msg.sender].add(tokens);
252             receiver.transfer(msg.value);
253             Transfer(owner, msg.sender, tokens);
254         }else{
255             throw;
256         }
257     }
258 }