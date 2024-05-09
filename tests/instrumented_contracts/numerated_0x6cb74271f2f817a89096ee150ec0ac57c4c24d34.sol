1 pragma solidity ^0.5.7;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
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
58 contract Authorizable is Ownable {
59     mapping(address => bool) public authorized;
60   
61     event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);
62 
63     constructor() public {
64         authorized[msg.sender] = true;
65     }
66 
67     modifier onlyAuthorized() {
68         require(authorized[msg.sender], "authorized[msg.sender]");
69         _;
70     }
71 
72     function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {
73         emit AuthorizationSet(addressAuthorized, authorization);
74         authorized[addressAuthorized] = authorization;
75     }
76   
77 }
78  
79 contract tokenInterface {
80     function transfer(address _to, uint256 _value) public returns (bool);
81 }
82 
83 contract MultiSender is Authorizable {
84 	tokenInterface public tokenContract;
85 	
86 	constructor(address _tokenAddress) public {
87 	    tokenContract = tokenInterface(_tokenAddress);
88 	}
89 	
90 	function updateTokenContract(address _tokenAddress) public onlyAuthorized {
91         tokenContract = tokenInterface(_tokenAddress);
92     }
93 	
94     function multiSend(address[] memory _dests, uint256[] memory _values) public onlyAuthorized returns(uint256) {
95         require(_dests.length == _values.length, "_dests.length == _values.length");
96         uint256 i = 0;
97         while (i < _dests.length) {
98            tokenContract.transfer(_dests[i], _values[i]);
99            i += 1;
100         }
101         return(i);
102     }
103 	
104 	function withdrawTokens(address to, uint256 value) public onlyAuthorized returns (bool) {
105         return tokenContract.transfer(to, value);
106     }
107     
108     function withdrawEther() public onlyAuthorized returns (bool) {
109         msg.sender.transfer(address(this).balance);
110         return true;
111     }
112 }