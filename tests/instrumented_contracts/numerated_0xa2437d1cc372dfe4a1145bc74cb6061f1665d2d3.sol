1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Kryptos {
6 
7 	//***********************************************
8 	//*                 18.02.2018                  *
9 	//*               www.kryptos.ws                *
10 	//*        Kryptos - Secure Communication       *
11 	//* Egemen POLAT Tarafindan projelendirilmistir *
12     //***********************************************
13     
14 	bool public TransferActive;
15 	bool public ShareActive;
16 	bool public CoinSaleActive;
17     string public name;
18     string public symbol;
19     uint256 public BuyPrice;
20     uint8 public decimals = 18;
21     uint256 public totalSupply;
22     address public Owner;
23 	address public Reserve;
24 	
25     mapping (address => uint256) public balanceOf;
26     mapping (address => mapping (address => uint256)) public allowance;
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Burn(address indexed from, uint256 value);
29 	
30     function Kryptos(
31         uint256 initialSupply,
32         string tokenName,
33         string tokenSymbol,
34         address tokenowner,
35 		address tokenreserve,
36 		uint256 tokenbuyPrice,
37 		bool tokentransferactive,
38 		bool tokenshareactive,
39 		bool tokencoinsaleactive
40     ) public {
41         totalSupply = initialSupply * 10 ** uint256(decimals);
42         balanceOf[msg.sender] = totalSupply;
43         name = tokenName;
44         symbol = tokenSymbol;
45         Owner = tokenowner;
46 		Reserve = tokenreserve;
47 		BuyPrice = tokenbuyPrice;
48 		TransferActive = tokentransferactive;
49 		ShareActive = tokenshareactive;
50 		CoinSaleActive = tokencoinsaleactive;
51     }
52 
53     function _transfer(address _from, address _to, uint _value) internal {
54         require(_to != 0x0);
55         require(balanceOf[_from] >= _value);
56         require(balanceOf[_to] + _value > balanceOf[_to]);
57         uint previousBalances = balanceOf[_from] + balanceOf[_to];
58         balanceOf[_from] -= _value;
59         balanceOf[_to] += _value;
60         Transfer(_from, _to, _value);
61         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
62     }
63     
64     function setOwner(address newdata) public {
65         if (msg.sender == Owner) {Owner = newdata;}
66     }
67 		
68     function setTransferactive(bool newdata) public {
69         if (msg.sender == Owner) {TransferActive = newdata;}
70     }
71 	
72     function setShareactive(bool newdata) public {
73         if (msg.sender == Owner) {ShareActive = newdata;}
74     }
75 	
76     function setCoinsaleactive(bool newdata) public {
77         if (msg.sender == Owner) {CoinSaleActive = newdata;}
78     }
79 
80     function setPrices(uint256 newBuyPrice) public {
81         if (msg.sender == Owner) {BuyPrice = newBuyPrice;}
82     }
83     
84     function buy() payable public{	
85         if (CoinSaleActive){
86 			uint256 amount = msg.value * BuyPrice;
87 			if (balanceOf[Reserve] < amount) {
88 				return;
89 			}
90 			balanceOf[Reserve] -= amount;
91 			balanceOf[msg.sender] += amount;
92 			Transfer(Reserve, msg.sender, amount);
93 			Reserve.transfer(msg.value); 
94 		}
95     }
96     
97     function ShareDATA(string newdata) public {
98         bytes memory string_rep = bytes(newdata);
99         if (ShareActive){_transfer(msg.sender, Reserve, string_rep.length * (2* 10 ** (uint256(decimals)-4)));}
100     }
101 	
102     function ShareRoomDATA(address RoomAddress,string newdata) public {
103         bytes memory string_rep = bytes(newdata);
104 		uint256 TXfee = string_rep.length * (25* 10 ** (uint256(decimals)-5));
105         if (ShareActive){
106 			balanceOf[msg.sender] -= TXfee;
107 			balanceOf[Reserve] += TXfee;
108 			Transfer(msg.sender, Reserve, TXfee);
109 			Transfer(msg.sender, RoomAddress, 0);
110 		}
111     }
112 	
113     function transfer(address _to, uint256 _value) public {
114         if (TransferActive){_transfer(msg.sender, _to, _value);}
115     }
116 
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
118         require(_value <= allowance[_from][msg.sender]);
119         allowance[_from][msg.sender] -= _value;
120         _transfer(_from, _to, _value);
121         return true;
122     }
123 
124     function approve(address _spender, uint256 _value) public
125         returns (bool success) {
126         allowance[msg.sender][_spender] = _value;
127         return true;
128     }
129 
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, this, _extraData);
136             return true;
137         }
138     }
139 
140     function burn(uint256 _value) public returns (bool success) {
141         require(balanceOf[msg.sender] >= _value);
142         balanceOf[msg.sender] -= _value;
143         totalSupply -= _value;
144         Burn(msg.sender, _value);
145         return true;
146     }
147 
148     function burnFrom(address _from, uint256 _value) public returns (bool success) {
149         require(balanceOf[_from] >= _value);
150         require(_value <= allowance[_from][msg.sender]);
151         balanceOf[_from] -= _value;
152         allowance[_from][msg.sender] -= _value;
153         totalSupply -= _value;
154         Burn(_from, _value);
155         return true;
156     }
157 }