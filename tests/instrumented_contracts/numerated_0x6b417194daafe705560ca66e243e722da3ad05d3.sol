1 pragma solidity 0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
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
33      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63      * account.
64      */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 
90 contract ERC20 {
91     function totalSupply() public view returns (uint256);
92     function balanceOf(address who) public view returns (uint256);
93     function transfer(address to, uint256 value) public returns (bool);
94     function allowance(address owner, address spender) public view returns (uint256);
95     function transferFrom(address from, address to, uint256 value) public returns (bool);
96     function approve(address spender, uint256 value) public returns (bool);
97     event Transfer(address indexed from, address indexed to, uint256 value);
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 /**
103  * @title Airdropper
104  * @author C&B
105  */
106 contract Airdropper is Ownable {
107     using SafeMath for uint;
108 
109     ERC20 public token;
110     uint public multiplier;
111 
112     /// @dev constructor
113     /// @param tokenAddress Address of token contract
114     function Airdropper(address tokenAddress, uint decimals) public {
115         require(decimals <= 77);  // 10**77 < 2**256-1 < 10**78
116 
117         token = ERC20(tokenAddress);
118         multiplier = 10**decimals;
119     }
120 
121     /// @dev Airdrops some tokens to some accounts.
122     /// @param dests List of account addresses.
123     /// @param values List of token amounts.
124     function airdrop(address source, address[] dests, uint[] values) public onlyOwner {
125         require(dests.length == values.length);
126 
127         for (uint256 i = 0; i < dests.length; i++) {
128             require(token.transferFrom(source, dests[i], values[i].mul(multiplier)));
129         }
130     }
131 
132     /// @dev Return all remaining tokens back to owner.
133     function returnTokens() public onlyOwner {
134         token.transfer(owner, token.balanceOf(this));
135     }
136 
137     function destroy() public onlyOwner {
138         selfdestruct(owner);
139     }
140 }