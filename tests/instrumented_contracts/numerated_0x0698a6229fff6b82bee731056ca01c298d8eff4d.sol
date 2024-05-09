1 /**
2  * Spork Token Contracts
3  * See Spork contract below for more detail.
4  *
5  * The DAO and Spork is free software: you can redistribute it and/or modify
6  * it under the terms of the GNU lesser General Public License as published by
7  * the Free Software Foundation, either version 3 of the License, or
8  * (at your option) any later version.
9  *
10  * The DAO and Spork is distributed in the hope that it will be useful,
11  * but WITHOUT ANY WARRANTY; without even the implied warranty of
12  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13  * GNU lesser General Public License for more details.
14  *
15  * http://www.gnu.org/licenses/
16  *
17  * credit
18  *   The DAO, Slock.it, Ethereum Foundation, EthCore, Consensys, pseudonymous
19  *   rebels everywhere, and every lunch spot with proper eating utensils. ?
20  */
21 
22 /**
23  * @title TokenInterface
24  * @notice ERC 20 token standard and DAO token interface.
25  */
26 contract TokenInterface {
27 
28     event Transfer(
29         address indexed _from,
30         address indexed _to,
31         uint256 _amount);
32 
33     event Approval(
34         address indexed _owner,
35         address indexed _spender,
36         uint256 _amount);
37 
38     mapping (address => // owner
39         uint256) balances;
40 
41     mapping (address => // owner
42     mapping (address => // spender
43         uint256)) allowed;
44 
45     uint256 public totalSupply;
46 
47     function balanceOf(address _owner)
48     constant
49     returns (uint256 balance);
50 
51     function transfer(address _to, uint256 _amount)
52     returns (bool success);
53 
54     function transferFrom(address _from, address _to, uint256 _amount)
55     returns (bool success);
56 
57     function approve(address _spender, uint256 _amount)
58     returns (bool success);
59 
60     function allowance(address _owner, address _spender)
61     constant
62     returns (uint256 remaining);
63 
64 }
65 
66 /**
67  * @title Spork
68  *
69  * @notice A rogue upgrade token for The DAO. There is nothing safe about this
70  *   contract or this life so strap in, bitches. You are responsible for you.
71  *   A Spork is minted through burning DAO tokens. This is irreversible and for
72  *   entertainment purposes. So why would you do this? Do it for love, do it
73  *   for So Tokey Nada Mojito, do it for the lulz; just do it with conviction!
74  *
75  * usage
76  *   1. Use The DAO to grant an allowance of DAO for the Spork contract.
77  *      + `DAO.approve(spork_contract_address, amount_of_DAO_to_burn)`
78  *      + Only grant the amount of DAO you are ready to destroy forever.
79  *   2. Use the Spork mint function to ...
80  *      1. Burn an amount of DAO up to the amount approved in the previous step.
81  *      2. Mint an equivalent amount of Spork.
82  *      3. Assign Spork tokens to the sender account.
83  *   3. You now have Sporks. Dig in!
84  */
85 contract Spork is TokenInterface {
86 
87     // crash and burn
88     address constant TheDAO = 0xbb9bc244d798123fde783fcc1c72d3bb8c189413;
89 
90     event Mint(
91         address indexed _sender,
92         uint256 indexed _amount,
93         string _lulz);
94 
95     // vanity attributes
96     string public name = "Spork";
97     string public symbol = "SPRK";
98     string public version = "Spork:0.1";
99     uint8 public decimals = 0;
100 
101     // @see {Spork.mint}
102     function () {
103         throw; // this is a coin, not a wallet.
104     }
105 
106     /**
107      * @notice Burn DAO tokens in exchange for Spork tokens
108      * @param _amount Amount of DAO to burn and equivalent Spork to mint
109      * @param _lulz If you gotta go, go with a smile! ?
110      * @return Determine if request was successful
111      */
112     function mint(uint256 _amount, string _lulz)
113     returns (bool success) {
114         if (totalSupply + _amount <= totalSupply)
115             return false; // zero or rollover value
116 
117         if (!TokenInterface(TheDAO).transferFrom(msg.sender, this, _amount))
118             return false; // unable to retrieve DAO tokens for sender
119 
120         balances[msg.sender] += _amount;
121         totalSupply += _amount;
122 
123         Mint(msg.sender, _amount, _lulz);
124         return true;
125     }
126 
127     /**
128      * @notice Transfer Spork tokens from `msg.sender` to another account.
129      * @param _to Account receiving tokens
130      * @param _amount Amount of tokens to transfer
131      * @return Determine if request was successful
132      */
133     function transfer(address _to, uint256 _amount)
134     returns (bool success) {
135         if (balances[_to] + _amount <= balances[_to])
136             return false; // zero or rollover value
137 
138         if (balances[msg.sender] < _amount)
139             return false; // party foul, sender does not have enough sporks
140 
141         balances[msg.sender] -= _amount;
142         balances[_to] += _amount;
143 
144         Transfer(msg.sender, _to, _amount);
145         return true;
146     }
147 
148     /**
149      * @notice Transfer Spork tokens from one account to another
150      * @param _from Account holding tokens for which `msg.sender` is an approved
151      *              spender with an allowance of at least `_amount` tokens
152      * @param _to Account receiving tokens
153      * @param _amount Amount of tokens to transfer
154      * @return Determine if request was successful
155      */
156     function transferFrom(address _from, address _to, uint256 _amount)
157     returns (bool success) {
158         if (balances[_to] + _amount <= balances[_to])
159             return false; // zero or rollover value
160 
161         if (allowed[_from][msg.sender] < _amount)
162             return false; // sender does not have enough allowance
163 
164         if (balances[msg.sender] < _amount)
165             return false; // party foul, sender does not have enough sporks
166 
167         balances[_to] += _amount;
168         balances[_from] -= _amount;
169         allowed[_from][msg.sender] -= _amount;
170 
171         Transfer(_from, _to, _amount);
172         return true;
173     }
174 
175     /**
176      * @notice Determine the Spork token balance for an account
177      * @param _owner Account holding tokens
178      * @return Token balance
179      */
180     function balanceOf(address _owner)
181     constant
182     returns (uint256 balance) {
183         return balances[_owner];
184     }
185 
186     /**
187      * @notice Approve an address to spend tokens on your behalf
188      * @param _spender Account to spend tokens on behalf of `msg.sender`
189      * @param _amount Maximum amount `_spender` can transfer from `msg.sender`
190      * @return Determine if request was successful
191      */
192     function approve(address _spender, uint256 _amount)
193     returns (bool success) {
194         allowed[msg.sender][_spender] = _amount;
195         Approval(msg.sender, _spender, _amount);
196         return true;
197     }
198 
199     /**
200      * @notice Maximum amount a spender can withdraw from an account
201      * @param _owner The account holding tokens
202      * @param _spender The account spending tokens
203      * @return Remaining allowance `_spender` can withdraw from `_owner`
204      */
205     function allowance(address _owner, address _spender)
206     constant
207     returns (uint256 remaining) {
208       return allowed[_owner][_spender];
209     }
210 
211 }