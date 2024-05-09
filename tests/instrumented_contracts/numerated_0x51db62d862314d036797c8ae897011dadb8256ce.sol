1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns(uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns(uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32     modifier onlyOwner() { require(msg.sender == owner); _; }
33 
34     function Ownable() {
35         owner = msg.sender;
36     }
37 
38     function transferOwnership(address newOwner) onlyOwner {
39         require(newOwner != address(0));
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 }
44 
45 contract Pausable is Ownable {
46     bool public paused = false;
47 
48     event Pause();
49     event Unpause();
50 
51     modifier whenNotPaused() { require(!paused); _; }
52     modifier whenPaused() { require(paused); _; }
53 
54     function pause() onlyOwner whenNotPaused {
55         paused = true;
56         Pause();
57     }
58     
59     function unpause() onlyOwner whenPaused {
60         paused = false;
61         Unpause();
62     }
63 }
64 
65 contract ERC20 {
66     uint256 public totalSupply;
67 
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 
71     function balanceOf(address who) constant returns (uint256);
72     function transfer(address to, uint256 value) returns (bool);
73     function transferFrom(address from, address to, uint256 value) returns (bool);
74     function allowance(address owner, address spender) constant returns (uint256);
75     function approve(address spender, uint256 value) returns (bool);
76 }
77 
78 contract StandardToken is ERC20 {
79     using SafeMath for uint256;
80 
81     mapping(address => uint256) balances;
82     mapping(address => mapping(address => uint256)) allowed;
83 
84     function balanceOf(address _owner) constant returns(uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function transfer(address _to, uint256 _value) returns(bool success) {
89         require(_to != address(0));
90 
91         balances[msg.sender] = balances[msg.sender].sub(_value);
92         balances[_to] = balances[_to].add(_value);
93 
94         Transfer(msg.sender, _to, _value);
95 
96         return true;
97     }
98 
99     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
100         require(_to != address(0));
101 
102         var _allowance = allowed[_from][msg.sender];
103 
104         balances[_from] = balances[_from].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         allowed[_from][msg.sender] = _allowance.sub(_value);
107 
108         Transfer(_from, _to, _value);
109 
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
114         return allowed[_owner][_spender];
115     }
116 
117     function approve(address _spender, uint256 _value) returns(bool success) {
118         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
119 
120         allowed[msg.sender][_spender] = _value;
121 
122         Approval(msg.sender, _spender, _value);
123 
124         return true;
125     }
126 
127     function increaseApproval(address _spender, uint _addedValue) returns(bool success) {
128         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
129 
130         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131 
132         return true;
133     }
134 
135     function decreaseApproval(address _spender, uint _subtractedValue) returns(bool success) {
136         uint oldValue = allowed[msg.sender][_spender];
137 
138         if(_subtractedValue > oldValue) {
139             allowed[msg.sender][_spender] = 0;
140         } else {
141             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
142         }
143 
144         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145         
146         return true;
147     }
148 }
149 
150 contract BurnableToken is StandardToken {
151     event Burn(address indexed burner, uint256 value);
152 
153     function burn(uint256 _value) public {
154         require(_value > 0);
155 
156         address burner = msg.sender;
157         balances[burner] = balances[burner].sub(_value);
158         totalSupply = totalSupply.sub(_value);
159         Burn(burner, _value);
160     }
161 }
162 
163 contract OKFToken is BurnableToken, Ownable {
164     string public name = "KickingOff Cinema Token";
165     string public symbol = "OKF";
166     uint256 public decimals = 18;
167     
168     uint256 public INITIAL_SUPPLY = 11000000 * 1 ether;                                // Amount tokens
169 
170     function OKFToken() {
171         totalSupply = INITIAL_SUPPLY;
172         balances[msg.sender] = INITIAL_SUPPLY;
173     }
174 }
175 
176 contract OKFCrowdsale is Pausable {
177     using SafeMath for uint;
178 
179     OKFToken public token;
180     address public beneficiary = 0x97F795fbdEf69ee530d54e7Dc4eCDCc0244aAf00;        // Beneficiary 90%
181     address public command = 0xEe7410eCf01988A61Ba2C3f66283c08859414F6B;            // Command 10%
182 
183     uint public collectedWei;
184     uint public collectedUSD;
185     uint public tokensSold;
186 
187     uint public tokensForSale = 10000000 * 1 ether;                                 // Amount tokens for sale
188     uint public priceETHUSD = 250;                                                  // Ether price USD
189     uint public softCapUSD = 1500000;                                               // Soft cap USD
190     uint public hardCapUSD = 2500000;                                               // Hard cap USD
191     uint public softCapWei = softCapUSD * 1 ether / priceETHUSD;
192     uint public hardCapWei = hardCapUSD * 1 ether / priceETHUSD;
193     uint public priceTokenWei = 1 ether / 1000;
194 
195     uint public startTime = 1507032000;                                             // Date start 03.10.2017 12:00 +0
196     uint public endTime = 1517659200;                                               // Date end 03.02.2018 12:00 +0
197     bool public crowdsaleFinished = false;
198 
199     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
200     event SoftCapReached(uint256 etherAmount);
201     event HardCapReached(uint256 etherAmount);
202     event Withdraw();
203 
204     function OKFCrowdsale() {
205         token = new OKFToken();
206         require(token.transfer(0x915c517cB57fAB7C532262cB9f109C875bEd7d18, 1000000 * 1 ether));    // Bounty tokens
207     }
208 
209     function() payable {
210         purchase();
211     }
212     
213     function purchase() whenNotPaused payable {
214         require(!crowdsaleFinished);
215         require(now >= startTime && now < endTime);
216         require(tokensSold < tokensForSale);
217         require(msg.value >= 0.001 * 1 ether);
218         require(msg.value <= 50 * 1 ether);
219 
220         uint sum = msg.value;
221         uint amount = sum.div(priceTokenWei).mul(1 ether);
222         
223         if(tokensSold.add(amount) > tokensForSale) {
224             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
225             uint retSum = retAmount.mul(priceTokenWei).div(1 ether);
226 
227             amount = amount.sub(retAmount);
228             sum = sum.sub(retSum);
229 
230             require(msg.sender.send(retSum));
231         }
232 
233         require(token.transfer(msg.sender, amount));
234         require(beneficiary.send(sum.div(100).mul(90)));
235         require(command.send(sum.sub(sum.div(100).mul(90))));
236 
237         if(collectedWei < softCapWei && collectedWei.add(sum) >= softCapWei) {
238             SoftCapReached(collectedWei);
239         }
240 
241         if(collectedWei < hardCapWei && collectedWei.add(sum) >= hardCapWei) {
242             HardCapReached(collectedWei);
243         }
244 
245         tokensSold = tokensSold.add(amount);
246         collectedWei = collectedWei.add(sum);
247         collectedUSD = collectedWei * priceETHUSD / 1 ether;
248 
249         NewContribution(msg.sender, amount, sum);
250     }
251 
252     function withdraw() onlyOwner {
253         require(!crowdsaleFinished);
254 
255         token.transfer(beneficiary, token.balanceOf(this));
256         token.transferOwnership(beneficiary);
257         crowdsaleFinished = true;
258 
259         Withdraw();
260     }
261 }