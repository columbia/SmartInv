1 /*
2 This file is part of the PROOF Contract.
3 
4 The PROOF Contract is free software: you can redistribute it and/or
5 modify it under the terms of the GNU lesser General Public License as published
6 by the Free Software Foundation, either version 3 of the License, or
7 (at your option) any later version.
8 
9 The PROOF Contract is distributed in the hope that it will be useful,
10 but WITHOUT ANY WARRANTY; without even the implied warranty of
11 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
12 GNU lesser General Public License for more details.
13 
14 You should have received a copy of the GNU lesser General Public License
15 along with the PROOF Contract. If not, see <http://www.gnu.org/licenses/>.
16 
17 @author Ilya Svirin <i.svirin@prover.io>
18 */
19 
20 pragma solidity ^0.4.11;
21 
22 contract owned {
23 
24     address public owner;
25     address public candidate;
26 
27     function owned() public {
28         owner = msg.sender;
29     }
30     
31     modifier onlyOwner {
32         require(owner == msg.sender);
33         _;
34     }
35 
36     function changeOwner(address _owner) onlyOwner public {
37         candidate = _owner;
38     }
39     
40     function confirmOwner() public {
41         require(candidate == msg.sender);
42         owner = candidate;
43         delete candidate;
44     }
45 }
46 
47 /**
48  * @title Base of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract BaseERC20 {
52     function balanceOf(address who) public constant returns (uint);
53     function transfer(address to, uint value) public;
54 }
55 
56 contract ManualMigration is owned {
57 
58     address                      public original = 0x5B5d8A8A732A3c73fF0fB6980880Ef399ecaf72E;
59     uint                         public totalSupply;
60     mapping (address => uint256) public balanceOf;
61 
62     uint                         public numberOfInvestors;
63     mapping (address => bool)    public investors;
64 
65     event Transfer(address indexed from, address indexed to, uint value);
66 
67     function ManualMigration() public owned() {}
68 
69     function migrateManual(address _who, bool _preico) public onlyOwner {
70         require(original != 0);
71         require(balanceOf[_who] == 0);
72         uint balance = BaseERC20(original).balanceOf(_who);
73         balance *= _preico ? 27 : 45;
74         balance /= 10;
75         balance *= 100000000;
76         balanceOf[_who] = balance;
77         totalSupply += balance;
78         if (!investors[_who]) {
79             investors[_who] = true;
80             ++numberOfInvestors;
81         }
82         Transfer(original, _who, balance);
83     }
84     
85     function migrateListManual(address [] _who, bool _preico) public onlyOwner {
86         for(uint i = 0; i < _who.length; ++i) {
87             migrateManual(_who[i], _preico);
88         }
89     }
90     
91     function sealManualMigration() public onlyOwner {
92         delete original;
93     }
94 }
95 
96 contract Crowdsale is ManualMigration {
97 
98     address public backend;
99     address public cryptaurToken = 0x88d50B466BE55222019D71F9E8fAe17f5f45FCA1;
100     uint    public crowdsaleStartTime = 1517270400;  // 30 January 2018, GMT 00:00:00
101     uint    public crowdsaleFinishTime = 1522454400; // 31 March 2018, 00:00:00
102     uint    public etherPrice;
103     uint    public collectedUSD;
104     bool    public crowdsaleFinished;
105 
106     event Mint(address indexed minter, uint tokens, bytes32 originalTxHash);
107 
108     // Fix for the ERC20 short address attack
109     modifier onlyPayloadSize(uint size) {
110         require(msg.data.length >= size + 4);
111         _;
112     }
113 
114     modifier isCrowdsale() {
115         require(now >= crowdsaleStartTime && now <= crowdsaleFinishTime);
116         _;
117     }
118 
119     function Crowdsale(address _backend, uint _etherPrice) public ManualMigration() {
120         backend = _backend;
121         etherPrice = _etherPrice;
122     }
123 
124     function changeBackend(address _backend) public onlyOwner {
125         backend = _backend;
126     }
127     
128     function setEtherPrice(uint _etherPrice) public {
129         require(msg.sender == owner || msg.sender == backend);
130         etherPrice = _etherPrice;
131     }
132 
133     function () payable public isCrowdsale {
134         uint valueUSD = msg.value * etherPrice / 1 ether;
135         collectedUSD += valueUSD;
136         mintTokens(msg.sender, valueUSD);
137     }
138 
139     function depositUSD(address _who, uint _valueUSD) public isCrowdsale {
140         require(msg.sender == backend || msg.sender == owner);
141         collectedUSD += _valueUSD;
142         mintTokens(_who, _valueUSD);
143     }
144 
145     function mintTokens(address _who, uint _valueUSD) internal {
146         uint tokensPerUSD = 100;
147         if (_valueUSD >= 50000) {
148             tokensPerUSD = 120;
149         } else if (now < crowdsaleStartTime + 1 days) {
150             tokensPerUSD = 115;
151         } else if (now < crowdsaleStartTime + 1 weeks) {
152             tokensPerUSD = 110;
153         }
154         uint tokens = tokensPerUSD * _valueUSD * 100000000;
155         require(balanceOf[_who] + tokens > balanceOf[_who]); // overflow
156         require(tokens > 0);
157         balanceOf[_who] += tokens;
158         if (!investors[_who]) {
159             investors[_who] = true;
160             ++numberOfInvestors;
161         }
162         Transfer(this, _who, tokens);
163         totalSupply += tokens;
164     }
165 
166     function depositCPT(address _who, uint _valueCPT, bytes32 _originalTxHash) public isCrowdsale {
167         require(msg.sender == backend || msg.sender == owner);
168         // decimals in CPT and PROOF are the same and equal 8
169         uint tokens = 15 * _valueCPT / 10;
170         require(balanceOf[_who] + tokens > balanceOf[_who]); // overflow
171         require(tokens > 0);
172         balanceOf[_who] += tokens;
173         totalSupply += tokens;
174         collectedUSD += _valueCPT / 100;
175         if (!investors[_who]) {
176             investors[_who] = true;
177             ++numberOfInvestors;
178         }
179         Transfer(this, _who, tokens);
180         Mint(_who, tokens, _originalTxHash);
181     }
182 
183     function withdraw() public onlyOwner {
184         require(msg.sender.call.gas(3000000).value(this.balance)());
185         uint balance = BaseERC20(cryptaurToken).balanceOf(this);
186         BaseERC20(cryptaurToken).transfer(msg.sender, balance);
187     }
188     
189     function finishCrowdsale() public onlyOwner {
190         require(!crowdsaleFinished);
191         uint extraTokens = totalSupply / 2;
192         balanceOf[msg.sender] += extraTokens;
193         totalSupply += extraTokens;
194         if (!investors[msg.sender]) {
195             investors[msg.sender] = true;
196             ++numberOfInvestors;
197         }
198         Transfer(this, msg.sender, extraTokens);
199         crowdsaleFinished = true;
200     }
201 }
202 
203 contract ProofToken is Crowdsale {
204 
205     string  public standard = 'Token 0.1';
206     string  public name     = 'PROOF';
207     string  public symbol   = 'PF';
208     uint8   public decimals = 8;
209 
210     mapping (address => mapping (address => uint)) public allowed;
211     event Approval(address indexed owner, address indexed spender, uint value);
212     event Burn(address indexed owner, uint value);
213 
214     function ProofToken(address _backend, uint _etherPrice) public
215         payable Crowdsale(_backend, _etherPrice) {
216     }
217 
218     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) {
219         require(balanceOf[msg.sender] >= _value);
220         require(balanceOf[_to] + _value >= balanceOf[_to]);
221         balanceOf[msg.sender] -= _value;
222         balanceOf[_to] += _value;
223         Transfer(msg.sender, _to, _value);
224     }
225     
226     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
227         require(balanceOf[_from] >= _value);
228         require(balanceOf[_to] + _value >= balanceOf[_to]); // overflow
229         require(allowed[_from][msg.sender] >= _value);
230         balanceOf[_from] -= _value;
231         balanceOf[_to] += _value;
232         allowed[_from][msg.sender] -= _value;
233         Transfer(_from, _to, _value);
234     }
235 
236     function approve(address _spender, uint _value) public {
237         allowed[msg.sender][_spender] = _value;
238         Approval(msg.sender, _spender, _value);
239     }
240 
241     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
242         return allowed[_owner][_spender];
243     }
244     
245     function burn(uint _value) public {
246         require(balanceOf[msg.sender] >= _value);
247         balanceOf[msg.sender] -= _value;
248         totalSupply -= _value;
249         Burn(msg.sender, _value);
250     }
251 }