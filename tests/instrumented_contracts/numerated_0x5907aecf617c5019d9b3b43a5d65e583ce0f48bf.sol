1 pragma solidity ^0.4.23;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9 
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     emit OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40 }
41 
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
53     if (a == 0) {
54       return 0;
55     }
56     c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     // uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return a / b;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20BasicInterface {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     function transferFrom(address from, address to, uint256 value) public returns (bool);
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     uint8 public decimals;
103 }
104 
105 
106 contract BatchTransferWallet is Ownable {
107     using SafeMath for uint256;
108 
109     /**
110     * @dev Send token to multiple address
111     * @param _investors The addresses of EOA that can receive token from this contract.
112     * @param _tokenAmounts The values of token are sent from this contract.
113     */
114     function batchTransferFrom(address _tokenAddress, address[] _investors, uint256[] _tokenAmounts) public {
115         ERC20BasicInterface token = ERC20BasicInterface(_tokenAddress);
116         require(_investors.length == _tokenAmounts.length && _investors.length != 0);
117 
118         for (uint i = 0; i < _investors.length; i++) {
119             require(_tokenAmounts[i] > 0 && _investors[i] != 0x0);
120             require(token.transferFrom(msg.sender,_investors[i], _tokenAmounts[i]));
121         }
122     }
123 
124     /**
125     * @dev return token balance this contract has
126     * @return _address token balance this contract has.
127     */
128     function balanceOfContract(address _tokenAddress,address _address) public view returns (uint) {
129         ERC20BasicInterface token = ERC20BasicInterface(_tokenAddress);
130         return token.balanceOf(_address);
131     }
132     function getTotalSendingAmount(uint256[] _amounts) private pure returns (uint totalSendingAmount) {
133         for (uint i = 0; i < _amounts.length; i++) {
134             require(_amounts[i] > 0);
135             totalSendingAmount += _amounts[i];
136         }
137     }
138     // Events allow light clients to react on
139     // changes efficiently.
140     event Sent(address from, address to, uint amount);
141     function transferMulti(address[] receivers, uint256[] amounts) payable {
142         require(msg.value != 0 && msg.value >= getTotalSendingAmount(amounts));
143         for (uint256 j = 0; j < amounts.length; j++) {
144             receivers[j].transfer(amounts[j]);
145             emit Sent(msg.sender, receivers[j], amounts[j]);
146         }
147     }
148     /**
149         * @dev Withdraw the amount of token that is remaining in this contract.
150         * @param _address The address of EOA that can receive token from this contract.
151         */
152         function withdraw(address _address) public onlyOwner {
153             require(_address != address(0));
154             _address.transfer(address(this).balance);
155         }
156 }