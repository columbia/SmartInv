1 pragma solidity 0.4.24;
2 
3 contract GFDGSHBoard {
4     
5     // x => y => color
6     mapping(uint256=>mapping(uint256=>uint256)) public canvas;
7     uint256 ownerBalance;
8     
9     uint256 pixelRate;
10     address owner;
11     constructor() public {
12         pixelRate = 100;
13         owner = msg.sender;
14         ownerBalance = 0;
15     }
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20     function setPixelRate(uint256 _pixelRate) onlyOwner public {
21         pixelRate = _pixelRate;
22     }
23     function pixelPrice(uint256 x, uint256 y) public view returns (uint256) {
24         // 500k x 500k canvas
25         require(x < 500000);
26         require(y < 500000);
27         uint256 pp = 0.0001 ether;
28         if(x>100 && y>100) {
29             pp = 0.00005 ether;
30         }
31         if(x>200 && y>200) {
32             pp = 0.000025 ether;
33         }
34         if(x>400 && y>400) {
35             pp = 0.0000125 ether;
36         }
37         if(x>800 && y>800) {
38             pp = 0.00000625 ether;
39         }
40         if(x>1600 && y>1600) {
41             pp = 0.000003125 ether;
42         }
43         if(x>3200 && y>3200) {
44             pp = 0.00000155 ether;
45         }
46         if(x>6400 && y>6400) {
47             pp = 0.0000007 ether;
48         }
49         if(x>12800 && y>12800) {
50             pp = 0.00000035 ether;
51         }
52         if(x>25600 && y>25600) {
53             pp = 0.000000125 ether;
54         }
55         if(x>51200 && y>51200) {
56             pp = 0.0000000625 ether;
57         }
58         if(x>100000 && y>100000) {
59             pp = 0.00000003125 ether;
60         }
61         if(x>200000 && y>200000) {
62             pp = 0.00000001 ether;
63         }
64         if(x>400000 && y>400000) {
65             pp = 0.000000001 ether;
66         }
67         return pp * pixelRate;
68     }
69     function priceForRect(uint256 left, uint256 right, uint256 top, uint256 bottom) public view returns (uint256) {
70         require(top < bottom);
71         require(right > left);
72         uint256 price = 0;
73         price += pixelPrice(left, top);
74         price += pixelPrice(right, top);
75         price += pixelPrice(left, bottom);
76         price += pixelPrice(right, bottom);
77         price /= 4;
78         uint256 pixelCount = (right - left) * (bottom - top);
79         return price * pixelCount;
80     }
81     function purchasePixel(uint256 x, uint256 y, uint256 color) public payable {
82         require(color < 16777216);
83         uint256 pp = pixelPrice(x, y);
84         require(msg.value >= pp);
85         canvas[x][y] = color;
86         ownerBalance += msg.value;
87     }
88     function applyPixelChange(uint256 left, uint256 right, uint256 top, uint256 bottom, uint256[] colors) internal {
89         uint256 colorIndex = 0;
90         for(uint256 x = left; x < right; x++) {
91             for (uint256 y = top; y < bottom; y++) {
92                 uint256 color = colors[colorIndex];
93                 require(color < 16777216);
94                 canvas[x][y] = color;
95                 colorIndex++;
96             }
97         }
98     }
99     function purchaseRect(uint256 left, uint256 right, uint256 top, uint256 bottom, uint256[] colors) payable public {
100         uint256 pp = priceForRect(left, right, top, bottom);
101         uint256 senderBal = balances[msg.sender];
102         require((msg.value == pp) || senderBal >= pp || senderBal + msg.value >= pp);
103         require(top < bottom);
104         require(right > left);
105         if(msg.value == pp) {
106             // Paid for in message
107             applyPixelChange(left, right, top, bottom, colors);
108         }
109         else if(msg.value != 0) {
110             // Paid partially in message
111             uint256 deductFromBal = pp - msg.value;
112             require(balances[msg.sender] >= deductFromBal);
113             balances[msg.sender] -= deductFromBal;
114             applyPixelChange(left, right, top, bottom, colors);
115         }
116         else if(msg.value == 0) {
117             // Paid fully from balance
118             require(balances[msg.sender] >= pp);
119             applyPixelChange(left, right, top, bottom, colors);
120         }
121         else {
122             revert();
123         }
124     }
125     mapping(address=>uint256) balances;
126     function deposit() payable public {
127         balances[msg.sender] += msg.value;
128     }
129     function() payable public {
130         balances[msg.sender] += msg.value;
131     }
132     function withdraw() public {
133         uint256 balance = balances[msg.sender];
134         require(balance >= 0);
135         msg.sender.transfer(balance);
136     }
137     function adminWithdraw() public onlyOwner {
138         msg.sender.transfer(ownerBalance);
139     }
140 }