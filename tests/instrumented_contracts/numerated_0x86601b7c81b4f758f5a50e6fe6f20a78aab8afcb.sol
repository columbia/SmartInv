1 pragma solidity ^0.4.24;
2 interface tokenRecipient{
3     function receiveApproval(address _from,uint256 _value,address _token,bytes _extraData) external ;
4 }
5 contract DossToken{
6     address public owner;
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     uint256 public sellPrice; 
12     uint256 public buyPrice;
13     bool public sellOpen;
14     bool public buyOpen;
15 
16     mapping(address => uint256) public balanceOf;
17     mapping(address => mapping(address => uint256)) public allowance;
18     mapping(address=>bool) public frozenAccount;
19     
20     event Transfer(address indexed from,address indexed to , uint256 value);
21     event Approval(address indexed owner,address indexed spender,uint256 value);
22     event FrozenFunds(address target,bool freeze);
23     event SellToken(address seller,uint256 sellPrice, uint256 amount,uint256 getEth);
24     event BuyToken(address buyer,uint256 buyPrice,uint256 amount,uint256 spendEth);
25     
26     modifier onlyOwner {
27         require(msg.sender == owner);
28         _;
29     }
30     constructor() public {
31         owner = 0xad90fDfb9007F2a8b0Aa45C299Bd375F0bD4E4Ad;
32         name = "DesertOasis";
33         symbol = "DOSS";
34         decimals = 8;
35         totalSupply = 100000000000 * 10 ** uint256(8);
36         balanceOf[owner] = totalSupply;
37     }
38     
39 	function () public payable {  
40 		if(msg.sender!=owner){
41          _buy();    
42 		}
43 	}
44  
45     function transfer(address _to,uint256 _value) public{
46         require(!frozenAccount[msg.sender]);
47         if(_to == address(this)){
48           _sell(msg.sender,_value);
49         }else{
50             _transfer(msg.sender,_to,_value);
51         }
52     }
53     
54     function transferFrom(address _from,address _to,uint256 _value) public returns (bool success){
55         require(!frozenAccount[_from]&&!frozenAccount[msg.sender]);
56         require(_value<=allowance[_from][msg.sender]);
57         allowance[_from][msg.sender] -= _value;
58         if(_to == address(this)){
59             _sell(_from,_value);
60         }else
61         {
62             _transfer(_from,_to,_value);
63         }
64         
65         return true;
66     }
67     
68     function approve(address _spender,uint256 _value) public returns (bool success){
69         require(!frozenAccount[msg.sender]);
70         allowance[msg.sender][_spender] = _value;
71         return true;
72     }
73 	
74     function approveAndCall(address _spender,uint256 _value,bytes _extraData) public returns (bool success){
75         require(!frozenAccount[msg.sender]);
76         tokenRecipient spender = tokenRecipient(_spender);
77         if(approve(_spender,_value)){
78             spender.receiveApproval(msg.sender,_value,this,_extraData);
79             return true;
80         }
81     }
82     
83     function freezeAccount(address target,bool freeze)  onlyOwner public{
84         require(target!=owner);
85         frozenAccount[target] = freeze;
86         emit FrozenFunds(target,freeze);
87     }
88 	
89     function transferOwnership(address newOwner) onlyOwner public{
90         _transfer(owner,newOwner,balanceOf[owner]);
91         owner = newOwner;
92     }
93 	
94     function setPrices(uint256 newSellPrice,uint256 newBuyPrice) onlyOwner public{
95         sellPrice = newSellPrice;
96         buyPrice = newBuyPrice;
97     }
98 	
99     function setBuyOpen(bool newBuyOpen) onlyOwner public{
100         require(buyPrice>0);
101         buyOpen = newBuyOpen;
102     }
103 	
104     function setSellOpen(bool newSellOpen) onlyOwner public{
105         require(sellPrice>0);
106         sellOpen = newSellOpen;
107     }
108 	
109     function transferEth(uint256 amount) onlyOwner public{
110         msg.sender.transfer(amount*10**uint256(18));
111     }
112     
113     function _transfer(address _from,address _to, uint256 _value) internal {
114         require(_to != 0x0);
115         require(balanceOf[_from] >= _value);
116         require(balanceOf[_to] + _value >balanceOf[_to]);
117         uint256 previousBalances = balanceOf[_from]+balanceOf[_to];
118         balanceOf[_from] -= _value;
119         balanceOf[_to] += _value;
120         emit Transfer(_from,_to,_value);
121         assert(balanceOf[_from]+balanceOf[_to] == previousBalances);
122     }
123 
124     function _buy() internal returns (uint256 amount){
125         require(buyOpen);
126         require(buyPrice>0);
127         require(msg.value>0);
128         amount = msg.value / buyPrice;
129         _transfer(owner,msg.sender,amount);
130         emit BuyToken(msg.sender,buyPrice,amount,msg.value);
131         return amount;
132     }
133     
134     function _sell(address _from,uint256 amount) internal returns (uint256 revenue){
135         require(sellOpen);
136         require(!frozenAccount[_from]);
137         require(amount>0);
138         require(sellPrice>0);
139         require(_from!=owner);
140         _transfer(_from,owner,amount);
141         revenue = amount * sellPrice;
142         _from.transfer(revenue);
143         emit SellToken(_from,sellPrice,amount,revenue);
144         return revenue;
145     }
146 }