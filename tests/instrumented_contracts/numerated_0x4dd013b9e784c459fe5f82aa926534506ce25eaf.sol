1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: contracts/MNYTiers.sol
117 
118 contract MNYTiers is Ownable {
119   using SafeMath for uint256;
120 
121   uint public offset = 10**8;
122   struct Tier {
123     uint mny;
124     uint futrx;
125     uint rate;
126   }
127   mapping(uint16 => Tier) public tiers;
128 
129   constructor() public {
130   }
131 
132   function addTiers(uint16 _startingTier, uint[] _mny, uint[] _futrx) public {
133     require(msg.sender == dev || msg.sender == admin || msg.sender == owner);
134     require(_mny.length == _futrx.length);
135     for (uint16 i = 0; i < _mny.length; i++) {
136       tiers[_startingTier + i] = Tier(_mny[i], _futrx[i], uint(_mny[i]).div(uint(_futrx[i]).div(offset)));
137     }
138   }
139 
140   function getTier(uint16 tier) public view returns (uint mny, uint futrx, uint rate) {
141     Tier t = tiers[tier];
142     return (t.mny, t.futrx, t.rate);
143   }
144 
145   address public dev = 0xab78275600E01Da6Ab7b5a4db7917d987FdB1b6d;
146   function changeDev (address _receiver) public {
147     require(msg.sender == dev);
148     dev = _receiver;
149   }
150 
151   address public admin = 0xab78275600E01Da6Ab7b5a4db7917d987FdB1b6d;
152   function changeAdmin (address _receiver) public {
153     require(msg.sender == admin);
154     admin = _receiver;
155   }
156 
157   function loadData() public {
158     require(msg.sender == dev || msg.sender == admin || msg.sender == owner);
159     tiers[1] = Tier(6.597 ether, 0.0369 ether, uint(6.597 ether).div(uint(0.0369 ether).div(offset)));
160     tiers[2] = Tier(9.5117 ether, 0.0531 ether, uint(9.5117 ether).div(uint(0.0531 ether).div(offset)));
161     tiers[3] = Tier(5.8799 ether, 0.0292 ether, uint(5.8799 ether).div(uint(0.0292 ether).div(offset)));
162     tiers[4] = Tier(7.7979 ether, 0.0338 ether, uint(7.7979 ether).div(uint(0.0338 ether).div(offset)));
163     tiers[5] = Tier(7.6839 ether, 0.0385 ether, uint(7.6839 ether).div(uint(0.0385 ether).div(offset)));
164     tiers[6] = Tier(6.9612 ether, 0.0215 ether, uint(6.9612 ether).div(uint(0.0215 ether).div(offset)));
165     tiers[7] = Tier(7.1697 ether, 0.0269 ether, uint(7.1697 ether).div(uint(0.0269 ether).div(offset)));
166     tiers[8] = Tier(6.2356 ether, 0.0192 ether, uint(6.2356 ether).div(uint(0.0192 ether).div(offset)));
167     tiers[9] = Tier(5.6619 ether, 0.0177 ether, uint(5.6619 ether).div(uint(0.0177 ether).div(offset)));
168     tiers[10] = Tier(6.1805 ether, 0.0231 ether, uint(6.1805 ether).div(uint(0.0231 ether).div(offset)));
169     tiers[11] = Tier(6.915 ether, 0.0262 ether, uint(6.915 ether).div(uint(0.0262 ether).div(offset)));
170     tiers[12] = Tier(8.7151 ether, 0.0323 ether, uint(8.7151 ether).div(uint(0.0323 ether).div(offset)));
171     tiers[13] = Tier(23.8751 ether, 0.1038 ether, uint(23.8751 ether).div(uint(0.1038 ether).div(offset)));
172     tiers[14] = Tier(7.0588 ether, 0.0262 ether, uint(7.0588 ether).div(uint(0.0262 ether).div(offset)));
173     tiers[15] = Tier(13.441 ether, 0.0585 ether, uint(13.441 ether).div(uint(0.0585 ether).div(offset)));
174     tiers[16] = Tier(6.7596 ether, 0.0254 ether, uint(6.7596 ether).div(uint(0.0254 ether).div(offset)));
175     tiers[17] = Tier(9.3726 ether, 0.0346 ether, uint(9.3726 ether).div(uint(0.0346 ether).div(offset)));
176     tiers[18] = Tier(7.1789 ether, 0.0269 ether, uint(7.1789 ether).div(uint(0.0269 ether).div(offset)));
177     tiers[19] = Tier(5.8699 ether, 0.0215 ether, uint(5.8699 ether).div(uint(0.0215 ether).div(offset)));
178     tiers[20] = Tier(8.3413 ether, 0.0308 ether, uint(8.3413 ether).div(uint(0.0308 ether).div(offset)));
179     tiers[21] = Tier(6.8338 ether, 0.0254 ether, uint(6.8338 ether).div(uint(0.0254 ether).div(offset)));
180     tiers[22] = Tier(6.1386 ether, 0.0231 ether, uint(6.1386 ether).div(uint(0.0231 ether).div(offset)));
181     tiers[23] = Tier(6.7469 ether, 0.0254 ether, uint(6.7469 ether).div(uint(0.0254 ether).div(offset)));
182     tiers[24] = Tier(9.9626 ether, 0.0431 ether, uint(9.9626 ether).div(uint(0.0431 ether).div(offset)));
183     tiers[25] = Tier(18.046 ether, 0.0785 ether, uint(18.046 ether).div(uint(0.0785 ether).div(offset)));
184     tiers[26] = Tier(10.2918 ether, 0.0446 ether, uint(10.2918 ether).div(uint(0.0446 ether).div(offset)));
185     tiers[27] = Tier(56.3078 ether, 0.2454 ether, uint(56.3078 ether).div(uint(0.2454 ether).div(offset)));
186     tiers[28] = Tier(17.2519 ether, 0.0646 ether, uint(17.2519 ether).div(uint(0.0646 ether).div(offset)));
187     tiers[29] = Tier(12.1003 ether, 0.0531 ether, uint(12.1003 ether).div(uint(0.0531 ether).div(offset)));
188     tiers[30] = Tier(14.4506 ether, 0.0631 ether, uint(14.4506 ether).div(uint(0.0631 ether).div(offset)));
189   }
190 }