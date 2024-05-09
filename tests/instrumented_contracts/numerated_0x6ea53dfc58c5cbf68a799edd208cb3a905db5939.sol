1 pragma solidity >=0.5.16 <0.6.0;
2 interface tokenRecipient {
3     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
4 }
5 
6 contract EthereumeRush {
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     uint256 public totalSupply;
11     address payable public fundsWallet;
12     uint256 public maximumTarget;
13     uint256 public lastBlock;
14     uint256 public rewardTimes;
15     uint256 public genesisReward;
16     uint256 public premined;
17     uint256 public nRewarMod;
18     uint256 public nWtime;
19     uint256 public totalReceived;
20 
21 
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) public allowance;
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26     event Burn(address indexed from, uint256 value);
27 
28     constructor(
29         uint256 initialSupply,
30         string memory tokenName,
31         string memory tokenSymbol
32     ) public {
33         initialSupply = 23592240  * 10 ** uint256(decimals);
34         tokenName = "EthereumeRush";
35         tokenSymbol = "EER";
36         lastBlock = 1;
37         nRewarMod = 5200;
38         nWtime = 7889231; 
39         genesisReward = (2**14)* (10**uint256(decimals));
40         maximumTarget = 100  * 10 ** uint256(decimals);
41         fundsWallet = msg.sender;
42         premined = 500000 * 10 ** uint256(decimals);
43         balanceOf[msg.sender] = premined;
44         balanceOf[address(this)] = initialSupply;
45         totalSupply =  initialSupply + premined;
46         name = tokenName;
47         symbol = tokenSymbol;
48         totalReceived = 0;
49     }
50 
51     function _transfer(address _from, address _to, uint _value) internal {
52         require(_to != address(0x0));
53         require(balanceOf[_from] >= _value);
54         require(balanceOf[_to] + _value >= balanceOf[_to]);
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         balanceOf[_from] -= _value;
57         balanceOf[_to] += _value;
58         emit Transfer(_from, _to, _value);
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     function transfer(address _to, uint256 _value) public returns (bool success) {
63         _transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
68         require(_value <= allowance[_from][msg.sender]);     // Check allowance
69         allowance[_from][msg.sender] -= _value;
70         _transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function approve(address _spender, uint256 _value) public
75         returns (bool success) {
76         allowance[msg.sender][_spender] = _value;
77         emit Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
82         public
83         returns (bool success) {
84         tokenRecipient spender = tokenRecipient(_spender);
85         if (approve(_spender, _value)) {
86             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
87             return true;
88         }
89     }
90 
91     function burn(uint256 _value) public returns (bool success) {
92         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
93         balanceOf[msg.sender] -= _value;            // Subtract from the sender
94         totalSupply -= _value;                      // Updates totalSupply
95         emit Burn(msg.sender, _value);
96         return true;
97     }
98 
99     function burnFrom(address _from, uint256 _value) public returns (bool success) {
100         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
101         require(_value <= allowance[_from][msg.sender]);    // Check allowance
102         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
103         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
104         totalSupply -= _value;                              // Update totalSupply
105         emit Burn(_from, _value);
106         return true;
107     }
108 
109 
110 
111     function uintToString(uint256 v) internal pure returns(string memory str) {
112         uint maxlength = 100;
113         bytes memory reversed = new bytes(maxlength);
114         uint i = 0;
115         while (v != 0) {
116             uint remainder = v % 10;
117             v = v / 10;
118             reversed[i++] = byte(uint8(48 + remainder));
119         }
120         bytes memory s = new bytes(i + 1);
121         for (uint j = 0; j <= i; j++) {
122             s[j] = reversed[i - j];
123         }
124         str = string(s);
125     }
126 
127     function append(string memory a, string memory b) internal pure returns (string memory) {
128         return string(abi.encodePacked(a,"-",b));
129     }
130 
131 
132 
133 
134     function getblockhash() public view returns (uint256) {
135             return uint256(blockhash(block.number-1));
136     }
137 
138     function getspesificblockhash(uint256 _blocknumber) public view returns(uint256, uint256){
139         uint256 crew = uint256(blockhash(_blocknumber)) % nRewarMod;
140         return (crew, block.number-1);
141     }
142 
143 
144 
145 
146     function checkRewardStatus() public view returns (uint256, uint256) {
147         uint256 crew = uint256(blockhash(block.number-1)) % nRewarMod;
148         return (crew, block.number-1);
149     }
150 
151 
152 
153 
154     struct sdetails {
155       uint256 _stocktime;
156       uint256 _stockamount;
157     }
158 
159 
160     address[] totalminers;
161 
162     mapping (address => sdetails) nStockDetails;
163     struct rewarddetails {
164         uint256 _artyr;
165         bool _didGetReward;
166     }
167     mapping (string => rewarddetails) nRewardDetails;
168 
169     struct nBlockDetails {
170         uint256 _bTime;
171         uint256 _tInvest;
172     }
173     mapping (uint256 => nBlockDetails) bBlockIteration;
174 
175 
176   struct activeMiners {
177       address bUser;
178   }
179 
180   mapping(uint256 => activeMiners[]) aMiners;
181 
182 
183     function numberofminer() view public returns (uint256) {
184         return totalminers.length;
185     }
186 
187 
188     function nAddrHash() view public returns (uint256) {
189         return uint256(msg.sender) % 10000000000;
190     }
191 
192      function getmaximumAverage() public view returns(uint){
193          if(numberofminer() == 0){
194              return maximumTarget;
195          } else {
196              return maximumTarget / numberofminer();
197          }
198     }
199 
200 
201     
202 
203 
204    function checkAddrMinerStatus(address _addr) view public returns(bool){
205     if(nStockDetails[_addr]._stocktime == 0){
206         return false;
207     } else {
208         return true;
209     }
210    }
211 
212    function checkAddrMinerAmount(address _addr) view public returns(uint256){
213     if(nStockDetails[_addr]._stocktime == 0){
214         return 0;
215     } else {
216         return nStockDetails[_addr]._stockamount;
217     }
218    }
219 
220 
221 
222 
223 
224    function getactiveminersnumber() view public returns(uint256) {
225         return aMiners[lastBlock].length; //that function for information.
226    }
227    
228    
229    function nMixAddrandBlock()  private view returns(string memory) {
230          return append(uintToString(nAddrHash()),uintToString(lastBlock));
231     }
232     
233     
234    
235    function signfordailyreward(uint256 _bnumber) public returns (uint256)  {
236        require(checkAddrMinerStatus(msg.sender) == true);
237        require((block.number-1) - _bnumber  <= 100);
238        require(uint256(blockhash(_bnumber)) % nRewarMod == 1);
239         if(bBlockIteration[lastBlock]._bTime + 1800 < now){
240            lastBlock += 1;
241            bBlockIteration[lastBlock]._bTime = now;
242        }
243        require(nRewardDetails[nMixAddrandBlock()]._artyr == 0);
244        bBlockIteration[lastBlock]._tInvest += nStockDetails[msg.sender]._stockamount;
245        nRewardDetails[nMixAddrandBlock()]._artyr = now;
246        nRewardDetails[nMixAddrandBlock()]._didGetReward = false;
247        aMiners[lastBlock].push(activeMiners(msg.sender));
248        return 200;
249    }
250 
251    
252    function getDailyReward(uint256 _bnumber) public returns(uint256) {
253        require(checkAddrMinerStatus(msg.sender) == true);
254        require((block.number-1) - _bnumber  >= 100);
255        require(uint256(blockhash(_bnumber)) % nRewarMod == 1);
256        require(nRewardDetails[nMixAddrandBlock()]._didGetReward == false);
257        uint256 totalRA = genesisReward / 2 ** (lastBlock/730);
258        uint256 usersReward = (totalRA * (nStockDetails[msg.sender]._stockamount * 100) / bBlockIteration[lastBlock]._tInvest) /  100;
259        nRewardDetails[nMixAddrandBlock()]._didGetReward = true;
260        _transfer(address(this), msg.sender, usersReward);
261        return usersReward;
262    }
263 
264     function becameaminer(uint256 mineamount) public returns (uint256) {
265       uint256 realMineAmount = mineamount * 10 ** uint256(decimals);
266       require(realMineAmount > getmaximumAverage() / 100); //Minimum maximum targes one percents neccessary.
267       require(realMineAmount > 1 * 10 ** uint256(decimals)); //minimum 1 coin require
268       require(nStockDetails[msg.sender]._stocktime == 0);
269       require(mineamount < 3000);
270       maximumTarget +=  realMineAmount;
271       nStockDetails[msg.sender]._stocktime = now;
272       nStockDetails[msg.sender]._stockamount = realMineAmount;
273       totalminers.push(msg.sender);
274       _transfer(msg.sender, address(this), realMineAmount);
275       return 200;
276    }
277 
278 
279 
280    function getyourcoinsbackafterthreemonths() public returns(uint256) {
281        require(nStockDetails[msg.sender]._stocktime + nWtime < now  );
282        nStockDetails[msg.sender]._stocktime = 0;
283        _transfer(address(this),msg.sender,nStockDetails[msg.sender]._stockamount);
284        return nStockDetails[msg.sender]._stockamount;
285    }
286 
287    struct memoIncDetails {
288        uint256 _receiveTime;
289        uint256 _receiveAmount;
290        address _senderAddr;
291        string _senderMemo;
292    }
293 
294   mapping(address => memoIncDetails[]) textPurchases;
295   function sendtokenwithmemo(uint256 _amount, address _to, string memory _memo)  public returns(uint256) {
296       textPurchases[_to].push(memoIncDetails(now, _amount, msg.sender, _memo));
297       _transfer(msg.sender, _to, _amount);
298       return 200;
299   }
300 
301 
302    function checkmemopurchases(address _addr, uint256 _index) view public returns(uint256,
303    uint256,
304    string memory,
305    address) {
306 
307        uint256 rTime = textPurchases[_addr][_index]._receiveTime;
308        uint256 rAmount = textPurchases[_addr][_index]._receiveAmount;
309        string memory sMemo = textPurchases[_addr][_index]._senderMemo;
310        address sAddr = textPurchases[_addr][_index]._senderAddr;
311        if(textPurchases[_addr][_index]._receiveTime == 0){
312             return (0, 0,"0", _addr);
313        }else {
314             return (rTime, rAmount,sMemo, sAddr);
315        }
316    }
317 
318 
319 
320    function getmemotextcountforaddr(address _addr) view public returns(uint256) {
321        return  textPurchases[_addr].length;
322    }
323  }