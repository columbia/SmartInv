1 pragma solidity 0.4.24;
2 
3 contract Token {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract Ownable {
16   address public owner;
17 
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48 }
49 
50 contract TokenTransferProxy is Ownable {
51 
52     /// @dev Only authorized addresses can invoke functions with this modifier.
53     modifier onlyAuthorized {
54         require(authorized[msg.sender]);
55         _;
56     }
57 
58     modifier targetAuthorized(address target) {
59         require(authorized[target]);
60         _;
61     }
62 
63     modifier targetNotAuthorized(address target) {
64         require(!authorized[target]);
65         _;
66     }
67 
68     mapping (address => bool) public authorized;
69     address[] public authorities;
70 
71     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
72     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
73 
74     /*
75      * Public functions
76      */
77 
78     /// @dev Authorizes an address.
79     /// @param target Address to authorize.
80     function addAuthorizedAddress(address target)
81         public
82         onlyOwner
83         targetNotAuthorized(target)
84     {
85         authorized[target] = true;
86         authorities.push(target);
87         emit LogAuthorizedAddressAdded(target, msg.sender);
88     }
89 
90     /// @dev Removes authorizion of an address.
91     /// @param target Address to remove authorization from.
92     function removeAuthorizedAddress(address target)
93         public
94         onlyOwner
95         targetAuthorized(target)
96     {
97         delete authorized[target];
98         for (uint i = 0; i < authorities.length; i++) {
99             if (authorities[i] == target) {
100                 authorities[i] = authorities[authorities.length - 1];
101                 authorities.length -= 1;
102                 break;
103             }
104         }
105         emit LogAuthorizedAddressRemoved(target, msg.sender);
106     }
107 
108     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
109     /// @param token Address of token to transfer.
110     /// @param from Address to transfer token from.
111     /// @param to Address to transfer token to.
112     /// @param value Amount of token to transfer.
113     /// @return Success of transfer.
114     function transferFrom(
115         address token,
116         address from,
117         address to,
118         uint value)
119         public
120         onlyAuthorized
121         returns (bool)
122     {
123         return Token(token).transferFrom(from, to, value);
124     }
125 
126     /*
127      * Public constant functions
128      */
129 
130     /// @dev Gets all authorized addresses.
131     /// @return Array of authorized addresses.
132     function getAuthorizedAddresses()
133         public
134         constant
135         returns (address[])
136     {
137         return authorities;
138     }
139 }