1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14      return a / b;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30 	address public owner;
31 	address public newOwner;
32 
33 	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
34 
35 	constructor() public {
36 		owner = msg.sender;
37 		newOwner = address(0);
38 	}
39 
40 	modifier onlyOwner() {
41 		require(msg.sender == owner, "msg.sender == owner");
42 		_;
43 	}
44 
45 	function transferOwnership(address _newOwner) public onlyOwner {
46 		require(address(0) != _newOwner, "address(0) != _newOwner");
47 		newOwner = _newOwner;
48 	}
49 
50 	function acceptOwnership() public {
51 		require(msg.sender == newOwner, "msg.sender == newOwner");
52 		emit OwnershipTransferred(owner, msg.sender);
53 		owner = msg.sender;
54 		newOwner = address(0);
55 	}
56 }
57 
58 contract tokenInterface {
59 	function balanceOf(address _owner) public constant returns (uint256 balance);
60 	function transfer(address _to, uint256 _value) public returns (bool);
61 	function originBurn(uint256 _value) public returns(bool);
62 }
63 
64 contract Refund is Ownable{
65     using SafeMath for uint256;
66     
67     tokenInterface public xcc;
68     
69     mapping (address => uint256) public refunds;
70     
71     constructor(address _xcc) public {
72         xcc = tokenInterface(_xcc);
73     } 
74 
75     function () public  {
76         require ( msg.sender == tx.origin, "msg.sender == tx.orgin" );
77 		
78 		uint256 xcc_amount = xcc.balanceOf(msg.sender);
79 		require( xcc_amount > 0, "xcc_amount > 0" );
80 		
81 		uint256 money = refunds[msg.sender];
82 		require( money > 0 , "money > 0" );
83 		
84 		refunds[msg.sender] = 0;
85 		
86 		xcc.originBurn(xcc_amount);
87 		msg.sender.transfer(money);
88 		
89     }
90     
91     function setRefund(address _buyer) public onlyOwner payable {
92         refunds[_buyer] = refunds[_buyer].add(msg.value);
93     }
94     
95     function cancelRefund(address _buyer) public onlyOwner {
96         uint256 money = refunds[_buyer];
97         require( money > 0 , "money > 0" );
98 		refunds[_buyer] = 0;
99 		
100         owner.transfer(money);
101     }
102     
103     function withdrawTokens(address tknAddr, address to, uint256 value) public onlyOwner returns (bool) { //emergency function
104         return tokenInterface(tknAddr).transfer(to, value);
105     }
106     
107     function withdraw(address to, uint256 value) public onlyOwner { //emergency function
108         to.transfer(value);
109     }
110 }