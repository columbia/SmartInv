1 pragma solidity ^0.4.23;
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
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62     * account.
63     */
64     function Ownable() public {
65         owner = msg.sender;
66     }
67 
68     /**
69     * @dev Throws if called by any account other than the owner.
70     */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77     * @dev Allows the current owner to transfer control of the contract to a newOwner.
78     * @param newOwner The address to transfer ownership to.
79     */
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0));
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84     }
85 
86 }
87 
88 
89 contract BatchTransferEther is Ownable {
90     using SafeMath for uint256;
91     
92     event LogTransfer(address indexed sender, address indexed receiver, uint256 amount);
93     
94     function batchTransferEtherWithSameAmount(address[] _addresses, uint _amoumt) public payable onlyOwner {
95         require(_addresses.length != 0 && _amoumt != 0);
96         uint checkAmount = msg.value.div(_addresses.length);
97         require(_amoumt == checkAmount);
98         
99         for (uint i = 0; i < _addresses.length; i++) {
100             require(_addresses[i] != address(0));
101             _addresses[i].transfer(_amoumt);
102             emit LogTransfer(msg.sender, _addresses[i], _amoumt);
103         }
104     }
105     
106     function batchTransferEther(address[] _addresses, uint[] _amoumts) public payable onlyOwner {
107         require(_addresses.length == _amoumts.length || _addresses.length != 0);
108         uint total = sumAmounts(_amoumts);
109         require(total == msg.value);
110         
111         for (uint i = 0; i < _addresses.length; i++) {
112             require(_addresses[i] != 0x0);
113             _addresses[i].transfer(_amoumts[i]);
114             emit LogTransfer(msg.sender, _addresses[i], _amoumts[i]);
115         }
116     }
117     
118     function sumAmounts(uint[] _amoumts) private pure returns (uint sumResult) {
119         for (uint i = 0; i < _amoumts.length; i++) {
120             require(_amoumts[i] > 0);
121             sumResult = sumResult.add(_amoumts[i]);
122         }
123     }
124 
125 }