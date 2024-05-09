1 pragma solidity 0.5.7;
2 
3 contract ERC223ReceivingContract { 
4     function tokenFallback(address _from, uint _value) public;
5 }
6 
7 contract IRC223 {
8   uint public totalSupply;
9   function balanceOf(address who) public view returns (uint);
10   
11   function name() public view returns (string memory _name);
12   function symbol() public view returns (string memory _symbol);
13   function decimals() public view returns (uint8 _decimals);
14 
15   function transfer(address to, uint value) public;
16   
17   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
18 }
19 
20 library SafeMath {
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25         uint256 c = a * b;
26         require(c / a == b);
27         return c;
28     }
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0);
31         uint256 c = a / b;
32         return c;
33     }
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b <= a);
36         uint256 c = a - b;
37         return c;
38     }
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a);
42         return c;
43     }
44     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b != 0);
46         return a % b;
47     }
48 }
49 
50 contract PIBC is IRC223 {
51     using SafeMath for uint;
52     
53     mapping(address => uint) public balances;
54     mapping(address => mapping (address => uint)) public approved;
55     mapping(address => mapping (address => uint)) public ttl;
56     string private _name;
57     string private _symbol;
58     uint8 _decimals;
59     uint public commisionRate;
60     address private _owner;
61     address private _commisioner; //0x4E911d2D6B83e4746055ccb167596bF9f2e680d2
62     event Commision(uint256 commision);
63     uint private _ttlLimit;
64     
65     constructor(address commisioner, address owner) public{
66         _name = "Pi token";
67         _symbol = "PIT";
68         _decimals = 5;
69         totalSupply = 10000000000000000000;
70         balances[owner] = totalSupply;
71         _owner = owner;
72         _commisioner = commisioner;
73         commisionRate = 10000;
74         _ttlLimit = 360;
75     }
76     
77     
78     function name() public view returns (string memory){
79         return _name;
80     }
81     function symbol() public view returns (string memory){
82         return _symbol;
83     }
84     function decimals() public view returns (uint8){
85         return _decimals;
86     }
87     
88     function _transfer(address _to, address _from, uint _value) internal{
89            require(balances[_from] >= _value);
90         uint codeLength;
91         uint256 commision;
92         bytes memory empty;
93 
94         assembly {
95             // Retrieve the size of the code on target address, this needs assembly .
96             codeLength := extcodesize(_to)
97         }
98         balances[_from] = balances[_from].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100         commision = _value.div(commisionRate);
101         balances[_from] = balances[_from].sub(commision);
102         balances[_commisioner] = balances[_commisioner].add(commision);
103         if(codeLength>0) {
104             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
105             receiver.tokenFallback(_from, _value);
106         }
107         emit Transfer(_from, _to, _value, empty);
108         emit Commision(commision);
109     }
110     
111     function transfer(address _to, uint _value) public {
112         _transfer(_to, msg.sender,_value);
113     }
114     
115     function transferFrom (address _to, address _from) public {
116         require(approved[_from][_to] > 0);
117         require(ttl[msg.sender][_to] > block.number);
118         uint _value = approved[_from][_to];
119         ttl[msg.sender][_to] = 0;
120         approved[_from][_to] = 0;
121         _transfer(_to, _from, _value);
122         
123     }
124     
125     function approve (address _to, uint _value) public{
126         require(_value <= balances[msg.sender]);
127         approved[msg.sender][_to] = approved[msg.sender][_to].add(_value);
128         ttl[msg.sender][_to] = block.number.add(_ttlLimit);
129 
130     }
131 
132     function balanceOf(address _user) public view returns (uint balance) {
133         return balances[_user];
134     }
135     
136     function setTtl(uint ttlLimit) public {
137         require(msg.sender == _owner);
138         _ttlLimit = ttlLimit;
139     }
140     
141     function setCommisionRate (uint _commisionRate) public {
142         require(msg.sender == _owner);
143         commisionRate = _commisionRate;
144     }
145     
146     function setCommisioner (address commisioner) public {
147         require(msg.sender == _owner);
148         _commisioner = commisioner;
149     }
150 }