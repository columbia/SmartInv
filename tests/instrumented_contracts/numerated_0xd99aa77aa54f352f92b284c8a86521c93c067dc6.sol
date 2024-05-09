1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4     
5     address public owner;
6 
7     /**
8      * The address whcih deploys this contrcat is automatically assgined ownership.
9      * */
10     function Ownable() public {
11         owner = msg.sender;
12     }
13 
14     /**
15      * Functions with this modifier can only be executed by the owner of the contract. 
16      * */
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     event OwnershipTransferred(address indexed from, address indexed to);
23 
24     /**
25     * Transfers ownership to new Ethereum address. This function can only be called by the 
26     * owner.
27     * @param _newOwner the address to be granted ownership.
28     **/
29     function transferOwnership(address _newOwner) public onlyOwner {
30         require(_newOwner != 0x0);
31         OwnershipTransferred(owner, _newOwner);
32         owner = _newOwner;
33     }
34 }
35 
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, throws on overflow.
46   */
47   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
49     // benefit is lost if 'b' is also tested.
50     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51     if (_a == 0) {
52       return 0;
53     }
54 
55     c = _a * _b;
56     assert(c / _a == _b);
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers, truncating the quotient.
62   */
63   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
64     // assert(_b > 0); // Solidity automatically throws when dividing by 0
65     // uint256 c = _a / _b;
66     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
67     return _a / _b;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
74     assert(_b <= _a);
75     return _a - _b;
76   }
77 
78   /**
79   * @dev Adds two numbers, throws on overflow.
80   */
81   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
82     c = _a + _b;
83     assert(c >= _a);
84     return c;
85   }
86 }
87 
88 
89 
90 contract TokenInterface {
91     function transfer(address to, uint256 value) public returns (bool);
92 }
93 
94 
95 contract ICO is Ownable {
96     
97     using SafeMath for uint256;
98     
99     string public website = "www.propvesta.com";
100     uint256 public rate;
101     uint256 public tokensSold;
102     address public fundsWallet = 0x304f970BaA307238A6a4F47caa9e0d82F082e3AD;
103     
104     TokenInterface public constant PROV = TokenInterface(0x409Ec1FCd524480b3CaDf4331aF21A2cB3Db68c9);
105     
106     function ICO() public {
107         rate = 20000000;
108     }
109     
110     function changeRate(uint256 _newRate) public onlyOwner {
111         require(_newRate > 0 && rate != _newRate);
112         rate = _newRate;
113     }
114     
115     function changeFundsWallet(address _fundsWallet) public onlyOwner returns(bool) {
116         fundsWallet = _fundsWallet;
117         return true;
118     }
119     
120     event TokenPurchase(address indexed investor, uint256 tokensPurchased);
121     
122     function buyTokens(address _investor) public payable {
123         require(msg.value >= 1e16);
124         uint256 exchangeRate = rate;
125         uint256 bonus = 0;
126         uint256 investment = msg.value;
127         uint256 remainder = 0;
128         if(investment >= 1e18 && investment < 2e18) {
129             bonus = 30;
130         } else if(investment >= 2e18 && investment < 3e18) {
131             bonus = 35;
132         } else if(investment >= 3e18 && investment < 4e18) {
133             bonus = 40;
134         } else if(investment >= 4e18 && investment < 5e18) {
135             bonus = 45;
136         } else if(investment >= 5e18) {
137             bonus = 50;
138         }
139         exchangeRate = rate.mul(bonus).div(100).add(rate);
140         uint256 toTransfer = 0;
141         if(investment > 10e18) {
142             uint256 bonusCap = 10e18;
143             toTransfer = bonusCap.mul(exchangeRate);
144             remainder = investment.sub(bonusCap);
145             toTransfer = toTransfer.add(remainder.mul(rate));
146         } else {
147             toTransfer = investment.mul(exchangeRate);
148         }
149         PROV.transfer(_investor, toTransfer);
150         TokenPurchase(_investor, toTransfer);
151         tokensSold = tokensSold.add(toTransfer);
152         fundsWallet.transfer(investment);
153     }
154     
155     function() public payable {
156         buyTokens(msg.sender);
157     }
158     
159     function getTokensSold() public view returns(uint256) {
160         return tokensSold;
161     }
162     
163     event TokensWithdrawn(uint256 totalPROV);
164     
165     function withdrawPROV(uint256 _value) public onlyOwner {
166         PROV.transfer(fundsWallet, _value);
167         TokensWithdrawn(_value);
168     }
169 }