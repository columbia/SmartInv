1 pragma solidity ^0.4.16;
2 
3 
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract owned {
33     address public owner;
34 
35     function owned() public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address newOwner) onlyOwner public {
45         owner = newOwner;
46     }
47 }
48 
49 
50 
51 
52 contract BDKT is owned{
53     
54     using SafeMath for uint256;
55      
56     mapping (address => uint256) internal lockMonth;
57     mapping (address => uint256) internal lockTime;
58     mapping (address => uint256) internal lockSum;
59     mapping (address => uint256) internal unlockMonth;
60     
61     string public name;
62     string public symbol;
63     uint8 public decimals = 18;
64     uint256 public totalSupply;
65 
66     mapping (address => uint256) public balanceOf;
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     function BDKT() public {
70         totalSupply = 5000000000 * 10 ** uint256(decimals);  
71         balanceOf[msg.sender] = totalSupply;                
72         name = "bidaka token";                                  
73         symbol = "BDKT";                              
74     }
75 
76     function _transfer(address _from, address _to, uint _value) internal {
77         Transfer(_from, _to, _value);
78     }
79 
80     
81     
82 
83     function transfer(address _to, uint256 _value) public {
84         _transfer(msg.sender, _to, _value);
85     }
86     
87 
88     
89    
90     
91     function batchTransfer(address[] _tos,uint256[] _amounts)  public returns (bool) {
92             require(_tos.length > 0);
93             require(_amounts.length > 0);
94             
95           for(uint32 i=0;i<_tos.length;i++){
96               _transfer(msg.sender, _tos[i],_amounts[i]* 10 ** uint256(decimals));
97           }
98           
99          return true;
100      }
101 
102 }