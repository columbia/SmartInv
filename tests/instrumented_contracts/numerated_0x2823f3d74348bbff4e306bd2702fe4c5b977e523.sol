1 pragma solidity ^0.4.18;
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
20   function Ownable() public {
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
38     OwnershipTransferred(owner, newOwner);
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
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 contract  HandToken {
93     function totalSupply() public constant returns (uint256 _totalSupply);
94     function transfer(address _to, uint256 _value) public returns (bool success) ;
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
96     function balanceOf(address _owner) view public returns (uint256 balance) ;
97 }
98 
99 
100 /**
101  * @title 空投合约
102  */
103 contract AirDrop is Ownable {
104   using SafeMath for uint256;
105   // 对应的token
106   HandToken public token; 
107   address public tokenAddress;
108   
109 
110   /**
111    * 构造函数，设置token
112    */
113   function AirDrop (address addr)  public {
114     token = HandToken(addr);
115     require(token.totalSupply() > 0);
116     tokenAddress = addr;
117   }
118 
119   /**
120    * fallback函数，接受eth充值
121    */
122   function () public payable {
123   }
124 
125   /**
126    * 空投
127    * @param dstAddress 目标地址列表
128    * @param value 分发的金额
129    */
130   function drop(address[] dstAddress, uint256 value) public onlyOwner {
131     require(dstAddress.length <= 100);  // 不能多于100个地址
132     for (uint256 i = 0; i < dstAddress.length; i++) {
133     	token.transfer(dstAddress[i], value);
134     }
135   }
136 }