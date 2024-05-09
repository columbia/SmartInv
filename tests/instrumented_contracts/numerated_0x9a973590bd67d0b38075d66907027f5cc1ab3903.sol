1 pragma solidity ^0.4.18;
2 contract Ownable {
3   address public owner;
4   function Ownable() public {
5     owner = msg.sender;
6   }
7   modifier onlyOwner() {
8     require(msg.sender == owner);
9     _;
10   }
11   function transferOwnership(address newOwner) onlyOwner public {
12         owner = newOwner;
13   }
14 }
15 interface TransferRecipient {
16 	function tokenFallback(address _from, uint256 _value, bytes _extraData) public returns(bool);
17 }
18 
19 interface ApprovalRecipient {
20 	function approvalFallback(address _from, uint256 _value, bytes _extraData) public returns(bool);
21 }
22 contract ERCToken {
23 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
24 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 	uint256 public  totalSupply;
26 	mapping (address => uint256) public balanceOf;
27 
28 	function allowance(address _owner,address _spender) public view returns(uint256);
29 	function transfer(address _to, uint256 _value) public returns (bool success);
30 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
31 	function approve(address _spender, uint256 _value) public  returns (bool success);
32 }
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 contract EABToken is ERCToken,Ownable {
60 
61     using SafeMath for uint256;
62     string public name;
63     string public symbol;
64     uint8 public decimals=18;
65     mapping (address => bool) public frozenAccount;
66     mapping (address => mapping (address => uint256)) internal allowed;
67     event FrozenFunds(address target, bool frozen);
68 
69 
70   function EABToken(
71         string tokenName,
72         string tokenSymbol
73     ) public {
74         totalSupply = 48e8 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
75         balanceOf[msg.sender] = totalSupply;                   // Give the creator all initial tokens
76         name = tokenName;                                      // Set the name for display purposes
77         symbol = tokenSymbol;
78      }
79  
80     function _transfer(address _from, address _to, uint _value) internal {
81         require(_to != 0x0);
82         require(balanceOf[_from] >= _value);
83         require(balanceOf[_to] + _value > balanceOf[_to]);
84         require(!frozenAccount[_from]);
85         uint previousbalanceOf = balanceOf[_from].add(balanceOf[_to]);
86         balanceOf[_from] = balanceOf[_from].sub(_value);
87         balanceOf[_to] =balanceOf[_to].add(_value);
88         Transfer(_from, _to, _value);
89         assert(balanceOf[_from].add(balanceOf[_to]) == previousbalanceOf);
90     }
91     function transfer(address _to, uint256 _value) public returns (bool success){
92         _transfer(msg.sender, _to, _value);
93         return true;
94     }
95     function transferAndCall(address _to, uint256 _value, bytes _data)
96         public
97         returns (bool success) {
98         _transfer(msg.sender,_to, _value);
99         if(_isContract(_to))
100         {
101             TransferRecipient spender = TransferRecipient(_to);
102             if(!spender.tokenFallback(msg.sender, _value, _data))
103             {
104                 revert();
105             }
106         }
107         return true;
108     }
109 
110 
111     function _isContract(address _addr) private view returns (bool is_contract) {
112       uint length;
113       assembly {
114            length := extcodesize(_addr)
115       }
116       return (length>0);
117     }
118 
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
120         require(_value <= allowed[_from][msg.sender]); // Check allowance
121         allowed[_from][msg.sender]= allowed[_from][msg.sender].sub(_value);
122         _transfer(_from, _to, _value);
123         return true;
124     }
125 
126 
127     function allowance(address _owner,address _spender) public view returns(uint256){
128         return allowed[_owner][_spender];
129 
130     }
131     function approve(address _spender, uint256 _value) public  returns (bool) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
137         public
138         returns (bool success) {
139 
140         allowed[msg.sender][_spender] = _value;
141         if(_isContract(_spender)){
142             ApprovalRecipient spender = ApprovalRecipient(_spender);
143             if(!spender.approvalFallback(msg.sender, _value, _extraData)){
144                 revert();
145             }
146         }
147         Approval(msg.sender, _spender, _value);
148         return true;
149 
150     }
151     function freezeAccount(address target, bool freeze) onlyOwner public{
152         frozenAccount[target] = freeze;
153         FrozenFunds(target, freeze);
154     }
155 }