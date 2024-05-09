1 pragma solidity ^0.4.13;        
2    
3   contract CentraWhiteList { 
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
22       function CentraWhiteList() {
23           owner = msg.sender; 
24           operation = 0;         
25       }
26       
27       //default function for crowdfunding
28       function() payable {    
29 
30         if(!(msg.value > 0)) throw;
31         
32         operation_address[operation] = msg.sender;
33         operation_amount[operation] = msg.value;        
34         operation = operation.add(1);
35       }
36 
37       //Withdraw money from contract balance to owner
38       function withdraw() onlyOwner returns (bool result) {
39           owner.send(this.balance);
40           return true;
41       }
42       
43  }
44 
45  /**
46    * Math operations with safety checks
47    */
48   library SafeMath {
49     function mul(uint a, uint b) internal returns (uint) {
50       uint c = a * b;
51       assert(a == 0 || c / a == b);
52       return c;
53     }
54 
55     function div(uint a, uint b) internal returns (uint) {
56       // assert(b > 0); // Solidity automatically throws when dividing by 0
57       uint c = a / b;
58       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59       return c;
60     }
61 
62     function sub(uint a, uint b) internal returns (uint) {
63       assert(b <= a);
64       return a - b;
65     }
66 
67     function add(uint a, uint b) internal returns (uint) {
68       uint c = a + b;
69       assert(c >= a);
70       return c;
71     }
72 
73     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
74       return a >= b ? a : b;
75     }
76 
77     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
78       return a < b ? a : b;
79     }
80 
81     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
82       return a >= b ? a : b;
83     }
84 
85     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
86       return a < b ? a : b;
87     }
88 
89     function assert(bool assertion) internal {
90       if (!assertion) {
91         throw;
92       }
93     }
94   }