1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner,"Sender not authorized");
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner {
68     require(newOwner != address(0));
69     emit OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 contract ERC20Interface {
76      function totalSupply() public constant returns (uint);
77      function balanceOf(address tokenOwner) public constant returns (uint balance);
78      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
79      function transfer(address to, uint tokens) public returns (bool success);
80      function approve(address spender, uint tokens) public returns (bool success);
81      function transferFrom(address from, address to, uint tokens) public returns (bool success);
82      event Transfer(address indexed from, address indexed to, uint tokens);
83      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
84 }
85 contract DankTokenAD is Ownable{
86     
87   // The token being sold
88   ERC20Interface public token;
89 
90   
91   mapping(address=>bool) airdroppedTo;
92   uint public TOTAL_AIRDROPPED_TOKENS;
93   uint public Airdrop_Limit;
94   
95   /**
96    * event for token purchase logging
97    * @param purchaser who paid for the tokens
98    * @param beneficiary who got the tokens
99    * @param value weis paid for purchase
100    * @param amount amount of tokens purchased
101    */
102   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
103 
104   constructor(address _wallet, address _tokenAddress) public 
105   {
106     require(_wallet != 0x0);
107     require (_tokenAddress != 0x0);
108     owner = _wallet;
109     token = ERC20Interface(_tokenAddress);
110     TOTAL_AIRDROPPED_TOKENS = 0;
111     //Airdrop_Limit=100000000*10**18;
112   }
113   
114   // fallback function can be used to buy tokens
115   function () public payable {
116     revert();
117   }
118 
119     /**
120      * airdrop to token holders
121      **/ 
122     function BulkTransfer(address[] tokenHolders, uint[] amount) public onlyOwner {
123        // require (TOTAL_AIRDROPPED_TOKENS<=Airdrop_Limit);
124         for(uint i = 0; i<tokenHolders.length; i++)
125         {
126             if (!airdroppedTo[tokenHolders[i]])
127             {
128                 token.transferFrom(owner,tokenHolders[i],amount[i]);
129                 airdroppedTo[tokenHolders[i]] = true;
130                 TOTAL_AIRDROPPED_TOKENS += amount[i];
131             }
132         }
133     }
134 }