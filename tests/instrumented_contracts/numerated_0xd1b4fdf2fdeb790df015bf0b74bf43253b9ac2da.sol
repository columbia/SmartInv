1 pragma solidity ^0.4.11;
2 // Dr. Sebastian Buergel, Validity Labs AG
3 
4 // from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control 
8  * functions, this simplifies the implementation of "user permissions". 
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   /** 
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner. 
25    */
26   modifier onlyOwner() {
27     if (msg.sender != owner) {
28       throw;
29     }
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to. 
37    */
38   function transferOwnership(address newOwner) onlyOwner {
39     if (newOwner != address(0)) {
40       owner = newOwner;
41     }
42   }
43 
44 }
45 
46 
47 
48 // from https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/Token.sol
49 contract Token {
50     /* This is a slight change to the ERC20 base standard.
51     function totalSupply() constant returns (uint256 supply);
52     is replaced with:
53     uint256 public totalSupply;
54     This automatically creates a getter function for the totalSupply.
55     This is moved to the base contract since public getter functions are not
56     currently recognised as an implementation of the matching abstract
57     function by the compiler.
58     */
59     /// total amount of tokens
60     uint256 public totalSupply;
61 
62     /// @param _owner The address from which the balance will be retrieved
63     /// @return The balance
64     function balanceOf(address _owner) constant returns (uint256 balance);
65 
66     /// @notice send `_value` token to `_to` from `msg.sender`
67     /// @param _to The address of the recipient
68     /// @param _value The amount of token to be transferred
69     /// @return Whether the transfer was successful or not
70     function transfer(address _to, uint256 _value) returns (bool success);
71 
72     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
73     /// @param _from The address of the sender
74     /// @param _to The address of the recipient
75     /// @param _value The amount of token to be transferred
76     /// @return Whether the transfer was successful or not
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
78 
79     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
80     /// @param _spender The address of the account able to transfer the tokens
81     /// @param _value The amount of tokens to be approved for transfer
82     /// @return Whether the approval was successful or not
83     function approve(address _spender, uint256 _value) returns (bool success);
84 
85     /// @param _owner The address of the account owning tokens
86     /// @param _spender The address of the account able to transfer the tokens
87     /// @return Amount of remaining tokens allowed to spent
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
89 
90     event Transfer(address indexed _from, address indexed _to, uint256 _value);
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92 }
93 
94 
95 
96 // from https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/StandardToken.sol
97 contract StandardToken is Token {
98 
99     function transfer(address _to, uint256 _value) returns (bool success) {
100         //Default assumes totalSupply can't be over max (2^256 - 1).
101         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
102         //Replace the if with this one instead.
103         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
104         if (balances[msg.sender] >= _value && _value > 0) {
105             balances[msg.sender] -= _value;
106             balances[_to] += _value;
107             Transfer(msg.sender, _to, _value);
108             return true;
109         } else { return false; }
110     }
111 
112     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
113         //same as above. Replace this line with the following if you want to protect against wrapping uints.
114         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
115         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
116             balances[_to] += _value;
117             balances[_from] -= _value;
118             allowed[_from][msg.sender] -= _value;
119             Transfer(_from, _to, _value);
120             return true;
121         } else { return false; }
122     }
123 
124     function balanceOf(address _owner) constant returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128     function approve(address _spender, uint256 _value) returns (bool success) {
129         allowed[msg.sender][_spender] = _value;
130         Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
135       return allowed[_owner][_spender];
136     }
137 
138     mapping (address => uint256) balances;
139     mapping (address => mapping (address => uint256)) allowed;
140 }
141 
142 
143 
144 // wraps non-ERC20-conforming fundraising contracts (aka pure IOU ICO) in a standard ERC20 contract that is immediately tradable and usable via default tools.
145 // this is again a pure IOU token but now having all the benefits of standard tokens.
146 contract ERC20nator is StandardToken, Ownable {
147 
148     address public fundraiserAddress;
149     bytes public fundraiserCallData;
150 
151     uint constant issueFeePercent = 2; // fee in percent that is collected for all paid in funds
152 
153     event requestedRedeem(address indexed requestor, uint amount);
154     
155     event redeemed(address redeemer, uint amount);
156 
157     // fallback function invests in fundraiser
158     // fee percentage is given to owner for providing this service
159     // remainder is invested in fundraiser
160     function() payable {
161         uint issuedTokens = msg.value * (100 - issueFeePercent) / 100;
162 
163         // pay fee to owner
164         if(!owner.send(msg.value - issuedTokens))
165             throw;
166         
167         // invest remainder into fundraiser
168         if(!fundraiserAddress.call.value(issuedTokens)(fundraiserCallData))
169             throw;
170 
171         // issue tokens by increasing total supply and balance
172         totalSupply += issuedTokens;
173         balances[msg.sender] += issuedTokens;
174     }
175 
176     // allow owner to set fundraiser target address
177     function setFundraiserAddress(address _fundraiserAddress) onlyOwner {
178         fundraiserAddress = _fundraiserAddress;
179     }
180 
181     // allow owner to set call data to be sent along to fundraiser target address
182     function setFundraiserCallData(string _fundraiserCallData) onlyOwner {
183         fundraiserCallData = hexStrToBytes(_fundraiserCallData);
184     }
185 
186     // this is just to inform the owner that a user wants to redeem some of their IOU tokens
187     function requestRedeem(uint _amount) {
188         requestedRedeem(msg.sender, _amount);
189     }
190 
191     // this is just to inform the investor that the owner redeemed some of their IOU tokens
192     function redeem(uint _amount) onlyOwner{
193         redeemed(msg.sender, _amount);
194     }
195 
196     // helper function to input bytes via remix
197     // from https://ethereum.stackexchange.com/a/13658/16
198     function hexStrToBytes(string _hexString) constant returns (bytes) {
199         //Check hex string is valid
200         if (bytes(_hexString)[0]!='0' ||
201             bytes(_hexString)[1]!='x' ||
202             bytes(_hexString).length%2!=0 ||
203             bytes(_hexString).length<4) {
204                 throw;
205             }
206 
207         bytes memory bytes_array = new bytes((bytes(_hexString).length-2)/2);
208         uint len = bytes(_hexString).length;
209         
210         for (uint i=2; i<len; i+=2) {
211             uint tetrad1=16;
212             uint tetrad2=16;
213 
214             //left digit
215             if (uint(bytes(_hexString)[i])>=48 &&uint(bytes(_hexString)[i])<=57)
216                 tetrad1=uint(bytes(_hexString)[i])-48;
217 
218             //right digit
219             if (uint(bytes(_hexString)[i+1])>=48 &&uint(bytes(_hexString)[i+1])<=57)
220                 tetrad2=uint(bytes(_hexString)[i+1])-48;
221 
222             //left A->F
223             if (uint(bytes(_hexString)[i])>=65 &&uint(bytes(_hexString)[i])<=70)
224                 tetrad1=uint(bytes(_hexString)[i])-65+10;
225 
226             //right A->F
227             if (uint(bytes(_hexString)[i+1])>=65 &&uint(bytes(_hexString)[i+1])<=70)
228                 tetrad2=uint(bytes(_hexString)[i+1])-65+10;
229 
230             //left a->f
231             if (uint(bytes(_hexString)[i])>=97 &&uint(bytes(_hexString)[i])<=102)
232                 tetrad1=uint(bytes(_hexString)[i])-97+10;
233 
234             //right a->f
235             if (uint(bytes(_hexString)[i+1])>=97 &&uint(bytes(_hexString)[i+1])<=102)
236                 tetrad2=uint(bytes(_hexString)[i+1])-97+10;
237 
238             //Check all symbols are allowed
239             if (tetrad1==16 || tetrad2==16)
240                 throw;
241 
242             bytes_array[i/2-1]=byte(16*tetrad1 + tetrad2);
243         }
244 
245         return bytes_array;
246     }
247 
248 }