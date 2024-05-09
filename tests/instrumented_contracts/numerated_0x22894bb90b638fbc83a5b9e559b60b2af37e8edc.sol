1 pragma solidity ^0.4.24;
2 interface tokenRecipient{
3     function receiveApproval(address _from,uint256 _value,address _token,bytes _extraData) external ;
4 }
5 contract BicasoBSOToken{
6     address public owner;
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     uint256 public sellPrice;
12     uint256 public buyPrice;
13     bool public sellOpen;
14     bool public buyOpen;
15     mapping(address => uint256) public balanceOf;
16     mapping(address => mapping(address => uint256)) public allowance;
17     mapping(address=>bool) public frozenAccount;
18     event Transfer(address indexed from,address indexed to , uint256 value);
19     event Approval(address indexed owner,address indexed spender,uint256 value);
20     event FrozenFunds(address target,bool freeze);
21     event SellToken(address seller,uint256 sellPrice, uint256 amount,uint256 getEth);
22     event BuyToken(address buyer,uint256 buyPrice,uint256 amount,uint256 spendEth);
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27     constructor() public {
28         owner = 0x28F1DdeC2218ec95b14076127a7AdE2F2986E4A6;
29         name = "BICASO";
30         symbol = "BSO";
31         decimals = 8;
32         totalSupply = 5000000000 * 10 ** uint256(8);
33         balanceOf[owner] = totalSupply;
34     }
35 	function () public payable {  
36      if(msg.sender!=owner){
37          _buy();    
38      }
39 	}
40     function transfer(address _to,uint256 _value) public{
41         require(!frozenAccount[msg.sender]);
42         if(_to == address(this)){
43           _sell(msg.sender,_value);
44         }else{
45             _transfer(msg.sender,_to,_value);
46         }
47     }
48     function transferFrom(address _from,address _to,uint256 _value) public returns (bool success){
49         require(!frozenAccount[_from]&&!frozenAccount[msg.sender]);
50         require(_value<=allowance[_from][msg.sender]);
51         allowance[_from][msg.sender] -= _value;
52         if(_to == address(this)){
53             _sell(_from,_value);
54         }else
55         {
56             _transfer(_from,_to,_value);
57         }
58         
59         return true;
60     }
61     function approve(address _spender,uint256 _value) public returns (bool success){
62         require(!frozenAccount[msg.sender]);
63         allowance[msg.sender][_spender] = _value;
64         return true;
65     }
66     function approveAndCall(address _spender,uint256 _value,bytes _extraData)
67     public returns (bool success){
68         require(!frozenAccount[msg.sender]);
69         tokenRecipient spender = tokenRecipient(_spender);
70         if(approve(_spender,_value)){
71             spender.receiveApproval(msg.sender,_value,this,_extraData);
72             return true;
73         }
74     }
75     function freezeAccount(address target,bool freeze)  onlyOwner public{
76         require(target!=owner);
77         frozenAccount[target] = freeze;
78         emit FrozenFunds(target,freeze);
79     }
80     function transferOwnership(address newOwner) onlyOwner public{
81         _transfer(owner,newOwner,balanceOf[owner]);
82         owner = newOwner;
83     }
84     function setPrices(uint256 newSellPrice,uint256 newBuyPrice) onlyOwner public{
85         sellPrice = newSellPrice;
86         buyPrice = newBuyPrice;
87     }
88     function setBuyOpen(bool newBuyOpen) onlyOwner public{
89         require(buyPrice>0);
90         buyOpen = newBuyOpen;
91     }
92     function setSellOpen(bool newSellOpen) onlyOwner public{
93         require(sellPrice>0);
94         sellOpen = newSellOpen;
95     }
96     function transferEth(uint256 amount) onlyOwner public{
97         msg.sender.transfer(amount*10**uint256(18));
98     }
99     function _transfer(address _from,address _to, uint256 _value) internal {
100         require(_to != 0x0);
101         require(balanceOf[_from] >= _value);
102         require(balanceOf[_to] + _value >balanceOf[_to]);
103         uint256 previousBalances = balanceOf[_from]+balanceOf[_to];
104         balanceOf[_from] -= _value;
105         balanceOf[_to] += _value;
106         emit Transfer(_from,_to,_value);
107         assert(balanceOf[_from]+balanceOf[_to] == previousBalances);
108     }
109     function _buy() internal returns (uint256 amount){
110         require(buyOpen);
111         require(buyPrice>0);
112         require(msg.value>0);
113         amount = msg.value / buyPrice;
114         _transfer(owner,msg.sender,amount);
115         emit BuyToken(msg.sender,buyPrice,amount,msg.value);
116         return amount;
117     }
118     function _sell(address _from,uint256 amount) internal returns (uint256 revenue){
119         require(sellOpen);
120         require(!frozenAccount[_from]);
121         require(amount>0);
122         require(sellPrice>0);
123         require(_from!=owner);
124         _transfer(_from,owner,amount);
125         revenue = amount * sellPrice;
126         _from.transfer(revenue);
127         emit SellToken(_from,sellPrice,amount,revenue);
128         return revenue;
129     }
130 }