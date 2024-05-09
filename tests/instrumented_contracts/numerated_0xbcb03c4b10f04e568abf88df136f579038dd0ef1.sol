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
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 
51   function toUINT112(uint256 a) internal constant returns(uint112) {
52     assert(uint112(a) == a);
53     return uint112(a);
54   }
55 
56   function toUINT120(uint256 a) internal constant returns(uint120) {
57     assert(uint120(a) == a);
58     return uint120(a);
59   }
60 
61   function toUINT128(uint256 a) internal constant returns(uint128) {
62     assert(uint128(a) == a);
63     return uint128(a);
64   }
65 }
66 
67 
68 // Abstract contract for the full ERC 20 Token standard
69 // https://github.com/ethereum/EIPs/issues/20
70 
71 contract Token {
72     /* This is a slight change to the ERC20 base standard.
73     function totalSupply() constant returns (uint256 supply);
74     is replaced with:
75     uint256 public totalSupply;
76     This automatically creates a getter function for the totalSupply.
77     This is moved to the base contract since public getter functions are not
78     currently recognised as an implementation of the matching abstract
79     function by the compiler.
80     */
81     /// total amount of tokens
82     //uint256 public totalSupply;
83     function totalSupply() constant returns (uint256 supply);
84 
85     /// @param _owner The address from which the balance will be retrieved
86     /// @return The balance
87     function balanceOf(address _owner) constant returns (uint256 balance);
88 
89     /// @notice send `_value` token to `_to` from `msg.sender`
90     /// @param _to The address of the recipient
91     /// @param _value The amount of token to be transferred
92     /// @return Whether the transfer was successful or not
93     function transfer(address _to, uint256 _value) returns (bool success);
94 
95     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
96     /// @param _from The address of the sender
97     /// @param _to The address of the recipient
98     /// @param _value The amount of token to be transferred
99     /// @return Whether the transfer was successful or not
100     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
101 
102     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
103     /// @param _spender The address of the account able to transfer the tokens
104     /// @param _value The amount of wei to be approved for transfer
105     /// @return Whether the approval was successful or not
106     function approve(address _spender, uint256 _value) returns (bool success);
107 
108     /// @param _owner The address of the account owning tokens
109     /// @param _spender The address of the account able to transfer the tokens
110     /// @return Amount of remaining tokens allowed to spent
111     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
112 
113     event Transfer(address indexed _from, address indexed _to, uint256 _value);
114     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
115 }
116 
117 
118 contract Exchange is Owned {
119 
120     event onExchangeTokenToEther(address who, uint256 tokenAmount, uint256 etherAmount);
121 
122     using SafeMath for uint256;
123 
124     Token public token = Token(0xD850942eF8811f2A866692A623011bDE52a462C1);
125 
126     // 1 ether = ? tokens
127     uint256 public rate = 4025;
128 
129     // quota of token for every account that can be exchanged to ether
130     uint256 public tokenQuota = 402500 ether;
131 
132     // quota of ether for every account that can be exchanged to token
133     // uint256 public etherQuota = 100 ether;
134 
135     bool public tokenToEtherAllowed = true;
136     // bool public etherToTokenAllowed = false;
137 
138     // uint256 public totalReturnedCredit;             //returned ven  
139 
140 
141     // struct QuotaUsed {
142     //     uint128 tokens;
143     //     uint128 ethers;
144     // }
145     mapping(address => uint256) accountQuotaUsed;
146 
147     function Exchange() {
148     }
149 
150     function () payable {
151     }
152 
153 
154     function withdrawEther(address _address,uint256 _amount) onlyOwner {
155         require(_address != 0);
156         _address.transfer(_amount);
157     }
158 
159     function withdrawToken(address _address, uint256 _amount) onlyOwner {
160         require(_address != 0);
161         token.transfer(_address, _amount);
162     }
163 
164     function quotaUsed(address _account) constant returns(uint256 ) {
165         return accountQuotaUsed[_account];
166     }
167 
168     //tested
169     function setRate(uint256 _rate) onlyOwner {
170         rate = _rate;
171     }
172 
173     //tested
174     function setTokenQuota(uint256 _quota) onlyOwner {
175         tokenQuota = _quota;
176     }
177 
178     // function setEtherQuota(uint256 _quota) onlyOwner {
179     //     etherQuota = _quota;
180     // }
181 
182     //tested    
183     function setTokenToEtherAllowed(bool _allowed) onlyOwner {
184         tokenToEtherAllowed = _allowed;
185     }
186 
187     // function setEtherToTokenAllowed(bool _allowed) onlyOwner {
188     //     etherToTokenAllowed = _allowed;
189     // }
190 
191     function receiveApproval(address _from, uint256 _value, address /*_tokenContract*/, bytes /*_extraData*/) {
192         exchangeTokenToEther(_from, _value);
193     }
194 
195     function exchangeTokenToEther(address _from, uint256 _tokenAmount) internal {
196         require(tokenToEtherAllowed);
197         require(msg.sender == address(token));
198         require(!isContract(_from));
199 
200         uint256 quota = tokenQuota.sub(accountQuotaUsed[_from]);                
201 
202         if (_tokenAmount > quota)
203             _tokenAmount = quota;
204         
205         uint256 balance = token.balanceOf(_from);
206         if (_tokenAmount > balance)
207             _tokenAmount = balance;
208 
209         require(_tokenAmount>0);    //require the token should be above 0
210 
211         //require(_tokenAmount > 0.01 ether);
212         require(token.transferFrom(_from, this, _tokenAmount));        
213 
214         accountQuotaUsed[_from] = _tokenAmount.add(accountQuotaUsed[_from]);
215         
216         uint256 etherAmount = _tokenAmount / rate;
217         require(etherAmount > 0);
218         _from.transfer(etherAmount);
219 
220         // totalReturnedCredit+=_tokenAmount;
221 
222         onExchangeTokenToEther(_from, _tokenAmount, etherAmount);
223     }
224 
225 
226     //exchange EtherToToken放到fallback函数中
227     //TokenToEther
228     //    function exchangeEtherToToken() payable {
229     //       require(etherToTokenAllowed);
230     //        require(!isContract(msg.sender));
231     //
232     //        uint256 quota = etherQuota.sub(accountQuotaUsed[msg.sender].ethers);
233 
234     //        uint256 etherAmount = msg.value;
235     //        require(etherAmount >= 0.01 ether && etherAmount <= quota);
236     //        
237     //        uint256 tokenAmount = etherAmount * rate;
238 
239     //        accountQuotaUsed[msg.sender].ethers = etherAmount.add(accountQuotaUsed[msg.sender].ethers).toUINT128();
240 
241     //        require(token.transfer(msg.sender, tokenAmount));
242 
243     //        onExchangeEtherToToken(msg.sender, tokenAmount, etherAmount);                                                        
244     //    }
245 
246     function isContract(address _addr) constant internal returns(bool) {
247         uint size;
248         if (_addr == 0)
249             return false;
250         assembly {
251             size := extcodesize(_addr)
252         }
253         return size > 0;
254     }
255 }