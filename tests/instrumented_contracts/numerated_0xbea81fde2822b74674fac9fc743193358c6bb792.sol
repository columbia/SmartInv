1 pragma solidity 0.4.21;
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
17     function Ownable() public {
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
53     function Authorizable() public {
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
85 /**
86  * @title Whitelist interface
87  */
88 contract Whitelist is Authorizable {
89     mapping(address => bool) whitelisted;
90     event AddToWhitelist(address _beneficiary);
91     event RemoveFromWhitelist(address _beneficiary);
92    
93     function Whitelist() public {
94         addToWhitelist(msg.sender);
95     }
96     
97     
98     modifier onlyWhitelisted() {
99         require(isWhitelisted(msg.sender));
100         _;
101     }
102 
103     function isWhitelisted(address _address) public view returns (bool) {
104         return whitelisted[_address];
105     }
106 
107  
108     function addToWhitelist(address _beneficiary) public onlyAuthorized {
109         require(!whitelisted[_beneficiary]);
110         emit AddToWhitelist(_beneficiary);
111         whitelisted[_beneficiary] = true;
112     }
113     
114     function removeFromWhitelist(address _beneficiary) public onlyAuthorized {
115         require(whitelisted[_beneficiary]);
116         emit RemoveFromWhitelist(_beneficiary);
117         whitelisted[_beneficiary] = false;
118     }
119 }