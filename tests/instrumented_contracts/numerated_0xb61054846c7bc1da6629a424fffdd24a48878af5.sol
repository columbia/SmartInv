1 pragma solidity ^0.4.20;
2 
3 contract Universe{
4     // Universe contract
5     // It is possible to buy planets or other universe-objects from other accounts.
6     // If an object has an owner, fees will be paid to that owner until no owner has been found.
7     
8     struct Item{
9         uint256 id;
10         string name;
11         uint256 price;
12         uint256 id_owner;
13         address owner;
14     }
15     
16    // bool TESTMODE = true;
17     
18   //  event pushuint(uint256 push);
19  //   event pushstr(string str);
20   //  event pusha(address addr);
21     
22     uint256[4] LevelLimits = [0.05 ether, 0.5 ether, 2 ether, 5 ether];
23     uint256[5] devFee = [5,4,3,2,2];
24     uint256[5] shareFee = [12,6,4,3,2];
25     uint256[5] raisePrice = [100, 35, 25, 17, 15];
26     
27     
28     mapping (uint256 => Item) public ItemList;
29     uint256 public current_item_index=1;
30     
31     address owner;
32     modifier onlyOwner() {
33         require(owner == msg.sender);
34         _;
35     }
36 
37     function Universe() public{
38         owner=msg.sender;
39         AddItem("Sun", 1 finney, 0);
40         AddItem("Mercury", 1 finney, 1);
41         AddItem("Venus", 1 finney, 1);
42         AddItem("Earth", 1 finney, 1);
43         AddItem("Mars", 1 finney, 1);
44         AddItem("Jupiter", 1 finney, 1);
45         AddItem("Saturn", 1 finney, 1);
46         AddItem("Uranus", 1 finney, 1);
47         AddItem("Neptune", 1  finney, 1);
48         AddItem("Pluto", 1 finney, 1);
49         AddItem("Moon", 1 finney, 4);
50     }
51     
52     function CheckItemExists(uint256 _id) internal returns (bool boolean){
53         if (ItemList[_id].price == 0){
54             return false;
55         }
56         return true;
57     }
58 
59     
60  //   function AddItem(string _name, uint256 _price, uint256 _id_owner) public {
61     function AddItem(string _name, uint256 _price, uint256 _id_owner) public onlyOwner {
62 //if (TESTMODE){
63 //if (_price < (1 finney)){
64   //              _price = (1 finney);
65     //        }
66 //}
67         //require(_id != 0);
68         //require(_id == current_item_index);
69         uint256 _id = current_item_index;
70 
71         require(_id_owner != _id);
72         require(_id_owner < _id);
73 
74         require(_price >= (1 finney));
75         require(_id_owner == 0 || CheckItemExists(_id_owner));
76         require(CheckItemExists(_id) != true);
77         
78      //   uint256 current_id_owner = _id_owner;
79         
80      //   uint256[] mem_owner;
81         
82         //pushuint(mem_owner.length);
83         
84         /*while (current_id_owner != 0){
85            
86             mem_owner[mem_owner.length-1] = current_id_owner;
87             current_id_owner = ItemList[current_id_owner].id_owner;
88             
89           
90             for(uint256 c=0; c<mem_owner.length; c++){
91                if(c != (mem_owner.length-1)){
92                    if(mem_owner[c] == current_id_owner){
93                         pushstr("false");
94                         return;
95                     }
96                 }
97             }
98             mem_owner.length += 1;
99         }*/
100         
101         var NewItem = Item(_id, _name, _price, _id_owner, owner);
102         ItemList[current_item_index] = NewItem;
103         current_item_index++;
104         
105     }
106     
107     function ChangeItemOwnerID(uint256 _id, uint256 _new_owner) public onlyOwner {
108         require(_new_owner != _id);
109         require(_id <= (current_item_index-1));
110         require(_id != 0);
111         require(_new_owner != 0);
112         require(_new_owner <= (current_item_index-1));
113         require(ItemList[_id].id_owner == 0);
114        
115         uint256 current_id_owner = _new_owner;
116         uint256[] mem_owner;   
117         
118          while (current_id_owner != 0){
119            
120             mem_owner[mem_owner.length-1] = current_id_owner;
121             current_id_owner = ItemList[current_id_owner].id_owner;
122             
123           
124             for(uint256 c=0; c<mem_owner.length; c++){
125                if(c != (mem_owner.length-1)){
126                    if(mem_owner[c] == current_id_owner || mem_owner[c] == _new_owner || mem_owner[c] == _id){
127 //pushstr("false");
128                         return;
129                     }
130                 }
131             }
132             mem_owner.length += 1;
133         }  
134         
135         ItemList[_id].id_owner = _new_owner;
136         
137     }
138 
139     function DoDividend(uint256 _current_index, uint256 valueShareFee, uint256 id_owner) internal returns (uint256){
140             uint256 pow = 0;
141             uint256 totalShareFee = 0;
142             uint256 current_index = _current_index;
143             while (current_index != 0){
144                 pow = pow + 1;
145                 current_index = ItemList[current_index].id_owner;
146             }
147         
148             uint256 total_sum = 0;
149         
150             for (uint256 c2=0; c2<pow; c2++){
151                 total_sum = total_sum + 2**c2;
152             }
153         
154             if (total_sum != 0){
155                // uint256 tot_value = 2**(pow-1);
156         
157                 current_index = id_owner;
158         
159                 while (current_index != 0){
160                     uint256 amount = div(mul(valueShareFee, 2**(pow-1)), total_sum);
161                     totalShareFee = add(amount, totalShareFee);
162                     ItemList[current_index].owner.transfer(amount);
163                 //    pusha(ItemList[current_index].owner);
164                  //   pushuint(amount);
165                     
166                     pow = sub(pow, 1);
167                     current_index = ItemList[current_index].id_owner;
168                 }
169             }
170             else{
171                 ItemList[current_index].owner.transfer(valueShareFee);
172             //    pusha(ItemList[current_index].owner);
173              //   pushuint(valueShareFee);
174                 totalShareFee = valueShareFee;
175             }
176             return totalShareFee;
177     }    
178     
179     function BuyItem(uint256 _id) public payable{
180         require(_id > 0 && _id < current_item_index);
181         var TheItem = ItemList[_id];
182         require(TheItem.owner != msg.sender);
183         require(msg.value >= TheItem.price);
184     
185         uint256 index=0;
186         
187         for (uint256 c=0; c<LevelLimits.length; c++){
188             uint256 value = LevelLimits[c];
189             if (TheItem.price < value){
190                 break;
191             }
192             index++;
193         }
194         
195         uint256 valueShareFee = div(mul(TheItem.price, shareFee[index]), 100);
196         uint256 totalShareFee = 0;
197         uint256 valueDevFee = div(mul(TheItem.price, devFee[index]), 100);
198         uint256 valueRaisePrice = div(mul(TheItem.price, 100 + raisePrice[index]), 100);
199         
200         uint256 current_index = TheItem.id_owner;
201         
202         if (current_index != 0){
203             totalShareFee = DoDividend(current_index, valueShareFee, current_index);
204         }
205         
206         owner.transfer(valueDevFee);
207         
208       //  pushstr("dev");
209       //  pushuint(valueDevFee);
210         
211         
212         uint256 totalToOwner = sub(sub(TheItem.price, valueDevFee), totalShareFee);
213         
214         uint256 totalBack = sub(sub(sub(msg.value, totalToOwner), valueDevFee), totalShareFee);
215         
216         if (totalBack > 0){
217             msg.sender.transfer(totalBack);
218         }
219         
220        // pushstr("owner transfer");
221        // pushuint(totalToOwner);
222         TheItem.owner.transfer(totalToOwner);
223         
224         TheItem.owner = msg.sender;
225         TheItem.price = valueRaisePrice;
226     }
227     
228    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
229       if (a == 0) {
230          return 0;
231       }
232       uint256 c = a * b;
233       assert(c / a == b);
234       return c;
235    }
236 
237    function div(uint256 a, uint256 b) internal pure returns (uint256) {
238       // assert(b > 0); // Solidity automatically throws when dividing by 0
239       uint256 c = a / b;
240       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241       return c;
242    }
243 
244    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
245       assert(b <= a);
246       return a - b;
247    }
248 
249    function add(uint256 a, uint256 b) internal pure returns (uint256) {
250       uint256 c = a + b;
251       assert(c >= a);
252       return c;
253    }
254     
255 }