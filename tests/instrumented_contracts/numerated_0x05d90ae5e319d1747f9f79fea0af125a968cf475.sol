1 pragma solidity 0.4.18;
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
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 
103 /**
104  * @title Airdropper
105  * @author C&B
106  */
107 contract Airdropper is Ownable {
108     using SafeMath for uint;
109 
110     ERC20Basic public token;
111     uint public multiplier;
112 
113     /// @dev constructor
114     /// @param tokenAddress Address of token contract
115     function Airdropper(address tokenAddress, uint decimals) public {
116         require(decimals <= 77);  // 10**77 < 2**256-1 < 10**78
117 
118         token = ERC20Basic(tokenAddress);
119         multiplier = 10**decimals;
120     }
121 
122     /// @dev Airdrops some tokens to some accounts.
123     /// @param dests List of account addresses.
124     /// @param values List of token amounts.
125     function airdrop(address[] dests, uint[] values) public onlyOwner {
126         require(dests.length == values.length);
127 
128         for (uint256 i = 0; i < dests.length; i++) {
129             token.transfer(dests[i], values[i].mul(multiplier));
130         }
131     }
132 
133     /// @dev Return all remaining tokens back to owner.
134     function returnTokens() public onlyOwner {
135         token.transfer(owner, token.balanceOf(this));
136     }
137 }