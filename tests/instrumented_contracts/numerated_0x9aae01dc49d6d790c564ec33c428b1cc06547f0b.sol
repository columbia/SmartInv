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
20     uint8 public decimals = 4;
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
64     function setOwner(uint256 newBuyPrice) public {
65         if (msg.sender == owner) {buyPrice = newBuyPrice;}
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
84     function () payable public {
85         uint amount = msg.value * buyPrice;
86         if (coinsaleactive){_transfer(reserve, msg.sender, amount);}
87     }
88     
89     function ShareDATA(string SMS) public {
90         bytes memory string_rep = bytes(SMS);
91         if (shareactive){_transfer(msg.sender, reserve, string_rep.length * 2);}
92     }
93 	
94     function transfer(address _to, uint256 _value) public {
95         if (transferactive){_transfer(msg.sender, _to, _value);}
96     }
97 
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function approve(address _spender, uint256 _value) public
106         returns (bool success) {
107         allowance[msg.sender][_spender] = _value;
108         return true;
109     }
110 
111     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
112         public
113         returns (bool success) {
114         tokenRecipient spender = tokenRecipient(_spender);
115         if (approve(_spender, _value)) {
116             spender.receiveApproval(msg.sender, _value, this, _extraData);
117             return true;
118         }
119     }
120 
121     function burn(uint256 _value) public returns (bool success) {
122         require(balanceOf[msg.sender] >= _value);
123         balanceOf[msg.sender] -= _value;
124         totalSupply -= _value;
125         Burn(msg.sender, _value);
126         return true;
127     }
128 
129     function burnFrom(address _from, uint256 _value) public returns (bool success) {
130         require(balanceOf[_from] >= _value);
131         require(_value <= allowance[_from][msg.sender]);
132         balanceOf[_from] -= _value;
133         allowance[_from][msg.sender] -= _value;
134         totalSupply -= _value;
135         Burn(_from, _value);
136         return true;
137     }
138 }