1 pragma solidity ^ 0.5.0;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract FAECERC20 {
28 		using SafeMath for uint256;
29     string public name;
30     string public symbol;
31     uint8 public decimals = 18; 
32     uint256 public totalSupply;
33 
34     mapping(address => uint256) public balanceOf;
35     mapping(address => mapping(address => uint256)) public allowance;
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Burn(address indexed from, uint256 value);
39 
40     constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
41         totalSupply = initialSupply * 10 ** uint256(decimals);
42         balanceOf[msg.sender] = totalSupply;
43         name = tokenName; 
44         symbol = tokenSymbol;
45     }
46 
47     function _transfer(address _from, address _to, uint _value) internal {
48         require(_to != address(0));
49         require(balanceOf[_from] >= _value);
50         require(balanceOf[_to] + _value > balanceOf[_to]);
51 
52         uint previousBalances = balanceOf[_from] + balanceOf[_to];
53 
54         balanceOf[_from] -= _value;
55 
56         balanceOf[_to] += _value;
57         emit Transfer(_from, _to, _value);
58 
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
67         require(_value <= allowance[_from][msg.sender]); 
68         allowance[_from][msg.sender] -= _value;
69         _transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function approve(address _spender, uint256 _value) public
74     returns(bool success) {
75         allowance[msg.sender][_spender] = _value;
76         return true;
77     }
78 
79     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
80     public
81     returns(bool success) {
82         if (approve(_spender, _value)) {
83             _spender.call(abi.encodeWithSelector(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")),msg.sender, _value, this, _extraData));
84              return true;
85         }
86         else
87             return false;
88     }
89 
90     function burn(uint256 _value) public returns(bool success) {
91         require(balanceOf[msg.sender] >= _value); 
92         balanceOf[msg.sender] -= _value; 
93         totalSupply -= _value; 
94         emit Burn(msg.sender, _value);
95         return true;
96     }
97 
98     function burnFrom(address _from, uint256 _value) public returns(bool success) {
99         require(balanceOf[_from] >= _value); 
100         require(_value <= allowance[_from][msg.sender]); 
101         balanceOf[_from] -= _value; 
102         allowance[_from][msg.sender] -= _value; 
103         totalSupply -= _value; 
104         emit Burn(_from, _value);
105         return true;
106     }
107 }