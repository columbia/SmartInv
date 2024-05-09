1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4     
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10  
11   function div(uint256 a, uint256 b) internal constant returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17  
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22  
23   function add(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28   
29 }
30 
31 contract Owned {
32     address public owner;
33     function Owned() {
34         owner = msg.sender;
35     }
36     modifier onlyOwner() {
37         assert(msg.sender == owner);
38         _;
39     }
40     function transferOwnership(address newOwner) external onlyOwner {
41         if (newOwner != address(0)) {
42             owner = newOwner;
43         }
44     }
45 }
46 
47 contract SmartConvas is Owned{
48     
49     using SafeMath for uint256;
50     
51     event paintEvent(address sender, uint x, uint y, uint r, uint g, uint b);
52     
53     struct Pixel {
54         address currentOwner;
55         uint r;
56         uint g;
57         uint b;
58         uint currentPrice;
59     }
60     
61     //переменная стоимости пикселя
62     uint defaultPrice = 1069120000000000; //1 $ по курсу 937p/eth  in wei
63     uint priceInOneEther = 1000000000000000000;
64     
65     Pixel [1000][1000] pixels;
66     
67     function getAddress(uint x, uint y) constant returns (address) {
68         Pixel memory p = pixels[x][y];
69         return p.currentOwner;
70     }
71     
72     function getColor(uint x, uint y) constant returns(uint[3])
73     {
74         return ([pixels[x][y].r, pixels[x][y].g, pixels[x][y].b]);
75     }
76     
77     function getCurrentPrice(uint x, uint y) constant returns (uint)
78     {
79         Pixel memory p = pixels[x][y];
80         return p.currentPrice;
81     }
82     
83     function addPixelPayable(uint x, uint y, uint r, uint g, uint b) payable  {
84 
85         Pixel memory px = pixels[x][y];
86         
87         if(msg.value<px.currentPrice)
88         {
89             revert();
90         }
91         
92 
93        
94         px.r = r;
95         px.g = g;
96         px.b = b;
97         
98         if(px.currentOwner>0)
99         {
100             px.currentOwner.transfer(msg.value.mul(75).div(100));
101         }
102         
103         px.currentOwner = msg.sender;
104         if(px.currentPrice ==0)
105         {
106             px.currentPrice = defaultPrice;
107         }
108         else
109         {
110             px.currentPrice = px.currentPrice.mul(2);
111         }
112         
113         pixels[x][y] = px;
114         
115         emit paintEvent(msg.sender,x,y,r,g,b);
116   
117     }
118     function GetBalance() constant returns (uint)
119     {
120         return address(this).balance;
121     }
122     function GetOwner() constant returns (address)
123     {
124         return owner;
125     }
126     
127     function withdraw() onlyOwner returns(bool) {
128         msg.sender.transfer(address(this).balance);
129         return true;
130     }
131 }