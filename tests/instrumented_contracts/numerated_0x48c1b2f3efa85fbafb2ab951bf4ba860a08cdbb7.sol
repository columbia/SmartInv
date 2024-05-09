1 pragma solidity ^0.4.19;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function div(uint256 a, uint256 b) internal constant returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 contract HAND{
27     using SafeMath for uint256;
28 
29     uint256 constant MAX_UINT256 = 2**256 - 1;
30     uint256 _initialAmount = 0;
31     uint256 public publicToken = 4*10**11;                // 40% of total, for public sale
32     uint256 public maxSupply = 10**12;
33     address  public contract_owner;
34     uint256 public exchangeRate = 3900000;                    // exchangeRate for public sale, token per ETH
35     bool public icoOpen = false;                           // whether ICO is open and accept public investment
36 
37 
38     address privateSaleAdd = 0x85e4FE33c590b8A5812fBF926a0f9fe64E6d8b35;
39     
40     mapping (address => uint256) balances;
41     mapping (address => mapping (address => uint256)) allowed;
42 
43     
44       
45     // lock struct for founder
46     struct founderLock {
47         uint256 amount;
48         uint256 startTime;
49         uint remainRound;
50         uint totalRound;
51         uint256 period;
52     }
53     
54     mapping (address => founderLock) public founderLockance;
55     mapping (address => bool) isFreezed;
56     
57 
58     
59     // uint256 totalSupply;
60     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62     event FounderUnlock(address _sender, uint256 _amount);
63             
64     /*
65     NOTE:
66     The following variables are OPTIONAL vanities. One does not have to include them.
67     */
68     string public name = "ShowHand";               //fancy name: eg Simon Bucks
69     uint8 public decimals = 0;                     //How many decimals to show.
70     string public symbol = "HAND";                 //An identifier: eg SBX
71 
72     /**
73       * @dev Fix for the ERC20 short address attack.
74       */
75       modifier onlyPayloadSize(uint size) {
76           require(msg.data.length >= size + 4);
77           _;
78       }
79       modifier  onlyOwner() { 
80           require(msg.sender == contract_owner); 
81           _; 
82       }
83       modifier inIco() { 
84           require(icoOpen==true); 
85           _; 
86       }
87       
88       
89     // token distribution, 60% in this part
90         address address1 = 0x85e4FE33c590b8A5812fBF926a0f9fe64E6d8b35;
91         address address2 = 0x5af6353F2BB222DF6FCD82065ed2e6db1bB12291;
92         address address3 = 0x6c24A6EfdfF15230EE284E2E72D86656ac752e48;
93         address address4 = 0xCB946d83617eDb6fbCa19148AD83e17Ea7B67294;
94         address address5 = 0x76360A75dC6e4bC5c6C0a20A4B74b8823fAFad8C;
95         address address6 = 0x356399eE0ebCB6AfB13dF33168fD2CC54Ba219C2;
96         address address7 = 0x8b46b43cA5412311A5Dfa08EF1149B5942B5FE22;
97         address address8 = 0xA51551B57CB4e37Ea20B3226ceA61ebc7135a11a;
98         address address9 = 0x174bC643442bE89265500E6C2c236D32248A4FaE;
99         address address10 = 0x0D78E82ECEd57aC3CE65fE3B828f4d52fF712f31;
100         address address11 = 0xe31062592358Cd489Bdc09e8217543C8cc3D5C1C;
101         address address12 = 0x0DB8c855C4BB0efd5a1c32de2362c5ABCFa4CA33;
102         address address13 = 0xF25A3ccDC54A746d56A90197d911d9a1f27cF512;
103         address address14 = 0x102d36210d312FB9A9Cf5f5c3A293a8f6598BD50;
104 
105         address address15 = 0x8Dd1cDD513b05D07726a6F8C75b57602991a9c34;
106         address address16 = 0x9d566BCc1BDda779a00a1D44E0b4cA07FB68EFEF;
107         address address17 = 0x1cfCe9A13aBC3381100e85BFA21160C98f8B103D;
108         address address18 = 0x61F0c924C0F91f4d17c82C534cfaF716A7893c13;
109         address address19 = 0xE76c0618Dd52403ad1907D3BCbF930226bFEa46B;
110         address address20 = 0xeF2f04dbd3E3aD126979646383c94Fd29E29de9F;
111 
112     function HAND() public {
113         // set sender as contract_owner
114         contract_owner = msg.sender;
115         _initialAmount += publicToken;
116 
117         
118 
119         setFounderLock(address1, 800*10**8, 4, 180 days);
120         setFounderLock(address2, 40*10**8, 4, 180 days);
121         setFounderLock(address3, 5*10**8, 4, 180 days);
122         setFounderLock(address4, 5*10**8, 4, 180 days);
123         setFounderLock(address5, 300*10**8, 4, 180 days);
124         setFounderLock(address6, 200*10**8, 4, 180 days);
125         setFounderLock(address7, 100*10**8, 4, 180 days);
126         setFounderLock(address8, 50*10**8, 4, 180 days);
127         setFounderLock(address9, 600*10**8, 4, 180 days);
128         setFounderLock(address10, 150*10**8, 4, 180 days);
129         setFounderLock(address11, 100*10**8, 4, 180 days);
130         setFounderLock(address12, 800*10**8, 4, 180 days);
131         setFounderLock(address13, 2400*10**8, 4, 180 days);
132         setFounderLock(address14, 100*10**8, 4, 180 days);
133 
134         setFounderLock(address15, 135*10**8, 4, 180 days);
135         setFounderLock(address16, 25*10**8, 4, 180 days);
136         setFounderLock(address17, 20*10**8, 4, 180 days);
137         setFounderLock(address18, 40*10**8, 4, 180 days);
138         setFounderLock(address19, 20*10**8, 4, 180 days);
139         setFounderLock(address20, 110*10**8, 4, 180 days);
140     }
141     function totalSupply() constant returns (uint256 _totalSupply){
142         _totalSupply = _initialAmount;
143       }
144     function transfer(address _to, uint256 _value) public returns (bool success) {
145         //Default assumes totalSupply can't be over max (2^256 - 1).
146         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
147         //Replace the if with this one instead.
148         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
149         require(balances[msg.sender] >= _value);
150         require(isFreezed[msg.sender]==false);
151         balances[msg.sender] -= _value;
152         balances[_to] += _value;
153         Transfer(msg.sender, _to, _value);
154         return true;
155         }
156     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
157         //same as above. Replace this line with the following if you want to protect against wrapping uints.
158         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
159         uint256 allowance = allowed[_from][msg.sender];
160         require(balances[_from] >= _value && allowance >= _value);
161         balances[_to] += _value;
162         balances[_from] -= _value;
163         if (allowance < MAX_UINT256) {
164             allowed[_from][msg.sender] -= _value;
165         }
166         Transfer(_from, _to, _value);
167         return true;
168         }
169 
170     function balanceOf(address _owner) view public returns (uint256 balance) {
171         return balances[_owner];
172         }
173 
174     function approve(address _spender, uint256 _value) public returns (bool success) {
175         require(isFreezed[msg.sender]==false);
176         allowed[msg.sender][_spender] = _value;
177         Approval(msg.sender, _spender, _value);
178         return true;
179         }
180 
181     function allowance(address _owner, address _spender)
182     view public returns (uint256 remaining) {
183       return allowed[_owner][_spender];
184         }
185 
186     function multisend(address[] addrs,  uint256 _value)
187     {
188         uint length = addrs.length;
189         require(_value * length <= balances[msg.sender]);
190         uint i = 0;
191         while (i < length) {
192            transfer(addrs[i], _value);
193            i ++;
194         }
195         
196       }
197     
198     
199     
200     // lock token of founder for periodically release
201     // _address: founder address; 
202     // _value: totoal locked token; 
203     // _round: rounds founder could withdraw; 
204     // _period: interval time between two rounds
205     function setFounderLock(address _address, uint256 _value, uint _round, uint256 _period)  internal onlyOwner{
206         founderLockance[_address].amount = _value;
207         founderLockance[_address].startTime = now;
208         founderLockance[_address].remainRound = _round;
209         founderLockance[_address].totalRound = _round;
210         founderLockance[_address].period = _period;
211     }
212     
213     
214     // allow locked token to be obtained for founder 
215     function unlockFounder () {
216         require(now >= founderLockance[msg.sender].startTime + (founderLockance[msg.sender].totalRound - founderLockance[msg.sender].remainRound + 1) * founderLockance[msg.sender].period);
217         require(founderLockance[msg.sender].remainRound > 0);
218         uint256 changeAmount = founderLockance[msg.sender].amount.div(founderLockance[msg.sender].remainRound);
219         balances[msg.sender] += changeAmount;
220         founderLockance[msg.sender].amount -= changeAmount;
221         _initialAmount += changeAmount;
222         founderLockance[msg.sender].remainRound --;
223         FounderUnlock(msg.sender, changeAmount);
224     }
225     
226     function freezeAccount (address _target) onlyOwner {
227         isFreezed[_target] = true;
228     }
229     function unfreezeAccount (address _target) onlyOwner {
230         isFreezed[_target] = false;
231     }
232     function ownerUnlock (address _target, uint256 _value) onlyOwner {
233         require(founderLockance[_target].amount >= _value);
234         founderLockance[_target].amount -= _value;
235         balances[_target] += _value;
236         _initialAmount += _value;
237     }
238     
239     // starts ICO
240     function openIco () onlyOwner{
241         icoOpen = true;
242       }
243     // ends ICO 
244     function closeIco () onlyOwner inIco{
245         icoOpen = false;
246       }
247 
248     // transfer all unsold token to bounty balance;
249     function weAreClosed () onlyOwner{
250         balances[contract_owner] += publicToken;
251         transfer(privateSaleAdd, publicToken);
252         publicToken = 0;
253     }
254     // change rate of public sale
255     function changeRate (uint256 _rate) onlyOwner{
256         exchangeRate = _rate;
257     }    
258     
259     //  withdraw ETH from contract
260     function withdraw() onlyOwner{
261         contract_owner.transfer(this.balance);
262       }
263     // fallback function for receive ETH during ICO
264     function () payable inIco{
265         require(msg.value >= 10**18);
266         uint256 tokenChange = (msg.value * exchangeRate).div(10**18);
267         require(tokenChange <= publicToken);
268         balances[msg.sender] += tokenChange;
269         publicToken = publicToken.sub(tokenChange);
270       }
271 }