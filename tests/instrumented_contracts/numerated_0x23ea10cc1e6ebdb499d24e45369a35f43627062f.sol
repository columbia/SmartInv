1 pragma solidity 0.5.16;
2 
3 contract DGDInterface {
4 
5   string public constant name = "DigixDAO";
6   string public constant symbol = "DGD";
7   uint8 public constant decimals = 9;
8 
9   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
10   event Transfer(address indexed from, address indexed to, uint tokens);
11 
12   mapping(address => uint256) balances;
13 
14   mapping(address => mapping (address => uint256)) allowed;
15 
16   uint256 public totalSupply;
17 
18   function balanceOf(address tokenOwner) public view returns (uint) {}
19 
20   function transfer(address receiver, uint numTokens) public returns (bool) {}
21 
22   function approve(address delegate, uint numTokens) public returns (bool) {}
23 
24   function allowance(address owner, address delegate) public view returns (uint) {}
25 
26   function transferFrom(address owner, address buyer, uint numTokens) public returns (bool _success) {}
27 }
28 
29 contract Acid {
30 
31   event Refund(address indexed user, uint256 indexed dgds, uint256 refundAmount);
32 
33   // wei refunded per 0.000000001 DGD burned
34   uint256 public weiPerNanoDGD;
35   bool public isInitialized;
36   address public dgdTokenContract;
37   address public owner;
38 
39   modifier onlyOwner() {
40     require(owner == msg.sender);
41     _;
42   }
43 
44   modifier unlessInitialized() {
45     require(!isInitialized, "contract is already initialized");
46     _;
47   }
48 
49   modifier requireInitialized() {
50     require(isInitialized, "contract is not initialized");
51     _;
52   }
53 
54   constructor() public {
55     owner = msg.sender;
56     isInitialized = false;
57   }
58 
59   function () external payable {}
60 
61   function init(uint256 _weiPerNanoDGD, address _dgdTokenContract) public onlyOwner() unlessInitialized() returns (bool _success) {
62     require(_weiPerNanoDGD > 0, "rate cannot be zero");
63     require(_dgdTokenContract != address(0), "DGD token contract cannot be empty");
64     weiPerNanoDGD = _weiPerNanoDGD;
65     dgdTokenContract = _dgdTokenContract;
66     isInitialized = true;
67     _success = true;
68   }
69 
70   function burn() public requireInitialized() returns (bool _success) {
71     // Rate will be calculated based on the nearest decimal
72     uint256 _amount = DGDInterface(dgdTokenContract).balanceOf(msg.sender);
73     uint256 _wei = mul(_amount, weiPerNanoDGD);
74     require(address(this).balance >= _wei, "Contract does not have enough funds");
75     require(DGDInterface(dgdTokenContract).transferFrom(msg.sender, 0x0000000000000000000000000000000000000000, _amount), "No DGDs or DGD account not authorized");
76     address _user = msg.sender;
77     (_success,) = _user.call.value(_wei)('');
78     require(_success, "Transfer of Ether failed");
79     emit Refund(_user, _amount, _wei);
80   }
81 
82   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84     // benefit is lost if 'b' is also tested.
85     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
86     if (a == 0) {
87       return 0;
88     }
89     uint256 c = a * b;
90     require(c / a == b, "SafeMath: multiplication overflow");
91 
92     return c;
93   }
94 }