1 pragma solidity ^0.4.19;
2 
3 /*
4 GECO TEMP
5 Version 1.01
6 Release date: 2018-11-29
7 */
8 
9 // File: zeppelin-solidity/contracts/math/SafeMath.sol
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() public {
63     owner = msg.sender;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86 }
87 
88 contract GECO is Ownable {
89   using SafeMath for uint256;
90   
91   event IncomingTransfer(address indexed to, uint256 amount);
92   event ContractFinished();
93     
94   address public wallet;
95   uint256 public endTime;
96   uint256 public totalSupply;
97   mapping(address => uint256) balances;
98   bool public contractFinished = false;
99   
100   function GECO(address _wallet, uint256 _endTime) public {
101     require(_wallet != address(0));
102     require(_endTime >= now);
103     
104     wallet = _wallet;
105     endTime = _endTime;
106   }
107   
108   function () external payable {
109     require(!contractFinished);
110     require(now <= endTime);
111       
112     totalSupply = totalSupply.add(msg.value);
113     balances[msg.sender] = balances[msg.sender].add(msg.value);
114     wallet.transfer(msg.value);
115     IncomingTransfer(msg.sender, msg.value);
116   }
117   
118   function finishContract() onlyOwner public returns (bool) {
119     contractFinished = true;
120     ContractFinished();
121     return true;
122   }
123   
124   function balanceOf(address _owner) public view returns (uint256 balance) {
125     return balances[_owner];
126   }
127   
128   function changeEndTime(uint256 _endTime) onlyOwner public {
129     endTime = _endTime;
130   }
131 }