1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two numbers, throws on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23      * @dev Integer division of two numbers, truncating the quotient.
24      */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41      * @dev Adds two numbers, throws on overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param newOwner The address to transfer ownership to.
81      */
82     function transferOwnership(address newOwner) public onlyOwner {
83         require(newOwner != address(0));
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86     }
87 }
88 
89 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
90 
91 /**
92  * @title Claimable
93  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
94  * This allows the new owner to accept the transfer.
95  */
96 contract Claimable is Ownable {
97     address public pendingOwner;
98 
99     /**
100      * @dev Modifier throws if called by any account other than the pendingOwner.
101      */
102     modifier onlyPendingOwner() {
103         require(msg.sender == pendingOwner);
104         _;
105     }
106 
107     /**
108      * @dev Allows the current owner to set the pendingOwner address.
109      * @param newOwner The address to transfer ownership to.
110      */
111     function transferOwnership(address newOwner) onlyOwner public {
112         pendingOwner = newOwner;
113     }
114 
115     /**
116      * @dev Allows the pendingOwner address to finalize the transfer.
117      */
118     function claimOwnership() onlyPendingOwner public {
119         emit OwnershipTransferred(owner, pendingOwner);
120         owner = pendingOwner;
121         pendingOwner = address(0);
122     }
123 }
124 
125 // File: contracts/AllowanceSheet.sol
126 
127 // A wrapper around the allowanceOf mapping.
128 contract AllowanceSheet is Claimable {
129     using SafeMath for uint256;
130 
131     mapping(address => mapping(address => uint256)) public allowanceOf;
132 
133     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
134         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
135     }
136 
137     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
138         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
139     }
140 
141     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
142         allowanceOf[_tokenHolder][_spender] = _value;
143     }
144 }