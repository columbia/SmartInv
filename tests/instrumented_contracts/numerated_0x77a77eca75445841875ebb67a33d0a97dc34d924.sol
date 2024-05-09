1 pragma solidity ^0.4.11;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public constant returns (address owner) { owner; }
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /*
15     Provides support and utilities for contract ownership
16 */
17 contract Owned is IOwned {
18     address public owner;
19     address public newOwner;
20 
21     event OwnerUpdate(address _prevOwner, address _newOwner);
22 
23     /**
24         @dev constructor
25     */
26     function Owned() {
27         owner = msg.sender;
28     }
29 
30     // allows execution by the owner only
31     modifier ownerOnly {
32         assert(msg.sender == owner);
33         _;
34     }
35 
36     /**
37         @dev allows transferring the contract ownership
38         the new owner still need to accept the transfer
39         can only be called by the contract owner
40 
41         @param _newOwner    new contract owner
42     */
43     function transferOwnership(address _newOwner) public ownerOnly {
44         require(_newOwner != owner);
45         newOwner = _newOwner;
46     }
47 
48     /**
49         @dev used by a new owner to accept an ownership transfer
50     */
51     function acceptOwnership() public {
52         require(msg.sender == newOwner);
53         OwnerUpdate(owner, newOwner);
54         owner = newOwner;
55         newOwner = 0x0;
56     }
57 }
58 
59 /*
60     ERC20 Standard Token interface
61 */
62 contract IERC20Token {
63     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
64     function name() public constant returns (string name) { name; }
65     function symbol() public constant returns (string symbol) { symbol; }
66     function decimals() public constant returns (uint8 decimals) { decimals; }
67     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
68     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
69     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
70 
71     function transfer(address _to, uint256 _value) public returns (bool success);
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
73     function approve(address _spender, uint256 _value) public returns (bool success);
74 }
75 
76 /*
77     Token Holder interface
78 */
79 contract ITokenHolder is IOwned {
80     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
81 }
82 
83 /*
84     We consider every contract to be a 'token holder' since it's currently not possible
85     for a contract to deny receiving tokens.
86 
87     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
88     the owner to send tokens that were sent to the contract by mistake back to their sender.
89 */
90 contract TokenHolder is ITokenHolder, Owned {
91     /**
92         @dev constructor
93     */
94     function TokenHolder() {
95     }
96 
97     // validates an address - currently only checks that it isn't null
98     modifier validAddress(address _address) {
99         require(_address != 0x0);
100         _;
101     }
102 
103     // verifies that the address is different than this contract address
104     modifier notThis(address _address) {
105         require(_address != address(this));
106         _;
107     }
108 
109     /**
110         @dev withdraws tokens held by the contract and sends them to an account
111         can only be called by the owner
112 
113         @param _token   ERC20 token contract address
114         @param _to      account to receive the new amount
115         @param _amount  amount to withdraw
116     */
117     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
118         public
119         ownerOnly
120         validAddress(_token)
121         validAddress(_to)
122         notThis(_to)
123     {
124         assert(_token.transfer(_to, _amount));
125     }
126 }
127 
128 /*
129     EIP228 Token Changer interface
130 */
131 contract ITokenChanger {
132     function changeableTokenCount() public constant returns (uint16 count);
133     function changeableToken(uint16 _tokenIndex) public constant returns (address tokenAddress);
134     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256 amount);
135     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 amount);
136 }
137 
138 /*
139     Smart Token interface
140 */
141 contract ISmartToken is ITokenHolder, IERC20Token {
142     function disableTransfers(bool _disable) public;
143     function issue(address _to, uint256 _amount) public;
144     function destroy(address _from, uint256 _amount) public;
145 }
146 
147 /*
148     Bancor Changer interface
149 */
150 contract IBancorChanger is ITokenChanger {
151     function token() public constant returns (ISmartToken _token) { _token; }
152     function getReserveBalance(IERC20Token _reserveToken) public constant returns (uint256 balance);
153 }
154 
155 /*
156     Ether Token interface
157 */
158 contract IEtherToken is ITokenHolder, IERC20Token {
159     function deposit() public payable;
160     function withdraw(uint256 _amount) public;
161 }
162 
163 /*
164     BancorBuyer v0.1
165 
166     The bancor buyer contract is a simple bancor changer wrapper that allows buying smart tokens with ETH
167 
168     WARNING: the contract will make the purchase using the current price at transaction mining time
169 */
170 contract BancorBuyer is TokenHolder {
171     string public version = '0.1';
172     IBancorChanger public tokenChanger; // bancor ETH <-> smart token changer
173     IEtherToken public etherToken;      // ether token
174 
175     /**
176         @dev constructor
177 
178         @param _changer     bancor token changer that actually does the purchase
179         @param _etherToken  ether token used as a reserve in the token changer
180     */
181     function BancorBuyer(IBancorChanger _changer, IEtherToken _etherToken)
182         validAddress(_changer)
183         validAddress(_etherToken)
184     {
185         tokenChanger = _changer;
186         etherToken = _etherToken;
187 
188         // ensure that the ether token is used as one of the changer's reserves
189         tokenChanger.getReserveBalance(etherToken);
190     }
191 
192     /**
193         @dev buys the smart token with ETH
194         note that the purchase will use the price at the time of the purchase
195 
196         @return tokens issued in return
197     */
198     function buy() public payable returns (uint256 amount) {
199         etherToken.deposit.value(msg.value)(); // deposit ETH in the reserve
200         assert(etherToken.approve(tokenChanger, 0)); // need to reset the allowance to 0 before setting a new one
201         assert(etherToken.approve(tokenChanger, msg.value)); // approve the changer to use the ETH amount for the purchase
202 
203         ISmartToken smartToken = tokenChanger.token();
204         uint256 returnAmount = tokenChanger.change(etherToken, smartToken, msg.value, 1); // do the actual change using the current price
205         assert(smartToken.transfer(msg.sender, returnAmount)); // transfer the tokens to the sender
206         return returnAmount;
207     }
208 
209     // fallback
210     function() payable {
211         buy();
212     }
213 }