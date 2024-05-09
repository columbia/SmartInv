1 pragma solidity ^0.4.19;
2 
3 
4 contract Ownable {
5     
6     address public owner;
7 
8     /**
9      * The address whcih deploys this contrcat is automatically assgined ownership.
10      * */
11     function Ownable() public {
12         owner = msg.sender;
13     }
14 
15     /**
16      * Functions with this modifier can only be executed by the owner of the contract. 
17      * */
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     event OwnershipTransferred(address indexed from, address indexed to);
24 
25     /**
26     * Transfers ownership to new Ethereum address. This function can only be called by the 
27     * owner.
28     * @param _newOwner the address to be granted ownership.
29     **/
30     function transferOwnership(address _newOwner) public onlyOwner {
31         require(_newOwner != 0x0);
32         OwnershipTransferred(owner, _newOwner);
33         owner = _newOwner;
34     }
35 }
36 
37 
38 
39 library SafeMath {
40 
41   /**
42   * @dev Multiplies two numbers, throws on overflow.
43   */
44   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
45     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
46     // benefit is lost if 'b' is also tested.
47     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48     if (_a == 0) {
49       return 0;
50     }
51 
52     c = _a * _b;
53     assert(c / _a == _b);
54     return c;
55   }
56 
57   /**
58   * @dev Integer division of two numbers, truncating the quotient.
59   */
60   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
61     // assert(_b > 0); // Solidity automatically throws when dividing by 0
62     // uint256 c = _a / _b;
63     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
64     return _a / _b;
65   }
66 
67   /**
68   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
69   */
70   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
71     assert(_b <= _a);
72     return _a - _b;
73   }
74 
75   /**
76   * @dev Adds two numbers, throws on overflow.
77   */
78   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
79     c = _a + _b;
80     assert(c >= _a);
81     return c;
82   }
83 }
84 
85 
86 
87 contract TokenInterface {
88     function transfer(address to, uint256 value) public returns (bool);
89 }
90 
91 
92 
93 contract ICO is Ownable {
94     
95     using SafeMath for uint256;
96     
97     uint256 public rate;
98     uint256 public bonus; 
99     
100     TokenInterface public constant MEC = TokenInterface(0x064037ed6359c5d49a4ab6353345f46b687bbdd1);
101     
102     function ICO() public {
103         rate = 2e7;
104         bonus = 50;
105     }
106     
107     function changeRate(uint256 _newRate) public onlyOwner {
108         require(_newRate > 0 && rate != _newRate);
109         rate = _newRate;
110     }
111     
112     function changeBonus(uint256 _newBonus) public onlyOwner {
113         require(_newBonus > 0 &&  bonus != _newBonus);
114         bonus = _newBonus;
115     }
116     
117     event TokenPurchase(address indexed investor, uint256 tokensPurchased);
118     
119     function buyTokens(address _investor) public payable {
120         uint256 exchangeRate = rate;
121         if(msg.value >= 1e17) {
122             exchangeRate = rate.mul(bonus).div(100).add(rate);
123         }
124         MEC.transfer(_investor, msg.value.mul(exchangeRate));
125         TokenPurchase(_investor, msg.value.mul(exchangeRate));
126         owner.transfer(msg.value);
127     }
128     
129     function() public payable {
130         buyTokens(msg.sender);
131     }
132     
133     event TokensWithdrawn(uint256 totalMEC);
134     
135     function withdrawMEC(uint256 _value) public onlyOwner {
136         MEC.transfer(owner, _value);
137         TokensWithdrawn(_value);
138     }
139 }