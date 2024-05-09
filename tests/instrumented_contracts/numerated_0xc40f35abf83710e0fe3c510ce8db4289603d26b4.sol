1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 
46 contract Ownable {
47     address public owner;
48 
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53     /**
54      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55      * account.
56      */
57     function Ownable() public {
58         owner = msg.sender;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     /**
70      * @dev Allows the current owner to transfer control of the contract to a newOwner.
71      * @param newOwner The address to transfer ownership to.
72      */
73     function transferOwnership(address newOwner) public onlyOwner {
74         require(newOwner != address(0));
75         emit OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77     }
78 
79 }
80 
81 contract XRRtoken {
82     function balanceOf(address _owner) public view returns (uint256 balance);
83 
84     function transfer(address _to, uint256 _value) public returns (bool);
85 }
86 
87 contract XRRsale is Ownable {
88     using SafeMath for uint256;
89 
90     XRRtoken public token;
91     address public wallet;
92 
93     uint256 public totalRaiseWei = 0;
94     uint256 public totalTokenRaiseWei = 0;
95 
96     // Only for TestNet
97     //    uint PreSaleStart = now;
98 
99     // Pre-Sale Launch March 20 - April 5th
100     uint PreSaleStart = 1521504000;
101 
102     uint PreSaleEnd = 1522886400;
103 
104 
105     //  Crowd sale Launch 12th - May 9th
106     uint ICO1 = 1523491200;
107     uint ICO2 = 1524096000;
108     uint ICO3 = 1524700800;
109     uint ICO4 = 1525305600;
110     uint ICOend = 1525910400;
111 
112     function XRRsale() public {
113         wallet = msg.sender;
114     }
115 
116     function setToken(XRRtoken _token) public {
117         token = _token;
118     }
119 
120     function setWallet(address _wallet) public {
121         wallet = _wallet;
122     }
123 
124 
125     function currentPrice() public view returns (uint256){
126         if (now > PreSaleStart && now < PreSaleEnd) return 26000;
127         else if (now > ICO1 && now < ICO2) return 12000;
128         else if (now > ICO2 && now < ICO3) return 11500;
129         else if (now > ICO3 && now < ICO4) return 11000;
130         else if (now > ICO4 && now < ICOend) return 10500;
131         else return 0;
132     }
133 
134 
135     function checkAmount(uint256 _amount) public view returns (bool){
136         if (now > PreSaleStart && now < PreSaleEnd) return _amount >= 1 ether;
137         else if (now > ICO1 && now < ICO2) return _amount >= 0.1 ether;
138         else if (now > ICO2 && now < ICO3) return _amount >= 0.1 ether;
139         else if (now > ICO3 && now < ICO4) return _amount >= 0.1 ether;
140         else if (now > ICO4 && now < ICOend) return _amount >= 0.1 ether;
141         else return false;
142     }
143 
144 
145     function tokenTosale() public view returns (uint256){
146         return token.balanceOf(this);
147     }
148 
149     function tokenWithdraw() public onlyOwner {
150         require(tokenTosale() > 0);
151         token.transfer(owner, tokenTosale());
152     }
153 
154     function() public payable {
155         require(msg.value > 0);
156         require(checkAmount(msg.value));
157         require(currentPrice() > 0);
158 
159         totalRaiseWei = totalRaiseWei.add(msg.value);
160         uint256 tokens = currentPrice().mul(msg.value);
161         require(tokens <= tokenTosale());
162 
163         totalTokenRaiseWei = totalTokenRaiseWei.add(tokens);
164         token.transfer(msg.sender, tokens);
165     }
166 
167     function sendTokens(address _to, uint256 _value) public onlyOwner {
168         require(_value > 0);
169         require(_value <= tokenTosale());
170         require(currentPrice() > 0);
171 
172         uint256 amount = _value.div(currentPrice());
173         totalRaiseWei = totalRaiseWei.add(amount);
174         totalTokenRaiseWei = totalTokenRaiseWei.add(_value);
175         token.transfer(_to, _value);
176     }
177 }