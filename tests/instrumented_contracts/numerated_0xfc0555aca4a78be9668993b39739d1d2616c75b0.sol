1 pragma solidity ^0.4.20;
2 
3 interface ERC20Token {
4 
5     function totalSupply() constant external returns (uint256 supply);
6 
7     function balanceOf(address _owner) constant external returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value) external returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
12 
13     function approve(address _spender, uint256 _value) external returns (bool success);
14 
15     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract Token is ERC20Token{
22     mapping (address => uint256) balances;
23     mapping (address => mapping (address => uint256)) allowed;
24 
25     uint256 public totalSupply;
26 
27     function balanceOf(address _owner) constant external returns (uint256 balance) {
28         return balances[_owner];
29     }
30 
31     function transfer(address _to, uint256 _value) external returns (bool success) {
32         if(msg.data.length < (2 * 32) + 4) { revert(); }
33 
34         if (balances[msg.sender] >= _value && _value > 0) {
35             balances[msg.sender] -= _value;
36             balances[_to] += _value;
37             Transfer(msg.sender, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
43         if(msg.data.length < (3 * 32) + 4) { revert(); }
44 
45         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
46             balances[_to] += _value;
47             balances[_from] -= _value;
48             allowed[_from][msg.sender] -= _value;
49             Transfer(_from, _to, _value);
50             return true;
51         } else { return false; }
52     }
53 
54     function approve(address _spender, uint256 _value) external returns (bool success) {
55         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
56 
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     function allowance(address _owner, address _spender) constant external returns (uint256 remaining) {
63         return allowed[_owner][_spender];
64     }
65 
66     function totalSupply() constant external returns (uint256 supply){
67         return totalSupply;
68     }
69 }
70 
71 contract PFAToken is Token{
72     address owner = msg.sender;
73 
74     address admin;
75 
76     bool private paused;
77     bool private mintStage;
78     bool private icoStage;
79 
80     string public name;
81     string public symbol;
82     uint8 public decimals;
83 
84     uint256 public unitsOneEthCanBuy;
85     uint256 public totalEthInWei;
86     uint256 public minimumContribution;
87     address public fundsWallet;
88     uint256 public tokenFunded;
89     uint256 public coinMinted;
90 
91     //Events
92     event Mint(address indexed _to, uint256 _value);
93     event RateChanged(uint256 _rate);
94     event ContributionChanged(uint256 _min);
95     event AdminChanged(address _address);
96 
97     //modifier
98     modifier onlyOwner{
99         require(msg.sender == owner || msg.sender == admin);
100         _;
101     }
102 
103     modifier whenNotPause{
104         require(!paused);
105         _;
106     }
107 
108     modifier isMintStage{
109         require(mintStage);
110         _;
111     }
112 
113     modifier isICOStage{
114         require(icoStage);
115         _;
116     }
117 
118     //consturtor
119     function PFAToken() {
120         paused = false;
121         mintStage = true;
122         icoStage = false;
123 
124         balances[msg.sender] = 1000000000 * 1000000000000000000;
125         totalSupply = 1000000000 * 1000000000000000000;
126         name = "Price Fitch Asset";
127         decimals = 18;
128         symbol = "PFA";
129         unitsOneEthCanBuy = 100;
130         minimumContribution = 10 finney;
131         fundsWallet = msg.sender;
132         tokenFunded = 0;
133         coinMinted = 0;
134     }
135 
136     // Mint
137     function mint(address _to, uint256 _value) external onlyOwner isMintStage{
138       balances[_to] = balances[_to] + _value;
139       coinMinted = coinMinted + _value;
140       Mint(_to, _value);
141     }
142 
143     function send(address _to, uint256 _value) external onlyOwner{
144       balances[fundsWallet] = balances[fundsWallet] - _value;
145       balances[_to] = balances[_to] + _value;
146       Transfer(fundsWallet, _to, _value);
147     }
148 
149     // fallback function for ICO use.
150     function() payable whenNotPause isICOStage{
151         if (msg.value >= minimumContribution){
152             totalEthInWei = totalEthInWei + msg.value;
153             uint256 amount = msg.value * unitsOneEthCanBuy;
154             if (balances[fundsWallet] < amount) {
155                 return;
156             }
157 
158             tokenFunded = tokenFunded + amount;
159 
160             balances[fundsWallet] = balances[fundsWallet] - amount;
161             balances[msg.sender] = balances[msg.sender] + amount;
162 
163             Transfer(fundsWallet, msg.sender, amount);
164         }
165 
166         fundsWallet.transfer(msg.value);
167     }
168 
169     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
170         allowed[msg.sender][_spender] = _value;
171         Approval(msg.sender, _spender, _value);
172 
173         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
174             revert();
175         }
176 
177         return true;
178     }
179 
180     //Set Admin address
181     function setAdmin(address _address) external onlyOwner{
182       admin = _address;
183       AdminChanged(_address);
184     }
185 
186     //Change Token rate
187     function changeTokenRate(uint256 _rate) external onlyOwner{
188       unitsOneEthCanBuy = _rate;
189       RateChanged(_rate);
190     }
191 
192     function changeMinimumContribution(uint256 _min) external onlyOwner{
193       minimumContribution = _min;
194       ContributionChanged(_min);
195     }
196 
197     //stage lock function
198     function mintStart(bool) external onlyOwner{
199         mintStage = true;
200     }
201 
202     function mintEnd(bool) external onlyOwner{
203         mintStage = false;
204     }
205 
206     function icoStart(bool) external onlyOwner{
207         icoStage = true;
208     }
209 
210     function icoEnd(bool) external onlyOwner{
211         icoStage = false;
212     }
213 
214     function pauseContract(bool) external onlyOwner{
215         paused = true;
216     }
217 
218     function unpauseContract(bool) external onlyOwner{
219         paused = false;
220     }
221 
222     //return stats of token
223     function getStats() external constant returns (uint256, uint256, bool, bool, bool) {
224         return (totalEthInWei, tokenFunded, paused, mintStage, icoStage);
225     }
226 
227 }