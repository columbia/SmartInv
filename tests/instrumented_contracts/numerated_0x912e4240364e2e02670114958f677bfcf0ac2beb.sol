1 pragma solidity ^0.4.18;
2 /**
3 *   Crowdsale contracts edited from original contract code at https://www.ethereum.org/crowdsale#crowdfund-your-idea
4 *   Additional crowdsale contracts, functions, libraries from OpenZeppelin
5 *       at https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token
6 *   Token contract edited from original contract code at https://www.ethereum.org/token
7 *   ERC20 interface and certain token functions adapted from https://github.com/ConsenSys/Tokens
8 **/
9 contract ERC20 {
10     //Sets events and functions for ERC20 token
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12     event Transfer(address indexed _from, address indexed _to, uint _value);
13     function allowance(address _owner, address _spender) public constant returns (uint remaining);
14     function approve(address _spender, uint _value) public returns (bool success);
15     function balanceOf(address _owner) public constant returns (uint balance);
16     function transfer(address _to, uint _value) public returns (bool success);
17     function transferFrom(address _from, address _to, uint _value) returns (bool success);
18 }
19 
20 contract Owned {
21     //Public variable
22     address public owner;
23     //Sets contract creator as the owner
24     function Owned() {
25         owner = msg.sender;
26     }
27     //Sets onlyOwner modifier for specified functions
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32     //Allows for transfer of contract ownership
33     function transferOwnership(address newOwner) onlyOwner {
34         owner = newOwner;
35     }
36 }
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43     function div(uint256 a, uint256 b) internal returns (uint256) {
44         // assert(b > 0); // Solidity automatically throws when dividing by 0
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47         return c;
48     }
49     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
50         return a >= b ? a : b;
51     }
52     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
53         return a >= b ? a : b;
54     }
55     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
56         return a < b ? a : b;
57     }
58     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
59         return a < b ? a : b;
60     }
61     function mul(uint256 a, uint256 b) internal returns (uint256) {
62         uint256 c = a * b;
63         assert(a == 0 || c / a == b);
64         return c;
65     }
66     function sub(uint256 a, uint256 b) internal returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 }
71 contract Funioza is ERC20, Owned {
72     //Applies SafeMath library to uint256 operations
73     using SafeMath for uint256;
74     //Public variables
75     string public name;
76     string public symbol;
77     uint256 public decimals;
78     uint256 public totalSupply;
79     //Variables
80     uint256 multiplier;
81     //Creates arrays for balances
82     mapping (address => uint256) balance;
83     mapping (address => mapping (address => uint256)) allowed;
84     //Creates modifier to prevent short address attack
85     modifier onlyPayloadSize(uint size) {
86         if(msg.data.length < size + 4) revert();
87         _;
88     }
89     //Constructor
90     function Funioza(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier) {
91         name = tokenName;
92         symbol = tokenSymbol;
93         decimals = decimalUnits;
94         multiplier = decimalMultiplier;
95     }
96     //Provides the remaining balance of approved tokens from function approve
97     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
98       return allowed[_owner][_spender];
99     }
100     //Allows for a certain amount of tokens to be spent on behalf of the account owner
101     function approve(address _spender, uint256 _value) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106     //Returns the account balance
107     function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
108         return balance[_owner];
109     }
110     //Allows contract owner to mint new tokens, prevents numerical overflow
111     function mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {
112         require(mintedAmount > 0);
113         uint256 addTokens = mintedAmount;
114         balance[target] += addTokens;
115         totalSupply += addTokens;
116         Transfer(0, target, addTokens);
117         return true;
118     }
119     //Sends tokens from sender's account
120     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
121         if ((balance[msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
122             balance[msg.sender] -= _value;
123             balance[_to] += _value;
124             Transfer(msg.sender, _to, _value);
125             return true;
126         } else {
127             return false;
128         }
129     }
130     //Transfers tokens from an approved account
131     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
132         if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
133             balance[_to] += _value;
134             balance[_from] -= _value;
135             allowed[_from][msg.sender] -= _value;
136             Transfer(_from, _to, _value);
137             return true;
138         } else {
139             return false;
140         }
141     }
142 }
143 contract FuniozaICO is Owned, Funioza {
144     //Applies SafeMath library to uint256 operations
145     using SafeMath for uint256;
146     //Public Variables
147     address public multiSigWallet;
148     uint256 public amountRaised;
149     uint256 public startTime;
150     uint256 public stopTime;
151     uint256 public hardcap;
152     uint256 public price;
153     //Variables
154     bool crowdsaleClosed = true;
155     string tokenName = "Funioza";
156     string tokenSymbol = "FNZ";
157     uint8 decimalUnits = 8;
158     uint256 multiplier = 100000000;
159 
160     uint256 public _v;
161     uint256 public _v2;
162     uint256 public _v3;
163     uint256 public _v4;
164 
165     function FuniozaICO()
166         Funioza(tokenName, tokenSymbol, decimalUnits, multiplier) {
167             multiSigWallet = msg.sender;
168             hardcap = 180000000;
169             hardcap = hardcap.mul(multiplier);
170     }
171 
172     //Fallback function creates tokens and sends to investor when crowdsale is open
173     function () payable {
174         require(!crowdsaleClosed
175             && (now < stopTime)
176             && (totalSupply.add(msg.value.mul(getPrice()).mul(multiplier).div(1 ether)) <= hardcap));
177         address recipient = msg.sender;
178         amountRaised = amountRaised.add(msg.value.div(1 ether));
179         uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);
180         totalSupply = totalSupply.add(tokens);
181         balance[recipient] = balance[recipient].add(tokens);
182         require(multiSigWallet.send(msg.value));
183         Transfer(0, recipient, tokens);
184     }
185 
186     //Returns the current price of the token for the crowdsale
187     function getPrice() returns (uint256 result) {
188         return price;
189     }
190     //Returns time remaining on crowdsale
191     function getRemainingTime() constant returns (uint256) {
192         return stopTime;
193     }
194     //Set the sale hardcap amount
195     function setHardCapValue(uint256 newHardcap) onlyOwner returns (bool success) {
196         hardcap = newHardcap.mul(multiplier);
197         return true;
198     }
199     //Sets the multisig wallet for a crowdsale
200     function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {
201         multiSigWallet = wallet;
202         return true;
203     }
204     //Sets the token price
205     function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {
206         require(newPriceperEther > 0);
207         price = newPriceperEther;
208         return price;
209     }
210     //Allows owner to start the crowdsale from the time of execution until a specified stopTime
211     function startSale(uint256 saleStart, uint256 saleStop, uint256 salePrice, address setBeneficiary) onlyOwner returns (bool success) {
212         require(saleStop > now);
213         //startTime = 1502881261; // 16 August 2017, 11:01 AM GMT
214         //stopTime = 1504263601;  // 1 September 2017, 11:00 AM GMT
215 
216         startTime = saleStart;
217         stopTime = saleStop;
218         crowdsaleClosed = false;
219         setPrice(salePrice);
220         setMultiSigWallet(setBeneficiary);
221         return true;
222     }
223     //Allows owner to stop the crowdsale immediately
224     function stopSale() onlyOwner returns (bool success) {
225         stopTime = now;
226         crowdsaleClosed = true;
227         return true;
228     }
229 }