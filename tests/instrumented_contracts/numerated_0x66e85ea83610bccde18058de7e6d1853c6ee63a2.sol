1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: contracts/MainFabric.sol
94 
95 //import "./tokens/ERC20StandardToken.sol";
96 //import "./tokens/ERC20MintableToken.sol";
97 //import "./crowdsale/RefundCrowdsale.sol";
98 
99 contract MainFabric is Ownable {
100 
101     using SafeMath for uint256;
102 
103     struct Contract {
104         address addr;
105         address owner;
106         address fabric;
107         string contractType;
108         uint256 index;
109     }
110 
111     struct Fabric {
112         address addr;
113         address owner;
114         bool isActive;
115         uint256 index;
116     }
117 
118     struct Admin {
119         address addr;
120         address[] contratcs;
121         uint256 numContratcs;
122         uint256 index;
123     }
124 
125     // ---====== CONTRACTS ======---
126     /**
127      * @dev Get contract object by address
128      */
129     mapping(address => Contract) public contracts;
130 
131     /**
132      * @dev Contracts addresses list
133      */
134     address[] public contractsAddr;
135 
136     /**
137      * @dev Count of contracts in list
138      */
139     function numContracts() public view returns (uint256)
140     { return contractsAddr.length; }
141 
142 
143     // ---====== ADMINS ======---
144     /**
145      * @dev Get contract object by address
146      */
147     mapping(address => Admin) public admins;
148 
149     /**
150      * @dev Contracts addresses list
151      */
152     address[] public adminsAddr;
153 
154     /**
155      * @dev Count of contracts in list
156      */
157     function numAdmins() public view returns (uint256)
158     { return adminsAddr.length; }
159 
160     function getAdminContract(address _adminAddress, uint256 _index) public view returns (
161         address
162     ) {
163         return (
164             admins[_adminAddress].contratcs[_index]
165         );
166     }
167 
168     // ---====== FABRICS ======---
169     /**
170      * @dev Get fabric object by address
171      */
172     mapping(address => Fabric) public fabrics;
173 
174     /**
175      * @dev Fabrics addresses list
176      */
177     address[] public fabricsAddr;
178 
179     /**
180      * @dev Count of fabrics in list
181      */
182     function numFabrics() public view returns (uint256)
183     { return fabricsAddr.length; }
184 
185     /**
186    * @dev Throws if called by any account other than the owner.
187    */
188     modifier onlyFabric() {
189         require(fabrics[msg.sender].isActive);
190         _;
191     }
192 
193     // ---====== CONSTRUCTOR ======---
194 
195     function MainFabric() public {
196 
197     }
198 
199     /**
200      * @dev Add fabric
201      * @param _address Fabric address
202      */
203     function addFabric(
204         address _address
205     )
206     public
207     onlyOwner
208     returns (bool)
209     {
210         fabrics[_address].addr = _address;
211         fabrics[_address].owner = msg.sender;
212         fabrics[_address].isActive = true;
213         fabrics[_address].index = fabricsAddr.push(_address) - 1;
214 
215         return true;
216     }
217 
218     /**
219      * @dev Remove fabric
220      * @param _address Fabric address
221      */
222     function removeFabric(
223         address _address
224     )
225     public
226     onlyOwner
227     returns (bool)
228     {
229         require(fabrics[_address].isActive);
230         fabrics[_address].isActive = false;
231 
232         uint rowToDelete = fabrics[_address].index;
233         address keyToMove   = fabricsAddr[fabricsAddr.length-1];
234         fabricsAddr[rowToDelete] = keyToMove;
235         fabrics[keyToMove].index = rowToDelete;
236         fabricsAddr.length--;
237 
238         return true;
239     }
240 
241     /**
242      * @dev Create refund crowdsale
243      * @param _address Fabric address
244      */
245     function addContract(
246         address _address,
247         address _owner,
248         string _contractType
249     )
250     public
251     onlyFabric
252     returns (bool)
253     {
254         contracts[_address].addr = _address;
255         contracts[_address].owner = _owner;
256         contracts[_address].fabric = msg.sender;
257         contracts[_address].contractType = _contractType;
258         contracts[_address].index = contractsAddr.push(_address) - 1;
259 
260         if (admins[_owner].addr != _owner) {
261             admins[_owner].addr = _owner;
262             admins[_owner].index = adminsAddr.push(_owner) - 1;
263         }
264 
265         admins[_owner].contratcs.push(contracts[_address].addr);
266         admins[_owner].numContratcs++;
267 
268         return true;
269     }
270 }