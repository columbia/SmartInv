1 pragma  solidity ^ 0.4.24 ;
2 
3 // ----------------------------------------------------------------------------
4 // 安全的加减乘除
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7 	function add(uint a, uint b) internal pure returns(uint c) {
8 		c = a + b;
9 		require(c >= a);
10 	}
11 
12 	function sub(uint a, uint b) internal pure returns(uint c) {
13 		require(b <= a);
14 		c = a - b;
15 	}
16 
17 	function mul(uint a, uint b) internal pure returns(uint c) {
18 		c = a * b;
19 		require(a == 0 || c / a == b);
20 	}
21 
22 	function div(uint a, uint b) internal pure returns(uint c) {
23 		require(b > 0);
24 		c = a / b;
25 	}
26 }
27 
28 
29 contract COM  {
30 	using SafeMath for uint;
31 	address public owner; 
32     
33     address public backaddress1;
34     address public backaddress2;
35     uint public per1 = 150 ;
36     uint public per2 = 850 ;
37     
38 	
39 	modifier onlyOwner {
40 		require(msg.sender == owner);
41 		_;
42 	}
43 	
44 	modifier onlyConf(address _back1,uint _limit1,address _back2,uint _limit2) {
45 	    require(_back1 !=address(0x0) && _back1 != address(this));
46 	    require(_back2 !=address(0x0) && _back2 != address(this));
47 	    require(_back2 != _back1);
48 	    require(_limit1 >0 && _limit2 >0 && _limit1.add(_limit2)==1000);
49 	    _;
50 	}
51 	
52 	event Transfer(address from,address to,uint value);
53 	event Setowner(address newowner,address oldower);
54 	
55 	constructor(address back1,address back2)  public{
56 	    require(back1 !=address(0x0) && back1 != address(this));
57 	    require(back2 !=address(0x0) && back2 != address(this));
58 	    require(back2 != back1);
59 	    owner = msg.sender;
60 	    backaddress1 = back1;
61 	    backaddress2 = back2;
62 	}
63 	
64 	function setconf(address _back1,uint _limit1,address _back2,uint _limit2) onlyOwner onlyConf( _back1, _limit1, _back2, _limit2) public {
65 	    backaddress1 = _back1;
66 	    backaddress2 = _back2;
67 	    per1 = _limit1;
68 	    per2 = _limit2;
69 	}
70 	function setowner(address _newowner) onlyOwner public {
71 	    require(_newowner !=owner && _newowner !=address(this) && _newowner !=address(0x0));
72 	    address  oldower = owner;
73 	    owner = _newowner;
74 	    emit Setowner(_newowner,oldower);
75 	}
76 	
77 	function transfer() public payable  {
78 	  emit Transfer(msg.sender,address(this),msg.value);
79 	  backaddress1.transfer(msg.value * per1 / 1000);
80 	  emit Transfer(address(this),backaddress1,msg.value * per1 / 1000);
81 	  backaddress2.transfer(msg.value * per2 / 1000);
82 	  emit Transfer(address(this),backaddress2,msg.value * per2 / 1000);
83 	}
84 	
85 	function () public payable  {
86 	  transfer();
87 	}
88 
89 }