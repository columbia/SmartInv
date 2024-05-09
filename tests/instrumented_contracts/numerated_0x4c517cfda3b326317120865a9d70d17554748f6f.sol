1 pragma solidity ^0.4.24;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/
5 // from https://github.com/ConsenSys/Tokens/blob/master/contracts/eip20/EIP20Interface.sol
6 contract EIP20Interface {
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) public view returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) public returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) public returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
46 
47     // solhint-disable-next-line no-simple-event-func-name  
48     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52  /// @dev lots token (an ERC20 token) contract
53  /// @dev Token distribution is also included
54  /// @dev Tokens reserved for fundraising (50%) can be withdraw any time
55  /// @dev Tokens reserved for the foundation (5%) and the team (20%) can be withdrawn in a monthly base, for 48 months
56  /// @dev Tokens reserved for the community (25%) can be withdrawn in a yealy base, 50%, 30%, 10%, 10% for each year, respectively
57 contract LOTS is EIP20Interface {
58     using SafeMath for uint;
59 
60     mapping (address => uint256) public balances;
61     mapping (address => mapping (address => uint256)) public allowed;
62 
63     string public constant name = "LOTS Token";                 
64     uint8 public constant decimals = 18;     
65     string public constant symbol = "LOTS";                 
66     uint public constant finalSupply = 10**9 * 10**uint(decimals); // 1 billion
67     uint public totalSupply;  // total supply is dynamically added when new tokens are minted
68 
69     // distrubutions of final supply
70     uint public constant fundraisingReservation = 50 * finalSupply / 100;
71     uint public constant foundationReservation = 5 * finalSupply / 100;
72     uint public constant communityReservation = 25 * finalSupply / 100;
73     uint public constant teamReservation = 20 * finalSupply / 100;
74 
75     // each part can be withdrawed once the next withdraw day is reached
76     // Attention: if former withdraw is not conducted, the next withdraw will be delayed
77     uint public nextWithdrawDayFoundation;
78     uint public nextWithdrawDayCommunity;
79     uint public nextWithdrawDayTeam;
80 
81     uint public withdrawedFundrasingPart; // tokens belongs to the fundrasing part that are already withdrawn
82     uint public withdrawedFoundationCounter;  // each month the counter plus 1
83     uint public withdrawedCoummunityCounter;  // each year the counter plus 1
84     uint public withdrawedTeamCounter;  //each month the counter plus 1
85     
86     address public manager; // who may decide the address to withdraw, as well as pause the circulation
87     bool public paused; // whether the circulation is paused
88 
89     event Burn(address _from, uint _value);
90 
91     modifier onlyManager() {
92         require(msg.sender == manager);
93         _;
94     }
95 
96     modifier notPaused() {
97         require(paused == false);
98         _;
99     }
100 
101     constructor() public {
102         manager = msg.sender;
103         nextWithdrawDayFoundation = now;
104         nextWithdrawDayCommunity = now;
105         nextWithdrawDayTeam = now;
106     }
107 
108     /// @dev pause or restart the circulaton
109     function pause() public onlyManager() {
110         paused = !paused;
111     }
112 
113     function withdrawFundraisingPart(address _to, uint _value) public onlyManager() {
114         require(_value.add(withdrawedFundrasingPart) <= fundraisingReservation);
115         balances[_to] = balances[_to].add(_value);
116         totalSupply = totalSupply.add(_value);
117         withdrawedFundrasingPart = withdrawedFundrasingPart.add(_value);
118         emit Transfer(address(this), _to, _value);
119     }
120 
121     function withdrawFoundationPart(address _to) public onlyManager() {
122         require(now > nextWithdrawDayFoundation);
123         require(withdrawedFoundationCounter < 48);
124         balances[_to] = balances[_to].add(foundationReservation / 48);
125         withdrawedFoundationCounter += 1;
126         nextWithdrawDayFoundation += 30 days;
127         totalSupply = totalSupply.add(foundationReservation / 48);
128         emit Transfer(address(this), _to, foundationReservation / 48);
129     }
130 
131     function withdrawCommunityPart(address _to) public onlyManager() {
132         require(now > nextWithdrawDayCommunity);
133         uint _value;
134         if (withdrawedCoummunityCounter == 0) {
135             _value = communityReservation / 2;
136         } else if (withdrawedCoummunityCounter == 1) {
137             _value = communityReservation * 3 / 10;
138         } else if (withdrawedCoummunityCounter == 2 || withdrawedCoummunityCounter == 3) {
139             _value = communityReservation / 10;
140         } else {
141             return;
142         }
143         balances[_to] = balances[_to].add(_value);
144         withdrawedCoummunityCounter += 1;
145         nextWithdrawDayCommunity += 365 days;
146         totalSupply = totalSupply.add(_value);
147         emit Transfer(address(this), _to, _value);
148     }
149 
150     function withdrawTeam(address _to) public onlyManager() {
151         require(now > nextWithdrawDayTeam);
152         require(withdrawedTeamCounter < 48);
153         balances[_to] = balances[_to].add(teamReservation / 48);
154         withdrawedTeamCounter += 1;
155         nextWithdrawDayTeam += 30 days;
156         totalSupply = totalSupply.add(teamReservation / 48);
157         emit Transfer(address(this), _to, teamReservation / 48);
158     }
159 
160     /// @dev remove owned tokens from circulation and destory them
161     function burn(uint _value) public returns (bool success) {
162         totalSupply = totalSupply.sub(_value);
163         balances[msg.sender] = balances[msg.sender].sub(_value);
164         emit Burn(msg.sender, _value);
165         return true;
166     }
167 
168     /**
169      * @dev Increase the amount of tokens that an owner allowed to a spender. *
170      * approve should be called when allowed[_spender] == 0. To increment
171      * allowed value is better to use this function to avoid 2 calls (and wait until
172      * the first transaction is mined)
173      * From MonolithDAO Token.sol
174      * @param _spender The address which will spend the funds.
175      * @param _addedValue The amount of tokens to increase the allowance by.
176      */
177     function increaseApproval(address _spender, uint _addedValue) public returns(bool)
178     {
179         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183     
184     /**
185      * @dev Decrease the amount of tokens that an owner allowed to a spender. *
186      * approve should be called when allowed[_spender] == 0. To decrement
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * @param _spender The address which will spend the funds.
191      * @param _subtractedValue The amount of tokens to decrease the allowance by.
192      */
193     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool)
194     {
195         uint oldValue = allowed[msg.sender][_spender];
196         if (_subtractedValue > oldValue){
197             allowed[msg.sender][_spender] = 0;
198         } else {
199             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200         }
201         return true;
202     }
203     
204     /// below are the standerd functions of ERC20 tokens
205 
206     function transfer(address _to, uint _value) public notPaused() returns (bool success) {
207         require(balances[msg.sender] >= _value);
208         balances[msg.sender] = balances[msg.sender].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         emit Transfer(msg.sender, _to, _value);
211         return true;
212     }
213 
214     function transferFrom(address _from, address _to, uint _value) public notPaused() returns (bool success) {
215         uint allowance = allowed[_from][msg.sender];
216         require(balances[_from] >= _value && allowance >= _value);
217         balances[_to] = balances[_to].add(_value);
218         balances[_from] = balances[_from].sub(_value);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220 
221         emit Transfer(_from, _to, _value);
222         return true;
223     }
224 
225     function balanceOf(address _owner) public view returns (uint balance) {
226         return balances[_owner];
227     }
228 
229     function approve(address _spender, uint256 _value) public returns (bool success) {
230         allowed[msg.sender][_spender] = _value;
231         emit Approval(msg.sender, _spender, _value);
232         return true;
233     }
234 
235     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
236         return allowed[_owner][_spender];
237     }   
238 }
239 
240 /**
241  * @title SafeMat
242  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
243  * @dev Math operations with safety checks that throw on error
244  */
245 library SafeMath {
246 
247   /**
248   * @dev Multiplies two numbers, throws on overflow.
249   */
250   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
251     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
252     // benefit is lost if 'b' is also tested.
253     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
254     if (a == 0) {
255       return 0;
256     }
257 
258     c = a * b;
259     assert(c / a == b);
260     return c;
261   }
262 
263   /**
264   * @dev Integer division of two numbers, truncating the quotient.
265   */
266   function div(uint256 a, uint256 b) internal pure returns (uint256) {
267     // assert(b > 0); // Solidity automatically throws when dividing by 0
268     // uint256 c = a / b;
269     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
270     return a / b;
271   }
272 
273   /**
274   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
275   */
276   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
277     assert(b <= a);
278     return a - b;
279   }
280 
281   /**
282   * @dev Adds two numbers, throws on overflow.
283   */
284   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
285     c = a + b;
286     assert(c >= a);
287     return c;
288   }
289 }