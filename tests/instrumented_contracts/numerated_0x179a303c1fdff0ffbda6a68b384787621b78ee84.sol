1 /*
2 This file is part of the Open Longevity Contract.
3 
4 The Open Longevity Contract is free software: you can redistribute it and/or
5 modify it under the terms of the GNU lesser General Public License as published
6 by the Free Software Foundation, either version 3 of the License, or
7 (at your option) any later version.
8 
9 The Open Longevity Contract is distributed in the hope that it will be useful,
10 but WITHOUT ANY WARRANTY; without even the implied warranty of
11 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
12 GNU lesser General Public License for more details.
13 
14 You should have received a copy of the GNU lesser General Public License
15 along with the Open Longevity Contract. If not, see <http://www.gnu.org/licenses/>.
16 
17 @author Ilya Svirin <i.svirin@nordavind.ru>
18 */
19 
20 
21 pragma solidity ^0.4.10;
22 
23 contract owned {
24 
25     address public owner;
26     address public newOwner;
27 
28     function owned() public payable {
29         owner = msg.sender;
30     }
31     
32     modifier onlyOwner {
33         require(owner == msg.sender);
34         _;
35     }
36 
37     function changeOwner(address _owner) onlyOwner public {
38         require(_owner != 0);
39         newOwner = _owner;
40     }
41     
42     function confirmOwner() public {
43         require(newOwner == msg.sender);
44         owner = newOwner;
45         delete newOwner;
46     }
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 {
54     uint public totalSupply;
55     function balanceOf(address who) public constant returns (uint);
56     function transfer(address to, uint value) public ;
57     function allowance(address owner, address spender) public constant returns (uint);
58     function transferFrom(address from, address to, uint value) public;
59     function approve(address spender, uint value) public;
60     event Approval(address indexed owner, address indexed spender, uint value);
61     event Transfer(address indexed from, address indexed to, uint value);
62 }
63 
64 contract PresaleOriginal is owned, ERC20 {
65 
66     uint    public totalLimitUSD;
67     uint    public collectedUSD;
68     uint    public presaleStartTime;
69 
70     struct Investor {
71         uint256 amountTokens;
72         uint    amountWei;
73     }
74     mapping (address => Investor) public investors;
75     mapping (uint => address)     public investorsIter;
76     uint                          public numberOfInvestors;
77 }
78 
79 contract Presale is PresaleOriginal {
80 
81     uint    public etherPrice;
82     address public presaleOwner;
83 
84     enum State { Disabled, Presale, Finished }
85     event NewState(State state);
86     State   public state;
87     uint    public presaleFinishTime;
88 
89     uint    public migrationCounter;
90 
91     function migrate(address _originalContract, uint n) public onlyOwner {
92         require(state == State.Disabled);
93         
94         // migrate tokens with x2 bonus
95         numberOfInvestors = PresaleOriginal(_originalContract).numberOfInvestors();
96         uint limit = migrationCounter + n;
97         if(limit > numberOfInvestors) {
98             limit = numberOfInvestors;
99         }
100         for(; migrationCounter < limit; ++migrationCounter) {
101             address a = PresaleOriginal(_originalContract).investorsIter(migrationCounter);
102             investorsIter[migrationCounter] = a;
103             uint256 amountTokens;
104             uint amountWei;
105             (amountTokens, amountWei) = PresaleOriginal(_originalContract).investors(a);
106             amountTokens *= 2;
107             investors[a].amountTokens = amountTokens;
108             investors[a].amountWei = amountWei;
109             totalSupply += amountTokens;
110             Transfer(_originalContract, a, amountTokens);
111         }
112         if(limit < numberOfInvestors) {
113             return;
114         }
115 
116         // migrate main parameters
117         presaleStartTime = PresaleOriginal(_originalContract).presaleStartTime();
118         collectedUSD = PresaleOriginal(_originalContract).collectedUSD();
119         totalLimitUSD = PresaleOriginal(_originalContract).totalLimitUSD();
120 
121         // add extra tokens for bounty
122         address bountyAddress = 0x59B95A5e0268Cc843e6308FEf723544BaA6676c6;
123         if(investors[bountyAddress].amountWei == 0 && investors[bountyAddress].amountTokens == 0) {
124             investorsIter[numberOfInvestors++] = bountyAddress;
125         }
126         uint bountyTokens = 5 * PresaleOriginal(_originalContract).totalSupply() / 100;
127         investors[bountyAddress].amountTokens += bountyTokens;
128         totalSupply += bountyTokens;
129     }
130 
131     function () payable public {
132         require(state == State.Presale);
133         require(now < presaleFinishTime);
134 
135         uint valueWei = msg.value;
136         uint valueUSD = valueWei * etherPrice / 1000000000000000000;
137         if (collectedUSD + valueUSD > totalLimitUSD) { // don't need so much ether
138             valueUSD = totalLimitUSD - collectedUSD;
139             valueWei = valueUSD * 1000000000000000000 / etherPrice;
140             require(msg.sender.call.gas(3000000).value(msg.value - valueWei)());
141             collectedUSD = totalLimitUSD; // to be sure!
142         } else {
143             collectedUSD += valueUSD;
144         }
145 
146         uint256 tokensPer10USD = 130;
147         if (valueUSD >= 100000) {
148             tokensPer10USD = 150;
149         }
150 
151         uint256 tokens = tokensPer10USD * valueUSD / 10;
152         require(tokens > 0);
153 
154         Investor storage inv = investors[msg.sender];
155         if (inv.amountWei == 0) { // new investor
156             investorsIter[numberOfInvestors++] = msg.sender;
157         }
158         require(inv.amountTokens + tokens > inv.amountTokens); // overflow
159         inv.amountTokens += tokens;
160         inv.amountWei += valueWei;
161         totalSupply += tokens;
162         Transfer(this, msg.sender, tokens);
163     }
164     
165     function startPresale(address _presaleOwner, uint _etherPrice) public onlyOwner {
166         require(state == State.Disabled);
167         presaleOwner = _presaleOwner;
168         etherPrice = _etherPrice;
169         presaleFinishTime = 1526342400; // (GMT) 15 May 2018, 00:00:00
170         state = State.Presale;
171         totalLimitUSD = 500000;
172         NewState(state);
173     }
174 
175     function setEtherPrice(uint _etherPrice) public onlyOwner {
176         require(state == State.Presale);
177         etherPrice = _etherPrice;
178     }
179     
180     function timeToFinishPresale() public constant returns(uint t) {
181         require(state == State.Presale);
182         if (now > presaleFinishTime) {
183             t = 0;
184         } else {
185             t = presaleFinishTime - now;
186         }
187     }
188     
189     function finishPresale() public onlyOwner {
190         require(state == State.Presale);
191         require(now >= presaleFinishTime || collectedUSD == totalLimitUSD);
192         require(presaleOwner.call.gas(3000000).value(this.balance)());
193         state = State.Finished;
194         NewState(state);
195     }
196     
197     function withdraw() public onlyOwner {
198         require(presaleOwner.call.gas(3000000).value(this.balance)());
199     }
200 }
201 
202 contract PresaleToken is Presale {
203     
204     string  public standard    = 'Token 0.1';
205     string  public name        = 'OpenLongevity';
206     string  public symbol      = "YEAR";
207     uint8   public decimals    = 0;
208 
209     mapping (address => mapping (address => uint)) public allowed;
210 
211     // Fix for the ERC20 short address attack
212     modifier onlyPayloadSize(uint size) {
213         require(msg.data.length >= size + 4);
214         _;
215     }
216 
217     function PresaleToken() payable public Presale() {}
218 
219     function balanceOf(address _who) constant public returns (uint) {
220         return investors[_who].amountTokens;
221     }
222 
223     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) {
224         require(investors[msg.sender].amountTokens >= _value);
225         require(investors[_to].amountTokens + _value >= investors[_to].amountTokens);
226         investors[msg.sender].amountTokens -= _value;
227         if(investors[_to].amountTokens == 0 && investors[_to].amountWei == 0) {
228             investorsIter[numberOfInvestors++] = _to;
229         }
230         investors[_to].amountTokens += _value;
231         Transfer(msg.sender, _to, _value);
232     }
233     
234     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
235         require(investors[_from].amountTokens >= _value);
236         require(investors[_to].amountTokens + _value >= investors[_to].amountTokens); // overflow
237         require(allowed[_from][msg.sender] >= _value);
238         investors[_from].amountTokens -= _value;
239         if(investors[_to].amountTokens == 0 && investors[_to].amountWei == 0) {
240             investorsIter[numberOfInvestors++] = _to;
241         }
242         investors[_to].amountTokens += _value;
243         allowed[_from][msg.sender] -= _value;
244         Transfer(_from, _to, _value);
245     }
246 
247     function approve(address _spender, uint _value) public {
248         allowed[msg.sender][_spender] = _value;
249         Approval(msg.sender, _spender, _value);
250     }
251 
252     function allowance(address _owner, address _spender) public constant
253         returns (uint remaining) {
254         return allowed[_owner][_spender];
255     }
256 }
257 
258 contract OpenLongevityPresale is PresaleToken {
259 
260     function OpenLongevityPresale() payable public PresaleToken() {}
261 
262     function killMe() public onlyOwner {
263         selfdestruct(owner);
264     }
265 }