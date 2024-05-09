1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7  
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract SwingerToken {
51     using SafeMath for uint256;
52 
53     string public name;
54     string public symbol;
55     uint8 public decimals = 2;
56     uint256 public totalSupply;
57 
58     mapping (address => uint256) public balanceOf;
59     mapping (address => mapping (address => uint256)) public allowance;
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Burn(address indexed from, uint256 value);
63 
64     function SwingerToken() public {
65         totalSupply = 220000000 * 10 ** uint256(decimals);
66         balanceOf[msg.sender] = totalSupply;
67         name = "Swinger";
68         symbol = "SWG";
69     }
70 
71     function _transfer(address _from, address _to, uint _value) internal {
72         require(_to != 0x0);
73         require(balanceOf[_from] >= _value);
74         balanceOf[_from] = balanceOf[_from].sub(_value);
75         balanceOf[_to] = balanceOf[_to].add(_value);
76         Transfer(_from, _to, _value);
77     }
78 
79     function transfer(address _to, uint256 _value) public {
80         _transfer(msg.sender, _to, _value);
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         require(_value <= allowance[_from][msg.sender]);   
85         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
86         _transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function approve(address _spender, uint256 _value) public returns (bool success) {
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94 
95     function burn(uint256 _value) public returns (bool success) {
96         require(balanceOf[msg.sender] >= _value);   
97         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            
98         totalSupply = totalSupply.sub(_value);                      
99         Burn(msg.sender, _value);
100         return true;
101     }
102 
103     function burnFrom(address _from, uint256 _value) public returns (bool success) {
104         require(balanceOf[_from] >= _value);                
105         require(_value <= allowance[_from][msg.sender]);    
106         balanceOf[_from] = balanceOf[_from].sub(_value);                         
107         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             
108         totalSupply = totalSupply.sub(_value);                              
109         Burn(_from, _value);
110         return true;
111     }
112 }