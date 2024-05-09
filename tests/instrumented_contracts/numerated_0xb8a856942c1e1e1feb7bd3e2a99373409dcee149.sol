1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     function Owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public returns (bool){
18         require(newOwner != 0x0);
19         OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21         return true;
22     }
23 }
24 
25 library SafeMath {
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     require(a >= b);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     require(c >= a);
34     return c;
35   }
36 }
37 
38 contract tokenRecipient {
39     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
40 }
41 
42 contract ERC20 {
43     using SafeMath for uint256;
44 
45     string public name;
46     string public symbol;
47     uint8 public decimals;
48     uint256 public totalSupply;
49 
50     mapping (address => uint256) public balanceOf;
51     mapping (address => mapping (address => uint256)) public allowance;
52 
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 
56     function ERC20(
57         uint256 initialSupply
58     ) public {
59         totalSupply = initialSupply;
60         balanceOf[msg.sender] = totalSupply;
61         Transfer(0x0, msg.sender, totalSupply);
62     }
63 
64     function _transfer(address _from, address _to, uint _value) internal returns (bool){
65         require(_to != 0x0);
66         balanceOf[_from] = balanceOf[_from].sub(_value);
67         balanceOf[_to] = balanceOf[_to].add(_value);
68         Transfer(_from, _to, _value);
69 	    return true;
70     }
71 
72     function transfer(address _to, uint256 _value) public returns (bool){
73         _transfer(msg.sender, _to, _value);
74 	    return true;
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
78         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
79         _transfer(_from, _to, _value);
80 	    return true;
81     }
82 
83     function approve(address _spender, uint256 _value) public returns (bool){
84         allowance[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool){
90         tokenRecipient spender = tokenRecipient(_spender);
91         if (approve(_spender, _value)) {
92             spender.receiveApproval(msg.sender, _value, this, _extraData);
93 	        return true;
94         }
95     }
96 }
97 
98 contract EPVToken is Owned, ERC20 {
99 
100     string public name = "EPVToken";
101     string public symbol = "EPV";
102     uint8 public decimals = 18;
103     uint256 public INITIAL_SUPPLY = 100000000000 * (10 ** uint256(decimals));
104 
105     function EPVToken() ERC20(INITIAL_SUPPLY) public {}
106 
107     function () payable public {
108 
109     }
110 
111     function backToken(address _to, uint256 _value) onlyOwner public returns (bool){
112         _transfer(this, _to, _value);
113 	    return true;
114     }
115 
116     function backTransfer(address _to, uint256 _value) onlyOwner public returns (bool){
117         require(_to != 0x0);
118         require(address(this).balance >= _value);
119         _to.transfer(_value);
120 	    return true;
121     }
122 }