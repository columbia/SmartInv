1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4 
5   address public owner;
6 
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11   function transferOwnership(address newOwner) onlyOwner public {
12     require(newOwner != address(0));
13     owner = newOwner;
14   }
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21 }
22 
23 contract ColorsData is Ownable {
24 
25     struct Color {
26 	    string label;
27 		uint64 creationTime;
28     }
29 
30 	event Transfer(address from, address to, uint256 colorId);
31     event Sold(uint256 colorId, uint256 priceWei, address winner);
32 	
33     Color[] colors;
34 
35     mapping (uint256 => address) public ColorIdToOwner;
36     mapping (uint256 => uint256) public ColorIdToLastPaid;
37     
38 }
39 
40 contract ColorsApis is ColorsData {
41 
42     function getColor(uint256 _id) external view returns (string label, uint256 lastPaid, uint256 price) {
43         Color storage color1 = colors[_id];
44 		label = color1.label;
45         lastPaid = ColorIdToLastPaid[_id];
46 		price = lastPaid + ((lastPaid * 2) / 10);
47     }
48 
49     function registerColor(string label, uint256 startingPrice) external onlyOwner {        
50         Color memory _Color = Color({
51 		    label: label,
52             creationTime: uint64(now)
53         });
54 
55         uint256 newColorId = colors.push(_Color) - 1;
56 		ColorIdToLastPaid[newColorId] = startingPrice;
57         _transfer(0, msg.sender, newColorId);
58     }
59     
60     function transfer(address _to, uint256 _ColorId) external {
61         require(_to != address(0));
62         require(_to != address(this));
63         require(ColorIdToOwner[_ColorId] == msg.sender);
64         _transfer(msg.sender, _to, _ColorId);
65     }
66 
67     function ownerOf(uint256 _ColorId) external view returns (address owner) {
68         owner = ColorIdToOwner[_ColorId];
69         require(owner != address(0));
70     }
71         
72     function bid(uint256 _ColorId) external payable {
73         uint256 lastPaid = ColorIdToLastPaid[_ColorId];
74         require(lastPaid > 0);
75 		
76 		uint256 price = lastPaid + ((lastPaid * 2) / 10);
77         require(msg.value >= price);
78 		
79 		address colorOwner = ColorIdToOwner[_ColorId];
80 		uint256 colorOwnerPayout = lastPaid + (lastPaid / 10);
81         colorOwner.transfer(colorOwnerPayout);
82 		
83 		// Transfer whatever is left to owner
84         owner.transfer(msg.value - colorOwnerPayout);
85 		
86 		ColorIdToLastPaid[_ColorId] = msg.value;
87 		ColorIdToOwner[_ColorId] = msg.sender;
88 
89 		// Trigger sold event
90         Sold(_ColorId, msg.value, msg.sender); 
91     }
92 
93     function _transfer(address _from, address _to, uint256 _ColorId) internal {
94         ColorIdToOwner[_ColorId] = _to;        
95         Transfer(_from, _to, _ColorId);
96     }
97 }
98 
99 contract ColorsMain is ColorsApis {
100 
101     function ColorsMain() public payable {
102         owner = msg.sender;
103     }
104     
105     function createStartingColors() external onlyOwner {
106         require(colors.length == 0);
107         this.registerColor("Red", 1);
108     }
109     
110     function() external payable {
111         require(msg.sender == address(0));
112     }
113     
114 }
115 
116 contract PixelsData is Ownable {
117 
118     struct Pixel {
119         address currentOwner;
120         uint256 lastPricePaid;
121 		uint64 lastUpdatedTime;
122     }
123 
124     event Sold(uint256 x, uint256 y, uint256 colorId, uint256 priceWei, address winner);
125 	
126     mapping (uint256 => Pixel) public PixelKeyToPixel;
127     
128     ColorsMain colorsMain;
129     
130     uint256 startingPriceWei = 1000000000000000;
131 }
132 
133 contract PixelsApi is PixelsData {
134     
135     function bidBatch(uint256[] inputs, address optionlReferrer) external payable {
136         require(inputs.length > 0);
137         require(inputs.length % 3 == 0);        
138         
139         uint256 rollingPriceRequired = 0;
140         
141         for(uint256 i = 0; i < inputs.length; i+=3)
142         {
143             uint256 x = inputs[i];
144             uint256 y = inputs[i+1];
145         
146             uint256 lastPaid = startingPriceWei;
147             uint256 pixelKey =  x + (y * 10000000);
148             Pixel storage pixel = PixelKeyToPixel[pixelKey];
149             
150             if(pixel.lastUpdatedTime != 0) {
151                 lastPaid = pixel.lastPricePaid;
152             }
153     		
154     		rollingPriceRequired += lastPaid + ((lastPaid * 2) / 10);
155         }
156         
157         require(msg.value >= rollingPriceRequired);
158         
159         for(uint256 z = 0; z < inputs.length; z+=3)
160         {
161             uint256 x1 = inputs[z];
162             uint256 y1 = inputs[z+1];
163             uint256 colorId = inputs[z+2];
164             bid(x1, y1, colorId, optionlReferrer);
165         }
166     }
167     
168     function bid(uint256 x, uint256 y, uint256 colorId, address optionlReferrer) internal {
169         uint256 lastPaid = startingPriceWei;
170         address currentOwner = owner;
171         uint256 pixelKey =  x + (y * 10000000);
172         
173         Pixel storage pixel = PixelKeyToPixel[pixelKey];
174         
175         if(pixel.lastUpdatedTime != 0) {
176             lastPaid = pixel.lastPricePaid;
177             currentOwner = pixel.currentOwner;
178         }
179 		
180 		uint256 price = lastPaid + ((lastPaid * 2) / 10);
181         require(msg.value >= price);
182         
183         address colorOwner;
184         
185         if(colorId == 99999) { //white
186             colorOwner = owner;
187         } else {
188             colorOwner = colorsMain.ownerOf(colorId);
189         }
190         
191 		require(colorOwner != 0);
192 		
193 		uint256 currentOwnerPayout = lastPaid + (lastPaid / 10);
194         currentOwner.transfer(currentOwnerPayout);
195         
196 		uint256 remainingPayout = price - currentOwnerPayout;
197 		uint256 colorOwnersFee = remainingPayout / 2;
198         colorOwner.transfer(colorOwnersFee);
199         
200         uint256 referralFee = 0;
201         
202         if(optionlReferrer != 0) {
203             referralFee = colorOwnersFee / 2;
204             optionlReferrer.transfer(referralFee);
205         }
206         
207         owner.transfer(colorOwnersFee - referralFee);
208         
209         Pixel memory _Pixel = Pixel({
210             currentOwner: msg.sender,
211 		    lastPricePaid: price,
212             lastUpdatedTime: uint64(now)
213         });
214 
215         PixelKeyToPixel[pixelKey] = _Pixel;
216 
217         Sold(x, y, colorId, price, msg.sender); 
218     }
219     
220     function setColorContract(address colorContract) external onlyOwner {        
221         colorsMain = ColorsMain(colorContract);
222     }
223     
224 }
225 
226 contract PixelsMain is PixelsApi {
227  
228     function PixelsMain() public payable {
229         owner = msg.sender;
230     }
231 
232     function() external payable {
233         require(msg.sender == address(0));
234     }
235 
236 }