1 pragma solidity ^0.4.24;
2 
3 /**
4  * Changes by https://www.docademic.com/
5  */
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 }
43 
44 /**
45  * Changes by https://www.docademic.com/
46  */
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 contract Destroyable is Ownable{
82     /**
83      * @notice Allows to destroy the contract and return the tokens to the owner.
84      */
85     function destroy() public onlyOwner{
86         selfdestruct(owner);
87     }
88 }
89 
90 interface Token {
91     function transfer(address _to, uint256 _value) external returns (bool);
92     function balanceOf(address who) view external returns (uint256);
93 }
94 
95 contract MTCMultiTransfer is Ownable, Destroyable {
96     using SafeMath for uint256;
97 
98     event Dropped(uint256 transfers, uint256 amount);
99 
100     Token public token;
101     uint256 public totalDropped;
102 
103     constructor(address _token) public{
104         require(_token != address(0));
105         token = Token(_token);
106         totalDropped = 0;
107     }
108 
109     function airdropTokens(address[] _recipients, uint256[] _balances) public
110     onlyOwner {
111         require(_recipients.length == _balances.length);
112 
113         uint airDropped = 0;
114         for (uint256 i = 0; i < _recipients.length; i++)
115         {
116             require(token.transfer(_recipients[i], _balances[i]));
117             airDropped = airDropped.add(_balances[i]);
118         }
119 
120         totalDropped = totalDropped.add(airDropped);
121         emit Dropped(_recipients.length, airDropped);
122     }
123 
124     /**
125      * @dev Get the remain MTC on the contract.
126      */
127     function Balance() view public returns (uint256) {
128         return token.balanceOf(address(this));
129     }
130 
131     /**
132          * @notice Allows the owner to flush the eth.
133          */
134     function flushEth() public onlyOwner {
135         owner.transfer(address(this).balance);
136     }
137 
138     /**
139      * @notice Allows the owner to destroy the contract and return the tokens to the owner.
140      */
141     function destroy() public onlyOwner {
142         token.transfer(owner, token.balanceOf(this));
143         selfdestruct(owner);
144     }
145 
146 }