1 pragma solidity ^0.4.17;
2 
3  /*
4  * Contract that is working with ERC223 tokens
5  * https://github.com/ethereum/EIPs/issues/223
6  */
7 
8 /// @title ERC223ReceivingContract - Standard contract implementation for compatibility with ERC223 tokens.
9 contract ERC223ReceivingContract {
10 
11     /// @dev Function that is called when a user or another contract wants to transfer funds.
12     /// @param _from Transaction initiator, analogue of msg.sender
13     /// @param _value Number of tokens to transfer.
14     /// @param _data Data containig a function signature and/or parameters
15     function tokenFallback(address _from, uint256 _value, bytes _data) public;
16 }
17 
18 /// @title Base Token contract - Functions to be implemented by token contracts.
19 contract Token {
20     /*
21      * Implements ERC 20 standard.
22      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
23      * https://github.com/ethereum/EIPs/issues/20
24      *
25      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
26      *  https://github.com/ethereum/EIPs/issues/223
27      */
28 
29     /*
30      * This is a slight change to the ERC20 base standard.
31      * function totalSupply() constant returns (uint256 supply);
32      * is replaced with:
33      * uint256 public totalSupply;
34      * This automatically creates a getter function for the totalSupply.
35      * This is moved to the base contract since public getter functions are not
36      * currently recognised as an implementation of the matching abstract
37      * function by the compiler.
38      */
39     uint256 public totalSupply;
40 
41     /*
42      * ERC 20
43      */
44     function balanceOf(address _owner) public constant returns (uint256 balance);
45     function transfer(address _to, uint256 _value) public returns (bool success);
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
47     function approve(address _spender, uint256 _value) public returns (bool success);
48     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
49 
50     /*
51      * ERC 223
52      */
53     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
54 
55     /*
56      * Events
57      */
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61     // There is no ERC223 compatible Transfer event, with `_data` included.
62 }
63 
64 /// @title Standard token contract - Standard token implementation.
65 contract StandardToken is Token {
66 
67     /*
68      * Data structures
69      */
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 
73     /*
74      * Public functions
75      */
76     /// @notice Send `_value` tokens to `_to` from `msg.sender`.
77     /// @dev Transfers sender's tokens to a given address. Returns success.
78     /// @param _to Address of token receiver.
79     /// @param _value Number of tokens to transfer.
80     /// @return Returns success of function call.
81     function transfer(address _to, uint256 _value) public returns (bool) {
82         require(_to != 0x0);
83         require(_to != address(this));
84         require(balances[msg.sender] >= _value);
85         require(balances[_to] + _value >= balances[_to]);
86 
87         balances[msg.sender] -= _value;
88         balances[_to] += _value;
89 
90         Transfer(msg.sender, _to, _value);
91 
92         return true;
93     }
94 
95     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
96     /// tokenFallback if sender is a contract.
97     /// @dev Function that is called when a user or another contract wants to transfer funds.
98     /// @param _to Address of token receiver.
99     /// @param _value Number of tokens to transfer.
100     /// @param _data Data to be sent to tokenFallback
101     /// @return Returns success of function call.
102     function transfer(
103         address _to,
104         uint256 _value,
105         bytes _data)
106         public
107         returns (bool)
108     {
109         require(transfer(_to, _value));
110 
111         uint codeLength;
112 
113         assembly {
114             // Retrieve the size of the code on target address, this needs assembly.
115             codeLength := extcodesize(_to)
116         }
117 
118         if (codeLength > 0) {
119             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
120             receiver.tokenFallback(msg.sender, _value, _data);
121         }
122 
123         return true;
124     }
125 
126     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
127     /// @dev Allows for an approved third party to transfer tokens from one
128     /// address to another. Returns success.
129     /// @param _from Address from where tokens are withdrawn.
130     /// @param _to Address to where tokens are sent.
131     /// @param _value Number of tokens to transfer.
132     /// @return Returns success of function call.
133     function transferFrom(address _from, address _to, uint256 _value)
134         public
135         returns (bool)
136     {
137         require(_from != 0x0);
138         require(_to != 0x0);
139         require(_to != address(this));
140         require(balances[_from] >= _value);
141         require(allowed[_from][msg.sender] >= _value);
142         require(balances[_to] + _value >= balances[_to]);
143 
144         balances[_to] += _value;
145         balances[_from] -= _value;
146         allowed[_from][msg.sender] -= _value;
147 
148         Transfer(_from, _to, _value);
149 
150         return true;
151     }
152 
153     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
154     /// @dev Sets approved amount of tokens for spender. Returns success.
155     /// @param _spender Address of allowed account.
156     /// @param _value Number of approved tokens.
157     /// @return Returns success of function call.
158     function approve(address _spender, uint256 _value) public returns (bool) {
159         require(_spender != 0x0);
160 
161         // To change the approve amount you first have to reduce the addresses`
162         // allowance to zero by calling `approve(_spender, 0)` if it is not
163         // already 0 to mitigate the race condition described here:
164         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165         require(_value == 0 || allowed[msg.sender][_spender] == 0);
166 
167         allowed[msg.sender][_spender] = _value;
168         Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     /*
173      * Read functions
174      */
175     /// @dev Returns number of allowed tokens that a spender can transfer on
176     /// behalf of a token owner.
177     /// @param _owner Address of token owner.
178     /// @param _spender Address of token spender.
179     /// @return Returns remaining allowance for spender.
180     function allowance(address _owner, address _spender)
181         constant
182         public
183         returns (uint256)
184     {
185         return allowed[_owner][_spender];
186     }
187 
188     /// @dev Returns number of tokens owned by the given address.
189     /// @param _owner Address of token owner.
190     /// @return Returns balance of owner.
191     function balanceOf(address _owner) constant public returns (uint256) {
192         return balances[_owner];
193     }
194 }
195 
196 
197 contract RealFundToken is StandardToken {
198 
199   string constant public name = "REAL FUND Token";
200   string constant public symbol = "REF";
201   uint8 constant public decimals = 8;
202   uint constant multiplier = 10 ** uint(decimals);
203 
204   event Deployed(uint indexed _totalSupply);
205   event Burnt(address indexed _receiver, uint indexed _num, uint indexed _totalSupply);
206 
207   function RealFundToken(address walletAddress) public {
208     require(walletAddress != 0x0);
209 
210     totalSupply = 5000000000000000;
211     balances[walletAddress] = totalSupply;
212     Transfer(0x0, walletAddress, totalSupply);
213   }
214 
215   function burn(uint num) public {
216         require(num > 0);
217         require(balances[msg.sender] >= num);
218         require(totalSupply >= num);
219 
220         uint preBalance = balances[msg.sender];
221 
222         balances[msg.sender] -= num;
223         totalSupply -= num;
224         Burnt(msg.sender, num, totalSupply);
225         Transfer(msg.sender, 0x0, num);
226 
227         assert(balances[msg.sender] == preBalance - num);
228     }
229 }
230 
231 contract PreSale {
232     RealFundToken public token;
233     address public walletAddress;
234     
235     uint public amountRaised;
236     
237     uint public bonus;
238     uint public price;    
239     uint public minSaleAmount;
240 
241     function PreSale(RealFundToken _token, address _walletAddress) public {
242         token = RealFundToken(_token);
243         walletAddress = _walletAddress;
244         bonus = 25;
245         price = 200000000;
246         minSaleAmount = 100000000;
247     }
248 
249     function () public payable {
250         uint amount = msg.value;
251         uint tokenAmount = amount / price;
252         require(tokenAmount >= minSaleAmount);
253         amountRaised += amount;
254         token.transfer(msg.sender, tokenAmount * (100 + bonus) / 100);
255     }
256     
257     function ChangeWallet(address _walletAddress) public {
258         require(msg.sender == walletAddress);
259         walletAddress = _walletAddress;
260     }
261 
262     function TransferETH(address _to, uint _amount) public {
263         require(msg.sender == walletAddress);
264         _to.transfer(_amount);
265     }
266 
267     function TransferTokens(address _to, uint _amount) public {
268         require(msg.sender == walletAddress);
269         token.transfer(_to, _amount);
270     }
271 
272     function ChangeBonus(uint _bonus) public {
273         require(msg.sender == walletAddress);
274         bonus = _bonus;
275     }
276     
277     function ChangePrice(uint _price) public {
278         require(msg.sender == walletAddress);
279         price = _price;
280     }
281     
282     function ChangeMinSaleAmount(uint _minSaleAmount) public {
283         require(msg.sender == walletAddress);
284         minSaleAmount = _minSaleAmount;
285     }
286 }