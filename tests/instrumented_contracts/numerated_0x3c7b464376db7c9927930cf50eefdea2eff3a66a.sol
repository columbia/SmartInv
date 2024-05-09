1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-11
3 */
4 
5 pragma solidity ^0.4.16;
6 
7 contract owned {
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) public onlyOwner {
20         owner = newOwner;
21     }
22 }
23 
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     if (a == 0) {
27       return 0;
28     }
29     uint256 c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a / b;
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 contract USDA is owned{
53     
54     using SafeMath for uint256;
55     
56     string public name;
57     string public symbol;
58     uint8 public decimals = 8;  
59     uint256 public totalSupply;
60 
61     mapping (address => uint256) public balanceOf;
62     mapping (address => mapping (address => uint256)) public allowance;
63     
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66     event Lock(address indexed ac, uint256 value, uint256 time);
67     event Burn(uint256 amount);
68     
69     constructor() public {
70         totalSupply = 100000 * 10 ** uint256(decimals);  
71         balanceOf[msg.sender] = totalSupply;                
72         name = "USDA";                                   
73         symbol = "USDA";                               
74     }
75 
76     function _transfer(address _from, address _to, uint _value) internal {
77         require(balanceOf[_from] >= _value);
78         require(balanceOf[_to].add(_value) > balanceOf[_to]);
79         balanceOf[_from] = balanceOf[_from].sub(_value);
80         balanceOf[_to] = balanceOf[_to].add(_value);
81         emit Transfer(_from, _to, _value);
82     }
83 
84     function transfer(address _to, uint256 _value) public returns (bool){
85         _transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90         require(_value <= allowance[_from][msg.sender]);     
91         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
92         _transfer(_from, _to, _value);
93         return true;
94     }
95 
96     function approve(address _spender, uint256 _value) public returns (bool) {
97         require(balanceOf[msg.sender] >= _value);
98         allowance[msg.sender][_spender] = _value;
99         emit Approval(msg.sender,_spender,_value);
100         return true;
101     }
102     
103     function mintToken(uint256 mintedAmount) external onlyOwner {
104         require(totalSupply + mintedAmount > totalSupply);
105         require(balanceOf[owner] + mintedAmount > balanceOf[owner]);
106         balanceOf[owner] += mintedAmount;
107         totalSupply += mintedAmount;
108         emit Transfer(address(0), owner, mintedAmount);
109     }
110     
111     function burn (uint256 amount) external onlyOwner {
112         require(balanceOf[msg.sender] >= amount);
113         require(totalSupply >= amount);
114         totalSupply -= amount;
115         balanceOf[msg.sender] -= amount;
116         emit Burn(amount);
117     }
118 
119 }