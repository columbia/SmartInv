1 pragma solidity ^0.4.18;
2 
3 ///EtherDrugs
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 contract ERC721 {
8     function approve(address _to, uint256 _tokenId) public;
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function implementsERC721() public pure returns (bool);
11     function ownerOf(uint256 _tokenId) public view returns (address addr);
12     function takeOwnership(uint256 _tokenId) public;
13     function totalSupply() public view returns (uint256 total);
14     function transferFrom(address _from, address _to, uint256 _tokenId) public;
15     function transfer(address _to, uint256 _tokenId) public;
16 
17     event Transfer(address indexed from, address indexed to, uint256 tokenId);
18     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
19 }
20 
21 contract EtherDrugs is ERC721 {
22 
23   /*** EVENTS ***/
24   event Birth(uint256 tokenId, bytes32 name, address owner);
25   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, bytes32 name);
26   event Transfer(address from, address to, uint256 tokenId);
27 
28   /*** STRUCTS ***/
29   struct Drug {
30     bytes32 name;
31     address owner;
32     uint256 price;
33     uint256 last_price;
34     address approve_transfer_to;
35   }
36 
37   /*** CONSTANTS ***/
38   string public constant NAME = "EtherDrugs";
39   string public constant SYMBOL = "DRUG";
40   
41   bool public gameOpen = false;
42 
43   /*** STORAGE ***/
44   mapping (address => uint256) private ownerCount;
45   mapping (uint256 => address) public lastBuyer;
46 
47   address public ceoAddress;
48   mapping (uint256 => address) public extra;
49   
50   uint256 drug_count;
51  
52   mapping (uint256 => Drug) private drugs;
53 
54   /*** ACCESS MODIFIERS ***/
55   modifier onlyCEO() { require(msg.sender == ceoAddress); _; }
56 
57   /*** ACCESS MODIFIES ***/
58   function setCEO(address _newCEO) public onlyCEO {
59     require(_newCEO != address(0));
60     ceoAddress = _newCEO;
61   }
62 
63   function setLast(uint256 _id, address _newExtra) public onlyCEO {
64     require(_newExtra != address(0));
65     lastBuyer[_id] = _newExtra;
66   }
67 
68   /*** DEFAULT METHODS ***/
69   function symbol() public pure returns (string) { return SYMBOL; }
70   function name() public pure returns (string) { return NAME; }
71   function implementsERC721() public pure returns (bool) { return true; }
72 
73   /*** CONSTRUCTOR ***/
74   function EtherDrugs() public {
75     ceoAddress = msg.sender;
76     lastBuyer[1] = msg.sender;
77     lastBuyer[2] = msg.sender;
78     lastBuyer[3] = msg.sender;
79     lastBuyer[4] = msg.sender;
80     lastBuyer[5] = msg.sender;
81     lastBuyer[6] = msg.sender;
82     lastBuyer[7] = msg.sender;
83     lastBuyer[8] = msg.sender;
84     lastBuyer[9] = msg.sender;
85   }
86 
87   /*** INTERFACE METHODS ***/
88 
89   function createDrug(bytes32 _name, uint256 _price) public onlyCEO {
90     require(msg.sender != address(0));
91     _create_drug(_name, address(this), _price, 0);
92   }
93 
94   function createPromoDrug(bytes32 _name, address _owner, uint256 _price, uint256 _last_price) public onlyCEO {
95     require(msg.sender != address(0));
96     require(_owner != address(0));
97     _create_drug(_name, _owner, _price, _last_price);
98   }
99 
100   function openGame() public onlyCEO {
101     require(msg.sender != address(0));
102     gameOpen = true;
103   }
104 
105   function totalSupply() public view returns (uint256 total) {
106     return drug_count;
107   }
108 
109   function balanceOf(address _owner) public view returns (uint256 balance) {
110     return ownerCount[_owner];
111   }
112   function priceOf(uint256 _drug_id) public view returns (uint256 price) {
113     return drugs[_drug_id].price;
114   }
115 
116   function getDrug(uint256 _drug_id) public view returns (
117     uint256 id,
118     bytes32 drug_name,
119     address owner,
120     uint256 price,
121     uint256 last_price
122   ) {
123     id = _drug_id;
124     drug_name = drugs[_drug_id].name;
125     owner = drugs[_drug_id].owner;
126     price = drugs[_drug_id].price;
127     last_price = drugs[_drug_id].last_price;
128   }
129   
130   function getDrugs() public view returns (uint256[], bytes32[], address[], uint256[]) {
131     uint256[] memory ids = new uint256[](drug_count);
132     bytes32[] memory names = new bytes32[](drug_count);
133     address[] memory owners = new address[](drug_count);
134     uint256[] memory prices = new uint256[](drug_count);
135     for(uint256 _id = 0; _id < drug_count; _id++){
136       ids[_id] = _id;
137       names[_id] = drugs[_id].name;
138       owners[_id] = drugs[_id].owner;
139       prices[_id] = drugs[_id].price;
140     }
141     return (ids, names, owners, prices);
142   }
143   
144   function purchase(uint256 _drug_id) public payable {
145     require(gameOpen == true);
146     Drug storage drug = drugs[_drug_id];
147 
148     require(drug.owner != msg.sender);
149     require(msg.sender != address(0));  
150     require(msg.value >= drug.price);
151 
152     uint256 excess = SafeMath.sub(msg.value, drug.price);
153     uint256 half_diff = SafeMath.div(SafeMath.sub(drug.price, drug.last_price), 2);
154     uint256 reward = SafeMath.add(half_diff, drug.last_price);
155   
156     lastBuyer[1].send(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 69))); //69% goes to last buyer
157     lastBuyer[6].send(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 2)));  //2% goes to 6th last buyer, else ceo
158     lastBuyer[9].send(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 2)));  //2% goes to 9th last buyer, else ceo
159 
160     if(drug.owner == address(this)){
161       ceoAddress.send(reward);
162     } else {
163       drug.owner.send(reward);
164     }
165     
166     
167     drug.last_price = drug.price;
168     address _old_owner = drug.owner;
169     
170     if(drug.price < 1690000000000000000){ // 1.69 eth
171         drug.price = SafeMath.mul(SafeMath.div(drug.price, 100), 169); // 1.69x
172     } else {
173         drug.price = SafeMath.mul(SafeMath.div(drug.price, 100), 125); // 1.2x
174     }
175     drug.owner = msg.sender;
176 
177     lastBuyer[9] = lastBuyer[8];
178     lastBuyer[8] = lastBuyer[7];
179     lastBuyer[7] = lastBuyer[6];
180     lastBuyer[6] = lastBuyer[5];
181     lastBuyer[5] = lastBuyer[4];
182     lastBuyer[4] = lastBuyer[3];
183     lastBuyer[3] = lastBuyer[2];
184     lastBuyer[2] = lastBuyer[1];
185     lastBuyer[1] = msg.sender;
186 
187     Transfer(_old_owner, drug.owner, _drug_id);
188     TokenSold(_drug_id, drug.last_price, drug.price, _old_owner, drug.owner, drug.name);
189 
190     msg.sender.send(excess);
191   }
192 
193   function payout() public onlyCEO {
194     ceoAddress.send(this.balance);
195   }
196 
197   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
198     uint256 tokenCount = balanceOf(_owner);
199     if (tokenCount == 0) {
200       return new uint256[](0);
201     } else {
202       uint256[] memory result = new uint256[](tokenCount);
203       uint256 resultIndex = 0;
204       for (uint256 drugId = 0; drugId <= totalSupply(); drugId++) {
205         if (drugs[drugId].owner == _owner) {
206           result[resultIndex] = drugId;
207           resultIndex++;
208         }
209       }
210       return result;
211     }
212   }
213 
214   /*** ERC-721 compliance. ***/
215 
216   function approve(address _to, uint256 _drug_id) public {
217     require(msg.sender == drugs[_drug_id].owner);
218     drugs[_drug_id].approve_transfer_to = _to;
219     Approval(msg.sender, _to, _drug_id);
220   }
221   function ownerOf(uint256 _drug_id) public view returns (address owner){
222     owner = drugs[_drug_id].owner;
223     require(owner != address(0));
224   }
225   function takeOwnership(uint256 _drug_id) public {
226     address oldOwner = drugs[_drug_id].owner;
227     require(msg.sender != address(0));
228     require(drugs[_drug_id].approve_transfer_to == msg.sender);
229     _transfer(oldOwner, msg.sender, _drug_id);
230   }
231   function transfer(address _to, uint256 _drug_id) public {
232     require(msg.sender != address(0));
233     require(msg.sender == drugs[_drug_id].owner);
234     _transfer(msg.sender, _to, _drug_id);
235   }
236   function transferFrom(address _from, address _to, uint256 _drug_id) public {
237     require(_from == drugs[_drug_id].owner);
238     require(drugs[_drug_id].approve_transfer_to == _to);
239     require(_to != address(0));
240     _transfer(_from, _to, _drug_id);
241   }
242 
243   /*** PRIVATE METHODS ***/
244 
245   function _create_drug(bytes32 _name, address _owner, uint256 _price, uint256 _last_price) private {
246     // Params: name, owner, price, is_for_sale, is_public, share_price, increase, fee, share_count,
247     drugs[drug_count] = Drug({
248       name: _name,
249       owner: _owner,
250       price: _price,
251       last_price: _last_price,
252       approve_transfer_to: address(0)
253     });
254     
255     Drug storage drug = drugs[drug_count];
256     
257     Birth(drug_count, _name, _owner);
258     Transfer(address(this), _owner, drug_count);
259     drug_count++;
260   }
261 
262   function _transfer(address _from, address _to, uint256 _drug_id) private {
263     drugs[_drug_id].owner = _to;
264     drugs[_drug_id].approve_transfer_to = address(0);
265     ownerCount[_from] -= 1;
266     ownerCount[_to] += 1;
267     Transfer(_from, _to, _drug_id);
268   }
269 }
270 
271 library SafeMath {
272   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
273     if (a == 0) {
274       return 0;
275     }
276     uint256 c = a * b;
277     assert(c / a == b);
278     return c;
279   }
280   function div(uint256 a, uint256 b) internal pure returns (uint256) {
281     uint256 c = a / b;
282     return c;
283   }
284   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
285     assert(b <= a);
286     return a - b;
287   }
288   function add(uint256 a, uint256 b) internal pure returns (uint256) {
289     uint256 c = a + b;
290     assert(c >= a);
291     return c;
292   }
293 }