1 pragma solidity >=0.5.16 <0.6.9;
2 //INCONTRACTWETRUST4.0
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
33         initialSupply = 20692240  * 10 ** uint256(decimals);
34         tokenName = "EthereumeRush";
35         tokenSymbol = "EER";
36         lastBlock = 158;
37         nRewarMod = 7200;
38         nWtime = 7776000;
39         genesisReward = (2**14)* (10**uint256(decimals));
40         maximumTarget = 100  * 10 ** uint256(decimals);
41         fundsWallet = msg.sender;
42         premined = 3400000 * 10 ** uint256(decimals);
43         balanceOf[msg.sender] = premined;
44         balanceOf[address(this)] = initialSupply;
45         totalSupply =  initialSupply + premined;
46         name = tokenName;
47         symbol = tokenSymbol;
48     }
49 
50     function _transfer(address _from, address _to, uint _value) internal {
51         require(_to != address(0x0));
52         require(balanceOf[_from] >= _value);
53         require(balanceOf[_to] + _value >= balanceOf[_to]);
54         uint previousBalances = balanceOf[_from] + balanceOf[_to];
55         balanceOf[_from] -= _value;
56         balanceOf[_to] += _value;
57         emit Transfer(_from, _to, _value);
58         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59     }
60 
61     function transfer(address _to, uint256 _value) public returns (bool success) {
62         _transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
67         require(_value <= allowance[_from][msg.sender]);     // Check allowance
68         allowance[_from][msg.sender] -= _value;
69         _transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function approve(address _spender, uint256 _value) public
74         returns (bool success) {
75         allowance[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
81         public
82         returns (bool success) {
83         tokenRecipient spender = tokenRecipient(_spender);
84         if (approve(_spender, _value)) {
85             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
86             return true;
87         }
88     }
89 
90     function burn(uint256 _value) public returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
92         balanceOf[msg.sender] -= _value;            // Subtract from the sender
93         totalSupply -= _value;                      // Updates totalSupply
94         emit Burn(msg.sender, _value);
95         return true;
96     }
97 
98     function burnFrom(address _from, uint256 _value) public returns (bool success) {
99         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
100         require(_value <= allowance[_from][msg.sender]);    // Check allowance
101         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
102         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
103         totalSupply -= _value;                              // Update totalSupply
104         emit Burn(_from, _value);
105         return true;
106     }
107 
108 
109 
110     function uintToString(uint256 v) internal pure returns(string memory str) {
111         uint maxlength = 100;
112         bytes memory reversed = new bytes(maxlength);
113         uint i = 0;
114         while (v != 0) {
115             uint remainder = v % 10;
116             v = v / 10;
117             reversed[i++] = byte(uint8(48 + remainder));
118         }
119         bytes memory s = new bytes(i + 1);
120         for (uint j = 0; j <= i; j++) {
121             s[j] = reversed[i - j];
122         }
123         str = string(s);
124     }
125 
126     function append(string memory a, string memory b) internal pure returns (string memory) {
127         return string(abi.encodePacked(a,"-",b));
128     }
129 
130 
131 
132 
133     function getblockhash() public view returns (uint256) {
134             return uint256(blockhash(block.number-1));
135     }
136 
137     function getspesificblockhash(uint256 _blocknumber) public view returns(uint256, uint256){
138         uint256 crew = uint256(blockhash(_blocknumber)) % nRewarMod;
139         return (crew, block.number-1);
140     }
141 
142 
143 
144 
145     function checkRewardStatus() public view returns (uint256, uint256) {
146         uint256 crew = uint256(blockhash(block.number-1)) % nRewarMod;
147         return (crew, block.number-1);
148     }
149 
150 
151 
152 
153     struct sdetails {
154       uint256 _stocktime;
155       uint256 _stockamount;
156     }
157 
158 
159     address[] totalminers;
160 
161     mapping (address => sdetails) nStockDetails;
162     struct rewarddetails {
163         uint256 _artyr;
164         bool _didGetReward;
165         bool _didisign;
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
247        nRewardDetails[nMixAddrandBlock()]._didisign = true;
248        aMiners[lastBlock].push(activeMiners(msg.sender));
249        return 200;
250    }
251 
252    
253    function getDailyReward(uint256 _bnumber) public returns(uint256) {
254        require(checkAddrMinerStatus(msg.sender) == true);
255        require((block.number-1) - _bnumber  >= 100);
256        require(uint256(blockhash(_bnumber)) % nRewarMod == 1);
257        require(nRewardDetails[nMixAddrandBlock()]._didGetReward == false);
258        require(nRewardDetails[nMixAddrandBlock()]._didisign == true);
259        uint256 totalRA = genesisReward / 2 ** (lastBlock/730);
260        uint256 usersReward = (totalRA * (nStockDetails[msg.sender]._stockamount * 100) / bBlockIteration[lastBlock]._tInvest) /  100;
261        nRewardDetails[nMixAddrandBlock()]._didGetReward = true;
262        _transfer(address(this), msg.sender, usersReward);
263        return usersReward;
264    }
265 
266     function becameaminer(uint256 mineamount) public returns (uint256) {
267       uint256 realMineAmount = mineamount * 10 ** uint256(decimals);
268       require(realMineAmount > getmaximumAverage() / 100); //Minimum maximum targes one percents neccessary.
269       require(realMineAmount > 1 * 10 ** uint256(decimals)); //minimum 1 coin require
270       require(nStockDetails[msg.sender]._stocktime == 0);
271       require(mineamount <= 3000);
272       maximumTarget +=  realMineAmount;
273       nStockDetails[msg.sender]._stocktime = now;
274       nStockDetails[msg.sender]._stockamount = realMineAmount;
275       totalminers.push(msg.sender);
276       _transfer(msg.sender, address(this), realMineAmount);
277       return 200;
278    }
279 
280 
281 
282    function getyourcoinsbackafterthreemonths() public returns(uint256) {
283        require(checkAddrMinerStatus(msg.sender) == true);
284        require(nStockDetails[msg.sender]._stocktime + nWtime < now  );
285        nStockDetails[msg.sender]._stocktime = 0;
286        _transfer(address(this),msg.sender,nStockDetails[msg.sender]._stockamount);
287        return nStockDetails[msg.sender]._stockamount;
288    }
289 
290    struct memoIncDetails {
291        uint256 _receiveTime;
292        uint256 _receiveAmount;
293        address _senderAddr;
294        string _senderMemo;
295    }
296 
297   mapping(address => memoIncDetails[]) textPurchases;
298   function sendtokenwithmemo(uint256 _amount, address _to, string memory _memo)  public returns(uint256) {
299       textPurchases[_to].push(memoIncDetails(now, _amount, msg.sender, _memo));
300       _transfer(msg.sender, _to, _amount);
301       return 200;
302   }
303 
304 
305    function checkmemopurchases(address _addr, uint256 _index) view public returns(uint256,
306    uint256,
307    string memory,
308    address) {
309 
310        uint256 rTime = textPurchases[_addr][_index]._receiveTime;
311        uint256 rAmount = textPurchases[_addr][_index]._receiveAmount;
312        string memory sMemo = textPurchases[_addr][_index]._senderMemo;
313        address sAddr = textPurchases[_addr][_index]._senderAddr;
314        if(textPurchases[_addr][_index]._receiveTime == 0){
315             return (0, 0,"0", _addr);
316        }else {
317             return (rTime, rAmount,sMemo, sAddr);
318        }
319    }
320 
321 
322 
323    function getmemotextcountforaddr(address _addr) view public returns(uint256) {
324        return  textPurchases[_addr].length;
325    }
326  }