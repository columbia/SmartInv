1 pragma solidity ^0.4.16;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract owned {
32     address public owner;
33 
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         owner = newOwner;
45     }
46 }
47 
48 contract KM is owned{
49     
50     using SafeMath for uint256;
51     
52     string public name;
53     string public symbol;
54     uint8 public decimals = 18;  
55     uint256 public totalSupply;
56 
57     mapping (address => uint256) public balanceOf;
58     mapping (address => mapping (address => uint256)) public allowance;
59     
60     mapping (address => uint256) public lockValue;
61     mapping (address => uint256) public lockTime;
62     
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
65     event Lock(address indexed ac, uint256 value, uint256 time);
66     
67     constructor() public {
68         totalSupply = 100000000 * 10 ** uint256(decimals);  
69         balanceOf[msg.sender] = totalSupply;                
70         name = "KinMall";                                   
71         symbol = "KM";                               
72     }
73 
74 
75     function _transfer(address _from, address _to, uint _value) internal {
76         require(balanceOf[_from] >= _value);
77         require(balanceOf[_to].add(_value) > balanceOf[_to]);
78         if (lockValue[_from] > 0){
79             if(now < lockTime[_from]){
80                 require(balanceOf[_from] - _value >= lockValue[_from]);
81             } else {
82                 delete lockValue[_to];
83                 delete lockTime[_to];
84             }
85         }
86         balanceOf[_from] = balanceOf[_from].sub(_value);
87         balanceOf[_to] = balanceOf[_to].add(_value);
88         emit Transfer(_from, _to, _value);
89     }
90 
91     function transfer(address _to, uint256 _value) public returns (bool){
92         _transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
97         require(_value <= allowance[_from][msg.sender]);     
98         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
99         _transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function approve(address _spender, uint256 _value) public returns (bool) {
104         require(balanceOf[msg.sender] >= _value);
105         allowance[msg.sender][_spender] = _value;
106         emit Approval(msg.sender,_spender,_value);
107         return true;
108     }
109     
110     function lock (address _to, uint256 _value, uint256 _time) public onlyOwner {
111         require(balanceOf[_to] >= _value);
112         lockValue[_to] = _value;
113         lockTime[_to] = _time;
114         emit Lock(_to, _value, _time);
115     }
116     
117     function unlock (address _to) public onlyOwner {
118         delete lockValue[_to];
119         delete lockTime[_to];
120     }
121 
122 }