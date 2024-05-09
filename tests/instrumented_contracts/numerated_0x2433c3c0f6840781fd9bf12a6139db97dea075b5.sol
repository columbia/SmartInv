1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     if (a == 0) {
56       return 0;
57     }
58     c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     // uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return a / b;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
85     c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20BasicInterface {
98     function totalSupply() public view returns (uint256);
99     function balanceOf(address who) public view returns (uint256);
100     function transfer(address to, uint256 value) public returns (bool);
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     uint8 public decimals;
104 }
105 
106 contract BatchTransferWallet is Ownable {
107     using SafeMath for uint256;
108     ERC20BasicInterface public token;
109 
110     event LogWithdrawal(address indexed receiver, uint amount);
111 
112     // constructor
113     constructor(address _tokenAddress) public {
114         token = ERC20BasicInterface(_tokenAddress);
115     }
116 
117     /**
118     * @dev Send token to multiple address
119     * @param _investors The addresses of EOA that can receive token from this contract.
120     * @param _tokenAmounts The values of token are sent from this contract.
121     */
122     function batchTransfer(address[] _investors, uint256[] _tokenAmounts) public onlyOwner {
123         if (_investors.length != _tokenAmounts.length || _investors.length == 0) {
124             revert();
125         }
126 
127         uint decimalsForCalc = 10 ** uint256(token.decimals());
128 
129         for (uint i = 0; i < _investors.length; i++) {
130             require(_tokenAmounts[i] > 0 && _investors[i] != 0x0);
131             _tokenAmounts[i] = _tokenAmounts[i].mul(decimalsForCalc);
132             require(token.transfer(_investors[i], _tokenAmounts[i]));
133         }
134     }
135 
136     /**
137     * @dev Withdraw the amount of token that is remaining in this contract.
138     * @param _address The address of EOA that can receive token from this contract.
139     */
140     function withdraw(address _address) public onlyOwner {
141         uint tokenBalanceOfContract = token.balanceOf(this);
142 
143         require(_address != address(0) && tokenBalanceOfContract > 0);
144         require(token.transfer(_address, tokenBalanceOfContract));
145         emit LogWithdrawal(_address, tokenBalanceOfContract);
146     }
147 
148     /**
149     * @dev return token balance this contract has
150     * @return _address token balance this contract has.
151     */
152     function balanceOfContract() public view returns (uint) {
153         return token.balanceOf(this);
154     }
155 }