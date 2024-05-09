1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28 
29 }
30 contract ERC20 {
31     uint256 public totalSupply;
32     function balanceOf(address _owner)public view returns (uint256 balance);
33     function transfer(address _to, uint256 _value)public returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);
35     function approve(address _spender, uint256 _value)public returns (bool success);
36     function allowance(address _owner, address _spender)public view returns (uint256 remaining);
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41 }
42 
43 
44 contract StdToken is ERC20,SafeMath {
45 
46     // validates an address - currently only checks that it isn't null
47     modifier validAddress(address _address) {
48         require(_address != address(0x0));
49         _;
50     }
51     bool public active=true;
52     modifier isActive(){
53       require(active==true);
54       _;
55     }
56     mapping(address => uint) balances;
57     mapping (address => mapping (address => uint)) allowed;
58 
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60 
61     function transfer(address _to, uint _value) public isActive () validAddress(_to)  returns (bool success){
62     if(balances[msg.sender]<_value)revert();
63     if(msg.sender != _to){
64         balances[msg.sender] = safeSub(balances[msg.sender], _value);
65         balances[_to] = safeAdd(balances[_to], _value);
66         emit Transfer(msg.sender, _to, _value);
67         return true;
68     }
69   }
70 
71     function transferFrom(address _from, address _to, uint256 _value)public isActive() validAddress(_to)  returns (bool success) {
72         if (_value <= 0) revert();
73         if (balances[_from] < _value) revert();
74         if (balances[_to] + _value < balances[_to]) revert();
75         if (_value > allowed[_from][msg.sender]) revert();
76         balances[_from] = safeSub(balances[_from], _value);                           
77         balances[_to] = safeAdd(balances[_to], _value);
78         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
79         emit Transfer(_from, _to, _value);
80         return true;
81     }
82 
83   function balanceOf(address _owner)public view returns (uint balance) {
84     return balances[_owner];
85   }
86 
87   function approve(address _spender, uint _value)public returns (bool success) {
88     allowed[msg.sender][_spender] = _value;
89     emit Approval(msg.sender, _spender, _value);
90     return true;
91   }
92 
93   function allowance(address _owner, address _spender)public view returns (uint remaining) {
94     return allowed[_owner][_spender];
95   }
96 }
97 
98 
99 contract Ownable {
100   address owner;
101 
102   constructor ()public {
103     owner = msg.sender;
104   }
105 
106   modifier onlyOwner() {
107     require(msg.sender == owner);
108     _;
109   }
110 
111   function transferOwnership(address newOwner)public onlyOwner {
112     if (newOwner != owner) {
113       owner = newOwner;
114     }
115   }
116 }
117 
118 
119 contract GAPi_Coin is StdToken,Ownable{
120     string public name="GAPi Coin";
121     string public symbol="GAPi";
122     uint public decimals = 18;
123 
124     constructor ()public{
125         totalSupply= 500 * (10**6) * (10**decimals);
126         balances[owner] = 500 * (10**6) * (10**decimals);
127     }    
128     function activeEnd()external onlyOwner{
129         active=false;
130     }
131     function activeStart()external onlyOwner{
132         active=true;
133     }
134     function Mint(uint _value)public onlyOwner returns(uint256){
135         if(_value>0){
136         balances[owner] = safeAdd(balances[owner],_value*(10**decimals));
137         return totalSupply;
138         }
139     }
140     function burn(uint _value)public onlyOwner returns(uint256){
141         if(_value>0 && balances[msg.sender] >= _value){
142             balances[owner] = safeSub(balances[owner],_value*(10**decimals));
143             return totalSupply;
144         }
145     }
146     function wihtdraw()public onlyOwner returns(bool success){
147         if(address(this).balance > 0){
148             msg.sender.transfer(address(this).balance);
149             return true;
150         }
151     }
152 }