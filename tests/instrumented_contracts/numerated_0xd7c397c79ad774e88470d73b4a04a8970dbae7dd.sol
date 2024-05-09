1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 
47 contract CryptoHearthStone {
48   using SafeMath for uint256;
49   struct Card {
50         uint attribute; // Card occupational attributes
51         uint256 price;// Card price
52         address delegate; // person delegated to
53         bool isSale;//Is the card sold?
54   }
55 
56   Card[] private cards;
57 
58   mapping (address => uint) private ownershipCardCount;
59 
60   event Transfer(address from, address to, uint256 cardId);
61 
62   event CardSold(uint256 cardId, uint256 price, address prevOwner, address newOwner);
63 
64   event userSell(uint256 cardId, uint256 price, address owner);
65 
66   event CancelCardSell(uint256 cardId, address owner);
67 
68   uint constant private DEFAULT_START_PRICE = 0.01 ether;
69   uint constant private FIRST_PRICE_LIMIT =  0.5 ether;
70   uint constant private SECOND_PRICE_LIMIT =  2 ether;
71   uint constant private THIRD_PRICE_LIMIT =  5 ether;
72 
73   uint constant private FIRST_COMMISSION_LEVEL = 6;
74   uint constant private SECOND_COMMISSION_LEVEL = 5;
75   uint constant private THIRD_COMMISSION_LEVEL = 4;
76   uint constant private FOURTH_COMMISSION_LEVEL = 3;
77 
78   address private owner;
79   mapping (address => bool) private admins;
80 
81   function CryptoHearthStone () public {
82     owner = msg.sender;
83     admins[owner] = true;
84   }
85    /* Modifiers */
86    modifier onlyOwner() {
87      require(owner == msg.sender);
88      _;
89    }
90 
91    modifier onlyAdmins() {
92      require(admins[msg.sender]);
93      _;
94    }
95 
96    function addAdmin (address _admin) onlyOwner() public {
97      admins[_admin] = true;
98    }
99 
100    function removeAdmin (address _admin) onlyOwner() public {
101      delete admins[_admin];
102    }
103 
104    function withdrawAll () onlyAdmins() public {
105      msg.sender.transfer(this.balance);
106    }
107 
108   function withdrawAmount (uint256 _amount) onlyAdmins() public {
109     msg.sender.transfer(_amount);
110   }
111 
112   function initCards (uint _attribut) onlyAdmins() public {
113       for(uint i=0;i<10;i++)
114       {
115           createCard(_attribut,20800000000000000);
116       }
117   }
118 
119   function createCard (uint _attribute, uint256 _price) onlyAdmins() public {
120     require(_price > 0);
121 
122     Card memory _card = Card({
123       attribute: _attribute,
124       price: _price,
125       delegate: msg.sender,
126       isSale: true
127     });
128     cards.push(_card);
129   }
130 
131   function getCard(uint _id) public view returns (uint attribute, uint256 price,address delegate,bool isSale,bool isWoner) {
132     require(_id < cards.length);
133     require(_addressNotNull(msg.sender));
134     Card memory _card=cards[_id];
135     isWoner=false;
136     if(_card.delegate==msg.sender) isWoner=true;
137     return (_card.attribute,_card.price,_card.delegate,_card.isSale,isWoner);
138   }
139 
140   function getMyCards(address _owner) public view returns (uint[] userCards) {
141     require(_addressNotNull(_owner));
142     uint cardCount = ownershipCardCount[_owner];
143     userCards = new uint[](cardCount);
144     if(_owner==owner)return userCards;
145     uint totalTeams = cards.length;
146     uint resultIndex = 0;
147     if (cardCount > 0) {
148       for (uint pos = 0; pos < totalTeams; pos++) {
149         if (cardOwnerOf(pos) == _owner) {
150           userCards[resultIndex] = pos;
151           resultIndex++;
152         }
153       }
154     }
155   }
156 
157   function purchase(uint _cardId) public payable {
158     address oldOwner = cardOwnerOf(_cardId);
159     address newOwner = msg.sender;
160 
161     uint sellingPrice = cards[_cardId].price;
162     require(newOwner != owner);
163 
164     require(oldOwner != newOwner);
165 
166     require(_addressNotNull(newOwner));
167 
168     require(cards[_cardId].isSale == true);
169 
170     require(msg.value >= sellingPrice);
171 
172     uint payment =  _calculatePaymentToOwner(sellingPrice);
173     uint excessPayment = msg.value.sub(sellingPrice);
174 
175     _transfer(oldOwner, newOwner, _cardId);
176     if (oldOwner != address(this)) {
177       oldOwner.transfer(payment);
178     }
179 
180     newOwner.transfer(excessPayment);
181 
182     CardSold(_cardId, sellingPrice, oldOwner, newOwner);
183   }
184 
185   function sell(uint _cardId, uint256 _price) public {
186       require(_price > 0);
187       address oldOwner = cardOwnerOf(_cardId);
188       require(_addressNotNull(oldOwner));
189       require(oldOwner == msg.sender);
190       cards[_cardId].price=_price;
191       cards[_cardId].isSale=true;
192       userSell(_cardId, _price,oldOwner);
193   }
194 
195   function CancelSell(uint _cardId) public {
196       address oldOwner = cardOwnerOf(_cardId);
197       require(_addressNotNull(oldOwner));
198       require(oldOwner == msg.sender);
199       cards[_cardId].isSale=false;
200       CancelCardSell(_cardId,oldOwner);
201   }
202 
203   function _calculatePaymentToOwner(uint _sellingPrice) private pure returns (uint payment) {
204     if (_sellingPrice < FIRST_PRICE_LIMIT) {
205       payment = uint256(_sellingPrice.mul(100-FIRST_COMMISSION_LEVEL).div(100));
206     }
207     else if (_sellingPrice < SECOND_PRICE_LIMIT) {
208       payment = uint256(_sellingPrice.mul(100-SECOND_COMMISSION_LEVEL).div(100));
209     }
210     else if (_sellingPrice < THIRD_PRICE_LIMIT) {
211       payment = uint256(_sellingPrice.mul(100-THIRD_COMMISSION_LEVEL).div(100));
212     }
213     else {
214       payment = uint256(_sellingPrice.mul(100-FOURTH_COMMISSION_LEVEL).div(100));
215     }
216   }
217 
218   function cardOwnerOf(uint _cardId) public view returns (address cardOwner) {
219     require(_cardId < cards.length);
220     cardOwner = cards[_cardId].delegate;
221   }
222 
223   function _addressNotNull(address _to) private pure returns (bool) {
224     return _to != address(0);
225   }
226 
227   function _transfer(address _from, address _to, uint _cardId) private {
228     ownershipCardCount[_to]++;
229     cards[_cardId].delegate=_to;
230     cards[_cardId].isSale=false;
231     if (_from != address(0)) {
232       ownershipCardCount[_from]--;
233     }
234 
235     Transfer(_from, _to, _cardId);
236   }
237 }