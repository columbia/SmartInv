1 pragma solidity ^0.4.18;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply);
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance);
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint256 _value) returns (bool success);
16 
17     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18     /// @param _from The address of the sender
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
23 
24 
25 
26     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of wei to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) returns (bool success);
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39     event Burn(address indexed from, uint256 value);
40     
41 }
42 
43 
44 
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal constant returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function add(uint256 a, uint256 b) internal constant returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 
70   function onePercent(uint256 a) internal constant returns (uint256){
71       return div(a,uint256(100));
72   }
73   
74   function power(uint256 a,uint256 b) internal constant returns (uint256){
75       return mul(a,10**b);
76   }
77 }
78 
79 contract StandardToken is Token {
80     using SafeMath for uint256;
81     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
82     mapping(address=>bool) internal withoutFee;
83     uint256 internal maxFee;
84     
85     function transfer(address _to, uint256 _value) returns (bool success) {
86         uint256 fee=getFee(_value);
87         if (balances[msg.sender].add(fee) >= _value && _value > 0) {
88             //Do Transfer
89             doTransfer(msg.sender,_to,_value,fee);
90             return true;
91         }  else { return false; }
92     }
93     
94     function getFee(uint256 _value) private returns (uint256){
95         uint256 onePercentOfValue=_value.onePercent();
96         uint256 fee=uint256(maxFee).power(decimals);
97          // Check if 1% burn fee exceeds maxfee
98         // If so then hard cap for burn fee is maxfee
99         if (_value.add(onePercentOfValue) >= fee) {
100             return fee;
101         // If 1% burn fee is less than maxfee
102         // then use 1% burn fee
103         } if (_value.add(onePercentOfValue) < fee) {
104             return onePercentOfValue;
105         }
106     }
107     function doTransfer(address _from,address _to,uint256 _value,uint256 fee) internal {
108             balances[_from] =balances[_from].sub(_value);
109             balances[_to] = balances[_to].add(_value);
110             Transfer(_from, _to, _value);
111             if(!withoutFee[_from]){
112                 doBurn(_from,fee);
113             }
114     }
115     
116     function doBurn(address _from,uint256 _value) private returns (bool success){
117         require(balanceOf(_from) >= _value);   // Check if the sender has enough
118         balances[_from] =balances[_from].sub(_value);            // Subtract from the sender
119         _totalSupply =_totalSupply.sub(_value);                      // Updates totalSupply
120         Burn(_from, _value);
121         return true;
122     }
123     
124     function burn(address _from,uint256 _value) public returns (bool success) {
125         return doBurn(_from,_value);
126     }
127 
128     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
129         //same as above. Replace this line with the following if you want to protect against wrapping uints.
130         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
131         uint256 fee=getFee(_value);  
132         uint256 valueWithFee=_value;
133         if(!withoutFee[_from]){
134             valueWithFee=valueWithFee.add(fee);
135         }
136         if (balances[_from] >= valueWithFee && allowed[_from][msg.sender] >= valueWithFee && _value > 0 ) {
137             doTransfer(_from,_to,_value,fee);
138             allowed[_from][msg.sender] =allowed[_from][msg.sender].sub(valueWithFee);
139             return true;
140         } else { return false; }
141     }
142 
143     function balanceOf(address _owner) constant returns (uint256 balance) {
144         return balances[_owner];
145     }
146 
147     function approve(address _spender, uint256 _value) returns (bool success) {
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
154       return allowed[_owner][_spender];
155     }
156     
157     function totalSupply() constant returns (uint totalSupply){
158         return _totalSupply;
159     }
160     
161     mapping (address => uint256) balances;
162     mapping (address => mapping (address => uint256)) allowed;
163     uint256 public _totalSupply;
164 }
165 
166 
167 //name this contract whatever you'd like
168 contract FinalTestToken is StandardToken {
169 
170     function () {
171         //if ether is sent to this address, send it back.
172         revert();
173     }
174 
175     /* Public variables of the token */
176 
177     /*
178     NOTE:
179     The following variables are OPTIONAL vanities. One does not have to include them.
180     They allow one to customise the token contract & in no way influences the core functionality.
181     Some wallets/interfaces might not even bother to look at this information.
182     */
183     string public name;                   //fancy name: eg Simon Bucks
184     string public symbol;                 //An identifier: eg SBX
185     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
186     address private _owner;
187     // Fee info
188     string public feeInfo = "Each operation costs 1% of the transaction amount, but not more than 250 tokens.";
189 
190     function FinalTestToken() {
191         _totalSupply = 800000000000000000000000000; 
192         _owner=msg.sender;
193         balances[msg.sender] =_totalSupply;
194 
195         // Airdrop Allocation
196         allocate(0x98592d09bA9B739BF9D563a601CB3F6c3A238475,20); // Airdrop Round One
197         allocate(0xf088394D9AEec53096A18Fb192C98FD90495416C,20); // Airdrop Round Two
198         allocate(0x353c65713fDf8169f14bE74012a59eF9BAB00e9b,5); // Airdrop Round Three
199 
200         // Adoption Allocation
201         allocate(0x52B8fA840468e2dd978936B54d0DC83392f4B4aC,35); // Seed Offerings
202 
203         // Internal Allocation
204         allocate(0x7DfE12664C21c00B6A3d1cd09444fC2CC9e7f192,20); // Team 
205 
206         maxFee=250; // max fee for transfer
207         
208         name = "Final Test Token";                      // Set the name for display purposes
209         decimals = 18;                            // Amount of decimals for display purposes
210         symbol = "FTT";                          // Set the symbol for display purposes
211     }
212 
213     function allocate(address _address,uint256 percent) private{
214         uint256 bal=_totalSupply.onePercent().mul(percent);
215         //balances[_address]=bal;
216         withoutFee[_address]=true;
217         doTransfer(msg.sender,_address,bal,0);
218     }
219    
220     function setWithoutFee(address _address,bool _withoutFee) public {
221         require(_owner==msg.sender);
222         withoutFee[_address]=_withoutFee;
223     }
224     
225     /* Approves and then calls the receiving contract */
226     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
227         allowed[msg.sender][_spender] = _value;
228         Approval(msg.sender, _spender, _value);
229 
230         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
231         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
232         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
233         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
234         return true;
235     }
236 }