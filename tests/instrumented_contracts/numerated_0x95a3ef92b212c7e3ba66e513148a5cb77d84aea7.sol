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
90     address public wallet = 0x3398BdC73b3e245187aAe7b231e453c0089AA04e;
91     XRRtoken public token = XRRtoken(0x0e75235647330B5e13cAD9115254C4B8E16272F8);
92     address public frozenVaults = 0xc684Bf3b56Ca914b7B0670845092420A661963F7;
93 
94     uint256 public totalRaiseWei = 0;
95     uint256 public totalTokenRaiseWei = 0;
96 
97     // Pre-Sale Launch March 20 - April 5th
98     uint PreSaleStart = 1521504000;
99 
100     uint PreSaleEnd = 1522886400;
101 
102 
103     //  Crowd sale Launch 12th - May 9th
104     uint ICO1 = 1523491200;
105     uint ICO2 = 1524096000;
106     uint ICO3 = 1524700800;
107     uint ICO4 = 1525305600;
108     uint ICOend = 1525910400;
109 
110     function XRRsale() public {
111 
112     }
113 
114     function currentPrice() public view returns (uint256){
115         if (now >= PreSaleStart && now < PreSaleEnd) return 26000;
116         else if (now >= ICO1 && now < ICO2) return 12000;
117         else if (now >= ICO2 && now < ICO3) return 11500;
118         else if (now >= ICO3 && now < ICO4) return 11000;
119         else if (now >= ICO4 && now < ICOend) return 10500;
120         else return 0;
121     }
122 
123 
124     function checkAmount(uint256 _amount) public view returns (bool){
125         if (now >= PreSaleStart && now < PreSaleEnd) return _amount >= 1 ether;
126         else if (now >= ICO1 && now < ICO2) return _amount >= 0.1 ether;
127         else if (now >= ICO2 && now < ICO3) return _amount >= 0.1 ether;
128         else if (now >= ICO3 && now < ICO4) return _amount >= 0.1 ether;
129         else if (now >= ICO4 && now < ICOend) return _amount >= 0.1 ether;
130         else return false;
131     }
132 
133 
134     function tokenTosale() public view returns (uint256){
135         return token.balanceOf(this);
136     }
137 
138     function tokenWithdraw() public onlyOwner {
139         require(tokenTosale() > 0);
140         token.transfer(owner, tokenTosale());
141     }
142 
143     function() public payable {
144         require(msg.value > 0);
145         require(checkAmount(msg.value));
146         require(currentPrice() > 0);
147 
148         totalRaiseWei = totalRaiseWei.add(msg.value);
149         uint256 tokens = currentPrice().mul(msg.value);
150         require(tokens <= tokenTosale());
151 
152         totalTokenRaiseWei = totalTokenRaiseWei.add(tokens);
153         token.transfer(msg.sender, tokens);
154         wallet.transfer(msg.value);
155     }
156 
157     function sendTokens(address _to, uint256 _value) public onlyOwner {
158         require(_value > 0);
159         require(_value <= tokenTosale());
160         require(currentPrice() > 0);
161         require(tokenTosale() >= _value);
162 
163         uint256 amount = _value.div(currentPrice());
164         totalRaiseWei = totalRaiseWei.add(amount);
165         totalTokenRaiseWei = totalTokenRaiseWei.add(_value);
166         token.transfer(_to, _value);
167     }
168 
169     function finishSale() public onlyOwner {
170         uint256 tokensToFrozen = 18000000 ether;
171         require(tokenTosale() >= tokensToFrozen);
172         // Frozen tokens for Bounty, Airdrop, Stakeholders
173         token.transfer(frozenVaults, tokensToFrozen);
174     }
175 }