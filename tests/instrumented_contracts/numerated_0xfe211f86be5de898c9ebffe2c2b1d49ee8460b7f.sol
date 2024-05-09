1 pragma solidity ^0.4.13;
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
37     function mint(address _to, uint256 _amount) public returns (bool);
38     
39     function setEndMintDate(uint256 endDate) public;
40     
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44 }
45 
46 
47 
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal constant returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal constant returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 
73   function inc(uint256 a) internal constant returns (uint256) {
74     return add(a,1);
75   }
76   
77   function onePercent(uint256 a) internal constant returns (uint256){
78       return div(a,uint256(100));
79   }
80   
81   function power(uint256 a,uint256 b) internal constant returns (uint256){
82       return mul(a,10**b);
83   }
84 }
85 
86 contract StandardToken is Token {
87      
88     event Mint(address indexed to, uint256 amount);
89     event MintFinished();
90     using SafeMath for uint256;
91     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
92     uint256 endMintDate;
93     
94     address owner;
95     mapping (address => uint256) balances;
96     mapping (address => mapping (address => uint256)) allowed;
97     mapping (address => bool) minter;
98     
99     uint256 public _totalSupply;
100     
101     modifier onlyOwner() {
102         require(msg.sender==owner);
103         _;
104     }
105   
106     modifier canMint() {
107         require(endMintDate>now && minter[msg.sender]);
108         _;
109     }
110     
111     modifier canTransfer() {
112         require(endMintDate<now);
113         _;
114     }
115     
116     function transfer(address _to, uint256 _value) canTransfer returns (bool success) {
117         if (balances[msg.sender] >= _value && _value > 0 && _to!=0x0) {
118             //Do Transfer
119             return doTransfer(msg.sender,_to,_value);
120         }  else { return false; }
121     }
122     
123     function doTransfer(address _from,address _to,uint256 _value) internal returns (bool success) {
124             balances[_from] =balances[_from].sub(_value);
125             balances[_to] = balances[_to].add(_value);
126             Transfer(_from, _to, _value);
127             return true;
128     }
129     
130     function transferFrom(address _from, address _to, uint256 _value) canTransfer returns (bool success) {
131         //same as above. Replace this line with the following if you want to protect against wrapping uints.
132         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && _to!=0x0 ) {
133             doTransfer(_from,_to,_value);
134             allowed[_from][msg.sender] =allowed[_from][msg.sender].sub(_value);
135             Transfer(_from, _to, _value);
136             return true;
137         } else { return false; }
138     }
139 
140     function balanceOf(address _owner) constant returns (uint256 balance) {
141         return balances[_owner];
142     }
143 
144     function approve(address _spender, uint256 _value) returns (bool success) {
145         allowed[msg.sender][_spender] = _value;
146         Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
151       return allowed[_owner][_spender];
152     }
153     
154     function totalSupply() constant returns (uint totalSupply){
155         return _totalSupply;
156     }
157     
158     /**
159         * @dev Function to mint tokens
160         * @param _to The address that will receive the minted tokens.
161         * @param _amount The amount of tokens to mint.
162         * @return A boolean that indicates if the operation was successful.
163     */
164     function mint(address _to, uint256 _amount) canMint public returns (bool) {
165         _totalSupply = _totalSupply.add(_amount);
166         balances[_to] = balances[_to].add(_amount);
167         Mint(_to, _amount);
168         Transfer(0x0, _to, _amount);
169         return true;
170     }
171   
172     function setMinter(address _address,bool _canMint) onlyOwner public {
173         minter[_address]=_canMint;
174     } 
175     
176 
177     function setEndMintDate(uint256 endDate) public{
178         endMintDate=endDate;
179     }
180 }
181 //name this contract whatever you'd like
182 contract GMCToken is StandardToken {
183 
184     struct GiftData {
185         address from;
186         uint256 value;
187         string message;
188     }
189     
190     function () {
191         //if ether is sent to this address, send it back.
192         revert();
193     }
194 
195     /* Public variables of the token */
196   
197     /*
198     NOTE:
199     The following variables are OPTIONAL vanities. One does not have to include them.
200     They allow one to customise the token contract & in no way influences the core functionality.
201     Some wallets/interfaces might not even bother to look at this information.
202     */
203     string public name;                   //fancy name: eg Simon Bucks
204     string public symbol;                 //An identifier: eg SBX
205     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
206     mapping (address => mapping (uint256 => GiftData)) private gifts;
207     mapping (address => uint256 ) private giftsCounter;
208     
209     function GMCToken(address _wallet) {
210         uint256 initialSupply = 2000000;
211         endMintDate=now+4 weeks;
212         owner=msg.sender;
213         minter[_wallet]=true;
214         minter[msg.sender]=true;
215         mint(_wallet,initialSupply.div(2));
216         mint(msg.sender,initialSupply.div(2));
217         
218         name = "Good Mood Coin";                                   // Set the name for display purposes
219         decimals = 4;                            // Amount of decimals for display purposes
220         symbol = "GMC";                               // Set the symbol for display purposes
221     }
222 
223     function sendGift(address _to,uint256 _value,string _msg) payable public returns  (bool success){
224         uint256 counter=giftsCounter[_to];
225         gifts[_to][counter]=(GiftData({
226             from:msg.sender,
227             value:_value,
228             message:_msg
229         }));
230         giftsCounter[_to]=giftsCounter[_to].inc();
231         return doTransfer(msg.sender,_to,_value);
232     }
233     
234     function getGiftsCounter() public constant returns (uint256 count){
235         return giftsCounter[msg.sender];
236     }
237     
238     function getGift(uint256 index) public constant returns (address from,uint256 value,string message){
239         GiftData data=gifts[msg.sender][index];
240         return (data.from,data.value,data.message);
241     }
242     
243     /* Approves and then calls the receiving contract */
244     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
245         allowed[msg.sender][_spender] = _value;
246         Approval(msg.sender, _spender, _value);
247 
248         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
249         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
250         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
251         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
252         return true;
253     }
254 }