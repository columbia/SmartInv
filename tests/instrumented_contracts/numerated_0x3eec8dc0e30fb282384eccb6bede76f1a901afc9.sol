1 pragma solidity >=0.5.16 <0.6.9;
2 //INCONTRACTWETRUST
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
5 }
6 
7 contract EthereumeRush {
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18;
11     uint256 public totalSupply;
12     address payable public fundsWallet;
13     uint256 public maximumTarget;
14     uint256 public lastBlock;
15     uint256 public rewardTimes;
16     uint256 public genesisReward;
17     uint256 public premined;
18     uint256 public nRewarMod;
19     uint256 public nWtime;
20     uint256 public totalReceived;
21 
22 
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27     event Burn(address indexed from, uint256 value);
28 
29     constructor(
30         uint256 initialSupply,
31         string memory tokenName,
32         string memory tokenSymbol
33     ) public {
34         initialSupply = 21919180  * 10 ** uint256(decimals);
35         tokenName = "EthereumeRush";
36         tokenSymbol = "EER";
37         lastBlock = 135;
38         nRewarMod = 5200;
39         nWtime = 3788923100; 
40         genesisReward = (2**14)* (10**uint256(decimals));
41         maximumTarget = 100  * 10 ** uint256(decimals);
42         fundsWallet = msg.sender;
43         premined = 3000000 * 10 ** uint256(decimals);
44         balanceOf[msg.sender] = premined;
45         balanceOf[address(this)] = initialSupply;
46         totalSupply =  initialSupply + premined;
47         name = tokenName;
48         symbol = tokenSymbol;
49         totalReceived = 0;
50     }
51 
52     function _transfer(address _from, address _to, uint _value) internal {
53         require(_to != address(0x0));
54         require(balanceOf[_from] >= _value);
55         require(balanceOf[_to] + _value >= balanceOf[_to]);
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         balanceOf[_from] -= _value;
58         balanceOf[_to] += _value;
59         emit Transfer(_from, _to, _value);
60         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
61     }
62 
63     function transfer(address _to, uint256 _value) public returns (bool success) {
64         _transfer(msg.sender, _to, _value);
65         return true;
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         require(_value <= allowance[_from][msg.sender]);     // Check allowance
70         allowance[_from][msg.sender] -= _value;
71         _transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function approve(address _spender, uint256 _value) public
76         returns (bool success) {
77         allowance[msg.sender][_spender] = _value;
78         emit Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
83         public
84         returns (bool success) {
85         tokenRecipient spender = tokenRecipient(_spender);
86         if (approve(_spender, _value)) {
87             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
88             return true;
89         }
90     }
91 
92     function burn(uint256 _value) public returns (bool success) {
93         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
94         balanceOf[msg.sender] -= _value;            // Subtract from the sender
95         totalSupply -= _value;                      // Updates totalSupply
96         emit Burn(msg.sender, _value);
97         return true;
98     }
99 
100     function burnFrom(address _from, uint256 _value) public returns (bool success) {
101         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
102         require(_value <= allowance[_from][msg.sender]);    // Check allowance
103         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
104         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
105         totalSupply -= _value;                              // Update totalSupply
106         emit Burn(_from, _value);
107         return true;
108     }
109 
110 
111 
112     function uintToString(uint256 v) internal pure returns(string memory str) {
113         uint maxlength = 100;
114         bytes memory reversed = new bytes(maxlength);
115         uint i = 0;
116         while (v != 0) {
117             uint remainder = v % 10;
118             v = v / 10;
119             reversed[i++] = byte(uint8(48 + remainder));
120         }
121         bytes memory s = new bytes(i + 1);
122         for (uint j = 0; j <= i; j++) {
123             s[j] = reversed[i - j];
124         }
125         str = string(s);
126     }
127 
128     function append(string memory a, string memory b) internal pure returns (string memory) {
129         return string(abi.encodePacked(a,"-",b));
130     }
131 
132 
133 
134 
135     function getblockhash() public view returns (uint256) {
136             return uint256(blockhash(block.number-1));
137     }
138 
139     function getspesificblockhash(uint256 _blocknumber) public view returns(uint256, uint256){
140         uint256 crew = uint256(blockhash(_blocknumber)) % nRewarMod;
141         return (crew, block.number-1);
142     }
143 
144 
145 
146 
147     function checkRewardStatus() public view returns (uint256, uint256) {
148         uint256 crew = uint256(blockhash(block.number-1)) % nRewarMod;
149         return (crew, block.number-1);
150     }
151 
152 
153 
154 
155     struct sdetails {
156       uint256 _stocktime;
157       uint256 _stockamount;
158     }
159 
160 
161     address[] totalminers;
162 
163     mapping (address => sdetails) nStockDetails;
164     struct rewarddetails {
165         uint256 _artyr;
166         bool _didGetReward;
167         bool _didisign;
168     }
169     mapping (string => rewarddetails) nRewardDetails;
170 
171     struct nBlockDetails {
172         uint256 _bTime;
173         uint256 _tInvest;
174     }
175     mapping (uint256 => nBlockDetails) bBlockIteration;
176 
177 
178   struct activeMiners {
179       address bUser;
180   }
181 
182   mapping(uint256 => activeMiners[]) aMiners;
183 
184 
185     function numberofminer() view public returns (uint256) {
186         return totalminers.length;
187     }
188 
189 
190     function nAddrHash() view public returns (uint256) {
191         return uint256(msg.sender) % 10000000000;
192     }
193 
194      function getmaximumAverage() public view returns(uint){
195          if(numberofminer() == 0){
196              return maximumTarget;
197          } else {
198              return maximumTarget / numberofminer();
199          }
200     }
201 
202 
203     
204 
205 
206    function checkAddrMinerStatus(address _addr) view public returns(bool){
207     if(nStockDetails[_addr]._stocktime == 0){
208         return false;
209     } else {
210         return true;
211     }
212    }
213 
214    function checkAddrMinerAmount(address _addr) view public returns(uint256){
215     if(nStockDetails[_addr]._stocktime == 0){
216         return 0;
217     } else {
218         return nStockDetails[_addr]._stockamount;
219     }
220    }
221 
222 
223 
224 
225 
226    function getactiveminersnumber() view public returns(uint256) {
227         return aMiners[lastBlock].length; //that function for information.
228    }
229    
230    
231    function nMixAddrandBlock()  private view returns(string memory) {
232          return append(uintToString(nAddrHash()),uintToString(lastBlock));
233     }
234     
235     
236    
237    function signfordailyreward(uint256 _bnumber) public returns (uint256)  {
238        require(checkAddrMinerStatus(msg.sender) == true);
239        require((block.number-1) - _bnumber  <= 100);
240        require(uint256(blockhash(_bnumber)) % nRewarMod == 1);
241         if(bBlockIteration[lastBlock]._bTime + 1800 < now){
242            lastBlock += 1;
243            bBlockIteration[lastBlock]._bTime = now;
244        }
245        require(nRewardDetails[nMixAddrandBlock()]._artyr == 0);
246        bBlockIteration[lastBlock]._tInvest += nStockDetails[msg.sender]._stockamount;
247        nRewardDetails[nMixAddrandBlock()]._artyr = now;
248        nRewardDetails[nMixAddrandBlock()]._didGetReward = false;
249        nRewardDetails[nMixAddrandBlock()]._didisign = true;
250        aMiners[lastBlock].push(activeMiners(msg.sender));
251        return 200;
252    }
253 
254    
255    function getDailyReward(uint256 _bnumber) public returns(uint256) {
256        require(checkAddrMinerStatus(msg.sender) == true);
257        require((block.number-1) - _bnumber  >= 100);
258        require(uint256(blockhash(_bnumber)) % nRewarMod == 1);
259        require(nRewardDetails[nMixAddrandBlock()]._didGetReward == false);
260        require(nRewardDetails[nMixAddrandBlock()]._didisign == true);
261        uint256 totalRA = genesisReward / 2 ** (lastBlock/730);
262        uint256 usersReward = (totalRA * (nStockDetails[msg.sender]._stockamount * 100) / bBlockIteration[lastBlock]._tInvest) /  100;
263        nRewardDetails[nMixAddrandBlock()]._didGetReward = true;
264        _transfer(address(this), msg.sender, usersReward);
265        return usersReward;
266    }
267 
268     function becameaminer(uint256 mineamount) public returns (uint256) {
269       uint256 realMineAmount = mineamount * 10 ** uint256(decimals);
270       require(realMineAmount > getmaximumAverage() / 100); //Minimum maximum targes one percents neccessary.
271       require(realMineAmount > 1 * 10 ** uint256(decimals)); //minimum 1 coin require
272       require(nStockDetails[msg.sender]._stocktime == 0);
273       require(mineamount <= 3000);
274       maximumTarget +=  realMineAmount;
275       nStockDetails[msg.sender]._stocktime = now;
276       nStockDetails[msg.sender]._stockamount = realMineAmount;
277       totalminers.push(msg.sender);
278       _transfer(msg.sender, address(this), realMineAmount);
279       return 200;
280    }
281 
282 
283 
284    function getyourcoinsbackafterthreemonths() public returns(uint256) {
285        require(checkAddrMinerStatus(msg.sender) == true);
286        require(nStockDetails[msg.sender]._stocktime + nWtime < now  );
287        nStockDetails[msg.sender]._stocktime = 0;
288        _transfer(address(this),msg.sender,nStockDetails[msg.sender]._stockamount);
289        return nStockDetails[msg.sender]._stockamount;
290    }
291 
292    struct memoIncDetails {
293        uint256 _receiveTime;
294        uint256 _receiveAmount;
295        address _senderAddr;
296        string _senderMemo;
297    }
298 
299   mapping(address => memoIncDetails[]) textPurchases;
300   function sendtokenwithmemo(uint256 _amount, address _to, string memory _memo)  public returns(uint256) {
301       textPurchases[_to].push(memoIncDetails(now, _amount, msg.sender, _memo));
302       _transfer(msg.sender, _to, _amount);
303       return 200;
304   }
305 
306 
307    function checkmemopurchases(address _addr, uint256 _index) view public returns(uint256,
308    uint256,
309    string memory,
310    address) {
311 
312        uint256 rTime = textPurchases[_addr][_index]._receiveTime;
313        uint256 rAmount = textPurchases[_addr][_index]._receiveAmount;
314        string memory sMemo = textPurchases[_addr][_index]._senderMemo;
315        address sAddr = textPurchases[_addr][_index]._senderAddr;
316        if(textPurchases[_addr][_index]._receiveTime == 0){
317             return (0, 0,"0", _addr);
318        }else {
319             return (rTime, rAmount,sMemo, sAddr);
320        }
321    }
322 
323 
324 
325    function getmemotextcountforaddr(address _addr) view public returns(uint256) {
326        return  textPurchases[_addr].length;
327    }
328  }