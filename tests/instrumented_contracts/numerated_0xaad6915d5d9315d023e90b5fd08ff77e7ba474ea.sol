1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract EIP20Interface {
46     /* This is a slight change to the ERC20 base standard.
47     function totalSupply() constant returns (uint256 supply);
48     is replaced with:
49     uint256 public totalSupply;
50     This automatically creates a getter function for the totalSupply.
51     This is moved to the base contract since public getter functions are not
52     currently recognised as an implementation of the matching abstract
53     function by the compiler.
54     */
55     /// total amount of tokens
56     uint256 public totalSupply;
57 
58     /// @param _owner The address from which the balance will be retrieved
59     /// @return The balance
60     function balanceOf(address _owner) public view returns (uint256 balance);
61 
62     /// @notice send `_value` token to `_to` from `msg.sender`
63     /// @param _to The address of the recipient
64     /// @param _value The amount of token to be transferred
65     /// @return Whether the transfer was successful or not
66     function transfer(address _to, uint256 _value) public returns (bool success);
67 
68     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
69     /// @param _from The address of the sender
70     /// @param _to The address of the recipient
71     /// @param _value The amount of token to be transferred
72     /// @return Whether the transfer was successful or not
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
74 
75     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
76     /// @param _spender The address of the account able to transfer the tokens
77     /// @param _value The amount of tokens to be approved for transfer
78     /// @return Whether the approval was successful or not
79     function approve(address _spender, uint256 _value) public returns (bool success);
80 
81     /// @param _owner The address of the account owning tokens
82     /// @param _spender The address of the account able to transfer the tokens
83     /// @return Amount of remaining tokens allowed to spent
84     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
85 
86     // solhint-disable-next-line no-simple-event-func-name
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89 }
90 
91 contract Lingu is EIP20Interface{
92     using SafeMath for uint256;
93 
94     uint256 constant private MAX_UINT256 = 2**256 - 1;
95     mapping (address => uint256) public balances;
96     mapping (address => mapping (address => uint256)) public allowed;
97  
98  
99     string public name;                   
100     uint8 public decimals;                
101     string public symbol;                 
102 
103     
104     constructor (
105         uint256 _initialAmount,
106         string _tokenName,
107         uint8 _decimalUnits,
108         string _tokenSymbol
109     )
110     public {
111         balances[msg.sender] = _initialAmount;              
112         totalSupply = _initialAmount;                      
113         name = _tokenName;                                   
114         decimals = _decimalUnits;                           
115         symbol = _tokenSymbol;                              
116     }
117 
118     function transfer(address _to, uint256 _value) public returns (bool success) {
119         require(balances[msg.sender] >= _value);
120         balances[msg.sender] -= _value;
121         balances[_to] += _value;
122         emit Transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
127         uint256 allowance = allowed[_from][msg.sender];
128         require(balances[_from] >= _value && allowance >= _value);
129         balances[_to] += _value;
130         balances[_from] -= _value;
131         if (allowance < MAX_UINT256) {
132             allowed[_from][msg.sender] -= _value;
133         }
134         emit Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     function balanceOf(address _owner) public view returns (uint256 balance) {
139         return balances[_owner];
140     }
141 
142     function approve(address _spender, uint256 _value) public returns (bool success) {
143         allowed[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
149         return allowed[_owner][_spender];
150     }
151     
152     
153         function() public payable{
154       
155     uint price = 0.00001136363 ether;
156     uint startDate = 1530403200 ;
157     uint endDate = 1538352000 ;
158     uint cap = 11000000000;
159     uint toMint = msg.value/price;
160     address bank = 0x0dE9d5eA2fF7AcA3E0050A4A174baE7f348be429 ;
161      
162         require(startDate <= now);
163         require(endDate >= startDate);
164         require(now <= endDate);
165         require(totalSupply <= cap);
166         
167         
168         totalSupply += toMint;
169         balances[msg.sender]+=toMint;
170         emit Transfer(0, msg.sender, toMint);
171         bank.transfer(msg.value);
172     }
173 
174 }