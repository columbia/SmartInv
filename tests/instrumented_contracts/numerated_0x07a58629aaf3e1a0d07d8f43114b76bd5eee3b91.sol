1 pragma solidity ^0.4.16;
2 
3 contract ERC20Token{
4     //ERC20 base standard
5     uint256 public totalSupply;
6     
7     function balanceOf(address _owner) public view returns (uint256 balance);
8     
9     function transfer(address _to, uint256 _value) public returns (bool success);
10     
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12     
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     
15     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
16     
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 // From https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable{
28   address public owner;
29   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) public onlyOwner {
49     require(newOwner != address(0));
50     OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53 }
54 
55 // Put the additional safe module here, safe math and pausable
56 // From https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol
57 // And https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
58 contract Safe is Ownable {
59     event Pause();
60     event Unpause();
61     bool public paused = false;
62   /**
63    * @dev Modifier to make a function callable only when the contract is not paused.
64    */
65     modifier whenNotPaused() {
66         require(!paused);
67         _;
68     }
69   /**
70    * @dev Modifier to make a function callable only when the contract is paused.
71    */
72     modifier whenPaused() {
73         require(paused);
74         _;
75     }
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79     function pause() onlyOwner whenNotPaused public {
80         paused = true;
81         Pause();
82     }
83   /**
84    * @dev called by the owner to unpause, returns to normal state
85    */
86     function unpause() onlyOwner whenPaused public {
87         paused = false;
88         Unpause();
89     }
90     
91     // Check if it is safe to add two numbers
92     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint c = a + b;
94         assert(c >= a && c >= b);
95         return c;
96     }
97 
98     // Check if it is safe to subtract two numbers
99     function safeSubtract(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint c = a - b;
101         assert(b <= a && c <= a);
102         return c;
103     }
104     // Check if it is safe to multiply two numbers
105     function safeMultiply(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint c = a * b;
107         assert(a == 0 || (c / a) == b);
108         return c;
109     }
110 
111     // reject any ether
112     function () public payable {
113         require(msg.value == 0);
114     }
115 }
116 
117 // Adapted from zeppelin-solidity's BasicToken, StandardToken and BurnableToken contracts
118 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
119 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
120 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
121 contract insChainToken is Safe, ERC20Token {
122     string public constant name = 'Guaranteed Ethurance Token Extra';              // Set the token name for display
123     string public constant symbol = 'GETX';                                  // Set the token symbol for display
124     uint8 public constant decimals = 18;                                     // Set the number of decimals for display
125     uint256 public constant INITIAL_SUPPLY = 1e9 * 10**uint256(decimals);
126     uint256 public totalSupply;
127     string public version = '2';
128     mapping (address => uint256) balances;
129     mapping (address => mapping (address => uint256)) allowed;
130     mapping (address => uint256) freeze;
131 
132     event Burn(address indexed burner, uint256 value);
133     
134     modifier whenNotFreeze() {
135         require(freeze[msg.sender]==0);
136         _;
137     }
138     
139     function insChainToken() public {
140         totalSupply = INITIAL_SUPPLY;                              // Set the total supply
141         balances[msg.sender] = INITIAL_SUPPLY;                     // Creator address is assigned all
142         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
143     }
144     
145     function transfer(address _to, uint256 _value)  whenNotPaused whenNotFreeze public returns (bool success) {
146         require(_to != address(this));
147         require(_to != address(0));
148         require(_value <= balances[msg.sender]);
149 
150         balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
151         balances[_to] = safeAdd(balances[_to], _value);
152         Transfer(msg.sender, _to, _value);
153         return true;
154     }
155 
156     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused whenNotFreeze public returns (bool success) {
157         require(_to != address(this));
158         require(_to != address(0));
159         require(_value <= balances[_from]);
160         require(_value <= allowed[_from][msg.sender]);
161 
162         balances[_from] = safeSubtract(balances[_from],_value);
163         balances[_to] = safeAdd(balances[_to],_value);
164         allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender],_value);
165         Transfer(_from, _to, _value);
166         return true;
167     }
168     
169 
170     function approve(address _spender, uint256 _value) public returns (bool success) {
171         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
172         allowed[msg.sender][_spender] = _value;
173         Approval(msg.sender, _spender, _value);
174         return true;
175     }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187 
188     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
189         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender],_addedValue);
190         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191         return true;
192     }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205         uint oldValue = allowed[msg.sender][_spender];
206         if (_subtractedValue > oldValue) {
207         allowed[msg.sender][_spender] = 0;
208         } else {
209         allowed[msg.sender][_spender] = safeSubtract(oldValue,_subtractedValue);
210         }
211         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212         return true;
213     }
214 
215     function updateFreeze(address account) onlyOwner public returns(bool success){
216         if (freeze[account]==0){
217           freeze[account]=1;
218         }else{
219           freeze[account]=0;
220         }
221         return true;
222     }
223 
224     function freezeOf(address account) public view returns (uint256 status) {
225         return freeze[account];
226     }
227     
228     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
229         return allowed[_owner][_spender];
230     }
231     
232     function balanceOf(address _owner) public view returns (uint256 balance) {
233         return balances[_owner];
234     }
235 
236     function burn(uint256 _value) public {
237       require(_value <= balances[msg.sender]);
238       address burner = msg.sender;
239       balances[burner] = safeSubtract(balances[burner],_value);
240       totalSupply = safeSubtract(totalSupply, _value);
241       Burn(burner, _value);
242     }
243 
244     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
245         allowed[msg.sender][_spender] = _value;
246         Approval(msg.sender, _spender, _value);
247 
248         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
249         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
250         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
251         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
252         return true;
253     }
254 
255 
256 }