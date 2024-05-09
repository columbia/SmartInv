1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address public owner;
33 
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() public {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     emit OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     if (a == 0) {
77       return 0;
78     }
79     c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     // uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return a / b;
92   }
93 
94   /**
95   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106     c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 contract ContractiumNatmin is Ownable {
113     using SafeMath for uint256;
114     
115     uint256 constant public CTU_RATE = 19500; // 1 ETH/19500 CTU
116     uint256 constant public NAT_RATE = 10400; // 1 ETH/10400 NAT
117     
118     mapping (string => ERC20) tokenAddresses;
119     mapping (string => address) approverAddresses;
120     uint256 receivedETH;
121     
122     event Deposit(address indexed _from, uint256 _ctuAmount, uint256 _natAmount);
123     
124     constructor(
125         address _ctu,
126         address _nat,
127         address _approverCTUAddress,
128         address _approverNATAddress
129     ) public {
130         setToken(_ctu, "CTU");
131         setToken(_nat, "NAT");
132         setApproverCTUAddress(_approverCTUAddress);
133         setApproverNATAddress(_approverNATAddress);
134     }
135     
136     function () public payable {
137         address sender = msg.sender;
138         uint256 depositAmount = msg.value;
139         uint256 halfOfDepositAmount = depositAmount.div(2);
140         uint256 ctuAmount = depositAmount.mul(CTU_RATE);
141         uint256 natAmount = depositAmount.mul(NAT_RATE);
142         ERC20 ctuToken = tokenAddresses["CTU"];
143         ERC20 natToken = tokenAddresses["NAT"];
144         
145         require(ctuToken.transferFrom(approverAddresses["CTU"], sender, ctuAmount));
146         require(natToken.transferFrom(approverAddresses["NAT"], sender, natAmount));
147         
148         receivedETH = receivedETH + depositAmount;
149         
150         approverAddresses["CTU"].transfer(halfOfDepositAmount);
151         approverAddresses["NAT"].transfer(depositAmount.sub(halfOfDepositAmount));
152         
153         emit Deposit(sender, ctuAmount, natAmount);
154     }
155     
156     function setApproverCTUAddress(address _address) public onlyOwner {
157         setApprover(_address, "CTU");
158     }
159     
160     function setApproverNATAddress(address _address) public onlyOwner {
161         setApprover(_address, "NAT");
162     }
163     
164     
165     function getAvailableCTU() public view returns (uint256) {
166         return getAvailableToken("CTU");
167     }
168     
169     function getAvailableNAT() public view returns (uint256) {
170         return getAvailableToken("NAT");
171     }
172     
173     function getTokenAddress(string _tokenSymbol) public view returns (address) {
174         return tokenAddresses[_tokenSymbol];
175     }
176     
177     function getApproverAddress(string _tokenSymbol) public view returns (address) {
178         return approverAddresses[_tokenSymbol];
179     }
180     
181     function getAvailableToken(string _tokenSymbol) internal view returns (uint256) {
182         ERC20 token = tokenAddresses[_tokenSymbol];
183         uint256 allowance = token.allowance(approverAddresses[_tokenSymbol], this);
184         uint256 approverBalance = token.balanceOf(approverAddresses[_tokenSymbol]);
185         
186         return allowance > approverBalance ? approverBalance : allowance;
187     }
188     
189     function setToken(address _address, string _symbol) internal onlyOwner {
190         require(_address != 0x0);
191         tokenAddresses[_symbol] = ERC20(_address);
192     }
193     
194     function setApprover(address _address, string _tokenSymbol) internal onlyOwner {
195         require(_address != 0x0);
196         approverAddresses[_tokenSymbol] = _address;
197     }
198     
199 }