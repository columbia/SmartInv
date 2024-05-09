1 pragma solidity ^0.4.25;
2 interface TransferRecipient {
3 	function tokenFallback(address _from, uint256 _value, bytes _extraData) public returns(bool);
4 }
5 
6 interface ApprovalRecipient {
7 	function approvalFallback(address _from, uint256 _value, bytes _extraData) public returns(bool);
8 }
9 contract ERCToken {
10 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 	uint256 public  totalSupply;
13 	mapping (address => uint256) public balanceOf;
14 
15 	function allowance(address _owner,address _spender) public view returns(uint256);
16 	function transfer(address _to, uint256 _value) public returns (bool success);
17 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
18 	function approve(address _spender, uint256 _value) public  returns (bool success);
19 
20 
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 contract MyToken is ERCToken {
55 
56     using SafeMath for uint256;
57     string public name;
58     string public symbol;
59     uint8 public decimals=18;
60 
61     mapping (address => mapping (address => uint256)) internal allowed;
62 
63   //构造方法
64   function MyToken (
65         string tokenName,
66         string tokenSymbol,
67         uint256 initSupply
68     ) public {
69         totalSupply = initSupply * 10 ** 18;  // Update total supply with the decimal amount 例如发10个token, 这个值应该是 10*10^decimals
70         balanceOf[msg.sender] = totalSupply;                   // Give the creator all initial tokens
71         name = tokenName;                                      // Set the name for display purposes
72         symbol = tokenSymbol;
73      }
74 
75     function greet() view public returns (string) {
76         return 'hello';
77     }
78 
79    /**
80      * Internal transfer, only can be called by this contract
81      */
82     function _transfer(address _from, address _to, uint _value) internal {
83 
84         // Prevent transfer to 0x0 address. Use burn() instead
85         require(_to != 0x0);
86         // Check if the sender has enough
87         require(balanceOf[_from] >= _value);
88         // Check for overflows
89         require(balanceOf[_to] + _value > balanceOf[_to]);
90         // Save this for an assertion in the future
91         uint previousbalanceOf = balanceOf[_from].add(balanceOf[_to]);
92 
93         // Subtract from the sender
94         balanceOf[_from] = balanceOf[_from].sub(_value);
95         // Add the same to the recipient
96         balanceOf[_to] =balanceOf[_to].add(_value);
97         Transfer(_from, _to, _value);
98         // Asserts are used to use static analysis to find bugs in your code. They should never fail
99         assert(balanceOf[_from].add(balanceOf[_to]) == previousbalanceOf);
100     }
101 
102 
103     /**
104      * Transfer tokens
105      *
106      * Send `_value` tokens to `_to` from your account
107      *
108      * @param _to The address of the recipient
109      * @param _value the amount to send
110      */
111     function transfer(address _to, uint256 _value) public returns (bool success){
112         _transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     function transferAndCall(address _to, uint256 _value, bytes _data)
117         public
118         returns (bool success) {
119         _transfer(msg.sender,_to, _value);
120         if(_isContract(_to))
121         {
122             TransferRecipient spender = TransferRecipient(_to);
123             if(!spender.tokenFallback(msg.sender, _value, _data))
124             {
125                 revert();
126             }
127         }
128         return true;
129     }
130 
131     function _isContract(address _addr) private view returns (bool is_contract) {
132       uint length;
133       assembly {
134             //retrieve the size of the code on target address, this needs assembly
135             length := extcodesize(_addr)
136       }
137       return (length>0);
138     }
139 
140     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
141         require(_value <= allowed[_from][msg.sender]);     // Check allowance
142         allowed[_from][msg.sender]= allowed[_from][msg.sender].sub(_value);
143         _transfer(_from, _to, _value);
144         return true;
145     }
146 
147     function allowance(address _owner,address _spender) public view returns(uint256){
148         return allowed[_owner][_spender];
149 
150     }
151 
152    
153     function approve(address _spender, uint256 _value) public  returns (bool) {
154         allowed[msg.sender][_spender] = _value;
155         Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
160         public
161         returns (bool success) {
162 
163         allowed[msg.sender][_spender] = _value;
164         if(_isContract(_spender)){
165             ApprovalRecipient spender = ApprovalRecipient(_spender);
166             if(!spender.approvalFallback(msg.sender, _value, _extraData)){
167                 revert();
168             }
169         }
170         Approval(msg.sender, _spender, _value);
171         return true;
172 
173     }
174 
175 }