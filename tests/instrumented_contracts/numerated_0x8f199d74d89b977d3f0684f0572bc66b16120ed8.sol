1 /**
2  *  The Option token contract complies with the ERC20 standard.
3  *  This contract implements american option.
4  *  Holders of the Option tokens can make a purchase of the underlying asset
5  *  at the price of Strike until the Expiration time.
6  *  The Strike price and Expiration date are set once and can't be changed.
7  *  Author: Alexey Bukhteyev
8  **/
9 
10 pragma solidity ^0.4.4;
11 
12 contract ERC20 {
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed from, address indexed spender, uint256 value);
15 
16     function name() public constant returns(string);
17     function symbol() public constant returns(string);
18 
19     function totalSupply() public constant returns(uint256 supply);
20     function balanceOf(address _owner) public constant returns(uint256 balance);
21     function transfer(address _to, uint256 _value) public returns(bool success);
22     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
23     function approve(address _spender, uint256 _value) public returns(bool success);
24     function allowance(address _owner, address _spender) public constant returns(uint256 remaining);
25     function decimals() public constant returns(uint8);
26 }
27 
28 /*
29     Allows to recreate OptionToken contract on the same address.
30     Just create new TokenHolders(OptionToken) and reinitiallize OptionToken using it's address
31 */
32 contract TokenHolders {
33     address public owner;
34 
35     mapping(address => uint256) public balanceOf;
36     mapping(address => mapping(address => uint256)) public allowance;
37 
38     /*
39         TokenHolders contract is being connected to OptionToken on creation.
40         Nobody can modify balanceOf and allowance except OptionToken
41     */
42 
43     function validate() external constant returns (bool);
44 
45     function setBalance(address _to, uint256 _value) external;
46 
47     /* Send some of your tokens to a given address */
48     function transfer(address _from, address _to, uint256 _value) public returns(bool success);
49 
50     /* Allow another contract or person to spend some tokens in your behalf */
51     function approve(address _sender, address _spender, uint256 _value) public returns(bool success);
52 
53     /* A contract or  person attempts to get the tokens of somebody else.
54      *  This is only allowed if the token holder approved. */
55     function transferWithAllowance(address _origin, address _from, address _to, uint256 _value)
56     public returns(bool success);
57 }
58 
59 /*
60     This ERC20 contract is a basic option contract that implements a token which
61     allows to token holder to buy some asset for the fixed strike price before expiration date.
62 */
63 contract OptionToken {
64     string public standard = 'ERC20';
65     string public name;
66     string public symbol;
67     uint8 public decimals;
68     address public owner;
69 
70     // Option characteristics
71     uint256 public expiration = 1512172800; //02.12.2017 Use unix timespamp
72     uint256 public strike = 20000000000;
73 
74     ERC20 public baseToken;
75     TokenHolders public tokenHolders;
76 
77     bool _initialized = false;
78 
79 
80     /* This generates a public event on the blockchain that will notify clients */
81     // ERC20 events
82     event Transfer(address indexed from, address indexed to, uint256 value);
83     event Approval(address indexed from, address indexed spender, uint256 value);
84 
85     // OptionToken events
86     event Deposit(address indexed from, uint256 value);
87     event Redeem(address indexed from, uint256 value, uint256 ethvalue);
88     event Issue(address indexed issuer, uint256 value);
89 
90     // Only set owner on the constructor
91     function OptionToken() public {
92         owner = msg.sender;
93     }
94 
95     // ERC20 functions
96     function balanceOf(address _owner) public constant returns(uint256 balance) {
97         return tokenHolders.balanceOf(_owner);
98     }
99 
100     function totalSupply() public constant returns(uint256 supply) {
101         // total supply is a balance of this contract in base tokens
102         return baseToken.balanceOf(this);
103     }
104 
105     /* Send some of your tokens to a given address */
106     function transfer(address _to, uint256 _value) public returns(bool success) {
107         if(now > expiration)
108             return false;
109 
110         if(!tokenHolders.transfer(msg.sender, _to, _value))
111             return false;
112 
113         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
114         return true;
115     }
116 
117     /* Allow another contract or person to spend some tokens in your behalf */
118     function approve(address _spender, uint256 _value) public returns(bool success) {
119         if(now > expiration)
120             return false;
121 
122         if(!tokenHolders.approve(msg.sender, _spender, _value))
123             return false;
124 
125         Approval(msg.sender, _spender, _value);
126         return true;
127     }
128 
129 
130     /* A contract or  person attempts to get the tokens of somebody else.
131      *  This is only allowed if the token holder approved. */
132     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
133         if(now > expiration)
134             return false;
135 
136         if(!tokenHolders.transferWithAllowance(msg.sender, _from, _to, _value))
137             return false;
138 
139         Transfer(_from, _to, _value);
140         return true;
141     }
142 
143     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
144         return tokenHolders.allowance(_owner, _spender);
145     }
146 
147     // OptionToken functions
148 
149     /*
150         Then we should pass base token contract address to init() function.
151         Only contract creator can call init() and only once
152     */
153     function init(ERC20 _baseToken, TokenHolders _tokenHolders, string _name, string _symbol,
154                 uint256 _exp, uint256 _strike) public returns(bool success) {
155         require(msg.sender == owner && !_initialized);
156 
157         baseToken = _baseToken;
158         tokenHolders = _tokenHolders;
159 
160         // if baseToken.totalSupply() is zero - something is wrong
161         assert(baseToken.totalSupply() != 0);
162         // validate tokenHolders contract owner - it should be OptionToken
163         assert(tokenHolders.validate());
164 
165         name = _name;
166         symbol = _symbol;
167         expiration = _exp;
168         strike = _strike;
169 
170         decimals = baseToken.decimals();
171 
172         _initialized = true;
173         return true;
174     }
175 
176     /*
177         Allows to increase totalSupply and get OptionTokens to their balance.
178         Before calling depositTokens the caller should approve the transfer for this contract address
179         using ERC20.approve().
180         Actually should be called by contract owner, because no ETH payout will be done for token transfer.
181     */
182     function issue(uint256 _value) public returns(bool success) {
183         require(now <= expiration && _initialized);
184 
185         uint256 receiver_balance = balanceOf(msg.sender) + _value;
186         assert(receiver_balance >= _value);
187 
188         // check if transfer failed
189         if(!baseToken.transferFrom(msg.sender, this, _value))
190             revert();
191 
192         tokenHolders.setBalance(msg.sender, receiver_balance);
193         Issue(msg.sender, receiver_balance);
194 
195         return true;
196     }
197 
198     /*
199         Buy base tokens for the strike price
200     */
201     function() public payable {
202         require(now <= expiration && _initialized); // the contract should be initialized!
203         uint256 available = balanceOf(msg.sender); // balance of option holder
204 
205         // check if there are tokens for sale
206         require(available > 0);
207 
208         uint256 tokens = msg.value / (strike);
209         assert(tokens > 0 && tokens <= msg.value);
210 
211         uint256 change = 0;
212         uint256 eth_to_transfer = 0;
213 
214         if(tokens > available) {
215             tokens = available; // send all available tokens
216         }
217 
218         // calculate the change for the operation
219         eth_to_transfer = tokens * strike;
220         assert(eth_to_transfer >= tokens);
221         change = msg.value - eth_to_transfer;
222         assert(change < msg.value);
223 
224         if(!baseToken.transfer(msg.sender, tokens)) {
225             revert(); // error, revert transaction
226         }
227 
228         uint256 new_balance = balanceOf(msg.sender) - tokens;
229         tokenHolders.setBalance(msg.sender, new_balance);
230 
231         // new balance should be less then old balance
232         assert(balanceOf(msg.sender) < available);
233 
234         if(change > 0) {
235             msg.sender.transfer(change); // return the change
236         }
237 
238         if(eth_to_transfer > 0) {
239             owner.transfer(eth_to_transfer); // transfer eth for tokens to the contract owner
240         }
241 
242         Redeem(msg.sender, tokens, eth_to_transfer);
243     }
244 
245     /*
246         Allows the the contract owner to withdraw all unsold base tokens,
247         also deinitializes the token
248     */
249     function withdraw() public returns(bool success) {
250         require(msg.sender == owner);
251         if(now <= expiration || !_initialized)
252             return false;
253 
254         // transfer all tokens
255         baseToken.transfer(owner, totalSupply());
256 
257         // perform deinitialization
258         baseToken = ERC20(0);
259         tokenHolders = TokenHolders(0);
260         _initialized = false;
261         return true;
262     }
263 }