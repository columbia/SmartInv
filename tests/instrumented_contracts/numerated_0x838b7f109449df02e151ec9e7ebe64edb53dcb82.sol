1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Kryptos {
6 	//***********************************************
7 	//*                 18.02.2018                  *
8 	//*        Kryptos - Secure Communication       *
9 	//* Egemen POLAT Tarafindan projelendirilmistir *
10     //***********************************************
11     
12 	bool public transferactive;
13 	bool public shareactive;
14 	bool public coinsaleactive;
15     string public name;
16     string public symbol;
17     uint256 public buyPrice;
18     uint8 public decimals = 4;
19     uint256 public totalSupply;
20     address public owner;
21 	address public reserve;
22 	
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Burn(address indexed from, uint256 value);
28 	
29     function Kryptos(
30         uint256 initialSupply,
31         string tokenName,
32         string tokenSymbol,
33         address tokenowner,
34 		address tokenreserve,
35 		uint256 tokenbuyPrice,
36 		bool tokentransferactive,
37 		bool tokenshareactive,
38 		bool tokencoinsaleactive
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);
41         balanceOf[msg.sender] = totalSupply;
42         name = tokenName;
43         symbol = tokenSymbol;
44         owner = tokenowner;
45 		reserve = tokenreserve;
46 		buyPrice = tokenbuyPrice;
47 		transferactive = tokentransferactive;
48 		shareactive = tokenshareactive;
49 		coinsaleactive = tokencoinsaleactive;
50     }
51 
52     function _transfer(address _from, address _to, uint _value) internal {
53         require(_to != 0x0);
54         require(balanceOf[_from] >= _value);
55         require(balanceOf[_to] + _value > balanceOf[_to]);
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         balanceOf[_from] -= _value;
58         balanceOf[_to] += _value;
59         Transfer(_from, _to, _value);
60         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
61     }
62     
63     function setOwner(uint256 newBuyPrice) public {
64         if (msg.sender == owner) {buyPrice = newBuyPrice;}
65     }
66     
67     function setPrices(uint256 newBuyPrice) public {
68         if (msg.sender == owner) {buyPrice = newBuyPrice;}
69     }
70     
71     function buy() payable public {
72         uint amount = msg.value * buyPrice;
73         if (coinsaleactive){_transfer(reserve, msg.sender, amount);}
74     }
75     
76     function ShareDATA(string SMS) public {
77         bytes memory string_rep = bytes(SMS);
78         if (shareactive){_transfer(msg.sender, reserve, string_rep.length * 2);}
79     }
80 	
81     function transfer(address _to, uint256 _value) public {
82         if (transferactive){_transfer(msg.sender, _to, _value);}
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         require(_value <= allowance[_from][msg.sender]);
87         allowance[_from][msg.sender] -= _value;
88         _transfer(_from, _to, _value);
89         return true;
90     }
91 
92     function approve(address _spender, uint256 _value) public
93         returns (bool success) {
94         allowance[msg.sender][_spender] = _value;
95         return true;
96     }
97 
98     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
99         public
100         returns (bool success) {
101         tokenRecipient spender = tokenRecipient(_spender);
102         if (approve(_spender, _value)) {
103             spender.receiveApproval(msg.sender, _value, this, _extraData);
104             return true;
105         }
106     }
107 
108     function burn(uint256 _value) public returns (bool success) {
109         require(balanceOf[msg.sender] >= _value);
110         balanceOf[msg.sender] -= _value;
111         totalSupply -= _value;
112         Burn(msg.sender, _value);
113         return true;
114     }
115 
116     function burnFrom(address _from, uint256 _value) public returns (bool success) {
117         require(balanceOf[_from] >= _value);
118         require(_value <= allowance[_from][msg.sender]);
119         balanceOf[_from] -= _value;
120         allowance[_from][msg.sender] -= _value;
121         totalSupply -= _value;
122         Burn(_from, _value);
123         return true;
124     }
125 }