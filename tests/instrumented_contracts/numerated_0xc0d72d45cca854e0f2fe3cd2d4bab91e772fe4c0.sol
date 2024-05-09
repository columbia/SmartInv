1 pragma solidity ^0.4.19;
2 
3 contract Pixereum {
4 
5 
6     struct Pixel {
7         address owner;
8         string message;
9         uint256 price;
10         bool isSale;
11     }
12 
13 
14 
15     /**************************************************************************
16     * public variables
17     ***************************************************************************/
18     uint24[10000] public colors;
19     bool public isMessageEnabled;
20 
21 
22 
23     /**************************************************************************
24     * private variables
25     ***************************************************************************/
26     mapping (uint16 => Pixel) private pixels;
27 
28 
29 
30     /**************************************************************************
31     * public constants
32     ***************************************************************************/
33     uint16 public constant numberOfPixels = 10000;
34     uint16 public constant width = 100;
35     uint256 public constant feeRate = 100;
36 
37 
38 
39     /**************************************************************************
40     * private constants
41     ***************************************************************************/
42     address private constant owner = 0xF1fA618D4661A8E20f665BE3BD46CAad828B5837;
43     address private constant fundWallet = 0x4F6896AF8C26D1a3C464a4A03705FB78fA2aDB86;
44     uint256 private constant defaultWeiPrice = 10000000000000000;   // 0.01 eth
45 
46 
47 
48     /**************************************************************************
49     * modifiers
50     ***************************************************************************/
51 
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     modifier onlyPixelOwner(uint16 pixelNumber) {
58         require(msg.sender == pixels[pixelNumber].owner);
59         _;
60     }
61 
62     modifier messageEnabled {
63         require(isMessageEnabled == true);
64         _;
65     }
66 
67 
68 
69     /**************************************************************************
70     * public methods
71     ***************************************************************************/
72 
73     // constructor
74     function Pixereum() public {
75         isMessageEnabled = true;
76     }
77 
78 
79 
80     /**************************************************************************
81     * public methods
82     ***************************************************************************/
83 
84     function getPixel(uint16 _pixelNumber)
85         constant
86         public
87         returns(address, string, uint256, bool) 
88     {
89         Pixel memory pixel;
90         if (pixels[_pixelNumber].owner == 0) {
91             pixel = Pixel(fundWallet, "", defaultWeiPrice, true); 
92         } else {
93             pixel = pixels[_pixelNumber];
94         }
95         return (pixel.owner, pixel.message, pixel.price, pixel.isSale);
96     }
97     
98     
99     function getColors() constant public returns(uint24[10000])  {
100         return colors;
101     }
102 
103 
104     // called when ether is sent to this contract
105     function ()
106         payable
107         public 
108     {
109         // check if data format is valid
110         // bytes[0]=x, bytes[1]=y, bytes[2-4]=color
111         require(msg.data.length == 5);
112 
113         uint16 pixelNumber = getPixelNumber(msg.data[0], msg.data[1]);
114         uint24 color = getColor(msg.data[2], msg.data[3], msg.data[4]);
115         buyPixel(msg.sender, pixelNumber, color, "");
116     }
117 
118 
119     function buyPixel(address beneficiary, uint16 _pixelNumber, uint24 _color, string _message)
120         payable
121         public 
122     {
123         require(_pixelNumber < numberOfPixels);
124         require(beneficiary != address(0));
125         require(msg.value != 0);
126         
127         // get current pixel info
128         address currentOwner;
129         uint256 currentPrice;
130         bool currentSaleState;
131         (currentOwner, , currentPrice, currentSaleState) = getPixel(_pixelNumber);
132         
133         // check if a pixel is for sale
134         require(currentSaleState == true);
135 
136         // check if a received Ether is higher than current price
137         require(currentPrice <= msg.value);
138 
139         // calculate fee
140         uint fee = msg.value / feeRate;
141 
142         // transfer received amount to current owner
143         currentOwner.transfer(msg.value - fee);
144 
145         // transfer fee to fundWallet
146         fundWallet.transfer(fee);
147 
148         // update pixel
149         pixels[_pixelNumber] = Pixel(beneficiary, _message, currentPrice, false);
150         
151         // update color
152         colors[_pixelNumber] = _color;
153     }
154 
155 
156     function setOwner(uint16 _pixelNumber, address _owner) 
157         public
158         onlyPixelOwner(_pixelNumber)
159     {
160         require(_owner != address(0));
161         pixels[_pixelNumber].owner = _owner;
162     }
163 
164 
165     function setColor(uint16 _pixelNumber, uint24 _color) 
166         public
167         onlyPixelOwner(_pixelNumber)
168     {
169         colors[_pixelNumber] = _color;
170     }
171 
172 
173     function setMessage(uint16 _pixelNumber, string _message)
174         public
175         messageEnabled
176         onlyPixelOwner(_pixelNumber)
177     {
178         pixels[_pixelNumber].message = _message;
179     }
180 
181 
182     function setPrice(uint16 _pixelNumber, uint256 _weiAmount) 
183         public
184         onlyPixelOwner(_pixelNumber)
185     {
186         pixels[_pixelNumber].price = _weiAmount;
187     }
188 
189 
190     function setSaleState(uint16 _pixelNumber, bool _isSale)
191         public
192         onlyPixelOwner(_pixelNumber)
193     {
194         pixels[_pixelNumber].isSale = _isSale;
195     }
196 
197 
198 
199     /**************************************************************************
200     * internal methods
201     ***************************************************************************/
202 
203     function getPixelNumber(byte _x, byte _y)
204         internal pure
205         returns(uint16) 
206     {
207         return uint16(_x) + uint16(_y) * width;
208     }
209 
210 
211     function getColor(byte _red, byte _green, byte _blue)
212         internal pure
213         returns(uint24) 
214     {
215         return uint24(_red)*65536 + uint24(_green)*256 + uint24(_blue);
216     }
217 
218 
219 
220     /**************************************************************************
221     * methods for contract owner
222     ***************************************************************************/
223 
224     // for emergency purpose
225     function deleteMessage(uint16 _pixelNumber)
226         onlyOwner
227         public
228     {
229         pixels[_pixelNumber].message = "";
230     }
231 
232 
233     // for emergency purpose
234     function setMessageStatus(bool _isMesssageEnabled)
235         onlyOwner
236         public
237     {
238         isMessageEnabled = _isMesssageEnabled;
239     }
240 
241 }