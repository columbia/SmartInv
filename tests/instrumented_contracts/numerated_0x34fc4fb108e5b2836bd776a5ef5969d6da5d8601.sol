1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4     address public owner;
5 
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10     /**
11      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12      * account.
13      */
14     function Ownable() public {
15         owner = msg.sender;
16     }
17 
18     /**
19      * @dev Throws if called by any account other than the owner.
20      */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     /**
27      * @dev Allows the current owner to transfer control of the contract to a newOwner.
28      * @param newOwner The address to transfer ownership to.
29      */
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(0));
32         OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 
36 }
37 
38 
39 library SafeMath {
40 
41     /**
42     * @dev Multiplies two numbers, throws on overflow.
43     */
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         assert(c / a == b);
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two numbers, truncating the quotient.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // assert(b > 0); // Solidity automatically throws when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60         return c;
61     }
62 
63     /**
64     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     /**
72     * @dev Adds two numbers, throws on overflow.
73     */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         assert(c >= a);
77         return c;
78     }
79 }
80 
81 contract ERC20Basic {
82     function totalSupply() public view returns (uint256);
83 
84     function balanceOf(address who) public view returns (uint256);
85 
86     function transfer(address to, uint256 value) public returns (bool);
87 
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 contract ERC20 is ERC20Basic {
92     function allowance(address owner, address spender) public view returns (uint256);
93 
94     function transferFrom(address from, address to, uint256 value) public returns (bool);
95 
96     function approve(address spender, uint256 value) public returns (bool);
97 
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 contract AsetToken is ERC20 {
102 
103 }
104 
105 contract AsetSale is Ownable {
106     using SafeMath for uint256;
107 
108     AsetToken public token;
109 
110     uint256 public price;
111 
112     address public wallet;
113 
114     uint256 public totalRice = 0;
115     uint256 public totalTokenRice = 0;
116 
117     function AsetSale() public {
118         // default price: 1 ETH = 1300 ASET
119         // ~$0.60
120         price = 1300;
121         // default: wallet = owner
122         wallet = msg.sender;
123     }
124 
125     function setToken(AsetToken _token) public onlyOwner {
126         token = _token;
127     }
128 
129     function tokensToSale() public view returns (uint256) {
130         return token.balanceOf(this);
131     }
132 
133     function setPrice(uint256 _price) public onlyOwner {
134         price = _price;
135     }
136 
137     function setWallet(address _wallet) public onlyOwner {
138         wallet = _wallet;
139     }
140 
141     function withdrawTokens() public onlyOwner {
142         require(address(token) != address(0));
143         require(tokensToSale() > 0);
144         token.transfer(wallet, tokensToSale());
145     }
146 
147 
148     function() public payable {
149         require(msg.value > 0);
150         require(address(token) != address(0));
151         require(tokensToSale() > 0);
152 
153         uint256 tokensWei = msg.value.mul(price);
154         tokensWei = withBonus(tokensWei);
155         token.transfer(msg.sender, tokensWei);
156         wallet.transfer(msg.value);
157         totalRice = totalRice.add(msg.value);
158         totalTokenRice = totalTokenRice.add(tokensWei);
159     }
160 
161     function sendToken(address _to, uint256 tokensWei)public onlyOwner{
162         require(address(token) != address(0));
163         require(tokensToSale() > 0);
164 
165         uint256 amountWei = tokensWei.div(price);
166         token.transfer(_to, tokensWei);
167         totalRice = totalRice.add(amountWei);
168         totalTokenRice = totalTokenRice.add(tokensWei);
169     }
170 
171     function withBonus(uint256 _amount) internal pure returns(uint256) {
172         if(_amount <= 500 ether) return _amount;
173         else if(_amount <= 1000 ether) return _amount.mul(105).div(100);
174         else if(_amount <= 2000 ether) return _amount.mul(107).div(100);
175         else if(_amount <= 5000 ether) return _amount.mul(110).div(100);
176         else if(_amount <= 10000 ether) return _amount.mul(115).div(100);
177         else return _amount.mul(120).div(100);
178     }
179 }