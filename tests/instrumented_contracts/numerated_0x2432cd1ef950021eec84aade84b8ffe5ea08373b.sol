1 /**
2  * 4art ERC20 StandardToken
3  * Author: scalify.it
4  * */
5 
6 pragma solidity ^0.4.24;
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a * b;
15         require(a == 0 || c / a == b);
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a);
27         return c;
28     }
29     
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return c;
35     }
36 }
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44     uint256 public totalSupply;
45     function balanceOf(address who) public view returns (uint256);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event DelegatedTransfer(address indexed from, address indexed to, address indexed delegate, uint256 value, uint256 fee);
48 }
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55     using SafeMath for uint256;
56     mapping(address => uint256) public balances;
57 
58     /**
59     * @dev Gets the balance of the specified address.
60     * @param _owner The address to query the the balance of.
61     * @return An uint256 representing the amount owned by the passed address.
62     */
63     function balanceOf(address _owner) public view returns (uint256 balance) {
64         return balances[_owner];
65     }
66 }
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73     function allowance(address owner, address spender) public view returns (uint256);
74     function transferFrom(address from, address to, uint256 value) public returns (bool);
75     function approve(address spender, uint256 value) public returns (bool);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @title Standard ERC20 token
81  *
82  * @dev Implementation of the basic standard token.
83  * @dev https://github.com/ethereum/EIPs/issues/20
84  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
85  */
86 contract StandardToken is ERC20, BasicToken {
87 
88     mapping (address => mapping (address => uint256)) internal allowed;
89 
90     /**
91      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
92      *
93      * Beware that changing an allowance with this method brings the risk that someone may use both the old
94      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
95      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
96      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97      * @param _spender The address which will spend the funds.
98      * @param _value The amount of tokens to be spent.
99      */
100     function approve(address _spender, uint256 _value) public returns (bool) {
101         allowed[msg.sender][_spender] = _value;
102         emit Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     /**
107      * @dev Function to check the amount of tokens that an owner allowed to a spender.
108      * @param _owner address The address which owns the funds.
109      * @param _spender address The address which will spend the funds.
110      * @return A uint256 specifying the amount of tokens still available for the spender.
111      */
112     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
113         return allowed[_owner][_spender];
114     }
115 
116     /**
117      * approve should be called when allowed[_spender] == 0. To increment
118      * allowed value is better to use this function to avoid 2 calls (and wait until
119      * the first transaction is mined)
120      * From MonolithDAO Token.sol
121      */
122     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
123         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
124         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125         return true;
126     }
127 
128     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
129         uint oldValue = allowed[msg.sender][_spender];
130         if (_subtractedValue > oldValue) {
131             allowed[msg.sender][_spender] = 0;
132         } else {
133             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
134         }
135         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136         return true;
137     }
138 
139 }
140 
141 contract Owned {
142     address public owner;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145 
146     constructor() public {
147         owner = msg.sender;
148     }
149 
150     /**
151     * @dev Allows the current owner to transfer control of the contract to a newOwner.
152     * @param newOwner The address to transfer ownership to.
153     */
154     function transferOwnership(address newOwner) public onlyOwner {
155         require(newOwner != address(0));
156         emit OwnershipTransferred(owner, newOwner);
157         owner = newOwner;
158     }
159 
160     modifier onlyOwner {
161         require(msg.sender == owner);
162         _;
163     }
164 }
165 
166 contract TestingCoin is StandardToken, Owned {
167     string public constant name = "TestingCoin";
168     string public constant symbol = "TeC";
169     uint8 public constant decimals = 18;
170     uint256 public sellPrice = 0; // eth
171     uint256 public buyPrice = 0; // eth
172     mapping (address => bool) private SubFounders;       
173     mapping (address => bool) private TeamAdviserPartner;
174 
175     constructor() public {
176         totalSupply = 15000000;
177         balances[msg.sender] = totalSupply;
178     }
179     
180     // desposit funds to smart contract
181     function () public payable {
182     }
183 
184     // Set buy and sell price of 1 token in eth.
185     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
186         sellPrice = newSellPrice;
187         buyPrice = newBuyPrice;
188     }
189 
190     // @notice Buy tokens from contract by sending ether
191     function buy() payable public {
192         require(now > 1543536000); // seconds since 01.01.1970 to 30.11.2018 (18:00:00 o'clock GMT)
193         uint amount = msg.value.div(buyPrice);       // calculates the amount
194         _transfer(owner, msg.sender, amount);   // makes the transfers
195     }
196 
197     // @notice Sell `amount` tokens to contract
198     function sell(uint256 amount) public {
199         require(now > 1543536000); // seconds since 01.01.1970 to 30.11.2018 (18:00:00 o'clock GMT) 
200         require(amount > 0);
201         require(balances[msg.sender] >= amount);
202         uint256 requiredBalance = amount.mul(sellPrice);
203         require(address(this).balance >= requiredBalance);  // checks if the contract has enough ether to pay
204         balances[msg.sender] -= amount;
205         balances[owner] += amount;
206         emit Transfer(msg.sender, owner, amount); 
207         msg.sender.transfer(requiredBalance);    // sends ether to the seller.
208     }
209 
210     function _transfer(address _from, address _to, uint _value) internal {
211         // Prevent transfer to 0x0 address. Use burn() instead
212         require(_to != 0x0);
213         // Check if the sender has enough
214         require(balances[_from] >= _value);
215         // Check for overflows
216         require(balances[_to] + _value > balances[_to]);
217         // Subtract from the sender
218         balances[_from] -= _value;
219         // Add the same to the recipient
220         balances[_to] += _value;
221         emit Transfer(_from, _to, _value);
222     }
223 
224     // @dev if owner wants to transfer contract ether balance to own account.
225     function transferBalanceToOwner(uint256 _value) public onlyOwner {
226         require(_value <= address(this).balance);
227         owner.transfer(_value);
228     }
229     
230     // @dev if someone wants to transfer tokens to other account.
231     function transferTokens(address _to, uint256 _tokens) lockTokenTransferBeforeStage4 public {
232         _transfer(msg.sender, _to, _tokens);
233     }
234     
235     // @dev Transfer tokens from one address to another
236     function transferFrom(address _from, address _to, uint256 _value) lockTokenTransferBeforeStage4 public returns (bool) {
237         require(_to != address(0));
238         require(_value <= balances[_from]);
239         require(_value <= allowed[_from][msg.sender]);
240         balances[_from] = balances[_from].sub(_value);
241         balances[_to] = balances[_to].add(_value);
242         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
243         emit Transfer(_from, _to, _value);
244         return true;
245     }
246     
247     modifier lockTokenTransferBeforeStage4{
248         if(msg.sender != owner){
249            require(now > 1533513600); // Locking till stage 4 starting date (ICO).
250         }
251         _;
252     }
253 
254 }