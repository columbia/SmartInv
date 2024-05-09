1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4 
5     address public owner;
6 
7     function Owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function setOwner(address _newOwner) onlyOwner {
17         owner = _newOwner;
18     }
19 }
20 
21 
22 // Abstract contract for the full ERC 20 Token standard
23 // https://github.com/ethereum/EIPs/issues/20
24 
25 contract Token {
26     /* This is a slight change to the ERC20 base standard.
27     function totalSupply() constant returns (uint256 supply);
28     is replaced with:
29     uint256 public totalSupply;
30     This automatically creates a getter function for the totalSupply.
31     This is moved to the base contract since public getter functions are not
32     currently recognised as an implementation of the matching abstract
33     function by the compiler.
34     */
35     /// total amount of tokens
36     //uint256 public totalSupply;
37     function totalSupply() constant returns (uint256 supply);
38 
39     /// @param _owner The address from which the balance will be retrieved
40     /// @return The balance
41     function balanceOf(address _owner) constant returns (uint256 balance);
42 
43     /// @notice send `_value` token to `_to` from `msg.sender`
44     /// @param _to The address of the recipient
45     /// @param _value The amount of token to be transferred
46     /// @return Whether the transfer was successful or not
47     function transfer(address _to, uint256 _value) returns (bool success);
48 
49     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
50     /// @param _from The address of the sender
51     /// @param _to The address of the recipient
52     /// @param _value The amount of token to be transferred
53     /// @return Whether the transfer was successful or not
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
55 
56     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
57     /// @param _spender The address of the account able to transfer the tokens
58     /// @param _value The amount of wei to be approved for transfer
59     /// @return Whether the approval was successful or not
60     function approve(address _spender, uint256 _value) returns (bool success);
61 
62     /// @param _owner The address of the account owning tokens
63     /// @param _spender The address of the account able to transfer the tokens
64     /// @return Amount of remaining tokens allowed to spent
65     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 }
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
78     uint256 c = a * b;
79     assert(a == 0 || c / a == b);
80     return c;
81   }
82 
83   function div(uint256 a, uint256 b) internal constant returns (uint256) {
84     // assert(b > 0); // Solidity automatically throws when dividing by 0
85     uint256 c = a / b;
86     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87     return c;
88   }
89 
90   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   function add(uint256 a, uint256 b) internal constant returns (uint256) {
96     uint256 c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 
101   function toUINT112(uint256 a) internal constant returns(uint112) {
102     assert(uint112(a) == a);
103     return uint112(a);
104   }
105 
106   function toUINT120(uint256 a) internal constant returns(uint120) {
107     assert(uint120(a) == a);
108     return uint120(a);
109   }
110 
111   function toUINT128(uint256 a) internal constant returns(uint128) {
112     assert(uint128(a) == a);
113     return uint128(a);
114   }
115 }
116 
117 
118 contract ApprovalReceiver {
119     function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData);
120 }
121 
122 
123 contract Rollback is Owned, ApprovalReceiver {
124 
125     event onSetCredit(address account , uint256 amount);
126     event onReturned(address who, uint256 tokenAmount, uint256 ethAmount);
127 
128 
129     using SafeMath for uint256;
130     
131     Token public token = Token(0xD850942eF8811f2A866692A623011bDE52a462C1);
132 
133     uint256 public totalSetCredit;                  //set ven that should be returned
134     uint256 public totalReturnedCredit;             //returned ven  
135 
136     struct Credit {
137         uint128 total;
138         uint128 used;
139     }
140 
141     mapping(address => Credit)  credits;           //public
142 
143     function Rollback() {
144     }
145 
146     function() payable {
147     }
148 
149     function withdrawETH(address _address,uint256 _amount) onlyOwner {
150         require(_address != 0);
151         _address.transfer(_amount);
152     }
153 
154     function withdrawToken(address _address, uint256 _amount) onlyOwner {
155         require(_address != 0);
156         token.transfer(_address, _amount);
157     }
158 
159     function setCredit(address _account, uint256 _amount) onlyOwner { 
160 
161         totalSetCredit += _amount;
162         totalSetCredit -= credits[_account].total;        
163 
164         credits[_account].total = _amount.toUINT128();
165         require(credits[_account].total >= credits[_account].used);
166         onSetCredit(_account, _amount);
167     }
168 
169     function getCredit(address _account) constant returns (uint256 total, uint256 used) {
170         return (credits[_account].total, credits[_account].used);
171     }    
172 
173     function receiveApproval(address _from, uint256 _value, address /*_tokenContract*/, bytes /*_extraData*/) {
174         require(msg.sender == address(token));
175 
176         require(credits[_from].total >= credits[_from].used);
177         uint256 remainedCredit = credits[_from].total - credits[_from].used;
178 
179         if(_value > remainedCredit)
180             _value = remainedCredit;  
181 
182         uint256 balance = token.balanceOf(_from);
183         if(_value > balance)
184             _value = balance;
185 
186         require(_value > 0);
187 
188         require(token.transferFrom(_from, this, _value));
189 
190         uint256 ethAmount = _value / 4025;
191         require(ethAmount > 0);
192 
193         credits[_from].used += _value.toUINT128();
194         totalReturnedCredit +=_value;
195 
196         _from.transfer(ethAmount);
197         
198         onReturned(_from, _value, ethAmount);
199     }
200 }