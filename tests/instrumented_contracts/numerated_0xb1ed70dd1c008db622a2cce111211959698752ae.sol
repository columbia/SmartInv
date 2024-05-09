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
31 
32 
33 
34 contract UNGT {
35     
36     using SafeMath for uint256;
37     
38     string public name;
39     string public symbol;
40     uint8 public decimals = 8;  
41     uint256 public totalSupply;
42 
43     mapping (address => uint256) public balanceOf;
44     mapping (address => mapping (address => uint256)) public allowance;
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48     function UNGT() public {
49         totalSupply = 1000000000 * 10 ** uint256(decimals);  
50         balanceOf[msg.sender] = totalSupply;                
51         name = "Universal Green Token";                                   
52         symbol = "UNGT";                               
53     }
54 
55 
56     function _transfer(address _from, address _to, uint _value) internal {
57         require(_to != 0x0);
58         require(balanceOf[_from] >= _value);
59         require(balanceOf[_to].add(_value) > balanceOf[_to]);
60         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
61         balanceOf[_from] = balanceOf[_from].sub(_value);
62         balanceOf[_to] = balanceOf[_to].add(_value);
63         emit Transfer(_from, _to, _value);
64         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
65     }
66 
67     function transfer(address _to, uint256 _value) public returns (bool){
68         _transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
73         require(_value <= allowance[_from][msg.sender]);     
74         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
75         _transfer(_from, _to, _value);
76         return true;
77     }
78 
79     function approve(address _spender, uint256 _value) public returns (bool) {
80         require(balanceOf[msg.sender] >= _value);
81         allowance[msg.sender][_spender] = _value;
82         emit Approval(msg.sender,_spender,_value);
83         return true;
84     }
85 
86 }