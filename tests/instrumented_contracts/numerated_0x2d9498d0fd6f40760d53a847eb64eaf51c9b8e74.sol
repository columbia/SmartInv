1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ETHCON Early Bird Token
5  * @author majoolr.io
6  *
7  * Only allows one token per account. See ETHCON.org for further information.
8  * Implements ERC20 Library at 0x71ecde7c4b184558e8dba60d9f323d7a87411946
9  *
10  * https://github.com/ethereum/EIPs/issues/20
11  * Based on code by FirstBlood:
12  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
13  */
14 
15 library ERC20Lib {
16   using BasicMathLib for uint256;
17 
18   struct TokenStorage {
19     mapping (address => uint256) balances;
20     mapping (address => mapping (address => uint256)) allowed;
21     uint totalSupply;
22   }
23 
24   event Transfer(address indexed from, address indexed to, uint256 value);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26   event ErrorMsg(string msg);
27 
28   /// @dev Called by the Standard Token upon creation.
29   /// @param self Stored token from token contract
30   /// @param _initial_supply The initial token supply
31   function init(TokenStorage storage self, uint256 _initial_supply) {
32     self.totalSupply = _initial_supply;
33     self.balances[msg.sender] = _initial_supply;
34   }
35 
36   /// @dev Transfer tokens from caller's account to another account.
37   /// @param self Stored token from token contract
38   /// @param _to Address to send tokens
39   /// @param _value Number of tokens to send
40   /// @return success True if completed, false otherwise
41   function transfer(TokenStorage storage self, address _to, uint256 _value) returns (bool success) {
42     bool err;
43     uint256 balance;
44 
45     (err,balance) = self.balances[msg.sender].minus(_value);
46     if(err) {
47       ErrorMsg("Balance too low for transfer");
48       return false;
49     }
50     self.balances[msg.sender] = balance;
51     //It's not possible to overflow token supply
52     self.balances[_to] = self.balances[_to] + _value;
53     Transfer(msg.sender, _to, _value);
54     return true;
55   }
56 
57   /// @dev Authorized caller transfers tokens from one account to another
58   /// @param self Stored token from token contract
59   /// @param _from Address to send tokens from
60   /// @param _to Address to send tokens to
61   /// @param _value Number of tokens to send
62   /// @return success True if completed, false otherwise
63   function transferFrom(TokenStorage storage self,
64                         address _from,
65                         address _to,
66                         uint256 _value)
67                         returns (bool success) {
68     var _allowance = self.allowed[_from][msg.sender];
69     bool err;
70     uint256 balanceOwner;
71     uint256 balanceSpender;
72 
73     (err,balanceOwner) = self.balances[_from].minus(_value);
74     if(err) {
75       ErrorMsg("Balance too low for transfer");
76       return false;
77     }
78 
79     (err,balanceSpender) = _allowance.minus(_value);
80     if(err) {
81       ErrorMsg("Transfer exceeds allowance");
82       return false;
83     }
84     self.balances[_from] = balanceOwner;
85     self.allowed[_from][msg.sender] = balanceSpender;
86     self.balances[_to] = self.balances[_to] + _value;
87 
88     Transfer(_from, _to, _value);
89     return true;
90   }
91 
92   /// @dev Retrieve token balance for an account
93   /// @param self Stored token from token contract
94   /// @param _owner Address to retrieve balance of
95   /// @return balance The number of tokens in the subject account
96   function balanceOf(TokenStorage storage self, address _owner) constant returns (uint256 balance) {
97     return self.balances[_owner];
98   }
99 
100   /// @dev Authorize an account to send tokens on caller's behalf
101   /// @param self Stored token from token contract
102   /// @param _spender Address to authorize
103   /// @param _value Number of tokens authorized account may send
104   /// @return success True if completed, false otherwise
105   function approve(TokenStorage storage self, address _spender, uint256 _value) returns (bool success) {
106     self.allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   /// @dev Remaining tokens third party spender has to send
112   /// @param self Stored token from token contract
113   /// @param _owner Address of token holder
114   /// @param _spender Address of authorized spender
115   /// @return remaining Number of tokens spender has left in owner's account
116   function allowance(TokenStorage storage self, address _owner, address _spender) constant returns (uint256 remaining) {
117     return self.allowed[_owner][_spender];
118   }
119 }
120 
121 library BasicMathLib {
122   event Err(string typeErr);
123 
124   /// @dev Multiplies two numbers and checks for overflow before returning.
125   /// Does not throw but rather logs an Err event if there is overflow.
126   /// @param a First number
127   /// @param b Second number
128   /// @return err False normally, or true if there is overflow
129   /// @return res The product of a and b, or 0 if there is overflow
130   function times(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
131     assembly{
132       res := mul(a,b)
133       jumpi(allGood, or(iszero(b), eq(div(res,b), a)))
134       err := 1
135       res := 0
136       allGood:
137     }
138     if (err)
139       Err("times func overflow");
140   }
141 
142   /// @dev Divides two numbers but checks for 0 in the divisor first.
143   /// Does not throw but rather logs an Err event if 0 is in the divisor.
144   /// @param a First number
145   /// @param b Second number
146   /// @return err False normally, or true if `b` is 0
147   /// @return res The quotient of a and b, or 0 if `b` is 0
148   function dividedBy(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
149     assembly{
150       jumpi(e, iszero(b))
151       res := div(a,b)
152       mstore(add(mload(0x40),0x20),res)
153       return(mload(0x40),0x40)
154       e:
155     }
156     Err("tried to divide by zero");
157     return (true, 0);
158   }
159 
160   /// @dev Adds two numbers and checks for overflow before returning.
161   /// Does not throw but rather logs an Err event if there is overflow.
162   /// @param a First number
163   /// @param b Second number
164   /// @return err False normally, or true if there is overflow
165   /// @return res The sum of a and b, or 0 if there is overflow
166   function plus(uint256 a, uint256 b) constant returns (bool err, uint256 res) {
167     assembly{
168       res := add(a,b)
169       jumpi(allGood, and(eq(sub(res,b), a), gt(res,b)))
170       err := 1
171       res := 0
172       allGood:
173     }
174     if (err)
175       Err("plus func overflow");
176   }
177 
178   /// @dev Subtracts two numbers and checks for underflow before returning.
179   /// Does not throw but rather logs an Err event if there is underflow.
180   /// @param a First number
181   /// @param b Second number
182   /// @return err False normally, or true if there is underflow
183   /// @return res The difference between a and b, or 0 if there is underflow
184   function minus(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
185     assembly{
186       res := sub(a,b)
187       jumpi(allGood, eq(and(eq(add(res,b), a), or(lt(res,a), eq(res,a))), 1))
188       err := 1
189       res := 0
190       allGood:
191     }
192     if (err)
193       Err("minus func underflow");
194   }
195 }
196 
197 contract ETHCONEarlyBirdToken {
198    using ERC20Lib for ERC20Lib.TokenStorage;
199 
200    ERC20Lib.TokenStorage token;
201 
202    string public name = "ETHCON-Early-Bird";
203    string public symbol = "THX";
204    uint public decimals = 0;
205    uint public INITIAL_SUPPLY = 600;
206 
207    event ErrorMsg(string msg);
208 
209    function ETHCONEarlyBirdToken() {
210      token.init(INITIAL_SUPPLY);
211    }
212 
213    function totalSupply() constant returns (uint) {
214      return token.totalSupply;
215    }
216 
217    function balanceOf(address who) constant returns (uint) {
218      return token.balanceOf(who);
219    }
220 
221    function allowance(address owner, address spender) constant returns (uint) {
222      return token.allowance(owner, spender);
223    }
224 
225    function transfer(address to, uint value) returns (bool ok) {
226      if(token.balanceOf(to) == 0){
227        return token.transfer(to, value);
228      } else {
229        ErrorMsg("Recipient already has token");
230        return false;
231      }
232 
233    }
234 
235    function transferFrom(address from, address to, uint value) returns (bool ok) {
236      if(token.balanceOf(to) == 0){
237        return token.transferFrom(from, to, value);
238      } else {
239        ErrorMsg("Recipient already has token");
240        return false;
241      }
242    }
243 
244    function approve(address spender, uint value) returns (bool ok) {
245      return token.approve(spender, value);
246    }
247 
248    event Transfer(address indexed from, address indexed to, uint value);
249    event Approval(address indexed owner, address indexed spender, uint value);
250 }