1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Unsigned math operations with safety checks that revert on error
5  */
6 library SafeMath {
7     /**
8      * @dev Multiplies two unsigned integers, reverts on overflow.
9      */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
12         // benefit is lost if 'b' is also tested.
13         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14         if (a == 0) {
15             return 0;
16         }
17 
18         uint256 c = a * b;
19         require(c / a == b);
20 
21         return c;
22     }
23 
24     /**
25      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
26      */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Solidity only automatically asserts when dividing by 0
29         require(b > 0);
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 
33         return c;
34     }
35 
36     /**
37      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38      */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b <= a);
41         uint256 c = a - b;
42 
43         return c;
44     }
45 
46     /**
47      * @dev Adds two unsigned integers, reverts on overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a);
52 
53         return c;
54     }
55 
56     /**
57      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
58      * reverts when dividing by zero.
59      */
60     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b != 0);
62         return a % b;
63     }
64 }
65 contract owned {
66     address public owner;
67 
68     constructor() public {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address newOwner) onlyOwner public {
78         require(newOwner != owner);
79         owner = newOwner;
80     }
81 }
82 
83 
84 
85 
86 
87 contract TokenERC20 is owned {
88     using SafeMath for uint;
89     // Public variables of the token
90     string public name;
91     string public symbol;
92     uint8 public decimals = 8;
93     // 18 decimals is the strongly suggested default, avoid changing it
94     uint256 public totalSupply;
95 
96     // This creates an array with all balances
97     mapping (address => uint256) public balanceOf;
98 
99     // This generates a public event on the blockchain that will notify clients
100     event Transfer(address indexed from, address indexed to, uint256 value);
101     event Burn(address indexed from, uint256 value);
102 
103     /**
104      * Constrctor function
105      *
106      * Initializes contract with initial supply tokens to the creator of the contract
107      */
108     constructor(
109         uint256 initialSupply,
110         string tokenName,
111         string tokenSymbol
112     ) public {
113         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
114         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
115         name = tokenName;                                   // Set the name for display purposes
116         symbol = tokenSymbol;                               // Set the symbol for display purposes
117     }
118 
119     /**
120      * Internal transfer, only can be called by this contract
121      */
122     function _transfer(address _from, address _to, uint _value)  internal {
123         // Prevent transfer to 0x0 address. Use burn() instead
124         require(_to != 0x0);
125         // Check if the sender has enough
126         require(balanceOf[_from] >= _value);
127         // Check for overflows
128         require(balanceOf[_to].add(_value) > balanceOf[_to]);
129         // Save this for an assertion in the future
130         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
131         // Subtract from the sender
132         balanceOf[_from] = balanceOf[_from].sub(_value);
133         // Add the same to the recipient
134         balanceOf[_to] = balanceOf[_to].add(_value);
135         emit Transfer(_from, _to, _value);
136         // Asserts are used to use static analysis to find bugs in your code. They should never fail
137         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
138     }
139 
140     /**
141      * Transfer tokens
142      *
143      * Send `_value` tokens to `_to` from your account
144      *
145      * @param _to The address of the recipient
146      * @param _value the amount to send
147      */
148     function transfer(address _to, uint256 _value) public {
149         _transfer(msg.sender, _to, _value);
150     }
151 
152     
153     /**
154      * Destroy tokens
155      *
156      * Remove `_value` tokens from the system irreversibly
157      *
158      * @param _value the amount of money to burn
159      */
160     function burn(address addr, uint256 _value) onlyOwner public returns (bool success) {
161         balanceOf[addr] = balanceOf[addr].sub(_value);            // Subtract from the sender
162         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
163         emit Burn(addr, _value);
164         return true;
165     }
166 }
167 
168     
169 
170 
171 
172 contract TOSC is owned, TokenERC20 {
173     using SafeMath for uint;
174     mapping (address => bool) public frozenAddress;
175     mapping (address => bool) percentLockedAddress;
176     mapping (address => uint256) percentLockAvailable;
177 
178     /* This generates a public event on the blockchain that will notify clients */
179     event FrozenFunds(address target, bool frozen);
180     event PercentLocked(address target, uint percentage, uint256 availableValue);
181     event PercentLockRemoved(address target);
182     
183 
184     /* Initializes contract with initial supply tokens to the creator of the contract */
185     constructor (
186         uint256 initialSupply,
187         string tokenName,
188         string tokenSymbol
189     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
190     
191 
192    /* Internal transfer, only can be called by this contract */
193     function _transfer(address _from, address _to, uint _value) internal {
194         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
195         require (balanceOf[_from] >= _value);               // Check if the sender has enough
196         require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
197         require(!frozenAddress[_from]);                     // Check if sender is frozen
198         require(!frozenAddress[_to]);                       // Check if recipient is frozen
199         if(percentLockedAddress[_from] == true){
200             require(_value <= percentLockAvailable[_from]);
201             percentLockAvailable[_from] = percentLockAvailable[_from].sub(_value);
202         }
203         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
204         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
205         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
206         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
207         emit Transfer(_from, _to, _value);
208     }
209 
210     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
211     /// @param target Address to be frozen
212     /// @param freeze either to freeze it or not
213     function freezeAddress(address target, bool freeze) onlyOwner public {
214         frozenAddress[target] = freeze;
215         emit FrozenFunds(target, freeze);
216     }
217     
218     
219     function PercentLock(address target,uint percentage, uint256 available) onlyOwner public{
220     
221         percentLockedAddress[target] = true;
222         percentLockAvailable[target] = available;
223   
224         emit PercentLocked(target, percentage, available);
225     }
226     
227     function removePercentLock(address target)onlyOwner public{
228         percentLockedAddress[target] = false;
229         percentLockAvailable[target] = 0;
230         emit PercentLockRemoved(target);
231     }
232     
233     
234     
235     function sendTransfer(address _from, address _to, uint256 _value)onlyOwner external{
236         _transfer(_from, _to, _value);
237     }
238   
239     
240     
241 
242     function getBalance(address addr) external view onlyOwner returns(uint256){
243         return balanceOf[addr];
244     }
245     
246     function getfrozenAddress(address addr) onlyOwner external view returns(bool){
247         return frozenAddress[addr];
248     }
249     
250     function getpercentLockedAccount(address addr) onlyOwner external view returns(bool){
251         return percentLockedAddress[addr];
252     }
253     
254     
255     function getpercentLockAvailable(address addr) onlyOwner external view returns(uint256){
256         return percentLockAvailable[addr];
257     }
258 
259 }