1 pragma solidity ^0.4.0;
2 
3 //https://github.com/nexusdev/erc20/blob/master/contracts/erc20.sol
4 
5 contract ERC20Constant {
6     function totalSupply() constant returns (uint supply);
7     function balanceOf( address who ) constant returns (uint value);
8     function allowance(address owner, address spender) constant returns (uint _allowance);
9 }
10 contract ERC20Stateful {
11     function transfer( address to, uint value) returns (bool ok);
12     function transferFrom( address from, address to, uint value) returns (bool ok);
13     function approve(address spender, uint value) returns (bool ok);
14 }
15 contract ERC20Events {
16     event Transfer(address indexed from, address indexed to, uint value);
17     event Approval( address indexed owner, address indexed spender, uint value);
18 }
19 contract ERC20 is ERC20Constant, ERC20Stateful, ERC20Events {}
20 
21 contract owned {
22     address public owner;
23 
24     function owned() {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         if (msg.sender != owner) throw;
30         _;
31     }
32 
33     function transferOwnership(address newOwner) onlyOwner {
34         owner = newOwner;
35     }
36 }
37 
38 // contract can buy or sell tokens for ETH
39 // prices are in amount of wei per batch of token units
40 
41 contract TokenTrader is owned {
42 
43     address public asset;       // address of token
44     uint256 public buyPrice;   // contact buys lots of token at this price
45     uint256 public sellPrice;  // contract sells lots at this price
46     uint256 public units;       // lot size (token-wei)
47 
48     bool public sellsTokens;    // is contract selling
49     bool public buysTokens;     // is contract buying
50 
51     event ActivatedEvent(bool sells, bool buys);
52     event UpdateEvent();
53 
54     function TokenTrader (
55         address _asset, 
56         uint256 _buyPrice, 
57         uint256 _sellPrice, 
58         uint256 _units,
59         bool    _sellsTokens,
60         bool    _buysTokens
61         )
62     {
63           asset         = _asset; 
64           buyPrice     = _buyPrice; 
65           sellPrice    = _sellPrice;
66           units         = _units; 
67           sellsTokens   = _sellsTokens;
68           buysTokens    = _buysTokens;
69 
70           ActivatedEvent(sellsTokens,buysTokens);
71     }
72 
73     // modify trading behavior
74     function activate (
75         bool    _sellsTokens,
76         bool    _buysTokens
77         ) onlyOwner
78     {
79           sellsTokens   = _sellsTokens;
80           buysTokens    = _buysTokens;
81 
82           ActivatedEvent(sellsTokens,buysTokens);
83     }
84 
85     // allows owner to deposit ETH
86     // deposit tokens by sending them directly to contract
87     // buyers must not send tokens to the contract, use: sell(...)
88     function deposit() payable onlyOwner {
89         UpdateEvent();
90     }
91 
92     // allow owner to remove trade token
93     function withdrawAsset(uint256 _value) onlyOwner returns (bool ok)
94     {
95         return ERC20(asset).transfer(owner,_value);
96         UpdateEvent();
97     }
98 
99     // allow owner to remove arbitrary tokens
100     // included just in case contract receives wrong token
101     function withdrawToken(address _token, uint256 _value) onlyOwner returns (bool ok)
102     {
103         return ERC20(_token).transfer(owner,_value);
104         UpdateEvent();
105     }
106 
107     // allow owner to remove ETH
108     function withdraw(uint256 _value) onlyOwner returns (bool ok)
109     {
110         if(this.balance >= _value) {
111             return owner.send(_value);
112         }
113         UpdateEvent();
114     }
115 
116     //user buys token with ETH
117     function buy() payable {
118         if(sellsTokens || msg.sender == owner) 
119         {
120             uint order   = msg.value / sellPrice; 
121             uint can_sell = ERC20(asset).balanceOf(address(this)) / units;
122 
123             if(order > can_sell)
124             {
125                 uint256 change = msg.value - (can_sell * sellPrice);
126                 order = can_sell;
127                 if(!msg.sender.send(change)) throw;
128             }
129 
130             if(order > 0) {
131                 if(!ERC20(asset).transfer(msg.sender,order * units)) throw;
132             }
133             UpdateEvent();
134         }
135         else throw;  // return user funds if the contract is not selling
136     }
137 
138     // user sells token for ETH
139     // user must set allowance for this contract before calling
140     function sell(uint256 amount) {
141         if (buysTokens || msg.sender == owner) {
142             uint256 can_buy = this.balance / buyPrice;  // token lots contract can buy
143             uint256 order = amount / units;             // token lots available
144 
145             if(order > can_buy) order = can_buy;        // adjust order for funds
146 
147             if (order > 0)
148             { 
149                 // extract user tokens
150                 if(!ERC20(asset).transferFrom(msg.sender, address(this), amount)) throw;
151 
152                 // pay user
153                 if(!msg.sender.send(order * buyPrice)) throw;
154             }
155             UpdateEvent();
156         }
157     }
158 
159     // sending ETH to contract sells ETH to user
160     function () payable {
161         buy();
162     }
163 }
164 
165 // This contract deploys TokenTrader contracts and logs the event
166 // trade pairs are identified with sha3(asset,units)
167 
168 contract TokenTraderFactory {
169 
170     event TradeListing(bytes32 bookid, address owner, address addr);
171     event NewBook(bytes32 bookid, address asset, uint256 units);
172 
173     mapping( address => bool ) public verify;
174     mapping( bytes32 => bool ) pairExits;
175 
176     function createTradeContract(       
177         address _asset, 
178         uint256 _buyPrice, 
179         uint256 _sellPrice, 
180         uint256 _units,
181         bool    _sellsTokens,
182         bool    _buysTokens
183         ) returns (address) 
184     {
185         if(_buyPrice > _sellPrice) throw; // must make profit on spread
186         if(_units == 0) throw;              // can't sell zero units
187 
188         address trader = new TokenTrader (
189                      _asset, 
190                      _buyPrice, 
191                      _sellPrice, 
192                      _units,
193                      _sellsTokens,
194                      _buysTokens);
195 
196         var bookid = sha3(_asset,_units);
197 
198         verify[trader] = true; // record that this factory created the trader
199 
200         TokenTrader(trader).transferOwnership(msg.sender); // set the owner to whoever called the function
201 
202         if(pairExits[bookid] == false) {
203             pairExits[bookid] = true;
204             NewBook(bookid, _asset, _units);
205         }
206 
207         TradeListing(bookid,msg.sender,trader);
208     }
209 
210     function () {
211         throw;     // Prevents accidental sending of ether to the factory
212     }
213 }