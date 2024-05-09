1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7     
8   address public owner;
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) public onlyOwner {
34     require(newOwner != address(0));
35     OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 
39 }pragma solidity ^0.4.18;
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, throws on overflow.
49   */
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers, truncating the quotient.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   /**
70   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71   */
72   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   /**
78   * @dev Adds two numbers, throws on overflow.
79   */
80   function add(uint256 a, uint256 b) internal pure returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 /**
88  * @title Ownable
89  * @dev The Ownable contract has an owner address, and provides basic authorization control
90  * functions, this simplifies the implementation of "user permissions".
91  */
92 
93 
94 contract GemsToken is Ownable{
95   
96   using SafeMath for uint256;
97   
98   mapping(address => uint256) public balances;
99   mapping (address => mapping (address => uint256)) internal allowed;
100   
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103   
104   string public name = "Gems Of Power";
105   string public symbol = "GOP";
106   uint8 public decimals = 18;
107   uint256 public totalSupply = 200000000 * 10 ** uint(decimals);
108   address crowdsaleContract = address(0x0);
109   bool flag = false;
110 
111   function GemsToken () public {
112       balances[this] = totalSupply;
113   }
114   /**
115   * @dev total number of tokens in existence
116   */
117   function totalSupply() public view returns (uint256) {
118     return totalSupply;
119   }
120   
121   /**
122   * @dev getdecimals
123   */
124   function getdecimals() public view returns (uint8) {
125       return decimals;
126   }
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256 balance) {
133     return balances[_owner];
134   }
135   
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[msg.sender]);
144 
145     // SafeMath.sub will throw if there is not enough balance.
146     balances[_to] = balances[_to].add(_value);
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[_from]);
161     require(_value <= allowed[_from][msg.sender]);
162 
163     balances[_from] = balances[_from].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166     Transfer(_from, _to, _value);
167     return true;
168   }
169   /**
170  * public transfer, only can be called by this contract
171  */
172     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
173         // Prevent transfer to 0x0 address. Use burn() instead
174         require(_to != 0x0);
175         // Check if the sender has enough
176         require(balances[_from] >= _value);
177         // Check for overflows
178         require(balances[_to] + _value > balances[_to]);
179         // Save this for an assertion in the future
180         uint previousBalances = balances[_from].add(balances[_to]);
181         // Subtract from the sender
182         balances[_from] = balances[_from].sub(_value);
183         // Add the same to the recipient
184         balances[_to] = balances[_to].add(_value);
185         Transfer(_from, _to, _value);
186         // Asserts are used to use static analysis to find bugs in your code. They should never fail
187         assert(balances[_from] + balances[_to] == previousBalances);
188         return true;
189     }
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    *
193    * Beware that changing an allowance with this method brings the risk that someone may use both the old
194    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public returns (bool) {
201     allowed[msg.sender][_spender] = _value;
202     Approval(msg.sender, _spender, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(address _owner, address _spender) public view returns (uint256) {
213     return allowed[_owner][_spender];
214   }
215   
216   function sendCrowdsaleBalance (address _address, uint256 _value) public {
217       require (msg.sender == crowdsaleContract);
218       require (_value <= balances[this]);
219       totalSupply = totalSupply.sub(_value);
220       balances[this] = balances[this].sub(_value);
221       balances[_address] = balances[_address].add(_value);
222       Transfer(this, _address, _value);
223   }
224   
225   function sendOwnerBalance(address _address, uint _value) public onlyOwner {
226      uint256 value = _value * 10 ** uint(decimals);
227      require (value <= balances[this]);
228      balances[this] = balances[this].sub(value);
229      balances[_address] = balances[_address].add(value);
230      Transfer(this, _address, value);
231   }
232   
233   
234   function setCrowdsaleContract(address _address) public onlyOwner {
235      require(!flag);
236      crowdsaleContract = _address;
237      flag = true;
238   }
239   
240   function removeCrowdsaleContract(address _address) public onlyOwner {
241       require(flag);
242       if(crowdsaleContract == _address) {
243          crowdsaleContract = address(0x0);
244          flag = false;
245       }
246   }
247   
248   function GetcrowdsaleContract() public view returns(address) {
249       return crowdsaleContract;
250   }
251   
252 }