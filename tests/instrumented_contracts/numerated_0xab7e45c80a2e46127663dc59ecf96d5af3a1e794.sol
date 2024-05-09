1 pragma solidity ^0.4.11;
2 
3 //https://github.com/nexusdev/erc20/blob/master/contracts/erc20.sol
4 
5 contract ERC20Constant {
6     function balanceOf( address who ) constant returns (uint value);
7 }
8 contract ERC20Stateful {
9     function transfer( address to, uint value) returns (bool ok);
10 }
11 contract ERC20Events {
12     event Transfer(address indexed from, address indexed to, uint value);
13 }
14 contract ERC20 is ERC20Constant, ERC20Stateful, ERC20Events {}
15 
16 contract owned {
17     address public owner;
18 
19     function owned() {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner {
24         if (msg.sender != owner) throw;
25         _;
26     }
27 
28     function transferOwnership(address newOwner) onlyOwner {
29         owner = newOwner;
30     }
31 }
32 
33 // contract can sell tokens for ETH
34 // prices are in amount of wei per batch of token units
35 
36 contract TokenTrader is owned {
37 
38     address public asset;       // address of token
39     uint256 public sellPrice;   // contract sells lots of tokens at this price
40     uint256 public units;       // lot size (token-wei)
41 
42     bool public sellsTokens;    // is contract selling
43 
44     event ActivatedEvent(bool sells);
45     event UpdateEvent();
46 
47     function TokenTrader (
48         address _asset, 
49         uint256 _sellPrice, 
50         uint256 _units,
51         bool    _sellsTokens
52         )
53     {
54           asset         = _asset; 
55           sellPrice    = _sellPrice;
56           units         = _units; 
57           sellsTokens   = _sellsTokens;
58 
59           ActivatedEvent(sellsTokens);
60     }
61 
62     // modify trading behavior
63     function activate (
64         bool    _sellsTokens
65         ) onlyOwner
66     {
67           sellsTokens   = _sellsTokens;
68 
69           ActivatedEvent(sellsTokens);
70     }
71 
72     // allow owner to remove trade token
73     function withdrawAsset(uint256 _value) onlyOwner returns (bool ok)
74     {
75         return ERC20(asset).transfer(owner,_value);
76         UpdateEvent();
77     }
78 
79     // allow owner to remove arbitrary tokens
80     // included just in case contract receives wrong token
81     function withdrawToken(address _token, uint256 _value) onlyOwner returns (bool ok)
82     {
83         return ERC20(_token).transfer(owner,_value);
84         UpdateEvent();
85     }
86 
87     // allow owner to remove ETH
88     function withdraw(uint256 _value) onlyOwner returns (bool ok)
89     {
90         if(this.balance >= _value) {
91             return owner.send(_value);
92         }
93         UpdateEvent();
94     }
95 
96     //user buys token with ETH
97     function buy() payable {
98         if(sellsTokens || msg.sender == owner) 
99         {
100             uint order   = msg.value / sellPrice; 
101             uint can_sell = ERC20(asset).balanceOf(address(this)) / units;
102 
103             if(order > can_sell)
104             {
105                 uint256 change = msg.value - (can_sell * sellPrice);
106                 order = can_sell;
107                 if(!msg.sender.send(change)) throw;
108             }
109 
110             if(order > 0) {
111                 if(!ERC20(asset).transfer(msg.sender,order * units)) throw;
112             }
113             UpdateEvent();
114         }
115         else if(!msg.sender.send(msg.value)) throw;  // return user funds if the contract is not selling
116     }
117 
118     // sending ETH to contract sells GNT to user
119     function () payable {
120         buy();
121     }
122 }
123 
124 // This contract deploys TokenTrader contracts and logs the event
125 // trade pairs are identified with sha3(asset,units)
126 
127 contract TokenTraderFactory {
128 
129     event TradeListing(bytes32 bookid, address owner, address addr);
130     event NewBook(bytes32 bookid, address asset, uint256 units);
131 
132     mapping( address => bool ) _verify;
133     mapping( bytes32 => bool ) pairExits;
134     
135     function verify(address tradeContract)  constant returns (
136         bool valid,
137         address asset, 
138         uint256 sellPrice, 
139         uint256 units,
140         bool    sellsTokens
141         ) {
142             
143             valid = _verify[tradeContract];
144             
145             if(valid) {
146                 TokenTrader t = TokenTrader(tradeContract);
147                 
148                 asset = t.asset();
149                 sellPrice = t.sellPrice();
150                 units = t.units();
151                 sellsTokens = t.sellsTokens();
152             }
153         
154     }
155 
156     function createTradeContract(       
157         address _asset, 
158         uint256 _sellPrice, 
159         uint256 _units,
160         bool    _sellsTokens
161         ) returns (address) 
162     {
163         if(_units == 0) throw;              // can't sell zero units
164 
165         address trader = new TokenTrader (
166                      _asset, 
167                      _sellPrice, 
168                      _units,
169                      _sellsTokens);
170 
171         var bookid = sha3(_asset,_units);
172 
173         _verify[trader] = true; // record that this factory created the trader
174 
175         TokenTrader(trader).transferOwnership(msg.sender); // set the owner to whoever called the function
176 
177         if(pairExits[bookid] == false) {
178             pairExits[bookid] = true;
179             NewBook(bookid, _asset, _units);
180         }
181 
182         TradeListing(bookid,msg.sender,trader);
183     }
184 
185     function () {
186         throw;     // Prevents accidental sending of ether to the factory
187     }
188 }