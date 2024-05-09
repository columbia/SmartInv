1 pragma solidity ^0.4.19;
2 
3 contract Ownable{
4     address public owner;
5 
6     function Ownable() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract CryptoChamps is Ownable{
21     
22     struct Person {
23         uint32 id;
24         string name;
25         uint16 txCount;
26         bool discounted;
27     }
28     
29     event Birth(uint32 _id, uint _startingPrice);
30     event Discount(uint32 _id, uint _newPrice);
31     event Purchase(uint32 indexed _id, address indexed _by, address indexed _from, uint _price, uint _nextPrice);
32     event Transfer(address indexed _from, address indexed _to, uint32 _id);
33     
34     uint public totalSupply = 0;
35     string public name = "CryptoChamps";
36     string public symbol = "CCH";
37     address store;
38     mapping (uint32 => Person) private people;
39     mapping (uint32 => address) private personToOwner;
40     mapping (uint32 => uint256) public personToPrice;
41     mapping (uint32 => uint256) public personToOldPrice;
42     mapping (address => uint) private noOfPersonsOwned;
43     mapping (address => bool) private isUserAdded;
44     
45     address[] private users;
46     
47     uint8 BELOW_FIVE = 200;
48     uint8 BELOW_TEN = 150;
49     uint8 BELOW_FIFTEEN = 130;
50     uint8 BELOW_TWENTY = 120;
51     uint8 TWENTY_ABOVE = 110;
52     
53     function CryptoChamps() public{
54         store = msg.sender;
55     }
56     
57     function createPerson (uint32 _id, string _name, uint256 _startingPrice) external onlyOwner {
58         require(people[_id].id == 0);
59         Person memory person = Person(_id, _name, 0, false);
60         people[_id] = person;
61         personToOwner[_id] = owner;
62         personToPrice[_id] = _startingPrice;
63         totalSupply++;
64         Birth(_id, _startingPrice);
65     }
66     
67     function getPerson(uint32 _id) external view returns (string, uint256, uint256) {
68        Person memory person = people[_id];
69        require(person.id != 0);
70        return (person.name, personToPrice[_id], person.txCount);
71     }
72     
73     function purchase(uint32 _id) payable public{
74         uint price = personToPrice[_id] ;
75         address personOwner = personToOwner[_id];
76         
77         require(msg.sender != 0x0);
78         require(msg.sender != personOwner);
79         require(price <= msg.value);
80         
81         
82         Person storage person = people[_id];
83         
84         if(price < msg.value){
85             msg.sender.transfer(msg.value - price);
86         }
87         
88         _handlePurchase(person, personOwner, price);
89         uint newPrice = _onPersonSale(person);
90         
91         if(!isUserAdded[msg.sender]){
92             users.push(msg.sender);
93             isUserAdded[msg.sender] = true;
94         }
95         
96         Purchase(_id, msg.sender, personOwner, price, newPrice);
97     }
98     
99     function discount(uint32 _id, uint _newPrice) external ownsPerson(_id) returns (bool){
100         uint price = personToPrice[_id];
101         require(price > _newPrice);
102         
103         Person storage person = people[_id];
104         person.discounted = true;
105         
106         personToPrice[_id] = _newPrice;
107         
108         Discount(_id, _newPrice);
109         
110         return true;
111     }
112     
113     function _handlePurchase(Person storage _person, address _owner, uint _price) internal {
114         uint oldPrice = personToOldPrice[_person.id];
115         
116         if(_person.discounted){
117             _shareDiscountPrice(_price, _owner);
118         }else{
119             _shareProfit(_price, oldPrice, _owner);
120         }
121         
122         personToOwner[_person.id] = msg.sender;
123         
124         noOfPersonsOwned[_owner]--;
125         noOfPersonsOwned[msg.sender]++;
126     }
127     
128     function _shareDiscountPrice(uint _price, address _target) internal {
129         uint commision = _price * 10 / 100;
130         
131         _target.transfer(_price - commision);
132         
133         owner.transfer(commision);
134     }
135     
136     function _shareProfit(uint _price, uint _oldPrice, address _target) internal {
137         uint profit = _price - _oldPrice;
138         
139         uint commision = profit * 30 / 100;
140         
141         _target.transfer(_price - commision);
142         
143         owner.transfer(commision);
144     }
145     
146     function _onPersonSale(Person storage _person) internal returns (uint) {
147         uint currentPrice = personToPrice[_person.id];
148         uint percent = 0;
149         
150         if(currentPrice >= 6.25 ether){
151             percent = TWENTY_ABOVE;
152         }else if(currentPrice >= 2.5 ether){
153             percent = BELOW_TWENTY;
154         }else if(currentPrice >=  1 ether){
155             percent = BELOW_FIFTEEN;
156         }else if(currentPrice >= 0.1 ether){
157             percent = BELOW_TEN;
158         }else{
159             percent = BELOW_FIVE;
160         }
161         
162         personToOldPrice[_person.id] = currentPrice;
163         uint newPrice = _approx((currentPrice * percent) / 100);
164         personToPrice[_person.id] = newPrice;
165         
166         _person.txCount++;
167         if(_person.discounted){
168             _person.discounted = false;
169         }
170         
171         return newPrice;
172     }
173     
174     function _approx(uint _price) internal pure returns (uint){
175         uint product = _price / 10 ** 14;
176         return product * 10 ** 14;
177     }
178     
179     function transfer(address _to, uint32 _id) external ownsPerson(_id){
180         personToOwner[_id] = _to;
181         noOfPersonsOwned[_to]++;
182         noOfPersonsOwned[msg.sender]--;
183         Transfer(msg.sender, _to, _id);
184     }
185     
186     function ownerOf(uint32 _id) external view returns (address) {
187         return personToOwner[_id];
188     }
189     
190     function priceOf(uint32 _id) external view returns (uint256) {
191         return personToPrice[_id];
192     }
193     
194     function balanceOf(address _owner) external view returns (uint){
195         return noOfPersonsOwned[_owner];
196     }
197     
198     function getStore() external view onlyOwner returns (address){
199         return store;
200     }
201     
202     function setStore(address _store) external onlyOwner returns (bool) {
203         require(_store != 0);
204         store = _store;
205         return true;
206     }
207     
208     function getUsers() external view returns (address[]) {
209         return users;
210     }
211     
212     function withdraw() external onlyOwner returns (bool){
213         owner.transfer(this.balance);
214         return true;
215     }
216     
217     modifier ownsPerson(uint32 _id){
218         require(personToOwner[_id] == msg.sender);
219         _;
220     }
221     
222 }