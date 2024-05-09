1 // pragma solidity >=0.4.22 <0.6.0;
2 pragma solidity  ^0.5.8;
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7         return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 interface tokenRecipient { 
28     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
29 }
30 
31 contract Base {
32     using SafeMath for uint256;
33 
34     address public owner;
35 
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     function setOwner(address _newOwner)  external  onlyOwner {
42         require(_newOwner != address(0x0));
43         owner = _newOwner;
44     }
45 
46     bool public IsStopped = false;
47 
48     function setStop(bool isStop) external onlyOwner {
49         IsStopped = isStop;
50     }
51 
52     modifier onlyNoStopped {
53         require(!IsStopped);
54         _;
55     }
56 
57 }
58 
59 contract TokenERC20 is Base {
60     string public name;
61     string public symbol;
62     uint8 public decimals = 6;//18;
63     uint256 public totalSupply;
64 
65     mapping (address => uint256) public balanceOf;
66     mapping (address => mapping (address => uint256)) public allowance;
67 
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70     event Burn(address indexed from, uint256 value);
71      
72     //Fix for short address attack against ERC20
73 	modifier onlyPayloadSize(uint size) {
74 		assert(msg.data.length == size + 4);
75 		_;
76 	}
77 
78     function _transfer(address _from, address _to, uint _value) internal onlyNoStopped returns (bool success) {
79         require(_to != address(0x0));
80         require(balanceOf[_from] >= _value);
81         balanceOf[_from] = balanceOf[_from].sub(_value);
82         balanceOf[_to] = balanceOf[_to].add(_value);
83         emit Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function transfer(address _to, uint256 _value)  onlyPayloadSize(2*32) public returns (bool success) {
88         _transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         require(_value <= allowance[_from][msg.sender]);     // Check allowance
94         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
95         _transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function approve(address _spender, uint256 _value) onlyPayloadSize(2*32) public returns (bool success) {
100         allowance[msg.sender][_spender] = _value;
101         emit Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 
105     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) 
106     {
107         tokenRecipient spender = tokenRecipient(_spender);
108         if (approve(_spender, _value)) {
109             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
110             return true;
111         }
112     }
113 
114     function burn(uint256 _value) public returns (bool success) {
115         require(balanceOf[msg.sender] >= _value);                               // Check if the sender has enough
116         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);              // Subtract from the sender
117         totalSupply = totalSupply.sub(_value);                                  // Updates totalSupply
118         emit Burn(msg.sender, _value);
119         return true;
120     }
121 
122     function burnFrom(address _from, uint256 _value) public returns (bool success) {
123         require(1 == 2);
124         emit Burn(_from, _value);
125         return false;
126     }
127 }
128 
129 
130 contract TokenFC is TokenERC20 {
131     
132     constructor(address _owner) public {
133         require(_owner != address(0x0));
134         owner = _owner;
135         
136         totalSupply = 200000000 * 10 ** uint256(decimals);     // Update total supply with the decimal amount
137         balanceOf[owner] = totalSupply;
138 
139         name = "FCToken";                                 // Set the name for display purposes
140         symbol = "FC";                                         // Set the symbol for display purposes
141     }
142 
143     
144     function batchTransfer1(address[] calldata _tos, uint256 _amount) external  {
145         require(_batchTransfer1(msg.sender, _tos, _amount));
146     }
147 
148     function _batchTransfer1(address _from, address[] memory _tos, uint256 _amount) internal returns (bool _result) {
149         require(_amount > 0);
150         require(_tos.length > 0);
151         for(uint i = 0; i < _tos.length; i++){
152             address to = _tos[i];
153             require(to != address(0x0));
154             require(_transfer(_from, to, _amount));
155         }
156         _result = true;
157     }
158 
159     function batchTransfer2(address[] calldata _tos, uint256[] calldata _amounts) external  {
160         require(_batchTransfer2(msg.sender, _tos, _amounts));
161     }
162 
163     function _batchTransfer2(address _from, address[] memory _tos, uint256[] memory _amounts) internal returns (bool _result)  {
164         require(_amounts.length > 0);
165         require(_tos.length > 0);
166         require(_amounts.length == _tos.length );
167         for(uint i = 0; i < _tos.length; i++){
168             require(_tos[i] != address(0x0) && _amounts[i] > 0);
169             require(_transfer(_from, _tos[i], _amounts[i]));
170         }
171         _result = true;
172     }
173      
174     function() payable external {
175         // require(1 == 2);    //selfdestruct(_to);
176     }
177 
178 }