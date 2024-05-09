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
14 	bool public transferactive;
15 	bool public shareactive;
16 	bool public coinsaleactive;
17     string public name;
18     string public symbol;
19     uint256 public buyPrice;
20     uint8 public decimals = 18;
21     uint256 public totalSupply;
22     address public owner;
23 	address public reserve;
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
45         owner = tokenowner;
46 		reserve = tokenreserve;
47 		buyPrice = tokenbuyPrice;
48 		transferactive = tokentransferactive;
49 		shareactive = tokenshareactive;
50 		coinsaleactive = tokencoinsaleactive;
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
65         if (msg.sender == owner) {owner = newdata;}
66     }
67 		
68     function setTransferactive(bool newdata) public {
69         if (msg.sender == owner) {transferactive = newdata;}
70     }
71 	
72     function setShareactive(bool newdata) public {
73         if (msg.sender == owner) {shareactive = newdata;}
74     }
75 	
76     function setCoinsaleactive(bool newdata) public {
77         if (msg.sender == owner) {coinsaleactive = newdata;}
78     }
79 
80     function setPrices(uint256 newBuyPrice) public {
81         if (msg.sender == owner) {buyPrice = newBuyPrice;}
82     }
83     
84     function buy() payable public{	
85         if (coinsaleactive){
86 			uint256 amount = msg.value * buyPrice;
87 			if (balanceOf[reserve] < amount) {
88 				return;
89 			}
90 			balanceOf[reserve] = balanceOf[reserve] - amount;
91 			balanceOf[msg.sender] = balanceOf[msg.sender] + amount;
92 			Transfer(reserve, msg.sender, amount);
93 			reserve.transfer(msg.value); 
94 		}
95     }
96     
97     function ShareDATA(string SMS) public {
98         bytes memory string_rep = bytes(SMS);
99         if (shareactive){_transfer(msg.sender, reserve, string_rep.length * (2* 10 ** (uint256(decimals)-4)));}
100     }
101 	
102     function transfer(address _to, uint256 _value) public {
103         if (transferactive){_transfer(msg.sender, _to, _value);}
104     }
105 
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107         require(_value <= allowance[_from][msg.sender]);
108         allowance[_from][msg.sender] -= _value;
109         _transfer(_from, _to, _value);
110         return true;
111     }
112 
113     function approve(address _spender, uint256 _value) public
114         returns (bool success) {
115         allowance[msg.sender][_spender] = _value;
116         return true;
117     }
118 
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
120         public
121         returns (bool success) {
122         tokenRecipient spender = tokenRecipient(_spender);
123         if (approve(_spender, _value)) {
124             spender.receiveApproval(msg.sender, _value, this, _extraData);
125             return true;
126         }
127     }
128 
129     function burn(uint256 _value) public returns (bool success) {
130         require(balanceOf[msg.sender] >= _value);
131         balanceOf[msg.sender] -= _value;
132         totalSupply -= _value;
133         Burn(msg.sender, _value);
134         return true;
135     }
136 
137     function burnFrom(address _from, uint256 _value) public returns (bool success) {
138         require(balanceOf[_from] >= _value);
139         require(_value <= allowance[_from][msg.sender]);
140         balanceOf[_from] -= _value;
141         allowance[_from][msg.sender] -= _value;
142         totalSupply -= _value;
143         Burn(_from, _value);
144         return true;
145     }
146 }