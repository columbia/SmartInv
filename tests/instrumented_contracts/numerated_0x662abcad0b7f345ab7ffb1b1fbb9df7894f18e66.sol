1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8 
9     uint constant DAY_IN_SECONDS = 86400;
10     uint constant BASE = 1000000000000000000;
11     uint constant preIcoPrice = 4101;
12     uint constant icoPrice = 2255;
13 
14     function mul(uint256 a, uint256 b) constant internal returns (uint256) {
15         uint256 c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) constant internal returns (uint256) {
21         assert(b != 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) constant internal returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) constant internal returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 
38     function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal returns (uint256) {
39         return div(mul(number, numerator), denominator);
40     }
41 
42     // presale volume bonus calculation 
43     function presaleVolumeBonus(uint256 price) internal returns (uint256) {
44 
45         // preCTX > ETH
46         uint256 val = div(price, preIcoPrice);
47 
48         if(val >= 100 * BASE) return add(price, price * 1/20); // 5%
49         if(val >= 50 * BASE) return add(price, price * 3/100); // 3%
50         if(val >= 20 * BASE) return add(price, price * 1/50);  // 2%
51 
52         return price;
53     }
54 
55 	// ICO volume bonus calculation 
56     function volumeBonus(uint256 etherValue) internal returns (uint256) {
57 		
58         if(etherValue >= 1000000000000000000000) return 15;// +15% tokens
59         if(etherValue >=  500000000000000000000) return 10; // +10% tokens
60         if(etherValue >=  300000000000000000000) return 7;  // +7% tokens
61         if(etherValue >=  100000000000000000000) return 5;  // +5% tokens
62         if(etherValue >=   50000000000000000000) return 3;   // +3% tokens
63         if(etherValue >=   20000000000000000000) return 2;   // +2% tokens
64 
65         return 0;
66     }
67 
68 	// ICO date bonus calculation 
69     function dateBonus(uint startIco) internal returns (uint256) {
70 
71         // day from ICO start
72         uint daysFromStart = (now - startIco) / DAY_IN_SECONDS + 1;
73 
74         if(daysFromStart == 1) return 15; // +15% tokens
75         if(daysFromStart == 2) return 10; // +10% tokens
76         if(daysFromStart == 3) return 10; // +10% tokens
77         if(daysFromStart == 4) return 5;  // +5% tokens
78         if(daysFromStart == 5) return 5;  // +5% tokens
79         if(daysFromStart == 6) return 5;  // +5% tokens
80 
81 		// no discount
82         return 0;
83     }
84 
85 }
86 
87 
88 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
89 /// @title Abstract token contract - Functions to be implemented by token contracts.
90 
91 contract AbstractToken {
92     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
93     function totalSupply() constant returns (uint256) {}
94     function balanceOf(address owner) constant returns (uint256 balance);
95     function transfer(address to, uint256 value) returns (bool success);
96     function transferFrom(address from, address to, uint256 value) returns (bool success);
97     function approve(address spender, uint256 value) returns (bool success);
98     function allowance(address owner, address spender) constant returns (uint256 remaining);
99 
100     event Transfer(address indexed from, address indexed to, uint256 value);
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102     event Issuance(address indexed to, uint256 value);
103 }
104 
105 contract StandardToken is AbstractToken {
106     /*
107      *  Data structures
108      */
109     mapping (address => uint256) balances;
110     mapping (address => bool) ownerAppended;
111     mapping (address => mapping (address => uint256)) allowed;
112     uint256 public totalSupply;
113     address[] public owners;
114 
115     /*
116      *  Read and write storage functions
117      */
118     /// @dev Transfers sender's tokens to a given address. Returns success.
119     /// @param _to Address of token receiver.
120     /// @param _value Number of tokens to transfer.
121     function transfer(address _to, uint256 _value) returns (bool success) {
122         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
123             balances[msg.sender] -= _value;
124             balances[_to] += _value;
125             if(!ownerAppended[_to]) {
126                 ownerAppended[_to] = true;
127                 owners.push(_to);
128             }
129             Transfer(msg.sender, _to, _value);
130             return true;
131         }
132         else {
133             return false;
134         }
135     }
136 
137     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
138     /// @param _from Address from where tokens are withdrawn.
139     /// @param _to Address to where tokens are sent.
140     /// @param _value Number of tokens to transfer.
141     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
142         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
143             balances[_to] += _value;
144             balances[_from] -= _value;
145             allowed[_from][msg.sender] -= _value;
146             if(!ownerAppended[_to]) {
147                 ownerAppended[_to] = true;
148                 owners.push(_to);
149             }
150             Transfer(_from, _to, _value);
151             return true;
152         }
153         else {
154             return false;
155         }
156     }
157 
158     /// @dev Returns number of tokens owned by given address.
159     /// @param _owner Address of token owner.
160     function balanceOf(address _owner) constant returns (uint256 balance) {
161         return balances[_owner];
162     }
163 
164     /// @dev Sets approved amount of tokens for spender. Returns success.
165     /// @param _spender Address of allowed account.
166     /// @param _value Number of approved tokens.
167     function approve(address _spender, uint256 _value) returns (bool success) {
168         allowed[msg.sender][_spender] = _value;
169         Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     /*
174      * Read storage functions
175      */
176     /// @dev Returns number of allowed tokens for given address.
177     /// @param _owner Address of token owner.
178     /// @param _spender Address of token spender.
179     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
180         return allowed[_owner][_spender];
181     }
182 
183 }
184 
185 
186 contract CarTaxiToken is StandardToken, SafeMath {
187     /*
188      * Token meta data
189      */
190     string public constant name = "CarTaxi";
191     string public constant symbol = "CTX";
192     uint public constant decimals = 18;
193 
194     // tottal supply
195 
196     address public icoContract = 0x0;
197     /*
198      * Modifiers
199      */
200 
201     modifier onlyIcoContract() {
202         // only ICO contract is allowed to proceed
203         require(msg.sender == icoContract);
204         _;
205     }
206 
207     /*
208      * Contract functions
209      */
210 
211     /// @dev Contract is needed in icoContract address
212     /// @param _icoContract Address of account which will be mint tokens
213     function CarTaxiToken(address _icoContract) {
214         assert(_icoContract != 0x0);
215         icoContract = _icoContract;
216     }
217 
218     /// @dev Burns tokens from address. It's can be applied by account with address this.icoContract
219     /// @param _from Address of account, from which will be burned tokens
220     /// @param _value Amount of tokens, that will be burned
221     function burnTokens(address _from, uint _value) onlyIcoContract {
222         assert(_from != 0x0);
223         require(_value > 0);
224 
225         balances[_from] = sub(balances[_from], _value);
226     }
227 
228     /// @dev Adds tokens to address. It's can be applied by account with address this.icoContract
229     /// @param _to Address of account to which the tokens will pass
230     /// @param _value Amount of tokens
231     function emitTokens(address _to, uint _value) onlyIcoContract {
232         assert(_to != 0x0);
233         require(_value > 0);
234 
235         balances[_to] = add(balances[_to], _value);
236 
237         if(!ownerAppended[_to]) {
238             ownerAppended[_to] = true;
239             owners.push(_to);
240         }
241 
242     }
243 
244     function getOwner(uint index) constant returns (address, uint256) {
245         return (owners[index], balances[owners[index]]);
246     }
247 
248     function getOwnerCount() constant returns (uint) {
249         return owners.length;
250     }
251 
252 }