1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
71    */
72   constructor() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to relinquish control of the contract.
86    */
87   function renounceOwnership() public onlyOwner {
88     emit OwnershipRenounced(owner);
89     owner = address(0);
90   }
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address _newOwner) public onlyOwner {
97     _transferOwnership(_newOwner);
98   }
99 
100   /**
101    * @dev Transfers control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function _transferOwnership(address _newOwner) internal {
105     require(_newOwner != address(0));
106     emit OwnershipTransferred(owner, _newOwner);
107     owner = _newOwner;
108   }
109 }
110 
111 
112 contract Blocksquare {
113     function transfer(address _to, uint256 _amount) public returns (bool _success);
114     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool _success);
115 }
116 
117 contract Data {
118     function isBS(address _member) public constant returns (bool);
119     function getCP(address _cp) constant public returns (string, string);
120     function canMakeNoFeeTransfer(address _from, address _to) constant public returns (bool);
121 }
122 
123 contract Whitelist {
124     function isWhitelisted(address _user) public constant returns (bool);
125 }
126 
127 contract PropTokenRENT is Ownable {
128     using SafeMath for uint256;
129 
130     Blocksquare BST;
131     Data data;
132     Whitelist whitelist;
133     mapping(address => mapping(address => uint256)) rentAmountPerToken;
134 
135     constructor() public {
136         BST = Blocksquare(0x509A38b7a1cC0dcd83Aa9d06214663D9eC7c7F4a);
137         data = Data(0x146d589cfe136644bdF4f1958452B5a4Bb9c5A05);
138         whitelist = Whitelist(0xCB641F6B46e1f2970dB003C19515018D0338550a);
139     }
140 
141     function compare(string _a, string _b) internal pure returns (int) {
142         bytes memory a = bytes(_a);
143         bytes memory b = bytes(_b);
144         uint minLength = a.length;
145         if (b.length < minLength) minLength = b.length;
146         for (uint i = 0; i < minLength; i ++)
147             if (a[i] < b[i])
148                 return -1;
149             else if (a[i] > b[i])
150                 return 1;
151         if (a.length < b.length)
152             return -1;
153         else if (a.length > b.length)
154             return 1;
155         else
156             return 0;
157     }
158 
159     function equal(string _a, string _b) pure internal returns (bool) {
160         return compare(_a, _b) == 0;
161     }
162 
163     modifier canAddRent() {
164         (string memory ref, string memory name) = data.getCP(msg.sender);
165         require(data.isBS(msg.sender) || (!equal(ref, "") && !equal(name, "")));
166         _;
167     }
168 
169     function addRentToAddressForToken(address _token, address[] _addresses, uint256[] _amount) public canAddRent {
170         require(_addresses.length == _amount.length);
171         uint256 amountToPay = 0;
172         for(uint256 i = 0; i < _addresses.length; i++) {
173             rentAmountPerToken[_token][_addresses[i]] = rentAmountPerToken[_token][_addresses[i]].add(_amount[i]);
174             amountToPay = amountToPay.add(_amount[i]);
175         }
176         BST.transferFrom(msg.sender, address(this), amountToPay);
177     }
178 
179     function claimRentForToken(address _token, address _holdingWallet) public {
180         require(whitelist.isWhitelisted(msg.sender) && whitelist.isWhitelisted(_holdingWallet));
181         uint256 rent = rentAmountPerToken[_token][msg.sender];
182         rentAmountPerToken[_token][msg.sender] = 0;
183         // Check if sending wallet and another wallet belong to same user
184         if(msg.sender != _holdingWallet) {
185             require(data.canMakeNoFeeTransfer(msg.sender, _holdingWallet));
186             rent = rent.add(rentAmountPerToken[_token][_holdingWallet]);
187             rentAmountPerToken[_token][_holdingWallet] = 0;
188         }
189 
190         BST.transfer(msg.sender, rent);
191     }
192 
193     function claimBulkRentForTokens(address[] _token, address _holdingWallet) public {
194         require(whitelist.isWhitelisted(msg.sender) && whitelist.isWhitelisted(_holdingWallet));
195         require(_token.length < 11);
196         if(msg.sender != _holdingWallet) {
197             require(data.canMakeNoFeeTransfer(msg.sender, _holdingWallet));
198         }
199         uint256 rent = 0;
200         for(uint256 i = 0; i < _token.length; i++) {
201             rent = rent.add(rentAmountPerToken[_token[i]][msg.sender]);
202             rentAmountPerToken[_token[i]][msg.sender] = 0;
203 
204             rent = rent.add(rentAmountPerToken[_token[i]][_holdingWallet]);
205             rentAmountPerToken[_token[i]][_holdingWallet] = 0;
206         }
207 
208         BST.transfer(msg.sender, rent);
209     }
210 
211     function pendingBSTForToken(address _token, address _user) public constant returns(uint256) {
212         return rentAmountPerToken[_token][_user];
213     }
214 }