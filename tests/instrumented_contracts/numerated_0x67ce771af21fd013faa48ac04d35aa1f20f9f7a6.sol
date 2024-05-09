1 /**
2  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
3  *
4  *  Code is based on multiple sources:
5  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20.sol
6  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/Token.sol
7  */
8 
9 pragma solidity ^0.4.8;
10 
11 contract Token {
12     /* This is a slight change to the ERC20 base standard.
13     function totalSupply() constant returns (uint256 supply);
14     is replaced with:
15     uint256 public totalSupply;
16     This automatically creates a getter function for the totalSupply.
17     This is moved to the base contract since public getter functions are not
18     currently recognised as an implementation of the matching abstract
19     function by the compiler.
20     */
21     /// total amount of tokens
22     uint256 public totalSupply;
23 
24     /// @param _owner The address from which the balance will be retrieved
25     /// @return The balance
26     function balanceOf(address _owner) constant returns (uint256 balance);
27 
28     /// @notice send `_value` token to `_to` from `msg.sender`
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transfer(address _to, uint256 _value) returns (bool success);
33 
34     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
35     /// @param _from The address of the sender
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
40 
41     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @param _value The amount of tokens to be approved for transfer
44     /// @return Whether the approval was successful or not
45     function approve(address _spender, uint256 _value) returns (bool success);
46 
47     /// @param _owner The address of the account owning tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @return Amount of remaining tokens allowed to spent
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 /**
57  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
58  *
59  *  Code is based on multiple sources:
60  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20.sol
61  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/HumanStandardToken.sol
62  */
63 
64 contract StandardToken is Token {
65 
66     function transfer(address _to, uint256 _value) returns (bool success) {
67         if (balances[msg.sender] >= _value && _value > 0) {
68             balances[msg.sender] -= _value;
69             balances[_to] += _value;
70             Transfer(msg.sender, _to, _value);
71             return true;
72         } else { return false; }
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
76         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
77             balances[_to] += _value;
78             balances[_from] -= _value;
79             allowed[_from][msg.sender] -= _value;
80             Transfer(_from, _to, _value);
81             return true;
82         } else { return false; }
83     }
84 
85     function balanceOf(address _owner) constant returns (uint256 balance) {
86         return balances[_owner];
87     }
88 
89     function approve(address _spender, uint256 _value) returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
96       return allowed[_owner][_spender];
97     }
98 
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101 }
102 
103 /**
104  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
105  *
106  *  Code is based on multiple sources:
107  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20.sol
108  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/HumanStandardToken.sol
109  */
110  
111 contract NotaryToken is StandardToken{
112 
113     function () {
114         //if ether is sent to this address, send it back.
115         throw;
116     }
117     
118     address owner;
119     mapping (address => bool) associateContracts;
120 
121     modifier onlyOwner { if (msg.sender != owner) throw; _; }
122 
123     /* Public variables of the token */
124     string public name = "Notary Platform Token";
125     uint8 public decimals = 18;
126     string public symbol = "NTRY";
127     string public version = 'NTRY-1.0';
128 
129     function NotaryToken() {
130         owner = 0x1538EF80213cde339A333Ee420a85c21905b1b2D;
131         /* Total supply is One hundred and fifty million (150,000,000)*/
132         balances[0x1538EF80213cde339A333Ee420a85c21905b1b2D] = 150000000 * 1 ether;
133         totalSupply = 150000000 * 1 ether;
134 
135         balances[0x1538EF80213cde339A333Ee420a85c21905b1b2D] -= teamAllocations;
136         unlockedAt =  now + 365 * 1 days;   // Freeze notary team funds for one year
137     }
138 
139     /* Approves and then calls the receiving contract */
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
141         allowed[msg.sender][_spender] = _value;
142         Approval(msg.sender, _spender, _value);
143         
144         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
145         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
146             throw; 
147         }
148         return true;
149     }
150 
151     /* In certain cases associated contracts can recover NTRY they have distributed */
152     function takeBackNTRY(address _from,address _to, uint256 _value) returns (bool) {
153         if (associateContracts[msg.sender]){
154             balances[_from] -= _value;
155             balances[_to] += _value;
156             return true;
157         }else{
158             return false;
159         }
160         
161     }
162 
163     function newAssociate(address _addressOfAssociate) onlyOwner {
164         associateContracts[_addressOfAssociate] = true;
165     }
166 
167     /* Expire association with NTRY Token*/
168     function expireAssociate(address _addressOfAssociate) onlyOwner {
169         delete associateContracts[_addressOfAssociate];
170     }
171     
172     /* Verify contract association with NTRY Token*/
173     function isAssociated(address _addressOfAssociate) returns(bool){
174         return associateContracts[_addressOfAssociate]; 
175     }
176 
177     function transferOwnership(address _newOwner) onlyOwner {
178         balances[_newOwner] = balances[owner];
179         balances[owner] = 0;
180         owner = _newOwner;
181     }
182 
183 
184     uint256 constant teamAllocations = 15000000 * 1 ether;
185     uint256 unlockedAt;
186     mapping (address => uint256) allocations;
187     function allocate() onlyOwner {
188         allocations[0xab1cb1740344A9280dC502F3B8545248Dc3045eA] = 2500000 * 1 ether;
189         allocations[0x330709A59Ab2D1E1105683F92c1EE8143955a357] = 2500000 * 1 ether;
190         allocations[0xAa0887fc6e8896C4A80Ca3368CFd56D203dB39db] = 2500000 * 1 ether;
191         allocations[0x1fbA1d22435DD3E7Fa5ba4b449CC550a933E72b3] = 2500000 * 1 ether;
192         allocations[0xC9d5E2c7e40373ae576a38cD7e62E223C95aBFD4] = 500000 * 1 ether;
193         allocations[0xabc0B64a38DE4b767313268F0db54F4cf8816D9C] = 500000 * 1 ether;
194         allocations[0x5d85bCDe5060C5Bd00DBeDF5E07F43CE3Ccade6f] = 250000 * 1 ether;
195         allocations[0xecb1b0231CBC0B04015F9e5132C62465C128B578] = 250000 * 1 ether;
196         allocations[0xF9b1Cfc7fe3B63bEDc594AD20132CB06c18FD5F2] = 250000 * 1 ether;
197         allocations[0xDbb89a87d9f91EA3f0Ab035a67E3A951A05d0130] = 250000 * 1 ether;
198         allocations[0xC1530645E21D27AB4b567Bac348721eE3E244Cbd] = 200000 * 1 ether;
199         allocations[0xcfb44162030e6CBca88e65DffA21911e97ce8533] = 200000 * 1 ether;
200         allocations[0x64f748a5C5e504DbDf61d49282d6202Bc1311c3E] = 200000 * 1 ether;
201         allocations[0xFF22FA2B3e5E21817b02a45Ba693B7aC01485a9C] = 200000 * 1 ether;
202         allocations[0xC9856112DCb8eE449B83604438611EdCf61408AF] = 200000 * 1 ether;
203         allocations[0x689CCfEABD99081D061aE070b1DA5E1f6e4B9fB2] = 2000000 * 1 ether;
204     }
205    
206     function withDraw(){
207         if(now < unlockedAt){ 
208             return;
209         }
210         if(allocations[msg.sender] > 0){
211             balances[msg.sender] += allocations[msg.sender];
212             allocations[msg.sender] = 0;
213         }
214     }
215 }