1 pragma solidity ^0.4.21;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
52  */
53 contract ERC20 {
54 
55     function balanceOf(address _owner) external returns (uint256 balance);
56 
57     function transfer(address _to, uint256 _value) external returns (bool success);
58 
59     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
60 
61     function approve(address _spender, uint256 _value) external returns (bool success);
62 
63     function allowance(address _owner, address _spender) external returns (uint256 remaining);
64 
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66 
67     event Approval(address indexed _owner, address indexed _spender, uint256  _value);
68 }
69 
70 
71 contract Offer {
72 
73 	using SafeMath for uint256;                                        // Use safe math library
74 
75     ERC20 tokenContract;            // Object of token contract
76     address owner; // address of contract creator
77     address cpaOwner; // 0x583031d1113ad414f02576bd6afabfb302140987
78     string public offer_id;
79     uint256 public conversionsCount;
80     uint256 public totalAmount;
81 
82     struct conversion{
83         string id;
84         uint256 timestamp;
85         address affiliate;
86         uint256 amount;
87         uint256 toAffiliate;
88     }
89 
90     event Conversion(
91         string conversion_id
92     );
93 
94     mapping (bytes32 => conversion) conversions;         // Conversions table
95 
96     function Offer(address tokenContractAddress, string _offer_id, address _cpaOwner) public {
97         tokenContract = ERC20(tokenContractAddress);
98         offer_id = _offer_id;
99         owner = msg.sender;
100         cpaOwner = _cpaOwner;
101     }
102 
103     function getMyAddress() public view returns (address myAddress) {
104         return msg.sender;
105     }
106 
107     function getBalance(address _wallet) public view returns(uint256 _balance) {
108         return tokenContract.balanceOf(_wallet);
109     }
110 
111     function contractBalance() public view returns(uint256 _balance) {
112         return tokenContract.balanceOf(address(this));
113     }
114 
115     function writeConversion(string _conversion_id, address _affiliate, uint256 _amount, uint256 _toAffiliate)
116         public returns (bool success) {
117         require(msg.sender == owner);
118         require(_toAffiliate <= _amount);
119         require(_amount > 0);
120         require(_toAffiliate > 0);
121         if (getBalance(address(this)) >= _amount) {
122             conversionsCount++;
123             totalAmount = totalAmount.add(_amount);
124             conversions[keccak256(_conversion_id)] = conversion(_conversion_id, now, _affiliate, _amount, _toAffiliate);
125             tokenContract.transfer(_affiliate, _toAffiliate);
126             tokenContract.transfer(cpaOwner, _amount.sub(_toAffiliate));
127             emit Conversion(_conversion_id);
128         } else {
129             return false;
130         }
131         return true;
132     }
133 
134     function getConversionInfo(string _conversion_id)
135         public
136         constant
137         returns (string cid, uint256 ts, address aff, uint256 am, uint256 toAff) {
138         conversion storage _c = conversions[keccak256(_conversion_id)];
139         return (_c.id, _c.timestamp, _c.affiliate, _c.amount, _c.toAffiliate);
140     }
141 }