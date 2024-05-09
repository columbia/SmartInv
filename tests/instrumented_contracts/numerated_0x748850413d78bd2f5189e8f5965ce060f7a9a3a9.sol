1 pragma solidity ^0.4.16;
2 
3 contract Athleticoin {
4 
5     string public name = "Athleticoin";      //  token name
6     string public symbol = "ATHA";           //  token symbol
7     //string public version = "newversion1.0";
8     uint256 public decimals = 18;            //  token digit
9 
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     uint256 public totalSupply = 0;
14     bool public stopped = false;
15 
16     uint256 public sellPrice = 1530000000000;
17     uint256 public buyPrice = 1530000000000;
18     //000000000000000000
19     uint256 constant valueFounder = 500000000000000000000000000;
20 
21     address owner = 0xA9F6e166D73D4b2CAeB89ca84101De2c763F8E86;
22     address redeem_address = 0xA1b36225858809dd41c3BE9f601638F3e673Ef48;
23     address owner2 = 0xC58ceD5BA5B1daa81BA2eD7062F5bBC9cE76dA8d;
24     address owner3 = 0x06c7d7981D360D953213C6C99B01957441068C82;
25     address redeemer = 0x91D0F9B1E17a05377C7707c6213FcEB7537eeDEB;
26     modifier isOwner {
27         assert(owner == msg.sender);
28         _;
29     }
30     
31     modifier isRedeemer {
32         assert(redeemer == msg.sender);
33         _;
34     }
35     
36     modifier isRunning {
37         assert (!stopped);
38         _;
39     }
40 
41     modifier validAddress {
42         assert(0x0 != msg.sender);
43         _;
44     }
45 
46     constructor () public {
47         totalSupply = 2000000000000000000000000000;
48         balanceOf[owner] = valueFounder;
49         emit Transfer(0x0, owner, valueFounder);
50 
51         balanceOf[owner2] = valueFounder;
52         emit Transfer(0x0, owner2, valueFounder);
53 
54         balanceOf[owner3] = valueFounder;
55         emit Transfer(0x0, owner3, valueFounder);
56     }
57 
58     function giveBlockReward() public {
59         balanceOf[block.coinbase] += 15000;
60     }
61 
62     function mintToken(address target, uint256 mintedAmount) isOwner public {
63       balanceOf[target] += mintedAmount;
64       totalSupply += mintedAmount;
65       emit Transfer(0, this, mintedAmount);
66       emit Transfer(this, target, mintedAmount);
67     }
68 
69     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) isOwner public {
70         sellPrice = newSellPrice;
71         buyPrice = newBuyPrice;
72     }
73     
74     function changeRedeemer(address _redeemer) isOwner public {
75         redeemer = _redeemer;    
76     }
77     
78     function redeem(address target, uint256 token_amount) public payable returns (uint256 amount){
79         token_amount = token_amount * 1000000000000000000;
80         uint256 fee_amount = token_amount * 2 / 102;
81         uint256 redeem_amount = token_amount - fee_amount;
82         uint256 sender_amount = balanceOf[msg.sender];
83         uint256 fee_value = fee_amount * buyPrice / 1000000000000000000;
84         if (sender_amount >= redeem_amount){
85             require(msg.value >= fee_value);
86             balanceOf[target] += redeem_amount;                  // adds the amount to buyer's balance
87             balanceOf[msg.sender] -= redeem_amount;
88             emit Transfer(msg.sender, target, redeem_amount);               // execute an event reflecting the change
89             redeem_address.transfer(msg.value);
90         } else {
91             uint256 lack_amount = token_amount - sender_amount;
92             uint256 eth_value = lack_amount * buyPrice / 1000000000000000000;
93             lack_amount = redeem_amount - sender_amount;
94             require(msg.value >= eth_value);
95             require(balanceOf[owner] >= lack_amount);    // checks if it has enough to sell
96 
97             balanceOf[target] += redeem_amount;                  // adds the amount to buyer's balance
98             balanceOf[owner] -= lack_amount;                        // subtracts amount from seller's balance
99             balanceOf[msg.sender] = 0;
100 
101             eth_value = msg.value - fee_value;
102             owner.transfer(eth_value);
103             redeem_address.transfer(fee_value);
104             emit Transfer(msg.sender, target, sender_amount);               // execute an event reflecting the change
105             emit Transfer(owner, target, lack_amount);               // execute an event reflecting the change
106         }
107         return token_amount;                                    // ends function and returns
108     }
109 
110     function redeem_deposit(uint256 token_amount) public payable returns(uint256 amount){
111         token_amount = token_amount * 1000000000000000000;
112         uint256 fee_amount = token_amount * 2 / 102;
113         uint256 redeem_amount = token_amount - fee_amount;
114         uint256 sender_amount = balanceOf[msg.sender];
115         uint256 fee_value = fee_amount * buyPrice / 1000000000000000000;
116         uint256 rest_value = msg.value - fee_value;
117         if (sender_amount >= redeem_amount){
118             require(msg.value >= fee_value);
119             balanceOf[redeemer] += redeem_amount;                  // adds the amount to buyer's balance
120             balanceOf[msg.sender] -= redeem_amount;
121             emit Transfer(msg.sender, redeemer, redeem_amount);               // execute an event reflecting the change
122             redeem_address.transfer(fee_value);
123             redeemer.transfer(rest_value);
124         } else {
125             uint256 lack_amount = token_amount - sender_amount;
126             uint256 eth_value = lack_amount * buyPrice / 1000000000000000000;
127             lack_amount = redeem_amount - sender_amount;
128             require(msg.value >= eth_value);
129             require(balanceOf[owner] >= lack_amount);    // checks if it has enough to sell
130 
131             balanceOf[redeemer] += redeem_amount;                  // adds the amount to buyer's balance
132             balanceOf[owner] -= lack_amount;                        // subtracts amount from seller's balance
133             balanceOf[msg.sender] = 0;
134 
135             rest_value = msg.value - fee_value - eth_value;
136             owner.transfer(eth_value);
137             redeem_address.transfer(fee_value);
138             redeemer.transfer(rest_value);
139             
140             emit Transfer(msg.sender, redeemer, sender_amount);               // execute an event reflecting the change
141             emit Transfer(owner, redeemer, lack_amount);               // execute an event reflecting the change
142         }
143         return token_amount;                                    // ends function and returns                                  // ends function and returns
144     }
145 
146     function redeem_withdraw (address target_address, uint256 token_amount) isRedeemer public returns(uint256 amount){
147          token_amount = token_amount * 1000000000000000000;
148          balanceOf[redeemer] -= token_amount;                  // adds the amount to buyer's balance
149          balanceOf[target_address] += token_amount;                        // subtracts amount from seller's balance
150          emit Transfer(redeemer, target_address, token_amount);
151          return token_amount;
152     }
153     
154     function buy() public payable returns (uint amount){
155         amount = msg.value / buyPrice;                    // calculates the amount
156         require(balanceOf[owner] >= amount);               // checks if it has enough to sell
157         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
158         balanceOf[owner] -= amount;                        // subtracts amount from seller's balance
159         emit Transfer(owner, msg.sender, amount);               // execute an event reflecting the change
160         return amount;                                    // ends function and returns
161     }
162 
163     function sell(uint amount) public isRunning validAddress returns (uint revenue){
164         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
165         balanceOf[owner] += amount;                        // adds the amount to owner's balance
166         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
167         revenue = amount * sellPrice;
168         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
169         emit Transfer(msg.sender, owner, amount);               // executes an event reflecting on the change
170         return revenue;                                   // ends function and returns
171     }
172 
173 
174     function transfer(address _to, uint256 _value) public returns (bool success) {
175         require(balanceOf[msg.sender] >= _value);
176         require(balanceOf[_to] + _value >= balanceOf[_to]);
177         balanceOf[msg.sender] -= _value;
178         balanceOf[_to] += _value;
179         emit Transfer(msg.sender, _to, _value);
180         return true;
181     }
182 
183     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
184         require(balanceOf[_from] >= _value);
185         require(balanceOf[_to] + _value >= balanceOf[_to]);
186         require(allowance[_from][msg.sender] >= _value);
187         balanceOf[_to] += _value;
188         balanceOf[_from] -= _value;
189         allowance[_from][msg.sender] -= _value;
190         emit Transfer(_from, _to, _value);
191         return true;
192     }
193 
194     function approve(address _spender, uint256 _value) public returns (bool success) {
195         require(_value == 0 || allowance[msg.sender][_spender] == 0);
196         allowance[msg.sender][_spender] = _value;
197         emit Approval(msg.sender, _spender, _value);
198         return true;
199     }
200 
201     function stop() public isOwner {
202         stopped = true;
203     }
204 
205     function start() public isOwner {
206         stopped = false;
207     }
208 
209     function burn(uint256 _value) public {
210         require(balanceOf[msg.sender] >= _value);
211         balanceOf[msg.sender] -= _value;
212         balanceOf[0x0] += _value;
213         emit Transfer(msg.sender, 0x0, _value);
214     }
215 
216     event Transfer(address indexed _from, address indexed _to, uint256 _value);
217     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
218 }