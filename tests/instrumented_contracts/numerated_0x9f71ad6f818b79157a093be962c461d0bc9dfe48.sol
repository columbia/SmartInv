1 pragma solidity ^0.4.20;
2 
3 contract ERC20Interface {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardToken is ERC20Interface {
15 
16     function transfer(address _to, uint256 _value) returns (bool success) {
17         if (balances[msg.sender] >= _value && _value > 0) {
18             balances[msg.sender] -= _value;
19             balances[_to] += _value;
20             Transfer(msg.sender, _to, _value);
21             return true;
22         } else { return false; }
23     }
24 
25     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
26         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
27             balances[_to] += _value;
28             balances[_from] -= _value;
29             allowed[_from][msg.sender] -= _value;
30             Transfer(_from, _to, _value);
31             return true;
32         } else { return false; }
33     }
34 
35     function balanceOf(address _owner) constant returns (uint256 balance) {
36         return balances[_owner];
37     }
38 
39     function approve(address _spender, uint256 _value) returns (bool success) {
40         allowed[msg.sender][_spender] = _value;
41         Approval(msg.sender, _spender, _value);
42         return true;
43     }
44 
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
46       return allowed[_owner][_spender];
47     }
48 
49     mapping (address => uint256) balances;
50     mapping (address => mapping (address => uint256)) allowed;
51     uint256 public totalSupply;
52 }
53 
54 contract SafeMath {
55     function mul(uint a, uint b) internal pure returns (uint) {
56         uint c = a * b;
57         assert(a == 0 || c / a == b);
58         return c;
59     }
60 
61     function div(uint a, uint b) internal pure returns (uint) {
62         assert(b > 0);
63         uint c = a / b;
64         assert(a == b * c + a % b);
65         return c;
66     }
67 
68     function sub(uint a, uint b) internal pure returns (uint) {
69         assert(b <= a);
70         return a - b;
71     }
72 
73     function add(uint a, uint b) internal pure returns (uint) {
74         uint c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 
79     function pow(uint a, uint b) internal pure returns (uint) {
80         uint c = a ** b;
81         assert(c >= a);
82         return c;
83     }
84 }
85 
86 contract Ownable {
87   address public ownerWallet;
88 
89   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91   function Ownable() public {
92     ownerWallet = msg.sender;
93   }
94 
95   modifier onlyOwner() {
96     require(msg.sender == ownerWallet);
97     _;
98   }
99 
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     OwnershipTransferred(ownerWallet, newOwner);
103     ownerWallet = newOwner;
104   }
105 
106 }
107 
108 contract Token is StandardToken, SafeMath, Ownable {
109 
110     function withDecimals(uint number, uint decimals)
111         internal
112         pure
113         returns (uint)
114     {
115         return mul(number, pow(10, decimals));
116     }
117 
118 }
119 
120 contract Apen is Token {
121 
122     string public name;                   
123     uint8 public decimals;                
124     string public symbol;                 
125     string public version = 'A1.1'; 
126     uint256 public unitsPerEth;     
127     uint256 public maxApenSell;         
128     uint256 public totalEthPos;  
129     address public ownerWallet;           
130 
131     function Apen() public {
132         decimals = 18;   
133         totalSupply = withDecimals(21000000, decimals); 
134         balances[msg.sender] = totalSupply;  
135         maxApenSell = div(totalSupply, 2);         
136         name = "Apen";                                             
137         symbol = "APEN";                                 
138         unitsPerEth = 1000;                           
139     }
140 
141     function() public payable{
142         
143         uint256 amount = mul(msg.value, unitsPerEth);
144         require(balances[ownerWallet] >= amount);
145         require(balances[ownerWallet] >= maxApenSell);
146 
147         balances[ownerWallet] = sub(balances[ownerWallet], amount);
148         maxApenSell = sub(maxApenSell, amount);
149         balances[msg.sender] = add(balances[msg.sender], amount);
150 
151         Transfer(ownerWallet, msg.sender, amount);
152 
153         totalEthPos = add(totalEthPos, msg.value);
154 
155         ownerWallet.transfer(msg.value);                               
156     }
157 
158     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
159         allowed[msg.sender][_spender] = _value;
160         Approval(msg.sender, _spender, _value);
161         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
162         return true;
163     }
164 
165 }