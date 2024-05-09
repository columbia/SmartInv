1 pragma solidity ^0.4.16;        
2    
3   contract CentraSale { 
4 
5     using SafeMath for uint; 
6 
7     address public contract_address = 0x96a65609a7b84e8842732deb08f56c3e21ac6f8a; 
8 
9     address public owner;    
10     uint public constant min_value = 10**18*1/10;     
11 
12     uint256 public constant token_price = 1481481481481481;  
13     uint256 public tokens_total;  
14    
15     // Functions with this modifier can only be executed by the owner
16     modifier onlyOwner() {
17         if (msg.sender != owner) {
18             throw;
19         }
20         _;
21     }      
22  
23     // Constructor
24     function CentraSale() {
25         owner = msg.sender;                         
26     }
27       
28     //default function for crowdfunding
29     function() payable {    
30 
31       if(!(msg.value >= min_value)) throw;                                 
32 
33       tokens_total = msg.value*10**18/token_price;
34       if(!(tokens_total > 0)) throw;           
35 
36       if(!contract_transfer(tokens_total)) throw;
37       owner.send(this.balance);
38     }
39 
40     //Contract execute
41     function contract_transfer(uint _amount) private returns (bool) {      
42 
43       if(!contract_address.call(bytes4(sha3("transfer(address,uint256)")),msg.sender,_amount)) {    
44         return false;
45       }
46       return true;
47     }     
48 
49     //Withdraw money from contract balance to owner
50     function withdraw() onlyOwner returns (bool result) {
51         owner.send(this.balance);
52         return true;
53     }    
54       
55  }
56 
57  /**
58    * Math operations with safety checks
59    */
60   library SafeMath {
61     function mul(uint a, uint b) internal returns (uint) {
62       uint c = a * b;
63       assert(a == 0 || c / a == b);
64       return c;
65     }
66 
67     function div(uint a, uint b) internal returns (uint) {
68       // assert(b > 0); // Solidity automatically throws when dividing by 0
69       uint c = a / b;
70       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71       return c;
72     }
73 
74     function sub(uint a, uint b) internal returns (uint) {
75       assert(b <= a);
76       return a - b;
77     }
78 
79     function add(uint a, uint b) internal returns (uint) {
80       uint c = a + b;
81       assert(c >= a);
82       return c;
83     }
84 
85     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
86       return a >= b ? a : b;
87     }
88 
89     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
90       return a < b ? a : b;
91     }
92 
93     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
94       return a >= b ? a : b;
95     }
96 
97     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
98       return a < b ? a : b;
99     }
100 
101     function assert(bool assertion) internal {
102       if (!assertion) {
103         throw;
104       }
105     }
106   }