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
49 contract BDKT is owned{
50     
51     using SafeMath for uint256;
52      
53     mapping (address => uint256) internal lockMonth;
54     mapping (address => uint256) internal lockTime;
55     mapping (address => uint256) internal lockSum;
56     mapping (address => uint256) internal unlockMonth;
57     
58     string public name;
59     string public symbol;
60     uint8 public decimals = 18;
61     uint256 public totalSupply;
62 
63     mapping (address => uint256) public balanceOf;
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     function BDKT() public {
67         totalSupply = 5000000000 * 10 ** uint256(decimals);  
68         balanceOf[msg.sender] = totalSupply;                
69         name = "bidaka token";                                  
70         symbol = "BDKT";                              
71     }
72 
73     function _transfer(address _from, address _to, uint _value) internal {
74         require(_to != 0x0);
75         require(balanceOf[_from] >= _value);
76         require(balanceOf[_to].add(_value)> balanceOf[_to]);
77             
78         balanceOf[_from] = balanceOf[_from].sub(_value);
79         balanceOf[_to] = balanceOf[_to].add(_value);
80         Transfer(_from, _to, _value);
81     }
82 
83     function transfer(address _to, uint256 _value) public {
84         _transfer(msg.sender, _to, _value);
85     }
86     
87     function batchTransfer(address[] _tos,uint256[] _amounts)  public returns (bool) {
88             require(_tos.length > 0);
89             require(_amounts.length > 0);
90             
91           for(uint32 i=0;i<_tos.length;i++){
92               _transfer(msg.sender, _tos[i],_amounts[i]* 10 ** uint256(decimals));
93           }
94           
95          return true;
96      }
97 
98 }