1 pragma solidity > 0.4.99 <0.6.0;
2 
3 interface IERC20Token {
4     function balanceOf(address owner) external returns (uint256);
5     function transfer(address to, uint256 amount) external returns (bool);
6     function burn(uint256 _value) external returns (bool);
7     function decimals() external returns (uint256);
8     function approve(address _spender, uint256 _value) external returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
10 }
11 
12 contract Ownable {
13   address payable public _owner;
14 
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20   /**
21   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22   * account.
23   */
24   constructor() internal {
25     _owner = tx.origin;
26     emit OwnershipTransferred(address(0), _owner);
27   }
28 
29   /**
30   * @return the address of the owner.
31   */
32   function owner() public view returns(address) {
33     return _owner;
34   }
35 
36   /**
37   * @dev Throws if called by any account other than the owner.
38   */
39   modifier onlyOwner() {
40     require(isOwner());
41     _;
42   }
43 
44   /**
45   * @return true if `msg.sender` is the owner of the contract.
46   */
47   function isOwner() public view returns(bool) {
48     return msg.sender == _owner;
49   }
50 
51   /**
52   * @dev Allows the current owner to relinquish control of the contract.
53   * @notice Renouncing to ownership will leave the contract without an owner.
54   * It will not be possible to call the functions with the `onlyOwner`
55   * modifier anymore.
56   */
57   function renounceOwnership() public onlyOwner {
58     emit OwnershipTransferred(_owner, address(0));
59     _owner = address(0);
60   }
61 
62   /**
63   * @dev Allows the current owner to transfer control of the contract to a newOwner.
64   * @param newOwner The address to transfer ownership to.
65   */
66   function transferOwnership(address payable newOwner) public onlyOwner {
67     _transferOwnership(newOwner);
68   }
69 
70   /**
71   * @dev Transfers control of the contract to a newOwner.
72   * @param newOwner The address to transfer ownership to.
73   */
74   function _transferOwnership(address payable newOwner) internal {
75     require(newOwner != address(0));
76     emit OwnershipTransferred(_owner, newOwner);
77     _owner = newOwner;
78   }
79 }
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, throws on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91     if (a == 0) {
92       return 0;
93     }
94     uint256 c = a * b;
95     assert(c / a == b);
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers, truncating the quotient.
101   */
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return c;
107   }
108 
109   /**
110   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111   */
112   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   /**
118   * @dev Adds two numbers, throws on overflow.
119   */
120   function add(uint256 a, uint256 b) internal pure returns (uint256) {
121     uint256 c = a + b;
122     assert(c >= a);
123     return c;
124   }
125 }
126 
127 contract TokenSale is Ownable {
128     
129     using SafeMath for uint256;
130     
131     string public constant createdBy = "AssetSplit.org - the guys who cut the pizza";
132     
133     IERC20Token public tokenContract;
134     uint256 public tokenPerEther;
135 
136     uint256 public tokensSold;
137     
138     uint256 public earlyBirdsPaid = 0;
139     uint256 public earlyBirdBonus = 5;
140     uint256 public earlyBirdValue = 900;
141     
142     uint256 public bonusStage1;
143     uint256 public bonusStage2;
144     uint256 public bonusStage3;
145     
146     uint256 public bonusPercentage1;
147     uint256 public bonusPercentage2;
148     uint256 public bonusPercentage3;
149 
150     event Sold(address buyer, uint256 amount);
151 
152     constructor(address _tokenContract, uint256 _tokenPerEther, uint256 _bonusStage1, uint256 _bonusPercentage1, uint256 _bonusStage2, uint256 _bonusPercentage2, uint256 _bonusStage3, uint256 _bonusPercentage3) public {
153         tokenContract = IERC20Token(_tokenContract);
154         tokenPerEther = _tokenPerEther;
155         
156         bonusStage1 = _bonusStage1.mul(1 ether);
157         bonusStage2 = _bonusStage2.mul(1 ether);
158         bonusStage3 = _bonusStage3.mul(1 ether);
159         bonusPercentage1 = _bonusPercentage1;
160         bonusPercentage2 = _bonusPercentage2;
161         bonusPercentage3 = _bonusPercentage3;
162     }
163     
164     function buyTokenWithEther() public payable {
165         address payable creator = _owner;
166         uint256 scaledAmount;
167         
168         require(msg.value > 0);
169         
170         if (msg.value < bonusStage1 || bonusStage1 == 0) {
171         scaledAmount = msg.value.mul(tokenPerEther).mul(uint256(10) ** tokenContract.decimals()).div(10 ** 18);
172         }
173         if (bonusStage1 != 0 && msg.value >= bonusStage1) {
174             scaledAmount = msg.value.mul(tokenPerEther).mul(uint256(10) ** tokenContract.decimals()).div(10 ** 18).mul(bonusPercentage1).div(100);
175         }
176         if (bonusStage2 != 0 && msg.value >= bonusStage2) {
177             scaledAmount = msg.value.mul(tokenPerEther).mul(uint256(10) ** tokenContract.decimals()).div(10 ** 18).mul(bonusPercentage2).div(100);
178         }
179         if (bonusStage3 != 0 && msg.value >= bonusStage3) {
180             scaledAmount = msg.value.mul(tokenPerEther).mul(uint256(10) ** tokenContract.decimals()).div(10 ** 18).mul(bonusPercentage3).div(100);
181             if (earlyBirdsPaid < earlyBirdBonus) {
182                 earlyBirdsPaid = earlyBirdsPaid.add(1);
183                 scaledAmount = scaledAmount.add((earlyBirdValue).mul(uint256(10) ** tokenContract.decimals()));
184             }
185         }
186         
187         require(tokenContract.balanceOf(address(this)) >= scaledAmount);
188         emit Sold(msg.sender, scaledAmount);
189         tokensSold = tokensSold.add(scaledAmount);
190         creator.transfer(address(this).balance);
191         require(tokenContract.transfer(msg.sender, scaledAmount));
192     }
193     
194     function () external payable {
195         buyTokenWithEther();
196     }
197 }