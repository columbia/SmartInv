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
33 contract ETFW{
34     
35     using SafeMath for uint256;
36     string public name;
37     string public symbol;
38     uint8 public decimals = 4;  
39     uint256 public totalSupply;
40 
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
45 
46     function ETFW() public {
47         totalSupply = 100000000 * 10 ** uint256(decimals);  
48         balanceOf[msg.sender] = totalSupply;                
49         name = "Ether Future Wins";                                   
50         symbol = "ETFW";                               
51     }
52 
53 
54     function _transfer(address _from, address _to, uint _value) internal {
55         require(_to != 0x0);
56         require(balanceOf[_from] >= _value);
57         require(balanceOf[_to].add(_value) > balanceOf[_to]);
58         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
59         balanceOf[_from] = balanceOf[_from].sub(_value);
60         balanceOf[_to] = balanceOf[_to].add(_value);
61         emit Transfer(_from, _to, _value);
62         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
63     }
64 
65     function transfer(address _to, uint256 _value) public returns (bool){
66         _transfer(msg.sender, _to, _value);
67         return true;
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
71         require(_value <= allowance[_from][msg.sender]);     
72         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
73         _transfer(_from, _to, _value);
74         return true;
75     }
76 
77     function approve(address _spender, uint256 _value) public returns (bool) {
78         require(balanceOf[msg.sender] >= _value);
79         allowance[msg.sender][_spender] = _value;
80         emit Approval(msg.sender,_spender,_value);
81         return true;
82     }
83 
84 }