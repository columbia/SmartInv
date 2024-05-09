1 pragma solidity ^0.4.21;
2 
3 contract OneMillionToken{
4     
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         assert(c >= a);
8         return c;
9         }
10     
11     struct PixelToken{
12         uint256 price;
13         uint24 color;
14         address pixelOwner;
15     }
16     
17     struct pixelWallet{
18         mapping (uint24 => uint) indexList;
19         uint24[] pixelOwned;
20         uint24 pixelListlength;
21         string name; 
22         string link;
23     }
24     
25     address public owner;
26     
27     string public constant symbol = "1MT";
28     string public constant name = "OneMillionToken";
29     uint8 public constant decimals = 0;
30     
31     uint private startPrice = 1000000000000000;
32     
33     uint public constant maxPrice = 100000000000000000000;
34     uint public constant minPrice = 1000000000000;
35     
36     
37     mapping (uint24 => PixelToken) private Image;
38     
39     mapping (address => pixelWallet) balance;
40     
41     function getPixelToken(uint24 _id) public view returns(uint256,string,string,uint24,address){
42         return(Image[_id].pixelOwner == address(0) ? startPrice : Image[_id].price,balance[Image[_id].pixelOwner].name,balance[Image[_id].pixelOwner].link,Image[_id].color,Image[_id].pixelOwner);
43     }
44     
45     function buyPixelTokenFor(uint24 _id,uint256 _price,uint24 _color, address _to) public payable returns (bool) {
46         require(_id>=0&&_id<1000000);
47         
48         require(_price>=minPrice&&_price<=maxPrice);
49         require(msg.value>=minPrice&&msg.value<=maxPrice);
50         
51         if(Image[_id].pixelOwner== address(0)){
52             
53             require(msg.value>=startPrice);
54             
55             Transfer(owner, _to, _id);
56             
57             Image[_id].pixelOwner = _to;
58             balance[_to].pixelOwned.push(_id);
59             balance[_to].indexList[_id] = balance[_to].pixelOwned.length;
60             balance[_to].pixelListlength++;
61             
62             require(owner.send(msg.value));
63             
64             Image[_id].price = _price;
65             Image[_id].color = _color;
66             
67             ChangePixel(_id);
68             
69             return true;
70             
71         }else{
72             require(msg.value>=Image[_id].price);
73             
74             address prevOwner =Image[_id].pixelOwner; 
75             
76             balance[Image[_id].pixelOwner].indexList[_id] = 0;
77             balance[Image[_id].pixelOwner].pixelListlength--;
78             
79             
80             Transfer(Image[_id].pixelOwner, _to, _id);
81             
82             Image[_id].pixelOwner = _to;
83             balance[_to].pixelOwned.push(_id);
84             balance[_to].indexList[_id] = balance[_to].pixelOwned.length;
85             balance[_to].pixelListlength++;
86             
87             require(prevOwner.send(msg.value));
88             
89             Image[_id].price = _price;
90             Image[_id].color = _color;
91             
92             ChangePixel(_id);
93             
94             return true;
95         }
96     }
97     
98     function buyPixelToken(uint24 _id,uint256 _price,uint24 _color) public payable returns (bool){
99         return buyPixelTokenFor(_id, _price, _color, msg.sender);
100     }
101     
102     function setPixelToken(uint24 _id,uint256 _price,uint24 _color) public returns (bool){
103         require(_id>=0&&_id<1000000);
104         require(_price>=minPrice&&_price<=maxPrice);
105         
106         require(msg.sender==Image[_id].pixelOwner);
107         
108         Image[_id].price = _price;
109         Image[_id].color = _color;
110         
111         ChangePixel(_id);
112         
113         return true;
114     }
115     
116     function OneMillionToken() public {
117         owner = msg.sender;
118     }
119     
120     function setNameLink(string _name,string _link) public{
121         balance[msg.sender].name = _name;
122         balance[msg.sender].link = _link;
123     }
124     
125     function totalSupply() public pure returns (uint) {
126         return 1000000;    
127     }
128 
129     function balanceOf(address _tokenOwner) public constant returns (uint){
130         return balance[_tokenOwner].pixelListlength;
131     }
132     
133     function myBalance() public view returns (uint24[]){
134         uint24[] memory list = new uint24[](balance[msg.sender].pixelListlength);
135         
136         uint24 index = 0;
137         
138         for(uint24 i = 0; i < balance[msg.sender].pixelOwned.length;i++){
139             if(balance[msg.sender].indexList[balance[msg.sender].pixelOwned[i]]==i+1){
140                 list[index]=balance[msg.sender].pixelOwned[i];
141                 index++;
142             }
143         }
144         return list;
145     }
146 
147     function transfer(address _to, uint24 _id) public returns (bool success){
148         require(_id>=0&&_id<1000000);
149         require(Image[_id].pixelOwner == msg.sender);
150         
151         balance[Image[_id].pixelOwner].indexList[_id] = 0;
152         balance[Image[_id].pixelOwner].pixelListlength--;
153         
154         Transfer(Image[_id].pixelOwner, _to, _id);
155         
156         Image[_id].pixelOwner = _to;
157         
158         balance[_to].pixelOwned.push(_id);
159         balance[_to].indexList[_id] = balance[_to].pixelOwned.length;
160         balance[_to].pixelListlength++;
161         return true;
162     }
163     
164     function pixelblockPrice (uint24 _startx,uint24 _starty,uint24 _endx,uint24 _endy) public view returns (uint){
165         require(_startx>=0&&_startx<625);
166         require(_starty>=0&&_starty<1600);
167         require(_endx>=_startx&&_endx<625);
168         require(_endy>=_starty&&_endy<1600);
169         
170         uint256 price = 0;
171         for(uint24 x = _startx; x<= _endx;x++){
172             for(uint24 y = _starty;y<=_endy;y++ ){
173                 uint24 id = y*1600+x;
174                 if(Image[id].pixelOwner==address(0)){
175                     price=add(price,startPrice);
176                 }else{
177                     price=add(price,Image[id].price);
178                 }
179             }
180         }
181         return price;
182     }
183     
184     function setStartPrice(uint _price) public onlyOwner returns (bool){
185         
186         require(_price>=minPrice&&_price<=maxPrice);
187         startPrice = _price;
188         return true;
189     }
190     
191     function getStartPrice() public view returns (uint){
192         return startPrice;
193     }
194     
195     modifier onlyOwner{
196         require(msg.sender==owner);
197         _;
198     }
199     
200     event ChangePixel(uint tokens);
201 
202     event Transfer(address indexed from, address indexed to, uint tokens);
203 }