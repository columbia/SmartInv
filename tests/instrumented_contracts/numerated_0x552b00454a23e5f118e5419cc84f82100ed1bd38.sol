1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4     function safeAdd(uint256 a, uint256 b) internal pure returns(uint256) {
5         uint256 c = a + b;
6         assert(c >= a);
7         return c;
8     }
9     function safeSub(uint256 a, uint256 b) internal pure returns(uint256) {
10         assert(b <= a);
11         return a - b;
12     }
13 
14     function safeMul(uint256 a, uint256 b) internal pure returns(uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     function safeDiv(uint256 a, uint256 b) internal pure returns(uint256) {
24         uint256 c = a / b;
25         return c;
26     }
27 }
28 
29 contract EIP20Interface {
30     /* This is a slight change to the ERC20 base standard.
31     function totalSupply() constant returns (uint256 supply);
32     is replaced with:
33     uint256 public totalSupply;
34     This automatically creates a getter function for the totalSupply.
35     This is moved to the base contract since public getter functions are not
36     currently recognised as an implementation of the matching abstract
37     function by the compiler.
38     */
39     /// total amount of tokens
40     uint256 public totalSupply;
41 
42     /// @param _owner The address from which the balance will be retrieved
43     /// @return The balance
44     function balanceOf(address _owner) public view returns (uint256 balance);
45 
46     /// @notice send `_value` token to `_to` from `msg.sender`
47     /// @param _to The address of the recipient
48     /// @param _value The amount of token to be transferred
49     /// @return Whether the transfer was successful or not
50     function transfer(address _to, uint256 _value) public returns (bool success);
51 
52     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
53     /// @param _from The address of the sender
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
58 
59     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
60     /// @param _spender The address of the account able to transfer the tokens
61     /// @param _value The amount of tokens to be approved for transfer
62     /// @return Whether the approval was successful or not
63     function approve(address _spender, uint256 _value) public returns (bool success);
64 
65     /// @param _owner The address of the account owning tokens
66     /// @param _spender The address of the account able to transfer the tokens
67     /// @return Amount of remaining tokens allowed to spent
68     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
69 
70     // solhint-disable-next-line no-simple-event-func-name
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 }
74 
75 contract SATEToken is EIP20Interface, SafeMath {
76 
77     uint256 constant private MAX_UINT256 = 2**256 - 1;
78     mapping (address => uint256) public balances;
79     mapping (address => mapping (address => uint256)) public allowed;
80 
81     /*
82     NOTE:
83     The following variables are OPTIONAL vanities. One does not have to include them.
84     They allow one to customise the token contract & in no way influences the core functionality.
85     Some wallets/interfaces might not even bother to look at this information.
86     */
87     string constant public name = "SATEToken";
88     uint8 constant public decimals = 18;                //How many decimals to show.
89     string constant public symbol = "SATE";
90 
91     mapping (address => uint256) public addressType;  // 1 for team; 2 for advisors and partners; 3 for seed investors; 4 for angel investors; 5 for regular investors; 0 for others
92     mapping (address => uint256[3]) public releaseForSeed;
93     mapping (address => uint256[5]) public releaseForTeamAndAdvisor;
94     event AllocateToken(address indexed _to, uint256 _value, uint256 _type);
95 
96     address public owner;
97     uint256 public finaliseTime;
98 
99     function SATEToken() public {
100         totalSupply = 20*10**26;                        // Update total supply
101         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
102         owner = msg.sender;
103     }
104 
105     modifier isOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109 
110     modifier notFinalised() {
111         require(finaliseTime == 0);
112         _;
113     }
114 
115     //
116     function allocateToken(address _to, uint256 _eth, uint256 _type) isOwner notFinalised public {
117         require(_to != address(0x0) && _eth != 0);
118         require(addressType[_to] == 0 || addressType[_to] == _type);
119         addressType[_to] = _type;
120         uint256 temp;
121         if (_type == 3) {
122             temp = safeMul(_eth, 60000 * 10**18);
123             balances[_to] = safeAdd(balances[_to], temp);
124             balances[msg.sender] = safeSub(balances[msg.sender], temp);
125             releaseForSeed[_to][0] = safeDiv(safeMul(balances[_to], 60), 100);
126             releaseForSeed[_to][1] = safeDiv(safeMul(balances[_to], 30), 100);
127             releaseForSeed[_to][2] = 0;
128 
129             AllocateToken(_to, temp, 3);
130         } else if (_type == 4) {
131             temp = safeMul(_eth, 20000 * 10**18);
132             balances[_to] = safeAdd(balances[_to], temp);
133             balances[msg.sender] = safeSub(balances[msg.sender], temp);
134             AllocateToken(_to, temp, 4);
135         } else if (_type == 5) {
136             temp = safeMul(_eth, 12000 * 10**18);
137             balances[_to] = safeAdd(balances[_to], temp);
138             balances[msg.sender] = safeSub(balances[msg.sender], temp);
139             AllocateToken(_to, temp, 5);
140         } else {
141             revert();
142         }
143     }
144 
145     function allocateTokenForTeam(address _to, uint256 _value) isOwner notFinalised public {
146         require(addressType[_to] == 0 || addressType[_to] == 1);
147         addressType[_to] = 1;
148         balances[_to] = safeAdd(balances[_to], safeMul(_value, 10**18));
149         balances[msg.sender] = safeSub(balances[msg.sender], safeMul(_value, 10**18));
150 
151         for (uint256 i = 0; i <= 4; ++i) {
152             releaseForTeamAndAdvisor[_to][i] = safeDiv(safeMul(balances[_to], (4 - i) * 25), 100);
153         }
154 
155         AllocateToken(_to, safeMul(_value, 10**18), 1);
156     }
157 
158     function allocateTokenForAdvisor(address _to, uint256 _value) isOwner public {
159         require(addressType[_to] == 0 || addressType[_to] == 2);
160         addressType[_to] = 2;
161         balances[_to] = safeAdd(balances[_to], safeMul(_value, 10**18));
162         balances[msg.sender] = safeSub(balances[msg.sender], safeMul(_value, 10**18));
163 
164         for (uint256 i = 0; i <= 4; ++i) {
165             releaseForTeamAndAdvisor[_to][i] = safeDiv(safeMul(balances[_to], (4 - i) * 25), 100);
166         }
167         AllocateToken(_to, safeMul(_value, 10**18), 2);
168     }
169 
170     function changeOwner(address _owner) isOwner public {
171         owner = _owner;
172     }
173 
174     function setFinaliseTime() isOwner public {
175         require(finaliseTime == 0);
176         finaliseTime = now;
177     }
178 
179     function transfer(address _to, uint256 _value) public returns (bool success) {
180         require(canTransfer(msg.sender, _value));
181         require(balances[msg.sender] >= _value);
182         balances[msg.sender] -= _value;
183         balances[_to] += _value;
184         Transfer(msg.sender, _to, _value);
185         return true;
186     }
187 
188     function canTransfer(address _from, uint256 _value) internal view returns (bool success) {
189         require(finaliseTime != 0);
190         uint256 index;
191 
192         if (addressType[_from] == 0 || addressType[_from] == 4 || addressType[_from] == 5) {
193             return true;
194         }
195         // for seed investors
196         if (addressType[_from] == 3) {
197             index = safeSub(now, finaliseTime) / 2 hours;
198             if ( index >= 2) {
199                 index = 2;
200             }
201             require(safeSub(balances[_from], _value) >= releaseForSeed[_from][index]);
202         } else if (addressType[_from] == 1 || addressType[_from] == 2) {
203             index = safeSub(now, finaliseTime) / 2 hours;
204             if (index >= 4) {
205                 index = 4;
206             }
207             require(safeSub(balances[_from], _value) >= releaseForTeamAndAdvisor[_from][index]);
208         }
209         return true;
210     }
211 
212     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
213         require(canTransfer(_from, _value));
214         uint256 allowance = allowed[_from][msg.sender];
215         require(balances[_from] >= _value && allowance >= _value);
216         balances[_to] += _value;
217         balances[_from] -= _value;
218         if (allowance < MAX_UINT256) {
219             allowed[_from][msg.sender] -= _value;
220         }
221         Transfer(_from, _to, _value);
222         return true;
223     }
224 
225     function balanceOf(address _owner) public view returns (uint256 balance) {
226         return balances[_owner];
227     }
228 
229     function approve(address _spender, uint256 _value) public returns (bool success) {
230         allowed[msg.sender][_spender] = _value;
231         Approval(msg.sender, _spender, _value);
232         return true;
233     }
234 
235     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
236         return allowed[_owner][_spender];
237     }
238 }