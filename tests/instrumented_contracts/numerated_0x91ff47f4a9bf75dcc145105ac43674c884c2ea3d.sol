1 pragma solidity > 0.4.99 <0.6.0;
2 
3 interface IPayeeShare {
4     function payeePartsToSell() external view returns (uint256);
5     function payeePricePerPart() external view returns (uint256);
6 }
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
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
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 contract AssetSplitContracts {
54     
55      struct Contract {
56         address payable contractAddress;
57         address payable creatorAddress;
58         uint256 contractType;
59         uint256 a_uint256;
60         string a_string;
61         uint256 b_uint256;
62         string b_string;
63         uint256 c_uint256;
64         string c_string;
65         bool active;
66     }
67     
68     Contract[] public contracts;
69 
70     struct SaleContract {
71         address payable saleContractAddress;
72     }
73     
74     SaleContract[] public saleContracts;
75     
76     mapping (address => uint) public saleContractCount;
77     
78     string public constant createdBy = "AssetSplit.org - the guys who cut the pizza";
79     
80     event AddedContract(address contractAddress, address contractCreator, uint256 contractType);
81     
82     bytes32 password = 0x75673d0f21e100acda4f6dc8b3ac99a142af1d843cb1936898d854e930409f10;
83 
84     using SafeMath for uint256;
85     
86     function addSaleContract(address payable _contractAddress, string memory _password, bytes32 _newPassword) public {
87         bytes32 pw = keccak256(bytes(_password));
88         require(password == pw);
89         require(password != _newPassword);
90         password = _newPassword;
91         saleContracts.push(SaleContract(_contractAddress)).sub(1);
92         saleContractCount[_contractAddress] = saleContractCount[_contractAddress].add(1);
93     }
94     
95     function editSaleContract(uint _id, address payable _newContractAddress, string memory _password, bytes32 _newPassword) public {
96         bytes32 pw = keccak256(bytes(_password));
97         require(password == pw);
98         require(_newPassword != "");
99         password = _newPassword;
100         SaleContract storage myContract = saleContracts[_id];
101         myContract.saleContractAddress = _newContractAddress;
102         saleContractCount[_newContractAddress] = saleContractCount[_newContractAddress].add(1);
103     }
104     
105     function addContract(address payable _contractAddress, address payable _creatorAddress, uint256 _contractType) public returns (bool success) {
106         require (saleContractCount[msg.sender] > 0);
107         removeOldFirst(_contractAddress);
108         contracts.push(Contract(_contractAddress, _creatorAddress, _contractType, 0, "", 0, "", 0, "", true));
109         emit AddedContract(_contractAddress, _creatorAddress, _contractType);
110         return true;
111     }
112 
113     function editContract (uint _id, uint256 _a_uint256, string memory _a_string, uint256 _b_uint256, string memory _b_string, uint256 _c_uint256, string memory _c_string) public returns (bool success) {
114         require (saleContractCount[msg.sender] > 0);
115         Contract storage myContract = contracts[_id];
116         myContract.a_uint256 = _a_uint256;
117         myContract.a_string = _a_string;
118         myContract.b_uint256 = _b_uint256;
119         myContract.b_string = _b_string;
120         myContract.c_uint256 = _c_uint256;
121         myContract.c_string = _c_string;
122         return true;
123     }
124     
125     function removeOldFirst(address _contractAddress) internal {
126         for (uint i = 0; i < contracts.length; i++) {    
127             Contract storage myContracts = contracts[i];
128             if (myContracts.contractAddress == _contractAddress) {
129                 myContracts.active = false;
130             }
131         }
132     }
133     
134     function countActiveType(uint256 _type) internal view returns (uint256) {
135         uint256 counter = 0;
136         for (uint i = 0; i < contracts.length; i++) {
137             Contract memory myContracts = contracts[i];
138         if (myContracts.contractType == _type && myContracts.active == true) {
139             counter++;
140           }
141         }
142         return counter;
143     }
144     
145    function getContractsByType(uint256 _type) public view returns (uint[] memory) {
146         uint[] memory result = new uint[](countActiveType(_type));
147         uint counter = 0;
148         for (uint i = 0; i < contracts.length; i++) {
149             Contract memory myContracts = contracts[i];
150           if (myContracts.contractType == _type && myContracts.active == true) {
151             result[counter] = i;
152             counter++;
153           }
154         }
155         return result;
156     }
157   
158      function getMyContractsByType(uint256 _type) public view returns (uint[] memory) {
159         uint[] memory result = new uint[](countActiveType(_type));
160         uint counter = 0;
161         for (uint i = 0; i < contracts.length; i++) {
162         Contract memory myContracts = contracts[i];
163           if (myContracts.contractType == _type && myContracts.creatorAddress == msg.sender && myContracts.active == true) {
164             result[counter] = i;
165             counter++;
166           }
167         }
168         return result;
169     }
170     
171     function cleanSellShareOutput() public {
172         for (uint i = 0; i < contracts.length; i++) {    
173             Contract storage myContracts = contracts[i];
174             IPayeeShare shareContract;
175             shareContract = IPayeeShare(myContracts.contractAddress);
176             if (shareContract.payeePartsToSell() < 1 || shareContract.payeePricePerPart() == 0) {
177                 myContracts.active = false;
178             }
179         }
180     }
181     
182 
183 }