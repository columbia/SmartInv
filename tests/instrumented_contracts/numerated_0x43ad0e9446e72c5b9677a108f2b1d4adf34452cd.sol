1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Token {
46     /* This is a slight change to the ERC20 base standard.
47     function totalSupply() constant returns (uint256 supply);
48     is replaced with:
49     uint256 public totalSupply;
50     This automatically creates a getter function for the totalSupply.
51     This is moved to the base contract since public getter functions are not
52     currently recognised as an implementation of the matching abstract
53     function by the compiler.
54     */
55     /// total amount of tokens
56     uint256 public totalSupply;
57 
58     /// @param _owner The address from which the balance will be retrieved
59     /// @return The balance
60     function balanceOf(address _owner) public view returns (uint256 balance);
61 
62     /// @notice send `_value` token to `_to` from `msg.sender`
63     /// @param _to The address of the recipient
64     /// @param _value The amount of token to be transferred
65     /// @return Whether the transfer was successful or not
66     function transfer(address _to, uint256 _value) public returns (bool success);
67 
68     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
69     /// @param _from The address of the sender
70     /// @param _to The address of the recipient
71     /// @param _value The amount of token to be transferred
72     /// @return Whether the transfer was successful or not
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
74 
75     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
76     /// @param _spender The address of the account able to transfer the tokens
77     /// @param _value The amount of tokens to be approved for transfer
78     /// @return Whether the approval was successful or not
79     function approve(address _spender, uint256 _value) public returns (bool success);
80 
81     /// @param _owner The address of the account owning tokens
82     /// @param _spender The address of the account able to transfer the tokens
83     /// @return Amount of remaining tokens allowed to spent
84     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88 }
89 
90 contract PrayerCoinToken is Token {
91 
92     uint256 constant MAX_UINT256 = 2**256 - 1;
93 
94     function transfer(address _to, uint256 _value) public returns (bool success) {
95         //Default assumes totalSupply can't be over max (2^256 - 1).
96         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
97         //Replace the if with this one instead.
98         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
99         require(balances[msg.sender] >= _value);
100         balances[msg.sender] -= _value;
101         balances[_to] += _value;
102         Transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107         //same as above. Replace this line with the following if you want to protect against wrapping uints.
108         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
109         uint256 allowance = allowed[_from][msg.sender];
110         require(balances[_from] >= _value && allowance >= _value);
111         balances[_to] += _value;
112         balances[_from] -= _value;
113         if (allowance < MAX_UINT256) {
114             allowed[_from][msg.sender] -= _value;
115         }
116         Transfer(_from, _to, _value);
117         return true;
118     }
119 
120     function balanceOf(address _owner) view public returns (uint256 balance) {
121         return balances[_owner];
122     }
123 
124     function getBalance(address _owner) view public returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128     function approve(address _spender, uint256 _value) public returns (bool success) {
129         allowed[msg.sender][_spender] = _value;
130         Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
135         return allowed[_owner][_spender];
136     }
137 
138     mapping (address => uint256) balances;
139     mapping (address => mapping (address => uint256)) allowed;
140 }
141 
142 contract Standard {
143     function balanceOf(address _owner) public constant returns (uint256);
144     function transfer(address _to, uint256 _value) public returns (bool);
145 }
146 
147 contract PrayerCoin is PrayerCoinToken {
148   using SafeMath for uint256;
149   address public god;
150 
151   string public name = "PrayerCoin";
152   uint8 public decimals = 18;
153   string public symbol = "PRAY";
154   string public version = 'H1.0';  
155 
156   uint256 public totalSupply = 666666666 ether;
157  
158   uint private PRAY_ETH_RATIO = 6666;
159   uint private PRAY_ETH_RATIO_BONUS1 = 7106;
160   uint private PRAY_ETH_RATIO_BONUS2 = 11066;
161 
162   uint256 public totalDonations = 0;
163   uint256 public totalPrayers = 0;
164 
165   bool private acceptingDonations = true;
166   
167   modifier divine {
168     require(msg.sender == god);
169     _;
170   }
171 
172   function PrayerCoin() public { // initialize contract
173     god = msg.sender;
174     balances[god] = totalSupply; // god holds all of the PRAY
175   } 
176 
177   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180 
181     //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
182     //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
183     //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
184     require(false == _spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
185     return true;
186   } 
187 
188   function startDonations() public divine {
189     acceptingDonations = true;
190   }
191 
192   function endDonations() public divine {
193     acceptingDonations = false;
194   }
195 
196   function fiatSend(address _to, uint256 amt, uint256 prayRatio) public divine {
197     totalDonations += amt;
198     uint256 prayersIssued = amt.mul(prayRatio);
199     totalPrayers += prayersIssued;
200     balances[_to] += prayersIssued;
201     balances[god] -= prayersIssued;
202 
203     Transfer(address(this), _to, prayersIssued);
204   }
205   
206   function() public payable {
207     require(acceptingDonations == true);
208     if (msg.value == 0) { return; }
209 
210     god.transfer(msg.value);
211 
212     totalDonations += msg.value;
213     
214     uint256 prayersIssued = 0;
215 
216     if (totalPrayers <= (6666666 * 1 ether)) {
217         if (totalPrayers <= (666666 * 1 ether)) {
218             prayersIssued = msg.value.mul(PRAY_ETH_RATIO_BONUS2);
219         } else {
220             prayersIssued = msg.value.mul(PRAY_ETH_RATIO_BONUS1);
221         }
222     } else {
223         prayersIssued = msg.value.mul(PRAY_ETH_RATIO);
224     }
225 
226     totalPrayers += prayersIssued;
227     balances[msg.sender] += prayersIssued;
228     balances[god] -= prayersIssued;
229 
230     Transfer(address(this), msg.sender, prayersIssued);
231   }
232  
233 }