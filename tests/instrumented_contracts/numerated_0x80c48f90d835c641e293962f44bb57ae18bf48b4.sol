1 pragma solidity ^0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 
51 
52 contract GSNxPS {
53     using SafeMath for uint;
54     address   owner;    // This is the current owner of the contract.
55     mapping (address => uint) internal balance;
56     
57     // Events begin.
58     event PsExcute(address from, uint amount);
59     event GdpSentFromAccount(address from, address to, uint amount);
60     event GdpSentFromContract(address from, address to, uint amount);
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62     // Events end.
63 
64   uint public target=0;
65   uint public blockheight=0;
66   uint public fulfillmentrate=100;
67   constructor () public {  // the contract's constructor function.
68         owner = msg.sender;
69     }
70 
71 
72 
73 // Function to get Balance of the contract.
74   function getBalance() public view returns (uint256) {
75         
76         require(msg.sender == owner); // Only the Owner of this contract can run this function.
77         return address(this).balance;
78     }
79 
80 // Function to accept payment and data into the contract.
81     function acceptPs() payable public {
82         require(fulfillmentrate >=90,"fulfillment rate less than 90% , stop ps");
83         balance[address(this)]+= msg.value;  
84         emit PsExcute(msg.sender, msg.value);
85     }
86 
87 // Function to withdraw or send Ether from Contract owner's account to a specified account.
88     function TransferToGsContractFromOwnerAccount(address payable receiver, uint amount) public {
89         require(msg.sender == owner, "You're not owner of the account"); // Only the Owner of this contract can run this function.
90         require(amount < address(this).balance, "Insufficient balance.");
91         receiver.transfer(amount);
92         emit GdpSentFromAccount(msg.sender, receiver, amount);
93     }
94     
95     function transferOwnership(address newOwner) public {
96      require(msg.sender == owner, "You're not owner of the contract"); 
97      require(newOwner != address(0));
98      owner = newOwner;
99      emit OwnershipTransferred(owner, newOwner);
100    
101     }
102   
103 // function to set GSN network's blockheight
104    function SetGsnBlockHeight(uint newTarget, uint newBlockheight) public {
105         require(msg.sender == owner, "You're not owner of the account");
106         blockheight=newBlockheight;
107         target=newTarget;
108         
109    }
110    
111 // Function to get current blockheight of the gsn network.
112   function getGsnBlockheight() public view returns (uint256) {
113         return blockheight;
114     }
115 
116 // Function to get current block target of the gsn network.
117   function getGsnTarget() public view returns (uint256) {
118         return target;
119     }    
120 
121 // Function to reset fulfillment rate if it is less than 90%
122   function resetFulfillmentRate(uint rate) public{
123        require(rate>0,"invalid rate");
124        require(rate<=100,"invalid rate");
125        fulfillmentrate=rate;
126   }
127   
128   function() external payable {
129      emit PsExcute(msg.sender, msg.value);
130     // Fallback function.
131     }
132     
133  
134 
135     
136 }