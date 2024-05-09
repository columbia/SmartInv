1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev modifier to allow actions only when the contract IS paused
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev modifier to allow actions only when the contract IS NOT paused
66    */
67   modifier whenPaused {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused returns (bool) {
76     paused = true;
77     Pause();
78     return true;
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused returns (bool) {
85     paused = false;
86     Unpause();
87     return true;
88   }
89 }
90 
91 contract ERC20{
92 
93 bool public isERC20 = true;
94 
95 function balanceOf(address who) constant returns (uint256);
96 
97 function transfer(address _to, uint256 _value) returns (bool);
98 
99 function transferFrom(address _from, address _to, uint256 _value) returns (bool);
100 
101 function approve(address _spender, uint256 _value) returns (bool);
102 
103 function allowance(address _owner, address _spender) constant returns (uint256);
104 
105 }
106 
107 
108 
109 contract Candy is Pausable {
110   ERC20 public erc20;
111   //uint256 public candy;
112 
113   function Candy(address _address){
114         ERC20 candidateContract = ERC20(_address);
115         require(candidateContract.isERC20());
116         erc20 = candidateContract;
117   }	
118   
119   function() external payable {
120         require(
121             msg.sender != address(0)
122         );
123       erc20.transfer(msg.sender,uint256(5000000000000000000)); 
124       //THX! This donation will drive us. 
125       //Each sender can only get 5 BUN per time.
126   }
127   
128   function withdrawBalance() external onlyOwner {
129         owner.transfer(this.balance);
130   }
131 }