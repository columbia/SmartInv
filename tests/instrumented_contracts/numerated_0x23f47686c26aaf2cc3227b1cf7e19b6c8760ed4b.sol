1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ETHCON Early Bird Donation Contract
5  * @author majoolr.io
6  *
7  * Accepts donations and issues ETHCON token if at or above 3.9604 ETH.
8  * See ETHCON.org for further information.
9  * ETHCONEarlyBirdToken contract at 0x2d9498d0fd6f40760d53a847eb64eaf51c9b8e74
10  */
11 
12 contract ETHCONEarlyBirdDonation {
13   address majoolr;
14   ETHCONEarlyBirdToken token;
15 
16   uint256 public donations;
17   mapping (address => uint256) public donationMap;
18   mapping (address => uint256) public failedDonations;
19   uint256 public minimum = 3960400000000000000;
20 
21   event ErrMsg(address indexed _from, string _msg);
22   event ThxMsg(address indexed _from, string _msg);
23 
24   modifier andIsMajoolr {
25     require(msg.sender == majoolr);
26     _;
27   }
28 
29   function(){ ErrMsg(msg.sender, 'No function called'); }
30 
31   function ETHCONEarlyBirdDonation(address _token){
32     token = ETHCONEarlyBirdToken(_token);
33     majoolr = msg.sender;
34   }
35 
36   function donate() payable returns (bool){
37     uint256 totalDonation = donationMap[msg.sender] + msg.value;
38     if(totalDonation < minimum){
39       failedDonations[msg.sender] += msg.value;
40       ErrMsg(msg.sender, "Donation too low, call withdrawDonation()");
41       return false;
42     }
43 
44     bool success = token.transferFrom(majoolr,msg.sender,1);
45     if(!success){
46       failedDonations[msg.sender] += msg.value;
47       ErrMsg(msg.sender, "Transer failed, call withdrawDonation()");
48       return false;
49     }
50 
51     donationMap[msg.sender] += msg.value;
52     donations += msg.value;
53     ThxMsg(msg.sender, "Thank you for your donation!");
54     return true;
55   }
56 
57   function generousDonation() payable returns (bool){
58     uint256 tokensLeft = token.allowance(majoolr, this);
59     if(tokensLeft == 0){
60       failedDonations[msg.sender] += msg.value;
61       ErrMsg(msg.sender, "No more donations here check Majoolr.io, call withdrawDonation()");
62       return false;
63     }
64 
65     donationMap[msg.sender] += msg.value;
66     donations += msg.value;
67     ThxMsg(msg.sender, "Thank you for your donation!");
68     return true;
69   }
70 
71   function withdraw() andIsMajoolr {
72     uint256 amount = donations;
73     donations = 0;
74     msg.sender.transfer(amount);
75   }
76 
77   function withdrawDonation(){
78     uint256 amount = failedDonations[msg.sender];
79     failedDonations[msg.sender] = 0;
80     msg.sender.transfer(amount);
81   }
82 }
83 
84 contract ETHCONEarlyBirdToken {
85    using ERC20Lib for ERC20Lib.TokenStorage;
86 
87    ERC20Lib.TokenStorage token;
88 
89    string public name = "ETHCON-Early-Bird";
90    string public symbol = "THX";
91    uint public decimals = 0;
92    uint public INITIAL_SUPPLY = 600;
93 
94    event ErrorMsg(string msg);
95 
96    function ETHCONEarlyBirdToken() {
97      token.init(INITIAL_SUPPLY);
98    }
99 
100    function totalSupply() constant returns (uint) {
101      return token.totalSupply;
102    }
103 
104    function balanceOf(address who) constant returns (uint) {
105      return token.balanceOf(who);
106    }
107 
108    function allowance(address owner, address spender) constant returns (uint) {
109      return token.allowance(owner, spender);
110    }
111 
112    function transfer(address to, uint value) returns (bool ok) {
113      if(token.balanceOf(to) == 0){
114        return token.transfer(to, value);
115      } else {
116        ErrorMsg("Recipient already has token");
117        return false;
118      }
119 
120    }
121 
122    function transferFrom(address from, address to, uint value) returns (bool ok) {
123      if(token.balanceOf(to) == 0){
124        return token.transferFrom(from, to, value);
125      } else {
126        ErrorMsg("Recipient already has token");
127        return false;
128      }
129    }
130 
131    function approve(address spender, uint value) returns (bool ok) {
132      return token.approve(spender, value);
133    }
134 
135    event Transfer(address indexed from, address indexed to, uint value);
136    event Approval(address indexed owner, address indexed spender, uint value);
137 }
138 
139 library ERC20Lib {
140   using BasicMathLib for uint256;
141 
142   struct TokenStorage {
143     mapping (address => uint256) balances;
144     mapping (address => mapping (address => uint256)) allowed;
145     uint totalSupply;
146   }
147 
148   event Transfer(address indexed from, address indexed to, uint256 value);
149   event Approval(address indexed owner, address indexed spender, uint256 value);
150   event ErrorMsg(string msg);
151 
152   /// @dev Called by the Standard Token upon creation.
153   /// @param self Stored token from token contract
154   /// @param _initial_supply The initial token supply
155   function init(TokenStorage storage self, uint256 _initial_supply) {
156     self.totalSupply = _initial_supply;
157     self.balances[msg.sender] = _initial_supply;
158   }
159 
160   /// @dev Transfer tokens from caller's account to another account.
161   /// @param self Stored token from token contract
162   /// @param _to Address to send tokens
163   /// @param _value Number of tokens to send
164   /// @return success True if completed, false otherwise
165   function transfer(TokenStorage storage self, address _to, uint256 _value) returns (bool success) {
166     bool err;
167     uint256 balance;
168 
169     (err,balance) = self.balances[msg.sender].minus(_value);
170     if(err) {
171       ErrorMsg("Balance too low for transfer");
172       return false;
173     }
174     self.balances[msg.sender] = balance;
175     //It's not possible to overflow token supply
176     self.balances[_to] = self.balances[_to] + _value;
177     Transfer(msg.sender, _to, _value);
178     return true;
179   }
180 
181   /// @dev Authorized caller transfers tokens from one account to another
182   /// @param self Stored token from token contract
183   /// @param _from Address to send tokens from
184   /// @param _to Address to send tokens to
185   /// @param _value Number of tokens to send
186   /// @return success True if completed, false otherwise
187   function transferFrom(TokenStorage storage self,
188                         address _from,
189                         address _to,
190                         uint256 _value)
191                         returns (bool success) {
192     var _allowance = self.allowed[_from][msg.sender];
193     bool err;
194     uint256 balanceOwner;
195     uint256 balanceSpender;
196 
197     (err,balanceOwner) = self.balances[_from].minus(_value);
198     if(err) {
199       ErrorMsg("Balance too low for transfer");
200       return false;
201     }
202 
203     (err,balanceSpender) = _allowance.minus(_value);
204     if(err) {
205       ErrorMsg("Transfer exceeds allowance");
206       return false;
207     }
208     self.balances[_from] = balanceOwner;
209     self.allowed[_from][msg.sender] = balanceSpender;
210     self.balances[_to] = self.balances[_to] + _value;
211 
212     Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /// @dev Retrieve token balance for an account
217   /// @param self Stored token from token contract
218   /// @param _owner Address to retrieve balance of
219   /// @return balance The number of tokens in the subject account
220   function balanceOf(TokenStorage storage self, address _owner) constant returns (uint256 balance) {
221     return self.balances[_owner];
222   }
223 
224   /// @dev Authorize an account to send tokens on caller's behalf
225   /// @param self Stored token from token contract
226   /// @param _spender Address to authorize
227   /// @param _value Number of tokens authorized account may send
228   /// @return success True if completed, false otherwise
229   function approve(TokenStorage storage self, address _spender, uint256 _value) returns (bool success) {
230     self.allowed[msg.sender][_spender] = _value;
231     Approval(msg.sender, _spender, _value);
232     return true;
233   }
234 
235   /// @dev Remaining tokens third party spender has to send
236   /// @param self Stored token from token contract
237   /// @param _owner Address of token holder
238   /// @param _spender Address of authorized spender
239   /// @return remaining Number of tokens spender has left in owner's account
240   function allowance(TokenStorage storage self, address _owner, address _spender) constant returns (uint256 remaining) {
241     return self.allowed[_owner][_spender];
242   }
243 }
244 
245 library BasicMathLib {
246   event Err(string typeErr);
247 
248   /// @dev Multiplies two numbers and checks for overflow before returning.
249   /// Does not throw but rather logs an Err event if there is overflow.
250   /// @param a First number
251   /// @param b Second number
252   /// @return err False normally, or true if there is overflow
253   /// @return res The product of a and b, or 0 if there is overflow
254   function times(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
255     assembly{
256       res := mul(a,b)
257       jumpi(allGood, or(iszero(b), eq(div(res,b), a)))
258       err := 1
259       res := 0
260       allGood:
261     }
262     if (err)
263       Err("times func overflow");
264   }
265 
266   /// @dev Divides two numbers but checks for 0 in the divisor first.
267   /// Does not throw but rather logs an Err event if 0 is in the divisor.
268   /// @param a First number
269   /// @param b Second number
270   /// @return err False normally, or true if `b` is 0
271   /// @return res The quotient of a and b, or 0 if `b` is 0
272   function dividedBy(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
273     assembly{
274       jumpi(e, iszero(b))
275       res := div(a,b)
276       mstore(add(mload(0x40),0x20),res)
277       return(mload(0x40),0x40)
278       e:
279     }
280     Err("tried to divide by zero");
281     return (true, 0);
282   }
283 
284   /// @dev Adds two numbers and checks for overflow before returning.
285   /// Does not throw but rather logs an Err event if there is overflow.
286   /// @param a First number
287   /// @param b Second number
288   /// @return err False normally, or true if there is overflow
289   /// @return res The sum of a and b, or 0 if there is overflow
290   function plus(uint256 a, uint256 b) constant returns (bool err, uint256 res) {
291     assembly{
292       res := add(a,b)
293       jumpi(allGood, and(eq(sub(res,b), a), gt(res,b)))
294       err := 1
295       res := 0
296       allGood:
297     }
298     if (err)
299       Err("plus func overflow");
300   }
301 
302   /// @dev Subtracts two numbers and checks for underflow before returning.
303   /// Does not throw but rather logs an Err event if there is underflow.
304   /// @param a First number
305   /// @param b Second number
306   /// @return err False normally, or true if there is underflow
307   /// @return res The difference between a and b, or 0 if there is underflow
308   function minus(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
309     assembly{
310       res := sub(a,b)
311       jumpi(allGood, eq(and(eq(add(res,b), a), or(lt(res,a), eq(res,a))), 1))
312       err := 1
313       res := 0
314       allGood:
315     }
316     if (err)
317       Err("minus func underflow");
318   }
319 }