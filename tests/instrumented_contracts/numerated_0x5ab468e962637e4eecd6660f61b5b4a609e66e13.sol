1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract FTWToken {
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
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Burn(address indexed from, uint256 value);
62 
63     function FTWToken() public {
64         totalSupply = 1000000000 * 10 ** uint256(decimals);
65         balanceOf[msg.sender] = totalSupply;
66         name = "FutureWorks";
67         symbol = "FTW";
68     }
69 
70     function _transfer(address _from, address _to, uint _value) internal {
71         require(_to != 0x0);
72         require(balanceOf[_from] >= _value);
73         balanceOf[_from] = balanceOf[_from].sub(_value);
74         balanceOf[_to] = balanceOf[_to].add(_value);
75         Transfer(_from, _to, _value);
76     }
77 
78     function transfer(address _to, uint256 _value) public {
79         _transfer(msg.sender, _to, _value);
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         require(_value <= allowance[_from][msg.sender]);   
84         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
85         _transfer(_from, _to, _value);
86         return true;
87     }
88 
89     function approve(address _spender, uint256 _value) public returns (bool success) {
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93 
94     function burn(uint256 _value) public returns (bool success) {
95         require(balanceOf[msg.sender] >= _value);   
96         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            
97         totalSupply = totalSupply.sub(_value);                      
98         Burn(msg.sender, _value);
99         return true;
100     }
101 
102     function burnFrom(address _from, uint256 _value) public returns (bool success) {
103         require(balanceOf[_from] >= _value);                
104         require(_value <= allowance[_from][msg.sender]);    
105         balanceOf[_from] = balanceOf[_from].sub(_value);                         
106         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             
107         totalSupply = totalSupply.sub(_value);                              
108         Burn(_from, _value);
109         return true;
110     }
111 }