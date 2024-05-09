1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract MANToken {
6     string public name; // MAN
7     string public symbol; // MAN
8     uint256 public decimals = 18;
9     uint256 DECIMALSFACTOR = 10**decimals;
10     uint256 constant weiDECIMALS = 18; 
11     uint256 weiFACTOR =  10 ** weiDECIMALS; 
12     
13     address ethFundAddress  = 0xdF039a39899eC1Bc571eBcb7944B3b3A0A30C36d; 
14 
15     address address1 = 0x75C6CBe2cd50932D1E565A9B1Aea9F7671c7fEbc; 
16     address address2 = 0xD94D499685bDdC28477f394bf3d7e4Ba729077f6; 
17     address address3 = 0x11786422E7dF7A88Ea47C2dA76EE0a94aD2c5c64; 
18     address address4 = 0xb1Df8C1a78582Db6CeEbFe6aAE3E01617198322e; 
19     address address5 = 0x7eCc05F2da74036a9152dB3a4891f0AFDBB4eCc2; 
20     address address6 = 0x39aC1d06EA941E2A41113F54737D49d9dD2c5022; 
21     address address7 = 0x371895F2000053a61216011Aa43542cdd0dEb750; 
22     address address8 = 0xf6a5F686bAd809b2Eb163fBE7Df646c472458852; 
23     address address9 = 0xD21eF6388b232E5ceb6c2a43F93D7337dEb63274; 
24     address address10 = 0xE92fFe240773E1F60fe17db7fAF8a3CdCD7bC6EC;
25 
26     uint256 public startTime; 
27     uint256 public endTime; 
28     uint256 lockedDuration = 3 * 24 * 60 * 60; 
29     uint256 tokenPerETH = 3780; 
30 
31     address contractOwner; 
32     uint256 ethRaised; 
33     uint256 tokenDistributed; 
34     uint256 donationCount; 
35     uint256 public currentTokenPerETH = tokenPerETH;     
36 
37     uint256 public totalSupply = 250 * (10**6) * DECIMALSFACTOR;
38     uint256 softCap = 20 * (10**6) * DECIMALSFACTOR; 
39     uint256 reservedAmountPerAddress = 20 * (10**6) * DECIMALSFACTOR;
40     uint256 minimumDonation = 5 * 10 ** (weiDECIMALS - 1); 
41     
42     uint256 public availableSupply = totalSupply; 
43     uint8 public currentStage = 0;
44     bool public isInLockStage = true;
45     bool public finalised = false;
46 
47     mapping (address => uint256) public balanceOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     // This generates a public event on the blockchain that will notify clients
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     // This notifies clients about the amount burnt
54     event Burn(address indexed from, uint256 value);
55 
56     function MANToken(
57         string tokenName,
58         string tokenSymbol,
59         uint256 _startTimestamp,
60         uint256 _endTimestamp) 
61     public {
62         contractOwner = msg.sender;
63 
64         name = tokenName; 
65         symbol = tokenSymbol; 
66         startTime = _startTimestamp;
67         endTime = _endTimestamp; 
68 
69         balanceOf[address1] += reservedAmountPerAddress;
70         availableSupply -= reservedAmountPerAddress;
71 
72         balanceOf[address2] += reservedAmountPerAddress;
73         availableSupply -= reservedAmountPerAddress;
74 
75         balanceOf[address3] += reservedAmountPerAddress;
76         availableSupply -= reservedAmountPerAddress;
77 
78         balanceOf[address4] += reservedAmountPerAddress;
79         availableSupply -= reservedAmountPerAddress;
80 
81         balanceOf[address5] += reservedAmountPerAddress;
82         availableSupply -= reservedAmountPerAddress;
83 
84         balanceOf[address6] += reservedAmountPerAddress;
85         availableSupply -= reservedAmountPerAddress;
86 
87         balanceOf[address7] += reservedAmountPerAddress;
88         availableSupply -= reservedAmountPerAddress;
89 
90         balanceOf[address8] += reservedAmountPerAddress;
91         availableSupply -= reservedAmountPerAddress;
92 
93         balanceOf[address9] += reservedAmountPerAddress;
94         availableSupply -= reservedAmountPerAddress;
95 
96         balanceOf[address10] += reservedAmountPerAddress;
97         availableSupply -= reservedAmountPerAddress;
98 
99         balanceOf[contractOwner] = availableSupply;
100     }
101 
102 
103     function () payable public {
104         require(!finalised);
105 
106         require(block.timestamp >= startTime);
107         require(block.timestamp <= endTime);
108 
109         require(availableSupply > 0);
110 
111         mintMAN(); 
112     }
113 
114     function mintMAN() payable public {
115         require(msg.value >= minimumDonation); 
116 
117         uint256 preLockedTime = startTime + lockedDuration;
118         
119         if (block.timestamp <= preLockedTime) { 
120             currentStage = 0;
121             isInLockStage = true;
122         }else if (block.timestamp > preLockedTime && tokenDistributed <= softCap) { 
123             currentStage = 1;
124             isInLockStage = true;
125         }else if (block.timestamp > preLockedTime && tokenDistributed <= 35 * (10**6) * DECIMALSFACTOR) { 
126             currentTokenPerETH = 3430;
127             currentStage = 2;
128             isInLockStage = false;
129         }else if (block.timestamp > preLockedTime && tokenDistributed >= 35 * (10**6) * DECIMALSFACTOR) { 
130             currentTokenPerETH = 3150;
131             currentStage = 3;
132             isInLockStage = false;
133         }
134 
135         uint256 tokenValue = currentTokenPerETH * msg.value / 10 ** (weiDECIMALS - decimals);
136         uint256 etherValue = msg.value;
137 
138         if (tokenValue > availableSupply) {
139             tokenValue = availableSupply;
140             
141             etherValue = weiFACTOR * availableSupply / currentTokenPerETH / DECIMALSFACTOR;
142 
143             require(msg.sender.send(msg.value - etherValue));
144         }
145 
146         ethRaised += etherValue;
147         donationCount += 1;
148         availableSupply -= tokenValue;
149 
150         _transfer(contractOwner, msg.sender, tokenValue);
151         tokenDistributed += tokenValue;
152 
153         require(ethFundAddress.send(etherValue));
154     }
155 
156     /**
157      * Internal transfer, only can be called by this contract
158      */
159     function _transfer(address _from, address _to, uint _value) internal {
160         // Prevent transfer to 0x0 address. Use burn() instead
161         require(_to != 0x0);
162         // Check if the sender has enough
163         require(balanceOf[_from] >= _value);
164         // Check for overflows
165         require(balanceOf[_to] + _value > balanceOf[_to]);
166         // Save this for an assertion in the future
167         uint previousBalances = balanceOf[_from] + balanceOf[_to];
168         // Subtract from the sender
169         balanceOf[_from] -= _value;
170         // Add the same to the recipient
171         balanceOf[_to] += _value;
172         Transfer(_from, _to, _value);
173         // Asserts are used to use static analysis to find bugs in your code. They should never fail
174         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
175     }
176 
177     function transfer(address _to, uint256 _value) public {
178         require(!isInLockStage);
179         _transfer(msg.sender, _to, _value);
180     }
181 
182     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
183         require(_value <= allowance[_from][msg.sender]);     // Check allowance
184         allowance[_from][msg.sender] -= _value;
185         _transfer(_from, _to, _value);
186         return true;
187     }
188 
189     function approve(address _spender, uint256 _value) public
190         returns (bool success) {
191         allowance[msg.sender][_spender] = _value;
192         return true;
193     }
194 
195     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
196         public
197         returns (bool success) {
198         tokenRecipient spender = tokenRecipient(_spender);
199         if (approve(_spender, _value)) {
200             spender.receiveApproval(msg.sender, _value, this, _extraData);
201             return true;
202         }
203     }
204 
205     function burn(uint256 _value) public returns (bool success) {
206         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
207         balanceOf[msg.sender] -= _value;            // Subtract from the sender
208         totalSupply -= _value;                      // Updates totalSupply
209         Burn(msg.sender, _value);
210         return true;
211     }
212 
213     function burnFrom(address _from, uint256 _value) public returns (bool success) {
214         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
215         require(_value <= allowance[_from][msg.sender]);    // Check allowance
216         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
217         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
218         totalSupply -= _value;                              // Update totalSupply
219         Burn(_from, _value);
220         return true;
221     }
222 
223     function finalise() public {
224         require( msg.sender == contractOwner );
225         require(!finalised);
226 
227         finalised = true;
228     } 
229 
230 	function unlockTokens() public {
231         require(msg.sender == contractOwner);
232         isInLockStage = false;
233     }
234 
235     function tokenHasDistributed() public constant returns (uint256) {
236         return tokenDistributed;
237     }
238 }