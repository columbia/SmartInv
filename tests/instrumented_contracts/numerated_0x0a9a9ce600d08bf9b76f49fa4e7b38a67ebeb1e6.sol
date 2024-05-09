1 pragma solidity ^0.4.18;
2 interface tokenRecipient{
3     function receiveApproval(address _from,uint256 _value,address _token,bytes _extraData) external ;
4 }
5 contract GrowToken{
6     //public var
7     address public owner;
8     string public name;
9     string public symbol;
10     uint8 public decimals;
11     uint256 public totalSupply;
12     uint256 public sellPrice; //grow to wei not eth!
13     uint256 public buyPrice;
14     bool public sellOpen;
15     bool public buyOpen;
16     
17     //store token data set
18     mapping(address => uint256) public balanceOf;
19     //transition limite
20     mapping(address => mapping(address => uint256)) public allowance;
21     //freeze account 
22     mapping(address=>bool) public frozenAccount;
23     
24     //event for transition
25     event Transfer(address indexed from,address indexed to , uint256 value);
26     //event for allowance
27     event Approval(address indexed owner,address indexed spender,uint256 value);
28     //event for freeze/unfreeze Account 
29     event FrozenFunds(address target,bool freeze);
30     //TODO event for sell token , do't need it now
31     event SellToken(address seller,uint256 sellPrice, uint256 amount,uint256 getEth);
32     //TODO event for buy token , do't need it now 
33     event BuyToken(address buyer,uint256 buyPrice,uint256 amount,uint256 spendEth);
34     
35     modifier onlyOwner {
36         require(msg.sender == owner);
37         _;
38     }
39     //func constructor
40     function GrowToken() public {
41         owner = 0x757D7FbB9822b5033a6BBD4e17F95714942f921f;
42         name = "GROWCHAIN";
43         symbol = "GROW";
44         decimals = 8;
45         totalSupply = 5000000000 * 10 ** uint256(8);
46         
47         //init totalSupply to map(db)
48         balanceOf[owner] = totalSupply;
49     }
50     
51  function () public payable {  
52      if(msg.sender!=owner){
53          _buy();    
54      }
55  }
56  
57     // public functions
58     // 1 Transfer tokens 
59     function transfer(address _to,uint256 _value) public{
60         require(!frozenAccount[msg.sender]);
61         if(_to == address(this)){
62           _sell(msg.sender,_value);
63         }else{
64             _transfer(msg.sender,_to,_value);
65         }
66     }
67     
68     // 2 Transfer Other's tokens ,who had approve some token to me 
69     function transferFrom(address _from,address _to,uint256 _value) public returns (bool success){
70         //validate the allowance 
71         require(!frozenAccount[_from]&&!frozenAccount[msg.sender]);
72         require(_value<=allowance[_from][msg.sender]);
73         //do action :sub allowance and do transfer 
74         allowance[_from][msg.sender] -= _value;
75         if(_to == address(this)){
76             _sell(_from,_value);
77         }else
78         {
79             _transfer(_from,_to,_value);
80         }
81         
82         return true;
83     }
84     //A is msg.sender or i 
85     //B is the person who has approve me to use his token or _from 
86     //C is the receipient or _to
87     
88     // 3 set allowance for other address,like B approve A(_spender) to use his token
89     function approve(address _spender,uint256 _value) public returns (bool success){
90         require(!frozenAccount[msg.sender]);
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94     // 4 allowance and notify the receipient/spender 
95     function approveAndCall(address _spender,uint256 _value,bytes _extraData)
96     public returns (bool success){
97         require(!frozenAccount[msg.sender]);
98         tokenRecipient spender = tokenRecipient(_spender);
99         if(approve(_spender,_value)){
100             spender.receiveApproval(msg.sender,_value,this,_extraData);
101             return true;
102         }
103     }
104     
105     // onlyOwner function 
106     // 11 freeze or unfreeze account 
107     function freezeAccount(address target,bool freeze)  onlyOwner public{
108         require(target!=owner);
109         frozenAccount[target] = freeze;
110         FrozenFunds(target,freeze);
111     }
112     // 12 transfer contract  Ownership to newOwner and transfer all balanceOf oldOwner to newOwner
113     function transferOwnership(address newOwner) onlyOwner public{
114         _transfer(owner,newOwner,balanceOf[owner]);
115         owner = newOwner;
116     }
117     // 13 set prices for sellPrice or buyPrice
118     function setPrices(uint256 newSellPrice,uint256 newBuyPrice) onlyOwner public{
119         sellPrice = newSellPrice;
120         buyPrice = newBuyPrice;
121     }
122     // 14 open/close user to  buy token 
123     function setBuyOpen(bool newBuyOpen) onlyOwner public{
124         require(buyPrice>0);
125         buyOpen = newBuyOpen;
126     }
127     // 15 open/close user to  sell token 
128     function setSellOpen(bool newSellOpen) onlyOwner public{
129         require(sellPrice>0);
130         sellOpen = newSellOpen;
131     }
132     // 16 transfer eth back to owner 
133     function transferEth(uint256 amount) onlyOwner public{
134         msg.sender.transfer(amount*10**uint256(18));
135     }
136     
137     //internal transfer function
138  // 1 _transfer
139     function _transfer(address _from,address _to, uint256 _value) internal {
140         //validate input and other internal limites
141         require(_to != 0x0);//check to address
142         require(balanceOf[_from] >= _value);//check from address has enough balance 
143         require(balanceOf[_to] + _value >balanceOf[_to]);//after transfer the balance of _to address is ok ,no overflow
144         uint256 previousBalances = balanceOf[_from]+balanceOf[_to];//store it for add asset to power the security
145         //do transfer:sub from _from address,and add to the _to address
146         balanceOf[_from] -= _value;
147         balanceOf[_to] += _value;
148         //after transfer: emit transfer event,and add asset for security
149         Transfer(_from,_to,_value);
150         assert(balanceOf[_from]+balanceOf[_to] == previousBalances);
151     }
152  // 2 _buy 
153     function _buy() internal returns (uint256 amount){
154         require(buyOpen);
155         require(buyPrice>0);
156         require(msg.value>0);
157         amount = msg.value / buyPrice;                    // calculates the amount
158         _transfer(owner,msg.sender,amount);
159         BuyToken(msg.sender,buyPrice,amount,msg.value);
160         return amount;                                    // ends function and returns
161     }
162     
163     // 3 _sell 
164     function _sell(address _from,uint256 amount) internal returns (uint256 revenue){
165         require(sellOpen);
166         require(!frozenAccount[_from]);
167         require(amount>0);
168         require(sellPrice>0);
169         require(_from!=owner);
170         _transfer(_from,owner,amount);
171         revenue = amount * sellPrice;
172         _from.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
173         SellToken(_from,sellPrice,amount,revenue);
174         return revenue;                                   // ends function and returns
175     }
176 }