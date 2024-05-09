1 /*
2 This file is part of the BREMP Contract.
3 
4 The BREMP Contract is free software: you can redistribute it and/or
5 modify it under the terms of the GNU lesser General Public License as published
6 by the Free Software Foundation, either version 3 of the License, or
7 (at your option) any later version.
8 
9 The BREMP Contract is distributed in the hope that it will be useful,
10 but WITHOUT ANY WARRANTY; without even the implied warranty of
11 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
12 GNU lesser General Public License for more details.
13 
14 You should have received a copy of the GNU lesser General Public License
15 along with the BREMP Contract. If not, see <http://www.gnu.org/licenses/>.
16 
17 @author Ilya Svirin <i.svirin@nordavind.ru>
18 IF YOU ARE ENJOYED IT DONATE TO 0x3Ad38D1060d1c350aF29685B2b8Ec3eDE527452B ! :)
19 */
20 
21 
22 pragma solidity ^0.4.0;
23 
24 contract NeuroDAO {
25     function balanceOf(address who) constant returns (uint);
26     function freezedBalanceOf(address _who) constant returns(uint);
27 }
28 
29 contract owned {
30 
31     address public owner;
32     address public newOwner;
33 
34     function owned() payable {
35         owner = msg.sender;
36     }
37     
38     modifier onlyOwner {
39         require(owner == msg.sender);
40         _;
41     }
42 
43     function changeOwner(address _owner) onlyOwner public {
44         require(_owner != 0);
45         newOwner = _owner;
46     }
47     
48     function confirmOwner() public {
49         require(newOwner == msg.sender);
50         owner = newOwner;
51         delete newOwner;
52     }
53 }
54 
55 contract Crowdsale is owned {
56 
57     uint constant totalTokens    = 25000000;
58     uint constant neurodaoTokens = 1250000;
59     uint constant totalLimitUSD  = 500000;
60     
61     uint                         public totalSupply;
62     mapping (address => uint256) public balanceOf;
63     address                      public neurodao;
64     uint                         public etherPrice;
65 
66     mapping (address => bool)    public holders;
67     mapping (uint => address)    public holdersIter;
68     uint                         public numberOfHolders;
69     
70     uint                         public collectedUSD;
71     address                      public presaleOwner;
72     uint                         public collectedNDAO;
73     
74     mapping (address => bool)    public gotBonus;
75     
76     enum State {Disabled, Presale, Bonuses, Enabled}
77     State                        public state;
78 
79     modifier enabledState {
80         require(state == State.Enabled);
81         _;
82     }
83 
84     event NewState(State _state);
85     event Transfer(address indexed from, address indexed to, uint value);
86 
87     function Crowdsale(address _neurodao, uint _etherPrice) payable owned() {
88         neurodao = _neurodao;
89         etherPrice = _etherPrice;
90         totalSupply = totalTokens;
91         balanceOf[owner] = neurodaoTokens;
92         balanceOf[this] = totalSupply - balanceOf[owner];
93         Transfer(this, owner, balanceOf[owner]);
94     }
95 
96     function setEtherPrice(uint _etherPrice) public {
97         require(presaleOwner == msg.sender || owner == msg.sender);
98         etherPrice = _etherPrice;
99     }
100 
101     function startPresale(address _presaleOwner) public onlyOwner {
102         require(state == State.Disabled);
103         presaleOwner = _presaleOwner;
104         state = State.Presale;
105         NewState(state);
106     }
107     
108     function startBonuses() public onlyOwner {
109         require(state == State.Presale);
110         state = State.Bonuses;
111         NewState(state);
112     }
113     
114     function finishCrowdsale() public onlyOwner {
115         require(state == State.Bonuses);
116         state = State.Enabled;
117         NewState(state);
118     }
119 
120     function () payable {
121         uint tokens;
122         address tokensSource;
123         if (state == State.Presale) {
124             require(balanceOf[this] > 0);
125             require(collectedUSD < totalLimitUSD);
126             uint valueWei = msg.value;
127             uint valueUSD = valueWei * etherPrice / 1 ether;
128             if (collectedUSD + valueUSD > totalLimitUSD) {
129                 valueUSD = totalLimitUSD - collectedUSD;
130                 valueWei = valueUSD * 1 ether / etherPrice;
131                 require(msg.sender.call.gas(3000000).value(msg.value - valueWei)());
132                 collectedUSD = totalLimitUSD;
133             } else {
134                 collectedUSD += valueUSD;
135             }
136             uint centsForToken;
137             if (now <= 1506815999) {        // 30/09/2017 11:59pm (UTC)
138                 centsForToken = 50;
139             } else if (now <= 1507247999) { // 05/10/2017 11:59pm (UTC)
140                 centsForToken = 50;
141             } else if (now <= 1507766399) { // 11/10/2017 11:59pm (UTC)
142                 centsForToken = 65;
143             } else {
144                 centsForToken = 70;
145             }
146             tokens = valueUSD * 100 / centsForToken;
147             if (NeuroDAO(neurodao).balanceOf(msg.sender) >= 1000) {
148                 collectedNDAO += tokens;
149             }
150             tokensSource = this;
151         } else if (state == State.Bonuses) {
152             require(gotBonus[msg.sender] != true);
153             gotBonus[msg.sender] = true;
154             uint freezedBalance = NeuroDAO(neurodao).freezedBalanceOf(msg.sender);
155             if (freezedBalance >= 1000) {
156                 tokens = (neurodaoTokens / 10) * freezedBalance / 21000000 + (9 * neurodaoTokens / 10) * balanceOf[msg.sender] / collectedNDAO;                
157             }
158             tokensSource = owner;
159         }        
160         require(tokens > 0);
161         require(balanceOf[msg.sender] + tokens > balanceOf[msg.sender]);
162         require(balanceOf[tokensSource] >= tokens);        
163         if (holders[msg.sender] != true) {
164             holders[msg.sender] = true;
165             holdersIter[numberOfHolders++] = msg.sender;
166         }
167         balanceOf[msg.sender] += tokens;
168         balanceOf[tokensSource] -= tokens;
169         Transfer(tokensSource, msg.sender, tokens);
170     }
171 }
172 
173 contract Token is Crowdsale {
174     
175     string  public standard    = 'Token 0.1';
176     string  public name        = 'BREMP';
177     string  public symbol      = "BREMP";
178     uint8   public decimals    = 0;
179 
180     mapping (address => mapping (address => uint)) public allowed;
181     event Approval(address indexed owner, address indexed spender, uint value);
182 
183     // Fix for the ERC20 short address attack
184     modifier onlyPayloadSize(uint size) {
185         require(msg.data.length >= size + 4);
186         _;
187     }
188 
189     function Token(address _neurodao, uint _etherPrice)
190         payable Crowdsale(_neurodao, _etherPrice) {}
191 
192     function transfer(address _to, uint256 _value)
193         public enabledState onlyPayloadSize(2 * 32) {
194         require(balanceOf[msg.sender] >= _value);
195         require(balanceOf[_to] + _value >= balanceOf[_to]);
196         if (holders[_to] != true) {
197             holders[_to] = true;
198             holdersIter[numberOfHolders++] = _to;
199         }
200         balanceOf[msg.sender] -= _value;
201         balanceOf[_to] += _value;
202         Transfer(msg.sender, _to, _value);
203     }
204     
205     function transferFrom(address _from, address _to, uint _value)
206         public enabledState onlyPayloadSize(3 * 32) {
207         require(balanceOf[_from] >= _value);
208         require(balanceOf[_to] + _value >= balanceOf[_to]); // overflow
209         require(allowed[_from][msg.sender] >= _value);
210         if (holders[_to] != true) {
211             holders[_to] = true;
212             holdersIter[numberOfHolders++] = _to;
213         }
214         balanceOf[_from] -= _value;
215         balanceOf[_to] += _value;
216         allowed[_from][msg.sender] -= _value;
217         Transfer(_from, _to, _value);
218     }
219 
220     function approve(address _spender, uint _value) public enabledState {
221         allowed[msg.sender][_spender] = _value;
222         Approval(msg.sender, _spender, _value);
223     }
224 
225     function allowance(address _owner, address _spender) public constant enabledState
226         returns (uint remaining) {
227         return allowed[_owner][_spender];
228     }
229 }
230 
231 contract PresaleBREMP is Token {
232     
233     function PresaleBREMP(address _neurodao, uint _etherPrice)
234         payable Token(_neurodao, _etherPrice) {}
235     
236     function withdraw() public {
237         require(presaleOwner == msg.sender || owner == msg.sender);
238         msg.sender.transfer(this.balance);
239     }
240     
241     function killMe() public onlyOwner {
242         presaleOwner.transfer(this.balance);
243         selfdestruct(owner);
244     }
245 }