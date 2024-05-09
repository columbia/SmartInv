1 pragma solidity ^0.4.13;        
2    
3   contract CentraAsiaWhiteList { 
4  
5       using SafeMath for uint;  
6  
7       address public owner;
8       uint public operation;
9       mapping(uint => address) public operation_address;
10       mapping(uint => uint) public operation_amount; 
11       
12    
13       // Functions with this modifier can only be executed by the owner
14       modifier onlyOwner() {
15           if (msg.sender != owner) {
16               throw;
17           }
18           _;
19       }
20    
21       // Constructor
22       function CentraAsiaWhiteList() {
23           owner = msg.sender; 
24           operation = 0;         
25       }
26       
27       //default function for crowdfunding
28       function() payable {    
29  
30         if(msg.value < 0) throw;
31         if(this.balance > 47000000000000000000000) throw; // 0.1 eth
32         if(now > 1505865600)throw; // timestamp 2017.09.20 00:00:00
33         
34         operation_address[operation] = msg.sender;
35         operation_amount[operation] = msg.value;        
36         operation = operation.add(1);
37       }
38  
39       //Withdraw money from contract balance to owner
40       function withdraw() onlyOwner returns (bool result) {
41           owner.send(this.balance);
42           return true;
43       }
44       
45  }
46  
47  /**
48    * Math operations with safety checks
49    */
50   library SafeMath {
51     function mul(uint a, uint b) internal returns (uint) {
52       uint c = a * b;
53       assert(a == 0 || c / a == b);
54       return c;
55     }
56  
57     function div(uint a, uint b) internal returns (uint) {
58       // assert(b > 0); // Solidity automatically throws when dividing by 0
59       uint c = a / b;
60       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61       return c;
62     }
63  
64     function sub(uint a, uint b) internal returns (uint) {
65       assert(b <= a);
66       return a - b;
67     }
68  
69     function add(uint a, uint b) internal returns (uint) {
70       uint c = a + b;
71       assert(c >= a);
72       return c;
73     }
74  
75     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
76       return a >= b ? a : b;
77     }
78  
79     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
80       return a < b ? a : b;
81     }
82  
83     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
84       return a >= b ? a : b;
85     }
86  
87     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
88       return a < b ? a : b;
89     }
90  
91     function assert(bool assertion) internal {
92       if (!assertion) {
93         throw;
94       }
95     }
96   }