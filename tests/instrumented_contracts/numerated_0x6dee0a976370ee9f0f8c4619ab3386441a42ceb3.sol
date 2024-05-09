1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract CoinifinexToken {
6 	// Setting constant
7 	uint256 constant public TOTAL_TOKEN = 10 ** 9;
8 	uint256 constant public TOKEN_FOR_ICO = 650 * 10 ** 6;
9 	uint256 constant public TOKEN_FOR_COMPANY = 200 * 10 ** 6;
10 	uint256 constant public TOKEN_FOR_BONUS = 50 * 10 ** 6;
11 	
12 	mapping (address => uint256) public tokenForTeam;
13 	mapping (address => uint256) public tokenForTeamGet;
14 	address[] public teamAddress;
15 
16 	uint public startTime;
17 	
18     // Public variables of the token
19     string public name;
20     string public symbol;
21     uint8 public decimals = 8;
22     // 18 decimals is the strongly suggested default, avoid changing it
23     uint256 public totalSupply;
24 
25     // This creates an array with all balances
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28 
29     // This generates a public event on the blockchain that will notify clients
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     // This notifies clients about the amount burnt
33     event Burn(address indexed from, uint256 value);
34 
35     /**
36      * Constrctor function
37      *
38      * Initializes contract with initial supply tokens to the creator of the contract
39      */
40     function CoinifinexToken(
41     ) public {
42         totalSupply = TOTAL_TOKEN * 10 ** uint256(decimals); // Update total supply with the decimal amount
43         name = "Coinifinex";                                 // Set the name for display purposes
44         symbol = "CFX";                               		// Set the symbol for display purposes
45 		
46 		// Initializes
47 		startTime = 1538265600; // 09/30/2018 @ 12:00am (UTC)
48 		
49 		tokenForTeam[0x4B7786bD8eB1F738699290Bb83cA8E28fEDea4b0] =	20 * 10 ** 6 * 10 ** uint256(decimals);
50 		tokenForTeam[0x040440286a443822211dDe0e7E9DA3F49aF2EBC7] =	20 * 10 ** 6 * 10 ** uint256(decimals);
51 		tokenForTeam[0x4f7a5A2BafAd56562ac4Ccc85FE004BB84435F71] =	20 * 10 ** 6 * 10 ** uint256(decimals);
52 		tokenForTeam[0x7E0D3AaaCB57b0Fd109D9F16e00a375ECa48b41D] =	20 * 10 ** 6 * 10 ** uint256(decimals);
53 		tokenForTeam[0xc456aC342f17E7003A03479e275fDA322dE38681] =	500  * 10 ** 3 * 10 ** uint256(decimals);
54 		tokenForTeam[0xB19d3c4c494B5a3d5d72E0e47076AefC1c643D24] =	300  * 10 ** 3 * 10 ** uint256(decimals);
55 		tokenForTeam[0x88311485647e19510298d7Dbf0a346D5B808DF03] =	500  * 10 ** 3 * 10 ** uint256(decimals);
56 		tokenForTeam[0x2f2754e403b58D8F21c4Ba501eff4c5f0dd95b7F] =	500  * 10 ** 3 * 10 ** uint256(decimals);
57 		tokenForTeam[0x45cD08764e06c1563d4B13b85cCE7082Be0bA6D1] =	100  * 10 ** 3 * 10 ** uint256(decimals);
58 		tokenForTeam[0xB08924a0D0AF93Fa29e5B0ba103A339704cdeFdb] =	100  * 10 ** 3 * 10 ** uint256(decimals);
59 		tokenForTeam[0xa8bD7C22d37ea1887b425a9B0A3458A186bf6E77] =	1 * 10 ** 6 * 10 ** uint256(decimals);
60 		tokenForTeam[0xe387125f1b24E59f7811d26fbb26bdA1c599b061] =	1 * 10 ** 6 * 10 ** uint256(decimals);
61 		tokenForTeam[0xC5b644c5fDe01fce561496179a8Bb7886349bD75] =	1 * 10 ** 6 * 10 ** uint256(decimals);
62 		tokenForTeam[0xe4dB43bcB8aecFf58C720F70414A9d36Fd7B9F78] =	5 * 10 ** 6 * 10 ** uint256(decimals);
63 		tokenForTeam[0xf28edB52E808cd9DCe18A87fD94D373D6B9f65ae] =	5 * 10 ** 6 * 10 ** uint256(decimals);
64 		tokenForTeam[0x87CE30ad0B66266b30c206a9e39A3FC0970db5eF] =	5 * 10 ** 6 * 10 ** uint256(decimals);
65 		
66 		// address of teams
67 		teamAddress.push(0x4B7786bD8eB1F738699290Bb83cA8E28fEDea4b0);
68 		teamAddress.push(0x040440286a443822211dDe0e7E9DA3F49aF2EBC7);
69 		teamAddress.push(0x4f7a5A2BafAd56562ac4Ccc85FE004BB84435F71);
70 		teamAddress.push(0x7E0D3AaaCB57b0Fd109D9F16e00a375ECa48b41D);
71 		teamAddress.push(0xc456aC342f17E7003A03479e275fDA322dE38681);
72 		teamAddress.push(0xB19d3c4c494B5a3d5d72E0e47076AefC1c643D24);
73 		teamAddress.push(0x88311485647e19510298d7Dbf0a346D5B808DF03);
74 		teamAddress.push(0x2f2754e403b58D8F21c4Ba501eff4c5f0dd95b7F);
75 		teamAddress.push(0x45cD08764e06c1563d4B13b85cCE7082Be0bA6D1);
76 		teamAddress.push(0xB08924a0D0AF93Fa29e5B0ba103A339704cdeFdb);
77 		teamAddress.push(0xa8bD7C22d37ea1887b425a9B0A3458A186bf6E77);
78 		teamAddress.push(0xe387125f1b24E59f7811d26fbb26bdA1c599b061);
79 		teamAddress.push(0xC5b644c5fDe01fce561496179a8Bb7886349bD75);
80 		teamAddress.push(0xe4dB43bcB8aecFf58C720F70414A9d36Fd7B9F78);
81 		teamAddress.push(0xf28edB52E808cd9DCe18A87fD94D373D6B9f65ae);
82 		teamAddress.push(0x87CE30ad0B66266b30c206a9e39A3FC0970db5eF);
83 
84 		uint arrayLength = teamAddress.length;
85 		for (uint i=0; i<arrayLength; i++) {
86 			tokenForTeamGet[teamAddress[i]] = tokenForTeam[teamAddress[i]] * 1 / 10; // first period
87 			balanceOf[teamAddress[i]] = tokenForTeamGet[teamAddress[i]];
88 			tokenForTeam[teamAddress[i]] -= tokenForTeamGet[teamAddress[i]];
89 		}
90 		balanceOf[0x966F2884524858326DfF216394a61b9894166c68] = TOKEN_FOR_ICO * 10 ** uint256(decimals);
91 		balanceOf[0x8eee1a576FaF1332466AaDD9F35Ebf5b6e0162c9] = TOKEN_FOR_COMPANY * 10 ** uint256(decimals);
92 		balanceOf[0xAe77D38cba1AA5D5288DFC5834a16CcD24dd4041] = TOKEN_FOR_BONUS * 10 ** uint256(decimals);
93     }
94 
95     /**
96      * Internal transfer, only can be called by this contract
97      */
98     function _transfer(address _from, address _to, uint _value) internal {
99         // Prevent transfer to 0x0 address. Use burn() instead
100         require(_to != 0x0);
101         // Check if the sender has enough
102         require(balanceOf[_from] >= _value);
103         // Check for overflows
104         require(balanceOf[_to] + _value > balanceOf[_to]);
105         // Save this for an assertion in the future
106         uint previousBalances = balanceOf[_from] + balanceOf[_to];
107         // Subtract from the sender
108         balanceOf[_from] -= _value;
109         // Add the same to the recipient
110         balanceOf[_to] += _value;
111         Transfer(_from, _to, _value);
112         // Asserts are used to use static analysis to find bugs in your code. They should never fail
113         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
114     }
115 
116     /**
117      * Transfer tokens
118      *
119      * Send `_value` tokens to `_to` from your account
120      *
121      * @param _to The address of the recipient
122      * @param _value the amount to send
123      */
124     function transfer(address _to, uint256 _value) public {
125         _transfer(msg.sender, _to, _value);
126     }
127 
128     /**
129      * Transfer tokens from other address
130      *
131      * Send `_value` tokens to `_to` in behalf of `_from`
132      *
133      * @param _from The address of the sender
134      * @param _to The address of the recipient
135      * @param _value the amount to send
136      */
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
138         require(_value <= allowance[_from][msg.sender]);     // Check allowance
139         allowance[_from][msg.sender] -= _value;
140         _transfer(_from, _to, _value);
141         return true;
142     }
143 
144     /**
145      * Set allowance for other address
146      *
147      * Allows `_spender` to spend no more than `_value` tokens in your behalf
148      *
149      * @param _spender The address authorized to spend
150      * @param _value the max amount they can spend
151      */
152     function approve(address _spender, uint256 _value) public
153         returns (bool success) {
154         allowance[msg.sender][_spender] = _value;
155         return true;
156     }
157 
158     /**
159      * Set allowance for other address and notify
160      *
161      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
162      *
163      * @param _spender The address authorized to spend
164      * @param _value the max amount they can spend
165      * @param _extraData some extra information to send to the approved contract
166      */
167     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
168         public
169         returns (bool success) {
170         tokenRecipient spender = tokenRecipient(_spender);
171         if (approve(_spender, _value)) {
172             spender.receiveApproval(msg.sender, _value, this, _extraData);
173             return true;
174         }
175     }
176 
177     /**
178      * Destroy tokens
179      *
180      * Remove `_value` tokens from the system irreversibly
181      *
182      * @param _value the amount of money to burn
183      */
184     function burn(uint256 _value) public returns (bool success) {
185         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
186         balanceOf[msg.sender] -= _value;            // Subtract from the sender
187         totalSupply -= _value;                      // Updates totalSupply
188         Burn(msg.sender, _value);
189         return true;
190     }
191 
192     /**
193      * Destroy tokens from other account
194      *
195      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
196      *
197      * @param _from the address of the sender
198      * @param _value the amount of money to burn
199      */
200     function burnFrom(address _from, uint256 _value) public returns (bool success) {
201         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
202         require(_value <= allowance[_from][msg.sender]);    // Check allowance
203         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
204         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
205         totalSupply -= _value;                              // Update totalSupply
206         Burn(_from, _value);
207         return true;
208     }
209 	
210 	function getTeamFund() public {
211 		// Second period after 9 months
212 		if (now >= startTime + 270 days) {
213 			if (tokenForTeamGet[msg.sender] <  tokenForTeam[msg.sender] * 55 / 100) {
214 				uint256 getValue2 = tokenForTeam[msg.sender] * 45 / 100;
215 				tokenForTeamGet[msg.sender] += getValue2; // first period
216 				balanceOf[msg.sender] += getValue2;		
217 			}
218 		}
219 		
220 		// Third period after 9 + 6 months
221 		if (now >= startTime + 450 days) {
222 			if (tokenForTeamGet[msg.sender] <  tokenForTeam[msg.sender]) {
223 				uint256 getValue3 = tokenForTeam[msg.sender] * 45 / 100;
224 				tokenForTeamGet[msg.sender] += getValue3; // first period
225 				balanceOf[msg.sender] += getValue3;	
226 			}			
227 		}
228     }
229 }