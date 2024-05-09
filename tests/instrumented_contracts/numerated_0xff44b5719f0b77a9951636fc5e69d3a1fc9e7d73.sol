1 pragma solidity ^0.5.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         require(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b <= a);
16         return a - b;
17     }
18 
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event DelegatedTransfer(address indexed from, address indexed to, address indexed delegate, uint256 value, uint256 fee);
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances.
49  */
50 contract BasicToken is ERC20Basic {
51     using SafeMath for uint256;
52     mapping(address => uint256) public balances;
53 
54     /**
55     * @dev Gets the balance of the specified address.
56     * @param _owner The address to query the the balance of.
57     * @return An uint256 representing the amount owned by the passed address.
58     */
59     function balanceOf(address _owner) public view returns (uint256 balance) {
60         return balances[_owner];
61     }
62 
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70     function allowance(address owner, address spender) public view returns (uint256);
71     function transferFrom(address from, address to, uint256 value) public returns (bool);
72     function approve(address spender, uint256 value) public returns (bool);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 /**
77  * @title Standard ERC20 token
78  *
79  * @dev Implementation of the basic standard token.
80  * @dev https://github.com/ethereum/EIPs/issues/20
81  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
82  */
83 contract StandardToken is ERC20, BasicToken {
84 
85     mapping (address => mapping (address => uint256)) internal allowed;
86 
87     /**
88      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
89      * Beware that changing an allowance with this method brings the risk that someone may use both the old
90      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
91      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
92      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93      * @param _spender The address which will spend the funds.
94      * @param _value The amount of tokens to be spent.
95      */
96     function approve(address _spender, uint256 _value) public returns (bool) {
97         allowed[msg.sender][_spender] = _value;
98         emit Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     /**
103      * @dev Function to check the amount of tokens that an owner allowed to a spender.
104      * @param _owner address The address which owns the funds.
105      * @param _spender address The address which will spend the funds.
106      * @return A uint256 specifying the amount of tokens still available for the spender.
107      */
108     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
109         return allowed[_owner][_spender];
110     }
111 
112     /**
113      * approve should be called when allowed[_spender] == 0. To increment
114      * allowed value is better to use this function to avoid 2 calls (and wait until
115      * the first transaction is mined)
116      * From MonolithDAO Token.sol
117      */
118     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
119         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
120         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121         return true;
122     }
123 
124     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
125         uint oldValue = allowed[msg.sender][_spender];
126         if (_subtractedValue > oldValue) {
127             allowed[msg.sender][_spender] = 0;
128         } else {
129             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
130         }
131         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132         return true;
133     }
134 
135 }
136 
137 /** @title Owned */
138 contract Owned {
139     address payable public  owner;
140 
141     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
142 
143     /**
144      * @dev Owned constructor
145      */
146     constructor() public {
147         owner = msg.sender;
148     }
149 
150     /**
151      * @dev Allows the current owner to transfer control of the contract to a newOwner.
152      * @param newOwner The address to transfer ownership to.
153      */
154     function transferOwnership(address payable newOwner) onlyOwner public {
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
166 
167 /** @title FourArt Token */
168 contract FourArt is StandardToken, Owned {
169     FourArt public associatedToken;
170     string public constant name = "4ArtCoin";
171     string public constant symbol = "4Art";
172     uint8 public constant decimals = 18;
173     uint256 public sellPrice = 0; // eth
174     uint256 public buyPrice = 0; // eth
175 
176     /**
177      * @dev FourArt constructor call on contract deployment
178      */
179     constructor(FourArt _address) public  {
180         associatedToken = _address;
181         totalSupply = 3508500000e18;
182         balances[msg.sender] = totalSupply;
183     }
184 
185 
186     // desposit funds to smart contract
187     function () external payable {}
188     
189     // Set buy and sell price of 1 token in eth.
190     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
191         sellPrice = newSellPrice;
192         buyPrice = newBuyPrice;
193     }
194 
195     // @notice Buy tokens from contract by sending ether
196     function buy() payable public {
197         uint amount = msg.value.div(buyPrice);       // calculates the amount
198         _transfer(owner, msg.sender, amount);   // makes the transfers
199     }
200 
201     // @notice Sell `amount` tokens to contract
202     function sell(uint256 amount) public {
203         require(amount > 0);
204         require(balances[msg.sender] >= amount);
205         uint256 requiredBalance = amount.mul(sellPrice);
206         require(address(this).balance >= requiredBalance);  // checks if the contract has enough ether to pay
207         
208         balances[msg.sender] = balances[msg.sender].sub(amount);
209         balances[owner] = balances[owner].add(amount);
210         emit Transfer(msg.sender, owner, amount); 
211         msg.sender.transfer(requiredBalance);    // sends ether to the seller.
212     }
213     
214     // for use of buy and sell methods
215     function _transfer(address _from, address _to, uint _value) internal {
216         // Prevent transfer to 0x0 address. Use burn() instead
217        require(_to != address(0));
218         // Check if the sender has enough
219         require(balances[_from] >= _value);
220         // Check for overflows
221         require(balances[_to] + _value > balances[_to]);
222         
223         // SafeMath.sub will throw if there is not enough balance.
224         balances[_from] = balances[_from].sub(_value);
225         balances[_to] = balances[_to].add(_value);
226         emit Transfer(_from, _to, _value);
227     }
228     
229     // @dev if owner wants to transfer contract ether balance to own account.
230     function transferBalanceToOwner(uint256 _value) public onlyOwner {
231         require(_value <= address(this).balance);
232         owner.transfer(_value);
233     }
234     
235     /**
236     * @dev transfer token for a specified address
237     * @param _to The address to transfer to.
238     * @param _value The amount to be transferred.
239     */
240     function transfer(address _to, uint256 _value) public returns (bool) {
241         _transfer(msg.sender, _to, _value);
242         return true;
243     }
244     
245     
246     /**
247      * @dev Transfer from allowed address to other address
248      * @param _from from address
249      * @param _to to address
250      * @param _value number of token(s)
251      */
252     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
253         require(_to != address(0));
254         require(_value <= balances[_from]);
255         require(_value <= allowed[_from][_to]);
256         balances[_from] = balances[_from].sub(_value);
257         balances[_to] = balances[_to].add(_value);
258         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259         emit Transfer(_from, _to, _value);
260         return true;
261     }
262     
263     /**
264      * @dev get coins against 4Art ICO coins
265      * @param _amount number of token(s)
266      */
267     function convertIcoCoins(uint256 _amount) public {   
268         // msg.sender mush approve tokens for this contract using Approve()
269         // method of 4ArtCoin
270         // Same number of Trading coins will be given to msg.sender
271         
272         require(associatedToken.transferFrom(msg.sender, address(this), _amount));
273         _transfer(owner, msg.sender, _amount);   // makes the transfer of trading coins
274     }
275 }