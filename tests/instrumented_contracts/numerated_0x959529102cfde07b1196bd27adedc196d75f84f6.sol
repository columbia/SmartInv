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
26 contract BLO{
27     using SafeMath for uint256;
28 
29     uint256 constant MAX_UINT256 = 2**256 - 1;
30     uint256 _initialAmount = 0;
31     address  public contract_owner;
32     uint256 public exchangeRate = 7000;                    // exchangeRate for public sale, token per ETH
33     bool public icoOpen = false;                           // whether ICO is open and accept public investment
34 
35     uint256 public publicToken = 110000000;                // 45% of total, for public sale
36     uint256 public bountyToken = 12070000;                 // bounty use
37     uint256 public airdropToken = 50430000 + 2500000;      // 20% + 1% of total, airdrop use including bonus
38     uint256 public reserveMember = 6450000;                // Reserve for new members and future M&D
39     uint256 public reservedFounder = 12000000;             // Future Founder & Advisor
40 
41     mapping (address => uint256) balances;
42     mapping (address => mapping (address => uint256)) allowed;
43 
44     // lock struct for member
45     struct lock {
46         uint256 amount;
47         uint256 duration;    
48     }    
49     // lock struct for founder
50     struct founderLock {
51         uint256 amount;
52         uint256 startTime;
53         uint remainRound;
54         uint totalRound;
55         uint256 period;
56     }
57     
58     mapping (address => lock) public lockance;
59     mapping (address => founderLock) public founderLockance;
60     
61 
62     
63     // uint256 totalSupply;
64     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66     event Unlock(address _sender, uint256 _amount);
67     event FounderUnlock(address _sender, uint256 _amount);
68     
69     
70     
71     
72     /*
73     NOTE:
74     The following variables are OPTIONAL vanities. One does not have to include them.
75     */
76     string public name = "PABLOCoin";                   //fancy name: eg Simon Bucks
77     uint8 public decimals = 0;                //How many decimals to show.
78     string public symbol = "BLO";                 //An identifier: eg SBX
79 
80     /**
81       * @dev Fix for the ERC20 short address attack.
82       */
83       modifier onlyPayloadSize(uint size) {
84           require(msg.data.length >= size + 4);
85           _;
86       }
87       modifier  onlyOwner() { 
88           require(msg.sender == contract_owner); 
89           _; 
90       }
91       modifier inIco() { 
92           require(icoOpen==true); 
93           _; 
94       }
95       
96       
97 
98     function BLO() public {
99         // set sender as contract_owner
100         contract_owner = msg.sender;
101 
102         // token distribution, 56550000 in this part
103         address Wayne = 0x1A33cDA3cF3d9b7318B105171115F799ac3e986D;
104         address Sophie = 0xd4AFd732Da602Fc44e99B4c3285B46D9369F2Beb;
105         address Calvin = 0xa34cB9F691B939b7C137CaC3C11907c9bE5F7Ae9;
106         address Marsh = 0x042bD518576C7fEDF26870D7C65f9ff2597c9935;
107         address Chris = 0x050992436F5048F5C5B48Db0e8593DE48521b35A;
108         address Josh = 0x11ae09350b18ea810bc7fd6892612a63c641d641;
109         address LM = 0x8Dd1cDD513b05D07726a6F8C75b57602991a9c34;
110         address TJ = 0xdd36FBf1C0A63759892FeAE493f4AaB9dc23cE54;
111         address Chuck1 = 0xb5d93E0cE63E7B7cE8fD5A89e8a7E217721Ad5Fa;
112         address Chuck2 = 0xE76c0618Dd52403ad1907D3BCbF930226bFEa46B;
113         address Tom1 = 0x52103e8bbDfcFB49d978CE8F4a0b862e0F14dC7E;
114         address Tom2 = 0xeF2f04dbd3E3aD126979646383c94Fd29E29de9F;
115 
116         balances[msg.sender] += 1000000/2;
117         transfer(Wayne, 1000000/2);
118         setLock(Wayne, 1000000/2, 60 days);
119         _initialAmount += 1000000;
120 
121         balances[msg.sender] += 1000000/2;
122         transfer(Sophie, 1000000/2);
123         setLock(Sophie, 1000000/2, 60 days);
124         _initialAmount += 1000000;
125 
126         balances[msg.sender] += 1000000/2;
127         transfer(Calvin, 1000000/2);
128         setLock(Calvin, 1000000/2, 60 days);
129         _initialAmount += 1000000;
130 
131         balances[msg.sender] += 2600000/2;
132         transfer(Marsh, 2600000/2);
133         setLock(Marsh, 2600000/2, 60 days);
134         _initialAmount += 2600000;
135 
136         balances[msg.sender] += 50000/2;
137         transfer(Chris, 50000/2);
138         setLock(Chris, 50000/2, 60 days);
139         _initialAmount += 50000;
140 
141         balances[msg.sender] += 1000000/2;
142         transfer(Josh, 1000000/2);
143         setLock(Josh, 1000000/2, 60 days);
144         _initialAmount += 1000000;
145 
146         balances[msg.sender] += 5100000/2;
147         transfer(LM, 5100000/2);
148         setLock(LM, 5100000/2, 60 days);
149         _initialAmount += 5100000;
150 
151         balances[msg.sender] += 1800000/2;
152         transfer(TJ, 1800000/2);
153         setLock(TJ, 1800000/2, 60 days);
154         _initialAmount += 1800000;
155 
156         balances[msg.sender] += 9000000;
157         transfer(Chuck1, 9000000);
158         setFounderLock(Chuck2, 12500000, 6, 180 days);
159         _initialAmount += 12500000 + 9000000;
160 
161         balances[msg.sender] += 9000000;
162         transfer(Tom1, 9000000);
163         setFounderLock(Tom2, 12500000, 6, 180 days);
164         _initialAmount += 12500000 + 9000000;
165     }
166     function totalSupply() constant returns (uint256 _totalSupply){
167         _totalSupply = _initialAmount;
168       }
169     function transfer(address _to, uint256 _value) public returns (bool success) {
170         //Default assumes totalSupply can't be over max (2^256 - 1).
171         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
172         //Replace the if with this one instead.
173         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
174         require(balances[msg.sender] >= _value);
175         balances[msg.sender] -= _value;
176         balances[_to] += _value;
177         Transfer(msg.sender, _to, _value);
178         return true;
179         }
180     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
181         //same as above. Replace this line with the following if you want to protect against wrapping uints.
182         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
183         uint256 allowance = allowed[_from][msg.sender];
184         require(balances[_from] >= _value && allowance >= _value);
185         balances[_to] += _value;
186         balances[_from] -= _value;
187         if (allowance < MAX_UINT256) {
188             allowed[_from][msg.sender] -= _value;
189         }
190         Transfer(_from, _to, _value);
191         return true;
192         }
193 
194     function balanceOf(address _owner) view public returns (uint256 balance) {
195         return balances[_owner];
196         }
197 
198     function approve(address _spender, uint256 _value) public returns (bool success) {
199         allowed[msg.sender][_spender] = _value;
200         Approval(msg.sender, _spender, _value);
201         return true;
202         }
203 
204     function allowance(address _owner, address _spender)
205     view public returns (uint256 remaining) {
206       return allowed[_owner][_spender];
207         }
208 
209     function multisend(address[] addrs,  uint256 _value)
210     {
211         uint length = addrs.length;
212         require(_value * length <= balances[msg.sender]);
213         uint i = 0;
214         while (i < length) {
215            transfer(addrs[i], _value);
216            i ++;
217         }
218         
219       }
220     function multAirdrop(address[] addrs,  uint256 _value) onlyOwner
221     {
222         uint length = addrs.length;
223         uint256 totalToken = _value * length;
224         require(totalToken <= airdropToken);
225         balances[contract_owner] += totalToken;
226         uint i = 0;
227         while (i < length) {
228            transfer(addrs[i], _value);
229            i ++;
230         }
231         _initialAmount += totalToken;
232         airdropToken -= totalToken;
233         
234       }
235     // lock token in specified address for some time
236     // _address: locked address
237     // _value: locked token
238     // _time: when it could be unlocked
239     function setLock(address _address, uint256 _value, uint256 _time) internal onlyOwner {
240         lockance[_address].amount = _value;
241         lockance[_address].duration = now + _time;
242       }
243     
244     // lock token of founder for periodically release
245     // _address: founder address; 
246     // _value: totoal locked token; 
247     // _round: rounds founder could withdraw; 
248     // _period: interval time between two rounds
249     function setFounderLock(address _address, uint256 _value, uint _round, uint256 _period)  internal onlyOwner{
250         founderLockance[_address].amount = _value.div(_round);
251         founderLockance[_address].startTime = now;
252         founderLockance[_address].remainRound = _round;
253         founderLockance[_address].totalRound = _round;
254         founderLockance[_address].period = _period;
255     }
256     
257     // allow locked token to be obtained for member
258     function unlock () {
259         require(now >= lockance[msg.sender].duration);
260         uint256 _amount = lockance[msg.sender].amount;
261         balances[msg.sender] += lockance[msg.sender].amount;
262         lockance[msg.sender].amount = 0;
263         Unlock(msg.sender, _amount);
264     }
265     // allow locked token to be obtained for founder 
266     function unlockFounder (uint _round) {
267         require(now >= founderLockance[msg.sender].startTime + _round * founderLockance[msg.sender].period);
268         require(founderLockance[msg.sender].remainRound > 0);
269         require(founderLockance[msg.sender].totalRound - founderLockance[msg.sender].remainRound < _round);
270         uint256 _amount = founderLockance[msg.sender].amount;
271         balances[msg.sender] += _amount;
272         founderLockance[msg.sender].remainRound --;
273         FounderUnlock(msg.sender, _amount);
274     }
275     
276     // starts ICO
277     function openIco () onlyOwner{
278         icoOpen = true;
279       }
280     // ends ICO 
281     function closeIco () onlyOwner inIco{
282         icoOpen = false;
283       }
284 
285     // transfer all unsold token to bounty balance;
286     function weAreClosed () onlyOwner{
287         bountyToken += publicToken;
288         publicToken = 0;
289     }
290     // change rate of public sale
291     function changeRate (uint256 _rate) onlyOwner{
292         require(_rate >= 5000 && _rate <= 8000);    //in case of mistypo :)
293         exchangeRate = _rate;
294     }
295     
296     
297     // add a new member and give him/her some token
298     function addMember (address _member, uint256 _value) onlyOwner{
299         require(_value <= reserveMember);
300         reserveMember -= _value;
301         balances[contract_owner] += _value;
302         transfer(_member, _value);
303         _initialAmount += _value;
304     }
305     // add a new founder/advisor and give him/her some token
306     function addFounder (address _founder, uint256 _value) onlyOwner{
307         require(_value <= reservedFounder);
308         reservedFounder -= _value;
309         balances[contract_owner] += _value;
310         transfer(_founder, _value);
311         _initialAmount += _value;
312     }
313     // obtain bounty token 
314     function obtainBounty (address _receiver, uint256 _value) onlyOwner{
315         require(_value <= bountyToken);
316         balances[_receiver] += _value;
317         _initialAmount += _value;
318         bountyToken -= _value;
319     }
320     
321     
322     //  withdraw ETH from contract
323     function withdraw() onlyOwner{
324         contract_owner.transfer(this.balance);
325       }
326     // fallback function for receive ETH during ICO
327     function () payable inIco{
328         uint256 tokenChange = (msg.value * exchangeRate).div(10**18);
329         require(tokenChange <= publicToken);
330         balances[msg.sender] += tokenChange;
331         _initialAmount += tokenChange;
332         publicToken = publicToken.sub(tokenChange);
333       }
334 }