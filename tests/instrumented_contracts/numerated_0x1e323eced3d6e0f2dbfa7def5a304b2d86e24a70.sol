1 pragma solidity ^0.4.18;
2 
3 
4 //>> Reference to https://github.com/OpenZeppelin/zeppelin-solidity
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 //<< Reference to https://github.com/OpenZeppelin/zeppelin-solidity
53 
54 
55 
56 
57 contract Coin {
58     function sell(address _to, uint256 _value, string _note) public returns (bool);
59 }
60 
61 
62 /**
63  * @title MultiOwnable
64  */
65 contract MultiOwnable {
66     address public root;
67     mapping (address => address) public owners; // owner => parent of owner
68     
69     /**
70     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71     * account.
72     */
73     function MultiOwnable() public {
74         root= msg.sender;
75         owners[root]= root;
76     }
77     
78     /**
79     * @dev Throws if called by any account other than the owner.
80     */
81     modifier onlyOwner() {
82         require(owners[msg.sender] != 0);
83         _;
84     }
85     
86     /**
87     * @dev Adding new owners
88     */
89     function newOwner(address _owner) onlyOwner public returns (bool) {
90         require(_owner != 0);
91         owners[_owner]= msg.sender;
92         return true;
93     }
94     
95     /**
96      * @dev Deleting owners
97      */
98     function deleteOwner(address _owner) onlyOwner public returns (bool) {
99         require(owners[_owner] == msg.sender || (owners[_owner] != 0 && msg.sender == root));
100         owners[_owner]= 0;
101         return true;
102     }
103 }
104 
105 
106 /**
107  * @title KStarCoinSale
108  * @author Tae Kim
109  * @notice This contract is for crowdfunding of KStarCoin.
110  */
111 contract KStarCoinSale is MultiOwnable {
112     using SafeMath for uint256;
113     
114     eICOLevel public level;
115     uint256 public rate;
116     uint256 public minWei;
117 
118     function checkValidLevel(eICOLevel _level) public pure returns (bool) {
119         return (_level == eICOLevel.C_ICO_PRESALE || _level == eICOLevel.C_ICO_ONSALE || _level == eICOLevel.C_ICO_END);
120     }
121 
122     modifier onSale() {
123         require(level != eICOLevel.C_ICO_END);
124         _;
125     }
126     
127     enum eICOLevel { C_ICO_PRESALE, C_ICO_ONSALE, C_ICO_END }
128     
129     Coin public coin;
130     address public wallet;
131 
132     // Constructure
133     function KStarCoinSale(Coin _coin, address _wallet) public {
134         require(_coin != address(0));
135         require(_wallet != address(0));
136         
137         coin= _coin;
138         wallet= _wallet;
139 
140         updateICOVars(  eICOLevel.C_ICO_PRESALE,
141                         3750,       // 3000 is default, +750 is pre-sale bonus
142                         1e5 szabo); // = 0.1 ether
143     }
144     
145     // Update variables related to crowdfunding
146     function updateICOVars(eICOLevel _level, uint _rate, uint _minWei) onlyOwner public returns (bool) {
147         require(checkValidLevel(_level));
148         require(_rate != 0);
149         require(_minWei >= 1 szabo);
150         
151         level= _level;
152         rate= _rate;
153         minWei= _minWei;
154         
155         ICOVarsChange(level, rate, minWei);
156         return true;
157     }
158     
159     function () external payable {
160         buyCoin(msg.sender);
161     }
162     
163     function buyCoin(address beneficiary) onSale public payable {
164         require(beneficiary != address(0));
165         require(msg.value >= minWei);
166 
167         // calculate token amount to be created
168         uint256 coins= getCoinAmount(msg.value);
169         
170         // update state 
171         coin.sell(beneficiary, coins, "");
172         
173         forwardFunds();
174     }
175 
176     function getCoinAmount(uint256 weiAmount) internal view returns(uint256) {
177         return weiAmount.mul(rate);
178     }
179   
180     // send ether to the fund collection wallet
181     function forwardFunds() internal {
182         wallet.transfer(msg.value);
183     }
184     
185     event ICOVarsChange(eICOLevel level, uint256 rate, uint256 minWei);
186 }