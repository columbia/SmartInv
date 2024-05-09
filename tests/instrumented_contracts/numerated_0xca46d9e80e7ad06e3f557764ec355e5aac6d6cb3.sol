1 pragma solidity 0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor() public {
18         owner = msg.sender;
19     }
20     /**
21      * @dev Throws if called by any account other than the owner.
22      */
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     /**
29      * @dev Allows the current owner to transfer control of the contract to a newOwner.
30      * @param newOwner The address to transfer ownership to.
31      */
32     function transferOwnership(address newOwner) public onlyOwner {
33         require(newOwner != address(0));
34         emit OwnershipTransferred(owner, newOwner);
35         owner = newOwner;
36     }
37 }
38 
39 /**
40  * @title Authorizable
41  * @dev The Authorizable contract has authorized addresses, and provides basic authorization control
42  * functions, this simplifies the implementation of "multiple user permissions".
43  */
44 contract Authorizable is Ownable {
45     
46     mapping(address => bool) public authorized;
47     event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);
48 
49     /**
50      * @dev The Authorizable constructor sets the first `authorized` of the contract to the sender
51      * account.
52      */
53     constructor() public {
54         authorize(msg.sender);
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the authorized.
59      */
60     modifier onlyAuthorized() {
61         require(authorized[msg.sender]);
62         _;
63     }
64 
65     /**
66      * @dev Allows 
67      * @param _address The address to change authorization.
68      */
69     function authorize(address _address) public onlyOwner {
70         require(!authorized[_address]);
71         emit AuthorizationSet(_address, true);
72         authorized[_address] = true;
73     }
74     /**
75      * @dev Disallows
76      * @param _address The address to change authorization.
77      */
78     function deauthorize(address _address) public onlyOwner {
79         require(authorized[_address]);
80         emit AuthorizationSet(_address, false);
81         authorized[_address] = false;
82     }
83 }
84 
85 contract ZmineStRandom is Authorizable {
86     
87     uint256 public counter = 0;
88     mapping(uint256 => uint256) public randomResultMap;
89     mapping(uint256 => uint256[]) public randomInputMap;
90     
91  
92     function random(uint256 min, uint256 max, uint256 lotto) public onlyAuthorized  {
93         
94 	require(min > 0);
95         require(max > min);
96          
97         counter++;
98         uint256 result = ((uint256(keccak256(abi.encodePacked())) 
99                         + uint256(keccak256(abi.encodePacked(counter))) 
100                         + uint256(keccak256(abi.encodePacked(block.difficulty)))
101                         + uint256(keccak256(abi.encodePacked(block.number - 1)))
102                     ) % (max-min+1)) + min;
103         
104         uint256[] memory array = new uint256[](5);
105         array[0] = min;
106         array[1] = max;
107         array[2] = lotto;
108         array[3] = block.difficulty;
109         array[4] = block.number;
110         randomInputMap[counter] = array;
111         randomResultMap[counter] = result;
112     }
113 
114     function checkHash(uint256 n) public pure returns (uint256){
115         return uint256(keccak256(abi.encodePacked(n)));
116     }
117 }