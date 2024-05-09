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
21     mapping (address => string) public nicknames;
22 
23     event Assign(uint indexed _cardIndex, address indexed _seller, uint256 _value);
24     event Transfer(address indexed _from, address indexed _to, uint _cardIndex, uint256 _value);
25     
26     function CryptoNumismat() public payable 
27     {
28         owner = msg.sender;
29         admins[owner] = true;
30         
31         totalSupply = 1000;                         // Update total supply
32         name = "cryptonumismat";                    // Set the name for display purposes
33         symbol = "$";                               // Set the symbol for display purposes
34         decimals = 0;                               // Amount of decimals for display purposes
35     }
36     
37     modifier onlyOwner() 
38     {
39         require(msg.sender == owner);
40         _;
41     }
42     
43     modifier onlyAdmins() 
44     {
45         require(admins[msg.sender]);
46         _;
47     }
48     
49     function setOwner(address _owner) onlyOwner() public 
50     {
51         owner = _owner;
52     }
53     
54     function addAdmin(address _admin) onlyOwner() public
55     {
56         admins[_admin] = true;
57     }
58     
59     function removeAdmin(address _admin) onlyOwner() public
60     {
61         delete admins[_admin];
62     }
63     
64     function withdrawAll() onlyOwner() public 
65     {
66         owner.transfer(this.balance);
67     }
68 
69     function withdrawAmount(uint256 _amount) onlyOwner() public 
70     {
71         require(_amount <= this.balance);
72         
73         owner.transfer(_amount);
74     }
75 
76     function addCard(uint _cardIndex, uint256 _value, address _ownAddress) public onlyAdmins()
77     {
78         require(_cardIndex <= 1000);
79         require(_cardIndex > 0);
80         
81         require(cardsForSale[_cardIndex].cardIndex != _cardIndex);
82         
83         address seller = _ownAddress;
84         uint256 _value2 = (_value * 1000000000);
85         
86         cardsForSale[_cardIndex] = Buy(_cardIndex, seller, _value2);
87         Assign(_cardIndex, seller, _value2);
88     }
89     
90     function displayCard(uint _cardIndex) public constant returns(uint, address, uint256) 
91     {
92         require(_cardIndex <= 1000);
93         require(_cardIndex > 0);
94         
95         require (cardsForSale[_cardIndex].cardIndex == _cardIndex);
96             
97         return(cardsForSale[_cardIndex].cardIndex, 
98         cardsForSale[_cardIndex].seller,
99         cardsForSale[_cardIndex].minValue);
100     }
101     
102     function setNick(string _newNick) public
103     {
104         nicknames[msg.sender] = _newNick;      
105     }
106     
107     function displayNick(address _owner) public constant returns(string)
108     {
109         return nicknames[_owner];
110     }
111     
112     
113     uint256 private limit1 = 0.05 ether;
114     uint256 private limit2 = 0.5 ether;
115     uint256 private limit3 = 5 ether;
116     uint256 private limit4 = 50 ether;
117     
118     function calculateNextPrice(uint256 _startPrice) public constant returns (uint256 _finalPrice)
119     {
120         if (_startPrice < limit1)
121             _startPrice =  _startPrice * 10 / 4;
122         else if (_startPrice < limit2)
123             _startPrice =  _startPrice * 10 / 5;
124         else if (_startPrice < limit3)
125             _startPrice =  _startPrice * 10 / 6;
126         else if (_startPrice < limit4)
127             _startPrice =  _startPrice * 10 / 7;
128         else
129             _startPrice =  _startPrice * 10 / 8;
130             
131         return (_startPrice / 1000000) * 1000000;
132     }
133     
134     function calculateDevCut(uint256 _startPrice) public constant returns (uint256 _cut)
135     {
136         if (_startPrice < limit2)
137             _startPrice =  _startPrice * 5 / 100;
138         else if (_startPrice < limit3)
139             _startPrice =  _startPrice * 4 / 100;
140         else if (_startPrice < limit4)
141             _startPrice =  _startPrice * 3 / 100;
142         else
143             _startPrice =  _startPrice * 2 / 100;
144             
145         return (_startPrice / 1000000) * 1000000;
146     }
147     
148     function buy(uint _cardIndex) public payable
149     {
150         require(_cardIndex <= 1000);
151         require(_cardIndex > 0);
152         require(cardsForSale[_cardIndex].cardIndex == _cardIndex);
153         require(cardsForSale[_cardIndex].seller != msg.sender);
154         require(msg.sender != address(0));
155         require(msg.sender != owner);
156         require(cardsForSale[_cardIndex].minValue > 0);
157         require(msg.value >= cardsForSale[_cardIndex].minValue);
158         
159         address _buyer = msg.sender;
160         address _seller = cardsForSale[_cardIndex].seller;
161         uint256 _price = cardsForSale[_cardIndex].minValue;
162         uint256 _nextPrice = calculateNextPrice(_price);
163         uint256 _totalPrice = _price - calculateDevCut(_price);
164         uint256 _extra = msg.value - _price;
165         
166         cardsForSale[_cardIndex].seller = _buyer;
167         cardsForSale[_cardIndex].minValue = _nextPrice;
168         
169         Transfer(_buyer, _seller, _cardIndex, _totalPrice);
170         Assign(_cardIndex, _buyer, _nextPrice);////////////////////////////////
171         
172         _seller.transfer(_totalPrice);
173         
174         if (_extra > 0)
175         {
176             Transfer(_buyer, _buyer, _cardIndex, _extra);
177             
178             _buyer.transfer(_extra);
179         }
180     }
181 }