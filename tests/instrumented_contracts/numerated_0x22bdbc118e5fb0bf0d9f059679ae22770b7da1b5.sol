1 /**
2  * Source Code first verified at https://etherscan.io on Monday, February 6, 2017
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 
8 contract Token {
9 
10     /// @return total amount of tokens
11     function totalSupply() constant returns (uint256 supply) {}
12 
13     /// @param _owner The address from which the balance will be retrieved
14     /// @return The balance
15     function balanceOf(address _owner) constant returns (uint256 balance) {}
16 
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successaful or not
21     function transfer(address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
29 
30     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of wei to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) returns (bool success) {}
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 
46 /*
47 This implements ONLY the standard functions and NOTHING else.
48 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
49 
50 If you deploy this, you won't have anything useful.
51 
52 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
53 .*/
54 
55 contract StandardToken is Token {
56 
57     function transfer(address _to, uint256 _value) returns (bool success) {
58         //Default assumes totalSupply can't be over max (2^256 - 1).
59         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
60         //Replace the if with this one instead.
61         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
62         if (balances[msg.sender] >= _value && _value > 0) {
63             balances[msg.sender] -= _value;
64             balances[_to] += _value;
65             Transfer(msg.sender, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
71         //same as above. Replace this line with the following if you want to protect against wrapping uints.
72         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
73         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
74             balances[_to] += _value;
75             balances[_from] -= _value;
76             allowed[_from][msg.sender] -= _value;
77             Transfer(_from, _to, _value);
78             return true;
79         } else { return false; }
80     }
81 
82     function balanceOf(address _owner) constant returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86     function approve(address _spender, uint256 _value) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93       return allowed[_owner][_spender];
94     }
95 
96     mapping (address => uint256) balances;
97     mapping (address => mapping (address => uint256)) allowed;
98     uint256 public totalSupply;
99 }
100 
101 /*
102 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
103 
104 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
105 Imagine coins, currencies, shares, voting weight, etc.
106 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
107 
108 1) Initial Finite Supply (upon creation one specifies how much is minted).
109 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
110 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
111 
112 .*/
113 
114 contract HumanStandardToken is StandardToken {
115 
116     function () {
117         //if ether is sent to this address, send it back.
118         throw;
119     }
120 
121     /* Public variables of the token */
122 
123     /*
124     NOTE:
125     The following variables are OPTIONAL vanities. One does not have to include them.
126     They allow one to customise the token contract & in no way influences the core functionality.
127     Some wallets/interfaces might not even bother to look at this information.
128     */
129     string public name;                   //fancy name: eg Simon Bucks
130     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
131     string public symbol;                 //An identifier: eg SBX
132     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
133 
134     function HumanStandardToken(
135         uint256 _initialAmount,
136         string _tokenName,
137         uint8 _decimalUnits,
138         string _tokenSymbol
139         ) {
140         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
141         totalSupply = _initialAmount;                        // Update total supply
142         name = _tokenName;                                   // Set the name for display purposes
143         decimals = _decimalUnits;                            // Amount of decimals for display purposes
144         symbol = _tokenSymbol;                               // Set the symbol for display purposes
145     }
146 
147     /* Approves and then calls the receiving contract */
148     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
149         allowed[msg.sender][_spender] = _value;
150         Approval(msg.sender, _spender, _value);
151 
152         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
153         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
154         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
155         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
156         return true;
157     }
158 }
159 
160 
161 
162 
163 contract Ownable {
164     address public owner;
165 
166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167   
168     constructor() {
169         owner = msg.sender;
170     }
171 
172 
173   
174     modifier onlyOwner() {
175         require(msg.sender == owner);
176         _;
177     }
178 
179 
180     function transferOwnership(address newOwner) public onlyOwner {
181         require(newOwner != address(0));
182         OwnershipTransferred(owner, newOwner);
183         owner = newOwner;
184     }
185 
186 }
187 
188 contract TokenHolder is Ownable {
189     constructor() {}
190 
191     function withdrawTokens(StandardToken _token, address _to, uint256 _amount) public onlyOwner {
192         require(_token != address(0));
193         require(_to != address(0));
194         require(_to != address(this));
195         assert(_token.transfer(_to, _amount));
196     }
197 }
198 
199 contract KopexExchange is TokenHolder{
200 
201     uint256 public price = 1;
202     StandardToken public tokenContract;
203 
204     constructor(uint256 _price, StandardToken _tokenContract) public {
205         price = _price;
206         tokenContract = _tokenContract;
207 
208     }
209 
210     function setPrice(uint256 newPrice) public onlyOwner {
211         require(newPrice > 0, 'inv1id price');
212         price = newPrice;
213     }
214 
215     function() public payable {
216         require(msg.value > 0, 'no eth received');
217         exchangeToken(msg.sender);
218     }
219 
220     // from safemath
221     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222         uint256 c = a * b;
223         assert(a == 0 || c / a == b);
224         return c;
225     }
226 
227     function exchangeToken(address _buyer) public payable {
228         uint256 amount = mul(msg.value, price);
229         tokenContract.transfer(_buyer, amount);
230     }
231 
232 }