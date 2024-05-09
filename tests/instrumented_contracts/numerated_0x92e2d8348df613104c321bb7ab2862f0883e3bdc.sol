1 pragma solidity ^0.4.8;
2 contract CryptoNumismat 
3 {
4     address owner;
5 
6     string public standard = 'CryptoNumismat';
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11 
12     struct Buy 
13     {
14         uint cardIndex;
15         address seller;
16         uint minValue;  // in wei
17     }
18 
19     mapping (uint => Buy) public cardsForSale;
20     mapping (address => bool) public admins;
21 
22     event Assign(uint indexed _cardIndex, address indexed _seller, uint256 _value);
23     event Transfer(address indexed _from, address indexed _to, uint _cardIndex, uint256 _value);
24     
25     function CryptoNumismat() public payable 
26     {
27         owner = msg.sender;
28         admins[owner] = true;
29         
30         totalSupply = 1000;                         // Update total supply
31         name = "cryptonumismat";                    // Set the name for display purposes
32         symbol = "$";                               // Set the symbol for display purposes
33         decimals = 0;                               // Amount of decimals for display purposes
34     }
35     
36     modifier onlyOwner() 
37     {
38         require(msg.sender == owner);
39         _;
40     }
41     
42     modifier onlyAdmins() 
43     {
44         require(admins[msg.sender]);
45         _;
46     }
47     
48     function setOwner(address _owner) onlyOwner() public 
49     {
50         owner = _owner;
51     }
52     
53     function addAdmin(address _admin) onlyOwner() public
54     {
55         admins[_admin] = true;
56     }
57     
58     function removeAdmin(address _admin) onlyOwner() public
59     {
60         delete admins[_admin];
61     }
62     
63     function withdrawAll() onlyOwner() public 
64     {
65         owner.transfer(this.balance);
66     }
67 
68     function withdrawAmount(uint256 _amount) onlyOwner() public 
69     {
70         require(_amount <= this.balance);
71         
72         owner.transfer(_amount);
73     }
74 
75     function addCard(uint _cardIndex, uint256 _value) public onlyAdmins()
76     {
77         require(_cardIndex <= 1000);
78         require(_cardIndex > 0);
79         
80         require(cardsForSale[_cardIndex].cardIndex != _cardIndex);
81         
82         address seller = msg.sender;
83         uint256 _value2 = (_value * 1000000000);
84         
85         cardsForSale[_cardIndex] = Buy(_cardIndex, seller, _value2);
86         Assign(_cardIndex, seller, _value2);
87     }
88     
89     function displayCard(uint _cardIndex) public constant returns(uint, address, uint256) 
90     {
91         require(_cardIndex <= 1000);
92         require(_cardIndex > 0);
93         
94         require (cardsForSale[_cardIndex].cardIndex == _cardIndex);
95             
96         return(cardsForSale[_cardIndex].cardIndex, 
97         cardsForSale[_cardIndex].seller,
98         cardsForSale[_cardIndex].minValue);
99     }
100     
101     
102     uint256 private limit1 = 0.05 ether;
103     uint256 private limit2 = 0.5 ether;
104     uint256 private limit3 = 5 ether;
105     uint256 private limit4 = 50 ether;
106     
107     function calculateNextPrice(uint256 _startPrice) public constant returns (uint256 _finalPrice)
108     {
109         if (_startPrice < limit1)
110             return _startPrice * 10 / 4;
111         else if (_startPrice < limit2)
112             return _startPrice * 10 / 5;
113         else if (_startPrice < limit3)
114             return _startPrice * 10 / 6;
115         else if (_startPrice < limit4)
116             return _startPrice * 10 / 7;
117         else
118             return _startPrice * 10 / 8;
119     }
120     
121     function calculateDevCut(uint256 _startPrice) public constant returns (uint256 _cut)
122     {
123         if (_startPrice < limit2)
124             return _startPrice * 5 / 100;
125         else if (_startPrice < limit3)
126             return _startPrice * 4 / 100;
127         else if (_startPrice < limit4)
128             return _startPrice * 3 / 100;
129         else
130             return _startPrice * 2 / 100;
131     }
132     
133     function buy(uint _cardIndex) public payable
134     {
135         require(_cardIndex <= 1000);
136         require(_cardIndex > 0);
137         require(cardsForSale[_cardIndex].cardIndex == _cardIndex);
138         require(cardsForSale[_cardIndex].seller != msg.sender);
139         require(msg.sender != address(0));
140         require(msg.sender != owner);
141         require(cardsForSale[_cardIndex].minValue > 0);
142         require(msg.value >= cardsForSale[_cardIndex].minValue);
143         
144         address _buyer = msg.sender;
145         address _seller = cardsForSale[_cardIndex].seller;
146         uint256 _price = cardsForSale[_cardIndex].minValue;
147         uint256 _nextPrice = calculateNextPrice(_price);
148         uint256 _totalPrice = _price - calculateDevCut(_price);
149         uint256 _extra = msg.value - _price;
150         
151         cardsForSale[_cardIndex].seller = _buyer;
152         cardsForSale[_cardIndex].minValue = _nextPrice;
153         
154         Transfer(_buyer, _seller, _cardIndex, _totalPrice);
155         Assign(_cardIndex, _buyer, _nextPrice);////////////////////////////////
156         
157         _seller.transfer(_totalPrice);
158         
159         if (_extra > 0)
160         {
161             Transfer(_buyer, _buyer, _cardIndex, _extra);
162             
163             _buyer.transfer(_extra);
164         }
165     }
166 }