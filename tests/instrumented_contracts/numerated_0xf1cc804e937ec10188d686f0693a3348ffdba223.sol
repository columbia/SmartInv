1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two numbers, throws on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         if (a == 0) {
9             return 0;
10         }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     /**
17     * @dev Integer division of two numbers, truncating the quotient.
18     */
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         // uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return a / b;
24     }
25 
26     /**
27     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28     */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     /**
35     * @dev Adds two numbers, throws on overflow.
36     */
37     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
38         c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 contract Ownable {
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     constructor () public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     function transferOwnership(address newOwner) onlyOwner public {
59         require(newOwner != address(0));
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62     }
63 }
64 
65 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;}
66 
67 contract TokenERC20 {
68     using SafeMath for uint256;
69 
70     string public name;
71     string public symbol;
72     uint8 public decimals = 18;
73     uint256 public totalSupply;
74 
75     mapping(address => uint256) public balanceOf;
76     mapping(address => mapping(address => uint256)) public allowance;
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     constructor (
81         uint256 initialSupply,
82         string tokenName,
83         string tokenSymbol
84     ) public {
85         totalSupply = initialSupply * 10 ** uint256(decimals);
86         balanceOf[msg.sender] = totalSupply;
87         name = tokenName;
88         symbol = tokenSymbol;
89     }
90 
91     function _transfer(address _from, address _to, uint _value) internal {
92         require(_to != 0x0);
93         require(balanceOf[_from] >= _value && _value > 0);
94         require(balanceOf[_to] + _value > balanceOf[_to]);
95         uint previousBalances = balanceOf[_from] + balanceOf[_to];
96         balanceOf[_from] = balanceOf[_from].sub(_value);
97         balanceOf[_to] = balanceOf[_to].add(_value);
98         emit Transfer(_from, _to, _value);
99         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
100     }
101 
102     function transfer(address _to, uint256 _value) public returns (bool success) {
103         _transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     function batchTransfer(address[] _to, uint _value) public returns (bool success) {
108         require(_to.length > 0 && _to.length <= 20);
109         for (uint i = 0; i < _to.length; i++) {
110             _transfer(msg.sender, _to[i], _value);
111         }
112         return true;
113     }
114 
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
116         require(_value <= allowance[_from][msg.sender]);
117         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
118         _transfer(_from, _to, _value);
119         return true;
120     }
121 
122     function approve(address _spender, uint256 _value) public returns (bool success) {
123         allowance[msg.sender][_spender] = _value;
124         return true;
125     }
126 
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
128         tokenRecipient spender = tokenRecipient(_spender);
129         if (approve(_spender, _value)) {
130             spender.receiveApproval(msg.sender, _value, this, _extraData);
131             return true;
132         }
133     }
134 }
135 
136 contract YCBToken is Ownable, TokenERC20 {
137     constructor (
138         uint256 initialSupply,
139         string tokenName,
140         string tokenSymbol
141     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
142 }