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
12 interface IAssetSplitContracts {
13  function addContract(address payable _contractAddress, address payable _creatorAddress, uint256 _contractType) external returns (bool success);
14 }
15 
16 interface IShareManager {
17     function getSharesByShareOwner(address _shareOwner) external view returns (uint[] memory);
18     function shares(uint _id) external view returns (address shareholder, uint256 sharePercentage);
19     function sharesToManager(uint _id) external view returns (address shareowner);
20 }
21 
22 interface IPayeeShare {
23     function owner() external view returns (address payable shareowner);
24     function payeePartsToSell() external view returns (uint256);
25     function payeePricePerPart() external view returns (uint256);
26 }
27 
28 contract Ownable {
29   address payable public _owner;
30 
31   event OwnershipTransferred(
32     address indexed previousOwner,
33     address indexed newOwner
34   );
35 
36   /**
37   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38   * account.
39   */
40   constructor() internal {
41     _owner = tx.origin;
42     emit OwnershipTransferred(address(0), _owner);
43   }
44 
45   /**
46   * @return the address of the owner.
47   */
48   function owner() public view returns(address) {
49     return _owner;
50   }
51 
52   /**
53   * @dev Throws if called by any account other than the owner.
54   */
55   modifier onlyOwner() {
56     require(isOwner());
57     _;
58   }
59 
60   /**
61   * @return true if `msg.sender` is the owner of the contract.
62   */
63   function isOwner() public view returns(bool) {
64     return msg.sender == _owner;
65   }
66 
67   /**
68   * @dev Allows the current owner to relinquish control of the contract.
69   * @notice Renouncing to ownership will leave the contract without an owner.
70   * It will not be possible to call the functions with the `onlyOwner`
71   * modifier anymore.
72   */
73   function renounceOwnership() public onlyOwner {
74     emit OwnershipTransferred(_owner, address(0));
75     _owner = address(0);
76   }
77 
78   /**
79   * @dev Allows the current owner to transfer control of the contract to a newOwner.
80   * @param newOwner The address to transfer ownership to.
81   */
82   function transferOwnership(address payable newOwner) public onlyOwner {
83     _transferOwnership(newOwner);
84   }
85 
86   /**
87   * @dev Transfers control of the contract to a newOwner.
88   * @param newOwner The address to transfer ownership to.
89   */
90   function _transferOwnership(address payable newOwner) internal {
91     require(newOwner != address(0));
92     emit OwnershipTransferred(_owner, newOwner);
93     _owner = newOwner;
94   }
95 }
96 
97 /**
98  * @title SafeMath
99  * @dev Math operations with safety checks that throw on error
100  */
101 library SafeMath {
102 
103   /**
104   * @dev Multiplies two numbers, throws on overflow.
105   */
106   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107     if (a == 0) {
108       return 0;
109     }
110     uint256 c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return c;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129     assert(b <= a);
130     return a - b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 a, uint256 b) internal pure returns (uint256) {
137     uint256 c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 contract SellPayee is Ownable{
144 
145     IERC20Token public tokenContract;
146     IAssetSplitContracts public assetSplitContract;
147     IShareManager public shareManagerContract;
148     
149     
150     string public constant createdBy = "AssetSplit.org - the guys who cut the pizza";
151     
152     uint256 priceInEther = 500 finney;
153     uint256 priceInToken = 1;
154     
155     using SafeMath for uint256;
156     
157     constructor(address _tokenContract, address _AssetSplitContracts, address _shareManager) public {
158         tokenContract = IERC20Token(_tokenContract);
159         assetSplitContract = IAssetSplitContracts(_AssetSplitContracts);
160         shareManagerContract = IShareManager(_shareManager);
161     }
162     
163     function getShareAddressFromId(uint _id) internal view returns (address) {
164         address shareAddress;
165         (shareAddress,) = shareManagerContract.shares(_id);
166         return shareAddress;
167     }
168     
169     
170     function isAllowed(address payable _contractAddress) public view returns (bool) {
171         uint[] memory result = shareManagerContract.getSharesByShareOwner(msg.sender);
172         uint counter = 0;
173         for (uint i = 0; i < result.length; i++) {
174           if (getShareAddressFromId(result[i]) == _contractAddress) {
175             counter++;
176             return true;
177           }
178         }
179         return false;
180     }
181  
182     
183     function addASC(address payable _contractAddress) public payable returns (bool success) {
184         if (msg.value >= priceInEther) {
185            IPayeeShare shareContract;
186            shareContract = IPayeeShare(_contractAddress);
187            require(shareContract.owner() == msg.sender);
188            require(isAllowed(_contractAddress) == true);
189            require(shareContract.payeePartsToSell() > 0);
190            require(shareContract.payeePricePerPart() > 0);
191            _owner.transfer(address(this).balance);
192            assetSplitContract.addContract(_contractAddress, msg.sender, 1);
193            return true;
194         } else {
195             IPayeeShare shareContract;
196             shareContract = IPayeeShare(_contractAddress);
197             require(tokenContract.balanceOf(msg.sender) >= priceInToken.mul(shareContract.payeePartsToSell()).mul(10 ** tokenContract.decimals()));
198             require(tokenContract.transferFrom(msg.sender, _owner, priceInToken.mul(shareContract.payeePartsToSell()).mul(10 ** tokenContract.decimals())));
199             require(shareContract.owner() == msg.sender);
200             require(isAllowed(_contractAddress) == true);
201             require(shareContract.payeePartsToSell() > 0);
202             require(shareContract.payeePricePerPart() > 0);
203             assetSplitContract.addContract(_contractAddress, msg.sender, 1);
204             return true;
205         }
206         
207     }
208 }