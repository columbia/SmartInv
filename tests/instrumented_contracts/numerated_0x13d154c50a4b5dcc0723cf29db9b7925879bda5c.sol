1 pragma solidity ^0.4.18;
2 /**
3  * Overflow aware uint math functions.
4  *
5  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
6  */
7 contract SafeMath {
8   //internals
9 
10   function safeMul(uint a, uint b) internal returns (uint) {
11     uint c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function safeSub(uint a, uint b) internal returns (uint) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function safeAdd(uint a, uint b) internal returns (uint) {
22     uint c = a + b;
23     assert(c>=a && c>=b);
24     return c;
25   }
26 
27   function assert(bool assertion) internal {
28     if (!assertion) throw;
29   }
30 }
31 
32 /**
33  * ERC 20 token
34  *
35  * https://github.com/ethereum/EIPs/issues/20
36  */
37 contract Token {
38 
39     /// @return total amount of tokens
40     function totalSupply() constant returns (uint256 supply) {}
41 
42     /// @param _owner The address from which the balance will be retrieved
43     /// @return The balance
44     function balanceOf(address _owner) constant returns (uint256 balance) {}
45 
46     /// @notice send `_value` token to `_to` from `msg.sender`
47     /// @param _to The address of the recipient
48     /// @param _value The amount of token to be transferred
49     /// @return Whether the transfer was successful or not
50     function transfer(address _to, uint256 _value) returns (bool success) {}
51 
52     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
53     /// @param _from The address of the sender
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
58 
59     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
60     /// @param _spender The address of the account able to transfer the tokens
61     /// @param _value The amount of wei to be approved for transfer
62     /// @return Whether the approval was successful or not
63     function approve(address _spender, uint256 _value) returns (bool success) {}
64 
65     /// @param _owner The address of the account owning tokens
66     /// @param _spender The address of the account able to transfer the tokens
67     /// @return Amount of remaining tokens allowed to spent
68     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 
73 }
74 
75 /**
76  * ERC 20 token
77  *
78  * https://github.com/ethereum/EIPs/issues/20
79  */
80 contract StandardToken is Token {
81 
82     /**
83      * Reviewed:
84      * - Interger overflow = OK, checked
85      */
86     function transfer(address _to, uint256 _value) returns (bool success) {
87         //Default assumes totalSupply can't be over max (2^256 - 1).
88         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
89         //Replace the if with this one instead.
90         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
91         //if (balances[msg.sender] >= _value && _value > 0) {
92             balances[msg.sender] -= _value;
93             balances[_to] += _value;
94             Transfer(msg.sender, _to, _value);
95             return true;
96         } else { return false; }
97     }
98 
99     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
100         //same as above. Replace this line with the following if you want to protect against wrapping uints.
101         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
102         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
103             balances[_to] += _value;
104             balances[_from] -= _value;
105             allowed[_from][msg.sender] -= _value;
106             Transfer(_from, _to, _value);
107             return true;
108         } else { return false; }
109     }
110 
111     function balanceOf(address _owner) constant returns (uint256 balance) {
112         return balances[_owner];
113     }
114 
115     function approve(address _spender, uint256 _value) returns (bool success) {
116         allowed[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
122       return allowed[_owner][_spender];
123     }
124 
125     mapping(address => uint256) balances;
126 
127     mapping (address => mapping (address => uint256)) allowed;
128 
129     uint256 public totalSupply;
130 
131 }
132 
133 
134 /*
135 * monechain token contract
136 */
137 
138 contract monechainToken is StandardToken, SafeMath {
139   string public name = "monechain token";
140   string public symbol = "MONE";
141   uint public decimals = 18;
142   uint crowdSalePrice = 300000;
143   uint totalPeriod = 256 * 24 * 365; // unit: block count, estimate: 7 days
144   /* uint public startBlock = 5275100; //crowdsale start block */
145   uint public startBlock = 5278735; //crowdsale start block
146   uint public endBlock = startBlock + totalPeriod; //crowdsale end block
147 
148   address public founder = 0x466ea8E1003273AE4471c903fBA7D8edF834970a;
149   uint256 bountyAllocation =    4500000000 * 10**(decimals);  //pre-allocation tokens
150   uint256 public crowdSaleCap = 1000000000 * 10**(decimals);  //max token sold during crowdsale
151   uint256 public candyCap =     4500000000 * 10**(decimals);  //max token send as candy
152   uint256 public candyPrice =   1000;  //candy amount per address
153   uint256 public crowdSaleSoldAmount = 0;
154   uint256 public candySentAmount = 0;
155 
156   mapping(address => bool) candyBook;  //candy require record book
157   event Buy(address indexed sender, uint eth, uint fbt);
158 
159   function monechainToken() {
160     // founder = msg.sender;
161     balances[founder] = bountyAllocation;
162     totalSupply = bountyAllocation;
163     Transfer(address(0), founder, bountyAllocation);
164   }
165 
166   function price() constant returns(uint) {
167       if (block.number<startBlock || block.number > endBlock) return 0; //this will not happen according to the buyToken block check, but still set it to 0.
168       else  return crowdSalePrice; // default-ICO
169   }
170 
171   function() public payable  {
172     if(msg.value == 0) {
173       //candy
174       sendCandy(msg.sender);
175     }
176     else {
177       // crowdsale
178       buyToken(msg.sender, msg.value);
179     }
180   }
181 
182   function sendCandy(address recipient) internal {
183     // check the address to see Whether or not it already has a record in the dababase
184     if (candyBook[recipient] || candySentAmount>=candyCap) revert();
185     else {
186       uint candies = candyPrice * 10**(decimals);
187       candyBook[recipient] = true;
188       balances[recipient] = safeAdd(balances[recipient], candies);
189       candySentAmount = safeAdd(candySentAmount, candies);
190       totalSupply = safeAdd(totalSupply, candies);
191       Transfer(address(0), recipient, candies);
192     }
193   }
194 
195   function buyToken(address recipient, uint256 value) internal {
196       if (block.number<startBlock || block.number>endBlock) throw;  //crowdsale period checked
197       uint tokens = safeMul(value, price());
198 
199       if(safeAdd(crowdSaleSoldAmount, tokens)>crowdSaleCap) throw;   //crowdSaleCap checked
200 
201       balances[recipient] = safeAdd(balances[recipient], tokens);
202       crowdSaleSoldAmount = safeAdd(crowdSaleSoldAmount, tokens);
203       totalSupply = safeAdd(totalSupply, tokens);
204 
205       Transfer(address(0), recipient, tokens); //Transaction record for token perchaise
206       if (!founder.call.value(value)()) throw; //immediately send Ether to founder address
207       Buy(recipient, value, tokens); //Buy event
208   }
209 
210   // check how many candies one can claim by now;
211   function checkCandy(address recipient) constant returns (uint256 remaining) {
212     if(candyBook[recipient]) return 0;
213     else return candyPrice;
214   }
215 
216   function changeFounder(address newFounder) {
217     if (msg.sender!=founder) throw;
218     founder = newFounder;
219   }
220 
221 }