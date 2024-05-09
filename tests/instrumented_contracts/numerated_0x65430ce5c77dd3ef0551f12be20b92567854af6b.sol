1 pragma solidity ^0.5.6;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 interface tokenRecipient { 
68     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
69 }
70 
71 contract Blackstone {
72     using SafeMath for uint256;
73    
74     // Defining Variables & Mapping 
75     string public name = "Blackstone";
76     string public symbol = "BLST";
77     uint256 public decimals = 0;
78     uint256 public totalSupply = 40000000;
79     
80     mapping (address => uint256) public balanceOf;
81     mapping (address => mapping (address => uint256)) public allowance;
82     
83     event Transfer (address indexed _from, address indexed _to, uint256 _value);
84     event Approval (address indexed _owner, address indexed _spender, uint256 _value);
85     event Burn (address indexed _from, uint256 _value);
86     
87     // Constructor to Deploy the ERC20 Token
88     constructor() public {
89             name;
90             symbol;
91             decimals;
92             balanceOf[msg.sender] = totalSupply;
93     }
94     
95     // Transfer Function
96     function _transfer(address _from, address _to, uint256 _value) internal {
97     	require(_from != address(0));
98     	require(_to != address(0));
99         require(balanceOf[_from] >= _value);
100         require(balanceOf[_to].add(_value) >= balanceOf[_to]);
101         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
102         
103         balanceOf[_from] = balanceOf[_from].sub(_value);
104         balanceOf[_to] = balanceOf[_to].add(_value);
105         
106         emit Transfer (_from, _to, _value);
107         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
108     }
109 
110     function transfer(address _to, uint256 _value) public returns (bool success) {
111         _transfer(msg.sender, _to, _value);
112         return true;
113     }
114     
115     // Transfer delegated Tokens
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117         require(_value <= allowance[_from][msg.sender]);
118         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
119         _transfer(_from, _to, _value);
120         return true;
121     }
122     
123     // Delegate/Approve spender a certain amount of Tokens
124     function approve(address _spender, uint256 _value) public returns (bool success) {
125         require(_spender != address(0));
126         require(balanceOf[msg.sender] >= _value);
127         require(allowance[msg.sender][_spender].add(_value) >= allowance[msg.sender][_spender]);
128         
129         allowance[msg.sender][_spender] = _value;
130         
131         emit Approval (msg.sender, _spender, _value);
132         return true;
133     }
134     
135     // Increase delegated amount
136     function increaseAllowance(address _spender, uint256 _value) public returns (bool success) {
137         require(_spender != address(0));
138         require(balanceOf[msg.sender] >= _value);
139         require(balanceOf[msg.sender] >= allowance[msg.sender][_spender].add(_value));
140         require(allowance[msg.sender][_spender].add(_value) >= allowance[msg.sender][_spender]);
141 
142         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_value);
143 
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147     
148     // Decrease delegated amount
149     function decreaseAllowance(address _spender, uint256 _value) public returns (bool success) {
150         require(_spender != address(0));
151         
152         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].sub(_value);
153         
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158     // Ping the contract about approved spender spendings
159     function approveAndCall(address _spender, uint256 _value, bytes memory _extradata) public returns (bool success) {
160         tokenRecipient spender = tokenRecipient(_spender);
161         if(approve(_spender, _value)) {
162             spender.receiveApproval(msg.sender, _value, address(this), _extradata);
163             return true;
164         }
165     }
166     
167     // Tokenburn
168     function burn(uint256 _value) public returns (bool success) {
169         require(balanceOf[msg.sender] >= _value);
170         
171         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
172         totalSupply = totalSupply.sub(_value);
173         
174         emit Burn (msg.sender, _value);
175         return true;
176     }
177     
178     function burnFrom(address _from, uint256 _value) public returns (bool success) {
179         require(_from != address(0));
180         require(balanceOf[_from] >= _value);
181         require(_value <= allowance[_from][msg.sender]);
182         
183         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
184         balanceOf[_from] = balanceOf[_from].sub(_value);
185         totalSupply = totalSupply.sub(_value);
186         
187         emit Burn (msg.sender, _value);
188         return true;
189     }
190     
191 }