1 pragma solidity ^0.4.13;
2 
3 contract BtzReceiver {
4     using SafeMath for *;
5 
6     // BTZReceiver state variables
7     BtzToken BTZToken;
8     address public tokenAddress = 0x0;
9     address public owner;
10     uint numUsers;
11 
12     // Struct to store user info
13     struct UserInfo {
14         uint totalDepositAmount;
15         uint totalDepositCount;
16         uint lastDepositAmount;
17         uint lastDepositTime;
18     }
19 
20     event DepositReceived(uint indexed _who, uint _value, uint _timestamp);
21     event Withdrawal(address indexed _withdrawalAddress, uint _value, uint _timestamp);
22 
23     // mapping of user info indexed by the user ID
24     mapping (uint => UserInfo) userInfo;
25 
26     constructor() {
27         owner = msg.sender;
28     }
29 
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     function setOwner(address _addr) public onlyOwner {
36         owner = _addr;
37     }
38 
39     /*
40     * @dev Gives admin the ability to update the address of BTZ223
41     *
42     * @param _tokenAddress The new address of BTZ223
43     **/
44     function setTokenContractAddress(address _tokenAddress) public onlyOwner {
45         tokenAddress = _tokenAddress;
46         BTZToken = BtzToken(_tokenAddress);
47     }
48 
49     /*
50     * @dev Returns the information of a user
51     *
52     * @param _uid The id of the user whose info to return
53     **/
54     function userLookup(uint _uid) public view returns (uint, uint, uint, uint){
55         return (userInfo[_uid].totalDepositAmount, userInfo[_uid].totalDepositCount, userInfo[_uid].lastDepositAmount, userInfo[_uid].lastDepositTime);
56     }
57 
58     /*
59     * @dev The function BTZ223 uses to update user info in this contract
60     *
61     * @param _id The users Bunz Application User ID
62     * @param _value The number of tokens to deposit
63     **/
64     function receiveDeposit(uint _id, uint _value) public {
65         require(msg.sender == tokenAddress);
66         userInfo[_id].totalDepositAmount = userInfo[_id].totalDepositAmount.add(_value);
67         userInfo[_id].totalDepositCount = userInfo[_id].totalDepositCount.add(1);
68         userInfo[_id].lastDepositAmount = _value;
69         userInfo[_id].lastDepositTime = now;
70         emit DepositReceived(_id, _value, now);
71     }
72 
73     /*
74     * @dev The withdrawal function for admin
75     *
76     * @param _withdrawalAddr The admins address to withdraw the BTZ223 tokens to
77     **/
78     function withdrawTokens(address _withdrawalAddr) public onlyOwner{
79         uint tokensToWithdraw = BTZToken.balanceOf(this);
80         BTZToken.transfer(_withdrawalAddr, tokensToWithdraw);
81         emit Withdrawal(_withdrawalAddr, tokensToWithdraw, now);
82     }
83 }
84 
85 contract ERC20 {
86   uint public totalSupply;
87   function balanceOf(address who) constant returns (uint);
88   function allowance(address owner, address spender) constant returns (uint);
89 
90   function transfer(address to, uint value) returns (bool ok);
91   function transferFrom(address from, address to, uint value) returns (bool ok);
92   function approve(address spender, uint value) returns (bool ok);
93   event Transfer(address indexed from, address indexed to, uint value);
94   event Approval(address indexed owner, address indexed spender, uint value);
95 }
96 
97 contract StandardToken is ERC20 {
98   using SafeMath for *;
99 
100   mapping(address => uint) balances;
101   mapping (address => mapping (address => uint)) allowed;
102 
103   function transfer(address _to, uint _value) public returns (bool success) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_to] = balances[_to].add(_value);
119     balances[_from] = balances[_from].sub(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     emit Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   function balanceOf(address _owner) public constant returns (uint balance) {
126     return balances[_owner];
127   }
128 
129   function approve(address _spender, uint _value) public returns (bool success) {
130     require(_value <= balances[msg.sender]);
131     allowed[msg.sender][_spender] = _value;
132     emit Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
137     return allowed[_owner][_spender];
138   }
139 }
140 
141 contract ERC223 is ERC20 {
142   function transfer(address to, uint value, bytes data) returns (bool ok);
143   function transferFrom(address from, address to, uint value, bytes data) returns (bool ok);
144 }
145 
146 contract Standard223Token is ERC223, StandardToken {
147   //function that is called when a user or another contract wants to transfer funds
148   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
149     //filtering if the target is a contract with bytecode inside it
150     if (!super.transfer(_to, _value)) throw; // do a normal token transfer
151     if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
152     return true;
153   }
154 
155   function transferFrom(address _from, address _to, uint _value, bytes _data) returns (bool success) {
156     if (!super.transferFrom(_from, _to, _value)) revert(); // do a normal token transfer
157     if (isContract(_to)) return contractFallback(_from, _to, _value, _data);
158     return true;
159   }
160 
161   function transfer(address _to, uint _value) returns (bool success) {
162     return transfer(_to, _value, new bytes(0));
163   }
164 
165   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
166     return transferFrom(_from, _to, _value, new bytes(0));
167   }
168 
169   //function that is called when transaction target is a contract
170   function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {
171     ERC223Receiver reciever = ERC223Receiver(_to);
172     return reciever.tokenFallback(msg.sender, _origin, _value, _data);
173   }
174 
175   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
176   function isContract(address _addr) private returns (bool is_contract) {
177     // retrieve the size of the code on target address, this needs assembly
178     uint length;
179     assembly { length := extcodesize(_addr) }
180     return length > 0;
181   }
182 }
183 
184 contract BtzToken is Standard223Token {
185   using SafeMath for *;
186   address public owner;
187 
188   // BTZ Token parameters
189   string public name = "BTZ by Bunz";
190   string public symbol = "BTZ";
191   uint8 public constant decimals = 18;
192   uint256 public constant decimalFactor = 10 ** uint256(decimals);
193   uint256 public constant totalSupply = 200000000000 * decimalFactor;
194 
195   // Variables for deposit functionality
196   bool public prebridge;
197   BtzReceiver receiverContract;
198   address public receiverContractAddress = 0x0;
199 
200   event Deposit(address _to, uint _value);
201 
202   /**
203   * @dev Constructor function for BTZ creation
204   */
205   constructor() public {
206     owner = msg.sender;
207     balances[owner] = totalSupply;
208     prebridge = true;
209     receiverContract = BtzReceiver(receiverContractAddress);
210 
211     Transfer(address(0), owner, totalSupply);
212   }
213 
214   modifier onlyOwner() {
215       require(msg.sender == owner);
216       _;
217   }
218 
219   function setOwner(address _addr) public onlyOwner {
220       owner = _addr;
221   }
222 
223   /**
224   * @dev Gives admin the ability to switch prebridge states.
225   *
226   */
227   function togglePrebrdige() onlyOwner {
228       prebridge = !prebridge;
229   }
230 
231   /**
232   * @dev Gives admin the ability to update the address of reciever contract
233   *
234   * @param _newAddr The address of the new receiver contract
235   */
236   function setReceiverContractAddress(address _newAddr) onlyOwner {
237       receiverContractAddress = _newAddr;
238       receiverContract = BtzReceiver(_newAddr);
239   }
240 
241   /**
242   * @dev Deposit function for users to send tokens to Bunz Application
243   *
244   * @param _value A uint representing the amount of BTZ to deposit
245   */
246   function deposit(uint _id, uint _value) public {
247       require(prebridge &&
248               balances[msg.sender] >= _value);
249       balances[msg.sender] = balances[msg.sender].sub(_value);
250       balances[receiverContractAddress] = balances[receiverContractAddress].add(_value);
251       emit Transfer(msg.sender, receiverContractAddress, _value);
252       receiverContract.receiveDeposit(_id, _value);
253   }
254 }
255 
256 contract ERC223Receiver {
257   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok);
258 }
259 
260 library SafeMath {
261 
262   /**
263   * @dev Multiplies two numbers, throws on overflow.
264   */
265   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
266     if (a == 0) {
267       return 0;
268     }
269     uint256 c = a * b;
270     assert(c / a == b);
271     return c;
272   }
273 
274   /**
275   * @dev Integer division of two numbers, truncating the quotient.
276   */
277   function div(uint256 a, uint256 b) internal pure returns (uint256) {
278     // assert(b > 0); // Solidity automatically throws when dividing by 0
279     uint256 c = a / b;
280     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
281     return c;
282   }
283 
284   /**
285   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
286   */
287   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288     assert(b <= a);
289     return a - b;
290   }
291 
292   /**
293   * @dev Adds two numbers, throws on overflow.
294   */
295   function add(uint256 a, uint256 b) internal pure returns (uint256) {
296     uint256 c = a + b;
297     assert(c >= a);
298     return c;
299   }
300 }